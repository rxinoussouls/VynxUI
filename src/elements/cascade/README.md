# Cascade-sourced elements

Ported from https://github.com/cascadeui/Cascade.git (HEAD `6ea63de`).
These are **Fusion**-based components, vendored here as-is rather than
rewritten against VynxUI's own `Creator` module — see
`src/vendor/Fusion.lua` (copied from Cascade's `packages/fusion.lua`).

## Replacing existing VynxUI elements (overlap)
The old VynxUI versions of these were removed from `src/elements/`:
Toggle, Slider, Stepper, Button, Section, HStack, VStack.
Their Cascade replacements live here instead. **Any code elsewhere in
VynxUI (`require("../elements/Toggle")` etc.) that pointed at the old
files will now fail to resolve** until those call sites are updated to
`require("../elements/cascade/Toggle")` and adapted to the Fusion
calling convention (Cascade components take Fusion `scope`/props
tables; the old VynxUI ones used VynxUI's own `Creator.New` convention
— they are NOT drop-in API compatible). This has not been done yet —
tracked in HANDOFF.md Phase 2.

## Net-new elements (no VynxUI equivalent)
Tab, Page, Form, Notification/, PopUpButton, PullDownButton, Symbol,
RadioCardGroup/, Label, KeybindField, TitleStack, PageSection,
TextField, ImageSurface/, Row, RadioButtonGroup.
Same caveat: usable once something in VynxUI actually requires and
Fusion-scopes them; not yet wired into `src/Init.lua` or exposed on
the `VynxUI` table.
