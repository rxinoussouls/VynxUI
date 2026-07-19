local TweenService = game:GetService("TweenService")

local Motion = {
	Preset = "Subtle",
	Enabled = true,
	Reduced = false,
}

Motion.Durations = {
	Fast = 0.08,
	Hover = 0.1,
	Press = 0.12,
	Select = 0.14,
	Focus = 0.14,
	DropdownOpen = 0.16,
	DropdownClose = 0.14,
	Notification = 0.24,
	NotificationClose = 0.2,
	WindowOpen = 0.26,
	WindowClose = 0.2,
	Resize = 0.22,
	Highlight = 0.28,
	Background = 0.22,
	Expand = 0.2,
	Switch = 0.16,
	Reveal = 0.18,
}

Motion.PresetDurations = {
	Liquid = {
		Fast = 0.1,
		Hover = 0.14,
		Press = 0.1,
		Select = 0.2,
		Focus = 0.18,
		DropdownOpen = 0.2,
		DropdownClose = 0.16,
		WindowOpen = 0.32,
		WindowClose = 0.22,
		Resize = 0.28,
		Highlight = 0.34,
		Background = 0.28,
		Expand = 0.24,
		Switch = 0.22,
		Reveal = 0.22,
	},
	Snappy = {
		Fast = 0.06,
		Hover = 0.08,
		Press = 0.08,
		Select = 0.11,
		Focus = 0.1,
		DropdownOpen = 0.12,
		DropdownClose = 0.1,
		WindowOpen = 0.2,
		WindowClose = 0.16,
		Resize = 0.16,
		Highlight = 0.22,
		Background = 0.16,
		Expand = 0.16,
		Switch = 0.12,
		Reveal = 0.14,
	},
}

Motion.PresetEasing = {
	Liquid = {
		Style = Enum.EasingStyle.Quint,
		Direction = Enum.EasingDirection.Out,
	},
	Snappy = {
		Style = Enum.EasingStyle.Quart,
		Direction = Enum.EasingDirection.Out,
	},
}

Motion.PresetPressAmount = {
	Liquid = 0.965,
	Snappy = 0.975,
}

local ActiveTweens = setmetatable({}, { __mode = "k" })

local NoopTween = {}
function NoopTween:Play() end
function NoopTween:Cancel() end

local SpatialProperties = {
	Position = true,
	Size = true,
	CanvasPosition = true,
	Rotation = true,
	Scale = true,
}

local function IsPointerInput(Input)
	return Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
end

local function ApplyProperties(Object, Properties)
	for Property, Value in next, Properties or {} do
		Object[Property] = Value
	end
end

local function SplitReducedProperties(Properties)
	local Instant = {}
	local Tweened = {}
	local HasInstant = false
	local HasTweened = false

	for Property, Value in next, Properties or {} do
		if SpatialProperties[Property] then
			Instant[Property] = Value
			HasInstant = true
		else
			Tweened[Property] = Value
			HasTweened = true
		end
	end

	return HasInstant and Instant or nil, HasTweened and Tweened or nil
end

function Motion.GetDuration(Duration)
	if typeof(Duration) == "string" then
		local PresetDurations = Motion.PresetDurations[Motion.Preset]
		return (PresetDurations and PresetDurations[Duration]) or Motion.Durations[Duration] or Motion.Durations.Fast
	end

	return math.max(tonumber(Duration) or Motion.Durations.Fast, 0)
end

function Motion:IsEnabled()
	return Motion.Enabled and Motion.Preset ~= "None"
end

function Motion:Configure(Config)
	if Config == false then
		Motion.Enabled = false
		Motion.Preset = "None"
		return Motion:GetConfig()
	end

	if typeof(Config) == "string" then
		return Motion:SetPreset(Config)
	end

	if typeof(Config) == "table" then
		if Config.Preset ~= nil then
			Motion:SetPreset(Config.Preset)
		elseif Config.Enabled ~= false and Motion.Preset == "None" then
			Motion:SetPreset("Subtle")
		end
		Motion.Enabled = Config.Enabled ~= false and Motion.Preset ~= "None"
		Motion.Reduced = Config.Reduced == true
	else
		Motion.Enabled = true
		if Motion.Preset == "None" then
			Motion.Preset = "Subtle"
		end
		Motion.Reduced = false
	end

	return Motion:GetConfig()
end

function Motion:SetPreset(Preset)
	Preset = tostring(Preset or "Subtle")

	if Preset ~= "Subtle" and Preset ~= "Liquid" and Preset ~= "Snappy" and Preset ~= "None" then
		Preset = "Subtle"
	end

	Motion.Preset = Preset
	Motion.Enabled = Preset ~= "None"

	return Motion:GetConfig()
end

function Motion:SetReducedMotion(Value)
	Motion.Reduced = Value == true
	return Motion:GetConfig()
end

function Motion:GetConfig()
	return {
		Preset = Motion.Preset,
		Enabled = Motion.Enabled,
		Reduced = Motion.Reduced,
	}
end

function Motion.ShouldAnimate(Config)
	if Config and (Config.Animation == false or Config.Motion == false) then
		return false
	end

	return Motion:IsEnabled()
end

function Motion.Cancel(Object, Key)
	if not Object then
		return
	end

	local Tweens = ActiveTweens[Object]
	if not Tweens then
		return
	end

	Key = Key or "Default"
	local Tween = Tweens[Key]
	if Tween then
		Tween:Cancel()
		Tweens[Key] = nil
	end
end

function Motion.Tween(Object, Duration, Properties, EasingStyle, EasingDirection, Key)
	if not Object or typeof(Object) ~= "Instance" then
		return NoopTween
	end

	local Time = Motion.GetDuration(Duration)
	Key = Key or "Default"

	local InstantProperties = nil
	local TweenProperties = Properties
	if Motion.Reduced then
		InstantProperties, TweenProperties = SplitReducedProperties(Properties)
		Time = math.min(Time, Motion.Durations.Focus)
	end

	local TweenLike = {}
	local Tween

	function TweenLike:Play()
		Motion.Cancel(Object, Key)

		if InstantProperties then
			ApplyProperties(Object, InstantProperties)
		end

		if not Motion:IsEnabled() or Time <= 0 or not TweenProperties then
			ApplyProperties(Object, TweenProperties or Properties)
			return
		end

		local PresetEasing = Motion.PresetEasing[Motion.Preset]
		Tween = TweenService:Create(
			Object,
			TweenInfo.new(
				Time,
				EasingStyle or (PresetEasing and PresetEasing.Style) or Enum.EasingStyle.Quint,
				EasingDirection or (PresetEasing and PresetEasing.Direction) or Enum.EasingDirection.Out
			),
			TweenProperties
		)

		ActiveTweens[Object] = ActiveTweens[Object] or {}
		ActiveTweens[Object][Key] = Tween

		Tween.Completed:Connect(function()
			local Tweens = ActiveTweens[Object]
			if Tweens and Tweens[Key] == Tween then
				Tweens[Key] = nil
			end
		end)

		Tween:Play()
	end

	function TweenLike:Cancel()
		if Tween then
			Tween:Cancel()
		end
		Motion.Cancel(Object, Key)
	end

	return TweenLike
end

function Motion.Play(Object, Duration, Properties, EasingStyle, EasingDirection, Key)
	local Tween = Motion.Tween(Object, Duration, Properties, EasingStyle, EasingDirection, Key)
	Tween:Play()
	return Tween
end

function Motion.GetScale(Object)
	if not Object then
		return nil
	end

	if Object:IsA("UIScale") then
		return Object
	end

	local Scale = Object:FindFirstChildOfClass("UIScale")
	if not Scale then
		Scale = Instance.new("UIScale")
		Scale.Scale = 1
		Scale.Parent = Object
	end

	return Scale
end

function Motion.Press(Object, IsPressed, Amount)
	local Scale = Motion.GetScale(Object)
	if not Scale then
		return
	end

	if not Motion:IsEnabled() or Motion.Reduced then
		if not IsPressed then
			Scale.Scale = 1
		end
		return
	end

	Motion.Play(
		Scale,
		"Press",
		{ Scale = IsPressed and (Amount or Motion.PresetPressAmount[Motion.Preset] or 0.97) or 1 },
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.Out,
		"Press"
	)
end

function Motion.AttachPress(Object, Creator, Options)
	if not Object or not Creator then
		return nil
	end

	Options = Options or {}
	local Amount = Options.Amount or 0.97
	local Enabled = Options.Enabled

	local Scale = Motion.GetScale(Object)

	local function CanPress()
		if typeof(Enabled) == "function" then
			return Enabled()
		end
		return Enabled ~= false
	end

	Creator.AddSignal(Object.InputBegan, function(Input)
		if CanPress() and IsPointerInput(Input) then
			Motion.Press(Scale, true, Amount)
		end
	end)

	Creator.AddSignal(Object.InputEnded, function(Input)
		if IsPointerInput(Input) then
			Motion.Press(Scale, false, Amount)
		end
	end)

	if Object.MouseLeave then
		Creator.AddSignal(Object.MouseLeave, function()
			Motion.Press(Scale, false, Amount)
		end)
	end

	return Scale
end

return Motion
