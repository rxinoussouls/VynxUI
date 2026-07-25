local cloneref = require("../utils/cloneref")

local UserInputService = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateLabel = require("../components/ui/Label").New
local CreateInput = require("../components/ui/Input").New
local CreateDropdown = require("../components/ui/Dropdown").New

local CurrentCamera = workspace.CurrentCamera

local Element = {
	UICorner = 10,
	UIPadding = 12,
	MenuCorner = 14,
	MenuPadding = 4,
	TabPadding = 8,
	SearchBarHeight = 36,
	TabIcon = 16,
	ItemHeight = 32,
}

function Element:New(Config)
	local Values = Config.Values or {}
	local SearchBarEnabled = Config.SearchBarEnabled
	if SearchBarEnabled == nil then
		if Config.Search ~= nil then
			SearchBarEnabled = Config.Search
		elseif Config.EnableSearch ~= nil then
			SearchBarEnabled = Config.EnableSearch
		else
			SearchBarEnabled = #Values >= (Config.SearchThreshold or 7)
		end
	end

	local Compact = Config.Compact ~= false
	local Placement = string.lower(tostring(Config.Placement or Config.MenuPlacement or Config.Mode or ""))
	local DirectionName = string.lower(tostring(Config.Direction or Config.OpenDirection or ""))
	local Centered = Config.Centered == true
		or Config.Modal == true
		or Placement == "center"
		or Placement == "middle"
		or DirectionName == "center"
		or DirectionName == "middle"

	local Dropdown = {
		__type = "Dropdown",
		Title = Config.Title or "Dropdown",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Values = Values,
		MenuWidth = Config.MenuWidth or (Centered and 236 or (Compact and 164 or 180)),
		MenuMaxWidth = Config.MenuMaxWidth,
		MenuMaxHeight = Config.MenuMaxHeight or (Centered and 240 or nil),
		FullWidth = Config.FullWidth or Config.Full or Config.Mode == "Full" or Config.MenuMode == "Full",
		Direction = Centered and "Center" or (Config.Direction or Config.OpenDirection or "Auto"),
		Side = Config.Side or Config.Align or Config.Alignment or "Right",
		MobileDirection = Config.MobileDirection or Config.MobileOpenDirection,
		MobileSide = Config.MobileSide or Config.MobileAlign,
		Centered = Centered,
		CenterTarget = Config.CenterTarget or Config.CenterIn or "Window",
		CenterOffset = typeof(Config.CenterOffset) == "Vector2" and Config.CenterOffset or Vector2.new(0, 0),
		Backdrop = Centered and Config.Backdrop ~= false,
		BackdropTransparency = Creator.ClampTransparency(Config.BackdropTransparency, 0.84),
		Value = Config.Value,
		AllowNone = Config.AllowNone,
		SearchBarEnabled = SearchBarEnabled == true,
		SearchPlaceholder = Config.SearchPlaceholder or "Search...",
		Compact = Compact,
		Glass = Config.Glass == true,
		GlassTransparency = Config.GlassTransparency or Config.MenuTransparency or 0,
		ItemHeight = Config.ItemHeight or (Compact and Element.ItemHeight or 36),
		Multi = Config.Multi,
		Callback = Config.Callback or nil,

		UIElements = {},

		Opened = false,
		Tabs = {},

		Width = Config.Width or (Compact and 136 or 150),
	}

	if Dropdown.Multi and not Dropdown.Value then
		Dropdown.Value = {}
	end
	if Dropdown.Values and typeof(Dropdown.Value) == "number" then
		Dropdown.Value = Dropdown.Values[Dropdown.Value]
	end

	Dropdown.DropdownFrame = require("../components/window/Element")({
		Title = Dropdown.Title,
		Desc = Dropdown.Desc,
		Parent = Config.Parent,
		TextOffset = Dropdown.Callback and Dropdown.Width or 20,
		Hover = not Dropdown.Callback and true or false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Dropdown,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	if Dropdown.Callback then
		Dropdown.UIElements.Dropdown =
			CreateLabel("", nil, Dropdown.DropdownFrame.UIElements.Main, nil, Config.Window.NewElements and 12 or 10)

		Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = "AtEnd"
		Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size =
			UDim2.new(1, Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12, 0, 0)

		Dropdown.UIElements.Dropdown.Size = UDim2.new(0, Dropdown.Width, 0, Compact and 32 or 36)
		Dropdown.UIElements.Dropdown.Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0)
		Dropdown.UIElements.Dropdown.AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5)

		-- New("UIScale", {
		--     Parent = Dropdown.UIElements.Dropdown,
		--     Scale = .85,
		-- })
	end

	Dropdown.DropdownMenu = CreateDropdown(Config, Dropdown, Element, "Dropdown")

	Dropdown.Display = Dropdown.DropdownMenu.Display
	Dropdown.Refresh = Dropdown.DropdownMenu.Refresh
	Dropdown.Select = Dropdown.DropdownMenu.Select
	Dropdown.Open = Dropdown.DropdownMenu.Open
	Dropdown.Close = Dropdown.DropdownMenu.Close
	function Dropdown:Cleanup()
		Dropdown.DropdownMenu:Destroy()
	end

	local DropdownIcon = New("ImageLabel", {
		Image = Creator.Icon("chevrons-up-down")[1],
		ImageRectOffset = Creator.Icon("chevrons-up-down")[2].ImageRectPosition,
		ImageRectSize = Creator.Icon("chevrons-up-down")[2].ImageRectSize,
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(1, Dropdown.UIElements.Dropdown and -12 or 0, 0.5, 0),
		ThemeTag = {
			ImageColor3 = "Icon",
		},
		AnchorPoint = Vector2.new(1, 0.5),
		Parent = Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown.Frame
			or Dropdown.DropdownFrame.UIElements.Main,
	})

	function Dropdown:Lock()
		Dropdown.Locked = true
		if Dropdown.Opened or (Dropdown.UIElements.MenuCanvas and Dropdown.UIElements.MenuCanvas.Visible) then
			Dropdown:Close()
		end
		return Dropdown.DropdownFrame:Lock(Dropdown.LockedTitle)
	end
	function Dropdown:Unlock()
		Dropdown.Locked = false
		return Dropdown.DropdownFrame:Unlock()
	end

	if Dropdown.Locked then
		Dropdown:Lock()
	end

	return Dropdown.__type, Dropdown
end

return Element
