local DropdownMenu = {}

local cloneref = require("../../utils/cloneref")

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = cloneref(game:GetService("Players")).LocalPlayer:GetMouse()
local Workspace = cloneref(game:GetService("Workspace"))
local Camera = Workspace.CurrentCamera

local CurrentCamera = workspace.CurrentCamera

local Creator = require("../../modules/Creator")
local Motion = require("../../modules/Motion")
local New = Creator.New
local Tween = Creator.Tween

local TabBackgroundTransparency = 0.76

function DropdownMenu.New(Config, Dropdown, Element, Type)
	local DropdownModule = {}
	local CenterTarget = string.lower(tostring(Dropdown.CenterTarget or "Window"))
	local WindowMain = Config.Window and Config.Window.UIElements and Config.Window.UIElements.Main
	local WindowPopupRoot = if typeof(WindowMain) == "Instance"
		then WindowMain:FindFirstChild("Main") or WindowMain
		else nil
	local InternalCenter = Dropdown.Centered
		and CenterTarget ~= "screen"
		and CenterTarget ~= "viewport"
		and typeof(WindowPopupRoot) == "Instance"
	local PopupParent = if InternalCenter then WindowPopupRoot else Config.WindUI.DropdownGui
	local PersistentConnections = {}

	Dropdown.InternalCenter = InternalCenter
	Dropdown.PopupParent = PopupParent

	if not Dropdown.Callback then
		Type = "Menu"
	end

	Dropdown.UIElements.UIListLayout = New("UIListLayout", {
		Padding = UDim.new(0, Element.MenuPadding / 1.5),
		FillDirection = "Vertical",
		HorizontalAlignment = "Center",
	})

	Dropdown.UIElements.Menu = Creator.NewRoundFrame(
		Element.MenuCorner,
		Dropdown.Glass and "SquircleGlass" or "Squircle",
		{
			ThemeTag = {
				ImageColor3 = "DropdownBackground",
			},
			ImageTransparency = 1, -- 0.05
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			ZIndex = 242,
		},
		{
			New("UIPadding", {
				PaddingTop = UDim.new(0, Element.MenuPadding),
				PaddingLeft = UDim.new(0, Element.MenuPadding),
				PaddingRight = UDim.new(0, Element.MenuPadding),
				PaddingBottom = UDim.new(0, Element.MenuPadding),
			}),
			New("UIListLayout", {
				FillDirection = "Vertical",
				Padding = UDim.new(0, Element.MenuPadding),
			}),
			New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, Dropdown.SearchBarEnabled and -Element.MenuPadding - Element.SearchBarHeight),
				--Name = "CanvasGroup",
				ClipsDescendants = true,
				LayoutOrder = 999,
				Name = "Frame",
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, Element.MenuCorner - Element.MenuPadding),
				}),
				New("ScrollingFrame", {
					Size = UDim2.new(1, 0, 1, 0),
					ScrollBarThickness = 0,
					ScrollingDirection = "Y",
					AutomaticCanvasSize = "Y",
					CanvasSize = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					ScrollBarImageTransparency = 1,
				}, {
					Dropdown.UIElements.UIListLayout,
				}),
			}),
		}
	)
	Dropdown.UIElements.MenuScale = New("UIScale", {
		Name = "MenuScale",
		Scale = 1,
		Parent = Dropdown.UIElements.Menu,
	})

	if Dropdown.Centered and Dropdown.Backdrop then
		Dropdown.UIElements.Backdrop = New("TextButton", {
			Name = "DropdownBackdrop",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Visible = false,
			Active = true,
			ZIndex = 240,
			Parent = PopupParent,
		})
	end

	Dropdown.UIElements.MenuCanvas = New("Frame", {
		Size = UDim2.new(0, Dropdown.MenuWidth, 0, 300),
		BackgroundTransparency = 1,
		Position = UDim2.new(-10, 0, -10, 0),
		Visible = false,
		Active = false,
		ZIndex = 241,
		--GroupTransparency = 1, -- 0
		Parent = PopupParent,
		AnchorPoint = Vector2.new(1, 0),
	}, {
		Dropdown.UIElements.Menu,
		New("UISizeConstraint", {
			MinSize = Vector2.new(Dropdown.Compact and 148 or 170, 0),
			MaxSize = Vector2.new(Dropdown.MenuMaxWidth or 420, Dropdown.MenuMaxHeight or 340),
		}),
	})

	local function GetLayoutScale()
		local Scale = Config.UIScale or Creator.UIScale or 1
		return Scale > 0 and Scale or 1
	end

	local function GetVisibleContentHeight()
		local ContentHeight = 0
		local VisibleItems = 0
		local Scale = GetLayoutScale()
		local ScrollingFrame = Dropdown.UIElements.Menu.Frame.ScrollingFrame

		for _, Child in next, ScrollingFrame:GetChildren() do
			if Child:IsA("GuiObject") and Child.Visible then
				local Height = Child.AbsoluteSize.Y / Scale
				if Height <= 0 then
					Height = Child.Size.Y.Offset > 0 and Child.Size.Y.Offset or Dropdown.ItemHeight
				end

				ContentHeight += Height
				VisibleItems += 1
			end
		end

		if VisibleItems > 1 then
			ContentHeight += Dropdown.UIElements.UIListLayout.Padding.Offset * (VisibleItems - 1)
		end

		return ContentHeight
	end

	local function RecalculateCanvasSize()
		Dropdown.UIElements.Menu.Frame.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, GetVisibleContentHeight())
	end

	local function GetDropdownButton()
		return Dropdown.UIElements.Dropdown or Dropdown.DropdownFrame.UIElements.Main
	end

	local function GetViewportSize()
		if InternalCenter and typeof(PopupParent) == "Instance" and PopupParent:IsA("GuiObject") then
			return PopupParent.AbsoluteSize / GetLayoutScale()
		end
		if Config.WindUI.DropdownGui and Config.WindUI.DropdownGui.AbsoluteSize.X > 0 then
			return Config.WindUI.DropdownGui.AbsoluteSize
		end
		local CurrentCamera = Workspace.CurrentCamera or Camera
		return CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	end

	local function GetInputPosition(Input)
		if Input and typeof(Input.Position) == "Vector3" then
			return Vector2.new(Input.Position.X, Input.Position.Y)
		end
		return Vector2.new(Mouse.X, Mouse.Y)
	end

	local function ContainsPoint(Object, Point)
		if typeof(Object) ~= "Instance" or not Object.Visible then
			return false
		end

		local AbsolutePosition = Object.AbsolutePosition
		local AbsoluteSize = Object.AbsoluteSize

		return Point.X >= AbsolutePosition.X
			and Point.X <= AbsolutePosition.X + AbsoluteSize.X
			and Point.Y >= AbsolutePosition.Y
			and Point.Y <= AbsolutePosition.Y + AbsoluteSize.Y
	end

	local function NormalizeDirection(Value, Default)
		local Direction = tostring(Value or Default or "Auto")
		Direction = Direction:sub(1, 1):upper() .. Direction:sub(2):lower()
		if
			Direction ~= "Auto"
			and Direction ~= "Down"
			and Direction ~= "Up"
			and Direction ~= "Left"
			and Direction ~= "Right"
		then
			return Default or "Auto"
		end
		return Direction
	end

	local function NormalizeSide(Value, Default)
		local Side = tostring(Value or Default or "Right")
		Side = Side:sub(1, 1):upper() .. Side:sub(2):lower()
		if Side ~= "Left" and Side ~= "Center" and Side ~= "Right" then
			return Default or "Right"
		end
		return Side
	end

	local function IsMobileViewport()
		local Viewport = GetViewportSize()
		return Config.Window.IsPC == false
			or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
			or Viewport.X <= 640
	end

	local function GetCanvasWidth()
		local button = GetDropdownButton()
		local Viewport = GetViewportSize()
		local Padding = math.max(Element.MenuPadding * 2, 8)
		local MaxWidth = math.max(
			120,
			math.min(Dropdown.MenuMaxWidth or (IsMobileViewport() and 320 or 420), Viewport.X - (Padding * 2))
		)
		local MinWidth = math.min(Dropdown.Compact and 148 or 170, MaxWidth)
		local TriggerWidth = if button.AbsoluteSize.X > 0
			then button.AbsoluteSize.X / (InternalCenter and GetLayoutScale() or 1)
			else Dropdown.MenuWidth
		local Width = Dropdown.FullWidth and math.max(TriggerWidth, Dropdown.MenuWidth) or Dropdown.MenuWidth

		return math.floor(math.clamp(Width, MinWidth, MaxWidth) + 0.5)
	end

	local function ApplyCanvasWidth()
		local Width = GetCanvasWidth()
		Dropdown.UIElements.MenuCanvas.Size = UDim2.new(
			0,
			Width,
			Dropdown.UIElements.MenuCanvas.Size.Y.Scale,
			Dropdown.UIElements.MenuCanvas.Size.Y.Offset
		)
		return Width
	end

	local function RecalculateListSize()
		local CanvasWidth = ApplyCanvasWidth()

		local Viewport = GetViewportSize()
		local MinHeight = Dropdown.SearchBarEnabled and (Element.SearchBarHeight + 44) or 44
		local MaxHeight = math.max(
			MinHeight,
			math.min(
				Dropdown.MenuMaxHeight or (IsMobileViewport() and 280 or 340),
				Viewport.Y - (Element.MenuPadding * 4)
			)
		)

		local ContentY = GetVisibleContentHeight()
		local SearchBarOffset = Dropdown.SearchBarEnabled and (Element.SearchBarHeight + (Element.MenuPadding * 3))
			or (Element.MenuPadding * 2)
		local TotalY = ContentY + SearchBarOffset

		if TotalY > MaxHeight then
			Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(CanvasWidth, MaxHeight)
		else
			Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(CanvasWidth, TotalY)
		end
	end

	function UpdatePosition()
		local button = GetDropdownButton()
		local menu = Dropdown.UIElements.MenuCanvas
		local viewport = GetViewportSize()
		local padding = Element.MenuPadding * 2
		local mobile = IsMobileViewport()
		local direction = NormalizeDirection(
			mobile and (Dropdown.MobileDirection or Dropdown.Direction) or Dropdown.Direction,
			"Auto"
		)
		local side =
			NormalizeSide(mobile and (Dropdown.MobileSide or "Center") or Dropdown.Side, mobile and "Center" or "Right")
		local buttonPosition = button.AbsolutePosition
		local buttonSize = button.AbsoluteSize
		local menuSize = menu.AbsoluteSize / (InternalCenter and GetLayoutScale() or 1)

		if menuSize.X <= 0 or menuSize.Y <= 0 then
			menuSize = Vector2.new(menu.Size.X.Offset, menu.Size.Y.Offset)
		end

		if Dropdown.Centered then
			if InternalCenter then
				local Offset = Dropdown.CenterOffset or Vector2.new(0, 0)
				local HalfWidth = menuSize.X / 2
				local HalfHeight = menuSize.Y / 2
				local x = math.clamp((viewport.X / 2) + Offset.X, padding + HalfWidth, viewport.X - padding - HalfWidth)
				local y =
					math.clamp((viewport.Y / 2) + Offset.Y, padding + HalfHeight, viewport.Y - padding - HalfHeight)

				menu.AnchorPoint = Vector2.new(0.5, 0.5)
				menu.Position = UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
				Dropdown.UIElements.Menu.AnchorPoint = Vector2.new(0.5, 0.5)
				Dropdown.UIElements.Menu.Position = UDim2.fromScale(0.5, 0.5)
				return "Center"
			end

			local CenterPosition = Vector2.new(0, 0)
			local CenterSize = viewport
			local CenterTarget = string.lower(tostring(Dropdown.CenterTarget or "Window"))
			local WindowMain = Config.Window and Config.Window.UIElements and Config.Window.UIElements.Main

			if
				CenterTarget ~= "screen"
				and CenterTarget ~= "viewport"
				and typeof(WindowMain) == "Instance"
				and WindowMain.Visible
				and WindowMain.AbsoluteSize.X > 0
			then
				CenterPosition = WindowMain.AbsolutePosition
				CenterSize = WindowMain.AbsoluteSize
			end

			local Offset = Dropdown.CenterOffset or Vector2.new(0, 0)
			local x = CenterPosition.X + (CenterSize.X / 2) + Offset.X
			local y = CenterPosition.Y + (CenterSize.Y / 2) + Offset.Y
			local HalfWidth = menuSize.X / 2
			local HalfHeight = menuSize.Y / 2
			x = math.clamp(x, padding + HalfWidth, viewport.X - padding - HalfWidth)
			y = math.clamp(y, padding + HalfHeight, viewport.Y - padding - HalfHeight)

			menu.AnchorPoint = Vector2.new(0.5, 0.5)
			menu.Position = UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
			Dropdown.UIElements.Menu.AnchorPoint = Vector2.new(0.5, 0.5)
			Dropdown.UIElements.Menu.Position = UDim2.fromScale(0.5, 0.5)
			return "Center"
		end

		if mobile and not Dropdown.MobileDirection and (direction == "Left" or direction == "Right") then
			direction = "Auto"
		end

		if direction == "Left" and buttonPosition.X - padding < menuSize.X then
			direction = "Auto"
		elseif direction == "Right" and viewport.X - (buttonPosition.X + buttonSize.X) - padding < menuSize.X then
			direction = "Auto"
		end

		if direction == "Auto" then
			local below = viewport.Y - (buttonPosition.Y + buttonSize.Y) - padding
			local above = buttonPosition.Y - padding
			if below >= menuSize.Y or below >= above then
				direction = "Down"
			else
				direction = "Up"
			end
		end

		if direction ~= "Up" and direction ~= "Left" and direction ~= "Right" then
			direction = "Down"
		end

		local x
		local y
		local anchor = Vector2.new(1, 0)

		if direction == "Left" then
			x = buttonPosition.X - padding
			y = buttonPosition.Y
			anchor = Vector2.new(1, 0)
		elseif direction == "Right" then
			x = buttonPosition.X + buttonSize.X + padding
			y = buttonPosition.Y
			anchor = Vector2.new(0, 0)
		elseif direction == "Up" then
			y = buttonPosition.Y - padding
			anchor = Vector2.new(side == "Left" and 0 or side == "Center" and 0.5 or 1, 1)
			if side == "Left" then
				x = buttonPosition.X
			elseif side == "Center" then
				x = buttonPosition.X + (buttonSize.X / 2)
			else
				x = buttonPosition.X + buttonSize.X
			end
		else
			y = buttonPosition.Y + buttonSize.Y + padding
			anchor = Vector2.new(side == "Left" and 0 or side == "Center" and 0.5 or 1, 0)
			if side == "Left" then
				x = buttonPosition.X
			elseif side == "Center" then
				x = buttonPosition.X + (buttonSize.X / 2)
			else
				x = buttonPosition.X + buttonSize.X
			end
		end

		local left = x - (anchor.X * menuSize.X)
		local top = y - (anchor.Y * menuSize.Y)

		if left < padding then
			x += padding - left
		elseif left + menuSize.X > viewport.X - padding then
			x -= (left + menuSize.X) - (viewport.X - padding)
		end

		if top < padding then
			y += padding - top
		elseif top + menuSize.Y > viewport.Y - padding then
			y -= (top + menuSize.Y) - (viewport.Y - padding)
		end

		menu.AnchorPoint = anchor
		menu.Position = UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
		Dropdown.UIElements.Menu.AnchorPoint = direction == "Left" and Vector2.new(1, 0)
			or direction == "Right" and Vector2.new(0, 0)
			or direction == "Up" and Vector2.new(1, 1)
			or Vector2.new(1, 0)
		Dropdown.UIElements.Menu.Position = direction == "Left" and UDim2.new(1, 0, 0, 0)
			or direction == "Right" and UDim2.new(0, 0, 0, 0)
			or direction == "Up" and UDim2.new(1, 0, 1, 0)
			or UDim2.new(1, 0, 0, 0)

		return direction
	end

	local SearchLabel
	local SearchQuery = ""
	local SearchBox
	local ApplySearchFilter

	local function CreateSearchBar()
		local Radius = math.max(Element.MenuCorner - Element.MenuPadding, 6)
		local IconData = Creator.Icon("search")

		SearchBox = New("TextBox", {
			Name = "TextBox",
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
			PlaceholderText = Dropdown.SearchPlaceholder,
			Text = SearchQuery,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 16,
			TextScaled = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			ThemeTag = {
				PlaceholderColor3 = "PlaceholderText",
				TextColor3 = "Text",
			},
			Size = UDim2.new(1, -31, 1, 0),
		})

		local SearchFrame = Creator.NewRoundFrame(Radius, "Squircle", {
			Name = "SearchBar",
			LayoutOrder = 0,
			Parent = Dropdown.UIElements.Menu,
			Size = UDim2.new(1, 0, 0, Element.SearchBarHeight),
			ImageTransparency = 0,
			ThemeTag = {
				ImageColor3 = "DropdownTabBackground",
			},
		}, {
			Creator.NewRoundFrame(Radius, "Squircle", {
				Name = "Outline",
				Size = UDim2.new(1, 1, 1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ImageTransparency = 0.8,
				ThemeTag = {
					ImageColor3 = "DropdownTabBorder",
				},
			}),
			New("Frame", {
				Name = "Content",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
			}, {
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
				}),
				New("UIListLayout", {
					FillDirection = "Horizontal",
					HorizontalAlignment = "Left",
					VerticalAlignment = "Center",
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				New("ImageLabel", {
					Name = "Icon",
					BackgroundTransparency = 1,
					Image = IconData[1],
					ImageRectOffset = IconData[2].ImageRectPosition,
					ImageRectSize = IconData[2].ImageRectSize,
					ImageTransparency = 0.18,
					Size = UDim2.new(0, 19, 0, 19),
					ThemeTag = {
						ImageColor3 = "Icon",
					},
				}),
				SearchBox,
			}),
		})

		Creator.AddSignal(SearchBox:GetPropertyChangedSignal("Text"), function()
			ApplySearchFilter(SearchBox.Text)
		end)

		Creator.AddSignal(SearchBox.Focused, function()
			Tween(SearchFrame.Outline, 0.12, { ImageTransparency = 0.48 }):Play()
		end)

		Creator.AddSignal(SearchBox.FocusLost, function()
			Tween(SearchFrame.Outline, 0.12, { ImageTransparency = 0.8 }):Play()
		end)

		return SearchFrame
	end

	local function GetSearchText(Tab)
		local parts = {
			Tab.Name,
			Tab.Desc,
		}

		if typeof(Tab.Original) == "table" then
			table.insert(parts, Tab.Original.Value)
			table.insert(parts, Tab.Original.Id)
			table.insert(parts, Tab.Original.Key)
		end

		local normalized = {}
		for _, part in next, parts do
			if part ~= nil then
				table.insert(normalized, tostring(part))
			end
		end

		return string.lower(table.concat(normalized, " "))
	end

	function ApplySearchFilter(Query)
		SearchQuery = tostring(Query or "")
		local NormalizedQuery = string.lower(SearchQuery)

		for _, tab in next, Dropdown.Tabs do
			if tab.UIElements and tab.UIElements.TabItem then
				local TabItem = tab.UIElements.TabItem
				local Visible = NormalizedQuery == ""
					or string.find(GetSearchText(tab), NormalizedQuery, 1, true) ~= nil
				if Visible then
					if not TabItem.Parent then
						TabItem.Parent = Dropdown.UIElements.Menu.Frame.ScrollingFrame
					end
					TabItem.Visible = true
					TabItem.Size = tab.Size
					TabItem.AutomaticSize = tab.AutomaticSize
				else
					TabItem.Visible = false
				end
			end
		end

		RecalculateCanvasSize()
		RecalculateListSize()

		if Dropdown.UIElements.MenuCanvas.Visible then
			UpdatePosition()
		end

		task.defer(function()
			if Config.Window.Destroyed then
				return
			end

			RecalculateCanvasSize()
			RecalculateListSize()

			if Dropdown.UIElements.MenuCanvas.Visible then
				UpdatePosition()
			end
		end)
	end

	function DropdownModule:Display()
		local Values = Dropdown.Values
		local Str = ""

		if Dropdown.Multi then
			local selected = {}
			if typeof(Dropdown.Value) == "table" then
				for _, item in ipairs(Dropdown.Value) do
					local title = typeof(item) == "table" and item.Title or item
					selected[title] = true
				end
			end

			for _, value in ipairs(Values) do
				local title = typeof(value) == "table" and value.Title or value
				if selected[title] then
					Str = Str .. title .. ", "
				end
			end

			if #Str > 0 then
				Str = Str:sub(1, #Str - 2)
			end
		else
			Str = typeof(Dropdown.Value) == "table" and (Dropdown.Value.Title or Dropdown.Value[1])
				or Dropdown.Value
				or ""
		end

		if Dropdown.UIElements.Dropdown then
			Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Text = (Str == "" and "--" or Str)
		end
	end

	local function Callback(customCallback)
		DropdownModule:Display()
		if Dropdown.Locked then
			return
		end

		if Dropdown.Callback then
			task.spawn(function()
				if Dropdown.Locked then
					return
				end
				Creator.SafeCallback(Dropdown.Callback, Dropdown.Value)
			end)
		else
			task.spawn(function()
				if Dropdown.Locked then
					return
				end
				Creator.SafeCallback(customCallback)
			end)
		end
	end

	function DropdownModule:LockValues(lockedItems)
		if not lockedItems then
			return
		end

		for _, tab in next, Dropdown.Tabs do
			if tab and tab.UIElements and tab.UIElements.TabItem then
				local itemName = tab.Name
				local isLocked = false

				for _, lockedItem in next, lockedItems do
					if itemName == lockedItem then
						isLocked = true
						break
					end
				end

				if isLocked then
					Tween(tab.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
					--Tween(tab.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
					Tween(tab.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0.6 }):Play()
					if tab.UIElements.TabIcon then
						Tween(tab.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0.6 }):Play()
					end

					tab.UIElements.TabItem.Active = false
					tab.Locked = true
				else
					if tab.Selected then
						Tween(tab.UIElements.TabItem, 0.1, { ImageTransparency = TabBackgroundTransparency }):Play()
						--Tween(tab.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 0.75 }):Play()
						Tween(tab.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0 }):Play()
						if tab.UIElements.TabIcon then
							Tween(tab.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0 }):Play()
						end
					else
						Tween(tab.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
						--Tween(tab.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
						Tween(
							tab.UIElements.TabItem.Frame.Title.TextLabel,
							0.1,
							{ TextTransparency = Type == "Dropdown" and 0.4 or 0.05 }
						):Play()
						if tab.UIElements.TabIcon then
							Tween(
								tab.UIElements.TabIcon.ImageLabel,
								0.1,
								{ ImageTransparency = Type == "Dropdown" and 0.2 or 0 }
							):Play()
						end
					end

					tab.UIElements.TabItem.Active = true
					tab.Locked = false
				end
			end
		end
	end

	function DropdownModule:Refresh(Values)
		if Config.Window.Destroyed then
			return
		end

		for _, Tab in next, Dropdown.Tabs do
			if Tab.UIElements and Tab.UIElements.TabItem then
				Tab.UIElements.TabItem:Destroy()
			end
		end

		for _, Elementt in next, Dropdown.UIElements.Menu.Frame.ScrollingFrame:GetChildren() do
			if not Elementt:IsA("UIListLayout") then
				Elementt:Destroy()
			end
		end

		Dropdown.Tabs = {}

		if Dropdown.SearchBarEnabled then
			if not SearchLabel then
				SearchLabel = CreateSearchBar()
			elseif SearchBox then
				SearchBox.PlaceholderText = Dropdown.SearchPlaceholder
			end
		end

		for Index, Tab in next, Values do
			if typeof(Tab) ~= "table" or Tab.Type ~= "Divider" then
				local TabMain = {
					Name = typeof(Tab) == "table" and Tab.Title or Tab,
					Desc = typeof(Tab) == "table" and Tab.Desc or nil,
					Icon = typeof(Tab) == "table" and Tab.Icon or nil,
					IconSize = typeof(Tab) == "table" and Tab.IconSize or nil,
					Original = Tab,
					Selected = false,
					Locked = typeof(Tab) == "table" and Tab.Locked or false,
					UIElements = {},
				}
				local TabIcon
				if TabMain.Icon then
					TabIcon = Creator.Image(TabMain.Icon, TabMain.Icon, 0, Config.Window.Folder, "Dropdown", true)
					TabIcon.Size =
						UDim2.new(0, TabMain.IconSize or Element.TabIcon, 0, TabMain.IconSize or Element.TabIcon)
					TabIcon.ImageLabel.ImageTransparency = Type == "Dropdown" and 0.2 or 0
					TabMain.UIElements.TabIcon = TabIcon
				end
				TabMain.UIElements.TabItem = Creator.NewRoundFrame(
					Element.MenuCorner - Element.MenuPadding,
					"Squircle",
					{
						Size = UDim2.new(1, 0, 0, Dropdown.ItemHeight),
						AutomaticSize = TabMain.Desc and "Y",
						LayoutOrder = typeof(Index) == "number" and Index or 0,
						ImageTransparency = 1, -- 0
						Parent = Dropdown.UIElements.Menu.Frame.ScrollingFrame,
						--ImageColor3 = Color3.new(1, 1, 1),
						ThemeTag = {
							ImageColor3 = "DropdownTabBackground",
						},
						Active = not TabMain.Locked,
					},
					{
						Creator.NewRoundFrame(Element.MenuCorner - Element.MenuPadding, "Glass-1.4", {
							Size = UDim2.new(1, 0, 1, 0),
							ThemeTag = {
								ImageColor3 = "DropdownTabBorder",
							},
							ImageTransparency = 1, -- .75
							Name = "Highlight",
						}, {
							-- New("UIGradient", {
							--     Rotation = 80,
							--     Color = ColorSequence.new({
							--         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
							--     }),
							--     Transparency = NumberSequence.new({
							--         NumberSequenceKeypoint.new(0.0, 0.1),
							--         NumberSequenceKeypoint.new(0.5, 1),
							--         NumberSequenceKeypoint.new(1.0, 0.1),
							--     })
							-- }),
						}),
						New("Frame", {
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
						}, {
							New("UIListLayout", {
								Padding = UDim.new(0, Element.TabPadding),
								FillDirection = "Horizontal",
								VerticalAlignment = "Center",
							}),
							New("UIPadding", {
								PaddingTop = UDim.new(0, Element.TabPadding),
								PaddingLeft = UDim.new(0, Element.TabPadding),
								PaddingRight = UDim.new(0, Element.TabPadding),
								PaddingBottom = UDim.new(0, Element.TabPadding),
							}),
							New("UICorner", {
								CornerRadius = UDim.new(0, Element.MenuCorner - Element.MenuPadding),
							}),
							TabIcon,
							New("Frame", {
								Size = UDim2.new(1, TabIcon and -Element.TabPadding - Element.TabIcon or 0, 0, 0),
								BackgroundTransparency = 1,
								AutomaticSize = "Y",
								Name = "Title",
							}, {
								New("TextLabel", {
									Text = TabMain.Name,
									TextXAlignment = "Left",
									FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
									ThemeTag = {
										TextColor3 = "Text",
										BackgroundColor3 = "Text",
									},
									TextSize = 14,
									BackgroundTransparency = 1,
									TextTransparency = Type == "Dropdown" and 0.4 or 0.05,
									LayoutOrder = 999,
									AutomaticSize = "Y",
									TextTruncate = "AtEnd",
									Size = UDim2.new(1, 0, 0, 0),
								}),
								New("TextLabel", {
									Text = TabMain.Desc or "",
									TextXAlignment = "Left",
									FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
									ThemeTag = {
										TextColor3 = "Text",
										BackgroundColor3 = "Text",
									},
									TextSize = 13,
									BackgroundTransparency = 1,
									TextTransparency = Type == "Dropdown" and 0.6 or 0.35,
									LayoutOrder = 999,
									AutomaticSize = "Y",
									TextWrapped = true,
									Size = UDim2.new(1, 0, 0, 0),
									Visible = TabMain.Desc and true or false,
									Name = "Desc",
								}),
								New("UIListLayout", {
									Padding = UDim.new(0, Element.TabPadding / 3),
									FillDirection = "Vertical",
								}),
							}),
						}),
					},
					true
				)
				TabMain.Size = TabMain.UIElements.TabItem.Size
				TabMain.AutomaticSize = TabMain.UIElements.TabItem.AutomaticSize

				if TabMain.Locked then
					TabMain.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0.6
					if TabMain.UIElements.TabIcon then
						TabMain.UIElements.TabIcon.ImageLabel.ImageTransparency = 0.6
					end
				end

				if Dropdown.Multi and typeof(Dropdown.Value) == "string" then
					for _, i in next, Dropdown.Values do
						if typeof(i) == "table" then
							if i.Title == Dropdown.Value then
								Dropdown.Value = { i }
							end
						else
							if i == Dropdown.Value then
								Dropdown.Value = { Dropdown.Value }
							end
						end
					end
				end

				if Dropdown.Multi then
					local found = false
					if typeof(Dropdown.Value) == "table" then
						for _, item in ipairs(Dropdown.Value) do
							local itemName = typeof(item) == "table" and item.Title or item
							if itemName == TabMain.Name then
								found = true
								break
							end
						end
					end
					TabMain.Selected = found
				else
					local currentValue = typeof(Dropdown.Value) == "table" and Dropdown.Value.Title or Dropdown.Value
					TabMain.Selected = currentValue == TabMain.Name
				end

				if TabMain.Selected and not TabMain.Locked then
					TabMain.UIElements.TabItem.ImageTransparency = TabBackgroundTransparency
					--TabMain.UIElements.TabItem.Highlight.ImageTransparency = 0.75
					TabMain.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0
					if TabMain.UIElements.TabIcon then
						TabMain.UIElements.TabIcon.ImageLabel.ImageTransparency = 0
					end
				end

				Dropdown.Tabs[Index] = TabMain

				DropdownModule:Display()

				if Type == "Dropdown" then
					Creator.AddSignal(TabMain.UIElements.TabItem.MouseButton1Click, function()
						if Dropdown.Locked or TabMain.Locked then
							return
						end

						if Dropdown.Multi then
							if not TabMain.Selected then
								TabMain.Selected = true
								Tween(
									TabMain.UIElements.TabItem,
									0.1,
									{ ImageTransparency = TabBackgroundTransparency }
								):Play()
								--Tween(TabMain.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 0.75 }):Play()
								Tween(TabMain.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0 }):Play()
								if TabMain.UIElements.TabIcon then
									Tween(TabMain.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0 }):Play()
								end
								table.insert(Dropdown.Value, TabMain.Original)
							else
								if not Dropdown.AllowNone and #Dropdown.Value == 1 then
									return
								end
								TabMain.Selected = false
								Tween(TabMain.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
								--Tween(TabMain.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
								Tween(TabMain.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0.4 }):Play()
								if TabMain.UIElements.TabIcon then
									Tween(TabMain.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0.2 }):Play()
								end

								for i, v in next, Dropdown.Value do
									if typeof(v) == "table" and (v.Title == TabMain.Name) or (v == TabMain.Name) then
										table.remove(Dropdown.Value, i)
										break
									end
								end
							end
						else
							for Index, TabPisun in next, Dropdown.Tabs do
								Tween(TabPisun.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
								--Tween(TabPisun.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
								Tween(
									TabPisun.UIElements.TabItem.Frame.Title.TextLabel,
									0.1,
									{ TextTransparency = 0.4 }
								):Play()
								if TabPisun.UIElements.TabIcon then
									Tween(TabPisun.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0.2 }):Play()
								end
								TabPisun.Selected = false
							end
							TabMain.Selected = true
							Tween(TabMain.UIElements.TabItem, 0.1, { ImageTransparency = TabBackgroundTransparency }):Play()
							--Tween(TabMain.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 0.75 }):Play()
							Tween(TabMain.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0 }):Play()
							if TabMain.UIElements.TabIcon then
								Tween(TabMain.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0 }):Play()
							end
							Dropdown.Value = TabMain.Original
						end
						Callback()
						if not Dropdown.Multi then
							DropdownModule:Close()
						end
					end)
				elseif Type == "Menu" then
					if not TabMain.Locked then
						Creator.AddSignal(TabMain.UIElements.TabItem.MouseEnter, function()
							Tween(TabMain.UIElements.TabItem, 0.08, { ImageTransparency = TabBackgroundTransparency }):Play()
						end)
						Creator.AddSignal(TabMain.UIElements.TabItem.InputEnded, function()
							Tween(TabMain.UIElements.TabItem, 0.08, { ImageTransparency = 1 }):Play()
						end)
					end
					Creator.AddSignal(TabMain.UIElements.TabItem.MouseButton1Click, function()
						if Dropdown.Locked or TabMain.Locked then
							return
						end
						Callback(Tab.Callback or function() end)
						DropdownModule:Close()
					end)
				end

				RecalculateCanvasSize()
				RecalculateListSize()
			else
				require("../../elements/Divider"):New({ Parent = Dropdown.UIElements.Menu.Frame.ScrollingFrame })
			end
		end

		-- local maxWidth = Dropdown.MenuWidth or 0
		-- if maxWidth == 0 then
		--     for _, tabmain in next, Dropdown.Tabs do
		--         if tabmain.UIElements.TabItem.Frame.UIListLayout then
		--             maxWidth = math.max(maxWidth, tabmain.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X)
		--         end
		--     end
		-- end

		ApplyCanvasWidth()
		ApplySearchFilter(SearchQuery)
		Callback()

		Dropdown.Values = Values
	end

	DropdownModule:Refresh(Dropdown.Values)

	function DropdownModule:Select(Items)
		if Items then
			Dropdown.Value = Items
		else
			if Dropdown.Multi then
				Dropdown.Value = {}
			else
				Dropdown.Value = nil
			end
		end
		DropdownModule:Refresh(Dropdown.Values)
	end

	RecalculateListSize()
	RecalculateCanvasSize()

	local MenuMotionToken = 0
	local LastDirection = "Down"

	function DropdownModule:Open()
		if not Dropdown.Locked then
			MenuMotionToken += 1
			local Token = MenuMotionToken
			Dropdown.UIElements.Menu.Visible = true
			Dropdown.UIElements.MenuCanvas.Visible = true
			Dropdown.UIElements.MenuCanvas.Active = true
			RecalculateListSize()
			RecalculateCanvasSize()
			LastDirection = UpdatePosition()
			local Horizontal = LastDirection == "Left" or LastDirection == "Right"
			if Dropdown.Centered then
				Dropdown.UIElements.Menu.Size = UDim2.fromScale(1, 1)
				Dropdown.UIElements.MenuScale.Scale = 0.9
				Motion.Play(
					Dropdown.UIElements.MenuScale,
					"DropdownOpen",
					{ Scale = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"CenterScale"
				)
				if Dropdown.UIElements.Backdrop then
					Dropdown.UIElements.Backdrop.Visible = true
					Dropdown.UIElements.Backdrop.BackgroundTransparency = 1
					Motion.Play(Dropdown.UIElements.Backdrop, "DropdownOpen", {
						BackgroundTransparency = Dropdown.BackdropTransparency,
					}, nil, nil, "Backdrop")
				end
			else
				Dropdown.UIElements.Menu.Size = Horizontal and UDim2.new(0, 0, 1, 0) or UDim2.new(1, 0, 0, 0)
			end
			Motion.Play(Dropdown.UIElements.Menu, "DropdownOpen", {
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = Dropdown.Glass and Dropdown.GlassTransparency or 0,
			}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, "OpenClose")

			task.spawn(function()
				task.wait(Motion.GetDuration("DropdownOpen"))
				if Dropdown.Locked or MenuMotionToken ~= Token then
					return
				end
				Dropdown.Opened = true
			end)

			UpdatePosition()
		end
	end

	function DropdownModule:Close()
		MenuMotionToken += 1
		local Token = MenuMotionToken
		Dropdown.Opened = false

		local Horizontal = LastDirection == "Left" or LastDirection == "Right"
		local CloseSize = if Dropdown.Centered
			then UDim2.fromScale(1, 1)
			else Horizontal and UDim2.new(0, 0, 1, 0) or UDim2.new(1, 0, 0, 0)
		Motion.Play(Dropdown.UIElements.Menu, "DropdownClose", {
			Size = CloseSize,
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, "OpenClose")
		if Dropdown.Centered then
			Motion.Play(Dropdown.UIElements.MenuScale, "DropdownClose", { Scale = 0.92 }, nil, nil, "CenterScale")
			if Dropdown.UIElements.Backdrop then
				Motion.Play(
					Dropdown.UIElements.Backdrop,
					"DropdownClose",
					{ BackgroundTransparency = 1 },
					nil,
					nil,
					"Backdrop"
				)
			end
		end

		task.spawn(function()
			task.wait(Motion.GetDuration("DropdownClose"))
			if MenuMotionToken ~= Token then
				return
			end
			Dropdown.UIElements.Menu.Visible = false
			Dropdown.UIElements.MenuCanvas.Visible = false
			Dropdown.UIElements.MenuCanvas.Active = false
			if Dropdown.UIElements.Backdrop then
				Dropdown.UIElements.Backdrop.Visible = false
			end
		end)
	end

	if Dropdown.UIElements.Backdrop then
		Creator.AddSignal(Dropdown.UIElements.Backdrop.MouseButton1Click, function()
			DropdownModule:Close()
		end)
	end

	Creator.AddSignal(
		(
			Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown.MouseButton1Click
			or Dropdown.DropdownFrame.UIElements.Main.MouseButton1Click
		),
		function()
			if Dropdown.Opened or Dropdown.UIElements.MenuCanvas.Visible then
				DropdownModule:Close()
			else
				DropdownModule:Open()
			end
		end
	)

	table.insert(
		PersistentConnections,
		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				local menuCanvas = Dropdown.UIElements.MenuCanvas
				local DropdownButton = Dropdown.UIElements.Dropdown or Dropdown.DropdownFrame.UIElements.Main
				local InputPosition = GetInputPosition(Input)
				local isClickOnDropdown = ContainsPoint(DropdownButton, InputPosition)
				local isClickOnMenu = ContainsPoint(menuCanvas, InputPosition)

				if
					Config.Window.CanDropdown
					and (Dropdown.Opened or menuCanvas.Visible)
					and not isClickOnDropdown
					and not isClickOnMenu
				then
					DropdownModule:Close()
				end
			end
		end)
	)

	table.insert(
		PersistentConnections,
		Creator.AddSignal(
			Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown:GetPropertyChangedSignal("AbsolutePosition")
				or Dropdown.DropdownFrame.UIElements.Main:GetPropertyChangedSignal("AbsolutePosition"),
			UpdatePosition
		)
	)

	if typeof(PopupParent) == "Instance" and PopupParent:IsA("GuiObject") then
		table.insert(
			PersistentConnections,
			Creator.AddSignal(PopupParent:GetPropertyChangedSignal("AbsoluteSize"), function()
				if Dropdown.UIElements.MenuCanvas.Visible then
					RecalculateListSize()
					UpdatePosition()
				end
			end)
		)
	end

	function DropdownModule:Destroy()
		MenuMotionToken += 1
		Dropdown.Opened = false

		for _, Connection in PersistentConnections do
			Connection:Disconnect()
		end
		table.clear(PersistentConnections)

		if Dropdown.UIElements.Backdrop then
			Dropdown.UIElements.Backdrop:Destroy()
			Dropdown.UIElements.Backdrop = nil
		end
		if Dropdown.UIElements.MenuCanvas then
			Dropdown.UIElements.MenuCanvas:Destroy()
		end
	end

	return DropdownModule
end

return DropdownMenu
