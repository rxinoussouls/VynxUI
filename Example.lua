-- VYNX UI — Example Script
-- แสดงการใช้งานทั้ง 2 styles: WindUI + Obsidian

local VynxUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/your-github/VynxUI/main/build/VynxUI.lua"
))()

-- ── Theme & Motion ───────────────────────────────────────────────────────────
VynxUI:SetTheme("Vynx")
VynxUI:SetMotionPreset("Liquid")
VynxUI:SetDPIScale(1)

-- ── Loading Screen ───────────────────────────────────────────────────────────
local Loader = VynxUI:CreateLoading({
    Title  = "VYNX Hub",
    Desc   = "กำลังโหลด...",
    Logo   = "rbxassetid://XXXXXXXX",
})
Loader:SetProgress(0.5)
Loader:SetStatus("กำลังโหลด modules...")
task.wait(1.5)
Loader:Close(0.3)

-- ── Create Window ────────────────────────────────────────────────────────────
local Window = VynxUI:CreateWindow({
    Title      = "VYNX Hub",
    Author     = "Jxckyz",
    Icon       = "star",
    Size       = UDim2.fromOffset(600, 440),
    ToggleKey  = Enum.KeyCode.RightControl,
    LiquidGlass= true,
    Footer     = { Text = "v1.0 • VYNX UI" },
    Watermark  = { Title = "VYNX Hub", Position = "TopRight" },

    -- Key System (optional)
    -- KeySystem = {
    --     Service   = "junkiedevelopment",
    --     ServiceId = "YOUR_SERVICE_ID",
    --     ApiKey    = "YOUR_API_KEY",
    --     Provider  = "xlinkx",
    -- },
})

-- ── WINDUI STYLE ─────────────────────────────────────────────────────────────
local WindTab = Window:CreateTab({ Title = "WindUI Style", Icon = "layout-panel-top" })

local MainSection = WindTab:Section({ Title = "Main Controls" })

local toggle = MainSection:Toggle({
    Title    = "Auto Farm",
    Default  = false,
    Flag     = "autoFarm",
    Callback = function(v)
        print("Auto Farm:", v)
    end,
})

local slider = MainSection:Slider({
    Title    = "Farm Speed",
    Min      = 1,
    Max      = 100,
    Default  = 50,
    Suffix   = "x",
    Flag     = "farmSpeed",
    Callback = function(v)
        print("Speed:", v)
    end,
})

local dropdown = MainSection:Dropdown({
    Title  = "Farm Mode",
    Values = { "Normal", "Fast", "Turbo" },
    Default= "Normal",
    Flag   = "farmMode",
    Callback = function(v)
        print("Mode:", v)
    end,
})

local inputSection = WindTab:Section({ Title = "Settings" })

local input = inputSection:Input({
    Title       = "Custom Text",
    Placeholder = "พิมพ์ที่นี่...",
    Flag        = "customText",
    Callback    = function(v) print("Text:", v) end,
})

local keybind = inputSection:Keybind({
    Title   = "Hotkey",
    Default = Enum.KeyCode.F,
    Flag    = "hotkey",
    Callback= function(v) print("Keybind:", v) end,
})

local cpick = inputSection:Colorpicker({
    Title   = "Trail Color",
    Default = Color3.fromHex("#7C5CFF"),
    Flag    = "trailColor",
    Callback= function(v) print("Color:", v) end,
})

-- ── OBSIDIAN STYLE ───────────────────────────────────────────────────────────
local ObsTab = Window:CreateTab({ Title = "Obsidian Style", Icon = "layers" })

-- Left groupbox
local Left = ObsTab:AddLeftGroupbox("Combat")

Left:AddToggle("autoAttack", {
    Text     = "Auto Attack",
    Default  = false,
    Callback = function(v) print("Auto Attack:", v) end,
})

Left:AddSlider("attackSpeed", {
    Text     = "Attack Speed",
    Min      = 1,
    Max      = 10,
    Default  = 3,
    Suffix   = "x",
    Callback = function(v) print("Attack Speed:", v) end,
})

Left:AddDropdown("target", {
    Text     = "Target",
    Values   = { "Nearest", "Furthest", "Random" },
    Default  = "Nearest",
    Callback = function(v) print("Target:", v) end,
})

Left:AddDivider()

Left:AddButton("resetStats", {
    Text     = "Reset Stats",
    Callback = function() print("Reset!") end,
})

-- Right groupbox
local Right = ObsTab:AddRightGroupbox("Visuals")

Right:AddCheckbox("showEsp", {
    Text     = "Show ESP",
    Default  = false,
    Callback = function(v) print("ESP:", v) end,
})

Right:AddColorPicker("espColor", {
    Text     = "ESP Color",
    Default  = Color3.fromHex("#FF5555"),
    Callback = function(v) print("ESP Color:", v) end,
})

Right:AddLabel("statusLabel", { Text = "Status: Ready" })

-- ── DEPENDENCY BOX ───────────────────────────────────────────────────────────
local DepTab = Window:CreateTab({ Title = "DependencyBox", Icon = "git-branch" })
local DepGroup = DepTab:AddGroupbox("Advanced Farm")

DepGroup:AddToggle("enableAdvanced", {
    Text    = "Enable Advanced",
    Default = false,
})

local DepBox = DepGroup:AddDependencyBox()

DepBox:AddToggle("autoCollect", {
    Text     = "Auto Collect",
    Default  = false,
    Callback = function(v) print("Auto Collect:", v) end,
})

DepBox:AddSlider("collectRange", {
    Text    = "Collect Range",
    Min     = 10,
    Max     = 200,
    Default = 50,
    Suffix  = " studs",
})

-- DependencyBox จะ show เฉพาะเมื่อ enableAdvanced = true
DepBox:SetupDependencies({
    { VynxUI.Toggles["enableAdvanced"], true }
})

-- ── GLOBAL ACCESS (Obsidian pattern) ─────────────────────────────────────────
-- ใช้งาน element ผ่าน global registry
-- VynxUI.Toggles["autoFarm"].Value
-- VynxUI.Options["farmSpeed"].Value
-- VynxUI.Toggles["autoAttack"]:SetValue(true)

-- ── DRAGGABLE WATERMARK ──────────────────────────────────────────────────────
local watermark = VynxUI:AddDraggableLabel(
    "VYNX Hub • " .. game.PlaceId,
    UDim2.fromOffset(8, 8)
)

-- ── NOTIFICATION ─────────────────────────────────────────────────────────────
task.wait(1)
VynxUI:Notify({
    Title   = "VYNX Hub",
    Content = "โหลดสำเร็จ! กด RCtrl เพื่อเปิด/ปิด",
    Style   = "Success",
    Duration= 5,
    Icon    = "circle-check",
})

-- ── CLEANUP ──────────────────────────────────────────────────────────────────
VynxUI:OnUnload(function()
    print("VYNX UI unloaded")
end)

-- หากต้องการ unload:
-- VynxUI:Unload()
