local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./ModernControlUtils")

local Element = {}

local function GetControlWidth(Config)
	return math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or 220, 120)
end

function Element:New(Config)
	local RadioGroup = {
		__type = "RadioGroup",
		Title = Config.Title or "Radio Group",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Options = Utils.NormalizeOptions(Config.Options or Config.Values or {}),
		Value = Config.Value,
		AllowNone = Config.AllowNone == true,
		Callback = Config.Callback or function() end,
		UIElements = {},
		OptionFrames = {},
		Animation = Config.Animation ~= false,

		Width = GetControlWidth(Config),
	}

	if RadioGroup.Value == nil then
		RadioGroup.Value = Config.Default
	end
	if typeof(RadioGroup.Value) == "number" and RadioGroup.Options[RadioGroup.Value] then
		RadioGroup.Value = RadioGroup.Options[RadioGroup.Value].Value
	end
	if RadioGroup.Value == nil and not RadioGroup.AllowNone and RadioGroup.Options[1] then
		RadioGroup.Value = RadioGroup.Options[1].Value
	end

	local CanCallback = true

	RadioGroup.RadioGroupFrame = require("../components/window/Element")({
		Title = RadioGroup.Title,
		Desc = RadioGroup.Desc,
		Parent = Config.Parent,
		TextOffset = RadioGroup.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = RadioGroup,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	RadioGroup.UIElements.Options = New("Frame", {
		Name = "RadioGroupOptions",
		Size = UDim2.new(0, RadioGroup.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = RadioGroup.RadioGroupFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
			HorizontalAlignment = "Right",
			SortOrder = "LayoutOrder",
		}),
	})

	local function UpdateOptionVisuals(IsAnimated)
		for _, Data in next, RadioGroup.OptionFrames do
			local Selected = Data.Option.Value == RadioGroup.Value
			local RowTransparency = Selected and 0.84 or 0.94
			local DotTransparency = Selected and 0 or 1
			local TitleTransparency = Data.Option.Disabled and 0.55 or (Selected and 0 or 0.18)

			if IsAnimated and RadioGroup.Animation then
				Motion.Play(Data.Row, "Select", { ImageTransparency = RowTransparency }, nil, nil, "Select")
				Motion.Play(Data.Dot, "Select", { ImageTransparency = DotTransparency }, nil, nil, "Select")
				Motion.Play(Data.Title, "Select", { TextTransparency = TitleTransparency }, nil, nil, "Select")
			else
				Data.Row.ImageTransparency = RowTransparency
				Data.Dot.ImageTransparency = DotTransparency
				Data.Title.TextTransparency = TitleTransparency
			end
		end
	end

	local function CreateOption(Option, Index)
		local Dot = Creator.NewRoundFrame(99, "Circle", {
			Name = "Dot",
			Size = UDim2.new(0, 8, 0, 8),
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "RadioGroupActive",
			},
		})

		local Ring = Creator.NewRoundFrame(99, "CircleOutline", {
			Name = "Ring",
			Size = UDim2.new(0, 18, 0, 18),
			ImageTransparency = Option.Disabled and 0.75 or 0.45,
			ThemeTag = {
				ImageColor3 = "RadioGroupBorder",
			},
		}, {
			Dot,
		})
		Dot.Position = UDim2.new(0.5, 0, 0.5, 0)
		Dot.AnchorPoint = Vector2.new(0.5, 0.5)

		local Title = New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -28, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Text = Option.Title,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = "Left",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			ThemeTag = {
				TextColor3 = "RadioGroupText",
			},
		})

		local Row = Creator.NewRoundFrame(12, "Squircle", {
			Name = "Option",
			Size = UDim2.new(1, 0, 0, 36),
			LayoutOrder = Index,
			ImageTransparency = 0.94,
			Active = not Option.Disabled,
			ThemeTag = {
				ImageColor3 = "RadioGroupBackground",
			},
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Left",
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			Ring,
			Title,
		}, true)

		Row.Parent = RadioGroup.UIElements.Options

		local Data = {
			Row = Row,
			Ring = Ring,
			Dot = Dot,
			Title = Title,
			Option = Option,
		}
		RadioGroup.OptionFrames[Index] = Data

		Motion.AttachPress(Row, Creator, {
			Enabled = function()
				return RadioGroup.Animation and not RadioGroup.Locked and not Option.Disabled
			end,
		})

		Creator.AddSignal(Row.MouseButton1Click, function()
			if not Option.Disabled then
				RadioGroup:Select(Option.Value)
			end
		end)
	end

	local function RenderOptions()
		for _, Data in next, RadioGroup.OptionFrames do
			if Data.Row then
				Data.Row:Destroy()
			end
		end

		RadioGroup.OptionFrames = {}

		for Index, Option in next, RadioGroup.Options do
			CreateOption(Option, Index)
		end

		UpdateOptionVisuals(false)
	end

	function RadioGroup:Lock()
		RadioGroup.Locked = true
		CanCallback = false
		return RadioGroup.RadioGroupFrame:Lock(RadioGroup.LockedTitle)
	end
	function RadioGroup:Unlock()
		RadioGroup.Locked = false
		CanCallback = true
		return RadioGroup.RadioGroupFrame:Unlock()
	end

	function RadioGroup:Get()
		return RadioGroup.Value
	end

	function RadioGroup:Select(Value, IsCallback)
		local Option = Utils.FindOption(RadioGroup.Options, Value)
		if not Option and not RadioGroup.AllowNone then
			return RadioGroup.Value
		end
		if Option and Option.Disabled then
			return RadioGroup.Value
		end

		RadioGroup.Value = Value
		UpdateOptionVisuals(true)

		if CanCallback and IsCallback ~= false then
			Creator.SafeCallback(RadioGroup.Callback, Value, Option)
		end

		return RadioGroup.Value
	end

	function RadioGroup:SetOptions(Options)
		RadioGroup.Options = Utils.NormalizeOptions(Options)

		if not Utils.FindOption(RadioGroup.Options, RadioGroup.Value) then
			RadioGroup.Value = RadioGroup.AllowNone and nil or (RadioGroup.Options[1] and RadioGroup.Options[1].Value)
		end

		RenderOptions()
		return RadioGroup.Options
	end

	RenderOptions()

	if RadioGroup.Locked then
		RadioGroup:Lock()
	end

	return RadioGroup.__type, RadioGroup
end

return Element
