<div align="center">

<br>

# ◈ VYNX UI

**Modern Roblox UI Library · 40+ Elements · 14 Themes · Dual API**

<br>

[![Version](https://img.shields.io/badge/v1.2.0-7C5CFF?style=flat-square&label=version)](https://github.com/rxinoussouls/VynxUI)
[![License](https://img.shields.io/badge/MIT-22c55e?style=flat-square&label=license)](LICENSE)
[![WindUI](https://img.shields.io/badge/WindUI-4f46e5?style=flat-square&logo=roblox)](https://github.com/article-hub-studio/WindUI-Skibidi)
[![Obsidian](https://img.shields.io/badge/Obsidian-6366f1?style=flat-square)](https://github.com/deividcomsono/Obsidian)

<br>

```lua
local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()
```

</div>

---

## Features

- **40+ Elements** — Toggle, Slider, Dropdown, Colorpicker, Keybind, Code, Timeline, Accordion...
- **Dual API** — WindUI style and Obsidian style work side by side
- **14 Themes** — Dark · Vynx · Midnight · Rose · Serenity · Fatality · Nord · Dracula · Catppuccin · TokyoNight · Gruvbox · Cyberpunk · Aurora · Light
- **Dynamic Island** — iOS-style pill button that expands on notifications/hover
- **DependencyBox** — Show/hide element groups based on toggle/dropdown values
- **Global Registry** — `VynxUI.Toggles["id"]` · `VynxUI.Options["id"]`
- **Motion Presets** — Subtle · Liquid · Snappy · Static
- **Key Systems** — Junkie · Platoboost · Luarmor · PandaDev
- **Icons** — Lucide · Craft · Geist · Solar · SF Symbols

---

## Quick Start

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
```

---

## WindUI Style

```lua
local Tab = Window:CreateTab({ Title = "Main", Icon = "home" })
local S   = Tab:Section({ Title = "Controls" })

S:Toggle({ Title="Auto Farm", Default=false, Flag="af", Callback=function(v) end })
S:Slider({ Title="Speed", Min=1, Max=100, Default=50, Suffix="x", Flag="spd" })
S:Dropdown({ Title="Mode", Values={"A","B","C"}, Default="A", Flag="mode" })
S:Input({ Title="Name", Placeholder="...", Flag="name" })
S:Keybind({ Title="Hotkey", Default=Enum.KeyCode.F, Flag="hk" })
S:Colorpicker({ Title="Color", Default=Color3.fromHex("#7C5CFF"), Flag="col" })
S:Button({ Title="Click", Callback=function() end })
```

---

## Obsidian Style

```lua
local Tab  = Window:CreateTab({ Title = "Combat" })
local Left = Tab:AddLeftGroupbox("Settings")

Left:AddToggle("autoAtk", { Text="Auto Attack", Default=false, Callback=function(v) end })
Left:AddSlider("atkSpd",  { Text="Speed", Min=1, Max=10, Default=5, Suffix="x" })
Left:AddDropdown("target",{ Text="Target", Values={"Near","Far"}, Default="Near" })
Left:AddInput("name",     { Text="Name", PlaceholderText="..." })
Left:AddKeyPicker("hk",   { Text="Hotkey", Default=Enum.KeyCode.F })
Left:AddColorPicker("col",{ Text="Color", Default=Color3.fromHex("#7C5CFF") })
Left:AddButton("btn",     { Text="Click", Callback=function() end })
Left:AddDivider()
Left:AddLabel("lbl",      { Text="Status: OK" })

-- Global access
VynxUI.Toggles["autoAtk"].Value
VynxUI.Options["atkSpd"]:SetValue(10)
```

---

## DependencyBox

```lua
local Group = Tab:AddGroupbox("Advanced")
Group:AddToggle("enable", { Text="Enable", Default=false })

local Dep = Group:AddDependencyBox()
Dep:AddToggle("sub",   { Text="Sub Option", Default=false })
Dep:AddSlider("speed", { Text="Speed", Min=1, Max=50, Default=10 })

Dep:SetupDependencies({
    { VynxUI.Toggles["enable"], true }
})
```

---

## Themes (14)

```lua
VynxUI:SetTheme("Dark")        -- Default dark
VynxUI:SetTheme("Vynx")        -- Purple gradient
VynxUI:SetTheme("Midnight")    -- Deep blue
VynxUI:SetTheme("Rose")        -- Red/pink
VynxUI:SetTheme("Serenity")    -- Teal
VynxUI:SetTheme("Fatality")    -- Black/red
VynxUI:SetTheme("Nord")        -- Nordic blue-gray
VynxUI:SetTheme("Dracula")     -- Dracula classic
VynxUI:SetTheme("Catppuccin")  -- Catppuccin Mocha
VynxUI:SetTheme("TokyoNight")  -- Tokyo Night
VynxUI:SetTheme("Gruvbox")     -- Gruvbox dark
VynxUI:SetTheme("Cyberpunk")   -- Neon cyberpunk
VynxUI:SetTheme("Aurora")      -- Green aurora
VynxUI:SetTheme("Light")       -- Light mode
```

---

## Dynamic Island

VYNX UI includes an iOS-inspired Dynamic Island button that:
- Expands on hover to show window title
- Pulses with color on notifications
- Tap to toggle the window open/closed

```lua
-- Available after CreateWindow
VynxUI.DynamicIsland:Pulse("Loading...", Color3.fromHex("#33C759"))
VynxUI.DynamicIsland:SetIcon("rbxassetid://...")
VynxUI.DynamicIsland:SetTitle("VYNX Hub")
```

---

## Notifications

```lua
VynxUI:Notify({
    Title    = "VYNX",
    Content  = "Done!",
    Style    = "Success",   -- Info | Success | Warning | Error | Notice
    Duration = 5,
    Icon     = "circle-check",
    Side     = "Right",
})
```

---

## Draggable Overlays

```lua
local label = VynxUI:AddDraggableLabel("VYNX Hub • v1.0")
local btn   = VynxUI:AddDraggableButton("Toggle UI", function() VynxUI:Toggle() end)
local menu  = VynxUI:AddDraggableMenu("Keybinds")
menu:AddItem("Auto Farm → F", function() end)
menu:SetVisible(true)
```

---

## Key System

```lua
VynxUI:CreateWindow({
    Title    = "Hub",
    KeySystem = {
        Service   = "junkiedevelopment",
        ServiceId = "YOUR_ID",
        ApiKey    = "YOUR_KEY",
        Provider  = "xlinkx",
    },
})
-- Also: platoboost | luarmor | pandadevelopment
```

---

## Addons

```lua
-- ThemeManager
local TM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/addons/ThemeManager.lua"
))()
TM:SetLibrary(VynxUI); TM:SetFolder("VynxUI"); TM:BuildThemeSection(Tab)

-- SaveManager
local SM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/addons/SaveManager.lua"
))()
SM:SetLibrary(VynxUI); SM:SetFolder("VynxUI/"..game.PlaceId); SM:BuildConfigSection(Tab)
```

---

## Lifecycle

```lua
VynxUI:GiveSignal(someConnection)      -- auto-disconnect on unload
VynxUI:OnUnload(function() end)        -- callback before unload
VynxUI:SetTheme("Nord")                -- change theme at runtime
VynxUI:SetMotionPreset("Snappy")       -- change animation preset
VynxUI:Toggle()                        -- show/hide UI
VynxUI:Unload()                        -- destroy everything
```

---

## Icons

Uses [Icons by Footagesus](https://github.com/Footagesus/Icons) — supports:
[Lucide](https://github.com/lucide-icons/lucide) · [Craft](https://www.figma.com/community/file/1415718327120418204) · [Geist](https://vercel.com/geist/icons) · [Solar](https://icones.js.org/collection/solar) · [SF Symbols](https://sf-symbols-one.vercel.app/)

---

## Credits

**[WindUI](https://github.com/article-hub-studio/WindUI-Skibidi)** by Footagesus / article-hub-studio
— Core UI library, all 40+ elements, motion system, icon integration, acrylic blur, key systems

**[Obsidian](https://github.com/deividcomsono/Obsidian)** by deividcomsono
— DependencyBox, global element registry (Toggles/Options), Obsidian-style API, SaveManager, ThemeManager

---

<div align="center">

MIT License · [rxinoussouls](https://github.com/rxinoussouls)

</div>
