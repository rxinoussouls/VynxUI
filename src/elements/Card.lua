local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function GetText(Value, Fallback)
	if Value == nil then
		return Fallback
	end
	return tostring(Value)
end

local function GetCardColor(Value, Fallback)
	return Utils.GetColor(Value, Fallback)
end

function Element:New(Config)
	local Card = {
		__type = "Card",
		Title = GetText(Config.Title, "Card"),
		Desc = Config.Desc or Config.Content,
		Icon = Config.Icon,
		Image = Config.Image or Config.Background or Config.BackgroundImage,
		Callback = Config.Callback,
		OpenTab = Config.OpenTab == true or Config.CardTab == true or typeof(Config.Build) == "function",
		Elements = {},
		UIElements = {},
		ElementFrame = nil,
		LinkCorners = Config.LinkCorners,
		CornerGroup = Config.CornerGroup or Config.LinkCornerGroup,
		CornerBreak = Config.CornerBreak,
		CornerBreakBefore = Config.CornerBreakBefore,
		CornerBreakAfter = Config.CornerBreakAfter,
	}

	local Radius = Config.Radius or Config.Window.ElementConfig.UICorner
	local Accent = GetCardColor(Config.Color or Config.Accent, nil)
	local Height = tonumber(Config.Height) or 0
	local IsInteractive = typeof(Card.Callback) == "function" or Card.OpenTab
	local MainFrameWrapper
	local NativeCorner
	local ImageCorner

	Card.UIElements.Main, MainFrameWrapper = Creator.NewRoundFrame(Radius, "Squircle", {
		Name = "Card",
		Size = UDim2.new(1, 0, 0, Height),
		AutomaticSize = "Y",
		ImageTransparency = 1,
		Parent = Config.Parent,
		ClipsDescendants = true,
	}, {}, IsInteractive)
	Card.ElementFrame = Card.UIElements.Main

	Card.UIElements.Background = New("Frame", {
		Name = "Background",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = Creator.ClampTransparency(
			Config.Transparency,
			Config.Window.LiquidGlass and 0.84 or 0.9
		),
		BackgroundColor3 = Accent or nil,
		ZIndex = 0,
		Parent = Card.UIElements.Main,
		ThemeTag = Accent and nil or {
			BackgroundColor3 = "ElementBackground",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, Radius),
		}),
	})
	NativeCorner = Card.UIElements.Background.UICorner

	Card.UIElements.Content = New("Frame", {
		Name = "Content",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		ZIndex = 2,
		Parent = Card.UIElements.Main,
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, Config.Padding or 14),
			PaddingLeft = UDim.new(0, Config.Padding or 14),
			PaddingRight = UDim.new(0, Config.Padding or 14),
			PaddingBottom = UDim.new(0, Config.Padding or 14),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, Config.Gap or 12),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	if Card.Image then
		Card.UIElements.Image =
			Creator.Image(Card.Image, Card.Title .. "-card-image", 0, Config.Window.Folder, "Card", false, false)
		Card.UIElements.Image.Size = UDim2.new(1, 0, 1, 0)
		Card.UIElements.Image.Position = UDim2.new(0.5, 0, 0.5, 0)
		Card.UIElements.Image.AnchorPoint = Vector2.new(0.5, 0.5)
		Card.UIElements.Image.Parent = Card.UIElements.Main
		Card.UIElements.Image.ZIndex = 0

		local Target = Utils.GetImageTarget(Card.UIElements.Image)
		if Target then
			Target.ZIndex = 0
			Target.ImageTransparency = Config.ImageTransparency or 0.32
			Target.ScaleType = Config.ScaleType or Enum.ScaleType.Crop
			ImageCorner = New("UICorner", {
				CornerRadius = UDim.new(0, Radius),
				Parent = Target,
			})
		end
	end

	local Header = New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = Card.UIElements.Content,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Horizontal",
			VerticalAlignment = "Top",
			HorizontalAlignment = "Left",
		}),
	})

	if Card.Icon then
		local Icon = Utils.CreateIcon(Creator, Card.Icon, Config.Window.Folder, "Card", true, "CardIcon")
		if Icon then
			Icon.Size = UDim2.new(0, 22, 0, 22)
			Icon.Parent = Header
			local IconTarget = Utils.GetImageTarget(Icon)
			if IconTarget and Accent then
				IconTarget.ImageColor3 = Accent
				IconTarget.ImageTransparency = 0
			end
		end
	end

	local Texts = New("Frame", {
		Name = "Texts",
		Size = UDim2.new(1, Card.Icon and -32 or 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Header,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 3),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
		}),
	})

	Card.UIElements.Title = New("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = Card.Title,
		TextSize = Config.TitleSize or 17,
		TextTransparency = 0.02,
		TextXAlignment = "Left",
		TextWrapped = true,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		Parent = Texts,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Card.UIElements.Desc = New("TextLabel", {
		Name = "Desc",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = Card.Desc or "",
		TextSize = Config.DescSize or 13,
		TextTransparency = 0.34,
		TextXAlignment = "Left",
		TextWrapped = true,
		Visible = Card.Desc ~= nil,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = Texts,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Card.UIElements.Body = New("Frame", {
		Name = "Body",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Parent = Card.UIElements.Content,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Config.BodyGap or (Config.Window.NewElements and 6 or 8)),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	local function EnsureActions()
		if Card.UIElements.Actions then
			return Card.UIElements.Actions
		end

		Card.UIElements.Actions = New("Frame", {
			Name = "Actions",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Parent = Card.UIElements.Content,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
				SortOrder = "LayoutOrder",
			}),
		})

		return Card.UIElements.Actions
	end

	local function CreateActionButton(ButtonConfig, SelectCallback)
		ButtonConfig = ButtonConfig or {}
		local ButtonAccent = GetCardColor(ButtonConfig.Color, Accent)
		local Button = Creator.NewRoundFrame(ButtonConfig.Radius or 14, "Squircle", {
			Name = ButtonConfig.Name or "CardButton",
			Size = UDim2.new(1, 0, 0, ButtonConfig.Height or 44),
			ImageColor3 = ButtonAccent or nil,
			ImageTransparency = ButtonConfig.Transparency or (ButtonAccent and 0.18 or 0.9),
			Parent = EnsureActions(),
			ThemeTag = ButtonAccent and nil or {
				ImageColor3 = "ElementBackground",
			},
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Left",
			}),
			Utils.CreateIcon(
				Creator,
				ButtonConfig.Icon or "arrow-right",
				Config.Window.Folder,
				"Card",
				not ButtonAccent,
				"CardButtonIcon"
			),
			New("TextLabel", {
				Name = "Title",
				Size = UDim2.new(1, -34, 1, 0),
				BackgroundTransparency = 1,
				Text = GetText(ButtonConfig.Title or ButtonConfig.Name, "Open"),
				TextSize = ButtonConfig.TextSize or 14,
				TextTransparency = 0.04,
				TextXAlignment = "Left",
				TextTruncate = "AtEnd",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
		}, true)

		local ButtonIcon = Button:FindFirstChildWhichIsA("Frame") or Button:FindFirstChildWhichIsA("ImageLabel")
		local IconTarget = Utils.GetImageTarget(ButtonIcon)
		if IconTarget and ButtonAccent then
			IconTarget.ImageColor3 = ButtonAccent
			IconTarget.ImageTransparency = 0
		end

		Motion.AttachPress(Button, Creator, {
			Amount = 0.975,
		})
		Creator.AddSignal(Button.MouseButton1Click, function()
			if SelectCallback then
				SelectCallback()
			end
			if typeof(ButtonConfig.Callback) == "function" then
				Creator.SafeCallback(ButtonConfig.Callback, Card)
			end
		end)

		return Button
	end

	local CardTabController
	local function CreateCardTab(TabConfig)
		TabConfig = TabConfig or {}
		local TargetTab = TabConfig.Tab

		if typeof(TargetTab) ~= "table" and TabConfig.CreateTab ~= false and Config.Window and Config.Window.Tab then
			TargetTab = Config.Window:Tab({
				Title = TabConfig.TabTitle or TabConfig.Title or Card.Title,
				Desc = TabConfig.TabDesc or TabConfig.Desc,
				Icon = TabConfig.TabIcon or TabConfig.Icon or Card.Icon or "panels-top-left",
				ShowTabTitle = TabConfig.ShowTabTitle,
				Golden = TabConfig.Golden,
				Premium = TabConfig.Premium,
				LinkCorners = TabConfig.LinkCorners,
				Gap = TabConfig.Gap,
			})

			if typeof(TabConfig.Build) == "function" then
				Creator.SafeCallback(TabConfig.Build, TargetTab, Card)
			end
		end

		return {
			Tab = TargetTab,
			Select = function()
				if TargetTab and TargetTab.Select then
					return TargetTab:Select()
				end
			end,
		}
	end

	function Card:CardButton(ButtonConfig)
		return CreateActionButton(ButtonConfig)
	end

	function Card:CardTab(TabConfig)
		TabConfig = TabConfig or {}
		local Controller = CreateCardTab(TabConfig)

		local Button = CreateActionButton({
			Title = TabConfig.Title or "Open Card Tab",
			Icon = TabConfig.Icon or "panels-top-left",
			Color = TabConfig.Color,
			Callback = TabConfig.Callback,
		}, function()
			Controller.Select()
		end)

		Controller.Button = Button
		return Controller
	end

	if Card.OpenTab then
		local PageConfig = typeof(Config.CardTab) == "table" and Config.CardTab or {}
		CardTabController = CreateCardTab({
			Tab = Config.TabTarget or Config.Page or PageConfig.Tab,
			CreateTab = Config.CreateTab ~= false and PageConfig.CreateTab ~= false,
			Title = Config.TabTitle or Config.PageTitle or PageConfig.Title or Card.Title,
			TabTitle = Config.TabTitle or Config.PageTitle or PageConfig.TabTitle or Card.Title,
			TabDesc = Config.TabDesc or Config.PageDesc or PageConfig.TabDesc or Card.Desc,
			Icon = Config.TabIcon or Config.PageIcon or PageConfig.Icon or Card.Icon,
			TabIcon = Config.TabIcon or Config.PageIcon or PageConfig.TabIcon or Card.Icon,
			ShowTabTitle = Config.ShowTabTitle or PageConfig.ShowTabTitle,
			Golden = Config.Golden or PageConfig.Golden,
			Premium = Config.Premium or PageConfig.Premium,
			LinkCorners = Config.PageLinkCorners or PageConfig.LinkCorners,
			Gap = Config.PageGap or PageConfig.Gap,
			Build = Config.Build or PageConfig.Build,
		})

		Card.Page = CardTabController.Tab
		Card.PageController = CardTabController
	end

	function Card:Open()
		if CardTabController then
			return CardTabController.Select()
		end
		if typeof(Card.Callback) == "function" then
			return Creator.SafeCallback(Card.Callback, Card)
		end
	end

	function Card:GetPage()
		return CardTabController and CardTabController.Tab
	end

	function Card:SetPage(Tab)
		CardTabController = {
			Tab = Tab,
			Select = function()
				if Tab and Tab.Select then
					return Tab:Select()
				end
			end,
		}
		Card.Page = Tab
		Card.PageController = CardTabController
		return {
			Tab = Tab,
			Select = CardTabController.Select,
		}
	end

	if IsInteractive then
		Motion.AttachPress(Card.UIElements.Main, Creator, {
			Amount = 0.985,
		})
		Creator.AddSignal(Card.UIElements.Main.MouseButton1Click, function()
			if CardTabController then
				CardTabController.Select()
			end
			if typeof(Card.Callback) == "function" then
				Creator.SafeCallback(Card.Callback, Card)
			end
		end)
	end

	local ElementsModule = Config.ElementsModule
	ElementsModule.Load(
		Card,
		Card.UIElements.Body,
		ElementsModule.Elements,
		Config.Window,
		Config.WindUI,
		nil,
		ElementsModule,
		Config.UIScale,
		Config.Tab
	)

	function Card:SetTitle(Title)
		Card.Title = tostring(Title or "")
		Card.UIElements.Title.Text = Card.Title
	end

	function Card:SetDesc(Desc)
		Card.Desc = Desc
		Card.UIElements.Desc.Text = tostring(Desc or "")
		Card.UIElements.Desc.Visible = Desc ~= nil
	end

	function Card:Highlight()
		Motion.Play(
			Card.UIElements.Background,
			"Highlight",
			{ BackgroundTransparency = 0.78 },
			nil,
			nil,
			"CardHighlight"
		)
		task.delay(Motion.GetDuration("Highlight"), function()
			if Card.UIElements.Main.Parent then
				Motion.Play(Card.UIElements.Background, "Highlight", {
					BackgroundTransparency = Creator.ClampTransparency(
						Config.Transparency,
						Config.Window.LiquidGlass and 0.84 or 0.9
					),
				}, nil, nil, "CardHighlight")
			end
		end)
	end

	function Card.UpdateShape(Container)
		local ShouldLinkCorners = Card.LinkCorners ~= false
			and (
				Card.LinkCorners == true
				or Config.Window.ElementConfig.LinkCorners
				or (Config.ParentTable and Config.ParentTable.LinkCorners == true)
			)

		local corners = {
			TopLeft = true,
			TopRight = true,
			BottomLeft = true,
			BottomRight = true,
		}
		local newShape = "Squircle"
		local Metadata = { Position = "Single", Count = 1 }

		if ShouldLinkCorners and Container and Container.Elements then
			local ParentType = Config.ParentConfig
					and Config.ParentConfig.ParentTable
					and Config.ParentConfig.ParentTable.__type
				or Config.ParentType
				or (Config.ParentTable and Config.ParentTable.__type)
			newShape, corners, Metadata = Creator.GetLinkedCornerShape(
				Container.Elements,
				Card.Index,
				Container,
				ParentType,
				Config.CornerLink
					or (Config.ParentConfig and Config.ParentConfig.CornerLink)
					or Config.Window.ElementConfig.CornerLink
			)
		end

		if newShape and MainFrameWrapper then
			local DynamicShape = if Metadata.Count > 1
				then "Square"
				else (newShape == "Squircle-TL-BL" or newShape == "Squircle-TR-BR") and "Squircle" or newShape
			MainFrameWrapper:SetType(DynamicShape)
		end

		Creator.ApplyCornerRadii(NativeCorner, UDim.new(0, Radius), corners)
		Creator.ApplyCornerRadii(ImageCorner, UDim.new(0, Radius), corners)
	end

	Card.UpdateShape(Config.Tab or Config.ParentTable)

	function Card:Destroy()
		Card.UIElements.Main:Destroy()
	end

	return Card.__type, Card
end

return Element
