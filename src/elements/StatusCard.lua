local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local VariantName = Config.Status or Config.Variant or "Info"
	local Variant = Utils.GetVariant(VariantName)
	local StatusCard = {
		__type = "StatusCard",
		Title = Config.Title or "Status",
		Desc = Config.Desc or Config.Content,
		Value = Config.Value or VariantName,
		Status = VariantName,
		Color = Utils.GetColor(Config.Color, Variant.Color),
		Callback = Config.Callback,
		UIElements = {},

		Width = math.max(Utils.ToFiniteNumber(Config.Width) or 136, 96),
	}

	StatusCard.StatusCardFrame = require("../components/window/Element")({
		Title = StatusCard.Title,
		Desc = StatusCard.Desc,
		Parent = Config.Parent,
		TextOffset = StatusCard.Width + 14,
		Hover = Config.Hover == true or StatusCard.Callback ~= nil,
		Scalable = StatusCard.Callback ~= nil,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = StatusCard,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	StatusCard.UIElements.Dot = Creator.NewRoundFrame(999, "Circle", {
		Name = "Dot",
		Size = UDim2.new(0, 10, 0, 10),
		ImageColor3 = StatusCard.Color,
	})

	StatusCard.UIElements.Value = New("TextLabel", {
		Name = "Value",
		BackgroundTransparency = 1,
		Text = tostring(StatusCard.Value),
		TextSize = 14,
		TextTransparency = 0.08,
		TextTruncate = "AtEnd",
		AutomaticSize = "Y",
		Size = UDim2.new(1, -18, 0, 0),
		TextXAlignment = "Left",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	StatusCard.UIElements.Status = New("Frame", {
		Name = "StatusCard",
		Size = UDim2.new(0, StatusCard.Width, 0, 34),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = StatusCard.StatusCardFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Right",
		}),
		StatusCard.UIElements.Dot,
		StatusCard.UIElements.Value,
	})

	function StatusCard:SetValue(Value)
		StatusCard.Value = Value
		StatusCard.UIElements.Value.Text = tostring(Value or "")
		return StatusCard.Value
	end

	function StatusCard:SetStatus(Status, Value)
		local VariantData = Utils.GetVariant(Status)
		StatusCard.Status = Status
		StatusCard.Color = VariantData.Color
		if Value ~= nil then
			StatusCard:SetValue(Value)
		end
		Motion.Play(StatusCard.UIElements.Dot, "Select", { ImageColor3 = StatusCard.Color }, nil, nil, "Status")
		return StatusCard.Status
	end

	if StatusCard.Callback then
		Creator.AddSignal(StatusCard.StatusCardFrame.UIElements.Main.MouseButton1Click, function()
			Creator.SafeCallback(StatusCard.Callback, StatusCard.Status, StatusCard.Value)
		end)
	end

	return StatusCard.__type, StatusCard
end

return Element
