local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function GetWidth(Config)
	return math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or 190, 120)
end

function Element:New(Config)
	local ChipList = {
		__type = "ChipList",
		Title = Config.Title or "Chips",
		Desc = Config.Desc,
		Options = Utils.NormalizeItems(Config.Options or Config.Values or {}),
		Values = Utils.NormalizeValues(Config.Value or Config.ValuesSelected or Config.SelectedValues),
		Multi = Config.Multi ~= false,
		Callback = Config.Callback or function() end,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Animation = Config.Animation ~= false,
		UIElements = {},
		Chips = {},

		Width = GetWidth(Config),
	}

	local CanCallback = true

	ChipList.ChipListFrame = require("../components/window/Element")({
		Title = ChipList.Title,
		Desc = ChipList.Desc,
		Parent = Config.Parent,
		TextOffset = ChipList.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = ChipList,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	ChipList.UIElements.List = New("Frame", {
		Name = "ChipList",
		Size = UDim2.new(0, ChipList.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = ChipList.ChipListFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
			HorizontalAlignment = "Right",
			SortOrder = "LayoutOrder",
		}),
	})

	local function IsSelected(Value)
		return Utils.ContainsValue(ChipList.Values, Value)
	end

	local function UpdateVisuals(IsAnimated)
		for _, Chip in next, ChipList.Chips do
			local Selected = IsSelected(Chip.Option.Value)
			local Transparency = Selected and 0.82 or 0.94
			local TextTransparency = Chip.Option.Disabled and 0.55 or (Selected and 0 or 0.2)

			if IsAnimated and ChipList.Animation then
				Motion.Play(Chip.Button, "Select", { ImageTransparency = Transparency }, nil, nil, "State")
				Motion.Play(Chip.Title, "Select", { TextTransparency = TextTransparency }, nil, nil, "State")
			else
				Chip.Button.ImageTransparency = Transparency
				Chip.Title.TextTransparency = TextTransparency
			end
		end
	end

	local function Sanitize(Values)
		local Sanitized = {}
		for _, Value in next, Values or {} do
			for _, Option in next, ChipList.Options do
				if Option.Value == Value and not Option.Disabled and not Utils.ContainsValue(Sanitized, Value) then
					table.insert(Sanitized, Value)
					break
				end
			end
		end
		return Sanitized
	end

	local function CreateChip(Option, Index)
		local Title = New("TextLabel", {
			Name = "Title",
			BackgroundTransparency = 1,
			Text = Option.Title,
			TextSize = 13,
			TextTruncate = "AtEnd",
			TextXAlignment = "Center",
			Size = UDim2.new(1, -16, 1, 0),
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local Button = Creator.NewRoundFrame(999, "Squircle", {
			Name = "Chip",
			Size = UDim2.new(1, 0, 0, 30),
			LayoutOrder = Index,
			ImageTransparency = 0.94,
			Active = not Option.Disabled,
			ThemeTag = {
				ImageColor3 = "ChipListBackground",
			},
			Parent = ChipList.UIElements.List,
		}, {
			Title,
		}, true)

		local Chip = {
			Button = Button,
			Title = Title,
			Option = Option,
		}
		ChipList.Chips[Index] = Chip

		Motion.AttachPress(Button, Creator, {
			Amount = 0.96,
			Enabled = function()
				return ChipList.Animation and not ChipList.Locked and not Option.Disabled
			end,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			if not Option.Disabled then
				ChipList:Toggle(Option.Value)
			end
		end)
	end

	local function Render()
		for _, Chip in next, ChipList.Chips do
			Chip.Button:Destroy()
		end
		ChipList.Chips = {}

		for Index, Option in next, ChipList.Options do
			CreateChip(Option, Index)
		end

		ChipList.Values = Sanitize(ChipList.Values)
		UpdateVisuals(false)
	end

	function ChipList:Lock()
		ChipList.Locked = true
		CanCallback = false
		return ChipList.ChipListFrame:Lock(ChipList.LockedTitle)
	end

	function ChipList:Unlock()
		ChipList.Locked = false
		CanCallback = true
		return ChipList.ChipListFrame:Unlock()
	end

	function ChipList:Get()
		return ChipList.Multi and Utils.CloneArray(ChipList.Values) or ChipList.Values[1]
	end

	function ChipList:Set(Values, IsCallback)
		local NextValues = Utils.NormalizeValues(Values)
		if not ChipList.Multi and NextValues[1] ~= nil then
			NextValues = { NextValues[1] }
		end

		ChipList.Values = Sanitize(NextValues)
		UpdateVisuals(true)

		if CanCallback and IsCallback ~= false then
			Creator.SafeCallback(ChipList.Callback, ChipList:Get())
		end

		return ChipList:Get()
	end

	function ChipList:Toggle(Value, IsCallback)
		if ChipList.Multi then
			ChipList.Values = Utils.ToggleValue(ChipList.Values, Value)
			return ChipList:Set(ChipList.Values, IsCallback)
		end

		return ChipList:Set(Value, IsCallback)
	end

	function ChipList:SetOptions(Options)
		ChipList.Options = Utils.NormalizeItems(Options or {})
		Render()
		return ChipList.Options
	end

	Render()

	if ChipList.Locked then
		ChipList:Lock()
	end

	return ChipList.__type, ChipList
end

return Element
