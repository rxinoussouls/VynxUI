<div align="center">

<br>

# ◈ VYNX UI

**Roblox UI Library — WindUI + Obsidian + NeverLose**

<br>

[![Version](https://img.shields.io/badge/v1.3.0-7C5CFF?style=flat-square&label=version)](https://github.com/rxinoussouls/VynxUI/releases)
[![License](https://img.shields.io/badge/MIT-22c55e?style=flat-square&label=license)](LICENSE)
[![WindUI](https://img.shields.io/badge/WindUI-4f46e5?style=flat-square)](https://github.com/article-hub-studio/WindUI-Skibidi)
[![Obsidian](https://img.shields.io/badge/Obsidian-6d28d9?style=flat-square)](https://github.com/deividcomsono/Obsidian)
[![NeverLose](https://img.shields.io/badge/NeverLose-dc2626?style=flat-square)](https://github.com/4lpaca-pin/NeverLose)

<br>

```lua
local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()
```

</div>

---

## Features

| Feature | Description |
|---|---|
| **40+ Elements** | Toggle, Slider, Dropdown, Colorpicker, Keybind, Code, Accordion, Timeline... |
| **Dual API** | WindUI style (`Section:Toggle{}`) and Obsidian style (`Group:AddToggle(id,{})`) |
| **14 Themes** | Dark · Vynx · Midnight · Rose · Serenity · Fatality · Nord · Dracula · Catppuccin · TokyoNight · Gruvbox · Cyberpunk · Aurora · Light |
| **Dynamic Island** | iOS-style pill button — expands on hover, pulses on notifications |
| **DependencyBox** | Show/hide element groups based on toggle/dropdown state |
| **NeverLose API** | `AddToggle`, `AddSlider`, `AddSection`, `AddOption`, `Watermark:AddBlock` |
| **Global Registry** | `VynxUI.Toggles["id"]` · `VynxUI.Options["id"]` |
| **Motion Presets** | Subtle · Liquid · Snappy · Static |
| **Key Systems** | Junkie · Platoboost · Luarmor · PandaDev |

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

local toggle = S:Toggle({
    Title    = "Auto Farm",
    Default  = false,
    Flag     = "autoFarm",
    Callback = function(v) print(v) end,
})
S:Slider({ Title = "Speed", Min = 1, Max = 100, Default = 50, Suffix = "x", Flag = "speed" })
S:Dropdown({ Title = "Mode", Values = {"A","B","C"}, Default = "A", Flag = "mode" })
S:Input({ Title = "Name", Placeholder = "...", Flag = "name" })
S:Keybind({ Title = "Hotkey", Default = Enum.KeyCode.F, Flag = "hk" })
S:Colorpicker({ Title = "Color", Default = Color3.fromHex("#7C5CFF"), Flag = "col" })
S:Button({ Title = "Click", Callback = function() end })
```

---

## Obsidian Style

```lua
local Tab  = Window:CreateTab({ Title = "Combat" })
local Left = Tab:AddLeftGroupbox("Settings")

Left:AddToggle("autoAtk", { Text = "Auto Attack", Default = false, Callback = function(v) end })
Left:AddSlider("atkSpd",  { Text = "Speed", Min = 1, Max = 10, Default = 5 })
Left:AddDropdown("mode",  { Text = "Mode", Values = {"A","B"}, Default = "A" })
Left:AddInput("name",     { Text = "Name", PlaceholderText = "..." })
Left:AddKeyPicker("hk",   { Text = "Hotkey", Default = Enum.KeyCode.F })
Left:AddColorPicker("col",{ Text = "Color", Default = Color3.fromHex("#7C5CFF") })
Left:AddButton("btn",     { Text = "Click", Callback = function() end })
Left:AddDivider()
Left:AddLabel("lbl",      { Text = "Status: Ready" })

-- Global access
VynxUI.Toggles["autoAtk"].Value        -- bool
VynxUI.Options["atkSpd"]:SetValue(10)  -- update
```

---

## NeverLose Style

```lua
local Win = VynxUI:CreateWindow({
    Title     = "My Hub",
    Author    = "YourName",
    Size      = UDim2.fromOffset(640, 480),
    ToggleKey = Enum.KeyCode.Insert,
})

-- NeverLose API (on top of VynxUI)
Win:SetAccount({
    Username = "Player",
    Profile  = "rbxassetid://0",
    Expires  = "Never",
})

local Tab = Win:CreateTab({ Title = "Aimbot", Icon = "crosshairs" })
local Sec = Tab:AddSection({ Name = "Settings", Position = "left" })

Sec:AddToggle("aimbot",  { Text = "Enable Aimbot",   Default = false })
Sec:AddSlider("fov",     { Text = "FOV",  Min = 1, Max = 360, Default = 90 })
Sec:AddDropdown("bone",  { Text = "Bone", Values = {"Head","Neck","Chest"}, Default = "Head" })
Sec:AddKeybind("aimKey", { Text = "Aim Key", Default = Enum.KeyCode.C })

-- Watermark
local WM = VynxUI:CreateWatermark()
local fps = WM:AddBlock("◈", "VYNX Hub")
WM:SetRender(true)
```

---

## DependencyBox

```lua
local Group = Tab:AddGroupbox("Advanced")
Group:AddToggle("enable", { Text = "Enable", Default = false })

local Dep = Group:AddDependencyBox()
Dep:AddToggle("sub",   { Text = "Sub Option", Default = false })
Dep:AddSlider("speed", { Text = "Speed", Min = 1, Max = 50, Default = 10 })
Dep:SetupDependencies({
    { VynxUI.Toggles["enable"], true }
})
-- Shows only when "enable" = true
```

---

## Dynamic Island

An iOS-style pill button appears at the top center of the screen:
- **Hover** → expands to show window title
- **Click** → toggles the window open/close
- **Notify** → pulses with notification color

```lua
-- After CreateWindow, available as:
VynxUI.DynamicIsland:Pulse("Loading...", Color3.fromHex("#33C759"))
VynxUI.DynamicIsland:SetTitle("VYNX Hub v1.0")
```

---

## Themes (14)

```lua
VynxUI:SetTheme("Dark")        VynxUI:SetTheme("Vynx")
VynxUI:SetTheme("Midnight")    VynxUI:SetTheme("Rose")
VynxUI:SetTheme("Serenity")    VynxUI:SetTheme("Fatality")
VynxUI:SetTheme("Nord")        VynxUI:SetTheme("Dracula")
VynxUI:SetTheme("Catppuccin")  VynxUI:SetTheme("TokyoNight")
VynxUI:SetTheme("Gruvbox")     VynxUI:SetTheme("Cyberpunk")
VynxUI:SetTheme("Aurora")      VynxUI:SetTheme("Light")
```

Custom theme:
```lua
VynxUI:AddTheme({
    Name       = "MyTheme",
    Background = Color3.fromHex("#0a0a0a"),
    Primary    = Color3.fromHex("#ff6b00"),
    Text       = Color3.new(1,1,1),
    PanelBackground = Color3.fromHex("#1a1a1a"),
    PanelBackgroundTransparency = 0,
    -- ... (all theme keys)
})
VynxUI:SetTheme("MyTheme")
```

---

## Notifications

```lua
VynxUI:Notify({
    Title    = "VYNX",
    Content  = "Done!",
    Style    = "Success",  -- Info | Success | Warning | Error | Notice
    Duration = 5,
    Icon     = "circle-check",
    Side     = "Right",
})
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
```

---

## Lifecycle

```lua
VynxUI:GiveSignal(connection)     -- auto-disconnect on unload
VynxUI:OnUnload(function() end)   -- callback on unload
VynxUI:SetTheme("Nord")           -- change theme anytime
VynxUI:SetMotionPreset("Snappy")  -- change animation preset
VynxUI:Toggle()                   -- show/hide UI
VynxUI:Unload()                   -- destroy everything
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
SM:SetLibrary(VynxUI); SM:SetFolder("VynxUI/"..game.PlaceId)
SM:BuildConfigSection(Tab)
```

---

## Credits

| Library | Author | Contribution |
|---|---|---|
| [WindUI](https://github.com/article-hub-studio/WindUI-Skibidi) | Footagesus | Core UI, 40+ elements, motion, icons, acrylic, key systems |
| [Obsidian](https://github.com/deividcomsono/Obsidian) | deividcomsono | DependencyBox, global registry, Obsidian API, addons |
| [NeverLose](https://github.com/4lpaca-pin/NeverLose) | 4lpaca-pin | NeverLose API, Watermark, SetAccount, AddSection style |

---

<div align="center">

MIT License · [rxinoussouls](https://github.com/rxinoussouls)

</div>
