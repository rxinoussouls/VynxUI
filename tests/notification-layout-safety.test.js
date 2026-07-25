const fs = require("fs")

const source = fs.readFileSync("src/components/Notification.lua", "utf8")
const creator = fs.readFileSync("src/modules/Creator.lua", "utf8")
const checks = {
	responsiveHolder:
		/UISizeConstraint/.test(source) &&
		/HOLDER_MAX_WIDTH = 420/.test(source) &&
		/MinSize/.test(source) &&
		/MaxSize/.test(source),
	bottomProgress: /Name = "ProgressTrack"/.test(source) && /Name = "ProgressFill"/.test(source),
	deterministicHeight: /UpdateContainerHeight/.test(source) && !/Main\.AbsoluteSize\.Y/.test(source),
	touchClose:
		/Name = "CloseButton"[\s\S]{0,220}Size = UDim2\.fromOffset\(CLOSE_SIZE, CLOSE_SIZE\)/.test(source) &&
		/CLOSE_SIZE = 44/.test(source) &&
		/CLOSE_SURFACE_SIZE = 24/.test(source),
	capsuleAppearance:
		/APPEARANCE_ALIASES/.test(source) &&
		/default = "Compact"/.test(source) &&
		/Name = "CapsuleSurface"/.test(source) &&
		/Card:SetAttribute\("Appearance", Notification\.Appearance\)/.test(source),
	metadataCard:
		/Appearance == "Card"/.test(source) &&
		/Name = "Timestamp"/.test(source) &&
		/AVATAR_SIZE = 40/.test(source) &&
		/DirectImageLabel/.test(creator) &&
		/Avatar = if Notification\.IsAvatar then IconImage else nil/.test(source),
	boundedStack: /MAX_VISIBLE = 4/.test(source) && /TrimNotifications/.test(source),
	heightAwareStack: /AvailableHeight/.test(source) && /TotalHeight > AvailableHeight/.test(source),
	shadowOverflow:
		/Name = "NotificationHolder"[\s\S]{0,260}ClipsDescendants = false/.test(source) &&
		/Name = "NotificationContainer"[\s\S]{0,180}ClipsDescendants = false/.test(source),
	orderedActions: /for Index = 1, math\.min\(#Buttons, MAX_ACTIONS\)/.test(source),
	glassTransition:
		/New\("CanvasGroup"/.test(source) &&
		/Name = "NotificationTransition"/.test(source) &&
		/GroupTransparency = 1/.test(source) &&
		/Name = "TransitionScale"/.test(source),
	themeAwareBorder:
		/Name = "Notification"/.test(source) &&
		/NotificationBorder/.test(source) &&
		/NotificationBorderTransparency/.test(source),
	compactProgress:
		/Name = "ProgressTrack"[\s\S]{0,420}UDim2\.new\(0\.32, 0, 0, PROGRESS_HEIGHT\)/.test(source),
	nativeShadow:
		/function Creator\.CreateUIShadow/.test(creator) &&
		/Instance\.new\("UIShadow"\)/.test(creator) &&
		/Creator\.CreateUIShadow\(Card/.test(source) &&
		/Shadow\.Visible = UseShadow and NativeShadow == nil and UseFallbackShadow/.test(source) &&
		/UseFallbackShadow = Config\.FallbackShadow == true/.test(source),
	liquidGlass:
		/LiquidGlass = Config\.LiquidGlass == true/.test(source) &&
		/Name = "LiquidGlass"/.test(source) &&
		/"SquircleGlass"/.test(source) &&
		/Card:SetAttribute\("LiquidGlass", Notification\.LiquidGlass\)/.test(source),
	noDarkOverlay:
		/DarkOverlay = Config\.DarkOverlay == true/.test(source) &&
		/Card:SetAttribute\("DarkOverlay", UseDarkOverlay\)/.test(source) &&
		/else \(if Notification\.LiquidGlass then 0\.64 else 0\.72\)/.test(source),
	individualCorners:
		/Creator\.ApplyCornerRadii\(Corner, Radius, Corners\)/.test(source) &&
		/TopLeftRadius/.test(creator) &&
		/CardCorners/.test(source),
	layoutVersion: /Card:SetAttribute\("LayoutVersion", 4\)/.test(source),
	notificationTypes:
		/NOTIFICATION_TYPE_ALIASES/.test(source) &&
		/window = "Window"/.test(source) &&
		/originally = "Originally"/.test(source) &&
		/Card:SetAttribute\("Type", Notification\.Type\)/.test(source),
	windowCard:
		/Name = "AppHeader"/.test(source) &&
		/Name = "Selection"/.test(source) &&
		/SelectionConfig\.Callback/.test(source),
	pausableTimer:
		/function Notification:Pause\(\)/.test(source) &&
		/function Notification:Resume\(\)/.test(source) &&
		/function Notification:GetRemainingDuration\(\)/.test(source),
	dynamicUpdate: /function Notification:Update\(Changes\)/.test(source),
	hoverPause:
		/PauseOnHover = Config\.PauseOnHover ~= false/.test(source) &&
		/Connect\(Main\.MouseEnter/.test(source) &&
		/Connect\(Main\.MouseLeave/.test(source),
}

const failed = Object.entries(checks).filter(([, ok]) => !ok)
if (failed.length > 0) {
	throw new Error("Notification layout regression: " + failed.map(([name]) => name).join(", "))
}

console.log("PASS notification layout safety")
