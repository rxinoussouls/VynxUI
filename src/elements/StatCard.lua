local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function GetTrendColor(Trend)
	if Trend == "Down" or Trend == "Negative" then
		return Color3.fromHex("#dc2626")
	end
	if Trend == "Neutral" then
		return Color3.fromHex("#71717a")
	end
	return Color3.fromHex("#16a34a")
end

function Element:New(Config)
	local StatCard = {
		__type = "StatCard",
		Title = Config.Title or "Stat",
		Desc = Config.Desc,
		Value = Config.Value or Config.Default or "0",
		SubValue = Config.SubValue or Config.TrendText,
		Trend = Config.Trend or "Up",
		Icon = Config.Icon,
		UIElements = {},
	}

	StatCard.StatCardFrame = require("../components/window/Element")({
		Title = StatCard.Title,
		Desc = StatCard.Desc,
		Image = StatCard.Icon,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = StatCard,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	StatCard.UIElements.Value = New("TextLabel", {
		Name = "Value",
		LayoutOrder = -1,
		BackgroundTransparency = 1,
		Text = tostring(StatCard.Value),
		TextSize = Utils.ToFiniteNumber(Config.ValueTextSize) or 24,
		TextWrapped = true,
		TextXAlignment = "Left",
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	StatCard.UIElements.TrendDot = Creator.NewRoundFrame(999, "Circle", {
		Name = "TrendDot",
		Size = UDim2.new(0, 8, 0, 8),
		ImageColor3 = Utils.GetColor(Config.TrendColor, GetTrendColor(StatCard.Trend)),
	})

	StatCard.UIElements.SubValue = New("TextLabel", {
		Name = "SubValue",
		BackgroundTransparency = 1,
		Text = tostring(StatCard.SubValue or ""),
		TextSize = 13,
		TextTransparency = 0.35,
		TextWrapped = true,
		TextXAlignment = "Left",
		AutomaticSize = "Y",
		Size = UDim2.new(1, -16, 0, 0),
		Visible = StatCard.SubValue ~= nil,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	StatCard.UIElements.Footer = New("Frame", {
		Name = "Footer",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = StatCard.StatCardFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Left",
		}),
		StatCard.UIElements.TrendDot,
		StatCard.UIElements.SubValue,
	})
	StatCard.UIElements.Value.Parent = StatCard.StatCardFrame.UIElements.Container

	function StatCard:SetValue(Value, SubValue)
		StatCard.Value = Value
		StatCard.UIElements.Value.Text = tostring(Value or "")
		if SubValue ~= nil then
			StatCard.SubValue = SubValue
			StatCard.UIElements.SubValue.Text = tostring(SubValue)
			StatCard.UIElements.SubValue.Visible = true
		end
		Motion.Play(StatCard.UIElements.Value, "Fast", { TextTransparency = 0.18 }, nil, nil, "Pulse")
		task.delay(Motion.GetDuration("Fast"), function()
			if StatCard.UIElements.Value.Parent then
				Motion.Play(StatCard.UIElements.Value, "Select", { TextTransparency = 0 }, nil, nil, "Pulse")
			end
		end)
		return StatCard.Value
	end

	function StatCard:SetTrend(Trend, Color)
		StatCard.Trend = Trend
		local TrendColor = Utils.GetColor(Color, GetTrendColor(Trend))
		Motion.Play(StatCard.UIElements.TrendDot, "Select", { ImageColor3 = TrendColor }, nil, nil, "Trend")
		return StatCard.Trend
	end

	return StatCard.__type, StatCard
end

return Element
