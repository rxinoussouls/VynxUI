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

		-- ported from Cascade (Controls.ImageSurface.Gradient) -- flattened
		-- to a single background + a top->bottom UIGradient overlay, since
		-- VynxUI themes are flat Color3s rather than Cascade's alpha-layer
		-- theme objects.
		ImageSurfaceBackground = "ElementBackground",

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
		-- restyled to match Cascade's Form (cascadeui/Cascade,
		-- src/components/Form.luau): opaque Controls.View-style card
		-- background + a subtle ~10%-opacity hairline stroke, replacing
		-- the old near-invisible "Text" tint (0.97 transparency) default.
		SectionBox = "ElementBackground",
		SectionBoxTransparency = 0,
		SectionBoxBorder = "White",
		SectionBoxBorderTransparency = 0.9,
		SectionBoxBackground = "ElementBackground",
		SectionBoxBackgroundTransparency = 0,

		SearchBarBorder = "White",
		SearchBarBorderTransparency = 0.75,

		Notification = "Dialog",
		NotificationTransparency = 0.08,
		NotificationGlass = "Dialog",
		NotificationGlassTransparency = 0.28,
		NotificationGlassSurface = "White",
		NotificationGlassSurfaceTransparency = 0.91,
		NotificationGlassHighlight = "White",
		NotificationGlassTextureTransparency = 0.78,
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
		-- raised to "Dialog" (an elevated surface, distinct from the
		-- flat window Background) to match FloatingMenu.lua's Cascade-
		-- style floating menus and Cascade's Controls.MenuButton
		-- .MenuBackground, which is a separate, lighter tone from
		-- Controls.Background.
		DropdownBackground = "Dialog",

		LabelBackground = "White",
		LabelBackgroundTransparency = 0.95,

		ViewportBackground = "ElementBackground",
		ViewportBackgroundTransparency = "ElementBackgroundTransparency",
	}
end
