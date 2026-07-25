local WindUI = loadstring(game:HttpGet("https://article-hub-studio.github.io/WindUI-Skibidi/loader.lua"))()

local Window = WindUI:CreateWindow({
	Title = "WindUI Discord Example",
	Folder = "WindUIDiscordExample",
	Icon = "message-circle",
	NewElements = true,
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},
	BackgroundColor = Color3.fromHex("#0C1018"),
	BackgroundGradient = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#0C1018"), Transparency = 0.1 },
		["50"] = { Color = Color3.fromHex("#122540"), Transparency = 0.32 },
		["100"] = { Color = Color3.fromHex("#2B2447"), Transparency = 0.48 },
	}, {
		Rotation = 28,
	}),
	BackgroundOverlayTransparency = 0.5,
})

local CommunityTab = Window:Tab({
	Title = "Community",
	Icon = "message-circle",
})

local InviteCard = CommunityTab:DiscordCard({
	Title = "WindUI Community",
	Desc = "Copy the invite or run a custom join callback from one card.",
	Invite = "ftgs-development-hub-1300692552005189632",
	Members = "10k+",
	Online = "Live",
	Callback = function(Url)
		WindUI:Notify({
			Title = "Discord callback",
			Content = Url,
			Icon = "external-link",
		})
	end,
})

local Actions = CommunityTab:HStack()
Actions:Button({
	Title = "Copy",
	Icon = "copy",
	Callback = function()
		InviteCard:Copy()
	end,
})
Actions:Button({
	Title = "Refresh Link",
	Icon = "refresh-cw",
	Callback = function()
		InviteCard:SetInvite("https://discord.gg/ftgs-development-hub-1300692552005189632")
		InviteCard:Highlight()
	end,
})

CommunityTab:Timeline({
	Title = "Invite Flow",
	Items = {
		{ Title = "URL normalized", Value = InviteCard:GetUrl() },
		{ Title = "Copy fallback", Value = "Notify" },
		{ Title = "Join callback", Value = "Enabled" },
	},
})
