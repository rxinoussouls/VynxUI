-- PullDownButton.lua
-- Ported from Cascade (cascadeui/Cascade, src/components/PullDownButton.luau).
-- Cascade's version renders a floating overlay menu via its own
-- `modules/dropdownMenu` (anchor modes, checkmarks, viewport clamping).
-- VynxUI's equivalent floating-menu machinery lives in
-- `components/ui/Dropdown.lua`, but it's tightly coupled to the full
-- Dropdown element (search box, multi-select state, its own Config
-- shape) and not safe to call standalone without risking breaking that
-- element too. SIMPLIFIED HERE INSTEAD: options list expands inline
-- below the button (pushes following elements down) rather than
-- floating on top. Same trigger idea as Cascade (label + chevron pill),
-- simpler menu behavior. Revisit with a real floating menu later if
-- inline expansion isn't good enough.
local Creator = require("../modules/Creator")
local New = Creator.New
local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local Options = Config.Options or {} -- { {Title=, Icon=, Callback=}, ... }

	local PullDown = {
		__type = "PullDownButton",
		Title = Config.Title or "Select",
		Options = Options,
		Expanded = false,
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

	local MenuList = New("Frame", {
		Name = "MenuList",
		BackgroundTransparency = 1,
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		Visible = false,
	})
	New("UIListLayout", { Parent = MenuList, SortOrder = "LayoutOrder", Padding = UDim.new(0, 2) })

	for _, Option in ipairs(Options) do
		local OptionButton = New("TextButton", {
			Name = "Option",
			Text = Option.Title or "",
			AutomaticSize = "XY",
			Size = UDim2.new(1, 0, 0, 22),
			ThemeTag = { BackgroundColor3 = "Dialog", TextColor3 = "Text" },
			BackgroundTransparency = 1,
		})
		OptionButton.MouseButton1Click:Connect(function()
			PullDown:Set(Option.Title)
			if Option.Callback then
				Creator.SafeCallback(Option.Callback, Option.Value or Option.Title)
			end
			PullDown:Toggle(false)
		end)
		OptionButton.Parent = MenuList
	end

	PullDown.ElementFrame = New("Frame", {
		Name = "PullDownButton",
		Parent = Config.Parent,
		BackgroundTransparency = 1,
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
	}, { TriggerButton, MenuList })
	New("UIListLayout", { Parent = PullDown.ElementFrame, SortOrder = "LayoutOrder", Padding = UDim.new(0, 4) })

	function PullDown:Set(NewTitle)
		PullDown.Title = NewTitle
		Label.Text = NewTitle
	end

	function PullDown:Toggle(Expanded)
		PullDown.Expanded = Expanded
		MenuList.Visible = Expanded
		Chevron.Rotation = Expanded and 180 or 0
	end

	TriggerButton.MouseButton1Click:Connect(function()
		PullDown:Toggle(not PullDown.Expanded)
	end)

	return PullDown.__type, PullDown
end

return Element
