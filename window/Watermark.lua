local Watermark = {}

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local POSITIONS = {
	TopLeft = { UDim2.new(0, 14, 0, 14), Vector2.new(0, 0) },
	TopRight = { UDim2.new(1, -14, 0, 14), Vector2.new(1, 0) },
	BottomLeft = { UDim2.new(0, 14, 1, -14), Vector2.new(0, 1) },
	BottomRight = { UDim2.new(1, -14, 1, -14), Vector2.new(1, 1) },
	TopCenter = { UDim2.new(0.5, 0, 0, 14), Vector2.new(0.5, 0) },
	BottomCenter = { UDim2.new(0.5, 0, 1, -14), Vector2.new(0.5, 1) },
}

local function NormalizeConfig(Config)
	if Config == false then
		return { Visible = false }
	end
	if typeof(Config) == "string" then
		return { Title = Config }
	end
	if typeof(Config) ~= "table" then
		return {}
	end
	return Config or {}
end

function Watermark.New(Window, WindUI)
	local WatermarkMain = {}
	local Icon
	local DragModule

	local Title = New("TextLabel", {
		BackgroundTransparency = 1,
		Text = Window.Title or "WindUI",
		TextSize = 13,
		TextXAlignment = "Left",
		AutomaticSize = "XY",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local Desc = New("TextLabel", {
		BackgroundTransparency = 1,
		Text = "v" .. tostring(WindUI and WindUI.Version or ""),
		TextSize = 11,
		TextTransparency = 0.42,
		TextXAlignment = "Left",
		AutomaticSize = "XY",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local Container = New("Frame", {
		Size = UDim2.new(0, 0, 0, 0),
		Position = POSITIONS.BottomRight[1],
		AnchorPoint = POSITIONS.BottomRight[2],
		BackgroundTransparency = 1,
		Parent = Window.Parent,
		Active = true,
		Visible = false,
		ZIndex = 120,
	})

	local Main = Creator.NewRoundFrame(14, "Squircle", {
		Name = "Watermark",
		Size = UDim2.new(0, 0, 0, 36),
		AutomaticSize = "XY",
		ImageTransparency = 0.18,
		Parent = Container,
		ZIndex = 120,
		ThemeTag = {
			ImageColor3 = "Background",
		},
	}, {
		New("UIStroke", {
			ApplyStrokeMode = "Border",
			Color = Color3.new(1, 1, 1),
			Transparency = 0.82,
			Thickness = 1,
		}),
		New("UIGradient", {
			Rotation = 24,
			Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(210, 235, 255)),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.96),
				NumberSequenceKeypoint.new(0.48, 0.76),
				NumberSequenceKeypoint.new(1, 0.96),
			}),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
		New("Frame", {
			Name = "Text",
			AutomaticSize = "XY",
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				FillDirection = "Vertical",
				Padding = UDim.new(0, 1),
			}),
			Title,
			Desc,
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 7),
			PaddingBottom = UDim.new(0, 7),
		}),
	})

	Creator.AddSignal(Main:GetPropertyChangedSignal("AbsoluteSize"), function()
		Container.Size = UDim2.fromOffset(Main.AbsoluteSize.X, Main.AbsoluteSize.Y)
	end)

	DragModule = Creator.Drag(Container)

	local function SetIcon(IconName)
		if Icon then
			Icon:Destroy()
			Icon = nil
		end
		if not IconName or IconName == "" then
			return
		end

		Icon = Creator.Image(IconName, IconName, 0, Window.Folder, "Watermark", true, true, "Icon")
		Icon.Size = UDim2.new(0, 16, 0, 16)
		Icon.LayoutOrder = -1
		Icon.Parent = Main
	end

	function WatermarkMain:Visible(Value)
		Container.Visible = Value ~= false
	end

	function WatermarkMain:Edit(Config)
		Config = NormalizeConfig(Config)

		if Config.Visible == false or Config.Enabled == false then
			WatermarkMain:Visible(false)
			return WatermarkMain
		end

		if Config.Title ~= nil then
			Title.Text = tostring(Config.Title)
			Creator:ChangeTranslationKey(Title, Title.Text)
		end
		if Config.Desc ~= nil or Config.Subtitle ~= nil then
			Desc.Text = tostring(Config.Desc or Config.Subtitle or "")
			Desc.Visible = Desc.Text ~= ""
			Creator:ChangeTranslationKey(Desc, Desc.Text)
		end
		if Config.Icon ~= nil then
			SetIcon(Config.Icon)
		end
		if Config.Position and POSITIONS[Config.Position] then
			Container.Position = POSITIONS[Config.Position][1]
			Container.AnchorPoint = POSITIONS[Config.Position][2]
		elseif typeof(Config.Position) == "UDim2" then
			Container.Position = Config.Position
		end
		if typeof(Config.AnchorPoint) == "Vector2" then
			Container.AnchorPoint = Config.AnchorPoint
		end
		if Config.Transparency ~= nil then
			Main.ImageTransparency = Creator.ClampTransparency(Config.Transparency, Main.ImageTransparency)
		end
		if Config.Scale then
			local Scale = Main:FindFirstChildOfClass("UIScale") or New("UIScale", { Parent = Main })
			Scale.Scale = tonumber(Config.Scale) or 1
		end
		if DragModule then
			DragModule:Set(Config.Draggable ~= false)
		end

		WatermarkMain:Visible(true)
		Motion.Play(Main, "Reveal", { ImageTransparency = Main.ImageTransparency }, nil, nil, "Watermark")
		return WatermarkMain
	end

	function WatermarkMain:SetTitle(Text)
		Title.Text = tostring(Text or "")
	end

	function WatermarkMain:SetDesc(Text)
		Desc.Text = tostring(Text or "")
		Desc.Visible = Desc.Text ~= ""
	end

	function WatermarkMain:Destroy()
		Container:Destroy()
	end

	WatermarkMain.Container = Container
	WatermarkMain.Main = Main

	return WatermarkMain
end

return Watermark
