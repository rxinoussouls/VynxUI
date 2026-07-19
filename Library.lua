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

local BASE_URL = "https://raw.githubusercontent.com/rxinoussouls/VynxUI/refs/heads/main/"

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
