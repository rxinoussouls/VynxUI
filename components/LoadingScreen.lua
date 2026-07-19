local LoadingScreen = {}

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New
local Workspace = game:GetService("Workspace")

local function AsConfig(Config)
	if Config == true then
		return {}
	end
	return typeof(Config) == "table" and Config or {}
end

local function ClampProgress(Value)
	return math.clamp(tonumber(Value) or 0, 0, 1)
end

local function CreateIcon(IconName, Parent, Size, Folder)
	local Icon = Creator.Image(IconName or "sparkles", IconName or "sparkles", 0, Folder or "Temp", "LoadingScreen", true, true)
	Icon.Size = UDim2.fromOffset(Size or 22, Size or 22)
	Icon.Parent = Parent
	return Icon
end

local function GetViewportSize()
	local Camera = Workspace.CurrentCamera
	return Camera and Camera.ViewportSize or Vector2.new(1280, 720)
end

function LoadingScreen.new(WindUI, Config)
	Config = AsConfig(Config)

	local Steps = Config.Steps or { "Theme", "Motion", "Interface" }
	local ViewportSize = GetViewportSize()
	local Width = math.floor(math.min(Config.Width or 360, math.max(286, ViewportSize.X - 28)))
	local Loader = {
		Closed = false,
		Progress = ClampProgress(Config.Progress or 0.08),
		UIElements = {},
	}

	local Root = New("Frame", {
		Name = Config.Name or "WindUILoadingScreen",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = Config.ZIndex or 11000,
		Parent = Config.Parent or WindUI.ScreenGui,
	})

	local Scrim = New("Frame", {
		Name = "Scrim",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		ZIndex = Root.ZIndex,
		Parent = Root,
	})

	local Content = New("CanvasGroup", {
		Name = "Content",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		ZIndex = Root.ZIndex + 1,
		Parent = Root,
	})

	local Card = Creator.NewRoundFrame(Config.Corner or 28, "Squircle", {
		Name = "Card",
		Size = UDim2.fromOffset(Width, 230),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ImageTransparency = 1,
		ZIndex = Root.ZIndex + 2,
		Parent = Content,
		ThemeTag = {
			ImageColor3 = "Background",
		},
	}, {
		New("UIScale", {
			Name = "Scale",
			Scale = 0.96,
		}),
		Creator.NewRoundFrame(Config.Corner or 28, "SquircleGlass", {
			Name = "Glass",
			Size = UDim2.new(1, 1, 1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ImageTransparency = 0.82,
			ZIndex = Root.ZIndex + 3,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}),
		Creator.NewRoundFrame(Config.Corner or 28, "SquircleOutline", {
			Name = "Outline",
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.64,
			ZIndex = Root.ZIndex + 4,
			ThemeTag = {
				ImageColor3 = "Outline",
			},
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 18),
			PaddingLeft = UDim.new(0, 18),
			PaddingRight = UDim.new(0, 18),
			PaddingBottom = UDim.new(0, 18),
		}),
		New("UIListLayout", {
			FillDirection = "Vertical",
			Padding = UDim.new(0, 14),
			SortOrder = "LayoutOrder",
		}),
	})

	local Accent = Creator.NewRoundFrame(24, "Squircle", {
		Name = "Accent",
		Size = UDim2.new(1, 0, 0, 72),
		ImageTransparency = 0.82,
		LayoutOrder = 1,
		ZIndex = Root.ZIndex + 5,
		Parent = Card,
		ThemeTag = {
			ImageColor3 = "Primary",
		},
	}, {
		New("UIGradient", {
			Name = "AccentGradient",
			Rotation = 18,
			Offset = Vector2.new(-0.25, 0),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1),
				NumberSequenceKeypoint.new(0.5, 0.24),
				NumberSequenceKeypoint.new(1, 0.5),
			}),
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
		}),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			Padding = UDim.new(0, 12),
		}),
	})

	local IconWrap = Creator.NewRoundFrame(999, "Squircle", {
		Size = UDim2.fromOffset(42, 42),
		ImageTransparency = 0.72,
		ZIndex = Root.ZIndex + 6,
		Parent = Accent,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	})
	local Icon = CreateIcon(Config.Icon or "sparkles", IconWrap, 21, Config.Folder)
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)

	local HeaderText = New("Frame", {
		Size = UDim2.new(1, -54, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Accent,
		ZIndex = Root.ZIndex + 6,
	}, {
		New("UIListLayout", {
			FillDirection = "Vertical",
			Padding = UDim.new(0, 3),
		}),
	})

	local Title = New("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = Config.Title or "WindUI",
		TextSize = 18,
		TextXAlignment = "Left",
		TextWrapped = true,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		Parent = HeaderText,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local Desc = New("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = Config.Desc or "Preparing interface",
		TextSize = 13,
		TextTransparency = 0.34,
		TextXAlignment = "Left",
		TextWrapped = true,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = HeaderText,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local Status = New("TextLabel", {
		Name = "Status",
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = Config.Status or Steps[1] or "Loading",
		TextSize = 13,
		TextTransparency = 0.18,
		TextXAlignment = "Left",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		LayoutOrder = 2,
		Parent = Card,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local Track = Creator.NewRoundFrame(999, "Squircle", {
		Name = "ProgressTrack",
		Size = UDim2.new(1, 0, 0, 10),
		ImageTransparency = 0.82,
		LayoutOrder = 3,
		ZIndex = Root.ZIndex + 5,
		Parent = Card,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "Fill",
			Size = UDim2.new(Loader.Progress, 0, 1, 0),
			ImageTransparency = 0.06,
			ZIndex = Root.ZIndex + 6,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}, {
			New("UIGradient", {
				Name = "FillGradient",
				Rotation = 0,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.05),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(1, 0.18),
				}),
			}),
		}),
	})

	local StepRow = New("Frame", {
		Name = "Steps",
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Parent = Card,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			Padding = UDim.new(0, 8),
		}),
	})

	local StepLabels = {}
	for Index, Step in next, Steps do
		local Pill = Creator.NewRoundFrame(12, "Squircle", {
			Size = UDim2.new(1 / #Steps, -6, 1, 0),
			ImageTransparency = Index == 1 and 0.84 or 0.94,
			Parent = StepRow,
			ThemeTag = {
				ImageColor3 = "ElementBackground",
			},
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			}),
			New("TextLabel", {
				Name = "Title",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = tostring(Step),
				TextSize = 11,
				TextTransparency = Index == 1 and 0.08 or 0.4,
				TextTruncate = "AtEnd",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
		})
		table.insert(StepLabels, Pill)
	end

	function Loader:SetStatus(Text)
		Status.Text = tostring(Text or "")
		return Loader
	end

	function Loader:SetProgress(Value)
		Loader.Progress = ClampProgress(Value)
		Motion.Play(Track.Fill, "Switch", {
			Size = UDim2.new(Loader.Progress, 0, 1, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "LoadingProgress")
		return Loader
	end

	function Loader:Step(Index, Text)
		local Count = math.max(#StepLabels, 1)
		local ActiveIndex = math.clamp(tonumber(Index) or 1, 1, Count)
		if Text then
			Loader:SetStatus(Text)
		else
			Loader:SetStatus(Steps[ActiveIndex] or Status.Text)
		end
		Loader:SetProgress(ActiveIndex / Count)

		for StepIndex, Pill in next, StepLabels do
			local Active = StepIndex <= ActiveIndex
			Motion.Play(Pill, "Switch", { ImageTransparency = Active and 0.84 or 0.94 }, nil, nil, "Step")
			if Pill.Title then
				Motion.Play(Pill.Title, "Switch", { TextTransparency = Active and 0.08 or 0.4 }, nil, nil, "StepText")
			end
		end
		return Loader
	end

	function Loader:Close(Delay)
		if Loader.Closed then
			return Loader
		end
		Loader.Closed = true
		task.delay(tonumber(Delay) or 0, function()
			Motion.Play(Content, "DropdownClose", { GroupTransparency = 1 }, nil, nil, "LoadingContent")
			Motion.Play(Scrim, "DropdownClose", { BackgroundTransparency = 1 }, nil, nil, "LoadingScrim")
			Motion.Play(Card, "DropdownClose", { ImageTransparency = 1 }, nil, nil, "LoadingCard")
			Motion.Play(Card.Scale, "DropdownClose", { Scale = 0.96 }, nil, nil, "LoadingScale")
			task.wait(Motion.GetDuration("DropdownClose") + 0.03)
			if Root then
				Root:Destroy()
			end
		end)
		return Loader
	end

	function Loader:Open()
		Loader.Closed = false
		Root.Visible = true
		Scrim.BackgroundTransparency = 1
		Content.GroupTransparency = 1
		Card.ImageTransparency = 1
		Card.Scale.Scale = 0.96
		Motion.Play(Scrim, "DropdownOpen", {
			BackgroundTransparency = Config.ScrimTransparency or 0.2,
		}, nil, nil, "LoadingScrim")
		Motion.Play(Content, "DropdownOpen", { GroupTransparency = 0 }, nil, nil, "LoadingContent")
		Motion.Play(Card, "DropdownOpen", { ImageTransparency = Config.CardTransparency or 0.16 }, nil, nil, "LoadingCard")
		Motion.Play(Card.Scale, "DropdownOpen", { Scale = 1 }, nil, nil, "LoadingScale")
		return Loader
	end

	Loader.UIElements.Root = Root
	Loader.UIElements.Scrim = Scrim
	Loader.UIElements.Content = Content
	Loader.UIElements.Card = Card
	Loader.UIElements.Status = Status
	Loader.UIElements.ProgressFill = Track.Fill

	Loader:Open()

	if Motion:IsEnabled() and not Motion.Reduced then
		task.spawn(function()
			local Direction = 1
			while not Loader.Closed and Accent and Accent.Parent do
				local Gradient = Accent:FindFirstChild("AccentGradient")
				local FillGradient = Track.Fill and Track.Fill:FindFirstChild("FillGradient")
				if Gradient then
					Motion.Play(Gradient, "Background", { Offset = Vector2.new(Direction * 0.28, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, "LoadingSheen")
				end
				if FillGradient then
					Motion.Play(FillGradient, "Background", { Offset = Vector2.new(Direction * 0.38, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, "LoadingFillSheen")
				end
				Direction *= -1
				task.wait(Motion.GetDuration("Background") + 0.18)
			end
		end)
	end

	if Config.Duration or Config.AutoClose then
		task.delay(tonumber(Config.Duration) or 1.2, function()
			Loader:SetProgress(1)
			Loader:Close(Config.CloseDelay or 0.15)
		end)
	end

	return Loader
end

return LoadingScreen
