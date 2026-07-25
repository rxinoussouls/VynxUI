local WindUI = require("../src/Init")

local Notification = WindUI:Notify({
	Title = "A notification title that wraps safely on a narrow mobile viewport",
	Content = "Long content must stay inside the card without touching the close button or progress indicator.",
	Style = "Warning",
	Duration = 3,
	Buttons = {
		{
			Title = "Dismiss",
		},
		{
			Title = "Retry",
			Close = false,
		},
	},
})

assert(Notification.Appearance == "Compact")
assert(Notification.Type == "Normal")
assert(Notification.UIElements.Main:GetAttribute("Appearance") == "Compact")
assert(Notification.UIElements.Surface.Name == "CapsuleSurface")
assert(Notification.UIElements.ProgressTrack.Size.Y.Offset == 2)
assert(Notification.UIElements.ProgressFill.Size.X.Scale == 1)
assert(Notification.UIElements.CloseButton.Size.X.Offset >= 44)
assert(Notification.UIElements.CloseSurface.Size.X.Offset == 24)
assert(Notification.UIElements.Container.Size.Y.Offset == 0)
assert(Notification.UIElements.Transition:IsA("CanvasGroup"))
assert(Notification.UIElements.Main:GetAttribute("LayoutVersion") == 4)
assert(Notification.DarkOverlay == false)
assert(Notification.UIElements.Main:GetAttribute("DarkOverlay") == false)
assert(type(Notification.Pause) == "function")
assert(type(Notification.Resume) == "function")
assert(type(Notification.Update) == "function")

Notification:Update({
	Title = "Updated notification",
	Content = "Updated without creating a second card.",
})

assert(Notification.UIElements.Title.Text == "Updated notification")
assert(Notification.UIElements.Content.Text == "Updated without creating a second card.")

local CardNotification = WindUI:Notify({
	Title = "Anonim",
	Content = "Metadata card notification",
	Avatar = "rbxassetid://123456789",
	Timestamp = "May 23, 2025",
	Duration = false,
})

assert(CardNotification.Appearance == "Card")
assert(CardNotification.UIElements.Timestamp.Text == "May 23, 2025")
assert(CardNotification.UIElements.IconBubble.Size.X.Offset == 40)
assert(CardNotification.UIElements.Avatar:IsA("ImageLabel"))
assert(CardNotification.UIElements.Avatar.Name == "Avatar")

local GlassNotification = WindUI:Notify({
	Title = "Liquid glass",
	Content = "Native shadow without the dark fallback overlay",
	LiquidGlass = true,
	Duration = false,
})

assert(GlassNotification.LiquidGlass == true)
assert(GlassNotification.UIElements.Main:GetAttribute("LiquidGlass") == true)
assert(GlassNotification.UIElements.Main:GetAttribute("DarkOverlay") == false)
assert(GlassNotification.UIElements.LiquidGlass.Visible == true)

local WindowNotification = WindUI:Notify({
	Type = "Window",
	AppName = "WindUI",
	AppIcon = "app-window",
	Title = "Feature Launch Party",
	Content = "Studio S / Ballroom",
	Selection = {
		Value = "Going",
		Values = { "Going", "Maybe", "Not going" },
	},
	Buttons = {
		{ Title = "RSVP", Close = false },
		{ Title = "Dismiss" },
	},
	Duration = false,
})

assert(WindowNotification.Type == "Window")
assert(WindowNotification.Appearance == "Window")
assert(WindowNotification.UIElements.Main:GetAttribute("Type") == "Window")
assert(WindowNotification.UIElements.AppHeader.Name == "AppHeader")
assert(WindowNotification.UIElements.Selection.Name == "Selection")
assert(WindowNotification.UIElements.SelectionValue.Text == "Going")

local OriginalNotification = WindUI:Notify({
	Type = "Originally",
	Title = "Classic WindUI",
	Duration = false,
})

assert(OriginalNotification.Type == "Originally")
assert(OriginalNotification.Appearance == "Originally")
assert(OriginalNotification.UIElements.Main:GetAttribute("DarkOverlay") == true)
