local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local KeyValue = {
		__type = "KeyValue",
		Title = Config.Title or "Details",
		Desc = Config.Desc,
		Items = Utils.NormalizeItems(Config.Items or Config.Rows or Config.Values or {}, "Key", "Value"),
		-- Cascade's Row/Form pattern: flat rows in one panel separated by a
		-- hairline, instead of each row floating as its own card.
		Divided = Config.Divided == true,
		UIElements = {},
		Rows = {},
	}

	KeyValue.KeyValueFrame = require("../components/window/Element")({
		Title = KeyValue.Title,
		Desc = KeyValue.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = KeyValue,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	KeyValue.UIElements.List = New("Frame", {
		Name = "KeyValueList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = KeyValue.KeyValueFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, KeyValue.Divided and 0 or 8),
			FillDirection = "Vertical",
			VerticalAlignment = "Top",
			HorizontalAlignment = "Left",
		}),
	})

	local function Render()
		for _, Row in next, KeyValue.Rows do
			Row:Destroy()
		end
		KeyValue.Rows = {}

		for Index, Item in next, KeyValue.Items do
			local Icon = Utils.CreateIcon(Creator, Item.Icon, Config.Window.Folder, "KeyValue", true, "KeyValueIcon")
			if Icon then
				Icon.Size = UDim2.new(0, 16, 0, 16)
			end

			local Key = New("TextLabel", {
				Name = "Key",
				BackgroundTransparency = 1,
				Text = tostring(Item.Title),
				TextSize = 14,
				TextTransparency = 0.35,
				TextTruncate = "AtEnd",
				TextXAlignment = "Left",
				Size = UDim2.new(0.45, Icon and -24 or 0, 0, 0),
				AutomaticSize = "Y",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local Value = New("TextLabel", {
				Name = "Value",
				BackgroundTransparency = 1,
				Text = tostring(Item.Value or ""),
				TextSize = 14,
				TextTransparency = 0.05,
				TextWrapped = true,
				TextXAlignment = "Right",
				Size = UDim2.new(0.55, 0, 0, 0),
				AutomaticSize = "Y",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local RowContent = New("Frame", {
				Name = "RowContent",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = "Horizontal",
					VerticalAlignment = "Top",
					HorizontalAlignment = "Left",
				}),
				Icon,
				Key,
				Value,
			})

			local Row = New("Frame", {
				Name = "Row",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Parent = KeyValue.UIElements.List,
			}, {
				New("UIListLayout", {
					FillDirection = "Vertical",
					Padding = UDim.new(0, KeyValue.Divided and 9 or 0),
				}),
				KeyValue.Divided and New("UIPadding", {
					PaddingTop = UDim.new(0, 9),
				}) or nil,
				RowContent,
				KeyValue.Divided and Index < #KeyValue.Items and New("Frame", {
					Name = "RowDivider",
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundTransparency = 0.65,
					ThemeTag = {
						BackgroundColor3 = "Text",
					},
				}) or nil,
			})

			table.insert(KeyValue.Rows, Row)
		end
	end

	function KeyValue:SetItems(Items)
		KeyValue.Items = Utils.NormalizeItems(Items or {}, "Key", "Value")
		Render()
		Motion.Play(KeyValue.UIElements.List, "Reveal", { BackgroundTransparency = 1 }, nil, nil, "Render")
		return KeyValue.Items
	end

	Render()

	return KeyValue.__type, KeyValue
end

return Element
