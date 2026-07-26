-- PullDownButton.lua
-- Ported from Cascade (cascadeui/Cascade, src/components/PullDownButton.luau).
-- First pass (see commit history) expanded the option list inline below
-- the button. Now upgraded to a real floating menu via the new
-- src/modules/FloatingMenu.lua helper (see its header for why Cascade's
-- own dropdownMenu.luau wasn't vendored directly).
local Creator = require("../modules/Creator")
local New = Creator.New
local Utils = require("./DisplayElementUtils")
local FloatingMenu = require("../modules/FloatingMenu")

local Element = {}

function Element:New(Config)
	local Options = Config.Options or {} -- { {Title=, Icon=, Callback=}, ... }

	local PullDown = {
		__type = "PullDownButton",
		Title = Config.Title or "Select",
		Options = Options,
		UIElements = {},
	}

	local Label = Utils.CreateText(New, Creator, PullDown.Title, 14, Enum.FontWeight.Medium, 0)

	local Chevron = New("TextLabel", {
		Name = "Chevron",
		BackgroundTransparency = 1,
		Text = "v",
		TextSize = 12,
		Size = UDim2.fromOffset(14, 14),
		ThemeTag = { TextColor3 = "Text" },
	})

	local TriggerButton = New("TextButton", {
		Name = "PullDownButton",
		Text = "",
		AutoButtonColor = false,
		AutomaticSize = "XY",
		Size = UDim2.new(0, 0, 0, 24),
		ThemeTag = { BackgroundColor3 = "Dialog" },
	}, { Label, Chevron })
	New("UICorner", { Parent = TriggerButton, CornerRadius = UDim.new(0, 6) })
	New("UIListLayout", {
		Parent = TriggerButton,
		FillDirection = "Horizontal",
		Padding = UDim.new(0, 6),
		VerticalAlignment = "Center",
		SortOrder = "LayoutOrder",
	})
	New("UIPadding", {
		Parent = TriggerButton,
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
	})

	PullDown.ElementFrame = TriggerButton
	TriggerButton.Parent = Config.Parent

	local Menu = FloatingMenu.new({
		VynxUI = Config.VynxUI,
		Trigger = TriggerButton,
		Items = Options,
		OnSelect = function(Option)
			PullDown:Set(Option.Title)
			if Option.Callback then
				Creator.SafeCallback(Option.Callback, Option.Value or Option.Title)
			end
		end,
	})

	function PullDown:Set(NewTitle)
		PullDown.Title = NewTitle
		Label.Text = NewTitle
	end

	TriggerButton.MouseButton1Click:Connect(function()
		Menu.Open()
	end)

	return PullDown.__type, PullDown
end

return Element

