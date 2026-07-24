local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))

local ICONS_URL = "https://article-hub-studio.github.io/WindUI-Skibidi/vendor/icons/Main-v2.lua"

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
