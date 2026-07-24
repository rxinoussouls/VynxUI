--[[
    VYNX UI Example
    Merged: WindUI + Obsidian + NeverLose
    https://github.com/rxinoussouls/VynxUI
]]

local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua"
))()

-- ── Theme & Motion ───────────────────────────────────────────────
VynxUI:SetTheme("Dark")
VynxUI:SetMotionPreset("Liquid")

-- ── Create Window ────────────────────────────────────────────────
local Window = VynxUI:CreateWindow({
    Title      = "VYNX Hub",
    Author     = "rxinoussouls",
    Icon       = "star",
    Size       = UDim2.fromOffset(610, 450),
    ToggleKey  = Enum.KeyCode.RightControl,
    Footer     = { Text = "v1.3  •  VYNX UI" },
    LiquidGlass= false,
})

-- ═══════════════════════════════════════════════════════════
--  TAB 1 — Elements Showcase (WindUI native)
-- ═══════════════════════════════════════════════════════════
local TabMain = Window:CreateTab({ Title = "Elements", Icon = "layout-panel-top" })

local SecBasic = TabMain:Section({ Title = "Basic Controls" })

SecBasic:Toggle({
    Title    = "Auto Farm",
    Default  = false,
    Flag     = "autoFarm",
    Callback = function(v) print("Auto Farm:", v) end,
})

SecBasic:Slider({
    Title    = "Speed",
    Min      = 1,
    Max      = 100,
    Default  = 50,
    Suffix   = " studs/s",
    Flag     = "farmSpeed",
    Callback = function(v) print("Speed:", v) end,
})

SecBasic:Dropdown({
    Title    = "Farm Mode",
    Values   = { "Closest", "Fastest", "Auto" },
    Default  = "Closest",
    Flag     = "farmMode",
    Callback = function(v) print("Mode:", v) end,
})

SecBasic:Input({
    Title       = "Custom Note",
    Placeholder = "Type here...",
    Flag        = "note",
    Callback    = function(v) print("Note:", v) end,
})

SecBasic:Keybind({
    Title    = "Toggle Key",
    Default  = Enum.KeyCode.RightControl,
    Flag     = "toggleKey",
    Callback = function(v) print("Key:", v) end,
})

SecBasic:Colorpicker({
    Title    = "Accent Color",
    Default  = Color3.fromHex("#7C5CFF"),
    Flag     = "accentColor",
    Callback = function(v) print("Color:", v) end,
})

local SecDisplay = TabMain:Section({ Title = "Display" })

SecDisplay:Paragraph({
    Title   = "About VYNX UI",
    Content = "Merged from WindUI, Obsidian and NeverLose. Supports all three API styles.",
})

SecDisplay:Badge({
    Title = "Version",
    Content = "v1.3.0",
})

SecDisplay:Callout({
    Title   = "Tip",
    Content = "Use DependencyBox to show/hide elements based on conditions.",
    Style   = "Info",
})

SecDisplay:Divider({ Title = "More Elements" })

SecDisplay:RadioGroup({
    Title   = "Sort By",
    Values  = { "Name", "Level", "Distance" },
    Default = "Name",
    Flag    = "sortBy",
})

SecDisplay:SegmentedControl({
    Title   = "Mode",
    Values  = { "Simple", "Advanced" },
    Default = "Simple",
    Flag    = "viewMode",
})

local SecActions = TabMain:Section({ Title = "Actions" })

SecActions:Button({
    Title    = "Teleport to Spawn",
    Callback = function() print("Teleporting...") end,
})

SecActions:Button({
    Title    = "Copy Player ID",
    Style    = "Secondary",
    Callback = function()
        local id = tostring(game.Players.LocalPlayer.UserId)
        print("ID:", id)
        if setclipboard then setclipboard(id) end
    end,
})

-- ═══════════════════════════════════════════════════════════
--  TAB 2 — Obsidian Style API
-- ═══════════════════════════════════════════════════════════
local TabObs = Window:CreateTab({ Title = "Obsidian API", Icon = "layers" })

local LeftGroup  = TabObs:AddLeftGroupbox("Combat")
local RightGroup = TabObs:AddRightGroupbox("Visuals")

-- Left groupbox
LeftGroup:AddToggle("aimbot", {
    Text     = "Aimbot",
    Default  = false,
    Callback = function(v) print("Aimbot:", v) end,
})

LeftGroup:AddSlider("fov", {
    Text     = "FOV",
    Min      = 10,
    Max      = 360,
    Default  = 90,
    Suffix   = "°",
    Callback = function(v) print("FOV:", v) end,
})

LeftGroup:AddDropdown("bone", {
    Text     = "Target Bone",
    Values   = { "Head", "Neck", "Chest", "HumanoidRootPart" },
    Default  = "Head",
    Callback = function(v) print("Bone:", v) end,
})

LeftGroup:AddKeyPicker("aimKey", {
    Text     = "Aim Key",
    Default  = Enum.KeyCode.C,
    Callback = function(v) print("Aim key:", v) end,
})

LeftGroup:AddDivider()

LeftGroup:AddButton("resetAim", {
    Text     = "Reset Aimbot",
    Callback = function() print("Reset!") end,
})

-- Right groupbox
RightGroup:AddToggle("esp", {
    Text     = "ESP",
    Default  = false,
    Callback = function(v) print("ESP:", v) end,
})

RightGroup:AddColorPicker("espColor", {
    Text     = "ESP Color",
    Default  = Color3.fromHex("#FF5555"),
    Callback = function(v) print("ESP Color:", v) end,
})

RightGroup:AddCheckbox("showNames", {
    Text     = "Show Names",
    Default  = true,
    Callback = function(v) print("Names:", v) end,
})

RightGroup:AddCheckbox("showDist", {
    Text     = "Show Distance",
    Default  = false,
    Callback = function(v) print("Distance:", v) end,
})

RightGroup:AddLabel("espStatus", { Text = "ESP: Disabled" })

-- Watch toggle to update label
VynxUI.Toggles["esp"] and VynxUI.Toggles["esp"].OnChanged
    and VynxUI.Toggles["esp"].OnChanged.Event:Connect(function(v)
        if VynxUI.Labels["espStatus"] then
            VynxUI.Labels["espStatus"]:SetText("ESP: " .. (v and "Enabled" or "Disabled"))
        end
    end)

-- ═══════════════════════════════════════════════════════════
--  TAB 3 — DependencyBox
-- ═══════════════════════════════════════════════════════════
local TabDep = Window:CreateTab({ Title = "DependencyBox", Icon = "git-branch" })

local DepGroup = TabDep:AddGroupbox("Advanced Options")

DepGroup:AddToggle("advEnabled", {
    Text    = "Enable Advanced",
    Default = false,
})

-- Sub-options only visible when advanced is enabled
local DepBox = DepGroup:AddDependencyBox()

DepBox:AddToggle("autoCollect", {
    Text     = "Auto Collect",
    Default  = false,
    Callback = function(v) print("Collect:", v) end,
})

DepBox:AddSlider("collectRange", {
    Text     = "Collect Range",
    Min      = 10,
    Max      = 300,
    Default  = 80,
    Suffix   = " studs",
})

DepBox:AddDropdown("collectFilter", {
    Text    = "Filter",
    Values  = { "All", "Rare+", "Legendary" },
    Default = "All",
})

DepBox:AddDivider()

DepBox:AddButton("startCollect", {
    Text     = "Start Collecting",
    Callback = function() print("Started!") end,
})

DepBox:SetupDependencies({
    { VynxUI.Toggles["advEnabled"], true },
})

-- Second dependency example
local ModeGroup = TabDep:AddGroupbox("Mode Dependency")

ModeGroup:AddDropdown("activeMode", {
    Text    = "Mode",
    Values  = { "Off", "Passive", "Aggressive" },
    Default = "Off",
})

local DepBoxMode = ModeGroup:AddDependencyBox()

DepBoxMode:AddSlider("aggrSpeed", {
    Text    = "Aggression Speed",
    Min     = 1,
    Max     = 10,
    Default = 5,
})

DepBoxMode:AddToggle("autoTarget", {
    Text    = "Auto Target",
    Default = false,
})

DepBoxMode:SetupDependencies({
    { VynxUI.Options["activeMode"], "Aggressive" },
})

-- ═══════════════════════════════════════════════════════════
--  TAB 4 — Player Info
-- ═══════════════════════════════════════════════════════════
local TabInfo = Window:CreateTab({ Title = "Player", Icon = "user" })

local SecPlayer = TabInfo:Section({ Title = "Local Player" })

local LP = game.Players.LocalPlayer

SecPlayer:StatCard({
    Title = "Username",
    Stats = {
        { Label = LP.DisplayName, Value = "@"..LP.Name },
    },
})

SecPlayer:KeyValue({ Key = "User ID",    Value = tostring(LP.UserId) })
SecPlayer:KeyValue({ Key = "Account Age",Value = tostring(LP.AccountAge) .. " days" })
SecPlayer:KeyValue({ Key = "Place ID",   Value = tostring(game.PlaceId) })

SecPlayer:Divider({ Title = "Actions" })

SecPlayer:Button({
    Title    = "Respawn Character",
    Callback = function()
        if LP.Character then LP:LoadCharacter() end
    end,
})

-- ═══════════════════════════════════════════════════════════
--  TAB 5 — Settings (WindUI built-in)
-- ═══════════════════════════════════════════════════════════
local TabSettings = Window:CreateTab({
    Title = "Settings",
    Icon  = "settings",
    Type  = "Settings",
})

-- ═══════════════════════════════════════════════════════════
--  WATERMARK
-- ═══════════════════════════════════════════════════════════
local Watermark = VynxUI:CreateWatermark()

local wFPS = Watermark:AddBlock("◈", "VYNX Hub")
local wGame = Watermark:AddBlock("🎮", tostring(game.PlaceId))
local wPlayer = Watermark:AddBlock("👤", LP.DisplayName)

Watermark:SetRender(true)

-- Update FPS every second
task.spawn(function()
    while task.wait(1) do
        local fps = math.round(1 / game:GetService("RunService").Heartbeat:Wait())
        wFPS:SetText("VYNX  " .. fps .. " FPS")
    end
end)

-- ═══════════════════════════════════════════════════════════
--  NOTIFICATION
-- ═══════════════════════════════════════════════════════════
task.wait(0.5)
VynxUI:Notify({
    Title   = "VYNX Hub Loaded",
    Content = "v1.3 • WindUI + Obsidian + NeverLose\nPress RCtrl to toggle",
    Style   = "Success",
    Duration= 6,
    Icon    = "circle-check",
})

-- ═══════════════════════════════════════════════════════════
--  CLEANUP
-- ═══════════════════════════════════════════════════════════
VynxUI:GiveSignal(game.Players.PlayerRemoving:Connect(function(p)
    if p == LP then VynxUI:Unload() end
end))

VynxUI:OnUnload(function()
    Watermark:Destroy()
    print("[VYNX] Unloaded.")
end)
