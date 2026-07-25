local TweenService = game:GetService("TweenService")

local Creator = require("../../modules/Creator")
local Motion = require("../../modules/Motion")
local New = Creator.New

local GoldenEffect = {}

local function GetImageTarget(Object)
	if typeof(Object) ~= "Instance" then
		return nil
	end

	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return Object
	end

	return Object:FindFirstChildWhichIsA("ImageLabel", true) or Object:FindFirstChildWhichIsA("ImageButton", true)
end

local function AsColor(Value, Fallback)
	if typeof(Value) == "Color3" then
		return Value
	end

	if typeof(Value) == "string" then
		local Success, Color = pcall(function()
			return Color3.fromHex(Value)
		end)
		if Success then
			return Color
		end
	end

	return Fallback
end

local function NewGradient(Rotation, Offset, Colors, Transparency)
	return New("UIGradient", {
		Rotation = Rotation or 0,
		Offset = Offset or Vector2.new(0, 0),
		Color = ColorSequence.new(Colors),
		Transparency = NumberSequence.new(Transparency),
	})
end

function GoldenEffect.Apply(Target, Config)
	if typeof(Target) ~= "Instance" then
		return nil
	end

	Config = typeof(Config) == "table" and Config or {}

	local Corner = Config.Corner or 16
	local BaseZIndex = Config.ZIndex or Target.ZIndex or 1
	local Compact = Config.Compact == true
	local Animated = Config.Animated ~= false

	local Edge = AsColor(Config.EdgeColor, Color3.fromRGB(255, 215, 92))
	local Deep = AsColor(Config.DeepColor, Color3.fromRGB(84, 54, 10))
	local Mid = AsColor(Config.MidColor, Color3.fromRGB(206, 147, 39))
	local Hot = AsColor(Config.HotColor, Color3.fromRGB(255, 241, 166))

	pcall(function()
		Target.ClipsDescendants = true
	end)

	local Group = New("Frame", {
		Name = Config.Name or "GoldenEffect",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Active = false,
		ZIndex = BaseZIndex + 20,
		Parent = Target,
	})

	local Fill = Creator.NewRoundFrame(Corner, "Squircle", {
		Name = "GoldenFill",
		Size = UDim2.new(1, 0, 1, 0),
		ImageColor3 = Deep,
		ImageTransparency = Config.FillTransparency or 0.76,
		Active = false,
		ZIndex = BaseZIndex + 20,
		Parent = Group,
	}, {
		NewGradient(24, Vector2.new(-0.1, 0), {
			ColorSequenceKeypoint.new(0, Deep),
			ColorSequenceKeypoint.new(0.42, Mid),
			ColorSequenceKeypoint.new(0.72, Hot),
			ColorSequenceKeypoint.new(1, Deep),
		}, {
			NumberSequenceKeypoint.new(0, 0.18),
			NumberSequenceKeypoint.new(0.52, 0.04),
			NumberSequenceKeypoint.new(1, 0.22),
		}),
	})

	local Outline = Creator.NewRoundFrame(Corner, "SquircleOutline", {
		Name = "GoldenOutline",
		Size = UDim2.new(1, 0, 1, 0),
		ImageColor3 = Edge,
		ImageTransparency = Config.OutlineTransparency or 0.22,
		Active = false,
		ZIndex = BaseZIndex + 22,
		Parent = Group,
	}, {
		NewGradient(35, Vector2.new(0, 0), {
			ColorSequenceKeypoint.new(0, Edge),
			ColorSequenceKeypoint.new(0.5, Hot),
			ColorSequenceKeypoint.new(1, Mid),
		}, {
			NumberSequenceKeypoint.new(0, 0.04),
			NumberSequenceKeypoint.new(0.48, 0),
			NumberSequenceKeypoint.new(1, 0.12),
		}),
	})

	local SheenGradient = NewGradient(18, Vector2.new(-1.15, 0), {
		ColorSequenceKeypoint.new(0, Hot),
		ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Hot),
	}, {
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.42, 1),
		NumberSequenceKeypoint.new(0.5, 0.15),
		NumberSequenceKeypoint.new(0.58, 1),
		NumberSequenceKeypoint.new(1, 1),
	})

	local Sheen = Creator.NewRoundFrame(Corner, "Squircle", {
		Name = "GoldenSheen",
		Size = UDim2.new(1, 0, 1, 0),
		ImageColor3 = Hot,
		ImageTransparency = Config.SheenTransparency or 0.74,
		Active = false,
		ZIndex = BaseZIndex + 23,
		Parent = Group,
	}, {
		SheenGradient,
	})

	local SparkleLayer = New("Frame", {
		Name = "Sparkles",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Active = false,
		ClipsDescendants = true,
		ZIndex = BaseZIndex + 24,
		Parent = Group,
	})

	local Sparkles = {}
	local Points = Config.Points or {
		{ 0.16, 0.28, 0 },
		{ 0.76, 0.22, 0.42 },
		{ 0.34, 0.72, 0.82 },
		{ 0.88, 0.64, 1.12 },
	}

	for Index, Point in ipairs(Points) do
		local Size = Compact and 9 or 12
		local Sparkle = Creator.Image("sparkles", "GoldenSparkle" .. Index, 0, "Temp", "GoldenEffect", false, true)
		Sparkle.Name = "Sparkle" .. Index
		Sparkle.Size = UDim2.fromOffset(Size, Size)
		Sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
		Sparkle.Position = UDim2.fromScale(Point[1], Point[2])
		Sparkle.BackgroundTransparency = 1
		Sparkle.ZIndex = BaseZIndex + 24
		Sparkle.Parent = SparkleLayer

		local ImageTarget = GetImageTarget(Sparkle)
		if ImageTarget then
			ImageTarget.ImageColor3 = Hot
			ImageTarget.ImageTransparency = 0.62
			ImageTarget.ZIndex = BaseZIndex + 24
		end

		local Scale = New("UIScale", {
			Scale = 0.72,
			Parent = Sparkle,
		})

		table.insert(Sparkles, {
			Frame = Sparkle,
			Image = ImageTarget,
			Scale = Scale,
			Delay = Point[3] or 0,
		})
	end

	local Effect = {
		Root = Group,
		Fill = Fill,
		Outline = Outline,
		Sheen = Sheen,
		Sparkles = Sparkles,
		Running = true,
	}

	function Effect:Destroy()
		self.Running = false
		if self.Root then
			self.Root:Destroy()
		end
	end

	if Motion:IsEnabled() and not Motion.Reduced and Animated then
		task.spawn(function()
			while Effect.Running and Group.Parent do
				SheenGradient.Offset = Vector2.new(-1.15, 0)
				local Tween = TweenService:Create(
					SheenGradient,
					TweenInfo.new(Config.SheenDuration or 1.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
					{ Offset = Vector2.new(1.15, 0) }
				)
				Tween:Play()
				Tween.Completed:Wait()
				task.wait(Config.SheenPause or 0.42)
			end
		end)

		for _, Sparkle in ipairs(Sparkles) do
			task.spawn(function()
				task.wait(Sparkle.Delay)
				while Effect.Running and Group.Parent and Sparkle.Frame.Parent do
					Sparkle.Scale.Scale = 0.72
					Sparkle.Frame.Rotation = -18
					if Sparkle.Image then
						Sparkle.Image.ImageTransparency = 0.68
					end

					local Rise = TweenService:Create(
						Sparkle.Scale,
						TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
						{ Scale = 1.12 }
					)
					local FadeIn = Sparkle.Image and TweenService:Create(
						Sparkle.Image,
						TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
						{ ImageTransparency = 0.12 }
					)
					local Spin = TweenService:Create(
						Sparkle.Frame,
						TweenInfo.new(0.58, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{ Rotation = 22 }
					)

					Rise:Play()
					Spin:Play()
					if FadeIn then
						FadeIn:Play()
					end
					Rise.Completed:Wait()

					local Fall = TweenService:Create(
						Sparkle.Scale,
						TweenInfo.new(0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
						{ Scale = 0.78 }
					)
					local FadeOut = Sparkle.Image and TweenService:Create(
						Sparkle.Image,
						TweenInfo.new(0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
						{ ImageTransparency = 0.72 }
					)
					Fall:Play()
					if FadeOut then
						FadeOut:Play()
					end
					Fall.Completed:Wait()
					task.wait(Config.SparklePause or 1.2)
				end
			end)
		end
	end

	return Effect
end

return GoldenEffect
