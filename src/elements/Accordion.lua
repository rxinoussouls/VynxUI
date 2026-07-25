local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local HEADER_HEIGHT = 34

function Element:New(Config)
	local Accordion = {
		__type = "Accordion",
		Title = Config.Title or "Accordion",
		Desc = Config.Desc,
		Items = Utils.NormalizeItems(Config.Items or Config.Sections or {}),
		OpenIndex = Utils.ToFiniteNumber(Config.OpenIndex or Config.DefaultOpen),
		Multiple = Config.Multiple == true,
		UIElements = {},
		Rows = {},
	}

	local OpenIndexes = {}
	if Accordion.OpenIndex then
		OpenIndexes[Accordion.OpenIndex] = true
	end

	Accordion.AccordionFrame = require("../components/window/Element")({
		Title = Accordion.Title,
		Desc = Accordion.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Accordion,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Accordion.UIElements.List = New("Frame", {
		Name = "AccordionList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Accordion.AccordionFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Vertical",
			VerticalAlignment = "Top",
			HorizontalAlignment = "Left",
		}),
	})

	local function GetOpenHeight(Row)
		return HEADER_HEIGHT + (Row.Content.AbsoluteSize.Y / Config.UIScale) + 10
	end

	local function SetRowOpen(Index, IsOpen, Instant)
		local Row = Accordion.Rows[Index]
		if not Row then
			return
		end

		OpenIndexes[Index] = IsOpen or nil
		Row.Open = IsOpen

		local TargetSize = UDim2.new(1, 0, 0, IsOpen and GetOpenHeight(Row) or HEADER_HEIGHT)
		if Instant then
			Row.Frame.Size = TargetSize
			Row.Chevron.Rotation = IsOpen and 180 or 0
		else
			Motion.Play(Row.Frame, "Expand", { Size = TargetSize }, nil, nil, "Expand")
			Motion.Play(Row.Chevron, "Expand", { Rotation = IsOpen and 180 or 0 }, nil, nil, "Chevron")
		end
	end

	local function Render()
		for _, Row in next, Accordion.Rows do
			Row.Frame:Destroy()
		end
		Accordion.Rows = {}

		for Index, Item in next, Accordion.Items do
			local Icon = Utils.CreateIcon(Creator, Item.Icon, Config.Window.Folder, "Accordion", true, "AccordionIcon")
			if Icon then
				Icon.Size = UDim2.new(0, 16, 0, 16)
			end

			local ChevronInfo = Creator.Icon("chevron-down")
			local Chevron = New("ImageLabel", {
				Name = "Chevron",
				Size = UDim2.new(0, 16, 0, 16),
				BackgroundTransparency = 1,
				Image = ChevronInfo[1],
				ImageRectOffset = ChevronInfo[2].ImageRectPosition,
				ImageRectSize = ChevronInfo[2].ImageRectSize,
				ImageTransparency = 0.4,
				ThemeTag = {
					ImageColor3 = "Icon",
				},
			})

			local Header = New("TextButton", {
				Name = "Header",
				Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
				BackgroundTransparency = 1,
				Text = "",
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = "Horizontal",
					VerticalAlignment = "Center",
					HorizontalAlignment = "Left",
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
				}),
				Icon,
				New("TextLabel", {
					Name = "Title",
					Size = UDim2.new(1, Icon and -48 or -24, 1, 0),
					BackgroundTransparency = 1,
					Text = Item.Title,
					TextSize = 14,
					TextTruncate = "AtEnd",
					TextXAlignment = "Left",
					FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
					ThemeTag = {
						TextColor3 = "Text",
					},
				}),
				Chevron,
			})

			local Content = New("Frame", {
				Name = "Content",
				Size = UDim2.new(1, -20, 0, 0),
				Position = UDim2.new(0, 10, 0, HEADER_HEIGHT),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
			}, {
				Utils.CreateText(New, Creator, Item.Desc or "", 13, Enum.FontWeight.Medium, 0.4),
			})

			local Frame = Creator.NewRoundFrame(12, "Squircle", {
				Name = "Item",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
				ClipsDescendants = true,
				ImageTransparency = 0.94,
				ThemeTag = {
					ImageColor3 = "AccordionBackground",
				},
				Parent = Accordion.UIElements.List,
			}, {
				Header,
				Content,
			})

			Accordion.Rows[Index] = {
				Frame = Frame,
				Header = Header,
				Content = Content,
				Chevron = Chevron,
				Open = false,
			}

			Motion.AttachPress(Header, Creator, {
				Amount = 0.985,
			})

			Creator.AddSignal(Header.MouseButton1Click, function()
				Accordion:Toggle(Index)
			end)

			Creator.AddSignal(Content:GetPropertyChangedSignal("AbsoluteSize"), function()
				if Accordion.Rows[Index] and Accordion.Rows[Index].Open then
					SetRowOpen(Index, true, true)
				end
			end)
		end

		for Index in next, OpenIndexes do
			SetRowOpen(Index, true, true)
		end
	end

	function Accordion:Open(Index)
		if not Accordion.Multiple then
			for RowIndex in next, OpenIndexes do
				if RowIndex ~= Index then
					SetRowOpen(RowIndex, false)
				end
			end
		end

		SetRowOpen(Index, true)
	end

	function Accordion:Close(Index)
		SetRowOpen(Index, false)
	end

	function Accordion:Toggle(Index)
		local Row = Accordion.Rows[Index]
		if not Row then
			return
		end
		if Row.Open then
			Accordion:Close(Index)
		else
			Accordion:Open(Index)
		end
	end

	function Accordion:SetItems(Items)
		Accordion.Items = Utils.NormalizeItems(Items or {})
		OpenIndexes = {}
		Render()
		return Accordion.Items
	end

	Render()

	return Accordion.__type, Accordion
end

return Element
