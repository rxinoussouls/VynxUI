local KeySystem = {}

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New
local Workspace = game:GetService("Workspace")

local CreateButton = require("./ui/Button").New
local CreateInput = require("./ui/Input").New

local function GetViewportSize()
	local Camera = Workspace.CurrentCamera
	return Camera and Camera.ViewportSize or Vector2.new(1280, 720)
end

function KeySystem.new(Config, Filename, func, keyValidator)
	local KeyDialogInit = require("./window/Dialog")
	local KeyDialog = KeyDialogInit.Create(true, "Popup", Config.Window, Config.WindUI, Config.WindUI.ScreenGui.KeySystem)

	local Services = {}

	local EnteredKey

	local ViewportSize = GetViewportSize()
	local IsCompact = ViewportSize.X < 560
	local UseThumbnail = Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image and not IsCompact
	local ThumbnailSize = (UseThumbnail and Config.KeySystem.Thumbnail.Width) or 200

	local UISize = Config.KeySystem.Width or 430
	if UseThumbnail then
		UISize = 430 + (ThumbnailSize / 2)
	end
	UISize = math.floor(math.min(UISize, math.max(300, ViewportSize.X - 24)))

	KeyDialog.UIElements.Main.AutomaticSize = "Y"
	KeyDialog.UIElements.Main.Size = UDim2.new(0, UISize, 0, 0)
	KeyDialog.UIElements.MainContainer.ClipsDescendants = true

	local DialogScale = New("UIScale", {
		Name = "Scale",
		Scale = 0.96,
		Parent = KeyDialog.UIElements.MainContainer,
	})

	Creator.NewRoundFrame(26, "SquircleGlass", {
		Name = "GlassLayer",
		Size = UDim2.new(1, 1, 1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ImageTransparency = 0.84,
		ZIndex = 9998,
		Parent = KeyDialog.UIElements.MainContainer,
		ThemeTag = {
			ImageColor3 = "Primary",
		},
	})

	Creator.NewRoundFrame(26, "SquircleOutline", {
		Name = "Outline",
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 0.62,
		ZIndex = 9998,
		Parent = KeyDialog.UIElements.MainContainer,
		ThemeTag = {
			ImageColor3 = "Outline",
		},
	})

	local IconFrame

	if Config.Icon then
		IconFrame =
			Creator.Image(Config.Icon, Config.Title .. ":" .. Config.Icon, 0, "Temp", "KeySystem", Config.IconThemed)
		IconFrame.Size = UDim2.new(0, 24, 0, 24)
		IconFrame.LayoutOrder = -1
	end

	local Title = New("TextLabel", {
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		Text = Config.KeySystem.Title or Config.Title,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		ThemeTag = {
			TextColor3 = "Text",
		},
		TextSize = 20,
	})

	local KeySystemTitle = New("TextLabel", {
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = Config.KeySystem.Subtitle or Config.KeySystem.Description or "Secure access gate",
		TextXAlignment = "Left",
		TextTransparency = 0.34,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
		TextSize = 13,
	})

	local IconAndTitleContainer = New("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = "XY",
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 14),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
		IconFrame,
		Title,
	})

	local StatusText = New("TextLabel", {
		BackgroundTransparency = 1,
		Text = "Waiting",
		TextSize = 12,
		TextTransparency = 0.08,
		AutomaticSize = "XY",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local StatusPill = Creator.NewRoundFrame(999, "Squircle", {
		Size = UDim2.new(0, 0, 0, 28),
		AutomaticSize = "X",
		ImageTransparency = 0.84,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			Padding = UDim.new(0, 6),
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "Dot",
			Size = UDim2.fromOffset(7, 7),
			ImageTransparency = 0,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}),
		StatusText,
	})

	local HeaderTop = New("Frame", {
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
		IconAndTitleContainer,
		StatusPill,
	})

	IconAndTitleContainer.Size = UDim2.new(1, -112, 0, 0)

	local TitleContainer = Creator.NewRoundFrame(18, "Squircle", {
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		ImageTransparency = 0.86,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		New("UIGradient", {
			Rotation = 18,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.06),
				NumberSequenceKeypoint.new(1, 0.34),
			}),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
		}),
		HeaderTop,
		KeySystemTitle,
	})

	local InputFrame = CreateInput(Config.KeySystem.Placeholder or "Enter Key", "key", nil, "Input", function(k)
		EnteredKey = k
	end)

	local NoteText
	if Config.KeySystem.Note and Config.KeySystem.Note ~= "" then
		NoteText = New("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextXAlignment = "Left",
			Text = Config.KeySystem.Note,
			TextSize = 18,
			TextTransparency = 0.4,
			ThemeTag = {
				TextColor3 = "Text",
			},
			BackgroundTransparency = 1,
			RichText = true,
			TextWrapped = true,
		})
	end

	local ProgressFillGradient = New("UIGradient", {
		Name = "FillGradient",
		Rotation = 0,
		Offset = Vector2.new(-0.2, 0),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.08),
			NumberSequenceKeypoint.new(0.45, 0),
			NumberSequenceKeypoint.new(1, 0.2),
		}),
	})
	local ProgressFill = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Fill",
		Size = UDim2.new(0.18, 0, 1, 0),
		ClipsDescendants = true,
		ImageTransparency = 0.02,
		ZIndex = 3,
		ThemeTag = {
			ImageColor3 = "Primary",
		},
	}, {
		ProgressFillGradient,
		Creator.NewRoundFrame(999, "SquircleGlass", {
			Name = "LiquidSheen",
			Size = UDim2.new(0.42, 0, 1, 0),
			Position = UDim2.new(0.18, 0, 0, 0),
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.7,
			ZIndex = 4,
		}, {
			New("UIGradient", {
				Rotation = 0,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.48, 0.22),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		}),
	})
	local ProgressText = New("TextLabel", {
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = "Access check ready",
		TextSize = 12,
		TextTransparency = 0.34,
		TextXAlignment = "Left",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})
	local ProgressTrack = Creator.NewRoundFrame(999, "Squircle", {
		Name = "ProgressTrack",
		Size = UDim2.new(1, 0, 0, 10),
		ClipsDescendants = true,
		ImageTransparency = 0.84,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		Creator.NewRoundFrame(999, "SquircleGlass", {
			Name = "TrackGlass",
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.92,
			ZIndex = 2,
		}),
		ProgressFill,
		Creator.NewRoundFrame(999, "SquircleOutline", {
			Name = "TrackOutline",
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.72,
			ZIndex = 5,
			ThemeTag = {
				ImageColor3 = "Outline",
			},
		}),
	})
	local ProgressCard = New("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			FillDirection = "Vertical",
			Padding = UDim.new(0, 6),
		}),
		ProgressText,
		ProgressTrack,
	})

	local function SetState(Text, Progress, IsError)
		StatusText.Text = tostring(Text or StatusText.Text)
		ProgressText.Text = tostring(Text or ProgressText.Text)
		if IsError then
			StatusPill.Dot.ImageColor3 = Color3.fromRGB(255, 94, 94)
			ProgressFill.ImageColor3 = Color3.fromRGB(255, 94, 94)
		else
			Creator.SetThemeTag(StatusPill.Dot, {
				ImageColor3 = "Primary",
			}, 0.12)
			Creator.SetThemeTag(ProgressFill, {
				ImageColor3 = "Primary",
			}, 0.12)
		end
		if Progress ~= nil then
			ProgressFillGradient.Offset = Vector2.new(-0.2, 0)
			Motion.Play(ProgressFill, "Switch", {
				Size = UDim2.new(math.clamp(tonumber(Progress) or 0, 0, 1), 0, 1, 0),
			}, nil, nil, "KeySystemProgress")
			Motion.Play(ProgressFillGradient, "Background", {
				Offset = Vector2.new(0.45, 0),
			}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, "KeySystemProgressSheen")
		end
	end

	local ButtonsContainer = New("Frame", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
	}, {
		New("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = "X",
			Size = UDim2.new(0, 0, 1, 0),
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 18 / 2),
				FillDirection = "Horizontal",
			}),
		}),
	})

	local ThumbnailFrame
	if UseThumbnail then
		local ThumbnailTitle
		if Config.KeySystem.Thumbnail.Title then
			ThumbnailTitle = New("TextLabel", {
				Text = Config.KeySystem.Thumbnail.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 18,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				BackgroundTransparency = 1,
				AutomaticSize = "XY",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
		end
		ThumbnailFrame = New("ImageLabel", {
			Image = Config.KeySystem.Thumbnail.Image,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ThumbnailSize, 1, -12),
			Position = UDim2.new(0, 6, 0, 6),
			Parent = KeyDialog.UIElements.Main,
			ScaleType = "Crop",
		}, {
			ThumbnailTitle,
			New("UICorner", {
				CornerRadius = UDim.new(0, 26 - 6),
			}),
		})
	end

	local MainFrame = New("Frame", {
		--AutomaticSize = "XY",
		Size = UDim2.new(1, ThumbnailFrame and -ThumbnailSize or 0, 1, 0),
		Position = UDim2.new(0, ThumbnailFrame and ThumbnailSize or 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = KeyDialog.UIElements.Main,
	}, {
		New("Frame", {
			--AutomaticSize = "XY",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 18),
				FillDirection = "Vertical",
			}),
			TitleContainer,
			NoteText,
			InputFrame,
			ProgressCard,
			ButtonsContainer,
			New("UIPadding", {
				PaddingTop = UDim.new(0, 16),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
				PaddingBottom = UDim.new(0, 16),
			}),
		}),
	})

	-- for _, values in next, KeySystemButtons do
	--     CreateButton(values.Title, values.Icon, values.Callback, values.Variant)
	-- end

	local ExitButton = CreateButton("Exit", "log-out", function()
		KeyDialog:Close()()
	end, "Tertiary", ButtonsContainer.Frame)

	if ThumbnailFrame then
		ExitButton.Parent = ThumbnailFrame
		ExitButton.Size = UDim2.new(0, 0, 0, 42)
		ExitButton.Position = UDim2.new(0, 10, 1, -10)
		ExitButton.AnchorPoint = Vector2.new(0, 1)
	end

	local function NotifyKeySystem(Content, Icon, Style)
		if Config.WindUI and Config.WindUI.Notify then
			Config.WindUI:Notify({
				Title = "Key System",
				Content = Content,
				Icon = Icon or "key",
				Style = Style,
			})
		end
	end

	local function CopyRawLink(Link)
		Link = Link and tostring(Link) or ""
		if Link == "" then
			return false, "No key link configured."
		end

		local Clipboard = setclipboard or toclipboard
		if not Clipboard then
			return false, "Clipboard is not available on this executor."
		end

		Clipboard(Link)
		return true
	end

	local function PickServiceLink(ServiceConfig)
		return ServiceConfig.Discord
			or ServiceConfig.URL
			or ServiceConfig.Url
			or ServiceConfig.url
			or ServiceConfig.Link
			or ServiceConfig.link
	end

	local function CopyServiceLink(ServiceEntry)
		local Link = PickServiceLink(ServiceEntry.Config)
		local CopyOk, CopyResult

		if Link then
			CopyOk, CopyResult = CopyRawLink(Link)
		elseif ServiceEntry.Instance and type(ServiceEntry.Instance.Copy) == "function" then
			CopyOk, CopyResult = pcall(ServiceEntry.Instance.Copy)
		else
			CopyOk, CopyResult = false, ServiceEntry.Error or "Service link is not ready."
		end

		if CopyOk then
			SetState("Key link copied", 0.36)
			NotifyKeySystem("Key link copied to clipboard.", "key", "Success")
		else
			SetState("Copy unavailable", 0.08, true)
			NotifyKeySystem(tostring(CopyResult or "Unable to copy key link."), "triangle-alert", "Warning")
		end
	end

	if Config.KeySystem.URL and not Config.KeySystem.API then
		CreateButton("Get key", "key", function()
			local CopyOk, CopyResult = CopyRawLink(Config.KeySystem.URL)
			if CopyOk then
				SetState("Key link copied", 0.36)
				NotifyKeySystem("Key link copied to clipboard.", "key", "Success")
			else
				SetState("Copy unavailable", 0.08, true)
				NotifyKeySystem(tostring(CopyResult), "triangle-alert", "Warning")
			end
		end, "Secondary", ButtonsContainer.Frame)
	end

	if Config.KeySystem.API then
		local ServiceEntries = {}
		for _, i in next, Config.KeySystem.API do
			local serviceDef = Config.WindUI.Services[i.Type]
			if serviceDef then
				local args = {}
				for _, argName in next, serviceDef.Args do
					table.insert(args, i[argName])
				end

				local CreateOk, serviceInstance = pcall(function()
					return serviceDef.New(table.unpack(args))
				end)

				local Entry = {
					Config = i,
					Definition = serviceDef,
					Instance = nil,
					Error = nil,
				}

				if CreateOk and serviceInstance then
					serviceInstance.Type = i.Type
					Entry.Instance = serviceInstance
					table.insert(Services, serviceInstance)
				else
					Entry.Error = serviceInstance
				end

				table.insert(ServiceEntries, Entry)
			end
		end

		local Width = math.min(240, math.max(190, UISize - 42))
		local Opened = false

		if #ServiceEntries == 1 then
			CreateButton("Get key", "key", function()
				CopyServiceLink(ServiceEntries[1])
			end, "Secondary", ButtonsContainer.Frame)
		elseif #ServiceEntries > 1 then
			local ButtonFrame = CreateButton("Get key", "key", nil, "Secondary", ButtonsContainer.Frame)

			local Divider = Creator.NewRoundFrame(99, "Squircle", {
				Size = UDim2.new(0, 1, 1, 0),
				ThemeTag = {
					ImageColor3 = "Text",
				},
				ImageTransparency = 0.9,
			})

			New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = "X",
				Parent = ButtonFrame.Frame,
			}, {
				Divider,
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 5),
					PaddingRight = UDim.new(0, 5),
				}),
			})

			local ChevronDown = Creator.Image("chevron-down", "chevron-down", 0, "Temp", "KeySystem", true)

			ChevronDown.Size = UDim2.new(1, 0, 1, 0)

			New("Frame", {
				Size = UDim2.new(0, 24 - 3, 0, 24 - 3),
				Parent = ButtonFrame.Frame,
				BackgroundTransparency = 1,
			}, {
				ChevronDown,
			})

			local DropdownFrame = Creator.NewRoundFrame(15, "Squircle", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				ZIndex = 99999,
				ThemeTag = {
					ImageColor3 = "Background",
				},
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, 10 / 2),
					PaddingLeft = UDim.new(0, 10 / 2),
					PaddingRight = UDim.new(0, 10 / 2),
					PaddingBottom = UDim.new(0, 10 / 2),
				}),
				New("UIListLayout", {
					FillDirection = "Vertical",
					Padding = UDim.new(0, 10 / 2),
				}),
			})

			local DropdownContainer = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, Width, 0, 0),
				ClipsDescendants = true,
				AnchorPoint = Vector2.new(1, 0),
				Parent = ButtonFrame,
				Position = UDim2.new(1, 0, 1, 10),
				ZIndex = 99999,
			}, {
				DropdownFrame,
			})

			New("TextLabel", {
				Text = "Select Service",
				BackgroundTransparency = 1,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				ThemeTag = { TextColor3 = "Text" },
				TextTransparency = 0.2,
				TextSize = 15,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				TextWrapped = true,
				TextXAlignment = "Left",
				Parent = DropdownFrame,
				ZIndex = 100000,
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 8),
				}),
			})

			for _, ServiceEntry in next, ServiceEntries do
				local i = ServiceEntry.Config
				local serviceDef = ServiceEntry.Definition
				local ServiceIcon = i.Icon or serviceDef.Icon or "key-round"
				local IconFrame = Creator.Image(ServiceIcon, ServiceIcon, 0, "Temp", "KeySystem", true)
				IconFrame.Size = UDim2.new(0, 20, 0, 20)
				IconFrame.ZIndex = 100000

				local APIFrame = Creator.NewRoundFrame(10, "Squircle", {
					Size = UDim2.new(1, 0, 0, 0),
					ThemeTag = { ImageColor3 = "Text" },
					ImageTransparency = 1,
					Parent = DropdownFrame,
					AutomaticSize = "Y",
					ZIndex = 100000,
				}, {
					New("UIListLayout", {
						FillDirection = "Horizontal",
						Padding = UDim.new(0, 8),
						VerticalAlignment = "Center",
					}),
					IconFrame,
					New("UIPadding", {
						PaddingTop = UDim.new(0, 9),
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10),
						PaddingBottom = UDim.new(0, 9),
					}),
					New("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -28, 0, 0),
						AutomaticSize = "Y",
						ZIndex = 100000,
					}, {
						New("UIListLayout", {
							FillDirection = "Vertical",
							Padding = UDim.new(0, 5),
							HorizontalAlignment = "Center",
						}),
						New("TextLabel", {
							Text = i.Title or serviceDef.Name,
							BackgroundTransparency = 1,
							FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
							ThemeTag = { TextColor3 = "Text" },
							TextTransparency = 0.05,
							TextSize = 18,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = "Y",
							TextWrapped = true,
							TextXAlignment = "Left",
							ZIndex = 100001,
						}),
						New("TextLabel", {
							Text = i.Desc or "",
							BackgroundTransparency = 1,
							FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
							ThemeTag = { TextColor3 = "Text" },
							TextTransparency = 0.2,
							TextSize = 16,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = "Y",
							TextWrapped = true,
							Visible = i.Desc and true or false,
							TextXAlignment = "Left",
							ZIndex = 100001,
						}),
					}),
				}, true)

				Creator.AddSignal(APIFrame.MouseEnter, function()
					Motion.Play(APIFrame, "Hover", { ImageTransparency = 0.94 }, nil, nil, "ServiceHover")
				end)
				Creator.AddSignal(APIFrame.InputEnded, function()
					Motion.Play(APIFrame, "Hover", { ImageTransparency = 1 }, nil, nil, "ServiceHover")
				end)
				Motion.AttachPress(APIFrame, Creator, {
					Amount = 0.985,
				})
				Creator.AddSignal(APIFrame.MouseButton1Click, function()
					CopyServiceLink(ServiceEntry)
				end)
			end

			Creator.AddSignal(ButtonFrame.MouseButton1Click, function()
				if not Opened then
					Motion.Play(
						DropdownContainer,
						"Expand",
						{ Size = UDim2.new(0, Width, 0, DropdownFrame.AbsoluteSize.Y + 1) },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"KeyService"
					)
					Motion.Play(ChevronDown, "Expand", { Rotation = 180 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "KeyServiceChevron")
				else
					Motion.Play(
						DropdownContainer,
						"Expand",
						{ Size = UDim2.new(0, Width, 0, 0) },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"KeyService"
					)
					Motion.Play(ChevronDown, "Expand", { Rotation = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "KeyServiceChevron")
				end
				Opened = not Opened
			end)
		end
	end

	local function handleSuccess(key, ShouldSave)
		SetState("Access granted", 1)
		KeyDialog:Close()()
		if ShouldSave and writefile then
			pcall(function()
				writefile((Config.Folder or "Temp") .. "/" .. Filename .. ".key", tostring(key))
			end)
		end
		task.wait(0.35)
		func(true)
	end

	local IsChecking = false
	local SubmitButton = CreateButton("Submit", "arrow-right", function()
		if IsChecking then
			return
		end
		IsChecking = true
		SetState("Checking key", 0.72)

		local key = tostring(EnteredKey or "empty")
		local function Reject(Message)
			IsChecking = false
			SetState("Invalid key", 0.08, true)
			Config.WindUI:Notify({
				Title = "Key System",
				Content = Message or "Invalid key.",
				Icon = "triangle-alert",
				Style = "Error",
			})
		end

		if Config.KeySystem.KeyValidator then
			local ValidatorOk, isValid, Message = pcall(Config.KeySystem.KeyValidator, key)
			if not ValidatorOk then
				Reject(tostring(isValid))
				return
			end

			if isValid then
				handleSuccess(key, Config.KeySystem.SaveKey)
			else
				Reject(Message or "Invalid key.")
			end
		elseif not Config.KeySystem.API then
			local isKey = type(Config.KeySystem.Key) == "table" and table.find(Config.KeySystem.Key, key)
				or Config.KeySystem.Key == key

			if isKey then
				handleSuccess(key, Config.KeySystem.SaveKey)
			else
				Reject("Invalid key.")
			end
		else
			local isSuccess, result
			for _, service in next, Services do
				local VerifyOk, success, res = pcall(service.Verify, key)
				if not VerifyOk then
					local ErrorMessage = success
					success = false
					res = tostring(ErrorMessage)
				end
				if success then
					isSuccess, result = true, res
					break
				end
				result = res
			end

			if isSuccess then
				handleSuccess(key, Config.KeySystem.SaveKey ~= false)
			else
				Reject(result or "Invalid key.")
			end
		end
	end, "Primary", ButtonsContainer)

	SubmitButton.AnchorPoint = Vector2.new(1, 0.5)
	SubmitButton.Position = UDim2.new(1, 0, 0.5, 0)

	-- TitleContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	--     KeyDialog.UIElements.Main.Size = UDim2.new(
	--         0,
	--         TitleContainer.AbsoluteSize.X +24+24+24+24+9,
	--         0,
	--         0
	--     )
	-- end)

	SetState("Waiting for key", 0.18)
	KeyDialog:Open()
	Motion.Play(DialogScale, "DropdownOpen", { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "KeySystemScale")
end

return KeySystem
