local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local VariantName = Config.Variant or "Info"
	local Variant = Utils.GetVariant(VariantName)
	local Badge = {
		__type = "Badge",
		Title = Config.Title or "Badge",
		Desc = Config.Desc or nil,
		Value = Config.Value or Config.Badge or VariantName,
		Variant = VariantName,
		Color = Utils.GetColor(Config.Color, Variant.Color),
		Icon = Config.Icon or Variant.Icon,
		Callback = Config.Callback,
		UIElements = {},

		Width = math.max(Utils.ToFiniteNumber(Config.Width) or 96, 72),
	}

	Badge.BadgeFrame = require("../components/window/Element")({
		Title = Badge.Title,
		Desc = Badge.Desc,
		Parent = Config.Parent,
		TextOffset = Badge.Width + 14,
		Hover = Config.Hover == true or Badge.Callback ~= nil,
		Scalable = Badge.Callback ~= nil,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Badge,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local Icon = Utils.CreateIcon(Creator, Badge.Icon, Config.Window.Folder, "Badge", false, "BadgeIcon")
	if Icon then
		Icon.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
		Icon.ImageLabel.ImageTransparency = 0
		Icon.Size = UDim2.new(0, 14, 0, 14)
	end

	Badge.UIElements.Label = New("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Text = tostring(Badge.Value),
		TextSize = 13,
		TextTruncate = "AtEnd",
		TextXAlignment = "Center",
		Size = UDim2.new(1, Icon and -20 or 0, 1, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextColor3 = Color3.new(1, 1, 1),
	})

	Badge.UIElements.Pill = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Badge",
		Size = UDim2.new(0, Badge.Width, 0, 28),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		ImageTransparency = 0,
		ImageColor3 = Badge.Color,
		Parent = Badge.BadgeFrame.UIElements.Main,
	}, {
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
		}),
		Icon,
		Badge.UIElements.Label,
	})

	function Badge:SetValue(Value)
		Badge.Value = Value
		Badge.UIElements.Label.Text = tostring(Value or "")
		Motion.Play(Badge.UIElements.Pill, "Fast", { ImageTransparency = 0.08 }, nil, nil, "Pulse")
		task.delay(Motion.GetDuration("Fast"), function()
			if Badge.UIElements.Pill.Parent then
				Motion.Play(Badge.UIElements.Pill, "Select", { ImageTransparency = 0 }, nil, nil, "Pulse")
			end
		end)
		return Badge.Value
	end

	function Badge:SetVariant(Variant)
		local NextVariant = Utils.GetVariant(Variant)
		Badge.Variant = Variant
		Badge.Color = NextVariant.Color
		Motion.Play(Badge.UIElements.Pill, "Select", { ImageColor3 = Badge.Color }, nil, nil, "Variant")
		return Badge.Variant
	end

	if Badge.Callback then
		Creator.AddSignal(Badge.BadgeFrame.UIElements.Main.MouseButton1Click, function()
			Creator.SafeCallback(Badge.Callback, Badge.Value)
		end)
	end

	return Badge.__type, Badge
end

return Element
