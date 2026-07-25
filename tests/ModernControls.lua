local WindUI = require("../src/Init")

assert(WindUI:SetMotionPreset("Subtle").Preset == "Subtle")
assert(WindUI:SetReducedMotion(false).Reduced == false)

local Window = WindUI:CreateWindow({
	Title = "Modern Controls Test",
	NewElements = true,
	Motion = {
		Preset = "Subtle",
		Reduced = false,
	},
})

local Tab = Window:Tab({
	Title = "Modern Controls",
})

local Radio = Tab:RadioGroup({
	Title = "Radio group",
	Options = { "Low", "Medium", "High" },
	Value = "Medium",
	Animation = false,
})

assert(Radio:Get() == "Medium")
Radio:Select("High", false)
assert(Radio:Get() == "High")

local Checks = Tab:CheckboxGroup({
	Title = "Checkbox group",
	Options = { "ESP", "Aimbot", "Fly" },
	Value = { "ESP" },
})

assert(#Checks:Get() == 1)
Checks:Toggle("Fly", false)
assert(#Checks:Get() == 2)

local Segmented = Tab:SegmentedControl({
	Title = "Segmented control",
	Options = { "Legit", "Rage", "Visual" },
	Value = "Legit",
})

assert(Segmented:Get() == "Legit")
Segmented:Select("Visual", false)
assert(Segmented:Get() == "Visual")

local TextArea = Tab:TextArea({
	Title = "Text area",
	Value = "hello",
})

assert(TextArea:Get() == "hello")
TextArea:Set("world", false)
assert(TextArea:Get() == "world")

local Stepper = Tab:Stepper({
	Title = "Stepper",
	Value = {
		Min = 1,
		Max = 5,
		Default = 3,
		Increment = 1,
	},
})

assert(Stepper:Get() == 3)
Stepper:Set(10, false)
assert(Stepper:Get() == 5)

Tab:Callout({
	Title = "Callout",
	Desc = "Static visual message",
	Variant = "Success",
})

local Badge = Tab:Badge({
	Title = "Badge",
	Value = "Ready",
	Variant = "Success",
})
Badge:SetValue("Live")
Badge:SetVariant("Info")

local Status = Tab:StatusCard({
	Title = "Status",
	Status = "Info",
	Value = "Booting",
})
Status:SetStatus("Success", "Online")
assert(Status.Status == "Success")

local Stat = Tab:StatCard({
	Title = "Stat",
	Value = "42",
	SubValue = "items",
})
Stat:SetValue("43", "items loaded")
Stat:SetTrend("Neutral")
assert(Stat.Value == "43")

local Details = Tab:KeyValue({
	Title = "Details",
	Items = {
		{ Title = "One", Value = "A" },
	},
})
Details:SetItems({
	{ Title = "Two", Value = "B" },
})

local Chips = Tab:ChipList({
	Title = "Chips",
	Options = { "A", "B", "C" },
	Value = { "A" },
})
assert(#Chips:Get() == 1)
Chips:Toggle("B", false)
assert(#Chips:Get() == 2)

local Timeline = Tab:Timeline({
	Title = "Timeline",
	Items = {
		{ Title = "Start", Value = "Success" },
	},
})
Timeline:SetItems({
	{ Title = "Start", Value = "Success" },
	{ Title = "Done", Value = "Info" },
})

local Accordion = Tab:Accordion({
	Title = "Accordion",
	OpenIndex = 1,
	Items = {
		{ Title = "One", Desc = "A" },
		{ Title = "Two", Desc = "B" },
	},
})
Accordion:Open(2)
Accordion:Close(2)

local EmptyState = Tab:EmptyState({
	Title = "Empty",
	Desc = "No data",
})
EmptyState:SetTitle("Still empty")
EmptyState:SetDesc("Waiting")
EmptyState:Highlight()

local Discord = Tab:DiscordCard({
	Title = "Discord",
	Desc = "Invite card",
	Invite = "example",
	Members = 120,
	Online = 24,
})
assert(Discord:SetInvite("new-code") == "https://discord.gg/new-code")
Discord:SetTitle("Community")
Discord:SetDesc("Updated invite card")

local Path = Tab:Path2D({
	Title = "Path",
	Points = {
		{ 0.1, 0.8 },
		{ 0.35, 0.35 },
		{ 0.75, 0.55 },
	},
	AutoPlay = false,
})
Path:Play()
Path:Stop()
assert(#Path:SetPoints({ { 0.1, 0.2 }, { 0.9, 0.8 } }) == 2)

local Section = Tab:Section({
	Title = "Box",
	Box = true,
	Opened = true,
})

local Box = Section:TabBox({
	Title = "Nested tabs",
})
local Page = Box:Tab({
	Title = "Main",
	Icon = "sparkles",
})
Page:Badge({
	Title = "Nested badge",
	Value = "OK",
})
Box:Select(1)
assert(Box:GetSelected() == Page)

Window:SetBackgroundColor("#0B0F14")
Window:SetBackgroundGradient(WindUI:Gradient({
	["0"] = { Color = "#0B0F14", Transparency = 0.1 },
	["100"] = { Color = "#17243A", Transparency = 0.6 },
}), 0.5)
Window:SetBackgroundImageTransparency(0.35)
