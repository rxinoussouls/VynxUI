# HANDOFF — VynxUI rebrand + Cascade UI merge

Last updated: 2026-07-26 (session 2) · Updated by: Claude (chat session)
Current phase: 3 — Verify (Cascade merge pushed; ORIGINAL "still buggy in Roblox"
report from earlier in session 2 was never re-confirmed after the fix that preceded
it — see §6, this is the top open item)

## 1. What this project is
VynxUI is a Roblox Luau UI library (originally WindUI, renamed VynxUI this session),
loaded into games via `loadstring(game:HttpGet(<url>))()`, plus a Next.js docs site
in `website/`. Repo: https://github.com/rxinoussouls/VynxUI (owner: rxinoussouls).
This session's added scope: merge visual/component language from a second library,
Cascade (https://github.com/cascadeui/Cascade, a macOS-System-Preferences-styled
Roblox UI lib), into VynxUI — NOT any gameplay/cheat functionality, explicitly
refused (see §6). User was shown a reference screenshot of a *different* product
("VynxUI Premium" executor-style dashboard with cheat toggles) and clarified it was
style-reference only, no functionality to port.

## 2. Architecture / how it works
- Source: `src/Init.lua` + `src/elements` (one file per UI element), `src/components`
  (lower-level window/popup/search building blocks), `src/modules`, `src/themes`,
  `src/utils`. Custom imperative builder (`Creator.New`), NOT Fusion/reactive —
  this matters because Cascade (see below) uses a different creator API, so its
  `.luau` component files could NOT be copied in verbatim; anything ported had to
  be rewritten against VynxUI's own `Creator.New`/element-table conventions.
- Theme system: `src/themes/Init.lua` returns a flat table of named themes (Dark,
  Light, Rose, ...16 originally, now +1 = Sequoia). Each theme is a flat
  `{Key = Color3/gradient}` table -- no nesting, no reactive bindings. Selected via
  `VynxUI:SetTheme("Name")` or `CreateWindow({Theme = "Name", ...})`.
- Build: `build/build.sh` runs **darklua** (bundler) on `src/Init.lua` -> produces
  `dist/main.lua` (single minified file, that's what Roblox actually loads at
  runtime via `loader.lua`). `.github/workflows/build.yml` does this automatically
  on push in CI. **This sandbox now has a working darklua binary** at
  `/home/claude/darklua_bin/darklua` (downloaded from
  `https://github.com/seaofvoices/darklua/releases/download/v0.17.1/darklua-linux-x86_64.zip`
  since apt/cargo darklua wasn't available) -- `export PATH=/home/claude/darklua_bin:$PATH`
  then `bash build/build.sh` from repo root works and takes ~1.1s. Also needs `node`
  (already present) for the header/package.json templating step. USE THIS instead of
  hand-patching `dist/main.lua` with sed/python string replace whenever `src/`
  changes are non-trivial (more than a pure string swap) -- a previous session did
  hand-patch `dist/main.lua` for the WindUI->VynxUI rename and URL fixes, which
  worked for simple swaps but was NOT sufficient once real component files were
  added/changed (see §3 item 6, §8).
- Runtime loading chain: `main_example.lua` -> `loader.lua` -> `dist/main.lua`
  (bundled lib) -> `dist/main.lua`'s icon module fetches
  `website/public/vendor/icons/Main-v2.lua` -> that fetches 6 per-pack icon files.
  All of these were migrated off dead `github.io` URLs to `raw.githubusercontent.com`
  earlier this session (see §3 items 1-5) -- still true, unaffected by the merge.
- `website/public/{main.lua,loader.lua,main_example.lua,dist/main.lua}` are DEAD
  MIRROR COPIES of the root files -- Roblox never fetches from these paths, but keep
  them in sync (plain `cp`) for consistency; don't hand-edit them separately.

## 3. Current state -- what's DONE
1-5. (Prior session-2 work, still valid, not re-detailed here -- see git log
   `ee9704e` through `6cf459f`: full WindUI->VynxUI rename, stale org/repo URL fixes,
   broken README link fix, github.io->raw.githubusercontent.com migration for all
   runtime loadstring URLs including the nested Main-v2.lua icon-pack URLs.)
6. **Cascade merge, done via a two-track process that then had to be reconciled:**
   - This Claude instance started an approach of just adding ONE new theme
     (`"Cascade"`) to `src/themes/Init.lua` with hand-approximated iOS-system colors,
     and hand-patched the equivalent block into `dist/main.lua`. Committed as
     `3f585c4`.
   - Independently, ANOTHER session/agent (same repo, different Claude
     instance/tool -- evidence: commit messages read like autonomous Claude Code
     work, e.g. "Finish Cascade element port pass (except dist rebuild)") had
     ALREADY done a much more thorough port directly to `origin/main`: ported
     `PullDownButton`, `ImageSurface`, `Symbol`, `TitleStack`, `FloatingMenu` as new
     `src/elements`/`src/modules` files; restyled existing `Dropdown` (in
     `src/components/ui/`) and `Section` to match Cascade's card/hairline-border
     language; added a **`Sequoia`** theme (not `Cascade`) with colors pulled from
     Cascade's actual source (`Dark.luau`'s `Controls.*` values, `accents.luau`'s
     Blue accent) rather than generic approximation; also did an unrelated safety
     fix "Refactor icon loading to remove exploit checks"; and had deleted an
     earlier HANDOFF.md of their own (commit `c13c9b8`).
   - On push, this diverged (`git push` rejected, `fetch first`). Fetched, merged.
     Only real conflict was in `src/themes/Init.lua` (my `Cascade` block vs their
     `Sequoia` block in roughly the same place). **Resolved by keeping their
     `Sequoia` theme and discarding my `Cascade` theme entirely** -- theirs is more
     accurate (real Cascade hex values, code comments citing exact source file/keys)
     and there was no reason to keep both. Updated the 3 demo files
     (`main_example.lua`, `main.client.lua`, `main2.client.lua`) that had been
     pointed at `"Cascade"` to point at `"Sequoia"` instead.
   - **Rebuilt `dist/main.lua` for real via darklua** (see §2) instead of
     hand-patching -- necessary because the diff was no longer a simple string swap
     (new files, restyled files). Verified post-build: `dist/main.lua` contains
     `"Sequoia"` (1 hit), zero `"Cascade"` hits, references to
     `PullDownButton`/`ImageSurface`/`TitleStack` (11 hits), `rxinoussouls/VynxUI`
     URLs still intact (3 hits), zero leftover `windui` (case-insensitive). Synced
     `website/public/dist/main.lua` and `website/public/main_example.lua` mirrors
     via `cp`.
   - Merge commit `3be81ed`, pushed to `origin/main` (push returned a clean
     `8e20973..3be81ed main -> main`, not rejected).

## 4. Current state -- what's IN PROGRESS right now
Nothing mid-edit. The merge+rebuild+push cycle described in §3 item 6 completed
cleanly. The very next thing to do is verification (§9), not more coding.

## 5. What's NOT started yet
- [ ] **User has not yet confirmed the Cascade/Sequoia visual merge looks right in
      Roblox.** No screenshot or feedback received since the merge was pushed.
- [ ] **User has not yet re-confirmed whether the ORIGINAL icon-catalog-crash fix
      (commit `6cf459f`, from earlier in session 2) actually resolved the "still
      buggy, same as before" report.** That question was still open when the user
      pivoted the conversation to the Cascade merge request -- it was never
      answered. Don't assume it's fixed; ask.
- [ ] The other session's "Refactor icon loading to remove exploit checks" commit
      (`977e20b`) has not been read/reviewed by this instance in detail -- worth a
      look to understand what changed, since it touches the same icon-loading path
      this session already debugged twice.
- [ ] No GitHub Pages deploy workflow still exists (Option B from earlier in
      session 2, explicitly deferred, not done) -- `website/` docs site is still
      not actually live anywhere.
- [ ] User's earlier open request "make main.lua better than original" (offered:
      pcall/error-handling, cleaner demo UI, or their own idea) was never answered
      with specifics and was superseded by the Cascade merge request. Still
      technically open if the user brings it back up.

## 6. Known issues / blockers / open questions
- **Hard refusal, not a blocker, but must persist:** the reference screenshot the
  user showed included cheat/exploit toggles (Noclip, Infinite Jump, WalkSpeed
  hack, Anti-AFK bypass, Server Hop, "Attach Executor"). User clarified this was
  style-reference only. If a FUTURE message asks to actually implement any such
  toggle's real functionality (not just a themed UI element that does nothing),
  that must be refused again regardless of framing -- do not build cheat/exploit
  logic into this library.
- Whether `Sequoia` actually renders well / whether the merge introduced any visual
  or functional regression in the restyled `Dropdown`/`Section` components is
  UNVERIFIED -- no in-Roblox test since the merge.
- Same sandbox limitation as before: `web_fetch` here refuses URLs not already seen
  via search/fetch, so raw.githubusercontent.com URLs can only be verified by
  checking the file exists locally at that repo path, not by confirming the actual
  HTTP response Roblox would see.
- Tokens: multiple short-lived PATs were pasted into chat this session and used
  once each per the user's own instruction, then meant to be revoked. Treat all
  prior token values in this transcript as dead. If a new push is needed, ask for a
  fresh token.
- The other-session's HANDOFF.md deletion (`c13c9b8`) was not overridden -- this
  file survived the merge only because it didn't exist yet in the common ancestor
  when it was created fresh this turn. If a future session finds HANDOFF.md deleted
  again, that may be intentional per whatever convention the other session/tool is
  using -- worth asking the user rather than assuming it should always exist.

## 7. How to verify things work
1. Confirm push landed: `git ls-remote https://github.com/rxinoussouls/VynxUI.git`
   -> `refs/heads/main` should be `3be81ed...` (or later).
2. In Roblox: `loadstring(game:HttpGet('https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/main_example.lua'))()`
   Expected: VynxUI demo window opens using the Sequoia (macOS-dark) look -- near-
   black `#1C1C1E`/`#1F1F21` surfaces, system-blue `#0A84FF` accents, no red errors.
3. To rebuild `dist/main.lua` locally after any future `src/` change:
   ```
   export PATH=/home/claude/darklua_bin:$PATH   # if in a fresh sandbox, re-download first (see §2)
   cd VynxUI && bash build/build.sh
   cp dist/main.lua website/public/dist/main.lua
   ```
4. Quick sanity grep after any rebuild: `grep -c '"Sequoia"' dist/main.lua` should
   be >=1, `grep -ci windui dist/main.lua` should be 0.

## 8. Key decisions log
- (Prior, session 2 early: case-preserving rename; raw.githubusercontent.com over
  github.io Pages since Pages was never deployed; kept docs-site links pointing at
  github.io on purpose for a future real deploy.)
- Chose to keep the OTHER session's `Sequoia` theme over this session's own
  `Cascade` theme when they conflicted, because theirs was derived from Cascade's
  actual source hex values (verifiable, cited in code comments) rather than a
  generic approximation -- correctness over "keep my own work."
- Chose to do a real `darklua` rebuild of `dist/main.lua` rather than continue the
  hand-patch approach, once the diff included genuinely new files/components --
  hand-patching only remains safe for pure string/URL swaps.
- Declined (again, implicitly by not doing it) to implement any real
  cheat/exploit functionality shown in the user's reference screenshot; treated it
  as UI styling reference only per the user's own clarification.

## 9. Immediate next action
Ask the user to re-test in Roblox against the latest commit (`3be81ed`+) and report
back: (a) does the Sequoia/Cascade-styled UI look right, and (b) is the
icon-catalog crash from earlier in the session actually gone now. Do not make
further code changes until at least one of those is confirmed, since next steps
depend entirely on what (if anything) is still broken.

## 10. Phase 1 update (window chrome) — done this turn
Key discovery: VynxUI already had a native macOS-style "Mac" topbar mode built in
(`Window.Topbar.ButtonsType == "Mac"` in `src/components/window/Init.lua`,
`Window:CreateTopbarButton` function, ~line 1155) — real traffic-light dots
(colored round Squircle frames), NOT icon buttons. It was already turned on in
`main_example.lua`'s `Topbar = { Height = 44, ButtonsType = "Mac" }`. So Cascade's
`structures/WindowControls.luau`/`Window.luau` did NOT need to be ported — the
equivalent already existed, just needed color tuning. Sidebar mode
(`TabHolderType = "sidebar", SidebarCompact = true`) was also already on in the demo.

Changes made:
- ASCII banner in `build/header.lua`, `Main.lua`, `website/public/main.lua`:
  "WindUI" figlet art -> "VYNX UI" (smslant font via `figlet -f smslant "VYNX UI"`).
  `dist/main.lua` gets this automatically from `build/header.lua` on rebuild.
- Traffic-light colors tuned to exact macOS/Cascade hex in
  `src/components/window/Init.lua`: Fullscreen/Zoom `#60C762`->`#28C840` (line
  ~1849), Minimize `#F4C948`->`#FEBC2E` (line ~1918), Close/Exit `#F4695F`->`#FF5F57`
  (line ~2762).
- Rebuilt `dist/main.lua` via darklua, synced `website/public/dist/main.lua`.
- Commit `0bed695`, pushed cleanly (`22e364d..0bed695`).

**IMPORTANT implication for the "UI still looks the same" report:** since Mac-style
traffic lights + sidebar were ALREADY configured in the demo before this phase even
started, the user testing the demo should have already been seeing a Mac-style
topbar, not VynxUI's plain default icon-button topbar. That they reported "looks
exactly like before" suggests the window may not be rendering fully at all when they
test (e.g. the icon-catalog crash from `6cf459f` might still be happening, or
they're testing a cached/old loadstring in Roblox, or they're not actually running
`main_example.lua`). **Next session: don't assume this phase's color/asset tuning
alone will look different to the user — first confirm the window is rendering at
all, then whether it now looks Mac-styled.** This is the same unresolved
confirmation gap noted in §5/§6 above, now compounded by a second layer of "why
doesn't it look different" that may have the same root cause.
