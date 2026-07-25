local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./ModernControlUtils")

local Element = {}

local function GetControlWidth(Config)
	return math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or 220, 120)
end

function Element:New(Config)
	local CheckboxGroup = {
		__type = "CheckboxGroup",
		Title = Config.Title or "Checkbox Group",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Options = Utils.NormalizeOptions(Config.Options or Config.Values or {}),
		Values = Utils.NormalizeValues(Config.ValuesSelected or Config.SelectedValues or Config.Value or Config.ValuesDefault),
		Callback = Config.Callback or function() end,
		UIElements = {},
		OptionFrames = {},
		Animation = Config.Animation ~= false,

		Width = GetControlWidth(Config),
	}

	local CanCallback = true

	CheckboxGroup.CheckboxGroupFrame = require("../components/window/Element")({
		Title = CheckboxGroup.Title,
		Desc = CheckboxGroup.Desc,
		Parent = Config.Parent,
		TextOffset = CheckboxGroup.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = CheckboxGroup,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	CheckboxGroup.UIElements.Options = New("Frame", {
		Name = "CheckboxGroupOptions",
		Size = UDim2.new(0, CheckboxGroup.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = CheckboxGroup.CheckboxGroupFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
			HorizontalAlignment = "Right",
			SortOrder = "LayoutOrder",
		}),
	})

	local function SanitizeValues(Values)
		local Sanitized = {}

		for _, Value in next, Values or {} do
			local Option = Utils.FindOption(CheckboxGroup.Options, Value)
			if Option and not Option.Disabled and not Utils.ContainsValue(Sanitized, Value) then
				table.insert(Sanitized, Value)
			end
		end

		return Sanitized
	end

	local function UpdateOptionVisuals(IsAnimated)
		for _, Data in next, CheckboxGroup.OptionFrames do
			local Selected = Utils.ContainsValue(CheckboxGroup.Values, Data.Option.Value)
			local RowTransparency = Selected and 0.84 or 0.94
			local FillTransparency = Selected and 0 or 1
			local IconTransparency = Selected and 0 or 1
			local TitleTransparency = Data.Option.Disabled and 0.55 or (Selected and 0 or 0.18)

			if IsAnimated and CheckboxGroup.Animation then
				Motion.Play(Data.Row, "Select", { ImageTransparency = RowTransparency }, nil, nil, "Select")
				Motion.Play(Data.Fill, "Select", { ImageTransparency = FillTransparency }, nil, nil, "Select")
				Motion.Play(Data.Icon, "Select", { ImageTransparency = IconTransparency }, nil, nil, "Select")
				Motion.Play(Data.Title, "Select", { TextTransparency = TitleTransparency }, nil, nil, "Select")
			else
				Data.Row.ImageTransparency = RowTransparency
				Data.Fill.ImageTransparency = FillTransparency
				Data.Icon.ImageTransparency = IconTransparency
				Data.Title.TextTransparency = TitleTransparency
			end
		end
	end

	local function CreateOption(Option, Index)
		local IconInfo = Creator.Icon("check")
		local CheckIcon = New("ImageLabel", {
			Name = "Check",
			Size = UDim2.new(0, 12, 0, 12),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = IconInfo[1],
			ImageRectOffset = IconInfo[2].ImageRectPosition,
			ImageRectSize = IconInfo[2].ImageRectSize,
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupIcon",
			},
		})

		local Fill = Creator.NewRoundFrame(5, "Squircle", {
			Name = "Fill",
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupActive",
			},
		}, {
			CheckIcon,
		})

		local Box = Creator.NewRoundFrame(5, "SquircleOutline", {
			Name = "Box",
			Size = UDim2.new(0, 18, 0, 18),
			ImageTransparency = Option.Disabled and 0.75 or 0.45,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupBorder",
			},
		}, {
			Fill,
		})

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
				TextColor3 = "CheckboxGroupText",
			},
		})

		local Row = Creator.NewRoundFrame(12, "Squircle", {
			Name = "Option",
			Size = UDim2.new(1, 0, 0, 36),
			LayoutOrder = Index,
			ImageTransparency = 0.94,
			Active = not Option.Disabled,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupBackground",
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
			Box,
			Title,
		}, true)

		Row.Parent = CheckboxGroup.UIElements.Options

		local Data = {
			Row = Row,
			Fill = Fill,
			Icon = CheckIcon,
			Title = Title,
			Option = Option,
		}
		CheckboxGroup.OptionFrames[Index] = Data

		Motion.AttachPress(Row, Creator, {
			Enabled = function()
				return CheckboxGroup.Animation and not CheckboxGroup.Locked and not Option.Disabled
			end,
		})

		Creator.AddSignal(Row.MouseButton1Click, function()
			if not Option.Disabled then
				CheckboxGroup:Toggle(Option.Value)
			end
		end)
	end

	local function RenderOptions()
		for _, Data in next, CheckboxGroup.OptionFrames do
			if Data.Row then
				Data.Row:Destroy()
			end
		end

		CheckboxGroup.OptionFrames = {}

		for Index, Option in next, CheckboxGroup.Options do
			CreateOption(Option, Index)
		end

		CheckboxGroup.Values = SanitizeValues(CheckboxGroup.Values)
		UpdateOptionVisuals(false)
	end

	function CheckboxGroup:Lock()
		CheckboxGroup.Locked = true
		CanCallback = false
		return CheckboxGroup.CheckboxGroupFrame:Lock(CheckboxGroup.LockedTitle)
	end
	function CheckboxGroup:Unlock()
		CheckboxGroup.Locked = false
		CanCallback = true
		return CheckboxGroup.CheckboxGroupFrame:Unlock()
	end

	function CheckboxGroup:Get()
		return Utils.CloneArray(CheckboxGroup.Values)
	end

	function CheckboxGroup:Set(Values, IsCallback)
		CheckboxGroup.Values = SanitizeValues(Utils.NormalizeValues(Values))
		UpdateOptionVisuals(true)

		if CanCallback and IsCallback ~= false then
			Creator.SafeCallback(CheckboxGroup.Callback, CheckboxGroup:Get())
		end

		return CheckboxGroup:Get()
	end

	function CheckboxGroup:Toggle(Value, IsCallback)
		local Option = Utils.FindOption(CheckboxGroup.Options, Value)
		if not Option or Option.Disabled then
			return CheckboxGroup:Get()
		end

		CheckboxGroup.Values = Utils.ToggleValue(CheckboxGroup.Values, Value)
		return CheckboxGroup:Set(CheckboxGroup.Values, IsCallback)
	end

	function CheckboxGroup:SetOptions(Options)
		CheckboxGroup.Options = Utils.NormalizeOptions(Options)
		RenderOptions()
		return CheckboxGroup.Options
	end

	RenderOptions()

	if CheckboxGroup.Locked then
		CheckboxGroup:Lock()
	end

	return CheckboxGroup.__type, CheckboxGroup
end

return Element
