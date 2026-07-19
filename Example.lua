-- VYNX UI — Example
-- https://github.com/rxinoussouls/VynxUI

local VynxUI = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()

-- ── Theme ────────────────────────────────────────────────────────────────────
VynxUI:SetTheme("Vynx")
VynxUI:SetMotionPreset("Liquid")
VynxUI:SetDPIScale(1)

-- ── Window ───────────────────────────────────────────────────────────────────
local Window = VynxUI:CreateWindow({
	Title      = "VYNX Hub",
	Author     = "rxinoussouls",
	Icon       = "star",
	Size       = UDim2.fromOffset(600, 440),
	ToggleKey  = Enum.KeyCode.RightControl,
	LiquidGlass= true,
	Footer     = { Text = "v1.0 • VYNX UI" },
})

-- ── Tab 1: WindUI Style ──────────────────────────────────────────────────────
local Tab1 = Window:CreateTab({ Title = "WindUI Style", Icon = "layout-panel-top" })

local S1 = Tab1:Section({ Title = "Controls" })

S1:Toggle({
	Title    = "Auto Farm",
	Default  = false,
	Flag     = "autoFarm",
	Callback = function(v) print("Auto Farm:", v) end,
})

S1:Slider({
	Title    = "Farm Speed",
	Min      = 1,
	Max      = 100,
	Default  = 50,
	Suffix   = "x",
	Flag     = "farmSpeed",
	Callback = function(v) print("Speed:", v) end,
})

S1:Dropdown({
	Title    = "Farm Mode",
	Values   = { "Normal", "Fast", "Turbo" },
	Default  = "Normal",
	Flag     = "farmMode",
	Callback = function(v) print("Mode:", v) end,
})

S1:Input({
	Title       = "Custom Text",
	Placeholder = "พิมพ์ที่นี่...",
	Flag        = "customText",
	Callback    = function(v) print("Text:", v) end,
})

S1:Keybind({
	Title    = "Hotkey",
	Default  = Enum.KeyCode.F,
	Flag     = "hotkey",
	Callback = function(v) print("Keybind:", v) end,
})

S1:Colorpicker({
	Title    = "Trail Color",
	Default  = Color3.fromHex("#7C5CFF"),
	Flag     = "trailColor",
	Callback = function(v) print("Color:", v) end,
})

-- ── Tab 2: Obsidian Style ────────────────────────────────────────────────────
local Tab2 = Window:CreateTab({ Title = "Obsidian Style", Icon = "layers" })

local Left = Tab2:AddLeftGroupbox("Combat")

Left:AddToggle("autoAttack", {
	Text     = "Auto Attack",
	Default  = false,
	Callback = function(v) print("Auto Attack:", v) end,
})

Left:AddSlider("attackSpeed", {
	Text     = "Attack Speed",
	Min      = 1,
	Max      = 10,
	Default  = 3,
	Suffix   = "x",
	Callback = function(v) print("Attack Speed:", v) end,
})

Left:AddDropdown("target", {
	Text     = "Target",
	Values   = { "Nearest", "Furthest", "Random" },
	Default  = "Nearest",
	Callback = function(v) print("Target:", v) end,
})

Left:AddDivider()

Left:AddButton("resetStats", {
	Text     = "Reset Stats",
	Callback = function() print("Reset!") end,
})

local Right = Tab2:AddRightGroupbox("Visuals")

Right:AddCheckbox("showEsp", {
	Text     = "Show ESP",
	Default  = false,
	Callback = function(v) print("ESP:", v) end,
})

Right:AddColorPicker("espColor", {
	Text     = "ESP Color",
	Default  = Color3.fromHex("#FF5555"),
	Callback = function(v) print("ESP Color:", v) end,
})

Right:AddLabel("statusLabel", { Text = "Status: Ready" })

-- ── Tab 3: DependencyBox ─────────────────────────────────────────────────────
local Tab3   = Window:CreateTab({ Title = "DependencyBox", Icon = "git-branch" })
local DGroup = Tab3:AddGroupbox("Advanced Farm")

DGroup:AddToggle("enableAdvanced", {
	Text    = "Enable Advanced",
	Default = false,
})

local DepBox = DGroup:AddDependencyBox()

DepBox:AddToggle("autoCollect", {
	Text     = "Auto Collect",
	Default  = false,
	Callback = function(v) print("Auto Collect:", v) end,
})

DepBox:AddSlider("collectRange", {
	Text     = "Collect Range",
	Min      = 10,
	Max      = 200,
	Default  = 50,
	Suffix   = " studs",
})

DepBox:SetupDependencies({
	{ VynxUI.Toggles["enableAdvanced"], true }
})

-- ── Notification ─────────────────────────────────────────────────────────────
task.wait(1)
VynxUI:Notify({
	Title   = "VYNX Hub",
	Content = "โหลดสำเร็จ! กด RCtrl เพื่อเปิด/ปิด",
	Style   = "Success",
	Duration= 5,
	Icon    = "circle-check",
})

-- ── Cleanup ──────────────────────────────────────────────────────────────────
VynxUI:OnUnload(function()
	print("VYNX UI unloaded")
end)
