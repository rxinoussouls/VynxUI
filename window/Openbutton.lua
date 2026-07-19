local OpenButton = {}

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local TextService = cloneref(game:GetService("TextService"))

local POSITION_PRESETS = {
	TopCenter = {
		Position = UDim2.new(0.5, 0, 0, 8),
		AnchorPoint = Vector2.new(0.5, 0),
	},
	TopLeft = {
		Position = UDim2.new(0, 14, 0, 8),
		AnchorPoint = Vector2.new(0, 0),
	},
	TopRight = {
		Position = UDim2.new(1, -14, 0, 8),
		AnchorPoint = Vector2.new(1, 0),
	},
	BottomCenter = {
		Position = UDim2.new(0.5, 0, 1, -14),
		AnchorPoint = Vector2.new(0.5, 1),
	},
	BottomLeft = {
		Position = UDim2.new(0, 14, 1, -14),
		AnchorPoint = Vector2.new(0, 1),
	},
	BottomRight = {
		Position = UDim2.new(1, -14, 1, -14),
		AnchorPoint = Vector2.new(1, 1),
	},
}

local STATE_ALIASES = {
	closed = "Collapsed",
	circle = "Collapsed",
	icon = "Collapsed",
	mini = "Collapsed",
	collapsed = "Collapsed",
	compact = "Compact",
	default = "Compact",
	pill = "Compact",
	open = "Expanded",
	expanded = "Expanded",
	dynamic = "Expanded",
}

local function Pick(Value, Fallback)
	if Value ~= nil then
		return Value
	end
	return Fallback
end

local function NormalizeState(Value)
	return STATE_ALIASES[tostring(Value or "Compact"):lower()] or "Compact"
end

local function NormalizeColorSequence(Value, Fallback)
	if typeof(Value) == "ColorSequence" then
		return Value
	end
	if typeof(Value) == "Color3" then
		return ColorSequence.new(Value)
	end
	return Fallback
end

local function GetInnerCornerRadius(CornerRadius, Inset)
	if typeof(CornerRadius) ~= "UDim" then
		return UDim.new(1, 0)
	end
	if CornerRadius.Scale ~= 0 then
		return UDim.new(CornerRadius.Scale, math.max(CornerRadius.Offset, 0))
	end
	return UDim.new(0, math.max(CornerRadius.Offset - Inset, 0))
end

local function MeasureText(Text, Size, MaxWidth)
	local Bounds =
		TextService:GetTextSize(tostring(Text or ""), Size, Enum.Font.GothamMedium, Vector2.new(MaxWidth, 1000))
	return math.ceil(Bounds.X), math.ceil(Bounds.Y)
end

function OpenButton.New(Window)
	local DefaultGradient = ColorSequence.new(Color3.fromHex("#40C9FF"), Color3.fromHex("#E81CFF"))
	local Settings = {
		Title = Window.Title or "Open",
		Content = nil,
		Icon = Window.Icon,
		Enabled = true,
		Visible = false,
		OnlyMobile = true,
		Draggable = true,
		Position = "TopCenter",
		State = "Compact",
		Height = 44,
		ExpandedHeight = 68,
		ExpandedWidth = 220,
		MaxWidth = 380,
		IconSize = 22,
		Padding = 12,
		Gap = 9,
		Scale = 1,
		CornerRadius = UDim.new(1, 0),
		StrokeThickness = 1,
		StrokeTransparency = 0.7,
		Color = DefaultGradient,
		BackgroundColor = Color3.fromRGB(7, 8, 11),
		BackgroundTransparency = 0.08,
		TextColor = nil,
		TextTransparency = nil,
		AutoCollapse = nil,
		OnStateChange = nil,
	}

	local OpenButtonMain = {
		Button = nil,
		Container = nil,
		IconSize = Settings.IconSize,
		Scale = Settings.Scale,
		State = Settings.State,
		Config = Settings,
		UIElements = {},
	}

	local StateToken = 0
	local ActiveTweens = {}
	local Icon
	local DragModule

	local Container = New("Frame", {
		Name = "OpenButtonContainer",
		Size = UDim2.fromOffset(Settings.Height, Settings.Height),
		Position = POSITION_PRESETS.TopCenter.Position,
		AnchorPoint = POSITION_PRESETS.TopCenter.AnchorPoint,
		Parent = Window.Parent,
		BackgroundTransparency = 1,
		Active = true,
		Visible = false,
		ZIndex = 98,
	})

	local UIScale = New("UIScale", {
		Name = "Scale",
		Scale = Settings.Scale,
		Parent = Container,
	})

	local Shadow = New("Frame", {
		Name = "Shadow",
		Size = UDim2.new(1, 4, 1, 4),
		Position = UDim2.fromOffset(-2, 3),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.58,
		BorderSizePixel = 0,
		ZIndex = 98,
		Parent = Container,
	}, {
		New("UICorner", {
			CornerRadius = Settings.CornerRadius,
		}),
	})

	local StrokeGradient = New("UIGradient", {
		Name = "UIGradient",
		Color = Settings.Color,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.12),
			NumberSequenceKeypoint.new(0.5, 0.52),
			NumberSequenceKeypoint.new(1, 0.18),
		}),
	})

	local Stroke = New("UIStroke", {
		Name = "UIStroke",
		Thickness = Settings.StrokeThickness,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.new(1, 1, 1),
		Transparency = Settings.StrokeTransparency,
	}, {
		StrokeGradient,
	})

	local Button = New("Frame", {
		Name = "OpenButton",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Settings.BackgroundColor,
		BackgroundTransparency = Settings.BackgroundTransparency,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
		ZIndex = 99,
		Parent = Container,
	}, {
		New("UICorner", {
			CornerRadius = Settings.CornerRadius,
		}),
		Stroke,
		New("Frame", {
			Name = "Surface",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.965,
			BorderSizePixel = 0,
			ZIndex = 99,
		}, {
			New("UICorner", {
				CornerRadius = Settings.CornerRadius,
			}),
			New("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.48),
					NumberSequenceKeypoint.new(0.45, 0.9),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		}),
	})

	local Drag = New("Frame", {
		Name = "Drag",
		Size = UDim2.fromOffset(36, 36),
		Position = UDim2.fromOffset(4, 4),
		BackgroundTransparency = 1,
		ZIndex = 102,
		Parent = Button,
	})

	local DragIcon = Creator.Image("move", "OpenButtonDrag", 0, Window.Folder, "OpenButton", true, true)
	DragIcon.Name = "Icon"
	DragIcon.Size = UDim2.fromOffset(17, 17)
	DragIcon.Position = UDim2.fromScale(0.5, 0.5)
	DragIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	DragIcon.Parent = Drag
	local DragImage = DragIcon:FindFirstChildWhichIsA("ImageLabel")
	if DragImage then
		DragImage.ImageTransparency = 0.42
	end

	local Divider = New("Frame", {
		Name = "Divider",
		Size = UDim2.new(0, 1, 1, -18),
		Position = UDim2.new(0, 44, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		ZIndex = 102,
		Parent = Button,
	})

	local MainAction = New("TextButton", {
		Name = "TextButton",
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.new(1, -45, 1, 0),
		Position = UDim2.fromOffset(45, 0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 101,
		Parent = Button,
	}, {
		New("UICorner", {
			CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4),
		}),
	})

	local HoverSurface = New("Frame", {
		Name = "HoverSurface",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 101,
		Parent = MainAction,
	}, {
		New("UICorner", {
			CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4),
		}),
	})

	local TextStack = New("CanvasGroup", {
		Name = "TextStack",
		Size = UDim2.new(1, -58, 1, 0),
		Position = UDim2.fromOffset(46, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 0,
		ZIndex = 103,
		Parent = MainAction,
	})

	local Title = New("TextLabel", {
		Name = "Title",
		Text = Settings.Title,
		TextSize = 15,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 103,
		ThemeTag = {
			TextColor3 = "Text",
		},
		Parent = TextStack,
	})

	local Description = New("TextLabel", {
		Name = "Content",
		Text = "",
		TextSize = 12,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.fromOffset(0, 35),
		BackgroundTransparency = 1,
		TextTransparency = 0.38,
		Visible = false,
		ZIndex = 103,
		ThemeTag = {
			TextColor3 = "Text",
		},
		Parent = TextStack,
	})

	local TrailingIcon = Creator.Image("chevron-up", "OpenButtonExpand", 0, Window.Folder, "OpenButton", true, true)
	TrailingIcon.Name = "TrailingIcon"
	TrailingIcon.Size = UDim2.fromOffset(15, 15)
	TrailingIcon.Position = UDim2.new(1, -17, 0.5, 0)
	TrailingIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	TrailingIcon.Visible = false
	TrailingIcon.ZIndex = 103
	TrailingIcon.Parent = MainAction
	local TrailingImage = TrailingIcon:FindFirstChildWhichIsA("ImageLabel")
	if TrailingImage then
		TrailingImage.ImageTransparency = 0.48
	end

	local function StopTween(Object)
		local Existing = ActiveTweens[Object]
		if Existing then
			Existing:Cancel()
			ActiveTweens[Object] = nil
		end
	end

	local function Animate(Object, Duration, Properties)
		StopTween(Object)
		if Duration <= 0 then
			for Name, Value in Properties do
				Object[Name] = Value
			end
			return nil
		end

		local Animation = Tween(Object, Duration, Properties, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		ActiveTweens[Object] = Animation
		Animation:Play()
		return Animation
	end

	local function ApplyPosition(Position)
		if typeof(Position) == "UDim2" then
			Container.Position = Position
			Container.AnchorPoint = Vector2.new(0.5, 0.5)
			return
		end

		local Preset = POSITION_PRESETS[tostring(Position or "TopCenter")] or POSITION_PRESETS.TopCenter
		Container.Position = Preset.Position
		Container.AnchorPoint = Preset.AnchorPoint
	end

	local function GetDragWidth(State, Height)
		if not Settings.Draggable or State == "Collapsed" then
			return 0
		end
		return Height
	end

	local function GetTargetSize(State)
		local Height = if State == "Expanded" then Settings.ExpandedHeight else Settings.Height
		if State == "Collapsed" then
			return Vector2.new(Settings.Height, Settings.Height)
		end

		local MaxTextWidth = math.max(Settings.MaxWidth - 120, 80)
		local TitleWidth = MeasureText(Settings.Title, 15, MaxTextWidth)
		local ContentWidth = if State == "Expanded" and Settings.Content
			then MeasureText(Settings.Content, 12, MaxTextWidth)
			else 0
		local TextWidth = math.max(TitleWidth, ContentWidth)
		local DragWidth = GetDragWidth(State, Height)
		local IconWidth = if Icon then Settings.IconSize + Settings.Gap else 0
		local TrailingWidth = if State == "Expanded" then 24 else 0
		local NaturalWidth = DragWidth + (Settings.Padding * 2) + IconWidth + TextWidth + TrailingWidth
		if State == "Expanded" then
			NaturalWidth = math.max(NaturalWidth, Settings.ExpandedWidth)
		end

		return Vector2.new(math.clamp(NaturalWidth, Height, Settings.MaxWidth), Height)
	end

	local function ApplyState(State, AnimateState)
		State = NormalizeState(State)
		local Duration = if AnimateState == false then 0 else 0.28
		local TargetSize = GetTargetSize(State)
		local DragWidth = GetDragWidth(State, TargetSize.Y)
		local ActionPadding = Settings.Padding
		local HasIcon = Icon ~= nil
		local IconOffset = if HasIcon then Settings.IconSize + Settings.Gap else 0
		local TrailingWidth = if State == "Expanded" then 24 else 0

		OpenButtonMain.State = State
		Settings.State = State
		Drag.Visible = DragWidth > 0
		Divider.Visible = DragWidth > 0
		Title.Visible = State ~= "Collapsed"
		Description.Visible = State == "Expanded" and Settings.Content ~= nil and Settings.Content ~= ""
		TrailingIcon.Visible = State == "Expanded"

		Animate(Container, Duration, { Size = UDim2.fromOffset(TargetSize.X, TargetSize.Y) })
		Animate(MainAction, Duration, {
			Size = UDim2.new(1, -DragWidth, 1, 0),
			Position = UDim2.fromOffset(DragWidth, 0),
		})

		Drag.Size = UDim2.fromOffset(math.max(TargetSize.Y - 8, 0), math.max(TargetSize.Y - 8, 0))
		Drag.Position = UDim2.fromOffset(4, 4)
		Divider.Position = UDim2.new(0, DragWidth, 0.5, 0)

		if Icon then
			local IconX = if State == "Collapsed" then TargetSize.X / 2 else ActionPadding + Settings.IconSize / 2
			Animate(Icon, Duration, {
				Position = UDim2.fromOffset(IconX, TargetSize.Y / 2),
				Size = UDim2.fromOffset(Settings.IconSize, Settings.IconSize),
			})
		end

		local TextX = ActionPadding + IconOffset
		TextStack.Position = UDim2.fromOffset(TextX, 0)
		TextStack.Size = UDim2.new(1, -(TextX + ActionPadding + TrailingWidth), 1, 0)
		Title.Size = if Description.Visible then UDim2.new(1, 0, 0, 22) else UDim2.fromScale(1, 1)
		Title.Position = if Description.Visible then UDim2.fromOffset(0, 13) else UDim2.fromOffset(0, 0)
		Description.Text = tostring(Settings.Content or "")

		Creator.SafeCallback(Settings.OnStateChange, State, OpenButtonMain)
	end

	function OpenButtonMain:SetIcon(NewIcon, SkipLayout)
		if Icon then
			Icon:Destroy()
			Icon = nil
		end

		Settings.Icon = NewIcon
		if NewIcon ~= nil and NewIcon ~= false and NewIcon ~= "" then
			Icon = Creator.Image(
				NewIcon,
				Settings.Title .. ":OpenButton",
				0,
				Window.Folder,
				"OpenButton",
				true,
				Window.IconThemed
			)
			Icon.Name = "Icon"
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.ZIndex = 103
			Icon.Parent = MainAction
		end

		if not SkipLayout then
			ApplyState(OpenButtonMain.State, false)
		end
		return OpenButtonMain
	end

	function OpenButtonMain:SetTitle(NewTitle)
		Settings.Title = tostring(NewTitle or "")
		Title.Text = Settings.Title
		Creator:ChangeTranslationKey(Title, Settings.Title)
		ApplyState(OpenButtonMain.State, true)
		return OpenButtonMain
	end

	function OpenButtonMain:SetContent(NewContent)
		Settings.Content = if NewContent == nil or NewContent == false then nil else tostring(NewContent)
		Description.Text = Settings.Content or ""
		ApplyState(OpenButtonMain.State, true)
		return OpenButtonMain
	end

	function OpenButtonMain:SetState(NewState, Changes, AnimateState)
		StateToken = StateToken + 1
		if typeof(Changes) == "table" then
			if Changes.Title ~= nil then
				Settings.Title = tostring(Changes.Title)
				Title.Text = Settings.Title
			end
			if Changes.Content ~= nil or Changes.Description ~= nil then
				local Content = if Changes.Content ~= nil then Changes.Content else Changes.Description
				Settings.Content = if Content == false then nil else tostring(Content or "")
			end
			if Changes.Icon ~= nil then
				OpenButtonMain:SetIcon(Changes.Icon, true)
			end
		end

		ApplyState(NewState, AnimateState)
		return OpenButtonMain
	end

	function OpenButtonMain:GetState()
		return OpenButtonMain.State
	end

	function OpenButtonMain:Expand(Changes, Duration)
		OpenButtonMain:SetState("Expanded", Changes)
		local Token = StateToken
		local Delay = tonumber(Duration) or tonumber(Settings.AutoCollapse)
		if Delay and Delay > 0 then
			task.delay(Delay, function()
				if Token == StateToken and Container.Parent then
					OpenButtonMain:SetState("Compact")
				end
			end)
		end
		return OpenButtonMain
	end

	function OpenButtonMain:Collapse(Changes)
		return OpenButtonMain:SetState("Collapsed", Changes)
	end

	function OpenButtonMain:Compact(Changes)
		return OpenButtonMain:SetState("Compact", Changes)
	end

	function OpenButtonMain:ToggleExpanded(Changes)
		if OpenButtonMain.State == "Expanded" then
			return OpenButtonMain:Compact(Changes)
		end
		return OpenButtonMain:Expand(Changes)
	end

	function OpenButtonMain:Push(Changes, Duration)
		local PreviousState = OpenButtonMain.State
		OpenButtonMain:SetState("Expanded", Changes)
		local Token = StateToken
		local Delay = math.max(tonumber(Duration) or 3, 0)
		task.delay(Delay, function()
			if Token == StateToken and Container.Parent then
				OpenButtonMain:SetState(PreviousState)
			end
		end)
		return OpenButtonMain
	end

	OpenButtonMain.Notify = OpenButtonMain.Push

	function OpenButtonMain:Visible(Value)
		Container.Visible = Value == true
		return OpenButtonMain
	end

	function OpenButtonMain:SetScale(Scale)
		Settings.Scale = math.max(tonumber(Scale) or 1, 0.1)
		OpenButtonMain.Scale = Settings.Scale
		StopTween(UIScale)
		UIScale.Scale = Settings.Scale
		return OpenButtonMain
	end

	function OpenButtonMain:Pulse()
		local BaseScale = Settings.Scale
		Animate(UIScale, 0.08, { Scale = BaseScale * 0.94 })
		task.delay(0.08, function()
			if UIScale.Parent then
				Animate(UIScale, 0.16, { Scale = BaseScale })
			end
		end)
		return OpenButtonMain
	end

	function OpenButtonMain:Edit(Config)
		Config = if typeof(Config) == "table" then Config else {}
		Settings.Title = tostring(Pick(Config.Title, Settings.Title))
		local Content = Pick(Config.Content, Pick(Config.Description, Settings.Content))
		Settings.Content = if Content == false or Content == nil then nil else tostring(Content)
		Settings.Enabled = Pick(Config.Enabled, Settings.Enabled)
		Settings.OnlyMobile = Pick(Config.OnlyMobile, Settings.OnlyMobile)
		Settings.Draggable = Pick(Config.Draggable, Settings.Draggable)
		Settings.Position = Pick(Config.Position, Pick(Config.Preset, Settings.Position))
		Settings.Height = math.max(tonumber(Pick(Config.Height, Settings.Height)) or 44, 34)
		Settings.ExpandedHeight =
			math.max(tonumber(Pick(Config.ExpandedHeight, Settings.ExpandedHeight)) or 68, Settings.Height)
		Settings.ExpandedWidth = math.max(tonumber(Pick(Config.ExpandedWidth, Settings.ExpandedWidth)) or 220, 120)
		Settings.MaxWidth = math.max(tonumber(Pick(Config.MaxWidth, Settings.MaxWidth)) or 380, Settings.ExpandedWidth)
		Settings.IconSize = math.max(tonumber(Pick(Config.IconSize, Settings.IconSize)) or 22, 12)
		Settings.Padding = math.max(tonumber(Pick(Config.Padding, Settings.Padding)) or 12, 4)
		Settings.Gap = math.max(tonumber(Pick(Config.Gap, Settings.Gap)) or 9, 0)
		Settings.CornerRadius = Pick(Config.CornerRadius, Settings.CornerRadius)
		Settings.StrokeThickness = math.max(tonumber(Pick(Config.StrokeThickness, Settings.StrokeThickness)) or 1, 0)
		Settings.StrokeTransparency =
			Creator.ClampTransparency(Pick(Config.StrokeTransparency, Settings.StrokeTransparency), 0.7)
		Settings.Scale = math.max(tonumber(Pick(Config.Scale, Settings.Scale)) or 1, 0.1)
		Settings.Color = NormalizeColorSequence(Config.Color, Settings.Color)
		Settings.BackgroundColor = Pick(Config.BackgroundColor, Settings.BackgroundColor)
		Settings.BackgroundTransparency = Creator.ClampTransparency(
			Pick(Config.BackgroundTransparency, Pick(Config.Transparency, Settings.BackgroundTransparency)),
			0.08
		)
		Settings.TextColor = Pick(Config.TextColor, Settings.TextColor)
		Settings.TextTransparency = Creator.ClampTransparency(
			Pick(Config.TextTransparency, Settings.TextTransparency),
			Settings.TextTransparency
		)
		Settings.AutoCollapse = Pick(Config.AutoCollapse, Settings.AutoCollapse)
		Settings.OnStateChange = Pick(Config.OnStateChange, Settings.OnStateChange)

		local RequestedState = Config.State or Config.Mode
		if Config.OnlyIcon == true or Config.Style == "Circle" then
			RequestedState = RequestedState or "Collapsed"
		elseif Config.OnlyIcon == false and RequestedState == nil then
			RequestedState = "Compact"
		end

		Window.IsOpenButtonEnabled = Settings.Enabled ~= false
		if Settings.OnlyMobile == false then
			Window.IsPC = false
		end
		if DragModule then
			DragModule:Set(Settings.Draggable)
		end

		ApplyPosition(Settings.Position)
		OpenButtonMain:SetScale(Settings.Scale)
		Button.BackgroundColor3 = Settings.BackgroundColor
		Button.BackgroundTransparency = Settings.BackgroundTransparency
		Button.UICorner.CornerRadius = Settings.CornerRadius
		MainAction.UICorner.CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4)
		HoverSurface.UICorner.CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4)
		Shadow.UICorner.CornerRadius = Settings.CornerRadius
		Stroke.Thickness = Settings.StrokeThickness
		Stroke.Transparency = Settings.StrokeTransparency
		StrokeGradient.Color = Settings.Color
		Title.Text = Settings.Title
		Description.Text = tostring(Settings.Content or "")
		if Settings.TextColor then
			Title.TextColor3 = Settings.TextColor
			Description.TextColor3 = Settings.TextColor
		end
		if Settings.TextTransparency ~= nil then
			Title.TextTransparency = Settings.TextTransparency
		end

		if Config.Icon ~= nil then
			OpenButtonMain:SetIcon(Config.Icon, true)
		elseif not Icon and Settings.Icon then
			OpenButtonMain:SetIcon(Settings.Icon, true)
		end

		ApplyState(RequestedState or OpenButtonMain.State, Config.Animate ~= false)
		if Config.Visible ~= nil then
			OpenButtonMain:Visible(Config.Visible)
		end
		return OpenButtonMain
	end

	function OpenButtonMain:Destroy()
		StateToken = StateToken + 1
		local Objects = {}
		for Object in ActiveTweens do
			table.insert(Objects, Object)
		end
		for _, Object in Objects do
			StopTween(Object)
		end
		Container:Destroy()
	end

	Creator.AddSignal(MainAction.MouseEnter, function()
		Animate(HoverSurface, 0.12, { BackgroundTransparency = 0.94 })
	end)
	Creator.AddSignal(MainAction.MouseLeave, function()
		Animate(HoverSurface, 0.16, { BackgroundTransparency = 1 })
	end)
	Creator.AddSignal(MainAction.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			OpenButtonMain:Pulse()
		end
	end)

	DragModule = Creator.Drag(Container)
	OpenButtonMain.Button = Button
	OpenButtonMain.Container = Container
	OpenButtonMain.UIElements = {
		Container = Container,
		Button = Button,
		MainAction = MainAction,
		Drag = Drag,
		Divider = Divider,
		Title = Title,
		Content = Description,
		TextStack = TextStack,
		HoverSurface = HoverSurface,
		TrailingIcon = TrailingIcon,
		Stroke = Stroke,
		Shadow = Shadow,
		Scale = UIScale,
	}

	if Settings.Icon then
		OpenButtonMain:SetIcon(Settings.Icon)
	else
		ApplyState(Settings.State, false)
	end

	return OpenButtonMain
end

return OpenButton
