# 1.2.0

## Changelog

- added `DependencyBox` element — show/hide element groups based on toggle/dropdown state
- added `Obsidian-style API` — `AddToggle`, `AddSlider`, `AddDropdown`, `AddColorPicker`, `AddKeyPicker`, `AddButton`, `AddLabel`, `AddDivider`, `AddGroupbox`, `AddLeftGroupbox`
- added `Global Registry` — `VynxUI.Toggles["id"]` and `VynxUI.Options["id"]` for cross-script access
- added `Dynamic Island` — iOS-style pill button with hover expand, pulse on notify, tap-to-toggle
- added `Draggable Overlays` — `AddDraggableLabel`, `AddDraggableButton`, `AddDraggableMenu`
- added 7 new themes: `Serenity`, `Fatality`, `Nord`, `Dracula`, `Catppuccin`, `TokyoNight`, `Gruvbox`, `Cyberpunk`, `Aurora`
- added `GiveSignal` and `OnUnload` lifecycle hooks
- added `SaveManager` and `ThemeManager` addons
- added `UIPassthrough` element for Obsidian compatibility
- added `Checkbox` standalone element
- fixed `Dropdown.Locked` state not persisting
- fixed `Colorpicker` hue slider precision
- fixed window drag on multi-touch devices
