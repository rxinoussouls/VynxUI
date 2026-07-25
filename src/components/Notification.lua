local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")

local New = Creator.New
local Tween = Creator.Tween

local HOLDER_SIDE_MARGIN = 14
local HOLDER_TOP = 58
local HOLDER_BOTTOM = 72
local HOLDER_MAX_WIDTH = 420
local HOLDER_MIN_WIDTH = 240
local CARD_RADIUS = 18
local CARD_PADDING = 10
local CARD_GAP = 8
local ICON_SIZE = 30
local AVATAR_SIZE = 40
local CLOSE_SIZE = 44
local CLOSE_SURFACE_SIZE = 24
local CLOSE_RESERVED = 30
local ACTION_HEIGHT = 36
local MAX_ACTIONS = 2
local MAX_TITLE_HEIGHT = 38
local MAX_CONTENT_HEIGHT = 48
local PROGRESS_HEIGHT = 2
local MAX_VISIBLE = 4
local ENTER_OFFSET = 18
local EXIT_OFFSET = 14
local SHADOW_OFFSET = 4
local NORMAL_WIDTH = 356
local ORIGINAL_WIDTH = 300
local WINDOW_WIDTH = 404

local NOTIFICATION_STYLES = {
	Info = {
		Icon = "info",
		Color = Color3.fromHex("#60A5FA"),
	},
	Notice = {
		Icon = "bell",
		Color = Color3.fromHex("#38BDF8"),
	},
	Success = {
		Icon = "circle-check",
		Color = Color3.fromHex("#34D399"),
	},
	Warning = {
		Icon = "triangle-alert",
		Color = Color3.fromHex("#FBBF24"),
	},
	Error = {
		Icon = "circle-x",
		Color = Color3.fromHex("#FB7185"),
	},
	Neutral = {
		Icon = "message-circle",
		Color = Color3.fromHex("#A1A1AA"),
	},
}

local STYLE_ALIASES = {
	default = "Info",
	info = "Info",
	notice = "Notice",
	message = "Notice",
	success = "Success",
	successful = "Success",
	ok = "Success",
	green = "Success",
	warn = "Warning",
	warning = "Warning",
	caution = "Warning",
	error = "Error",
	fail = "Error",
	failed = "Error",
	danger = "Error",
	neutral = "Neutral",
}

local APPEARANCE_ALIASES = {
	default = "Compact",
	compact = "Compact",
	minimal = "Compact",
	pill = "Compact",
	capsule = "Compact",
	card = "Card",
	avatar = "Card",
	glass = "Glass",
	liquid = "Glass",
	liquidglass = "Glass",
	frosted = "Glass",
	legacy = "Glass",
}

local NOTIFICATION_TYPE_ALIASES = {
	default = "Normal",
	normal = "Normal",
	modern = "Normal",
	toast = "Normal",
	window = "Window",
	windows = "Window",
	desktop = "Window",
	windownotification = "Window",
	windownotify = "Window",
	original = "Originally",
	originally = "Originally",
	legacy = "Originally",
	classic = "Originally",
}

local NotificationModule = {
	Holder = nil,
	NotificationIndex = 0,
	Notifications = {},
}

local function ResolveColor(Value, Fallback)
	if typeof(Value) == "Color3" then
		return Value
	end

	if typeof(Value) == "string" and string.sub(Value, 1, 1) == "#" then
		local Success, Color = pcall(Color3.fromHex, Value)
		if Success then
			return Color
		end
	end

	return Fallback
end

local function NormalizeStyleName(Value)
	local Key = tostring(Value or "Info"):lower():gsub("%s+", "")
	return STYLE_ALIASES[Key] or "Info"
end

local function NormalizeNotificationType(Value)
	if Value == nil then
		return nil
	end

	local Key = tostring(Value):lower():gsub("%s+", "")
	return NOTIFICATION_TYPE_ALIASES[Key]
end

local function NormalizeAppearance(Value, Config)
	if Value == nil and (Config.Avatar ~= nil or Config.Timestamp ~= nil or Config.Time ~= nil) then
		return "Card"
	end
	local Key = tostring(Value or "Compact"):lower():gsub("%s+", "")
	return APPEARANCE_ALIASES[Key] or "Compact"
end

local function ResolveDuration(Value)
	if Value == false then
		return false
	end

	local Number = tonumber(Value)
	if Number == nil then
		return 5
	end

	return math.max(Number, 0)
end

local function NormalizeIcon(Value)
	if typeof(Value) == "number" then
		return "rbxassetid://" .. tostring(Value)
	end
	if typeof(Value) == "string" then
		return Value
	end
	if typeof(Value) == "table" or typeof(Value) == "Instance" then
		return Value
	end
	return nil
end

local function PaintIcon(Icon, Color, Transparency)
	if typeof(Icon) ~= "Instance" then
		return
	end

	local Targets = {}
	if Icon:IsA("ImageLabel") or Icon:IsA("ImageButton") then
		table.insert(Targets, Icon)
	end

	for _, Descendant in Icon:GetDescendants() do
		if Descendant:IsA("ImageLabel") or Descendant:IsA("ImageButton") then
			table.insert(Targets, Descendant)
		end
	end

	for _, Target in Targets do
		Target.ImageColor3 = Color
		if Transparency ~= nil then
			Target.ImageTransparency = Transparency
		end
	end
end

local function CreateCorner(Radius, Corners)
	local Corner = New("UICorner", {
		CornerRadius = UDim.new(0, Radius),
	})
	return Creator.ApplyCornerRadii(Corner, Radius, Corners)
end

local function ResolveCornerValue(Corners, Name, Default)
	local Value = Corners[Name]
	if Value == nil then
		Value = Corners[Name .. "Radius"]
	end
	if Value == nil then
		return Default
	end
	return Value
end

local function GetActions(Buttons)
	local Actions = {}
	if typeof(Buttons) ~= "table" then
		return Actions
	end

	for Index = 1, math.min(#Buttons, MAX_ACTIONS) do
		local Action = Buttons[Index]
		if typeof(Action) == "table" then
			table.insert(Actions, Action)
		end
	end

	return Actions
end

local function TrimNotifications(MaxVisible, AvailableHeight)
	local Active = {}
	for _, Notification in NotificationModule.Notifications do
		if not Notification.Closed then
			table.insert(Active, Notification)
		end
	end

	table.sort(Active, function(A, B)
		return A.Index < B.Index
	end)

	local TotalHeight = math.max(#Active - 1, 0) * CARD_GAP
	for _, Notification in Active do
		TotalHeight = TotalHeight + (Notification.LayoutHeight or 64)
	end

	while #Active > 1 and (#Active > MaxVisible or TotalHeight > AvailableHeight) do
		local Oldest = table.remove(Active, 1)
		TotalHeight = TotalHeight - (Oldest.LayoutHeight or 64) - CARD_GAP
		Oldest:Close("Overflow")
	end
end

function NotificationModule.Init(Parent)
	local NotModule = {
		Lower = false,
	}

	NotModule.Frame = New("Frame", {
		Name = "NotificationHolder",
		Position = UDim2.new(1, -HOLDER_SIDE_MARGIN, 0, HOLDER_TOP),
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(1, -(HOLDER_SIDE_MARGIN * 2), 1, -(HOLDER_TOP + HOLDER_BOTTOM)),
		Parent = Parent,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		ZIndex = 100,
	}, {
		New("UISizeConstraint", {
			MinSize = Vector2.new(HOLDER_MIN_WIDTH, 0),
			MaxSize = Vector2.new(HOLDER_MAX_WIDTH, 10000),
		}),
		New("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, CARD_GAP),
		}),
	})

	function NotModule.SetLower(Value)
		NotModule.Lower = Value == true
		local Bottom = if NotModule.Lower then 12 else HOLDER_BOTTOM
		NotModule.Frame.Size = UDim2.new(1, -(HOLDER_SIDE_MARGIN * 2), 1, -(HOLDER_TOP + Bottom))
	end

	NotificationModule.Holder = NotModule.Frame
	return NotModule
end

function NotificationModule.New(Config)
	Config = if typeof(Config) == "table" then Config else {}

	local TypeRenderer = NormalizeNotificationType(Config.Type)
	local ExplicitNotificationType = NormalizeNotificationType(Config.NotificationType) or TypeRenderer
	local NotificationType = ExplicitNotificationType or "Normal"
	local LegacyTypeStyle = if TypeRenderer == nil then Config.Type else nil
	local StyleName = NormalizeStyleName(Config.Style or Config.Variant or LegacyTypeStyle)
	local Appearance = if NotificationType == "Window"
		then "Window"
		elseif NotificationType == "Originally" then "Originally"
		else NormalizeAppearance(Config.Appearance or Config.Layout, Config)
	local Style = NOTIFICATION_STYLES[StyleName] or NOTIFICATION_STYLES.Info
	local AccentColor = ResolveColor(Config.AccentColor or Config.Color, Style.Color)
	local IconValue
	local RequestedIcon = if NotificationType == "Window"
		then (if Config.Avatar ~= nil then Config.Avatar else Config.BodyIcon)
		else (if Config.Avatar ~= nil then Config.Avatar else Config.Icon)
	if RequestedIcon == false or RequestedIcon == "" then
		IconValue = nil
	elseif RequestedIcon ~= nil then
		IconValue = NormalizeIcon(RequestedIcon)
	elseif NotificationType ~= "Window" then
		IconValue = Style.Icon
	end
	local LiquidGlass = Config.LiquidGlass == true
		or Config.Glass == true
		or Appearance == "Glass"
		or (NotificationType == "Window" and Config.LiquidGlass ~= false and Config.Glass ~= false)
	local Decorated = Config.Decorated == true or Config.Accented == true or Appearance == "Glass"

	local Notification = {
		Type = NotificationType,
		Title = tostring(Config.Title or "Notification"),
		Content = Config.Content ~= nil and tostring(Config.Content) or nil,
		Icon = IconValue,
		IsAvatar = Config.Avatar ~= nil,
		IconThemed = Config.IconThemed,
		IconColor = ResolveColor(
			Config.IconColor,
			if Decorated
					or Config.AccentColor ~= nil
					or Config.Color ~= nil
				then AccentColor
				else Color3.fromHex("#A1A1AA")
		),
		Style = StyleName,
		Appearance = Appearance,
		LiquidGlass = LiquidGlass,
		Decorated = Decorated,
		DarkOverlay = Config.DarkOverlay == true or Config.Overlay == true or NotificationType == "Originally",
		Timestamp = Config.Timestamp ~= nil and tostring(Config.Timestamp)
			or (Config.Time ~= nil and tostring(Config.Time) or nil),
		AppName = tostring(Config.AppName or Config.Application or Config.App or "WindUI"),
		AppIcon = NormalizeIcon(
			Config.AppIcon or Config.ApplicationIcon or (NotificationType == "Window" and Config.Icon) or "bell"
		),
		Selection = Config.Selection or Config.Dropdown or Config.Select,
		AccentColor = AccentColor,
		ProgressColor = ResolveColor(Config.ProgressColor, AccentColor),
		Background = Config.Background,
		BackgroundImageTransparency = Creator.ClampTransparency(Config.BackgroundImageTransparency, 0.35),
		Duration = ResolveDuration(Config.Duration),
		Buttons = GetActions(Config.Buttons),
		CanClose = Config.CanClose ~= false,
		PauseOnHover = Config.PauseOnHover ~= false,
		OnOpen = Config.OnOpen,
		OnClose = Config.OnClose,
		UIElements = {},
		Closed = false,
		Paused = false,
	}

	NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
	Notification.Index = NotificationModule.NotificationIndex
	NotificationModule.Notifications[Notification.Index] = Notification

	local Holder = Config.Holder or NotificationModule.Holder
	assert(Holder, "Notification holder is not initialized")

	local IsWindow = Notification.Type == "Window"
	local IsOriginally = Notification.Type == "Originally"
	local IsCard = Notification.Appearance == "Card" or IsWindow
	local CardWidth = math.max(
		tonumber(Config.Width) or (IsWindow and WINDOW_WIDTH or (IsOriginally and ORIGINAL_WIDTH or NORMAL_WIDTH)),
		HOLDER_MIN_WIDTH
	)
	local CardPadding = if IsWindow or IsOriginally then 14 elseif IsCard then 12 else CARD_PADDING
	local CardRadius = math.max(
		tonumber(Config.Radius) or (IsWindow and 20 or (IsOriginally and 18 or (IsCard and 20 or CARD_RADIUS))),
		8
	)
	local CornerConfig = if typeof(Config.Corners or Config.CornerRadii) == "table"
		then Config.Corners or Config.CornerRadii
		else Config
	local CardCorners = {
		TopLeft = ResolveCornerValue(CornerConfig, "TopLeft", CardRadius),
		TopRight = ResolveCornerValue(CornerConfig, "TopRight", CardRadius),
		BottomRight = ResolveCornerValue(CornerConfig, "BottomRight", CardRadius),
		BottomLeft = ResolveCornerValue(CornerConfig, "BottomLeft", CardRadius),
	}
	local IconSize = if IsCard then AVATAR_SIZE elseif IsOriginally then 38 else ICON_SIZE
	local TimestampWidth = if Notification.Timestamp and not IsWindow then 72 else 0
	local HasTimer = typeof(Notification.Duration) == "number" and Notification.Duration > 0
	local LeftSpace = Notification.Icon and (IconSize + 9) or 0
	local RightSpace = (Notification.CanClose and not IsWindow and CLOSE_RESERVED or 0) + TimestampWidth
	local UseShadow = Config.Shadow ~= false
	local UseFallbackShadow = Config.FallbackShadow == true
	local UseDarkOverlay = Notification.DarkOverlay
	local CardThemeTag = {
		BackgroundColor3 = if UseDarkOverlay
			then (if Notification.LiquidGlass then "NotificationGlass" else "Notification")
			else "NotificationGlassSurface",
	}
	if Config.Transparency == nil and UseDarkOverlay then
		CardThemeTag.BackgroundTransparency = if Notification.LiquidGlass
			then "NotificationGlassTransparency"
			else "NotificationTransparency"
	end
	local ProgressTween
	local TimerToken = 0
	local TimerRemaining = if HasTimer then Notification.Duration else 0
	local TimerStartedAt
	local Opened = false
	local CanTrim = false
	local TargetHeight = 64
	local Connections = {}

	local function Connect(Signal, Callback)
		local Connection = Signal:Connect(Callback)
		table.insert(Connections, Connection)
		return Connection
	end

	local function AttachPress(Button, Amount)
		Connect(Button.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Motion.Press(Button, true, Amount)
			end
		end)
		Connect(Button.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Motion.Press(Button, false, Amount)
			end
		end)
		Connect(Button.MouseLeave, function()
			Motion.Press(Button, false, Amount)
		end)
	end

	local function AttachHover(Button, Target, HoverTransparency, RestTransparency)
		Connect(Button.MouseEnter, function()
			Motion.Play(
				Target,
				"Hover",
				{ BackgroundTransparency = HoverTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"Hover"
			)
		end)
		Connect(Button.MouseLeave, function()
			Motion.Play(
				Target,
				"Hover",
				{ BackgroundTransparency = RestTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"Hover"
			)
		end)
	end

	local function DisconnectSignals()
		for _, Connection in Connections do
			Connection:Disconnect()
		end
		table.clear(Connections)
	end

	local MainContainer = New("Frame", {
		Name = "NotificationContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = false,
		LayoutOrder = -Notification.Index,
		ZIndex = 100,
		Parent = Holder,
	}, {
		New("UISizeConstraint", {
			MinSize = Vector2.new(math.min(CardWidth, HOLDER_MIN_WIDTH), 0),
			MaxSize = Vector2.new(CardWidth, 10000),
		}),
	})

	local MainScale = New("UIScale", {
		Name = "TransitionScale",
		Scale = 0.965,
	})

	local Main = New("CanvasGroup", {
		Name = "NotificationTransition",
		Active = true,
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, TargetHeight),
		Position = UDim2.new(0, ENTER_OFFSET, 0, 0),
		ClipsDescendants = false,
		ZIndex = 101,
		Parent = MainContainer,
	}, {
		MainScale,
	})

	local Shadow = New("Frame", {
		Name = "Shadow",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.78,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -4, 1, -4),
		Position = UDim2.new(0, 2, 0, SHADOW_OFFSET),
		Visible = UseShadow,
		ZIndex = 101,
		Parent = Main,
	}, {
		CreateCorner(CardRadius, CardCorners),
	})

	local CardStroke = New("UIStroke", {
		Color = Color3.new(1, 1, 1),
		Transparency = 0.76,
		Thickness = 1,
		ThemeTag = {
			Color = "NotificationBorder",
			Transparency = "NotificationBorderTransparency",
		},
	})

	local Card = New("Frame", {
		Name = "Notification",
		BackgroundColor3 = if UseDarkOverlay then Color3.fromRGB(24, 25, 29) else Color3.new(1, 1, 1),
		BackgroundTransparency = Creator.ClampTransparency(
			Config.Transparency,
			if UseDarkOverlay
				then (if Notification.LiquidGlass then 0.28 else 0.08)
				else (if Notification.LiquidGlass then 0.64 else 0.72)
		),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		ZIndex = 102,
		ThemeTag = CardThemeTag,
		Parent = Main,
	}, {
		CreateCorner(CardRadius, CardCorners),
		CardStroke,
	})
	Card:SetAttribute("Appearance", Notification.Appearance)
	Card:SetAttribute("Type", Notification.Type)
	Card:SetAttribute("LiquidGlass", Notification.LiquidGlass)
	Card:SetAttribute("DarkOverlay", UseDarkOverlay)
	Card:SetAttribute("LayoutVersion", 4)

	local NativeShadow
	if UseShadow then
		NativeShadow = Creator.CreateUIShadow(Card, {
			Name = "NativeShadow",
			BlurRadius = Creator.ToUDimRadius(Config.ShadowBlur, UDim.new(0, 16)),
			Color = ResolveColor(Config.ShadowColor, Color3.new(0, 0, 0)),
			Offset = if typeof(Config.ShadowOffset) == "UDim2" then Config.ShadowOffset else UDim2.fromOffset(0, 5),
			Spread = if typeof(Config.ShadowSpread) == "UDim2" then Config.ShadowSpread else UDim2.fromOffset(2, 2),
			Transparency = Creator.ClampTransparency(Config.ShadowTransparency, 0.68),
			ZIndex = 0,
		})
	end
	Shadow.Visible = UseShadow and NativeShadow == nil and UseFallbackShadow

	local CapsuleSurface = New("Frame", {
		Name = "CapsuleSurface",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = if UseDarkOverlay
			then (if Notification.LiquidGlass then 0.91 else 0.985)
			else (if Notification.LiquidGlass then 0.94 else 1),
		Size = UDim2.fromScale(1, 1),
		ZIndex = 103,
		ThemeTag = {
			BackgroundColor3 = if Notification.LiquidGlass then "NotificationGlassSurface" else "Notification2",
			BackgroundTransparency = if UseDarkOverlay
				then (if Notification.LiquidGlass
					then "NotificationGlassSurfaceTransparency"
					else "Notification2Transparency")
				else nil,
		},
		Parent = Card,
	}, {
		CreateCorner(CardRadius, CardCorners),
	})

	local LiquidGlassLayer = Creator.NewRoundFrame(CardRadius, "SquircleGlass", {
		Name = "LiquidGlass",
		ImageColor3 = Color3.new(1, 1, 1),
		ImageTransparency = Creator.ClampTransparency(Config.GlassTransparency, 0.78),
		Size = UDim2.fromScale(1, 1),
		Visible = Notification.LiquidGlass,
		ZIndex = 104,
		ThemeTag = if Config.GlassTransparency == nil
			then {
				ImageColor3 = "NotificationGlassHighlight",
				ImageTransparency = "NotificationGlassTextureTransparency",
			}
			else {
				ImageColor3 = "NotificationGlassHighlight",
			},
		Parent = Card,
	})

	if typeof(Notification.Background) == "string" and Notification.Background ~= "" then
		New("ImageLabel", {
			Name = "Background",
			Image = Notification.Background,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ImageTransparency = Notification.BackgroundImageTransparency,
			ZIndex = 104,
			Parent = Card,
		}, {
			CreateCorner(CardRadius, CardCorners),
		})
	end

	local ToneWash = New("Frame", {
		Name = "ToneWash",
		BackgroundColor3 = Notification.AccentColor,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Visible = Notification.Decorated,
		ZIndex = 105,
		Parent = Card,
	}, {
		CreateCorner(CardRadius, CardCorners),
		New("UIGradient", {
			Rotation = 18,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.42),
				NumberSequenceKeypoint.new(0.38, 0.86),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	local AccentLine = New("Frame", {
		Name = "AccentLine",
		BackgroundColor3 = Notification.AccentColor,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 3, 0.48, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Visible = Notification.Decorated,
		ZIndex = 106,
		Parent = Card,
	}, {
		CreateCorner(3, {
			TopLeft = CardCorners.TopLeft,
			TopRight = 3,
			BottomRight = 3,
			BottomLeft = CardCorners.BottomLeft,
		}),
		New("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.32, 0.08),
				NumberSequenceKeypoint.new(0.68, 0.08),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	local TopHighlight = New("Frame", {
		Name = "TopHighlight",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.new(0.72, 0, 0, 1),
		Position = UDim2.new(0.14, 0, 0, 0),
		ZIndex = 106,
		Parent = Card,
	}, {
		New("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0.15),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	local Body = New("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -(CardPadding * 2), 0, 0),
		Position = UDim2.fromOffset(CardPadding, CardPadding),
		ZIndex = 107,
		Parent = Card,
	})

	local BodyLayout = New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, if IsWindow then 10 elseif IsOriginally then 5 else 8),
		Parent = Body,
	})

	local AppRow
	local AppIcon
	local AppName
	local AppTimestamp
	if IsWindow then
		AppRow = New("Frame", {
			Name = "AppHeader",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 28),
			LayoutOrder = 0,
			ZIndex = 108,
			Parent = Body,
		})

		if Notification.AppIcon then
			AppIcon = Creator.Image(
				Notification.AppIcon,
				Notification.AppName .. ":AppIcon",
				4,
				Config.Window and Config.Window.Folder,
				"NotificationApp",
				true,
				Config.AppIconThemed,
				"NotificationTitle"
			)
			AppIcon.Name = "AppIcon"
			AppIcon.Size = UDim2.fromOffset(22, 22)
			AppIcon.Position = UDim2.new(0, 0, 0.5, 0)
			AppIcon.AnchorPoint = Vector2.new(0, 0.5)
			AppIcon.ZIndex = 109
			AppIcon.Parent = AppRow
		end

		local AppLeftOffset = if AppIcon then 30 else 0
		AppName = New("TextLabel", {
			Name = "AppName",
			Text = Notification.AppName,
			TextSize = 13,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -(AppLeftOffset + 92), 1, 0),
			Position = UDim2.fromOffset(AppLeftOffset, 0),
			ZIndex = 109,
			ThemeTag = {
				TextColor3 = "NotificationTitle",
			},
			Parent = AppRow,
		})

		AppTimestamp = New("TextLabel", {
			Name = "AppTimestamp",
			Text = Notification.Timestamp or os.date("%H:%M"),
			TextSize = 11,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(48, 28),
			Position = UDim2.new(1, -(Notification.CanClose and 46 or 0), 0, 0),
			AnchorPoint = Vector2.new(1, 0),
			TextTransparency = 0.3,
			ZIndex = 109,
			ThemeTag = {
				TextColor3 = "NotificationContent",
			},
			Parent = AppRow,
		})
	end

	local HeaderRow = New("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, math.max(Notification.Icon and IconSize or 0, 20)),
		LayoutOrder = 1,
		ZIndex = 107,
		Parent = Body,
	})

	local Timestamp
	if Notification.Timestamp and not IsWindow then
		Timestamp = New("TextLabel", {
			Name = "Timestamp",
			Text = Notification.Timestamp,
			TextSize = 11,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(TimestampWidth, 18),
			Position = UDim2.new(1, -(Notification.CanClose and CLOSE_RESERVED or 0), 0, 1),
			AnchorPoint = Vector2.new(1, 0),
			TextTransparency = 0.22,
			ZIndex = 109,
			ThemeTag = {
				TextColor3 = "NotificationContent",
			},
			Parent = AppRow or HeaderRow,
		})
	end

	local TextContainer = New("Frame", {
		Name = "TextContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -(LeftSpace + RightSpace), 0, 0),
		Position = UDim2.fromOffset(LeftSpace, 0),
		ZIndex = 108,
		Parent = HeaderRow,
	})

	local TextLayout = New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		Parent = TextContainer,
	})

	local Title = New("TextLabel", {
		Name = "Title",
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = Notification.Title,
		TextWrapped = IsCard or IsOriginally or Config.Wrap == true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = if IsWindow then 19 elseif IsOriginally then 18 elseif IsCard then 15 else 14,
		LineHeight = 1,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		LayoutOrder = 1,
		ZIndex = 108,
		ThemeTag = {
			TextColor3 = "NotificationTitle",
			TextTransparency = "NotificationTitleTransparency",
		},
		Parent = TextContainer,
	}, {
		New("UISizeConstraint", {
			MinSize = Vector2.new(0, 18),
			MaxSize = Vector2.new(10000, MAX_TITLE_HEIGHT),
		}),
	})

	local Content = New("TextLabel", {
		Name = "Content",
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = Notification.Content or "",
		TextWrapped = IsCard or IsOriginally or Config.Wrap == true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = if IsWindow then 14 elseif IsOriginally then 15 else 12,
		LineHeight = 1.05,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
		LayoutOrder = 2,
		Visible = Notification.Content ~= nil,
		ZIndex = 108,
		ThemeTag = {
			TextColor3 = "NotificationContent",
			TextTransparency = "NotificationContentTransparency",
		},
		Parent = TextContainer,
	}, {
		New("UISizeConstraint", {
			MinSize = Vector2.new(0, 16),
			MaxSize = Vector2.new(10000, MAX_CONTENT_HEIGHT),
		}),
	})

	local IconBubble
	local IconImage
	if Notification.Icon then
		local IconIsGlyph = not Notification.IsAvatar
			and (
				type(Notification.Icon) ~= "string"
				or (Notification.Icon:match("^rbxassetid://") == nil and Notification.Icon:match("^https?://") == nil)
			)
		IconImage = Creator.Image(
			Notification.Icon,
			Notification.Title .. ":" .. tostring(Notification.Icon),
			Notification.IsAvatar and IconSize / 2 or 0,
			Config.Window and Config.Window.Folder,
			"Notification",
			true,
			Notification.IconThemed,
			nil,
			Notification.IsAvatar
		)
		IconImage.Name = if Notification.IsAvatar then "Avatar" else "Icon"
		IconImage.Size = if Notification.IsAvatar
			then UDim2.fromScale(1, 1)
			else UDim2.fromOffset(if IsCard then 22 else 18, if IsCard then 22 else 18)
		IconImage.Position = UDim2.fromScale(0.5, 0.5)
		IconImage.AnchorPoint = Vector2.new(0.5, 0.5)
		IconImage.ZIndex = 110
		if IconIsGlyph and Creator.Icon(Notification.Icon) and Notification.IconThemed ~= true then
			PaintIcon(IconImage, Notification.IconColor, 0)
		end

		IconBubble = New("Frame", {
			Name = "IconBubble",
			BackgroundColor3 = if Notification.IsAvatar then Color3.new(1, 1, 1) else Notification.IconColor,
			BackgroundTransparency = if Notification.IsAvatar then 0.9 elseif Notification.Decorated then 0.88 else 0.95,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(IconSize, IconSize),
			ClipsDescendants = true,
			ZIndex = 109,
			Parent = HeaderRow,
		}, {
			CreateCorner(IconSize / 2),
			New("UIStroke", {
				Color = Notification.IconColor,
				Transparency = if Notification.Decorated then 0.72 else 0.88,
				Thickness = 1,
			}),
			New("UIGradient", {
				Rotation = 35,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Notification.AccentColor:Lerp(Color3.new(1, 1, 1), 0.16)),
					ColorSequenceKeypoint.new(1, Notification.AccentColor),
				}),
			}),
			IconImage,
		})
	end

	local CloseButton
	local CloseSurface
	if Notification.CanClose then
		local CloseIconData = Creator.Icon("x")
		CloseSurface = New("Frame", {
			Name = "Surface",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.98,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(CLOSE_SURFACE_SIZE, CLOSE_SURFACE_SIZE),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 109,
			ThemeTag = {
				BackgroundColor3 = "Notification2",
			},
		}, {
			CreateCorner(CLOSE_SURFACE_SIZE / 2),
			New("ImageLabel", {
				Name = "Icon",
				Image = CloseIconData and CloseIconData[1] or "",
				ImageRectSize = CloseIconData and CloseIconData[2] and CloseIconData[2].ImageRectSize or Vector2.zero,
				ImageRectOffset = CloseIconData and CloseIconData[2] and CloseIconData[2].ImageRectPosition
					or Vector2.zero,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(14, 14),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = 0.46,
				ZIndex = 110,
				ThemeTag = {
					ImageColor3 = "NotificationTitle",
				},
			}),
		})

		CloseButton = New("TextButton", {
			Name = "CloseButton",
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(CLOSE_SIZE, CLOSE_SIZE),
			Position = UDim2.new(1, 4, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ZIndex = 109,
			Parent = if IsWindow then AppRow else HeaderRow,
		}, {
			CloseSurface,
		})
		AttachPress(CloseButton, 0.96)
		AttachHover(CloseButton, CloseSurface, 0.91, 0.98)
	end

	local SelectionRow
	local SelectionValue
	if IsWindow and Notification.Selection ~= nil then
		local SelectionConfig = if typeof(Notification.Selection) == "table"
			then Notification.Selection
			else { Value = Notification.Selection }
		local SelectionValues = if typeof(SelectionConfig.Values or SelectionConfig.Options) == "table"
			then SelectionConfig.Values or SelectionConfig.Options
			else {}
		local SelectionIndex = math.max(tonumber(SelectionConfig.Index) or 1, 1)

		local function GetSelectionValue(Value)
			if typeof(Value) == "table" then
				return Value.Value or Value.Title or Value.Name
			end
			return Value
		end

		local CurrentSelection = SelectionConfig.Value or SelectionConfig.Default
		if CurrentSelection ~= nil and #SelectionValues > 0 then
			for Index, Value in SelectionValues do
				local ResolvedValue = GetSelectionValue(Value)
				if ResolvedValue == CurrentSelection or tostring(ResolvedValue) == tostring(CurrentSelection) then
					SelectionIndex = Index
					break
				end
			end
		end
		if CurrentSelection == nil and #SelectionValues > 0 then
			CurrentSelection = GetSelectionValue(SelectionValues[SelectionIndex] or SelectionValues[1])
		end
		CurrentSelection = CurrentSelection or "Select"

		local ChevronData = Creator.Icon("chevron-down")
		SelectionRow = New("TextButton", {
			Name = "Selection",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.9,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 40),
			LayoutOrder = 2,
			ZIndex = 108,
			ThemeTag = {
				BackgroundColor3 = "Notification2",
			},
			Parent = Body,
		}, {
			CreateCorner(10),
			New("UIStroke", {
				Color = Color3.new(1, 1, 1),
				Transparency = 0.8,
				Thickness = 1,
				ThemeTag = {
					Color = "NotificationBorder",
					Transparency = "NotificationBorderTransparency",
				},
			}),
			New("TextLabel", {
				Name = "Value",
				Text = tostring(CurrentSelection),
				TextSize = 14,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -48, 1, 0),
				Position = UDim2.fromOffset(14, 0),
				ZIndex = 109,
				ThemeTag = {
					TextColor3 = "NotificationTitle",
				},
			}),
			New("ImageLabel", {
				Name = "Chevron",
				Image = ChevronData and ChevronData[1] or "",
				ImageRectSize = ChevronData and ChevronData[2] and ChevronData[2].ImageRectSize or Vector2.zero,
				ImageRectOffset = ChevronData and ChevronData[2] and ChevronData[2].ImageRectPosition or Vector2.zero,
				ImageTransparency = 0.35,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(1, -14, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				ZIndex = 109,
				ThemeTag = {
					ImageColor3 = "NotificationTitle",
				},
			}),
		})
		SelectionValue = SelectionRow.Value
		AttachPress(SelectionRow, 0.985)
		AttachHover(SelectionRow, SelectionRow, 0.84, 0.9)

		Connect(SelectionRow.MouseButton1Click, function()
			if #SelectionValues > 0 then
				SelectionIndex = (SelectionIndex % #SelectionValues) + 1
				CurrentSelection = GetSelectionValue(SelectionValues[SelectionIndex])
				SelectionValue.Text = tostring(CurrentSelection)
			end
			Creator.SafeCallback(SelectionConfig.Callback, CurrentSelection, SelectionIndex, Notification)
		end)
	end

	local ActionRow
	local ActionHeight = if IsWindow then 40 else ACTION_HEIGHT
	if #Notification.Buttons > 0 then
		ActionRow = New("Frame", {
			Name = "Actions",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, ActionHeight),
			LayoutOrder = if IsWindow then 3 else 2,
			ZIndex = 107,
			Parent = Body,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
			Parent = ActionRow,
		})

		for Index, Action in Notification.Buttons do
			local IsPrimary = Index == 1
			local ButtonSize
			if #Notification.Buttons == 2 then
				ButtonSize = UDim2.new(0.5, -3, 0, ActionHeight)
			else
				ButtonSize = UDim2.new(1, 0, 0, ActionHeight)
			end

			local RestTransparency = if IsPrimary then 0.16 else 0.93
			local ActionStroke = New("UIStroke", {
				Color = if IsPrimary then Notification.AccentColor else Color3.new(1, 1, 1),
				Transparency = if IsPrimary then 0.55 else 0.78,
				Thickness = 1,
				ThemeTag = if IsPrimary
					then nil
					else {
						Color = "NotificationBorder",
						Transparency = "NotificationBorderTransparency",
					},
			})

			local ActionButton = New("TextButton", {
				Name = "Action" .. Index,
				Text = tostring(Action.Title or Action.Text or "Action"),
				TextSize = 12,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				AutoButtonColor = false,
				BackgroundColor3 = if IsPrimary then Notification.AccentColor else Color3.new(1, 1, 1),
				BackgroundTransparency = RestTransparency,
				BorderSizePixel = 0,
				Size = ButtonSize,
				LayoutOrder = Index,
				ZIndex = 108,
				ThemeTag = if IsPrimary
					then {
						TextColor3 = "White",
					}
					else {
						BackgroundColor3 = "Notification2",
						TextColor3 = "NotificationTitle",
					},
				Parent = ActionRow,
			}, {
				CreateCorner(9),
				ActionStroke,
			})
			AttachPress(ActionButton, 0.97)
			AttachHover(ActionButton, ActionButton, if IsPrimary then 0.06 else 0.87, RestTransparency)

			Connect(ActionButton.MouseButton1Click, function()
				Creator.SafeCallback(Action.Callback, Notification, Action)
				if Action.Close ~= false and Action.CloseOnClick ~= false then
					Notification:Close("Action")
				end
			end)
		end
	end

	local AnimateProgress = HasTimer and Motion:IsEnabled() and not Motion.Reduced
	local ProgressTrack = New("Frame", {
		Name = "ProgressTrack",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = if IsOriginally
			then UDim2.new(1, -(CardPadding * 2), 0, PROGRESS_HEIGHT)
			else UDim2.new(0.32, 0, 0, PROGRESS_HEIGHT),
		Position = UDim2.new(0.5, 0, 1, if IsOriginally then -3 else -5),
		AnchorPoint = Vector2.new(0.5, 1),
		Visible = HasTimer,
		ZIndex = 111,
		ThemeTag = {
			BackgroundColor3 = "NotificationDuration",
			BackgroundTransparency = "NotificationDurationTransparency",
		},
		Parent = Card,
	}, {
		CreateCorner(PROGRESS_HEIGHT),
	})

	local ProgressFill = New("Frame", {
		Name = "ProgressFill",
		BackgroundColor3 = Notification.ProgressColor,
		BackgroundTransparency = Creator.ClampTransparency(Config.ProgressTransparency, 0.12),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 112,
		Parent = ProgressTrack,
	}, {
		CreateCorner(PROGRESS_HEIGHT),
		New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Notification.ProgressColor),
				ColorSequenceKeypoint.new(1, Notification.ProgressColor:Lerp(Color3.new(1, 1, 1), 0.22)),
			}),
		}),
	})

	local function UpdateContainerHeight(Animate)
		local BodyHeight = math.max(math.ceil(BodyLayout.AbsoluteContentSize.Y), HeaderRow.Size.Y.Offset)
		TargetHeight = CardPadding + BodyHeight + CardPadding
		Notification.LayoutHeight = TargetHeight
		Main.Size = UDim2.new(1, 0, 0, TargetHeight)

		if Opened then
			if Animate == false then
				MainContainer.Size = UDim2.new(1, 0, 0, TargetHeight)
			else
				Motion.Play(
					MainContainer,
					"Resize",
					{ Size = UDim2.new(1, 0, 0, TargetHeight) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Resize"
				)
			end
		end

		if CanTrim then
			local AvailableHeight = math.max(Holder.AbsoluteSize.Y, TargetHeight)
			TrimNotifications(math.max(math.floor(tonumber(Config.MaxVisible) or MAX_VISIBLE), 1), AvailableHeight)
		end
	end

	local function UpdateTextHeight()
		local TextHeight = math.max(math.ceil(TextLayout.AbsoluteContentSize.Y), 20)
		TextContainer.Size = UDim2.new(1, -(LeftSpace + RightSpace), 0, TextHeight)
		HeaderRow.Size = UDim2.new(1, 0, 0, math.max(TextHeight, Notification.Icon and IconSize or 0, 20))
		UpdateContainerHeight(Opened)
	end

	Connect(TextLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		UpdateTextHeight()
	end)
	Connect(BodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		UpdateContainerHeight(Opened)
	end)

	local function StopProgressTween()
		if ProgressTween then
			ProgressTween:Cancel()
			ProgressTween = nil
		end
	end

	local function CaptureRemainingTime()
		if TimerStartedAt then
			TimerRemaining = math.max(TimerRemaining - (os.clock() - TimerStartedAt), 0)
			TimerStartedAt = nil
		end
		Notification.Remaining = TimerRemaining
	end

	local function SetProgressRatio(Ratio)
		ProgressFill.Size = UDim2.new(math.clamp(Ratio, 0, 1), 0, 1, 0)
	end

	local function StartTimer()
		if not HasTimer or not Opened or Notification.Closed or Notification.Paused then
			return
		end

		if TimerRemaining <= 0 then
			Notification:Close("Timeout")
			return
		end

		TimerToken = TimerToken + 1
		local CurrentToken = TimerToken
		TimerStartedAt = os.clock()
		Notification.Remaining = TimerRemaining

		StopProgressTween()
		local Ratio = TimerRemaining / Notification.Duration
		SetProgressRatio(Ratio)
		if AnimateProgress then
			ProgressTween = Tween(
				ProgressFill,
				TimerRemaining,
				{ Size = UDim2.new(0, 0, 1, 0) },
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.InOut
			)
			ProgressTween:Play()
		end

		task.delay(TimerRemaining, function()
			if CurrentToken == TimerToken and not Notification.Closed and not Notification.Paused then
				TimerRemaining = 0
				Notification.Remaining = 0
				Notification:Close("Timeout")
			end
		end)
	end

	function Notification:Pause()
		if not HasTimer or Notification.Closed or Notification.Paused then
			return Notification
		end

		Notification.Paused = true
		TimerToken = TimerToken + 1
		CaptureRemainingTime()
		StopProgressTween()
		SetProgressRatio(TimerRemaining / Notification.Duration)
		return Notification
	end

	function Notification:Resume()
		if not HasTimer or Notification.Closed or not Notification.Paused then
			return Notification
		end

		Notification.Paused = false
		StartTimer()
		return Notification
	end

	function Notification:GetRemainingDuration()
		if not HasTimer then
			return 0
		end

		local Remaining = TimerRemaining
		if TimerStartedAt then
			Remaining = math.max(Remaining - (os.clock() - TimerStartedAt), 0)
		end
		return Remaining
	end

	function Notification:Update(Changes)
		if typeof(Changes) ~= "table" or Notification.Closed then
			return Notification
		end

		if Changes.Title ~= nil then
			Notification.Title = tostring(Changes.Title)
			Title.Text = Notification.Title
		end

		if Changes.Content ~= nil then
			Notification.Content = if Changes.Content == false then nil else tostring(Changes.Content)
			Content.Text = Notification.Content or ""
			Content.Visible = Notification.Content ~= nil
		end

		if Changes.Duration ~= nil then
			local WasPaused = Notification.Paused
			TimerToken = TimerToken + 1
			CaptureRemainingTime()
			StopProgressTween()
			Notification.Duration = ResolveDuration(Changes.Duration)
			HasTimer = typeof(Notification.Duration) == "number" and Notification.Duration > 0
			AnimateProgress = HasTimer and Motion:IsEnabled() and not Motion.Reduced
			TimerRemaining = if HasTimer then Notification.Duration else 0
			Notification.Remaining = TimerRemaining
			Notification.Paused = WasPaused
			ProgressTrack.Visible = HasTimer
			SetProgressRatio(if HasTimer then 1 else 0)
			StartTimer()
		end

		UpdateTextHeight()
		return Notification
	end

	function Notification:Close(Reason)
		if Notification.Closed then
			return Notification
		end

		Notification.Closed = true
		Notification.CloseReason = tostring(Reason or "Manual")
		TimerToken = TimerToken + 1
		CaptureRemainingTime()
		DisconnectSignals()
		StopProgressTween()

		Motion.Cancel(MainContainer, "Open")
		Motion.Cancel(MainContainer, "Resize")
		Motion.Cancel(Main, "Open")
		Motion.Cancel(MainScale, "Open")
		Motion.Play(
			MainContainer,
			"NotificationClose",
			{ Size = UDim2.new(1, 0, 0, 0) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Close"
		)
		Motion.Play(Main, "NotificationClose", {
			Position = UDim2.new(0, EXIT_OFFSET, 0, 0),
			GroupTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Close")
		Motion.Play(
			MainScale,
			"NotificationClose",
			{ Scale = 0.98 },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Close"
		)

		Creator.SafeCallback(Notification.OnClose, Notification, Notification.CloseReason)

		local CloseDelay = if Motion:IsEnabled() and not Motion.Reduced
			then Motion.GetDuration("NotificationClose") + 0.02
			else 0
		task.delay(CloseDelay, function()
			NotificationModule.Notifications[Notification.Index] = nil
			if MainContainer.Parent then
				MainContainer:Destroy()
			end
		end)

		return Notification
	end

	if CloseButton then
		Connect(CloseButton.MouseButton1Click, function()
			Notification:Close("Dismissed")
		end)
	end

	if Notification.PauseOnHover then
		Connect(Main.MouseEnter, function()
			Notification:Pause()
		end)
		Connect(Main.MouseLeave, function()
			Notification:Resume()
		end)
	end

	Notification.UIElements = {
		Container = MainContainer,
		Main = Card,
		Card = Card,
		Type = Notification.Type,
		Transition = Main,
		TransitionScale = MainScale,
		Shadow = Shadow,
		NativeShadow = NativeShadow,
		Stroke = CardStroke,
		Surface = CapsuleSurface,
		LiquidGlass = LiquidGlassLayer,
		ToneWash = ToneWash,
		AccentLine = AccentLine,
		TopHighlight = TopHighlight,
		Body = Body,
		Header = HeaderRow,
		AppHeader = AppRow,
		AppIcon = AppIcon,
		AppName = AppName,
		AppTimestamp = AppTimestamp,
		TextContainer = TextContainer,
		Title = Title,
		Content = Content,
		Timestamp = Timestamp,
		Icon = IconImage,
		Avatar = if Notification.IsAvatar then IconImage else nil,
		IconBubble = IconBubble,
		CloseButton = CloseButton,
		CloseSurface = CloseSurface,
		Actions = ActionRow,
		Selection = SelectionRow,
		SelectionValue = SelectionValue,
		ProgressTrack = ProgressTrack,
		ProgressFill = ProgressFill,
	}

	UpdateTextHeight()
	CanTrim = true
	TrimNotifications(
		math.max(math.floor(tonumber(Config.MaxVisible) or MAX_VISIBLE), 1),
		math.max(Holder.AbsoluteSize.Y, TargetHeight)
	)

	task.spawn(function()
		task.wait()
		if Notification.Closed then
			return
		end

		UpdateTextHeight()
		Opened = true
		Motion.Play(
			MainContainer,
			"Notification",
			{ Size = UDim2.new(1, 0, 0, TargetHeight) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Open"
		)
		Motion.Play(Main, "Notification", {
			Position = UDim2.new(0, 0, 0, 0),
			GroupTransparency = 0,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Open")
		Motion.Play(MainScale, "Notification", { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Open")

		Creator.SafeCallback(Notification.OnOpen, Notification)
		StartTimer()
	end)

	return Notification
end

return NotificationModule
