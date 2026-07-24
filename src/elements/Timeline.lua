local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local Timeline = {
		__type = "Timeline",
		Title = Config.Title or "Timeline",
		Desc = Config.Desc,
		Items = Utils.NormalizeItems(Config.Items or Config.Events or {}),
		UIElements = {},
		Rows = {},
	}

	Timeline.TimelineFrame = require("../components/window/Element")({
		Title = Timeline.Title,
		Desc = Timeline.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Timeline,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Timeline.UIElements.List = New("Frame", {
		Name = "TimelineList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Timeline.TimelineFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Vertical",
			VerticalAlignment = "Top",
			HorizontalAlignment = "Left",
		}),
	})

	local function Render()
		for _, Row in next, Timeline.Rows do
			Row:Destroy()
		end
		Timeline.Rows = {}

		for Index, Item in next, Timeline.Items do
			local Variant = Utils.GetVariant(Item.Value)
			local Color = Utils.GetColor(Item.Color, Variant.Color)

			local Dot = Creator.NewRoundFrame(999, "Circle", {
				Name = "Dot",
				Size = UDim2.new(0, 10, 0, 10),
				Position = UDim2.new(0.5, 0, 0, 5),
				AnchorPoint = Vector2.new(0.5, 0),
				ImageTransparency = 1,
				ImageColor3 = Color,
			})

			local Rail = New("Frame", {
				Name = "Rail",
				Size = UDim2.new(0, 24, 0, Item.Desc and 46 or 30),
				BackgroundTransparency = 1,
			}, {
				New("Frame", {
					Name = "Line",
					Size = UDim2.new(0, 1, 1, Index == #Timeline.Items and -8 or 0),
					Position = UDim2.new(0.5, 0, 0, 16),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 0.86,
					ThemeTag = {
						BackgroundColor3 = "TimelineLine",
					},
				}),
				Dot,
			})

			local TextContainer = New("Frame", {
				Name = "Text",
				Size = UDim2.new(1, -32, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 3),
					FillDirection = "Vertical",
					VerticalAlignment = "Top",
					HorizontalAlignment = "Left",
				}),
				Utils.CreateText(New, Creator, Item.Title, 14, Enum.FontWeight.SemiBold, 0),
				Item.Desc and Utils.CreateText(New, Creator, Item.Desc, 13, Enum.FontWeight.Medium, 0.4) or nil,
			})

			local Row = New("Frame", {
				Name = "Item",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Parent = Timeline.UIElements.List,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = "Horizontal",
					VerticalAlignment = "Top",
					HorizontalAlignment = "Left",
				}),
				Rail,
				TextContainer,
			})

			table.insert(Timeline.Rows, Row)
			task.delay((Index - 1) * 0.025, function()
				if Dot.Parent then
					Motion.Play(Dot, "Reveal", { ImageTransparency = 0 }, nil, nil, "Reveal")
				end
			end)
		end
	end

	function Timeline:SetItems(Items)
		Timeline.Items = Utils.NormalizeItems(Items or {})
		Render()
		return Timeline.Items
	end

	Render()

	return Timeline.__type, Timeline
end

return Element
