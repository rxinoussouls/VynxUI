-- FloatingMenu.lua
-- A small, self-contained floating overlay-menu helper, used by
-- PopUpButton.lua and PullDownButton.lua (both ported from Cascade).
--
-- Cascade's own floating menu (modules/dropdownMenu.luau +
-- structures/DropdownMenu.luau, ~700 lines together) does real anchor-
-- mode/viewport-clamping work, but it's wired to Cascade's reactive
-- theme system (`self.Theme.Controls.X[1]/[2]` Value objects driven by
-- its `binder`/`creator` modules) — pulling it in as-is would mean
-- vendoring Cascade's whole theme + self/window object model, not just
-- "a menu". That's a much bigger, riskier change than one helper file,
-- so this is a from-scratch rewrite of the same idea (button opens a
-- ScreenGui-parented list, positioned under the trigger, closes on
-- outside click) using VynxUI's own Creator.New / ThemeTag / cloneref.
-- Less polish than Cascade's version (no viewport-edge flipping, no
-- scroll clamping past MaxHeight) but fully wired to VynxUI's real
-- theme system rather than a second, disconnected one.
local Creator = require("../modules/Creator")
local New = Creator.New

local FloatingMenu = {}

-- Config: { VynxUI, Trigger (GuiObject), Items = {{Title, Callback}}, OnSelect }
function FloatingMenu.new(Config)
	local VynxUI = Config.VynxUI
	local Trigger = Config.Trigger

	local Menu = New("ScrollingFrame", {
		Name = "FloatingMenu",
		AutomaticSize = "Y",
		Size = UDim2.new(0, math.max(Trigger.AbsoluteSize.X, 140), 0, 0),
		AutomaticCanvasSize = "Y",
		CanvasSize = UDim2.new(),
		ScrollBarThickness = 3,
		BackgroundTransparency = 0,
		Visible = false,
		ZIndex = 1000,
		ThemeTag = { BackgroundColor3 = "Dialog", ScrollBarImageColor3 = "Text" },
	})
	New("UICorner", { Parent = Menu, CornerRadius = UDim.new(0, 8) })
	New("UIStroke", { Parent = Menu, Transparency = 0.9 })
	New("UIListLayout", { Parent = Menu, SortOrder = "LayoutOrder", Padding = UDim.new(0, 1) })
	New("UIPadding", {
		Parent = Menu,
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
	})

	local Overlay = New("Frame", {
		Name = "FloatingMenuOverlay",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 999,
	}, { Menu })

	Overlay.Parent = VynxUI.ScreenGui

	for Index, Item in ipairs(Config.Items or {}) do
		local ItemButton = New("TextButton", {
			Name = "Item",
			Text = Item.Title or "",
			TextXAlignment = "Left",
			AutomaticSize = "XY",
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundTransparency = 1,
			LayoutOrder = Index,
			ThemeTag = { TextColor3 = "Text" },
		})
		New("UIPadding", { Parent = ItemButton, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
		ItemButton.Parent = Menu
		ItemButton.MouseButton1Click:Connect(function()
			FloatingMenu.Close(Overlay)
			if Config.OnSelect then
				Creator.SafeCallback(Config.OnSelect, Item, Index)
			end
		end)
	end

	function FloatingMenu.Open()
		local AbsPos = Trigger.AbsolutePosition
		local AbsSize = Trigger.AbsoluteSize
		Menu.Position = UDim2.fromOffset(AbsPos.X, AbsPos.Y + AbsSize.Y + 4)
		Overlay.Visible = true
	end

	function FloatingMenu.Close(SelfOverlay)
		(SelfOverlay or Overlay).Visible = false
	end

	Overlay.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			-- Click landed on the transparent overlay itself (outside the menu) -> close.
			FloatingMenu.Close(Overlay)
		end
	end)

	return {
		Overlay = Overlay,
		Menu = Menu,
		Open = FloatingMenu.Open,
		Close = function()
			FloatingMenu.Close(Overlay)
		end,
	}
end

return FloatingMenu
