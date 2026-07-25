-- Symbol.lua
-- Ported from Cascade (cascadeui/Cascade, src/components/Symbol.luau) and
-- adapted from Fusion-free Cascade `create()` calls to VynxUI's own
-- Creator.New/ThemeTag convention. A plain themed icon, independent of the
-- row/Title/Desc layout that most VynxUI elements use (see Divider.lua for
-- the same "standalone, no window/Element wrapper" pattern this follows).
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local Style = Config.Style or "Primary" -- "Primary" | "Secondary"

	-- VynxUI's theme table has no separate "TextSecondary" tag (checked
	-- src/themes/Init.lua) — reuse "Text" for both styles and fake the
	-- secondary look with extra transparency, same trick VynxUI's own
	-- elements use for de-emphasized text (see TabTextTransparency).
	local Icon = Creator.Image(
		Config.Icon or "circle",
		Config.Icon or "circle",
		0,
		Config.Window and Config.Window.Folder,
		"Element",
		true,
		true,
		"Text"
	)
	Icon.Size = Config.Size or UDim2.fromOffset(20, 20)
	if Style == "Secondary" then
		Icon.ImageTransparency = math.clamp((Icon.ImageTransparency or 0) + 0.35, 0, 1)
	end

	local SymbolFrame = New("Frame", {
		Name = "Symbol",
		Parent = Config.Parent,
		BackgroundTransparency = 1,
		Size = Config.Size or UDim2.fromOffset(20, 20),
		AutomaticSize = "XY",
	}, { Icon })

	local Symbol = {
		__type = "Symbol",
		Style = Style,
		UIElements = { Icon = Icon },
		ElementFrame = SymbolFrame,
	}

	function Symbol:SetStyle(NewStyle)
		Symbol.Style = NewStyle
		Creator.SetThemeTag(Icon, "Text")
		if NewStyle == "Secondary" then
			Icon.ImageTransparency = math.clamp((Icon.ImageTransparency or 0) + 0.35, 0, 1)
		end
	end

	return Symbol.__type, Symbol
end

return Element
