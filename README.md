<div align="center">

# ◈ VYNX UI

**A modern Roblox UI library with 40+ elements, dual API, and full Obsidian compatibility**

[![Version](https://img.shields.io/badge/Version-1.0.0-7C5CFF?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0xMiAyTDIgN2wxMCA1IDEwLTV6TTIgMTdsOCA0IDgtNE0yIDEybDggNCA4LTQiLz48L3N2Zz4=)](https://github.com/rxinoussouls/VynxUI)
[![License](https://img.shields.io/badge/License-MIT-22c55e?style=for-the-badge)](LICENSE)
[![WindUI](https://img.shields.io/badge/Based_on-WindUI-4f46e5?style=for-the-badge)](https://github.com/article-hub-studio/WindUI-Skibidi)
[![Obsidian](https://img.shields.io/badge/+_Obsidian-6366f1?style=for-the-badge)](https://github.com/deividcomsono/Obsidian)

<br>

```lua
local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()
```

</div>

---

## Features

- **40+ UI Elements** — Toggle, Slider, Dropdown, Colorpicker, Keybind, DependencyBox and more
- **Dual API** — Both WindUI style and Obsidian style work side by side
- **7 Themes** — Dark, Light, Vynx, Midnight, Rose, Serenity, Fatality + custom themes
- **DependencyBox** — Show/hide element groups automatically based on toggle/dropdown state
- **Global Registry** — Access any element via `VynxUI.Toggles["id"]` or `VynxUI.Options["id"]`
- **Motion Presets** — Subtle, Liquid, Snappy, Static animation presets
- **Key Systems** — Junkie Development, Platoboost, Luarmor, PandaDev
- **Icons** — Lucide, Craft, Geist, Solar, SF Symbols via [Icons library](https://github.com/Footagesus/Icons)
- **Acrylic Blur** — Depth-of-field window blur
- **Draggable Overlays** — Floating labels, buttons, and menus

---

## Installation

```lua
local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()
```

---

## Quick Start

### WindUI Style

```lua
local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()

VynxUI:SetTheme("Vynx")
VynxUI:SetMotionPreset("Liquid")

local Window = VynxUI:CreateWindow({
    Title     = "My Hub",
    Author    = "YourName",
    Icon      = "star",
    Size      = UDim2.fromOffset(600, 440),
    ToggleKey = Enum.KeyCode.RightControl,
    Footer    = { Text = "v1.0" },
})

local Tab     = Window:CreateTab({ Title = "Main", Icon = "home" })
local Section = Tab:Section({ Title = "Controls" })

local toggle = Section:Toggle({
    Title    = "Auto Farm",
    Default  = false,
    Flag     = "autoFarm",
    Callback = function(v) print("Auto Farm:", v) end,
})

local slider = Section:Slider({
    Title    = "Speed",
    Min      = 1,
    Max      = 100,
    Default  = 50,
    Suffix   = "x",
    Flag     = "speed",
    Callback = function(v) print("Speed:", v) end,
})
```

### Obsidian Style

```lua
local Tab  = Window:CreateTab({ Title = "Combat", Icon = "sword" })
local Left = Tab:AddLeftGroupbox("Settings")

Left:AddToggle("autoAttack", {
    Text     = "Auto Attack",
    Default  = false,
    Callback = function(v) print("Auto Attack:", v) end,
})

Left:AddSlider("attackSpeed", {
    Text    = "Speed",
    Min     = 1,
    Max     = 10,
    Default = 5,
    Suffix  = "x",
})

Left:AddDropdown("target", {
    Text    = "Target",
    Values  = { "Nearest", "Furthest", "Random" },
    Default = "Nearest",
})

Left:AddKeyPicker("hotkey", {
    Text    = "Hotkey",
    Default = Enum.KeyCode.F,
})

Left:AddColorPicker("color", {
    Text    = "Color",
    Default = Color3.fromHex("#7C5CFF"),
})

Left:AddButton("myBtn", {
    Text     = "Click Me",
    Callback = function() print("Clicked!") end,
})

Left:AddDivider()

Left:AddLabel("status", { Text = "Status: Ready" })

-- Global access
print(VynxUI.Toggles["autoAttack"].Value)
print(VynxUI.Options["attackSpeed"].Value)
VynxUI.Toggles["autoAttack"]:SetValue(true)
```

---

## DependencyBox

Show/hide a group of elements based on another element's value:

```lua
local Group = Tab:AddGroupbox("Advanced")

Group:AddToggle("enableAdv", {
    Text    = "Enable Advanced",
    Default = false,
})

local Dep = Group:AddDependencyBox()

Dep:AddToggle("subOption", {
    Text     = "Sub Option",
    Default  = false,
    Callback = function(v) print("Sub:", v) end,
})

Dep:AddSlider("subSpeed", {
    Text    = "Sub Speed",
    Min     = 1,
    Max     = 50,
    Default = 10,
})

Dep:SetupDependencies({
    { VynxUI.Toggles["enableAdv"], true }
})
-- Dep will only show when enableAdv = true
```

---

## Themes

```lua
VynxUI:SetTheme("Dark")      -- Dark (default)
VynxUI:SetTheme("Light")     -- Light
VynxUI:SetTheme("Vynx")      -- Purple gradient
VynxUI:SetTheme("Midnight")  -- Deep blue
VynxUI:SetTheme("Rose")      -- Red / pink
VynxUI:SetTheme("Serenity")  -- Teal
VynxUI:SetTheme("Fatality")  -- Black / red

-- Custom theme
VynxUI:AddTheme({
    Name       = "MyTheme",
    Background = Color3.fromHex("#0A0A0A"),
    Primary    = Color3.fromHex("#FF6B00"),
    Text       = Color3.new(1, 1, 1),
    -- see docs/themes.md for all keys
})
VynxUI:SetTheme("MyTheme")
```

---

## Motion

```lua
VynxUI:SetMotionPreset("Subtle")   -- Light animations
VynxUI:SetMotionPreset("Liquid")   -- Smooth fluid
VynxUI:SetMotionPreset("Snappy")   -- Fast & sharp
VynxUI:SetMotionPreset("Static")   -- No animation
```

---

## Notifications

```lua
VynxUI:Notify({
    Title    = "VYNX",
    Content  = "Loaded successfully!",
    Style    = "Success",   -- Info | Success | Warning | Error | Notice
    Duration = 5,
    Icon     = "circle-check",
    Side     = "Right",     -- Left | Right
})
```

---

## Key System

```lua
local Window = VynxUI:CreateWindow({
    Title    = "My Hub",
    KeySystem = {
        Service   = "junkiedevelopment",
        ServiceId = "YOUR_SERVICE_ID",
        ApiKey    = "YOUR_API_KEY",
        Provider  = "xlinkx",
    },
})
```

Supported services: `junkiedevelopment` · `platoboost` · `luarmor` · `pandadevelopment`

---

## Draggable Overlays

```lua
local label = VynxUI:AddDraggableLabel("VYNX Hub • v1.0", UDim2.fromOffset(8, 8))
label:SetText("Updated text")

local btn = VynxUI:AddDraggableButton("Toggle UI", function()
    VynxUI:Toggle()
end)

local menu = VynxUI:AddDraggableMenu("Keybinds")
menu:AddItem("Auto Farm → F", function() end)
menu:AddItem("ESP → G",       function() end)
menu:SetVisible(true)
```

---

## Lifecycle & Cleanup

```lua
-- Signal auto-cleanup on unload
VynxUI:GiveSignal(workspace.ChildAdded:Connect(function() end))

-- Callback before unload
VynxUI:OnUnload(function()
    print("UI unloaded, cleaning up...")
end)

-- Destroy everything
VynxUI:Unload()
```

---

## Addons

### ThemeManager

```lua
local ThemeManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/addons/ThemeManager.lua"
))()
ThemeManager:SetLibrary(VynxUI)
ThemeManager:SetFolder("VynxUI")
ThemeManager:BuildThemeSection(Tab)
```

### SaveManager

```lua
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/addons/SaveManager.lua"
))()
SaveManager:SetLibrary(VynxUI)
SaveManager:SetFolder("VynxUI/" .. game.PlaceId)
SaveManager:BuildConfigSection(Tab)
```

---

## Elements Reference

| Category | Elements |
|---|---|
| **Input** | Toggle, Slider, Dropdown, Input, Keybind, Colorpicker, Checkbox, RadioGroup, CheckboxGroup, SegmentedControl, TextArea, Stepper |
| **Display** | Paragraph, Badge, Callout, StatusCard, StatCard, KeyValue, DiscordCard, EmptyState |
| **Layout** | Section / Groupbox, Divider, Space, Card, Group, HStack, VStack, Accordion, TabBox |
| **Media** | Image, Viewport, Video, Path2D |
| **Action** | Button, ActionList, ChipList |
| **Data** | ProgressBar, MeterGroup, Timeline, Code |
| **Obsidian** | DependencyBox, DependencyGroupbox, UIPassthrough |

---

## Icons

VYNX UI uses the [Icons library by Footagesus](https://github.com/Footagesus/Icons) supporting:

- [Lucide Icons](https://github.com/lucide-icons/lucide)
- [Craft Icons](https://www.figma.com/community/file/1415718327120418204)
- [Geist Icons](https://vercel.com/geist/icons)
- [Solar Icons](https://icones.js.org/collection/solar)
- [SF Symbols](https://sf-symbols-one.vercel.app/)

```lua
Window:CreateTab({ Title = "Main", Icon = "home" })
Section:Toggle({ Title = "Enable", Icon = "check" })
VynxUI:Notify({ Icon = "circle-check", ... })
```

---

## Credits

VYNX UI is built on the work of these amazing open source projects:

**[WindUI](https://github.com/article-hub-studio/WindUI-Skibidi)** by Footagesus / article-hub-studio
— Core UI library, all elements, motion system, icon integration, acrylic blur, key systems, themes

**[Obsidian](https://github.com/deividcomsono/Obsidian)** by deividcomsono
— DependencyBox system, global element registry (Toggles/Options), Obsidian-style API, SaveManager, ThemeManager

**[Icons](https://github.com/Footagesus/Icons)** by Footagesus
— Multi-source icon library (Lucide, Craft, Geist, Solar, SF Symbols)

---

<div align="center">

MIT License · Made by [rxinoussouls](https://github.com/rxinoussouls)

</div>
