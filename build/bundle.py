#!/usr/bin/env python3
"""
VYNX UI Bundle Script
Concatenates all modular Lua files into a single VynxUI.lua for distribution.

Usage:
  python3 build/bundle.py                        # build to build/VynxUI.lua with header
  python3 build/bundle.py --output path.lua      # custom output path
  python3 build/bundle.py --no-header            # skip header (for build.sh darklua flow)
"""
import os, re, sys, json
from datetime import date

ROOT    = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT = os.path.join(ROOT, "build", "VynxUI.lua")

# ── CLI args ──────────────────────────────────────────────────────────────────
args       = sys.argv[1:]
NO_HEADER  = "--no-header" in args
OUTPUT     = DEFAULT
if "--output" in args:
    idx    = args.index("--output")
    OUTPUT = args[idx + 1] if idx + 1 < len(args) else DEFAULT

# ── Order matters — dependencies first ───────────────────────────────────────
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

# ── Read package.json metadata ────────────────────────────────────────────────
pkg_path = os.path.join(ROOT, "package.json")
pkg = {}
if os.path.isfile(pkg_path):
    with open(pkg_path, encoding="utf-8") as f:
        pkg = json.load(f)

VERSION     = pkg.get("version", "0.0.0")
DESCRIPTION = pkg.get("description", "")
REPOSITORY  = pkg.get("repository", "")
LICENSE     = pkg.get("license", "MIT")
BUILD_DATE  = date.today().isoformat()

# ── Generate header from template ─────────────────────────────────────────────
def make_header():
    tpl_path = os.path.join(ROOT, "build", "header.lua")
    if not os.path.isfile(tpl_path):
        return f"-- VYNX UI v{VERSION} | {BUILD_DATE}\n"
    with open(tpl_path, encoding="utf-8") as f:
        tpl = f.read()
    tpl = tpl.replace("{{VERSION}}", VERSION)
    tpl = tpl.replace("{{BUILD_DATE}}", BUILD_DATE)
    tpl = tpl.replace("{{DESCRIPTION}}", DESCRIPTION)
    tpl = tpl.replace("{{REPOSITORY}}", REPOSITORY)
    tpl = tpl.replace("{{LICENSE}}", LICENSE)
    return tpl

# ── Assemble bundle ───────────────────────────────────────────────────────────
lines = []

if not NO_HEADER:
    lines.append(make_header())

lines += [
    "",
    "local _VYNX_MODULES = {}",
    "local _req = require",
    "local function require(path)",
    "    path = path:gsub('^%.+/', ''):gsub('\\\\', '/')",
    "    if _VYNX_MODULES[path] then return _VYNX_MODULES[path] end",
    "    local ok, r = pcall(_req, path)",
    "    if ok then return r end",
    "    error('VynxUI: module not found: ' .. tostring(path))",
    "end",
    "",
]

ok_count   = 0
skip_count = 0

for rel in MODULE_ORDER:
    fpath = os.path.join(ROOT, rel)
    if not os.path.isfile(fpath):
        print(f"  [SKIP] {rel}")
        skip_count += 1
        continue
    with open(fpath, encoding="utf-8") as f:
        src = f.read()
    key = rel.replace("\\", "/")
    lines.append(f"-- ── {rel} ──")
    lines.append(f'_VYNX_MODULES["{key}"] = (function()')
    lines.append(src)
    lines.append("end)()")
    lines.append("")
    print(f"  [OK]   {rel}")
    ok_count += 1

lines.append('return _VYNX_MODULES["Library.lua"]')

# ── Write output ──────────────────────────────────────────────────────────────
os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
with open(OUTPUT, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

size_kb = os.path.getsize(OUTPUT) / 1024
print(f"\n  Bundled {ok_count} modules ({skip_count} skipped)")
print(f"  Output  → {OUTPUT}  ({size_kb:.1f} KB)")
