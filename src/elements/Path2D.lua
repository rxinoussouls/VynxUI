local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local DEFAULT_POINTS = {
	Vector2.new(0.08, 0.72),
	Vector2.new(0.28, 0.38),
	Vector2.new(0.52, 0.56),
	Vector2.new(0.72, 0.24),
	Vector2.new(0.92, 0.42),
}

local LABEL_WIDTH = 92
local LABEL_HEIGHT = 22

local function NormalizePoint(Point)
	if typeof(Point) == "Vector2" then
		return Vector2.new(math.clamp(Point.X, 0, 1), math.clamp(Point.Y, 0, 1))
	end

	if typeof(Point) == "table" then
		local X = Utils.ToFiniteNumber(Point.X or Point.x or Point[1]) or 0
		local Y = Utils.ToFiniteNumber(Point.Y or Point.y or Point[2]) or 0
		return Vector2.new(math.clamp(X, 0, 1), math.clamp(Y, 0, 1))
	end

	return Vector2.new(0, 0)
end

local function NormalizePoints(Points)
	local Normalized = {}
	local Source = typeof(Points) == "table" and Points or DEFAULT_POINTS

	if #Source > 0 then
		for Index = 1, #Source do
			table.insert(Normalized, NormalizePoint(Source[Index]))
		end
	else
		for _, Point in next, Source do
			table.insert(Normalized, NormalizePoint(Point))
		end
	end

	if #Normalized < 2 then
		Normalized = DEFAULT_POINTS
	end

	return Normalized
end

local function PointToUDim2(Point)
	return UDim2.new(Point.X, 0, Point.Y, 0)
end

local function PixelToUDim2(Point)
	return UDim2.fromOffset(Point.X, Point.Y)
end

local function GetTweenPoint(FromPoint, ToPoint, Progress)
	return FromPoint:Lerp(ToPoint, math.clamp(Progress, 0, 1))
end

local function GetAngle(Y, X)
	if math.atan2 then
		return math.atan2(Y, X)
	end

	if X == 0 then
		return Y >= 0 and math.pi / 2 or -math.pi / 2
	end

	local Angle = math.atan(Y / X)
	if X < 0 then
		Angle += math.pi
	end
	return Angle
end

function Element:New(Config)
	local Path2D = {
		__type = "Path2D",
		Title = Config.Title or "Path 2D",
		Desc = Config.Desc,
		Points = NormalizePoints(Config.Points or Config.Path),
		Labels = Config.Labels or {},
		Height = math.max(Utils.ToFiniteNumber(Config.Height) or 156, 96),
		Thickness = math.max(Utils.ToFiniteNumber(Config.Thickness) or 4, 2),
		Padding = math.max(Utils.ToFiniteNumber(Config.PathPadding or Config.Padding) or 20, 0),
		DotSize = math.max(Utils.ToFiniteNumber(Config.DotSize) or 9, 5),
		MarkerSize = math.max(Utils.ToFiniteNumber(Config.MarkerSize) or 16, 10),
		Duration = math.max(Utils.ToFiniteNumber(Config.Duration) or 1.2, 0.18),
		StepDelay = math.max(Utils.ToFiniteNumber(Config.StepDelay) or 0.055, 0),
		Loop = Config.Loop == true,
		AutoPlay = Config.AutoPlay ~= false,
		Glow = Config.Glow ~= false,
		UIElements = {},
		Segments = {},
		Dots = {},
		LabelObjects = {},
		PlayToken = 0,
		HasRendered = false,
		Destroyed = false,
	}

	Path2D.Path2DFrame = require("../components/window/Element")({
		Title = Path2D.Title,
		Desc = Path2D.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Path2D,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Path2D.UIElements.Canvas = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
		Name = "Path2DCanvas",
		Size = UDim2.new(1, 0, 0, Path2D.Height),
		ClipsDescendants = true,
		ImageTransparency = Creator.ClampTransparency(Config.BackgroundTransparency, 0.92),
		Parent = Path2D.Path2DFrame.UIElements.Container,
		ThemeTag = {
			ImageColor3 = "Path2DBackground",
		},
	}, {
		New("UIGradient", {
			Rotation = 25,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.08),
				NumberSequenceKeypoint.new(1, 0.28),
			}),
		}),
	})

	local function ClearObjects()
		for _, Segment in next, Path2D.Segments do
			Segment.Track:Destroy()
		end
		for _, Dot in next, Path2D.Dots do
			Dot:Destroy()
		end
		for _, Label in next, Path2D.LabelObjects do
			Label:Destroy()
		end
		if Path2D.UIElements.Marker then
			Path2D.UIElements.Marker:Destroy()
			Path2D.UIElements.Marker = nil
		end

		Path2D.Segments = {}
		Path2D.Dots = {}
		Path2D.LabelObjects = {}
	end

	local function GetCanvasSize()
		local Size = Path2D.UIElements.Canvas.AbsoluteSize
		return Vector2.new(Size.X / Config.UIScale, Size.Y / Config.UIScale)
	end

	local function GetPixelPoint(Point, CanvasSize)
		local Padding = math.min(Path2D.Padding, math.max(CanvasSize.X, CanvasSize.Y) / 3)
		local UsableSize = Vector2.new(
			math.max(CanvasSize.X - (Padding * 2), 1),
			math.max(CanvasSize.Y - (Padding * 2), 1)
		)

		return Vector2.new(
			Padding + (Point.X * UsableSize.X),
			Padding + (Point.Y * UsableSize.Y)
		)
	end

	local function GetLabelPosition(PixelPoint, CanvasSize, LabelConfig)
		local Width = math.max(Utils.ToFiniteNumber(LabelConfig.Width) or LABEL_WIDTH, 54)
		local Height = math.max(Utils.ToFiniteNumber(LabelConfig.Height) or LABEL_HEIGHT, 18)
		local OffsetX = Utils.ToFiniteNumber(LabelConfig.OffsetX) or 0
		local OffsetY = Utils.ToFiniteNumber(LabelConfig.OffsetY)
		if OffsetY == nil then
			OffsetY = LabelConfig.Above == false and 18 or -18
		end

		return Vector2.new(
			math.clamp(PixelPoint.X + OffsetX, (Width / 2) + 6, math.max((Width / 2) + 6, CanvasSize.X - (Width / 2) - 6)),
			math.clamp(PixelPoint.Y + OffsetY, (Height / 2) + 6, math.max((Height / 2) + 6, CanvasSize.Y - (Height / 2) - 6))
		), Width, Height
	end

	function Path2D:Render(ShouldPlay)
		local CanvasSize = GetCanvasSize()
		if CanvasSize.X <= 0 or CanvasSize.Y <= 0 then
			return
		end

		local ShouldAnimate = ShouldPlay ~= false and Path2D.AutoPlay
		Path2D.PlayToken = Path2D.PlayToken + 1
		Path2D.HasRendered = true
		ClearObjects()

		for Index = 1, #Path2D.Points - 1 do
			local StartPoint = GetPixelPoint(Path2D.Points[Index], CanvasSize)
			local EndPoint = GetPixelPoint(Path2D.Points[Index + 1], CanvasSize)
			local Delta = EndPoint - StartPoint
			local Length = Delta.Magnitude
			local Angle = math.deg(GetAngle(Delta.Y, Delta.X))
			local MidPoint = (StartPoint + EndPoint) / 2

			local Track = Creator.NewRoundFrame(999, "Squircle", {
				Name = "Segment" .. tostring(Index),
				Size = UDim2.new(0, Length, 0, Path2D.Thickness),
				Position = PixelToUDim2(MidPoint),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Rotation = Angle,
				ImageTransparency = 0.84,
				Parent = Path2D.UIElements.Canvas,
				ZIndex = 2,
				ThemeTag = {
					ImageColor3 = "Path2DTrack",
				},
			})

			local Glow = Path2D.Glow and Creator.NewRoundFrame(999, "Squircle", {
				Name = "Glow",
				Size = UDim2.new(0, ShouldAnimate and 0 or Length, 0, Path2D.Thickness + 8),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				ImageTransparency = 0.84,
				ZIndex = 2,
				Parent = Track,
				ThemeTag = {
					ImageColor3 = "Path2DLine",
				},
			}) or nil

			local Fill = Creator.NewRoundFrame(999, "Squircle", {
				Name = "Fill",
				Size = UDim2.new(0, ShouldAnimate and 0 or Length, 1, 0),
				ImageTransparency = 0,
				ZIndex = 3,
				Parent = Track,
				ThemeTag = {
					ImageColor3 = "Path2DLine",
				},
			})

			table.insert(Path2D.Segments, {
				Track = Track,
				Glow = Glow,
				Fill = Fill,
				Length = Length,
				From = Path2D.Points[Index],
				To = Path2D.Points[Index + 1],
				FromPixel = StartPoint,
				ToPixel = EndPoint,
				FromPosition = PixelToUDim2(StartPoint),
				ToPosition = PixelToUDim2(EndPoint),
			})
		end

		for Index = 1, #Path2D.Points do
			local Point = Path2D.Points[Index]
			local PixelPoint = GetPixelPoint(Point, CanvasSize)
			local Size = Index == 1 and Path2D.DotSize + 3 or Path2D.DotSize
			local Dot = Creator.NewRoundFrame(999, "Circle", {
				Name = "Point" .. tostring(Index),
				Size = UDim2.new(0, Size, 0, Size),
				Position = PixelToUDim2(PixelPoint),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = ShouldAnimate and 0.54 or 0.12,
				Parent = Path2D.UIElements.Canvas,
				ZIndex = 4,
				ThemeTag = {
					ImageColor3 = Index == #Path2D.Points and "Path2DMarker" or "Path2DLine",
				},
			}, {
				Creator.NewRoundFrame(999, "Circle", {
					Name = "DotCore",
					Size = UDim2.new(0, math.max(Size - 5, 3), 0, math.max(Size - 5, 3)),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageColor3 = Color3.new(1, 1, 1),
					ImageTransparency = 0.22,
					ZIndex = 5,
				}),
			})
			table.insert(Path2D.Dots, Dot)
		end

		for _, LabelConfig in next, Path2D.Labels do
			if typeof(LabelConfig) ~= "table" then
				LabelConfig = {
					Text = tostring(LabelConfig),
				}
			end
			local PointIndex = math.clamp(math.floor(Utils.ToFiniteNumber(LabelConfig.Point or LabelConfig.Index) or 1), 1, #Path2D.Points)
			local PixelPoint = GetPixelPoint(Path2D.Points[PointIndex], CanvasSize)
			local LabelPosition, Width, Height = GetLabelPosition(PixelPoint, CanvasSize, LabelConfig)
			local Label = New("TextLabel", {
				Name = "PathLabel",
				Size = UDim2.new(0, Width, 0, Height),
				Position = PixelToUDim2(LabelPosition),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Text = tostring(LabelConfig.Text or LabelConfig.Title or PointIndex),
				TextSize = 12,
				TextTransparency = 0.22,
				TextXAlignment = "Center",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				Parent = Path2D.UIElements.Canvas,
				ZIndex = 6,
				ThemeTag = {
					TextColor3 = "Path2DLabel",
				},
			})
			table.insert(Path2D.LabelObjects, Label)
		end

		local Marker = Creator.NewRoundFrame(999, "Circle", {
			Name = "Marker",
			Size = UDim2.new(0, Path2D.MarkerSize, 0, Path2D.MarkerSize),
			Position = ShouldAnimate and Path2D.Segments[1] and Path2D.Segments[1].FromPosition
				or PixelToUDim2(GetPixelPoint(Path2D.Points[#Path2D.Points], CanvasSize)),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = 0,
			Parent = Path2D.UIElements.Canvas,
			ZIndex = 8,
			ThemeTag = {
				ImageColor3 = "Path2DMarker",
			},
		}, {
			Creator.NewRoundFrame(999, "Circle", {
				Name = "Halo",
				Size = UDim2.new(1, 12, 1, 12),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = 0.78,
				ZIndex = 7,
				ThemeTag = {
					ImageColor3 = "Path2DMarker",
				},
			}),
			Creator.NewRoundFrame(999, "Circle", {
				Name = "Core",
				Size = UDim2.new(0, 6, 0, 6),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = Color3.new(1, 1, 1),
				ZIndex = 9,
			}),
		})
		Path2D.UIElements.Marker = Marker

		if ShouldAnimate then
			Path2D:Play()
		end
	end

	function Path2D:Play()
		Path2D.PlayToken = Path2D.PlayToken + 1
		local Token = Path2D.PlayToken
		local SegmentDuration = Path2D.Duration / math.max(#Path2D.Segments, 1)

		if Path2D.UIElements.Marker then
			Path2D.UIElements.Marker.Position = Path2D.Segments[1] and Path2D.Segments[1].FromPosition
				or PointToUDim2(Path2D.Points[1])
		end
		for _, Dot in next, Path2D.Dots do
			Dot.ImageTransparency = 0.72
		end
		for _, Segment in next, Path2D.Segments do
			Segment.Fill.Size = UDim2.new(0, 0, 1, 0)
			if Segment.Glow then
				Segment.Glow.Size = UDim2.new(0, 0, 0, Path2D.Thickness + 8)
			end
		end

		for Index = 1, #Path2D.Segments do
			local Segment = Path2D.Segments[Index]
			local DelayTime = (Index - 1) * (SegmentDuration + Path2D.StepDelay)
			task.delay(DelayTime, function()
				if Token ~= Path2D.PlayToken or Path2D.Destroyed then
					return
				end

				if Path2D.Dots[Index] then
					Motion.Play(Path2D.Dots[Index], "Reveal", { ImageTransparency = 0.12 }, nil, nil, "Point")
				end
				Motion.Play(
					Segment.Fill,
					SegmentDuration,
					{ Size = UDim2.new(0, Segment.Length, 1, 0) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Draw"
				)
				if Segment.Glow then
					Motion.Play(
						Segment.Glow,
						SegmentDuration,
						{ Size = UDim2.new(0, Segment.Length, 0, Path2D.Thickness + 8) },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"Glow"
					)
				end
				if Path2D.UIElements.Marker then
					Motion.Play(
						Path2D.UIElements.Marker,
						SegmentDuration,
						{ Position = Segment.ToPosition },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"Path"
					)
				end
			end)
		end

		local EndDelay = #Path2D.Segments * (SegmentDuration + Path2D.StepDelay)
		task.delay(EndDelay, function()
			if Token ~= Path2D.PlayToken or Path2D.Destroyed then
				return
			end
			if Path2D.Dots[#Path2D.Dots] then
				Motion.Play(Path2D.Dots[#Path2D.Dots], "Reveal", { ImageTransparency = 0 }, nil, nil, "Point")
			end
			if Path2D.Loop then
				task.delay(0.4, function()
					if Token == Path2D.PlayToken and not Path2D.Destroyed then
						Path2D:Play()
					end
				end)
			end
		end)
	end

	function Path2D:Stop()
		Path2D.PlayToken = Path2D.PlayToken + 1
		if Path2D.UIElements.Marker then
			Motion.Cancel(Path2D.UIElements.Marker, "Path")
		end
		for _, Segment in next, Path2D.Segments do
			Motion.Cancel(Segment.Fill, "Draw")
			if Segment.Glow then
				Motion.Cancel(Segment.Glow, "Glow")
			end
		end
	end

	function Path2D:SetProgress(Progress)
		Path2D:Stop()
		local Value = math.clamp(Utils.ToFiniteNumber(Progress) or 0, 0, 1)
		if #Path2D.Segments == 0 then
			return Value
		end

		local SegmentCount = math.max(#Path2D.Segments, 1)
		local ScaledProgress = Value * SegmentCount

		for Index = 1, #Path2D.Segments do
			local Segment = Path2D.Segments[Index]
			local SegmentProgress = math.clamp(ScaledProgress - (Index - 1), 0, 1)
			Segment.Fill.Size = UDim2.new(0, Segment.Length * SegmentProgress, 1, 0)
			if Segment.Glow then
				Segment.Glow.Size = UDim2.new(0, Segment.Length * SegmentProgress, 0, Path2D.Thickness + 8)
			end
		end

		local ActiveIndex = math.clamp(math.ceil(ScaledProgress), 1, #Path2D.Segments)
		local ActiveSegment = Path2D.Segments[ActiveIndex]
		if ActiveSegment and Path2D.UIElements.Marker then
			local SegmentProgress = math.clamp(ScaledProgress - (ActiveIndex - 1), 0, 1)
			Path2D.UIElements.Marker.Position = PixelToUDim2(
				GetTweenPoint(ActiveSegment.FromPixel, ActiveSegment.ToPixel, SegmentProgress)
			)
		end

		for Index = 1, #Path2D.Dots do
			local Dot = Path2D.Dots[Index]
			Dot.ImageTransparency = Index <= math.floor(ScaledProgress) + 1 and 0.12 or 0.54
		end

		return Value
	end

	function Path2D:SetPoints(Points)
		Path2D.Points = NormalizePoints(Points)
		Path2D:Render(true)
		return Path2D.Points
	end

	function Path2D:Destroy()
		Path2D.Destroyed = true
		Path2D:Stop()
		Path2D.Path2DFrame:Destroy()
	end

	Creator.AddSignal(Path2D.UIElements.Canvas:GetPropertyChangedSignal("AbsoluteSize"), function()
		Path2D:Render(not Path2D.HasRendered)
	end)

	task.defer(function()
		Path2D:Render(true)
	end)

	return Path2D.__type, Path2D
end

return Element
