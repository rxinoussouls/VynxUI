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
