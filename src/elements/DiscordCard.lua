local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local DISCORD_BLURPLE = Color3.fromHex("#5865F2")
local DISCORD_DARK = Color3.fromHex("#1E1F2A")

local function Trim(Text)
	Text = tostring(Text or "")
	Text = string.gsub(Text, "^%s+", "")
	Text = string.gsub(Text, "%s+$", "")
	return Text
end

local function GetInviteUrl(Value)
	local Text = Trim(Value)
	if Text == "" then
		return "https://discord.gg/"
	end

	if string.match(Text, "^https?://") then
		return Text
	end
	if string.match(Text, "^discord%.gg/") or string.match(Text, "^discord%.com/invite/") then
		return "https://" .. Text
	end

	return "https://discord.gg/" .. Text
end

local function CopyText(Text)
	if typeof(setclipboard) == "function" then
		local Success = pcall(function()
			setclipboard(Text)
		end)
		return Success
	end
	if typeof(toclipboard) == "function" then
		local Success = pcall(function()
			toclipboard(Text)
		end)
		return Success
	end
	return false
end

local function Notify(WindUI, Title, Content, Icon, Style)
	if WindUI and WindUI.Notify then
		WindUI:Notify({
			Title = Title,
			Content = Content,
			Icon = Icon,
			Style = Style,
		})
	end
end

function Element:New(Config)
	local Invite = Config.Url or Config.Invite or Config.InviteCode or Config.Code
	local InviteUrl = GetInviteUrl(Invite)
	local DiscordCard = {
		__type = "DiscordCard",
		Title = Config.Title or Config.ServerName or "Discord Server",
		Desc = Config.Desc or Config.Content or "Join the community and get updates.",
		Invite = Invite,
		Url = InviteUrl,
		Icon = Config.Icon or "message-circle",
		Members = Config.Members or Config.MemberCount,
		Online = Config.Online or Config.OnlineCount,
		Callback = Config.Callback,
		UIElements = {},
	}

	local Height = math.max(tonumber(Config.Height) or 152, 126)

	DiscordCard.UIElements.Main = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
		Name = "DiscordCard",
		Size = UDim2.new(1, 0, 0, Height),
		AutomaticSize = "Y",
		ImageColor3 = DISCORD_DARK,
		ImageTransparency = 0,
		Parent = Config.Parent,
	}, {
		New("UIGradient", {
			Rotation = 22,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, DISCORD_DARK),
				ColorSequenceKeypoint.new(1, DISCORD_BLURPLE),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.02),
				NumberSequenceKeypoint.new(1, 0.18),
			}),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 12),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
		}),
	})

	local Header = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = DiscordCard.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
	})

	local IconBubble = Creator.NewRoundFrame(999, "Squircle", {
		Size = UDim2.new(0, 42, 0, 42),
		ImageColor3 = Color3.new(1, 1, 1),
		ImageTransparency = 0.9,
		Parent = Header,
	}, {
		Utils.CreateIcon(Creator, DiscordCard.Icon, Config.Window.Folder, "DiscordCard", false, nil),
	})

	local HeaderIcon = IconBubble:FindFirstChildWhichIsA("Frame") or IconBubble:FindFirstChildWhichIsA("ImageLabel")
	if HeaderIcon then
		HeaderIcon.Size = UDim2.new(0, 20, 0, 20)
		HeaderIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		HeaderIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		local IconTarget = Utils.GetImageTarget(HeaderIcon)
		if IconTarget then
			IconTarget.ImageColor3 = Color3.new(1, 1, 1)
			IconTarget.ImageTransparency = 0
		end
	end

	local HeaderText = New("Frame", {
		Size = UDim2.new(1, -52, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = Header,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 3),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
		}),
	})

	DiscordCard.UIElements.Title = New("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = DiscordCard.Title,
		TextSize = 18,
		TextWrapped = true,
		TextXAlignment = "Left",
		TextColor3 = Color3.new(1, 1, 1),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		Parent = HeaderText,
	})

	DiscordCard.UIElements.Desc = New("TextLabel", {
		Name = "Desc",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Text = DiscordCard.Desc,
		TextSize = 13,
		TextWrapped = true,
		TextXAlignment = "Left",
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0.26,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = HeaderText,
	})

	local StatsRow = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Visible = DiscordCard.Members ~= nil or DiscordCard.Online ~= nil,
		Parent = DiscordCard.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Left",
			VerticalAlignment = "Center",
		}),
	})

	local function CreateStat(Title, Value, Color)
		return Creator.NewRoundFrame(999, "Squircle", {
			Size = UDim2.new(0, 0, 0, 28),
			AutomaticSize = "X",
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.9,
			Parent = StatsRow,
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			Creator.NewRoundFrame(999, "Circle", {
				Size = UDim2.new(0, 7, 0, 7),
				ImageColor3 = Color,
			}),
			New("TextLabel", {
				BackgroundTransparency = 1,
				Text = tostring(Value) .. " " .. Title,
				TextSize = 12,
				TextColor3 = Color3.new(1, 1, 1),
				TextTransparency = 0.08,
				AutomaticSize = "XY",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			}),
		})
	end

	if DiscordCard.Members then
		CreateStat("members", DiscordCard.Members, Color3.fromHex("#B6C2FF"))
	end
	if DiscordCard.Online then
		CreateStat("online", DiscordCard.Online, Color3.fromHex("#23A55A"))
	end

	local Actions = New("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Parent = DiscordCard.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
		}),
	})

	local function CreateButton(Title, Icon, Variant, Callback)
		local Button = Creator.NewRoundFrame(999, "Squircle", {
			Size = UDim2.new(0.5, -4, 1, 0),
			ImageColor3 = Variant == "Primary" and Color3.new(1, 1, 1) or Color3.new(1, 1, 1),
			ImageTransparency = Variant == "Primary" and 0.08 or 0.9,
			Parent = Actions,
		}, {
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 7),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
			}),
			Utils.CreateIcon(Creator, Icon, Config.Window.Folder, "DiscordCard", false, nil),
			New("TextLabel", {
				BackgroundTransparency = 1,
				Text = Title,
				TextSize = 13,
				TextColor3 = Variant == "Primary" and Color3.fromHex("#111827") or Color3.new(1, 1, 1),
				TextTransparency = 0,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				AutomaticSize = "XY",
			}),
		}, true)

		local ButtonIcon = Button:FindFirstChildWhichIsA("Frame") or Button:FindFirstChildWhichIsA("ImageLabel")
		local IconTarget = Utils.GetImageTarget(ButtonIcon)
		if IconTarget then
			IconTarget.ImageColor3 = Variant == "Primary" and Color3.fromHex("#111827") or Color3.new(1, 1, 1)
			IconTarget.ImageTransparency = 0
		end

		Motion.AttachPress(Button, Creator, {
			Amount = 0.97,
		})

		Creator.AddSignal(Button.MouseButton1Click, function()
			Creator.SafeCallback(Callback)
		end)

		return Button
	end

	local function CopyInvite(Title)
		if CopyText(DiscordCard.Url) then
			Notify(Config.WindUI, Title or "Discord link copied", DiscordCard.Url, "check", "Success")
			return true
		else
			Notify(Config.WindUI, "Discord invite", DiscordCard.Url, "link", "Warning")
			return false
		end
	end

	CreateButton(Config.CopyTitle or "Copy Link", "link", "Secondary", function()
		CopyInvite("Discord link copied")
	end)

	CreateButton(Config.JoinTitle or "Join", "external-link", "Primary", function()
		if DiscordCard.Callback then
			Creator.SafeCallback(DiscordCard.Callback, DiscordCard.Url, DiscordCard)
		end

		CopyInvite("Discord invite ready")
	end)

	function DiscordCard:SetInvite(Invite)
		DiscordCard.Invite = Invite
		DiscordCard.Url = GetInviteUrl(Invite)
		return DiscordCard.Url
	end

	function DiscordCard:GetUrl()
		return DiscordCard.Url
	end

	function DiscordCard:Copy()
		return CopyInvite("Discord link copied")
	end

	function DiscordCard:Open()
		if DiscordCard.Callback then
			Creator.SafeCallback(DiscordCard.Callback, DiscordCard.Url, DiscordCard)
		end
		return CopyInvite("Discord invite ready")
	end

	function DiscordCard:SetTitle(Title)
		DiscordCard.Title = Title
		DiscordCard.UIElements.Title.Text = Title
	end

	function DiscordCard:SetDesc(Desc)
		DiscordCard.Desc = Desc
		DiscordCard.UIElements.Desc.Text = Desc or ""
	end

	function DiscordCard:Highlight()
		Motion.Play(DiscordCard.UIElements.Main, "Highlight", { ImageTransparency = 0.08 }, nil, nil, "Highlight")
		task.delay(Motion.GetDuration("Highlight"), function()
			if DiscordCard.UIElements.Main.Parent then
				Motion.Play(DiscordCard.UIElements.Main, "Highlight", { ImageTransparency = 0 }, nil, nil, "Highlight")
			end
		end)
	end

	function DiscordCard:Destroy()
		DiscordCard.UIElements.Main:Destroy()
	end

	return DiscordCard.__type, DiscordCard
end

return Element
