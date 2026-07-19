local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local KeyBindMenu = {}

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

local function NormalizeKey(Value)
	if typeof(Value) == "EnumItem" then
		return Value.Name, Value
	end
	if typeof(Value) == "string" and Enum.KeyCode[Value] then
		return Value, Enum.KeyCode[Value]
	end
	return "None", nil
end

function KeyBindMenu.New(Window, WindUI, Config)
	local MenuConfig = typeof(Window.KeyBindMenu) == "table" and Window.KeyBindMenu or {}
	local IsMobile = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) or Window.IsPC == false
	local Compact = MenuConfig.Compact == true or (MenuConfig.Compact ~= false and IsMobile)
	local RootWidth = MenuConfig.Width or (Compact and 330 or 326)
	local RootHeight = MenuConfig.Height or (Compact and 300 or 354)
	local ContentPadding = Compact and 10 or 14
	local ContentGap = Compact and 6 or 10
	local QuickKeys = MenuConfig.QuickKeys or { "RightShift", "F", "LeftControl" }
	local Menu = {
		Open = false,
		Button = nil,
		Token = 0,
		Capturing = false,
		UserMoved = false,
		StoredPosition = nil,
		TargetPosition = nil,
		UIElements = {},
	}

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

	local function GetViewportSize()
		local Camera = Workspace.CurrentCamera
		return Camera and Camera.ViewportSize or Vector2.new(1280, 720)
	end

	local function GetScrimTransparency()
		if MenuConfig.Scrim == false or MenuConfig.ShowScrim == false then
			return 1
		end
		if MenuConfig.ScrimTransparency ~= nil then
			return MenuConfig.ScrimTransparency
		end
		return Compact and 1 or 0.78
	end

	local function CreateIcon(IconName, Parent, Size)
		local Icon = Creator.Image(IconName, IconName, 0, Window.Folder, "KeyBindMenu", true, true, "Icon")
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
			TextXAlignment = "Left",
			TextWrapped = true,
			AutomaticSize = "Y",
			Size = UDim2.new(1, 0, 0, 0),
			Parent = Parent,
			FontFace = Font.new(Creator.Font, Weight or Enum.FontWeight.Medium),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})
	end

	local Root = Creator.NewRoundFrame(Window.ElementConfig.UICorner, "Squircle", {
		Name = "KeyBindMenu",
		Size = UDim2.new(0, RootWidth, 0, RootHeight),
		AnchorPoint = Compact and Vector2.new(0.5, 1) or Vector2.new(1, 0),
		Position = UDim2.fromOffset(0, 0),
		ImageTransparency = 1,
		Visible = false,
		Active = false,
		ClipsDescendants = true,
		ZIndex = 10020,
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
			ImageTransparency = 1,
			ZIndex = 10020,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}),
		Creator.NewRoundFrame(Window.ElementConfig.UICorner, "SquircleOutline", {
			Name = "Outline",
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 1,
			ZIndex = 10021,
			ThemeTag = {
				ImageColor3 = "Outline",
			},
		}),
	})

	local Scrim = New("Frame", {
		Name = "KeyBindScrim",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Active = false,
		ZIndex = 10018,
		Parent = WindUI.ScreenGui,
	})

	local Content = New("CanvasGroup", {
		Name = "Content",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		ZIndex = 10022,
		Parent = Root,
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, ContentPadding),
			PaddingLeft = UDim.new(0, ContentPadding),
			PaddingRight = UDim.new(0, ContentPadding),
			PaddingBottom = UDim.new(0, ContentPadding),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, ContentGap),
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

	local function IsImageBackground(Value)
		if typeof(Value) ~= "string" then
			return false
		end
		if string.sub(Value, 1, 1) == "#" then
			return false
		end
		if string.match(Value, "^video:") then
			return false
		end
		return Value ~= ""
	end

	local function GetBackgroundKind(Value)
		if Value == nil or Value == false then
			return nil, nil, {}
		end

		if typeof(Value) == "table" then
			local Kind = Value.Type or Value.Kind or Value.Mode
			if Value.Video or Kind == "Video" or Kind == "video" then
				return "Video", Value.Video or Value.Url or Value.URL or Value.Source or Value.Asset or Value.Path, Value
			end
			if Value.Image or Value.Url or Value.URL or Value.Asset or Value.Path or Kind == "Image" or Kind == "image" then
				return "Image", Value.Image or Value.Url or Value.URL or Value.Asset or Value.Path or Value.Source, Value
			end
			if Value.Gradient then
				return "Gradient", Value.Gradient, Value
			end
			if Kind == "Gradient" or Kind == "gradient" or Value.Rotation ~= nil or Value.Offset ~= nil then
				return "Gradient", Value, Value
			end
			if typeof(Value.Color) == "ColorSequence" or typeof(Value.Transparency) == "NumberSequence" then
				return "Gradient", Value, Value
			end
			return nil, nil, Value
		end

		if typeof(Value) == "string" then
			local Video = string.match(Value, "^video:(.+)")
			local CleanUrl = Value:match("^([^?#]+)") or Value
			if Video or string.match(CleanUrl:lower(), "%.webm$") then
				return "Video", Video or Value, {}
			end
			if IsImageBackground(Value) then
				return "Image", Value, {}
			end
		end

		return nil, nil, {}
	end

	local function FindWindowBackgroundVideo()
		local Main = Window.UIElements and Window.UIElements.Main
		local Background = Main and Main:FindFirstChild("Background")
		local Video = Background and Background:FindFirstChild("BackgroundVideo")
		if Video and Video:IsA("VideoFrame") then
			return Video.Video
		end
		return nil
	end

	local function ApplyGradientProperty(UIGradient, Key, Value)
		if Key == "Transparency" and typeof(Value) == "number" then
			return
		end
		pcall(function()
			UIGradient[Key] = Value
		end)
	end

	local function ApplyBackgroundMedia()
		if MenuConfig.UseWindowBackground == false then
			return
		end

		local MenuBackgroundKind, MenuBackgroundSource = GetBackgroundKind(MenuConfig.Background)
		local WindowBackgroundKind, WindowBackgroundSource = GetBackgroundKind(Window.Background)
		local Gradient = MenuConfig.BackgroundGradient
			or (MenuBackgroundKind == "Gradient" and MenuBackgroundSource)
			or Window.BackgroundGradient
			or (WindowBackgroundKind == "Gradient" and WindowBackgroundSource)
		local Image = MenuConfig.BackgroundImage
			or (MenuBackgroundKind == "Image" and MenuBackgroundSource)
			or (WindowBackgroundKind == "Image" and WindowBackgroundSource)
		local Video = (MenuBackgroundKind == "Video" and MenuBackgroundSource)
			or (WindowBackgroundKind == "Video" and (FindWindowBackgroundVideo() or WindowBackgroundSource))

		if Image then
			Menu.UIElements.BackgroundImage = New("ImageLabel", {
				Name = "BackgroundImage",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = tostring(Image),
				ImageTransparency = MenuConfig.BackgroundImageTransparency or Window.BackgroundImageTransparency or 0.46,
				ScaleType = MenuConfig.BackgroundScaleType or Window.BackgroundScaleType or "Crop",
				ZIndex = 10019,
				Parent = Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, Window.ElementConfig.UICorner),
				}),
			})
		end

		if Video then
			Menu.UIElements.BackgroundVideo = New("VideoFrame", {
				Name = "BackgroundVideo",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Video = tostring(Video),
				Looped = true,
				Volume = 0,
				ZIndex = 10019,
				Parent = Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, Window.ElementConfig.UICorner),
				}),
			})
			Menu.UIElements.BackgroundVideo:Play()
		end

		if Gradient then
			local UIGradient = New("UIGradient")
			for Key, Value in next, Gradient do
				ApplyGradientProperty(UIGradient, Key, Value)
			end

			Menu.UIElements.BackgroundGradient = Creator.NewRoundFrame(Window.ElementConfig.UICorner, "Squircle", {
				Name = "BackgroundGradient",
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = MenuConfig.BackgroundGradientTransparency
					or MenuConfig.BackgroundOverlayTransparency
					or Window.BackgroundOverlayTransparency
					or 0.55,
				ZIndex = 10019,
				Parent = Root,
			}, {
				UIGradient,
			})
		end
	end

	ApplyBackgroundMedia()

	local Handle = New("Frame", {
		Name = "DragHandle",
		Size = UDim2.new(1, 0, 0, 8),
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		Visible = Compact,
		Parent = Content,
	}, {
		New("Frame", {
			Size = UDim2.new(0, 42, 0, 4),
			Position = UDim2.new(0.5, 0, 0, 1),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.72,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),
	})

	local Header = New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, Compact and 34 or 42),
		BackgroundTransparency = 1,
		Active = true,
		LayoutOrder = 1,
		Parent = Content,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Compact and 8 or 10),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
	})

	local HeaderGlyph = CreateIcon("keyboard", nil, Compact and 15 or 18)
	local HeaderIcon = Creator.NewRoundFrame(999, "Squircle", {
		Size = UDim2.new(0, Compact and 32 or 38, 0, Compact and 32 or 38),
		ImageTransparency = 0.86,
		Parent = Header,
		ThemeTag = {
			ImageColor3 = "Primary",
		},
	}, {
		HeaderGlyph,
	})
	HeaderGlyph.Position = UDim2.new(0.5, 0, 0.5, 0)
	HeaderGlyph.AnchorPoint = Vector2.new(0.5, 0.5)

	local HeaderText = New("Frame", {
		Size = UDim2.new(1, Compact and -78 or -48, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Header,
	}, {
		New("UIListLayout", {
			FillDirection = "Vertical",
			Padding = UDim.new(0, 2),
		}),
	})
	CreateText(HeaderText, MenuConfig.Title or (Compact and "Keybind" or "KeyBind Menu"), Compact and 14 or 16, Enum.FontWeight.Bold, 0)
	local HeaderDesc = CreateText(
		HeaderText,
		MenuConfig.Desc or (Compact and "Mobile quick toggle controls." or "Set the window toggle shortcut."),
		Compact and 11 or 12,
		Enum.FontWeight.Medium,
		0.42
	)
	if MenuConfig.HideDesc ~= nil then
		HeaderDesc.Visible = not MenuConfig.HideDesc
	else
		HeaderDesc.Visible = not Compact
	end

	local CloseIcon = CreateIcon("x", nil, 13)
	local CloseButton = Creator.NewRoundFrame(999, "Squircle", {
		Size = Compact and UDim2.new(0, 28, 0, 28) or UDim2.new(0, 0, 0, 0),
		ImageTransparency = 0.9,
		Visible = Compact,
		Parent = Header,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		CloseIcon,
	}, true)
	CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)

	Creator.AddSignal(CloseButton.MouseButton1Click, function()
		Menu:CloseMenu()
	end)

	local CurrentPanel = Creator.NewRoundFrame(16, "Squircle", {
		Size = UDim2.new(1, 0, 0, Compact and 48 or 58),
		ImageTransparency = Compact and 0.8 or 0.88,
		LayoutOrder = 2,
		Parent = Content,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		New("UIStroke", {
			ApplyStrokeMode = "Border",
			Color = Color3.new(1, 1, 1),
			Transparency = Compact and 0.8 or 0.88,
			Thickness = 1,
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
	})

	local CurrentKeyName = NormalizeKey(Window.ToggleKey or MenuConfig.DefaultKey or MenuConfig.Value)
	local CurrentLabel = New("TextLabel", {
		Size = UDim2.new(0.4, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "Current",
		TextSize = Compact and 11 or 12,
		TextXAlignment = "Left",
		TextTransparency = 0.44,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = CurrentPanel,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local CurrentKey = New("TextLabel", {
		Size = UDim2.new(0.6, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = CurrentKeyName,
		TextSize = Compact and 16 or 18,
		TextXAlignment = "Right",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		Parent = CurrentPanel,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local ElementBindings = Creator.NewRoundFrame(16, "Squircle", {
		Name = "ElementBindings",
		Size = UDim2.new(1, 0, 0, Compact and 84 or 94),
		ImageTransparency = Compact and 0.86 or 0.9,
		LayoutOrder = 3,
		Parent = Content,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		New("UIStroke", {
			ApplyStrokeMode = "Border",
			Color = Color3.new(1, 1, 1),
			Transparency = Compact and 0.82 or 0.9,
			Thickness = 1,
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 8),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 5),
			FillDirection = "Vertical",
			SortOrder = "LayoutOrder",
		}),
	})

	local ElementBindingsHeader = New("TextLabel", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundTransparency = 1,
		Text = "Element keybinds",
		TextSize = Compact and 11 or 12,
		TextXAlignment = "Left",
		TextTransparency = 0.3,
		LayoutOrder = 1,
		Parent = ElementBindings,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local ElementList = New("ScrollingFrame", {
		Name = "List",
		Size = UDim2.new(1, 0, 1, -19),
		BackgroundTransparency = 1,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = "Y",
		ScrollingDirection = "Y",
		ScrollBarThickness = 0,
		LayoutOrder = 2,
		Parent = ElementBindings,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 5),
			FillDirection = "Vertical",
			SortOrder = "LayoutOrder",
		}),
	})

	local ElementEmpty = New("TextLabel", {
		Name = "Empty",
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Text = "No element keybinds",
		TextSize = Compact and 11 or 12,
		TextTransparency = 0.48,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = ElementList,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local Actions = New("Frame", {
		Size = UDim2.new(1, 0, 0, Compact and 38 or 38),
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Parent = Content,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
		}),
	})

	local function CreateButton(Parent, Title, IconName, Variant, Callback)
		local Button = Creator.NewRoundFrame(14, "Squircle", {
			Size = UDim2.new(0.5, -4, 1, 0),
			ImageTransparency = Variant == "Primary" and (Compact and 0.08 or 0.18) or (Compact and 0.84 or 0.9),
			Parent = Parent,
			ThemeTag = {
				ImageColor3 = Variant == "Primary" and "Primary" or "ElementBackground",
			},
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, Compact and 8 or 10),
				PaddingRight = UDim.new(0, Compact and 8 or 10),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, Compact and 5 or 7),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
			}),
			IconName and CreateIcon(IconName, nil, Compact and 13 or 15) or nil,
			New("TextLabel", {
				Name = "Title",
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = "X",
				BackgroundTransparency = 1,
				Text = Title,
				TextSize = Compact and 12 or 13,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				ThemeTag = {
					TextColor3 = "Text",
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

	local CaptureConnection

	local function ApplyKey(KeyCode, Silent)
		local Name, EnumKey = NormalizeKey(KeyCode)
		Window:SetToggleKey(EnumKey)
		CurrentKey.Text = Name
		if not Silent then
			Notify("Keybind updated", EnumKey and ("Toggle key: " .. Name) or "Toggle key cleared.", "keyboard", "Success")
		end
	end

	local function StopCapture()
		Menu.Capturing = false
		if CaptureConnection then
			CaptureConnection:Disconnect()
			CaptureConnection = nil
		end
	end

	function Menu:Capture()
		if Menu.Capturing then
			return
		end

		Menu.Capturing = true
		CurrentKey.Text = "Press key..."

		CaptureConnection = UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			if Input.KeyCode == Enum.KeyCode.Unknown then
				return
			end
			if Input.KeyCode == Enum.KeyCode.Escape then
				StopCapture()
				local Name = NormalizeKey(Window.ToggleKey)
				CurrentKey.Text = Name
				return
			end

			ApplyKey(Input.KeyCode)
			StopCapture()
		end)
	end

	local SetButton = CreateButton(Actions, Compact and "Bind" or "Set Key", "scan-line", "Primary", function()
		Menu:Capture()
	end)
	local ClearButton = CreateButton(Actions, "Clear", "x", "Secondary", function()
		StopCapture()
		ApplyKey(nil)
	end)

	local QuickRow = New("Frame", {
		Name = "QuickKeys",
		Size = UDim2.new(1, 0, 0, Compact and 34 or 32),
		BackgroundTransparency = 1,
		LayoutOrder = 5,
		Parent = Content,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
		}),
	})

	local function ShortKeyName(KeyName)
		local Text = tostring(KeyName)
		if not Compact then
			return Text
		end

		Text = Text:gsub("Right", "R")
		Text = Text:gsub("Left", "L")
		Text = Text:gsub("Control", "Ctrl")
		return Text
	end

	for _, KeyName in next, QuickKeys do
		local _, EnumKey = NormalizeKey(KeyName)
		if EnumKey then
			CreateButton(QuickRow, ShortKeyName(KeyName), nil, "Secondary", function()
				StopCapture()
				ApplyKey(EnumKey)
			end).Size = UDim2.new(1 / #QuickKeys, -4, 1, 0)
		end
	end

	local ElementRows = {}
	local ElementRowSignals = {}

	local function ClearElementRows()
		for _, Connection in next, ElementRowSignals do
			if Connection then
				Connection:Disconnect()
			end
		end
		for _, Row in next, ElementRows do
			if Row and Row.Destroy then
				Row:Destroy()
			end
		end
		for Key in next, ElementRowSignals do
			ElementRowSignals[Key] = nil
		end
		for Key in next, ElementRows do
			ElementRows[Key] = nil
		end
	end

	local function NormalizeElementKey(Value)
		local Name, EnumKey = NormalizeKey(Value)
		if EnumKey then
			return ShortKeyName(Name), EnumKey
		end
		if typeof(Value) == "string" and Value ~= "" then
			return ShortKeyName(Value), nil
		end
		return nil, nil
	end

	local function GetElementKeybind(Element)
		if typeof(Element) ~= "table" then
			return nil, nil
		end

		local Value = Element.Keybind
			or Element.KeyBind
			or Element.Shortcut
			or Element.Bind
			or Element.Hotkey
			or (Element.__type == "Keybind" and Element.Value)
		return NormalizeElementKey(Value)
	end

	local function GetElementIcon(Element)
		if Element.__type == "Toggle" then
			return "toggle-right"
		elseif Element.__type == "Button" then
			return "mouse-pointer-click"
		end
		return "keyboard"
	end

	local function ActivateElement(Element, KeyName)
		if typeof(Element) ~= "table" then
			return
		end
		if Element.Locked then
			return
		end
		if Element.__type == "Toggle" and Element.Toggle then
			Element:Toggle()
			return
		end
		if Element.__type == "Button" and Element.Press then
			Element:Press()
			return
		end
		if Element.Callback then
			Creator.SafeCallback(Element.Callback, KeyName)
		end
	end

	local function CreateElementRow(Element, KeyName, Order)
		local Row = Creator.NewRoundFrame(12, "Squircle", {
			Name = "ElementBind",
			Size = UDim2.new(1, 0, 0, Compact and 28 or 32),
			ImageTransparency = Compact and 0.9 or 0.92,
			LayoutOrder = Order,
			Parent = ElementList,
			ThemeTag = {
				ImageColor3 = "ElementBackground",
			},
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 7),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			CreateIcon(GetElementIcon(Element), nil, Compact and 13 or 14),
			New("TextLabel", {
				Name = "Title",
				Size = UDim2.new(1, -84, 1, 0),
				BackgroundTransparency = 1,
				Text = Element.Title or Element.__type or "Element",
				TextSize = Compact and 11 or 12,
				TextXAlignment = "Left",
				TextTruncate = "AtEnd",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
			New("TextLabel", {
				Name = "Key",
				Size = UDim2.new(0, 56, 0, Compact and 20 or 22),
				BackgroundTransparency = 1,
				Text = KeyName,
				TextSize = Compact and 11 or 12,
				TextXAlignment = "Right",
				TextTransparency = 0.14,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
		}, true)

		Motion.AttachPress(Row, Creator, {
			Amount = 0.98,
		})

		local ClickConnection = Row.MouseButton1Click:Connect(function()
			ActivateElement(Element, KeyName)
		end)

		table.insert(ElementRowSignals, ClickConnection)
		table.insert(ElementRows, Row)
	end

	local function RenderElementBindings()
		ClearElementRows()

		local Count = 0
		for _, Element in next, Window.AllElements or {} do
			local KeyName = GetElementKeybind(Element)
			if KeyName then
				Count += 1
				CreateElementRow(Element, KeyName, Count)
			end
		end

		ElementEmpty.Visible = Count == 0
		ElementBindingsHeader.Text = Count > 0 and ("Element keybinds (" .. Count .. ")") or "Element keybinds"
	end

	if Window.ToggleKey == nil and MenuConfig.DefaultKey and MenuConfig.ApplyDefault ~= false then
		local _, DefaultKey = NormalizeKey(MenuConfig.DefaultKey)
		if DefaultKey then
			ApplyKey(DefaultKey, true)
		end
	end

	local function UpdateRootPosition()
		local Viewport = GetViewportSize()
		local Margin = 12

		if Compact then
			RootWidth = math.min(MenuConfig.Width or 330, math.max(240, Viewport.X - (Margin * 2)))
			RootHeight = MenuConfig.Height or 300
			Root.Size = UDim2.fromOffset(RootWidth, RootHeight)
			Root.AnchorPoint = Vector2.new(0.5, 1)
			Menu.TargetPosition = UDim2.fromOffset(Viewport.X / 2, Viewport.Y - Margin)
			Root.Position = Menu.TargetPosition
			Scrim.Size = UDim2.fromOffset(Viewport.X, Viewport.Y)

			if Menu.UserMoved and Menu.StoredPosition then
				Root.Position = Menu.StoredPosition
				Menu.TargetPosition = Menu.StoredPosition
			end

			return
		end

		local X = Viewport.X - Margin
		local Y = Margin + Window.Topbar.Height

		if Menu.Button and Menu.Button.AbsoluteSize.X > 0 then
			local ButtonPosition = Menu.Button.AbsolutePosition
			local ButtonSize = Menu.Button.AbsoluteSize
			X = ButtonPosition.X + ButtonSize.X
			Y = ButtonPosition.Y + ButtonSize.Y + 10
		end

		if X - RootWidth < Margin then
			X = math.min(Viewport.X - Margin, Margin + RootWidth)
		end
		if Y + RootHeight > Viewport.Y - Margin then
			Y = math.max(Margin, Viewport.Y - RootHeight - Margin)
		end

		Root.Position = UDim2.fromOffset(X, Y)
		Menu.TargetPosition = Root.Position
		Scrim.Size = UDim2.fromOffset(Viewport.X, Viewport.Y)

		if Menu.UserMoved and Menu.StoredPosition then
			Root.Position = Menu.StoredPosition
		end
	end

	function Menu:SetButton(Button)
		Menu.Button = Button
	end

	local DragModule = Creator.Drag(Root, { Header, Handle }, function(Dragging)
		if not Dragging then
			Menu.UserMoved = true
			Menu.StoredPosition = Root.Position
		end
	end)
	Menu.UIElements.Drag = DragModule

	function Menu:OpenMenu()
		if Menu.Open then
			return
		end

		Menu.Open = true
		Menu.Token += 1
		RenderElementBindings()
		UpdateRootPosition()
		local TargetPosition = Menu.TargetPosition or Root.Position
		Root.Visible = true
		Root.Active = true
		Scrim.Visible = true
		if Compact then
			Root.Position = UDim2.new(
				TargetPosition.X.Scale,
				TargetPosition.X.Offset,
				TargetPosition.Y.Scale,
				TargetPosition.Y.Offset + 18
			)
		end
		Root.ImageTransparency = 1
		Content.GroupTransparency = 1
		Root.GlassLayer.ImageTransparency = 1
		Root.Outline.ImageTransparency = 1
		Root.Scale.Scale = 0.98
		Scrim.BackgroundTransparency = 1
		Motion.Play(Root, "DropdownOpen", {
			ImageTransparency = MenuConfig.BackgroundTransparency or (Compact and 0.48 or 0.18),
			Position = TargetPosition,
		}, nil, nil, "KeyBindMenu")
		Motion.Play(Content, "DropdownOpen", { GroupTransparency = 0 }, nil, nil, "KeyBindContent")
		Motion.Play(Root.GlassLayer, "DropdownOpen", { ImageTransparency = Compact and 0.92 or 0.78 }, nil, nil, "KeyBindGlass")
		Motion.Play(Root.Outline, "DropdownOpen", { ImageTransparency = Compact and 0.48 or 0.72 }, nil, nil, "KeyBindOutline")
		Motion.Play(Root.Scale, "DropdownOpen", { Scale = 1 }, nil, nil, "KeyBindScale")
		Motion.Play(
			Scrim,
			"DropdownOpen",
			{ BackgroundTransparency = GetScrimTransparency() },
			nil,
			nil,
			"KeyBindScrim"
		)
	end

	function Menu:CloseMenu()
		if not Menu.Open then
			return
		end

		Menu.Open = false
		Menu.Token += 1
		local Token = Menu.Token
		StopCapture()
		Root.Active = false
		local ClosePosition = Root.Position
		if Compact then
			ClosePosition = UDim2.new(
				Root.Position.X.Scale,
				Root.Position.X.Offset,
				Root.Position.Y.Scale,
				Root.Position.Y.Offset + 18
			)
		end
		Motion.Play(Root, "DropdownClose", { ImageTransparency = 1, Position = ClosePosition }, nil, nil, "KeyBindMenu")
		Motion.Play(Content, "DropdownClose", { GroupTransparency = 1 }, nil, nil, "KeyBindContent")
		Motion.Play(Root.GlassLayer, "DropdownClose", { ImageTransparency = 1 }, nil, nil, "KeyBindGlass")
		Motion.Play(Root.Outline, "DropdownClose", { ImageTransparency = 1 }, nil, nil, "KeyBindOutline")
		Motion.Play(Root.Scale, "DropdownClose", { Scale = 0.98 }, nil, nil, "KeyBindScale")
		Motion.Play(Scrim, "DropdownClose", { BackgroundTransparency = 1 }, nil, nil, "KeyBindScrim")
		task.delay(Motion.GetDuration("DropdownClose"), function()
			if Token == Menu.Token then
				Root.Visible = false
				Scrim.Visible = false
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

	Menu.UIElements.CurrentKey = CurrentKey
	Menu.UIElements.SetButton = SetButton
	Menu.UIElements.ClearButton = ClearButton

	return Menu
end

return KeyBindMenu
