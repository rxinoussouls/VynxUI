local WindUI = loadstring(game:HttpGet("https://article-hub-studio.github.io/WindUI-Skibidi/loader.lua"))()

WindUI:SetMotionPreset("Liquid")

local Window = WindUI:CreateWindow({
	Title = "WindUI Advanced Motion",
	Folder = "WindUIAdvancedMotion",
	Icon = "sparkles",
	NewElements = true,
	Motion = {
		Preset = "Liquid",
		Reduced = false,
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},
	BackgroundColor = Color3.fromHex("#08111A"),
	BackgroundGradient = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#08111A"), Transparency = 0.06 },
		["45"] = { Color = Color3.fromHex("#12352F"), Transparency = 0.3 },
		["100"] = { Color = Color3.fromHex("#24172D"), Transparency = 0.54 },
	}, {
		Rotation = 118,
	}),
	BackgroundOverlayTransparency = 0.47,
})

local MotionTab = Window:Tab({
	Title = "Motion",
	Icon = "sparkles",
})

local SectionBox = MotionTab:Section({
	Title = "Section Box Tabs",
	Desc = "TabBox keeps page height synced after nested elements mount.",
	Icon = "folder-kanban",
	Box = true,
	BoxBorder = true,
	Opened = true,
})

local BoxTabs = SectionBox:TabBox({
	Title = "Animated Pages",
	Desc = "Nested controls with page switch animation",
})

local Overview = BoxTabs:Tab({
	Title = "Overview",
	Icon = "badge-check",
})
Overview:StatusCard({
	Title = "Renderer",
	Status = "Success",
	Value = "Ready",
})
Overview:ProgressBar({
	Title = "Load",
	Value = 72,
})

local Controls = BoxTabs:Tab({
	Title = "Controls",
	Icon = "sliders-horizontal",
})
local ControlRow = Controls:HStack()
ControlRow:Stepper({
	Title = "Amount",
	Value = {
		Min = 1,
		Max = 10,
		Default = 4,
		Increment = 1,
	},
})
ControlRow:Toggle({
	Title = "Pulse",
	Value = true,
})
Controls:ChipList({
	Title = "Filters",
	Options = { "Motion", "Mobile", "Glass" },
	Value = { "Motion", "Glass" },
})
Controls:Path2D({
	Title = "Control Path",
	Desc = "2D line draw and marker travel.",
	Height = 118,
	Duration = 0.95,
	Points = {
		{ 0.1, 0.5 },
		{ 0.32, 0.22 },
		{ 0.58, 0.68 },
		{ 0.86, 0.34 },
	},
	Labels = {
		{ Point = 1, Text = "A" },
		{ Point = 4, Text = "B" },
	},
})

local Logs = BoxTabs:Tab({
	Title = "Logs",
	Icon = "history",
})
Logs:Timeline({
	Title = "Events",
	Items = {
		{ Title = "Window opened", Value = "Done" },
		{ Title = "TabBox measured", Value = "Done" },
		{ Title = "Animations active", Value = "Live" },
	},
})

MotionTab:Accordion({
	Title = "Motion Notes",
	OpenIndex = 1,
	Items = {
		{ Title = "Switch", Desc = "TabBox fades pages and updates height after layout changes." },
		{ Title = "Press", Desc = "Buttons and chips keep compact touch feedback." },
	},
})
