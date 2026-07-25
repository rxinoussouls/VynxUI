export type ColorRef = string;

export const defaults: Record<string, ColorRef> = {
    Primary: "icon",
    White: "#ffffff",
    Black: "#000000",

    Dialog: "accent",
    Background: "accent",
    Hover: "text",

    PanelBackground: "White",
    PanelBackgroundOpacity: "0.05",

    WindowBackground: "background",
    WindowShadow: "Black",

    WindowTopbarTitle: "text",
    WindowTopbarAuthor: "text",
    WindowTopbarIcon: "icon",
    WindowTopbarButtonIcon: "icon",

    TabBackground: "Hover",
    TabBackgroundHover: "Hover",
    TabBackgroundHoverOpacity: "0.03",
    TabBackgroundActive: "Hover",
    TabBackgroundActiveOpacity: "0.07",
    TabText: "text",
    TabTextOpacity: "0.7",
    TabTextOpacityActive: "1",
    TabTitle: "text",
    TabIcon: "icon",
    TabIconOpacity: "0.6",
    TabIconOpacityActive: "0.9",
    TabBorderOpacity: "0",
    TabBorderOpacityActive: "0.25",
    TabBorder: "White",

    ElementBackground: "text",
    ElementTitle: "text",
    ElementDesc: "text",
    ElementIcon: "icon",

    PopupBackground: "background",
    PopupTitle: "text",
    PopupContent: "text",
    PopupIcon: "icon",

    DialogBackground: "background",
    DialogTitle: "text",
    DialogContent: "text",
    DialogIcon: "icon",

    Toggle: "button",
    ToggleBar: "White",

    Checkbox: "Primary",
    CheckboxIcon: "White",
    CheckboxBorder: "White",
    CheckboxBorderOpacity: "0.25",

    SliderIcon: "icon",
    Slider: "Primary",
    SliderThumb: "White",
    SliderIconFrom: "SliderIcon",
    SliderIconTo: "SliderIcon",

    Tooltip: "#4C4C4C",
    TooltipText: "White",
    TooltipSecondary: "Primary",
    TooltipSecondaryText: "White",

    SectionIcon: "icon",
    SectionExpandIcon: "White",
    SectionExpandIconOpacity: "0.6",
    SectionBox: "White",
    SectionBoxOpacity: "0.05",
    SectionBoxBorder: "White",
    SectionBoxBorderOpacity: "0.25",

    SearchBarBorder: "White",
    SearchBarBorderOpacity: "0.25",

    Notification: "background",
    NotificationTitle: "text",
    NotificationTitleOpacity: "1",
    NotificationContent: "text",
    NotificationContentOpacity: "0.6",
    NotificationBorder: "White",
    NotificationBorderOpacity: "0.25",

    LabelBackground: "White",
    LabelBackgroundOpacity: "0.05",
};
