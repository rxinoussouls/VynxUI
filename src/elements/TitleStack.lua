-- TitleStack.lua
-- Ported from Cascade (cascadeui/Cascade, src/components/TitleStack.luau).
-- Cascade builds this via its own `structures/TitleStack` + `binder`
-- reactive-property helpers; VynxUI has no equivalent binder module, so
-- this is a straight rewrite against Creator.New + Utils.CreateText,
-- matching the plain-table `Element:New(Config)` style used across
-- src/elements (see Badge.lua for the closest sibling: title + optional
-- secondary text, no window/Element row wrapper needed).
local Creator = require("../modules/Creator")
local New = Creator.New
local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local TitleStack = {
		__type = "TitleStack",
		Title = Config.Title or "Title",
		Subtitle = Config.Subtitle,
		UIElements = {},
	}

	TitleStack.UIElements.Title = Utils.CreateText(New, Creator, TitleStack.Title, 15, Enum.FontWeight.SemiBold, 0)

	local Children = { TitleStack.UIElements.Title }

	if TitleStack.Subtitle then
		TitleStack.UIElements.Subtitle = Utils.CreateText(New, Creator, TitleStack.Subtitle, 13, Enum.FontWeight.Medium, 0.3)
		table.insert(Children, TitleStack.UIElements.Subtitle)
	end

	TitleStack.ElementFrame = New("Frame", {
		Name = "TitleStack",
		Parent = Config.Parent,
		BackgroundTransparency = 1,
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
	}, Children)

	New("UIListLayout", {
		Parent = TitleStack.ElementFrame,
		SortOrder = "LayoutOrder",
		Padding = UDim.new(0, 2),
	})

	function TitleStack:SetTitle(NewTitle)
		TitleStack.Title = NewTitle
		TitleStack.UIElements.Title.Text = NewTitle
	end

	function TitleStack:SetSubtitle(NewSubtitle)
		TitleStack.Subtitle = NewSubtitle
		if not TitleStack.UIElements.Subtitle then
			TitleStack.UIElements.Subtitle =
				Utils.CreateText(New, Creator, NewSubtitle, 13, Enum.FontWeight.Medium, 0.3)
			TitleStack.UIElements.Subtitle.Parent = TitleStack.ElementFrame
		else
			TitleStack.UIElements.Subtitle.Visible = true
			TitleStack.UIElements.Subtitle.Text = NewSubtitle
		end
	end

	return TitleStack.__type, TitleStack
end

return Element
