#!/usr/bin/env python3
"""
VYNX UI Bundle Script
Concatenates all modular Lua files into a single Library.lua for distribution.
Replaces require() calls with inline module tables.
"""
import os, re, sys

ROOT   = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT = os.path.join(ROOT, "build", "VynxUI.lua")

# Order matters — dependencies first
MODULE_ORDER = [
    "modules/Motion.lua",
    "modules/DynamicShape.lua",
    "modules/Highlighter.lua",
    "modules/Localization.lua",
    "modules/Icons.lua",
    "modules/Creator.lua",
    "themes/Fallbacks.lua",
    "themes/Init.lua",
    "utils/Acrylic/Utils.lua",
    "utils/Acrylic/Blur.lua",
    "utils/Acrylic/Paint.lua",
    "utils/Acrylic/Init.lua",
    "utils/services/JunkieDevelopment.lua",
    "utils/services/Luarmor.lua",
    "utils/services/PandaDevelopment.lua",
    "utils/services/Platoboost.lua",
    "utils/services/Init.lua",
    "components/ConfigManager.lua",
    "components/Notification.lua",
    "components/LoadingScreen.lua",
    "components/KeySystem.lua",
    "window/Element.lua",
    "window/GoldenEffect.lua",
    "window/KeyBindMenu.lua",
    "window/Openbutton.lua",
    "window/Watermark.lua",
    "window/SettingsMenu.lua",
    "window/Dialog.lua",
    "window/Section.lua",
    "window/Tab.lua",
    "window/Init.lua",
    "elements/DisplayElementUtils.lua",
    "elements/ModernControlUtils.lua",
    "elements/Paragraph.lua",
    "elements/Button.lua",
    "elements/Toggle.lua",
    "elements/Slider.lua",
    "elements/ProgressBar.lua",
    "elements/Keybind.lua",
    "elements/Input.lua",
    "elements/Dropdown.lua",
    "elements/Code.lua",
    "elements/Colorpicker.lua",
    "elements/Checkbox.lua",
    "elements/UIPassthrough.lua",
    "elements/RadioGroup.lua",
    "elements/CheckboxGroup.lua",
    "elements/SegmentedControl.lua",
    "elements/TextArea.lua",
    "elements/Stepper.lua",
    "elements/Callout.lua",
    "elements/Badge.lua",
    "elements/StatusCard.lua",
    "elements/StatCard.lua",
    "elements/KeyValue.lua",
    "elements/ChipList.lua",
    "elements/ActionList.lua",
    "elements/MeterGroup.lua",
    "elements/Timeline.lua",
    "elements/Accordion.lua",
    "elements/EmptyState.lua",
    "elements/DiscordCard.lua",
    "elements/TabBox.lua",
    "elements/Path2D.lua",
    "elements/Card.lua",
    "elements/Section.lua",
    "elements/Divider.lua",
    "elements/Space.lua",
    "elements/Image.lua",
    "elements/Group.lua",
    "elements/HStack.lua",
    "elements/VStack.lua",
    "elements/Viewport.lua",
    "elements/Video.lua",
    "elements/DependencyBox.lua",
    "elements/Init.lua",
    "Library.lua",
]

lines = [
    "-- VYNX UI Library — Bundled Build",
    "-- Auto-generated. Do not edit directly.",
    "-- Source: github.com/your-github/VynxUI",
    "",
    "local _VYNX_MODULES = {}",
    "local function require(path)",
    "    path = path:gsub('^%.+/', ''):gsub('/', '/')",
    "    if _VYNX_MODULES[path] then return _VYNX_MODULES[path] end",
    "    error('VynxUI: module not found: ' .. path)",
    "end",
    "",
]

for rel in MODULE_ORDER:
    path = os.path.join(ROOT, rel)
    if not os.path.isfile(path):
        print(f"  [SKIP] {rel}")
        continue
    with open(path, encoding="utf-8") as f:
        src = f.read()
    key = rel.replace("\\", "/")
    lines.append(f"-- ── {rel} ──")
    lines.append(f'_VYNX_MODULES["{key}"] = (function()')
    lines.append(src)
    lines.append("end)()")
    lines.append("")
    print(f"  [OK]   {rel}")

lines.append("return _VYNX_MODULES[\"Library.lua\"]")

os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
with open(OUTPUT, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

size_kb = os.path.getsize(OUTPUT) / 1024
print(f"\nBundle written → {OUTPUT}  ({size_kb:.1f} KB)")
