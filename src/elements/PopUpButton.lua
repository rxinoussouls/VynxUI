-- PopUpButton.lua
-- Ported from Cascade (cascadeui/Cascade, src/components/PopUpButton.luau).
-- Rewritten against VynxUI's Creator.New + the new src/modules/FloatingMenu.lua
-- helper instead of Cascade's creator/binder/dropdownMenu stack — see
-- FloatingMenu.lua's header comment for why that stack wasn't vendored
-- wholesale. Single-select only (Cascade's multi-select via Maximum>1
-- was dropped to keep this a reasonable single pass — same limitation
-- applies to PullDownButton.lua).
local Creator = require("../modules/Creator")
local New = Creator.New
local Utils = require("./DisplayElementUtils")
local FloatingMenu = require("../modules/FloatingMenu")

local Element = {}

function Element:New(Config)
	local Options = Config.Options or {} -- list of strings or {Title=, Value=}

	local PopUp = {
		__type = "PopUpButton",
		Value = Config.Value,
		Options = Options,
		Callback = Config.Callback or function() end,
		UIElements = {},
	}

	local function OptionTitle(Option)
		return type(Option) == "table" and (Option.Title or "") or tostring(Option)
	end

	local Label = Utils.CreateText(New, Creator, "None", 14, Enum.FontWeight.Medium, 0)

	local TriggerButton = New("TextButton", {
		Name = "PopUpButton",
		Text = "",
		AutoButtonColor = false,
		AutomaticSize = "XY",
		Size = UDim2.new(0, 0, 0, 24),
		ThemeTag = { BackgroundColor3 = "Dialog" },
	}, { Label })
	New("UICorner", { Parent = TriggerButton, CornerRadius = UDim.new(0, 6) })
	New("UIPadding", {
		Parent = TriggerButton,
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
	})

	PopUp.ElementFrame = TriggerButton
	TriggerButton.Parent = Config.Parent

	local Menu = FloatingMenu.new({
		VynxUI = Config.VynxUI,
		Trigger = TriggerButton,
		Items = (function()
			local Items = {}
			for _, Option in ipairs(Options) do
				table.insert(Items, { Title = OptionTitle(Option) })
			end
			return Items
		end)(),
		OnSelect = function(_, Index)
			PopUp:Set(Options[Index])
		end,
	})

	function PopUp:Set(NewValue)
		PopUp.Value = NewValue
		Label.Text = NewValue and OptionTitle(NewValue) or "None"
		Creator.SafeCallback(PopUp.Callback, NewValue)
	end

	TriggerButton.MouseButton1Click:Connect(function()
		Menu.Open()
	end)

	if PopUp.Value then
		PopUp:Set(PopUp.Value)
	end

	return PopUp.__type, PopUp
end

return Element
