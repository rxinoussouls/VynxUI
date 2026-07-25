local WindUI = loadstring(game:HttpGet("https://article-hub-studio.github.io/WindUI-Skibidi/loader.lua"))()

WindUI:SetMotionPreset("Liquid")

local Window = WindUI:CreateWindow({
	Title = "WindUI Settings Example",
	Folder = "WindUISettingsExample",
	Icon = "settings",
	NewElements = true,
	Settings = {
		DefaultConfig = "mobile-settings",
		Width = 352,
		Height = 424,
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},
	BackgroundColor = Color3.fromHex("#0A0F16"),
	BackgroundGradient = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#0A0F16"), Transparency = 0.08 },
		["58"] = { Color = Color3.fromHex("#14313A"), Transparency = 0.34 },
		["100"] = { Color = Color3.fromHex("#211631"), Transparency = 0.5 },
	}, {
		Rotation = 42,
	}),
	BackgroundOverlayTransparency = 0.46,
})

local SettingsTab = Window:Tab({
	Title = "Settings",
	Icon = "settings",
})

SettingsTab:Callout({
	Title = "Topbar Settings",
	Desc = "Tap the gear icon to open the glass tab settings panel.",
	Variant = "Info",
})

SettingsTab:Button({
	Title = "Open Settings Panel",
	Icon = "settings",
	Callback = function()
		if Window.SettingsMenu then
			Window.SettingsMenu:Toggle()
		end
	end,
})

local ThemeStack = SettingsTab:VStack()
ThemeStack:SegmentedControl({
	Title = "Demo Mode",
	Options = { "Clean", "Dense", "Glass" },
	Value = "Glass",
})
ThemeStack:Slider({
	Title = "Background Overlay",
	Value = {
		Min = 0.25,
		Max = 0.75,
		Default = 0.46,
		Increment = 0.01,
	},
	Callback = function(Value)
		Window:SetBackgroundOverlayTransparency(Value)
	end,
})

SettingsTab:KeyValue({
	Title = "Settings State",
	Items = {
		{ Title = "Config", Value = "mobile-settings" },
		{ Title = "Theme", Value = WindUI:GetCurrentTheme() },
		{ Title = "Topbar", Value = "Mac + gear" },
	},
})
