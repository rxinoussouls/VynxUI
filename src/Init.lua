local VynxUI = {
	Window = nil,
	Theme = nil,
	Creator = require("./modules/Creator"),
	Motion = require("./modules/Motion"),
	LocalizationModule = require("./modules/Localization"),
	NotificationModule = require("./components/Notification"),
	Themes = nil,
	Transparent = false,

	TransparencyValue = 0.15,

	UIScale = 1,

	ConfigManager = nil,
	Version = "0.0.0",

	Services = require("./utils/services/Init"),

	OnThemeChangeFunction = nil,

	cloneref = nil,
	UIScaleObj = nil,

	CreateWindow = nil,

	CurrentInput = nil,
}

VynxUI.IconAdapterVersion = VynxUI.Creator.IconAdapterVersion

local Creator = VynxUI.Creator

local cloneref = require("./utils/cloneref")

VynxUI.cloneref = cloneref

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

function VynxUI.GenerateGUID()
	return HttpService:GenerateGUID(false)
end

local CurInput = VynxUI.GenerateGUID()

Creator.AddSignal(UserInputService.InputBegan, function(Input, GameProcessed)
	--[[if GameProcessed then
		return
	end]]

	task.defer(function()
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			if VynxUI.CurrentInput and VynxUI.CurrentInput ~= CurInput then
				return
			end

			VynxUI.CurrentInput = CurInput
			--print(CurInput)
			--VynxUI.InputStartedOnUI = false
		end
	end)
end)
Creator.AddSignal(UserInputService.InputEnded, function(Input, GameProcessed)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		if VynxUI.CurrentInput and VynxUI.CurrentInput ~= CurInput then
			return
		end

		VynxUI.CurrentInput = nil
	end
end)

local LocalPlayer = Players.LocalPlayer or nil

local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
	VynxUI.Version = Package.version
end

local KeySystem = require("./components/KeySystem")
local LoadingScreen = require("./components/LoadingScreen")

local New = Creator.New

--local Tween = Creator.Tween
--local ServicesModule = VynxUI.Services

local Acrylic = require("./utils/Acrylic/Init")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))

local UIScaleObj = New("UIScale", {
	Scale = VynxUI.UIScale,
})

VynxUI.UIScaleObj = UIScaleObj

VynxUI.ScreenGui = New("ScreenGui", {
	Name = "VynxUI",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	DisplayOrder = -99999,
}, {

	New("Folder", {
		Name = "Window",
	}),
	-- New("Folder", {
	--     Name = "Notifications"
	-- }),
	-- New("Folder", {
	--     Name = "Dropdowns"
	-- }),
	New("Folder", {
		Name = "KeySystem",
	}),
	New("Folder", {
		Name = "Popups",
	}),
	New("Folder", {
		Name = "ToolTips",
	}),
})

VynxUI.NotificationGui = New("ScreenGui", {
	Name = "VynxUI/Notifications",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	ResetOnSpawn = false,
	DisplayOrder = 999999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
VynxUI.DropdownGui = New("ScreenGui", {
	Name = "VynxUI/Dropdowns",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
VynxUI.TooltipGui = New("ScreenGui", {
	Name = "VynxUI/Tooltips",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
ProtectGui(VynxUI.ScreenGui)
ProtectGui(VynxUI.NotificationGui)
ProtectGui(VynxUI.DropdownGui)
ProtectGui(VynxUI.TooltipGui)

Creator.Init(VynxUI)

function VynxUI:SetParent(parent)
	if VynxUI.ScreenGui then
		VynxUI.ScreenGui.Parent = parent
	end
	if VynxUI.NotificationGui then
		VynxUI.NotificationGui.Parent = parent
	end
	if VynxUI.DropdownGui then
		VynxUI.DropdownGui.Parent = parent
	end
	if VynxUI.TooltipGui then
		VynxUI.TooltipGui.Parent = parent
	end
end
math.clamp(VynxUI.TransparencyValue, 0, 1)

local Holder = VynxUI.NotificationModule.Init(VynxUI.NotificationGui)

function VynxUI:Notify(Config)
	Config.Holder = Holder.Frame
	Config.Window = VynxUI.Window
	--Config.VynxUI = VynxUI
	return VynxUI.NotificationModule.New(Config)
end

function VynxUI:SetNotificationLower(Val)
	Holder.SetLower(Val)
end

function VynxUI:RegisterIconSource(Source, Provider, Options)
	return Creator.RegisterIconSource(Source, Provider, Options)
end

function VynxUI:RegisterIconPack(Source, Icons)
	return Creator.RegisterIconPack(Source, Icons)
end

VynxUI.AddIconSource = VynxUI.RegisterIconSource
VynxUI.AddIcons = VynxUI.RegisterIconPack

function VynxUI:AddIcon(Source, Name, Value)
	return Creator.AddIcon(Source, Name, Value)
end

function VynxUI:AddIconSourceAlias(Alias, Source)
	return Creator.AddIconSourceAlias(Alias, Source)
end

function VynxUI:SetIconSource(Source)
	return Creator.SetIconSource(Source)
end

function VynxUI:GetIconSources()
	return Creator.GetIconSources()
end

function VynxUI:HasIcon(Icon, Source)
	return Creator.HasIcon(Icon, Source)
end

function VynxUI:LoadingScreen(Config)
	return LoadingScreen.new(VynxUI, Config)
end

function VynxUI:LoadingCreate(Config)
	if VynxUI.ActiveLoading and not VynxUI.ActiveLoading.Closed then
		VynxUI.ActiveLoading:Close(0)
	end

	VynxUI.ActiveLoading = LoadingScreen.new(VynxUI, Config)
	return VynxUI.ActiveLoading
end

function VynxUI:LoadingSet(Value, Status)
	local Loader = VynxUI.ActiveLoading
	if not Loader or Loader.Closed then
		Loader = VynxUI:LoadingCreate({})
	end

	if typeof(Value) == "table" then
		if Value.Status or Value.Text or Value.Title then
			Loader:SetStatus(Value.Status or Value.Text or Value.Title)
		end
		if Value.Progress ~= nil or Value.Value ~= nil then
			Loader:SetProgress(Value.Progress ~= nil and Value.Progress or Value.Value)
		end
		if Value.Step then
			Loader:Step(Value.Step, Value.Status or Value.Text)
		end
		if Value.Close then
			Loader:Close(Value.Delay or Value.CloseDelay or 0)
		end
		return Loader
	end

	if typeof(Value) == "number" then
		Loader:SetProgress(Value)
		if Status then
			Loader:SetStatus(Status)
		end
	elseif Value ~= nil then
		Loader:SetStatus(Value)
		if typeof(Status) == "number" then
			Loader:SetProgress(Status)
		end
	end

	return Loader
end

function VynxUI:SetFont(FontId)
	Creator.UpdateFont(FontId)
end

function VynxUI:SetMotionPreset(Preset)
	return VynxUI.Motion:SetPreset(Preset)
end

function VynxUI:SetReducedMotion(Value)
	return VynxUI.Motion:SetReducedMotion(Value)
end

function VynxUI:OnThemeChange(func)
	VynxUI.OnThemeChangeFunction = func
end

function VynxUI:AddTheme(LTheme)
	VynxUI.Themes[LTheme.Name] = LTheme
	return LTheme
end

function VynxUI:SetTheme(Value)
	if VynxUI.Themes[Value] then
		VynxUI.Theme = VynxUI.Themes[Value]
		Creator.SetTheme(VynxUI.Themes[Value])

		if VynxUI.OnThemeChangeFunction then
			VynxUI.OnThemeChangeFunction(Value)
		end

		return VynxUI.Themes[Value]
	end
	return nil
end

function VynxUI:GetThemes()
	return VynxUI.Themes
end
function VynxUI:GetCurrentTheme()
	return VynxUI.Theme.Name
end
function VynxUI:GetTransparency()
	return VynxUI.Transparent or false
end
function VynxUI:GetWindowSize()
	return VynxUI.Window.UIElements.Main.Size
end
function VynxUI:Localization(LocalizationConfig)
	return VynxUI.LocalizationModule:New(LocalizationConfig, Creator)
end

function VynxUI:SetLanguage(Value)
	if Creator.Localization then
		return Creator.SetLanguage(Value)
	end
	return false
end

function VynxUI:ToggleAcrylic(Value)
	if VynxUI.Window and VynxUI.Window.AcrylicPaint and VynxUI.Window.AcrylicPaint.Model then
		VynxUI.Window.Acrylic = Value
		VynxUI.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value then
			Acrylic.Enable()
		else
			Acrylic.Disable()
		end
	end
end

function VynxUI:Gradient(stops, props)
	local colorSequence = {}
	local transparencySequence = {}

	for posStr, stop in next, stops do
		local position = tonumber(posStr)
		if position then
			position = math.clamp(position / 100, 0, 1)

			local color = stop.Color
			if typeof(color) == "string" and string.sub(color, 1, 1) == "#" then
				color = Color3.fromHex(color)
			end

			local transparency = stop.Transparency or 0

			table.insert(colorSequence, ColorSequenceKeypoint.new(position, color))
			table.insert(transparencySequence, NumberSequenceKeypoint.new(position, transparency))
		end
	end

	table.sort(colorSequence, function(a, b)
		return a.Time < b.Time
	end)
	table.sort(transparencySequence, function(a, b)
		return a.Time < b.Time
	end)

	if #colorSequence < 2 then
		table.insert(colorSequence, ColorSequenceKeypoint.new(1, colorSequence[1].Value))
		table.insert(transparencySequence, NumberSequenceKeypoint.new(1, transparencySequence[1].Value))
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

function VynxUI:Popup(PopupConfig)
	PopupConfig.VynxUI = VynxUI
	return require("./components/popup/Init").new(PopupConfig, VynxUI.ScreenGui.Popups)
end

VynxUI.Themes = require("./themes/Init")(VynxUI, Creator)

Creator.Themes = VynxUI.Themes

VynxUI:SetTheme("Dark")
VynxUI:SetLanguage(Creator.Language)

function VynxUI:CreateWindow(Config)
	local CreateWindow = require("./components/window/Init")

	if not RunService:IsStudio() and writefile then
		if not isfolder("VynxUI") then
			makefolder("VynxUI")
		end
		if Config.Folder then
			makefolder(Config.Folder)
		else
			makefolder(Config.Title)
		end
	end

	Config.VynxUI = VynxUI
	Config.Window = VynxUI.Window
	Config.Parent = VynxUI.ScreenGui.Window

	if VynxUI.Window then
		warn("You cannot create more than one window")
		return
	end

	VynxUI.Motion:Configure(Config.Motion)

	local CanLoadWindow = true
	local LoaderConfig = Config.LoadingScreen or Config.Loader or Config.Loading
	local Loader

	local function OpenLoader(Status, Progress)
		if LoaderConfig == nil or LoaderConfig == false then
			return nil
		end

		if not Loader then
			local Options = {}
			if typeof(LoaderConfig) == "table" then
				for Key, Value in next, LoaderConfig do
					Options[Key] = Value
				end
			end

			Options.Title = Options.Title or Config.Title or "VynxUI"
			Options.Desc = Options.Desc or "Loading interface"
			Options.Icon = Options.Icon or Config.Icon or "sparkles"
			Options.Folder = Options.Folder or Config.Folder
			Loader = LoadingScreen.new(VynxUI, Options)
		end

		if Status then
			Loader:SetStatus(Status)
		end
		if Progress then
			Loader:SetProgress(Progress)
		end

		return Loader
	end

	if not Config.KeySystem then
		OpenLoader("Preparing interface", 0.16)
	end

	local RequestedTheme = Config.Theme or "Dark"
	local Theme
	if typeof(RequestedTheme) == "table" then
		Theme = RequestedTheme
	elseif typeof(RequestedTheme) == "string" then
		Theme = VynxUI.Themes[RequestedTheme]
	end

	Theme = Theme or VynxUI.Theme or VynxUI.Themes["Dark"]
	VynxUI.Theme = Theme
	Creator.SetTheme(Theme)

	local hwid = gethwid or function()
		return Players.LocalPlayer.UserId
	end

	local Filename = hwid()

	local function PickField(Table, Fields)
		for _, Field in next, Fields do
			if Table[Field] ~= nil then
				return Table[Field]
			end
		end
		return nil
	end

	local function NormalizeServiceType(Value)
		local Raw = string.lower(tostring(Value or ""))
		Raw = string.gsub(Raw, "%s+", "")
		Raw = string.gsub(Raw, "[_%-%./]", "")

		local Aliases = {
			luarmor = "luarmor",
			platoboost = "platoboost",
			plato = "platoboost",
			panda = "pandadevelopment",
			pandadev = "pandadevelopment",
			pandadevelopment = "pandadevelopment",
			junkie = "junkiedevelopment",
			junkiedev = "junkiedevelopment",
			junkiedevelopment = "junkiedevelopment",
		}

		return Aliases[Raw] or Raw
	end

	local function NormalizeKeySystemAPI()
		if not Config.KeySystem or typeof(Config.KeySystem.API) ~= "table" then
			return
		end

		local RawAPI = Config.KeySystem.API
		local APIList = RawAPI
		if RawAPI.Type or RawAPI.type or RawAPI.Service or RawAPI.service then
			APIList = { RawAPI }
		end

		local Normalized = {}
		for _, ServiceConfig in next, APIList do
			if typeof(ServiceConfig) == "table" then
				local Service = {}
				for Key, Value in next, ServiceConfig do
					Service[Key] = Value
				end

				Service.Type = NormalizeServiceType(PickField(ServiceConfig, {
					"Type",
					"type",
					"Service",
					"service",
					"Provider",
					"provider",
				}))

				Service.ScriptId = PickField(ServiceConfig, {
					"ScriptId",
					"ScriptID",
					"scriptId",
					"scriptID",
					"script_id",
					"Script",
					"script",
					"Id",
					"ID",
					"id",
				}) or Service.ScriptId

				Service.ServiceId = PickField(ServiceConfig, {
					"ServiceId",
					"ServiceID",
					"serviceId",
					"serviceID",
					"service_id",
					"Service",
					"service",
					"Id",
					"ID",
					"id",
				}) or Service.ServiceId

				Service.Discord = PickField(ServiceConfig, {
					"Discord",
					"discord",
					"DiscordURL",
					"DiscordUrl",
					"discordUrl",
					"discord_url",
					"Invite",
					"invite",
					"URL",
					"Url",
					"url",
				}) or Service.Discord

				Service.Secret = PickField(ServiceConfig, {
					"Secret",
					"secret",
					"ApiSecret",
					"APISecret",
					"apiSecret",
					"api_secret",
				}) or Service.Secret

				Service.ApiKey = PickField(ServiceConfig, {
					"ApiKey",
					"APIKey",
					"apiKey",
					"api_key",
					"Key",
					"key",
				}) or Service.ApiKey

				if Service.Type and Service.Type ~= "" then
					table.insert(Normalized, Service)
				end
			end
		end

		Config.KeySystem.API = Normalized
	end

	NormalizeKeySystemAPI()

	if Config.KeySystem then
		CanLoadWindow = false

		local function loadKeysystem()
			KeySystem.new(Config, Filename, function(c)
				CanLoadWindow = c
			end)
		end

		local keyPath = (Config.Folder or "Temp") .. "/" .. Filename .. ".key"

		if Config.KeySystem.KeyValidator then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local ValidatorOk, isValid = pcall(Config.KeySystem.KeyValidator, savedKey)

				if ValidatorOk and isValid then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		elseif not Config.KeySystem.API then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local isKey = (type(Config.KeySystem.Key) == "table") and table.find(Config.KeySystem.Key, savedKey)
					or tostring(Config.KeySystem.Key) == tostring(savedKey)

				if isKey then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		else
			if isfile(keyPath) then
				local fileKey = readfile(keyPath)
				local isSuccess = false

				for _, i in next, Config.KeySystem.API do
					local serviceData = VynxUI.Services[i.Type]
					if serviceData then
						local args = {}
						for _, argName in next, serviceData.Args do
							table.insert(args, i[argName])
						end

						local CreateOk, service = pcall(function()
							return serviceData.New(table.unpack(args))
						end)
						local VerifyOk, success = false, false
						if CreateOk and service and type(service.Verify) == "function" then
							VerifyOk, success = pcall(service.Verify, fileKey)
						end
						if VerifyOk and success then
							isSuccess = true
							break
						end
					end
				end

				CanLoadWindow = isSuccess
				if not isSuccess then
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		end

		repeat
			task.wait()
		until CanLoadWindow

		OpenLoader("Access granted", 0.42)
	end

	OpenLoader("Building window", 0.72)
	local Window = CreateWindow(Config)

	VynxUI.Transparent = Config.Transparent
	VynxUI.Window = Window

	if Config.Acrylic then
		Acrylic.init()
	end

	if Loader then
		Loader:SetStatus("Ready")
		Loader:SetProgress(1)
		Loader:Close((typeof(LoaderConfig) == "table" and LoaderConfig.CloseDelay) or 0.18)
	end

	-- function Window:ToggleTransparency(Value)
	--     VynxUI.Transparent = Value
	--     VynxUI.Window.Transparent = Value

	--     Window.UIElements.Main.Background.BackgroundTransparency = Value and VynxUI.TransparencyValue or 0
	--     Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and VynxUI.TransparencyValue or 0
	--     Window.UIElements.Main.Gradient.UIGradient.Transparency = NumberSequence.new{
	--         NumberSequenceKeypoint.new(0, 1),
	--         NumberSequenceKeypoint.new(1, Value and 0.85 or 0.7),
	--     }
	-- end

	return Window
end

return VynxUI
