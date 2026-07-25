local cloneref = require("../utils/cloneref")

local UserInputService = cloneref(game:GetService("UserInputService"))

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./ModernControlUtils")

local Element = {}

local function ReadValueConfig(Config)
	local ValueConfig = typeof(Config.Value) == "table" and Config.Value or {}
	local Min = Utils.ToFiniteNumber(ValueConfig.Min) or Utils.ToFiniteNumber(Config.Min) or 0
	local Max = Utils.ToFiniteNumber(ValueConfig.Max) or Utils.ToFiniteNumber(Config.Max) or 100

	if Min > Max then
		Min, Max = Max, Min
	end

	local Default = typeof(Config.Value) == "number" and Config.Value
		or Utils.ToFiniteNumber(ValueConfig.Default)
		or Utils.ToFiniteNumber(Config.Default)
		or Min
	local Increment = Utils.ToFiniteNumber(ValueConfig.Increment) or Utils.ToFiniteNumber(Config.Increment) or 1

	return Min, Max, math.clamp(Utils.ToFiniteNumber(Default) or Min, Min, Max), math.max(math.abs(Increment), 0.0001)
end

function Element:New(Config)
	local Min, Max, Default, Increment = ReadValueConfig(Config)
	local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local ShowButtons = Config.Buttons ~= false and Config.ShowButtons ~= false
	local ButtonSize = IsMobile and 38 or 34
	local ControlHeight = IsMobile and 40 or 36
	local MinWidth = ShowButtons and 164 or 128

	local Stepper = {
		__type = "Stepper",
		Title = Config.Title or "Stepper",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Value = {
			Min = Min,
			Max = Max,
			Default = Default,
			Increment = Increment,
		},
		Callback = Config.Callback or function() end,
		Format = Config.Format,
		UIElements = {},
		Animation = Config.Animation ~= false,
		Draggable = Config.Draggable ~= false,
		ShowButtons = ShowButtons,
		Width = math.max(
			Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or (IsMobile and 188 or 176),
			MinWidth
		),
	}

	local CanCallback = true

	Stepper.StepperFrame = require("../components/window/Element")({
		Title = Stepper.Title,
		Desc = Stepper.Desc,
		Parent = Config.Parent,
		TextOffset = Stepper.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Stepper,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local function FormatValue(Value)
		if typeof(Stepper.Format) == "function" then
			local Success, Result = pcall(Stepper.Format, Value, Stepper.Value.Min, Stepper.Value.Max)
			if Success and Result ~= nil then
				return tostring(Result)
			end
		end

		return Utils.FormatNumber(Value)
	end

	local function GetRange()
		return math.max(Stepper.Value.Max - Stepper.Value.Min, Stepper.Value.Increment)
	end

	local function SnapValue(Value)
		local Number = Utils.ToFiniteNumber(Value)
		if Number == nil then
			return Stepper.Value.Default
		end

		local Steps = math.floor(((Number - Stepper.Value.Min) / Stepper.Value.Increment) + 0.5)
		local Snapped = Stepper.Value.Min + (Steps * Stepper.Value.Increment)
		return math.clamp(Snapped, Stepper.Value.Min, Stepper.Value.Max)
	end

	local function ValueToDelta(Value)
		return math.clamp((Value - Stepper.Value.Min) / GetRange(), 0, 1)
	end

	local function CreateIconButton(Name, IconName)
		local IconInfo = Creator.Icon(IconName)
		local Icon = New("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = IconInfo[1],
			ImageRectOffset = IconInfo[2].ImageRectPosition,
			ImageRectSize = IconInfo[2].ImageRectSize,
			ThemeTag = {
				ImageColor3 = "StepperIcon",
			},
		})

		local Button = Creator.NewRoundFrame(12, "Squircle", {
			Name = Name,
			Size = UDim2.fromOffset(ButtonSize, ButtonSize),
			ImageTransparency = 0.88,
			ThemeTag = {
				ImageColor3 = "StepperButton",
			},
		}, {
			Icon,
		}, true)

		return Button, Icon
	end

	local MinusButton, MinusIcon
	local PlusButton, PlusIcon
	if Stepper.ShowButtons then
		MinusButton, MinusIcon = CreateIconButton("Minus", "minus")
		PlusButton, PlusIcon = CreateIconButton("Plus", "plus")

		Motion.AttachPress(MinusButton, Creator, {
			Amount = 0.94,
			Enabled = function()
				return Stepper.Animation and not Stepper.Locked and Stepper.Value.Default > Stepper.Value.Min
			end,
		})
		Motion.AttachPress(PlusButton, Creator, {
			Amount = 0.94,
			Enabled = function()
				return Stepper.Animation and not Stepper.Locked and Stepper.Value.Default < Stepper.Value.Max
			end,
		})
	end

	local TrackFill = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Fill",
		Size = UDim2.new(ValueToDelta(Stepper.Value.Default), 0, 1, 0),
		ImageTransparency = 0.12,
		ThemeTag = {
			ImageColor3 = "Primary",
		},
	})

	local TrackThumb = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Thumb",
		Size = UDim2.fromOffset(9, 9),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(ValueToDelta(Stepper.Value.Default), 0, 0.5, 0),
		ImageTransparency = 0,
		ThemeTag = {
			ImageColor3 = "SliderThumb",
		},
	})

	local Track = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Track",
		Size = UDim2.new(1, -18, 0, 4),
		Position = UDim2.new(0.5, 0, 1, -7),
		AnchorPoint = Vector2.new(0.5, 1),
		ImageTransparency = 0.88,
		ThemeTag = {
			ImageColor3 = "Text",
		},
	}, {
		TrackFill,
		TrackThumb,
	})

	Stepper.UIElements.ValueLabel = New("TextLabel", {
		Name = "Value",
		Size = UDim2.new(1, -18, 1, -10),
		Position = UDim2.new(0.5, 0, 0, 1),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Text = FormatValue(Stepper.Value.Default),
		TextSize = IsMobile and 15 or 14,
		TextTruncate = "AtEnd",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		ThemeTag = {
			TextColor3 = "StepperText",
		},
	})

	local ButtonSpace = Stepper.ShowButtons and ((ButtonSize * 2) + 10) or 0
	local ValueBackground = Creator.NewRoundFrame(12, "Squircle", {
		Name = "ValueBackground",
		Size = UDim2.new(1, -ButtonSpace, 0, ControlHeight),
		ImageTransparency = 0.92,
		Active = true,
		ClipsDescendants = true,
		ThemeTag = {
			ImageColor3 = "StepperValueBackground",
		},
	}, {
		Stepper.UIElements.ValueLabel,
		Track,
	}, true)

	Stepper.UIElements.Track = Track
	Stepper.UIElements.TrackFill = TrackFill
	Stepper.UIElements.TrackThumb = TrackThumb
	Stepper.UIElements.ValueBackground = ValueBackground

	Stepper.UIElements.Container = New("Frame", {
		Name = "Stepper",
		Size = UDim2.new(0, Stepper.Width, 0, ControlHeight),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = Stepper.StepperFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 5),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Right",
			VerticalAlignment = "Center",
		}),
		MinusButton,
		ValueBackground,
		PlusButton,
	})

	local function SetProgressVisual(Value, IsAnimated)
		local Delta = ValueToDelta(Value)
		local FillSize = UDim2.new(Delta, 0, 1, 0)
		local ThumbPosition = UDim2.new(Delta, 0, 0.5, 0)

		if IsAnimated and Stepper.Animation then
			Motion.Play(TrackFill, "Fast", { Size = FillSize }, nil, nil, "StepperFill")
			Motion.Play(TrackThumb, "Fast", { Position = ThumbPosition }, nil, nil, "StepperThumb")
		else
			TrackFill.Size = FillSize
			TrackThumb.Position = ThumbPosition
		end
	end

	local function UpdateButtonStates(IsAnimated)
		if not Stepper.ShowButtons then
			return
		end

		local AtMin = Stepper.Value.Default <= Stepper.Value.Min
		local AtMax = Stepper.Value.Default >= Stepper.Value.Max
		local MinusTransparency = AtMin and 0.62 or 0
		local PlusTransparency = AtMax and 0.62 or 0
		local MinusButtonTransparency = AtMin and 0.94 or 0.88
		local PlusButtonTransparency = AtMax and 0.94 or 0.88

		if IsAnimated and Stepper.Animation then
			Motion.Play(MinusIcon, "Fast", { ImageTransparency = MinusTransparency }, nil, nil, "State")
			Motion.Play(PlusIcon, "Fast", { ImageTransparency = PlusTransparency }, nil, nil, "State")
			Motion.Play(MinusButton, "Fast", { ImageTransparency = MinusButtonTransparency }, nil, nil, "State")
			Motion.Play(PlusButton, "Fast", { ImageTransparency = PlusButtonTransparency }, nil, nil, "State")
		else
			MinusIcon.ImageTransparency = MinusTransparency
			PlusIcon.ImageTransparency = PlusTransparency
			MinusButton.ImageTransparency = MinusButtonTransparency
			PlusButton.ImageTransparency = PlusButtonTransparency
		end
	end

	local function UpdateValue(Value, IsCallback, Snap)
		local Number = Utils.ToFiniteNumber(Value)
		if Number == nil then
			return Stepper.Value.Default
		end

		local PreviousValue = Stepper.Value.Default
		Stepper.Value.Default = Snap == false and math.clamp(Number, Stepper.Value.Min, Stepper.Value.Max)
			or SnapValue(Number)
		Stepper.UIElements.ValueLabel.Text = FormatValue(Stepper.Value.Default)
		SetProgressVisual(Stepper.Value.Default, true)
		UpdateButtonStates(true)

		if Stepper.Animation and PreviousValue ~= Stepper.Value.Default then
			Motion.Play(ValueBackground, "Fast", { ImageTransparency = 0.86 }, nil, nil, "Pulse")
			task.delay(Motion.GetDuration("Fast"), function()
				if ValueBackground.Parent then
					Motion.Play(ValueBackground, "Select", { ImageTransparency = 0.92 }, nil, nil, "Pulse")
				end
			end)
		end

		if CanCallback and IsCallback ~= false and PreviousValue ~= Stepper.Value.Default then
			Creator.SafeCallback(Stepper.Callback, Stepper.Value.Default)
		end

		return Stepper.Value.Default
	end

	function Stepper:Lock()
		Stepper.Locked = true
		CanCallback = false
		UpdateButtonStates(true)
		return Stepper.StepperFrame:Lock(Stepper.LockedTitle)
	end
	function Stepper:Unlock()
		Stepper.Locked = false
		CanCallback = true
		UpdateButtonStates(true)
		return Stepper.StepperFrame:Unlock()
	end

	function Stepper:Get()
		return Stepper.Value.Default
	end

	function Stepper:Set(Value, IsCallback)
		return UpdateValue(Value, IsCallback)
	end

	function Stepper:SetRange(NewMin, NewMax)
		NewMin = Utils.ToFiniteNumber(NewMin)
		NewMax = Utils.ToFiniteNumber(NewMax)

		if NewMin == nil or NewMax == nil then
			return Stepper.Value.Min, Stepper.Value.Max
		end

		if NewMin > NewMax then
			NewMin, NewMax = NewMax, NewMin
		end

		Stepper.Value.Min = NewMin
		Stepper.Value.Max = NewMax
		UpdateValue(Stepper.Value.Default, false)

		return Stepper.Value.Min, Stepper.Value.Max
	end

	function Stepper:SetMin(NewMin)
		Stepper:SetRange(NewMin, math.max(Utils.ToFiniteNumber(NewMin) or Stepper.Value.Min, Stepper.Value.Max))
		return Stepper.Value.Min
	end

	function Stepper:SetMax(NewMax)
		Stepper:SetRange(math.min(Stepper.Value.Min, Utils.ToFiniteNumber(NewMax) or Stepper.Value.Max), NewMax)
		return Stepper.Value.Max
	end

	local CurInput = Config.WindUI.GenerateGUID()
	local ActiveInput
	local MoveConnection
	local ReleaseConnection
	local ScrollingFrameParent = Config.Tab and Config.Tab.UIElements and Config.Tab.UIElements.ContainerFrame

	local function DisconnectDrag()
		local WasDragging = ActiveInput ~= nil
			or MoveConnection ~= nil
			or ReleaseConnection ~= nil
			or Config.WindUI.CurrentInput == CurInput

		if MoveConnection then
			Creator.DisconnectSignal(MoveConnection)
			MoveConnection = nil
		end
		if ReleaseConnection then
			Creator.DisconnectSignal(ReleaseConnection)
			ReleaseConnection = nil
		end
		if WasDragging and ScrollingFrameParent then
			ScrollingFrameParent.ScrollingEnabled = true
		end
		if Config.WindUI.CurrentInput == CurInput then
			Config.WindUI.CurrentInput = nil
		end
		ActiveInput = nil
		if WasDragging and Stepper.Animation then
			Motion.Play(TrackThumb, "Focus", { Size = UDim2.fromOffset(9, 9) }, nil, nil, "StepperDrag")
		end
	end

	local function GetInputX(Input)
		if Input.UserInputType == Enum.UserInputType.Touch then
			return Input.Position.X
		end
		return UserInputService:GetMouseLocation().X
	end

	local function UpdateFromInput(Input)
		if not Track or Track.AbsoluteSize.X <= 0 then
			return
		end

		local Delta = math.clamp((GetInputX(Input) - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		local NextValue = Stepper.Value.Min + (Delta * GetRange())
		UpdateValue(NextValue, true)
	end

	if Stepper.ShowButtons then
		Creator.AddSignal(MinusButton.MouseButton1Click, function()
			if not Stepper.Locked then
				Stepper:Set(Stepper.Value.Default - Stepper.Value.Increment)
			end
		end)
		Creator.AddSignal(PlusButton.MouseButton1Click, function()
			if not Stepper.Locked then
				Stepper:Set(Stepper.Value.Default + Stepper.Value.Increment)
			end
		end)
	end

	Creator.AddSignal(ValueBackground.InputBegan, function(Input)
		if Stepper.Locked or not Stepper.Draggable or ActiveInput then
			return
		end
		if
			Input.UserInputType ~= Enum.UserInputType.MouseButton1
			and Input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end
		if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
			return
		end

		Config.WindUI.CurrentInput = CurInput
		ActiveInput = Input
		if ScrollingFrameParent then
			ScrollingFrameParent.ScrollingEnabled = false
		end
		if Stepper.Animation then
			Motion.Play(TrackThumb, "Focus", { Size = UDim2.fromOffset(13, 13) }, nil, nil, "StepperDrag")
		end
		UpdateFromInput(Input)

		MoveConnection = Creator.AddSignal(UserInputService.InputChanged, function(ChangedInput)
			if not ActiveInput then
				return
			end
			if ActiveInput.UserInputType == Enum.UserInputType.Touch and ChangedInput ~= ActiveInput then
				return
			end
			if
				ActiveInput.UserInputType == Enum.UserInputType.MouseButton1
				and ChangedInput.UserInputType ~= Enum.UserInputType.MouseMovement
			then
				return
			end
			UpdateFromInput(ChangedInput)
		end)

		ReleaseConnection = Creator.AddSignal(UserInputService.InputEnded, function(EndedInput)
			if not ActiveInput then
				return
			end
			local ReleasedTouch = ActiveInput.UserInputType == Enum.UserInputType.Touch and EndedInput == ActiveInput
			local ReleasedMouse = ActiveInput.UserInputType == Enum.UserInputType.MouseButton1
				and EndedInput.UserInputType == Enum.UserInputType.MouseButton1
			if ReleasedTouch or ReleasedMouse then
				DisconnectDrag()
			end
		end)
	end)

	function Stepper:Cleanup()
		DisconnectDrag()
	end

	UpdateButtonStates(false)
	SetProgressVisual(Stepper.Value.Default, false)

	if Stepper.Locked then
		Stepper:Lock()
	end

	return Stepper.__type, Stepper
end

return Element
