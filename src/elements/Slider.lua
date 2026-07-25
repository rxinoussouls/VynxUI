local cloneref = require("../utils/cloneref")
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local Slider = {
		__type = "Slider",
		Title = Config.Title or nil,
		Desc = Config.Desc or nil,
		Locked = Config.Locked or nil,
		LockedTitle = Config.LockedTitle,
		Value = Config.Value or {
        Min = Config.Min or 0,
        Max = Config.Max or 100,
        Default = Config.Default or Config.Min or 0,},
		Icons = Config.Icons or nil,
		IsTooltip = Config.IsTooltip or false,
		IsTextbox = Config.IsTextbox,
		Step = Config.Step or 1, -- Can be 1, 0.5, 0.1, 0.01, etc.
		Callback = Config.Callback or function() end,
		UIElements = {},
		IsFocusing = false,

		Width = Config.Width or 130,
		TextBoxWidth = Config.Window.NewElements and 40 or 30,
		ThumbSize = 13,
		IconSize = 26,
	}
	if typeof(Slider.Icons) == "table" and next(Slider.Icons) == nil then
		Slider.Icons = {
			From = "sfsymbols:sunMinFill",
			To = "sfsymbols:sunMaxFill",
		}
	end
	if Slider.IsTextbox == nil and Slider.Title == nil then
		Slider.IsTextbox = false
	else
		Slider.IsTextbox = Slider.IsTextbox ~= false
	end

	local isTouch
	local moveconnection
	local releaseconnection
	local IsSliderHolding = false
	Slider.Value.Min = Slider.Value.Min or 0
    Slider.Value.Max = Slider.Value.Max or 100
    Slider.Value.Default = Slider.Value.Default or Slider.Value.Min

local Value = Slider.Value.Default

	local LastValue = Value
	local delta = (Value - (Slider.Value.Min or 0)) / ((Slider.Value.Max or 100) - (Slider.Value.Min or 0))

	local CanCallback = true

	local IsFloat = Slider.Step % 1 ~= 0  -- True if Step is 0.1, 0.5, etc.
	local DecimalPlaces = 0
	if IsFloat then
		-- Count decimal places from Step (e.g., 0.1 → 1, 0.01 → 2)
		local stepStr = tostring(Slider.Step)
		local dotIndex = stepStr:find("%.")
		if dotIndex then
			DecimalPlaces = #stepStr:sub(dotIndex + 1)
		end
	end

	local function FormatValue(val)
		if IsFloat then
			-- Round to the correct number of decimal places
			local multiplier = 10 ^ DecimalPlaces
			return tonumber(string.format("%." .. DecimalPlaces .. "f", math.round(val * multiplier) / multiplier))
		end
		return math.floor(val + 0.5)
	end

	local function CalculateValue(rawValue)
		if IsFloat then
			-- Snap to nearest Step (e.g., 0.1, 0.5, etc.)
			local multiplier = 10 ^ DecimalPlaces
			return math.round(rawValue / Slider.Step) * Slider.Step
		else
			return math.floor(rawValue / Slider.Step + 0.5) * Slider.Step
		end
	end

	-- Math Round helper (Luau 5.1 doesn't have this Natively)
	local function round(num)
		return math.floor(num + 0.5)
	end
	-- Override math.round if it doesn't exist
	if not math.round then
		math.round = round
	end

	local IconFrom, IconTo
	local TotalSliderWidth = 32
	if Slider.Icons then
		if Slider.Icons.From then
			IconFrom = Creator.Image(
				Slider.Icons.From,
				Slider.Icons.From,
				0,
				Config.Window.Folder,
				"SliderIconFrom",
				true,
				true,
				"SliderIconFrom"
			)
			IconFrom.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
			TotalSliderWidth = TotalSliderWidth + Slider.IconSize - 2
		end
		if Slider.Icons.To then
			IconTo = Creator.Image(
				Slider.Icons.To,
				Slider.Icons.To,
				0,
				Config.Window.Folder,
				"SliderIconTo",
				true,
				true,
				"SliderIconTo"
			)
			IconTo.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
			TotalSliderWidth = TotalSliderWidth + Slider.IconSize - 2
		end
	end
	Slider.SliderFrame = require("../components/window/Element")({
		Title = Slider.Title,
		Desc = Slider.Desc,
		Parent = Config.Parent,
		TextOffset = Slider.Width,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Slider,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Slider.UIElements.SliderIcon = Creator.NewRoundFrame(99, "Squircle", {
		ImageTransparency = 0.95,
		Size = UDim2.new(1, not Slider.IsTextbox and -TotalSliderWidth or (-Slider.TextBoxWidth - 8), 0, 4),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Name = "Frame",
		ThemeTag = {
			ImageColor3 = "Text",
		},
	}, {
		Creator.NewRoundFrame(99, "Squircle", {
			Name = "Frame",
			Size = UDim2.new(delta, 0, 1, 0),
			ImageTransparency = 0.1,
			ThemeTag = {
				ImageColor3 = "Slider",
			},
		}, {
			Creator.NewRoundFrame(99, "Squircle", {
				Size = UDim2.new(
					0,
					Config.Window.NewElements and (Slider.ThumbSize * 2) or (Slider.ThumbSize + 2),
					0,
					Config.Window.NewElements and (Slider.ThumbSize + 4) or (Slider.ThumbSize + 2)
				),
				Position = UDim2.new(1, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ThemeTag = {
					ImageColor3 = "SliderThumb",
				},
				Name = "Thumb",
			}, {
				Creator.NewRoundFrame(999, "SquircleGlass", {
					Size = UDim2.new(1, 0, 1, 0),
					ImageColor3 = Color3.new(1, 1, 1),
					Name = "Highlight",
					ImageTransparency = 0.5,
				}),
			}),
		}),
	})

	Slider.UIElements.SliderContainer = New("Frame", {
		Size = UDim2.new(Slider.Title == nil and 1 or 0, Slider.Title == nil and 0 or Slider.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, Slider.IsTextbox and (Config.Window.NewElements and -12 - 4 or 0) or 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Parent = Slider.SliderFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Slider.Title ~= nil and 8 or 12),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = Slider.Icons
					and (Slider.Icons.From and (Slider.Icons.To and "Center" or "Left") or Slider.Icons.To and "Right")
				or "Center",
		}),
		IconFrom,
		Slider.UIElements.SliderIcon,
		IconTo,
		New("TextBox", {
			Size = UDim2.new(0, Slider.TextBoxWidth, 0, 0),
			TextXAlignment = "Left",
			Text = FormatValue(Value),
			ThemeTag = {
				TextColor3 = "Text",
			},
			TextTransparency = 0.4,
			AutomaticSize = "Y",
			TextSize = 15,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Visible = Slider.IsTextbox,
		}),
	})

	local Tooltip
	if Slider.IsTooltip then
		Tooltip = require("../components/ui/Tooltip").New(
			Value,
			Slider.UIElements.SliderIcon.Frame.Thumb,
			true,
			"Secondary",
			"Small",
			false
		)
		Tooltip.Container.AnchorPoint = Vector2.new(0.5, 1)
		Tooltip.Container.Position = UDim2.new(0.5, 0, 0, -8)
	end

	local function SetFillSize(Delta, Duration)
		local Size = UDim2.new(Delta, 0, 1, 0)
		if Duration == 0 or not Motion.ShouldAnimate(Config) then
			Slider.UIElements.SliderIcon.Frame.Size = Size
		else
			Motion.Play(Slider.UIElements.SliderIcon.Frame, Duration or "Fast", { Size = Size }, nil, nil, "Fill")
		end
	end

	function Slider:Lock()
		Slider.Locked = true
		CanCallback = false
		return Slider.SliderFrame:Lock(Slider.LockedTitle)
	end
	function Slider:Unlock()
		Slider.Locked = false
		CanCallback = true
		return Slider.SliderFrame:Unlock()
	end

	if Slider.Locked then
		Slider:Lock()
	end

	local ScrollingFrameParent = Config.Tab.UIElements.ContainerFrame
	local CurInput = Config.WindUI.GenerateGUID()

	local function DisconnectSliderInput()
		local WasHolding = IsSliderHolding
			or moveconnection ~= nil
			or releaseconnection ~= nil
			or Config.WindUI.CurrentInput == CurInput

		if moveconnection then
			Creator.DisconnectSignal(moveconnection)
			moveconnection = nil
		end
		if releaseconnection then
			Creator.DisconnectSignal(releaseconnection)
			releaseconnection = nil
		end

		IsSliderHolding = false
		if WasHolding then
			ScrollingFrameParent.ScrollingEnabled = true
		end
		if Config.WindUI.CurrentInput == CurInput then
			Config.WindUI.CurrentInput = nil
		end
	end

	local function FinishSliderInput()
		local WasHolding = IsSliderHolding
		DisconnectSliderInput()
		if not WasHolding then
			return
		end

		if Config.Window.NewElements then
			Motion.Play(Slider.UIElements.SliderIcon.Frame.Thumb, "Focus", {
				ImageTransparency = 0,
				Size = UDim2.new(
					0,
					Config.Window.NewElements and (Slider.ThumbSize * 2) or (Slider.ThumbSize + 2),
					0,
					Config.Window.NewElements and (Slider.ThumbSize + 4) or (Slider.ThumbSize + 2)
				),
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Thumb")
		end
		if Tooltip then
			Tooltip:Close(false)
		end
	end
function Slider:Set(Value, input)
    local self = Slider  -- alias

    if not self.Value then
        self.Value = { Min = 0, Max = 100, Default = 0 }
    end

    local min = self.Value.Min or 0
    local max = self.Value.Max or 100
    self.Value.Min = min
    self.Value.Max = max

    if Value == nil then
        Value = self.Value.Default or min
    end

    local step = self.Step or 1
    self.Step = step

    local isFloat = step % 1 ~= 0
    local decimalPlaces = 0
    if isFloat then
        local stepStr = tostring(step)
        local dotIdx = stepStr:find("%.")
        if dotIdx then
            decimalPlaces = #stepStr:sub(dotIdx + 1)
        end
    end

    local function formatValue(val)
        if isFloat then
            local mult = 10 ^ decimalPlaces
            return tonumber(string.format("%." .. decimalPlaces .. "f", math.floor(val * mult + 0.5) / mult))
        else
            return math.floor(val + 0.5)
        end
    end

    local function snapValue(raw)
        if isFloat then
            local mult = 10 ^ decimalPlaces
            return math.floor(raw / step + 0.5) * step
        else
            return math.floor(raw / step + 0.5) * step
        end
    end

    local uiReady = self.UIElements
        and self.UIElements.SliderIcon
        and self.UIElements.SliderIcon.AbsolutePosition
        and self.UIElements.SliderIcon.AbsoluteSize
        and self.UIElements.SliderIcon.AbsoluteSize.X > 0

    if not CanCallback then return end
    if self.IsFocusing then return end
    if IsSliderHolding then return end

    if input and not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        input = nil
    end
    if input then
        -- Drag input – requires UI to be ready
        if not uiReady then
            warn("Slider:Set – UI not ready for drag, skipping")
            return
        end

        isTouch = (input.UserInputType == Enum.UserInputType.Touch)
        ScrollingFrameParent.ScrollingEnabled = false
        IsSliderHolding = true

        -- SAFE FALLBACKS ADDED HERE:
        local inputX = isTouch and (input.Position and input.Position.X or 0) or (UserInputService and UserInputService:GetMouseLocation().X or 0)
        local iconPos = (self.UIElements and self.UIElements.SliderIcon and self.UIElements.SliderIcon.AbsolutePosition) and self.UIElements.SliderIcon.AbsolutePosition.X or 0
        local iconSize = (self.UIElements and self.UIElements.SliderIcon and self.UIElements.SliderIcon.AbsoluteSize) and self.UIElements.SliderIcon.AbsoluteSize.X or 1

        local delta = iconSize > 0 and math.clamp((inputX - iconPos) / iconSize, 0, 1) or 0

        local rawValue = min + delta * (max - min)
        Value = snapValue(rawValue)
        Value = math.clamp(Value, min, max)

        if Value ~= LastValue then
            SetFillSize(delta, 0)
            self.UIElements.SliderContainer.TextBox.Text = formatValue(Value)
            if Tooltip then
                Tooltip.TitleFrame.Text = formatValue(Value)
            end
            self.Value.Default = formatValue(Value)
            LastValue = Value
            Creator.SafeCallback(self.Callback, formatValue(Value))
        end

        -- RenderStepped update
        moveconnection = Creator.AddSignal(RunService.RenderStepped, function()
            if not uiReady then return end
            -- SAFE FALLBACKS ADDED HERE TOO:
            local inputX = isTouch and (input.Position and input.Position.X or 0) or (UserInputService and UserInputService:GetMouseLocation().X or 0)
            local iconPos = (self.UIElements and self.UIElements.SliderIcon and self.UIElements.SliderIcon.AbsolutePosition) and self.UIElements.SliderIcon.AbsolutePosition.X or 0
            local iconSize = (self.UIElements and self.UIElements.SliderIcon and self.UIElements.SliderIcon.AbsoluteSize) and self.UIElements.SliderIcon.AbsoluteSize.X or 1

            local delta = iconSize > 0 and math.clamp((inputX - iconPos) / iconSize, 0, 1) or 0
            local rawValue = min + delta * (max - min)
            Value = snapValue(rawValue)
            if Value ~= LastValue then
                SetFillSize(delta, 0)
                self.UIElements.SliderContainer.TextBox.Text = formatValue(Value)
                if Tooltip then
                    Tooltip.TitleFrame.Text = formatValue(Value)
                end
                self.Value.Default = formatValue(Value)
                LastValue = Value
                Creator.SafeCallback(self.Callback, formatValue(Value))
            end
        end)

        releaseconnection = Creator.AddSignal(UserInputService.InputEnded, function(endInput)
            local isTouchRelease = input.UserInputType == Enum.UserInputType.Touch and endInput == input
            local isMouseRelease = input.UserInputType == Enum.UserInputType.MouseButton1
                and endInput.UserInputType == Enum.UserInputType.MouseButton1
            if isTouchRelease or isMouseRelease then
                FinishSliderInput()
            end
        end)
    else
        -- Programmatic set (no input) – safe even without UI
        Value = math.clamp(Value, min, max)
        if typeof(Value) ~= "number" then
    Value = min
end

local range = max - min
local delta = range ~= 0 and ((Value - min) / range) or 0
        Value = snapValue(Value)

        if Value ~= LastValue then
            SetFillSize(delta, "Fast")
            self.UIElements.SliderContainer.TextBox.Text = formatValue(Value)
            if Tooltip then
                Tooltip.TitleFrame.Text = formatValue(Value)
            end
            self.Value.Default = formatValue(Value)
            LastValue = Value
            Creator.SafeCallback(self.Callback, formatValue(Value))
        end
    end
end
	function Slider:SetMax(newMax)
		newMax = newMax or 100
		Slider.Value.Max = newMax

		local minVal = Slider.Value.Min or 0
		local currentValue = tonumber(Slider.Value.Default) or LastValue or minVal

		if currentValue > newMax then
			Slider:Set(newMax)
		else
			local range = newMax - minVal
			local newDelta = range ~= 0 and math.clamp((currentValue - minVal) / range, 0, 1) or 0
			SetFillSize(newDelta, "Fast")
		end
	end

	function Slider:SetMin(newMin)
		newMin = newMin or 0
		Slider.Value.Min = newMin

		local maxVal = Slider.Value.Max or 100
		local currentValue = tonumber(Slider.Value.Default) or LastValue or newMin

		if currentValue < newMin then
			Slider:Set(newMin)
		else
			local range = maxVal - newMin
			local newDelta = range ~= 0 and math.clamp((currentValue - newMin) / range, 0, 1) or 0
			SetFillSize(newDelta, "Fast")
		end
	end

	--  UPDATED: TextBox FocusLost – accepts decimal input
	Creator.AddSignal(Slider.UIElements.SliderContainer.TextBox.FocusLost, function(enterPressed)
		local newValue = tonumber(Slider.UIElements.SliderContainer.TextBox.Text)
		if newValue then
			-- Clamp to Min/Max
			newValue = math.clamp(newValue, Slider.Value.Min, Slider.Value.Max)
			Slider:Set(newValue)
		else
			Slider.UIElements.SliderContainer.TextBox.Text = FormatValue(LastValue)
			if Tooltip then
				Tooltip.TitleFrame.Text = FormatValue(LastValue)
			end
		end
	end)

	Creator.AddSignal(Slider.UIElements.SliderContainer.InputBegan, function(input)
		if Slider.Locked or IsSliderHolding then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
				return
			end
			Config.WindUI.CurrentInput = CurInput

			Slider:Set(Value, input)

			if Config.Window.NewElements then
				Motion.Play(Slider.UIElements.SliderIcon.Frame.Thumb, "Focus", {
					ImageTransparency = 0.85,
					Size = UDim2.new(
						0,
						(Config.Window.NewElements and (Slider.ThumbSize * 2) or Slider.ThumbSize) + 8,
						0,
						Slider.ThumbSize + 8
					),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Thumb")
			end
			if Tooltip then
				Tooltip:Open()
			end
		end
	end)

	function Slider:Cleanup()
		DisconnectSliderInput()
		if Tooltip then
			Tooltip:Close(false)
		end
	end

	return Slider.__type, Slider
end

return Element
