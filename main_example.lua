local WindUI =
	loadstring(game:HttpGet("https://article-hub-studio.github.io/WindUI-Skibidi/loader.lua?v=1.6.65-ui-runtime-9"))()

local HasIconSourceAPI = (tonumber(WindUI.IconAdapterVersion) or 0) >= 3
	and type(WindUI.RegisterIconPack) == "function"
	and type(WindUI.AddIconSourceAlias) == "function"
	and type(WindUI.GetIconSources) == "function"

if HasIconSourceAPI then
	WindUI:RegisterIconPack("demo", {
		island = { Alias = "lucide:radio" },
		notification = { Alias = "lucide:bell" },
		corners = { Alias = "lucide:combine" },
		success = { Alias = "lucide:circle-check" },
	})
	WindUI:AddIconSourceAlias("sample", "demo")
end

local function DemoIcon(Name, Fallback)
	return if HasIconSourceAPI then "demo:" .. Name else Fallback
end

local function SourceIcon(Source, Name, Fallback)
	return if HasIconSourceAPI then { Source = Source, Name = Name } else Fallback
end

local IconSources = if HasIconSourceAPI then WindUI:GetIconSources() else { "lucide", "solar" }

WindUI:SetMotionPreset("Liquid")

WindUI:LoadingCreate({
	Title = "WindUI Full Example",
	Desc = "Preparing liquid UI kit",
	Icon = DemoIcon("island", "radio"),
	Width = 350,
	Steps = { "Theme", "Motion", "Elements" },
	ScrimTransparency = 0.28,
	CardTransparency = 0.14,
	Duration = 5,
	AutoStatus = true,
	CompleteStatus = "Ready",
	CloseDelay = 0.18,
})

local Window = WindUI:CreateWindow({
	Title = ".ftgs hub | WindUI Full Example",
	Folder = "WindUIFullExample",
	Icon = DemoIcon("island", "radio"),
	Default = true,
	NewElements = true,
	ElementTransparency = 0.18,
	ElementGap = 1,
	TabHolderType = "sidebar", -- "sidebar" or "top"
	SidebarCompact = true, -- icon-only sidebar; ignored when TabHolderType = "top"
	LinkElementCorners = true,
	CornerLink = {
		InnerRadius = 0,
		Gap = 1,
		BridgeHidden = true,
		BridgeSparse = false,
		BreakTypes = { "Divider", "Space", "Section" },
	},
	LiquidGlass = true,
	ToggleKey = Enum.KeyCode.RightShift,
	KeyBindMenu = {
		DefaultKey = "RightShift",
		QuickKeys = { "RightShift", "F", "LeftControl" },
		Scrim = false,
		BackgroundTransparency = 0.52,
		Compact = true,
		UseWindowBackground = true,
	},
	Watermark = {
		Title = "WindUI",
		Desc = "liquid build",
		Icon = "sparkles",
		Position = "BottomRight",
		Transparency = 0.2,
		Draggable = true,
	},
	Settings = {
		DefaultConfig = "full-example",
		Width = 360,
		Height = 410,
		ScrimTransparency = 0.76,
	},
	Motion = {
		Preset = "Liquid",
		Reduced = false,
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},
	OpenButton = {
		Title = "WindUI",
		Content = "Ready",
		Icon = DemoIcon("island", "radio"),
		State = "Compact",
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.9,
		Position = "TopCenter",
		Height = 44,
		IdleWidth = 78,
		IdleHeight = 28,
		ExpandedHeight = 68,
		ExpandedWidth = 248,
		MaxWidth = 360,
		AutoCollapse = 3,
		AutoHide = 4,
		WakeOnShow = true,
		IconSize = 21,
		BackgroundTransparency = 0.08,
		StrokeTransparency = 0.7,
		Shadow = true,
		ShadowBlur = 18,
		ShadowTransparency = 0.5,
		FallbackShadow = false,
		MorphWindow = true,
		MorphDuration = 0.46,
		Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#E7FF2F")),
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

local function HasDynamicIslandAPI()
	return type(Window.ExpandOpenButton) == "function"
		and type(Window.PushOpenButton) == "function"
		and type(Window.SetOpenButtonState) == "function"
		and type(Window.HideOpenButton) == "function"
		and type(Window.WakeOpenButton) == "function"
end

local function NotifyOutdatedRuntime()
	WindUI:Notify({
		Title = "Runtime cache is updating",
		Content = "Re-run the example to load the latest Dynamic Island API.",
		Icon = "refresh-cw",
		Style = "Notice",
	})
end

local OverviewTab = Window:Tab({
	Title = "Overview",
	Icon = "home",
})

OverviewTab:Callout({
	Title = "WindUI Full Example",
	Desc = "Full example with capsule notifications, Dynamic Island, linked corners and multi-source icons.",
	Variant = "Info",
})

local OverviewStats = OverviewTab:HStack({
	MinChildWidth = 220,
})
OverviewStats:StatusCard({
	Title = "Build",
	Status = "Success",
	Value = "Ready",
})
OverviewStats:StatCard({
	Title = "Elements",
	Value = "Modern",
	SubValue = "Tabs + Discord + Settings",
})

OverviewTab:Path2D({
	Title = "Path 2D",
	Desc = "Animated route drawing with a moving marker.",
	Height = 132,
	PathPadding = 22,
	Duration = 1.15,
	Points = {
		{ 0.08, 0.68 },
		{ 0.26, 0.34 },
		{ 0.48, 0.52 },
		{ 0.68, 0.22 },
		{ 0.9, 0.42 },
	},
	Labels = {
		{ Point = 1, Text = "Start" },
		{ Point = 3, Text = "Sync" },
		{ Point = 5, Text = "Done" },
	},
})

OverviewTab:KeyValue({
	Title = "Runtime",
	Items = {
		{ Title = "Loader", Value = "loadstring" },
		{ Title = "Theme", Value = WindUI:GetCurrentTheme() },
		{ Title = "Topbar", Value = "Mac + Settings Gear" },
		{ Title = "Tab holder", Value = "Compact sidebar / top" },
		{ Title = "Icon sources", Value = tostring(#IconSources) },
	},
})

local FeatureCard = OverviewTab:Card({
	Title = "Card Navigation",
	Desc = "Tap the card itself to open a dedicated page. Nested content remains optional.",
	Icon = "panels-top-left",
	Color = "#0EA5E9",
	OpenTab = true,
	TabTitle = "Card Detail",
	TabIcon = "panels-top-left",
	Build = function(Tab)
		Tab:Callout({
			Title = "Card Page",
			Desc = "This page was opened by pressing the card, like a visual tab.",
			Variant = "Success",
		})
		Tab:Card({
			Title = "Dedicated Card Page",
			Desc = "Use this pattern for premium cards, profile cards or feature dashboards.",
			Icon = "sparkles",
		})
	end,
})

local FeatureCardStats = FeatureCard:HStack({
	MinChildWidth = 150,
})
FeatureCardStats:Badge({
	Title = "Default Preset",
	Variant = "Info",
})
FeatureCardStats:Badge({
	Title = "CardTab",
	Variant = "Success",
})

FeatureCard:CardButton({
	Title = "Notify From Card",
	Icon = DemoIcon("notification", "bell"),
	Callback = function()
		WindUI:Notify({
			Title = "CardButton",
			Content = "Card action callback fired.",
			Icon = DemoIcon("success", "circle-check"),
			Style = "Success",
		})
	end,
})

local SystemTab = Window:Tab({
	Title = "System UI",
	Icon = DemoIcon("notification", "bell"),
})

SystemTab:Callout({
	Title = "Notification + Dynamic Island",
	Desc = "Preview native UI shadows, individual corners and Dynamic Island states.",
	Variant = "Info",
	Icon = DemoIcon("island", "radio"),
})

SystemTab:ActionList({
	Title = "Notification Gallery",
	Desc = "Compact native-shadow toasts, metadata cards and Liquid Glass use the same Notify API.",
	Actions = {
		{
			Title = "Compact Toast",
			Desc = "Small toast with native shadow and a short timer.",
			Value = "Compact",
			Icon = SourceIcon("solar", "bell-bold", "bell"),
		},
		{
			Title = "Decorated Success",
			Desc = "Compact layout with a colored wash and accent line.",
			Value = "Decorated",
			Icon = "lucide:circle-check",
		},
		{
			Title = "Avatar Card",
			Desc = "Larger profile image with timestamp metadata.",
			Value = "Card",
			Icon = "geist:user",
		},
		{
			Title = "Persistent Glass",
			Desc = "Glass appearance with action buttons and no timeout.",
			Value = "Glass",
			Icon = "gravity:triangle-exclamation",
		},
		{
			Title = "Windows Card",
			Desc = "Desktop-style app header, selector and actions.",
			Value = "Window",
			Icon = "lucide:app-window",
		},
		{
			Title = "Original WindUI",
			Desc = "Classic WindUI notification layout and surface.",
			Value = "Originally",
			Icon = "lucide:history",
		},
	},
	Callback = function(Action)
		if Action.Value == "Window" then
			WindUI:Notify({
				Type = "Window",
				AppName = "WindUI",
				AppIcon = "lucide:app-window",
				Title = "Feature Launch Party",
				Content = "Studio S / Ballroom\n4:00 PM, 10/31/2026",
				Timestamp = os.date("%H:%M"),
				Selection = {
					Value = "Going",
					Values = { "Going", "Maybe", "Not going" },
				},
				Buttons = {
					{ Title = "RSVP", Close = false },
					{ Title = "Dismiss" },
				},
				Duration = false,
			})
		elseif Action.Value == "Originally" then
			WindUI:Notify({
				Type = "Originally",
				Title = "Original WindUI",
				Content = "Classic notification presentation with the original compact width.",
				Icon = "lucide:bell",
				Duration = 5,
			})
		elseif Action.Value == "Card" then
			WindUI:Notify({
				Title = "Anonim",
				Content = "Metadata notification with an avatar and timestamp.",
				Appearance = "Card",
				Avatar = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150",
				Timestamp = os.date("%H:%M"),
				Style = "Neutral",
				DarkOverlay = false,
				Duration = 5,
			})
		elseif Action.Value == "Decorated" then
			WindUI:Notify({
				Title = "Saved successfully",
				Content = "Native shadow, individual corners and a quiet accent rail.",
				Appearance = "Compact",
				Icon = DemoIcon("success", "circle-check"),
				Style = "Success",
				Decorated = true,
				Corners = {
					TopLeft = 18,
					TopRight = 18,
					BottomRight = 18,
					BottomLeft = 10,
				},
			})
		elseif Action.Value == "Glass" then
			WindUI:Notify({
				Title = "Persistent notification",
				Content = "Choose an action or close this notification manually.",
				Appearance = "Glass",
				LiquidGlass = true,
				DarkOverlay = false,
				GlassTransparency = 0.78,
				Icon = "solar:bell-bold",
				Style = "Warning",
				Duration = false,
				Buttons = {
					{
						Title = "Expand Island",
						Callback = function()
							if not HasDynamicIslandAPI() then
								NotifyOutdatedRuntime()
								return
							end
							Window:ExpandOpenButton({
								Title = "WindUI alert",
								Content = "Opened from a notification action",
								Icon = DemoIcon("notification", "bell"),
							}, 3)
						end,
					},
					{ Title = "Dismiss" },
				},
			})
		else
			WindUI:Notify({
				Type = "Normal",
				Title = "Notification example",
				Content = "Compact toast using a table-based Solar icon reference.",
				Appearance = "Compact",
				Icon = SourceIcon("solar", "bell-bold", "bell"),
				Style = "Info",
			})
		end
	end,
})

SystemTab:ActionList({
	Title = "Dynamic Island Open Button",
	Desc = "Preview a state by closing the window. Tap the island to reopen WindUI.",
	Actions = {
		{
			Title = "Push Update",
			Desc = "Expand temporarily, then restore the previous state.",
			Value = "Push",
			Icon = DemoIcon("island", "radio"),
		},
		{
			Title = "Expanded",
			Desc = "Show title and secondary content.",
			Value = "Expanded",
			Icon = "lucide:panel-top-open",
		},
		{
			Title = "Compact",
			Desc = "Show icon and title as a small pill.",
			Value = "Compact",
			Icon = "geist:minus",
		},
		{
			Title = "Idle (Auto Hidden)",
			Desc = "Shrink to the tappable iPhone-style idle pill.",
			Value = "Idle",
			Icon = "geist:minus",
		},
		{
			Title = "Collapsed",
			Desc = "Use an icon-only circular state.",
			Value = "Collapsed",
			Icon = "gravity:circle",
		},
	},
	Callback = function(Action)
		if not HasDynamicIslandAPI() then
			NotifyOutdatedRuntime()
			return
		end

		local Changes = {
			Title = "WindUI " .. Action.Value,
			Content = (Action.Value == "Collapsed" or Action.Value == "Idle") and false
				or "Dynamic Island method preview",
			Icon = DemoIcon("island", "radio"),
		}

		if Action.Value == "Push" then
			Window:PushOpenButton(Changes, 3)
		else
			Window:SetOpenButtonState(Action.Value, Changes)
		end

		task.defer(function()
			Window:Close()
		end)
	end,
})

SystemTab:KeyValue({
	Title = "Icon Resolver",
	Items = {
		{ Title = "Custom pack", Value = "demo:*" },
		{ Title = "Alias", Value = "sample:*" },
		{ Title = "Bundled", Value = "lucide / solar / geist / gravity" },
		{ Title = "Structured", Value = '{ Source = "solar", Name = "bell-bold" }' },
	},
})

local SettingsTab = Window:Tab({
	Title = "Settings",
	Icon = "settings",
})

SettingsTab:Button({
	Title = "Open Settings Panel",
	Icon = "settings",
	Keybind = "G",
	Callback = function()
		if Window.SettingsMenu then
			Window.SettingsMenu:Toggle()
		end
	end,
})

SettingsTab:Toggle({
	Title = "Mobile Boost",
	Desc = "Shown inside the mobile keybind menu.",
	Value = true,
	Keybind = "T",
})

SettingsTab:SegmentedControl({
	Title = "Demo Mode",
	Options = { "Clean", "Dense", "Glass" },
	Value = "Glass",
})

SettingsTab:Slider({
	Title = "Background Overlay",
	Value = {
		Min = 0.25,
		Max = 0.75,
		Default = 0.47,
		Increment = 0.01,
	},
	Callback = function(Value)
		Window:SetBackgroundOverlayTransparency(Value)
	end,
})

SettingsTab:ChipList({
	Title = "Theme Tags",
	Options = { "Glass", "Mobile", "Motion" },
	Value = { "Glass", "Mobile" },
})

SettingsTab:Button({
	Title = "Apply Webm Background API",
	Desc = "Demonstrates SetBackground with media resolver.",
	Icon = "image",
	Callback = function()
		Window:SetBackground({
			Image = "rbxassetid://120997033468887",
			Transparency = 0.42,
			ScaleType = Enum.ScaleType.Crop,
		})
	end,
})

SettingsTab:Dropdown({
	Title = "Full Width Dropdown",
	Desc = "Auto chooses up or down and matches the trigger width.",
	Values = { "Auto", "Down", "Up" },
	Value = "Auto",
	Search = true,
	FullWidth = true,
	Direction = "Auto",
	Side = "Left",
})

SettingsTab:Dropdown({
	Title = "Centered Dropdown",
	Desc = "Opens as a compact centered menu inside this window.",
	Values = { "Workspace", "Interface", "Notifications", "Dynamic Island", "Loading" },
	Value = "Interface",
	Search = true,
	Centered = true,
	CenterTarget = "Window",
	Backdrop = true,
	BackdropTransparency = 0.84,
	MenuWidth = 236,
	MenuMaxHeight = 240,
})

local DropdownRow = SettingsTab:HStack({
	MinChildWidth = 180,
})
DropdownRow:Dropdown({
	Title = "Open Left",
	Values = { "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Omega" },
	Value = "Alpha",
	Search = true,
	Direction = "Left",
	MenuWidth = 164,
})
DropdownRow:Dropdown({
	Title = "Open Right",
	Values = { "North", "East", "South", "West", "Center", "Upper", "Lower" },
	Value = "East",
	Search = true,
	Direction = "Right",
	MenuWidth = 164,
})

SettingsTab:Slider({
	Title = "Element Transparency",
	Value = {
		Min = 0,
		Max = 0.65,
		Default = 0.18,
		Increment = 0.01,
	},
	Callback = function(Value)
		Window:SetElementTransparency(Value)
	end,
})

local PremiumTab = Window:Tab({
	Title = "Premium",
	Icon = "crown",
	Golden = true,
	Desc = "Golden tab and button effects",
})

PremiumTab:Callout({
	Title = "Golden Components",
	Desc = "Use Golden = true or Premium = true on tabs and buttons.",
	Variant = "Info",
	Icon = "sparkles",
})

PremiumTab:Button({
	Title = "Golden Action",
	Desc = "Premium button with sheen and sparkle animation.",
	Icon = "sparkles",
	Golden = true,
	Callback = function()
		WindUI:Notify({
			Title = "Premium",
			Content = "Golden button callback fired.",
			Icon = "crown",
			Style = "Notice",
		})
	end,
})

local PremiumRow = PremiumTab:HStack({
	MinChildWidth = 150,
})
PremiumRow:Button({
	Title = "Reward",
	Icon = "gem",
	Premium = true,
})
PremiumRow:Button({
	Title = "Boost",
	Icon = "zap",
	Golden = true,
})

PremiumTab:KeyValue({
	Title = "Premium API",
	Items = {
		{ Title = "Tab", Value = "Golden = true" },
		{ Title = "Button", Value = "Premium = true" },
		{ Title = "Motion", Value = "Sheen + sparkle" },
	},
})

local LinkedTab = Window:Tab({
	Title = "Linked Corners",
	Icon = DemoIcon("corners", "combine"),
	LinkCorners = true,
	CornerLink = {
		InnerRadius = 0,
		Gap = 1,
		BridgeHidden = true,
		BridgeSparse = false,
	},
})

LinkedTab:Callout({
	Title = "Linked Element Stack",
	Desc = "This tab uses LinkCorners = true, so nearby elements share only the outside corners.",
	Variant = "Info",
})

LinkedTab:Button({
	Title = "Top Action",
	Icon = "mouse-pointer-click",
	CornerGroup = "primary",
	Callback = function()
		WindUI:Notify({
			Title = "Linked corners",
			Content = "The group keeps flat shared seams and rounded outside edges.",
			Icon = DemoIcon("corners", "combine"),
			Style = "Info",
		})
	end,
})

LinkedTab:Toggle({
	Title = "Middle Toggle",
	Desc = "Middle element stays square while linked.",
	Value = true,
	CornerGroup = "primary",
})

LinkedTab:Card({
	Title = "Linked Card Page",
	Desc = "This card sits inside the linked stack and opens its own page.",
	Icon = "panels-top-left",
	CornerGroup = "primary",
	CornerBreakAfter = true,
	OpenTab = true,
	TabTitle = "Linked Card",
	Build = function(Tab)
		Tab:Callout({
			Title = "Linked Card Page",
			Desc = "Card corners follow the linked stack, while this page behaves like a normal tab.",
			Variant = "Info",
		})
	end,
})

LinkedTab:Slider({
	Title = "Bottom Slider",
	CornerGroup = "range",
	Value = {
		Min = 0,
		Max = 100,
		Default = 64,
		Increment = 1,
	},
})

LinkedTab:Space()

local LinkedRow = LinkedTab:HStack({
	LinkCorners = true,
	CornerLink = { InnerRadius = 0, Gap = 1, Orientation = "Horizontal" },
	MinChildWidth = 72,
})
LinkedRow:Button({
	Title = "Left",
	Icon = "arrow-left",
})
LinkedRow:Button({
	Title = "Center",
	Icon = "minus",
})
LinkedRow:Button({
	Title = "Right",
	Icon = "arrow-right",
})

LinkedTab:Space()

local LinkedStack = LinkedTab:VStack({
	LinkCorners = true,
	CornerLink = { InnerRadius = 0, Gap = 1 },
})
LinkedStack:Button({
	Title = "Stack Save",
	Icon = "save",
})
LinkedStack:Button({
	Title = "Stack Load",
	Icon = "download",
})

LinkedTab:Space()

LinkedTab:KeyValue({
	Title = "Corner Mode",
	Items = {
		{ Title = "Surface", Value = "Native UICorner radii" },
		{ Title = "Tab", Value = "LinkCorners + CornerLink" },
		{ Title = "Inner radius", Value = "0px (flat seams)" },
		{ Title = "Groups", Value = "primary / range" },
		{ Title = "Gap", Value = "1px" },
		{ Title = "Nested row", Value = "Left / Center / Right" },
	},
})

local DiscordTab = Window:Tab({
	Title = "Discord",
	Icon = "message-circle",
})

local InviteCard = DiscordTab:DiscordCard({
	Title = "WindUI Community",
	Desc = "Copy the invite or run a custom callback from one card.",
	Invite = "ftgs-development-hub-1300692552005189632",
	Members = "10k+",
	Online = "Live",
	Callback = function(Url)
		WindUI:Notify({
			Title = "Discord callback",
			Content = Url,
			Icon = "external-link",
			Style = "Notice",
		})
	end,
})

local DiscordActions = DiscordTab:HStack()
DiscordActions:Button({
	Title = "Copy",
	Icon = "copy",
	Callback = function()
		InviteCard:Copy()
	end,
})
DiscordActions:Button({
	Title = "Highlight",
	Icon = "scan",
	Callback = function()
		InviteCard:Highlight()
	end,
})

DiscordTab:Timeline({
	Title = "Invite Flow",
	Items = {
		{ Title = "URL normalized", Value = InviteCard:GetUrl() },
		{ Title = "Copy fallback", Value = "Notify" },
		{ Title = "Join callback", Value = "Enabled" },
	},
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
	Flag = "motion-tabbox",
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
Controls:Stepper({
	Title = "Amount",
	Desc = "Hybrid step control",
	Flag = "control-amount",
	Width = 210,
	Value = {
		Min = 1,
		Max = 10,
		Default = 4,
		Increment = 1,
	},
})
Controls:Toggle({
	Title = "Pulse",
	Desc = "Single-row toggle without HStack spacing.",
	Value = true,
})
Controls:MeterGroup({
	Title = "Motion Budget",
	Desc = "Grouped meters stay full-width on mobile.",
	Meters = {
		{ Title = "Input", Value = 64, Color = "#0091FF" },
		{ Title = "Tween", Value = 82, Color = "#22C55E" },
		{ Title = "Layout", Value = 46, Color = "#F59E0B" },
	},
})
Controls:ChipList({
	Title = "Filters",
	Options = { "Motion", "Mobile", "Glass" },
	Value = { "Motion", "Glass" },
})
Controls:ActionList({
	Title = "Quick Actions",
	Actions = {
		{ Title = "Replay path", Icon = "rotate-ccw", Value = "Run" },
		{ Title = "Compact mode", Icon = "panel-top", Value = "Mobile" },
	},
	Callback = function(Action)
		WindUI:Notify({
			Title = "Action",
			Content = Action.Title,
			Icon = Action.Icon or "sparkles",
			Style = "Neutral",
		})
	end,
})
Controls:Path2D({
	Title = "Control Path",
	Desc = "Replayable 2D path animation.",
	Height = 118,
	PathPadding = 22,
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
		{ Title = "Press", Desc = "Buttons and cards keep compact touch feedback." },
	},
})

task.delay(0.7, function()
	WindUI:Notify({
		Title = "WindUI ready",
		Content = "Open System UI to preview the upgraded components.",
		Appearance = "Compact",
		Icon = DemoIcon("success", "circle-check"),
		Style = "Success",
		Duration = 4,
	})
end)
