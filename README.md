# VYNX UI Library

> ยำรวม **WindUI** + **Obsidian** → VYNX UI  
> Dual API · 41 Elements · 7 Themes · DependencyBox · Full Obsidian Compat

---

## Quick Start

```lua
local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()
```

## API — WindUI Style

```lua
local Window  = VynxUI:CreateWindow({ Title = "My Hub", ToggleKey = Enum.KeyCode.RightControl })
local Tab     = Window:CreateTab({ Title = "Main", Icon = "star" })
local Section = Tab:Section({ Title = "Controls" })

Section:Toggle({ Title = "Auto Farm", Default = false, Flag = "af", Callback = function(v) end })
Section:Slider({ Title = "Speed", Min = 1, Max = 100, Default = 50, Flag = "spd" })
Section:Dropdown({ Title = "Mode", Values = {"A","B"}, Default = "A", Flag = "mode" })
Section:Input({ Title = "Text", Placeholder = "...", Flag = "txt" })
Section:Keybind({ Title = "Hotkey", Default = Enum.KeyCode.F, Flag = "hk" })
Section:Colorpicker({ Title = "Color", Default = Color3.new(1,0,0), Flag = "col" })
```

## API — Obsidian Style

```lua
local Tab   = Window:CreateTab({ Title = "Main" })
local Left  = Tab:AddLeftGroupbox("Controls")
local Right = Tab:AddRightGroupbox("Visuals")

Left:AddToggle("myToggle", { Text = "Enable", Default = false, Callback = function(v) end })
Left:AddSlider("mySlider", { Text = "Speed", Min = 1, Max = 100, Default = 50 })
Left:AddDropdown("myDrop", { Text = "Mode", Values = {"A","B"}, Default = "A" })
Left:AddInput("myInput", { Text = "Name", PlaceholderText = "..." })
Left:AddCheckbox("myCheck", { Text = "Option", Default = false })
Left:AddKeyPicker("myKey", { Text = "Hotkey", Default = Enum.KeyCode.F })
Left:AddColorPicker("myColor", { Text = "Color", Default = Color3.new(1,0,0) })
Left:AddButton("myBtn", { Text = "Click Me", Callback = function() end })
Left:AddDivider()
Left:AddLabel("myLabel", { Text = "Status: Ready" })
```

## DependencyBox

```lua
local Group = Tab:AddGroupbox("Advanced")
Group:AddToggle("enableAdv", { Text = "Enable Advanced", Default = false })

local Dep = Group:AddDependencyBox()
Dep:AddToggle("subOption", { Text = "Sub Option", Default = false })
Dep:AddSlider("subSlider", { Text = "Sub Speed", Min = 1, Max = 50, Default = 10 })
Dep:SetupDependencies({ { VynxUI.Toggles["enableAdv"], true } })
```

## Global Registry

```lua
-- Access any element globally (Obsidian pattern)
VynxUI.Toggles["myToggle"].Value         -- bool
VynxUI.Options["mySlider"].Value         -- number
VynxUI.Toggles["myToggle"]:SetValue(true)
VynxUI.Options["myDrop"]:SetValue("B")
```

## Themes

```lua
VynxUI:SetTheme("Dark")      -- Dark, Light, Vynx, Midnight, Rose, Serenity, Fatality
VynxUI:SetMotionPreset("Liquid")  -- Subtle, Liquid, Snappy, None
VynxUI:SetDPIScale(1.2)
VynxUI:SetFont(Enum.Font.GothamSsm)
```

## Notifications

```lua
VynxUI:Notify({
    Title   = "Hello",
    Content = "สำเร็จ!",
    Style   = "Success",   -- Info, Success, Warning, Error, Notice
    Duration= 5,
    Icon    = "circle-check",
    Side    = "Right",     -- Left / Right
})
```

## Draggable Overlays

```lua
local label = VynxUI:AddDraggableLabel("VYNX Hub • v1.0", UDim2.fromOffset(8, 8))
local btn   = VynxUI:AddDraggableButton("Toggle ESP", function(v) end)
local menu  = VynxUI:AddDraggableMenu("Keybinds")
menu:AddItem("Auto Farm → F", function() end)
```

## Addons

```lua
local ThemeManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/addons/ThemeManager.lua"
))()
ThemeManager:SetLibrary(VynxUI)
ThemeManager:SetFolder("VynxUI")
ThemeManager:ApplyTheme("Default")
```

```lua
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/addons/SaveManager.lua"
))()
SaveManager:SetLibrary(VynxUI)
SaveManager:SetFolder("VynxUI/" .. game.PlaceId)
```

## Cleanup

```lua
VynxUI:OnUnload(function() print("unloaded") end)
VynxUI:GiveSignal(someConnection)  -- auto-disconnect on unload
VynxUI:Unload()
```

---

## Elements (41 total)

| Category | Elements |
|---|---|
| Input | Toggle, Slider, Input, Dropdown, Keybind, Colorpicker, Checkbox, RadioGroup, CheckboxGroup, SegmentedControl, TextArea, Stepper |
| Display | Paragraph, Badge, Callout, StatusCard, StatCard, KeyValue, DiscordCard, EmptyState |
| Layout | Divider, Space, Card, Group, HStack, VStack, Section, TabBox, Accordion |
| Media | Image, Viewport, Video, Path2D |
| Action | Button, ActionList, ChipList |
| Data | ProgressBar, MeterGroup, Timeline, Code |
| Obsidian | UIPassthrough, DependencyBox, DependencyGroupbox |

---

*MIT License — WindUI (article-hub-studio) + Obsidian (deividcomsono)*
