local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Creator = require("../../modules/Creator")
local Motion = require("../../modules/Motion")
local New = Creator.New

local SettingsMenu = {}

local function GetImageTarget(Icon)
	if typeof(Icon) ~= "Instance" then
		return nil
	end

	if Icon:IsA("ImageLabel") or Icon:IsA("ImageButton") then
		return Icon
	end

	return Icon:FindFirstChildWhichIsA("ImageLabel") or Icon:FindFirstChildWhichIsA("ImageButton")
end

local function ContainsPoint(Object, Position)
	if typeof(Object) ~= "Instance" or not Object.Visible then
		return false
	end

	local AbsolutePosition = Object.AbsolutePosition
	local AbsoluteSize = Object.AbsoluteSize

	return Position.X >= AbsolutePosition.X
		and Position.X <= AbsolutePosition.X + AbsoluteSize.X
		and Position.Y >= AbsolutePosition.Y
		and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y
end

local function Trim(Text)
	Text = tostring(Text or "")
	Text = string.gsub(Text, "^%s+", "")
	Text = string.gsub(Text, "%s+$", "")
	return Text
end

local function GetThemeList(WindUI)
	local Themes = {}

	for Key, Theme in next, WindUI:GetThemes() or {} do
		table.insert(Themes, {
			Key = Key,
			Name = Theme.Name or Key,
		})
	end

	table.sort(Themes, function(A, B)
		return A.Name < B.Name
	end)

	return Themes
end

function SettingsMenu.New(Window, WindUI, Config)
	local SettingsConfig = typeof(Window.Settings) == "table" and Window.Settings or {}
	local DefaultConfigName = SettingsConfig.DefaultConfig or "default"
	local RootWidth = SettingsConfig.Width or 360
	local RootHeight = SettingsConfig.Height or 410
	local PageHeight = SettingsConfig.PageHeight or (RootHeight - 142)
	local Menu = {
		Open = false,
		Button = nil,
		Token = 0,
		SelectedTab = "config",
		UIElements = {},
		ThemeButtons = {},
		TabButtons = {},
		Pages = {},
	}

	local function GetViewportSize()
		local Camera = Workspace.CurrentCamera
		return Camera and Camera.ViewportSize or Vector2.new(1280, 720)
	end

	local function Notify(Title, Content, Icon, Style)
		if WindUI.Notify then
			WindUI:Notify({
				Title = Title,
				Content = Content,
				Icon = Icon,
				Style = Style,
			})
		end
	end

	local function CreateIcon(IconName, Parent, Size)
		local Icon = Creator.Image(IconName, IconName, 0, Window.Folder, "SettingsMenu", true, true, "Icon")
		Icon.Size = UDim2.new(0, Size or 16, 0, Size or 16)
		Icon.Parent = Parent
		return Icon
	end

	local function CreateText(Parent, Text, Size, Weight, Transparency)
		return New("TextLabel", {
			BackgroundTransparency = 1,
			Text = Text or "",
			TextSize = Size or 14,
			TextTransparency = Transparency or 0,
			TextWrapped = true,
			TextXAlignment = "Left",
			AutomaticSize = "Y",
			Size = UDim2.new(1, 0, 0, 0),
			Parent = Parent,
			FontFace = Font.new(Creator.Font, Weight or Enum.FontWeight.Medium),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})
	end

	local function CreatePanel(Parent)
		return Creator.NewRoundFrame(Window.ElementConfig.UICorner, "Squircle", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			ImageTransparency = 0.9,
			Parent = Parent,
			ThemeTag = {
				ImageColor3 = "ElementBackground",
			},
		}, {
			New("UIGradient", {
				Rotation = 35,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.05),
					NumberSequenceKeypoint.new(1, 0.2),
				}),
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
			}),
		})
	end

	local function CreateActionButton(Parent, Title, IconName, Variant, Callback)
		local Button = Creator.NewRoundFrame(14, "Squircle", {
			Size = UDim2.new(1, 0, 0, 34),
			ImageTransparency = Variant == "Primary" and 0 or 0.9,
			ThemeTag = {
				ImageColor3 = Variant == "Primary" and "Primary" or "ElementBackground",
			},
			Parent = Parent,
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 7),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
			}),
			IconName and CreateIcon(IconName, nil, 15) or nil,
			New("TextLabel", {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = "X",
				BackgroundTransparency = 1,
				Text = Title,
				TextSize = 13,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				TextColor3 = Variant == "Primary" and Color3.new(1, 1, 1) or nil,
				ThemeTag = {
					TextColor3 = Variant ~= "Primary" and "Text" or nil,
				},
			}),
		}, true)

		Motion.AttachPress(Button, Creator, {
			Amount = 0.97,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			Creator.SafeCallback(Callback)
		end)

		return Button
	end

	local Root = Creator.NewRoundFrame(Window.ElementConfig.UICorner, "Squircle", {
		Name = "SettingsDropdown",
		Size = UDim2.new(0, RootWidth, 0, RootHeight),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromOffset(0, 0),
		ImageTransparency = 1,
		Visible = false,
		Active = false,
		ZIndex = 10000,
		Parent = WindUI.ScreenGui,
		ThemeTag = {
			ImageColor3 = "Background",
		},
	}, {
		New("UIScale", {
			Name = "Scale",
			Scale = 0.98,
		}),
		Creator.NewRoundFrame(Window.ElementConfig.UICorner, "SquircleGlass", {
			Name = "GlassLayer",
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.72,
			ZIndex = 10000,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}),
		Creator.NewRoundFrame(Window.ElementConfig.UICorner, "SquircleOutline", {
			Name = "Outline",
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.72,
			ZIndex = 10001,
			ThemeTag = {
				ImageColor3 = "Outline",
			},
		}),
	})

	local Scrim = New("Frame", {
		Name = "SettingsScrim",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Active = false,
		ZIndex = 9998,
		Parent = WindUI.ScreenGui,
	})

	local Content = New("CanvasGroup", {
		Name = "Content",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		ZIndex = 10002,
		Parent = Root,
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	Menu.UIElements.Root = Root
	Menu.UIElements.Scale = Root.Scale
	Menu.UIElements.Scrim = Scrim
	Menu.UIElements.Content = Content
	Menu.UIElements.GlassLayer = Root.GlassLayer
	Menu.UIElements.Outline = Root.Outline

	local Pages
	local ThemeList

	local function UpdateRootPosition()
		local Viewport = GetViewportSize()
		local Margin = 12
		local CurrentRootWidth = math.floor(math.min(RootWidth, math.max(280, Viewport.X - (Margin * 2))))
		local CurrentRootHeight = math.floor(math.min(RootHeight, math.max(300, Viewport.Y - (Margin * 2))))
		local Anchor = Vector2.new(1, 0)
		local X = Viewport.X - Margin
		local Y = Margin + Window.Topbar.Height

		Root.Size = UDim2.fromOffset(CurrentRootWidth, CurrentRootHeight)
		if Pages then
			Pages.Size = UDim2.new(1, 0, 0, math.max(154, CurrentRootHeight - 142))
		end
		if ThemeList then
			ThemeList.Size = UDim2.new(1, 0, 0, math.max(116, CurrentRootHeight - 238))
		end

		if Menu.Button and Menu.Button.AbsoluteSize.X > 0 then
			local ButtonPosition = Menu.Button.AbsolutePosition
			local ButtonSize = Menu.Button.AbsoluteSize
			X = ButtonPosition.X + ButtonSize.X
			Y = ButtonPosition.Y + ButtonSize.Y + 10
		end

		if X - CurrentRootWidth < Margin then
			X = math.min(Viewport.X - Margin, Margin + CurrentRootWidth)
		end
		if Y + CurrentRootHeight > Viewport.Y - Margin then
			Y = math.max(Margin, Viewport.Y - CurrentRootHeight - Margin)
		end

		Root.AnchorPoint = Anchor
		Root.Position = UDim2.fromOffset(X, Y)
		Scrim.Size = UDim2.fromOffset(Viewport.X, Viewport.Y)
	end

	local Header = New("Frame", {
		Name = "Header",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		Parent = Content,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
	})

	local HeaderGlyph = CreateIcon("settings", nil, 17)
	local HeaderIcon = Creator.NewRoundFrame(999, "Squircle", {
		Size = UDim2.new(0, 36, 0, 36),
		ImageTransparency = 0.86,
		ThemeTag = {
			ImageColor3 = "Primary",
		},
		Parent = Header,
	}, {
		HeaderGlyph,
		Creator.NewRoundFrame(999, "SquircleGlass", {
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.8,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}),
	})
	HeaderGlyph.Position = UDim2.new(0.5, 0, 0.5, 0)
	HeaderGlyph.AnchorPoint = Vector2.new(0.5, 0.5)
	HeaderGlyph.ZIndex = 10002

	local HeaderTexts = New("Frame", {
		Size = UDim2.new(1, -46, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Header,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 2),
			FillDirection = "Vertical",
		}),
	})
	CreateText(HeaderTexts, "Settings", 16, Enum.FontWeight.Bold, 0)
	CreateText(HeaderTexts, "Config, theme and runtime controls", 12, Enum.FontWeight.Medium, 0.42)

	local TabStrip = Creator.NewRoundFrame(16, "Squircle", {
		Name = "SettingsTabs",
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 38),
		ImageTransparency = 0.9,
		Parent = Content,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 4),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			SortOrder = "LayoutOrder",
		}),
	})

	Pages = New("Frame", {
		Name = "Pages",
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, PageHeight),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = Content,
	})

	local function CreateTabButton(Key, Title, IconName, LayoutOrder)
		local Icon = CreateIcon(IconName, nil, 14)
		local Label = New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = "X",
			BackgroundTransparency = 1,
			Text = Title,
			TextSize = 12,
			TextTruncate = "AtEnd",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local Button = Creator.NewRoundFrame(12, "Squircle", {
			Name = Key,
			LayoutOrder = LayoutOrder,
			Size = UDim2.new(1 / 3, -3, 1, 0),
			ImageTransparency = 1,
			Parent = TabStrip,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 5),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
			}),
			Icon,
			Label,
		}, true)

		local IconTarget = GetImageTarget(Icon)
		Menu.TabButtons[Key] = {
			Button = Button,
			Label = Label,
			Icon = IconTarget,
		}

		Motion.AttachPress(Button, Creator, {
			Amount = 0.98,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			Menu:SelectTab(Key)
		end)

		return Button
	end

	local function CreatePage(Key)
		local Page = New("CanvasGroup", {
			Name = Key,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			GroupTransparency = 1,
			Visible = false,
			Active = false,
			Parent = Pages,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
				SortOrder = "LayoutOrder",
			}),
		})

		Menu.Pages[Key] = Page
		return Page
	end

	local ConfigPage = CreatePage("config")
	local ThemePage = CreatePage("theme")
	local AboutPage = CreatePage("about")

	CreateTabButton("config", "Config", "save", 1)
	CreateTabButton("theme", "Theme", "palette", 2)
	CreateTabButton("about", "Info", "badge-info", 3)

	local ConfigCard = CreatePanel(ConfigPage)
	CreateText(ConfigCard, "Config Profile", 13, Enum.FontWeight.Bold, 0.05)

	local NameBoxContainer = Creator.NewRoundFrame(12, "Squircle", {
		Size = UDim2.new(1, 0, 0, 36),
		ImageTransparency = 0.9,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
		Parent = ConfigCard,
	}, {
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
	})

	local ConfigNameBox = New("TextBox", {
		Name = "ConfigName",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Text = DefaultConfigName,
		PlaceholderText = "default",
		TextSize = 13,
		TextXAlignment = "Left",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = NameBoxContainer,
		ThemeTag = {
			TextColor3 = "Text",
			PlaceholderColor3 = "Placeholder",
		},
	})

	local ConfigMeta = CreateText(ConfigCard, "No saved configs", 12, Enum.FontWeight.Medium, 0.45)

	local ConfigActions = New("Frame", {
		Name = "HStack",
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		Parent = ConfigCard,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
			VerticalAlignment = "Center",
		}),
	})

	local RuntimeCard = CreatePanel(ConfigPage)
	CreateText(RuntimeCard, "Runtime", 13, Enum.FontWeight.Bold, 0.05)
	local ThemeMeta = CreateText(RuntimeCard, "Theme: " .. tostring(WindUI:GetCurrentTheme()), 12, Enum.FontWeight.Medium, 0.28)
	CreateText(RuntimeCard, "Settings use glass morph layers and tabbed pages.", 12, Enum.FontWeight.Medium, 0.45)

	local function GetConfigName()
		local Name = Trim(ConfigNameBox.Text)
		return Name ~= "" and Name or DefaultConfigName
	end

	local function RefreshConfigMeta()
		local Manager = Window.ConfigManager
		if not Manager or typeof(Manager) ~= "table" then
			ConfigMeta.Text = "Config is unavailable in this environment"
			return
		end

		local Success, Configs = pcall(function()
			return Manager:AllConfigs()
		end)
		local Count = Success and #Configs or 0
		ConfigMeta.Text = Count == 1 and "1 saved config" or tostring(Count) .. " saved configs"
	end

	local SaveButton = CreateActionButton(ConfigActions, "Save", "save", "Primary", function()
		local Manager = Window.ConfigManager
		if not Manager or typeof(Manager) ~= "table" then
			Notify("Config unavailable", "Config save needs file access.", "triangle-alert", "Warning")
			return
		end

		local Name = GetConfigName()
		local Success, Result, Message = pcall(function()
			local ConfigModule = Manager:Config(Name)
			ConfigModule:Set("theme", WindUI:GetCurrentTheme())
			return ConfigModule:Save()
		end)

		if Success and Result then
			RefreshConfigMeta()
			Notify("Config saved", "Saved '" .. Name .. "'.", "check", "Success")
		else
			Notify("Config save failed", tostring(Message or Result), "triangle-alert", "Error")
		end
	end)
	SaveButton.Size = UDim2.new(0.5, -4, 1, 0)

	local LoadButton = CreateActionButton(ConfigActions, "Load", "download", "Secondary", function()
		local Manager = Window.ConfigManager
		if not Manager or typeof(Manager) ~= "table" then
			Notify("Config unavailable", "Config load needs file access.", "triangle-alert", "Warning")
			return
		end

		local Name = GetConfigName()
		local Success, Result, Message = pcall(function()
			local ConfigModule = Manager:Config(Name)
			local Data = ConfigModule:Load()
			if Data and Data.theme then
				WindUI:SetTheme(Data.theme)
			end
			return Data
		end)

		if Success and Result then
			ThemeMeta.Text = "Theme: " .. tostring(WindUI:GetCurrentTheme())
			Notify("Config loaded", "Loaded '" .. Name .. "'.", "refresh-cw", "Success")
		else
			Notify("Config load failed", tostring(Message or Result), "triangle-alert", "Error")
		end
	end)
	LoadButton.Size = UDim2.new(0.5, -4, 1, 0)

	local ThemeCard = CreatePanel(ThemePage)
	CreateText(ThemeCard, "Theme Picker", 13, Enum.FontWeight.Bold, 0.05)
	CreateText(ThemeCard, "Tap a theme to apply it instantly.", 12, Enum.FontWeight.Medium, 0.45)

	ThemeList = New("ScrollingFrame", {
		Name = "ThemeList",
		Size = UDim2.new(1, 0, 0, SettingsConfig.ThemeListHeight or 214),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		AutomaticCanvasSize = "Y",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = ThemeCard,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
		}),
	})

	local function UpdateThemeButtons()
		local CurrentTheme = WindUI:GetCurrentTheme()
		ThemeMeta.Text = "Theme: " .. tostring(CurrentTheme)
		for Key, Data in next, Menu.ThemeButtons do
			local Selected = Key == CurrentTheme
			Motion.Play(Data.Button, "Switch", { ImageTransparency = Selected and 0.82 or 0.94 }, nil, nil, "Theme")
			Motion.Play(Data.Label, "Switch", { TextTransparency = Selected and 0 or 0.24 }, nil, nil, "Theme")
			if Data.Check then
				Motion.Play(Data.Check, "Switch", { ImageTransparency = Selected and 0 or 1 }, nil, nil, "Theme")
			end
		end
	end

	for _, Theme in next, GetThemeList(WindUI) do
		local CheckIcon = CreateIcon("check", nil, 14)
		local ThemeButton = Creator.NewRoundFrame(12, "Squircle", {
			Size = UDim2.new(1, 0, 0, 32),
			ImageTransparency = 0.94,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
			Parent = ThemeList,
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				FillDirection = "Horizontal",
				Padding = UDim.new(0, 8),
				VerticalAlignment = "Center",
			}),
			New("TextLabel", {
				Name = "Title",
				Size = UDim2.new(1, -22, 1, 0),
				BackgroundTransparency = 1,
				Text = Theme.Name,
				TextSize = 13,
				TextXAlignment = "Left",
				TextTruncate = "AtEnd",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
			CheckIcon,
		}, true)

		local CheckTarget = GetImageTarget(CheckIcon)
		if CheckTarget then
			CheckTarget.ImageTransparency = 1
		end

		Menu.ThemeButtons[Theme.Key] = {
			Button = ThemeButton,
			Label = ThemeButton.Title,
			Check = CheckTarget,
		}

		Motion.AttachPress(ThemeButton, Creator, {
			Amount = 0.985,
		})

		Creator.AddSignal(ThemeButton.MouseButton1Click, function()
			WindUI:SetTheme(Theme.Key)
			UpdateThemeButtons()
		end)
	end

	local AboutCard = CreatePanel(AboutPage)
	CreateText(AboutCard, "WindUI Settings", 13, Enum.FontWeight.Bold, 0.05)
	CreateText(AboutCard, "Use Config for save/load and Theme for quick visual switching.", 12, Enum.FontWeight.Medium, 0.36)

	local AboutStack = New("Frame", {
		Name = "VStack",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = AboutCard,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
		}),
	})

	local function CreateInfoRow(Title, Value)
		return Creator.NewRoundFrame(12, "Squircle", {
			Size = UDim2.new(1, 0, 0, 34),
			ImageTransparency = 0.94,
			ThemeTag = {
				ImageColor3 = "ElementBackground",
			},
			Parent = AboutStack,
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			New("TextLabel", {
				Size = UDim2.new(0.44, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = Title,
				TextSize = 12,
				TextXAlignment = "Left",
				TextTransparency = 0.38,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
			New("TextLabel", {
				Size = UDim2.new(0.56, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = Value,
				TextSize = 12,
				TextXAlignment = "Right",
				TextTruncate = "AtEnd",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
		})
	end

	CreateInfoRow("Folder", tostring(Window.Folder or "WindUI"))
	CreateInfoRow("Topbar", tostring(Window.Topbar.ButtonsType or "Default"))
	CreateInfoRow("Motion", tostring(Motion:GetConfig().Preset))

	function Menu:SetButton(Button)
		Menu.Button = Button
	end

	function Menu:SelectTab(Key)
		if not Menu.Pages[Key] then
			return
		end

		Menu.SelectedTab = Key
		for TabKey, Data in next, Menu.TabButtons do
			local Selected = TabKey == Key
			Motion.Play(Data.Button, "Switch", { ImageTransparency = Selected and 0.82 or 1 }, nil, nil, "SettingsTab")
			Motion.Play(Data.Label, "Switch", { TextTransparency = Selected and 0 or 0.3 }, nil, nil, "SettingsTab")
			if Data.Icon then
				Motion.Play(Data.Icon, "Switch", { ImageTransparency = Selected and 0 or 0.35 }, nil, nil, "SettingsTab")
			end
		end

		for PageKey, Page in next, Menu.Pages do
			local Selected = PageKey == Key
			Page.Active = Selected
			if Selected then
				Page.Visible = true
				Page.GroupTransparency = 1
				Motion.Play(Page, "Reveal", { GroupTransparency = 0 }, nil, nil, "SettingsPage")
			else
				Page.Visible = false
				Page.GroupTransparency = 1
			end
		end
	end

	function Menu:OpenMenu()
		if Menu.Open then
			return
		end

		Menu.Open = true
		Menu.Token = Menu.Token + 1
		RefreshConfigMeta()
		UpdateThemeButtons()
		Menu:SelectTab(Menu.SelectedTab)
		UpdateRootPosition()
		Root.Visible = true
		Root.Active = true
		Menu.UIElements.Scrim.Visible = true
		Root.ImageTransparency = 1
		Menu.UIElements.Scrim.BackgroundTransparency = 1
		Menu.UIElements.Content.GroupTransparency = 1
		Menu.UIElements.GlassLayer.ImageTransparency = 1
		Menu.UIElements.Outline.ImageTransparency = 1
		Menu.UIElements.Scale.Scale = 0.98
		Motion.Play(Root, "DropdownOpen", { ImageTransparency = 0.18 }, nil, nil, "Settings")
		Motion.Play(Menu.UIElements.Scrim, "DropdownOpen", { BackgroundTransparency = SettingsConfig.ScrimTransparency or 0.72 }, nil, nil, "SettingsScrim")
		Motion.Play(Menu.UIElements.Content, "DropdownOpen", { GroupTransparency = 0 }, nil, nil, "SettingsContent")
		Motion.Play(Menu.UIElements.GlassLayer, "DropdownOpen", { ImageTransparency = 0.78 }, nil, nil, "SettingsGlass")
		Motion.Play(Menu.UIElements.Outline, "DropdownOpen", { ImageTransparency = 0.72 }, nil, nil, "SettingsOutline")
		Motion.Play(Menu.UIElements.Scale, "DropdownOpen", { Scale = 1 }, nil, nil, "SettingsScale")
	end

	function Menu:CloseMenu()
		if not Menu.Open then
			return
		end

		Menu.Open = false
		Menu.Token = Menu.Token + 1
		local Token = Menu.Token
		Root.Active = false
		Motion.Play(Root, "DropdownClose", { ImageTransparency = 1 }, nil, nil, "Settings")
		Motion.Play(Menu.UIElements.Scrim, "DropdownClose", { BackgroundTransparency = 1 }, nil, nil, "SettingsScrim")
		Motion.Play(Menu.UIElements.Content, "DropdownClose", { GroupTransparency = 1 }, nil, nil, "SettingsContent")
		Motion.Play(Menu.UIElements.GlassLayer, "DropdownClose", { ImageTransparency = 1 }, nil, nil, "SettingsGlass")
		Motion.Play(Menu.UIElements.Outline, "DropdownClose", { ImageTransparency = 1 }, nil, nil, "SettingsOutline")
		Motion.Play(Menu.UIElements.Scale, "DropdownClose", { Scale = 0.98 }, nil, nil, "SettingsScale")
		task.delay(Motion.GetDuration("DropdownClose"), function()
			if Token == Menu.Token then
				Root.Visible = false
				Menu.UIElements.Scrim.Visible = false
			end
		end)
	end

	function Menu:Toggle()
		if Menu.Open then
			Menu:CloseMenu()
		else
			Menu:OpenMenu()
		end
	end

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if not Menu.Open then
			return
		end
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if ContainsPoint(Root, Input.Position) or ContainsPoint(Menu.Button, Input.Position) then
			return
		end

		Menu:CloseMenu()
	end)

	RefreshConfigMeta()
	UpdateThemeButtons()
	Menu:SelectTab("config")

	return Menu
end

return SettingsMenu
