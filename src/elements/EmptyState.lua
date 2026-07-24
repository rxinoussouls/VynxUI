local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local CreateButton = require("../components/ui/Button").New

local Element = {}

function Element:New(Config)
	local EmptyState = {
		__type = "EmptyState",
		Title = Config.Title or "Nothing here",
		Desc = Config.Desc or Config.Content,
		Icon = Config.Icon or "inbox",
		Buttons = Config.Buttons or {},
		UIElements = {},
	}

	local Height = math.max(tonumber(Config.Height) or 138, 96)

	EmptyState.UIElements.Main = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
		Name = "EmptyState",
		Size = UDim2.new(1, 0, 0, Height),
		AutomaticSize = #EmptyState.Buttons > 0 and "Y" or "None",
		ImageTransparency = 0.94,
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = "ElementBackground",
		},
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, 16),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
			PaddingBottom = UDim.new(0, 16),
		}),
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Vertical",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
		}),
	})

	local Icon = Creator.Image(EmptyState.Icon, EmptyState.Icon, 0, Config.Window.Folder, "EmptyState", true, true, "EmptyStateIcon")
	Icon.Size = UDim2.new(0, tonumber(Config.IconSize) or 34, 0, tonumber(Config.IconSize) or 34)
	Icon.ImageLabel.ImageTransparency = 0.2
	Icon.Parent = EmptyState.UIElements.Main

	EmptyState.UIElements.Title = New("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Text = EmptyState.Title,
		TextSize = 17,
		TextWrapped = true,
		TextXAlignment = "Center",
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		Parent = EmptyState.UIElements.Main,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	EmptyState.UIElements.Desc = New("TextLabel", {
		Name = "Desc",
		BackgroundTransparency = 1,
		Text = EmptyState.Desc or "",
		TextSize = 14,
		TextTransparency = 0.4,
		TextWrapped = true,
		TextXAlignment = "Center",
		AutomaticSize = "Y",
		Visible = EmptyState.Desc ~= nil,
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		Parent = EmptyState.UIElements.Main,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	if #EmptyState.Buttons > 0 then
		local Buttons = New("Frame", {
			Name = "Buttons",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = EmptyState.UIElements.Main,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = "Vertical",
				HorizontalAlignment = "Center",
			}),
		})

		for _, Button in next, EmptyState.Buttons do
			local ButtonFrame = CreateButton(
				Button.Title,
				Button.Icon,
				Button.Callback,
				Button.Variant or "White",
				Buttons,
				nil,
				nil,
				Config.Window.NewElements and 999 or 10
			)
			ButtonFrame.Size = UDim2.new(1, 0, 0, 36)
		end
	end

	function EmptyState:SetTitle(Title)
		EmptyState.Title = Title
		EmptyState.UIElements.Title.Text = Title
	end

	function EmptyState:SetDesc(Desc)
		EmptyState.Desc = Desc
		EmptyState.UIElements.Desc.Text = Desc or ""
		EmptyState.UIElements.Desc.Visible = Desc ~= nil
	end

	function EmptyState:Highlight()
		Motion.Play(EmptyState.UIElements.Main, "Highlight", { ImageTransparency = 0.9 }, nil, nil, "Highlight")
		task.delay(Motion.GetDuration("Highlight"), function()
			if EmptyState.UIElements.Main.Parent then
				Motion.Play(EmptyState.UIElements.Main, "Highlight", { ImageTransparency = 0.94 }, nil, nil, "Highlight")
			end
		end)
	end

	function EmptyState:Destroy()
		EmptyState.UIElements.Main:Destroy()
	end

	return EmptyState.__type, EmptyState
end

return Element
