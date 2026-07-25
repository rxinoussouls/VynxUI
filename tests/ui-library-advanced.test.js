const fs = require("fs")

const icons = fs.readFileSync("src/modules/Icons.lua", "utf8")
const creator = fs.readFileSync("src/modules/Creator.lua", "utf8")
const dynamicShape = fs.readFileSync("src/modules/DynamicShape.lua", "utf8")
const elementsInit = fs.readFileSync("src/elements/Init.lua", "utf8")
const dropdown = fs.readFileSync("src/components/ui/Dropdown.lua", "utf8")
const dropdownElement = fs.readFileSync("src/elements/Dropdown.lua", "utf8")
const toggle = fs.readFileSync("src/components/ui/Toggle.lua", "utf8")
const toggleElement = fs.readFileSync("src/elements/Toggle.lua", "utf8")
const loading = fs.readFileSync("src/components/LoadingScreen.lua", "utf8")
const openButton = fs.readFileSync("src/components/window/Openbutton.lua", "utf8")
const windowModule = fs.readFileSync("src/components/window/Init.lua", "utf8")
const loader = fs.readFileSync("loader.lua", "utf8")
const example = fs.readFileSync("main_example.lua", "utf8")
const runtime = fs.readFileSync("dist/main.lua")
const publicRuntime = fs.readFileSync("website/public/main.lua")
const publicDistRuntime = fs.readFileSync("website/public/dist/main.lua")

const checks = {
	multiSourceParser:
		/ParseIconReference/.test(icons) &&
		/source:name/.test(fs.readFileSync("website/content/docs/windui/icons.mdx", "utf8")) &&
		/Value\.Source or Value\.Pack or Value\.Library/.test(icons),
	dynamicIconSources:
		/function IconModule\.RegisterIconSource/.test(icons) &&
		/function IconModule\.AddIcons/.test(icons) &&
		/function IconModule\.AddSourceAlias/.test(icons) &&
		/function IconModule\.GetIconSources/.test(icons),
	executorIconAdapter:
		/local function LoadBaseIcons/.test(icons) &&
		/FindFirstChild\("GetIcons"\)/.test(icons) &&
		/game:HttpGet\(ICONS_URL\)/.test(icons) &&
		/IconModule\.AdapterVersion = 3/.test(icons) &&
		/local Icons = require\("\.\/Icons"\)/.test(creator) &&
		!/RunService:IsStudio\(\) or not writefile/.test(creator),
	creatorImageContract:
		/IconLabel\.Name = "ImageLabel"/.test(creator) &&
		/IconLabel\.Parent = ImageFrame/.test(creator),
	iconPackAliases:
		/typeof\(IconValue\) == "table" and IconValue\.Alias/.test(icons) &&
		/Pack\.Icons\[IconName\] = \{ Alias = IconValue\.Alias \}/.test(icons),
	safeIconFallback:
		/local Image = Resolved and Resolved\[1\] or ""/.test(icons) &&
		/function IconModule\.HasIcon/.test(icons),
	structuredAndInstanceIcons:
		/Value\.Image or Value\.Asset or Value\.AssetId/.test(icons) &&
		/if typeof\(Img\) == "Instance"/.test(creator),
	dynamicIslandStates:
		/function OpenButtonMain:SetState/.test(openButton) &&
		/function OpenButtonMain:Expand/.test(openButton) &&
		/function OpenButtonMain:Collapse/.test(openButton) &&
		/function OpenButtonMain:Compact/.test(openButton) &&
		/function OpenButtonMain:Idle/.test(openButton) &&
		/OpenButtonMain\.Hide = OpenButtonMain\.Idle/.test(openButton) &&
		/function OpenButtonMain:Push/.test(openButton) &&
		/function OpenButtonMain:GetState/.test(openButton),
	dynamicIslandTween:
		/Name = "OpenButtonContainer"/.test(openButton) &&
		/Animate\(Container, Duration, \{ Size = UDim2\.fromOffset/.test(openButton) &&
		/STATE_ALIASES/.test(openButton),
	dynamicIslandAutoHide:
		/AutoHide = 4/.test(openButton) &&
		/function ScheduleAutoHide/.test(openButton) &&
		/State == "Idle"/.test(openButton) &&
		/IdleWidth/.test(openButton) &&
		/IdleHeight/.test(openButton),
	dynamicIslandShadow:
		/Creator\.CreateUIShadow\(Button/.test(openButton) &&
		/NativeShadow/.test(openButton) &&
		/FallbackShadow = false/.test(openButton),
	windowIslandApi:
		/function Window:ExpandOpenButton/.test(windowModule) &&
		/function Window:CollapseOpenButton/.test(windowModule) &&
		/function Window:SetOpenButtonState/.test(windowModule) &&
		/function Window:HideOpenButton/.test(windowModule) &&
		/function Window:WakeOpenButton/.test(windowModule),
	windowIslandMorph:
		/function OpenButtonMain:GetMorphTarget/.test(openButton) &&
		/MorphWindow = true/.test(openButton) &&
		/WindowMorphPosition/.test(windowModule) &&
		/WindowMorphScale/.test(windowModule) &&
		/Motion\.GetDuration\("WindowMorph"\)/.test(windowModule),
	advancedLinkedCorners:
		/Options\.InnerRadius/.test(creator) &&
		/Options\.BridgeSparse/.test(creator) &&
		/Options\.BridgeHidden/.test(creator) &&
		/CornerBreakBefore/.test(creator) &&
		/CornerBreakAfter/.test(creator) &&
		/CornerGroup/.test(creator),
	flatLinkedCornerSeams:
		/InnerRadius = 0/.test(windowModule) &&
		/CornerLink = \{ InnerRadius = 0, Gap = 1/.test(example),
	linkedCornerMetadata:
		/Position = PositionName/.test(creator) &&
		/Horizontal = isHStack == true/.test(creator) &&
		/typeof\(Options\.Resolver\) == "function"/.test(creator),
	linkedCornerSurfaces:
		/function Creator\.ApplyLinkedCornerSurface/.test(creator) &&
		/Corner\.TopLeftRadius/.test(creator) &&
		/Corner\.TopRightRadius/.test(creator) &&
		/Corner\.BottomLeftRadius/.test(creator) &&
		/Corner\.BottomRightRadius/.test(creator) &&
		/function Wrapper:SetLinkedCorners/.test(dynamicShape) &&
		/WindUILinkedCorner/.test(dynamicShape) &&
		/content\.CornerGroup = config\.CornerGroup/.test(elementsInit) &&
		/config\.CornerLink = tbl\.CornerLink/.test(elementsInit),
	centeredDropdown:
		/Dropdown\.Centered/.test(dropdown) &&
		/Name = "DropdownBackdrop"/.test(dropdown) &&
		/Dropdown\.InternalCenter = InternalCenter/.test(dropdown) &&
		/Parent = PopupParent/.test(dropdown) &&
		/return "Center"/.test(dropdown) &&
		/Config\.Centered == true/.test(dropdownElement) &&
		/Centered and 236/.test(dropdownElement) &&
		/CenterTarget/.test(dropdownElement),
	optimizedToggle:
		/UseGlassSpritesheet = Config\.GlassSpritesheet == true/.test(toggle) &&
		/UseDrag = Config\.Drag == true/.test(toggle) &&
		/UseHoldAnimation = Config\.HoldAnimation ~= false/.test(toggle) &&
		/function Control:BeginHold/.test(toggle) &&
		/function Control:EndHold/.test(toggle) &&
		/task\.defer/.test(toggle) &&
		/ToggleFunc\.UseDrag/.test(toggleElement) &&
		!/task\.spawn/.test(toggle),
	tabHolderModes:
		/TabHolderType = TabHolderType/.test(windowModule) &&
		/Name = "TopTabHolder"/.test(windowModule) &&
		/SidebarCompact = SidebarCompact/.test(windowModule) &&
		/Window\.UIElements\.TabHolder/.test(windowModule) &&
		/IsIconOnly/.test(fs.readFileSync("src/components/window/Tab.lua", "utf8")),
	macMenuAccents:
		/IsMacAccent/.test(windowModule) &&
		/MacAccent = true/.test(windowModule) &&
		/#F472B6/.test(windowModule),
	loadingPlayback:
		/Name = "Body"/.test(loading) &&
		/Name = "Percent"/.test(loading) &&
		/function Loader:Play/.test(loading) &&
		/os\.clock\(\) - StartedAt/.test(loading) &&
		/Duration = 5/.test(example),
	freshRuntimeLoader:
		/CACHE_KEY/.test(loader) &&
		/REQUIRED_API/.test(loader) &&
		/AdapterVersion/.test(loader) &&
		/CreateUIShadow/.test(loader) &&
		/RegisterIconPack/.test(loader) &&
		/GetIconSources/.test(loader) &&
		/pcall\(Chunk\)/.test(loader),
	canonicalRuntimeLoader:
		/SOURCE_URL/.test(loader) &&
		/article-hub-studio\.github\.io\/WindUI-Skibidi\/dist\/main\.lua/.test(loader) &&
		!/MIRRORS/.test(loader) &&
		!/cdn\.jsdelivr\.net/.test(loader),
	publishedRuntimeSynced: runtime.equals(publicRuntime) && runtime.equals(publicDistRuntime),
	builtIconAdapter:
		runtime.includes("AdapterVersion=3") &&
		runtime.includes("Unable to load the base icon catalog; custom sources remain available"),
	builtNativeUi:
		runtime.includes("CreateUIShadow") &&
		runtime.includes("UIShadow") &&
		runtime.includes("LayoutVersion") &&
		runtime.includes("LiquidGlass") &&
		runtime.includes("AutoHide") &&
		runtime.includes("WindUILinkedCorner") &&
		runtime.includes("WindowMorphScale") &&
		runtime.includes("DropdownBackdrop") &&
		runtime.includes("InternalCenter") &&
		runtime.includes("UseGlassSpritesheet") &&
		runtime.includes("UseHoldAnimation") &&
		runtime.includes("TopTabHolder") &&
		runtime.includes("Originally") &&
		runtime.includes("DarkOverlay") &&
		runtime.includes("LoadingProgress"),
	exampleRuntimeCompatibility:
		/HasIconSourceAPI/.test(example) &&
		/HasDynamicIslandAPI/.test(example) &&
		/NotifyOutdatedRuntime/.test(example) &&
		/ui-runtime-9/.test(example),
}

const failed = Object.entries(checks).filter(([, ok]) => !ok)
if (failed.length > 0) {
	throw new Error("Advanced UI regression: " + failed.map(([name]) => name).join(", "))
}

console.log("PASS advanced UI library safety")
