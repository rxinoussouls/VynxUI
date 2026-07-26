# 1.6.67

## Changelog

- added `ImageSurface` element, ported from [Cascade](https://github.com/cascadeui/Cascade) (`src/components/ImageSurface`)
- added `Sequoia` theme, translated from Cascade's macOS-Sequoia `Dark` theme + `Blue` accent
- added `ImageSurfaceBackground` fallback theme key (`src/themes/Fallbacks.lua`) so `ImageSurface` themes correctly on every existing theme without per-theme edits
- **note:** `dist/main.lua` / `Main.lua` are generated bundles -- run `npm run build` (requires `aftman install` for `darklua`) to regenerate them after this source change

# 1.6.66

## Changelog

- added `CodeSize: number`, `CodeTheme: table`, `CanCopied: boolean` and `Height: UDim` to [Code](https://footagesus.github.io/treehub-web/docs/vynxui/code) element (#91)
- changed PandaDev API url in [Key System](https://footagesus.github.io/treehub-web/docs/vynxui/keysystem) (#92)
- fixed [Section](https://footagesus.github.io/treehub-web/docs/vynxui/sections) bg (in custom themes)
- fixed [Colorpicker](https://footagesus.github.io/treehub-web/docs/vynxui/colorpicker) issue
- fixed `Viewport` bug when u can pinch it outside
- fixed [Window](https://footagesus.github.io/treehub-web/docs/vynxui/window) Drag with multiple fingers (#79)
- added `ProgressBar` element (#95 by [BitRevenant](https://github.com/BitRevenant)) [Github PR](https://github.com/rxinoussouls/VynxUI/pull/95)
- fixed `Dropdown.Locked` (#94 by [BitRevenant](https://github.com/BitRevenant)) [Github PR](https://github.com/rxinoussouls/VynxUI/pull/94)
