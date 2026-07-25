# HANDOFF — VynxUI + Cascade component merge

Last updated: 2026-07-26 · Updated by: Claude (chat session 1)
Current phase: 0 (Discovery) — repos cloned, structure inventoried, no edits made yet

## 1. What this project is
User wants to modify VynxUI (a Roblox Luau UI library, loaded via
`loadstring`/`HttpGet`, forked as "VynxUI Modded") — specifically its
`dist/`, `src/components`, `src/elements` folders — and port/add many
more components and elements sourced from a second Roblox UI library,
Cascade (built on Fusion). Goal: grow VynxUI's element/component set
significantly using Cascade as a source of extra components. "Done"
= VynxUI has new components/elements added under `src/`, and `dist/main.lua`
rebuilt to include them.

## 2. Architecture / how it works
**VynxUI** (`/home/claude/VynxUI`, cloned from
https://github.com/rxinoussouls/VynxUI.git, HEAD `977e20b`):
- `src/Init.lua` — library entry point
- `src/elements/` — 38 leaf UI elements (Button.lua, Toggle.lua, Slider.lua,
  Dropdown.lua, Accordion.lua, etc.) — plain `.lua`, not `.luau`
- `src/components/` — higher-level components: KeySystem.lua,
  LoadingScreen.lua, Notification.lua, plus subfolders `popup/`, `search/`,
  `ui/`, `window/`
- `src/config`, `src/themes`, `src/modules`, `src/utils`, `src/server`
- `build/` — darklua-based bundler (`darklua.config.json`,
  `darklua.dev.config.json`, `build.sh`, `header.lua`, `package.lua`) —
  this is what produces `dist/main.lua` (544K, single-file bundle) from
  `src/`
- `website/` — separate Next.js docs site, not part of the Lua lib
- Distributed via `loadstring(game:HttpGet('.../main_example.lua'))()`

**Cascade** (`/home/claude/Cascade`, cloned from
https://github.com/cascadeui/Cascade.git, HEAD `6ea63de`):
- `src/init.luau` — entry point
- `src/components/` — 29 files, built on **Fusion** (`packages/fusion.lua`
  present as a dependency) — Tab, Slider, Page, VStack, HStack, Form,
  Notification/, PopUpButton, PullDownButton, Section, Symbol,
  RadioCardGroup/, Toggle, Label, KeybindField, TitleStack, PageSection,
  Button, Stepper, Window, TextField, ImageSurface/, Row,
  RadioButtonGroup
- `src/modules`, `src/structures`, `src/themes`, `src/types.luau`
- `pipeline/darklua` — its own darklua-based build pipeline
- Uses `.luau` extension throughout (typed Luau); VynxUI mostly uses `.lua`

**Key incompatibility to solve before porting anything**: Cascade
components are written against the **Fusion** reactive framework
(`packages/fusion.lua`), while VynxUI's own elements do NOT import
Fusion — need to check VynxUI's actual state/reactivity pattern in
`src/utils` / `src/modules` before assuming a 1:1 port is possible.
This has NOT been checked yet — first real task of Phase 1.

## 3. Current state — what's DONE
- Cloned both repos into `/home/claude/VynxUI` and `/home/claude/Cascade`
  (this container's scratch space — **not persistent**, wiped between
  sessions; see Known issues below).
- Top-level structure of both inventoried (see section 2).
- Confirmed VynxUI ships via loadstring/HttpGet from `main.lua`/`dist/main.lua`,
  built by a darklua pipeline in `build/`.
- Confirmed Cascade is Fusion-based; VynxUI's reactivity approach not yet
  confirmed.

## 4. Current state — what's IN PROGRESS right now
Nothing mid-edit. Next real step (not yet started): read
`/home/claude/VynxUI/src/utils/` and `/home/claude/VynxUI/src/modules/`
to determine what state/reactivity system VynxUI's elements use, then
compare against Cascade's Fusion usage in one sample file, e.g.
`/home/claude/Cascade/src/components/Toggle.luau`, to decide the porting
strategy (direct copy+adapt vs full rewrite per component).

## 5. What's NOT started yet
- [ ] Diff VynxUI's state pattern vs Fusion (read src/utils, src/modules)
- [ ] Pick 1 Cascade component (e.g. Toggle or Stepper — VynxUI has both
      already, good for side-by-side comparison) and do one manual port to
      validate approach
- [ ] Decide which Cascade components are net-new vs duplicates of
      existing VynxUI elements (overlap seen already: Toggle, Slider,
      Stepper, Button, Section, HStack/VStack exist in BOTH — user said
      "add more elements", so likely only want the non-overlapping ones:
      Tab, Page, Form, Notification, PopUpButton, PullDownButton, Symbol,
      RadioCardGroup, Label, KeybindField, TitleStack, PageSection,
      TextField, ImageSurface, Row, RadioButtonGroup — confirm with user)
- [ ] Port chosen components into VynxUI's `src/elements/` or
      `src/components/` (needs a decision: does a ported component go in
      `elements/` (leaf) or `components/` (composite)? Match VynxUI's own
      existing split.)
- [ ] Rebuild `dist/main.lua` via VynxUI's own `build/build.sh` /
      darklua config after edits
- [ ] Verify nothing broke (VynxUI has `tests/` — .lua manual test files
      and a few `.test.js` files; check what actually runs them)

## 6. Known issues / blockers / open questions
- **Environment is not persistent.** Both repos currently live only in
  this session's container scratch space (`/home/claude`). Nothing here
  survives to the next chat session automatically. Before doing real
  editing work, user should confirm: (a) work happens in THIS
  container per-session and gets copied out via `present_files`/output
  dir at the end of each session, or (b) user wants this pushed to their
  own fork/branch each session (would need a GitHub token/`gh auth` —
  not set up yet). Ask user which before Phase 2 starts.
- Open question for user: confirm overlap list above (Toggle, Slider,
  Stepper, Button, Section, HStack, VStack) — skip porting these since
  VynxUI already has them, or replace with Cascade's version?
- Cascade's Fusion dependency: if VynxUI doesn't already use Fusion,
  porting either needs (a) vendoring Fusion into VynxUI too, or (b)
  rewriting each ported component against VynxUI's own reactivity —
  more work, but keeps one dependency model. Needs a decision once
  section 5's first checklist item is done.

## 7. How to verify things work
Not yet applicable — no edits made. Once building: VynxUI's
`build/build.sh` runs darklua per `build/darklua.config.json` to produce
`dist/main.lua`. Manual test files exist in `VynxUI/tests/*.lua` (run
inside Roblox Studio / an executor, not headless) and some `.test.js`
files (`acrylic-theme-safety.test.js` etc. — check `package.json` scripts
for how those actually run, not yet checked).

## 8. Key decisions log
- Chose to clone both repos fresh into container scratch rather than
  guessing structure from web — needed real file layout before planning
  a port.

## 9. Immediate next action
Read `VynxUI/src/utils/` and `VynxUI/src/modules/` to identify its
reactivity/state system, then open `Cascade/src/components/Toggle.luau`
to compare against `VynxUI/src/elements/Toggle.lua` side by side.
