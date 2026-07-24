local Element = {}

local Variants = {
	Info = {
		Icon = "info",
		Color = Color3.fromHex("#2563eb"),
	},
	Success = {
		Icon = "circle-check",
		Color = Color3.fromHex("#16a34a"),
	},
	Warning = {
		Icon = "triangle-alert",
		Color = Color3.fromHex("#d97706"),
	},
	Error = {
		Icon = "circle-x",
		Color = Color3.fromHex("#dc2626"),
	},
}

function Element:New(Config)
	local VariantName = Config.Variant or "Info"
	local Variant = Variants[VariantName] or Variants.Info

	local Callout = {
		__type = "Callout",
		Title = Config.Title or VariantName,
		Desc = Config.Desc or Config.Content,
		Icon = Config.Icon or Variant.Icon,
		Variant = VariantName,
		Color = Config.Color or Variant.Color,
		UIElements = {},
	}

	Callout.CalloutFrame = require("../components/window/Element")({
		Title = Callout.Title,
		Desc = Callout.Desc,
		Image = Callout.Icon,
		IconThemed = Config.IconThemed,
		Color = Callout.Color,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Callout,
		ParentConfig = Config,
		Tags = Config.Tags,
		Size = Config.Size,
	})

	return Callout.__type, Callout
end

return Element
