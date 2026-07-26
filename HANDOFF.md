# HANDOFF — VynxUI rebrand (WindUI → VynxUI) + loadstring 404/crash fixes

Last updated: 2026-07-26 · Updated by: Claude (chat session, context ~90%)
Current phase: 3 — Verify (bug still reported after latest push; unconfirmed whether user re-tested after the most recent fix)

## 1. What this project is
VynxUI is a Roblox Luau UI library (originally named WindUI, later "VynxUI-Skibidi",
now VynxUI), with a Next.js docs website in `website/`. The repo lives at
https://github.com/rxinoussouls/VynxUI (owner: rxinoussouls). The end product is
loaded into Roblox games via `loadstring(game:HttpGet(<url>))()`. "Done" for this
session's task = the rename to VynxUI is complete everywhere, and the example
loadstring in `main_example.lua` / README actually runs in Roblox without erroring.

## 2. Architecture / how it works
- Source: `src/Init.lua` + `src/elements`, `src/components`, `src/modules`, `src/themes`, `src/utils`.
- Build: `build/build.sh` runs `darklua` to bundle `src/Init.lua` → `dist/main.lua`
  (minified, single file, function names are single/double letters like `a.K()`).
  `.github/workflows/build.yml` runs this on every push to `main` and commits
  `dist/main.lua` back automatically.
- Runtime loading chain a Roblox user actually triggers:
  `main_example.lua` → fetches `loader.lua` → fetches `dist/main.lua` (the bundled lib)
  → `dist/main.lua`'s icon module fetches `website/public/vendor/icons/Main-v2.lua`
  → THAT file fetches 6 more per-pack icon files (lucide/solar/craft/geist/sfsymbols/gravity)
  from `website/public/vendor/icons/<pack>/dist/Icons.lua`.
- Docs site: `website/` (Next.js, static export via `output: "export"`), intended to be
  hosted at `rxinoussouls.github.io/VynxUI`. **This has never actually been deployed** —
  there is no GitHub Actions workflow that builds+publishes it to Pages. Only
  `build.yml` (builds dist/main.lua), `pull_request.yml` (PR checks), `release.yml`
  (tag releases) exist in `.github/workflows/`.
- Why this matters: every hardcoded `https://rxinoussouls.github.io/VynxUI/...` URL
  in the Lua runtime code is dead (404) because nothing is served there. This was the
  root cause of bug #1 below. Decision made: point runtime loadstring/HttpGet URLs at
  `raw.githubusercontent.com/rxinoussouls/VynxUI/main/<path>` instead, since those files
  really exist in the repo. Docs-site links (README "Documentation"/"Installation",
  website's own internal metadata) were LEFT pointing at github.io on purpose, since
  those are for the future Pages deploy (Option B, not done this session — see §5).

## 3. Current state — what's DONE
1. **Full rename WindUI → VynxUI** across the entire repo (case-preserving:
   WindUI→VynxUI, windui→vynxui, WINDUI→VYNXUI). ~133 files edited, plus files/dirs
   renamed (e.g. `website/public/windui/` → `website/public/vynxui/`,
   `docs/WindUI – Themes.png` → `docs/VynxUI – Themes.png`). Verified zero remaining
   case-insensitive "windui" hits anywhere outside `.git/`.
   Commit: `ee9704e` "Rename WindUI to VynxUI throughout project"
2. **Fixed stale org/repo name references** that caused separate 404s: old GitHub
   org/repo `article-hub-studio/VynxUI-Skibidi` and old owner `Footagesus/VynxUI` were
   replaced with `rxinoussouls/VynxUI` across ~48 files (URLs in docs, workflows,
   changelog, website ts/tsx). Also fixed `website/next.config.mjs`'s GH Pages
   `basePath` variable (`const repo = "VynxUI-Skibidi"` → `"VynxUI"`), and
   `website/package.json` / `website/package-lock.json` name field
   (`vynxui-skibidi-docs` → `vynxui-docs`). Left `Footagesus/Icons` and bare
   "Footagesus" author-credit mentions alone (different repo / personal credit, not
   a broken path).
   Commit: `64dc945` "Fix stale username/repo references..."
3. **Fixed broken relative link** in `README.md` line 36: `[Example](/main_example.lua)`
   (leading slash resolves to `github.com/main_example.lua` on GitHub's renderer, not
   the repo — 404). Fixed to a working absolute raw URL.
   Commit: `ea91a92`
4. **Fixed the actual runtime 404 the user was hitting in Roblox**: every
   `loadstring`/`HttpGet` call in the Lua runtime files pointed at
   `rxinoussouls.github.io/VynxUI/...` which is dead (see §2). Swapped to
   `raw.githubusercontent.com/rxinoussouls/VynxUI/main/...` equivalents in:
   `Main.lua`, `Example.lua`, `loader.lua`, `main_example.lua`, `main.client.lua`,
   `main2.client.lua`, `src/modules/Icons.lua`, `src/server/Icons.server.lua`,
   `examples/*.client.lua`, `dist/main.lua`, plus the dead mirror copies under
   `website/public/{main.lua,loader.lua,main_example.lua,dist/main.lua}` for
   consistency (these mirrors are NOT what Roblox fetches, just kept in sync).
   Verified via user's Roblox screenshot: the original 404 error was GONE after this.
   Commit: `f7f61da` "Point loadstring/HttpGet URLs at raw.githubusercontent.com..."
5. **Fixed second-order crash**: after fix #4, the 404 was gone but a NEW error
   appeared (user sent screenshot): yellow warning
   `[ VynxUI.Icons ] Unable to load the base icon catalog; custom sources remain available`
   followed by red error `attempt to index nil with number` inside `CreateWindow`
   (dist/main.lua line ~26561, at `an.Icon"expand"[1]`). Root cause: found and fixed —
   `website/public/vendor/icons/Main-v2.lua` (fetched at runtime by
   `src/modules/Icons.lua`'s `ICONS_URL`) still had ITS OWN 6 hardcoded
   `github.io` URLs for the individual icon packs (lucide/solar/craft/geist/
   sfsymbols/gravity), which 404'd, so the icon catalog loaded empty `{}`, so
   `IconModule.Icon("expand")` returned nil, so indexing `[1]` on nil crashed
   `CreateWindow`. Rewrote all 6 URLs in `Main-v2.lua` to raw.githubusercontent.com
   equivalents (verified each target file exists on disk:
   `website/public/vendor/icons/<pack>/dist/Icons.lua` for all 6 packs).
   Also re-synced the README loadstring example to the raw.githubusercontent URL.
   Commit: `6cf459f` "Fix icon-pack URLs inside Main-v2.lua..."
   **This fix has been pushed but NOT yet confirmed working in Roblox by the user.**

All 5 commits above have been pushed to `origin/main` on GitHub (repo is currently
at commit `6cf459f`). Pushes were done using short-lived personal access tokens the
user pasted directly into chat and asked to be used once, then revoked — do NOT
reuse any token value visible earlier in this conversation; if a new push is needed,
ask the user for a fresh token or have them push from their own machine.

## 4. Current state — what's IN PROGRESS right now
User said (message right before this handoff): "ยังบัคเหมือนเดิม" ("still buggy, same
as before") — but this message did NOT include a new screenshot or console error text,
and it's ambiguous whether they:
(a) re-tested AFTER commit `6cf459f` (the Main-v2.lua icon-pack URL fix) and it's
    still broken, or
(b) were referring to the state from BEFORE that fix (i.e. hadn't pulled/re-run yet)
No new diagnostic evidence has been gathered for this specific "still buggy" report.
**Immediate first step next session: ask the user for a fresh Roblox console
screenshot/error text taken AFTER pulling commit `6cf459f`, to confirm whether the
icon-catalog crash is actually fixed or whether there's a third-order bug.**

If it's still crashing after 6cf459f, things to check next, in order:
1. Confirm the 6 icon-pack raw URLs in `website/public/vendor/icons/Main-v2.lua`
   are actually fetchable (Roblox `game:HttpGet` sometimes has issues with GitHub's
   raw CDN caching/redirects that a browser fetch wouldn't show — was not able to
   verify via `web_fetch` tool in this sandbox since it restricts fetching URLs not
   already seen via search).
2. Check whether `dist/main.lua` (the file Roblox actually loads via `loader.lua`)
   needs to be rebuilt from `src/` — it was hand-edited via text find/replace for
   the rename+URL fixes rather than rebuilt via `build/build.sh`/darklua. This has
   worked so far for simple string swaps, but if any OTHER stale reference exists
   inside `dist/main.lua` that wasn't caught by the global find/replace (e.g. a
   differently-encoded URL, string built via concatenation instead of a literal),
   a rebuild from source would catch it where text-replace could not. Consider
   offering to run the real build (`npm install && npm run build`, needs Lua 5.1 +
   aftman/rojo/darklua per `build.yml` — NOT yet verified this sandbox can run it).
3. Double-check `src/server/Icons.server.lua` (server-side icon fetch, separate
   from the client-side `src/modules/Icons.lua`) — was included in the fix but not
   independently traced through a call path the way `Main-v2.lua` was.

## 5. What's NOT started yet
- [ ] Confirm fix `6cf459f` actually resolves the Roblox crash (see §4 — blocked on
      user re-testing and reporting back).
- [ ] Option B from earlier in the conversation, explicitly deferred: set up a real
      GitHub Actions workflow to build the Next.js `website/` and deploy it to GitHub
      Pages at `rxinoussouls.github.io/VynxUI`, so the docs-site links (left
      pointing at github.io on purpose) actually resolve. Not started at all.
- [ ] User asked "แก้ main.lua ให้มันดีกว่าอันเดิมไปเลย" (make main.lua better than the
      original) but gave no specifics when asked to clarify (offered: better error
      handling/pcall fallback messaging, cleaner example UI, or user's own idea).
      No response received yet — do not guess/start this without direction, ask again
      if the crash-fix confirmation comes back clean.
- [ ] No rebuild-from-source of `dist/main.lua` has been done — every dist/main.lua
      edit this session was a targeted text find/replace onto the existing bundled
      file, not a fresh darklua build. If more source-level bugs turn up, a real
      rebuild may be cleaner than more targeted patches.

## 6. Known issues / blockers / open questions
- Whether the icon-catalog crash is actually fixed is UNCONFIRMED (see §4).
- GitHub Pages for `website/` was never deployed and no workflow exists to deploy it —
  by design, out of scope for the "quick fix" (Option A) the user chose; Option B
  (proper Pages deploy) was explicitly deferred, not forgotten.
- This sandbox's `web_fetch` tool refused to fetch raw.githubusercontent.com URLs
  directly ("not in any prior search or fetch result"), so several of the raw URL
  fixes could only be verified by checking the file exists at that path in the local
  clone — NOT by actually confirming the URL resolves over HTTP the way Roblox would
  see it. If a "file exists locally but URL still 404s" scenario shows up, suspect
  branch name mismatch (repo default branch is `main` — confirmed via `git ls-remote`)
  or a path-casing mismatch (GitHub raw URLs are case-sensitive).
- Multiple short-lived PATs (personal access tokens) were pasted into this chat by
  the user over the session and used once each for pushing, per their instruction.
  All should be treated as already-revoked/dead by the time a new session starts —
  never attempt to reuse a token value that appears earlier in this transcript.

## 7. How to verify things work
1. In Roblox (Studio or live client), run:
   ```lua
   loadstring(game:HttpGet('https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/main_example.lua'))()
   ```
2. Expected if fully fixed: the VynxUI demo window opens (title "VynxUI Full
   Example"), no red errors in the console, at most informational/yellow output.
3. If still broken: get the exact yellow/red console text (a screenshot like the
   one from this session works well) — that's how both prior bugs in this session
   were actually diagnosed (the 404 message, then the `CreateWindow`/icon crash).
4. To check the repo state directly without Roblox:
   `git ls-remote https://github.com/rxinoussouls/VynxUI.git` should show
   `refs/heads/main` at `6cf459f...` (or later, if more commits landed since).

## 8. Key decisions log
- Chose case-preserving global rename (WindUI/windui/WINDUI → VynxUI/vynxui/VYNXUI)
  over a single-case replace, since the codebase used all three cases in different
  contexts (PascalCase code identifiers, lowercase URLs/package names, uppercase
  in a couple of workflow strings).
- Chose to fix runtime URLs to `raw.githubusercontent.com` (Option A, "quick fix")
  rather than standing up GitHub Pages deploy (Option B, "proper fix") first,
  per explicit user choice, because it works immediately without new CI setup.
- Left docs-site links (README docs/install links, website internal metadata)
  pointing at `github.io` rather than raw.githubusercontent, since those are meant
  to be human-facing web pages, not raw Lua fetches — they'll start working
  automatically once/if Option B (Pages deploy) is done later.
- Declined to reuse pasted PAT tokens beyond the single push each was provided for,
  and declined an initial request to force-push with a token pasted in chat before
  confirming the repo was the user's own — did the push once ownership + explicit
  reconfirmation were established.

## 9. Immediate next action
Ask the user: "Did you pull the latest commit (`6cf459f`) before testing again?
Can you send a fresh console screenshot from after that pull?" — do not attempt
further code changes until it's confirmed whether the icon-catalog fix actually
resolved the crash, since the next fix (if needed) depends entirely on what the
new error (if any) actually says.
