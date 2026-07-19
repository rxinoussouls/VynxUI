-- VYNX UI Library — Bundled Build
-- Auto-generated. Do not edit directly.
-- Source: github.com/your-github/VynxUI

local _VYNX_MODULES = {}
local function require(path)
    path = path:gsub('^%.+/', ''):gsub('/', '/')
    if _VYNX_MODULES[path] then return _VYNX_MODULES[path] end
    error('VynxUI: module not found: ' .. path)
end

-- ── modules/Motion.lua ──
_VYNX_MODULES["modules/Motion.lua"] = (function()
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

end)()

-- ── modules/DynamicShape.lua ──
_VYNX_MODULES["modules/DynamicShape.lua"] = (function()
local Creator

local DynamicShapeModule = {
	New = nil,
	Init = nil,
	Shapes = {
		Circle = {
			Image = "rbxassetid://111665032676235",
			Rect = Rect.new(1024 / 2, 1024 / 2, 1024 / 2, 1024 / 2),
			Radius = 1024 / 2,
		},
		CircleOutline = {
			Image = "rbxassetid://108556680453287",
			Rect = Rect.new(1024 / 2, 1024 / 2, 1024 / 2, 1024 / 2),
			Radius = 1024 / 2,
		},
		CircleGlass = {
			Image = "rbxassetid://95600044758841",
			Rect = Rect.new(1024 / 2, 1024 / 2, 1024 / 2, 1024 / 2),
			Radius = 1024 / 2,
		},

		-- * Apple Squircles * --
		-- * For horizontally/vertically stretched elements * --
		SquircleH = {
			Image = "rbxassetid://125083578015333",
			Rect = Rect.new(1024 / 2, 650 / 2, 1024 / 2, 650 / 2),
			Radius = 650 / 2,
		},
		SquircleHOutline = {
			Image = "rbxassetid://107043713170567",
			Rect = Rect.new(1024 / 2, 650 / 2, 1024 / 2, 650 / 2),
			Radius = 650 / 2,
		},
		SquircleHGlass = {
			Image = "rbxassetid://84819521201001",
			Rect = Rect.new(1024 / 2, 650 / 2, 1024 / 2, 650 / 2),
			Radius = 650 / 2,
		},
		["SquircleH-TL-TR"] = {
			Image = "rbxassetid://90680657206619",
			Rect = Rect.new(807, 1024 / 2, 807, 1024 / 2),
			Radius = 650 / 2,
			AutoChange = false,
		},
		["SquircleH-BL-BR"] = {
			Image = "rbxassetid://99216342056719",
			Rect = Rect.new(0, 1024 / 2, 0, 1024 / 2),
			Radius = 650 / 2,
			AutoChange = false,
		},

		SquircleV = {
			Image = "rbxassetid://124965260437653",
			Rect = Rect.new(650 / 2, 1024 / 2, 650 / 2, 1024 / 2),
			Radius = 650 / 2,
		},
		SquircleVOutline = {
			Image = "rbxassetid://88808835404198",
			Rect = Rect.new(650 / 2, 1024 / 2, 650 / 2, 1024 / 2),
			Radius = 650 / 2,
		},
		SquircleVGlass = {
			Image = "rbxassetid://124982801466667",
			Rect = Rect.new(650 / 2, 1024 / 2, 650 / 2, 1024 / 2),
			Radius = 650 / 2,
		},

		Squircle = {
			Image = "rbxassetid://89641024074289",
			Rect = Rect.new(460, 460, 460, 460),
			Radius = 620 / 2,
		},
		SquircleOutline = {
			Image = "rbxassetid://74029063732681",
			Rect = Rect.new(1024 / 2, 1024 / 2, 1024 / 2, 1024 / 2),
			Radius = 620 / 2,
		},
		SquircleGlass = {
			Image = "rbxassetid://131126436897551",
			Rect = Rect.new(1024 / 2, 1024 / 2, 1024 / 2, 1024 / 2),
			Radius = 620 / 2,
		},

		["Squircle-TL-TR"] = {
			Image = "rbxassetid://75712142040725",
			Rect = Rect.new(1024 / 2, 1024 / 2, 1024 / 2, 1024 / 2),
			Radius = 620 / 2,
			AutoChange = false,
		},
		["Squircle-BL-BR"] = {
			Image = "rbxassetid://83676684425544",
			Rect = Rect.new(1024 / 2, 0, 1024 / 2, 0),
			Radius = 620 / 2,
			AutoChange = false,
		},
		["Square"] = {
			Image = "rbxassetid://82909646051652",
			Rect = Rect.new(1024 / 2, 1024 / 2, 1024 / 2, 1024 / 2),
			Radius = 1024 / 2,
			AutoChange = false,
		},
	},
}

function DynamicShapeModule:Init(CreatorObj)
	Creator = CreatorObj
	return self.New
end

function DynamicShapeModule:New(Radius, Type, Properties, Children, IsButton, IsSlice)
	local Wrapper = {
		Radius = Radius or 0,
		Type = Type or "Circle",
		GetRadius = nil,
		GetType = nil,
		SetRadius = nil,
		SetType = nil,
	}

	local ShapeFallbacks = {
		["Glass-0.7"] = "SquircleGlass",
		["Glass-1"] = "SquircleGlass",
		["Glass-1.4"] = "SquircleGlass",
		["Squircle-Outline"] = "SquircleOutline",
	}

	local function GetShape(Type)
		return DynamicShapeModule.Shapes[ShapeFallbacks[Type] or Type] or DynamicShapeModule.Shapes.Circle
	end

	local ImageLabel = Creator.New(IsButton and "ImageButton" or "ImageLabel", {
		Image = "",
		ScaleType = IsSlice ~= false and "Slice" or nil,
		SliceCenter = Wrapper.Type ~= "Squircle" and Rect.new(512, 512, 512, 512) or nil,
		SliceScale = 1,
		ThemeTag = Properties and Properties.ThemeTag or nil,
		BackgroundTransparency = 1,
	}, Children)

	for Property, Value in next, Properties do
		if not table.find({ "ThemeTag" }, Property) then
			ImageLabel[Property] = Value
		end
	end

	function Wrapper:SetRadius(NewRadius)
		Wrapper.Radius = NewRadius
		ImageLabel.SliceScale = math.max(NewRadius / GetShape(Wrapper.Type).Radius, 0.0001)
		return Wrapper
	end

	function Wrapper:SetType(NewType)
		Wrapper.Type = NewType
		local Shape = GetShape(NewType)
		ImageLabel.Image = Shape.Image
		ImageLabel.SliceCenter = Shape.Rect
		Wrapper:SetRadius(Wrapper.Radius)
		return Wrapper
	end

	function Wrapper:GetRadius()
		return Wrapper.Radius
	end

	function Wrapper:GetType()
		return Wrapper.Type
	end

	Wrapper:SetRadius(Radius)
	Wrapper:SetType(Type)

	Creator.AddSignal(ImageLabel:GetPropertyChangedSignal("AbsoluteSize"), function()
		local Shape = GetShape(Wrapper.Type)
		if Shape.AutoChange == false then
			return
		end

		if string.find(Wrapper.Type, "Squircle") then
			local Glass = string.find(Wrapper.Type, "Glass") and "Glass" or nil
			local Outline = string.find(Wrapper.Type, "Outline") and "Outline" or nil

			local X = math.round(ImageLabel.AbsoluteSize.X / Creator.UIScale)
			local Y = math.round(ImageLabel.AbsoluteSize.Y / Creator.UIScale)

			local effectiveRadius = Wrapper.Radius ~= 0 and Wrapper.Radius or math.min(X, Y) / 2
			local SquircleRatio = DynamicShapeModule.Shapes.Squircle.Radius / 1024
			local RadiusRatio = effectiveRadius / math.min(X, Y)

			local newType

			if X > Y then
				if RadiusRatio >= SquircleRatio then
					newType = "SquircleH" .. (Outline or Glass or "")
				else
					newType = "Squircle" .. (Outline or Glass or "")
				end
			elseif X < Y then
				if RadiusRatio >= SquircleRatio then
					newType = "SquircleV" .. (Outline or Glass or "")
				else
					newType = "Squircle" .. (Outline or Glass or "")
				end
			else
				if RadiusRatio >= SquircleRatio then
					newType = "Circle" .. (Outline or Glass or "")
				else
					newType = "Squircle" .. (Outline or Glass or "")
				end
			end

			if newType ~= Wrapper:GetType() then
				Wrapper:SetType(newType)
			end
		end
	end)

	return ImageLabel, Wrapper
end

return DynamicShapeModule

end)()

-- ── modules/Highlighter.lua ──
_VYNX_MODULES["modules/Highlighter.lua"] = (function()
-- Credits: https://devforum.roblox.com/t/realtime-richtext-lua-syntax-highlighting/2500399
-- Modified by me (Footagesus)

local highlighter = {}
local keywords = {
	lua = {
		"and",
		"break",
		"or",
		"else",
		"elseif",
		"if",
		"then",
		"until",
		"repeat",
		"while",
		"do",
		"for",
		"in",
		"end",
		"local",
		"return",
		"function",
		"export",
	},
	rbx = {
		"game",
		"workspace",
		"script",
		"math",
		"string",
		"table",
		"task",
		"wait",
		"select",
		"next",
		"Enum",
		"tick",
		"assert",
		"shared",
		"loadstring",
		"tonumber",
		"tostring",
		"type",
		"typeof",
		"unpack",
		"Instance",
		"CFrame",
		"Vector3",
		"Vector2",
		"Color3",
		"UDim",
		"UDim2",
		"Ray",
		"BrickColor",
		"OverlapParams",
		"RaycastParams",
		"Axes",
		"Random",
		"Region3",
		"Rect",
		"TweenInfo",
		"collectgarbage",
		"not",
		"utf8",
		"pcall",
		"xpcall",
		"_G",
		"setmetatable",
		"getmetatable",
		"os",
		"pairs",
		"ipairs",
	},
	operators = {
		"#",
		"+",
		"-",
		"*",
		"%",
		"/",
		"^",
		"=",
		"~",
		"=",
		"<",
		">",
	},
}

local colors = {
	numbers = Color3.fromHex("#FAB387"),
	boolean = Color3.fromHex("#FAB387"),
	operator = Color3.fromHex("#94E2D5"),
	lua = Color3.fromHex("#CBA6F7"),
	rbx = Color3.fromHex("#F38BA8"), -- def
	str = Color3.fromHex("#A6E3A1"),
	comment = Color3.fromHex("#9399B2"),
	null = Color3.fromHex("#F38BA8"), -- nil
	call = Color3.fromHex("#89B4FA"),
	self_call = Color3.fromHex("#89B4FA"),
	local_property = Color3.fromHex("#CBA6F7"),
}

local function createKeywordSet(keywords)
	local keywordSet = {}
	for _, keyword in ipairs(keywords) do
		keywordSet[keyword] = true
	end
	return keywordSet
end

local luaSet = createKeywordSet(keywords.lua)
local rbxSet = createKeywordSet(keywords.rbx)
local operatorsSet = createKeywordSet(keywords.operators)

local function getHighlight(tokens, index)
	local token = tokens[index]

	if colors[token .. "_color"] then
		return colors[token .. "_color"]
	end

	if tonumber(token) then
		return colors.numbers
	elseif token == "nil" then
		return colors.null
	elseif token:sub(1, 2) == "--" then
		return colors.comment
	elseif operatorsSet[token] then
		return colors.operator
	elseif luaSet[token] then
		return colors.lua
	elseif rbxSet[token] then
		return colors.rbx
	elseif token:sub(1, 1) == '"' or token:sub(1, 1) == "'" then
		return colors.str
	elseif token == "true" or token == "false" then
		return colors.boolean
	end

	if tokens[index + 1] == "(" then
		if tokens[index - 1] == ":" then
			return colors.self_call
		end

		return colors.call
	end

	if tokens[index - 1] == "." then
		if tokens[index - 2] == "Enum" then
			return colors.rbx
		end

		return colors.local_property
	end
end

function highlighter.run(source, newColors)
	if newColors ~= nil then
		for name, color in next, newColors do
			colors[name] = color
		end
	end

	local tokens = {}
	local currentToken = ""

	local inString = false
	local inComment = false
	local commentPersist = false

	for i = 1, #source do
		local character = source:sub(i, i)

		if inComment then
			if character == "\n" and not commentPersist then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""

				inComment = false
			elseif source:sub(i - 1, i) == "]]" and commentPersist then
				currentToken = currentToken .. "]"

				table.insert(tokens, currentToken)
				currentToken = ""

				inComment = false
				commentPersist = false
			else
				currentToken = currentToken .. character
			end
		elseif inString then
			if character == inString and source:sub(i - 1, i - 1) ~= "\\" or character == "\n" then
				currentToken = currentToken .. character
				inString = false
			else
				currentToken = currentToken .. character
			end
		else
			if source:sub(i, i + 1) == "--" then
				table.insert(tokens, currentToken)
				currentToken = "-"
				inComment = true
				commentPersist = source:sub(i + 2, i + 3) == "[["
			elseif character == '"' or character == "'" then
				table.insert(tokens, currentToken)
				currentToken = character
				inString = character
			elseif operatorsSet[character] then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			elseif character:match("[%w_]") then
				currentToken = currentToken .. character
			else
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			end
		end
	end

	table.insert(tokens, currentToken)

	local highlighted = {}

	for i, token in ipairs(tokens) do
		local highlight = getHighlight(tokens, i)

		if highlight then
			local syntax = string.format(
				'<font color = "#%s">%s</font>',
				highlight:ToHex(),
				token:gsub("<", "&lt;"):gsub(">", "&gt;")
			)

			table.insert(highlighted, syntax)
		else
			table.insert(highlighted, token)
		end
	end

	return table.concat(highlighted)
end

return highlighter

end)()

-- ── modules/Localization.lua ──
_VYNX_MODULES["modules/Localization.lua"] = (function()
local Localization = {}



-- function Localization:Init(Creator)
    
-- end

function Localization:New(LocalizationConfig, Creator)
    local LocalizationModule = {
        Enabled = LocalizationConfig.Enabled or false,
        Translations = LocalizationConfig.Translations or {},
        Prefix = LocalizationConfig.Prefix or "loc:",
        DefaultLanguage = LocalizationConfig.DefaultLanguage or "en"
    }
    
    Creator.Localization = LocalizationModule
    
    return LocalizationModule
end



return Localization
end)()

-- ── modules/Icons.lua ──
_VYNX_MODULES["modules/Icons.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))

local ICONS_URL = "https://your-github.github.io/VynxUI/vendor/icons/Main-v2.lua"

local function LoadBaseIcons()
	local RemoteFunction = ReplicatedStorage:FindFirstChild("GetIcons")
	if
		RemoteFunction
		and RemoteFunction:IsA("RemoteFunction")
		and (RunService:IsStudio() or RemoteFunction:GetAttribute("WindUIIcons") == true)
	then
		local Success, Result = pcall(function()
			return RemoteFunction:InvokeServer()
		end)
		if Success and typeof(Result) == "table" then
			return Result
		end
	end

	local Success, Source = pcall(function()
		if game.HttpGet then
			return game:HttpGet(ICONS_URL)
		end
		return HttpService:GetAsync(ICONS_URL)
	end)
	if Success and type(Source) == "string" and type(loadstring) == "function" then
		local Chunk = loadstring(Source)
		if Chunk then
			local Ran, Result = pcall(Chunk)
			if Ran and typeof(Result) == "table" then
				return Result
			end
		end
	end

	warn("[ WindUI.Icons ] Unable to load the base icon catalog; custom sources remain available")
	return {}
end

local IconModule = LoadBaseIcons()
IconModule.AdapterVersion = 3

local DEFAULT_SOURCE_ALIASES = {
	lucidev = "lucide",
	lucideicons = "lucide",
	sf = "sfsymbols",
	sfsymbol = "sfsymbols",
	sf_symbols = "sfsymbols",
	gravityui = "gravity",
	gravity_ui = "gravity",
}

IconModule.Icons = if typeof(IconModule.Icons) == "table" then IconModule.Icons else {}
IconModule.IconsType = IconModule.IconsType or "lucide"
IconModule.SourceAliases = if typeof(IconModule.SourceAliases) == "table" then IconModule.SourceAliases else {}
IconModule.Resolvers = if typeof(IconModule.Resolvers) == "table" then IconModule.Resolvers else {}
IconModule.FallbackAcrossSources = IconModule.FallbackAcrossSources ~= false

for Alias, Source in DEFAULT_SOURCE_ALIASES do
	if IconModule.SourceAliases[Alias] == nil then
		IconModule.SourceAliases[Alias] = Source
	end
end

local New

local function NormalizeSourceName(Value)
	if type(Value) ~= "string" then
		return nil
	end

	local Normalized = Value:lower():gsub("%s+", ""):gsub("[^%w_%-]", "")
	if Normalized == "" then
		return nil
	end
	return Normalized
end

local function ResolveSourceAlias(Value)
	local Source = NormalizeSourceName(Value)
	local Seen = {}

	for _ = 1, 8 do
		if not Source or Seen[Source] then
			break
		end
		Seen[Source] = true

		local Alias = IconModule.SourceAliases[Source]
		if not Alias then
			break
		end
		Source = NormalizeSourceName(Alias)
	end

	return Source
end

local function NormalizeImage(Value)
	if type(Value) == "number" then
		return "rbxassetid://" .. tostring(Value)
	end
	if type(Value) ~= "string" then
		return nil
	end

	if Value:match("^%d+$") then
		return "rbxassetid://" .. Value
	end
	return Value
end

local function IsDirectImage(Value)
	if type(Value) == "number" then
		return true
	end
	if type(Value) ~= "string" then
		return false
	end

	return Value:match("^%d+$") ~= nil
		or Value:match("^rbxassetid://") ~= nil
		or Value:match("^rbxthumb://") ~= nil
		or Value:match("^rbxgameasset://") ~= nil
		or Value:match("^https?://") ~= nil
end

local function NormalizeVector2(Value)
	if typeof(Value) == "Vector2" then
		return Value
	end
	if typeof(Value) == "table" then
		return Vector2.new(tonumber(Value.X or Value.x or Value[1]) or 0, tonumber(Value.Y or Value.y or Value[2]) or 0)
	end
	return Vector2.zero
end

local function NormalizeDescriptor(Value)
	if IsDirectImage(Value) then
		return {
			Image = NormalizeImage(Value),
			ImageRectSize = Vector2.zero,
			ImageRectPosition = Vector2.zero,
			Parts = nil,
		}
	end

	if typeof(Value) ~= "table" then
		return nil
	end

	local Image = Value.Image or Value.Asset or Value.AssetId or Value.Id or Value.URL or Value.Url
	if not IsDirectImage(Image) then
		return nil
	end

	return {
		Image = NormalizeImage(Image),
		ImageRectSize = NormalizeVector2(Value.ImageRectSize or Value.RectSize or Value.Size),
		ImageRectPosition = NormalizeVector2(
			Value.ImageRectPosition or Value.ImageRectOffset or Value.RectPosition or Value.Offset
		),
		Parts = Value.Parts,
	}
end

local function ParseIconReference(Value)
	if typeof(Value) == "table" then
		return Value.Source or Value.Pack or Value.Library or Value.Type, Value.Name or Value.Icon or Value.Key, Value
	end

	if type(Value) ~= "string" or IsDirectImage(Value) then
		return nil, Value, Value
	end

	local Source, Name = Value:match("^@([%w_%-]+)/(.+)$")
	if not Source then
		Source, Name = Value:match("^([%w_%-]+):(.+)$")
	end
	if not Source then
		Source, Name = Value:match("^([%w_%-]+)/(.+)$")
	end

	return Source, Name or Value, Value
end

local function FindSource(SourceName)
	local Source = ResolveSourceAlias(SourceName)
	if not Source then
		return nil, nil
	end

	if IconModule.Icons[Source] then
		return IconModule.Icons[Source], Source
	end

	for Name, Pack in IconModule.Icons do
		if NormalizeSourceName(Name) == Source then
			return Pack, Name
		end
	end

	return nil, Source
end

local function GetSourceNames()
	local Sources = {}
	for Name in IconModule.Icons do
		table.insert(Sources, tostring(Name))
	end
	table.sort(Sources, function(A, B)
		return A:lower() < B:lower()
	end)
	return Sources
end

local ResolveIcon

local function ResolvePackIcon(Pack, Name, Depth)
	if typeof(Pack) ~= "table" or Name == nil then
		return nil
	end

	local Icons = if typeof(Pack.Icons) == "table" then Pack.Icons else Pack
	local Value = Icons[Name]
	if Value == nil then
		local LowerName = tostring(Name):lower()
		for IconName, IconValue in Icons do
			if tostring(IconName):lower() == LowerName then
				Value = IconValue
				break
			end
		end
	end

	if typeof(Value) == "table" and Value.Alias then
		return ResolveIcon(Value.Alias, nil, (Depth or 0) + 1)
	end

	local RawImage = typeof(Value) == "table"
			and (Value.Image or Value.Asset or Value.AssetId or Value.Id or Value.URL or Value.Url)
		or Value
	local Descriptor = NormalizeDescriptor(Value)
	if not Descriptor then
		return nil
	end

	if typeof(Pack.Spritesheets) == "table" then
		Descriptor.Image = Pack.Spritesheets[RawImage]
			or Pack.Spritesheets[tostring(RawImage)]
			or Pack.Spritesheets[Descriptor.Image]
			or Pack.Spritesheets[tostring(Descriptor.Image)]
			or Descriptor.Image
	end

	return Descriptor
end

local function ResolveProviderIcon(Source, Name)
	local Provider = IconModule.Resolvers[ResolveSourceAlias(Source)]
	if typeof(Provider) ~= "function" then
		return nil
	end

	local Success, Value = pcall(Provider, Name, Source)
	if not Success then
		warn(string.format("[ WindUI.Icons ] Source '%s' failed: %s", tostring(Source), tostring(Value)))
		return nil
	end

	return NormalizeDescriptor(Value)
end

ResolveIcon = function(Value, Type, Depth)
	if (Depth or 0) > 8 then
		return nil
	end

	local Direct = NormalizeDescriptor(Value)
	if Direct then
		return Direct
	end

	local Source, Name, Original = ParseIconReference(Value)
	if typeof(Original) == "table" and Original.Alias then
		return ResolveIcon(Original.Alias, Type, (Depth or 0) + 1)
	end

	local PreferredSource = ResolveSourceAlias(Source or Type or IconModule.IconsType)
	if PreferredSource then
		local Pack = FindSource(PreferredSource)
		local Descriptor = ResolvePackIcon(Pack, Name, Depth) or ResolveProviderIcon(PreferredSource, Name)
		if Descriptor then
			return Descriptor
		end
	end

	if Source or not IconModule.FallbackAcrossSources then
		return nil
	end

	for _, Candidate in GetSourceNames() do
		if ResolveSourceAlias(Candidate) ~= PreferredSource then
			local Descriptor = ResolvePackIcon(IconModule.Icons[Candidate], Name, Depth)
			if Descriptor then
				return Descriptor
			end
		end
	end

	for Candidate, Provider in IconModule.Resolvers do
		if Candidate ~= PreferredSource and typeof(Provider) == "function" then
			local Descriptor = ResolveProviderIcon(Candidate, Name)
			if Descriptor then
				return Descriptor
			end
		end
	end

	return nil
end

local function FormatDescriptor(Descriptor, DefaultFormat)
	if not Descriptor then
		return nil
	end

	if DefaultFormat == false and Descriptor.ImageRectSize == Vector2.zero and not Descriptor.Parts then
		return Descriptor.Image
	end

	return { Descriptor.Image, Descriptor }
end

function IconModule.AddSourceAlias(Alias, Source)
	local AliasName = NormalizeSourceName(Alias)
	local SourceName = NormalizeSourceName(Source)
	assert(AliasName and SourceName, "AddSourceAlias: alias and source must be non-empty strings")
	IconModule.SourceAliases[AliasName] = SourceName
	return IconModule
end

function IconModule.RegisterIconSource(Source, Provider, Options)
	local SourceName = NormalizeSourceName(Source)
	assert(SourceName, "RegisterIconSource: source must be a non-empty string")

	if typeof(Provider) == "function" then
		IconModule.Resolvers[SourceName] = Provider
	elseif typeof(Provider) == "table" then
		IconModule.AddIcons(SourceName, Provider)
	else
		error("RegisterIconSource: provider must be a function or icon table")
	end

	if typeof(Options) == "table" then
		for _, Alias in Options.Aliases or {} do
			IconModule.AddSourceAlias(Alias, SourceName)
		end
	end

	return IconModule
end

function IconModule.AddIcons(PackName, IconsData)
	local Source = NormalizeSourceName(PackName)
	assert(Source and typeof(IconsData) == "table", "AddIcons: packName must be string and iconsData must be table")

	local Pack = IconModule.Icons[Source]
	if typeof(Pack) ~= "table" or typeof(Pack.Icons) ~= "table" then
		Pack = {
			Icons = {},
			Spritesheets = {},
		}
		IconModule.Icons[Source] = Pack
	end

	for IconName, IconValue in IconsData do
		local Descriptor = NormalizeDescriptor(IconValue)
		if Descriptor then
			Pack.Icons[IconName] = Descriptor
			Pack.Spritesheets[Descriptor.Image] = Descriptor.Image
		elseif typeof(IconValue) == "table" and IconValue.Alias then
			Pack.Icons[IconName] = { Alias = IconValue.Alias }
		else
			warn(string.format("[ WindUI.Icons ] Ignored invalid icon '%s:%s'", Source, tostring(IconName)))
		end
	end

	return IconModule
end

IconModule.RegisterIconPack = IconModule.AddIcons
IconModule.AddIconSource = IconModule.RegisterIconSource

function IconModule.AddIcon(PackName, IconName, IconValue)
	return IconModule.AddIcons(PackName, { [IconName] = IconValue })
end

function IconModule.SetIconsType(IconType)
	local Source = ResolveSourceAlias(IconType)
	assert(Source, "SetIconsType: icon type must be a non-empty string")
	IconModule.IconsType = Source
	return IconModule
end

function IconModule.GetIconSources()
	local Sources = GetSourceNames()
	for Source in IconModule.Resolvers do
		if not table.find(Sources, Source) then
			table.insert(Sources, Source)
		end
	end
	table.sort(Sources)
	return Sources
end

function IconModule.HasIcon(Icon, Type)
	return ResolveIcon(Icon, Type, 0) ~= nil
end

function IconModule.Init(NewFunction, IconThemeTag)
	IconModule.New = NewFunction
	IconModule.IconThemeTag = IconThemeTag
	New = NewFunction
	return IconModule
end

function IconModule.Icon(Icon, Type, DefaultFormat)
	return FormatDescriptor(ResolveIcon(Icon, Type, 0), DefaultFormat ~= false)
end

function IconModule.GetIcon(Icon, Type)
	return IconModule.Icon(Icon, Type, false)
end

function IconModule.Icon2(Icon, Type)
	return IconModule.Icon(Icon, Type, true)
end

local function ResolveStyle(Values, Index, Fallback)
	local Value = Values[Index]
	if Value == nil then
		Value = Values[1]
	end
	if Value == nil then
		Value = Fallback
	end

	return {
		ThemeTag = typeof(Value) == "string" and Value or nil,
		Color = typeof(Value) == "Color3" and Value or nil,
		Value = typeof(Value) == "number" and Value or nil,
	}
end

local function CreateImageLabel(Properties)
	if New then
		return New("ImageLabel", Properties)
	end

	local ImageLabel = Instance.new("ImageLabel")
	for Name, Value in Properties do
		if Name ~= "ThemeTag" and Value ~= nil then
			ImageLabel[Name] = Value
		end
	end
	return ImageLabel
end

function IconModule.Image(IconConfig)
	IconConfig = if typeof(IconConfig) == "table" then IconConfig else {}
	local Icon = {
		Icon = IconConfig.Icon,
		Type = IconConfig.Type,
		Colors = IconConfig.Colors or { IconModule.IconThemeTag or Color3.new(1, 1, 1) },
		Transparency = IconConfig.Transparency or { 0 },
		Size = IconConfig.Size or UDim2.fromOffset(24, 24),
		IconFrame = nil,
	}

	local Resolved = IconModule.Icon2(Icon.Icon, Icon.Type)
	local Image = Resolved and Resolved[1] or ""
	local Descriptor = Resolved and Resolved[2]
		or {
			ImageRectSize = Vector2.zero,
			ImageRectPosition = Vector2.zero,
		}
	local PrimaryColor = ResolveStyle(Icon.Colors, 1, IconModule.IconThemeTag or Color3.new(1, 1, 1))
	local PrimaryTransparency = ResolveStyle(Icon.Transparency, 1, 0)

	local IconFrame = CreateImageLabel({
		Name = "Icon",
		Size = Icon.Size,
		BackgroundTransparency = 1,
		ImageColor3 = PrimaryColor.Color,
		ImageTransparency = PrimaryTransparency.Value,
		ThemeTag = PrimaryColor.ThemeTag and {
			ImageColor3 = PrimaryColor.ThemeTag,
			ImageTransparency = PrimaryTransparency.ThemeTag,
		} or nil,
		Image = Image,
		ImageRectSize = Descriptor.ImageRectSize,
		ImageRectOffset = Descriptor.ImageRectPosition,
	})

	local Source = ParseIconReference(Icon.Icon)
	for Index, Part in Descriptor.Parts or {} do
		local PartInfo = IconModule.Icon2(Part, Source or Icon.Type)
		if PartInfo then
			local PartColor = ResolveStyle(Icon.Colors, Index + 1, PrimaryColor.Color or PrimaryColor.ThemeTag)
			local PartTransparency = ResolveStyle(Icon.Transparency, Index + 1, PrimaryTransparency.Value or 0)
			CreateImageLabel({
				Name = "Part" .. tostring(Index),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ImageColor3 = PartColor.Color,
				ImageTransparency = PartTransparency.Value,
				ThemeTag = PartColor.ThemeTag and {
					ImageColor3 = PartColor.ThemeTag,
					ImageTransparency = PartTransparency.ThemeTag,
				} or nil,
				Image = PartInfo[1],
				ImageRectSize = PartInfo[2].ImageRectSize,
				ImageRectOffset = PartInfo[2].ImageRectPosition,
				Parent = IconFrame,
			})
		end
	end

	Icon.IconFrame = IconFrame
	return Icon
end

return IconModule

end)()

-- ── modules/Creator.lua ──
_VYNX_MODULES["modules/Creator.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local LocalizationService = cloneref(game:GetService("LocalizationService"))
local HttpService = cloneref(game:GetService("HttpService"))

local DynamicShapeModule = require("./DynamicShape")
local Icons = require("./Icons")

local RenderStepped = RunService.Heartbeat

Icons.SetIconsType("lucide")

local WindUI

local Creator
Creator = {
	Font = "rbxassetid://12187365364",
	Localization = nil,
	CanDraggable = true,
	Theme = nil,
	Themes = nil,
	Icons = Icons,
	IconAdapterVersion = Icons.AdapterVersion or 1,
	Signals = {},
	Objects = {},
	LocalizationObjects = {},
	UIScale = 1,
	FontObjects = {},
	Language = string.match(LocalizationService.SystemLocaleId, "^[a-z]+"),
	Request = http_request or (syn and syn.request) or request,
	DefaultProperties = {
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = "Sibling",
		},
		CanvasGroup = {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
		},
		Frame = {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Text = "",
			RichText = true,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 14,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		ImageLabel = {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			AutoButtonColor = false,
		},
		UIListLayout = {
			SortOrder = "LayoutOrder",
		},
		ScrollingFrame = {
			ScrollBarImageTransparency = 1,
			BorderSizePixel = 0,
		},
		VideoFrame = {
			BorderSizePixel = 0,
		},
	},
	Colors = {
		Red = "#e53935",
		Orange = "#f57c00",
		Green = "#43a047",
		Blue = "#039be5",
		White = "#ffffff",
		Grey = "#484848",
	},
	ThemeFallbacks = nil,
	--[[Shapes = {
		["Square"] = "rbxassetid://82909646051652",
		["Square-Outline"] = "rbxassetid://72946211851948",

		["Squircle"] = "rbxassetid://80999662900595",
		["SquircleOutline"] = "rbxassetid://117788349049947",
		["Squircle-Outline"] = "rbxassetid://117817408534198",

		["SquircleOutline2"] = "rbxassetid://117817408534198",

		["Shadow-sm"] = "rbxassetid://84825982946844",

		["Squircle-TL-TR"] = "rbxassetid://73569156276236",
		["Squircle-BL-BR"] = "rbxassetid://93853842912264",
		["Squircle-TL-TR-Outline"] = "rbxassetid://136702870075563",
		["Squircle-BL-BR-Outline"] = "rbxassetid://75035847706564",

		["Glass-0.7"] = "rbxassetid://79047752995006",
		["Glass-1"] = "rbxassetid://97324581055162",
		["Glass-1.4"] = "rbxassetid://95071123641270",
	},]]
	ThemeChangeCallbacks = {},
}

function Creator.Init(WindUITable)
	WindUI = WindUITable

	Creator.ThemeFallbacks = require("../themes/Fallbacks")(Creator)

	Creator.UIScale = WindUITable.UIScale

	DynamicShapeModule:Init(Creator)
end

function Creator.AddSignal(Signal, Function)
	local conn = Signal:Connect(Function)
	table.insert(Creator.Signals, conn)
	return conn
end

function Creator.DisconnectAll()
	for idx, signal in next, Creator.Signals do
		local Connection = table.remove(Creator.Signals, idx)
		Connection:Disconnect()
	end
end

function Creator.SafeCallback(Function, ...)
	if not Function then
		return
	end

	local Success, Event = pcall(Function, ...)
	if not Success then
		if WindUI and WindUI.Window and WindUI.Window.Debug then
			local _, i = Event:find(":%d+: ")

			warn("[ WindUI: DEBUG Mode ] " .. Event)

			return WindUI:Notify({
				Title = "DEBUG Mode: Error",
				Content = not i and Event or Event:sub(i + 1),
				Style = "Error",
				Duration = 8,
			})
		end
	end
end

function Creator.Gradient(stops, props)
	if WindUI and WindUI.Gradient then
		return WindUI:Gradient(stops, props)
	end

	local colorSequence = {}
	local transparencySequence = {}

	for posStr, stop in next, stops do
		local position = tonumber(posStr)
		if position then
			position = math.clamp(position / 100, 0, 1)
			table.insert(colorSequence, ColorSequenceKeypoint.new(position, stop.Color))
			table.insert(transparencySequence, NumberSequenceKeypoint.new(position, stop.Transparency or 0))
		end
	end

	table.sort(colorSequence, function(a, b)
		return a.Time < b.Time
	end)
	table.sort(transparencySequence, function(a, b)
		return a.Time < b.Time
	end)

	if #colorSequence < 2 then
		error("ColorSequence requires at least 2 keypoints")
	end

	local gradientData = {
		Color = ColorSequence.new(colorSequence),
		Transparency = NumberSequence.new(transparencySequence),
	}

	if props then
		for k, v in pairs(props) do
			gradientData[k] = v
		end
	end

	return gradientData
end

function Creator.SetTheme(Theme)
	if typeof(Theme) ~= "table" then
		Theme = Creator.Theme or (Creator.Themes and Creator.Themes["Dark"])
	end
	if typeof(Theme) ~= "table" then
		return nil
	end

	local PreviousTheme = Creator.Theme
	Creator.Theme = Theme
	Creator.UpdateTheme(nil, false)

	for _, Callback in next, Creator.ThemeChangeCallbacks do
		Creator.SafeCallback(Callback, Theme, PreviousTheme)
	end

	return Theme
end

function Creator.AddFontObject(Object)
	table.insert(Creator.FontObjects, Object)
	Creator.UpdateFont(Creator.Font)
end

function Creator.UpdateFont(FontId)
	Creator.Font = FontId
	for _, Obj in next, Creator.FontObjects do
		Obj.FontFace = Font.new(FontId, Obj.FontFace.Weight, Obj.FontFace.Style)
	end
end

function Creator.GetThemeProperty(Property, Theme)
	local function getValue(prop, themeTable)
		if typeof(themeTable) ~= "table" then
			return nil
		end

		local value = themeTable[prop]

		if value == nil then
			return nil
		end

		if typeof(value) == "string" and string.sub(value, 1, 1) == "#" then
			return Color3.fromHex(value)
		end

		if typeof(value) == "Color3" then
			return value
		end

		if typeof(value) == "number" then
			return value
		end

		if typeof(value) == "table" and value.Color and value.Transparency then
			return value
		end

		if typeof(value) == "function" then
			return value(themeTable)
		end

		return value
	end

	Theme = if typeof(Theme) == "table" then Theme else Creator.Theme

	local value = getValue(Property, Theme)
	if value ~= nil then
		if typeof(value) == "string" and string.sub(value, 1, 1) ~= "#" then
			local referencedValue = Creator.GetThemeProperty(value, Theme)
			if referencedValue ~= nil then
				return referencedValue
			end
		else
			return value
		end
	end

	local fallbackProperty = Creator.ThemeFallbacks and Creator.ThemeFallbacks[Property]
	if fallbackProperty ~= nil then
		if typeof(fallbackProperty) == "string" and string.sub(fallbackProperty, 1, 1) ~= "#" then
			return Creator.GetThemeProperty(fallbackProperty, Theme)
		else
			return getValue(Property, { [Property] = fallbackProperty })
		end
	end

	local darkTheme = Creator.Themes and Creator.Themes["Dark"]
	value = getValue(Property, darkTheme)
	if value ~= nil then
		if typeof(value) == "string" and string.sub(value, 1, 1) ~= "#" then
			local referencedValue = Creator.GetThemeProperty(value, darkTheme)
			if referencedValue ~= nil then
				return referencedValue
			end
		else
			return value
		end
	end

	if fallbackProperty ~= nil then
		if typeof(fallbackProperty) == "string" and string.sub(fallbackProperty, 1, 1) ~= "#" then
			return Creator.GetThemeProperty(fallbackProperty, darkTheme)
		else
			return getValue(Property, { [Property] = fallbackProperty })
		end
	end

	return nil
end

function Creator.AddThemeObject(Object, Properties, skipUpdate)
	if Creator.Objects[Object] then
		for prop, value in pairs(Properties) do
			Creator.Objects[Object].Properties[prop] = value
		end
	else
		Creator.Objects[Object] = { Object = Object, Properties = Properties }
	end

	if not skipUpdate then
		Creator.UpdateTheme(Object, false)
	end
	return Object
end

function Creator.AddLangObject(idx)
	local currentObj = Creator.LocalizationObjects[idx]
	if not currentObj then
		return
	end

	local Object = currentObj.Object

	Creator.SetLangForObject(idx)

	return Object
end

function Creator.UpdateTheme(TargetObject, isTween, isTweenTarget, Duration, EasingStyle, EasingDirection)
	local function ApplyTheme(objData)
		for Property, ColorKey in pairs(objData.Properties or {}) do
			local value = Creator.GetThemeProperty(ColorKey, Creator.Theme)
			if value ~= nil then
				if typeof(value) == "Color3" then
					local gradient = objData.Object:FindFirstChild("LibraryGradient")
					if gradient then
						gradient:Destroy()
					end

					if isTweenTarget then
						Creator.Tween(
							objData.Object,
							Duration or 0.2,
							{ [Property] = value },
							EasingStyle or Enum.EasingStyle.Quint,
							EasingDirection or Enum.EasingDirection.Out
						):Play()
					elseif isTween then
						Creator.Tween(objData.Object, 0.08, { [Property] = value }):Play()
					else
						objData.Object[Property] = value
					end
				elseif typeof(value) == "table" and value.Color and value.Transparency then
					objData.Object[Property] = Color3.new(1, 1, 1)

					local gradient = objData.Object:FindFirstChild("LibraryGradient")
					if not gradient then
						gradient = Instance.new("UIGradient")
						gradient.Name = "LibraryGradient"
						gradient.Parent = objData.Object
					end

					gradient.Color = value.Color
					gradient.Transparency = value.Transparency

					for prop, propValue in pairs(value) do
						if prop ~= "Color" and prop ~= "Transparency" and gradient[prop] ~= nil then
							gradient[prop] = propValue
						end
					end
				elseif typeof(value) == "number" then
					if isTweenTarget then
						Creator.Tween(
							objData.Object,
							Duration or 0.2,
							{ [Property] = value },
							EasingStyle or Enum.EasingStyle.Quint,
							EasingDirection or Enum.EasingDirection.Out
						):Play()
					elseif isTween then
						Creator.Tween(objData.Object, 0.08, { [Property] = value }):Play()
					else
						objData.Object[Property] = value
					end
				end
			else
				local gradient = objData.Object:FindFirstChild("LibraryGradient")
				if gradient then
					gradient:Destroy()
				end
			end
		end
	end

	if TargetObject then
		local objData = Creator.Objects[TargetObject]
		if objData then
			ApplyTheme(objData)
		end
	else
		for _, objData in pairs(Creator.Objects) do
			ApplyTheme(objData)
		end
	end
end

function Creator.SetThemeTag(Object, ThemeTag, Duration, EasingStyle, EasingDirection)
	Creator.AddThemeObject(Object, ThemeTag)
	Creator.UpdateTheme(Object, false, true, Duration, EasingStyle, EasingDirection)
end

function Creator.SetLangForObject(index)
	if Creator.Localization and Creator.Localization.Enabled then
		local data = Creator.LocalizationObjects[index]
		if not data then
			return
		end

		local obj = data.Object
		local translationId = data.TranslationId

		local translations = Creator.Localization.Translations[Creator.Language]
		if translations and translations[translationId] then
			obj.Text = translations[translationId]
		else
			local enTranslations = Creator.Localization
					and Creator.Localization.Translations
					and Creator.Localization.Translations.en
				or nil
			if enTranslations and enTranslations[translationId] then
				obj.Text = enTranslations[translationId]
			else
				obj.Text = "[" .. translationId .. "]"
			end
		end
	end
end

function Creator:ChangeTranslationKey(object, newKey)
	if Creator.Localization and Creator.Localization.Enabled then
		local ParsedKey = string.match(newKey, "^" .. Creator.Localization.Prefix .. "(.+)")
		if ParsedKey then
			for i, data in ipairs(Creator.LocalizationObjects) do
				if data.Object == object then
					data.TranslationId = ParsedKey
					Creator.SetLangForObject(i)
					return
				end
			end

			table.insert(Creator.LocalizationObjects, {
				TranslationId = ParsedKey,
				Object = object,
			})
			Creator.SetLangForObject(#Creator.LocalizationObjects)
		end
	end
end

function Creator.UpdateLang(newLang)
	if newLang then
		Creator.Language = newLang
	end

	for i = 1, #Creator.LocalizationObjects do
		local data = Creator.LocalizationObjects[i]
		if data.Object and data.Object.Parent ~= nil then
			Creator.SetLangForObject(i)
		else
			Creator.LocalizationObjects[i] = nil
		end
	end
end

function Creator.SetLanguage(lang)
	Creator.Language = lang
	Creator.UpdateLang()
end

function Creator.Icon(Icon, formatdefault)
	return Icons.Icon(Icon, nil, formatdefault ~= false)
end

function Creator.AddIcons(packName, iconsData)
	return Icons.AddIcons(packName, iconsData)
end

function Creator.AddIcon(packName, iconName, iconValue)
	return Icons.AddIcon(packName, iconName, iconValue)
end

function Creator.RegisterIconSource(source, provider, options)
	return Icons.RegisterIconSource(source, provider, options)
end

Creator.RegisterIconPack = Creator.AddIcons
Creator.AddIconSource = Creator.RegisterIconSource

function Creator.AddIconSourceAlias(alias, source)
	return Icons.AddSourceAlias(alias, source)
end

function Creator.SetIconSource(source)
	return Icons.SetIconsType(source)
end

function Creator.GetIconSources()
	return Icons.GetIconSources()
end

function Creator.HasIcon(icon, source)
	return Icons.HasIcon(icon, source)
end

function Creator.New(Name, Properties, Children)
	local Object = Instance.new(Name)

	for Name, Value in next, Creator.DefaultProperties[Name] or {} do
		Object[Name] = Value
	end

	for Name, Value in next, Properties or {} do
		if Name ~= "ThemeTag" then
			Object[Name] = Value
		end
		if Creator.Localization and Creator.Localization.Enabled and Name == "Text" then
			local TranslationId = string.match(Value, "^" .. Creator.Localization.Prefix .. "(.+)")
			if TranslationId then
				local currentId = #Creator.LocalizationObjects + 1
				Creator.LocalizationObjects[currentId] = { TranslationId = TranslationId, Object = Object }

				Creator.SetLangForObject(currentId)
			end
		end
	end

	for _, Child in next, Children or {} do
		Child.Parent = Object
	end

	if Properties and Properties.ThemeTag then
		Creator.AddThemeObject(Object, Properties.ThemeTag)
	end
	if Properties and Properties.FontFace then
		Creator.AddFontObject(Object)
	end
	return Object
end

function Creator.Tween(Object, Time, Properties, ...)
	return TweenService:Create(Object, TweenInfo.new(Time, ...), Properties)
end

function Creator.ClampTransparency(Value, Default)
	local Number = tonumber(Value)
	if Number == nil then
		return Default
	end

	return math.clamp(Number, 0, 1)
end

function Creator.ToUDimRadius(Value, Default)
	if typeof(Value) == "UDim" then
		return Value
	end

	if typeof(Default) == "UDim" then
		return Default
	end

	return UDim.new(0, tonumber(Value) or tonumber(Default) or 0)
end

function Creator.ApplyCornerRadii(Corner, Radius, Corners)
	if typeof(Corner) ~= "Instance" or not Corner:IsA("UICorner") then
		return Corner
	end

	local Rounded = Creator.ToUDimRadius(Radius, Corner.CornerRadius)
	local ActiveCorners = Corners
		or {
			TopLeft = true,
			TopRight = true,
			BottomLeft = true,
			BottomRight = true,
		}
	local function ResolveCorner(Value)
		if Value == false then
			return UDim.new(0, 0)
		end
		if typeof(Value) == "UDim" then
			return Value
		end
		if type(Value) == "number" then
			return UDim.new(0, math.max(Value, 0))
		end
		return Rounded
	end

	Corner.CornerRadius = Rounded

	pcall(function()
		Corner.TopLeftRadius = ResolveCorner(ActiveCorners.TopLeft)
		Corner.TopRightRadius = ResolveCorner(ActiveCorners.TopRight)
		Corner.BottomRightRadius = ResolveCorner(ActiveCorners.BottomRight)
		Corner.BottomLeftRadius = ResolveCorner(ActiveCorners.BottomLeft)
	end)

	return Corner
end

function Creator.CreateUIShadow(Parent, Properties)
	local Shadow
	local Success = pcall(function()
		Shadow = Instance.new("UIShadow")
		for Name, Value in Properties or {} do
			if Name ~= "Parent" and Name ~= "ThemeTag" then
				Shadow[Name] = Value
			end
		end
		Shadow.Parent = Parent or (Properties and Properties.Parent)
	end)

	if not Success then
		if Shadow then
			Shadow:Destroy()
		end
		return nil
	end

	if Properties and Properties.ThemeTag then
		Creator.AddThemeObject(Shadow, Properties.ThemeTag)
	end

	return Shadow
end

function Creator.DefaultCornerMap()
	return {
		TopLeft = true,
		TopRight = true,
		BottomLeft = true,
		BottomRight = true,
	}
end

function Creator.GetLinkedCornerDirection(ParentTable, ParentType, Options)
	if typeof(Options) == "table" then
		local Orientation = tostring(Options.Orientation or Options.Direction or ""):lower()
		if Orientation == "horizontal" or Orientation == "row" or Orientation == "x" then
			return true
		elseif Orientation == "vertical" or Orientation == "column" or Orientation == "y" then
			return false
		end
	end

	local TypeName = ParentType or (ParentTable and ParentTable.__type)

	if TypeName == "Group" then
		return true
	end

	if TypeName == "HStack" then
		if ParentTable and ParentTable.IsStacked == true then
			return false
		end

		local Frame = ParentTable and ParentTable.ElementFrame
		local Layout = Frame and Frame:FindFirstChildWhichIsA("UIListLayout")
		if Layout then
			return Layout.FillDirection == Enum.FillDirection.Horizontal
		end

		return true
	end

	return false
end

function Creator.GetLinkedCornerShape(elements, targetIndex, ParentTable, ParentType, Options)
	return Creator:GetElementPosition(
		elements,
		targetIndex,
		Creator.GetLinkedCornerDirection(ParentTable, ParentType, Options),
		Options
	)
end

--[[function Creator.NewRoundFrame(Radius, Type, Properties, Children, isButton, ReturnTable)
	local function getImageForType(shapeType)
		return Creator.Shapes[shapeType]
	end

	local function getSliceCenterForType(shapeType)
		return not table.find({ "Shadow-sm", "Glass-0.7", "Glass-1", "Glass-1.4" }, shapeType)
				and Rect.new(512 / 2, 512 / 2, 512 / 2, 512 / 2)
			or Rect.new(512, 512, 512, 512)
	end

	local Image = Creator.New(isButton and "ImageButton" or "ImageLabel", {
		Image = getImageForType(Type),
		ScaleType = "Slice",
		SliceCenter = getSliceCenterForType(Type),
		SliceScale = 1,
		BackgroundTransparency = 1,
		ThemeTag = Properties.ThemeTag and Properties.ThemeTag,
	}, Children)

	for k, v in pairs(Properties or {}) do
		if k ~= "ThemeTag" then
			Image[k] = v
		end
	end

	local function UpdateSliceScale(newRadius)
		local sliceScale = not table.find({ "Shadow-sm", "Glass-0.7", "Glass-1", "Glass-1.4" }, Type)
				and (newRadius / (512 / 2))
			or (newRadius / 512)
		Image.SliceScale = math.max(sliceScale, 0.0001)
	end

	local Wrapper = {}

	function Wrapper:SetRadius(newRadius)
		UpdateSliceScale(newRadius)
	end

	function Wrapper:SetType(newType)
		Type = newType
		Image.Image = getImageForType(newType)
		Image.SliceCenter = getSliceCenterForType(newType)
		UpdateSliceScale(Radius)
	end

	function Wrapper:UpdateShape(newRadius, newType)
		if newType then
			Type = newType
			Image.Image = getImageForType(newType)
			Image.SliceCenter = getSliceCenterForType(newType)
		end
		if newRadius then
			Radius = newRadius
		end
		UpdateSliceScale(Radius)
	end

	function Wrapper:GetRadius()
		return Radius
	end

	function Wrapper:GetType()
		return Type
	end

	UpdateSliceScale(Radius)

	return Image, ReturnTable and Wrapper or nil
end]]

function Creator.NewRoundFrame(Radius, Type, Properties, Children, IsButton, ReturnTable)
	return DynamicShapeModule:New(Radius, Type, Properties, Children, IsButton, nil)
end

local New = Creator.New
local Tween = Creator.Tween

function Creator.SetDraggable(can)
	Creator.CanDraggable = can
end

function Creator.Drag(mainFrame, dragFrames, ondrag)
	local CurInput = WindUI.GenerateGUID()

	local currentDragFrame = nil
	local dragging = false
	local dragStart, startPos
	local activeInput = nil

	local DragModule = {
		CanDraggable = true,
	}

	if not dragFrames or typeof(dragFrames) ~= "table" then
		dragFrames = { mainFrame }
	end

	local function update(input)
		if not dragging or not DragModule.CanDraggable then
			return
		end

		local delta = input.Position - dragStart
		Creator.Tween(mainFrame, 0.02, {
			Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			),
		}):Play()
	end

	for _, dragFrame in pairs(dragFrames) do
		dragFrame.InputBegan:Connect(function(input)
			if not DragModule.CanDraggable or dragging then
				return
			end

			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				if WindUI and WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then
					return
				end

				WindUI.CurrentInput = CurInput

				dragging = true
				activeInput = input
				currentDragFrame = dragFrame
				dragStart = input.Position
				startPos = mainFrame.Position

				if ondrag and typeof(ondrag) == "function" then
					ondrag(true, currentDragFrame)
				end
			end
		end)
	end

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then
			return
		end

		if activeInput.UserInputType == Enum.UserInputType.MouseButton1 then
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				update(input)
			end
		elseif activeInput.UserInputType == Enum.UserInputType.Touch then
			if input == activeInput then
				update(input)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if not dragging or WindUI.CurrentInput ~= CurInput then
			return
		end

		if
			input == activeInput
			or (
				activeInput.UserInputType == Enum.UserInputType.MouseButton1
				and input.UserInputType == Enum.UserInputType.MouseButton1
			)
		then
			WindUI.CurrentInput = nil
			dragging = false
			activeInput = nil
			currentDragFrame = nil

			if ondrag and typeof(ondrag) == "function" then
				ondrag(false, nil)
			end
		end
	end)

	function DragModule:Set(v)
		DragModule.CanDraggable = v
	end

	return DragModule
end

Icons.Init(New, "Icon")

function Creator.SanitizeFilename(url)
	local filename = url:match("([^/]+)$") or url

	filename = filename:gsub("%.[^%.]+$", "")

	filename = filename:gsub("[^%w%-_]", "_")

	if #filename > 50 then
		filename = filename:sub(1, 50)
	end

	return filename
end

function Creator.Image(Img, Name, Corner, Folder, Type, IsThemeTag, Themed, ThemeTagName)
	local FolderName = if typeof(Folder) == "table" then Folder.Folder else Folder
	FolderName = tostring(FolderName or "Temp")
	Name = Creator.SanitizeFilename(tostring(Name or "Image"))
	Type = tostring(Type or "Image")

	local IsExternalURL = type(Img) == "string"
		and Img:match("^https?://") ~= nil
		and Img:find("roblox.com", 1, true) == nil
	local ResolvedIcon = if IsExternalURL or typeof(Img) == "Instance" then nil else Creator.Icon(Img)
	local ImageThemeTag = (ResolvedIcon or Themed) and IsThemeTag and (ThemeTagName or "Icon") or nil

	local ImageFrame = New("Frame", {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
	}, {
		New("ImageLabel", {
			Name = "ImageLabel",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Crop,
			ThemeTag = ImageThemeTag and {
				ImageColor3 = ImageThemeTag,
			} or nil,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, tonumber(Corner) or 0),
			}),
		}),
	})

	if typeof(Img) == "Instance" then
		ImageFrame.ImageLabel:Destroy()
		local Clone = Img:Clone()
		Clone.Name = "ImageLabel"
		if Clone:IsA("GuiObject") then
			Clone.Size = UDim2.fromScale(1, 1)
			Clone.Position = UDim2.fromScale(0.5, 0.5)
			Clone.AnchorPoint = Vector2.new(0.5, 0.5)
		end
		Clone.Parent = ImageFrame
	elseif ResolvedIcon then
		ImageFrame.ImageLabel:Destroy()
		local IconLabel = Icons.Image({
			Icon = Img,
			Size = UDim2.fromScale(1, 1),
			Colors = {
				ImageThemeTag or false,
				"Button",
			},
		}).IconFrame
		IconLabel.Name = "ImageLabel"
		IconLabel.Parent = ImageFrame
	elseif IsExternalURL then
		local FileName = "WindUI/" .. FolderName .. "/assets/." .. Type .. "-" .. Name .. ".png"
		local Success, ErrorMessage = pcall(function()
			task.spawn(function()
				local Response = Creator.Request and Creator.Request({
					Url = Img,
					Method = "GET",
				}) or nil
				local Body = typeof(Response) == "table" and Response.Body or Response

				if Body and writefile then
					writefile(FileName, Body)
				end

				local AssetSuccess, Asset = pcall(getcustomasset, FileName)
				if AssetSuccess then
					ImageFrame.ImageLabel.Image = Asset
				elseif not AssetSuccess then
					warn(string.format("[ WindUI.Creator ] Failed to load '%s': %s", FileName, tostring(Asset)))
				end
			end)
		end)

		if not Success then
			warn(string.format("[ WindUI.Creator ] URL image is unavailable: %s", tostring(ErrorMessage)))
			ImageFrame.Visible = false
		end
	elseif Img == nil or Img == "" then
		ImageFrame.Visible = false
	elseif type(Img) == "number" then
		ImageFrame.ImageLabel.Image = "rbxassetid://" .. tostring(Img)
	elseif type(Img) == "string" then
		ImageFrame.ImageLabel.Image = Img
	else
		warn(string.format("[ WindUI.Creator ] Unsupported image value: %s", typeof(Img)))
		ImageFrame.Visible = false
	end

	return ImageFrame
end

function Creator.Color3ToHSB(color)
	local r, g, b = color.R, color.G, color.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h = 0
	if delta ~= 0 then
		if max == r then
			h = (g - b) / delta % 6
		elseif max == g then
			h = (b - r) / delta + 2
		else
			h = (r - g) / delta + 4
		end
		h = h * 60
	else
		h = 0
	end

	local s = (max == 0) and 0 or (delta / max)
	local v = max

	return {
		h = math.floor(h + 0.5),
		s = s,
		b = v,
	}
end

function Creator.GetPerceivedBrightness(color)
	local r = color.R
	local g = color.G
	local b = color.B
	return 0.299 * r + 0.587 * g + 0.114 * b
end

function Creator.GetTextColorForHSB(color, contrast)
	local hsb = Creator.Color3ToHSB(color)
	local h, s, b = hsb.h, hsb.s, hsb.b
	if Creator.GetPerceivedBrightness(color) > (contrast or 0.5) then
		return Color3.fromHSV(h / 360, 0, 0.05)
	else
		return Color3.fromHSV(h / 360, 0, 0.98)
	end
end

function Creator.GetAverageColor(gradient)
	local r, g, b = 0, 0, 0
	local keypoints = gradient.Color.Keypoints
	for _, k in ipairs(keypoints) do
		-- bruh
		r = r + k.Value.R
		g = g + k.Value.G
		b = b + k.Value.B
	end
	local n = #keypoints
	return Color3.new(r / n, g / n, b / n)
end

function Creator:GenerateUniqueID()
	return HttpService:GenerateGUID(false)
end

function Creator:OnThemeChange(callback)
	if typeof(callback) ~= "function" then
		return
	end

	local id = HttpService:GenerateGUID(false)
	Creator.ThemeChangeCallbacks[id] = callback

	return {
		Disconnect = function()
			Creator.ThemeChangeCallbacks[id] = nil
		end,
	}
end

function Creator:AddColor(base, add, weight)
	weight = math.clamp(weight or 1, 0, 1)
	if typeof(add) == "string" then
		add = Color3.fromHex(add)
	end

	return function(theme)
		local baseColor
		if typeof(base) == "string" and string.sub(base, 1, 1) ~= "#" then
			baseColor = Creator.GetThemeProperty(base, theme)
		elseif typeof(base) == "string" then
			baseColor = Color3.fromHex(base)
		else
			baseColor = base
		end

		if not baseColor or typeof(baseColor) ~= "Color3" then
			return nil
		end

		return Color3.new(
			math.clamp(baseColor.R + add.R * weight, 0, 1),
			math.clamp(baseColor.G + add.G * weight, 0, 1),
			math.clamp(baseColor.B + add.B * weight, 0, 1)
		)
	end
end

function Creator:GetElementPosition(elements, targetIndex, isHStack, Options)
	Options = if typeof(Options) == "table" then Options else {}
	if type(targetIndex) ~= "number" or targetIndex ~= math.floor(targetIndex) then
		return "Squircle", Creator.DefaultCornerMap(), { Position = "Single", Count = 1 }
	end

	local Target = elements and elements[targetIndex]
	if Target == nil then
		return "Squircle", Creator.DefaultCornerMap(), { Position = "Single", Count = 1 }
	end

	local BreakTypes = if Options.IncludeDefaultBreaks == false
		then {}
		else {
			Divider = true,
			Space = true,
			Section = true,
		}
	if typeof(Options.BreakTypes) == "table" then
		for Key, Value in Options.BreakTypes do
			if type(Key) == "number" then
				BreakTypes[tostring(Value)] = true
			else
				BreakTypes[tostring(Key)] = Value == true
			end
		end
	end

	local function GetFrame(Element)
		return Element and (Element.ElementFrame or (Element.UIElements and Element.UIElements.Main))
	end

	local function IsHidden(Element)
		if Options.IgnoreHidden == false then
			return false
		end
		local Frame = GetFrame(Element)
		return typeof(Frame) == "Instance" and Frame:IsA("GuiObject") and Frame.Visible == false
	end

	local function IsDelimiter(Element)
		return Element == nil
			or Element.CornerBreak == true
			or Element.LinkCornerBreak == true
			or BreakTypes[tostring(Element.__type)] == true
	end

	local function GetGroup(Element)
		if typeof(Options.GroupBy) == "function" then
			local Success, Group = pcall(Options.GroupBy, Element)
			if Success then
				return Group
			end
		elseif type(Options.GroupBy) == "string" then
			return Element[Options.GroupBy]
		end

		return Element.CornerGroup or Element.LinkCornerGroup or Element.LinkedCornerGroup
	end

	if IsDelimiter(Target) or IsHidden(Target) then
		return "Squircle", Creator.DefaultCornerMap(), { Position = "Single", Count = 1 }
	end

	local Indices = {}
	for Index, Element in elements or {} do
		if type(Index) == "number" and Element ~= nil then
			table.insert(Indices, Index)
		end
	end
	table.sort(Indices)

	local Groups = {}
	local Current = {}
	local PreviousElement
	local PreviousIndex

	local function Flush()
		if #Current > 0 then
			table.insert(Groups, Current)
			Current = {}
		end
		PreviousElement = nil
		PreviousIndex = nil
	end

	for _, Index in Indices do
		local Element = elements[Index]
		if IsHidden(Element) then
			if Options.BridgeHidden ~= true then
				Flush()
			else
				PreviousIndex = Index
			end
		elseif IsDelimiter(Element) then
			Flush()
		else
			local BreakBefore = Element.CornerBreakBefore == true or Element.LinkCornerBreakBefore == true
			local SparseBreak = PreviousIndex ~= nil and Index - PreviousIndex > 1 and Options.BridgeSparse ~= true
			local GroupBreak = PreviousElement ~= nil and GetGroup(PreviousElement) ~= GetGroup(Element)
			local PreviousBreak = PreviousElement
				and (PreviousElement.CornerBreakAfter == true or PreviousElement.LinkCornerBreakAfter == true)

			if #Current > 0 and (BreakBefore or SparseBreak or GroupBreak or PreviousBreak) then
				Flush()
			end

			table.insert(Current, Index)
			PreviousElement = Element
			PreviousIndex = Index

			if Element.LinkCorners == false or Element.LinkCorner == false then
				Flush()
			end
		end
	end
	Flush()

	local TargetGroup
	local TargetPosition
	for _, Group in Groups do
		for Position, Index in Group do
			if Index == targetIndex then
				TargetGroup = Group
				TargetPosition = Position
				break
			end
		end
		if TargetGroup then
			break
		end
	end

	if not TargetGroup or not TargetPosition then
		return "Squircle", Creator.DefaultCornerMap(), { Position = "Single", Count = 1 }
	end

	local Count = #TargetGroup
	local Position = if Options.Reverse == true then Count - TargetPosition + 1 else TargetPosition
	local Inner = if Options.InnerRadius ~= nil
		then Creator.ToUDimRadius(Options.InnerRadius, UDim.new(0, 0))
		else false
	local Shape = "Squircle"
	local Corners = Creator.DefaultCornerMap()
	local PositionName = "Single"

	if Count > 1 and Position == 1 then
		PositionName = "First"
		if isHStack then
			Shape = "Squircle-TL-BL"
			Corners.TopRight = Inner
			Corners.BottomRight = Inner
		else
			Shape = "Squircle-TL-TR"
			Corners.BottomLeft = Inner
			Corners.BottomRight = Inner
		end
	elseif Count > 1 and Position == Count then
		PositionName = "Last"
		if isHStack then
			Shape = "Squircle-TR-BR"
			Corners.TopLeft = Inner
			Corners.BottomLeft = Inner
		else
			Shape = "Squircle-BL-BR"
			Corners.TopLeft = Inner
			Corners.TopRight = Inner
		end
	elseif Count > 1 then
		PositionName = "Middle"
		Shape = "Square"
		if isHStack then
			Corners.TopLeft = Inner
			Corners.TopRight = Inner
			Corners.BottomLeft = Inner
			Corners.BottomRight = Inner
		else
			Corners.TopLeft = Inner
			Corners.TopRight = Inner
			Corners.BottomLeft = Inner
			Corners.BottomRight = Inner
		end
	end

	local Metadata = {
		Position = PositionName,
		Index = Position,
		Count = Count,
		Horizontal = isHStack == true,
		SourceIndex = targetIndex,
		Group = GetGroup(Target),
	}

	if typeof(Options.Resolver) == "function" then
		local Success, CustomShape, CustomCorners = pcall(Options.Resolver, Metadata, Shape, Corners, Target)
		if Success then
			Shape = CustomShape or Shape
			Corners = CustomCorners or Corners
		end
	end

	return Shape, Corners, Metadata
end

return Creator

end)()

-- ── themes/Fallbacks.lua ──
_VYNX_MODULES["themes/Fallbacks.lua"] = (function()
return function(Creator)
	return {
		-- More soon!

		Primary = "Icon",

		White = Color3.new(1, 1, 1),
		Black = Color3.new(0, 0, 0),

		Dialog = "Accent",

		Background = "Accent",
		BackgroundTransparency = 0,
		Hover = "Text",

		PanelBackground = "White",
		PanelBackgroundTransparency = 0.95,

		WindowBackground = "Background",

		WindowShadow = "Black",
		--WindowShadowTransparency = .7,

		WindowTopbarTitle = "Text",
		WindowTopbarAuthor = "Text",
		WindowTopbarIcon = "Icon",
		WindowTopbarButtonIcon = "Icon",

		--WindowSearchBarBackground = "Background",
		WindowSearchBarBackground = "Dialog",

		TabBackground = "Hover",
		TabBackgroundHover = "Hover",
		TabBackgroundHoverTransparency = 0.97,
		TabBackgroundActive = "Hover",
		TabBackgroundActiveTransparency = 0.93,
		TabText = "Text",
		TabTextTransparency = 0.3,
		TabTextTransparencyActive = 0,
		TabTitle = "Text",
		TabIcon = "Icon",
		TabIconTransparency = 0.4,
		TabIconTransparencyActive = 0.1,
		TabBorderTransparency = 1,
		TabBorderTransparencyActive = 0.75,
		TabBorder = "White",

		ElementBackground = "Text",
		ElementBackgroundTransparency = 0.93,
		ElementBackgroundHover = Creator:AddColor("ElementBackground", "#ffffff", 1 / 10),
		ElementTitle = "Text",
		ElementDesc = "Text",
		ElementIcon = "Icon",

		RadioGroupBackground = "ElementBackground",
		RadioGroupText = "Text",
		RadioGroupBorder = "Text",
		RadioGroupActive = "Primary",

		CheckboxGroupBackground = "ElementBackground",
		CheckboxGroupText = "Text",
		CheckboxGroupBorder = "Text",
		CheckboxGroupActive = "Primary",
		CheckboxGroupIcon = "White",

		SegmentedControlBackground = "ElementBackground",
		SegmentedControlActive = "Primary",
		SegmentedControlText = "Text",

		StepperButton = "ElementBackground",
		StepperValueBackground = "ElementBackground",
		StepperIcon = "Icon",
		StepperText = "Text",

		BadgeBackground = "Primary",
		BadgeText = "White",
		BadgeIcon = "White",

		KeyValueIcon = "Icon",
		ChipListBackground = "ElementBackground",
		TimelineLine = "Text",
		AccordionBackground = "ElementBackground",
		AccordionIcon = "Icon",
		TabBoxTabBackground = "ElementBackground",
		TabBoxIcon = "Icon",
		EmptyStateIcon = "Icon",
		DiscordCardBackground = "ElementBackground",
		DiscordCardAccent = "Primary",
		Path2DBackground = "ElementBackground",
		Path2DTrack = "ElementBackground",
		Path2DLine = "Primary",
		Path2DMarker = "Primary",
		Path2DLabel = "Text",

		PopupBackground = "Background",
		PopupBackgroundTransparency = "BackgroundTransparency",
		PopupTitle = "Text",
		PopupContent = "Text",
		PopupIcon = "Icon",

		DialogBackground = "Dialog",
		DialogBackgroundTransparency = "BackgroundTransparency",
		DialogTitle = "Text",
		DialogContent = "Text",
		DialogIcon = "Icon",

		Toggle = "Button",
		ToggleBar = "White",

		Checkbox = "Primary",
		CheckboxIcon = "White",
		CheckboxBorder = "White",
		CheckboxBorderTransparency = 0.75,

		SliderIcon = "Icon",

		Slider = "Primary",
		SliderThumb = "White",
		SliderIconFrom = "SliderIcon",
		SliderIconTo = "SliderIcon",

		ProgressBar = "Primary",
		ProgressBarTrack = "Text",
		ProgressBarTrackTransparency = 0.9,
		ProgressBarText = "Text",

		Tooltip = Color3.fromHex("4C4C4C"),
		TooltipText = "White",
		TooltipSecondary = "Primary",
		TooltipSecondaryText = "White",

		TabSectionIcon = "Icon",

		SectionIcon = "Icon",

		SectionExpandIcon = "Icon",
		SectionExpandIconTransparency = 0.4,
		SectionBox = "Text",
		SectionBoxTransparency = 0.95,
		SectionBoxBorder = "White",
		SectionBoxBorderTransparency = 0.75,
		SectionBoxBackground = "Text",
		SectionBoxBackgroundTransparency = 0.97,

		SearchBarBorder = "White",
		SearchBarBorderTransparency = 0.75,

		Notification = "Dialog",
		NotificationTransparency = 0.08,
		Notification2 = "White",
		Notification2Transparency = 0.985,
		NotificationTitle = "Text",
		NotificationTitleTransparency = 0,
		NotificationContent = "Text",
		NotificationContentTransparency = 0.32,
		NotificationDuration = "White",
		NotificationDurationTransparency = 0.94,
		NotificationBorder = "White",
		NotificationBorderTransparency = 0.76,

		DropdownTabBorder = "White",
		DropdownTabBackground = "ElementBackground",
		DropdownBackground = "Background",

		LabelBackground = "White",
		LabelBackgroundTransparency = 0.95,

		ViewportBackground = "ElementBackground",
		ViewportBackgroundTransparency = "ElementBackgroundTransparency",
	}
end

end)()

-- ── themes/Init.lua ──
_VYNX_MODULES["themes/Init.lua"] = (function()
return function(VynxUI, Creator)
	local Themes = {
		Dark = {
			Name = "Dark",
			-- WindUI keys
			Accent                       = Color3.fromHex("#18181b"),
			Dialog                       = Color3.fromHex("#1a1a1a"),
			Outline                      = Color3.fromHex("#2a2a3a"),
			Text                         = Color3.fromHex("#FFFFFF"),
			Placeholder                  = Color3.fromHex("#a1a1aa"),
			Background                   = Color3.fromHex("#0D0D12"),
			Button                       = Color3.fromHex("#2A2A38"),
			Icon                         = Color3.fromHex("#a1a1aa"),
			Toggle                       = Color3.fromHex("#33C759"),
			Slider                       = Color3.fromHex("#7C5CFF"),
			Checkbox                     = Color3.fromHex("#7C5CFF"),
			PanelBackground              = Color3.fromHex("#FFFFFF"),
			PanelBackgroundTransparency  = 0.95,
			SliderIcon                   = Color3.fromHex("#908F95"),
			Primary                      = Color3.fromHex("#7C5CFF"),
			LabelBackground              = Color3.fromHex("#000000"),
			LabelBackgroundTransparency  = 0.83,
			ElementBackground            = Color3.fromHex("#1E1E2C"),
			ElementBackgroundTransparency= 0,
			-- Obsidian Scheme fields
			BackgroundColor              = Color3.fromHex("#0D0D12"),
			MainColor                    = Color3.fromHex("#16161F"),
			AccentColor                  = Color3.fromHex("#7C5CFF"),
			OutlineColor                 = Color3.fromHex("#2a2a3a"),
			FontColor                    = Color3.new(1, 1, 1),
			RedColor                     = Color3.fromRGB(255, 50, 50),
			DestructiveColor             = Color3.fromRGB(220, 38, 38),
		},

		Light = {
			Name = "Light",
			Accent                       = Color3.fromHex("#efefef"),
			Dialog                       = Color3.fromHex("#f4f4f5"),
			Outline                      = Color3.fromHex("#e4e4e7"),
			Text                         = Color3.fromHex("#000000"),
			Placeholder                  = Color3.fromHex("#555555"),
			Background                   = Color3.fromHex("#FFFFFF"),
			Button                       = Color3.fromHex("#18181b"),
			Icon                         = Color3.fromHex("#52525b"),
			Toggle                       = Color3.fromHex("#33C759"),
			Slider                       = Color3.fromHex("#7C5CFF"),
			Checkbox                     = Color3.fromHex("#7C5CFF"),
			PanelBackground              = Color3.fromHex("#efefef"),
			PanelBackgroundTransparency  = 0,
			SliderIcon                   = Color3.fromHex("#555555"),
			Primary                      = Color3.fromHex("#7C5CFF"),
			LabelBackground              = Color3.fromHex("#efefef"),
			LabelBackgroundTransparency  = 0,
			ElementBackground            = Color3.fromHex("#ffffff"),
			ElementBackgroundTransparency= 0,
			BackgroundColor              = Color3.fromHex("#FFFFFF"),
			MainColor                    = Color3.fromHex("#f4f4f5"),
			AccentColor                  = Color3.fromHex("#7C5CFF"),
			OutlineColor                 = Color3.fromHex("#e4e4e7"),
			FontColor                    = Color3.new(0, 0, 0),
			RedColor                     = Color3.fromRGB(200, 30, 30),
			DestructiveColor             = Color3.fromRGB(180, 28, 28),
		},

		Vynx = {
			Name = "Vynx",
			Accent                       = Color3.fromHex("#1a1228"),
			Dialog                       = Color3.fromHex("#130e1f"),
			Outline                      = Color3.fromHex("#2f2150"),
			Text                         = Color3.fromHex("#EDE8FF"),
			Placeholder                  = Color3.fromHex("#9d8ec7"),
			Background                   = Color3.fromHex("#0A0814"),
			Button                       = Color3.fromHex("#2A1F42"),
			Icon                         = Color3.fromHex("#b09de0"),
			Toggle                       = Color3.fromHex("#A374FF"),
			Slider                       = Color3.fromHex("#7C5CFF"),
			Checkbox                     = Color3.fromHex("#7C5CFF"),
			PanelBackground              = Color3.fromHex("#FFFFFF"),
			PanelBackgroundTransparency  = 0.95,
			SliderIcon                   = Color3.fromHex("#7C5CFF"),
			Primary                      = Color3.fromHex("#7C5CFF"),
			LabelBackground              = Color3.fromHex("#000000"),
			LabelBackgroundTransparency  = 0.8,
			ElementBackground            = Color3.fromHex("#180F2B"),
			ElementBackgroundTransparency= 0,
			BackgroundColor              = Color3.fromHex("#0A0814"),
			MainColor                    = Color3.fromHex("#130e1f"),
			AccentColor                  = Color3.fromHex("#7C5CFF"),
			OutlineColor                 = Color3.fromHex("#2f2150"),
			FontColor                    = Color3.fromHex("#EDE8FF"),
			RedColor                     = Color3.fromRGB(255, 60, 80),
			DestructiveColor             = Color3.fromRGB(220, 38, 55),
		},

		Midnight = {
			Name = "Midnight",
			Accent                       = Color3.fromHex("#141422"),
			Dialog                       = Color3.fromHex("#0e0e1c"),
			Outline                      = Color3.fromHex("#252540"),
			Text                         = Color3.fromHex("#e0e0ff"),
			Placeholder                  = Color3.fromHex("#6666aa"),
			Background                   = Color3.fromHex("#08080F"),
			Button                       = Color3.fromHex("#1e1e38"),
			Icon                         = Color3.fromHex("#8888cc"),
			Toggle                       = Color3.fromHex("#4488FF"),
			Slider                       = Color3.fromHex("#4466DD"),
			Checkbox                     = Color3.fromHex("#4466DD"),
			PanelBackground              = Color3.fromHex("#FFFFFF"),
			PanelBackgroundTransparency  = 0.96,
			Primary                      = Color3.fromHex("#4466DD"),
			LabelBackground              = Color3.fromHex("#000000"),
			LabelBackgroundTransparency  = 0.85,
			ElementBackground            = Color3.fromHex("#131328"),
			ElementBackgroundTransparency= 0,
			BackgroundColor              = Color3.fromHex("#08080F"),
			MainColor                    = Color3.fromHex("#0e0e1c"),
			AccentColor                  = Color3.fromHex("#4466DD"),
			OutlineColor                 = Color3.fromHex("#252540"),
			FontColor                    = Color3.fromHex("#e0e0ff"),
			RedColor                     = Color3.fromRGB(255, 50, 60),
			DestructiveColor             = Color3.fromRGB(220, 38, 38),
		},

		Rose = {
			Name = "Rose",
			Accent                       = Color3.fromHex("#be185d"),
			Dialog                       = Color3.fromHex("#4c0519"),
			Outline                      = Color3.fromHex("#881337"),
			Text                         = Color3.fromHex("#fdf2f8"),
			Placeholder                  = Color3.fromHex("#d67aa6"),
			Background                   = Color3.fromHex("#1f0308"),
			Button                       = Color3.fromHex("#e95f74"),
			Icon                         = Color3.fromHex("#fb7185"),
			Toggle                       = Color3.fromHex("#fb7185"),
			Slider                       = Color3.fromHex("#e11d48"),
			Checkbox                     = Color3.fromHex("#e11d48"),
			PanelBackground              = Color3.fromHex("#FFFFFF"),
			PanelBackgroundTransparency  = 0.94,
			Primary                      = Color3.fromHex("#e11d48"),
			LabelBackground              = Color3.fromHex("#000000"),
			LabelBackgroundTransparency  = 0.8,
			ElementBackground            = Color3.fromHex("#381E23"),
			ElementBackgroundTransparency= 0,
			BackgroundColor              = Color3.fromHex("#1f0308"),
			MainColor                    = Color3.fromHex("#4c0519"),
			AccentColor                  = Color3.fromHex("#e11d48"),
			OutlineColor                 = Color3.fromHex("#881337"),
			FontColor                    = Color3.fromHex("#fdf2f8"),
			RedColor                     = Color3.fromRGB(255, 50, 80),
			DestructiveColor             = Color3.fromRGB(220, 38, 60),
		},

		Serenity = {
			Name = "Serenity",
			Accent                       = Color3.fromHex("#0f2027"),
			Dialog                       = Color3.fromHex("#0a1a20"),
			Outline                      = Color3.fromHex("#1e4d5a"),
			Text                         = Color3.fromHex("#e0f4f9"),
			Placeholder                  = Color3.fromHex("#5a9aaa"),
			Background                   = Color3.fromHex("#060f14"),
			Button                       = Color3.fromHex("#0d2d38"),
			Icon                         = Color3.fromHex("#7ec8d8"),
			Toggle                       = Color3.fromHex("#00b4cc"),
			Slider                       = Color3.fromHex("#00A8C0"),
			Checkbox                     = Color3.fromHex("#00A8C0"),
			PanelBackground              = Color3.fromHex("#FFFFFF"),
			PanelBackgroundTransparency  = 0.95,
			Primary                      = Color3.fromHex("#00A8C0"),
			LabelBackground              = Color3.fromHex("#000000"),
			LabelBackgroundTransparency  = 0.83,
			ElementBackground            = Color3.fromHex("#0d2030"),
			ElementBackgroundTransparency= 0,
			BackgroundColor              = Color3.fromHex("#060f14"),
			MainColor                    = Color3.fromHex("#0a1a20"),
			AccentColor                  = Color3.fromHex("#00A8C0"),
			OutlineColor                 = Color3.fromHex("#1e4d5a"),
			FontColor                    = Color3.fromHex("#e0f4f9"),
			RedColor                     = Color3.fromRGB(255, 60, 60),
			DestructiveColor             = Color3.fromRGB(220, 38, 38),
		},

		Fatality = {
			Name = "Fatality",
			Accent                       = Color3.fromHex("#1a1a1a"),
			Dialog                       = Color3.fromHex("#111111"),
			Outline                      = Color3.fromHex("#333333"),
			Text                         = Color3.fromHex("#ffffff"),
			Placeholder                  = Color3.fromHex("#888888"),
			Background                   = Color3.fromHex("#0a0a0a"),
			Button                       = Color3.fromHex("#cc2233"),
			Icon                         = Color3.fromHex("#ff3344"),
			Toggle                       = Color3.fromHex("#ff3344"),
			Slider                       = Color3.fromHex("#cc2233"),
			Checkbox                     = Color3.fromHex("#cc2233"),
			PanelBackground              = Color3.fromHex("#FFFFFF"),
			PanelBackgroundTransparency  = 0.95,
			Primary                      = Color3.fromHex("#cc2233"),
			LabelBackground              = Color3.fromHex("#000000"),
			LabelBackgroundTransparency  = 0.84,
			ElementBackground            = Color3.fromHex("#1a0a0a"),
			ElementBackgroundTransparency= 0,
			BackgroundColor              = Color3.fromHex("#0a0a0a"),
			MainColor                    = Color3.fromHex("#111111"),
			AccentColor                  = Color3.fromHex("#cc2233"),
			OutlineColor                 = Color3.fromHex("#333333"),
			FontColor                    = Color3.fromHex("#ffffff"),
			RedColor                     = Color3.fromRGB(255, 50, 50),
			DestructiveColor             = Color3.fromRGB(200, 30, 30),
		},
	}

	return Themes
end

end)()

-- ── utils/Acrylic/Utils.lua ──
_VYNX_MODULES["utils/Acrylic/Utils.lua"] = (function()
-- Credits: Fluent - Dawid


local cloneref = (cloneref or clonereference or function(instance) return instance end)


local function map(value, inMin, inMax, outMin, outMax)
	return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

local function viewportPointToWorld(location, distance)
	local unitRay = cloneref(game:GetService("Workspace")).CurrentCamera:ScreenPointToRay(location.X, location.Y)
	return unitRay.Origin + unitRay.Direction * distance
end

local function getOffset()
	local viewportSizeY = cloneref(game:GetService("Workspace")).CurrentCamera.ViewportSize.Y
	return map(viewportSizeY, 0, 2560, 8, 56)
end

return { viewportPointToWorld, getOffset }

end)()

-- ── utils/Acrylic/Blur.lua ──
_VYNX_MODULES["utils/Acrylic/Blur.lua"] = (function()
-- Credits: Fluent - Dawid

local cloneref = (cloneref or clonereference or function(instance) return instance end)


local Creator = require("../../modules/Creator")
local New = Creator.New


local viewportPointToWorld, getOffset = unpack(require("./Utils"))
local BlurFolder = Instance.new("Folder", cloneref(game:GetService("Workspace")).CurrentCamera)


local function createAcrylic()
	local Part = New("Part", {
		Name = "Body",
		Color = Color3.new(0, 0, 0),
		Material = Enum.Material.Glass,
		Size = Vector3.new(1, 1, 0),
		Anchored = true,
		CanCollide = false,
		Locked = true,
		CastShadow = false,
		Transparency = 0.98,
	}, {
		New("SpecialMesh", {
			MeshType = Enum.MeshType.Brick,
			Offset = Vector3.new(0, 0, -0.000001),
		}),
	})

	return Part
end


local function createAcrylicBlur(distance)
	local cleanups = {}

	distance = distance or 0.001
	local positions = {
		topLeft = Vector2.new(),
		topRight = Vector2.new(),
		bottomRight = Vector2.new(),
	}
	local model = createAcrylic()
	model.Parent = BlurFolder

	local function updatePositions(size, position)
		positions.topLeft = position
		positions.topRight = position + Vector2.new(size.X, 0)
		positions.bottomRight = position + size
	end

	local function render()
		local res = cloneref(game:GetService("Workspace")).CurrentCamera
		if res then
			res = res.CFrame
		end
		local cond = res
		if not cond then
			cond = CFrame.new()
		end

		local camera = cond
		local topLeft = positions.topLeft
		local topRight = positions.topRight
		local bottomRight = positions.bottomRight

		local topLeft3D = viewportPointToWorld(topLeft, distance)
		local topRight3D = viewportPointToWorld(topRight, distance)
		local bottomRight3D = viewportPointToWorld(bottomRight, distance)

		local width = (topRight3D - topLeft3D).Magnitude
		local height = (topRight3D - bottomRight3D).Magnitude

		model.CFrame =
			CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, camera.XVector, camera.YVector, camera.ZVector)
		model.Mesh.Scale = Vector3.new(width, height, 0)
	end

	local function onChange(rbx)
		local offset = getOffset()
		local size = rbx.AbsoluteSize - Vector2.new(offset, offset)
		local position = rbx.AbsolutePosition + Vector2.new(offset / 2, offset / 2)

		updatePositions(size, position)
		task.spawn(render)
	end

	local function renderOnChange()
		local camera = cloneref(game:GetService("Workspace")).CurrentCamera
		if not camera then
			return
		end

		table.insert(cleanups, camera:GetPropertyChangedSignal("CFrame"):Connect(render))
		table.insert(cleanups, camera:GetPropertyChangedSignal("ViewportSize"):Connect(render))
		table.insert(cleanups, camera:GetPropertyChangedSignal("FieldOfView"):Connect(render))
		task.spawn(render)
	end

	model.Destroying:Connect(function()
		for _, item in cleanups do
			pcall(function()
				item:Disconnect()
			end)
		end
	end)

	renderOnChange()

	return onChange, model
end

return function(distance)
	local Blur = {}
	local onChange, model = createAcrylicBlur(distance)

	local comp = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	})

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsolutePosition"), function()
		onChange(comp)
	end)

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsoluteSize"), function()
		onChange(comp)
	end)

	Blur.AddParent = function(Parent)
		Creator.AddSignal(Parent:GetPropertyChangedSignal("Visible"), function()
			--Blur.SetVisibility(Parent.Visible)
		end)
	end

	Blur.SetVisibility = function(Value)
		model.Transparency = Value and 0.98 or 1
	end

	Blur.Frame = comp
	Blur.Model = model

	return Blur
end
end)()

-- ── utils/Acrylic/Paint.lua ──
_VYNX_MODULES["utils/Acrylic/Paint.lua"] = (function()
-- Credits: Fluent - Dawid

local Creator = require("../../modules/Creator")
local AcrylicBlur = require("./Blur")

local New = Creator.New

return function(props)
	local AcrylicPaint = {}

  	AcrylicPaint.Frame = New("Frame", {
  		Size = UDim2.fromScale(1, 1),
  		BackgroundTransparency = 1,
  		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
  		BorderSizePixel = 0,
  	}, {
--		New("ImageLabel", {
--			Image = "rbxassetid://8992230677",
--			ScaleType = "Slice",
--			SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
--			AnchorPoint = Vector2.new(0.5, 0.5),
--			Size = UDim2.new(1, 120, 1, 116),
--			Position = UDim2.new(0.5, 0, 0.5, 0),
--			BackgroundTransparency = 1,
--			ImageColor3 = Color3.fromRGB(0, 0, 0),
--			ImageTransparency = 0.7,
--		}),

		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),

		New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Name = "Background",
			ThemeTag = {
				BackgroundColor3 = "AcrylicMain",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

  		New("Frame", {
  			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
  			BackgroundTransparency = 1,
  			Size = UDim2.fromScale(1, 1),
  		}, {
--			New("UICorner", {
--				CornerRadius = UDim.new(0, 8),
--			}),

--			New("UIGradient", {
--				Rotation = 90,
--				ThemeTag = {
--					Color = "AcrylicGradient",
--				},
--			}),
  		}),

		New("ImageLabel", {
			Image = "rbxassetid://9968344105",
			ImageTransparency = 0.98,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.new(0, 128, 0, 128),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

		New("ImageLabel", {
			Image = "rbxassetid://9968344227",
			ImageTransparency = 0.9,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.new(0, 128, 0, 128),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ThemeTag = {
				ImageTransparency = "AcrylicNoise",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

  		New("Frame", {
  			BackgroundTransparency = 1,
  			Size = UDim2.fromScale(1, 1),
  			ZIndex = 2,
  		}, {
--			New("UICorner", {
--				CornerRadius = UDim.new(0, 8),
--			}),
--			New("UIStroke", {
--				Transparency = 0.5,
--				Thickness = 1,
--				ThemeTag = {
--					Color = "AcrylicBorder",
--				},
--			}),
  		}),
  	})

    
    local Blur
    
    task.wait()
	if props.UseAcrylic then
		Blur = AcrylicBlur()
		
		Blur.Frame.Parent = AcrylicPaint.Frame
		AcrylicPaint.Model = Blur.Model
		AcrylicPaint.AddParent = Blur.AddParent
		AcrylicPaint.SetVisibility = Blur.SetVisibility
	end

	return AcrylicPaint, Blur
end

end)()

-- ── utils/Acrylic/Init.lua ──
_VYNX_MODULES["utils/Acrylic/Init.lua"] = (function()
-- Credits: Fluent - Dawid

local cloneref = (cloneref or clonereference or function(instance) return instance end)


local Acrylic = {
	AcrylicBlur = require("./Blur"),
	--CreateAcrylic = require("./"),
	AcrylicPaint = require("./Paint"),
}

function Acrylic.init()
	local baseEffect = Instance.new("DepthOfFieldEffect")
	baseEffect.FarIntensity = 0
	baseEffect.InFocusRadius = 0.1
	baseEffect.NearIntensity = 1

	local depthOfFieldDefaults = {}

	function Acrylic.Enable()
		for _, effect in pairs(depthOfFieldDefaults) do
			effect.Enabled = false
		end
		baseEffect.Parent = cloneref(game:GetService("Lighting"))
	end

	function Acrylic.Disable()
		for _, effect in pairs(depthOfFieldDefaults) do
			effect.Enabled = effect.enabled
		end
		baseEffect.Parent = nil
	end

	local function registerDefaults()
		local function register(object)
			if object:IsA("DepthOfFieldEffect") then
				depthOfFieldDefaults[object] = { enabled = object.Enabled }
			end
		end

		for _, child in pairs(cloneref(game:GetService("Lighting")):GetChildren()) do
			register(child)
		end

		if cloneref(game:GetService("Workspace")).CurrentCamera then
			for _, child in pairs(cloneref(game:GetService("Workspace")).CurrentCamera:GetChildren()) do
				register(child)
			end
		end
	end

	registerDefaults()
	Acrylic.Enable()
end

return Acrylic

end)()

-- ── utils/services/JunkieDevelopment.lua ──
_VYNX_MODULES["utils/services/JunkieDevelopment.lua"] = (function()


--[[

    Junkie Development API   |   

]]

local JunkieDevelopment = {}

function JunkieDevelopment.New(ServiceId, ApiKey, Provider)
    JunkieProtected.API_KEY = ApiKey
    JunkieProtected.PROVIDER = Provider
    JunkieProtected.SERVICE_ID = ServiceId

    local function ValidateKey(key)
        if not key or key == "" then
            print("No key provided!")
            --game.Players.LocalPlayer:Kick("No key provided. Please get a key.")
            return false, "No key provided. Please get a key."
        end

        local keylessCheck = JunkieProtected.IsKeylessMode()
        if keylessCheck and keylessCheck.keyless_mode then
            print("Keyless mode enabled. Starting script...")
            return true, "Keyless mode enabled. Starting script..."
        end

        local result = JunkieProtected.ValidateKey({ Key = key })
        if result == "valid" then
            print("Key is valid! Starting script...")
            load()                                                                                                               
            if _G.JD_IsPremium then                       
                print("Premium user detected!")
            else
                print("Standard user")
            end

            return true, "Key is valid!"
        else
            local keyLink = JunkieProtected.GetKeyLink()
            print("Invalid key!")
            --game.Players.LocalPlayer:Kick("Invalid key. Get one from: " .. keyLink)
            return false, "Invalid key. Get one from:" .. keyLink
        end                                                                                                            
    end

    local function copyLink()
        local link = JunkieProtected.GetKeyLink()                                                                                        
        --print("Get your key: " .. link)                                                                                                
        if setclipboard then
            setclipboard(link)
        end
    end                                                                                                                                                                                                                                                                       
    return {
        Verify = ValidateKey,
        Copy = copyLink
    }
end

return JunkieDevelopment



end)()

-- ── utils/services/Luarmor.lua ──
_VYNX_MODULES["utils/services/Luarmor.lua"] = (function()
--[[

    Luarmor API   |   https://luarmor.net
    
]]

local Luarmor = {}

function Luarmor.New(scriptId, discord)
	local APIURL = "https://sdkapi-public.luarmor.net/library.lua"

	local API = loadstring(game.HttpGet and game:HttpGet(APIURL) or HttpService:GetAsync(APIURL))()
	local fsetclipboard = setclipboard or toclipboard

	API.script_id = scriptId

	function ValidateKey(key)
		local status = API.check_key(key)
		--print(status)

		if status.code == "KEY_VALID" then
			return true, "Whitelisted!"
		elseif status.code == "KEY_HWID_LOCKED" then
			return false, "Key linked to a different HWID. Please reset it using our bot"
		elseif status.code == "KEY_INCORRECT" then
			return false, "Key is wrong or deleted!"
		else
			return false, "Key check failed:" .. status.message .. " Code: " .. status.code
		end
	end

	function CopyLink()
		fsetclipboard(tostring(discord))
	end

	return {
		Verify = ValidateKey,
		Copy = CopyLink,
	}
end

return Luarmor

end)()

-- ── utils/services/PandaDevelopment.lua ──
_VYNX_MODULES["utils/services/PandaDevelopment.lua"] = (function()
--[[

    Panda Development API   |   https://pandadevelopment.net/
    
]]

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local HttpService = cloneref(game:GetService("HttpService"))
local PandaDevelopment = {}

function PandaDevelopment.New(serviceId)
	local hwid = gethwid or function()
		return cloneref(game:GetService("Players")).LocalPlayer.UserId
	end
	local frequest, fsetclipboard = request or http_request or syn_request, setclipboard or toclipboard

	function ValidateKey(key)
		local validationUrl = "https://api.pandauth.com/api/v1/keys/validate"

		local payload = {
			ServiceID = serviceId,
			HWID = tostring(hwid()),
			Key = tostring(key),
		}

		local jsonData = HttpService:JSONEncode(payload)
		local success, response = pcall(function()
			return frequest({
				Url = validationUrl,
				Method = "POST",
				Headers = {
					["User-Agent"] = "Roblox/Exploit",
					["Content-Type"] = "application/json",
				},
				Body = jsonData,
			})
		end)

		if success and response then
			if response.Success then
				local decodeSuccess, jsonData = pcall(function()
					return HttpService:JSONDecode(response.Body)
				end)

				if decodeSuccess and jsonData then
					if jsonData.Authenticated_Status and jsonData.Authenticated_Status == "Success" then
						return true, "Authenticated"
					else
						local reason = jsonData.Note or "Unknown reason"
						return false, "Authentication failed: " .. reason
					end
				else
					return false, "JSON decode error"
				end
			else
				warn(
					" HTTP request was not successful. Code: "
						.. tostring(response.StatusCode)
						.. " Message: "
						.. response.StatusMessage
				)
				return false, "HTTP request failed: " .. response.StatusMessage
			end
		else
			return false, "Request pcall error"
		end
	end

	function GetKeyLink()
		return "https://new.pandadevelopment.net/getkey/" .. tostring(serviceId) .. "?hwid=" .. tostring(hwid())
	end

	function CopyLink()
		return fsetclipboard(GetKeyLink())
	end

	return {
		Verify = ValidateKey,
		Copy = CopyLink,
	}
end

return PandaDevelopment

end)()

-- ── utils/services/Platoboost.lua ──
_VYNX_MODULES["utils/services/Platoboost.lua"] = (function()


--[[

    Platoboost API   |   https://platoboost.com/
    
]]

-------------------------------------------------------------------------------
--! json library
--! cryptography library
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! platoboost library

local Platoboost = {}

local cloneref = (cloneref or clonereference or function(instance) return instance end)


function Platoboost.New(Service, Secret)
    --! configuration
    local service = Service;  -- your service id, this is used to identify your service.
    local secret = Secret;  -- make sure to obfuscate this if you want to ensure security.
    local useNonce = true;  -- use a nonce to prevent replay attacks and request tampering.
    
    --! callbacks
    local onMessage = function(message) end;
    
    --! wait for game to load
    repeat task.wait(1) until game:IsLoaded();
    
    --! functions
    local requestSending = false;
    local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return cloneref(game:GetService("Players")).LocalPlayer.UserId end
    local cachedLink, cachedTime = "", 0;
    
    --! pick host
    local host = "https://api.platoboost.app";
    local hostResponse = fRequest({
        Url = host .. "/public/connectivity",
        Method = "GET"
    });
    if hostResponse.StatusCode ~= 200 and hostResponse.StatusCode ~= 429 then
        host = "https://api.platoboost.net";
    end
    
    --!optimize 2
    function cacheLink()
        if cachedTime + (10*60) < fOsTime() then
            local response = fRequest({
                Url = host .. "/public/start",
                Method = "POST",
                Body = lEncode({
                    service = service,
                    identifier = lDigest(fGetHwid())
                }),
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"] = "Roblox/Exploit"
                }
            });
    
            if response.StatusCode == 200 then
                local decoded = lDecode(response.Body);
    
                if decoded.success == true then
                    cachedLink = decoded.data.url;
                    cachedTime = fOsTime();
                    return true, cachedLink;
                else
                    onMessage(decoded.message);
                    return false, decoded.message;
                end
            elseif response.StatusCode == 429 then
                local msg = "you are being rate limited, please wait 20 seconds and try again.";
                onMessage(msg);
                return false, msg;
            end
    
            local msg = "Failed to cache link.";
            onMessage(msg);
            return false, msg;
        else
            return true, cachedLink;
        end
    end
    
    cacheLink();
    
    --!optimize 2
    local generateNonce = function()
        local str = ""
        for _ = 1, 16 do
            str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
        end
        return str
    end
    
    --!optimize 1
    for _ = 1, 5 do
        local oNonce = generateNonce();
        task.wait(0.2)
        if generateNonce() == oNonce then
            local msg = "platoboost nonce error.";
            onMessage(msg);
            error(msg);
        end
    end
    
    --!optimize 2
    local copyLink = function()
        local success, link = cacheLink();
        
        if success then
            fSetClipboard(link);
        end
    end
    
    --!optimize 2
    local redeemKey = function(key)
        local nonce = generateNonce();
        local endpoint = host .. "/public/redeem/" .. fToString(service);
    
        local body = {
            identifier = lDigest(fGetHwid()),
            key = key
        }
    
        if useNonce then
            body.nonce = nonce;
        end
    
        local response = fRequest({
            Url = endpoint,
            Method = "POST",
            Body = lEncode(body),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        });
    
        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);
    
            if decoded.success == true then
                if decoded.data.valid == true then
                    if useNonce then
                        if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                            return true;
                        else
                            onMessage("failed to verify integrity.");
                            return false;
                        end    
                    else
                        return true;
                    end
                else
                    onMessage("key is invalid.");
                    return false;
                end
            else
                if fStringSub(decoded.message, 1, 27) == "unique constraint violation" then
                    onMessage("you already have an active key, please wait for it to expire before redeeming it.");
                    return false;
                else
                    onMessage(decoded.message);
                    return false;
                end
            end
        elseif response.StatusCode == 429 then
            onMessage("you are being rate limited, please wait 20 seconds and try again.");
            return false;
        else
            onMessage("server returned an invalid status code, please try again later.");
            return false; 
        end
    end
    
    --!optimize 2
    local verifyKey = function(key)
        if requestSending == true then
            return false, ("A request is already being sent, please slow down.");
        else
            requestSending = true;
        end
    
        local nonce = generateNonce();
        local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;
    
        if useNonce then
            endpoint = endpoint .. "&nonce=" .. nonce;
        end
    
        local response = fRequest({
            Url = endpoint,
            Method = "GET",
        });
    
        requestSending = false;
    
        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);
    
            if decoded.success == true then
                if decoded.data.valid == true then
                    if useNonce then
                        if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                            return true, "";
                        else
                            return false, ("failed to verify integrity.");
                        end
                    else
                        return true;
                    end
                else
                    if fStringSub(key, 1, 4) == "KEY_" then
                        return true, redeemKey(key);
                    else
                        return false, ("Key is invalid.");
                    end
                end
            else
                return false, (decoded.message);
            end
        elseif response.StatusCode == 429 then
            return false, ("You are being rate limited, please wait 20 seconds and try again.");
        else
            return false, ("Server returned an invalid status code, please try again later.");
        end
    end
    
    --!optimize 2
    local getFlag = function(name)
        local nonce = generateNonce();
        local endpoint = host .. "/public/flag/" .. fToString(service) .. "?name=" .. name;
    
        if useNonce then
            endpoint = endpoint .. "&nonce=" .. nonce;
        end
    
        local response = fRequest({
            Url = endpoint,
            Method = "GET",
        });
    
        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);
    
            if decoded.success == true then
                if useNonce then
                    if decoded.data.hash == lDigest(fToString(decoded.data.value) .. "-" .. nonce .. "-" .. secret) then
                        return decoded.data.value;
                    else
                        onMessage("failed to verify integrity.");
                        return nil;
                    end
                else
                    return decoded.data.value;
                end
            else
                onMessage(decoded.message);
                return nil;
            end
        else
            return nil;
        end
    end
    
    
    return {
        Verify = verifyKey,
        GetFlag = getFlag,
        Copy = copyLink,
    }
end


return Platoboost
end)()

-- ── utils/services/Init.lua ──
_VYNX_MODULES["utils/services/Init.lua"] = (function()
return {
	platoboost = {
		Name = "Platoboost",
		Icon = "rbxassetid://75920162824531",
		Args = { "ServiceId", "Secret" },
		New = require("./Platoboost").New,
	},
	pandadevelopment = {
		Name = "Panda Development",
		Icon = "panda",
		Args = { "ServiceId" },
		New = require("./PandaDevelopment").New,
	},
	luarmor = {
		Name = "Luarmor",
		Icon = "rbxassetid://130918283130165",
		Args = { "ScriptId", "Discord" },
		New = require("./Luarmor").New,
	},
	junkiedevelopment = {
		Name = "Junkie Development",
		Icon = "rbxassetid://106310347705078",
		Args = { "ServiceId", "ApiKey", "Provider" },
		New = require("./JunkieDevelopment").New,
	},
}

end)()

-- ── components/ConfigManager.lua ──
_VYNX_MODULES["components/ConfigManager.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance) return instance end)


local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))

local Window 

local ConfigManager
ConfigManager = {
    Folder = nil,
    Path = nil,
    Configs = {},
    Parser = {
        Colorpicker = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Default:ToHex(),
                    transparency = obj.Transparency or nil,
                }
            end,
            Load = function(element, data)
                if element and element.Update then
                    element:Update(Color3.fromHex(data.value), data.transparency or nil)
                end
            end
        },
        Dropdown = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Select then
                    element:Select(data.value)
                end
            end
        },
        Input = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
        Keybind = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
        RadioGroup = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Get and obj:Get() or obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Select then
                    element:Select(data.value, false)
                end
            end
        },
        CheckboxGroup = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Get and obj:Get() or obj.Values,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value or {}, false)
                end
            end
        },
        SegmentedControl = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Get and obj:Get() or obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Select then
                    element:Select(data.value, false)
                end
            end
        },
        TextArea = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Get and obj:Get() or obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value or "", false)
                end
            end
        },
        Slider = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value.Default,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(tonumber(data.value))
                end
            end
        },
        Stepper = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Get and obj:Get() or obj.Value.Default,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(tonumber(data.value), false)
                end
            end
        },
        TabBox = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Get and obj:Get() or obj.SelectedValue,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
        ChipList = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Get and obj:Get() or obj.Values,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value, false)
                end
            end
        },
        Toggle = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
    }
}

function ConfigManager:Init(WindowTable)
    if not WindowTable.Folder then
        warn("[ WindUI.ConfigManager ] Window.Folder is not specified.")
        return false
    end
    if RunService:IsStudio() or not writefile then
        warn("[ WindUI.ConfigManager ] The config system doesn't work in the studio.")
        return false
    end
    
    Window = WindowTable
    ConfigManager.Folder = Window.Folder
    ConfigManager.Path = "WindUI/" .. tostring(ConfigManager.Folder) .. "/config/"
    
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
    end
    
    local files = ConfigManager:AllConfigs()
    
    for _, configName in next, files do
        local configPath = ConfigManager.Path .. tostring(configName) .. ".json"
        if isfile and readfile and isfile(configPath) then
            local success, content = pcall(function()
                return readfile(configPath)
            end)
            if success then
                ConfigManager.Configs[configName] = content
            end
        end
    end
    
    return ConfigManager
end

function ConfigManager:SetPath(customPath)
    if not customPath then
        warn("[ WindUI.ConfigManager ] Custom path is not specified.")
        return false
    end
    
    ConfigManager.Path = customPath
    if not customPath:match("/$") then
        ConfigManager.Path = customPath .. "/"
    end
    
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
    end
    
    return true
end

function ConfigManager:CreateConfig(configFilename, autoload)
    local ConfigModule = {
        Path = ConfigManager.Path .. configFilename .. ".json",
        Elements = {},
        CustomData = {},
        AutoLoad = autoload or false,
        Version = 1.2,
    }
    
    if not configFilename then
        return false, "No config file is selected"
    end
    
    function ConfigModule:SetAsCurrent()
        Window:SetCurrentConfig(ConfigModule)
    end
    
    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
    end
    
    function ConfigModule:Set(key, value)
        ConfigModule.CustomData[key] = value
    end
    
    function ConfigModule:Get(key)
        return ConfigModule.CustomData[key]
    end
    
    function ConfigModule:SetAutoLoad(Value)
        ConfigModule.AutoLoad = Value
    end
    
    function ConfigModule:Save()
        if Window.PendingFlags then
            for flag, element in next, Window.PendingFlags do
                ConfigModule:Register(flag, element)
            end
        end
        
        local saveData = {
            __version = ConfigModule.Version,
            __elements = {},
            __autoload = ConfigModule.AutoLoad,
            __custom = ConfigModule.CustomData
        }
        
        for name, element in next, ConfigModule.Elements do
            if ConfigManager.Parser[element.__type] then
                saveData.__elements[tostring(name)] = ConfigManager.Parser[element.__type].Save(element)
            end
        end
        
        local jsonData = HttpService:JSONEncode(saveData)
        if writefile then
            local success, err = pcall(function()
                writefile(ConfigModule.Path, jsonData)
            end)
            if not success then
                return false, "Failed to save config: " .. tostring(err)
            end
        else
            return false, "writefile function is not available"
        end
        
        return saveData
    end
    
    function ConfigModule:Load()
        if isfile and not isfile(ConfigModule.Path) then 
            return false, "Config file does not exist" 
        end
        
        local success, loadData = pcall(function()
            local readfile = readfile or function() 
                warn("[ WindUI.ConfigManager ] The config system doesn't work in the studio.") 
                return nil 
            end
            return HttpService:JSONDecode(readfile(ConfigModule.Path))
        end)
        
        if not success then
            return false, "Failed to parse config file"
        end
        
        if not loadData.__version then
            local migratedData = {
                __version = ConfigModule.Version,
                __elements = loadData,
                __custom = {}
            }
            loadData = migratedData
        end
        
        if Window.PendingFlags then
            for flag, element in next, Window.PendingFlags do
                ConfigModule:Register(flag, element)
            end
        end
        
        Window.PendingConfigData = loadData.__elements or {}

        for name, data in next, (loadData.__elements or {}) do
            if typeof(data) == "table" and ConfigModule.Elements[name] and ConfigManager.Parser[data.__type] then
                task.spawn(function()
                    local success, err = pcall(function()
                        ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
                    end)
                    if not success then
                        warn("[ WindUI.ConfigManager ] Failed to load element '" .. tostring(name) .. "': " .. tostring(err))
                    end
                end)
            end
        end
        
        ConfigModule.CustomData = loadData.__custom or {}
        
        return ConfigModule.CustomData
    end
    
    function ConfigModule:Delete()
        if not delfile then
            return false, "delfile function is not available"
        end
        
        if not isfile(ConfigModule.Path) then
            return false, "Config file does not exist"
        end
        
        local success, err = pcall(function()
            delfile(ConfigModule.Path)
        end)
        
        if not success then
            return false, "Failed to delete config file: " .. tostring(err)
        end
        
        ConfigManager.Configs[configFilename] = nil
        
        if Window.CurrentConfig == ConfigModule then
            Window.CurrentConfig = nil
        end
        
        return true, "Config deleted successfully"
    end
    
    function ConfigModule:GetData()
        return {
            elements = ConfigModule.Elements,
            custom = ConfigModule.CustomData,
            autoload = ConfigModule.AutoLoad
        }
    end
    
    
    if isfile(ConfigModule.Path) then
        local success, configData = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigModule.Path))
        end)
        
        if success and configData and configData.__autoload then
            ConfigModule.AutoLoad = true
            
            task.spawn(function()
                task.wait(0.5)
                local success, result = pcall(function()
                    return ConfigModule:Load()
                end)
                if success then
                    if Window.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: " .. configFilename) end
                else
                    warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: " .. configFilename .. " - " .. tostring(result))
                end
            end)
        end
    end
    
    
    ConfigModule:SetAsCurrent()
    ConfigManager.Configs[configFilename] = ConfigModule
    return ConfigModule
end

function ConfigManager:Config(configFilename, autoload)
    return ConfigManager:CreateConfig(configFilename, autoload)
end

function ConfigManager:GetAutoLoadConfigs()
    local autoloadConfigs = {}
    
    for configName, configModule in pairs(ConfigManager.Configs) do
        if configModule.AutoLoad then
            table.insert(autoloadConfigs, configName)
        end
    end
    
    return autoloadConfigs
end

function ConfigManager:DeleteConfig(configName)
    if not delfile then
        return false, "delfile function is not available"
    end
    
    local configPath = ConfigManager.Path .. configName .. ".json"
    
    if not isfile(configPath) then
        return false, "Config file does not exist"
    end
    
    local success, err = pcall(function()
        delfile(configPath)
    end)
    
    if not success then
        return false, "Failed to delete config file: " .. tostring(err)
    end
    
    ConfigManager.Configs[configName] = nil
    
    if Window.CurrentConfig and Window.CurrentConfig.Path == configPath then
        Window.CurrentConfig = nil
    end
    
    return true, "Config deleted successfully"
end

function ConfigManager:AllConfigs()
    if not listfiles then return {} end
    
    local files = {}
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
        return files
    end
    
    for _, file in next, listfiles(ConfigManager.Path) do
        local name = file:match("([^\\/]+)%.json$")
        if name then
            table.insert(files, name)
        end
    end
    
    return files
end

function ConfigManager:GetConfig(configName)
    return ConfigManager.Configs[configName]
end

return ConfigManager

end)()

-- ── components/Notification.lua ──
_VYNX_MODULES["components/Notification.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")

local New = Creator.New
local Tween = Creator.Tween

local HOLDER_SIDE_MARGIN = 14
local HOLDER_TOP = 58
local HOLDER_BOTTOM = 72
local HOLDER_MAX_WIDTH = 356
local HOLDER_MIN_WIDTH = 240
local CARD_RADIUS = 18
local CARD_PADDING = 10
local CARD_GAP = 8
local ICON_SIZE = 30
local AVATAR_SIZE = 40
local CLOSE_SIZE = 44
local CLOSE_SURFACE_SIZE = 24
local CLOSE_RESERVED = 30
local ACTION_HEIGHT = 36
local MAX_ACTIONS = 2
local MAX_TITLE_HEIGHT = 38
local MAX_CONTENT_HEIGHT = 48
local PROGRESS_HEIGHT = 2
local MAX_VISIBLE = 4
local ENTER_OFFSET = 18
local EXIT_OFFSET = 14
local SHADOW_OFFSET = 4

local NOTIFICATION_STYLES = {
	Info = {
		Icon = "info",
		Color = Color3.fromHex("#60A5FA"),
	},
	Notice = {
		Icon = "bell",
		Color = Color3.fromHex("#38BDF8"),
	},
	Success = {
		Icon = "circle-check",
		Color = Color3.fromHex("#34D399"),
	},
	Warning = {
		Icon = "triangle-alert",
		Color = Color3.fromHex("#FBBF24"),
	},
	Error = {
		Icon = "circle-x",
		Color = Color3.fromHex("#FB7185"),
	},
	Neutral = {
		Icon = "message-circle",
		Color = Color3.fromHex("#A1A1AA"),
	},
}

local STYLE_ALIASES = {
	default = "Info",
	info = "Info",
	notice = "Notice",
	message = "Notice",
	success = "Success",
	successful = "Success",
	ok = "Success",
	green = "Success",
	warn = "Warning",
	warning = "Warning",
	caution = "Warning",
	error = "Error",
	fail = "Error",
	failed = "Error",
	danger = "Error",
	neutral = "Neutral",
}

local APPEARANCE_ALIASES = {
	default = "Compact",
	compact = "Compact",
	minimal = "Compact",
	pill = "Compact",
	capsule = "Compact",
	card = "Card",
	avatar = "Card",
	glass = "Glass",
	legacy = "Glass",
}

local NotificationModule = {
	Holder = nil,
	NotificationIndex = 0,
	Notifications = {},
}

local function ResolveColor(Value, Fallback)
	if typeof(Value) == "Color3" then
		return Value
	end

	if typeof(Value) == "string" and string.sub(Value, 1, 1) == "#" then
		local Success, Color = pcall(Color3.fromHex, Value)
		if Success then
			return Color
		end
	end

	return Fallback
end

local function NormalizeStyleName(Value)
	local Key = tostring(Value or "Info"):lower():gsub("%s+", "")
	return STYLE_ALIASES[Key] or "Info"
end

local function NormalizeAppearance(Value, Config)
	if Value == nil and (Config.Avatar ~= nil or Config.Timestamp ~= nil or Config.Time ~= nil) then
		return "Card"
	end
	local Key = tostring(Value or "Compact"):lower():gsub("%s+", "")
	return APPEARANCE_ALIASES[Key] or "Compact"
end

local function ResolveDuration(Value)
	if Value == false then
		return false
	end

	local Number = tonumber(Value)
	if Number == nil then
		return 5
	end

	return math.max(Number, 0)
end

local function NormalizeIcon(Value)
	if typeof(Value) == "number" then
		return "rbxassetid://" .. tostring(Value)
	end
	if typeof(Value) == "string" then
		return Value
	end
	if typeof(Value) == "table" or typeof(Value) == "Instance" then
		return Value
	end
	return nil
end

local function PaintIcon(Icon, Color, Transparency)
	if typeof(Icon) ~= "Instance" then
		return
	end

	local Targets = {}
	if Icon:IsA("ImageLabel") or Icon:IsA("ImageButton") then
		table.insert(Targets, Icon)
	end

	for _, Descendant in Icon:GetDescendants() do
		if Descendant:IsA("ImageLabel") or Descendant:IsA("ImageButton") then
			table.insert(Targets, Descendant)
		end
	end

	for _, Target in Targets do
		Target.ImageColor3 = Color
		if Transparency ~= nil then
			Target.ImageTransparency = Transparency
		end
	end
end

local function CreateCorner(Radius, Corners)
	local Corner = New("UICorner", {
		CornerRadius = UDim.new(0, Radius),
	})
	return Creator.ApplyCornerRadii(Corner, Radius, Corners)
end

local function ResolveCornerValue(Corners, Name, Default)
	local Value = Corners[Name]
	if Value == nil then
		Value = Corners[Name .. "Radius"]
	end
	if Value == nil then
		return Default
	end
	return Value
end

local function GetActions(Buttons)
	local Actions = {}
	if typeof(Buttons) ~= "table" then
		return Actions
	end

	for Index = 1, math.min(#Buttons, MAX_ACTIONS) do
		local Action = Buttons[Index]
		if typeof(Action) == "table" then
			table.insert(Actions, Action)
		end
	end

	return Actions
end

local function TrimNotifications(MaxVisible, AvailableHeight)
	local Active = {}
	for _, Notification in NotificationModule.Notifications do
		if not Notification.Closed then
			table.insert(Active, Notification)
		end
	end

	table.sort(Active, function(A, B)
		return A.Index < B.Index
	end)

	local TotalHeight = math.max(#Active - 1, 0) * CARD_GAP
	for _, Notification in Active do
		TotalHeight = TotalHeight + (Notification.LayoutHeight or 64)
	end

	while #Active > 1 and (#Active > MaxVisible or TotalHeight > AvailableHeight) do
		local Oldest = table.remove(Active, 1)
		TotalHeight = TotalHeight - (Oldest.LayoutHeight or 64) - CARD_GAP
		Oldest:Close("Overflow")
	end
end

function NotificationModule.Init(Parent)
	local NotModule = {
		Lower = false,
	}

	NotModule.Frame = New("Frame", {
		Name = "NotificationHolder",
		Position = UDim2.new(1, -HOLDER_SIDE_MARGIN, 0, HOLDER_TOP),
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(1, -(HOLDER_SIDE_MARGIN * 2), 1, -(HOLDER_TOP + HOLDER_BOTTOM)),
		Parent = Parent,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		ZIndex = 100,
	}, {
		New("UISizeConstraint", {
			MinSize = Vector2.new(HOLDER_MIN_WIDTH, 0),
			MaxSize = Vector2.new(HOLDER_MAX_WIDTH, 10000),
		}),
		New("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, CARD_GAP),
		}),
	})

	function NotModule.SetLower(Value)
		NotModule.Lower = Value == true
		local Bottom = if NotModule.Lower then 12 else HOLDER_BOTTOM
		NotModule.Frame.Size = UDim2.new(1, -(HOLDER_SIDE_MARGIN * 2), 1, -(HOLDER_TOP + Bottom))
	end

	NotificationModule.Holder = NotModule.Frame
	return NotModule
end

function NotificationModule.New(Config)
	Config = if typeof(Config) == "table" then Config else {}

	local StyleName = NormalizeStyleName(Config.Style or Config.Type or Config.Variant)
	local Appearance = NormalizeAppearance(Config.Appearance or Config.Layout, Config)
	local Style = NOTIFICATION_STYLES[StyleName] or NOTIFICATION_STYLES.Info
	local AccentColor = ResolveColor(Config.AccentColor or Config.Color, Style.Color)
	local IconValue
	local RequestedIcon = if Config.Avatar ~= nil then Config.Avatar else Config.Icon
	if RequestedIcon == false or RequestedIcon == "" then
		IconValue = nil
	elseif RequestedIcon ~= nil then
		IconValue = NormalizeIcon(RequestedIcon)
	else
		IconValue = Style.Icon
	end
	local Decorated = Config.Decorated == true or Config.Accented == true or Appearance == "Glass"

	local Notification = {
		Title = tostring(Config.Title or "Notification"),
		Content = Config.Content ~= nil and tostring(Config.Content) or nil,
		Icon = IconValue,
		IsAvatar = Config.Avatar ~= nil,
		IconThemed = Config.IconThemed,
		IconColor = ResolveColor(
			Config.IconColor,
			if Decorated
					or Config.AccentColor ~= nil
					or Config.Color ~= nil
				then AccentColor
				else Color3.fromHex("#A1A1AA")
		),
		Style = StyleName,
		Appearance = Appearance,
		Decorated = Decorated,
		Timestamp = Config.Timestamp ~= nil and tostring(Config.Timestamp)
			or (Config.Time ~= nil and tostring(Config.Time) or nil),
		AccentColor = AccentColor,
		ProgressColor = ResolveColor(Config.ProgressColor, AccentColor),
		Background = Config.Background,
		BackgroundImageTransparency = Creator.ClampTransparency(Config.BackgroundImageTransparency, 0.35),
		Duration = ResolveDuration(Config.Duration),
		Buttons = GetActions(Config.Buttons),
		CanClose = Config.CanClose ~= false,
		PauseOnHover = Config.PauseOnHover ~= false,
		OnOpen = Config.OnOpen,
		OnClose = Config.OnClose,
		UIElements = {},
		Closed = false,
		Paused = false,
	}

	NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
	Notification.Index = NotificationModule.NotificationIndex
	NotificationModule.Notifications[Notification.Index] = Notification

	local Holder = Config.Holder or NotificationModule.Holder
	assert(Holder, "Notification holder is not initialized")

	local IsCard = Notification.Appearance == "Card"
	local CardPadding = if IsCard then 12 else CARD_PADDING
	local CardRadius = math.max(tonumber(Config.Radius) or (IsCard and 20 or CARD_RADIUS), 8)
	local CornerConfig = if typeof(Config.Corners or Config.CornerRadii) == "table"
		then Config.Corners or Config.CornerRadii
		else Config
	local CardCorners = {
		TopLeft = ResolveCornerValue(CornerConfig, "TopLeft", CardRadius),
		TopRight = ResolveCornerValue(CornerConfig, "TopRight", CardRadius),
		BottomRight = ResolveCornerValue(CornerConfig, "BottomRight", CardRadius),
		BottomLeft = ResolveCornerValue(CornerConfig, "BottomLeft", CardRadius),
	}
	local IconSize = if IsCard then AVATAR_SIZE else ICON_SIZE
	local TimestampWidth = if Notification.Timestamp then 72 else 0
	local HasTimer = typeof(Notification.Duration) == "number" and Notification.Duration > 0
	local LeftSpace = Notification.Icon and (IconSize + 9) or 0
	local RightSpace = (Notification.CanClose and CLOSE_RESERVED or 0) + TimestampWidth
	local UseShadow = Config.Shadow ~= false
	local CardThemeTag = {
		BackgroundColor3 = "Notification",
	}
	if Config.Transparency == nil then
		CardThemeTag.BackgroundTransparency = "NotificationTransparency"
	end
	local ProgressTween
	local TimerToken = 0
	local TimerRemaining = if HasTimer then Notification.Duration else 0
	local TimerStartedAt
	local Opened = false
	local CanTrim = false
	local TargetHeight = 64
	local Connections = {}

	local function Connect(Signal, Callback)
		local Connection = Signal:Connect(Callback)
		table.insert(Connections, Connection)
		return Connection
	end

	local function AttachPress(Button, Amount)
		Connect(Button.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Motion.Press(Button, true, Amount)
			end
		end)
		Connect(Button.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Motion.Press(Button, false, Amount)
			end
		end)
		Connect(Button.MouseLeave, function()
			Motion.Press(Button, false, Amount)
		end)
	end

	local function AttachHover(Button, Target, HoverTransparency, RestTransparency)
		Connect(Button.MouseEnter, function()
			Motion.Play(
				Target,
				"Hover",
				{ BackgroundTransparency = HoverTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"Hover"
			)
		end)
		Connect(Button.MouseLeave, function()
			Motion.Play(
				Target,
				"Hover",
				{ BackgroundTransparency = RestTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"Hover"
			)
		end)
	end

	local function DisconnectSignals()
		for _, Connection in Connections do
			Connection:Disconnect()
		end
		table.clear(Connections)
	end

	local MainContainer = New("Frame", {
		Name = "NotificationContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = false,
		LayoutOrder = -Notification.Index,
		ZIndex = 100,
		Parent = Holder,
	})

	local MainScale = New("UIScale", {
		Name = "TransitionScale",
		Scale = 0.965,
	})

	local Main = New("CanvasGroup", {
		Name = "NotificationTransition",
		Active = true,
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, TargetHeight),
		Position = UDim2.new(0, ENTER_OFFSET, 0, 0),
		ClipsDescendants = false,
		ZIndex = 101,
		Parent = MainContainer,
	}, {
		MainScale,
	})

	local Shadow = New("Frame", {
		Name = "Shadow",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.78,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -4, 1, -4),
		Position = UDim2.new(0, 2, 0, SHADOW_OFFSET),
		Visible = UseShadow,
		ZIndex = 101,
		Parent = Main,
	}, {
		CreateCorner(CardRadius, CardCorners),
	})

	local CardStroke = New("UIStroke", {
		Color = Color3.new(1, 1, 1),
		Transparency = 0.76,
		Thickness = 1,
		ThemeTag = {
			Color = "NotificationBorder",
			Transparency = "NotificationBorderTransparency",
		},
	})

	local Card = New("Frame", {
		Name = "Notification",
		BackgroundColor3 = Color3.fromRGB(24, 25, 29),
		BackgroundTransparency = Creator.ClampTransparency(Config.Transparency, 0.08),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		ZIndex = 102,
		ThemeTag = CardThemeTag,
		Parent = Main,
	}, {
		CreateCorner(CardRadius, CardCorners),
		CardStroke,
	})
	Card:SetAttribute("Appearance", Notification.Appearance)
	Card:SetAttribute("LayoutVersion", 2)

	local NativeShadow
	if UseShadow then
		NativeShadow = Creator.CreateUIShadow(Card, {
			Name = "NativeShadow",
			BlurRadius = Creator.ToUDimRadius(Config.ShadowBlur, UDim.new(0, 16)),
			Color = ResolveColor(Config.ShadowColor, Color3.new(0, 0, 0)),
			Offset = if typeof(Config.ShadowOffset) == "UDim2" then Config.ShadowOffset else UDim2.fromOffset(0, 5),
			Spread = if typeof(Config.ShadowSpread) == "UDim2" then Config.ShadowSpread else UDim2.fromOffset(2, 2),
			Transparency = Creator.ClampTransparency(Config.ShadowTransparency, 0.58),
			ZIndex = 0,
		})
	end
	Shadow.Visible = UseShadow and NativeShadow == nil

	local CapsuleSurface = New("Frame", {
		Name = "CapsuleSurface",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = if Notification.Appearance == "Glass" then 0.955 else 0.985,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 103,
		ThemeTag = {
			BackgroundColor3 = "Notification2",
			BackgroundTransparency = "Notification2Transparency",
		},
		Parent = Card,
	}, {
		CreateCorner(CardRadius, CardCorners),
	})

	if typeof(Notification.Background) == "string" and Notification.Background ~= "" then
		New("ImageLabel", {
			Name = "Background",
			Image = Notification.Background,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ImageTransparency = Notification.BackgroundImageTransparency,
			ZIndex = 104,
			Parent = Card,
		}, {
			CreateCorner(CardRadius, CardCorners),
		})
	end

	local ToneWash = New("Frame", {
		Name = "ToneWash",
		BackgroundColor3 = Notification.AccentColor,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Visible = Notification.Decorated,
		ZIndex = 105,
		Parent = Card,
	}, {
		CreateCorner(CardRadius, CardCorners),
		New("UIGradient", {
			Rotation = 18,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.42),
				NumberSequenceKeypoint.new(0.38, 0.86),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	local AccentLine = New("Frame", {
		Name = "AccentLine",
		BackgroundColor3 = Notification.AccentColor,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 3, 0.48, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Visible = Notification.Decorated,
		ZIndex = 106,
		Parent = Card,
	}, {
		CreateCorner(3, {
			TopLeft = CardCorners.TopLeft,
			TopRight = 3,
			BottomRight = 3,
			BottomLeft = CardCorners.BottomLeft,
		}),
		New("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.32, 0.08),
				NumberSequenceKeypoint.new(0.68, 0.08),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	local TopHighlight = New("Frame", {
		Name = "TopHighlight",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.new(0.72, 0, 0, 1),
		Position = UDim2.new(0.14, 0, 0, 0),
		ZIndex = 106,
		Parent = Card,
	}, {
		New("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0.15),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	local Body = New("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -(CardPadding * 2), 0, 0),
		Position = UDim2.fromOffset(CardPadding, CardPadding),
		ZIndex = 107,
		Parent = Card,
	})

	local BodyLayout = New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = Body,
	})

	local HeaderRow = New("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, math.max(Notification.Icon and IconSize or 0, 20)),
		LayoutOrder = 1,
		ZIndex = 107,
		Parent = Body,
	})

	local Timestamp
	if Notification.Timestamp then
		Timestamp = New("TextLabel", {
			Name = "Timestamp",
			Text = Notification.Timestamp,
			TextSize = 11,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(TimestampWidth, 18),
			Position = UDim2.new(1, -(Notification.CanClose and CLOSE_RESERVED or 0), 0, 1),
			AnchorPoint = Vector2.new(1, 0),
			TextTransparency = 0.22,
			ZIndex = 109,
			ThemeTag = {
				TextColor3 = "NotificationContent",
			},
			Parent = HeaderRow,
		})
	end

	local TextContainer = New("Frame", {
		Name = "TextContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -(LeftSpace + RightSpace), 0, 0),
		Position = UDim2.fromOffset(LeftSpace, 0),
		ZIndex = 108,
		Parent = HeaderRow,
	})

	local TextLayout = New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		Parent = TextContainer,
	})

	local Title = New("TextLabel", {
		Name = "Title",
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = Notification.Title,
		TextWrapped = IsCard or Config.Wrap == true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = if IsCard then 15 else 14,
		LineHeight = 1,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		LayoutOrder = 1,
		ZIndex = 108,
		ThemeTag = {
			TextColor3 = "NotificationTitle",
			TextTransparency = "NotificationTitleTransparency",
		},
		Parent = TextContainer,
	}, {
		New("UISizeConstraint", {
			MinSize = Vector2.new(0, 18),
			MaxSize = Vector2.new(10000, MAX_TITLE_HEIGHT),
		}),
	})

	local Content = New("TextLabel", {
		Name = "Content",
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = Notification.Content or "",
		TextWrapped = IsCard or Config.Wrap == true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = 12,
		LineHeight = 1.05,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
		LayoutOrder = 2,
		Visible = Notification.Content ~= nil,
		ZIndex = 108,
		ThemeTag = {
			TextColor3 = "NotificationContent",
			TextTransparency = "NotificationContentTransparency",
		},
		Parent = TextContainer,
	}, {
		New("UISizeConstraint", {
			MinSize = Vector2.new(0, 16),
			MaxSize = Vector2.new(10000, MAX_CONTENT_HEIGHT),
		}),
	})

	local IconBubble
	if Notification.Icon then
		local IconIsGlyph = not Notification.IsAvatar
			and (
				type(Notification.Icon) ~= "string"
				or (Notification.Icon:match("^rbxassetid://") == nil and Notification.Icon:match("^https?://") == nil)
			)
		local Icon = Creator.Image(
			Notification.Icon,
			Notification.Title .. ":" .. tostring(Notification.Icon),
			Notification.IsAvatar and IconSize / 2 or 0,
			Config.Window and Config.Window.Folder,
			"Notification",
			true,
			Notification.IconThemed
		)
		Icon.Name = "Icon"
		Icon.Size = if Notification.IsAvatar
			then UDim2.fromScale(1, 1)
			else UDim2.fromOffset(if IsCard then 22 else 18, if IsCard then 22 else 18)
		Icon.Position = UDim2.fromScale(0.5, 0.5)
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.ZIndex = 110
		if IconIsGlyph and Creator.Icon(Notification.Icon) and Notification.IconThemed ~= true then
			PaintIcon(Icon, Notification.IconColor, 0)
		end

		IconBubble = New("Frame", {
			Name = "IconBubble",
			BackgroundColor3 = if Notification.IsAvatar then Color3.new(1, 1, 1) else Notification.IconColor,
			BackgroundTransparency = if Notification.IsAvatar then 0.9 elseif Notification.Decorated then 0.88 else 0.95,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(IconSize, IconSize),
			ClipsDescendants = true,
			ZIndex = 109,
			Parent = HeaderRow,
		}, {
			CreateCorner(IconSize / 2),
			New("UIStroke", {
				Color = Notification.IconColor,
				Transparency = if Notification.Decorated then 0.72 else 0.88,
				Thickness = 1,
			}),
			New("UIGradient", {
				Rotation = 35,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Notification.AccentColor:Lerp(Color3.new(1, 1, 1), 0.16)),
					ColorSequenceKeypoint.new(1, Notification.AccentColor),
				}),
			}),
			Icon,
		})
	end

	local CloseButton
	local CloseSurface
	if Notification.CanClose then
		local CloseIconData = Creator.Icon("x")
		CloseSurface = New("Frame", {
			Name = "Surface",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.98,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(CLOSE_SURFACE_SIZE, CLOSE_SURFACE_SIZE),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 109,
			ThemeTag = {
				BackgroundColor3 = "Notification2",
			},
		}, {
			CreateCorner(CLOSE_SURFACE_SIZE / 2),
			New("ImageLabel", {
				Name = "Icon",
				Image = CloseIconData and CloseIconData[1] or "",
				ImageRectSize = CloseIconData and CloseIconData[2] and CloseIconData[2].ImageRectSize or Vector2.zero,
				ImageRectOffset = CloseIconData and CloseIconData[2] and CloseIconData[2].ImageRectPosition
					or Vector2.zero,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(14, 14),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = 0.46,
				ZIndex = 110,
				ThemeTag = {
					ImageColor3 = "NotificationTitle",
				},
			}),
		})

		CloseButton = New("TextButton", {
			Name = "CloseButton",
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(CLOSE_SIZE, CLOSE_SIZE),
			Position = UDim2.new(1, 4, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ZIndex = 109,
			Parent = HeaderRow,
		}, {
			CloseSurface,
		})
		AttachPress(CloseButton, 0.96)
		AttachHover(CloseButton, CloseSurface, 0.91, 0.98)
	end

	local ActionRow
	if #Notification.Buttons > 0 then
		ActionRow = New("Frame", {
			Name = "Actions",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, ACTION_HEIGHT),
			LayoutOrder = 2,
			ZIndex = 107,
			Parent = Body,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
			Parent = ActionRow,
		})

		for Index, Action in Notification.Buttons do
			local IsPrimary = Index == 1
			local ButtonSize
			if #Notification.Buttons == 2 then
				ButtonSize = UDim2.new(0.5, -3, 0, ACTION_HEIGHT)
			else
				ButtonSize = UDim2.new(1, 0, 0, ACTION_HEIGHT)
			end

			local RestTransparency = if IsPrimary then 0.16 else 0.93
			local ActionStroke = New("UIStroke", {
				Color = if IsPrimary then Notification.AccentColor else Color3.new(1, 1, 1),
				Transparency = if IsPrimary then 0.55 else 0.78,
				Thickness = 1,
				ThemeTag = if IsPrimary
					then nil
					else {
						Color = "NotificationBorder",
						Transparency = "NotificationBorderTransparency",
					},
			})

			local ActionButton = New("TextButton", {
				Name = "Action" .. Index,
				Text = tostring(Action.Title or Action.Text or "Action"),
				TextSize = 12,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				AutoButtonColor = false,
				BackgroundColor3 = if IsPrimary then Notification.AccentColor else Color3.new(1, 1, 1),
				BackgroundTransparency = RestTransparency,
				BorderSizePixel = 0,
				Size = ButtonSize,
				LayoutOrder = Index,
				ZIndex = 108,
				ThemeTag = if IsPrimary
					then {
						TextColor3 = "White",
					}
					else {
						BackgroundColor3 = "Notification2",
						TextColor3 = "NotificationTitle",
					},
				Parent = ActionRow,
			}, {
				CreateCorner(9),
				ActionStroke,
			})
			AttachPress(ActionButton, 0.97)
			AttachHover(ActionButton, ActionButton, if IsPrimary then 0.06 else 0.87, RestTransparency)

			Connect(ActionButton.MouseButton1Click, function()
				Creator.SafeCallback(Action.Callback, Notification, Action)
				if Action.Close ~= false and Action.CloseOnClick ~= false then
					Notification:Close("Action")
				end
			end)
		end
	end

	local AnimateProgress = HasTimer and Motion:IsEnabled() and not Motion.Reduced
	local ProgressTrack = New("Frame", {
		Name = "ProgressTrack",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.new(0.32, 0, 0, PROGRESS_HEIGHT),
		Position = UDim2.new(0.5, 0, 1, -5),
		AnchorPoint = Vector2.new(0.5, 1),
		Visible = HasTimer,
		ZIndex = 111,
		ThemeTag = {
			BackgroundColor3 = "NotificationDuration",
			BackgroundTransparency = "NotificationDurationTransparency",
		},
		Parent = Card,
	}, {
		CreateCorner(PROGRESS_HEIGHT),
	})

	local ProgressFill = New("Frame", {
		Name = "ProgressFill",
		BackgroundColor3 = Notification.ProgressColor,
		BackgroundTransparency = Creator.ClampTransparency(Config.ProgressTransparency, 0.12),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 112,
		Parent = ProgressTrack,
	}, {
		CreateCorner(PROGRESS_HEIGHT),
		New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Notification.ProgressColor),
				ColorSequenceKeypoint.new(1, Notification.ProgressColor:Lerp(Color3.new(1, 1, 1), 0.22)),
			}),
		}),
	})

	local function UpdateContainerHeight(Animate)
		local BodyHeight = math.max(math.ceil(BodyLayout.AbsoluteContentSize.Y), HeaderRow.Size.Y.Offset)
		TargetHeight = CardPadding + BodyHeight + CardPadding
		Notification.LayoutHeight = TargetHeight
		Main.Size = UDim2.new(1, 0, 0, TargetHeight)

		if Opened then
			if Animate == false then
				MainContainer.Size = UDim2.new(1, 0, 0, TargetHeight)
			else
				Motion.Play(
					MainContainer,
					"Resize",
					{ Size = UDim2.new(1, 0, 0, TargetHeight) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Resize"
				)
			end
		end

		if CanTrim then
			local AvailableHeight = math.max(Holder.AbsoluteSize.Y, TargetHeight)
			TrimNotifications(math.max(math.floor(tonumber(Config.MaxVisible) or MAX_VISIBLE), 1), AvailableHeight)
		end
	end

	local function UpdateTextHeight()
		local TextHeight = math.max(math.ceil(TextLayout.AbsoluteContentSize.Y), 20)
		TextContainer.Size = UDim2.new(1, -(LeftSpace + RightSpace), 0, TextHeight)
		HeaderRow.Size = UDim2.new(1, 0, 0, math.max(TextHeight, Notification.Icon and IconSize or 0, 20))
		UpdateContainerHeight(Opened)
	end

	Connect(TextLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		UpdateTextHeight()
	end)
	Connect(BodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		UpdateContainerHeight(Opened)
	end)

	local function StopProgressTween()
		if ProgressTween then
			ProgressTween:Cancel()
			ProgressTween = nil
		end
	end

	local function CaptureRemainingTime()
		if TimerStartedAt then
			TimerRemaining = math.max(TimerRemaining - (os.clock() - TimerStartedAt), 0)
			TimerStartedAt = nil
		end
		Notification.Remaining = TimerRemaining
	end

	local function SetProgressRatio(Ratio)
		ProgressFill.Size = UDim2.new(math.clamp(Ratio, 0, 1), 0, 1, 0)
	end

	local function StartTimer()
		if not HasTimer or not Opened or Notification.Closed or Notification.Paused then
			return
		end

		if TimerRemaining <= 0 then
			Notification:Close("Timeout")
			return
		end

		TimerToken = TimerToken + 1
		local CurrentToken = TimerToken
		TimerStartedAt = os.clock()
		Notification.Remaining = TimerRemaining

		StopProgressTween()
		local Ratio = TimerRemaining / Notification.Duration
		SetProgressRatio(Ratio)
		if AnimateProgress then
			ProgressTween = Tween(
				ProgressFill,
				TimerRemaining,
				{ Size = UDim2.new(0, 0, 1, 0) },
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.InOut
			)
			ProgressTween:Play()
		end

		task.delay(TimerRemaining, function()
			if CurrentToken == TimerToken and not Notification.Closed and not Notification.Paused then
				TimerRemaining = 0
				Notification.Remaining = 0
				Notification:Close("Timeout")
			end
		end)
	end

	function Notification:Pause()
		if not HasTimer or Notification.Closed or Notification.Paused then
			return Notification
		end

		Notification.Paused = true
		TimerToken = TimerToken + 1
		CaptureRemainingTime()
		StopProgressTween()
		SetProgressRatio(TimerRemaining / Notification.Duration)
		return Notification
	end

	function Notification:Resume()
		if not HasTimer or Notification.Closed or not Notification.Paused then
			return Notification
		end

		Notification.Paused = false
		StartTimer()
		return Notification
	end

	function Notification:GetRemainingDuration()
		if not HasTimer then
			return 0
		end

		local Remaining = TimerRemaining
		if TimerStartedAt then
			Remaining = math.max(Remaining - (os.clock() - TimerStartedAt), 0)
		end
		return Remaining
	end

	function Notification:Update(Changes)
		if typeof(Changes) ~= "table" or Notification.Closed then
			return Notification
		end

		if Changes.Title ~= nil then
			Notification.Title = tostring(Changes.Title)
			Title.Text = Notification.Title
		end

		if Changes.Content ~= nil then
			Notification.Content = if Changes.Content == false then nil else tostring(Changes.Content)
			Content.Text = Notification.Content or ""
			Content.Visible = Notification.Content ~= nil
		end

		if Changes.Duration ~= nil then
			local WasPaused = Notification.Paused
			TimerToken = TimerToken + 1
			CaptureRemainingTime()
			StopProgressTween()
			Notification.Duration = ResolveDuration(Changes.Duration)
			HasTimer = typeof(Notification.Duration) == "number" and Notification.Duration > 0
			AnimateProgress = HasTimer and Motion:IsEnabled() and not Motion.Reduced
			TimerRemaining = if HasTimer then Notification.Duration else 0
			Notification.Remaining = TimerRemaining
			Notification.Paused = WasPaused
			ProgressTrack.Visible = HasTimer
			SetProgressRatio(if HasTimer then 1 else 0)
			StartTimer()
		end

		UpdateTextHeight()
		return Notification
	end

	function Notification:Close(Reason)
		if Notification.Closed then
			return Notification
		end

		Notification.Closed = true
		Notification.CloseReason = tostring(Reason or "Manual")
		TimerToken = TimerToken + 1
		CaptureRemainingTime()
		DisconnectSignals()
		StopProgressTween()

		Motion.Cancel(MainContainer, "Open")
		Motion.Cancel(MainContainer, "Resize")
		Motion.Cancel(Main, "Open")
		Motion.Cancel(MainScale, "Open")
		Motion.Play(
			MainContainer,
			"NotificationClose",
			{ Size = UDim2.new(1, 0, 0, 0) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Close"
		)
		Motion.Play(Main, "NotificationClose", {
			Position = UDim2.new(0, EXIT_OFFSET, 0, 0),
			GroupTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Close")
		Motion.Play(
			MainScale,
			"NotificationClose",
			{ Scale = 0.98 },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Close"
		)

		Creator.SafeCallback(Notification.OnClose, Notification, Notification.CloseReason)

		local CloseDelay = if Motion:IsEnabled() and not Motion.Reduced
			then Motion.GetDuration("NotificationClose") + 0.02
			else 0
		task.delay(CloseDelay, function()
			NotificationModule.Notifications[Notification.Index] = nil
			if MainContainer.Parent then
				MainContainer:Destroy()
			end
		end)

		return Notification
	end

	if CloseButton then
		Connect(CloseButton.MouseButton1Click, function()
			Notification:Close("Dismissed")
		end)
	end

	if Notification.PauseOnHover then
		Connect(Main.MouseEnter, function()
			Notification:Pause()
		end)
		Connect(Main.MouseLeave, function()
			Notification:Resume()
		end)
	end

	Notification.UIElements = {
		Container = MainContainer,
		Main = Card,
		Card = Card,
		Transition = Main,
		TransitionScale = MainScale,
		Shadow = Shadow,
		NativeShadow = NativeShadow,
		Stroke = CardStroke,
		Surface = CapsuleSurface,
		ToneWash = ToneWash,
		AccentLine = AccentLine,
		TopHighlight = TopHighlight,
		Body = Body,
		Header = HeaderRow,
		TextContainer = TextContainer,
		Title = Title,
		Content = Content,
		Timestamp = Timestamp,
		IconBubble = IconBubble,
		CloseButton = CloseButton,
		CloseSurface = CloseSurface,
		Actions = ActionRow,
		ProgressTrack = ProgressTrack,
		ProgressFill = ProgressFill,
	}

	UpdateTextHeight()
	CanTrim = true
	TrimNotifications(
		math.max(math.floor(tonumber(Config.MaxVisible) or MAX_VISIBLE), 1),
		math.max(Holder.AbsoluteSize.Y, TargetHeight)
	)

	task.spawn(function()
		task.wait()
		if Notification.Closed then
			return
		end

		UpdateTextHeight()
		Opened = true
		Motion.Play(
			MainContainer,
			"Notification",
			{ Size = UDim2.new(1, 0, 0, TargetHeight) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Open"
		)
		Motion.Play(Main, "Notification", {
			Position = UDim2.new(0, 0, 0, 0),
			GroupTransparency = 0,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Open")
		Motion.Play(MainScale, "Notification", { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Open")

		Creator.SafeCallback(Notification.OnOpen, Notification)
		StartTimer()
	end)

	return Notification
end

return NotificationModule

end)()

-- ── components/LoadingScreen.lua ──
_VYNX_MODULES["components/LoadingScreen.lua"] = (function()
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

end)()

-- ── components/KeySystem.lua ──
_VYNX_MODULES["components/KeySystem.lua"] = (function()
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

end)()

-- ── window/Element.lua ──
_VYNX_MODULES["window/Element.lua"] = (function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New
local NewRoundFrame = Creator.NewRoundFrame
local GoldenEffect = require("./GoldenEffect")

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))

local TagModule = require("../components/ui/Tag")

local function Color3ToHSB(color)
	local r, g, b = color.R, color.G, color.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h = 0
	if delta ~= 0 then
		if max == r then
			h = (g - b) / delta % 6
		elseif max == g then
			h = (b - r) / delta + 2
		else
			h = (r - g) / delta + 4
		end
		h = h * 60
	else
		h = 0
	end

	local s = (max == 0) and 0 or (delta / max)
	local v = max

	return {
		h = math.floor(h + 0.5),
		s = s,
		b = v,
	}
end

local function GetPerceivedBrightness(color)
	local r = color.R
	local g = color.G
	local b = color.B
	return 0.299 * r + 0.587 * g + 0.114 * b
end

local function GetTextColorForHSB(color)
	local hsb = Color3ToHSB(color)
	local h, s, b = hsb.h, hsb.s, hsb.b
	if GetPerceivedBrightness(color) > 0.5 then
		return Color3.fromHSV(h / 360, 0, 0.05)
	else
		return Color3.fromHSV(h / 360, 0, 0.98)
	end
end

local function Coalesce(...)
	for i = 1, select("#", ...) do
		local Value = select(i, ...)
		if Value ~= nil then
			return Value
		end
	end
	return nil
end

return function(Config)
	local Element = {
		Title = Config.Title,
		Desc = Config.Desc or nil,
		Hover = Config.Hover,
		Thumbnail = Config.Thumbnail,
		ThumbnailSize = Config.ThumbnailSize or 80,
		Image = Config.Image,
		IconThemed = Config.IconThemed or false,
		ImageSize = Config.ImageSize or 30,
		Color = Config.Color,
		Scalable = Config.Scalable,
		Parent = Config.Parent,
		Justify = Config.Justify or "Between", -- Center or Between
		UIPadding = Config.Window.ElementConfig.UIPadding,
		UICorner = Config.Window.ElementConfig.UICorner,
		Transparency = Coalesce(
			Config.Transparency,
			Config.ParentConfig and Config.ParentConfig.Transparency,
			Config.ParentConfig and Config.ParentConfig.ElementTransparency,
			Config.Window.ElementConfig.Transparency
		),
		GlassTransparency = Coalesce(
			Config.GlassTransparency,
			Config.ParentConfig and Config.ParentConfig.GlassTransparency,
			Config.Window.ElementConfig.GlassTransparency
		),
		LiquidGlass = Coalesce(
			Config.LiquidGlass,
			Config.ParentConfig and Config.ParentConfig.LiquidGlass,
			Config.ParentConfig and Config.ParentConfig.GlassLiquid,
			Config.Window.ElementConfig.LiquidGlass
		),
		Golden = Config.Golden == true
			or Config.Premium == true
			or (Config.ParentConfig and (Config.ParentConfig.Golden == true or Config.ParentConfig.Premium == true)),
		CornerStyle = Coalesce(
			Config.CornerStyle,
			Config.ParentConfig and Config.ParentConfig.CornerStyle,
			Config.ParentConfig and Config.ParentConfig.ElementCornerStyle,
			Config.Window.ElementConfig.CornerStyle
		),
		Size = Config.Size or "Default", -- Small, Default, Large
		Tags = Config.Tags or {},
		UIElements = {},

		Index = Config.Index,
		LinkCorners = Config.LinkCorners,
		CornerGroup = Config.CornerGroup or Config.LinkCornerGroup,
		CornerBreak = Config.CornerBreak,
		CornerBreakBefore = Config.CornerBreakBefore,
		CornerBreakAfter = Config.CornerBreakAfter,
	}

	local AddPaddingX = Element.Size == "Small" and -4 or Element.Size == "Large" and 4 or 0
	local AddPaddingY = Element.Size == "Small" and -4 or Element.Size == "Large" and 4 or 0

	local ImageSize = Element.ImageSize
	local ThumbnailSize = Element.ThumbnailSize
	local CanHover = true
	local Hovering = false
	local UseNativeCorners = Element.CornerStyle == "Native" or Element.CornerStyle == "PerCorner"
	local ElementTransparency = Creator.ClampTransparency(Element.Transparency, nil)
	local NativeBackground
	local NativeBackgroundCorner
	local NativeLiquidSheen
	local CurrentCorners = {
		TopLeft = true,
		TopRight = true,
		BottomLeft = true,
		BottomRight = true,
	}

	local IconOffset = 0

	local ThumbnailFrame
	local ImageFrame
	if Element.Thumbnail then
		ThumbnailFrame = Creator.Image(
			Element.Thumbnail,
			Element.Title,
			Config.Window.NewElements and Element.UICorner - 11 or (Element.UICorner - 4),
			Config.Window.Folder,
			"Thumbnail",
			false,
			Element.IconThemed
		)
		ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
	end
	if Element.Image then
		ImageFrame = Creator.Image(
			Element.Image,
			Element.Title,
			Config.Window.NewElements and Element.UICorner - 11 or (Element.UICorner - 4),
			Config.Window.Folder,
			"Image",
			Element.IconThemed,
			not Element.Color and true or false,
			"ElementIcon"
		)
		--print(Creator.Colors[Element.Color])
		if typeof(Element.Color) == "string" and not string.find(Element.Image, "rbxthumb") then
			ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
		elseif typeof(Element.Color) == "Color3" and not string.find(Element.Image, "rbxthumb") then
			ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
		end

		ImageFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)

		IconOffset = ImageSize
	end

	local function CreateText(Title, Type)
		local TextColor = typeof(Element.Color) == "string"
				and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
			or typeof(Element.Color) == "Color3" and GetTextColorForHSB(Element.Color)

		return New("TextLabel", {
			BackgroundTransparency = 1,
			Text = Title or "",
			TextSize = Type == "Desc" and 15 or 17,
			TextXAlignment = "Left",
			ThemeTag = {
				TextColor3 = not Element.Color and ("Element" .. Type) or nil,
			},
			TextColor3 = Element.Color and TextColor or nil,
			TextTransparency = Type == "Desc" and 0.3 or 0,
			TextWrapped = true,
			Size = UDim2.new(Element.Justify == "Between" and 1 or 0, 0, 0, 0),
			AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
			FontFace = Font.new(Creator.Font, Type == "Desc" and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
		})
	end

	local Title = CreateText(Element.Title, "Title")
	local Desc = CreateText(Element.Desc, "Desc")
	if not Element.Title or Element.Title == "" then
		Desc.Visible = false
	end
	if not Element.Desc or Element.Desc == "" then
		Desc.Visible = false
	end

	Element.UIElements.Title = Title
	Element.UIElements.Desc = Desc

	Element.UIElements.Container = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Element.UIPadding),
			FillDirection = "Vertical",
			VerticalAlignment = "Center",
			HorizontalAlignment = Element.Justify == "Between" and "Left" or "Center",
		}),
		ThumbnailFrame,
		New("Frame", {
			Size = UDim2.new(
				Element.Justify == "Between" and 1 or 0,
				Element.Justify == "Between" and -Config.TextOffset or 0,
				0,
				0
			),
			AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
			BackgroundTransparency = 1,
			Name = "TitleFrame",
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, Element.UIPadding),
				FillDirection = "Horizontal",
				VerticalAlignment = Config.Window.NewElements and (Element.Justify == "Between" and "Top" or "Center")
					or "Center",
				HorizontalAlignment = Element.Justify ~= "Between" and Element.Justify or "Center",
			}),
			ImageFrame,
			New("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
				Size = UDim2.new(
					Element.Justify == "Between" and 1 or 0,
					Element.Justify == "Between" and (ImageFrame and -IconOffset - Element.UIPadding or -IconOffset)
						or 0,
					1,
					0
				),
				Name = "TitleFrame",
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingY),
					PaddingLeft = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingX),
					PaddingRight = UDim.new(
						0,
						(Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingX
					),
					PaddingBottom = UDim.new(
						0,
						(Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingY
					),
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = "Vertical",
					VerticalAlignment = "Center",
					HorizontalAlignment = "Left",
				}),
				New("ScrollingFrame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					LayoutOrder = -99,
					BackgroundTransparency = 1,
					ScrollingDirection = "X",
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ScrollBarThickness = 0,
					Visible = false,
				}, {
					New("UIListLayout", {
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
						HorizontalAlignment = "Left",
						Padding = UDim.new(0, Config.Window.UIPadding / 2),
					}),
				}),
				New("Frame", {
					Name = "Space",
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Visible = false,
				}),
				Title,
				Desc,
			}),
		}),
	})

	for _, TagConfig in next, Config.Tags or {} do
		if not Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible then
			Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible = true
			Element.UIElements.Container.TitleFrame.TitleFrame.Space.Visible = true
		end
		local Tag = TagModule:New(TagConfig, Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame)
	end

	Creator.AddSignal(
		Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout:GetPropertyChangedSignal(
			"AbsoluteContentSize"
		),
		function()
			Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Size = UDim2.new(
				1,
				0,
				0,
				Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y
					/ Config.ParentConfig.UIScale
			)
		end
	)

	-- print(Config.Tab.Elements)
	-- print(Config.Index)
	-- print("Squircle")

	local LockedIcon = Creator.Image("lock", "lock", 0, Config.Window.Folder, "Lock", false)
	LockedIcon.Size = UDim2.new(0, 20, 0, 20)
	LockedIcon.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
	LockedIcon.ImageLabel.ImageTransparency = 0.4

	local LockedTitle = New("TextLabel", {
		Text = "Locked",
		TextSize = 18,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0.05,
	})

	local ElementFullFrame = New("Frame", {
		Size = UDim2.new(1, Element.UIPadding * 2, 1, Element.UIPadding * 2),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ZIndex = 9999999,
	})

	local Locked, LockedTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 0.25,
		ImageColor3 = Color3.new(0, 0, 0),
		Visible = false,
		Active = false,
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
		LockedIcon,
		LockedTitle,
	}, nil, true)

	local HighlightOutline, HighlightOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.25
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local Highlight, HighlightTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.88
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local HoverOutline, HoverOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.25
		Visible = false,
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
		New("UIGradient", {
			Name = "HoverGradient",
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.25, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.75, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	}, nil, true)

	local Hover, HoverTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.88
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIGradient", {
			Name = "HoverGradient",
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.25, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.75, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local function GetElementColor()
		if typeof(Element.Color) == "string" then
			return Color3.fromHex(Creator.Colors[Element.Color])
		end
		if typeof(Element.Color) == "Color3" then
			return Element.Color
		end
		return nil
	end

	local function GetBackgroundTransparency()
		if ElementTransparency ~= nil then
			return ElementTransparency
		end
		if Element.LiquidGlass then
			return Creator.ClampTransparency(Element.GlassTransparency, 0.24)
		end
		if Element.Color then
			return 0.05
		end
		if not Config.Window.NewElements then
			return 0.93
		end
		return nil
	end

	local function ApplyNativeCorners(Corners)
		CurrentCorners = Corners or CurrentCorners
		if NativeBackgroundCorner then
			Creator.ApplyCornerRadii(NativeBackgroundCorner, UDim.new(0, Element.UICorner), CurrentCorners)
		end
	end

	local function CreateLiquidGlassChildren()
		if not Element.LiquidGlass then
			return {}
		end

		NativeLiquidSheen = New("UIGradient", {
			Rotation = 25,
			Offset = Vector2.new(-0.35, 0),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.45, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.94),
				NumberSequenceKeypoint.new(0.45, 0.78),
				NumberSequenceKeypoint.new(1, 0.98),
			}),
		})

		return {
			New("UIStroke", {
				ApplyStrokeMode = "Border",
				Thickness = 1,
				Color = Color3.new(1, 1, 1),
				Transparency = 0.88,
			}),
			NativeLiquidSheen,
		}
	end

	local function CreateNativeBackground()
		NativeBackgroundCorner = New("UICorner", {
			CornerRadius = UDim.new(0, Element.UICorner),
		})

		local Children = {
			NativeBackgroundCorner,
		}

		for _, Child in next, CreateLiquidGlassChildren() do
			table.insert(Children, Child)
		end

		return New("Frame", {
			Name = "NativeBackground",
			Size = UDim2.new(1, Element.UIPadding * 2, 1, Element.UIPadding * 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = GetElementColor() or nil,
			BackgroundTransparency = GetBackgroundTransparency() or 0,
			ThemeTag = not Element.Color and {
				BackgroundColor3 = "ElementBackground",
				BackgroundTransparency = ElementTransparency == nil and not Element.LiquidGlass and "ElementBackgroundTransparency"
					or nil,
			} or nil,
			ZIndex = 0,
			Active = false,
		}, Children)
	end

	local MainChildren = {}
	if UseNativeCorners then
		NativeBackground = CreateNativeBackground()
		table.insert(MainChildren, NativeBackground)
	end

	table.insert(MainChildren, Element.UIElements.Container)
	table.insert(MainChildren, ElementFullFrame)
	table.insert(MainChildren, New("UIPadding", {
		PaddingTop = UDim.new(0, Element.UIPadding),
		PaddingLeft = UDim.new(0, Element.UIPadding),
		PaddingRight = UDim.new(0, Element.UIPadding),
		PaddingBottom = UDim.new(0, Element.UIPadding),
	}))

	local Main, MainTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		ImageTransparency = UseNativeCorners and 1 or GetBackgroundTransparency(),
		--Text = "",
		--TextTransparency = 1,
		--AutoButtonColor = false,
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = not UseNativeCorners
					and not Element.Color
					and (Config.Window.NewElements and "ElementBackground" or "Text")
				or nil,
			ImageTransparency = not UseNativeCorners
					and not Element.Color
					and ElementTransparency == nil
					and not Element.LiquidGlass
					and (Config.Window.NewElements and "ElementBackgroundTransparency" or nil)
				or nil,
		},
		ImageColor3 = not UseNativeCorners and GetElementColor() or nil,
	}, MainChildren, true, true)

	Element.UIElements.Main = Main
	Element.UIElements.Locked = Locked
	ApplyNativeCorners(CurrentCorners)

	if Element.Golden then
		Element.UIElements.GoldenEffect = GoldenEffect.Apply(ElementFullFrame, {
			Corner = Element.UICorner,
			Compact = Element.Size == "Small",
			FillTransparency = 0.8,
			OutlineTransparency = 0.18,
			SheenTransparency = 0.82,
		})

		Title.TextColor3 = Color3.fromRGB(255, 232, 144)
		Desc.TextColor3 = Color3.fromRGB(255, 224, 138)
		Desc.TextTransparency = math.min(Desc.TextTransparency + 0.08, 0.72)
	end

	if Element.Hover then
		Creator.AddSignal(Main.MouseMoved, function(x, y)
			if CanHover and Main.AbsoluteSize.X > 0 then
				Hover.HoverGradient.Offset = Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
				HoverOutline.HoverGradient.Offset =
					Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
				if NativeLiquidSheen then
					NativeLiquidSheen.Offset = Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
				end
			end
		end)

		Creator.AddSignal(Main.MouseEnter, function()
			if CanHover then
				--Tween(Main, 0.12, { ImageTransparency = Element.Color and 0.15 or 0.9 }):Play()
				HoverOutline.Visible = true
				Motion.Play(Hover, "Hover", { ImageTransparency = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Hover")
				Motion.Play(
					HoverOutline,
					"Hover",
					{ ImageTransparency = 0.8 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				if NativeBackground and Element.LiquidGlass then
					Motion.Play(
						NativeBackground,
						"Hover",
						{ BackgroundTransparency = math.max((ElementTransparency or Element.GlassTransparency or 0.24) - 0.06, 0) },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"Hover"
					)
				end
			end
		end)
		Creator.AddSignal(Main.InputEnded, function()
			if CanHover then
				--Tween(Main, 0.12, { ImageTransparency = Element.Color and 0.05 or 0.93 }):Play()
				Motion.Play(Hover, "Hover", { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Hover")
				Motion.Play(
					HoverOutline,
					"Hover",
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				if NativeBackground and Element.LiquidGlass then
					Motion.Play(
						NativeBackground,
						"Hover",
						{ BackgroundTransparency = GetBackgroundTransparency() or 0 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"Hover"
					)
				end
			end
		end)
		Creator.AddSignal(Main.MouseLeave, function()
			if CanHover then
				Motion.Play(Hover, "Hover", { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Hover")
				Motion.Play(
					HoverOutline,
					"Hover",
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				if NativeBackground and Element.LiquidGlass then
					Motion.Play(
						NativeBackground,
						"Hover",
						{ BackgroundTransparency = GetBackgroundTransparency() or 0 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"Hover"
					)
				end
			end
		end)
	end

	if Element.Scalable then
		Motion.AttachPress(Main, Creator, {
			Amount = 0.985,
			Enabled = function()
				return CanHover
			end,
		})
	end

	function Element:SetTitle(text)
		Element.Title = text
		Title.Text = text
	end

	function Element:SetDesc(text)
		Element.Desc = text
		Desc.Text = text or ""
		if not text then
			Desc.Visible = false
		elseif not Desc.Visible then
			Desc.Visible = true
		end
	end

	function Element:SetTransparency(value)
		ElementTransparency = Creator.ClampTransparency(value, ElementTransparency or 0)
		Element.Transparency = ElementTransparency

		if NativeBackground then
			Motion.Play(
				NativeBackground,
				"Focus",
				{ BackgroundTransparency = ElementTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"ElementTransparency"
			)
		else
			Motion.Play(
				Main,
				"Focus",
				{ ImageTransparency = ElementTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"ElementTransparency"
			)
		end
	end

	function Element:SetLiquidGlass(value)
		Element.LiquidGlass = value == true
		if NativeBackground then
			for _, Child in next, NativeBackground:GetChildren() do
				if Child:IsA("UIStroke") or Child:IsA("UIGradient") then
					pcall(function()
						Child.Enabled = Element.LiquidGlass
					end)
				end
			end
			if ElementTransparency == nil then
				NativeBackground.BackgroundTransparency = GetBackgroundTransparency() or 0
			end
		end
	end

	function Element:Colorize(obj, prop)
		if Element.Color then
			obj[prop] = typeof(Element.Color) == "string"
					and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
				or typeof(Element.Color) == "Color3" and GetTextColorForHSB(Element.Color)
				or nil
		end
	end

	if Config.ElementTable then
		Creator.AddSignal(Title:GetPropertyChangedSignal("Text"), function()
			if Element.Title ~= Title.Text then
				Element:SetTitle(Title.Text)
				Config.ElementTable.Title = Title.Text
			end
		end)
		Creator.AddSignal(Desc:GetPropertyChangedSignal("Text"), function()
			if Element.Desc ~= Desc.Text then
				Element:SetDesc(Desc.Text)
				Config.ElementTable.Desc = Desc.Text
			end
		end)
	end

	-- function Element:Show()

	-- end

	function Element:SetThumbnail(newThumbnail, newSize)
		Element.Thumbnail = newThumbnail
		if newSize then
			Element.ThumbnailSize = newSize
			ThumbnailSize = newSize
		end

		if ThumbnailFrame then
			if newThumbnail then
				ThumbnailFrame:Destroy()
				ThumbnailFrame = Creator.Image(
					newThumbnail,
					Element.Title,
					Element.UICorner - 3,
					Config.Window.Folder,
					"Thumbnail",
					false,
					Element.IconThemed
				)
				if ThumbnailFrame then
					ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
					ThumbnailFrame.Parent = Element.UIElements.Container
					local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
					if layout then
						ThumbnailFrame.LayoutOrder = -1
					end
				end
			else
				ThumbnailFrame.Visible = false
			end
		else
			if newThumbnail then
				ThumbnailFrame = Creator.Image(
					newThumbnail,
					Element.Title,
					Element.UICorner - 3,
					Config.Window.Folder,
					"Thumbnail",
					false,
					Element.IconThemed
				)
				if ThumbnailFrame then
					ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
					ThumbnailFrame.Parent = Element.UIElements.Container
					local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
					if layout then
						ThumbnailFrame.LayoutOrder = -1
					end
				end
			end
		end
	end

	function Element:SetImage(newImage, newSize)
		Element.Image = newImage
		if newSize then
			Element.ImageSize = newSize
			ImageSize = newSize
		end

		if newImage then
			local OldImageParent = ImageFrame and ImageFrame.Parent or Element.UIElements.Container.TitleFrame
			if ImageFrame then
				ImageFrame:Destroy()
			end

			ImageFrame = Creator.Image(
				newImage,
				newImage,
				Element.UICorner - 3,
				Config.Window.Folder,
				"Image",
				not Element.Color and true or false
			)
			if ImageFrame then
				if typeof(Element.Color) == "string" and not string.find(Element.Image, "rbxthumb") then
					ImageFrame.ImageLabel.ImageColor3 =
						GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
				elseif typeof(Element.Color) == "Color3" and not string.find(Element.Image, "rbxthumb") then
					ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
				end

				ImageFrame.Visible = true
				ImageFrame.Parent = OldImageParent
				ImageFrame.LayoutOrder = -99

				ImageFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)
				IconOffset = Element.ImageSize + Element.UIPadding
			end
		else
			if ImageFrame then
				ImageFrame.Visible = true
			end
			IconOffset = 0
		end

		Element.UIElements.Container.TitleFrame.TitleFrame.Size = UDim2.new(1, -IconOffset, 1, 0)
	end

	function Element:Destroy()
		Main:Destroy()
	end

	function Element:Lock(newtitle)
		CanHover = false
		Locked.Active = true
		Locked.Visible = true
		LockedTitle.Text = newtitle or "Locked"
	end

	function Element:Unlock()
		CanHover = true
		Locked.Active = false
		Locked.Visible = false
	end

	function Element:Highlight()
		local OutlineGradient = New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.9, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Rotation = 0,
			Offset = Vector2.new(-1, 0),
			Parent = HighlightOutline,
		})

		local HighlightGradient = New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.15, 0.8),
				NumberSequenceKeypoint.new(0.5, 0.1),
				NumberSequenceKeypoint.new(0.85, 0.8),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Rotation = 0,
			Offset = Vector2.new(-1, 0),
			Parent = Highlight,
		})

		HighlightOutline.ImageTransparency = 0.65
		Highlight.ImageTransparency = 0.88

		Motion.Play(OutlineGradient, "Highlight", {
			Offset = Vector2.new(1, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Highlight")

		Motion.Play(HighlightGradient, "Highlight", {
			Offset = Vector2.new(1, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Highlight")

		task.spawn(function()
			task.wait(Motion.GetDuration("Highlight"))
			HighlightOutline.ImageTransparency = 1
			Highlight.ImageTransparency = 1
			OutlineGradient:Destroy()
			HighlightGradient:Destroy()
		end)
	end

	function Element.UpdateShape(Tab)
		if Config.Window.NewElements then
			local ParentType = Config.ParentConfig
					and Config.ParentConfig.ParentTable
					and Config.ParentConfig.ParentTable.__type
				or Config.ParentType
			local ShouldLinkCorners = Config.Window.ElementConfig.LinkCorners
				or (Config.ParentConfig and Config.ParentConfig.LinkCorners == true)

			local newShape = "Squircle"
			local corners = {
				TopLeft = true,
				TopRight = true,
				BottomLeft = true,
				BottomRight = true,
			}

			if ShouldLinkCorners then
				newShape, corners = Creator.GetLinkedCornerShape(
					Tab.Elements,
					Element.Index,
					Tab,
					ParentType,
					Config.CornerLink
						or (Config.ParentConfig and Config.ParentConfig.CornerLink)
						or Config.Window.ElementConfig.CornerLink
				)
			end

			if newShape and Main then
				local DynamicShape = (newShape == "Squircle-TL-BL" or newShape == "Squircle-TR-BR") and "Squircle"
					or newShape

				MainTable:SetType(DynamicShape)
				LockedTable:SetType(DynamicShape)
				HighlightTable:SetType(DynamicShape)
				--HighlightOutlineTable:SetType(newShape .. "-Outline")
				HoverTable:SetType(DynamicShape)
				--HoverOutlineTable:SetType(newShape .. "-Outline")
				ApplyNativeCorners(corners)
			end
		end
	end

	--task.wait(.015)

	--Element:Show()

	return Element
end

end)()

-- ── window/GoldenEffect.lua ──
_VYNX_MODULES["window/GoldenEffect.lua"] = (function()
local TweenService = game:GetService("TweenService")

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
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

end)()

-- ── window/KeyBindMenu.lua ──
_VYNX_MODULES["window/KeyBindMenu.lua"] = (function()
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

end)()

-- ── window/Openbutton.lua ──
_VYNX_MODULES["window/Openbutton.lua"] = (function()
local OpenButton = {}

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local TextService = cloneref(game:GetService("TextService"))

local POSITION_PRESETS = {
	TopCenter = {
		Position = UDim2.new(0.5, 0, 0, 8),
		AnchorPoint = Vector2.new(0.5, 0),
	},
	TopLeft = {
		Position = UDim2.new(0, 14, 0, 8),
		AnchorPoint = Vector2.new(0, 0),
	},
	TopRight = {
		Position = UDim2.new(1, -14, 0, 8),
		AnchorPoint = Vector2.new(1, 0),
	},
	BottomCenter = {
		Position = UDim2.new(0.5, 0, 1, -14),
		AnchorPoint = Vector2.new(0.5, 1),
	},
	BottomLeft = {
		Position = UDim2.new(0, 14, 1, -14),
		AnchorPoint = Vector2.new(0, 1),
	},
	BottomRight = {
		Position = UDim2.new(1, -14, 1, -14),
		AnchorPoint = Vector2.new(1, 1),
	},
}

local STATE_ALIASES = {
	closed = "Collapsed",
	circle = "Collapsed",
	icon = "Collapsed",
	mini = "Collapsed",
	collapsed = "Collapsed",
	compact = "Compact",
	default = "Compact",
	pill = "Compact",
	open = "Expanded",
	expanded = "Expanded",
	dynamic = "Expanded",
}

local function Pick(Value, Fallback)
	if Value ~= nil then
		return Value
	end
	return Fallback
end

local function NormalizeState(Value)
	return STATE_ALIASES[tostring(Value or "Compact"):lower()] or "Compact"
end

local function NormalizeColorSequence(Value, Fallback)
	if typeof(Value) == "ColorSequence" then
		return Value
	end
	if typeof(Value) == "Color3" then
		return ColorSequence.new(Value)
	end
	return Fallback
end

local function GetInnerCornerRadius(CornerRadius, Inset)
	if typeof(CornerRadius) ~= "UDim" then
		return UDim.new(1, 0)
	end
	if CornerRadius.Scale ~= 0 then
		return UDim.new(CornerRadius.Scale, math.max(CornerRadius.Offset, 0))
	end
	return UDim.new(0, math.max(CornerRadius.Offset - Inset, 0))
end

local function MeasureText(Text, Size, MaxWidth)
	local Bounds =
		TextService:GetTextSize(tostring(Text or ""), Size, Enum.Font.GothamMedium, Vector2.new(MaxWidth, 1000))
	return math.ceil(Bounds.X), math.ceil(Bounds.Y)
end

function OpenButton.New(Window)
	local DefaultGradient = ColorSequence.new(Color3.fromHex("#40C9FF"), Color3.fromHex("#E81CFF"))
	local Settings = {
		Title = Window.Title or "Open",
		Content = nil,
		Icon = Window.Icon,
		Enabled = true,
		Visible = false,
		OnlyMobile = true,
		Draggable = true,
		Position = "TopCenter",
		State = "Compact",
		Height = 44,
		ExpandedHeight = 68,
		ExpandedWidth = 220,
		MaxWidth = 380,
		IconSize = 22,
		Padding = 12,
		Gap = 9,
		Scale = 1,
		CornerRadius = UDim.new(1, 0),
		StrokeThickness = 1,
		StrokeTransparency = 0.7,
		Color = DefaultGradient,
		BackgroundColor = Color3.fromRGB(7, 8, 11),
		BackgroundTransparency = 0.08,
		TextColor = nil,
		TextTransparency = nil,
		AutoCollapse = nil,
		OnStateChange = nil,
	}

	local OpenButtonMain = {
		Button = nil,
		Container = nil,
		IconSize = Settings.IconSize,
		Scale = Settings.Scale,
		State = Settings.State,
		Config = Settings,
		UIElements = {},
	}

	local StateToken = 0
	local ActiveTweens = {}
	local Icon
	local DragModule

	local Container = New("Frame", {
		Name = "OpenButtonContainer",
		Size = UDim2.fromOffset(Settings.Height, Settings.Height),
		Position = POSITION_PRESETS.TopCenter.Position,
		AnchorPoint = POSITION_PRESETS.TopCenter.AnchorPoint,
		Parent = Window.Parent,
		BackgroundTransparency = 1,
		Active = true,
		Visible = false,
		ZIndex = 98,
	})

	local UIScale = New("UIScale", {
		Name = "Scale",
		Scale = Settings.Scale,
		Parent = Container,
	})

	local Shadow = New("Frame", {
		Name = "Shadow",
		Size = UDim2.new(1, 4, 1, 4),
		Position = UDim2.fromOffset(-2, 3),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.58,
		BorderSizePixel = 0,
		ZIndex = 98,
		Parent = Container,
	}, {
		New("UICorner", {
			CornerRadius = Settings.CornerRadius,
		}),
	})

	local StrokeGradient = New("UIGradient", {
		Name = "UIGradient",
		Color = Settings.Color,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.12),
			NumberSequenceKeypoint.new(0.5, 0.52),
			NumberSequenceKeypoint.new(1, 0.18),
		}),
	})

	local Stroke = New("UIStroke", {
		Name = "UIStroke",
		Thickness = Settings.StrokeThickness,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.new(1, 1, 1),
		Transparency = Settings.StrokeTransparency,
	}, {
		StrokeGradient,
	})

	local Button = New("Frame", {
		Name = "OpenButton",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Settings.BackgroundColor,
		BackgroundTransparency = Settings.BackgroundTransparency,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
		ZIndex = 99,
		Parent = Container,
	}, {
		New("UICorner", {
			CornerRadius = Settings.CornerRadius,
		}),
		Stroke,
		New("Frame", {
			Name = "Surface",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.965,
			BorderSizePixel = 0,
			ZIndex = 99,
		}, {
			New("UICorner", {
				CornerRadius = Settings.CornerRadius,
			}),
			New("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.48),
					NumberSequenceKeypoint.new(0.45, 0.9),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		}),
	})

	local Drag = New("Frame", {
		Name = "Drag",
		Size = UDim2.fromOffset(36, 36),
		Position = UDim2.fromOffset(4, 4),
		BackgroundTransparency = 1,
		ZIndex = 102,
		Parent = Button,
	})

	local DragIcon = Creator.Image("move", "OpenButtonDrag", 0, Window.Folder, "OpenButton", true, true)
	DragIcon.Name = "Icon"
	DragIcon.Size = UDim2.fromOffset(17, 17)
	DragIcon.Position = UDim2.fromScale(0.5, 0.5)
	DragIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	DragIcon.Parent = Drag
	local DragImage = DragIcon:FindFirstChildWhichIsA("ImageLabel")
	if DragImage then
		DragImage.ImageTransparency = 0.42
	end

	local Divider = New("Frame", {
		Name = "Divider",
		Size = UDim2.new(0, 1, 1, -18),
		Position = UDim2.new(0, 44, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		ZIndex = 102,
		Parent = Button,
	})

	local MainAction = New("TextButton", {
		Name = "TextButton",
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.new(1, -45, 1, 0),
		Position = UDim2.fromOffset(45, 0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 101,
		Parent = Button,
	}, {
		New("UICorner", {
			CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4),
		}),
	})

	local HoverSurface = New("Frame", {
		Name = "HoverSurface",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 101,
		Parent = MainAction,
	}, {
		New("UICorner", {
			CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4),
		}),
	})

	local TextStack = New("CanvasGroup", {
		Name = "TextStack",
		Size = UDim2.new(1, -58, 1, 0),
		Position = UDim2.fromOffset(46, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 0,
		ZIndex = 103,
		Parent = MainAction,
	})

	local Title = New("TextLabel", {
		Name = "Title",
		Text = Settings.Title,
		TextSize = 15,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 103,
		ThemeTag = {
			TextColor3 = "Text",
		},
		Parent = TextStack,
	})

	local Description = New("TextLabel", {
		Name = "Content",
		Text = "",
		TextSize = 12,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.fromOffset(0, 35),
		BackgroundTransparency = 1,
		TextTransparency = 0.38,
		Visible = false,
		ZIndex = 103,
		ThemeTag = {
			TextColor3 = "Text",
		},
		Parent = TextStack,
	})

	local TrailingIcon = Creator.Image("chevron-up", "OpenButtonExpand", 0, Window.Folder, "OpenButton", true, true)
	TrailingIcon.Name = "TrailingIcon"
	TrailingIcon.Size = UDim2.fromOffset(15, 15)
	TrailingIcon.Position = UDim2.new(1, -17, 0.5, 0)
	TrailingIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	TrailingIcon.Visible = false
	TrailingIcon.ZIndex = 103
	TrailingIcon.Parent = MainAction
	local TrailingImage = TrailingIcon:FindFirstChildWhichIsA("ImageLabel")
	if TrailingImage then
		TrailingImage.ImageTransparency = 0.48
	end

	local function StopTween(Object)
		local Existing = ActiveTweens[Object]
		if Existing then
			Existing:Cancel()
			ActiveTweens[Object] = nil
		end
	end

	local function Animate(Object, Duration, Properties)
		StopTween(Object)
		if Duration <= 0 then
			for Name, Value in Properties do
				Object[Name] = Value
			end
			return nil
		end

		local Animation = Tween(Object, Duration, Properties, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		ActiveTweens[Object] = Animation
		Animation:Play()
		return Animation
	end

	local function ApplyPosition(Position)
		if typeof(Position) == "UDim2" then
			Container.Position = Position
			Container.AnchorPoint = Vector2.new(0.5, 0.5)
			return
		end

		local Preset = POSITION_PRESETS[tostring(Position or "TopCenter")] or POSITION_PRESETS.TopCenter
		Container.Position = Preset.Position
		Container.AnchorPoint = Preset.AnchorPoint
	end

	local function GetDragWidth(State, Height)
		if not Settings.Draggable or State == "Collapsed" then
			return 0
		end
		return Height
	end

	local function GetTargetSize(State)
		local Height = if State == "Expanded" then Settings.ExpandedHeight else Settings.Height
		if State == "Collapsed" then
			return Vector2.new(Settings.Height, Settings.Height)
		end

		local MaxTextWidth = math.max(Settings.MaxWidth - 120, 80)
		local TitleWidth = MeasureText(Settings.Title, 15, MaxTextWidth)
		local ContentWidth = if State == "Expanded" and Settings.Content
			then MeasureText(Settings.Content, 12, MaxTextWidth)
			else 0
		local TextWidth = math.max(TitleWidth, ContentWidth)
		local DragWidth = GetDragWidth(State, Height)
		local IconWidth = if Icon then Settings.IconSize + Settings.Gap else 0
		local TrailingWidth = if State == "Expanded" then 24 else 0
		local NaturalWidth = DragWidth + (Settings.Padding * 2) + IconWidth + TextWidth + TrailingWidth
		if State == "Expanded" then
			NaturalWidth = math.max(NaturalWidth, Settings.ExpandedWidth)
		end

		return Vector2.new(math.clamp(NaturalWidth, Height, Settings.MaxWidth), Height)
	end

	local function ApplyState(State, AnimateState)
		State = NormalizeState(State)
		local Duration = if AnimateState == false then 0 else 0.28
		local TargetSize = GetTargetSize(State)
		local DragWidth = GetDragWidth(State, TargetSize.Y)
		local ActionPadding = Settings.Padding
		local HasIcon = Icon ~= nil
		local IconOffset = if HasIcon then Settings.IconSize + Settings.Gap else 0
		local TrailingWidth = if State == "Expanded" then 24 else 0

		OpenButtonMain.State = State
		Settings.State = State
		Drag.Visible = DragWidth > 0
		Divider.Visible = DragWidth > 0
		Title.Visible = State ~= "Collapsed"
		Description.Visible = State == "Expanded" and Settings.Content ~= nil and Settings.Content ~= ""
		TrailingIcon.Visible = State == "Expanded"

		Animate(Container, Duration, { Size = UDim2.fromOffset(TargetSize.X, TargetSize.Y) })
		Animate(MainAction, Duration, {
			Size = UDim2.new(1, -DragWidth, 1, 0),
			Position = UDim2.fromOffset(DragWidth, 0),
		})

		Drag.Size = UDim2.fromOffset(math.max(TargetSize.Y - 8, 0), math.max(TargetSize.Y - 8, 0))
		Drag.Position = UDim2.fromOffset(4, 4)
		Divider.Position = UDim2.new(0, DragWidth, 0.5, 0)

		if Icon then
			local IconX = if State == "Collapsed" then TargetSize.X / 2 else ActionPadding + Settings.IconSize / 2
			Animate(Icon, Duration, {
				Position = UDim2.fromOffset(IconX, TargetSize.Y / 2),
				Size = UDim2.fromOffset(Settings.IconSize, Settings.IconSize),
			})
		end

		local TextX = ActionPadding + IconOffset
		TextStack.Position = UDim2.fromOffset(TextX, 0)
		TextStack.Size = UDim2.new(1, -(TextX + ActionPadding + TrailingWidth), 1, 0)
		Title.Size = if Description.Visible then UDim2.new(1, 0, 0, 22) else UDim2.fromScale(1, 1)
		Title.Position = if Description.Visible then UDim2.fromOffset(0, 13) else UDim2.fromOffset(0, 0)
		Description.Text = tostring(Settings.Content or "")

		Creator.SafeCallback(Settings.OnStateChange, State, OpenButtonMain)
	end

	function OpenButtonMain:SetIcon(NewIcon, SkipLayout)
		if Icon then
			Icon:Destroy()
			Icon = nil
		end

		Settings.Icon = NewIcon
		if NewIcon ~= nil and NewIcon ~= false and NewIcon ~= "" then
			Icon = Creator.Image(
				NewIcon,
				Settings.Title .. ":OpenButton",
				0,
				Window.Folder,
				"OpenButton",
				true,
				Window.IconThemed
			)
			Icon.Name = "Icon"
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.ZIndex = 103
			Icon.Parent = MainAction
		end

		if not SkipLayout then
			ApplyState(OpenButtonMain.State, false)
		end
		return OpenButtonMain
	end

	function OpenButtonMain:SetTitle(NewTitle)
		Settings.Title = tostring(NewTitle or "")
		Title.Text = Settings.Title
		Creator:ChangeTranslationKey(Title, Settings.Title)
		ApplyState(OpenButtonMain.State, true)
		return OpenButtonMain
	end

	function OpenButtonMain:SetContent(NewContent)
		Settings.Content = if NewContent == nil or NewContent == false then nil else tostring(NewContent)
		Description.Text = Settings.Content or ""
		ApplyState(OpenButtonMain.State, true)
		return OpenButtonMain
	end

	function OpenButtonMain:SetState(NewState, Changes, AnimateState)
		StateToken = StateToken + 1
		if typeof(Changes) == "table" then
			if Changes.Title ~= nil then
				Settings.Title = tostring(Changes.Title)
				Title.Text = Settings.Title
			end
			if Changes.Content ~= nil or Changes.Description ~= nil then
				local Content = if Changes.Content ~= nil then Changes.Content else Changes.Description
				Settings.Content = if Content == false then nil else tostring(Content or "")
			end
			if Changes.Icon ~= nil then
				OpenButtonMain:SetIcon(Changes.Icon, true)
			end
		end

		ApplyState(NewState, AnimateState)
		return OpenButtonMain
	end

	function OpenButtonMain:GetState()
		return OpenButtonMain.State
	end

	function OpenButtonMain:Expand(Changes, Duration)
		OpenButtonMain:SetState("Expanded", Changes)
		local Token = StateToken
		local Delay = tonumber(Duration) or tonumber(Settings.AutoCollapse)
		if Delay and Delay > 0 then
			task.delay(Delay, function()
				if Token == StateToken and Container.Parent then
					OpenButtonMain:SetState("Compact")
				end
			end)
		end
		return OpenButtonMain
	end

	function OpenButtonMain:Collapse(Changes)
		return OpenButtonMain:SetState("Collapsed", Changes)
	end

	function OpenButtonMain:Compact(Changes)
		return OpenButtonMain:SetState("Compact", Changes)
	end

	function OpenButtonMain:ToggleExpanded(Changes)
		if OpenButtonMain.State == "Expanded" then
			return OpenButtonMain:Compact(Changes)
		end
		return OpenButtonMain:Expand(Changes)
	end

	function OpenButtonMain:Push(Changes, Duration)
		local PreviousState = OpenButtonMain.State
		OpenButtonMain:SetState("Expanded", Changes)
		local Token = StateToken
		local Delay = math.max(tonumber(Duration) or 3, 0)
		task.delay(Delay, function()
			if Token == StateToken and Container.Parent then
				OpenButtonMain:SetState(PreviousState)
			end
		end)
		return OpenButtonMain
	end

	OpenButtonMain.Notify = OpenButtonMain.Push

	function OpenButtonMain:Visible(Value)
		Container.Visible = Value == true
		return OpenButtonMain
	end

	function OpenButtonMain:SetScale(Scale)
		Settings.Scale = math.max(tonumber(Scale) or 1, 0.1)
		OpenButtonMain.Scale = Settings.Scale
		StopTween(UIScale)
		UIScale.Scale = Settings.Scale
		return OpenButtonMain
	end

	function OpenButtonMain:Pulse()
		local BaseScale = Settings.Scale
		Animate(UIScale, 0.08, { Scale = BaseScale * 0.94 })
		task.delay(0.08, function()
			if UIScale.Parent then
				Animate(UIScale, 0.16, { Scale = BaseScale })
			end
		end)
		return OpenButtonMain
	end

	function OpenButtonMain:Edit(Config)
		Config = if typeof(Config) == "table" then Config else {}
		Settings.Title = tostring(Pick(Config.Title, Settings.Title))
		local Content = Pick(Config.Content, Pick(Config.Description, Settings.Content))
		Settings.Content = if Content == false or Content == nil then nil else tostring(Content)
		Settings.Enabled = Pick(Config.Enabled, Settings.Enabled)
		Settings.OnlyMobile = Pick(Config.OnlyMobile, Settings.OnlyMobile)
		Settings.Draggable = Pick(Config.Draggable, Settings.Draggable)
		Settings.Position = Pick(Config.Position, Pick(Config.Preset, Settings.Position))
		Settings.Height = math.max(tonumber(Pick(Config.Height, Settings.Height)) or 44, 34)
		Settings.ExpandedHeight =
			math.max(tonumber(Pick(Config.ExpandedHeight, Settings.ExpandedHeight)) or 68, Settings.Height)
		Settings.ExpandedWidth = math.max(tonumber(Pick(Config.ExpandedWidth, Settings.ExpandedWidth)) or 220, 120)
		Settings.MaxWidth = math.max(tonumber(Pick(Config.MaxWidth, Settings.MaxWidth)) or 380, Settings.ExpandedWidth)
		Settings.IconSize = math.max(tonumber(Pick(Config.IconSize, Settings.IconSize)) or 22, 12)
		Settings.Padding = math.max(tonumber(Pick(Config.Padding, Settings.Padding)) or 12, 4)
		Settings.Gap = math.max(tonumber(Pick(Config.Gap, Settings.Gap)) or 9, 0)
		Settings.CornerRadius = Pick(Config.CornerRadius, Settings.CornerRadius)
		Settings.StrokeThickness = math.max(tonumber(Pick(Config.StrokeThickness, Settings.StrokeThickness)) or 1, 0)
		Settings.StrokeTransparency =
			Creator.ClampTransparency(Pick(Config.StrokeTransparency, Settings.StrokeTransparency), 0.7)
		Settings.Scale = math.max(tonumber(Pick(Config.Scale, Settings.Scale)) or 1, 0.1)
		Settings.Color = NormalizeColorSequence(Config.Color, Settings.Color)
		Settings.BackgroundColor = Pick(Config.BackgroundColor, Settings.BackgroundColor)
		Settings.BackgroundTransparency = Creator.ClampTransparency(
			Pick(Config.BackgroundTransparency, Pick(Config.Transparency, Settings.BackgroundTransparency)),
			0.08
		)
		Settings.TextColor = Pick(Config.TextColor, Settings.TextColor)
		Settings.TextTransparency = Creator.ClampTransparency(
			Pick(Config.TextTransparency, Settings.TextTransparency),
			Settings.TextTransparency
		)
		Settings.AutoCollapse = Pick(Config.AutoCollapse, Settings.AutoCollapse)
		Settings.OnStateChange = Pick(Config.OnStateChange, Settings.OnStateChange)

		local RequestedState = Config.State or Config.Mode
		if Config.OnlyIcon == true or Config.Style == "Circle" then
			RequestedState = RequestedState or "Collapsed"
		elseif Config.OnlyIcon == false and RequestedState == nil then
			RequestedState = "Compact"
		end

		Window.IsOpenButtonEnabled = Settings.Enabled ~= false
		if Settings.OnlyMobile == false then
			Window.IsPC = false
		end
		if DragModule then
			DragModule:Set(Settings.Draggable)
		end

		ApplyPosition(Settings.Position)
		OpenButtonMain:SetScale(Settings.Scale)
		Button.BackgroundColor3 = Settings.BackgroundColor
		Button.BackgroundTransparency = Settings.BackgroundTransparency
		Button.UICorner.CornerRadius = Settings.CornerRadius
		MainAction.UICorner.CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4)
		HoverSurface.UICorner.CornerRadius = GetInnerCornerRadius(Settings.CornerRadius, 4)
		Shadow.UICorner.CornerRadius = Settings.CornerRadius
		Stroke.Thickness = Settings.StrokeThickness
		Stroke.Transparency = Settings.StrokeTransparency
		StrokeGradient.Color = Settings.Color
		Title.Text = Settings.Title
		Description.Text = tostring(Settings.Content or "")
		if Settings.TextColor then
			Title.TextColor3 = Settings.TextColor
			Description.TextColor3 = Settings.TextColor
		end
		if Settings.TextTransparency ~= nil then
			Title.TextTransparency = Settings.TextTransparency
		end

		if Config.Icon ~= nil then
			OpenButtonMain:SetIcon(Config.Icon, true)
		elseif not Icon and Settings.Icon then
			OpenButtonMain:SetIcon(Settings.Icon, true)
		end

		ApplyState(RequestedState or OpenButtonMain.State, Config.Animate ~= false)
		if Config.Visible ~= nil then
			OpenButtonMain:Visible(Config.Visible)
		end
		return OpenButtonMain
	end

	function OpenButtonMain:Destroy()
		StateToken = StateToken + 1
		local Objects = {}
		for Object in ActiveTweens do
			table.insert(Objects, Object)
		end
		for _, Object in Objects do
			StopTween(Object)
		end
		Container:Destroy()
	end

	Creator.AddSignal(MainAction.MouseEnter, function()
		Animate(HoverSurface, 0.12, { BackgroundTransparency = 0.94 })
	end)
	Creator.AddSignal(MainAction.MouseLeave, function()
		Animate(HoverSurface, 0.16, { BackgroundTransparency = 1 })
	end)
	Creator.AddSignal(MainAction.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			OpenButtonMain:Pulse()
		end
	end)

	DragModule = Creator.Drag(Container)
	OpenButtonMain.Button = Button
	OpenButtonMain.Container = Container
	OpenButtonMain.UIElements = {
		Container = Container,
		Button = Button,
		MainAction = MainAction,
		Drag = Drag,
		Divider = Divider,
		Title = Title,
		Content = Description,
		TextStack = TextStack,
		HoverSurface = HoverSurface,
		TrailingIcon = TrailingIcon,
		Stroke = Stroke,
		Shadow = Shadow,
		Scale = UIScale,
	}

	if Settings.Icon then
		OpenButtonMain:SetIcon(Settings.Icon)
	else
		ApplyState(Settings.State, false)
	end

	return OpenButtonMain
end

return OpenButton

end)()

-- ── window/Watermark.lua ──
_VYNX_MODULES["window/Watermark.lua"] = (function()
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

end)()

-- ── window/SettingsMenu.lua ──
_VYNX_MODULES["window/SettingsMenu.lua"] = (function()
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
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

end)()

-- ── window/Dialog.lua ──
_VYNX_MODULES["window/Dialog.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

-- local Window
-- local WindUI

local DialogModule = {
	Holder = nil,
	--Window = nil,
	Parent = nil,
}

function DialogModule.Create(Key, Type, Window, WindUI, Parent)
	local Dialog = {
		UICorner = 28,
		UIPadding = 12,

		Window = Window,
		WindUI = WindUI,

		UIElements = {},
	}

	if Key then
		Dialog.UIPadding = 0
	end -- 16
	if Key then
		Dialog.UICorner = 26
	end

	Type = Type or "Dialog"

	if not Key then
		Dialog.UIElements.FullScreen = New("Frame", {
			ZIndex = 999,
			BackgroundTransparency = 1, -- 0.65
			BackgroundColor3 = Color3.fromHex("#000000"),
			Size = UDim2.new(1, 0, 1, 0),
			Active = false, -- true
			Visible = false, -- true
			Parent = DialogModule.Parent
				or (Window and Window.UIElements and Window.UIElements.Main and Window.UIElements.Main.Main),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
	end

	local Blur = New("ImageLabel", { -- Shadow
		Image = "rbxassetid://8992230677",
		ThemeTag = {
			ImageColor3 = "WindowShadow",
			--ImageTransparency = "WindowShadowTransparency",
		},
		ImageTransparency = 1, -- .7
		Size = UDim2.new(1, 100, 1, 100),
		Position = UDim2.new(0, -100 / 2, 0, -100 / 2),
		ScaleType = "Slice",
		SliceCenter = Rect.new(99, 99, 99, 99),
		BackgroundTransparency = 1,
		ZIndex = -999999999999999,
		Name = "Blur",
	})

	Dialog.UIElements.Main = New("Frame", {
		Size = UDim2.new(0, 280, 0, 0),
		ThemeTag = {
			BackgroundColor3 = Type .. "Background",
		},
		AutomaticSize = "Y",
		BackgroundTransparency = 1, -- .7
		Visible = false,
		ZIndex = 99999,
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, Dialog.UIPadding),
			PaddingLeft = UDim.new(0, Dialog.UIPadding),
			PaddingRight = UDim.new(0, Dialog.UIPadding),
			PaddingBottom = UDim.new(0, Dialog.UIPadding),
		}),
	})

	Dialog.UIElements.MainContainer = Creator.NewRoundFrame(Dialog.UICorner, "Squircle", {
		Visible = false, -- true
		--GroupTransparency = 1, -- 0
		ImageTransparency = Key and 0.15 or 0,
		Parent = Parent or Dialog.UIElements.FullScreen,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = "XY",
		ThemeTag = {
			ImageColor3 = Type .. "Background",
			ImageTransparency = Type .. "BackgroundTransparency",
		},
		ZIndex = 9999,
	}, {
		--[[Creator.NewRoundFrame(Dialog.UICorner, "SquircleGlass", {
			ImageTransparency = 0.92,
			Size = UDim2.new(1, 2, 1, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
		}),]]
		Dialog.UIElements.Main,

		-- New("UIScale", {
		--     Scale = .9
		-- }),
		-- Creator.NewRoundFrame(Dialog.UICorner, "SquircleOutline2", {
		--     Size = UDim2.new(1,0,1,0),
		--     ImageTransparency = 1,
		--     ThemeTag = {
		--         ImageColor3 = "Outline",
		--     },
		-- }, {
		--     New("UIGradient", {
		--         Rotation = 45,
		--         Transparency = NumberSequence.new({
		--             NumberSequenceKeypoint.new(0, 0.55),
		--             NumberSequenceKeypoint.new(0.5, 0.8),
		--             NumberSequenceKeypoint.new(1, 0.6)
		--         })
		--     })
		-- })
	})

	function Dialog:Open()
		if not Key then
			Dialog.UIElements.FullScreen.Visible = true
			Dialog.UIElements.FullScreen.Active = true
		end

		task.spawn(function()
			Dialog.UIElements.MainContainer.Visible = true

			if not Key then
				Tween(Dialog.UIElements.FullScreen, 0.1, { BackgroundTransparency = 0.65 }):Play()
			end
			Tween(Dialog.UIElements.MainContainer, 0.1, { ImageTransparency = 0 }):Play()
			--Tween(Dialog.UIElements.MainContainer.UIScale, 0.1, {Scale = 1}):Play()
			--Tween(Dialog.UIElements.MainContainer.UIStroke, 0.1, {Transparency = 1}):Play()
			task.spawn(function()
				task.wait(0.05)
				Dialog.UIElements.Main.Visible = true
			end)
		end)
	end
	function Dialog:Close()
		if not Key then
			Tween(Dialog.UIElements.FullScreen, 0.1, { BackgroundTransparency = 1 }):Play()
			Dialog.UIElements.FullScreen.Active = false
			task.spawn(function()
				task.wait(0.1)
				Dialog.UIElements.FullScreen.Visible = false
			end)
		end
		Dialog.UIElements.Main.Visible = false

		Tween(Dialog.UIElements.MainContainer, 0.1, { ImageTransparency = 1 }):Play()
		--Tween(Dialog.UIElements.MainContainer.UIScale, 0.1, {Scale = .9}):Play()
		--Tween(Dialog.UIElements.MainContainer.UIStroke, 0.1, {Transparency = 1}):Play()

		task.spawn(function()
			task.wait(0.1)
			if not Key then
				Dialog.UIElements.FullScreen:Destroy()
			else
				Dialog.UIElements.MainContainer:Destroy()
			end
		end)

		return function() end
	end

	--Dialog:Open()
	return Dialog
end

return DialogModule

end)()

-- ── window/Section.lua ──
_VYNX_MODULES["window/Section.lua"] = (function()
local Section = {}


local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local TabModule = require("./Tab")

function Section.New(SectionConfig, Parent, Folder, UIScale, Window)
    local SectionModule = {
        Title = SectionConfig.Title or "Section",
        Icon = SectionConfig.Icon,
        IconThemed = SectionConfig.IconThemed,
        Opened = SectionConfig.Opened or false,
        
        HeaderSize = 42,
        IconSize = 18,
        
        Expandable = false,
    }
    
    local IconFrame
    if SectionModule.Icon then
        IconFrame = Creator.Image(
            SectionModule.Icon,
            SectionModule.Icon,
            0,
            Folder,
            "Section",
            true,
            SectionModule.IconThemed,
            "TabSectionIcon"
        )
        
        IconFrame.Size = UDim2.new(0,SectionModule.IconSize,0,SectionModule.IconSize)
        IconFrame.ImageLabel.ImageTransparency = .25
    end
    
    local ChevronIconFrame = New("Frame", {
        Size = UDim2.new(0,SectionModule.IconSize,0,SectionModule.IconSize),
        BackgroundTransparency = 1,
        Visible = false
    }, {
        New("ImageLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Image = Creator.Icon("chevron-down")[1],
            ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
            ThemeTag = {
                ImageColor3 = "Icon",
            },
            ImageTransparency = .7,
        })
    })
    
    local SectionFrame = New("Frame", {
        Size = UDim2.new(1,0,0,SectionModule.HeaderSize),
        BackgroundTransparency = 1,
        Parent = Parent,
        ClipsDescendants = true,
    }, {
        New("TextButton", {
            Size = UDim2.new(1,0,0,SectionModule.HeaderSize),
            BackgroundTransparency = 1,
            Text = "",
        }, {
            IconFrame,
            New("TextLabel", {
                Text = SectionModule.Title,
                TextXAlignment = "Left",
                Size = UDim2.new(
                    1, 
                    IconFrame and (-SectionModule.IconSize-10)*2
                        or (-SectionModule.IconSize-10),
                        
                    1,
                    0
                ),
                ThemeTag = {
                    TextColor3 = "Text",
                },
                FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                TextSize = 14,
                BackgroundTransparency = 1,
                TextTransparency = .7,
                --TextTruncate = "AtEnd",
                TextWrapped = true
            }),
            New("UIListLayout", {
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
                Padding = UDim.new(0,10)
            }),
            ChevronIconFrame,
            New("UIPadding", {
                PaddingLeft = UDim.new(0,11),
                PaddingRight = UDim.new(0,11),
            })
        }),
        New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            Name = "Content",
            Visible = true,
            Position = UDim2.new(0,0,0,SectionModule.HeaderSize)
        }, {
            New("UIListLayout", {
                FillDirection = "Vertical",
                Padding = UDim.new(0,Window.Gap),
                VerticalAlignment = "Bottom",
            }),
        })
    })
    
    
    function SectionModule:Tab(TabConfig)
        if not SectionModule.Expandable then
            SectionModule.Expandable = true
            ChevronIconFrame.Visible = true
        end
        TabConfig.Parent = SectionFrame.Content
        return TabModule.New(TabConfig, UIScale)
    end
    
    function SectionModule:Open()
        if SectionModule.Expandable then
            SectionModule.Opened = true
            Tween(SectionFrame, 0.33, {
                Size = UDim2.new(1,0,0, SectionModule.HeaderSize + (SectionFrame.Content.AbsoluteSize.Y/UIScale))
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            
            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 180}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
    function SectionModule:Close()
        if SectionModule.Expandable then
            SectionModule.Opened = false
            Tween(SectionFrame, 0.26, {
                Size = UDim2.new(1,0,0, SectionModule.HeaderSize)
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
    
    Creator.AddSignal(SectionFrame.TextButton.MouseButton1Click, function()
        if SectionModule.Expandable then
            if SectionModule.Opened then
                SectionModule:Close()
            else
                SectionModule:Open()
            end
        end
    end)
    
    Creator.AddSignal(SectionFrame.Content.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if SectionModule.Opened then
            SectionModule:Open()
        end
    end)
    
    if SectionModule.Opened then
        task.spawn(function()
            task.wait()
            SectionModule:Open()
        end)
    end

    
    
    return SectionModule
end


return Section
end)()

-- ── window/Tab.lua ──
_VYNX_MODULES["window/Tab.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = Players.LocalPlayer:GetMouse()

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local CreateToolTip = require("../components/ui/Tooltip").New
local CreateScrollSlider = require("../components/ui/ScrollSlider").New

local Window, WindUI, UIScale

local TabModule = {
	--Window = nil,
	--WindUI = nil,
	Tabs = {},
	Containers = {},
	SelectedTab = nil,
	TabCount = 0,
	ToolTipParent = nil,
	TabHighlight = nil,

	OnChangeFunc = function(v) end,
}

local function GetImageTarget(Object)
	if typeof(Object) ~= "Instance" then
		return nil
	end

	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return Object
	end

	return Object:FindFirstChildWhichIsA("ImageLabel", true) or Object:FindFirstChildWhichIsA("ImageButton", true)
end

function TabModule.Init(WindowTable, WindUITable, ToolTipParent, TabHighlight)
	Window = WindowTable
	WindUI = WindUITable
	TabModule.ToolTipParent = ToolTipParent
	TabModule.TabHighlight = TabHighlight
	return TabModule
end

function TabModule.New(Config, UIScale)
	local Tab = {
		__type = "Tab",
		Title = Config.Title or "Tab",
		Desc = Config.Desc,
		Icon = Config.Icon,
		Golden = Config.Golden == true or Config.Premium == true,
		Premium = Config.Premium == true or Config.Golden == true,
		IconColor = Config.IconColor
			or ((Config.Golden == true or Config.Premium == true) and Color3.fromRGB(255, 222, 105) or nil),
		IconShape = Config.IconShape,
		IconThemed = Config.IconThemed,
		Locked = Config.Locked,
		ShowTabTitle = Config.ShowTabTitle,
		TabTitleAlign = Config.TabTitleAlign or "Left",
		CustomEmptyPage = (Config.CustomEmptyPage and next(Config.CustomEmptyPage) ~= nil) and Config.CustomEmptyPage
			or { Icon = "lucide:frown", IconSize = 48, Title = "This tab is Empty", Desc = nil },
		Border = Config.Border,
		Selected = false,
		Index = nil,
		Parent = Config.Parent,
		UIElements = {},
		Elements = {},
		ContainerFrame = nil,
		UICorner = Window.UICorner - (Window.UIPadding / 2),
		LinkCorners = Config.LinkCorners == true,

		Gap = Config.Gap or Config.ElementGap or Window.ElementGap or (Window.NewElements and (Window.LiquidGlass and 6 or 1) or 6),

		TabPaddingX = 4 + (Window.UIPadding / 2),
		TabPaddingY = 3 + (Window.UIPadding / 2),
		TitlePaddingY = 0,
	}

	-- if Tab.TabTitleAlign == "Left" then
	-- 	Tab.TabTitleAlign = "Top"
	-- elseif Tab.TabTitleAlign == "Right" then
	-- 	Tab.TabTitleAlign = "Bottom"
	-- elseif Tab.TabTitleAlign == "Center" then
	-- 	Tab.TabTitleAlign = "Center"
	-- end

	if Tab.IconShape then
		Tab.TabPaddingX = 2 + (Window.UIPadding / 4)
		Tab.TabPaddingY = 2 + (Window.UIPadding / 4)
		Tab.TitlePaddingY = 2 + (Window.UIPadding / 4)
	end

	TabModule.TabCount = TabModule.TabCount + 1

	local TabIndex = TabModule.TabCount
	Tab.Index = TabIndex

	Tab.UIElements.Main = Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -7, 0, 0),
		AutomaticSize = "Y",
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = "TabBackground",
		},
		ImageTransparency = 1,
	}, {
		Creator.NewRoundFrame(Tab.UICorner - 1, "Glass-1.4", {
			Size = UDim2.new(1, 1, 1, 1),
			ThemeTag = {
				ImageColor3 = "TabBorder",
			},
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ImageTransparency = 1, -- .7
			Name = "Outline",
		}, {
			-- New("UIGradient", {
			--     Rotation = 80,
			--     Color = ColorSequence.new({
			--         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
			--         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			--         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
			--     }),
			--     Transparency = NumberSequence.new({
			--         NumberSequenceKeypoint.new(0.0, 0.1),
			--         NumberSequenceKeypoint.new(0.5, 1),
			--         NumberSequenceKeypoint.new(1.0, 0.1),
			--     })
				-- }),
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "ActiveRail",
			Size = UDim2.new(0, 3, 0, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}),
		Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			ThemeTag = {
				ImageColor3 = "Text",
			},
			ImageTransparency = 1, -- .95
			Name = "Frame",
		}, {
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 2 + (Window.UIPadding / 2)),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = not Tab.Golden and {
					TextColor3 = "TabTitle",
				} or nil,
				TextColor3 = Tab.Golden and Color3.fromRGB(255, 232, 144) or nil,
				TextTransparency = not Tab.Locked and (Tab.Golden and 0.12 or 0.4) or 0.7,
				TextSize = 15,
				Size = UDim2.new(1, 0, 0, 0),
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextWrapped = true,
				RichText = true,
				AutomaticSize = "Y",
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, Tab.TitlePaddingY),
					--PaddingLeft = UDim.new(0,2+(Window.UIPadding/2)),
					--PaddingRight = UDim.new(0,2+(Window.UIPadding/2)),
					PaddingBottom = UDim.new(0, Tab.TitlePaddingY),
				}),
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, Tab.TabPaddingY),
				PaddingLeft = UDim.new(0, Tab.TabPaddingX),
				PaddingRight = UDim.new(0, Tab.TabPaddingX),
				PaddingBottom = UDim.new(0, Tab.TabPaddingY),
			}),
		}),
	}, true)

	if Tab.Golden then
		Tab.UIElements.Main.Frame.ImageColor3 = Color3.fromRGB(64, 49, 18)
		Tab.UIElements.Main.Frame.ImageTransparency = 0.88
		Tab.UIElements.Main.Outline.ImageColor3 = Color3.fromRGB(255, 214, 92)
		Tab.UIElements.Main.Outline.ImageTransparency = 0.78
		Tab.UIElements.GoldenShine = New("UIGradient", {
			Rotation = 18,
			Offset = Vector2.new(-1, 0),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 185, 56)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 244, 184)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 94, 18)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.88),
				NumberSequenceKeypoint.new(0.48, 0.72),
				NumberSequenceKeypoint.new(0.55, 0.18),
				NumberSequenceKeypoint.new(0.64, 0.74),
				NumberSequenceKeypoint.new(1, 0.9),
			}),
			Parent = Tab.UIElements.Main.Frame,
		})

		if Motion:IsEnabled() and not Motion.Reduced then
			task.spawn(function()
				while Tab.UIElements.Main and Tab.UIElements.Main.Parent and Tab.UIElements.GoldenShine do
					Tab.UIElements.GoldenShine.Offset = Vector2.new(-1, 0)
					local Tween = TweenService:Create(
						Tab.UIElements.GoldenShine,
						TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{ Offset = Vector2.new(1, 0) }
					)
					Tween:Play()
					Tween.Completed:Wait()
					task.wait(1.1)
				end
			end)
		end
	end

	local TextOffset = 0
	local Icon
	local Icon2

	if Tab.Icon then
		Icon = Creator.Image(
			Tab.Icon,
			Tab.Icon .. ":" .. Tab.Title,
			0,
			Window.Folder,
			Tab.__type,
			Tab.IconColor and false or true,
			Tab.IconThemed,
			"TabIcon"
		)
		Icon.Size = UDim2.new(0, 16, 0, 16)
		local IconTarget = GetImageTarget(Icon)
		if Tab.IconColor and IconTarget then
			IconTarget.ImageColor3 = Tab.IconColor
		end
		if not Tab.IconShape then
			Icon.Parent = Tab.UIElements.Main.Frame
			Tab.UIElements.Icon = Icon
			if IconTarget then
				IconTarget.ImageTransparency = not Tab.Locked and 0 or 0.7
			end
			TextOffset = -16 - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		elseif Tab.IconColor then
			local _IconBG = Creator.NewRoundFrame(
				Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
				"Squircle",
				{
					Size = UDim2.new(0, 26, 0, 26),
					ImageColor3 = Tab.IconColor,
					Parent = Tab.UIElements.Main.Frame,
				},
				{
					Icon,
					Creator.NewRoundFrame(
						Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
						"Glass-1.4",
						{
							Size = UDim2.new(1, 0, 1, 0),
							ThemeTag = {
								ImageColor3 = "White",
							},
							ImageTransparency = 0,
							Name = "Outline",
						},
						{
							-- New("UIGradient", {
							--     Rotation = 45,
							--     Color = ColorSequence.new({
							--         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
							--     }),
							--     Transparency = NumberSequence.new({
							--         NumberSequenceKeypoint.new(0.0, 0.1),
							--         NumberSequenceKeypoint.new(0.5, 1),
							--         NumberSequenceKeypoint.new(1.0, 0.1),
							--     })
							-- }),
						}
					),
				}
			)
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
			if IconTarget then
				IconTarget.ImageTransparency = 0
				IconTarget.ImageColor3 = Creator.GetTextColorForHSB(Tab.IconColor, 0.68)
			end
			TextOffset = -26 - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		end

		Icon2 =
			Creator.Image(Tab.Icon, Tab.Icon .. ":" .. Tab.Title, 0, Window.Folder, Tab.__type, true, Tab.IconThemed)
		Icon2.Size = UDim2.new(0, 16, 0, 16)
		local Icon2Target = GetImageTarget(Icon2)
		if Icon2Target then
			Icon2Target.ImageTransparency = not Tab.Locked and 0 or 0.7
		end
		TextOffset = -30

		--Icon2.Parent = Tab.UIElements.Main.Frame
		--Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1,-30,0,0)
		--Tab.UIElements.Icon = Icon
	end

	Tab.UIElements.ContainerFrame = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, Tab.ShowTabTitle and -((Window.UIPadding * 2.4) + 12) or 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = "Never",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		AutomaticCanvasSize = "Y",
		--Visible = false,
		ScrollingDirection = "Y",
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingLeft = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingRight = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingBottom = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
		}),
		New("UIListLayout", {
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, Tab.Gap),
			HorizontalAlignment = "Center",
		}),
	})

	-- Tab.UIElements.ContainerFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	--     Tab.UIElements.ContainerFrame.CanvasSize = UDim2.new(0,0,0,Tab.UIElements.ContainerFrame.UIListLayout.AbsoluteContentSize.Y+Window.UIPadding*2)
	-- end)

	Tab.UIElements.ContainerFrameCanvas = New("CanvasGroup", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Visible = false,
		Parent = Window.UIElements.MainBar,
		ZIndex = 5,
	}, {
		Tab.UIElements.ContainerFrame,
		New("Frame", {
			Size = UDim2.new(1, -14, 1, -14),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Name = "ScrollSliderHolder",
		}),
		New("Frame", {
			Size = UDim2.new(1, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			BackgroundTransparency = 1,
			Visible = Tab.ShowTabTitle or false,
			Name = "TabTitle",
		}, {
			Icon2,
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 20,
				TextTransparency = 0.1,
				Size = UDim2.new(0, 0, 1, 0),
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				--TextTruncate = "AtEnd",
				RichText = true,
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
				AutomaticSize = "X",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 20),
			}),
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = Tab.TabTitleAlign,
			}),
		}),
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 0.9,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
			Position = UDim2.new(0, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			Visible = Tab.ShowTabTitle or false,
		}),
	})

	TabModule.Containers[TabIndex] = Tab.UIElements.ContainerFrameCanvas
	TabModule.Tabs[TabIndex] = Tab

	Tab.ContainerFrame = Tab.UIElements.ContainerFrameCanvas

	Creator.AddSignal(Tab.UIElements.Main.MouseButton1Click, function()
		if not Tab.Locked then
			TabModule:SelectTab(TabIndex)
		end
	end)

	Motion.AttachPress(Tab.UIElements.Main, Creator, {
		Amount = 0.985,
	})

	if Window.ScrollBarEnabled then
		CreateScrollSlider(
			Tab.UIElements.ContainerFrame,
			Tab.UIElements.ContainerFrameCanvas.ScrollSliderHolder,
			Window,
			4,
			WindUI
		)
	end

	local ToolTip
	local hoverTimer
	local MouseConn
	local IsHovering = false

	-- ToolTip
	if Tab.Desc then
		Creator.AddSignal(Tab.UIElements.Main.InputBegan, function()
			IsHovering = true
			hoverTimer = task.spawn(function()
				task.wait(0.35)
				if IsHovering and not ToolTip then
					ToolTip = CreateToolTip(Tab.Desc, TabModule.ToolTipParent, true)
					ToolTip.Container.AnchorPoint = Vector2.new(0.5, 0.5)

					local function updatePosition()
						if ToolTip then
							ToolTip.Container.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y - 4)
						end
					end

					updatePosition()
					MouseConn = Mouse.Move:Connect(updatePosition)
					ToolTip:Open()
				end
			end)
		end)
	end

	Creator.AddSignal(Tab.UIElements.Main.MouseEnter, function()
		if not Tab.Locked and not Tab.Selected then
			Creator.SetThemeTag(Tab.UIElements.Main.Frame, {
				ImageTransparency = "TabBackgroundHoverTransparency",
				ImageColor3 = "TabBackgroundHover",
			}, 0.1)
		end
	end)
	Creator.AddSignal(Tab.UIElements.Main.MouseLeave, function()
		if not Tab.Locked and not Tab.Selected then
			Motion.Play(Tab.UIElements.Main.Frame, "Hover", {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabHover")
		end
	end)
	Creator.AddSignal(Tab.UIElements.Main.InputEnded, function()
		if Tab.Desc then
			IsHovering = false
			if hoverTimer then
				task.cancel(hoverTimer)
				hoverTimer = nil
			end
			if MouseConn then
				MouseConn:Disconnect()
				MouseConn = nil
			end
			if ToolTip then
				ToolTip:Close()
				ToolTip = nil
			end
		end

		if not Tab.Locked and not Tab.Selected then
			Motion.Play(Tab.UIElements.Main.Frame, "Hover", {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabHover")
		end
	end)

	function Tab:ScrollToTheElement(elemindex)
		Tab.UIElements.ContainerFrame.ScrollingEnabled = false

		Motion.Play(Tab.UIElements.ContainerFrame, "Resize", {
			CanvasPosition = Vector2.new(
				0,
				Tab.Elements[elemindex].ElementFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
			),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "ScrollToElement")

		task.spawn(function()
			task.wait(Motion.GetDuration("Resize") + 0.03)

			if Tab.Elements[elemindex].Highlight then
				Tab.Elements[elemindex]:Highlight()
			end
			Tab.UIElements.ContainerFrame.ScrollingEnabled = true
		end)

		return Tab
	end

	-- yo

	local ElementsModule = require("../elements/Init")

	ElementsModule.Load(
		Tab,
		Tab.UIElements.ContainerFrame,
		ElementsModule.Elements,
		Window,
		WindUI,
		nil,
		ElementsModule,
		UIScale,
		Tab
	)

	function Tab:LockAll()
		--print("LockAll called, number of elements: " .. #self.Elements)
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Lock then
				element:Lock()
			end
		end
	end
	function Tab:UnlockAll()
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Unlock then
				element:Unlock()
			end
		end
	end
	function Tab:GetLocked()
		local LockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == true then
				table.insert(LockedElements, element)
			end
		end

		return LockedElements
	end
	function Tab:GetUnlocked()
		local UnlockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == false then
				table.insert(UnlockedElements, element)
			end
		end

		return UnlockedElements
	end

	function Tab:Select()
		return TabModule:SelectTab(Tab.Index)
	end

	task.spawn(function()
		local EmptyPageIcon
		if Tab.CustomEmptyPage.Icon then
			EmptyPageIcon =
				Creator.Image(Tab.CustomEmptyPage.Icon, Tab.CustomEmptyPage.Icon, 0, "Temp", "EmptyPage", true)
			EmptyPageIcon.Size =
				UDim2.fromOffset(Tab.CustomEmptyPage.IconSize or 48, Tab.CustomEmptyPage.IconSize or 48)
		end

		local Empty = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
			Parent = Tab.UIElements.ContainerFrame,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
				FillDirection = "Vertical",
			}),
			-- New("ImageLabel", {
			-- 	Size = UDim2.new(0, 48, 0, 48),
			-- 	Image = Creator.Icon("frown")[1],
			-- 	ImageRectOffset = Creator.Icon("frown")[2].ImageRectPosition,
			-- 	ImageRectSize = Creator.Icon("frown")[2].ImageRectSize,
			-- 	ThemeTag = {
			-- 		ImageColor3 = "Icon",
			-- 	},
			-- 	BackgroundTransparency = 1,
			-- 	ImageTransparency = 0.6,
			-- }),
			EmptyPageIcon,
			Tab.CustomEmptyPage.Title and New("TextLabel", { -- Title
				AutomaticSize = "XY",
				Text = Tab.CustomEmptyPage.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 18,
				TextTransparency = 0.5,
				BackgroundTransparency = 1,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			}) or nil,
			Tab.CustomEmptyPage.Desc and New("TextLabel", { -- Desc
				AutomaticSize = "XY",
				Text = Tab.CustomEmptyPage.Desc,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 15,
				TextTransparency = 0.65,
				BackgroundTransparency = 1,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
			}) or nil,
		})

		-- Empty.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
		--     Empty.TextLabel.Size = UDim2.new(0,Empty.TextLabel.TextBounds.X,0,Empty.TextLabel.TextBounds.Y)
		-- end)

		local CreationConn
		CreationConn = Creator.AddSignal(Tab.UIElements.ContainerFrame.ChildAdded, function()
			Empty.Visible = false
			CreationConn:Disconnect()
		end)
	end)

	return Tab
end

function TabModule:OnChange(func)
	TabModule.OnChangeFunc = func
end

local function ApplyGoldenTabVisual(TabObject, Active)
	if not TabObject or not TabObject.Golden then
		return
	end

	local Label = TabObject.UIElements
		and TabObject.UIElements.Main
		and TabObject.UIElements.Main.Frame
		and TabObject.UIElements.Main.Frame.TextLabel
	if Label then
		Label.TextColor3 = Active and Color3.fromRGB(255, 244, 184) or Color3.fromRGB(255, 224, 120)
		Label.TextTransparency = Active and 0 or 0.12
	end

	local IconTarget = TabObject.UIElements and TabObject.UIElements.Icon and GetImageTarget(TabObject.UIElements.Icon)
	if IconTarget then
		IconTarget.ImageColor3 = TabObject.IconColor or Color3.fromRGB(255, 222, 105)
		IconTarget.ImageTransparency = Active and 0 or 0.08
	end

	local Outline = TabObject.UIElements and TabObject.UIElements.Main and TabObject.UIElements.Main.Outline
	if Outline then
		Outline.ImageColor3 = Active and Color3.fromRGB(255, 232, 132) or Color3.fromRGB(255, 214, 92)
		Outline.ImageTransparency = Active and 0.58 or 0.78
	end
end

local function ApplyTabMotionVisual(TabObject, Active)
	if not TabObject or not TabObject.UIElements or not TabObject.UIElements.Main then
		return
	end

	local Rail = TabObject.UIElements.Main.ActiveRail
	if Rail then
		if TabObject.Golden then
			Rail.ImageColor3 = Active and Color3.fromRGB(255, 232, 132) or Color3.fromRGB(255, 214, 92)
		end

		Motion.Play(Rail, "Switch", {
			Size = Active and UDim2.new(0, 3, 1, -12) or UDim2.new(0, 3, 0, 0),
			ImageTransparency = Active and 0.08 or 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabRail")
	end

	if not Active and TabObject.UIElements.Main.Frame then
		Motion.Play(TabObject.UIElements.Main.Frame, "Hover", {
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabHover")
	end
end

function TabModule:SelectTab(TabIndex)
	local SelectedTab = TabModule.Tabs[TabIndex]
	if SelectedTab and not SelectedTab.Locked and TabModule.SelectedTab ~= TabIndex then
		TabModule.SelectedTab = TabIndex

		for _, TabObject in next, TabModule.Tabs do
			if not TabObject.Locked then
				Creator.SetThemeTag(TabObject.UIElements.Main, {
					ImageTransparency = "TabBorderTransparency",
				}, 0.15)
				if TabObject.Border then
					Creator.SetThemeTag(TabObject.UIElements.Main.Outline, {
						ImageTransparency = "TabBorderTransparency",
					}, 0.15)
				end
				Creator.SetThemeTag(TabObject.UIElements.Main.Frame.TextLabel, {
					TextTransparency = "TabTextTransparency",
				}, 0.15)
				local IconTarget = TabObject.UIElements.Icon and GetImageTarget(TabObject.UIElements.Icon)
				if IconTarget and not TabObject.IconColor then
					Creator.SetThemeTag(IconTarget, {
						ImageTransparency = "TabIconTransparency",
					}, 0.15)
				end
				TabObject.Selected = false
				ApplyGoldenTabVisual(TabObject, false)
				ApplyTabMotionVisual(TabObject, false)
			end
		end
		Creator.SetThemeTag(SelectedTab.UIElements.Main, {
			ImageColor3 = "TabBackgroundActive",
			ImageTransparency = "TabBackgroundActiveTransparency",
		}, 0.15)
		if SelectedTab.Border then
			Creator.SetThemeTag(SelectedTab.UIElements.Main.Outline, {
				ImageTransparency = "TabBorderTransparencyActive",
			}, 0.15)
		end
		Creator.SetThemeTag(SelectedTab.UIElements.Main.Frame.TextLabel, {
			TextTransparency = "TabTextTransparencyActive",
		}, 0.15)
		local SelectedIconTarget = SelectedTab.UIElements.Icon and GetImageTarget(SelectedTab.UIElements.Icon)
		if SelectedIconTarget and not SelectedTab.IconColor then
			Creator.SetThemeTag(SelectedIconTarget, {
				ImageTransparency = "TabIconTransparencyActive",
			}, 0.15)
		end
		SelectedTab.Selected = true
		ApplyGoldenTabVisual(SelectedTab, true)
		ApplyTabMotionVisual(SelectedTab, true)

		task.spawn(function()
			local SelectedContainer = TabModule.Containers[TabIndex]
			for _, ContainerObject in next, TabModule.Containers do
				if ContainerObject ~= SelectedContainer then
					ContainerObject.AnchorPoint = Vector2.new(0, 0.035)
					ContainerObject.GroupTransparency = 1
					ContainerObject.Visible = false
				end
			end
			SelectedContainer.AnchorPoint = Vector2.new(0, 0.035)
			SelectedContainer.GroupTransparency = 1
			SelectedContainer.Visible = true
			Motion.Play(SelectedContainer, "Switch", {
				AnchorPoint = Vector2.new(0, 0),
				GroupTransparency = 0,
			}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, "Select")
		end)

		TabModule.OnChangeFunc(TabIndex)
	end
end

return TabModule

-- ── VYNX PATCH — Obsidian-style Groupbox API ────────────────────────────────
-- Appended by VYNX UI merger

local _VynxOrig_TabNew = TabModule.New
TabModule.New = function(Config, UIScale)
	local Tab = _VynxOrig_TabNew(Config, UIScale)

	-- Tab:AddLeftGroupbox(Title) / Tab:AddRightGroupbox(Title) / Tab:AddGroupbox(Title)
	-- Obsidian layout: two-column (Left/Right) inside a ScrollingFrame
	-- VYNX maps these to WindUI Sections inside an HStack layout

	local function MakeGroupbox(Title, Side)
		local GroupboxConfig = {
			Title  = Title or "",
			Parent = Tab.UIElements.ContainerFrame,
		}
		local ElementsModule = require("../elements/Init")
		local section = ElementsModule.Elements.Section:New(
			GroupboxConfig,
			Tab.UIElements.ContainerFrame,
			Window and Window.Folder or "VynxUI",
			UIScale or 1,
			Window or {}
		)
		-- Attach element API (both styles)
		ElementsModule.Load(
			section,
			section.UIElements and section.UIElements.Content or section.ContentFrame or Tab.UIElements.ContainerFrame,
			ElementsModule.Elements,
			Window or {},
			WindUI or {},
			nil,
			ElementsModule,
			UIScale or 1,
			Tab
		)
		-- Obsidian compat fields
		section.Tab      = Tab
		section.BoxHolder = Tab.UIElements.ContainerFrame
		section.__type   = "Groupbox"
		section.Destroyed= false
		section.Elements = section.Elements or {}
		section.DependencyBoxes = {}
		return section
	end

	function Tab:AddLeftGroupbox(Title)  return MakeGroupbox(Title, "Left")  end
	function Tab:AddRightGroupbox(Title) return MakeGroupbox(Title, "Right") end
	function Tab:AddGroupbox(Title)      return MakeGroupbox(Title, "Full")  end

	-- Obsidian alias: Tab:AddTab(Title, Icon) → Tab:Select() equivalent already exists
	-- WindUI already has Tab.Select(), so we just alias CreateTab→Tab on the window level

	return Tab
end

end)()

-- ── window/Init.lua ──
_VYNX_MODULES["window/Init.lua"] = (function()
-- /* src/components/Window/Init.lua */

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local CurrentCamera = workspace.CurrentCamera

local Acrylic = require("../utils/Acrylic/Init")

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New
local Tween = Creator.Tween

--local UIComponents = require("../Components/UI.lua")
local CreateLabel = require("../components/ui/Label").New
local CreateButton = require("../components/ui/Button").New
local CreateScrollSlider = require("../components/ui/ScrollSlider").New
local Tag = require("../components/ui/Tag")

local ConfigManager = require("../components/ConfigManager")

local Notified = false

return function(Config)
	local UseDefaultPreset = Config.Default == true or Config.Preset == "Default" or Config.Preset == "Obsidian"
	local function Pick(Value, Default)
		if Value ~= nil then
			return Value
		end
		return Default
	end
	local function PickAlias(Value, Alias, Default)
		if Value ~= nil then
			return Value
		end
		if Alias ~= nil then
			return Alias
		end
		return Default
	end

	if UseDefaultPreset then
		Config.NewElements = Pick(Config.NewElements, true)
		Config.LiquidGlass = PickAlias(Config.LiquidGlass, Config.GlassLiquid, true)
		Config.HideSearchBar = Pick(Config.HideSearchBar, false)
		Config.LinkElementCorners = PickAlias(Config.LinkElementCorners, Config.ElementsLinkCorners, true)
		Config.CornerLink = Config.CornerLink
			or Config.LinkedCornerOptions
			or (typeof(Config.LinkElementCorners) == "table" and Config.LinkElementCorners)
			or (typeof(Config.ElementsLinkCorners) == "table" and Config.ElementsLinkCorners)
			or {
			InnerRadius = 6,
			BridgeHidden = true,
		}
		Config.ElementGap = PickAlias(Config.ElementGap, Config.ElementsGap, 8)
		Config.ElementTransparency = PickAlias(Config.ElementTransparency, Config.ElementsTransparency, 0.18)
		Config.BackgroundOverlayTransparency = Pick(Config.BackgroundOverlayTransparency, 0.5)
		Config.BackgroundColor = Pick(Config.BackgroundColor, Color3.fromHex("#101821"))
		Config.Radius = Pick(Config.Radius, 20)
		Config.SideBarWidth = Pick(Config.SideBarWidth, 210)
		Config.Topbar = Config.Topbar or {
			Height = 48,
			ButtonsType = "Mac",
		}
	end

	local Window = {
		Title = Config.Title or "UI Library",
		Author = Config.Author,
		Icon = Config.Icon,
		IconSize = Config.IconSize or 22,
		IconThemed = Config.IconThemed,
		IconRadius = Config.IconRadius or 0,
		Folder = Config.Folder,
		Resizable = Config.Resizable ~= false,
		Background = Config.Background or Config.BackgroundImage,
		BackgroundColor = Config.BackgroundColor,
		BackgroundGradient = Config.BackgroundGradient,
		BackgroundImageTransparency = Config.BackgroundImageTransparency or 0,
		BackgroundOverlayTransparency = Config.BackgroundOverlayTransparency or 0.62,
		BackgroundScaleType = Config.BackgroundScaleType or "Crop",
		ShadowTransparency = Config.ShadowTransparency or 0.6,
		User = Config.User or {},
		Footer = Config.Footer or {},
		Topbar = Config.Topbar or { Height = 52, ButtonsType = "Default" }, -- Default or Mac

		Size = Config.Size,

		MinSize = Config.MinSize or Vector2.new(560, 350),
		MaxSize = Config.MaxSize or Vector2.new(850, 560),

		TopBarButtonIconSize = Config.TopBarButtonIconSize,

		ToggleKey = Config.ToggleKey,
		ElementsRadius = Config.ElementsRadius,
		Radius = Config.Radius or 16,
		Transparent = Config.Transparent or false,
		ElementTransparency = Config.ElementTransparency or Config.ElementsTransparency,
		ElementGlassTransparency = Config.ElementGlassTransparency or Config.GlassTransparency,
		LiquidGlass = Config.LiquidGlass or Config.GlassLiquid or Config.ElementGlass or false,
		ElementCornerStyle = Config.ElementCornerStyle or Config.ElementsCornerStyle or Config.CornerStyle,
		ElementGap = Config.ElementGap or Config.ElementsGap,
		LinkElementCorners = Config.LinkElementCorners == true
			or Config.ElementsLinkCorners == true
			or typeof(Config.LinkElementCorners) == "table"
			or typeof(Config.ElementsLinkCorners) == "table",
		ElementCornerLink = Config.CornerLink
			or Config.LinkedCornerOptions
			or (typeof(Config.LinkElementCorners) == "table" and Config.LinkElementCorners)
			or (typeof(Config.ElementsLinkCorners) == "table" and Config.ElementsLinkCorners),
		Watermark = Config.Watermark ~= nil and Config.Watermark or Config.WaterMark,
		KeyBindMenu = Config.KeyBindMenu == false and false or (Config.KeyBindMenu or {}),
		HideSearchBar = Config.HideSearchBar ~= false,
		ScrollBarEnabled = Config.ScrollBarEnabled or false,
		SideBarWidth = Config.SideBarWidth or 200,
		Acrylic = Config.Acrylic or false,
		NewElements = Config.NewElements or false,
		Motion = Config.Motion,
		Settings = Config.Settings == false and false or (Config.Settings or {}),
		IgnoreAlerts = Config.IgnoreAlerts or false,
		HidePanelBackground = Config.HidePanelBackground or false,
		AutoScale = Config.AutoScale ~= false,
		OpenButton = Config.OpenButton,
		DragFrameSize = 160,

		Position = UDim2.new(0.5, 0, 0.5, 0),
		UICorner = 16, -- Window.Radius (16)
		UIPadding = 14,
		UIElements = {},
		CanDropdown = true,
		Closed = false,
		Parent = Config.Parent,
		Destroyed = false,
		IsFullscreen = false,
		CanResize = Config.Resizable ~= false,
		IsOpenButtonEnabled = true,

		CurrentConfig = nil,
		ConfigManager = nil,
		AcrylicPaint = nil,
		CurrentTab = nil,
		TabModule = nil,

		OnOpenCallback = nil,
		OnCloseCallback = nil,
		OnDestroyCallback = nil,

		IsPC = false,

		Gap = 5,

		TopBarButtons = {},
		AllElements = {},

		ElementConfig = {},

		PendingFlags = {},

		IsToggleDragging = false,
	}

	Window.UICorner = Window.Radius

	Window.TopBarButtonIconSize = Window.TopBarButtonIconSize or (Window.Topbar.ButtonsType == "Mac" and 11 or 16)

	Window.ElementConfig = {
		UIPadding = (Window.NewElements and 10 or 13),
		UICorner = Window.ElementsRadius or (Window.NewElements and 23 or 16),
		Transparency = Window.ElementTransparency,
		GlassTransparency = Window.ElementGlassTransparency or 0.24,
		LiquidGlass = Window.LiquidGlass,
		CornerStyle = Window.ElementCornerStyle or (Window.NewElements and "Native" or "Shape"),
		LinkCorners = Window.LinkElementCorners,
		CornerLink = Window.ElementCornerLink,
	}

	local WindowSize = Window.Size or UDim2.new(0, 580, 0, 460)
	Window.Size = UDim2.new(
		WindowSize.X.Scale,
		math.clamp(WindowSize.X.Offset, Window.MinSize.X, Window.MaxSize.X),
		WindowSize.Y.Scale,
		math.clamp(WindowSize.Y.Offset, Window.MinSize.Y, Window.MaxSize.Y)
	)

	if Window.Topbar == {} then
		Window.Topbar = { Height = 52, ButtonsType = "Default" }
	end

	if not RunService:IsStudio() and Window.Folder and writefile then
		if not isfolder("WindUI/" .. Window.Folder) then
			makefolder("WindUI/" .. Window.Folder)
		end
		if not isfolder("WindUI/" .. Window.Folder .. "/assets") then
			makefolder("WindUI/" .. Window.Folder .. "/assets")
		end
		if not isfolder(Window.Folder) then
			makefolder(Window.Folder)
		end
		if not isfolder(Window.Folder .. "/assets") then
			makefolder(Window.Folder .. "/assets")
		end
	end

	local UICorner = New("UICorner", {
		CornerRadius = UDim.new(0, Window.UICorner),
	})

	if Window.Folder then
		Window.ConfigManager = ConfigManager:Init(Window)
	end

	if Window.Acrylic then
		local AcrylicPaint, BlurModule = Acrylic.AcrylicPaint({ UseAcrylic = Window.Acrylic })

		Window.AcrylicPaint = AcrylicPaint
	end

	local ResizeHandle = New("Frame", {
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 99,
		Active = true,
	}, {
		New("ImageLabel", {
			Size = UDim2.new(0, 48 * 2, 0, 48 * 2),
			BackgroundTransparency = 1,
			Image = "rbxassetid://120997033468887",
			Position = UDim2.new(0.5, -16, 0.5, -16),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = 1, -- .8; .35
		}),
	})
	local FullScreenIcon = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- .65
		ImageColor3 = Color3.new(0, 0, 0),
		ZIndex = 98,
		Active = false, -- true
	}, {
		New("ImageLabel", {
			Size = UDim2.new(0, 70, 0, 70),
			Image = Creator.Icon("expand")[1],
			ImageRectOffset = Creator.Icon("expand")[2].ImageRectPosition,
			ImageRectSize = Creator.Icon("expand")[2].ImageRectSize,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = 1,
		}),
	})

	local FullScreenBlur = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- .65
		ImageColor3 = Color3.new(0, 0, 0),
		ZIndex = 999,
		Active = false, -- true
	})

	-- local TabHighlight = Creator.NewRoundFrame(Window.UICorner-(Window.UIPadding/2), "Squircle", {
	--     Size = UDim2.new(1,0,0,0),
	--     ImageTransparency = .95,
	--     ThemeTag = {
	--         ImageColor3 = "Text",
	--     }
	-- })

	Window.UIElements.SideBar = New("ScrollingFrame", {
		Size = UDim2.new(
			1,
			Window.ScrollBarEnabled and -3 - (Window.UIPadding / 2) or 0,
			1,
			not Window.HideSearchBar and -39 - 6 or 0
		),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = "Never",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = "Y",
		ScrollingDirection = "Y",
		ClipsDescendants = true,
		VerticalScrollBarPosition = "Left",
	}, {
		New("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = "Y",
			Size = UDim2.new(1, 0, 0, 0),
			Name = "Frame",
		}, {
			New("UIPadding", {
				--PaddingTop = UDim.new(0,Window.UIPadding/2),
				--PaddingLeft = UDim.new(0,4+(Window.UIPadding/2)),
				--PaddingRight = UDim.new(0,4+(Window.UIPadding/2)),
				PaddingBottom = UDim.new(0, Window.UIPadding / 2),
			}),
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, Window.Gap),
			}),
		}),
		New("UIPadding", {
			--PaddingTop = UDim.new(0,4),
			PaddingLeft = UDim.new(0, Window.UIPadding / 2),
			PaddingRight = UDim.new(0, Window.UIPadding / 2),
			PaddingBottom = UDim.new(0, Window.UIPadding / 2),
		}),
		--TabHighlight
	})

	Window.UIElements.SideBarContainer = New("Frame", {
		Size = UDim2.new(
			0,
			Window.SideBarWidth,
			1,
			Window.User.Enabled and -Window.Topbar.Height - 42 - (Window.UIPadding * 2) or -Window.Topbar.Height
		),
		Position = UDim2.new(0, 0, 0, Window.Topbar.Height),
		BackgroundTransparency = 1,
		Visible = true,
	}, {
		New("Frame", {
			Name = "Content",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, not Window.HideSearchBar and -39 - 6 - Window.UIPadding or -Window.UIPadding / 2),
			Position = UDim2.new(0, 0, 1, -Window.UIPadding / 2),
			AnchorPoint = Vector2.new(0, 1),
		}),
		Window.UIElements.SideBar,
	})

	if Window.ScrollBarEnabled then
		CreateScrollSlider(
			Window.UIElements.SideBar,
			Window.UIElements.SideBarContainer.Content,
			Window,
			3,
			Config.WindUI
		)
	end

	Window.UIElements.MainBar = New("Frame", {
		Size = UDim2.new(1, -Window.UIElements.SideBarContainer.AbsoluteSize.X, 1, -Window.Topbar.Height),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
	}, {
		Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "Squircle", {
			Size = UDim2.new(1, 0, 1, 0),
			ThemeTag = {
				ImageColor3 = "PanelBackground",
				ImageTransparency = "PanelBackgroundTransparency",
			},
			-- ImageColor3 = Color3.new(1,1,1),
			-- ImageTransparency = .95,
			ZIndex = 3,
			Name = "Background",
			Visible = not Window.HidePanelBackground,
		}),
		New("UIPadding", {
			--PaddingTop = UDim.new(0,Window.UIPadding/2),
			PaddingLeft = UDim.new(0, Window.UIPadding / 2),
			PaddingRight = UDim.new(0, Window.UIPadding / 2),
			PaddingBottom = UDim.new(0, Window.UIPadding / 2),
		}),
	})

	local Blur = New("ImageLabel", { -- Shadow
		Image = "rbxassetid://8992230677",
		ThemeTag = {
			ImageColor3 = "WindowShadow",
			--ImageTransparency = "WindowShadowTransparency",
		},
		ImageTransparency = 1, -- .7
		Size = UDim2.new(1, 100, 1, 100),
		Position = UDim2.new(0, -100 / 2, 0, -100 / 2),
		ScaleType = "Slice",
		SliceCenter = Rect.new(99, 99, 99, 99),
		BackgroundTransparency = 1,
		ZIndex = -999999999999999,
		Name = "Blur",
	})

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		Window.IsPC = false
	elseif UserInputService.KeyboardEnabled then
		Window.IsPC = true
	else
		Window.IsPC = nil
	end

	--Window.IsPC = true

	-- local OpenButtonContainer = nil
	-- local OpenButton = nil
	-- local OpenButtonIcon = nil

	local UserIcon
	if Window.User then
		local function GetUserThumb()
			local ImageId, _ = Players:GetUserThumbnailAsync(
				Window.User.Anonymous and 1 or Players.LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size420x420
			)
			return ImageId
		end

		UserIcon = New("TextButton", {
			Size = UDim2.new(
				0,
				Window.UIElements.SideBarContainer.AbsoluteSize.X - (Window.UIPadding / 2),
				0,
				42 + Window.UIPadding
			),
			Position = UDim2.new(0, Window.UIPadding / 2, 1, -(Window.UIPadding / 2)),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Visible = Window.User.Enabled or false,
		}, {
			Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "SquircleOutline", {
				Size = UDim2.new(1, 0, 1, 0),
				ThemeTag = {
					ImageColor3 = "Text",
				},
				ImageTransparency = 1, -- .85
				Name = "Outline",
			}, {
				New("UIGradient", {
					Rotation = 78,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0.0, 0.1),
						NumberSequenceKeypoint.new(0.5, 1),
						NumberSequenceKeypoint.new(1.0, 0.1),
					}),
				}),
			}),
			Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "Squircle", {
				Size = UDim2.new(1, 0, 1, 0),
				ThemeTag = {
					ImageColor3 = "Text",
				},
				ImageTransparency = 1, -- .95
				Name = "UserIcon",
			}, {
				New("ImageLabel", {
					Image = GetUserThumb(),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 42, 0, 42),
					ThemeTag = {
						BackgroundColor3 = "Text",
					},
					BackgroundTransparency = 0.93,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
				New("Frame", {
					AutomaticSize = "XY",
					BackgroundTransparency = 1,
				}, {
					New("TextLabel", {
						Text = Window.User.Anonymous and "Anonymous" or Players.LocalPlayer.DisplayName,
						TextSize = 17,
						ThemeTag = {
							TextColor3 = "Text",
						},
						FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
						AutomaticSize = "Y",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -(42 / 2) - 6, 0, 0),
						TextTruncate = "AtEnd",
						TextXAlignment = "Left",
						Name = "DisplayName",
					}),
					New("TextLabel", {
						Text = Window.User.Anonymous and "anonymous" or Players.LocalPlayer.Name,
						TextSize = 15,
						TextTransparency = 0.6,
						ThemeTag = {
							TextColor3 = "Text",
						},
						FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
						AutomaticSize = "Y",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -(42 / 2) - 6, 0, 0),
						TextTruncate = "AtEnd",
						TextXAlignment = "Left",
						Name = "UserName",
					}),
					New("UIListLayout", {
						Padding = UDim.new(0, 4),
						HorizontalAlignment = "Left",
					}),
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, Window.UIPadding),
					FillDirection = "Horizontal",
					VerticalAlignment = "Center",
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, Window.UIPadding / 2),
					PaddingRight = UDim.new(0, Window.UIPadding / 2),
				}),
			}),
		})

		function Window.User:Enable()
			Window.User.Enabled = true
			Tween(
				Window.UIElements.SideBarContainer,
				0.25,
				{ Size = UDim2.new(0, Window.SideBarWidth, 1, -Window.Topbar.Height - 42 - (Window.UIPadding * 2)) },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			):Play()
			UserIcon.Visible = true
		end
		function Window.User:Disable()
			Window.User.Enabled = false
			Tween(
				Window.UIElements.SideBarContainer,
				0.25,
				{ Size = UDim2.new(0, Window.SideBarWidth, 1, -Window.Topbar.Height) },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			):Play()
			UserIcon.Visible = false
		end
		function Window.User:SetAnonymous(v)
			if v ~= false then
				v = true
			end
			Window.User.Anonymous = v
			UserIcon.UserIcon.ImageLabel.Image = GetUserThumb()
			UserIcon.UserIcon.Frame.DisplayName.Text = v and "Anonymous" or Players.LocalPlayer.DisplayName
			UserIcon.UserIcon.Frame.UserName.Text = v and "anonymous" or Players.LocalPlayer.Name
		end

		if Window.User.Enabled then
			Window.User:Enable()
		else
			Window.User:Disable()
		end

		if Window.User.Callback then
			Creator.AddSignal(UserIcon.MouseButton1Click, function()
				Window.User.Callback()
			end)
			Creator.AddSignal(UserIcon.MouseEnter, function()
				Tween(UserIcon.UserIcon, 0.04, { ImageTransparency = 0.95 }):Play()
				Tween(UserIcon.Outline, 0.04, { ImageTransparency = 0.85 }):Play()
			end)
			Creator.AddSignal(UserIcon.InputEnded, function()
				Tween(UserIcon.UserIcon, 0.04, { ImageTransparency = 1 }):Play()
				Tween(UserIcon.Outline, 0.04, { ImageTransparency = 1 }):Play()
			end)
		end
	end

	local Outline1
	local Outline2

	local IsVideoBG = false
	local BGImage = nil

	local function GetTransparencyValue(Value, Default)
		local Number = tonumber(Value)
		if Number == nil then
			return Default
		end
		return math.clamp(math.floor(Number * 100 + 0.5) / 100, 0, 1)
	end

	local function ParseColorValue(Value)
		if typeof(Value) == "Color3" then
			return Value
		end
		if typeof(Value) == "string" and string.sub(Value, 1, 1) == "#" then
			local Success, Color = pcall(function()
				return Color3.fromHex(Value)
			end)
			return Success and Color or nil
		end
		return nil
	end

	local function GetUrlExtension(Url, DefaultExtension)
		if not Url or typeof(Url) ~= "string" then
			return DefaultExtension or ".png"
		end
		local CleanUrl = Url:match("^([^?#]+)") or Url
		local Extension = CleanUrl:match("%.(%w+)$")
		if Extension then
			Extension = Extension:lower()
			if Extension == "jpg" or Extension == "jpeg" or Extension == "png" or Extension == "webp" or Extension == "webm" then
				return "." .. Extension
			end
		end
		return DefaultExtension or ".png"
	end

	local function EnsureAssetFolder()
		if RunService:IsStudio() or not makefolder or not isfolder then
			return
		end

		local Folder = Window.Folder or "Temp"
		if not isfolder(Folder) then
			makefolder(Folder)
		end
		if not isfolder(Folder .. "/assets") then
			makefolder(Folder .. "/assets")
		end
	end

	local function ReadHttp(Url)
		if game.HttpGet then
			return game:HttpGet(Url)
		end
		if Creator.Request then
			local Response = Creator.Request({
				Url = Url,
				Method = "GET",
				Headers = { ["User-Agent"] = "Roblox/Exploit" },
			})
			return Response and Response.Body
		end
		return nil
	end

	local function GetCustomAsset(Path)
		if typeof(getcustomasset) ~= "function" then
			return Path
		end

		local Success, Asset = pcall(function()
			return getcustomasset(Path)
		end)
		if Success then
			return Asset
		end

		warn("[ WindUI.Window.Background ] Failed to load custom asset: " .. tostring(Asset))
		return Path
	end

	local function CacheHttpAsset(Url, Extension)
		if not writefile then
			return Url
		end

		EnsureAssetFolder()
		local AssetPath = (Window.Folder or "Temp")
			.. "/assets/."
			.. Creator.SanitizeFilename(Url)
			.. GetUrlExtension(Url, Extension)

		if not isfile or not isfile(AssetPath) then
			local Success, Result = pcall(function()
				local Response = ReadHttp(Url)
				if Response then
					writefile(AssetPath, Response)
				end
			end)

			if not Success then
				warn("[ WindUI.Window.Background ] Failed to download asset: " .. tostring(Result))
				return Url
			end
		end

		return GetCustomAsset(AssetPath)
	end

	local function ResolveBackgroundAsset(Source, Kind)
		if typeof(Source) ~= "string" then
			return ""
		end

		local VideoSource = string.match(Source, "^video:(.+)")
		if VideoSource then
			Source = VideoSource
			Kind = "Video"
		end

		local CustomPath = string.match(Source, "^customasset:(.+)")
			or string.match(Source, "^getcustomasset:(.+)")
			or string.match(Source, "^file:(.+)")
		if CustomPath then
			return GetCustomAsset(CustomPath)
		end

		if isfile and isfile(Source) then
			return GetCustomAsset(Source)
		end

		if string.match(Source, "^https?://") then
			return CacheHttpAsset(Source, Kind == "Video" and ".webm" or ".png")
		end

		return Source
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
			if Value.Color or Kind == "Color" or Kind == "color" then
				return "Color", Value.Color or Value.Value, Value
			end
			return "Gradient", Value.Gradient or Value, Value
		end

		local Color = ParseColorValue(Value)
		if Color then
			return "Color", Color, {}
		end

		if typeof(Value) == "string" then
			local Video = string.match(Value, "^video:(.+)")
			local CleanUrl = Value:match("^([^?#]+)") or Value
			if Video or string.match(CleanUrl:lower(), "%.webm$") then
				return "Video", Video or Value, {}
			end
			return "Image", Value, {}
		end

		return nil, nil, {}
	end

	local function CreateDetachedMediaBackground(Kind, Source, Options)
		if Kind == "Image" then
			Window.BackgroundScaleType = Options.ScaleType or Window.BackgroundScaleType
			Window.BackgroundImageTransparency = GetTransparencyValue(
				Options.Transparency or Options.ImageTransparency,
				Window.BackgroundImageTransparency
			)
			return New("ImageLabel", {
				Name = "BackgroundImage",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Image = ResolveBackgroundAsset(Source, "Image"),
				ImageTransparency = Window.BackgroundImageTransparency,
				ScaleType = Window.BackgroundScaleType,
				ZIndex = -10,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, Window.UICorner),
				}),
			})
		end

		if Kind == "Video" then
			local Video = New("VideoFrame", {
				Name = "BackgroundVideo",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Video = ResolveBackgroundAsset(Source, "Video"),
				Looped = Options.Looped ~= false,
				Volume = math.clamp(tonumber(Options.Volume) or 0, 0, 1),
				ZIndex = -10,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, Window.UICorner),
				}),
			})
			Video:Play()
			return Video
		end

		return nil
	end

	local InitialBackgroundKind, InitialBackgroundSource, InitialBackgroundOptions = GetBackgroundKind(Window.Background)
	IsVideoBG = InitialBackgroundKind == "Video"
	BGImage = CreateDetachedMediaBackground(InitialBackgroundKind, InitialBackgroundSource, InitialBackgroundOptions)

	local BottomDragFrame = Creator.NewRoundFrame(99, "Squircle", {
		ImageTransparency = 0.8,
		ImageColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 0, 0, 4), -- 200
		Position = UDim2.new(0.5, 0, 1, 4),
		AnchorPoint = Vector2.new(0.5, 0),
	}, {
		New("TextButton", {
			Size = UDim2.new(1, 12, 1, 12),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Active = true,
			ZIndex = 99,
			Name = "Frame",
		}),
	})

	function createAuthor(text)
		return New("TextLabel", {
			Text = text,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			BackgroundTransparency = 1,
			TextTransparency = 0.35,
			AutomaticSize = "XY",
			Parent = Window.UIElements.Main and Window.UIElements.Main.Main.Topbar.Left.Title,
			TextXAlignment = "Left",
			TextSize = 13,
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "WindowTopbarAuthor",
			},
			Name = "Author",
		})
	end

	local WindowAuthor
	local WindowIcon

	if Window.Author then
		WindowAuthor = createAuthor(Window.Author)
	end

	local WindowTitle = New("TextLabel", {
		Text = Window.Title,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		BackgroundTransparency = 1,
		AutomaticSize = "XY",
		Name = "Title",
		TextXAlignment = "Left",
		TextSize = 16,
		ThemeTag = {
			TextColor3 = "WindowTopbarTitle",
		},
	})

	Window.UIElements.Main = New("Frame", {
		Size = UDim2.new(Window.Size.X.Scale, Window.Size.X.Offset, 0, 0),
		Position = Window.Position,
		BackgroundTransparency = 1,
		Parent = Config.Parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Active = true,
		--GroupTransparency = 1,
	}, {
		Config.WindUI.UIScaleObj,
		Window.AcrylicPaint and Window.AcrylicPaint.Frame or nil,
		Blur,
		Creator.NewRoundFrame(Window.UICorner, "Squircle", {
			ImageTransparency = 1, --  Window.Transparent and Config.WindUI.TransparencyValue or 0,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Name = "Background",
			ThemeTag = {
				ImageColor3 = "WindowBackground",
			},
			--ZIndex = -9999,
		}, {
			BGImage,
			BottomDragFrame,
			ResizeHandle,
		}),
		--[[New("UIScale", {
			Scale = 0.89,
		}),]]
		--UIStroke,
		UICorner,
		FullScreenIcon,
		FullScreenBlur,
		New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Name = "Main",
			--GroupTransparency = 1,
			Visible = false,
			ZIndex = 97,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
			Window.UIElements.SideBarContainer,
			Window.UIElements.MainBar,

			UserIcon,

			Outline2,
			New("Frame", { -- Topbar
				Size = UDim2.new(1, 0, 0, Window.Topbar.Height),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				Name = "Topbar",
			}, {
				Outline1,
				--[[New("Frame", { -- Outline
                    Size = UDim2.new(1,Window.UIPadding*2, 0, 1),
                    Position = UDim2.new(0,-Window.UIPadding, 1,Window.UIPadding-2),
                    BackgroundTransparency = 0.9,
                    BackgroundColor3 = Color3.fromHex(Config.Theme.Outline),
                }),]]
				New("Frame", { -- Topbar Left Side
					AutomaticSize = "X",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Name = "Left",
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, Window.UIPadding + 4),
						SortOrder = "LayoutOrder",
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
					}),
					New("Frame", {
						AutomaticSize = "XY",
						BackgroundTransparency = 1,
						Name = "Title",
						Size = UDim2.new(0, 0, 1, 0),
						LayoutOrder = 2,
					}, {
						New("UIListLayout", {
							Padding = UDim.new(0, 0),
							SortOrder = "LayoutOrder",
							FillDirection = "Vertical",
							VerticalAlignment = "Center",
						}),
						WindowTitle,
						WindowAuthor,
					}),
					New("UIPadding", {
						PaddingLeft = UDim.new(0, 4),
					}),
				}),
				New("CanvasGroup", {
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Name = "Center",
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					AutomaticSize = "Y",
					Visible = false,
				}, {
					--[[New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),]]
					New("ScrollingFrame", { -- Topbar Center Size
						Name = "Holder",
						BackgroundTransparency = 1,
						AutomaticSize = "Y",
						ScrollBarThickness = 0,
						ScrollingDirection = "X",
						AutomaticCanvasSize = "X",
						CanvasSize = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						--AnchorPoint = Vector2.new(0, 0.5),
						--Position = UDim2.new(0, 0, 0.5, 0),
					}, {

						New("UIListLayout", {
							FillDirection = "Horizontal",
							VerticalAlignment = "Center",
							HorizontalAlignment = "Left",
							Padding = UDim.new(0, Window.UIPadding / 2),
						}),
					}),
				}),
				New("Frame", { -- Topbar Right Side -- Window.UIElements.Main.Main.Topbar.Right
					AutomaticSize = "XY",
					BackgroundTransparency = 1,
					Position = UDim2.new(Window.Topbar.ButtonsType == "Default" and 1 or 0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(Window.Topbar.ButtonsType == "Default" and 1 or 0, 0.5),
					Name = "Right",
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, Window.Topbar.ButtonsType == "Default" and 9 or 0),
						FillDirection = "Horizontal",
						SortOrder = "LayoutOrder",
					}),
				}),
				New("UIPadding", {
					PaddingTop = UDim.new(0, Window.UIPadding),
					PaddingLeft = UDim.new(
						0,
						Window.Topbar.ButtonsType == "Default" and Window.UIPadding or Window.UIPadding - 2
					),
					PaddingRight = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, Window.UIPadding),
				}),
			}),
		}),
	})

	Creator.AddSignal(Window.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal("AbsoluteSize"), function()
		local LeftWidth = 0
		local RightWidth = Window.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X
			/ Config.WindUI.UIScale

		LeftWidth = Window.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X / Config.WindUI.UIScale
		if Window.Topbar.ButtonsType ~= "Default" then
			LeftWidth = LeftWidth + RightWidth + Window.UIPadding - 4
		end

		Window.UIElements.Main.Main.Topbar.Center.Position =
			UDim2.new(0, LeftWidth + (Window.UIPadding / Config.WindUI.UIScale), 0.5, 0)
		Window.UIElements.Main.Main.Topbar.Center.Size = UDim2.new(
			1,
			-LeftWidth
				- (Window.UIPadding / Config.WindUI.UIScale)
				- (Window.Topbar.ButtonsType == "Default" and RightWidth + Window.UIPadding or 0),
			1,
			0
		)
	end)

	if Window.Topbar.ButtonsType ~= "Default" then
		Creator.AddSignal(Window.UIElements.Main.Main.Topbar.Right:GetPropertyChangedSignal("AbsoluteSize"), function()
			Window.UIElements.Main.Main.Topbar.Left.Position = UDim2.new(
				0,
				(Window.UIElements.Main.Main.Topbar.Right.AbsoluteSize.X / Config.WindUI.UIScale) + Window.UIPadding - 4,
				0,
				0
			)
		end)
	end

	local function GetImageTarget(IconFrame)
		if typeof(IconFrame) ~= "Instance" then
			return nil
		end

		if IconFrame:IsA("ImageLabel") or IconFrame:IsA("ImageButton") then
			return IconFrame
		end

		return IconFrame:FindFirstChildWhichIsA("ImageLabel") or IconFrame:FindFirstChildWhichIsA("ImageButton")
	end

	function Window:CreateTopbarButton(Name, Icon, Callback, LayoutOrder, IconThemed, Color, IconSize, Options)
		local ButtonLayoutOrder = LayoutOrder or 999
		Options = Options or {}
		local ForceIconButton = Options.ForceIcon == true
		local IsIconButton = Window.Topbar.ButtonsType == "Default" or ForceIconButton
		local IsTrafficButton = Window.Topbar.ButtonsType ~= "Default" and not ForceIconButton
		local IconFrame = Creator.Image(
			Icon,
			Icon,
			0,
			Window.Folder,
			"WindowTopbarIcon",
			IsIconButton,
			IconThemed,
			"WindowTopbarButtonIcon"
		)
		IconFrame.Size = IsIconButton
				and UDim2.new(0, IconSize or Window.TopBarButtonIconSize, 0, IconSize or Window.TopBarButtonIconSize)
			or UDim2.new(0, 0, 0, 0)
		IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		IconFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		local IconTarget = GetImageTarget(IconFrame)
		if IconTarget then
			IconTarget.ImageTransparency = IsIconButton and 0 or 1
		end

		if IsTrafficButton and IconTarget then
			IconTarget.ImageColor3 = Creator.GetTextColorForHSB(Color or Color3.fromHex("#ff3030"))
		end

		local Button = Creator.NewRoundFrame(
			IsIconButton and Window.UICorner - (Window.UIPadding / 2) or 999,
			"Squircle",
			{
				Size = IsIconButton
						and UDim2.new(0, Window.Topbar.Height - 16, 0, Window.Topbar.Height - 16)
					or UDim2.new(0, 14, 0, 14),
				LayoutOrder = ButtonLayoutOrder,
				--Parent = Window.Topbar.ButtonsType == "Default" and Window.UIElements.Main.Main.Topbar.Right or nil,
				--Active = true,
				ZIndex = 9999,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ImageColor3 = IsTrafficButton and (Color or Color3.fromHex("#ff3030")) or nil,
				ThemeTag = IsIconButton and {
					ImageColor3 = "Text",
				} or nil,
				ImageTransparency = IsIconButton and 1 or 0, -- .93
			},
			{
				--[[Creator.NewRoundFrame(
					Window.Topbar.ButtonsType == "Default" and Window.UICorner - (Window.UIPadding / 2) or 999,
					"Glass-1",
					{
						Size = UDim2.new(1, 0, 1, 0),
						ThemeTag = {
							ImageColor3 = "Outline",
						},
						ImageTransparency = Window.Topbar.ButtonsType == "Default" and 1 or 0.5, -- .75
						Name = "Outline",
					}
				),]]
				IconFrame,
				New("UIScale", {
					Scale = 1,
				}),
			},
			true
		)

		local ButtonContainer = New("Frame", {
			Size = IsTrafficButton and UDim2.new(0, 24, 0, 24)
				or UDim2.new(0, Window.Topbar.Height - 16, 0, Window.Topbar.Height - 16),
			BackgroundTransparency = 1,
			Parent = Window.UIElements.Main.Main.Topbar.Right,
			LayoutOrder = ButtonLayoutOrder,
		}, {
			Button,
		})

		-- shhh

		Window.TopBarButtons[100 - ButtonLayoutOrder] = {
			Name = Name,
			Object = ButtonContainer,
		}

		Creator.AddSignal(Button.MouseButton1Click, function()
			if Callback then
				Callback()
			end
		end)
		Creator.AddSignal(Button.MouseEnter, function()
			if IsIconButton then
				Motion.Play(Button, "Hover", { ImageTransparency = 0.93 }, nil, nil, "Hover")
				--Tween(Button.Outline, 0.15, { ImageTransparency = 0.75 }):Play()
				--Tween(IconFrame.ImageLabel, .15, {ImageTransparency = 0}):Play()
			else
				--Tween(Button, .1, {Size = UDim2.new(0,14+8,0,14+8)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
				Motion.Play(
					IconTarget,
					"Hover",
					{ ImageTransparency = 0 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				Motion.Play(IconFrame, "Hover", {
					Size = UDim2.new(
						0,
						IconSize or Window.TopBarButtonIconSize,
						0,
						IconSize or Window.TopBarButtonIconSize
					),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Hover")
			end
		end)

		Creator.AddSignal(Button.MouseButton1Down, function()
			Motion.Play(Button.UIScale, "Press", { Scale = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Press")
		end)

		Creator.AddSignal(Button.MouseLeave, function()
			if IsIconButton then
				Motion.Play(Button, "Hover", { ImageTransparency = 1 }, nil, nil, "Hover")
				--Tween(Button.Outline, 0.1, { ImageTransparency = 1 }):Play()
				--Tween(IconFrame.ImageLabel, .1, {ImageTransparency = .2}):Play()
			else
				--Tween(Button, .1, {Size = UDim2.new(0,14,0,14)}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
				Motion.Play(
					IconTarget,
					"Hover",
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				Motion.Play(
					IconFrame,
					"Hover",
					{ Size = UDim2.new(0, 0, 0, 0) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
			end
		end)

		Creator.AddSignal(Button.InputEnded, function()
			Motion.Play(Button.UIScale, "Press", { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Press")
		end)

		return Button
	end

	function Window.Topbar:Button(ButtonConfig: {
		Name: string,
		Icon: string,
		Callback: any,
		LayoutOrder: number,
		IconThemed: boolean,
		Color: Color3,
		IconSize: number,
		Options: table,
	})
		return Window:CreateTopbarButton(
			ButtonConfig.Name,
			ButtonConfig.Icon,
			ButtonConfig.Callback,
			ButtonConfig.LayoutOrder or 0,
			ButtonConfig.IconThemed,
			ButtonConfig.Color,
			ButtonConfig.IconSize,
			ButtonConfig.Options
		)
	end

	-- local Dragged = false

	local WindowDragModule = Creator.Drag(
		Window.UIElements.Main,
		{ Window.UIElements.Main.Main.Topbar, BottomDragFrame.Frame },
		function(dragging, frame) -- On drag
			if not Window.Closed then
				if dragging and frame == BottomDragFrame.Frame then
					Tween(BottomDragFrame, 0.1, { ImageTransparency = 0.35 }):Play()
				else
					Tween(BottomDragFrame, 0.2, { ImageTransparency = 0.8 }):Play()
				end
				Window.Position = Window.UIElements.Main.Position
				Window.Dragging = dragging
			end
		end
	)

	local function ParseBackgroundColor(Value)
		return ParseColorValue(Value)
	end

	local function ApplyBackgroundColor(Value)
		local Color = ParseBackgroundColor(Value)
		if Color then
			Window.BackgroundColor = Value
			Motion.Play(
				Window.UIElements.Main.Background,
				"Background",
				{ ImageColor3 = Color },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"BackgroundColor"
			)
		end
		return Color
	end

	local function SetBackgroundGradientObject(Gradient, Transparency)
		if Window.UIElements.BackgroundGradient then
			Window.UIElements.BackgroundGradient:Destroy()
			Window.UIElements.BackgroundGradient = nil
		end

		if typeof(Gradient) ~= "table" then
			return nil
		end

		local HasGradientProperty = Gradient.Color ~= nil
			or Gradient.Transparency ~= nil
			or Gradient.Rotation ~= nil
			or Gradient.Offset ~= nil
		if not HasGradientProperty then
			return nil
		end

		local BackgroundGradient = New("UIGradient")
		for key, value in next, Gradient do
			if key == "Transparency" and typeof(value) == "number" then
				continue
			end
			pcall(function()
				BackgroundGradient[key] = value
			end)
		end

		local GradientFrame = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
			Name = "BackgroundGradient",
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Window.UIElements.Main.Background,
			ImageTransparency = Transparency or Window.BackgroundOverlayTransparency,
			ZIndex = -9,
		}, {
			BackgroundGradient,
		})

		Window.UIElements.BackgroundGradient = GradientFrame
		return GradientFrame
	end

	local function ClearDetachedBackgroundMedia(KeepKind)
		if KeepKind ~= "Image" and BGImage and BGImage:IsA("ImageLabel") then
			BGImage:Destroy()
			BGImage = nil
		elseif KeepKind ~= "Video" and BGImage and BGImage:IsA("VideoFrame") then
			BGImage:Destroy()
			BGImage = nil
		end

		if KeepKind ~= "Gradient" and Window.UIElements.BackgroundGradient then
			Window.UIElements.BackgroundGradient:Destroy()
			Window.UIElements.BackgroundGradient = nil
		end
	end

	local function CreateImageBackground()
		ClearDetachedBackgroundMedia("Image")

		if BGImage and BGImage:IsA("ImageLabel") then
			return BGImage
		end

		if BGImage then
			BGImage:Destroy()
		end

		BGImage = New("ImageLabel", {
			Name = "BackgroundImage",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 1,
			ScaleType = Window.BackgroundScaleType,
			ZIndex = -10,
			Parent = Window.UIElements.Main.Background,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})

		return BGImage
	end

	local function CreateVideoBackground()
		ClearDetachedBackgroundMedia("Video")

		if BGImage then
			BGImage:Destroy()
		end

		BGImage = New("VideoFrame", {
			Name = "BackgroundVideo",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Looped = true,
			Volume = 0,
			ZIndex = -10,
			Parent = Window.UIElements.Main.Background,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})

		return BGImage
	end

	if Window.BackgroundColor then
		ApplyBackgroundColor(Window.BackgroundColor)
	elseif InitialBackgroundKind == "Color" then
		ApplyBackgroundColor(InitialBackgroundSource)
	end

	local InitialGradient = Window.BackgroundGradient
		or (InitialBackgroundKind == "Gradient" and InitialBackgroundSource or nil)
	if InitialGradient then
		local InitialTransparency = Window.BackgroundGradient and Window.BackgroundOverlayTransparency
			or (Window.Transparent and Config.WindUI.TransparencyValue or 0)
		SetBackgroundGradientObject(InitialGradient, InitialTransparency)
	end

	-- local blur = require("../Blur")

	-- blur.new(Window.UIElements.Main.Background, {
	--     Corner = Window.UICorner
	-- })

	--Creator.Blur(Window.UIElements.Main.Background)
	-- local OpenButtonDragModule

	-- if not Window.IsPC then
	--     OpenButtonDragModule = Creator.Drag(OpenButtonContainer)
	-- end

	Window.OpenButtonMain = require("./Openbutton").New(Window)
	Window.OpenButtonController = Window.OpenButtonMain
	Window.WatermarkMain = require("./Watermark").New(Window, Config.WindUI)

	function Window:SetWatermark(WatermarkConfig)
		Window.Watermark = WatermarkConfig
		return Window.WatermarkMain:Edit(WatermarkConfig)
	end

	function Window:ToggleWatermark(Value)
		if Window.WatermarkMain then
			Window.WatermarkMain:Visible(Value)
		end
	end

	if Window.Watermark ~= nil and Window.Watermark ~= false then
		Window:SetWatermark(Window.Watermark)
	end

	task.spawn(function()
		if Window.Icon then
			local WindowIconContainer = New("Frame", {
				Size = UDim2.new(0, 22, 0, 22),
				BackgroundTransparency = 1,
				Parent = Window.UIElements.Main.Main.Topbar.Left,
			})

			WindowIcon = Creator.Image(
				Window.Icon,
				Window.Title,
				Window.IconRadius,
				Window.Folder,
				"Window",
				true,
				Window.IconThemed,
				"WindowTopbarIcon"
			)
			WindowIcon.Parent = WindowIconContainer
			WindowIcon.Size = UDim2.new(0, Window.IconSize, 0, Window.IconSize)
			WindowIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
			WindowIcon.AnchorPoint = Vector2.new(0.5, 0.5)

			Window.OpenButtonMain:SetIcon(Window.Icon)

			-- if Creator.Icon(tostring(Window.Icon)) and Creator.Icon(tostring(Window.Icon))[1] then
			--     -- ImageLabel.Image = Creator.Icon(Window.Icon)[1]
			--     -- ImageLabel.ImageRectOffset = Creator.Icon(Window.Icon)[2].ImageRectPosition
			--     -- ImageLabel.ImageRectSize = Creator.Icon(Window.Icon)[2].ImageRectSize
			--     -- OpenButtonIcon.Image = Creator.Icon(Window.Icon)[1]
			--     -- OpenButtonIcon.ImageRectOffset = Creator.Icon(Window.Icon)[2].ImageRectPosition
			--     -- OpenButtonIcon.ImageRectSize = Creator.Icon(Window.Icon)[2].ImageRectSize

			-- end
			-- end
		else
			Window.OpenButtonMain:SetIcon(Window.Icon)
			--OpenButtonIcon.Visible = false
		end
	end)

	function Window:SetToggleKey(keycode)
		Window.ToggleKey = keycode
	end

	function Window:SetTitle(text)
		Window.Title = text
		WindowTitle.Text = text
	end

	function Window:SetAuthor(text)
		Window.Author = text
		if not WindowAuthor then
			WindowAuthor = createAuthor(Window.Author)
		end

		WindowAuthor.Text = text
	end

	function Window:SetSize(size)
		if typeof(size) == "UDim2" then
			Window.Size = size

			Tween(Window.UIElements.Main, 0.08, { Size = size }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end
	end

	local function GetBackgroundTransparency(Value, Default)
		return GetTransparencyValue(Value, Default)
	end

	function Window:SetBackgroundImage(id, Options)
		Options = typeof(Options) == "table" and Options or { Transparency = Options }
		ClearDetachedBackgroundMedia("Image")
		local Image = CreateImageBackground()
		Window.Background = id
		Window.BackgroundGradient = nil
		Window.BackgroundScaleType = Options.ScaleType or Window.BackgroundScaleType
		Window.BackgroundImageTransparency = GetBackgroundTransparency(
			Options.Transparency or Options.ImageTransparency,
			Window.BackgroundImageTransparency
		)
		Image.ScaleType = Window.BackgroundScaleType
		Image.Image = ResolveBackgroundAsset(id, "Image")
		Image.ImageTransparency = 1
		Motion.Play(
			Image,
			"Background",
			{ ImageTransparency = Window.BackgroundImageTransparency },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"BackgroundImage"
		)
		return Image
	end

	function Window:SetBackgroundVideo(id, Options)
		Options = typeof(Options) == "table" and Options or {}
		ClearDetachedBackgroundMedia("Video")
		local Video = CreateVideoBackground()
		Window.Background = "video:" .. tostring(id or "")
		Window.BackgroundGradient = nil
		Video.Video = ResolveBackgroundAsset(id, "Video")
		Video.Visible = true
		Video.Looped = Options.Looped ~= false
		Video.Volume = math.clamp(tonumber(Options.Volume) or Video.Volume or 0, 0, 1)
		Video:Play()
		return Video
	end

	function Window:SetBackgroundGradient(Gradient, Transparency)
		ClearDetachedBackgroundMedia("Gradient")
		Window.BackgroundGradient = Gradient
		Window.Background = nil
		Window.BackgroundOverlayTransparency = GetBackgroundTransparency(Transparency, Window.BackgroundOverlayTransparency)
		local GradientFrame = SetBackgroundGradientObject(Gradient, 1)
		if GradientFrame then
			Motion.Play(
				GradientFrame,
				"Background",
				{ ImageTransparency = Window.BackgroundOverlayTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"BackgroundGradient"
			)
		end
		return GradientFrame
	end

	function Window:SetBackgroundColor(Color)
		return ApplyBackgroundColor(Color)
	end

	function Window:SetBackgroundOverlayTransparency(Value)
		Window.BackgroundOverlayTransparency = GetBackgroundTransparency(Value, Window.BackgroundOverlayTransparency)
		if Window.UIElements.BackgroundGradient then
			Motion.Play(
				Window.UIElements.BackgroundGradient,
				"Background",
				{ ImageTransparency = Window.BackgroundOverlayTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"BackgroundGradient"
			)
		end
		return Window.BackgroundOverlayTransparency
	end

	function Window:SetBackground(Value, Options)
		if Value == nil or Value == false then
			Window.Background = nil
			Window.BackgroundGradient = nil
			if BGImage then
				BGImage:Destroy()
				BGImage = nil
			end
			if Window.UIElements.BackgroundGradient then
				Window.UIElements.BackgroundGradient:Destroy()
				Window.UIElements.BackgroundGradient = nil
			end
			return nil
		end

		local Kind, Source, InlineOptions = GetBackgroundKind(Value)
		local MergedOptions = {}
		if typeof(InlineOptions) == "table" then
			for Key, OptionValue in next, InlineOptions do
				MergedOptions[Key] = OptionValue
			end
		end
		if typeof(Options) == "table" then
			for Key, OptionValue in next, Options do
				MergedOptions[Key] = OptionValue
			end
		elseif Options ~= nil then
			MergedOptions.Transparency = Options
		end

		if Kind == "Gradient" then
			return Window:SetBackgroundGradient(Source, MergedOptions.Transparency or MergedOptions.OverlayTransparency)
		elseif Kind == "Color" then
			return Window:SetBackgroundColor(Source)
		elseif Kind == "Video" then
			return Window:SetBackgroundVideo(Source, MergedOptions)
		elseif Kind == "Image" then
			return Window:SetBackgroundImage(Source, MergedOptions)
		end

		return nil
	end

	function Window:SetBackgroundImageTransparency(v)
		Window.BackgroundImageTransparency = GetBackgroundTransparency(v, Window.BackgroundImageTransparency)
		if BGImage and BGImage:IsA("ImageLabel") then
			Motion.Play(
				BGImage,
				"Background",
				{ ImageTransparency = Window.BackgroundImageTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"BackgroundImage"
			)
		end
	end

	function Window:SetBackgroundTransparency(v)
		local rounded = math.floor(tonumber(v) * 10 + 0.5) / 10
		Config.WindUI.TransparencyValue = rounded
		Window:ToggleTransparency(rounded > 0)
	end

	function Window:SetElementTransparency(v)
		local Rounded = math.floor(Creator.ClampTransparency(v, Window.ElementConfig.Transparency or 0) * 100 + 0.5)
			/ 100

		Window.ElementTransparency = Rounded
		Window.ElementConfig.Transparency = Rounded

		for _, Element in next, Window.AllElements do
			if Element and Element.SetTransparency then
				Element:SetTransparency(Rounded)
			end
		end

		return Rounded
	end

	function Window:SetLiquidGlass(Value)
		Window.LiquidGlass = Value == true
		Window.ElementConfig.LiquidGlass = Window.LiquidGlass

		for _, Element in next, Window.AllElements do
			if Element and Element.SetLiquidGlass then
				Element:SetLiquidGlass(Window.LiquidGlass)
			end
		end
	end

	local CurrentPos
	local CurrentSize
	local iconCopy = Creator.Icon("minimize")
	local iconSquare = Creator.Icon("maximize")

	if Window.Settings ~= false and Window.Topbar.Settings ~= false then
		local SettingsMenu = require("./SettingsMenu").New(Window, Config.WindUI, Config)
		local SettingsButton = Window:CreateTopbarButton(
			"Settings",
			"settings",
			function()
				SettingsMenu:Toggle()
			end,
			Window.Topbar.ButtonsType == "Default" and 997 or 1000,
			true,
			Color3.fromHex("#9B87F5"),
			nil,
			{
				ForceIcon = true,
			}
		)
		SettingsMenu:SetButton(SettingsButton)
		Window.SettingsMenu = SettingsMenu
	end

	if Window.KeyBindMenu ~= false and Window.Topbar.KeyBindMenu ~= false then
		local KeyBindMenu = require("./KeyBindMenu").New(Window, Config.WindUI, Config)
		local KeyBindButton = Window:CreateTopbarButton(
			"KeyBind",
			"keyboard",
			function()
				KeyBindMenu:Toggle()
			end,
			Window.Topbar.ButtonsType == "Default" and 996 or 1001,
			true,
			Color3.fromHex("#38BDF8"),
			nil,
			{
				ForceIcon = true,
			}
		)
		KeyBindMenu:SetButton(KeyBindButton)
		Window.KeyBindMenuMain = KeyBindMenu

		function Window:ToggleKeyBindMenu()
			return KeyBindMenu:Toggle()
		end

		function Window:OpenKeyBindMenu()
			return KeyBindMenu:OpenMenu()
		end
	end

	local FullscreenButton = Window:CreateTopbarButton(
		"Fullscreen",
		Window.Topbar.ButtonsType == "Mac" and "rbxassetid://127426072704909" or "maximize",
		function()
			Window:ToggleFullscreen()
		end,
		(Window.Topbar.ButtonsType == "Default" and 998 or 999),
		true,
		Color3.fromHex("#60C762"),
		Window.Topbar.ButtonsType == "Mac" and 9 or nil
	)

	local function SetSize(isAnimation)
		Motion.Play(Window.UIElements.Main, "Resize", {
			Size = not Window.IsFullscreen and CurrentSize or UDim2.new(
				0,
				(Config.WindUI.ScreenGui.AbsoluteSize.X - 20) / Config.WindUI.UIScale,
				0,
				(Config.WindUI.ScreenGui.AbsoluteSize.Y - 20 - 52) / Config.WindUI.UIScale
			),
			Position = not Window.IsFullscreen and CurrentPos or UDim2.new(0.5, 0, 0.5, 52 / 2),
		},
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Fullscreen"
		)
	end

	function Window:ToggleFullscreen()
		local isFullscreen = Window.IsFullscreen
		-- Creator.SetDraggable(isFullscreen)
		WindowDragModule:Set(isFullscreen)

		if not isFullscreen then
			CurrentPos = Window.UIElements.Main.Position
			CurrentSize = Window.UIElements.Main.Size

			Window.CanResize = false
		else
			if Window.Resizable then
				Window.CanResize = true
			end
		end

		Window.IsFullscreen = not isFullscreen

		SetSize(true)
	end

	Creator.AddSignal(Config.WindUI.ScreenGui:GetPropertyChangedSignal("AbsoluteSize"), function()
		if Window.IsFullscreen then
			SetSize()
		end
	end)

	Window:CreateTopbarButton("Minimize", "minus", function()
		if Window.Close then
			Window:Close()
		end
		-- task.spawn(function()
		--     task.wait(.3)
		--     if not Window.IsPC and Window.IsOpenButtonEnabled then
		--         -- OpenButtonContainer.Visible = true
		--         --Window.OpenButtonMain:Visible(true)
		--     end
		-- end)

		-- local NotifiedText = Window.IsPC and "Press " .. Window.ToggleKey.Name .. " to open the Window" or "Click the Button to open the Window"

		-- if not Window.IsOpenButtonEnabled then
		--     Notified = true
		-- end
		-- if not Notified then
		--     Notified = not Notified
		--     Config.WindUI:Notify({
		--         Title = "Minimize",
		--         Content = "You've closed the Window. " .. NotifiedText,
		--         Icon = "eye-off",
		--         Duration = 5,
		--     })
		-- end
	end, (Window.Topbar.ButtonsType == "Default" and 997 or 998), nil, Color3.fromHex("#F4C948"))

	function Window:OnOpen(func)
		Window.OnOpenCallback = func
	end
	function Window:OnClose(func)
		Window.OnCloseCallback = func
	end
	function Window:OnDestroy(func)
		Window.OnDestroyCallback = func
	end

	if Config.WindUI.UseAcrylic then
		Window.AcrylicPaint.AddParent(Window.UIElements.Main)
	end

	function Window:SetIconSize(Size)
		local NewSize
		if typeof(Size) == "number" then
			NewSize = UDim2.new(0, Size, 0, Size)
			Window.IconSize = Size
		elseif typeof(Size) == "UDim2" then
			NewSize = Size
			Window.IconSize = Size.X.Offset
		end

		if WindowIcon then
			WindowIcon.Size = NewSize
		end
	end

	function Window:Open()
		if Window.Destroyed then
			return
		end
		task.spawn(function()
			if Window.OnOpenCallback then
				task.spawn(function()
					Creator.SafeCallback(Window.OnOpenCallback)
				end)
			end

			task.wait(0.06)
			Window.Closed = false

			Window.UIElements.Main.Size = UDim2.new(Window.Size.X.Scale, Window.Size.X.Offset, 0, 100)

			Motion.Play(Window.UIElements.Main, "WindowOpen", {
				--GroupTransparency = 0,
				Size = Window.Size,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Window")

			if Window.UIElements.BackgroundGradient then
				Motion.Play(Window.UIElements.BackgroundGradient, "Focus", {
					ImageTransparency = Window.BackgroundGradient and Window.BackgroundOverlayTransparency or 0,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Window")
			end

			Window.UIElements.Main.Background.ImageTransparency = 1
			Motion.Play(Window.UIElements.Main.Background, "WindowOpen", {
				--Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = Window.Transparent and Config.WindUI.TransparencyValue or 0,
			}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, "WindowBackground")

			if BGImage then
				if BGImage:IsA("VideoFrame") then
					BGImage.Visible = true
				else
					Motion.Play(BGImage, "Focus", {
						ImageTransparency = Window.BackgroundImageTransparency,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Window")
				end
			end

			if Window.OpenButtonMain and Window.IsOpenButtonEnabled then
				Window.OpenButtonMain:Visible(false)
			end

			--[[Config.WindUI.UIScaleObj.Scale -= 1 - 0.85
			Tween(
				Config.WindUI.UIScaleObj,
				0.33,
				{ Scale = Config.WindUI.UIScale },
				Enum.EasingStyle.Back,
				Enum.EasingDirection.Out
			):Play()]]
			Motion.Play(
				Blur,
				"WindowOpen",
				{ ImageTransparency = Window.ShadowTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"Window"
			)
			--[[if UIStroke then
				Tween(UIStroke, 0.25, { Transparency = 0.8 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end]]

			Motion.Play(
				BottomDragFrame,
				"WindowOpen",
				{ Size = UDim2.new(0, Window.DragFrameSize, 0, 4), ImageTransparency = 0.8 },
				Enum.EasingStyle.Exponential,
				Enum.EasingDirection.Out,
				"Window"
			)
			WindowDragModule:Set(true)

			if Window.Resizable then
				Motion.Play(
					ResizeHandle.ImageLabel,
					"WindowOpen",
					{ ImageTransparency = 0.8 },
					Enum.EasingStyle.Exponential,
					Enum.EasingDirection.Out,
					"Window"
				)
				Window.CanResize = true
			end

			Window.CanDropdown = true
			Window.UIElements.Main.Visible = true
			--task.spawn(function()
			--task.wait(0.05)

			Window.UIElements.Main:WaitForChild("Main").Visible = true

			Config.WindUI:ToggleAcrylic(true)
			--end)
		end)
	end
	function Window:Close()
		if Window.Destroyed then
			return
		end

		local Close = {}

		if Window.OnCloseCallback then
			task.spawn(function()
				Creator.SafeCallback(Window.OnCloseCallback)
			end)
		end

		Config.WindUI:ToggleAcrylic(false)

		if Window.UIElements.Main and Window.UIElements.Main:WaitForChild("Main") then
			Window.UIElements.Main.Main.Visible = false
		end

		Window.CanDropdown = false
		Window.Closed = true

		Motion.Play(Window.UIElements.Main, "WindowClose", {
			--GroupTransparency = 1,
			Size = UDim2.new(Window.Size.X.Scale, Window.Size.X.Offset, 0, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Window")
		if Window.UIElements.BackgroundGradient then
			Motion.Play(Window.UIElements.BackgroundGradient, "Fast", {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Window")
		end

		Motion.Play(Window.UIElements.Main.Background, "WindowClose", {
			--Size = UDim2.new(1, 0, 1, -240),
			ImageTransparency = 1,
		}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, "WindowBackground")

		--[[Tween(
			Config.WindUI.UIScaleObj,
			0.28,
			{ Scale = Config.WindUI.UIScale - (1 - 0.85) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()]]
		if BGImage then
			if BGImage:IsA("VideoFrame") then
				BGImage.Visible = false
			else
				Motion.Play(BGImage, "WindowClose", {
					ImageTransparency = 1,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Window")
			end
		end
		Motion.Play(Blur, "WindowClose", { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Window")
		--[[if UIStroke then
			Tween(UIStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end]]

		Motion.Play(
			BottomDragFrame,
			"WindowClose",
			{ Size = UDim2.new(0, 0, 0, 4), ImageTransparency = 1 },
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.Out,
			"Window"
		)
		Motion.Play(
			ResizeHandle.ImageLabel,
			"WindowClose",
			{ ImageTransparency = 1 },
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.Out,
			"Window"
		)
		WindowDragModule:Set(false)
		Window.CanResize = false

		task.spawn(function()
			task.wait(Motion.GetDuration("WindowClose") + 0.05)

			if not Window.Closed then
				return
			end

			Window.UIElements.Main.Visible = false

			if Window.OpenButtonMain and not Window.Destroyed and not Window.IsPC and Window.IsOpenButtonEnabled then
				Window.OpenButtonMain:Visible(true)
			end
		end)

		function Close:Destroy()
			task.spawn(function()
				if Window.OnDestroyCallback then
					task.spawn(function()
						Creator.SafeCallback(Window.OnDestroyCallback)
					end)
				end

				if Window.AcrylicPaint and Window.AcrylicPaint.Model then
					Window.AcrylicPaint.Model:Destroy()
				end

				Window.Destroyed = true

				task.wait(0.4)

				Config.WindUI.ScreenGui:Destroy()
				Config.WindUI.NotificationGui:Destroy()
				Config.WindUI.DropdownGui:Destroy()
				Config.WindUI.TooltipGui:Destroy()

				Creator.DisconnectAll()

				return
			end)
		end

		return Close
	end
	function Window:Destroy()
		return Window:Close():Destroy()
	end
	function Window:Toggle()
		if Window.Closed then
			Window:Open()
		else
			Window:Close()
		end
	end

	function Window:ToggleTransparency(Value)
		-- Config.Transparent = Value
		Window.Transparent = Value
		Config.WindUI.Transparent = Value

		Window.UIElements.Main.Background.ImageTransparency = Value and Config.WindUI.TransparencyValue or 0
		if Window.UIElements.BackgroundGradient then
			Window.UIElements.BackgroundGradient.ImageTransparency = Value and Config.WindUI.TransparencyValue
				or Window.BackgroundOverlayTransparency
		end
		-- Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and Config.WindUI.TransparencyValue or 0
		--Window.UIElements.MainBar.Background.ImageTransparency = Value and 0.97 or 0.95
	end

	function Window:LockAll()
		for _, element in next, Window.AllElements do
			if element.Lock then
				element:Lock()
			end
		end
	end
	function Window:UnlockAll()
		for _, element in next, Window.AllElements do
			if element.Unlock then
				element:Unlock()
			end
		end
	end
	function Window:GetLocked()
		local LockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Locked then
				table.insert(LockedElements, element)
			end
		end

		return LockedElements
	end
	function Window:GetUnlocked()
		local UnlockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Locked == false then
				table.insert(UnlockedElements, element)
			end
		end

		return UnlockedElements
	end

	function Window:GetUIScale(v)
		return Config.WindUI.UIScale
	end

	function Window:SetUIScale(v)
		Config.WindUI.UIScale = v
		Tween(Config.WindUI.UIScaleObj, 0.2, { Scale = v }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		return Window
	end

	function Window:SetToTheCenter()
		Tween(
			Window.UIElements.Main,
			0.45,
			{ Position = UDim2.new(0.5, 0, 0.5, 0) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()
		return Window
	end

	function Window:SetCurrentConfig(ConfigModule)
		Window.CurrentConfig = ConfigModule
	end

	do
		local Margin = 40
		local ViewportSize = CurrentCamera.ViewportSize
		local WindowSize = Vector2.new(Window.Size.X.Offset, Window.Size.Y.Offset)

		if not Window.IsFullscreen and Window.AutoScale then
			local AvailableWidth = ViewportSize.X - (Margin * 2)
			local AvailableHeight = ViewportSize.Y - (Margin * 2)

			local ScaleX = AvailableWidth / WindowSize.X
			local ScaleY = AvailableHeight / WindowSize.Y

			local RequiredScale = math.min(ScaleX, ScaleY)

			local MinScale = 0.3
			local MaxScale = 1.0

			local FinalScale = math.clamp(RequiredScale, MinScale, MaxScale)

			local CurrentScale = Window:GetUIScale() or 1
			local Tolerance = 0.05

			if math.abs(FinalScale - CurrentScale) > Tolerance then
				Window:SetUIScale(FinalScale)
			end
		end
	end

	if Window.OpenButtonMain and Window.OpenButtonMain.Button then
		Creator.AddSignal(Window.OpenButtonMain.Button.TextButton.MouseButton1Click, function()
			-- OpenButtonContainer.Visible = false
			--Window.OpenButtonMain:Visible(false)
			Window:Open()
		end)
	end

	Creator.AddSignal(UserInputService.InputBegan, function(input, isProcessed)
		if isProcessed then
			return
		end

		if Window.ToggleKey then
			if input.KeyCode == Window.ToggleKey then
				Window:Toggle()
			end
		end
	end)

	task.spawn(function()
		--task.wait(1.38583)
		Window:Open()
	end)

	function Window:EditOpenButton(OpenButtonConfig)
		return Window.OpenButtonMain:Edit(OpenButtonConfig)
	end

	function Window:GetOpenButton()
		return Window.OpenButtonMain
	end

	function Window:SetOpenButtonState(State, Changes, Animate)
		return Window.OpenButtonMain:SetState(State, Changes, Animate)
	end

	function Window:ExpandOpenButton(Changes, Duration)
		return Window.OpenButtonMain:Expand(Changes, Duration)
	end

	function Window:CollapseOpenButton(Changes)
		return Window.OpenButtonMain:Collapse(Changes)
	end

	function Window:CompactOpenButton(Changes)
		return Window.OpenButtonMain:Compact(Changes)
	end

	function Window:PushOpenButton(Changes, Duration)
		return Window.OpenButtonMain:Push(Changes, Duration)
	end

	if Window.OpenButton and typeof(Window.OpenButton) == "table" then
		Window:EditOpenButton(Window.OpenButton)
	end

	local TabModuleMain = require("./Tab")
	local SectionModule = require("./Section")
	local TabModule = TabModuleMain.Init(Window, Config.WindUI, Config.WindUI.TooltipGui)
	TabModule:OnChange(function(t)
		Window.CurrentTab = t
	end)

	Window.TabModule = TabModule

	function Window:Tab(TabConfig)
		TabConfig.Parent = Window.UIElements.SideBar.Frame
		return TabModule.New(TabConfig, Config.WindUI.UIScale)
	end

	function Window:SelectTab(Tab)
		TabModule:SelectTab(Tab)
	end

	function Window:Section(SectionConfig)
		return SectionModule.New(
			SectionConfig,
			Window.UIElements.SideBar.Frame,
			Window.Folder,
			Config.WindUI.UIScale,
			Window
		)
	end

	function Window:IsResizable(v)
		Window.Resizable = v
		Window.CanResize = v
	end

	function Window:SetPanelBackground(v)
		if typeof(v) == "boolean" then
			Window.HidePanelBackground = v

			Window.UIElements.MainBar.Background.Visible = v

			if TabModule then
				for _, Container in next, TabModule.Containers do
					Container.ScrollingFrame.UIPadding.PaddingTop = UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingLeft =
						UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingRight =
						UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingBottom =
						UDim.new(0, Window.HidePanelBackground and 20 or 10)
				end
			end
		end
	end

	function Window:Divider()
		local Divider = New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 0.9,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
		})
		local MainDivider = New("Frame", {
			Parent = Window.UIElements.SideBar.Frame,
			--AutomaticSize = "Y",
			Size = UDim2.new(1, -7, 0, 5),
			BackgroundTransparency = 1,
		}, {
			Divider,
		})

		return MainDivider
	end

	local DialogModule = require("./Dialog")
	function Window:Dialog(DialogConfig)
		local DialogTable = {
			Title = DialogConfig.Title or "Dialog",
			Width = DialogConfig.Width or 320,
			Content = DialogConfig.Content,
			Buttons = DialogConfig.Buttons or {},

			TextPadding = 14,
		}
		local Dialog = DialogModule.Create(false, "Dialog", Window, Config.WindUI, Window.UIElements.Main.Main)

		Dialog.UIElements.Main.Size = UDim2.new(0, DialogTable.Width, 0, 0)

		local DialogTopColFrame = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = Dialog.UIElements.Main,
		}, {
			New("UIListLayout", {
				FillDirection = "Vertical",
				--HorizontalAlignment = "Center",
				Padding = UDim.new(0, Dialog.UIPadding),
			}),
		})

		local DialogTopRowFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = DialogTopColFrame,
		}, {
			New("UIListLayout", {
				FillDirection = "Horizontal",
				Padding = UDim.new(0, Dialog.UIPadding),
				VerticalAlignment = "Center",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, DialogTable.TextPadding / 2),
				PaddingLeft = UDim.new(0, DialogTable.TextPadding / 2),
				PaddingRight = UDim.new(0, DialogTable.TextPadding / 2),
			}),
		})

		local Icon
		if DialogConfig.Icon then
			Icon = Creator.Image(
				DialogConfig.Icon,
				DialogTable.Title .. ":" .. DialogConfig.Icon,
				0,
				Window,
				"Dialog",
				true,
				DialogConfig.IconThemed
			)
			Icon.Size = UDim2.new(0, 22, 0, 22)
			Icon.Parent = DialogTopRowFrame
		end

		Dialog.UIElements.UIListLayout = New("UIListLayout", {
			Padding = UDim.new(0, 12),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			VerticalFlex = "SpaceBetween",
			Parent = Dialog.UIElements.Main,
		})

		New("UISizeConstraint", {
			MinSize = Vector2.new(180, 20),
			MaxSize = Vector2.new(400, math.huge),
			Parent = Dialog.UIElements.Main,
		})

		Dialog.UIElements.Title = New("TextLabel", {
			Text = DialogTable.Title,
			TextSize = 20,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			TextXAlignment = "Left",
			TextWrapped = true,
			RichText = true,
			Size = UDim2.new(1, Icon and -26 - Dialog.UIPadding or 0, 0, 0),
			AutomaticSize = "Y",
			ThemeTag = {
				TextColor3 = "Text",
			},
			BackgroundTransparency = 1,
			Parent = DialogTopRowFrame,
		})
		if DialogTable.Content then
			local Content = New("TextLabel", {
				Text = DialogTable.Content,
				TextSize = 18,
				TextTransparency = 0.4,
				TextWrapped = true,
				RichText = true,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextXAlignment = "Left",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				LayoutOrder = 2,
				ThemeTag = {
					TextColor3 = "Text",
				},
				BackgroundTransparency = 1,
				Parent = DialogTopColFrame,
			}, {
				New("UIPadding", {
					PaddingLeft = UDim.new(0, DialogTable.TextPadding / 2),
					PaddingRight = UDim.new(0, DialogTable.TextPadding / 2),
					PaddingBottom = UDim.new(0, DialogTable.TextPadding / 2),
				}),
			})
		end

		local ButtonsLayout = New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
			HorizontalFlex = "Fill",
		})

		local ButtonsContent = New("Frame", {
			Size = UDim2.new(1, 0, 0, 36),
			AutomaticSize = "None",
			BackgroundTransparency = 1,
			Parent = Dialog.UIElements.Main,
			LayoutOrder = 4,
		}, {
			ButtonsLayout,
			-- New("UIPadding", {
			--     PaddingTop = UDim.new(0, DialogTable.TextPadding/2),
			--     PaddingLeft = UDim.new(0, DialogTable.TextPadding/2),
			--     PaddingRight = UDim.new(0, DialogTable.TextPadding/2),
			--     PaddingBottom = UDim.new(0, DialogTable.TextPadding/2),
			-- })
		})

		local Buttons = {}

		for _, Button in next, DialogTable.Buttons do
			local ButtonFrame =
				CreateButton(Button.Title, Button.Icon, Button.Callback, Button.Variant, ButtonsContent, Dialog, true)
			table.insert(Buttons, ButtonFrame)
			ButtonFrame.Size = UDim2.new(1, 0, 1, 0)
		end

		local function CheckButtonsOverflow()
			ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
			ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			ButtonsContent.AutomaticSize = Enum.AutomaticSize.None

			for _, button in ipairs(Buttons) do
				button.Size = UDim2.new(0, 0, 1, 0)
				button.AutomaticSize = Enum.AutomaticSize.X
			end

			wait()

			local totalWidth = ButtonsLayout.AbsoluteContentSize.X / Config.WindUI.UIScale
			local parentWidth = ButtonsContent.AbsoluteSize.X / Config.WindUI.UIScale

			if totalWidth > parentWidth then
				ButtonsLayout.FillDirection = Enum.FillDirection.Vertical
				ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
				ButtonsContent.AutomaticSize = Enum.AutomaticSize.Y

				for _, button in ipairs(Buttons) do
					button.Size = UDim2.new(1, 0, 0, 36)
					button.AutomaticSize = Enum.AutomaticSize.None
				end
			else
				local availableSpace = parentWidth - totalWidth
				if availableSpace > 0 then
					local smallestButton = nil
					local smallestWidth = math.huge

					for _, button in ipairs(Buttons) do
						local buttonWidth = button.AbsoluteSize.X / Config.WindUI.UIScale
						if buttonWidth < smallestWidth then
							smallestWidth = buttonWidth
							smallestButton = button
						end
					end

					if smallestButton then
						smallestButton.Size = UDim2.new(0, smallestWidth + availableSpace, 1, 0)
						smallestButton.AutomaticSize = Enum.AutomaticSize.None
					end
				end
			end
		end

		-- Creator.AddSignal(Dialog.UIElements.Main:GetPropertyChangedSignal("AbsoluteSize"), CheckButtonsOverflow)
		-- CheckButtonsOverflow()

		-- wait()
		Dialog:Open()

		return Dialog
	end

	local ClickedClose = false

	Window:CreateTopbarButton("Close", "x", function()
		if not ClickedClose then
			if not Window.IgnoreAlerts then
				ClickedClose = true
				--Window:SetToTheCenter()
				Window:Dialog({
					--Icon = "trash-2",
					Title = "Close Window",
					Content = "Do you want to close this window? You will not be able to open it again.",
					Buttons = {
						{
							Title = "Cancel",
							--Icon = "chevron-left",
							Callback = function()
								ClickedClose = false
							end,
							Variant = "Secondary",
						},
						{
							Title = "Close Window",
							--Icon = "chevron-down",
							Callback = function()
								ClickedClose = false
								Window:Destroy()
							end,
							Variant = "Primary",
						},
					},
				})
			else
				Window:Destroy()
			end
		end
	end, (Window.Topbar.ButtonsType == "Default" and 999 or 997), nil, Color3.fromHex("#F4695F"))

	function Window:Tag(TagConfig)
		if Window.UIElements.Main.Main.Topbar.Center.Visible == false then
			Window.UIElements.Main.Main.Topbar.Center.Visible = true
		end
		TagConfig.Window = Window
		return Tag:New(TagConfig, Window.UIElements.Main.Main.Topbar.Center.Holder)
	end

	local CurResizeInput = Config.WindUI.GenerateGUID()

	local function startResizing(input)
		if Window.CanResize then
			isResizing = true
			FullScreenIcon.Active = true
			initialSize = Window.UIElements.Main.Size
			initialInputPosition = input.Position
			--Tween(FullScreenIcon, 0.12, {ImageTransparency = .65}):Play()
			--Tween(FullScreenIcon.ImageLabel, 0.12, {ImageTransparency = 0}):Play()
			Tween(ResizeHandle.ImageLabel, 0.1, { ImageTransparency = 0.35 }):Play()

			Creator.AddSignal(input.Changed, function()
				if input.UserInputState == Enum.UserInputState.End then
					if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurResizeInput then
						return
					end

					Config.WindUI.CurrentInput = nil

					isResizing = false
					FullScreenIcon.Active = false
					--Tween(FullScreenIcon, 0.2, {ImageTransparency = 1}):Play()
					--Tween(FullScreenIcon.ImageLabel, 0.17, {ImageTransparency = 1}):Play()
					Tween(ResizeHandle.ImageLabel, 0.17, { ImageTransparency = 0.8 }):Play()
				end
			end)
		end
	end

	Creator.AddSignal(ResizeHandle.InputBegan, function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurResizeInput then
				return
			end
			Config.WindUI.CurrentInput = CurResizeInput

			if Window.CanResize then
				startResizing(input)
			end
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if isResizing and Window.CanResize then
				local delta = input.Position - initialInputPosition
				local newSize = UDim2.new(0, initialSize.X.Offset + delta.X * 2, 0, initialSize.Y.Offset + delta.Y * 2)

				newSize = UDim2.new(
					newSize.X.Scale,
					math.clamp(newSize.X.Offset, Window.MinSize.X, Window.MaxSize.X),
					newSize.Y.Scale,
					math.clamp(newSize.Y.Offset, Window.MinSize.Y, Window.MaxSize.Y)
				)

				Tween(Window.UIElements.Main, 0.08, {
					Size = newSize,
				}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()

				Window.Size = newSize
			end
		end
	end)

	Creator.AddSignal(ResizeHandle.MouseEnter, function()
		if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurResizeInput then
			return
		end
		if not isResizing then
			Tween(ResizeHandle.ImageLabel, 0.1, { ImageTransparency = 0.35 }):Play()
		end
	end)
	Creator.AddSignal(ResizeHandle.MouseLeave, function()
		if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurResizeInput then
			return
		end
		if not isResizing then
			Tween(ResizeHandle.ImageLabel, 0.17, { ImageTransparency = 0.8 }):Play()
		end
	end)

	-- / Double click /

	local LastUpTime = 0
	local DoubleClickWindow = 0.4
	local InitialPosition = nil
	local ClickCount = 0

	function onDoubleClick()
		Window:SetToTheCenter()
	end

	Creator.AddSignal(BottomDragFrame.Frame.MouseButton1Up, function()
		local currentTime = tick()
		local currentPosition = Window.Position

		ClickCount = ClickCount + 1

		if ClickCount == 1 then
			LastUpTime = currentTime
			InitialPosition = currentPosition

			task.spawn(function()
				task.wait(DoubleClickWindow)
				if ClickCount == 1 then
					ClickCount = 0
					InitialPosition = nil
				end
			end)
		elseif ClickCount == 2 then
			if currentTime - LastUpTime <= DoubleClickWindow and currentPosition == InitialPosition then
				onDoubleClick()
			end

			ClickCount = 0
			InitialPosition = nil
			LastUpTime = 0
		else
			ClickCount = 1
			LastUpTime = currentTime
			InitialPosition = currentPosition
		end
	end)

	-- / Search Bar /

	if not Window.HideSearchBar then
		local SearchBar = require("../search/Init")
		local IsOpen = false
		local CurrentSearchBar

		-- local SearchButton
		-- SearchButton = Window:CreateTopbarButton("search", function()
		--     if IsOpen then return end

		--     SearchBar.new(Window.TabModule, Window.UIElements.Main, function()
		--         -- OnClose
		--         IsOpen = false
		--         Window.CanResize = true

		--         Tween(FullScreenBlur, 0.1, {ImageTransparency = 1}):Play()
		--         FullScreenBlur.Active = false
		--     end)
		--     Tween(FullScreenBlur, 0.1, {ImageTransparency = .65}):Play()
		--     FullScreenBlur.Active = true

		--     IsOpen = true
		--     Window.CanResize = false
		-- end, 996)

		local SearchLabel = CreateLabel("Search", "search", Window.UIElements.SideBarContainer, true)
		SearchLabel.Size = UDim2.new(1, -Window.UIPadding / 2, 0, 39)
		SearchLabel.Position = UDim2.new(0, Window.UIPadding / 2, 0,--[[Window.UIPadding/2]] 0)

		Creator.AddSignal(SearchLabel.MouseButton1Click, function()
			if IsOpen then
				return
			end

			SearchBar.new(Window.TabModule, Window.UIElements.Main, function()
				-- OnClose
				IsOpen = false
				if Window.Resizable then
					Window.CanResize = true
				end

				Tween(FullScreenBlur, 0.1, { ImageTransparency = 1 }):Play()
				FullScreenBlur.Active = false
			end)
			Tween(FullScreenBlur, 0.1, { ImageTransparency = 0.65 }):Play()
			FullScreenBlur.Active = true

			IsOpen = true
			Window.CanResize = false
		end)
	end

	-- / TopBar Edit /

	function Window:DisableTopbarButtons(btns)
		for _, b in next, btns do
			for _, i in next, Window.TopBarButtons do
				if i.Name == b then
					i.Object.Visible = false
				end
			end
		end
	end

	-- local Bindings = {
	--     Title = function(v)
	--         Window:SetTitle(v)
	--     end,
	--     Author = function(v)
	--         Window:SetAuthor(v)
	--     end,
	--     Size = function(v)
	--         Window:SetSize(v)
	--     end,
	--     HidePanelBackground  = function(v)
	--         Window:SetPanelBackground(v)
	--     end
	-- }

	-- setmetatable(Window, {
	--     __newindex = function(t, key, value)
	--         rawset(t, key, value)

	--         local bind = bindings[key]
	--         if bind then
	--             bind(value)
	--         end
	--     end
	-- })

	return Window
end

end)()

-- ── elements/DisplayElementUtils.lua ──
_VYNX_MODULES["elements/DisplayElementUtils.lua"] = (function()
local Utils = {}

Utils.Variants = {
	Info = {
		Icon = "info",
		Color = Color3.fromHex("#2563eb"),
	},
	Success = {
		Icon = "circle-check",
		Color = Color3.fromHex("#16a34a"),
	},
	Warning = {
		Icon = "triangle-alert",
		Color = Color3.fromHex("#d97706"),
	},
	Error = {
		Icon = "circle-x",
		Color = Color3.fromHex("#dc2626"),
	},
	Neutral = {
		Icon = "circle",
		Color = Color3.fromHex("#71717a"),
	},
}

function Utils.ToFiniteNumber(Value)
	local Number = tonumber(Value)
	if Number == nil or Number ~= Number or math.abs(Number) == math.huge then
		return nil
	end

	return Number
end

function Utils.GetVariant(Name)
	return Utils.Variants[Name or "Info"] or Utils.Variants.Info
end

function Utils.GetColor(Value, Fallback)
	if typeof(Value) == "Color3" then
		return Value
	end
	if typeof(Value) == "string" and string.sub(Value, 1, 1) == "#" then
		return Color3.fromHex(Value)
	end
	return Fallback
end

function Utils.NormalizeItems(Items, TitleKey, ValueKey)
	local Normalized = {}

	for Index, Item in next, Items or {} do
		if typeof(Item) == "table" then
			local Value = Item[ValueKey or "Value"]
			if Value == nil then
				Value = Item.Id or Item.Key or Item.Title or Item.Name or Index
			end

			table.insert(Normalized, {
				Title = tostring(Item[TitleKey or "Title"] or Item.Name or Value),
				Desc = Item.Desc or Item.Content,
				Value = Value,
				Icon = Item.Icon,
				Color = Item.Color,
				Disabled = Item.Disabled == true,
				Items = Item.Items,
			})
		else
			table.insert(Normalized, {
				Title = tostring(Item),
				Value = Item,
				Disabled = false,
			})
		end
	end

	return Normalized
end

function Utils.CloneArray(Values)
	local Clone = {}
	for _, Value in next, Values or {} do
		table.insert(Clone, Value)
	end
	return Clone
end

function Utils.NormalizeValues(Values)
	if Values == nil then
		return {}
	end
	if typeof(Values) ~= "table" then
		return { Values }
	end
	return Utils.CloneArray(Values)
end

function Utils.ContainsValue(Values, Value)
	for _, Item in next, Values or {} do
		if Item == Value then
			return true
		end
	end
	return false
end

function Utils.ToggleValue(Values, Value)
	local NextValues = Utils.CloneArray(Values)

	for Index, Item in next, NextValues do
		if Item == Value then
			table.remove(NextValues, Index)
			return NextValues, false
		end
	end

	table.insert(NextValues, Value)
	return NextValues, true
end

function Utils.CreateIcon(Creator, IconName, Folder, Type, Themed, ThemeTag)
	if not IconName or IconName == "" then
		return nil
	end

	local Icon = Creator.Image(IconName, IconName, 0, Folder, Type or "Element", Themed ~= false, true, ThemeTag)
	Icon.Size = UDim2.new(0, 18, 0, 18)
	return Icon
end

function Utils.GetImageTarget(Icon)
	if typeof(Icon) ~= "Instance" then
		return nil
	end

	if Icon:IsA("ImageLabel") or Icon:IsA("ImageButton") then
		return Icon
	end

	return Icon:FindFirstChildWhichIsA("ImageLabel") or Icon:FindFirstChildWhichIsA("ImageButton")
end

function Utils.CreateText(New, Creator, Text, Size, Weight, Transparency)
	return New("TextLabel", {
		BackgroundTransparency = 1,
		Text = tostring(Text or ""),
		TextSize = Size or 14,
		TextTransparency = Transparency or 0,
		TextWrapped = true,
		TextXAlignment = "Left",
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Weight or Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})
end

return Utils

end)()

-- ── elements/ModernControlUtils.lua ──
_VYNX_MODULES["elements/ModernControlUtils.lua"] = (function()
local Utils = {}

function Utils.ToFiniteNumber(Value)
	local Number = tonumber(Value)
	if Number == nil or Number ~= Number or math.abs(Number) == math.huge then
		return nil
	end

	return Number
end

function Utils.FormatNumber(Value)
	if Value % 1 == 0 then
		return tostring(Value)
	end

	return tostring(tonumber(string.format("%.2f", Value)))
end

function Utils.NormalizeOptions(Options)
	local Normalized = {}

	for Index, Option in next, Options or {} do
		local Item
		if typeof(Option) == "table" then
			local Value = Option.Value
			if Value == nil then
				Value = Option.Id or Option.Key or Option.Title or Option.Name or Index
			end

			Item = {
				Title = tostring(Option.Title or Option.Name or Value),
				Desc = Option.Desc,
				Value = Value,
				Icon = Option.Icon,
				Disabled = Option.Disabled == true,
			}
		else
			Item = {
				Title = tostring(Option),
				Value = Option,
				Disabled = false,
			}
		end

		table.insert(Normalized, Item)
	end

	return Normalized
end

function Utils.FindOption(Options, Value)
	for Index, Option in next, Options or {} do
		if Option.Value == Value then
			return Option, Index
		end
	end

	return nil, nil
end

function Utils.ContainsValue(Values, Value)
	for _, Item in next, Values or {} do
		if Item == Value then
			return true
		end
	end

	return false
end

function Utils.CloneArray(Values)
	local Clone = {}
	for _, Value in next, Values or {} do
		table.insert(Clone, Value)
	end
	return Clone
end

function Utils.NormalizeValues(Values)
	if Values == nil then
		return {}
	end

	if typeof(Values) ~= "table" then
		return { Values }
	end

	return Utils.CloneArray(Values)
end

function Utils.ToggleValue(Values, Value)
	local NextValues = Utils.CloneArray(Values)

	for Index, Item in next, NextValues do
		if Item == Value then
			table.remove(NextValues, Index)
			return NextValues, false
		end
	end

	table.insert(NextValues, Value)
	return NextValues, true
end

return Utils

end)()

-- ── elements/Paragraph.lua ──
_VYNX_MODULES["elements/Paragraph.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

local CreateButton = require("./components/ui/Button").New

function Element:New(ElementConfig)
	ElementConfig.Hover = false
	ElementConfig.TextOffset = 0
	ElementConfig.ParentConfig = ElementConfig
	ElementConfig.IsButtons = ElementConfig.Buttons and #ElementConfig.Buttons > 0 and true or false

	local ParagraphModule = {
		__type = "Paragraph",
		Title = ElementConfig.Title or "Paragraph",
		Desc = ElementConfig.Desc or nil,
		--Color = ElementConfig.Color,
		Locked = ElementConfig.Locked or false,
	}
	local Paragraph = require("./components/window/Element")(ElementConfig)

	ParagraphModule.ParagraphFrame = Paragraph
	if ElementConfig.Buttons and #ElementConfig.Buttons > 0 then
		local ButtonsContainer = New("Frame", {
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundTransparency = 1,
			AutomaticSize = "Y",
			Parent = Paragraph.UIElements.Container,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Vertical",
			}),
		})

		for _, Button in next, ElementConfig.Buttons do
			local ButtonFrame = CreateButton(
				Button.Title,
				Button.Icon,
				Button.Callback,
				Button.Variant or "White",
				ButtonsContainer,
				nil,
				nil,
				ElementConfig.Window.NewElements and 999 or 10
			)
			ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
			--ButtonFrame.AutomaticSize = "X"
		end
	end

	return ParagraphModule.__type, ParagraphModule
end

return Element

end)()

-- ── elements/Button.lua ──
_VYNX_MODULES["elements/Button.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New
local UserInputService = game:GetService("UserInputService")

local Element = {}

local function NormalizeKey(Value)
	if typeof(Value) == "EnumItem" then
		return Value.Name, Value
	end
	if typeof(Value) == "string" and Enum.KeyCode[Value] then
		return Value, Enum.KeyCode[Value]
	end
	return nil, nil
end

local function GetImageTarget(Object)
	if typeof(Object) ~= "Instance" then
		return nil
	end

	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return Object
	end

	return Object:FindFirstChildWhichIsA("ImageLabel", true) or Object:FindFirstChildWhichIsA("ImageButton", true)
end

function Element:New(Config)
	local KeybindName, KeybindCode =
		NormalizeKey(Config.Keybind or Config.KeyBind or Config.Shortcut or Config.Bind or Config.Hotkey)
	local Button = {
		__type = "Button",
		Title = Config.Title or "Button",
		Desc = Config.Desc or nil,
		Icon = Config.Icon or "mouse-pointer-click",
		IconThemed = Config.IconThemed or false,
		IconColor = Config.IconColor or nil,
		Color = Config.Color,
		Justify = Config.Justify or "Between",
		IconAlign = Config.IconAlign or "Right",
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Golden = Config.Golden == true or Config.Premium == true,
		Premium = Config.Premium == true or Config.Golden == true,
		Keybind = KeybindName,
		KeyCode = KeybindCode,
		Callback = Config.Callback or function() end,
		UIElements = {},
	}

	local CanCallback = true

	Button.ButtonFrame = require("./components/window/Element")({
		Title = Button.Title,
		Desc = Button.Desc,
		Parent = Config.Parent,
		-- Image = Config.Image,
		-- ImageSize = Config.ImageSize,
		-- Thumbnail = Config.Thumbnail,
		-- ThumbnailSize = Config.ThumbnailSize,
		Window = Config.Window,
		Color = Button.Color,
		Justify = Button.Justify,
		TextOffset = 20,
		Hover = true,
		Scalable = true,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Button,
		ParentConfig = Config,
		Size = Config.Size,
		Tags = Config.Tags,
		Golden = Button.Golden,
		Premium = Button.Premium,
	})

	-- Button.UIElements.ButtonIcon = New("ImageLabel",{
	--     Image = Creator.Icon("mouse-pointer-click")[1],
	--     ImageRectOffset = Creator.Icon("mouse-pointer-click")[2].ImageRectPosition,
	--     ImageRectSize = Creator.Icon("mouse-pointer-click")[2].ImageRectSize,
	--     BackgroundTransparency = 1,
	--     Parent = Button.ButtonFrame.UIElements.Main,
	--     Size = UDim2.new(0,20,0,20),
	--     AnchorPoint = Vector2.new(1,0.5),
	--     Position = UDim2.new(1,0,0.5,0),
	--     ThemeTag = {
	--         ImageColor3 = "Text"
	--     }
	-- })
	Button.UIElements.ButtonIcon = Creator.Image(
		Button.Icon,
		Button.Icon,
		0,
		Config.Window.Folder,
		"Button",
		not (Button.Color or Button.IconColor) and true or nil,
		Button.IconThemed
	)

	Button.UIElements.ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
	Button.UIElements.ButtonIcon.Parent = Button.Justify == "Between" and Button.ButtonFrame.UIElements.Main
		or Button.ButtonFrame.UIElements.Container.TitleFrame
	Button.UIElements.ButtonIcon.LayoutOrder = Button.IconAlign == "Left" and -99999 or 99999
	Button.UIElements.ButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
	Button.UIElements.ButtonIcon.Position = UDim2.new(1, 0, 0.5, 0)

	local ButtonIconTarget = GetImageTarget(Button.UIElements.ButtonIcon)
	if ButtonIconTarget then
		if Button.IconColor then
			ButtonIconTarget.ImageColor3 = Button.IconColor
		elseif Button.Golden then
			ButtonIconTarget.ImageColor3 = Color3.fromRGB(255, 222, 105)
		end
		Button.ButtonFrame:Colorize(ButtonIconTarget, "ImageColor3")
	end

	function Button:Lock()
		Button.Locked = true
		CanCallback = false
		return Button.ButtonFrame:Lock(Button.LockedTitle)
	end
	function Button:Unlock()
		Button.Locked = false
		CanCallback = true
		return Button.ButtonFrame:Unlock()
	end

	if Button.Locked then
		Button:Lock()
	end

	function Button:Press()
		if CanCallback then
			task.spawn(function()
				Creator.SafeCallback(Button.Callback)
			end)
		end
	end

	Creator.AddSignal(Button.ButtonFrame.UIElements.Main.MouseButton1Click, function()
		Button:Press()
	end)

	if Button.KeyCode then
		Creator.AddSignal(UserInputService.InputBegan, function(Input, GameProcessed)
			if GameProcessed or UserInputService:GetFocusedTextBox() then
				return
			end
			if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Button.KeyCode then
				Button:Press()
			end
		end)
	end

	return Button.__type, Button
end

return Element

end)()

-- ── elements/Toggle.lua ──
_VYNX_MODULES["elements/Toggle.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween
local UserInputService = game:GetService("UserInputService")

local CreateToggle = require("./components/ui/Toggle").New
local CreateCheckbox = require("./components/ui/Checkbox").New

local Element = {}

local function NormalizeKey(Value)
	if typeof(Value) == "EnumItem" then
		return Value.Name, Value
	end
	if typeof(Value) == "string" and Enum.KeyCode[Value] then
		return Value, Enum.KeyCode[Value]
	end
	return nil, nil
end

function Element:New(Config)
	local KeybindName, KeybindCode =
		NormalizeKey(Config.Keybind or Config.KeyBind or Config.Shortcut or Config.Bind or Config.Hotkey)
	local Toggle = {
		__type = "Toggle",
		Title = Config.Title or "Toggle",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Value = Config.Value,
		Icon = Config.Icon or nil,
		IconSize = Config.IconSize or 23, -- from 26 to 0
		Type = Config.Type or "Toggle",
		Keybind = KeybindName,
		KeyCode = KeybindCode,
		Callback = Config.Callback or function() end,
		UIElements = {},
	}
	Toggle.ToggleFrame = require("./components/window/Element")({
		Title = Toggle.Title,
		Desc = Toggle.Desc,
		-- Image = Config.Image,
		-- ImageSize = Config.ImageSize,
		-- Thumbnail = Config.Thumbnail,
		-- ThumbnailSize = Config.ThumbnailSize,
		Window = Config.Window,
		Parent = Config.Parent,
		TextOffset = (24 + 24 + 4),
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Toggle,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local CanCallback = true

	if Toggle.Value == nil then
		Toggle.Value = false
	end

	function Toggle:Lock()
		Toggle.Locked = true
		CanCallback = false
		return Toggle.ToggleFrame:Lock(Toggle.LockedTitle)
	end
	function Toggle:Unlock()
		Toggle.Locked = false
		CanCallback = true
		return Toggle.ToggleFrame:Unlock()
	end

	if Toggle.Locked then
		Toggle:Lock()
	end

	local Toggled = Toggle.Value

	local ToggleFrame, ToggleFunc
	if Toggle.Type == "Toggle" then
		ToggleFrame, ToggleFunc = CreateToggle(
			Toggled,
			Toggle.Icon,
			Toggle.IconSize,
			Toggle.ToggleFrame.UIElements.Main,
			Toggle.Callback,
			Config.Window.NewElements,
			Config
		)
	elseif Toggle.Type == "Checkbox" then
		ToggleFrame, ToggleFunc = CreateCheckbox(
			Toggled,
			Toggle.Icon,
			Toggle.IconSize,
			Toggle.ToggleFrame.UIElements.Main,
			Toggle.Callback,
			Config
		)
	else
		error("Unknown Toggle Type: " .. tostring(Toggle.Type))
	end

	ToggleFrame.AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5)
	ToggleFrame.Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0)

	function Toggle:Set(v, isCallback, isAnim)
		if CanCallback then
			ToggleFunc:Set(v, isCallback, isAnim or false)
			Toggled = v
			Toggle.Value = v
		end
	end

	function Toggle:Toggle(isCallback, isAnim)
		Toggle:Set(not Toggle.Value, isCallback, isAnim or Config.Window.NewElements)
	end

	Toggle:Set(Toggled, false, Config.Window.NewElements)

	local CurInput = Config.WindUI.GenerateGUID()

	if Config.Window.NewElements and ToggleFunc.Animate then
		if Toggle.Type == "Toggle" then
			Creator.AddSignal(ToggleFrame.ToggleFrame.Hitbox.InputBegan, function(Input)
				if
					not Config.Window.IsToggleDragging
					and (
						Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch
					)
				then
					if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
						return
					end

					Config.WindUI.CurrentInput = CurInput
					ToggleFunc:Animate(Input, Toggle)
				end
			end)
		end
		-- Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.InputEnded, function(input)
		--     if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		--         ToggleFunc:Animate(input, true, Toggle)
		--     end
		-- end)
	else
		if Toggle.Type == "Toggle" then
			Creator.AddSignal(ToggleFrame.ToggleFrame.Hitbox.MouseButton1Click, function()
				Toggle:Toggle(nil, Config.Window.NewElements)
			end)
		elseif Toggle.Type == "Checkbox" then
			Creator.AddSignal(ToggleFrame.MouseButton1Click, function()
				Toggle:Toggle(nil, Config.Window.NewElements)
			end)
		end
	end

	if Toggle.KeyCode then
		Creator.AddSignal(UserInputService.InputBegan, function(Input, GameProcessed)
			if GameProcessed or UserInputService:GetFocusedTextBox() then
				return
			end
			if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Toggle.KeyCode then
				Toggle:Toggle(nil, Config.Window.NewElements)
			end
		end)
	end

	return Toggle.__type, Toggle
end

return Element

end)()

-- ── elements/Slider.lua ──
_VYNX_MODULES["elements/Slider.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Element = {}

local IsSliderHolding = false

function Element:New(Config)
	local Slider = {
		__type = "Slider",
		Title = Config.Title or nil,
		Desc = Config.Desc or nil,
		Locked = Config.Locked or nil,
		LockedTitle = Config.LockedTitle,
		Value = Config.Value or {},
		Icons = Config.Icons or nil,
		IsTooltip = Config.IsTooltip or false,
		IsTextbox = Config.IsTextbox,
		Step = Config.Step or 1,
		Callback = Config.Callback or function() end,
		UIElements = {},
		IsFocusing = false,

		Width = Config.Width or 130,
		TextBoxWidth = Config.Window.NewElements and 40 or 30,
		ThumbSize = 13,
		IconSize = 26,
	}
	if Slider.Icons == {} then
		Slider.Icons = {
			From = "sfsymbols:sunMinFill",
			To = "sfsymbols:sunMaxFill",
		}
	end
	if Slider.IsTextbox == nil and Slider.Title == nil then
		Slider.IsTextbox = false
	else
		Slider.IsTextbox = Slider.IsTextbox ~= false
	end

	local isTouch
	local moveconnection
	local releaseconnection
	local Value = Slider.Value.Default or Slider.Value.Min or 0

	local LastValue = Value
	local delta = (Value - (Slider.Value.Min or 0)) / ((Slider.Value.Max or 100) - (Slider.Value.Min or 0))

	local CanCallback = true
	local IsFloat = Slider.Step % 1 ~= 0

	local function FormatValue(val)
		if IsFloat then
			return tonumber(string.format("%.2f", val))
		end
		return math.floor(val + 0.5)
	end

	local function CalculateValue(rawValue)
		if IsFloat then
			return math.floor(rawValue / Slider.Step + 0.5) * Slider.Step
		else
			return math.floor(rawValue / Slider.Step + 0.5) * Slider.Step
		end
	end

	local IconFrom, IconTo
	local TotalSliderWidth = 32
	if Slider.Icons then
		if Slider.Icons.From then
			IconFrom = Creator.Image(
				Slider.Icons.From,
				Slider.Icons.From,
				0,
				Config.Window.Folder,
				"SliderIconFrom",
				true,
				true,
				"SliderIconFrom"
			)
			IconFrom.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
			TotalSliderWidth = TotalSliderWidth + Slider.IconSize - 2
		end
		if Slider.Icons.To then
			IconTo = Creator.Image(
				Slider.Icons.To,
				Slider.Icons.To,
				0,
				Config.Window.Folder,
				"SliderIconTo",
				true,
				true,
				"SliderIconTo"
			)
			IconTo.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
			TotalSliderWidth = TotalSliderWidth + Slider.IconSize - 2
		end
	end
	Slider.SliderFrame = require("./components/window/Element")({
		Title = Slider.Title,
		Desc = Slider.Desc,
		Parent = Config.Parent,
		TextOffset = Slider.Width,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Slider,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Slider.UIElements.SliderIcon = Creator.NewRoundFrame(99, "Squircle", {
		ImageTransparency = 0.95,
		Size = UDim2.new(1, not Slider.IsTextbox and -TotalSliderWidth or (-Slider.TextBoxWidth - 8), 0, 4),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Name = "Frame",
		ThemeTag = {
			ImageColor3 = "Text",
		},
	}, {
		Creator.NewRoundFrame(99, "Squircle", {
			Name = "Frame",
			Size = UDim2.new(delta, 0, 1, 0),
			ImageTransparency = 0.1,
			ThemeTag = {
				ImageColor3 = "Slider",
			},
		}, {
			Creator.NewRoundFrame(99, "Squircle", {
				Size = UDim2.new(
					0,
					Config.Window.NewElements and (Slider.ThumbSize * 2) or (Slider.ThumbSize + 2),
					0,
					Config.Window.NewElements and (Slider.ThumbSize + 4) or (Slider.ThumbSize + 2)
				),
				Position = UDim2.new(1, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ThemeTag = {
					ImageColor3 = "SliderThumb",
				},
				Name = "Thumb",
			}, {
				Creator.NewRoundFrame(999, "SquircleGlass", {
					Size = UDim2.new(1, 0, 1, 0),
					ImageColor3 = Color3.new(1, 1, 1),
					Name = "Highlight",
					ImageTransparency = 0.5,
				}),
			}),
		}),
	})

	Slider.UIElements.SliderContainer = New("Frame", {
		Size = UDim2.new(Slider.Title == nil and 1 or 0, Slider.Title == nil and 0 or Slider.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, Slider.IsTextbox and (Config.Window.NewElements and -12 - 4 or 0) or 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Parent = Slider.SliderFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Slider.Title ~= nil and 8 or 12),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = Slider.Icons
					and (Slider.Icons.From and (Slider.Icons.To and "Center" or "Left") or Slider.Icons.To and "Right")
				or "Center",
		}),
		IconFrom,
		Slider.UIElements.SliderIcon,
		IconTo,
		New("TextBox", {
			Size = UDim2.new(0, Slider.TextBoxWidth, 0, 0),
			TextXAlignment = "Left",
			Text = FormatValue(Value),
			ThemeTag = {
				TextColor3 = "Text",
			},
			TextTransparency = 0.4,
			AutomaticSize = "Y",
			TextSize = 15,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Visible = Slider.IsTextbox,
		}),
	})

	local Tooltip
	if Slider.IsTooltip then
		Tooltip = require("./components/ui/Tooltip").New(
			Value,
			Slider.UIElements.SliderIcon.Frame.Thumb,
			true,
			"Secondary",
			"Small",
			false
		)
		Tooltip.Container.AnchorPoint = Vector2.new(0.5, 1)
		Tooltip.Container.Position = UDim2.new(0.5, 0, 0, -8)
	end

	local function SetFillSize(Delta, Duration)
		local Size = UDim2.new(Delta, 0, 1, 0)
		if Duration == 0 or not Motion.ShouldAnimate(Config) then
			Slider.UIElements.SliderIcon.Frame.Size = Size
		else
			Motion.Play(Slider.UIElements.SliderIcon.Frame, Duration or "Fast", { Size = Size }, nil, nil, "Fill")
		end
	end

	function Slider:Lock()
		Slider.Locked = true
		CanCallback = false
		return Slider.SliderFrame:Lock(Slider.LockedTitle)
	end
	function Slider:Unlock()
		Slider.Locked = false
		CanCallback = true
		return Slider.SliderFrame:Unlock()
	end

	if Slider.Locked then
		Slider:Lock()
	end

	--local ScrollingFrameParent = Slider.SliderFrame.Parent:IsA("ScrollingFrame") and Slider.SliderFrame.Parent or Slider.SliderFrame.Parent.Parent.Parent
	local ScrollingFrameParent = Config.Tab.UIElements.ContainerFrame

	function Slider:Set(Value, input)
		if CanCallback then
			if
				not Slider.IsFocusing
				and not IsSliderHolding
				and (
					not input
					or (
						input.UserInputType == Enum.UserInputType.MouseButton1
						or input.UserInputType == Enum.UserInputType.Touch
					)
				)
			then
				if input then
					isTouch = (input.UserInputType == Enum.UserInputType.Touch)
					ScrollingFrameParent.ScrollingEnabled = false
					IsSliderHolding = true

					local inputPosition = isTouch and input.Position.X or UserInputService:GetMouseLocation().X
					local delta = math.clamp(
						(inputPosition - Slider.UIElements.SliderIcon.AbsolutePosition.X)
							/ Slider.UIElements.SliderIcon.AbsoluteSize.X,
						0,
						1
					)
					Value = CalculateValue(Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min))
					Value = math.clamp(Value, Slider.Value.Min or 0, Slider.Value.Max or 100)

					if Value ~= LastValue then
						SetFillSize(delta, 0)
						Slider.UIElements.SliderContainer.TextBox.Text = FormatValue(Value)
						if Tooltip then
							Tooltip.TitleFrame.Text = FormatValue(Value)
						end
						Slider.Value.Default = FormatValue(Value)
						LastValue = Value
						Creator.SafeCallback(Slider.Callback, FormatValue(Value))
					end

					moveconnection = RunService.RenderStepped:Connect(function()
						local inputPosition = isTouch and input.Position.X or UserInputService:GetMouseLocation().X
						local delta = math.clamp(
							(inputPosition - Slider.UIElements.SliderIcon.AbsolutePosition.X)
								/ Slider.UIElements.SliderIcon.AbsoluteSize.X,
							0,
							1
						)
						Value = CalculateValue(Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min))

						if Value ~= LastValue then
							SetFillSize(delta, 0)
							Slider.UIElements.SliderContainer.TextBox.Text = FormatValue(Value)
							if Tooltip then
								Tooltip.TitleFrame.Text = FormatValue(Value)
							end
							Slider.Value.Default = FormatValue(Value)
							LastValue = Value
							Creator.SafeCallback(Slider.Callback, FormatValue(Value))
						end
					end)

					-- release slider
					releaseconnection = UserInputService.InputEnded:Connect(function(endInput)
						if
							(
								endInput.UserInputType == Enum.UserInputType.MouseButton1
								or endInput.UserInputType == Enum.UserInputType.Touch
							) and input == endInput
						then
							moveconnection:Disconnect()
							releaseconnection:Disconnect()
							IsSliderHolding = false
							ScrollingFrameParent.ScrollingEnabled = true

							Config.WindUI.CurrentInput = nil

							if Config.Window.NewElements then
								Motion.Play(Slider.UIElements.SliderIcon.Frame.Thumb, "Focus", {
									ImageTransparency = 0,
									Size = UDim2.new(
										0,
										Config.Window.NewElements and (Slider.ThumbSize * 2) or (Slider.ThumbSize + 2),
										0,
										Config.Window.NewElements and (Slider.ThumbSize + 4) or (Slider.ThumbSize + 2)
									),
								}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Thumb")
							end
							if Tooltip then
								Tooltip:Close(false)
							end
						end
					end)
				else
					Value = math.clamp(Value, Slider.Value.Min or 0, Slider.Value.Max or 100)

					local delta = math.clamp(
						(Value - (Slider.Value.Min or 0)) / ((Slider.Value.Max or 100) - (Slider.Value.Min or 0)),
						0,
						1
					)
					Value = CalculateValue(Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min))

					if Value ~= LastValue then
						SetFillSize(delta, "Fast")
						Slider.UIElements.SliderContainer.TextBox.Text = FormatValue(Value)
						if Tooltip then
							Tooltip.TitleFrame.Text = FormatValue(Value)
						end
						Slider.Value.Default = FormatValue(Value)
						LastValue = Value
						Creator.SafeCallback(Slider.Callback, FormatValue(Value))
					end
				end
			end
		end
	end

	function Slider:SetMax(newMax)
		Slider.Value.Max = newMax

		local currentValue = tonumber(Slider.Value.Default) or LastValue
		if currentValue > newMax then
			Slider:Set(newMax)
		else
			local newDelta =
				math.clamp((currentValue - (Slider.Value.Min or 0)) / (newMax - (Slider.Value.Min or 0)), 0, 1)
			SetFillSize(newDelta, "Fast")
		end
	end

	function Slider:SetMin(newMin)
		Slider.Value.Min = newMin

		local currentValue = tonumber(Slider.Value.Default) or LastValue
		if currentValue < newMin then
			Slider:Set(newMin)
		else
			local newDelta = math.clamp((currentValue - newMin) / ((Slider.Value.Max or 100) - newMin), 0, 1)
			SetFillSize(newDelta, "Fast")
		end
	end

	Creator.AddSignal(Slider.UIElements.SliderContainer.TextBox.FocusLost, function(enterPressed)
		local newValue = tonumber(Slider.UIElements.SliderContainer.TextBox.Text)
		if newValue then
			Slider:Set(newValue)
		else
			Slider.UIElements.SliderContainer.TextBox.Text = FormatValue(LastValue)
			if Tooltip then
				Tooltip.TitleFrame.Text = FormatValue(LastValue)
			end
		end
	end)

	local CurInput = Config.WindUI.GenerateGUID()

	Creator.AddSignal(Slider.UIElements.SliderContainer.InputBegan, function(input)
		if Slider.Locked or IsSliderHolding then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
				return
			end
			Config.WindUI.CurrentInput = CurInput

			Slider:Set(Value, input)

			-- drag slider
			if Config.Window.NewElements then
				Motion.Play(Slider.UIElements.SliderIcon.Frame.Thumb, "Focus", {
					ImageTransparency = 0.85,
					Size = UDim2.new(
						0,
						(Config.Window.NewElements and (Slider.ThumbSize * 2) or Slider.ThumbSize) + 8,
						0,
						Slider.ThumbSize + 8
					),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Thumb")
			end
			if Tooltip then
				Tooltip:Open()
			end
			--print("piskaa")
		end
	end)

	return Slider.__type, Slider
end

return Element

end)()

-- ── elements/ProgressBar.lua ──
_VYNX_MODULES["elements/ProgressBar.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

local function ToFiniteNumber(Value)
	local Number = tonumber(Value)
	if Number == nil or Number ~= Number or math.abs(Number) == math.huge then
		return nil
	end

	return Number
end

local function FormatNumber(Value)
	if Value % 1 == 0 then
		return tostring(Value)
	end

	return tostring(tonumber(string.format("%.2f", Value)))
end

function Element:New(Config)
	local ValueConfig = typeof(Config.Value) == "table" and Config.Value or {}
	local Min = ToFiniteNumber(ValueConfig.Min) or ToFiniteNumber(Config.Min) or 0
	local Max = ToFiniteNumber(ValueConfig.Max) or ToFiniteNumber(Config.Max) or 100

	if Min > Max then
		Min, Max = Max, Min
	end

	local DefaultValue = typeof(Config.Value) == "number" and Config.Value
		or ToFiniteNumber(ValueConfig.Default)
		or ToFiniteNumber(Config.Default)
		or Min
	DefaultValue = ToFiniteNumber(DefaultValue) or Min

	local Indeterminate = Config.Indeterminate == true

	local ShowValue = Config.ShowValue
	if ShowValue == nil then
		ShowValue = not Indeterminate
	end

	local ValueWidth = math.max(ToFiniteNumber(Config.ValueWidth) or 44, 0)

	local ProgressBar = {
		__type = "ProgressBar",
		Title = Config.Title or "Progress",
		Desc = Config.Desc or nil,
		Value = {
			Min = Min,
			Max = Max,
			Default = math.clamp(DefaultValue, Min, Max),
		},
		ShowValue = ShowValue,
		DisplayMode = Config.DisplayMode or "Percent",
		Format = Config.Format,
		Animate = Config.Animate ~= false,
		AnimationDuration = math.max(ToFiniteNumber(Config.AnimationDuration) or 0.15, 0),
		Indeterminate = Indeterminate,
		IndeterminateText = Config.IndeterminateText or "",
		Speed = math.max(ToFiniteNumber(Config.Speed) or 1, 0.01),
		ControlGap = math.max(ToFiniteNumber(Config.ControlGap) or 16, 0),
		UIElements = {},

		Width = math.max(ToFiniteNumber(Config.Width) or 160, 0),
		ValueWidth = ValueWidth,
	}

	local function GetRatio(Value)
		if ProgressBar.Value.Max == ProgressBar.Value.Min then
			return Value >= ProgressBar.Value.Max and 1 or 0
		end

		return math.clamp((Value - ProgressBar.Value.Min) / (ProgressBar.Value.Max - ProgressBar.Value.Min), 0, 1)
	end

	local function GetValueText(Value, Ratio)
		if ProgressBar.Indeterminate then
			return tostring(ProgressBar.IndeterminateText)
		end

		local Percentage = Ratio * 100

		if typeof(ProgressBar.Format) == "function" then
			local Success, Result =
				pcall(ProgressBar.Format, Value, Percentage, ProgressBar.Value.Min, ProgressBar.Value.Max)

			if Success and Result ~= nil then
				return tostring(Result)
			end
		end

		if ProgressBar.DisplayMode == "Value" then
			return FormatNumber(Value)
		elseif ProgressBar.DisplayMode == "Fraction" then
			return FormatNumber(Value) .. "/" .. FormatNumber(ProgressBar.Value.Max)
		end

		return tostring(math.floor(Percentage + 0.5)) .. "%"
	end

	ProgressBar.ProgressBarFrame = require("./components/window/Element")({
		Title = ProgressBar.Title,
		Desc = ProgressBar.Desc,
		Parent = Config.Parent,
		TextOffset = ProgressBar.Width + ProgressBar.ControlGap,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = ProgressBar,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	ProgressBar.UIElements.Fill = Creator.NewRoundFrame(99, "Squircle", {
		Name = "Fill",
		Size = ProgressBar.Indeterminate and UDim2.new(0.3, 0, 1, 0)
			or UDim2.new(GetRatio(ProgressBar.Value.Default), 0, 1, 0),
		Position = ProgressBar.Indeterminate and UDim2.new(-0.3, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
		ThemeTag = {
			ImageColor3 = "ProgressBar",
		},
	})

	ProgressBar.UIElements.Bar = Creator.NewRoundFrame(99, "Squircle", {
		Name = "Bar",
		Size = UDim2.new(1, ProgressBar.ShowValue and -(ProgressBar.ValueWidth + 8) or 0, 0, 6),
		ClipsDescendants = true,
		ImageTransparency = 0.9,
		ThemeTag = {
			ImageColor3 = "ProgressBarTrack",
			ImageTransparency = "ProgressBarTrackTransparency",
		},
	}, {
		ProgressBar.UIElements.Fill,
	})

	ProgressBar.UIElements.Value = New("TextLabel", {
		Name = "Value",
		Size = UDim2.new(0, ProgressBar.ValueWidth, 0, 20),
		BackgroundTransparency = 1,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Text = GetValueText(ProgressBar.Value.Default, GetRatio(ProgressBar.Value.Default)),
		TextSize = 14,
		TextTransparency = 0.25,
		TextTruncate = "AtEnd",
		TextXAlignment = "Right",
		Visible = ProgressBar.ShowValue,
		ThemeTag = {
			TextColor3 = "ProgressBarText",
		},
	})

	ProgressBar.UIElements.Container = New("Frame", {
		Name = "ProgressBarContainer",
		Size = UDim2.new(0, ProgressBar.Width, 0, 36),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = ProgressBar.ProgressBarFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Right",
			VerticalAlignment = "Center",
		}),
		ProgressBar.UIElements.Bar,
		ProgressBar.UIElements.Value,
	})

	if ProgressBar.Indeterminate then
		local IndeterminateTween = Tween(
			ProgressBar.UIElements.Fill,
			1 / ProgressBar.Speed,
			{ Position = UDim2.new(1, 0, 0, 0) },
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.InOut,
			-1
		)
		Creator.AddSignal(ProgressBar.UIElements.Bar.Destroying, function()
			IndeterminateTween:Cancel()
		end)
		IndeterminateTween:Play()
	end

	local function Update(Value, Instant)
		local NumericValue = ToFiniteNumber(Value)
		if NumericValue == nil then
			return ProgressBar.Value.Default
		end

		NumericValue = math.clamp(NumericValue, ProgressBar.Value.Min, ProgressBar.Value.Max)
		ProgressBar.Value.Default = NumericValue

		local Ratio = GetRatio(NumericValue)
		local Size = UDim2.new(Ratio, 0, 1, 0)

		if ProgressBar.UIElements.Fill and not ProgressBar.Indeterminate then
			if Instant or not ProgressBar.Animate or ProgressBar.AnimationDuration <= 0 then
				ProgressBar.UIElements.Fill.Size = Size
			else
				Tween(
					ProgressBar.UIElements.Fill,
					ProgressBar.AnimationDuration,
					{ Size = Size },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
			end
		end

		ProgressBar.UIElements.Value.Text = GetValueText(NumericValue, Ratio)

		return NumericValue
	end

	function ProgressBar:Set(Value)
		return Update(Value, false)
	end

	function ProgressBar:Get()
		return ProgressBar.Value.Default
	end

	function ProgressBar:GetPercentage()
		return GetRatio(ProgressBar.Value.Default) * 100
	end

	function ProgressBar:SetRange(NewMin, NewMax)
		NewMin = ToFiniteNumber(NewMin)
		NewMax = ToFiniteNumber(NewMax)

		if NewMin == nil or NewMax == nil then
			return ProgressBar.Value.Min, ProgressBar.Value.Max
		end

		if NewMin > NewMax then
			NewMin, NewMax = NewMax, NewMin
		end

		ProgressBar.Value.Min = NewMin
		ProgressBar.Value.Max = NewMax
		Update(ProgressBar.Value.Default, false)

		return NewMin, NewMax
	end

	function ProgressBar:SetMin(NewMin)
		NewMin = ToFiniteNumber(NewMin)
		if NewMin == nil then
			return ProgressBar.Value.Min
		end

		ProgressBar:SetRange(NewMin, math.max(NewMin, ProgressBar.Value.Max))
		return ProgressBar.Value.Min
	end

	function ProgressBar:SetMax(NewMax)
		NewMax = ToFiniteNumber(NewMax)
		if NewMax == nil then
			return ProgressBar.Value.Max
		end

		ProgressBar:SetRange(math.min(ProgressBar.Value.Min, NewMax), NewMax)
		return ProgressBar.Value.Max
	end

	Update(ProgressBar.Value.Default, true)

	return ProgressBar.__type, ProgressBar
end

return Element

end)()

-- ── elements/Keybind.lua ──
_VYNX_MODULES["elements/Keybind.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {
	UICorner = 6,
	UIPadding = 8,
}

local CreateLabel = require("./components/ui/Label").New

function Element:New(Config)
	local function NormalizeKeyCode(value)
		if typeof(value) == "EnumItem" then
			return value.Name
		elseif type(value) == "string" then
			return value
		else
			return "F"
		end
	end

	local Keybind = {
		__type = "Keybind",
		Title = Config.Title or "Keybind",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Value = NormalizeKeyCode(Config.Value) or "F",
		Callback = Config.Callback or function() end,
		CanChange = Config.CanChange ~= false,
		Blacklist = Config.Blacklist or {},
		Picking = false,
		UIElements = {},
	}

	local FilteredBlacklist = {}

	for _, Item in next, Keybind.Blacklist do
		table.insert(FilteredBlacklist, Enum.KeyCode[NormalizeKeyCode(Item)])
	end
	table.insert(FilteredBlacklist, Enum.KeyCode[NormalizeKeyCode("Escape")])

	local CanCallback = true

	Keybind.KeybindFrame = require("./components/window/Element")({
		Title = Keybind.Title,
		Desc = Keybind.Desc,
		Parent = Config.Parent,
		TextOffset = 85,
		Hover = Keybind.CanChange,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Keybind,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Keybind.UIElements.Keybind = CreateLabel(
		Keybind.Value,
		nil,
		Keybind.KeybindFrame.UIElements.Main,
		nil,
		Config.Window.NewElements and 12 or 10
	)

	Keybind.UIElements.Keybind.Size =
		UDim2.new(0, 12 + 12 + Keybind.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
	Keybind.UIElements.Keybind.AnchorPoint = Vector2.new(1, 0.5)
	Keybind.UIElements.Keybind.Position = UDim2.new(1, 0, 0.5, 0)
	Keybind.UIElements.Keybind.Interactable = false

	New("UIScale", {
		Parent = Keybind.UIElements.Keybind,
		Scale = 0.85,
	})

	Creator.AddSignal(
		Keybind.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal("TextBounds"),
		function()
			Keybind.UIElements.Keybind.Size =
				UDim2.new(0, 12 + 12 + Keybind.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
		end
	)

	function Keybind:Lock()
		Keybind.Locked = true
		CanCallback = false
		return Keybind.KeybindFrame:Lock(Keybind.LockedTitle)
	end
	function Keybind:Unlock()
		Keybind.Locked = false
		CanCallback = true
		return Keybind.KeybindFrame:Unlock()
	end

	function Keybind:Set(v)
		local normalizedValue = NormalizeKeyCode(v)
		Keybind.Value = normalizedValue
		Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = normalizedValue
	end

	if Keybind.Locked then
		Keybind:Lock()
	end

	local EndedEvent

	Creator.AddSignal(Keybind.KeybindFrame.UIElements.Main.MouseButton1Click, function()
		if CanCallback then
			if Keybind.CanChange then
				Keybind.Picking = true
				Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = "..."

				--task.wait(0.2)

				local Event
				Event = UserInputService.InputBegan:Connect(function(Input)
					local Key

					if Input.UserInputType == Enum.UserInputType.Keyboard then
						if table.find(FilteredBlacklist, Input.KeyCode) then
							Key = nil
							return
						else
							Key = Input.KeyCode.Name
						end
					elseif
						Input.UserInputType == Enum.UserInputType.MouseButton1
						and not table.find(FilteredBlacklist, "MouseLeftButton")
					then
						Key = "MouseLeftButton"
					elseif
						Input.UserInputType == Enum.UserInputType.MouseButton2
						and not table.find(FilteredBlacklist, "MouseRightButton")
					then
						Key = "MouseRightButton"
					end

					if EndedEvent then
						EndedEvent:Disconnect()
					end

					EndedEvent = UserInputService.InputEnded:Connect(function(Input)
						if
							Key
							and (
								Input.KeyCode.Name == Key
								or Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
								or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
							)
						then
							Keybind.Picking = false

							Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = Key
							Keybind.Value = Key

							Event:Disconnect()
							EndedEvent:Disconnect()
						end
					end)
				end)
			end
		end
	end)

	Creator.AddSignal(UserInputService.InputBegan, function(input, gpe)
		if UserInputService:GetFocusedTextBox() then
			return
		end
		if not CanCallback then
			return
		end
		if Keybind.Picking then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode.Name == Keybind.Value then
				Creator.SafeCallback(Keybind.Callback, input.KeyCode.Name)
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Value == "MouseLeft" then
			Creator.SafeCallback(Keybind.Callback, "MouseLeft")
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Value == "MouseRight" then
			Creator.SafeCallback(Keybind.Callback, "MouseRight")
		end
	end)

	return Keybind.__type, Keybind
end

return Element

end)()

-- ── elements/Input.lua ──
_VYNX_MODULES["elements/Input.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {
	UICorner = 8,
	UIPadding = 8,
}

local CreateButton = require("./components/ui/Button").New
local CreateInput = require("./components/ui/Input").New

function Element:New(Config)
	local Input = {
		__type = "Input",
		Title = Config.Title or "Input",
		Desc = Config.Desc or nil,
		Type = Config.Type or "Input", -- Input or Textarea
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		InputIcon = Config.InputIcon or false,
		Placeholder = Config.Placeholder or "Enter Text...",
		Value = Config.Value or "",
		Callback = Config.Callback or function() end,
		ClearTextOnFocus = Config.ClearTextOnFocus or false,
		UIElements = {},

		Width = 150,
	}

	local CanCallback = true

	Input.InputFrame = require("./components/window/Element")({
		Title = Input.Title,
		Desc = Input.Desc,
		Parent = Config.Parent,
		TextOffset = Input.Width,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Input,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local InputComponent = CreateInput(
		Input.Placeholder,
		Input.InputIcon,
		Input.Type == "Textarea" and Input.InputFrame.UIElements.Container or Input.InputFrame.UIElements.Main,
		Input.Type,
		function(v)
			Input:Set(v, true)
		end,
		nil,
		Config.Window.NewElements and 12 or 10,
		Input.ClearTextOnFocus
	)

	if Input.Type ~= "Textarea" then
		InputComponent.Size = UDim2.new(0, Input.Width, 0, 36)
		InputComponent.Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0)
		InputComponent.AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5)
	else
		InputComponent.Size = UDim2.new(1, 0, 0, 42 + 56 + 50)
	end

	--[[New("UIScale", {
		Parent = InputComponent,
		Scale = 1,
	})]]

	function Input:Lock()
		Input.Locked = true
		CanCallback = false
		return Input.InputFrame:Lock(Input.LockedTitle)
	end
	function Input:Unlock()
		Input.Locked = false
		CanCallback = true
		return Input.InputFrame:Unlock()
	end

	function Input:Set(v, IsUserInput)
		if CanCallback then
			Input.Value = v
			Creator.SafeCallback(Input.Callback, v)

			if not IsUserInput then
				InputComponent.Frame.Frame.TextBox.Text = v
			end
		end
	end

	function Input:SetPlaceholder(v)
		InputComponent.Frame.Frame.TextBox.PlaceholderText = v
		Input.Placeholder = v
	end

	Input:Set(Input.Value)

	if Input.Locked then
		Input:Lock()
	end

	return Input.__type, Input
end

return Element

end)()

-- ── elements/Dropdown.lua ──
_VYNX_MODULES["elements/Dropdown.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = cloneref(game:GetService("Players")).LocalPlayer:GetMouse()
local Camera = cloneref(game:GetService("Workspace")).CurrentCamera

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateLabel = require("./components/ui/Label").New
local CreateInput = require("./components/ui/Input").New
local CreateDropdown = require("./components/ui/Dropdown").New

local CurrentCamera = workspace.CurrentCamera

local Element = {
	UICorner = 10,
	UIPadding = 12,
	MenuCorner = 14,
	MenuPadding = 4,
	TabPadding = 8,
	SearchBarHeight = 36,
	TabIcon = 16,
	ItemHeight = 32,
}

function Element:New(Config)
	local Values = Config.Values or {}
	local SearchBarEnabled = Config.SearchBarEnabled
	if SearchBarEnabled == nil then
		if Config.Search ~= nil then
			SearchBarEnabled = Config.Search
		elseif Config.EnableSearch ~= nil then
			SearchBarEnabled = Config.EnableSearch
		else
			SearchBarEnabled = #Values >= (Config.SearchThreshold or 7)
		end
	end

	local Compact = Config.Compact ~= false

	local Dropdown = {
		__type = "Dropdown",
		Title = Config.Title or "Dropdown",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Values = Values,
		MenuWidth = Config.MenuWidth or (Compact and 164 or 180),
		MenuMaxWidth = Config.MenuMaxWidth,
		FullWidth = Config.FullWidth or Config.Full or Config.Mode == "Full" or Config.MenuMode == "Full",
		Direction = Config.Direction or Config.OpenDirection or "Auto",
		Side = Config.Side or Config.Align or Config.Alignment or "Right",
		MobileDirection = Config.MobileDirection or Config.MobileOpenDirection,
		MobileSide = Config.MobileSide or Config.MobileAlign,
		Value = Config.Value,
		AllowNone = Config.AllowNone,
		SearchBarEnabled = SearchBarEnabled == true,
		SearchPlaceholder = Config.SearchPlaceholder or "Search...",
		Compact = Compact,
		Glass = Config.Glass == true,
		GlassTransparency = Config.GlassTransparency or Config.MenuTransparency or 0,
		ItemHeight = Config.ItemHeight or (Compact and Element.ItemHeight or 36),
		Multi = Config.Multi,
		Callback = Config.Callback or nil,

		UIElements = {},

		Opened = false,
		Tabs = {},

		Width = Config.Width or (Compact and 136 or 150),
	}

	if Dropdown.Multi and not Dropdown.Value then
		Dropdown.Value = {}
	end
	if Dropdown.Values and typeof(Dropdown.Value) == "number" then
		Dropdown.Value = Dropdown.Values[Dropdown.Value]
	end

	Dropdown.DropdownFrame = require("./components/window/Element")({
		Title = Dropdown.Title,
		Desc = Dropdown.Desc,
		Parent = Config.Parent,
		TextOffset = Dropdown.Callback and Dropdown.Width or 20,
		Hover = not Dropdown.Callback and true or false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Dropdown,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	if Dropdown.Callback then
		Dropdown.UIElements.Dropdown =
			CreateLabel("", nil, Dropdown.DropdownFrame.UIElements.Main, nil, Config.Window.NewElements and 12 or 10)

		Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = "AtEnd"
		Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size =
			UDim2.new(1, Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12, 0, 0)

		Dropdown.UIElements.Dropdown.Size = UDim2.new(0, Dropdown.Width, 0, Compact and 32 or 36)
		Dropdown.UIElements.Dropdown.Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0)
		Dropdown.UIElements.Dropdown.AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5)

		-- New("UIScale", {
		--     Parent = Dropdown.UIElements.Dropdown,
		--     Scale = .85,
		-- })
	end

	Dropdown.DropdownMenu = CreateDropdown(Config, Dropdown, Element, "Dropdown")

	Dropdown.Display = Dropdown.DropdownMenu.Display
	Dropdown.Refresh = Dropdown.DropdownMenu.Refresh
	Dropdown.Select = Dropdown.DropdownMenu.Select
	Dropdown.Open = Dropdown.DropdownMenu.Open
	Dropdown.Close = Dropdown.DropdownMenu.Close

	local DropdownIcon = New("ImageLabel", {
		Image = Creator.Icon("chevrons-up-down")[1],
		ImageRectOffset = Creator.Icon("chevrons-up-down")[2].ImageRectPosition,
		ImageRectSize = Creator.Icon("chevrons-up-down")[2].ImageRectSize,
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(1, Dropdown.UIElements.Dropdown and -12 or 0, 0.5, 0),
		ThemeTag = {
			ImageColor3 = "Icon",
		},
		AnchorPoint = Vector2.new(1, 0.5),
		Parent = Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown.Frame
			or Dropdown.DropdownFrame.UIElements.Main,
	})

	function Dropdown:Lock()
		Dropdown.Locked = true
		if Dropdown.Opened or Dropdown.UIElements.MenuCanvas.Visible then
			Dropdown:Close()
		end
		return Dropdown.DropdownFrame:Lock(Dropdown.LockedTitle)
	end
	function Dropdown:Unlock()
		Dropdown.Locked = false
		return Dropdown.DropdownFrame:Unlock()
	end

	if Dropdown.Locked then
		Dropdown:Lock()
	end

	return Dropdown.__type, Dropdown
end

return Element

end)()

-- ── elements/Code.lua ──
_VYNX_MODULES["elements/Code.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

-- local Highlighter = require("../Highlighter")
local CodeComponent = require("./components/ui/Code")

local Element = {}

function Element:New(Config)
	local Code = {
		__type = "Code",
		Title = Config.Title,
		Code = Config.Code,
		CodeSize = Config.CodeSize or 18,
		Height = Config.Height,
		CodeTheme = Config.CodeTheme,
		Locked = false,
		CanCopied = Config.CanCopied ~= false,
		OnCopy = Config.OnCopy,
		LinkCorners = Config.LinkCorners,
		CornerGroup = Config.CornerGroup or Config.LinkCornerGroup,
		CornerBreak = Config.CornerBreak,
		CornerBreakBefore = Config.CornerBreakBefore,
		CornerBreakAfter = Config.CornerBreakAfter,

		Index = Config.Index,
	}

	local CanCallback = not Code.Locked

	-- Code.CodeFrame = require("../Components/Element")({
	--     Title = Code.Title,
	--     Desc = Code.Code,
	--     Parent = Config.Parent,
	--     TextOffset = 40,
	--     Hover = false,
	-- })

	-- Code.CodeFrame.UIElements.Main.Title.Desc:Destroy()

	local CodeElement = CodeComponent.New(Code, Config.Window, Config.Parent, function()
		if CanCallback then
			local NewTitle = Code.Title or "code"
			local success, result = pcall(function()
				if toclipboard then
					toclipboard(Code.Code)
				end
				if setclipboard then
					setclipboard(Code.Code)
				end

				if Code.OnCopy then
					Code.OnCopy()
				end
			end)
			if not success then
				Config.WindUI:Notify({
					Title = "Error",
					Content = "The " .. NewTitle .. " is not copied. Error: " .. result,
					Icon = "x",
					Style = "Error",
					Duration = 5,
				})
			end
		end
	end, Config.WindUI.UIScale)

	function Code:SetCode(code)
		CodeElement.Set(code)
		Code.Code = code
	end

	function Code:Set(code)
		return Code.SetCode(code)
	end

	function Code:Destroy()
		CodeElement.Destroy()
		Code = nil
	end

	function Code.UpdateShape(Tab)
		if Config.Window.NewElements then
			local ShouldLinkCorners = Config.Window.ElementConfig.LinkCorners or Config.LinkCorners == true
			local newShape = "Squircle"

			if ShouldLinkCorners then
				newShape = Creator.GetLinkedCornerShape(
					Tab.Elements,
					Code.Index,
					Tab,
					Config.ParentType,
					Config.CornerLink
						or (Config.ParentConfig and Config.ParentConfig.CornerLink)
						or Config.Window.ElementConfig.CornerLink
				)
			end

			if newShape and CodeElement.CodeFrameModule then
				local DynamicShape = (newShape == "Squircle-TL-BL" or newShape == "Squircle-TR-BR") and "Squircle"
					or newShape

				CodeElement.CodeFrameModule:SetType(DynamicShape)
				--CodeElement.BackgroundFrameModule:SetType(newShape)
				CodeElement.TopbarFrameModule:SetType(
					table.find({ "Squircle-BL-BR", "SquircleH-BL-BR", "Squircle-TR-BR" }, newShape) ~= nil and "Square"
						or DynamicShape
				)
			end
		end
	end

	Code.UIElements = { Main = CodeElement.CodeFrame }
	Code.ElementFrame = CodeElement.CodeFrame

	return Code.__type, Code
end

return Element

end)()

-- ── elements/Colorpicker.lua ──
_VYNX_MODULES["elements/Colorpicker.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local TouchInputService = cloneref(game:GetService("TouchInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local RenderStepped = RunService.RenderStepped
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local CreateButton = require("./components/ui/Button").New
local CreateInput = require("./components/ui/Input").New

local Element = {
	UICorner = 9,
	--UIPadding = 8
}

local ActiveSlider = nil

function Element:Colorpicker(Config, Window, WindUI, OnApply)
	local Colorpicker = {
		__type = "Colorpicker",
		Title = Config.Title,
		Desc = Config.Desc,
		Default = Config.Value or Config.Default,
		Callback = Config.Callback,
		Transparency = Config.Transparency,
		UIElements = Config.UIElements,

		TextPadding = 10,
	}

	local Connections = {}
	local IsTransparency = Colorpicker.Transparency ~= nil

	function Colorpicker:SetHSVFromRGB(Color)
		local H, S, V = Color3.toHSV(Color)
		Colorpicker.Hue = H
		Colorpicker.Sat = S
		Colorpicker.Vib = V
	end

	Colorpicker:SetHSVFromRGB(Colorpicker.Default)

	local ColorpickerModule = require("./components/window/Dialog")
	local ColorpickerFrame = ColorpickerModule.Create(nil, "Dialog", Window, WindUI, Window.UIElements.Main.Main)

	Colorpicker.ColorpickerFrame = ColorpickerFrame

	ColorpickerFrame.UIElements.Main.Size = UDim2.new(1, 0, 0, 0)

	--ColorpickerFrame:Close()

	local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib

	Colorpicker.UIElements.Title = New("TextLabel", {
		Text = Colorpicker.Title,
		TextSize = 20,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextXAlignment = "Left",
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = "Y",
		ThemeTag = {
			TextColor3 = "Text",
		},
		BackgroundTransparency = 1,
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, Colorpicker.TextPadding / 2),
			PaddingLeft = UDim.new(0, Colorpicker.TextPadding / 2),
			PaddingRight = UDim.new(0, Colorpicker.TextPadding / 2),
			PaddingBottom = UDim.new(0, Colorpicker.TextPadding / 2),
		}),
	})

	-- Colorpicker.UIElements.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
	--     Colorpicker.UIElements.Title.Size = UDim2.new(1,0,0,Colorpicker.UIElements.Title.TextBounds.Y)
	-- end)

	local HueDragHolder = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
	})

	local SatCursor = New("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 0),
		Parent = HueDragHolder,
		BackgroundColor3 = Colorpicker.Default,
	}, {
		New("UIStroke", {
			Thickness = 2,
			Transparency = 0.1,
			ThemeTag = {
				Color = "Text",
			},
		}),
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
	})

	Colorpicker.UIElements.SatVibMap = New("ImageLabel", {
		Size = UDim2.fromOffset(160, 182 - 24),
		Position = UDim2.fromOffset(0, 40 + Colorpicker.TextPadding),
		Image = "rbxassetid://4155801252",
		BackgroundColor3 = Color3.fromHSV(Hue, 1, 1),
		BackgroundTransparency = 0,
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
		Creator.NewRoundFrame(8, "SquircleOutline", {
			ThemeTag = {
				ImageColor3 = "Outline",
			},
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.85,
			ZIndex = 99999,
		}, {
			New("UIGradient", {
				Rotation = 45,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0.0, 0.1),
					NumberSequenceKeypoint.new(0.5, 1),
					NumberSequenceKeypoint.new(1.0, 0.1),
				}),
			}),
		}),

		SatCursor,
	})

	Colorpicker.UIElements.Inputs = New("Frame", {
		AutomaticSize = "XY",
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.fromOffset(
			IsTransparency and 160 + 10 + 10 + 10 + 10 + 10 + 10 + 20 or 160 + 10 + 10 + 10 + 20,
			40 + Colorpicker.TextPadding
		),
		BackgroundTransparency = 1,
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 4),
			FillDirection = "Vertical",
		}),
	})

	--	Colorpicker.UIElements.Inputs.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	--         Colorpicker.UIElements.Inputs.Size = UDim2.new(0,Colorpicker.UIElements.Inputs.UIListLayout.AbsoluteContentSize.X,0,Colorpicker.UIElements.Inputs.UIListLayout.AbsoluteContentSize.Y)
	--     end)

	local OldColorFrame = New("Frame", {
		BackgroundColor3 = Colorpicker.Default,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = Colorpicker.Transparency,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
	})

	local OldColorFrameChecker = New("ImageLabel", {
		Image = "http://www.roblox.com/asset/?id=14204231522",
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(75 + 10, 40 + 182 - 24 + 10 + Colorpicker.TextPadding),
		Size = UDim2.fromOffset(75, 24),
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
		Creator.NewRoundFrame(8, "SquircleOutline", {
			ThemeTag = {
				ImageColor3 = "Outline",
			},
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.85,
			ZIndex = 99999,
		}, {
			New("UIGradient", {
				Rotation = 60,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0.0, 0.1),
					NumberSequenceKeypoint.new(0.5, 1),
					NumberSequenceKeypoint.new(1.0, 0.1),
				}),
			}),
		}),
		--		New("UIStroke", {
		--			Thickness = 1,
		--			Transparency = 0.8,
		--			ThemeTag = {
		--			    Color = "Text"
		--			}
		--		}),
		OldColorFrame,
	})

	local NewDisplayFrame = New("Frame", {
		BackgroundColor3 = Colorpicker.Default,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 0,
		ZIndex = 9,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
	})

	local NewDisplayFrameChecker = New("ImageLabel", {
		Image = "http://www.roblox.com/asset/?id=14204231522",
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 40 + 182 - 24 + 10 + Colorpicker.TextPadding),
		Size = UDim2.fromOffset(75, 24),
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
		--		New("UIStroke", {
		--			Thickness = 1,
		--			Transparency = 0.8,
		--			ThemeTag = {
		--			    Color = "Text"
		--			}
		--		}),
		Creator.NewRoundFrame(8, "SquircleOutline", {
			ThemeTag = {
				ImageColor3 = "Outline",
			},
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 0.85,
			ZIndex = 99999,
		}, {
			New("UIGradient", {
				Rotation = 60,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0.0, 0.1),
					NumberSequenceKeypoint.new(0.5, 1),
					NumberSequenceKeypoint.new(1.0, 0.1),
				}),
			}),
		}),
		NewDisplayFrame,
	})

	local SequenceTable = {}

	for Color = 0, 1, 0.1 do
		table.insert(SequenceTable, ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1)))
	end

	local HueSliderGradient = New("UIGradient", {
		Color = ColorSequence.new(SequenceTable),
		Rotation = 90,
	})

	local HueDrag = New("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 0),
		Parent = HueDragHolder,
		--Image = "rbxassetid://18747052224",
		--ScaleType = "Crop",
		BackgroundColor3 = Colorpicker.Default,
	}, {
		New("UIStroke", {
			Thickness = 2,
			Transparency = 0.1,
			ThemeTag = {
				Color = "Text",
			},
		}),
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
	})

	local HueSlider = New("Frame", {
		Size = UDim2.fromOffset(6, 182 + 10),
		Position = UDim2.fromOffset(160 + 10 + 10, 40 + Colorpicker.TextPadding),
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
		HueSliderGradient,
		HueDragHolder,
	})

	local function CreateNewInput(Title, Value)
		local InputFrame = CreateInput(Title, nil, Colorpicker.UIElements.Inputs, nil, nil, nil, nil, nil, true)

		New("TextLabel", {
			BackgroundTransparency = 1,
			TextTransparency = 0.4,
			TextSize = 17,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
			AutomaticSize = "XY",
			ThemeTag = {
				TextColor3 = "Placeholder",
			},
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Parent = InputFrame.Frame,
			Text = Title,
		})

		New("UIScale", {
			Parent = InputFrame,
			Scale = 0.85,
		})

		InputFrame.Frame.Frame.TextBox.Text = Value
		InputFrame.Size = UDim2.new(0, 30 * 5, 0, 42)

		return InputFrame
	end

	local function ToRGB(color)
		return {
			R = math.floor(color.R * 255),
			G = math.floor(color.G * 255),
			B = math.floor(color.B * 255),
		}
	end

	local HexInput = CreateNewInput("Hex", "#" .. Colorpicker.Default:ToHex())

	local RedInput = CreateNewInput("Red", ToRGB(Colorpicker.Default)["R"])
	local GreenInput = CreateNewInput("Green", ToRGB(Colorpicker.Default)["G"])
	local BlueInput = CreateNewInput("Blue", ToRGB(Colorpicker.Default)["B"])
	local AlphaInput
	if IsTransparency then
		AlphaInput = CreateNewInput("Alpha", ((1 - Colorpicker.Transparency) * 100) .. "%")
	end

	local ButtonsContent = New("Frame", {
		Size = UDim2.new(0, 0, 0, 40),
		AutomaticSize = "Y",
		Position = UDim2.new(0, 0, 0, 40 + 8 + 182 + 24 + Colorpicker.TextPadding),
		BackgroundTransparency = 1,
		Parent = ColorpickerFrame.UIElements.Main,
		LayoutOrder = 4,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Right",
		}),
		-- New("UIPadding", {
		--         PaddingTop = UDim.new(0, Colorpicker.TextPadding/2),
		--         PaddingLeft = UDim.new(0, Colorpicker.TextPadding/2),
		--         PaddingRight = UDim.new(0, Colorpicker.TextPadding/2),
		--         PaddingBottom = UDim.new(0, Colorpicker.TextPadding/2),
		--     })
	})

	Creator.AddSignal(ColorpickerFrame.UIElements.Main:GetPropertyChangedSignal("AbsoluteSize"), function()
		Colorpicker.UIElements.Title.Size = UDim2.new(
			0,
			ColorpickerFrame.UIElements.Main.AbsoluteSize.X / Config.UIScale - (ColorpickerFrame.UIPadding * 2),
			0,
			0
		)
		ButtonsContent.Size = UDim2.new(
			0,
			ColorpickerFrame.UIElements.Main.AbsoluteSize.X / Config.UIScale - ColorpickerFrame.UIPadding * 2,
			0,
			40
		)
	end)

	local Buttons = {
		{
			Title = "Cancel",
			Variant = "Secondary",
			Callback = function()
				Config.IsShowed = false
				for _, Conn in next, Connections do
					Conn:Disconnect()
				end
				Connections = {}
			end,
		},
		{
			Title = "Apply",
			--Icon = "chevron-right",
			Variant = "Primary",
			Callback = function()
				Config.IsShowed = false
				for _, Conn in next, Connections do
					Conn:Disconnect()
				end
				Connections = {}

				OnApply(Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib), Colorpicker.Transparency)
			end,
		},
	}

	for _, Button in next, Buttons do
		local ButtonFrame = CreateButton(
			Button.Title,
			Button.Icon,
			Button.Callback,
			Button.Variant,
			ButtonsContent,
			ColorpickerFrame,
			true
		)
		ButtonFrame.Size = UDim2.new(0.5, -3, 0, 40)
		ButtonFrame.AutomaticSize = "None"
	end

	local TransparencySlider, TransparencyDrag, TransparencyColor
	if IsTransparency then
		local TransparencyDragHolder = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
		})

		TransparencyDrag = New("ImageLabel", {
			Size = UDim2.new(0, 14, 0, 14),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0, 0),
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
			Parent = TransparencyDragHolder,
		}, {
			New("UIStroke", {
				Thickness = 2,
				Transparency = 0.1,
				ThemeTag = {
					Color = "Text",
				},
			}),
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		})

		TransparencyColor = New("Frame", {
			Size = UDim2.fromScale(1, 1),
		}, {
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Rotation = 270,
			}),
			New("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
		})

		TransparencySlider = New("Frame", {
			Size = UDim2.fromOffset(6, 182 + 10),
			Position = UDim2.fromOffset(160 + 10 + 10 + 10 + 10 + 10, 40 + Colorpicker.TextPadding),
			Parent = ColorpickerFrame.UIElements.Main,
			BackgroundTransparency = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			New("ImageLabel", {
				Image = "rbxassetid://14204231522",
				ImageTransparency = 0.45,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(40, 40),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),
			TransparencyColor,
			TransparencyDragHolder,
		})
	end

	function Colorpicker:Round(Number, Factor)
		if Factor == 0 then
			return math.floor(Number)
		end
		Number = tostring(Number)
		return Number:find("%.") and tonumber(Number:sub(1, Number:find("%.") + Factor)) or Number
	end

	function Colorpicker:Update(color, transparency)
		if color then
			Hue, Sat, Vib = Color3.toHSV(color)
		else
			Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
		end

		Colorpicker.UIElements.SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
		SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
		SatCursor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
		NewDisplayFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
		HueDrag.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
		HueDrag.Position = UDim2.new(0.5, 0, Hue, 0)

		HexInput.Frame.Frame.TextBox.Text = "#" .. Color3.fromHSV(Hue, Sat, Vib):ToHex()
		RedInput.Frame.Frame.TextBox.Text = ToRGB(Color3.fromHSV(Hue, Sat, Vib))["R"]
		GreenInput.Frame.Frame.TextBox.Text = ToRGB(Color3.fromHSV(Hue, Sat, Vib))["G"]
		BlueInput.Frame.Frame.TextBox.Text = ToRGB(Color3.fromHSV(Hue, Sat, Vib))["B"]

		if transparency or IsTransparency then
			NewDisplayFrame.BackgroundTransparency = Colorpicker.Transparency or transparency
			TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
			TransparencyDrag.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
			TransparencyDrag.BackgroundTransparency = Colorpicker.Transparency or transparency
			TransparencyDrag.Position = UDim2.new(0.5, 0, 1 - Colorpicker.Transparency or transparency, 0)
			AlphaInput.Frame.Frame.TextBox.Text = Colorpicker:Round(
				(1 - Colorpicker.Transparency or transparency) * 100,
				0
			) .. "%"
		end
	end

	Colorpicker:Update(Colorpicker.Default, Colorpicker.Transparency)

	local function GetRGB()
		local Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)
		return { R = math.floor(Value.r * 255), G = math.floor(Value.g * 255), B = math.floor(Value.b * 255) }
	end

	-- oh no!

	local function clamp(val, min, max)
		return math.clamp(tonumber(val) or 0, min, max)
	end

	table.insert(
		Connections,
		Creator.AddSignal(HexInput.Frame.Frame.TextBox.FocusLost, function(Enter)
			if Enter then
				local hex = HexInput.Frame.Frame.TextBox.Text:gsub("#", "")
				local Success, Result = pcall(Color3.fromHex, hex)
				if Success and typeof(Result) == "Color3" then
					Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib = Color3.toHSV(Result)
					Colorpicker:Update()
					Colorpicker.Default = Result
				end
			end
		end)
	)

	local function updateColorFromInput(inputBox, component)
		Creator.AddSignal(inputBox.Frame.Frame.TextBox.FocusLost, function(Enter)
			if Enter then
				local textBox = inputBox.Frame.Frame.TextBox
				local current = GetRGB()
				local clamped = clamp(textBox.Text, 0, 255)
				textBox.Text = tostring(clamped)

				current[component] = clamped
				local Result = Color3.fromRGB(current.R, current.G, current.B)
				Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib = Color3.toHSV(Result)
				Colorpicker:Update()
			end
		end)
	end

	updateColorFromInput(RedInput, "R")
	updateColorFromInput(GreenInput, "G")
	updateColorFromInput(BlueInput, "B")

	if IsTransparency then
		Creator.AddSignal(AlphaInput.Frame.Frame.TextBox.FocusLost, function(Enter)
			if Enter then
				local textBox = AlphaInput.Frame.Frame.TextBox
				local clamped = clamp(textBox.Text, 0, 100)
				textBox.Text = tostring(clamped)

				Colorpicker.Transparency = 1 - clamped * 0.01
				Colorpicker:Update(nil, Colorpicker.Transparency)
			end
		end)
	end

	-- fu

	local function UpdateSatVib(SatVibMap, Colorpicker)
		local MinX = SatVibMap.AbsolutePosition.X
		local MaxX = MinX + SatVibMap.AbsoluteSize.X
		local MinY = SatVibMap.AbsolutePosition.Y
		local MaxY = MinY + SatVibMap.AbsoluteSize.Y

		local MouseX = math.clamp(Mouse.X, MinX, MaxX)
		local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

		Colorpicker.Sat = (MouseX - MinX) / (MaxX - MinX)
		Colorpicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))

		Colorpicker:Update()
	end

	local function UpdateHue(HueSlider, Colorpicker)
		local MinY = HueSlider.AbsolutePosition.Y
		local MaxY = MinY + HueSlider.AbsoluteSize.Y

		local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

		Colorpicker.Hue = (MouseY - MinY) / (MaxY - MinY)

		Colorpicker:Update()
	end

	local function UpdateTransparency(TransparencySlider, Colorpicker)
		local MinY = TransparencySlider.AbsolutePosition.Y
		local MaxY = MinY + TransparencySlider.AbsoluteSize.Y

		local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

		Colorpicker.Transparency = 1 - ((MouseY - MinY) / (MaxY - MinY))

		Colorpicker:Update()
	end

	local CurInput = WindUI.GenerateGUID()

	table.insert(
		Connections,
		UserInputService.InputChanged:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseMovement
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			if ActiveSlider == "SatVib" then
				UpdateSatVib(Colorpicker.UIElements.SatVibMap, Colorpicker)
			elseif ActiveSlider == "Hue" then
				UpdateHue(HueSlider, Colorpicker)
			elseif ActiveSlider == "Transparency" then
				UpdateTransparency(TransparencySlider, Colorpicker)
			end
		end)
	)

	table.insert(
		Connections,
		Colorpicker.UIElements.SatVibMap.InputBegan:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			if WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then
				return
			end
			WindUI.CurrentInput = CurInput

			if ActiveSlider and ActiveSlider ~= "SatVib" then
				return
			end

			ActiveSlider = "SatVib"

			UpdateSatVib(Colorpicker.UIElements.SatVibMap, Colorpicker)
		end)
	)

	table.insert(
		Connections,
		HueSlider.InputBegan:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			if WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then
				return
			end
			WindUI.CurrentInput = CurInput

			if ActiveSlider and ActiveSlider ~= "Hue" then
				return
			end

			ActiveSlider = "Hue"

			UpdateHue(HueSlider, Colorpicker)
		end)
	)

	if TransparencySlider then
		table.insert(
			Connections,
			TransparencySlider.InputBegan:Connect(function(input)
				if
					input.UserInputType ~= Enum.UserInputType.MouseButton1
					and input.UserInputType ~= Enum.UserInputType.Touch
				then
					return
				end

				if WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then
					return
				end
				WindUI.CurrentInput = CurInput

				if ActiveSlider and ActiveSlider ~= "Transparency" then
					return
				end

				ActiveSlider = "Transparency"

				UpdateTransparency(TransparencySlider, Colorpicker)
			end)
		)
	end

	table.insert(
		Connections,
		UserInputService.InputEnded:Connect(function(input)
			ActiveSlider = nil

			if WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then
				return
			end
			WindUI.CurrentInput = nil
		end)
	)

	return Colorpicker
end

function Element:New(Config)
	local Colorpicker = {
		__type = "Colorpicker",
		Title = Config.Title or "Colorpicker",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Default = Config.Default or Color3.new(1, 1, 1),
		Callback = Config.Callback or function() end,
		--Window = Config.Window,
		UIScale = Config.UIScale,
		Transparency = Config.Transparency,
		UIElements = {},

		IsShowed = false,
	}

	local CanCallback = true

	--if Config.Window.NewElements then Element.UICorner = 14 end

	Colorpicker.ColorpickerFrame = require("./components/window/Element")({
		Title = Colorpicker.Title,
		Desc = Colorpicker.Desc,
		Parent = Config.Parent,
		TextOffset = 40,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Colorpicker,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Colorpicker.UIElements.Colorpicker = Creator.NewRoundFrame(Element.UICorner, "Squircle", {
		ImageTransparency = 0,
		Active = true,
		ImageColor3 = Colorpicker.Default,
		Parent = Colorpicker.ColorpickerFrame.UIElements.Main,
		Size = UDim2.new(0, 26, 0, 26),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		ZIndex = 2,
	}, {
		Creator.NewRoundFrame(Element.UICorner, "SquircleGlass", {
			Size = UDim2.new(1, 0, 1, 0),
			ThemeTag = {
				ImageColor3 = "Outline",
			},
			ImageTransparency = 0.55,
		}),
	}, true)

	function Colorpicker:Lock()
		Colorpicker.Locked = true
		CanCallback = false
		return Colorpicker.ColorpickerFrame:Lock(Colorpicker.LockedTitle)
	end
	function Colorpicker:Unlock()
		Colorpicker.Locked = false
		CanCallback = true
		return Colorpicker.ColorpickerFrame:Unlock()
	end

	if Colorpicker.Locked then
		Colorpicker:Lock()
	end

	function Colorpicker:Update(Color, Transparency)
		Colorpicker.UIElements.Colorpicker.ImageTransparency = Transparency or 0
		Colorpicker.UIElements.Colorpicker.ImageColor3 = Color
		Colorpicker.Default = Color
		if Transparency then
			Colorpicker.Transparency = Transparency
		end
	end

	function Colorpicker:Set(c, t)
		return Colorpicker:Update(c, t)
	end

	Creator.AddSignal(Colorpicker.UIElements.Colorpicker.MouseButton1Click, function()
		if CanCallback and not Colorpicker.IsShowed then
			Colorpicker.IsShowed = true

			Element:Colorpicker(Colorpicker, Config.Window, Config.WindUI, function(color, transparency)
				Colorpicker:Update(color, transparency)
				Colorpicker.Default = color
				Colorpicker.Transparency = transparency
				Creator.SafeCallback(Colorpicker.Callback, color, transparency)
			end).ColorpickerFrame
				:Open()
		end
	end)

	return Colorpicker.__type, Colorpicker
end

return Element

end)()

-- ── elements/Checkbox.lua ──
_VYNX_MODULES["elements/Checkbox.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local Checkbox = {
		__type    = "Checkbox",
		Type      = "Checkbox",
		Title     = Config.Title or Config.Text or "Checkbox",
		Value     = Config.Default ~= nil and Config.Default or false,
		Locked    = Config.Locked or false,
		Callback  = Config.Callback or function() end,
		OnChanged = Instance.new("BindableEvent"),
		UIElements = {},
	}

	local Frame = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 28),
		Parent = Config.Parent,
	})

	local Box = New("Frame", {
		AnchorPoint      = Vector2.new(0, 0.5),
		Position         = UDim2.new(0, 0, 0.5, 0),
		Size             = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Color3.fromHex("#2A2A38"),
		Parent           = Frame,
	}, {
		New("UICorner", { CornerRadius = UDim.new(0, 4) }),
		New("UIStroke", { Color = Color3.fromHex("#2a2a3a"), Thickness = 1 }),
	})

	local Check = New("ImageLabel", {
		Size                 = UDim2.fromScale(0.75, 0.75),
		AnchorPoint          = Vector2.new(0.5, 0.5),
		Position             = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Image                = "rbxassetid://97682394690683",
		ImageColor3          = Color3.new(1, 1, 1),
		ImageTransparency    = 1,
		Parent               = Box,
	})

	New("TextLabel", {
		AnchorPoint          = Vector2.new(0, 0.5),
		Position             = UDim2.new(0, 24, 0.5, 0),
		Size                 = UDim2.new(1, -24, 1, 0),
		BackgroundTransparency = 1,
		Text                 = Checkbox.Title,
		TextColor3           = Color3.new(1, 1, 1),
		TextTransparency     = 0.35,
		TextSize             = 13,
		TextXAlignment       = Enum.TextXAlignment.Left,
		FontFace             = Font.fromEnum(Enum.Font.GothamSsm),
		Parent               = Frame,
	})

	local Hit = New("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text                 = "",
		ZIndex               = 5,
		Parent               = Frame,
	})

	local function UpdateVisual(v)
		Box.BackgroundColor3 = v and Color3.fromHex("#7C5CFF") or Color3.fromHex("#2A2A38")
		Check.ImageTransparency = v and 0 or 1
	end

	UpdateVisual(Checkbox.Value)

	Hit.MouseButton1Click:Connect(function()
		if Checkbox.Locked then return end
		Checkbox.Value = not Checkbox.Value
		UpdateVisual(Checkbox.Value)
		Checkbox.Callback(Checkbox.Value)
		Checkbox.OnChanged:Fire(Checkbox.Value)
	end)

	function Checkbox:SetValue(v)
		Checkbox.Value = v
		UpdateVisual(v)
	end

	function Checkbox:Destroy()
		Frame:Destroy()
		Checkbox.OnChanged:Destroy()
	end

	Checkbox.UIElements.Frame = Frame
	Checkbox.ElementFrame     = Frame
	return Frame, Checkbox
end

return Element

end)()

-- ── elements/UIPassthrough.lua ──
_VYNX_MODULES["elements/UIPassthrough.lua"] = (function()
local Element = {}

function Element:New(Config)
	assert(Config.Instance, "UIPassthrough: Instance must be provided")
	assert(
		typeof(Config.Instance) == "Instance" and Config.Instance:IsA("GuiBase2d"),
		"UIPassthrough: Instance must inherit GuiBase2d"
	)
	local height = Config.Height or 60
	assert(typeof(height) == "number" and height > 0, "UIPassthrough: Height must be > 0")

	local Passthrough = {
		__type   = "UIPassthrough",
		Type     = "UIPassthrough",
		Instance = Config.Instance,
		Height   = height,
		Visible  = Config.Visible ~= false,
	}

	local Holder
	do
		local New = function(cls, props)
			local inst = Instance.new(cls)
			for k, v in props do inst[k] = v end
			return inst
		end
		Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size    = UDim2.new(1, 0, 0, height),
			Visible = Passthrough.Visible,
			Parent  = Config.Parent,
		})
	end

	Config.Instance.Parent = Holder

	function Passthrough:SetHeight(h)
		assert(typeof(h) == "number" and h > 0, "Height must be > 0")
		Passthrough.Height = h
		Holder.Size = UDim2.new(1, 0, 0, h)
	end

	function Passthrough:SetInstance(inst)
		assert(inst and typeof(inst) == "Instance" and inst:IsA("GuiBase2d"),
			"Instance must inherit GuiBase2d")
		if Passthrough.Instance then Passthrough.Instance.Parent = nil end
		Passthrough.Instance = inst
		inst.Parent = Holder
	end

	function Passthrough:SetVisible(v)
		Passthrough.Visible = v
		Holder.Visible = v
	end

	function Passthrough:Destroy()
		if Holder then Holder:Destroy() end
	end

	Passthrough.Holder       = Holder
	Passthrough.ElementFrame = Holder
	return Holder, Passthrough
end

return Element

end)()

-- ── elements/RadioGroup.lua ──
_VYNX_MODULES["elements/RadioGroup.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./ModernControlUtils")

local Element = {}

local function GetControlWidth(Config)
	return math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or 220, 120)
end

function Element:New(Config)
	local RadioGroup = {
		__type = "RadioGroup",
		Title = Config.Title or "Radio Group",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Options = Utils.NormalizeOptions(Config.Options or Config.Values or {}),
		Value = Config.Value,
		AllowNone = Config.AllowNone == true,
		Callback = Config.Callback or function() end,
		UIElements = {},
		OptionFrames = {},
		Animation = Config.Animation ~= false,

		Width = GetControlWidth(Config),
	}

	if RadioGroup.Value == nil then
		RadioGroup.Value = Config.Default
	end
	if typeof(RadioGroup.Value) == "number" and RadioGroup.Options[RadioGroup.Value] then
		RadioGroup.Value = RadioGroup.Options[RadioGroup.Value].Value
	end
	if RadioGroup.Value == nil and not RadioGroup.AllowNone and RadioGroup.Options[1] then
		RadioGroup.Value = RadioGroup.Options[1].Value
	end

	local CanCallback = true

	RadioGroup.RadioGroupFrame = require("./components/window/Element")({
		Title = RadioGroup.Title,
		Desc = RadioGroup.Desc,
		Parent = Config.Parent,
		TextOffset = RadioGroup.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = RadioGroup,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	RadioGroup.UIElements.Options = New("Frame", {
		Name = "RadioGroupOptions",
		Size = UDim2.new(0, RadioGroup.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = RadioGroup.RadioGroupFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
			HorizontalAlignment = "Right",
			SortOrder = "LayoutOrder",
		}),
	})

	local function UpdateOptionVisuals(IsAnimated)
		for _, Data in next, RadioGroup.OptionFrames do
			local Selected = Data.Option.Value == RadioGroup.Value
			local RowTransparency = Selected and 0.84 or 0.94
			local DotTransparency = Selected and 0 or 1
			local TitleTransparency = Data.Option.Disabled and 0.55 or (Selected and 0 or 0.18)

			if IsAnimated and RadioGroup.Animation then
				Motion.Play(Data.Row, "Select", { ImageTransparency = RowTransparency }, nil, nil, "Select")
				Motion.Play(Data.Dot, "Select", { ImageTransparency = DotTransparency }, nil, nil, "Select")
				Motion.Play(Data.Title, "Select", { TextTransparency = TitleTransparency }, nil, nil, "Select")
			else
				Data.Row.ImageTransparency = RowTransparency
				Data.Dot.ImageTransparency = DotTransparency
				Data.Title.TextTransparency = TitleTransparency
			end
		end
	end

	local function CreateOption(Option, Index)
		local Dot = Creator.NewRoundFrame(99, "Circle", {
			Name = "Dot",
			Size = UDim2.new(0, 8, 0, 8),
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "RadioGroupActive",
			},
		})

		local Ring = Creator.NewRoundFrame(99, "CircleOutline", {
			Name = "Ring",
			Size = UDim2.new(0, 18, 0, 18),
			ImageTransparency = Option.Disabled and 0.75 or 0.45,
			ThemeTag = {
				ImageColor3 = "RadioGroupBorder",
			},
		}, {
			Dot,
		})
		Dot.Position = UDim2.new(0.5, 0, 0.5, 0)
		Dot.AnchorPoint = Vector2.new(0.5, 0.5)

		local Title = New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -28, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Text = Option.Title,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = "Left",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			ThemeTag = {
				TextColor3 = "RadioGroupText",
			},
		})

		local Row = Creator.NewRoundFrame(12, "Squircle", {
			Name = "Option",
			Size = UDim2.new(1, 0, 0, 36),
			LayoutOrder = Index,
			ImageTransparency = 0.94,
			Active = not Option.Disabled,
			ThemeTag = {
				ImageColor3 = "RadioGroupBackground",
			},
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Left",
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			Ring,
			Title,
		}, true)

		Row.Parent = RadioGroup.UIElements.Options

		local Data = {
			Row = Row,
			Ring = Ring,
			Dot = Dot,
			Title = Title,
			Option = Option,
		}
		RadioGroup.OptionFrames[Index] = Data

		Motion.AttachPress(Row, Creator, {
			Enabled = function()
				return RadioGroup.Animation and not RadioGroup.Locked and not Option.Disabled
			end,
		})

		Creator.AddSignal(Row.MouseButton1Click, function()
			if not Option.Disabled then
				RadioGroup:Select(Option.Value)
			end
		end)
	end

	local function RenderOptions()
		for _, Data in next, RadioGroup.OptionFrames do
			if Data.Row then
				Data.Row:Destroy()
			end
		end

		RadioGroup.OptionFrames = {}

		for Index, Option in next, RadioGroup.Options do
			CreateOption(Option, Index)
		end

		UpdateOptionVisuals(false)
	end

	function RadioGroup:Lock()
		RadioGroup.Locked = true
		CanCallback = false
		return RadioGroup.RadioGroupFrame:Lock(RadioGroup.LockedTitle)
	end
	function RadioGroup:Unlock()
		RadioGroup.Locked = false
		CanCallback = true
		return RadioGroup.RadioGroupFrame:Unlock()
	end

	function RadioGroup:Get()
		return RadioGroup.Value
	end

	function RadioGroup:Select(Value, IsCallback)
		local Option = Utils.FindOption(RadioGroup.Options, Value)
		if not Option and not RadioGroup.AllowNone then
			return RadioGroup.Value
		end
		if Option and Option.Disabled then
			return RadioGroup.Value
		end

		RadioGroup.Value = Value
		UpdateOptionVisuals(true)

		if CanCallback and IsCallback ~= false then
			Creator.SafeCallback(RadioGroup.Callback, Value, Option)
		end

		return RadioGroup.Value
	end

	function RadioGroup:SetOptions(Options)
		RadioGroup.Options = Utils.NormalizeOptions(Options)

		if not Utils.FindOption(RadioGroup.Options, RadioGroup.Value) then
			RadioGroup.Value = RadioGroup.AllowNone and nil or (RadioGroup.Options[1] and RadioGroup.Options[1].Value)
		end

		RenderOptions()
		return RadioGroup.Options
	end

	RenderOptions()

	if RadioGroup.Locked then
		RadioGroup:Lock()
	end

	return RadioGroup.__type, RadioGroup
end

return Element

end)()

-- ── elements/CheckboxGroup.lua ──
_VYNX_MODULES["elements/CheckboxGroup.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./ModernControlUtils")

local Element = {}

local function GetControlWidth(Config)
	return math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or 220, 120)
end

function Element:New(Config)
	local CheckboxGroup = {
		__type = "CheckboxGroup",
		Title = Config.Title or "Checkbox Group",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Options = Utils.NormalizeOptions(Config.Options or Config.Values or {}),
		Values = Utils.NormalizeValues(Config.ValuesSelected or Config.SelectedValues or Config.Value or Config.ValuesDefault),
		Callback = Config.Callback or function() end,
		UIElements = {},
		OptionFrames = {},
		Animation = Config.Animation ~= false,

		Width = GetControlWidth(Config),
	}

	local CanCallback = true

	CheckboxGroup.CheckboxGroupFrame = require("./components/window/Element")({
		Title = CheckboxGroup.Title,
		Desc = CheckboxGroup.Desc,
		Parent = Config.Parent,
		TextOffset = CheckboxGroup.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = CheckboxGroup,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	CheckboxGroup.UIElements.Options = New("Frame", {
		Name = "CheckboxGroupOptions",
		Size = UDim2.new(0, CheckboxGroup.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = CheckboxGroup.CheckboxGroupFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
			HorizontalAlignment = "Right",
			SortOrder = "LayoutOrder",
		}),
	})

	local function SanitizeValues(Values)
		local Sanitized = {}

		for _, Value in next, Values or {} do
			local Option = Utils.FindOption(CheckboxGroup.Options, Value)
			if Option and not Option.Disabled and not Utils.ContainsValue(Sanitized, Value) then
				table.insert(Sanitized, Value)
			end
		end

		return Sanitized
	end

	local function UpdateOptionVisuals(IsAnimated)
		for _, Data in next, CheckboxGroup.OptionFrames do
			local Selected = Utils.ContainsValue(CheckboxGroup.Values, Data.Option.Value)
			local RowTransparency = Selected and 0.84 or 0.94
			local FillTransparency = Selected and 0 or 1
			local IconTransparency = Selected and 0 or 1
			local TitleTransparency = Data.Option.Disabled and 0.55 or (Selected and 0 or 0.18)

			if IsAnimated and CheckboxGroup.Animation then
				Motion.Play(Data.Row, "Select", { ImageTransparency = RowTransparency }, nil, nil, "Select")
				Motion.Play(Data.Fill, "Select", { ImageTransparency = FillTransparency }, nil, nil, "Select")
				Motion.Play(Data.Icon, "Select", { ImageTransparency = IconTransparency }, nil, nil, "Select")
				Motion.Play(Data.Title, "Select", { TextTransparency = TitleTransparency }, nil, nil, "Select")
			else
				Data.Row.ImageTransparency = RowTransparency
				Data.Fill.ImageTransparency = FillTransparency
				Data.Icon.ImageTransparency = IconTransparency
				Data.Title.TextTransparency = TitleTransparency
			end
		end
	end

	local function CreateOption(Option, Index)
		local IconInfo = Creator.Icon("check")
		local CheckIcon = New("ImageLabel", {
			Name = "Check",
			Size = UDim2.new(0, 12, 0, 12),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = IconInfo[1],
			ImageRectOffset = IconInfo[2].ImageRectPosition,
			ImageRectSize = IconInfo[2].ImageRectSize,
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupIcon",
			},
		})

		local Fill = Creator.NewRoundFrame(5, "Squircle", {
			Name = "Fill",
			Size = UDim2.new(1, 0, 1, 0),
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupActive",
			},
		}, {
			CheckIcon,
		})

		local Box = Creator.NewRoundFrame(5, "SquircleOutline", {
			Name = "Box",
			Size = UDim2.new(0, 18, 0, 18),
			ImageTransparency = Option.Disabled and 0.75 or 0.45,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupBorder",
			},
		}, {
			Fill,
		})

		local Title = New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -28, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Text = Option.Title,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = "Left",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			ThemeTag = {
				TextColor3 = "CheckboxGroupText",
			},
		})

		local Row = Creator.NewRoundFrame(12, "Squircle", {
			Name = "Option",
			Size = UDim2.new(1, 0, 0, 36),
			LayoutOrder = Index,
			ImageTransparency = 0.94,
			Active = not Option.Disabled,
			ThemeTag = {
				ImageColor3 = "CheckboxGroupBackground",
			},
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Left",
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			Box,
			Title,
		}, true)

		Row.Parent = CheckboxGroup.UIElements.Options

		local Data = {
			Row = Row,
			Fill = Fill,
			Icon = CheckIcon,
			Title = Title,
			Option = Option,
		}
		CheckboxGroup.OptionFrames[Index] = Data

		Motion.AttachPress(Row, Creator, {
			Enabled = function()
				return CheckboxGroup.Animation and not CheckboxGroup.Locked and not Option.Disabled
			end,
		})

		Creator.AddSignal(Row.MouseButton1Click, function()
			if not Option.Disabled then
				CheckboxGroup:Toggle(Option.Value)
			end
		end)
	end

	local function RenderOptions()
		for _, Data in next, CheckboxGroup.OptionFrames do
			if Data.Row then
				Data.Row:Destroy()
			end
		end

		CheckboxGroup.OptionFrames = {}

		for Index, Option in next, CheckboxGroup.Options do
			CreateOption(Option, Index)
		end

		CheckboxGroup.Values = SanitizeValues(CheckboxGroup.Values)
		UpdateOptionVisuals(false)
	end

	function CheckboxGroup:Lock()
		CheckboxGroup.Locked = true
		CanCallback = false
		return CheckboxGroup.CheckboxGroupFrame:Lock(CheckboxGroup.LockedTitle)
	end
	function CheckboxGroup:Unlock()
		CheckboxGroup.Locked = false
		CanCallback = true
		return CheckboxGroup.CheckboxGroupFrame:Unlock()
	end

	function CheckboxGroup:Get()
		return Utils.CloneArray(CheckboxGroup.Values)
	end

	function CheckboxGroup:Set(Values, IsCallback)
		CheckboxGroup.Values = SanitizeValues(Utils.NormalizeValues(Values))
		UpdateOptionVisuals(true)

		if CanCallback and IsCallback ~= false then
			Creator.SafeCallback(CheckboxGroup.Callback, CheckboxGroup:Get())
		end

		return CheckboxGroup:Get()
	end

	function CheckboxGroup:Toggle(Value, IsCallback)
		local Option = Utils.FindOption(CheckboxGroup.Options, Value)
		if not Option or Option.Disabled then
			return CheckboxGroup:Get()
		end

		CheckboxGroup.Values = Utils.ToggleValue(CheckboxGroup.Values, Value)
		return CheckboxGroup:Set(CheckboxGroup.Values, IsCallback)
	end

	function CheckboxGroup:SetOptions(Options)
		CheckboxGroup.Options = Utils.NormalizeOptions(Options)
		RenderOptions()
		return CheckboxGroup.Options
	end

	RenderOptions()

	if CheckboxGroup.Locked then
		CheckboxGroup:Lock()
	end

	return CheckboxGroup.__type, CheckboxGroup
end

return Element

end)()

-- ── elements/SegmentedControl.lua ──
_VYNX_MODULES["elements/SegmentedControl.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./ModernControlUtils")

local Element = {}

local function GetControlWidth(Config)
	return math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or 220, 120)
end

function Element:New(Config)
	local SegmentedControl = {
		__type = "SegmentedControl",
		Title = Config.Title or "Segmented Control",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Options = Utils.NormalizeOptions(Config.Options or Config.Values or {}),
		Value = Config.Value or Config.Default,
		Callback = Config.Callback or function() end,
		UIElements = {},
		Segments = {},
		Animation = Config.Animation ~= false,

		Width = GetControlWidth(Config),
	}

	if typeof(SegmentedControl.Value) == "number" and SegmentedControl.Options[SegmentedControl.Value] then
		SegmentedControl.Value = SegmentedControl.Options[SegmentedControl.Value].Value
	end
	if SegmentedControl.Value == nil and SegmentedControl.Options[1] then
		SegmentedControl.Value = SegmentedControl.Options[1].Value
	end

	local CanCallback = true

	SegmentedControl.SegmentedControlFrame = require("./components/window/Element")({
		Title = SegmentedControl.Title,
		Desc = SegmentedControl.Desc,
		Parent = Config.Parent,
		TextOffset = SegmentedControl.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = SegmentedControl,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	SegmentedControl.UIElements.Container = Creator.NewRoundFrame(13, "Squircle", {
		Name = "SegmentedControl",
		Size = UDim2.new(0, SegmentedControl.Width, 0, 36),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		ImageTransparency = 0.93,
		ThemeTag = {
			ImageColor3 = "SegmentedControlBackground",
		},
		Parent = SegmentedControl.SegmentedControlFrame.UIElements.Main,
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
		}),
	})

	local function UpdateSegmentVisuals(IsAnimated)
		for _, Segment in next, SegmentedControl.Segments do
			local Selected = Segment.Option.Value == SegmentedControl.Value
			local BackgroundTransparency = Selected and 0.82 or 1
			local TextTransparency = Segment.Option.Disabled and 0.55 or (Selected and 0 or 0.25)

			if IsAnimated and SegmentedControl.Animation then
				Motion.Play(Segment.Button, "Select", { ImageTransparency = BackgroundTransparency }, nil, nil, "Select")
				Motion.Play(Segment.Title, "Select", { TextTransparency = TextTransparency }, nil, nil, "Select")
			else
				Segment.Button.ImageTransparency = BackgroundTransparency
				Segment.Title.TextTransparency = TextTransparency
			end
		end
	end

	local function CreateSegment(Option, Index, Count)
		local Gap = 4
		local SegmentWidth = math.max((SegmentedControl.Width - 8 - (Gap * (Count - 1))) / math.max(Count, 1), 24)

		local Title = New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -10, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Text = Option.Title,
			TextSize = 13,
			TextTruncate = "AtEnd",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			ThemeTag = {
				TextColor3 = "SegmentedControlText",
			},
		})

		local Button = Creator.NewRoundFrame(10, "Squircle", {
			Name = "Segment",
			Size = UDim2.new(0, SegmentWidth, 1, 0),
			Position = UDim2.new(0, (Index - 1) * (SegmentWidth + Gap) + 4, 0, 4),
			ImageTransparency = 1,
			Active = not Option.Disabled,
			ThemeTag = {
				ImageColor3 = "SegmentedControlActive",
			},
		}, {
			Title,
		}, true)

		Button.Parent = SegmentedControl.UIElements.Container

		local Segment = {
			Button = Button,
			Title = Title,
			Option = Option,
		}
		SegmentedControl.Segments[Index] = Segment

		Motion.AttachPress(Button, Creator, {
			Amount = 0.96,
			Enabled = function()
				return SegmentedControl.Animation and not SegmentedControl.Locked and not Option.Disabled
			end,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			if not Option.Disabled then
				SegmentedControl:Select(Option.Value)
			end
		end)
	end

	local function RenderSegments()
		for _, Segment in next, SegmentedControl.Segments do
			if Segment.Button then
				Segment.Button:Destroy()
			end
		end

		SegmentedControl.Segments = {}

		local Count = #SegmentedControl.Options
		for Index, Option in next, SegmentedControl.Options do
			CreateSegment(Option, Index, Count)
		end

		UpdateSegmentVisuals(false)
	end

	function SegmentedControl:Lock()
		SegmentedControl.Locked = true
		CanCallback = false
		return SegmentedControl.SegmentedControlFrame:Lock(SegmentedControl.LockedTitle)
	end
	function SegmentedControl:Unlock()
		SegmentedControl.Locked = false
		CanCallback = true
		return SegmentedControl.SegmentedControlFrame:Unlock()
	end

	function SegmentedControl:Get()
		return SegmentedControl.Value
	end

	function SegmentedControl:Select(Value, IsCallback)
		local Option = Utils.FindOption(SegmentedControl.Options, Value)
		if not Option or Option.Disabled then
			return SegmentedControl.Value
		end

		SegmentedControl.Value = Value
		UpdateSegmentVisuals(true)

		if CanCallback and IsCallback ~= false then
			Creator.SafeCallback(SegmentedControl.Callback, Value, Option)
		end

		return SegmentedControl.Value
	end

	function SegmentedControl:SetOptions(Options)
		SegmentedControl.Options = Utils.NormalizeOptions(Options)

		if not Utils.FindOption(SegmentedControl.Options, SegmentedControl.Value) then
			SegmentedControl.Value = SegmentedControl.Options[1] and SegmentedControl.Options[1].Value or nil
		end

		RenderSegments()
		return SegmentedControl.Options
	end

	RenderSegments()

	if SegmentedControl.Locked then
		SegmentedControl:Lock()
	end

	return SegmentedControl.__type, SegmentedControl
end

return Element

end)()

-- ── elements/TextArea.lua ──
_VYNX_MODULES["elements/TextArea.lua"] = (function()
local Creator = require("../modules/Creator")

local CreateInput = require("./components/ui/Input").New

local Element = {}

function Element:New(Config)
	local TextArea = {
		__type = "TextArea",
		Title = Config.Title or "Text Area",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		InputIcon = Config.InputIcon or false,
		Placeholder = Config.Placeholder or "Enter Text...",
		Value = Config.Value or "",
		Callback = Config.Callback or function() end,
		ClearTextOnFocus = Config.ClearTextOnFocus or false,
		UIElements = {},
	}

	local CanCallback = true

	TextArea.TextAreaFrame = require("./components/window/Element")({
		Title = TextArea.Title,
		Desc = TextArea.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = TextArea,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local InputComponent = CreateInput(
		TextArea.Placeholder,
		TextArea.InputIcon,
		TextArea.TextAreaFrame.UIElements.Container,
		"Textarea",
		function(Value)
			TextArea:Set(Value, true, true)
		end,
		nil,
		Config.Window.NewElements and 12 or 10,
		TextArea.ClearTextOnFocus
	)
	InputComponent.Size = UDim2.new(1, 0, 0, Config.Height or 148)
	InputComponent.LayoutOrder = 99

	local TextBox = InputComponent.Frame.Frame.TextBox

	function TextArea:Lock()
		TextArea.Locked = true
		CanCallback = false
		return TextArea.TextAreaFrame:Lock(TextArea.LockedTitle)
	end
	function TextArea:Unlock()
		TextArea.Locked = false
		CanCallback = true
		return TextArea.TextAreaFrame:Unlock()
	end

	function TextArea:Get()
		return TextArea.Value
	end

	function TextArea:Set(Value, IsCallback, IsUserInput)
		if not CanCallback then
			return TextArea.Value
		end

		TextArea.Value = tostring(Value or "")

		if not IsUserInput then
			TextBox.Text = TextArea.Value
		end

		if IsCallback ~= false then
			Creator.SafeCallback(TextArea.Callback, TextArea.Value)
		end

		return TextArea.Value
	end

	function TextArea:SetPlaceholder(Value)
		TextArea.Placeholder = tostring(Value or "")
		TextBox.PlaceholderText = TextArea.Placeholder
	end

	TextArea:Set(TextArea.Value, false)

	if TextArea.Locked then
		TextArea:Lock()
	end

	return TextArea.__type, TextArea
end

return Element

end)()

-- ── elements/Stepper.lua ──
_VYNX_MODULES["elements/Stepper.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./ModernControlUtils")

local Element = {}

local function ReadValueConfig(Config)
	local ValueConfig = typeof(Config.Value) == "table" and Config.Value or {}
	local Min = Utils.ToFiniteNumber(ValueConfig.Min) or Utils.ToFiniteNumber(Config.Min) or 0
	local Max = Utils.ToFiniteNumber(ValueConfig.Max) or Utils.ToFiniteNumber(Config.Max) or 100

	if Min > Max then
		Min, Max = Max, Min
	end

	local Default = typeof(Config.Value) == "number" and Config.Value
		or Utils.ToFiniteNumber(ValueConfig.Default)
		or Utils.ToFiniteNumber(Config.Default)
		or Min
	local Increment = Utils.ToFiniteNumber(ValueConfig.Increment) or Utils.ToFiniteNumber(Config.Increment) or 1

	return Min, Max, math.clamp(Utils.ToFiniteNumber(Default) or Min, Min, Max), math.max(math.abs(Increment), 0.0001)
end

function Element:New(Config)
	local Min, Max, Default, Increment = ReadValueConfig(Config)
	local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local ShowButtons = Config.Buttons ~= false and Config.ShowButtons ~= false
	local ButtonSize = IsMobile and 38 or 34
	local ControlHeight = IsMobile and 40 or 36
	local MinWidth = ShowButtons and 164 or 128

	local Stepper = {
		__type = "Stepper",
		Title = Config.Title or "Stepper",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Value = {
			Min = Min,
			Max = Max,
			Default = Default,
			Increment = Increment,
		},
		Callback = Config.Callback or function() end,
		Format = Config.Format,
		UIElements = {},
		Animation = Config.Animation ~= false,
		Draggable = Config.Draggable ~= false,
		ShowButtons = ShowButtons,
		Width = math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or (IsMobile and 188 or 176), MinWidth),
	}

	local CanCallback = true

	Stepper.StepperFrame = require("./components/window/Element")({
		Title = Stepper.Title,
		Desc = Stepper.Desc,
		Parent = Config.Parent,
		TextOffset = Stepper.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Stepper,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local function FormatValue(Value)
		if typeof(Stepper.Format) == "function" then
			local Success, Result = pcall(Stepper.Format, Value, Stepper.Value.Min, Stepper.Value.Max)
			if Success and Result ~= nil then
				return tostring(Result)
			end
		end

		return Utils.FormatNumber(Value)
	end

	local function GetRange()
		return math.max(Stepper.Value.Max - Stepper.Value.Min, Stepper.Value.Increment)
	end

	local function SnapValue(Value)
		local Number = Utils.ToFiniteNumber(Value)
		if Number == nil then
			return Stepper.Value.Default
		end

		local Steps = math.floor(((Number - Stepper.Value.Min) / Stepper.Value.Increment) + 0.5)
		local Snapped = Stepper.Value.Min + (Steps * Stepper.Value.Increment)
		return math.clamp(Snapped, Stepper.Value.Min, Stepper.Value.Max)
	end

	local function ValueToDelta(Value)
		return math.clamp((Value - Stepper.Value.Min) / GetRange(), 0, 1)
	end

	local function CreateIconButton(Name, IconName)
		local IconInfo = Creator.Icon(IconName)
		local Icon = New("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = IconInfo[1],
			ImageRectOffset = IconInfo[2].ImageRectPosition,
			ImageRectSize = IconInfo[2].ImageRectSize,
			ThemeTag = {
				ImageColor3 = "StepperIcon",
			},
		})

		local Button = Creator.NewRoundFrame(12, "Squircle", {
			Name = Name,
			Size = UDim2.fromOffset(ButtonSize, ButtonSize),
			ImageTransparency = 0.88,
			ThemeTag = {
				ImageColor3 = "StepperButton",
			},
		}, {
			Icon,
		}, true)

		return Button, Icon
	end

	local MinusButton, MinusIcon
	local PlusButton, PlusIcon
	if Stepper.ShowButtons then
		MinusButton, MinusIcon = CreateIconButton("Minus", "minus")
		PlusButton, PlusIcon = CreateIconButton("Plus", "plus")

		Motion.AttachPress(MinusButton, Creator, {
			Amount = 0.94,
			Enabled = function()
				return Stepper.Animation and not Stepper.Locked and Stepper.Value.Default > Stepper.Value.Min
			end,
		})
		Motion.AttachPress(PlusButton, Creator, {
			Amount = 0.94,
			Enabled = function()
				return Stepper.Animation and not Stepper.Locked and Stepper.Value.Default < Stepper.Value.Max
			end,
		})
	end

	local TrackFill = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Fill",
		Size = UDim2.new(ValueToDelta(Stepper.Value.Default), 0, 1, 0),
		ImageTransparency = 0.12,
		ThemeTag = {
			ImageColor3 = "Primary",
		},
	})

	local TrackThumb = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Thumb",
		Size = UDim2.fromOffset(9, 9),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(ValueToDelta(Stepper.Value.Default), 0, 0.5, 0),
		ImageTransparency = 0,
		ThemeTag = {
			ImageColor3 = "SliderThumb",
		},
	})

	local Track = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Track",
		Size = UDim2.new(1, -18, 0, 4),
		Position = UDim2.new(0.5, 0, 1, -7),
		AnchorPoint = Vector2.new(0.5, 1),
		ImageTransparency = 0.88,
		ThemeTag = {
			ImageColor3 = "Text",
		},
	}, {
		TrackFill,
		TrackThumb,
	})

	Stepper.UIElements.ValueLabel = New("TextLabel", {
		Name = "Value",
		Size = UDim2.new(1, -18, 1, -10),
		Position = UDim2.new(0.5, 0, 0, 1),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Text = FormatValue(Stepper.Value.Default),
		TextSize = IsMobile and 15 or 14,
		TextTruncate = "AtEnd",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		ThemeTag = {
			TextColor3 = "StepperText",
		},
	})

	local ButtonSpace = Stepper.ShowButtons and ((ButtonSize * 2) + 10) or 0
	local ValueBackground = Creator.NewRoundFrame(12, "Squircle", {
		Name = "ValueBackground",
		Size = UDim2.new(1, -ButtonSpace, 0, ControlHeight),
		ImageTransparency = 0.92,
		Active = true,
		ClipsDescendants = true,
		ThemeTag = {
			ImageColor3 = "StepperValueBackground",
		},
	}, {
		Stepper.UIElements.ValueLabel,
		Track,
	}, true)

	Stepper.UIElements.Track = Track
	Stepper.UIElements.TrackFill = TrackFill
	Stepper.UIElements.TrackThumb = TrackThumb
	Stepper.UIElements.ValueBackground = ValueBackground

	Stepper.UIElements.Container = New("Frame", {
		Name = "Stepper",
		Size = UDim2.new(0, Stepper.Width, 0, ControlHeight),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = Stepper.StepperFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 5),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Right",
			VerticalAlignment = "Center",
		}),
		MinusButton,
		ValueBackground,
		PlusButton,
	})

	local function SetProgressVisual(Value, IsAnimated)
		local Delta = ValueToDelta(Value)
		local FillSize = UDim2.new(Delta, 0, 1, 0)
		local ThumbPosition = UDim2.new(Delta, 0, 0.5, 0)

		if IsAnimated and Stepper.Animation then
			Motion.Play(TrackFill, "Fast", { Size = FillSize }, nil, nil, "StepperFill")
			Motion.Play(TrackThumb, "Fast", { Position = ThumbPosition }, nil, nil, "StepperThumb")
		else
			TrackFill.Size = FillSize
			TrackThumb.Position = ThumbPosition
		end
	end

	local function UpdateButtonStates(IsAnimated)
		if not Stepper.ShowButtons then
			return
		end

		local AtMin = Stepper.Value.Default <= Stepper.Value.Min
		local AtMax = Stepper.Value.Default >= Stepper.Value.Max
		local MinusTransparency = AtMin and 0.62 or 0
		local PlusTransparency = AtMax and 0.62 or 0
		local MinusButtonTransparency = AtMin and 0.94 or 0.88
		local PlusButtonTransparency = AtMax and 0.94 or 0.88

		if IsAnimated and Stepper.Animation then
			Motion.Play(MinusIcon, "Fast", { ImageTransparency = MinusTransparency }, nil, nil, "State")
			Motion.Play(PlusIcon, "Fast", { ImageTransparency = PlusTransparency }, nil, nil, "State")
			Motion.Play(MinusButton, "Fast", { ImageTransparency = MinusButtonTransparency }, nil, nil, "State")
			Motion.Play(PlusButton, "Fast", { ImageTransparency = PlusButtonTransparency }, nil, nil, "State")
		else
			MinusIcon.ImageTransparency = MinusTransparency
			PlusIcon.ImageTransparency = PlusTransparency
			MinusButton.ImageTransparency = MinusButtonTransparency
			PlusButton.ImageTransparency = PlusButtonTransparency
		end
	end

	local function UpdateValue(Value, IsCallback, Snap)
		local Number = Utils.ToFiniteNumber(Value)
		if Number == nil then
			return Stepper.Value.Default
		end

		local PreviousValue = Stepper.Value.Default
		Stepper.Value.Default = Snap == false and math.clamp(Number, Stepper.Value.Min, Stepper.Value.Max) or SnapValue(Number)
		Stepper.UIElements.ValueLabel.Text = FormatValue(Stepper.Value.Default)
		SetProgressVisual(Stepper.Value.Default, true)
		UpdateButtonStates(true)

		if Stepper.Animation and PreviousValue ~= Stepper.Value.Default then
			Motion.Play(ValueBackground, "Fast", { ImageTransparency = 0.86 }, nil, nil, "Pulse")
			task.delay(Motion.GetDuration("Fast"), function()
				if ValueBackground.Parent then
					Motion.Play(ValueBackground, "Select", { ImageTransparency = 0.92 }, nil, nil, "Pulse")
				end
			end)
		end

		if CanCallback and IsCallback ~= false and PreviousValue ~= Stepper.Value.Default then
			Creator.SafeCallback(Stepper.Callback, Stepper.Value.Default)
		end

		return Stepper.Value.Default
	end

	function Stepper:Lock()
		Stepper.Locked = true
		CanCallback = false
		UpdateButtonStates(true)
		return Stepper.StepperFrame:Lock(Stepper.LockedTitle)
	end
	function Stepper:Unlock()
		Stepper.Locked = false
		CanCallback = true
		UpdateButtonStates(true)
		return Stepper.StepperFrame:Unlock()
	end

	function Stepper:Get()
		return Stepper.Value.Default
	end

	function Stepper:Set(Value, IsCallback)
		return UpdateValue(Value, IsCallback)
	end

	function Stepper:SetRange(NewMin, NewMax)
		NewMin = Utils.ToFiniteNumber(NewMin)
		NewMax = Utils.ToFiniteNumber(NewMax)

		if NewMin == nil or NewMax == nil then
			return Stepper.Value.Min, Stepper.Value.Max
		end

		if NewMin > NewMax then
			NewMin, NewMax = NewMax, NewMin
		end

		Stepper.Value.Min = NewMin
		Stepper.Value.Max = NewMax
		UpdateValue(Stepper.Value.Default, false)

		return Stepper.Value.Min, Stepper.Value.Max
	end

	function Stepper:SetMin(NewMin)
		Stepper:SetRange(NewMin, math.max(Utils.ToFiniteNumber(NewMin) or Stepper.Value.Min, Stepper.Value.Max))
		return Stepper.Value.Min
	end

	function Stepper:SetMax(NewMax)
		Stepper:SetRange(math.min(Stepper.Value.Min, Utils.ToFiniteNumber(NewMax) or Stepper.Value.Max), NewMax)
		return Stepper.Value.Max
	end

	local CurInput = Config.WindUI.GenerateGUID()
	local ActiveInput
	local MoveConnection
	local ReleaseConnection
	local ScrollingFrameParent = Config.Tab and Config.Tab.UIElements and Config.Tab.UIElements.ContainerFrame

	local function DisconnectDrag()
		if MoveConnection then
			MoveConnection:Disconnect()
			MoveConnection = nil
		end
		if ReleaseConnection then
			ReleaseConnection:Disconnect()
			ReleaseConnection = nil
		end
		if ScrollingFrameParent then
			ScrollingFrameParent.ScrollingEnabled = true
		end
		if Config.WindUI.CurrentInput == CurInput then
			Config.WindUI.CurrentInput = nil
		end
		ActiveInput = nil
		if Stepper.Animation then
			Motion.Play(TrackThumb, "Focus", { Size = UDim2.fromOffset(9, 9) }, nil, nil, "StepperDrag")
		end
	end

	local function GetInputX(Input)
		if Input.UserInputType == Enum.UserInputType.Touch then
			return Input.Position.X
		end
		return UserInputService:GetMouseLocation().X
	end

	local function UpdateFromInput(Input)
		if not Track or Track.AbsoluteSize.X <= 0 then
			return
		end

		local Delta = math.clamp((GetInputX(Input) - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		local NextValue = Stepper.Value.Min + (Delta * GetRange())
		UpdateValue(NextValue, true)
	end

	if Stepper.ShowButtons then
		Creator.AddSignal(MinusButton.MouseButton1Click, function()
			if not Stepper.Locked then
				Stepper:Set(Stepper.Value.Default - Stepper.Value.Increment)
			end
		end)
		Creator.AddSignal(PlusButton.MouseButton1Click, function()
			if not Stepper.Locked then
				Stepper:Set(Stepper.Value.Default + Stepper.Value.Increment)
			end
		end)
	end

	Creator.AddSignal(ValueBackground.InputBegan, function(Input)
		if Stepper.Locked or not Stepper.Draggable then
			return
		end
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
			return
		end

		Config.WindUI.CurrentInput = CurInput
		ActiveInput = Input
		if ScrollingFrameParent then
			ScrollingFrameParent.ScrollingEnabled = false
		end
		if Stepper.Animation then
			Motion.Play(TrackThumb, "Focus", { Size = UDim2.fromOffset(13, 13) }, nil, nil, "StepperDrag")
		end
		UpdateFromInput(Input)

		MoveConnection = UserInputService.InputChanged:Connect(function(ChangedInput)
			if not ActiveInput then
				return
			end
			if ActiveInput.UserInputType == Enum.UserInputType.Touch and ChangedInput.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			if ActiveInput.UserInputType == Enum.UserInputType.MouseButton1 and ChangedInput.UserInputType ~= Enum.UserInputType.MouseMovement then
				return
			end
			UpdateFromInput(ChangedInput)
		end)

		ReleaseConnection = UserInputService.InputEnded:Connect(function(EndedInput)
			if not ActiveInput then
				return
			end
			local ReleasedTouch = ActiveInput.UserInputType == Enum.UserInputType.Touch and EndedInput == ActiveInput
			local ReleasedMouse = ActiveInput.UserInputType == Enum.UserInputType.MouseButton1
				and EndedInput.UserInputType == Enum.UserInputType.MouseButton1
			if ReleasedTouch or ReleasedMouse then
				DisconnectDrag()
			end
		end)
	end)

	UpdateButtonStates(false)
	SetProgressVisual(Stepper.Value.Default, false)

	if Stepper.Locked then
		Stepper:Lock()
	end

	return Stepper.__type, Stepper
end

return Element

end)()

-- ── elements/Callout.lua ──
_VYNX_MODULES["elements/Callout.lua"] = (function()
local Element = {}

local Variants = {
	Info = {
		Icon = "info",
		Color = Color3.fromHex("#2563eb"),
	},
	Success = {
		Icon = "circle-check",
		Color = Color3.fromHex("#16a34a"),
	},
	Warning = {
		Icon = "triangle-alert",
		Color = Color3.fromHex("#d97706"),
	},
	Error = {
		Icon = "circle-x",
		Color = Color3.fromHex("#dc2626"),
	},
}

function Element:New(Config)
	local VariantName = Config.Variant or "Info"
	local Variant = Variants[VariantName] or Variants.Info

	local Callout = {
		__type = "Callout",
		Title = Config.Title or VariantName,
		Desc = Config.Desc or Config.Content,
		Icon = Config.Icon or Variant.Icon,
		Variant = VariantName,
		Color = Config.Color or Variant.Color,
		UIElements = {},
	}

	Callout.CalloutFrame = require("./components/window/Element")({
		Title = Callout.Title,
		Desc = Callout.Desc,
		Image = Callout.Icon,
		IconThemed = Config.IconThemed,
		Color = Callout.Color,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Callout,
		ParentConfig = Config,
		Tags = Config.Tags,
		Size = Config.Size,
	})

	return Callout.__type, Callout
end

return Element

end)()

-- ── elements/Badge.lua ──
_VYNX_MODULES["elements/Badge.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local VariantName = Config.Variant or "Info"
	local Variant = Utils.GetVariant(VariantName)
	local Badge = {
		__type = "Badge",
		Title = Config.Title or "Badge",
		Desc = Config.Desc or nil,
		Value = Config.Value or Config.Badge or VariantName,
		Variant = VariantName,
		Color = Utils.GetColor(Config.Color, Variant.Color),
		Icon = Config.Icon or Variant.Icon,
		Callback = Config.Callback,
		UIElements = {},

		Width = math.max(Utils.ToFiniteNumber(Config.Width) or 96, 72),
	}

	Badge.BadgeFrame = require("./components/window/Element")({
		Title = Badge.Title,
		Desc = Badge.Desc,
		Parent = Config.Parent,
		TextOffset = Badge.Width + 14,
		Hover = Config.Hover == true or Badge.Callback ~= nil,
		Scalable = Badge.Callback ~= nil,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Badge,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local Icon = Utils.CreateIcon(Creator, Badge.Icon, Config.Window.Folder, "Badge", false, "BadgeIcon")
	if Icon then
		Icon.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
		Icon.ImageLabel.ImageTransparency = 0
		Icon.Size = UDim2.new(0, 14, 0, 14)
	end

	Badge.UIElements.Label = New("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Text = tostring(Badge.Value),
		TextSize = 13,
		TextTruncate = "AtEnd",
		TextXAlignment = "Center",
		Size = UDim2.new(1, Icon and -20 or 0, 1, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextColor3 = Color3.new(1, 1, 1),
	})

	Badge.UIElements.Pill = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Badge",
		Size = UDim2.new(0, Badge.Width, 0, 28),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		ImageTransparency = 0,
		ImageColor3 = Badge.Color,
		Parent = Badge.BadgeFrame.UIElements.Main,
	}, {
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
		}),
		Icon,
		Badge.UIElements.Label,
	})

	function Badge:SetValue(Value)
		Badge.Value = Value
		Badge.UIElements.Label.Text = tostring(Value or "")
		Motion.Play(Badge.UIElements.Pill, "Fast", { ImageTransparency = 0.08 }, nil, nil, "Pulse")
		task.delay(Motion.GetDuration("Fast"), function()
			if Badge.UIElements.Pill.Parent then
				Motion.Play(Badge.UIElements.Pill, "Select", { ImageTransparency = 0 }, nil, nil, "Pulse")
			end
		end)
		return Badge.Value
	end

	function Badge:SetVariant(Variant)
		local NextVariant = Utils.GetVariant(Variant)
		Badge.Variant = Variant
		Badge.Color = NextVariant.Color
		Motion.Play(Badge.UIElements.Pill, "Select", { ImageColor3 = Badge.Color }, nil, nil, "Variant")
		return Badge.Variant
	end

	if Badge.Callback then
		Creator.AddSignal(Badge.BadgeFrame.UIElements.Main.MouseButton1Click, function()
			Creator.SafeCallback(Badge.Callback, Badge.Value)
		end)
	end

	return Badge.__type, Badge
end

return Element

end)()

-- ── elements/StatusCard.lua ──
_VYNX_MODULES["elements/StatusCard.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local VariantName = Config.Status or Config.Variant or "Info"
	local Variant = Utils.GetVariant(VariantName)
	local StatusCard = {
		__type = "StatusCard",
		Title = Config.Title or "Status",
		Desc = Config.Desc or Config.Content,
		Value = Config.Value or VariantName,
		Status = VariantName,
		Color = Utils.GetColor(Config.Color, Variant.Color),
		Callback = Config.Callback,
		UIElements = {},

		Width = math.max(Utils.ToFiniteNumber(Config.Width) or 136, 96),
	}

	StatusCard.StatusCardFrame = require("./components/window/Element")({
		Title = StatusCard.Title,
		Desc = StatusCard.Desc,
		Parent = Config.Parent,
		TextOffset = StatusCard.Width + 14,
		Hover = Config.Hover == true or StatusCard.Callback ~= nil,
		Scalable = StatusCard.Callback ~= nil,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = StatusCard,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	StatusCard.UIElements.Dot = Creator.NewRoundFrame(999, "Circle", {
		Name = "Dot",
		Size = UDim2.new(0, 10, 0, 10),
		ImageColor3 = StatusCard.Color,
	})

	StatusCard.UIElements.Value = New("TextLabel", {
		Name = "Value",
		BackgroundTransparency = 1,
		Text = tostring(StatusCard.Value),
		TextSize = 14,
		TextTransparency = 0.08,
		TextTruncate = "AtEnd",
		AutomaticSize = "Y",
		Size = UDim2.new(1, -18, 0, 0),
		TextXAlignment = "Left",
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	StatusCard.UIElements.Status = New("Frame", {
		Name = "StatusCard",
		Size = UDim2.new(0, StatusCard.Width, 0, 34),
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = StatusCard.StatusCardFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Right",
		}),
		StatusCard.UIElements.Dot,
		StatusCard.UIElements.Value,
	})

	function StatusCard:SetValue(Value)
		StatusCard.Value = Value
		StatusCard.UIElements.Value.Text = tostring(Value or "")
		return StatusCard.Value
	end

	function StatusCard:SetStatus(Status, Value)
		local VariantData = Utils.GetVariant(Status)
		StatusCard.Status = Status
		StatusCard.Color = VariantData.Color
		if Value ~= nil then
			StatusCard:SetValue(Value)
		end
		Motion.Play(StatusCard.UIElements.Dot, "Select", { ImageColor3 = StatusCard.Color }, nil, nil, "Status")
		return StatusCard.Status
	end

	if StatusCard.Callback then
		Creator.AddSignal(StatusCard.StatusCardFrame.UIElements.Main.MouseButton1Click, function()
			Creator.SafeCallback(StatusCard.Callback, StatusCard.Status, StatusCard.Value)
		end)
	end

	return StatusCard.__type, StatusCard
end

return Element

end)()

-- ── elements/StatCard.lua ──
_VYNX_MODULES["elements/StatCard.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function GetTrendColor(Trend)
	if Trend == "Down" or Trend == "Negative" then
		return Color3.fromHex("#dc2626")
	end
	if Trend == "Neutral" then
		return Color3.fromHex("#71717a")
	end
	return Color3.fromHex("#16a34a")
end

function Element:New(Config)
	local StatCard = {
		__type = "StatCard",
		Title = Config.Title or "Stat",
		Desc = Config.Desc,
		Value = Config.Value or Config.Default or "0",
		SubValue = Config.SubValue or Config.TrendText,
		Trend = Config.Trend or "Up",
		Icon = Config.Icon,
		UIElements = {},
	}

	StatCard.StatCardFrame = require("./components/window/Element")({
		Title = StatCard.Title,
		Desc = StatCard.Desc,
		Image = StatCard.Icon,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = StatCard,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	StatCard.UIElements.Value = New("TextLabel", {
		Name = "Value",
		LayoutOrder = -1,
		BackgroundTransparency = 1,
		Text = tostring(StatCard.Value),
		TextSize = Utils.ToFiniteNumber(Config.ValueTextSize) or 24,
		TextWrapped = true,
		TextXAlignment = "Left",
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	StatCard.UIElements.TrendDot = Creator.NewRoundFrame(999, "Circle", {
		Name = "TrendDot",
		Size = UDim2.new(0, 8, 0, 8),
		ImageColor3 = Utils.GetColor(Config.TrendColor, GetTrendColor(StatCard.Trend)),
	})

	StatCard.UIElements.SubValue = New("TextLabel", {
		Name = "SubValue",
		BackgroundTransparency = 1,
		Text = tostring(StatCard.SubValue or ""),
		TextSize = 13,
		TextTransparency = 0.35,
		TextWrapped = true,
		TextXAlignment = "Left",
		AutomaticSize = "Y",
		Size = UDim2.new(1, -16, 0, 0),
		Visible = StatCard.SubValue ~= nil,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	StatCard.UIElements.Footer = New("Frame", {
		Name = "Footer",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = StatCard.StatCardFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Left",
		}),
		StatCard.UIElements.TrendDot,
		StatCard.UIElements.SubValue,
	})
	StatCard.UIElements.Value.Parent = StatCard.StatCardFrame.UIElements.Container

	function StatCard:SetValue(Value, SubValue)
		StatCard.Value = Value
		StatCard.UIElements.Value.Text = tostring(Value or "")
		if SubValue ~= nil then
			StatCard.SubValue = SubValue
			StatCard.UIElements.SubValue.Text = tostring(SubValue)
			StatCard.UIElements.SubValue.Visible = true
		end
		Motion.Play(StatCard.UIElements.Value, "Fast", { TextTransparency = 0.18 }, nil, nil, "Pulse")
		task.delay(Motion.GetDuration("Fast"), function()
			if StatCard.UIElements.Value.Parent then
				Motion.Play(StatCard.UIElements.Value, "Select", { TextTransparency = 0 }, nil, nil, "Pulse")
			end
		end)
		return StatCard.Value
	end

	function StatCard:SetTrend(Trend, Color)
		StatCard.Trend = Trend
		local TrendColor = Utils.GetColor(Color, GetTrendColor(Trend))
		Motion.Play(StatCard.UIElements.TrendDot, "Select", { ImageColor3 = TrendColor }, nil, nil, "Trend")
		return StatCard.Trend
	end

	return StatCard.__type, StatCard
end

return Element

end)()

-- ── elements/KeyValue.lua ──
_VYNX_MODULES["elements/KeyValue.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local KeyValue = {
		__type = "KeyValue",
		Title = Config.Title or "Details",
		Desc = Config.Desc,
		Items = Utils.NormalizeItems(Config.Items or Config.Rows or Config.Values or {}, "Key", "Value"),
		UIElements = {},
		Rows = {},
	}

	KeyValue.KeyValueFrame = require("./components/window/Element")({
		Title = KeyValue.Title,
		Desc = KeyValue.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = KeyValue,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	KeyValue.UIElements.List = New("Frame", {
		Name = "KeyValueList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = KeyValue.KeyValueFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Vertical",
			VerticalAlignment = "Top",
			HorizontalAlignment = "Left",
		}),
	})

	local function Render()
		for _, Row in next, KeyValue.Rows do
			Row:Destroy()
		end
		KeyValue.Rows = {}

		for Index, Item in next, KeyValue.Items do
			local Icon = Utils.CreateIcon(Creator, Item.Icon, Config.Window.Folder, "KeyValue", true, "KeyValueIcon")
			if Icon then
				Icon.Size = UDim2.new(0, 16, 0, 16)
			end

			local Key = New("TextLabel", {
				Name = "Key",
				BackgroundTransparency = 1,
				Text = tostring(Item.Title),
				TextSize = 14,
				TextTransparency = 0.35,
				TextTruncate = "AtEnd",
				TextXAlignment = "Left",
				Size = UDim2.new(0.45, Icon and -24 or 0, 0, 0),
				AutomaticSize = "Y",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local Value = New("TextLabel", {
				Name = "Value",
				BackgroundTransparency = 1,
				Text = tostring(Item.Value or ""),
				TextSize = 14,
				TextTransparency = 0.05,
				TextWrapped = true,
				TextXAlignment = "Right",
				Size = UDim2.new(0.55, 0, 0, 0),
				AutomaticSize = "Y",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local Row = New("Frame", {
				Name = "Row",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Parent = KeyValue.UIElements.List,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = "Horizontal",
					VerticalAlignment = "Top",
					HorizontalAlignment = "Left",
				}),
				Icon,
				Key,
				Value,
			})

			table.insert(KeyValue.Rows, Row)
		end
	end

	function KeyValue:SetItems(Items)
		KeyValue.Items = Utils.NormalizeItems(Items or {}, "Key", "Value")
		Render()
		Motion.Play(KeyValue.UIElements.List, "Reveal", { BackgroundTransparency = 1 }, nil, nil, "Render")
		return KeyValue.Items
	end

	Render()

	return KeyValue.__type, KeyValue
end

return Element

end)()

-- ── elements/ChipList.lua ──
_VYNX_MODULES["elements/ChipList.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function GetWidth(Config)
	return math.max(Utils.ToFiniteNumber(Config.Width) or Utils.ToFiniteNumber(Config.ControlWidth) or 190, 120)
end

function Element:New(Config)
	local ChipList = {
		__type = "ChipList",
		Title = Config.Title or "Chips",
		Desc = Config.Desc,
		Options = Utils.NormalizeItems(Config.Options or Config.Values or {}),
		Values = Utils.NormalizeValues(Config.Value or Config.ValuesSelected or Config.SelectedValues),
		Multi = Config.Multi ~= false,
		Callback = Config.Callback or function() end,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Animation = Config.Animation ~= false,
		UIElements = {},
		Chips = {},

		Width = GetWidth(Config),
	}

	local CanCallback = true

	ChipList.ChipListFrame = require("./components/window/Element")({
		Title = ChipList.Title,
		Desc = ChipList.Desc,
		Parent = Config.Parent,
		TextOffset = ChipList.Width + 14,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = ChipList,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	ChipList.UIElements.List = New("Frame", {
		Name = "ChipList",
		Size = UDim2.new(0, ChipList.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0),
		AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5),
		BackgroundTransparency = 1,
		Parent = ChipList.ChipListFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Vertical",
			HorizontalAlignment = "Right",
			SortOrder = "LayoutOrder",
		}),
	})

	local function IsSelected(Value)
		return Utils.ContainsValue(ChipList.Values, Value)
	end

	local function UpdateVisuals(IsAnimated)
		for _, Chip in next, ChipList.Chips do
			local Selected = IsSelected(Chip.Option.Value)
			local Transparency = Selected and 0.82 or 0.94
			local TextTransparency = Chip.Option.Disabled and 0.55 or (Selected and 0 or 0.2)

			if IsAnimated and ChipList.Animation then
				Motion.Play(Chip.Button, "Select", { ImageTransparency = Transparency }, nil, nil, "State")
				Motion.Play(Chip.Title, "Select", { TextTransparency = TextTransparency }, nil, nil, "State")
			else
				Chip.Button.ImageTransparency = Transparency
				Chip.Title.TextTransparency = TextTransparency
			end
		end
	end

	local function Sanitize(Values)
		local Sanitized = {}
		for _, Value in next, Values or {} do
			for _, Option in next, ChipList.Options do
				if Option.Value == Value and not Option.Disabled and not Utils.ContainsValue(Sanitized, Value) then
					table.insert(Sanitized, Value)
					break
				end
			end
		end
		return Sanitized
	end

	local function CreateChip(Option, Index)
		local Title = New("TextLabel", {
			Name = "Title",
			BackgroundTransparency = 1,
			Text = Option.Title,
			TextSize = 13,
			TextTruncate = "AtEnd",
			TextXAlignment = "Center",
			Size = UDim2.new(1, -16, 1, 0),
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local Button = Creator.NewRoundFrame(999, "Squircle", {
			Name = "Chip",
			Size = UDim2.new(1, 0, 0, 30),
			LayoutOrder = Index,
			ImageTransparency = 0.94,
			Active = not Option.Disabled,
			ThemeTag = {
				ImageColor3 = "ChipListBackground",
			},
			Parent = ChipList.UIElements.List,
		}, {
			Title,
		}, true)

		local Chip = {
			Button = Button,
			Title = Title,
			Option = Option,
		}
		ChipList.Chips[Index] = Chip

		Motion.AttachPress(Button, Creator, {
			Amount = 0.96,
			Enabled = function()
				return ChipList.Animation and not ChipList.Locked and not Option.Disabled
			end,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			if not Option.Disabled then
				ChipList:Toggle(Option.Value)
			end
		end)
	end

	local function Render()
		for _, Chip in next, ChipList.Chips do
			Chip.Button:Destroy()
		end
		ChipList.Chips = {}

		for Index, Option in next, ChipList.Options do
			CreateChip(Option, Index)
		end

		ChipList.Values = Sanitize(ChipList.Values)
		UpdateVisuals(false)
	end

	function ChipList:Lock()
		ChipList.Locked = true
		CanCallback = false
		return ChipList.ChipListFrame:Lock(ChipList.LockedTitle)
	end

	function ChipList:Unlock()
		ChipList.Locked = false
		CanCallback = true
		return ChipList.ChipListFrame:Unlock()
	end

	function ChipList:Get()
		return ChipList.Multi and Utils.CloneArray(ChipList.Values) or ChipList.Values[1]
	end

	function ChipList:Set(Values, IsCallback)
		local NextValues = Utils.NormalizeValues(Values)
		if not ChipList.Multi and NextValues[1] ~= nil then
			NextValues = { NextValues[1] }
		end

		ChipList.Values = Sanitize(NextValues)
		UpdateVisuals(true)

		if CanCallback and IsCallback ~= false then
			Creator.SafeCallback(ChipList.Callback, ChipList:Get())
		end

		return ChipList:Get()
	end

	function ChipList:Toggle(Value, IsCallback)
		if ChipList.Multi then
			ChipList.Values = Utils.ToggleValue(ChipList.Values, Value)
			return ChipList:Set(ChipList.Values, IsCallback)
		end

		return ChipList:Set(Value, IsCallback)
	end

	function ChipList:SetOptions(Options)
		ChipList.Options = Utils.NormalizeItems(Options or {})
		Render()
		return ChipList.Options
	end

	Render()

	if ChipList.Locked then
		ChipList:Lock()
	end

	return ChipList.__type, ChipList
end

return Element

end)()

-- ── elements/ActionList.lua ──
_VYNX_MODULES["elements/ActionList.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function NormalizeActions(Actions)
	local Normalized = {}

	for Index, Action in next, Actions or {} do
		if typeof(Action) == "table" then
			table.insert(Normalized, {
				Title = tostring(Action.Title or Action.Name or Action.Value or ("Action " .. tostring(Index))),
				Desc = Action.Desc or Action.Content,
				Value = Action.Value or Action.Badge,
				Icon = Action.Icon,
				Color = Utils.GetColor(Action.Color, nil),
				Disabled = Action.Disabled == true,
				Callback = Action.Callback,
			})
		else
			table.insert(Normalized, {
				Title = tostring(Action),
				Disabled = false,
			})
		end
	end

	return Normalized
end

function Element:New(Config)
	local ActionList = {
		__type = "ActionList",
		Title = Config.Title or "Actions",
		Desc = Config.Desc,
		Actions = NormalizeActions(Config.Actions or Config.Items or Config.Values or {}),
		Rows = {},
		UIElements = {},
	}

	ActionList.ActionListFrame = require("./components/window/Element")({
		Title = ActionList.Title,
		Desc = ActionList.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = ActionList,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	ActionList.UIElements.List = New("Frame", {
		Name = "ActionList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = ActionList.ActionListFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Config.Window.NewElements and 6 or 8),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	local function Render()
		for _, Row in next, ActionList.Rows do
			Row:Destroy()
		end
		ActionList.Rows = {}

		for Index, Action in next, ActionList.Actions do
			local Icon = Utils.CreateIcon(Creator, Action.Icon or "circle-dot", Config.Window.Folder, "ActionList", true, "ActionListIcon")
			if Icon then
				Icon.Size = UDim2.fromOffset(17, 17)
			end
			local IconTarget = Utils.GetImageTarget(Icon)
			if IconTarget and Action.Color then
				IconTarget.ImageColor3 = Action.Color
			end

			local Texts = New("Frame", {
				Name = "Texts",
				Size = UDim2.new(1, Action.Value and -96 or -42, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 2),
					FillDirection = "Vertical",
					HorizontalAlignment = "Left",
				}),
				New("TextLabel", {
					Name = "Title",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = Action.Title,
					TextSize = 14,
					TextTransparency = Action.Disabled and 0.46 or 0.04,
					TextXAlignment = "Left",
					TextTruncate = "AtEnd",
					FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
					ThemeTag = {
						TextColor3 = "Text",
					},
				}),
				Action.Desc and New("TextLabel", {
					Name = "Desc",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = tostring(Action.Desc),
					TextSize = 12,
					TextTransparency = Action.Disabled and 0.62 or 0.38,
					TextXAlignment = "Left",
					TextWrapped = true,
					FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
					ThemeTag = {
						TextColor3 = "Text",
					},
				}) or nil,
			})

			local Value
			if Action.Value ~= nil then
				Value = Creator.NewRoundFrame(999, "Squircle", {
					Name = "Value",
					Size = UDim2.new(0, 0, 0, 26),
					AutomaticSize = "X",
					ImageTransparency = 0.88,
					ThemeTag = {
						ImageColor3 = "ElementBackground",
					},
				}, {
					New("UIPadding", {
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10),
					}),
					New("TextLabel", {
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = "X",
						BackgroundTransparency = 1,
						Text = tostring(Action.Value),
						TextSize = 12,
						TextTransparency = 0.12,
						FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
						ThemeTag = {
							TextColor3 = "Text",
						},
					}),
				})
			end

			local Row = Creator.NewRoundFrame(14, "Squircle", {
				Name = "Action",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				ImageTransparency = Action.Disabled and 0.96 or 0.92,
				Parent = ActionList.UIElements.List,
				ThemeTag = {
					ImageColor3 = "ElementBackground",
				},
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, 10),
					FillDirection = "Horizontal",
					VerticalAlignment = "Center",
					HorizontalAlignment = "Left",
				}),
				Icon,
				Texts,
				Value,
			}, not Action.Disabled)

			if not Action.Disabled then
				Motion.AttachPress(Row, Creator, {
					Amount = 0.985,
				})
				Creator.AddSignal(Row.MouseButton1Click, function()
					if typeof(Action.Callback) == "function" then
						Creator.SafeCallback(Action.Callback, Action, Index)
					elseif typeof(Config.Callback) == "function" then
						Creator.SafeCallback(Config.Callback, Action, Index)
					end
				end)
			end

			table.insert(ActionList.Rows, Row)
		end
	end

	function ActionList:SetActions(Actions)
		ActionList.Actions = NormalizeActions(Actions)
		Render()
		return ActionList.Actions
	end

	function ActionList:AddAction(Action)
		local Normalized = NormalizeActions({ Action })[1]
		if Normalized then
			table.insert(ActionList.Actions, Normalized)
			Render()
		end
		return Normalized
	end

	Render()

	return ActionList.__type, ActionList
end

return Element

end)()

-- ── elements/MeterGroup.lua ──
_VYNX_MODULES["elements/MeterGroup.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function NormalizeMeters(Meters)
	local Normalized = {}

	for Index, Meter in next, Meters or {} do
		if typeof(Meter) == "table" then
			local Max = Utils.ToFiniteNumber(Meter.Max) or 100
			local Value = Utils.ToFiniteNumber(Meter.Value or Meter.Default) or 0
			table.insert(Normalized, {
				Title = tostring(Meter.Title or Meter.Name or ("Meter " .. tostring(Index))),
				Value = math.clamp(Value, 0, Max),
				Max = math.max(Max, 0.0001),
				Desc = Meter.Desc,
				Color = Utils.GetColor(Meter.Color, nil),
				Format = Meter.Format,
			})
		else
			table.insert(Normalized, {
				Title = tostring(Index),
				Value = math.clamp(Utils.ToFiniteNumber(Meter) or 0, 0, 100),
				Max = 100,
			})
		end
	end

	return Normalized
end

function Element:New(Config)
	local MeterGroup = {
		__type = "MeterGroup",
		Title = Config.Title or "Meters",
		Desc = Config.Desc,
		Meters = NormalizeMeters(Config.Meters or Config.Items or Config.Values or {}),
		Rows = {},
		UIElements = {},
	}

	MeterGroup.MeterGroupFrame = require("./components/window/Element")({
		Title = MeterGroup.Title,
		Desc = MeterGroup.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = MeterGroup,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	MeterGroup.UIElements.List = New("Frame", {
		Name = "MeterGroup",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = MeterGroup.MeterGroupFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	local function FormatValue(Meter)
		local Ratio = math.clamp(Meter.Value / Meter.Max, 0, 1)
		if typeof(Meter.Format) == "function" then
			local Success, Result = pcall(Meter.Format, Meter.Value, Meter.Max, Ratio)
			if Success and Result ~= nil then
				return tostring(Result)
			end
		end
		return tostring(math.floor((Ratio * 100) + 0.5)) .. "%"
	end

	local function Render()
		for _, Row in next, MeterGroup.Rows do
			Row.Frame:Destroy()
		end
		MeterGroup.Rows = {}

		for Index, Meter in next, MeterGroup.Meters do
			local Ratio = math.clamp(Meter.Value / Meter.Max, 0, 1)
			local Fill = Creator.NewRoundFrame(999, "Squircle", {
				Name = "Fill",
				Size = UDim2.new(Ratio, 0, 1, 0),
				ImageTransparency = 0.08,
				ImageColor3 = Meter.Color,
				ThemeTag = not Meter.Color and {
					ImageColor3 = "Primary",
				} or nil,
			})

			local ValueLabel = New("TextLabel", {
				Name = "Value",
				Size = UDim2.new(0, 52, 0, 18),
				BackgroundTransparency = 1,
				Text = FormatValue(Meter),
				TextSize = 12,
				TextTransparency = 0.22,
				TextXAlignment = "Right",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local Row = New("Frame", {
				Name = "Meter",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Parent = MeterGroup.UIElements.List,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = "Vertical",
					HorizontalAlignment = "Left",
				}),
				New("Frame", {
					Name = "Header",
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
				}, {
					New("UIListLayout", {
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
					}),
					New("TextLabel", {
						Name = "Title",
						Size = UDim2.new(1, -58, 1, 0),
						BackgroundTransparency = 1,
						Text = Meter.Title,
						TextSize = 13,
						TextTransparency = 0.1,
						TextXAlignment = "Left",
						TextTruncate = "AtEnd",
						FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
						ThemeTag = {
							TextColor3 = "Text",
						},
					}),
					ValueLabel,
				}),
				Creator.NewRoundFrame(999, "Squircle", {
					Name = "Track",
					Size = UDim2.new(1, 0, 0, 7),
					ImageTransparency = 0.9,
					ClipsDescendants = true,
					ThemeTag = {
						ImageColor3 = "ElementBackground",
					},
				}, {
					Fill,
				}),
				Meter.Desc and New("TextLabel", {
					Name = "Desc",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = tostring(Meter.Desc),
					TextSize = 12,
					TextTransparency = 0.42,
					TextXAlignment = "Left",
					TextWrapped = true,
					FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
					ThemeTag = {
						TextColor3 = "Text",
					},
				}) or nil,
			})

			MeterGroup.Rows[Index] = {
				Frame = Row,
				Fill = Fill,
				ValueLabel = ValueLabel,
			}
		end
	end

	function MeterGroup:SetValue(Index, Value)
		local Meter = MeterGroup.Meters[Index]
		local Row = MeterGroup.Rows[Index]
		if not Meter or not Row then
			return nil
		end

		Meter.Value = math.clamp(Utils.ToFiniteNumber(Value) or Meter.Value, 0, Meter.Max)
		local Ratio = math.clamp(Meter.Value / Meter.Max, 0, 1)
		Row.ValueLabel.Text = FormatValue(Meter)
		Motion.Play(Row.Fill, "Fast", {
			Size = UDim2.new(Ratio, 0, 1, 0),
		}, nil, nil, "Meter")
		return Meter.Value
	end

	function MeterGroup:SetMeters(Meters)
		MeterGroup.Meters = NormalizeMeters(Meters)
		Render()
		return MeterGroup.Meters
	end

	Render()

	return MeterGroup.__type, MeterGroup
end

return Element

end)()

-- ── elements/Timeline.lua ──
_VYNX_MODULES["elements/Timeline.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local Timeline = {
		__type = "Timeline",
		Title = Config.Title or "Timeline",
		Desc = Config.Desc,
		Items = Utils.NormalizeItems(Config.Items or Config.Events or {}),
		UIElements = {},
		Rows = {},
	}

	Timeline.TimelineFrame = require("./components/window/Element")({
		Title = Timeline.Title,
		Desc = Timeline.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Timeline,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Timeline.UIElements.List = New("Frame", {
		Name = "TimelineList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Timeline.TimelineFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Vertical",
			VerticalAlignment = "Top",
			HorizontalAlignment = "Left",
		}),
	})

	local function Render()
		for _, Row in next, Timeline.Rows do
			Row:Destroy()
		end
		Timeline.Rows = {}

		for Index, Item in next, Timeline.Items do
			local Variant = Utils.GetVariant(Item.Value)
			local Color = Utils.GetColor(Item.Color, Variant.Color)

			local Dot = Creator.NewRoundFrame(999, "Circle", {
				Name = "Dot",
				Size = UDim2.new(0, 10, 0, 10),
				Position = UDim2.new(0.5, 0, 0, 5),
				AnchorPoint = Vector2.new(0.5, 0),
				ImageTransparency = 1,
				ImageColor3 = Color,
			})

			local Rail = New("Frame", {
				Name = "Rail",
				Size = UDim2.new(0, 24, 0, Item.Desc and 46 or 30),
				BackgroundTransparency = 1,
			}, {
				New("Frame", {
					Name = "Line",
					Size = UDim2.new(0, 1, 1, Index == #Timeline.Items and -8 or 0),
					Position = UDim2.new(0.5, 0, 0, 16),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 0.86,
					ThemeTag = {
						BackgroundColor3 = "TimelineLine",
					},
				}),
				Dot,
			})

			local TextContainer = New("Frame", {
				Name = "Text",
				Size = UDim2.new(1, -32, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 3),
					FillDirection = "Vertical",
					VerticalAlignment = "Top",
					HorizontalAlignment = "Left",
				}),
				Utils.CreateText(New, Creator, Item.Title, 14, Enum.FontWeight.SemiBold, 0),
				Item.Desc and Utils.CreateText(New, Creator, Item.Desc, 13, Enum.FontWeight.Medium, 0.4) or nil,
			})

			local Row = New("Frame", {
				Name = "Item",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Parent = Timeline.UIElements.List,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = "Horizontal",
					VerticalAlignment = "Top",
					HorizontalAlignment = "Left",
				}),
				Rail,
				TextContainer,
			})

			table.insert(Timeline.Rows, Row)
			task.delay((Index - 1) * 0.025, function()
				if Dot.Parent then
					Motion.Play(Dot, "Reveal", { ImageTransparency = 0 }, nil, nil, "Reveal")
				end
			end)
		end
	end

	function Timeline:SetItems(Items)
		Timeline.Items = Utils.NormalizeItems(Items or {})
		Render()
		return Timeline.Items
	end

	Render()

	return Timeline.__type, Timeline
end

return Element

end)()

-- ── elements/Accordion.lua ──
_VYNX_MODULES["elements/Accordion.lua"] = (function()
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

	Accordion.AccordionFrame = require("./components/window/Element")({
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

end)()

-- ── elements/EmptyState.lua ──
_VYNX_MODULES["elements/EmptyState.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local CreateButton = require("./components/ui/Button").New

local Element = {}

function Element:New(Config)
	local EmptyState = {
		__type = "EmptyState",
		Title = Config.Title or "Nothing here",
		Desc = Config.Desc or Config.Content,
		Icon = Config.Icon or "inbox",
		Buttons = Config.Buttons or {},
		UIElements = {},
	}

	local Height = math.max(tonumber(Config.Height) or 138, 96)

	EmptyState.UIElements.Main = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
		Name = "EmptyState",
		Size = UDim2.new(1, 0, 0, Height),
		AutomaticSize = #EmptyState.Buttons > 0 and "Y" or "None",
		ImageTransparency = 0.94,
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, 16),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
			PaddingBottom = UDim.new(0, 16),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Vertical",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
		}),
	})

	local Icon = Creator.Image(EmptyState.Icon, EmptyState.Icon, 0, Config.Window.Folder, "EmptyState", true, true, "EmptyStateIcon")
	Icon.Size = UDim2.new(0, tonumber(Config.IconSize) or 34, 0, tonumber(Config.IconSize) or 34)
	Icon.ImageLabel.ImageTransparency = 0.2
	Icon.Parent = EmptyState.UIElements.Main

	EmptyState.UIElements.Title = New("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Text = EmptyState.Title,
		TextSize = 17,
		TextWrapped = true,
		TextXAlignment = "Center",
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		Parent = EmptyState.UIElements.Main,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	EmptyState.UIElements.Desc = New("TextLabel", {
		Name = "Desc",
		BackgroundTransparency = 1,
		Text = EmptyState.Desc or "",
		TextSize = 14,
		TextTransparency = 0.4,
		TextWrapped = true,
		TextXAlignment = "Center",
		AutomaticSize = "Y",
		Visible = EmptyState.Desc ~= nil,
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = EmptyState.UIElements.Main,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	if #EmptyState.Buttons > 0 then
		local Buttons = New("Frame", {
			Name = "Buttons",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = EmptyState.UIElements.Main,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = "Vertical",
				HorizontalAlignment = "Center",
			}),
		})

		for _, Button in next, EmptyState.Buttons do
			local ButtonFrame = CreateButton(
				Button.Title,
				Button.Icon,
				Button.Callback,
				Button.Variant or "White",
				Buttons,
				nil,
				nil,
				Config.Window.NewElements and 999 or 10
			)
			ButtonFrame.Size = UDim2.new(1, 0, 0, 36)
		end
	end

	function EmptyState:SetTitle(Title)
		EmptyState.Title = Title
		EmptyState.UIElements.Title.Text = Title
	end

	function EmptyState:SetDesc(Desc)
		EmptyState.Desc = Desc
		EmptyState.UIElements.Desc.Text = Desc or ""
		EmptyState.UIElements.Desc.Visible = Desc ~= nil
	end

	function EmptyState:Highlight()
		Motion.Play(EmptyState.UIElements.Main, "Highlight", { ImageTransparency = 0.9 }, nil, nil, "Highlight")
		task.delay(Motion.GetDuration("Highlight"), function()
			if EmptyState.UIElements.Main.Parent then
				Motion.Play(EmptyState.UIElements.Main, "Highlight", { ImageTransparency = 0.94 }, nil, nil, "Highlight")
			end
		end)
	end

	function EmptyState:Destroy()
		EmptyState.UIElements.Main:Destroy()
	end

	return EmptyState.__type, EmptyState
end

return Element

end)()

-- ── elements/DiscordCard.lua ──
_VYNX_MODULES["elements/DiscordCard.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local DISCORD_BLURPLE = Color3.fromHex("#5865F2")
local DISCORD_DARK = Color3.fromHex("#1E1F2A")

local function Trim(Text)
	Text = tostring(Text or "")
	Text = string.gsub(Text, "^%s+", "")
	Text = string.gsub(Text, "%s+$", "")
	return Text
end

local function GetInviteUrl(Value)
	local Text = Trim(Value)
	if Text == "" then
		return "https://discord.gg/"
	end

	if string.match(Text, "^https?://") then
		return Text
	end
	if string.match(Text, "^discord%.gg/") or string.match(Text, "^discord%.com/invite/") then
		return "https://" .. Text
	end

	return "https://discord.gg/" .. Text
end

local function CopyText(Text)
	if typeof(setclipboard) == "function" then
		local Success = pcall(function()
			setclipboard(Text)
		end)
		return Success
	end
	if typeof(toclipboard) == "function" then
		local Success = pcall(function()
			toclipboard(Text)
		end)
		return Success
	end
	return false
end

local function Notify(WindUI, Title, Content, Icon, Style)
	if WindUI and WindUI.Notify then
		WindUI:Notify({
			Title = Title,
			Content = Content,
			Icon = Icon,
			Style = Style,
		})
	end
end

function Element:New(Config)
	local Invite = Config.Url or Config.Invite or Config.InviteCode or Config.Code
	local InviteUrl = GetInviteUrl(Invite)
	local DiscordCard = {
		__type = "DiscordCard",
		Title = Config.Title or Config.ServerName or "Discord Server",
		Desc = Config.Desc or Config.Content or "Join the community and get updates.",
		Invite = Invite,
		Url = InviteUrl,
		Icon = Config.Icon or "message-circle",
		Members = Config.Members or Config.MemberCount,
		Online = Config.Online or Config.OnlineCount,
		Callback = Config.Callback,
		UIElements = {},
	}

	local Height = math.max(tonumber(Config.Height) or 152, 126)

	DiscordCard.UIElements.Main = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
		Name = "DiscordCard",
		Size = UDim2.new(1, 0, 0, Height),
		AutomaticSize = "Y",
		ImageColor3 = DISCORD_DARK,
		ImageTransparency = 0,
		Parent = Config.Parent,
	}, {
		New("UIGradient", {
			Rotation = 22,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, DISCORD_DARK),
				ColorSequenceKeypoint.new(1, DISCORD_BLURPLE),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.02),
				NumberSequenceKeypoint.new(1, 0.18),
			}),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 12),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
		}),
	})

	local Header = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = DiscordCard.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
	})

	local IconBubble = Creator.NewRoundFrame(999, "Squircle", {
		Size = UDim2.new(0, 42, 0, 42),
		ImageColor3 = Color3.new(1, 1, 1),
		ImageTransparency = 0.9,
		Parent = Header,
	}, {
		Utils.CreateIcon(Creator, DiscordCard.Icon, Config.Window.Folder, "DiscordCard", false, nil),
	})

	local HeaderIcon = IconBubble:FindFirstChildWhichIsA("Frame") or IconBubble:FindFirstChildWhichIsA("ImageLabel")
	if HeaderIcon then
		HeaderIcon.Size = UDim2.new(0, 20, 0, 20)
		HeaderIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		HeaderIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		local IconTarget = Utils.GetImageTarget(HeaderIcon)
		if IconTarget then
			IconTarget.ImageColor3 = Color3.new(1, 1, 1)
			IconTarget.ImageTransparency = 0
		end
	end

	local HeaderText = New("Frame", {
		Size = UDim2.new(1, -52, 0, 0),
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

	DiscordCard.UIElements.Title = New("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = DiscordCard.Title,
		TextSize = 18,
		TextWrapped = true,
		TextXAlignment = "Left",
		TextColor3 = Color3.new(1, 1, 1),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		Parent = HeaderText,
	})

	DiscordCard.UIElements.Desc = New("TextLabel", {
		Name = "Desc",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = DiscordCard.Desc,
		TextSize = 13,
		TextWrapped = true,
		TextXAlignment = "Left",
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0.26,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = HeaderText,
	})

	local StatsRow = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Visible = DiscordCard.Members ~= nil or DiscordCard.Online ~= nil,
		Parent = DiscordCard.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Left",
			VerticalAlignment = "Center",
		}),
	})

	local function CreateStat(Title, Value, Color)
		return Creator.NewRoundFrame(999, "Squircle", {
			Size = UDim2.new(0, 0, 0, 28),
			AutomaticSize = "X",
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.9,
			Parent = StatsRow,
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			Creator.NewRoundFrame(999, "Circle", {
				Size = UDim2.new(0, 7, 0, 7),
				ImageColor3 = Color,
			}),
			New("TextLabel", {
				BackgroundTransparency = 1,
				Text = tostring(Value) .. " " .. Title,
				TextSize = 12,
				TextColor3 = Color3.new(1, 1, 1),
				TextTransparency = 0.08,
				AutomaticSize = "XY",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			}),
		})
	end

	if DiscordCard.Members then
		CreateStat("members", DiscordCard.Members, Color3.fromHex("#B6C2FF"))
	end
	if DiscordCard.Online then
		CreateStat("online", DiscordCard.Online, Color3.fromHex("#23A55A"))
	end

	local Actions = New("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Parent = DiscordCard.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
		}),
	})

	local function CreateButton(Title, Icon, Variant, Callback)
		local Button = Creator.NewRoundFrame(999, "Squircle", {
			Size = UDim2.new(0.5, -4, 1, 0),
			ImageColor3 = Variant == "Primary" and Color3.new(1, 1, 1) or Color3.new(1, 1, 1),
			ImageTransparency = Variant == "Primary" and 0.08 or 0.9,
			Parent = Actions,
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
			Utils.CreateIcon(Creator, Icon, Config.Window.Folder, "DiscordCard", false, nil),
			New("TextLabel", {
				BackgroundTransparency = 1,
				Text = Title,
				TextSize = 13,
				TextColor3 = Variant == "Primary" and Color3.fromHex("#111827") or Color3.new(1, 1, 1),
				TextTransparency = 0,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				AutomaticSize = "XY",
			}),
		}, true)

		local ButtonIcon = Button:FindFirstChildWhichIsA("Frame") or Button:FindFirstChildWhichIsA("ImageLabel")
		local IconTarget = Utils.GetImageTarget(ButtonIcon)
		if IconTarget then
			IconTarget.ImageColor3 = Variant == "Primary" and Color3.fromHex("#111827") or Color3.new(1, 1, 1)
			IconTarget.ImageTransparency = 0
		end

		Motion.AttachPress(Button, Creator, {
			Amount = 0.97,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			Creator.SafeCallback(Callback)
		end)

		return Button
	end

	local function CopyInvite(Title)
		if CopyText(DiscordCard.Url) then
			Notify(Config.WindUI, Title or "Discord link copied", DiscordCard.Url, "check", "Success")
			return true
		else
			Notify(Config.WindUI, "Discord invite", DiscordCard.Url, "link", "Warning")
			return false
		end
	end

	CreateButton(Config.CopyTitle or "Copy Link", "link", "Secondary", function()
		CopyInvite("Discord link copied")
	end)

	CreateButton(Config.JoinTitle or "Join", "external-link", "Primary", function()
		if DiscordCard.Callback then
			Creator.SafeCallback(DiscordCard.Callback, DiscordCard.Url, DiscordCard)
		end

		CopyInvite("Discord invite ready")
	end)

	function DiscordCard:SetInvite(Invite)
		DiscordCard.Invite = Invite
		DiscordCard.Url = GetInviteUrl(Invite)
		return DiscordCard.Url
	end

	function DiscordCard:GetUrl()
		return DiscordCard.Url
	end

	function DiscordCard:Copy()
		return CopyInvite("Discord link copied")
	end

	function DiscordCard:Open()
		if DiscordCard.Callback then
			Creator.SafeCallback(DiscordCard.Callback, DiscordCard.Url, DiscordCard)
		end
		return CopyInvite("Discord invite ready")
	end

	function DiscordCard:SetTitle(Title)
		DiscordCard.Title = Title
		DiscordCard.UIElements.Title.Text = Title
	end

	function DiscordCard:SetDesc(Desc)
		DiscordCard.Desc = Desc
		DiscordCard.UIElements.Desc.Text = Desc or ""
	end

	function DiscordCard:Highlight()
		Motion.Play(DiscordCard.UIElements.Main, "Highlight", { ImageTransparency = 0.08 }, nil, nil, "Highlight")
		task.delay(Motion.GetDuration("Highlight"), function()
			if DiscordCard.UIElements.Main.Parent then
				Motion.Play(DiscordCard.UIElements.Main, "Highlight", { ImageTransparency = 0 }, nil, nil, "Highlight")
			end
		end)
	end

	function DiscordCard:Destroy()
		DiscordCard.UIElements.Main:Destroy()
	end

	return DiscordCard.__type, DiscordCard
end

return Element

end)()

-- ── elements/TabBox.lua ──
_VYNX_MODULES["elements/TabBox.lua"] = (function()
local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

function Element:New(Config)
	local TabBox = {
		__type = "TabBox",
		Title = Config.Title or "Tabs",
		Desc = Config.Desc,
		Tabs = {},
		Selected = nil,
		SelectedValue = nil,
		UIElements = {},
	}

	TabBox.TabBoxFrame = require("./components/window/Element")({
		Title = TabBox.Title,
		Desc = TabBox.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = TabBox,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	TabBox.UIElements.Tabs = New("ScrollingFrame", {
		Name = "Tabs",
		Size = UDim2.new(1, 0, 0, Config.TabHeight or 36),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ScrollingDirection = "X",
		ScrollingEnabled = true,
		AutomaticCanvasSize = "X",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ElasticBehavior = "Never",
		Active = true,
		Parent = TabBox.TabBoxFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	TabBox.UIElements.Pages = New("Frame", {
		Name = "Pages",
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		Parent = TabBox.TabBoxFrame.UIElements.Container,
	})

	local function UpdateTabVisuals()
		for Index, Page in next, TabBox.Tabs do
			local Selected = TabBox.Selected == Index
			Motion.Play(Page.Button, "Switch", { ImageTransparency = Selected and 0.82 or 0.94 }, nil, nil, "State")
			Motion.Play(Page.TitleLabel, "Switch", { TextTransparency = Selected and 0 or 0.25 }, nil, nil, "State")
			if Page.IconTarget then
				Motion.Play(Page.IconTarget, "Switch", { ImageTransparency = Selected and 0 or 0.35 }, nil, nil, "State")
			end
		end
	end

	local function GetPageHeight(Page)
		local Layout = Page.UIElements.Container.UIListLayout
		local Padding = Config.Window.ElementConfig.UIPadding / 2
		local Height = Layout.AbsoluteContentSize.Y / Config.UIScale + Padding
		return math.max(Height, Padding)
	end

	local function UpdatePageHeight(Page)
		if not Page or not Page.UIElements.Container then
			return
		end

		local Height = GetPageHeight(Page)
		Page.UIElements.Container.Size = UDim2.new(1, 0, 0, Height)
		TabBox.UIElements.Pages.Size = UDim2.new(1, 0, 0, Height)
		return Height
	end

	local function ScrollTabIntoView(Page)
		task.defer(function()
			if not Page or not Page.Button or not Page.Button.Parent then
				return
			end

			local Tabs = TabBox.UIElements.Tabs
			local ViewWidth = Tabs.AbsoluteSize.X
			local ButtonLeft = Page.Button.AbsolutePosition.X - Tabs.AbsolutePosition.X + Tabs.CanvasPosition.X
			local ButtonRight = ButtonLeft + Page.Button.AbsoluteSize.X
			local ViewLeft = Tabs.CanvasPosition.X
			local ViewRight = ViewLeft + ViewWidth
			local Target = ViewLeft

			if ButtonLeft < ViewLeft then
				Target = ButtonLeft
			elseif ButtonRight > ViewRight then
				Target = ButtonRight - ViewWidth
			end

			if math.abs(Target - ViewLeft) > 1 then
				Tabs.CanvasPosition = Vector2.new(math.max(Target, 0), 0)
			end
		end)
	end

	local function QueuePageHeightUpdate(Page, Index)
		task.defer(function()
			if TabBox.Selected == Index and Page and Page.UIElements.Container.Parent then
				UpdatePageHeight(Page)
			end
		end)
	end

	function TabBox:Select(Index)
		local Page = TabBox.Tabs[Index]
		if not Page then
			return nil
		end

		TabBox.Selected = Index
		TabBox.SelectedValue = Page.Value
		for PageIndex, OtherPage in next, TabBox.Tabs do
			local IsSelected = PageIndex == Index
			OtherPage.UIElements.Container.Visible = IsSelected
			OtherPage.UIElements.Container.Active = IsSelected
			OtherPage.UIElements.Container.GroupTransparency = 1
			if IsSelected then
				OtherPage.UIElements.Container.Position = UDim2.new(0, 0, 0, 8)
			end
		end

		UpdatePageHeight(Page)
		Motion.Play(Page.UIElements.Container, "Switch", { GroupTransparency = 0 }, nil, nil, "Page")
		Motion.Play(Page.UIElements.Container, "Switch", { Position = UDim2.new(0, 0, 0, 0) }, nil, nil, "PageSlide")
		QueuePageHeightUpdate(Page, Index)
		UpdateTabVisuals()
		ScrollTabIntoView(Page)
		return Page
	end

	function TabBox:GetSelected()
		return TabBox.Selected and TabBox.Tabs[TabBox.Selected] or nil
	end

	function TabBox:Get()
		return TabBox.SelectedValue
	end

	function TabBox:SelectValue(Value)
		for Index, Page in next, TabBox.Tabs do
			if Page.Value == Value then
				return TabBox:Select(Index)
			end
		end
		return nil
	end

	function TabBox:Set(Value)
		return TabBox:SelectValue(Value)
	end

	function TabBox:Tab(TabConfig)
		TabConfig = TabConfig or {}
		local Index = #TabBox.Tabs + 1
		local Page = {
			__type = "TabBoxPage",
			Title = TabConfig.Title or ("Tab " .. tostring(Index)),
			Value = TabConfig.Value or TabConfig.Id or Index,
			Icon = TabConfig.Icon,
			Elements = {},
			UIElements = {},
			Gap = Config.Tab and Config.Tab.Gap or 6,
		}

		local Icon = Utils.CreateIcon(Creator, Page.Icon, Config.Window.Folder, "TabBox", true, "TabBoxIcon")
		if Icon then
			Icon.Size = UDim2.new(0, 15, 0, 15)
		end
		local IconTarget = Utils.GetImageTarget(Icon)
		local TextWidth = string.len(Page.Title) * (Config.Window.IsPC == false and 6 or 7)
		local ButtonWidth = math.clamp(TextWidth + (Icon and 40 or 26), Config.MinTabWidth or 68, Config.MaxTabWidth or 154)

		local Title = New("TextLabel", {
			Name = "Title",
			BackgroundTransparency = 1,
			Text = Page.Title,
			TextSize = Config.Window.IsPC == false and 12 or 13,
			TextTruncate = "AtEnd",
			Size = UDim2.new(0, math.max(ButtonWidth - (Icon and 42 or 20), 24), 1, 0),
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local Button = Creator.NewRoundFrame(999, "Squircle", {
			Name = "Tab",
			LayoutOrder = Index,
			Size = UDim2.new(0, ButtonWidth, 0, Config.TabButtonHeight or 30),
			ImageTransparency = 0.94,
			ClipsDescendants = true,
			ThemeTag = {
				ImageColor3 = "TabBoxTabBackground",
			},
			Parent = TabBox.UIElements.Tabs,
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
			}),
			Icon,
			Title,
		}, true)

		local Container = New("CanvasGroup", {
			Name = "Page",
			LayoutOrder = Index,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			GroupTransparency = 1,
			Visible = false,
			Active = false,
			Parent = TabBox.UIElements.Pages,
		}, {
			New("UIPadding", {
				PaddingTop = UDim.new(0, Config.Window.ElementConfig.UIPadding / 2),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, Page.Gap),
				FillDirection = "Vertical",
				VerticalAlignment = "Top",
				HorizontalAlignment = "Left",
				SortOrder = "LayoutOrder",
			}),
		})

		Page.Button = Button
		Page.TitleLabel = Title
		Page.Icon = Icon
		Page.IconTarget = IconTarget
		Page.ElementFrame = Container
		Page.UIElements.Container = Container
		Page.UIElements.Title = Title

		Config.ElementsModule.Load(
			Page,
			Container,
			Config.ElementsModule.Elements,
			Config.Window,
			Config.WindUI,
			function()
				QueuePageHeightUpdate(Page, Index)
			end,
			Config.ElementsModule,
			Config.UIScale,
			Config.Tab
		)

		function Page:Select()
			return TabBox:Select(Index)
		end

		function Page:Destroy()
			Button:Destroy()
			Container:Destroy()
			table.remove(TabBox.Tabs, Index)
			if TabBox.Selected == Index then
				TabBox.Selected = nil
				if TabBox.Tabs[1] then
					TabBox:Select(1)
				end
			end
		end

		TabBox.Tabs[Index] = Page

		Motion.AttachPress(Button, Creator, {
			Amount = 0.97,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			TabBox:Select(Index)
		end)

		Creator.AddSignal(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			QueuePageHeightUpdate(Page, Index)
		end)

		if not TabBox.Selected or TabConfig.Selected == true or TabConfig.Value == Config.Value then
			TabBox:Select(Index)
		else
			UpdateTabVisuals()
		end

		if typeof(TabConfig.Elements) == "function" then
			task.defer(function()
				Creator.SafeCallback(TabConfig.Elements, Page)
			end)
		end

		return Page
	end

	function TabBox:CreateTab(TabConfig)
		return TabBox:Tab(TabConfig)
	end

	for _, TabConfig in next, Config.Tabs or {} do
		TabBox:Tab(TabConfig)
	end

	return TabBox.__type, TabBox
end

return Element

end)()

-- ── elements/Path2D.lua ──
_VYNX_MODULES["elements/Path2D.lua"] = (function()
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

	Path2D.Path2DFrame = require("./components/window/Element")({
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

end)()

-- ── elements/Card.lua ──
_VYNX_MODULES["elements/Card.lua"] = (function()
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
		Card.UIElements.Image = Creator.Image(Card.Image, Card.Title .. "-card-image", 0, Config.Window.Folder, "Card", false, false)
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
			Utils.CreateIcon(Creator, ButtonConfig.Icon or "arrow-right", Config.Window.Folder, "Card", not ButtonAccent, "CardButtonIcon"),
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
		Motion.Play(Card.UIElements.Background, "Highlight", { BackgroundTransparency = 0.78 }, nil, nil, "CardHighlight")
		task.delay(Motion.GetDuration("Highlight"), function()
			if Card.UIElements.Main.Parent then
				Motion.Play(
					Card.UIElements.Background,
					"Highlight",
					{
						BackgroundTransparency = Creator.ClampTransparency(
							Config.Transparency,
							Config.Window.LiquidGlass and 0.84 or 0.9
						),
					},
					nil,
					nil,
					"CardHighlight"
				)
			end
		end)
	end

	function Card.UpdateShape(Container)
		local ShouldLinkCorners = Config.Window.ElementConfig.LinkCorners
			or Card.LinkCorners
			or (Config.ParentTable and Config.ParentTable.LinkCorners == true)

		local corners = {
			TopLeft = true,
			TopRight = true,
			BottomLeft = true,
			BottomRight = true,
		}
		local newShape = "Squircle"

		if ShouldLinkCorners and Container and Container.Elements then
			local ParentType = Config.ParentConfig
					and Config.ParentConfig.ParentTable
					and Config.ParentConfig.ParentTable.__type
				or Config.ParentType
				or (Config.ParentTable and Config.ParentTable.__type)
			newShape, corners = Creator.GetLinkedCornerShape(
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
			local DynamicShape = (newShape == "Squircle-TL-BL" or newShape == "Squircle-TR-BR") and "Squircle"
				or newShape
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

end)()

-- ── elements/Section.lua ──
_VYNX_MODULES["elements/Section.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

function Element:New(Config)
	local Section = {
		__type = "Section",
		Title = Config.Title or "Section",
		Desc = Config.Desc,
		Icon = Config.Icon,
		IconThemed = Config.IconThemed,
		TextXAlignment = Config.TextXAlignment or "Left",
		TextSize = Config.TextSize or 19,
		DescTextSize = Config.DescTextSize or 16,
		Box = Config.Box or false,
		BoxBorder = Config.BoxBorder or false,
		FontWeight = Config.FontWeight or Enum.FontWeight.SemiBold,
		DescFontWeight = Config.DescFontWeight or Enum.FontWeight.Medium,
		TextTransparency = Config.TextTransparency or 0.05,
		DescTextTransparency = Config.DescTextTransparency or 0.4,
		Opened = Config.Opened or false,
		UIElements = {},

		HeaderSize = 48,
		IconSize = 20,
		Padding = 10,

		Elements = {},

		Expandable = false,
	}

	local Icon

	function Section:SetIcon(i)
		Section.Icon = i or nil
		if Icon then
			Icon:Destroy()
		end
		if i then
			Icon = Creator.Image(
				i,
				i .. ":" .. Section.Title,
				0,
				Config.Window.Folder,
				Section.__type,
				true,
				Section.IconThemed,
				"SectionIcon"
			)
			Icon.Size = UDim2.new(0, Section.IconSize, 0, Section.IconSize)
		end
	end

	local ChevronIconFrame = New("Frame", {
		Size = UDim2.new(0, Section.IconSize, 0, Section.IconSize),
		BackgroundTransparency = 1,
		Visible = false,
	}, {
		New("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = Creator.Icon("chevron-down")[1],
			ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
			ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
			ThemeTag = {
				ImageTransparency = "SectionExpandIconTransparency",
				ImageColor3 = "SectionExpandIcon",
			},
		}),
	})

	if Section.Icon then
		Section:SetIcon(Section.Icon)
	end

	local TitleContainer = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			FillDirection = "Vertical",
			HorizontalAlignment = Section.TextXAlignment,
			VerticalAlignment = "Center",
			Padding = UDim.new(0, 4),
		}),
	})

	local TitleFrame, DescFrame

	local function createTitle(Text, Type)
		return New("TextLabel", {
			BackgroundTransparency = 1,
			TextXAlignment = Section.TextXAlignment,
			AutomaticSize = "Y",
			TextSize = Type == "Title" and Section.TextSize or Section.DescTextSize,
			TextTransparency = Type == "Title" and Section.TextTransparency or Section.DescTextTransparency,
			ThemeTag = {
				TextColor3 = "Text",
			},
			FontFace = Font.new(Creator.Font, Type == "Title" and Section.FontWeight or Section.DescFontWeight),
			--Parent = Config.Parent,
			--Size = UDim2.new(1,0,0,0),
			Text = Text,
			Size = UDim2.new(1, 0, 0, 0),
			TextWrapped = true,
			Parent = TitleContainer,
		})
	end

	TitleFrame = createTitle(Section.Title, "Title")
	if Section.Desc then
		DescFrame = createTitle(Section.Desc, "Desc")
	end

	local function UpdateTitleSize()
		local offset = 0
		if Icon then
			offset = offset - (Section.IconSize + 8)
		end
		if ChevronIconFrame.Visible then
			offset = offset - (Section.IconSize + 8)
		end
		TitleContainer.Size = UDim2.new(1, offset, 0, 0)
	end

	local Main = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = Config.Parent,
		--ClipsDescendants = true,
		AutomaticSize = "Y",
		ThemeTag = {
			ImageTransparency = Section.Box and "SectionBoxBackgroundTransparency" or nil,
			ImageColor3 = "SectionBoxBackground",
		},
		ImageTransparency = not Section.Box and 1 or nil,
	}, {
		Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner - 1, "SquircleOutline", {
			Size = UDim2.new(1, 0, 1, 0),
			--AnchorPoint = Vector2.new(0.5, 0.5),
			--Position = UDim2.new(0.5, 0, 0.5, 0),
			--ImageTransparency = .75,
			ThemeTag = {
				--ImageTransparency = "SectionBoxBorderTransparency",
				ImageColor3 = "SectionBoxBorder",
			},
			ImageTransparency = Section.Box and Section.BoxBorder and 0.92 or 1,
			Name = "Outline",
			ClipsDescendants = true,
		}, {
			New("TextButton", {
				Size = UDim2.new(1, 0, 0, Section.Expandable and 0 or (not DescFrame and Section.HeaderSize or 0)),
				BackgroundTransparency = 1,
				AutomaticSize = (not Section.Expandable or DescFrame) and "Y" or nil,
				Text = "",
				Name = "Top",
			}, {
				Section.Box and New("UIPadding", {
					PaddingTop = UDim.new(
						0,
						Config.Window.ElementConfig.UIPadding + (Config.Window.NewElements and 4 or 0)
					),
					PaddingLeft = UDim.new(
						0,
						Config.Window.ElementConfig.UIPadding + (Config.Window.NewElements and 4 or 0)
					),
					PaddingRight = UDim.new(
						0,
						Config.Window.ElementConfig.UIPadding + (Config.Window.NewElements and 4 or 0)
					),
					PaddingBottom = UDim.new(
						0,
						Config.Window.ElementConfig.UIPadding + (Config.Window.NewElements and 4 or 0)
					),
				}) or nil,
				Icon,
				TitleContainer,
				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = "Horizontal",
					VerticalAlignment = "Center",
					HorizontalAlignment = "Left",
				}),
				ChevronIconFrame,
			}),
			New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				Name = "Content",
				Visible = false,
				Position = UDim2.new(0, 0, 0, Section.HeaderSize + 10),
			}, {
				Section.Box and New("UIPadding", {
					PaddingLeft = UDim.new(0, Config.Window.ElementConfig.UIPadding / 1.5),
					PaddingRight = UDim.new(0, Config.Window.ElementConfig.UIPadding / 1.5),
					PaddingBottom = UDim.new(0, Config.Window.ElementConfig.UIPadding / 1.5),
				}) or nil,
				New("UIListLayout", {
					FillDirection = "Vertical",
					Padding = UDim.new(0, Config.Tab.Gap),
					VerticalAlignment = "Top",
				}),
			}),
		}),
	})

	-- Section.UIElements.Main:GetPropertyChangedSignal("TextBounds"):Connect(function()
	--     Section.UIElements.Main.Size = UDim2.new(1,0,0,Section.UIElements.Main.TextBounds.Y)
	-- end)

	Section.ElementFrame = Main

	Main.Outline.Top:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		Main.Outline.Content.Position = UDim2.new(0, 0, 0, (Main.Outline.Top.AbsoluteSize.Y / Config.UIScale) + 10)

		if Section.Opened then
			Section:Open(true)
		else
			Section.Close(true)
		end
	end)

	local ElementsModule = Config.ElementsModule

	ElementsModule.Load(Section, Main.Outline.Content, ElementsModule.Elements, Config.Window, Config.WindUI, function()
		if not Section.Expandable then
			Section.Expandable = true
			ChevronIconFrame.Visible = true
			UpdateTitleSize()
		end
	end, ElementsModule, Config.UIScale, Config.Tab)

	UpdateTitleSize()

	function Section:SetTitle(Title)
		Section.Title = Title
		TitleFrame.Text = Title
	end

	function Section:SetDesc(Desc)
		Section.Desc = Desc
		if not DescFrame then
			DescFrame = createTitle(Desc, "Desc")
		end
		DescFrame.Text = Desc
	end

	function Section:Destroy()
		for _, element in next, Section.Elements do
			element:Destroy()
		end

		-- Section.UIElements.Main.AutomaticSize = "None"
		-- Section.UIElements.Main.Size = UDim2.new(1,0,0,Section.UIElements.Main.TextBounds.Y)

		-- Tween(Section.UIElements.Main, .1, {TextTransparency = 1}):Play()
		-- task.wait(.1)
		-- Tween(Section.UIElements.Main, .15, {Size = UDim2.new(1,0,0,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()

		Main:Destroy()
	end

	function Section:Open(IsNotAnim)
		if Section.Expandable then
			Section.Opened = true
			if IsNotAnim then
				Main.Size = UDim2.new(
					Main.Size.X.Scale,
					Main.Size.X.Offset,
					0,
					Main.Outline.Top.AbsoluteSize.Y / Config.UIScale
						+ (Main.Outline.Content.AbsoluteSize.Y / Config.UIScale)
						+ 10
				)
				ChevronIconFrame.ImageLabel.Rotation = 180
			else
				Tween(Main, 0.33, {
					Size = UDim2.new(
						Main.Size.X.Scale,
						Main.Size.X.Offset,
						0,
						Main.Outline.Top.AbsoluteSize.Y / Config.UIScale
							+ (Main.Outline.Content.AbsoluteSize.Y / Config.UIScale)
							+ 10
					),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

				Tween(
					ChevronIconFrame.ImageLabel,
					0.2,
					{ Rotation = 180 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
			end
		end
	end
	function Section:Close(IsNotAnim)
		if Section.Expandable then
			Section.Opened = false
			if IsNotAnim then
				Main.Size = UDim2.new(
					Main.Size.X.Scale,
					Main.Size.X.Offset,
					0,
					(Main.Outline.Top.AbsoluteSize.Y / Config.UIScale)
				)
				ChevronIconFrame.ImageLabel.Rotation = 0
			else
				Tween(Main, 0.26, {
					Size = UDim2.new(
						Main.Size.X.Scale,
						Main.Size.X.Offset,
						0,
						(Main.Outline.Top.AbsoluteSize.Y / Config.UIScale)
					),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
				Tween(
					ChevronIconFrame.ImageLabel,
					0.2,
					{ Rotation = 0 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
			end
		end
	end

	Creator.AddSignal(Main.Outline.Top.MouseButton1Click, function()
		if Section.Expandable then
			if Section.Opened then
				Section:Close()
			else
				Section:Open()
			end
		end
	end)

	Creator.AddSignal(Main.Outline.Content.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if Section.Opened then
			Section:Open(true)
		else
			Section:Close(true)
		end
	end)

	task.defer(function()
		if Section.Expandable then
			-- New("UIPadding", {
			--     PaddingTop = UDim.new(0,4),
			--     PaddingLeft = UDim.new(0,Section.Padding),
			--     PaddingRight = UDim.new(0,Section.Padding),
			--     PaddingBottom = UDim.new(0,2),

			--     Parent = Main.Top,
			-- })
			Main.Size =
				UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, Main.Outline.Top.AbsoluteSize.Y / Config.UIScale)
			Main.AutomaticSize = "None"
			Main.Outline.Top.Size = UDim2.new(1, 0, 0, (not DescFrame and Section.HeaderSize or 0))
			Main.Outline.Top.AutomaticSize = (not Section.Expandable or DescFrame) and "Y" or "None"
			Main.Outline.Content.Visible = true
		end
		if Section.Opened then
			Section:Open()
		else
			Section:Close(true)
		end
	end)

	return Section.__type, Section
end

return Element

end)()

-- ── elements/Divider.lua ──
_VYNX_MODULES["elements/Divider.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
    local Divider = New("Frame", {
        Size = Config.ParentType ~= "Group" and UDim2.new(1,0,0,1) or UDim2.new(0,1,1,0),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = .9,
        ThemeTag = {
            BackgroundColor3 = "Text"
        }
    })
    local MainDivider = New("Frame", {
        Parent = Config.Parent,
        Size = Config.ParentType ~= "Group" and UDim2.new(1,-7,0,7) or UDim2.new(0,7,1,-7),
        BackgroundTransparency = 1,
    }, {
        Divider
    })
    
    return "Divider", { __type = "Divider", ElementFrame = MainDivider }
end

return Element
end)()

-- ── elements/Space.lua ──
_VYNX_MODULES["elements/Space.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
    local MainSpace = New("Frame", {
        Parent = Config.Parent,
        Size = not table.find({ "Group", "HStack" }, Config.ParentType) and UDim2.new(1,-7,0,7*(Config.Columns or 1)) or UDim2.new(0,7*(Config.Columns or 1),0,0),
        BackgroundTransparency = 1,
    })
    
    return "Space", { __type = "Space", ElementFrame = MainSpace}
end

return Element
end)()

-- ── elements/Image.lua ──
_VYNX_MODULES["elements/Image.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

local function ParseAspectRatio(aspectRatio)
    if type(aspectRatio) == "string" then
        local width, height = aspectRatio:match("(%d+):(%d+)")
        if width and height then
            return tonumber(width) / tonumber(height)
        end
    elseif type(aspectRatio) == "number" then
        return aspectRatio
    end
    return nil
end

function Element:New(Config)
    local ImageModule = {
        __type = "Image",
        Image = Config.Image or "",
        AspectRatio = Config.AspectRatio or "16:9",
        Radius = Config.Radius or Config.Window.ElementConfig.UICorner,
    }
    local MainImage = Creator.Image(
        ImageModule.Image,
        ImageModule.Image,
        ImageModule.Radius,
        Config.Window.Folder,
        "Image",
        false
    )
    if MainImage and MainImage.Parent then
        MainImage.Parent = Config.Parent
        MainImage.Size = UDim2.new(1,0,0,0)
        MainImage.BackgroundTransparency = 1
        
        -- local MainImage = New("ImageLabel", {
        --     Parent = Config.Parent,
        --     Size = UDim2.new(1, 0, 0, 0),
        --     Image = ,
        --     BackgroundTransparency = 1,
        -- }, {
        --     New("UICorner", {
        --         CornerRadius = UDim.new(0,ImageModule.Radius)
        --     })
        -- })
        
        local aspectRatio = ParseAspectRatio(ImageModule.AspectRatio)
        local aspectRatioConstraint = nil
        
        if aspectRatio then
            aspectRatioConstraint = New("UIAspectRatioConstraint", {
                Parent = MainImage,
                AspectRatio = aspectRatio,
                AspectType = "ScaleWithParentSize",
                DominantAxis = "Width"
            })
        end
        
        function ImageModule:Destroy()
            MainImage:Destroy()
        end
    end
    
    return ImageModule.__type, ImageModule
end

return Element
end)()

-- ── elements/Group.lua ──
_VYNX_MODULES["elements/Group.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
    local GroupModule = {
        __type = "Group",
        Elements = {},
        ElementFrame = nil,
        LinkCorners = Config.LinkCorners == true,
        CornerLink = Config.CornerLink,
    }
    
    local GroupFrame = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
        Parent = Config.Parent,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            HorizontalAlignment = "Center",
            --VerticalAlignment = "Center",
            Padding = UDim.new(0, Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6))
        }),
    })

    GroupModule.ElementFrame = GroupFrame
    
    local ElementsModule = Config.ElementsModule
    ElementsModule.Load(
        GroupModule, 
        GroupFrame, 
        ElementsModule.Elements,
        Config.Window, 
        Config.WindUI,
        function(CurrentElement, AllElements)
            local Gap = Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6)
            
            local StretchableElements = {}
            local TotalFixedWidth = 0
            
            for _, Element in next, AllElements do
                if Element.__type == "Space" then
                    TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 6)
                elseif Element.__type == "Divider" then
                    TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 1)
                else
                    table.insert(StretchableElements, Element)
                end
            end
            
            local StretchCount = #StretchableElements
            if StretchCount == 0 then return end
            
            local ElementWidthScale = 1 / StretchCount
            
            local TotalGapWidth = Gap * (StretchCount - 1)
            
            local TotalOffset = -(TotalGapWidth + TotalFixedWidth)
            
            local BaseOffset = math.floor(TotalOffset / StretchCount)
            local Remainder = TotalOffset - (BaseOffset * StretchCount)
            
            for i, Element in next, StretchableElements do
                local Offset = BaseOffset
                if i <= math.abs(Remainder) then
                    Offset = Offset - 1
                end
                
                if Element.ElementFrame then
                    Element.ElementFrame.Size = UDim2.new(ElementWidthScale, Offset, 1, 0)
                end
            end
        end,  
        ElementsModule, 
        Config.UIScale, 
        Config.Tab
    )
    
    
    
    return GroupModule.__type, GroupModule
end

return Element

end)()

-- ── elements/HStack.lua ──
_VYNX_MODULES["elements/HStack.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local HStackModule = {
		__type = "HStack",
		AutoSpace = Config.AutoSpace or false,
		Elements = {},
		ElementFrame = nil,
		LinkCorners = Config.LinkCorners == true,
		CornerLink = Config.CornerLink,
		MinChildWidth = math.max(tonumber(Config.MinChildWidth) or 128, 40),
		IsStacked = false,
	}

	local HStackFrame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = "Y",
		Parent = Config.Parent,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
			--VerticalAlignment = "Center",
			Padding = UDim.new(0, Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6)),
		}),
	})

	HStackModule.ElementFrame = HStackFrame

	local ElementsModule = Config.ElementsModule
	local function UpdateLayout(AllElements)
		AllElements = AllElements or HStackModule.Elements
		local Gap = Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6)

		local StretchableElements = {}
		local TotalFixedWidth = 0
		local ParentWidth = HStackFrame.AbsoluteSize.X / Config.UIScale

		for _, Element in next, AllElements do
			if Element.__type == "Space" then
				TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 6)
			elseif Element.__type == "Divider" then
				TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 1)
			else
				table.insert(StretchableElements, Element)
			end
		end

		local StretchCount = #StretchableElements
		if StretchCount == 0 then
			return
		end

		local TotalGapWidth = Gap * (StretchCount - 1)
		local AvailableWidth = ParentWidth - TotalGapWidth - TotalFixedWidth
		local ShouldStack = ParentWidth > 0 and AvailableWidth / StretchCount < HStackModule.MinChildWidth
		local OrientationChanged = HStackModule.IsStacked ~= ShouldStack
		HStackModule.IsStacked = ShouldStack
		local ElementWidthScale = ShouldStack and 1 or (1 / StretchCount)
		local TotalOffset = ShouldStack and 0 or -(TotalGapWidth + TotalFixedWidth)
		local BaseOffset = math.floor(TotalOffset / StretchCount)
		local Remainder = TotalOffset - (BaseOffset * StretchCount)

		HStackFrame.UIListLayout.FillDirection = ShouldStack and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		HStackFrame.UIListLayout.HorizontalAlignment = ShouldStack and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center

		for i, Element in next, StretchableElements do
			local Offset = ShouldStack and 0 or BaseOffset
			if not ShouldStack and i <= math.abs(Remainder) then
				Offset = Offset - 1
			end

			if Element.ElementFrame then
				local CurrentSize = Element.ElementFrame.Size
				Element.ElementFrame.Size = UDim2.new(
					ElementWidthScale,
					Offset,
					CurrentSize.Y.Scale == 1 and 0 or CurrentSize.Y.Scale,
					CurrentSize.Y.Scale == 1 and 0 or CurrentSize.Y.Offset
				)
			end
		end

		if OrientationChanged and HStackModule.UpdateAllElementShapes then
			HStackModule:UpdateAllElementShapes(HStackModule)
		end
	end

	ElementsModule.Load(
		HStackModule,
		HStackFrame,
		ElementsModule.Elements,
		Config.Window,
		Config.WindUI,
		function(CurrentElement, AllElements)
			UpdateLayout(AllElements)
		end,
		ElementsModule,
		Config.UIScale,
		Config.Tab
	)

	Creator.AddSignal(HStackFrame:GetPropertyChangedSignal("AbsoluteSize"), function()
		UpdateLayout()
	end)

	if HStackModule.AutoSpace then
		for name in next, ElementsModule.Elements do
			if name ~= "Space" and name ~= "Divider" then
				local original = HStackModule[name]
				HStackModule[name] = function(self, config)
					if #HStackModule.Elements > 0 then
						HStackModule:Space()
					end
					return original(self, config)
				end
			end
		end
	end

	return HStackModule.__type, HStackModule
end

return Element

end)()

-- ── elements/VStack.lua ──
_VYNX_MODULES["elements/VStack.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
    local VStackModule = {
        __type = "VStack",
        Elements = {},
        ElementFrame = nil,
        LinkCorners = Config.LinkCorners == true,
        CornerLink = Config.CornerLink,
    }
    
    local VStackFrame = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
        Parent = Config.Parent,
    }, {
        New("UIListLayout", {
            FillDirection = "Vertical",
            HorizontalAlignment = "Center",
            --VerticalAlignment = "Center",
            Padding = UDim.new(0, Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6))
        }),
    })

    VStackModule.ElementFrame = VStackFrame
    
    local ElementsModule = Config.ElementsModule
    ElementsModule.Load(
        VStackModule, 
        VStackFrame, 
        ElementsModule.Elements,
        Config.Window, 
        Config.WindUI,
        -- function(CurrentElement, AllElements)
        --     local Gap = Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6)
            
        --     local StretchableElements = {}
        --     local TotalFixedWidth = 0
            
        --     for _, Element in next, AllElements do
        --         if Element.__type == "Space" then
        --             TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 6)
        --         elseif Element.__type == "Divider" then
        --             TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 1)
        --         else
        --             table.insert(StretchableElements, Element)
        --         end
        --     end
            
        --     local StretchCount = #StretchableElements
        --     if StretchCount == 0 then return end
            
        --     local ElementWidthScale = 1 / StretchCount
            
        --     local TotalGapWidth = Gap * (StretchCount - 1)
            
        --     local TotalOffset = -(TotalGapWidth + TotalFixedWidth)
            
        --     local BaseOffset = math.floor(TotalOffset / StretchCount)
        --     local Remainder = TotalOffset - (BaseOffset * StretchCount)
            
        --     for i, Element in next, StretchableElements do
        --         local Offset = BaseOffset
        --         if i <= math.abs(Remainder) then
        --             Offset = Offset - 1
        --         end
                
        --         if Element.ElementFrame then
        --             Element.ElementFrame.Size = UDim2.new(ElementWidthScale, Offset, 1, 0)
        --         end
        --     end
        -- end,  
        nil,
        ElementsModule, 
        Config.UIScale, 
        Config.Tab
    )
    
    
    
    return VStackModule.__type, VStackModule
end

return Element

end)()

-- ── elements/Viewport.lua ──
_VYNX_MODULES["elements/Viewport.lua"] = (function()
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))

local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

type ConfigType = {
	Object: Instance,
	Camera: Instance?,
	Interactive: boolean?,
	Height: number?,
	Focused: boolean,

	Window: any, -- later
	WindUI: any, -- later
	Tab: any, -- later
	Parent: Instance,
}

function Element:New(Config: ConfigType)
	local Viewport = {
		__type = "Viewport",
		Object = Config.Object,
		Camera = Config.Camera or Instance.new("Camera"),
		Interactive = Config.Interactive or false,
		Height = Config.Height or 200,
		Focused = Config.Focused ~= false,
	}

	local Dragging = false
	local Pinching = false
	local LastMousePos, LastPinchDist = nil, 0

	local Main = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 0, Viewport.Height),
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = "ViewportBackground",
			ImageTransparency = "ViewportBackgroundTransparency",
		},
	}, {
		New("CanvasGroup", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Config.Window.ElementConfig.UICorner),
			}),
			New("ViewportFrame", {
				Name = "Viewport",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				CurrentCamera = Viewport.Camera,
				Active = Viewport.Interactive,
			}, {
				Viewport.Object,
			}),
		}),
	})

	local function IsTouchInsideViewport(Position)
		local AbsPos = Main.CanvasGroup.Viewport.AbsolutePosition
		local Size = Main.CanvasGroup.Viewport.AbsoluteSize

		return Position.X >= AbsPos.X
			and Position.X <= AbsPos.X + Size.X
			and Position.Y >= AbsPos.Y
			and Position.Y <= AbsPos.Y + Size.Y
	end

	local CurInput = Config.WindUI.GenerateGUID()

	Creator.AddSignal(Main.CanvasGroup.Viewport.MouseEnter, function()
		if Viewport.Interactive then
			Config.Tab.UIElements.ContainerFrame.ScrollingEnabled = false
		end
	end)

	Creator.AddSignal(Main.CanvasGroup.Viewport.InputEnded, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Config.Tab.UIElements.ContainerFrame.ScrollingEnabled = true
		end
	end)

	Creator.AddSignal(Main.CanvasGroup.Viewport.InputBegan, function(Input)
		if Viewport.Interactive then
			if
				(Input.UserInputType == Enum.UserInputType.MouseButton1)
				or (Input.UserInputType == Enum.UserInputType.Touch and not Pinching)
			then
				if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
					return
				end

				Config.WindUI.CurrentInput = CurInput

				Dragging = true
				LastMousePos = Input.Position
			end
		end
	end)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if Viewport.Interactive then
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
					return
				end

				Config.WindUI.CurrentInput = nil

				Dragging = false
			end
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if Viewport.Interactive and Dragging and not Pinching then
			if
				Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				local MouseDelta = Input.Position - LastMousePos
				LastMousePos = Input.Position

				local Position = Viewport.Object:GetPivot().Position
				local Camera = Viewport.Camera

				local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.02)
				Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

				local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.02)
				local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

				if PitchedCFrame.UpVector.Y > 0.1 then
					Camera.CFrame = PitchedCFrame
				end
			end
		end
	end)

	Creator.AddSignal(Main.CanvasGroup.Viewport.InputChanged, function(Input)
		if Viewport.Interactive then
			if Input.UserInputType == Enum.UserInputType.MouseWheel then
				local ZoomAmount = Input.Position.Z * 2
				Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
			end
		end
	end)

	Creator.AddSignal(UserInputService.TouchPinch, function(touchPositions, scale, velocity, state)
		if not IsTouchInsideViewport(touchPositions[1]) or not IsTouchInsideViewport(touchPositions[2]) then
			return
		end
		if Viewport.Interactive then
			if state == Enum.UserInputState.Begin then
				Pinching = true
				Dragging = false
				LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
			elseif state == Enum.UserInputState.Change then
				if Pinching then
					local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
					local delta = (currentDist - LastPinchDist) * 0.03
					LastPinchDist = currentDist
					Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
				end
			elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
				Pinching = false
			end
		end
	end)

	local function FocusCamera()
		local ModelSize = Viewport.Object:IsA("BasePart") and Viewport.Object.Size
			or select(2, Viewport.Object:GetBoundingBox(0))
		local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
		local CameraDistance = MaxExtent * 2
		local ModelPosition = Viewport.Object:GetPivot().Position

		Viewport.Camera.CFrame =
			CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
	end

	if Viewport.Focused then
		FocusCamera()
	end

	function Viewport:SetObject(Object, IsClone)
		if IsClone then
			Object = Object:Clone()
		end
		if Viewport.Object then
			Viewport.Object:Destroy()
		end

		Viewport.Object = Object
		Viewport.Object.Parent = Main.CanvasGroup.Viewport
	end

	function Viewport:SetHeight(Height)
		Main.Size = UDim2.new(1, 0, 0, Height)
	end

	function Viewport:Focus()
		if Viewport.Object then
			FocusCamera()
		end
	end

	function Viewport:SetCamera(Camera)
		Viewport.Camera = Camera
		Main.CanvasGroup.Viewport.CurrentCamera = Camera
	end

	function Viewport:SetInteractive(Interactive)
		Viewport.Interactive = Interactive
		Main.CanvasGroup.Viewport.Active = Interactive
	end

	Viewport.Main = Main

	return Viewport.__type, Viewport
end

return Element

end)()

-- ── elements/Video.lua ──
_VYNX_MODULES["elements/Video.lua"] = (function()
--- VideoFrame is not working with custom video on exploits

local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

local function ParseAspectRatio(aspectRatio)
    if type(aspectRatio) == "string" then
        local width, height = aspectRatio:match("(%d+):(%d+)")
        if width and height then
            return tonumber(width) / tonumber(height)
        end
    elseif type(aspectRatio) == "number" then
        return aspectRatio
    end
    return nil
end


function Element:New(Config)
    local VideoModule = {
        __type = "Video",
        Video = Config.Video or "",
        AspectRatio = Config.AspectRatio or "16:9",
        Radius = Config.Radius or Config.Window.ElementConfig.UICorner,
        ElementFrame = nil,
    }
    
    local MainVideo
    
    if VideoModule.Video then
        local BGVideo
        if string.find(VideoModule.Video, "http") then
            local folder = Config.Window.Folder or "Temp"
            if makefolder and isfolder then
                if not isfolder(folder) then
                    makefolder(folder)
                end
                if not isfolder(folder .. "/assets") then
                    makefolder(folder .. "/assets")
                end
            end
            local videoPath = folder .. "/assets/." .. Creator.SanitizeFilename(VideoModule.Video) .. ".webm"
            if not isfile or not isfile(videoPath) then
                local success, result = pcall(function()
                    local response = game.HttpGet and game:HttpGet(VideoModule.Video) or nil
                    if not response and Creator.Request then
                        local requestResponse = Creator.Request({
                            Url = VideoModule.Video,
                            Method = "GET",
                            Headers = { ["User-Agent"] = "Roblox/Exploit" },
                        })
                        response = requestResponse and requestResponse.Body
                    end
                    if response and writefile then
                        writefile(videoPath, response)
                    end
                end)
                if not success then
                    warn("[ Window.Background ] Failed to download video: " .. tostring(result))
                    return
                end
            end
            
            local success, customAsset = pcall(function()
                return typeof(getcustomasset) == "function" and getcustomasset(videoPath) or videoPath
            end)
            if not success then
                warn("[ WindUI.Video ] Failed to load custom asset: " .. tostring(customAsset))
            end
            BGVideo = customAsset
        else
            BGVideo = VideoModule.Video
        end
        
        MainVideo = New("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            Video = BGVideo,
            Looped = false,
            Volume = 0,
            Parent = Config.Parent
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,VideoModule.Radius)
            }),
        })
        VideoModule.ElementFrame = MainVideo
        MainVideo:Play()
        
        
        local aspectRatio = ParseAspectRatio(VideoModule.AspectRatio)
        local aspectRatioConstraint = nil
        
        if aspectRatio then
            aspectRatioConstraint = New("UIAspectRatioConstraint", {
                Parent = MainVideo,
                AspectRatio = aspectRatio,
                AspectType = "ScaleWithParentSize",
                DominantAxis = "Width"
            })
        end
    end
    
    
    function VideoModule:Destroy()
        if MainVideo then MainVideo:Destroy() end
    end
    
    return VideoModule.__type, VideoModule
end

return Element

end)()

-- ── elements/DependencyBox.lua ──
_VYNX_MODULES["elements/DependencyBox.lua"] = (function()
local Creator = require("../modules/Creator")
local New = Creator.New

local DependencyBox = {}

function DependencyBox.AttachToSection(Section, VynxUI)
	function Section:AddDependencyBox()
		if self.Destroyed then
			return nil
		end

		local Groupbox = self
		local Container = Groupbox.Container or Groupbox.ElementContainer

		if not Container then
			return nil
		end

		local DepboxContainer = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Visible = false,
			ClipsDescendants = false,
			Parent = Container,
		})

		local DepboxList = New("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = DepboxContainer,
		})

		local Depbox = {
			__type        = "DependencyBox",
			Connections   = {},
			Destroyed     = false,
			Visible       = false,
			Dependencies  = {},
			Holder        = DepboxContainer,
			Container     = DepboxContainer,
			Elements      = {},
			DependencyBoxes = {},
			Window        = Groupbox.Window,
			WindUI        = Groupbox.WindUI or VynxUI,
		}

		function Depbox:Resize()
			local height = DepboxList.AbsoluteContentSize.Y
			DepboxContainer.Size = UDim2.new(1, 0, 0, height)
			if Groupbox.Resize then
				Groupbox:Resize()
			end
		end

		function Depbox:Update()
			for _, Dependency in Depbox.Dependencies do
				local Element = Dependency[1]
				local Expected = Dependency[2]

				if not Element then
					continue
				end

				local elemType = Element.__type or Element.Type or ""

				if elemType == "Toggle" or elemType == "Checkbox" then
					if Element.Value ~= Expected then
						DepboxContainer.Visible = false
						Depbox.Visible = false
						return
					end
				elseif elemType == "Dropdown" then
					local val = Element.Value
					if typeof(val) == "table" then
						if not val[Expected] then
							DepboxContainer.Visible = false
							Depbox.Visible = false
							return
						end
					else
						if val ~= Expected then
							DepboxContainer.Visible = false
							Depbox.Visible = false
							return
						end
					end
				end
			end

			Depbox.Visible = true
			DepboxContainer.Visible = true
			task.defer(function()
				Depbox:Resize()
			end)
		end

		DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if Depbox.Visible then
				Depbox:Resize()
			end
		end)

		function Depbox:SetupDependencies(Dependencies)
			for _, Dep in Dependencies do
				assert(typeof(Dep) == "table", "Each dependency must be a table: {element, expectedValue}")
				assert(Dep[1] ~= nil, "Dependency missing element reference")
				assert(Dep[2] ~= nil, "Dependency missing expected value")

				local Element = Dep[1]
				if Element.OnChanged then
					local conn = Element.OnChanged:Connect(function()
						Depbox:Update()
					end)
					table.insert(Depbox.Connections, conn)
				elseif Element.OnChange then
					local conn = Element.OnChange:Connect(function()
						Depbox:Update()
					end)
					table.insert(Depbox.Connections, conn)
				end
			end

			Depbox.Dependencies = Dependencies
			Depbox:Update()
		end

		function Depbox:Destroy()
			Depbox.Destroyed = true

			for _, conn in Depbox.Connections do
				if conn and conn.Connected then
					conn:Disconnect()
				end
			end

			for _, elem in Depbox.Elements do
				if elem and elem.Destroy then
					elem:Destroy()
				end
			end

			for _, sub in Depbox.DependencyBoxes do
				if sub and sub.Destroy then
					sub:Destroy()
				end
			end

			if DepboxContainer and DepboxContainer.Parent then
				DepboxContainer:Destroy()
			end

			if VynxUI and VynxUI.DependencyBoxes then
				local idx = table.find(VynxUI.DependencyBoxes, Depbox)
				if idx then
					table.remove(VynxUI.DependencyBoxes, idx)
				end
			end
		end

		local ElementsModule = require("./Init")
		ElementsModule.Load(
			Depbox,
			DepboxContainer,
			ElementsModule.Elements,
			Groupbox.Window,
			Groupbox.WindUI or VynxUI,
			nil,
			ElementsModule,
			Groupbox.UIScale or 1,
			Groupbox.Tab
		)

		if VynxUI and VynxUI.DependencyBoxes then
			table.insert(VynxUI.DependencyBoxes, Depbox)
		end

		return Depbox
	end

	function Section:AddDependencyGroupbox(Title)
		if self.Destroyed then
			return nil
		end

		local Groupbox = self
		local Container = Groupbox.Container or Groupbox.ElementContainer
		if not Container then
			return nil
		end

		local DepGroupboxOuter = New("Frame", {
			BackgroundColor3 = Color3.fromHex("#1E1E2C"),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = Container,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 8) }),
			New("UIStroke", {
				Color = Color3.fromHex("#2a2a3a"),
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),
			New("UIPadding", {
				PaddingTop    = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft   = UDim.new(0, 8),
				PaddingRight  = UDim.new(0, 8),
			}),
		})

		local DepGroupboxList = New("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = DepGroupboxOuter,
		})

		if Title then
			New("TextLabel", {
				BackgroundTransparency = 1,
				Text = Title,
				TextSize = 13,
				TextColor3 = Color3.fromHex("#a1a1aa"),
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, 16),
				LayoutOrder = 0,
				Parent = DepGroupboxOuter,
			})
		end

		local DepGroupbox = {
			__type        = "DependencyGroupbox",
			Connections   = {},
			Destroyed     = false,
			Visible       = false,
			Dependencies  = {},
			Holder        = DepGroupboxOuter,
			Container     = DepGroupboxOuter,
			Elements      = {},
			DependencyBoxes = {},
			Window        = Groupbox.Window,
			WindUI        = Groupbox.WindUI or VynxUI,
			Tab           = Groupbox.Tab,
		}

		function DepGroupbox:Resize()
			DepGroupboxOuter.Size = UDim2.new(1, 0, 0, DepGroupboxList.AbsoluteContentSize.Y + 16)
		end

		function DepGroupbox:Update()
			for _, Dep in DepGroupbox.Dependencies do
				local Element = Dep[1]
				local Expected = Dep[2]

				if not Element then
					continue
				end

				local elemType = Element.__type or Element.Type or ""

				if elemType == "Toggle" or elemType == "Checkbox" then
					if Element.Value ~= Expected then
						DepGroupboxOuter.Visible = false
						DepGroupbox.Visible = false
						return
					end
				elseif elemType == "Dropdown" then
					local val = Element.Value
					if typeof(val) == "table" then
						if not val[Expected] then
							DepGroupboxOuter.Visible = false
							DepGroupbox.Visible = false
							return
						end
					else
						if val ~= Expected then
							DepGroupboxOuter.Visible = false
							DepGroupbox.Visible = false
							return
						end
					end
				end
			end

			DepGroupbox.Visible = true
			DepGroupboxOuter.Visible = true
			task.defer(function()
				DepGroupbox:Resize()
			end)
		end

		function DepGroupbox:SetupDependencies(Dependencies)
			for _, Dep in Dependencies do
				assert(typeof(Dep) == "table", "Each dependency must be a table: {element, expectedValue}")
				assert(Dep[1] ~= nil, "Dependency missing element reference")
				assert(Dep[2] ~= nil, "Dependency missing expected value")

				local Element = Dep[1]
				if Element.OnChanged then
					local conn = Element.OnChanged:Connect(function()
						DepGroupbox:Update()
					end)
					table.insert(DepGroupbox.Connections, conn)
				elseif Element.OnChange then
					local conn = Element.OnChange:Connect(function()
						DepGroupbox:Update()
					end)
					table.insert(DepGroupbox.Connections, conn)
				end
			end

			DepGroupbox.Dependencies = Dependencies
			DepGroupbox:Update()
		end

		function DepGroupbox:Destroy()
			DepGroupbox.Destroyed = true

			for _, conn in DepGroupbox.Connections do
				if conn and conn.Connected then
					conn:Disconnect()
				end
			end

			for _, elem in DepGroupbox.Elements do
				if elem and elem.Destroy then
					elem:Destroy()
				end
			end

			for _, sub in DepGroupbox.DependencyBoxes do
				if sub and sub.Destroy then
					sub:Destroy()
				end
			end

			if DepGroupboxOuter and DepGroupboxOuter.Parent then
				DepGroupboxOuter:Destroy()
			end

			if VynxUI and VynxUI.DependencyBoxes then
				local idx = table.find(VynxUI.DependencyBoxes, DepGroupbox)
				if idx then
					table.remove(VynxUI.DependencyBoxes, idx)
				end
			end
		end

		local ElementsModule = require("./Init")
		ElementsModule.Load(
			DepGroupbox,
			DepGroupboxOuter,
			ElementsModule.Elements,
			Groupbox.Window,
			Groupbox.WindUI or VynxUI,
			nil,
			ElementsModule,
			Groupbox.UIScale or 1,
			Groupbox.Tab
		)

		if VynxUI and VynxUI.DependencyBoxes then
			table.insert(VynxUI.DependencyBoxes, DepGroupbox)
		end

		return DepGroupbox
	end
end

return DependencyBox

end)()

-- ── elements/Init.lua ──
_VYNX_MODULES["elements/Init.lua"] = (function()
-- VYNX UI — Elements Init
-- Supports: WindUI-style (Section:Toggle{}) + Obsidian-style (Group:AddToggle(Idx, Info))

local Elements = {
	-- WindUI originals (38 elements)
	Paragraph       = require("./Paragraph"),
	Button          = require("./Button"),
	Toggle          = require("./Toggle"),
	Slider          = require("./Slider"),
	ProgressBar     = require("./ProgressBar"),
	Keybind         = require("./Keybind"),
	Input           = require("./Input"),
	Dropdown        = require("./Dropdown"),
	Code            = require("./Code"),
	Colorpicker     = require("./Colorpicker"),
	RadioGroup      = require("./RadioGroup"),
	CheckboxGroup   = require("./CheckboxGroup"),
	SegmentedControl= require("./SegmentedControl"),
	TextArea        = require("./TextArea"),
	Stepper         = require("./Stepper"),
	Callout         = require("./Callout"),
	Badge           = require("./Badge"),
	StatusCard      = require("./StatusCard"),
	StatCard        = require("./StatCard"),
	KeyValue        = require("./KeyValue"),
	ChipList        = require("./ChipList"),
	ActionList      = require("./ActionList"),
	MeterGroup      = require("./MeterGroup"),
	Timeline        = require("./Timeline"),
	Accordion       = require("./Accordion"),
	EmptyState      = require("./EmptyState"),
	DiscordCard     = require("./DiscordCard"),
	TabBox          = require("./TabBox"),
	Path2D          = require("./Path2D"),
	Card            = require("./Card"),
	Section         = require("./Section"),
	Divider         = require("./Divider"),
	Space           = require("./Space"),
	Image           = require("./Image"),
	Group           = require("./Group"),
	HStack          = require("./HStack"),
	VStack          = require("./VStack"),
	Viewport        = require("./Viewport"),
	Video           = require("./Video"),
	-- Obsidian ports (new)
	Checkbox        = require("./Checkbox"),
	UIPassthrough   = require("./UIPassthrough"),
}

local DependencyBoxModule = require("./DependencyBox")

-- ── Registry helpers (Obsidian global access) ────────────────────────────────
local function RegisterInVynx(VynxUI, key, elem, idx)
	if not VynxUI or not idx then return end
	if key == "Toggle"       then VynxUI.Toggles[idx] = elem
	elseif key == "Slider" or key == "Dropdown" or key == "RadioGroup"
		or key == "Keybind"  or key == "Colorpicker" or key == "Input"
		or key == "Checkbox" or key == "SegmentedControl" or key == "Stepper"
		or key == "CheckboxGroup"
	then VynxUI.Options[idx] = elem
	elseif key == "Paragraph" or key == "Badge" then VynxUI.Labels[idx] = elem
	elseif key == "Button"   then VynxUI.Buttons[idx] = elem
	end
end

-- ── Obsidian-style method name → WindUI element name map ────────────────────
local ObsidianAliases = {
	AddToggle         = "Toggle",
	AddSlider         = "Slider",
	AddDropdown       = "Dropdown",
	AddInput          = "Input",
	AddButton         = "Button",
	AddLabel          = "Paragraph",
	AddCheckbox       = "Checkbox",
	AddKeyPicker      = "Keybind",
	AddColorPicker    = "Colorpicker",
	AddDivider        = "Divider",
	AddImage          = "Image",
	AddViewport       = "Viewport",
	AddVideo          = "Video",
	AddUIPassthrough  = "UIPassthrough",
	AddProgressBar    = "ProgressBar",
	AddSegmentedControl = "SegmentedControl",
	AddRadioGroup     = "RadioGroup",
}

-- ── Obsidian Info → WindUI Config translator ─────────────────────────────────
local function TranslateObsidianConfig(elemName, Idx, Info)
	Info = Info or {}
	local cfg = {}

	-- Common
	cfg.Title   = Info.Text or Info.Title or (typeof(Idx) == "string" and Idx) or ""
	cfg.Desc    = Info.Tooltip or Info.Desc
	cfg.Default = Info.Default
	cfg.Locked  = Info.Disabled or Info.Locked or false
	cfg.Visible = Info.Visible
	cfg.Flag    = typeof(Idx) == "string" and Idx or Info.Flag

	-- Callback normalise (Obsidian uses Callback OR Changed)
	cfg.Callback = Info.Callback or Info.Changed or function() end

	-- Element-specific
	if elemName == "Slider" then
		cfg.Min     = Info.Min or 0
		cfg.Max     = Info.Max or 100
		cfg.Suffix  = Info.Suffix or ""
		cfg.Decimals= Info.Decimals or 0
		cfg.Compact = Info.Compact
	elseif elemName == "Dropdown" then
		cfg.Values    = Info.Values or {}
		cfg.Multi     = Info.Multi or false
		cfg.Searchable= Info.Searchable or false
	elseif elemName == "Input" then
		cfg.Placeholder = Info.PlaceholderText or Info.Placeholder or ""
		cfg.MaxLength   = Info.MaxLength
		cfg.NumberOnly  = Info.NumbersOnly or Info.NumberOnly
		cfg.ClearButton = Info.ClearButton
	elseif elemName == "Keybind" then
		cfg.Default      = Info.Default
		cfg.Mode         = Info.Mode or "Toggle"
		cfg.SyncToggleState = Info.SyncToggleState
	elseif elemName == "Colorpicker" then
		cfg.Default     = Info.Default or Color3.new(1, 1, 1)
		cfg.Transparency= Info.Transparency or false
	elseif elemName == "Paragraph" then
		cfg.Title   = Info.Text or Info.Title or ""
		cfg.Content = Info.Desc or Info.Content or ""
	end

	return cfg
end

-- ── Main Load function ───────────────────────────────────────────────────────
local function Load(tbl, Container, Elems, Window, VynxUI, OnElementCreateFunction, ElementsModule, UIScale, Tab)

	-- WindUI style: Section:Toggle({...})
	for name, module in next, Elems do
		tbl[name] = function(self, config)
			config = config or {}
			config.Tab         = Tab or tbl
			config.ParentType  = tbl.__type
			config.ParentTable = tbl
			config.Index       = #tbl.Elements + 1
			config.GlobalIndex = Window.AllElements and (#Window.AllElements + 1) or 1
			if config.LinkCorners == nil then
				config.LinkCorners = tbl.LinkCorners == true or (Tab and Tab.LinkCorners == true)
			end
			config.Parent     = Container
			config.Window     = Window
			config.WindUI     = VynxUI
			config.UIScale    = UIScale
			config.ElementsModule = ElementsModule

			local _frame, content = module:New(config)

			-- Flag registration
			if config.Flag and typeof(config.Flag) == "string" and Window.CurrentConfig then
				Window.CurrentConfig:Register(config.Flag, content)
			end

			-- Obsidian global registry
			RegisterInVynx(VynxUI, name, content, config.Flag)

			if content then
				content.Tab    = Tab or tbl
				content.Window = Window
				table.insert(tbl.Elements, content)
				if Window.AllElements then
					table.insert(Window.AllElements, content)
				end
			end

			if OnElementCreateFunction then
				OnElementCreateFunction(name, content)
			end

			return content
		end
	end

	-- Obsidian style: Group:AddToggle(Idx, Info)
	for alias, elemName in next, ObsidianAliases do
		local module = Elems[elemName]
		if module then
			tbl[alias] = function(self, Idx, Info)
				-- Support single-table call: AddToggle({Text="x", Default=false})
				if typeof(Idx) == "table" and Info == nil then
					Info = Idx
					Idx  = Info.Flag or Info.Id or tostring(#tbl.Elements + 1)
				end

				local config = TranslateObsidianConfig(elemName, Idx, Info or {})
				config.Tab         = Tab or tbl
				config.ParentType  = tbl.__type
				config.ParentTable = tbl
				config.Index       = #tbl.Elements + 1
				config.GlobalIndex = Window.AllElements and (#Window.AllElements + 1) or 1
				config.Parent      = Container
				config.Window      = Window
				config.WindUI      = VynxUI
				config.UIScale     = UIScale
				config.ElementsModule = ElementsModule

				local _frame, content = module:New(config)

				-- Global registry (Obsidian pattern)
				if typeof(Idx) == "string" and Idx ~= "" then
					RegisterInVynx(VynxUI, elemName, content, Idx)
				end

				if content then
					content.Tab    = Tab or tbl
					content.Window = Window
					table.insert(tbl.Elements, content)
					if Window.AllElements then
						table.insert(Window.AllElements, content)
					end
				end

				return content
			end
		end
	end

	-- DependencyBox (Obsidian exclusive)
	DependencyBoxModule.AttachToSection(tbl, VynxUI)
end

return {
	Elements = Elements,
	Load     = Load,
}

end)()

-- ── Library.lua ──
_VYNX_MODULES["Library.lua"] = (function()
-- ██╗   ██╗██╗   ██╗███╗   ██╗██╗  ██╗    ██╗   ██╗██╗
-- ██║   ██║╚██╗ ██╔╝████╗  ██║╚██╗██╔╝    ██║   ██║██║
-- ██║   ██║ ╚████╔╝ ██╔██╗ ██║ ╚███╔╝     ██║   ██║██║
-- ╚██╗ ██╔╝  ╚██╔╝  ██║╚██╗██║ ██╔██╗     ██║   ██║██║
--  ╚████╔╝    ██║   ██║ ╚████║██╔╝ ██╗    ╚██████╔╝██║
--   ╚═══╝     ╚═╝   ╚═╝  ╚═══╝╚═╝  ╚═╝     ╚═════╝ ╚═╝
-- VYNX UI Library v1.0.0
-- Merged from WindUI (MIT) + Obsidian (MIT)
-- Dual API: supports both WindUI and Obsidian call styles

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local CoreGui         = cloneref(game:GetService("CoreGui"))
local Players         = cloneref(game:GetService("Players"))
local RunService      = cloneref(game:GetService("RunService"))
local UserInputService= cloneref(game:GetService("UserInputService"))
local HttpService     = cloneref(game:GetService("HttpService"))
local TweenService    = cloneref(game:GetService("TweenService"))
local TextService     = cloneref(game:GetService("TextService"))

local getgenv     = getgenv or function() return shared end
local protectgui  = protectgui or (syn and syn.protect_gui) or function() end
local gethui      = gethui or function() return CoreGui end
local setclipboard= setclipboard or nil

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local BASE_URL = "https://raw.githubusercontent.com/your-github/VynxUI/refs/heads/main/"

local VynxUI = {
	Version = "1.0.0",

	-- ── Core ──
	Window            = nil,
	ScreenGui         = nil,
	NotificationGui   = nil,
	DropdownGui       = nil,

	-- ── Modules ──
	Creator           = nil,
	Motion            = nil,
	Themes            = nil,
	Theme             = nil,

	-- ── Obsidian-style global registries ──
	Toggles           = {},
	Options           = {},
	Labels            = {},
	Buttons           = {},

	-- ── Dependency system ──
	DependencyBoxes   = {},

	-- ── Notifications ──
	Notifications     = {},
	NotifySide        = "Right",

	-- ── State ──
	Toggled           = false,
	Unloaded          = false,
	Searching         = false,
	SearchText        = "",
	GlobalSearch      = false,

	-- ── Settings ──
	ToggleKeybind     = Enum.KeyCode.RightControl,
	DPIScale          = 1,
	CornerRadius      = 8,
	ShowCustomCursor  = false,
	ForceCheckbox     = false,
	UIScale           = 1,
	Transparent       = false,
	TransparencyValue = 0.15,

	-- ── Callbacks ──
	OnThemeChangeFunction = nil,
	UnloadCallbacks       = {},
	Signals               = {},

	-- ── DraggableElements ──
	DraggableElements = {},

	-- ── Internal ──
	ActiveLoading     = nil,
	cloneref          = cloneref,
	LocalPlayer       = LocalPlayer,

	-- ── Obsidian Scheme (live, mutated by SetTheme) ──
	Scheme = {
		BackgroundColor  = Color3.fromHex("#0D0D12"),
		MainColor        = Color3.fromHex("#16161F"),
		AccentColor      = Color3.fromHex("#7C5CFF"),
		OutlineColor     = Color3.fromHex("#2a2a3a"),
		FontColor        = Color3.new(1, 1, 1),
		Font             = Font.fromEnum(Enum.Font.GothamSsm),
		RedColor         = Color3.fromRGB(255, 50, 50),
		DestructiveColor = Color3.fromRGB(220, 38, 38),
		DarkColor        = Color3.new(0, 0, 0),
		WhiteColor       = Color3.new(1, 1, 1),
		BackgroundImage  = "",
	},

	-- ── Obsidian animation config ──
	TweenInfo               = TweenInfo.new(0.1,  Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	TabTransitionInfo       = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	WindowAnimationInfo     = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	DropdownTransitionInfo  = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	GroupboxTweenInfo       = TweenInfo.new(0.2,  Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Animations = {
		ToggleWindow = true,
		TabSwitch    = true,
		Groupbox     = true,
		Dropdown     = true,
		KeyPicker    = true,
	},
}

-- ── Custom image asset manager (Obsidian port) ──────────────────────────────
local VYNX_ASSETS = {
	TransparencyTexture = {
		RobloxId = 139785960036434,
		Path     = "VynxUI/assets/TransparencyTexture.png",
		URL      = BASE_URL .. "assets/TransparencyTexture.png",
		Id       = nil,
	},
	SaturationMap = {
		RobloxId = 4155801252,
		Path     = "VynxUI/assets/SaturationMap.png",
		URL      = BASE_URL .. "assets/SaturationMap.png",
		Id       = nil,
	},
	LoadingIcon = {
		RobloxId = 97544096941083,
		Path     = "VynxUI/assets/LoadingIcon.png",
		URL      = BASE_URL .. "assets/LoadingIcon.png",
		Id       = nil,
	},
	CheckIcon = {
		RobloxId = 97682394690683,
		Path     = "VynxUI/assets/CheckIcon.png",
		URL      = BASE_URL .. "assets/CheckIcon.png",
		Id       = nil,
	},
}

local ImageManager = {}

function ImageManager.GetAsset(Name)
	local asset = VYNX_ASSETS[Name]
	if not asset then return nil end
	if asset.Id then return asset.Id end

	local id = string.format("rbxassetid://%s", asset.RobloxId)
	if getcustomasset then
		local ok, newId = pcall(getcustomasset, asset.Path)
		if ok and newId then id = newId end
	end

	asset.Id = id
	return id
end

function ImageManager.DownloadAsset(Name, Force)
	local asset = VYNX_ASSETS[Name]
	if not asset then return end
	if not getcustomasset or not writefile or not isfile then return end
	if not Force and isfile(asset.Path) then return end
	pcall(function()
		writefile(asset.Path, game:HttpGet(asset.URL))
	end)
end

function ImageManager.AddAsset(Name, RobloxId, URL, Force)
	if VYNX_ASSETS[Name] then
		error(string.format("Asset %q already exists", Name))
	end
	VYNX_ASSETS[Name] = {
		RobloxId = RobloxId,
		Path     = string.format("VynxUI/custom_assets/%s", Name),
		URL      = URL,
		Id       = nil,
	}
	ImageManager.DownloadAsset(Name, Force)
end

do
	if not RunService:IsStudio() then
		for Name in VYNX_ASSETS do
			ImageManager.DownloadAsset(Name)
		end
	end
end

VynxUI.ImageManager = ImageManager

-- ── Load core modules ───────────────────────────────────────────────────────
local Creator  = require("./modules/Creator")
local Motion   = require("./modules/Motion")
local Themes   = require("./themes/Init")(VynxUI, Creator)

Creator.Init(VynxUI)

VynxUI.Creator = Creator
VynxUI.Motion  = Motion
VynxUI.Themes  = Themes

-- ── ScreenGui setup ─────────────────────────────────────────────────────────
local GUIParent = gethui and gethui() or CoreGui
local New = Creator.New

local UIScaleObj = New("UIScale", { Scale = VynxUI.UIScale })
VynxUI.UIScaleObj = UIScaleObj

VynxUI.ScreenGui = New("ScreenGui", {
	Name             = "VynxUI",
	Parent           = GUIParent,
	IgnoreGuiInset   = true,
	ScreenInsets     = "None",
	DisplayOrder     = -99999,
	ResetOnSpawn     = false,
	ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
}, {
	New("Folder", { Name = "Window" }),
	New("Folder", { Name = "KeySystem" }),
	New("Folder", { Name = "Popups" }),
	New("Folder", { Name = "ToolTips" }),
})

VynxUI.NotificationGui = New("ScreenGui", {
	Name           = "VynxUI/Notifications",
	Parent         = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets   = "None",
	ResetOnSpawn   = false,
	DisplayOrder   = 999999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

VynxUI.DropdownGui = New("ScreenGui", {
	Name           = "VynxUI/Dropdowns",
	Parent         = GUIParent,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

protectgui(VynxUI.ScreenGui)
protectgui(VynxUI.NotificationGui)
protectgui(VynxUI.DropdownGui)

-- ── Notification module ──────────────────────────────────────────────────────
local NotificationModule = require("./components/Notification")
local NotifHolder = NotificationModule.Init(VynxUI.NotificationGui)

-- ── Input tracking (WindUI pattern) ─────────────────────────────────────────
local CurInputId = HttpService:GenerateGUID(false)

UserInputService.InputBegan:Connect(function(Input)
	task.defer(function()
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			VynxUI.CurrentInput = CurInputId
		end
	end)
end)
UserInputService.InputEnded:Connect(function(Input)
	if
		Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch
	then
		VynxUI.CurrentInput = nil
	end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- COLOR UTILITIES (Obsidian port)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:GetBetterColor(Color, Add)
	Add = Add or 0
	local H, S, V = Color:ToHSV()
	V = math.clamp(V + Add * 0.05, 0, 1)
	return Color3.fromHSV(H, S, V)
end

function VynxUI:GetLighterColor(Color)
	local H, S, V = Color:ToHSV()
	return Color3.fromHSV(H, S, math.min(V + 0.1, 1))
end

function VynxUI:GetDarkerColor(Color)
	local H, S, V = Color:ToHSV()
	return Color3.fromHSV(H, S, math.max(V - 0.1, 0))
end

function VynxUI:GetKeyString(KeyCode)
	if typeof(KeyCode) ~= "EnumItem" then return tostring(KeyCode) end
	local name = KeyCode.Name
	local short = {
		LeftControl = "LCtrl", RightControl = "RCtrl",
		LeftShift = "LShift", RightShift = "RShift",
		LeftAlt = "LAlt", RightAlt = "RAlt",
		Return = "Enter", BackSpace = "Back",
	}
	return short[name] or name
end

function VynxUI:GetTextBounds(Text, Font, Size, Width)
	local params = Instance.new("GetTextBoundsParams")
	params.Text = Text
	params.Font = typeof(Font) == "EnumItem" and Font.fromEnum(Font) or Font
	params.Size = Size
	params.Width = Width or math.huge
	local bounds = TextService:GetTextBoundsAsync(params)
	return bounds.X, bounds.Y
end

function VynxUI:MouseIsOverFrame(Frame, MousePos)
	if not Frame or not Frame.Visible then return false end
	local pos  = Frame.AbsolutePosition
	local size = Frame.AbsoluteSize
	return MousePos.X >= pos.X and MousePos.X <= pos.X + size.X
		and MousePos.Y >= pos.Y and MousePos.Y <= pos.Y + size.Y
end

-- ─────────────────────────────────────────────────────────────────────────────
-- THEME SYSTEM (merged)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:SetTheme(Value)
	local theme = VynxUI.Themes[Value]
	if not theme then return nil end

	VynxUI.Theme = theme
	Creator.SetTheme(theme)

	-- Sync Obsidian Scheme fields
	if theme.BackgroundColor then VynxUI.Scheme.BackgroundColor = theme.BackgroundColor end
	if theme.MainColor       then VynxUI.Scheme.MainColor       = theme.MainColor       end
	if theme.AccentColor     then VynxUI.Scheme.AccentColor     = theme.AccentColor     end
	if theme.OutlineColor    then VynxUI.Scheme.OutlineColor    = theme.OutlineColor    end
	if theme.FontColor       then VynxUI.Scheme.FontColor       = theme.FontColor       end
	if theme.RedColor        then VynxUI.Scheme.RedColor        = theme.RedColor        end
	if theme.DestructiveColor then VynxUI.Scheme.DestructiveColor = theme.DestructiveColor end

	if VynxUI.OnThemeChangeFunction then
		VynxUI.OnThemeChangeFunction(Value, theme)
	end

	return theme
end

function VynxUI:AddTheme(ThemeTable)
	VynxUI.Themes[ThemeTable.Name] = ThemeTable
	return ThemeTable
end

function VynxUI:GetThemes()        return VynxUI.Themes end
function VynxUI:GetCurrentTheme() return VynxUI.Theme and VynxUI.Theme.Name or "Dark" end
function VynxUI:OnThemeChange(fn) VynxUI.OnThemeChangeFunction = fn end

-- ─────────────────────────────────────────────────────────────────────────────
-- MOTION / ANIMATION
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:SetMotionPreset(Preset)
	Motion:SetPreset(Preset)
	local baseTime = Motion.Durations
	-- Sync Obsidian TweenInfo fields
	VynxUI.TweenInfo               = TweenInfo.new(Motion.GetDuration("Hover"),       Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	VynxUI.TabTransitionInfo       = TweenInfo.new(Motion.GetDuration("Select"),      Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	VynxUI.WindowAnimationInfo     = TweenInfo.new(Motion.GetDuration("WindowOpen"),  Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	VynxUI.DropdownTransitionInfo  = TweenInfo.new(Motion.GetDuration("DropdownOpen"),Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	VynxUI.KeyPickerTransitionInfo = TweenInfo.new(Motion.GetDuration("Focus"),       Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	VynxUI.GroupboxTweenInfo       = TweenInfo.new(Motion.GetDuration("Expand"),      Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	return Motion:GetConfig()
end

function VynxUI:SetReducedMotion(Value) return Motion:SetReducedMotion(Value) end

-- ─────────────────────────────────────────────────────────────────────────────
-- FONT
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:SetFont(FontId)
	Creator.UpdateFont(FontId)
	if typeof(FontId) == "string" then
		VynxUI.Scheme.Font = Font.new(FontId)
	elseif typeof(FontId) == "EnumItem" then
		VynxUI.Scheme.Font = Font.fromEnum(FontId)
	else
		VynxUI.Scheme.Font = FontId
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- DPI SCALE (Obsidian)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:SetDPIScale(Scale)
	VynxUI.DPIScale = math.max(0.5, math.min(Scale, 3))
	if VynxUI.UIScaleObj then
		VynxUI.UIScaleObj.Scale = VynxUI.DPIScale
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- ICON SYSTEM (merged WindUI + Obsidian)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:RegisterIconSource(Source, Provider, Options)
	return Creator.RegisterIconSource(Source, Provider, Options)
end
VynxUI.AddIconSource = VynxUI.RegisterIconSource

function VynxUI:RegisterIconPack(Source, Icons)
	return Creator.RegisterIconPack(Source, Icons)
end
VynxUI.AddIcons = VynxUI.RegisterIconPack

function VynxUI:AddIcon(Source, Name, Value)
	return Creator.AddIcon(Source, Name, Value)
end

function VynxUI:SetIconSource(Source)
	return Creator.SetIconSource(Source)
end

function VynxUI:GetIcon(Name)
	return Creator.GetIcon and Creator.GetIcon(Name) or nil
end

function VynxUI:GetCustomIcon(Name)
	return Creator.GetCustomIcon and Creator.GetCustomIcon(Name) or nil
end

local _IconModule = nil
function VynxUI:SetIconModule(module)
	_IconModule = module
end

function VynxUI:HasIcon(Icon, Source)
	return Creator.HasIcon(Icon, Source)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- PARENT / GUI PARENT
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:SetParent(parent)
	if VynxUI.ScreenGui      then VynxUI.ScreenGui.Parent      = parent end
	if VynxUI.NotificationGui then VynxUI.NotificationGui.Parent = parent end
	if VynxUI.DropdownGui    then VynxUI.DropdownGui.Parent    = parent end
end

function VynxUI:SetBackgroundImage(Image)
	VynxUI.Scheme.BackgroundImage = tostring(Image or "")
	if VynxUI.Window and VynxUI.Window.UIElements then
		local bg = VynxUI.Window.UIElements.BackgroundImage
		if bg then
			bg.Image = VynxUI.Scheme.BackgroundImage
			bg.Visible = VynxUI.Scheme.BackgroundImage ~= ""
		end
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- NOTIFICATION (merged WindUI + Obsidian)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:SetNotifySide(Side)
	VynxUI.NotifySide = (Side == "Left" or Side == "Right") and Side or "Right"
end
function VynxUI:SetNotificationLower(Val)
	if NotifHolder.SetLower then NotifHolder.SetLower(Val) end
end

function VynxUI:Notify(Config)
	if typeof(Config) == "string" then
		Config = { Title = Config, Content = "", Duration = 4 }
	end
	Config.Holder  = NotifHolder.Frame
	Config.Window  = VynxUI.Window
	Config.Side    = Config.Side or VynxUI.NotifySide
	return NotificationModule.New(Config)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- LOADING SCREEN
-- ─────────────────────────────────────────────────────────────────────────────

local LoadingScreen = require("./components/LoadingScreen")

function VynxUI:CreateLoading(Config)
	if VynxUI.ActiveLoading and not VynxUI.ActiveLoading.Closed then
		VynxUI.ActiveLoading:Close(0)
	end
	VynxUI.ActiveLoading = LoadingScreen.new(VynxUI, Config or {})
	return VynxUI.ActiveLoading
end
VynxUI.LoadingCreate = VynxUI.CreateLoading

function VynxUI:LoadingScreen(Config)
	return LoadingScreen.new(VynxUI, Config or {})
end

function VynxUI:LoadingSet(Value, Status)
	local Loader = VynxUI.ActiveLoading
	if not Loader or Loader.Closed then
		Loader = VynxUI:CreateLoading({})
	end
	if typeof(Value) == "table" then
		if Value.Status or Value.Text or Value.Title then Loader:SetStatus(Value.Status or Value.Text or Value.Title) end
		if Value.Progress ~= nil or Value.Value ~= nil then Loader:SetProgress(Value.Progress ~= nil and Value.Progress or Value.Value) end
		if Value.Step   then Loader:Step(Value.Step, Value.Status or Value.Text) end
		if Value.Close  then Loader:Close(Value.Delay or Value.CloseDelay or 0) end
		return Loader
	end
	if typeof(Value) == "number" then
		Loader:SetProgress(Value)
		if Status then Loader:SetStatus(Status) end
	elseif Value ~= nil then
		Loader:SetStatus(Value)
		if typeof(Status) == "number" then Loader:SetProgress(Status) end
	end
	return Loader
end

-- ─────────────────────────────────────────────────────────────────────────────
-- POPUP / DIALOG
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:Popup(Config)
	Config.WindUI = VynxUI
	return require("./components/popup/Init").new(Config, VynxUI.ScreenGui.Popups)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- LOCALIZATION (WindUI)
-- ─────────────────────────────────────────────────────────────────────────────

local LocalizationModule = require("./modules/Localization")

function VynxUI:Localization(Config)
	return LocalizationModule:New(Config, Creator)
end
function VynxUI:SetLanguage(Value)
	if Creator.SetLanguage then return Creator.SetLanguage(Value) end
	return false
end

-- ─────────────────────────────────────────────────────────────────────────────
-- ACRYLIC (WindUI)
-- ─────────────────────────────────────────────────────────────────────────────

local Acrylic = require("./utils/Acrylic/Init")
Acrylic.init()

function VynxUI:ToggleAcrylic(Value)
	if VynxUI.Window and VynxUI.Window.AcrylicPaint and VynxUI.Window.AcrylicPaint.Model then
		VynxUI.Window.Acrylic = Value
		VynxUI.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value then Acrylic.Enable() else Acrylic.Disable() end
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- GRADIENT HELPER (WindUI)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:Gradient(stops, props)
	local cs, ts = {}, {}
	for posStr, stop in next, stops do
		local pos = tonumber(posStr)
		if pos then
			pos = math.clamp(pos / 100, 0, 1)
			local color = stop.Color
			if typeof(color) == "string" and string.sub(color, 1, 1) == "#" then
				color = Color3.fromHex(color)
			end
			table.insert(cs, ColorSequenceKeypoint.new(pos, color))
			table.insert(ts, NumberSequenceKeypoint.new(pos, stop.Transparency or 0))
		end
	end
	table.sort(cs, function(a, b) return a.Time < b.Time end)
	table.sort(ts, function(a, b) return a.Time < b.Time end)
	if #cs < 2 then
		table.insert(cs, ColorSequenceKeypoint.new(1, cs[1].Value))
		table.insert(ts, NumberSequenceKeypoint.new(1, ts[1].Value))
	end
	local result = { Color = ColorSequence.new(cs), Transparency = NumberSequence.new(ts) }
	if props then for k, v in pairs(props) do result[k] = v end end
	return result
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SIGNAL / UNLOAD SYSTEM (Obsidian)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:GiveSignal(Connection)
	table.insert(VynxUI.Signals, Connection)
	return Connection
end

function VynxUI:OnUnload(Callback)
	table.insert(VynxUI.UnloadCallbacks, Callback)
end

function VynxUI:Unload()
	VynxUI.Unloaded = true
	VynxUI.Toggled  = false

	for _, cb in VynxUI.UnloadCallbacks do
		pcall(cb)
	end
	for _, sig in VynxUI.Signals do
		if sig and sig.Disconnect then sig:Disconnect()
		elseif sig and sig.Connected then sig:Disconnect() end
	end
	VynxUI.Signals = {}

	if VynxUI.ScreenGui      then VynxUI.ScreenGui:Destroy() end
	if VynxUI.NotificationGui then VynxUI.NotificationGui:Destroy() end
	if VynxUI.DropdownGui    then VynxUI.DropdownGui:Destroy() end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- TOOLTIP (Obsidian port)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:AddTooltip(InfoStr, DisabledInfoStr, HoverInstance)
	if not InfoStr and not DisabledInfoStr then return {} end

	local TooltipGui = VynxUI.ScreenGui.ToolTips
	local tooltip    = nil

	local function showTip(text)
		if not text or text == "" then return end
		local lbl = New("TextLabel", {
			BackgroundColor3 = Color3.fromHex("#1E1E2C"),
			AutomaticSize    = Enum.AutomaticSize.XY,
			Text             = text,
			TextColor3       = Color3.new(1, 1, 1),
			TextSize         = 12,
			FontFace         = Font.fromEnum(Enum.Font.GothamSsm),
			ZIndex           = 9999,
			Parent           = TooltipGui,
		}, {
			New("UICorner",  { CornerRadius = UDim.new(0, 6) }),
			New("UIPadding", {
				PaddingTop    = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft   = UDim.new(0, 8),
				PaddingRight  = UDim.new(0, 8),
			}),
			New("UIStroke", { Color = Color3.fromHex("#2a2a3a"), Thickness = 1 }),
		})
		tooltip = lbl
		local conn
		conn = UserInputService.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				lbl.Position = UDim2.fromOffset(Input.Position.X + 14, Input.Position.Y + 14)
			end
		end)
		return conn
	end

	local tipConn
	if HoverInstance then
		HoverInstance.MouseEnter:Connect(function()
			local text = InfoStr or ""
			if tipConn then tipConn:Disconnect() end
			tipConn = showTip(text)
		end)
		HoverInstance.MouseLeave:Connect(function()
			if tooltip then tooltip:Destroy(); tooltip = nil end
			if tipConn then tipConn:Disconnect(); tipConn = nil end
		end)
	end

	return { Destroy = function()
		if tooltip then tooltip:Destroy() end
		if tipConn then tipConn:Disconnect() end
	end }
end

-- ─────────────────────────────────────────────────────────────────────────────
-- DRAGGABLE OVERLAYS (Obsidian port)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:MakeDraggable(UI, DragFrame, IgnoreToggle, IsMainWindow)
	local Dragging, DragStart, StartPos = false, nil, nil
	local function Update(Input)
		local delta = Input.Position - DragStart
		UI.Position = UDim2.new(
			StartPos.X.Scale, StartPos.X.Offset + delta.X,
			StartPos.Y.Scale, StartPos.Y.Offset + delta.Y
		)
	end
	DragFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1
			and Input.UserInputType ~= Enum.UserInputType.Touch then return end
		Dragging  = true
		DragStart = Input.Position
		StartPos  = UI.Position
		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false
			end
		end)
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		) then Update(Input) end
	end)
end

function VynxUI:AddDraggableLabel(Text, Position, Font, TextSize)
	local gui = VynxUI.ScreenGui
	local holder = New("TextLabel", {
		BackgroundColor3     = Color3.fromHex("#16161F"),
		AutomaticSize        = Enum.AutomaticSize.XY,
		Position             = Position or UDim2.fromOffset(10, 10),
		Text                 = Text or "",
		TextColor3           = Color3.new(1, 1, 1),
		TextSize             = TextSize or 13,
		FontFace             = Font or Font.fromEnum(Enum.Font.GothamSsm),
		ZIndex               = 9999,
		Active               = true,
		Parent               = gui,
	}, {
		New("UICorner",  { CornerRadius = UDim.new(0, 6) }),
		New("UIPadding", { PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8) }),
		New("UIStroke",  { Color = Color3.fromHex("#2a2a3a"), Thickness = 1 }),
	})

	VynxUI:MakeDraggable(holder, holder, true)
	table.insert(VynxUI.DraggableElements, holder)

	local Label = { Frame = holder }
	function Label:SetText(t) holder.Text = t end
	function Label:SetVisible(v) holder.Visible = v end
	function Label:Destroy() holder:Destroy() end
	return Label
end

function VynxUI:AddDraggableButton(Text, Callback, VisibleByDefault, IsToggle)
	local gui = VynxUI.ScreenGui
	local pressed = false

	local holder = New("TextButton", {
		BackgroundColor3 = Color3.fromHex("#2A2A38"),
		AutomaticSize    = Enum.AutomaticSize.XY,
		Position         = UDim2.fromOffset(10, 40),
		Text             = Text or "",
		TextColor3       = Color3.new(1, 1, 1),
		TextSize         = 13,
		FontFace         = Font.fromEnum(Enum.Font.GothamSsm),
		ZIndex           = 9999,
		Active           = true,
		Visible          = VisibleByDefault ~= false,
		Parent           = gui,
	}, {
		New("UICorner",  { CornerRadius = UDim.new(0, 6) }),
		New("UIPadding", { PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10) }),
		New("UIStroke",  { Color = Color3.fromHex("#2a2a3a"), Thickness = 1 }),
	})

	holder.MouseButton1Click:Connect(function()
		if IsToggle then pressed = not pressed end
		if Callback then Callback(IsToggle and { Value = pressed } or holder) end
	end)

	VynxUI:MakeDraggable(holder, holder, true)
	table.insert(VynxUI.DraggableElements, holder)

	local Btn = { Button = holder, Value = false }
	function Btn:SetText(t)    holder.Text    = t end
	function Btn:SetVisible(v) holder.Visible = v end
	function Btn:Destroy()     holder:Destroy() end
	return Btn
end

function VynxUI:AddDraggableMenu(Name)
	local gui   = VynxUI.ScreenGui
	local Frame = New("Frame", {
		BackgroundColor3 = Color3.fromHex("#16161F"),
		Size             = UDim2.fromOffset(160, 24),
		AutomaticSize    = Enum.AutomaticSize.Y,
		Position         = UDim2.fromOffset(6, 200),
		ZIndex           = 9998,
		Visible          = false,
		Active           = true,
		Parent           = gui,
	}, {
		New("UICorner",  { CornerRadius = UDim.new(0, 8) }),
		New("UIStroke",  { Color = Color3.fromHex("#2a2a3a"), Thickness = 1 }),
		New("UIPadding", { PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8) }),
	})

	local TitleLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		Text       = Name or "Menu",
		TextColor3 = Color3.fromHex("#a1a1aa"),
		TextSize   = 12,
		FontFace   = Font.fromEnum(Enum.Font.GothamSsm),
		Size       = UDim2.new(1, 0, 0, 18),
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder= 0,
		Parent     = Frame,
	})

	local Container = New("Frame", {
		BackgroundTransparency = 1,
		Size       = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder= 1,
		Parent     = Frame,
	}, {
		New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
	})

	VynxUI:MakeDraggable(Frame, TitleLabel, true)
	table.insert(VynxUI.DraggableElements, Frame)

	local Menu = { Frame = Frame, Container = Container }
	function Menu:SetVisible(v) Frame.Visible = v end
	function Menu:AddItem(text, callback)
		local btn = New("TextButton", {
			BackgroundColor3 = Color3.fromHex("#1E1E2C"),
			Size             = UDim2.new(1, 0, 0, 24),
			Text             = text,
			TextColor3       = Color3.new(1, 1, 1),
			TextSize         = 12,
			FontFace         = Font.fromEnum(Enum.Font.GothamSsm),
			TextXAlignment   = Enum.TextXAlignment.Left,
			Parent           = Container,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 4) }),
			New("UIPadding", { PaddingLeft = UDim.new(0, 6) }),
		})
		btn.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)
		return btn
	end
	function Menu:Destroy() Frame:Destroy() end
	return Menu
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SEARCH SYSTEM
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:UpdateSearch(SearchText)
	VynxUI.SearchText = SearchText or ""
	VynxUI.Searching  = VynxUI.SearchText ~= ""
end

-- ─────────────────────────────────────────────────────────────────────────────
-- TOGGLE (UI visibility)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:Toggle(Value)
	if VynxUI.Window and VynxUI.Window.Toggle then
		return VynxUI.Window:Toggle(Value)
	end
	VynxUI.Toggled = Value ~= nil and Value or not VynxUI.Toggled
	if VynxUI.ScreenGui then
		VynxUI.ScreenGui.Enabled = VynxUI.Toggled
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- CREATE WINDOW
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:CreateWindow(Config)
	local CreateWindowModule = require("./window/Init")

	if not RunService:IsStudio() then
		if writefile then
			local folderName = Config.Folder or Config.Title or "VynxUI"
			pcall(function()
				if not isfolder("VynxUI") then makefolder("VynxUI") end
				if not isfolder(folderName) then makefolder(folderName) end
			end)
		end
	end

	Config.VynxUI = VynxUI
	Config.WindUI = VynxUI
	Config.Window = VynxUI.Window
	Config.Parent = VynxUI.ScreenGui.Window

	local Window = CreateWindowModule(Config)
	VynxUI.Window = Window

	-- Toggle keybind listener
	VynxUI:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
		if VynxUI.Unloaded then return end
		if UserInputService:GetFocusedTextBox() then return end
		local key = Config.ToggleKey or Config.ToggleKeybind or VynxUI.ToggleKeybind
		if Input.KeyCode == key then
			VynxUI:Toggle()
		end
	end))

	return Window
end

-- ─────────────────────────────────────────────────────────────────────────────
-- VALIDATE (Obsidian helper)
-- ─────────────────────────────────────────────────────────────────────────────

function VynxUI:Validate(Table, Template)
	if typeof(Table) ~= "table" then Table = {} end
	for Key, Default in Template do
		if Table[Key] == nil then
			if typeof(Default) == "function" then
				Table[Key] = Default()
			else
				Table[Key] = Default
			end
		end
	end
	return Table
end

function VynxUI:SafeCallback(Func, ...)
	if typeof(Func) ~= "function" then return end
	local ok, err = pcall(Func, ...)
	if not ok then
		VynxUI:Notify({ Title = "VynxUI Error", Content = tostring(err), Style = "Error", Duration = 6 })
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- APPLY INITIAL THEME
-- ─────────────────────────────────────────────────────────────────────────────

VynxUI:SetTheme("Dark")
VynxUI:SetLanguage(Creator.Language or "en")
VynxUI:SetMotionPreset("Subtle")

-- ─────────────────────────────────────────────────────────────────────────────
-- EXPOSE
-- ─────────────────────────────────────────────────────────────────────────────

return VynxUI

end)()

return _VYNX_MODULES["Library.lua"]