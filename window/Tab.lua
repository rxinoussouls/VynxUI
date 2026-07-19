local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = Players.LocalPlayer:GetMouse()

local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local CreateToolTip = require("../components/ui/Tooltip").New
local CreateScrollSlider = require("../components/ui/ScrollSlider").New

local Window, WindUI, UIScale

local TabModule = {
	--Window = nil,
	--WindUI = nil,
	Tabs = {},
	Containers = {},
	SelectedTab = nil,
	TabCount = 0,
	ToolTipParent = nil,
	TabHighlight = nil,

	OnChangeFunc = function(v) end,
}

local function GetImageTarget(Object)
	if typeof(Object) ~= "Instance" then
		return nil
	end

	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return Object
	end

	return Object:FindFirstChildWhichIsA("ImageLabel", true) or Object:FindFirstChildWhichIsA("ImageButton", true)
end

function TabModule.Init(WindowTable, WindUITable, ToolTipParent, TabHighlight)
	Window = WindowTable
	WindUI = WindUITable
	TabModule.ToolTipParent = ToolTipParent
	TabModule.TabHighlight = TabHighlight
	return TabModule
end

function TabModule.New(Config, UIScale)
	local Tab = {
		__type = "Tab",
		Title = Config.Title or "Tab",
		Desc = Config.Desc,
		Icon = Config.Icon,
		Golden = Config.Golden == true or Config.Premium == true,
		Premium = Config.Premium == true or Config.Golden == true,
		IconColor = Config.IconColor
			or ((Config.Golden == true or Config.Premium == true) and Color3.fromRGB(255, 222, 105) or nil),
		IconShape = Config.IconShape,
		IconThemed = Config.IconThemed,
		Locked = Config.Locked,
		ShowTabTitle = Config.ShowTabTitle,
		TabTitleAlign = Config.TabTitleAlign or "Left",
		CustomEmptyPage = (Config.CustomEmptyPage and next(Config.CustomEmptyPage) ~= nil) and Config.CustomEmptyPage
			or { Icon = "lucide:frown", IconSize = 48, Title = "This tab is Empty", Desc = nil },
		Border = Config.Border,
		Selected = false,
		Index = nil,
		Parent = Config.Parent,
		UIElements = {},
		Elements = {},
		ContainerFrame = nil,
		UICorner = Window.UICorner - (Window.UIPadding / 2),
		LinkCorners = Config.LinkCorners == true,

		Gap = Config.Gap or Config.ElementGap or Window.ElementGap or (Window.NewElements and (Window.LiquidGlass and 6 or 1) or 6),

		TabPaddingX = 4 + (Window.UIPadding / 2),
		TabPaddingY = 3 + (Window.UIPadding / 2),
		TitlePaddingY = 0,
	}

	-- if Tab.TabTitleAlign == "Left" then
	-- 	Tab.TabTitleAlign = "Top"
	-- elseif Tab.TabTitleAlign == "Right" then
	-- 	Tab.TabTitleAlign = "Bottom"
	-- elseif Tab.TabTitleAlign == "Center" then
	-- 	Tab.TabTitleAlign = "Center"
	-- end

	if Tab.IconShape then
		Tab.TabPaddingX = 2 + (Window.UIPadding / 4)
		Tab.TabPaddingY = 2 + (Window.UIPadding / 4)
		Tab.TitlePaddingY = 2 + (Window.UIPadding / 4)
	end

	TabModule.TabCount = TabModule.TabCount + 1

	local TabIndex = TabModule.TabCount
	Tab.Index = TabIndex

	Tab.UIElements.Main = Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -7, 0, 0),
		AutomaticSize = "Y",
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = "TabBackground",
		},
		ImageTransparency = 1,
	}, {
		Creator.NewRoundFrame(Tab.UICorner - 1, "Glass-1.4", {
			Size = UDim2.new(1, 1, 1, 1),
			ThemeTag = {
				ImageColor3 = "TabBorder",
			},
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ImageTransparency = 1, -- .7
			Name = "Outline",
		}, {
			-- New("UIGradient", {
			--     Rotation = 80,
			--     Color = ColorSequence.new({
			--         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
			--         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			--         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
			--     }),
			--     Transparency = NumberSequence.new({
			--         NumberSequenceKeypoint.new(0.0, 0.1),
			--         NumberSequenceKeypoint.new(0.5, 1),
			--         NumberSequenceKeypoint.new(1.0, 0.1),
			--     })
				-- }),
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "ActiveRail",
			Size = UDim2.new(0, 3, 0, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "Primary",
			},
		}),
		Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			ThemeTag = {
				ImageColor3 = "Text",
			},
			ImageTransparency = 1, -- .95
			Name = "Frame",
		}, {
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 2 + (Window.UIPadding / 2)),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = not Tab.Golden and {
					TextColor3 = "TabTitle",
				} or nil,
				TextColor3 = Tab.Golden and Color3.fromRGB(255, 232, 144) or nil,
				TextTransparency = not Tab.Locked and (Tab.Golden and 0.12 or 0.4) or 0.7,
				TextSize = 15,
				Size = UDim2.new(1, 0, 0, 0),
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextWrapped = true,
				RichText = true,
				AutomaticSize = "Y",
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, Tab.TitlePaddingY),
					--PaddingLeft = UDim.new(0,2+(Window.UIPadding/2)),
					--PaddingRight = UDim.new(0,2+(Window.UIPadding/2)),
					PaddingBottom = UDim.new(0, Tab.TitlePaddingY),
				}),
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, Tab.TabPaddingY),
				PaddingLeft = UDim.new(0, Tab.TabPaddingX),
				PaddingRight = UDim.new(0, Tab.TabPaddingX),
				PaddingBottom = UDim.new(0, Tab.TabPaddingY),
			}),
		}),
	}, true)

	if Tab.Golden then
		Tab.UIElements.Main.Frame.ImageColor3 = Color3.fromRGB(64, 49, 18)
		Tab.UIElements.Main.Frame.ImageTransparency = 0.88
		Tab.UIElements.Main.Outline.ImageColor3 = Color3.fromRGB(255, 214, 92)
		Tab.UIElements.Main.Outline.ImageTransparency = 0.78
		Tab.UIElements.GoldenShine = New("UIGradient", {
			Rotation = 18,
			Offset = Vector2.new(-1, 0),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 185, 56)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 244, 184)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 94, 18)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.88),
				NumberSequenceKeypoint.new(0.48, 0.72),
				NumberSequenceKeypoint.new(0.55, 0.18),
				NumberSequenceKeypoint.new(0.64, 0.74),
				NumberSequenceKeypoint.new(1, 0.9),
			}),
			Parent = Tab.UIElements.Main.Frame,
		})

		if Motion:IsEnabled() and not Motion.Reduced then
			task.spawn(function()
				while Tab.UIElements.Main and Tab.UIElements.Main.Parent and Tab.UIElements.GoldenShine do
					Tab.UIElements.GoldenShine.Offset = Vector2.new(-1, 0)
					local Tween = TweenService:Create(
						Tab.UIElements.GoldenShine,
						TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{ Offset = Vector2.new(1, 0) }
					)
					Tween:Play()
					Tween.Completed:Wait()
					task.wait(1.1)
				end
			end)
		end
	end

	local TextOffset = 0
	local Icon
	local Icon2

	if Tab.Icon then
		Icon = Creator.Image(
			Tab.Icon,
			Tab.Icon .. ":" .. Tab.Title,
			0,
			Window.Folder,
			Tab.__type,
			Tab.IconColor and false or true,
			Tab.IconThemed,
			"TabIcon"
		)
		Icon.Size = UDim2.new(0, 16, 0, 16)
		local IconTarget = GetImageTarget(Icon)
		if Tab.IconColor and IconTarget then
			IconTarget.ImageColor3 = Tab.IconColor
		end
		if not Tab.IconShape then
			Icon.Parent = Tab.UIElements.Main.Frame
			Tab.UIElements.Icon = Icon
			if IconTarget then
				IconTarget.ImageTransparency = not Tab.Locked and 0 or 0.7
			end
			TextOffset = -16 - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		elseif Tab.IconColor then
			local _IconBG = Creator.NewRoundFrame(
				Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
				"Squircle",
				{
					Size = UDim2.new(0, 26, 0, 26),
					ImageColor3 = Tab.IconColor,
					Parent = Tab.UIElements.Main.Frame,
				},
				{
					Icon,
					Creator.NewRoundFrame(
						Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
						"Glass-1.4",
						{
							Size = UDim2.new(1, 0, 1, 0),
							ThemeTag = {
								ImageColor3 = "White",
							},
							ImageTransparency = 0,
							Name = "Outline",
						},
						{
							-- New("UIGradient", {
							--     Rotation = 45,
							--     Color = ColorSequence.new({
							--         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
							--     }),
							--     Transparency = NumberSequence.new({
							--         NumberSequenceKeypoint.new(0.0, 0.1),
							--         NumberSequenceKeypoint.new(0.5, 1),
							--         NumberSequenceKeypoint.new(1.0, 0.1),
							--     })
							-- }),
						}
					),
				}
			)
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
			if IconTarget then
				IconTarget.ImageTransparency = 0
				IconTarget.ImageColor3 = Creator.GetTextColorForHSB(Tab.IconColor, 0.68)
			end
			TextOffset = -26 - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		end

		Icon2 =
			Creator.Image(Tab.Icon, Tab.Icon .. ":" .. Tab.Title, 0, Window.Folder, Tab.__type, true, Tab.IconThemed)
		Icon2.Size = UDim2.new(0, 16, 0, 16)
		local Icon2Target = GetImageTarget(Icon2)
		if Icon2Target then
			Icon2Target.ImageTransparency = not Tab.Locked and 0 or 0.7
		end
		TextOffset = -30

		--Icon2.Parent = Tab.UIElements.Main.Frame
		--Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1,-30,0,0)
		--Tab.UIElements.Icon = Icon
	end

	Tab.UIElements.ContainerFrame = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, Tab.ShowTabTitle and -((Window.UIPadding * 2.4) + 12) or 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = "Never",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		AutomaticCanvasSize = "Y",
		--Visible = false,
		ScrollingDirection = "Y",
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingLeft = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingRight = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingBottom = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
		}),
		New("UIListLayout", {
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, Tab.Gap),
			HorizontalAlignment = "Center",
		}),
	})

	-- Tab.UIElements.ContainerFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	--     Tab.UIElements.ContainerFrame.CanvasSize = UDim2.new(0,0,0,Tab.UIElements.ContainerFrame.UIListLayout.AbsoluteContentSize.Y+Window.UIPadding*2)
	-- end)

	Tab.UIElements.ContainerFrameCanvas = New("CanvasGroup", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Visible = false,
		Parent = Window.UIElements.MainBar,
		ZIndex = 5,
	}, {
		Tab.UIElements.ContainerFrame,
		New("Frame", {
			Size = UDim2.new(1, -14, 1, -14),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Name = "ScrollSliderHolder",
		}),
		New("Frame", {
			Size = UDim2.new(1, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			BackgroundTransparency = 1,
			Visible = Tab.ShowTabTitle or false,
			Name = "TabTitle",
		}, {
			Icon2,
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 20,
				TextTransparency = 0.1,
				Size = UDim2.new(0, 0, 1, 0),
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				--TextTruncate = "AtEnd",
				RichText = true,
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
				AutomaticSize = "X",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 20),
			}),
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = Tab.TabTitleAlign,
			}),
		}),
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 0.9,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
			Position = UDim2.new(0, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			Visible = Tab.ShowTabTitle or false,
		}),
	})

	TabModule.Containers[TabIndex] = Tab.UIElements.ContainerFrameCanvas
	TabModule.Tabs[TabIndex] = Tab

	Tab.ContainerFrame = Tab.UIElements.ContainerFrameCanvas

	Creator.AddSignal(Tab.UIElements.Main.MouseButton1Click, function()
		if not Tab.Locked then
			TabModule:SelectTab(TabIndex)
		end
	end)

	Motion.AttachPress(Tab.UIElements.Main, Creator, {
		Amount = 0.985,
	})

	if Window.ScrollBarEnabled then
		CreateScrollSlider(
			Tab.UIElements.ContainerFrame,
			Tab.UIElements.ContainerFrameCanvas.ScrollSliderHolder,
			Window,
			4,
			WindUI
		)
	end

	local ToolTip
	local hoverTimer
	local MouseConn
	local IsHovering = false

	-- ToolTip
	if Tab.Desc then
		Creator.AddSignal(Tab.UIElements.Main.InputBegan, function()
			IsHovering = true
			hoverTimer = task.spawn(function()
				task.wait(0.35)
				if IsHovering and not ToolTip then
					ToolTip = CreateToolTip(Tab.Desc, TabModule.ToolTipParent, true)
					ToolTip.Container.AnchorPoint = Vector2.new(0.5, 0.5)

					local function updatePosition()
						if ToolTip then
							ToolTip.Container.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y - 4)
						end
					end

					updatePosition()
					MouseConn = Mouse.Move:Connect(updatePosition)
					ToolTip:Open()
				end
			end)
		end)
	end

	Creator.AddSignal(Tab.UIElements.Main.MouseEnter, function()
		if not Tab.Locked and not Tab.Selected then
			Creator.SetThemeTag(Tab.UIElements.Main.Frame, {
				ImageTransparency = "TabBackgroundHoverTransparency",
				ImageColor3 = "TabBackgroundHover",
			}, 0.1)
		end
	end)
	Creator.AddSignal(Tab.UIElements.Main.MouseLeave, function()
		if not Tab.Locked and not Tab.Selected then
			Motion.Play(Tab.UIElements.Main.Frame, "Hover", {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabHover")
		end
	end)
	Creator.AddSignal(Tab.UIElements.Main.InputEnded, function()
		if Tab.Desc then
			IsHovering = false
			if hoverTimer then
				task.cancel(hoverTimer)
				hoverTimer = nil
			end
			if MouseConn then
				MouseConn:Disconnect()
				MouseConn = nil
			end
			if ToolTip then
				ToolTip:Close()
				ToolTip = nil
			end
		end

		if not Tab.Locked and not Tab.Selected then
			Motion.Play(Tab.UIElements.Main.Frame, "Hover", {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabHover")
		end
	end)

	function Tab:ScrollToTheElement(elemindex)
		Tab.UIElements.ContainerFrame.ScrollingEnabled = false

		Motion.Play(Tab.UIElements.ContainerFrame, "Resize", {
			CanvasPosition = Vector2.new(
				0,
				Tab.Elements[elemindex].ElementFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
			),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "ScrollToElement")

		task.spawn(function()
			task.wait(Motion.GetDuration("Resize") + 0.03)

			if Tab.Elements[elemindex].Highlight then
				Tab.Elements[elemindex]:Highlight()
			end
			Tab.UIElements.ContainerFrame.ScrollingEnabled = true
		end)

		return Tab
	end

	-- yo

	local ElementsModule = require("../elements/Init")

	ElementsModule.Load(
		Tab,
		Tab.UIElements.ContainerFrame,
		ElementsModule.Elements,
		Window,
		WindUI,
		nil,
		ElementsModule,
		UIScale,
		Tab
	)

	function Tab:LockAll()
		--print("LockAll called, number of elements: " .. #self.Elements)
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Lock then
				element:Lock()
			end
		end
	end
	function Tab:UnlockAll()
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Unlock then
				element:Unlock()
			end
		end
	end
	function Tab:GetLocked()
		local LockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == true then
				table.insert(LockedElements, element)
			end
		end

		return LockedElements
	end
	function Tab:GetUnlocked()
		local UnlockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == false then
				table.insert(UnlockedElements, element)
			end
		end

		return UnlockedElements
	end

	function Tab:Select()
		return TabModule:SelectTab(Tab.Index)
	end

	task.spawn(function()
		local EmptyPageIcon
		if Tab.CustomEmptyPage.Icon then
			EmptyPageIcon =
				Creator.Image(Tab.CustomEmptyPage.Icon, Tab.CustomEmptyPage.Icon, 0, "Temp", "EmptyPage", true)
			EmptyPageIcon.Size =
				UDim2.fromOffset(Tab.CustomEmptyPage.IconSize or 48, Tab.CustomEmptyPage.IconSize or 48)
		end

		local Empty = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
			Parent = Tab.UIElements.ContainerFrame,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
				FillDirection = "Vertical",
			}),
			-- New("ImageLabel", {
			-- 	Size = UDim2.new(0, 48, 0, 48),
			-- 	Image = Creator.Icon("frown")[1],
			-- 	ImageRectOffset = Creator.Icon("frown")[2].ImageRectPosition,
			-- 	ImageRectSize = Creator.Icon("frown")[2].ImageRectSize,
			-- 	ThemeTag = {
			-- 		ImageColor3 = "Icon",
			-- 	},
			-- 	BackgroundTransparency = 1,
			-- 	ImageTransparency = 0.6,
			-- }),
			EmptyPageIcon,
			Tab.CustomEmptyPage.Title and New("TextLabel", { -- Title
				AutomaticSize = "XY",
				Text = Tab.CustomEmptyPage.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 18,
				TextTransparency = 0.5,
				BackgroundTransparency = 1,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			}) or nil,
			Tab.CustomEmptyPage.Desc and New("TextLabel", { -- Desc
				AutomaticSize = "XY",
				Text = Tab.CustomEmptyPage.Desc,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 15,
				TextTransparency = 0.65,
				BackgroundTransparency = 1,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
			}) or nil,
		})

		-- Empty.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
		--     Empty.TextLabel.Size = UDim2.new(0,Empty.TextLabel.TextBounds.X,0,Empty.TextLabel.TextBounds.Y)
		-- end)

		local CreationConn
		CreationConn = Creator.AddSignal(Tab.UIElements.ContainerFrame.ChildAdded, function()
			Empty.Visible = false
			CreationConn:Disconnect()
		end)
	end)

	return Tab
end

function TabModule:OnChange(func)
	TabModule.OnChangeFunc = func
end

local function ApplyGoldenTabVisual(TabObject, Active)
	if not TabObject or not TabObject.Golden then
		return
	end

	local Label = TabObject.UIElements
		and TabObject.UIElements.Main
		and TabObject.UIElements.Main.Frame
		and TabObject.UIElements.Main.Frame.TextLabel
	if Label then
		Label.TextColor3 = Active and Color3.fromRGB(255, 244, 184) or Color3.fromRGB(255, 224, 120)
		Label.TextTransparency = Active and 0 or 0.12
	end

	local IconTarget = TabObject.UIElements and TabObject.UIElements.Icon and GetImageTarget(TabObject.UIElements.Icon)
	if IconTarget then
		IconTarget.ImageColor3 = TabObject.IconColor or Color3.fromRGB(255, 222, 105)
		IconTarget.ImageTransparency = Active and 0 or 0.08
	end

	local Outline = TabObject.UIElements and TabObject.UIElements.Main and TabObject.UIElements.Main.Outline
	if Outline then
		Outline.ImageColor3 = Active and Color3.fromRGB(255, 232, 132) or Color3.fromRGB(255, 214, 92)
		Outline.ImageTransparency = Active and 0.58 or 0.78
	end
end

local function ApplyTabMotionVisual(TabObject, Active)
	if not TabObject or not TabObject.UIElements or not TabObject.UIElements.Main then
		return
	end

	local Rail = TabObject.UIElements.Main.ActiveRail
	if Rail then
		if TabObject.Golden then
			Rail.ImageColor3 = Active and Color3.fromRGB(255, 232, 132) or Color3.fromRGB(255, 214, 92)
		end

		Motion.Play(Rail, "Switch", {
			Size = Active and UDim2.new(0, 3, 1, -12) or UDim2.new(0, 3, 0, 0),
			ImageTransparency = Active and 0.08 or 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabRail")
	end

	if not Active and TabObject.UIElements.Main.Frame then
		Motion.Play(TabObject.UIElements.Main.Frame, "Hover", {
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "TabHover")
	end
end

function TabModule:SelectTab(TabIndex)
	local SelectedTab = TabModule.Tabs[TabIndex]
	if SelectedTab and not SelectedTab.Locked and TabModule.SelectedTab ~= TabIndex then
		TabModule.SelectedTab = TabIndex

		for _, TabObject in next, TabModule.Tabs do
			if not TabObject.Locked then
				Creator.SetThemeTag(TabObject.UIElements.Main, {
					ImageTransparency = "TabBorderTransparency",
				}, 0.15)
				if TabObject.Border then
					Creator.SetThemeTag(TabObject.UIElements.Main.Outline, {
						ImageTransparency = "TabBorderTransparency",
					}, 0.15)
				end
				Creator.SetThemeTag(TabObject.UIElements.Main.Frame.TextLabel, {
					TextTransparency = "TabTextTransparency",
				}, 0.15)
				local IconTarget = TabObject.UIElements.Icon and GetImageTarget(TabObject.UIElements.Icon)
				if IconTarget and not TabObject.IconColor then
					Creator.SetThemeTag(IconTarget, {
						ImageTransparency = "TabIconTransparency",
					}, 0.15)
				end
				TabObject.Selected = false
				ApplyGoldenTabVisual(TabObject, false)
				ApplyTabMotionVisual(TabObject, false)
			end
		end
		Creator.SetThemeTag(SelectedTab.UIElements.Main, {
			ImageColor3 = "TabBackgroundActive",
			ImageTransparency = "TabBackgroundActiveTransparency",
		}, 0.15)
		if SelectedTab.Border then
			Creator.SetThemeTag(SelectedTab.UIElements.Main.Outline, {
				ImageTransparency = "TabBorderTransparencyActive",
			}, 0.15)
		end
		Creator.SetThemeTag(SelectedTab.UIElements.Main.Frame.TextLabel, {
			TextTransparency = "TabTextTransparencyActive",
		}, 0.15)
		local SelectedIconTarget = SelectedTab.UIElements.Icon and GetImageTarget(SelectedTab.UIElements.Icon)
		if SelectedIconTarget and not SelectedTab.IconColor then
			Creator.SetThemeTag(SelectedIconTarget, {
				ImageTransparency = "TabIconTransparencyActive",
			}, 0.15)
		end
		SelectedTab.Selected = true
		ApplyGoldenTabVisual(SelectedTab, true)
		ApplyTabMotionVisual(SelectedTab, true)

		task.spawn(function()
			local SelectedContainer = TabModule.Containers[TabIndex]
			for _, ContainerObject in next, TabModule.Containers do
				if ContainerObject ~= SelectedContainer then
					ContainerObject.AnchorPoint = Vector2.new(0, 0.035)
					ContainerObject.GroupTransparency = 1
					ContainerObject.Visible = false
				end
			end
			SelectedContainer.AnchorPoint = Vector2.new(0, 0.035)
			SelectedContainer.GroupTransparency = 1
			SelectedContainer.Visible = true
			Motion.Play(SelectedContainer, "Switch", {
				AnchorPoint = Vector2.new(0, 0),
				GroupTransparency = 0,
			}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, "Select")
		end)

		TabModule.OnChangeFunc(TabIndex)
	end
end

return TabModule

-- ── VYNX PATCH — Obsidian-style Groupbox API ────────────────────────────────
-- Appended by VYNX UI merger

local _VynxOrig_TabNew = TabModule.New
TabModule.New = function(Config, UIScale)
	local Tab = _VynxOrig_TabNew(Config, UIScale)

	-- Tab:AddLeftGroupbox(Title) / Tab:AddRightGroupbox(Title) / Tab:AddGroupbox(Title)
	-- Obsidian layout: two-column (Left/Right) inside a ScrollingFrame
	-- VYNX maps these to WindUI Sections inside an HStack layout

	local function MakeGroupbox(Title, Side)
		local GroupboxConfig = {
			Title  = Title or "",
			Parent = Tab.UIElements.ContainerFrame,
		}
		local ElementsModule = require("../elements/Init")
		local section = ElementsModule.Elements.Section:New(
			GroupboxConfig,
			Tab.UIElements.ContainerFrame,
			Window and Window.Folder or "VynxUI",
			UIScale or 1,
			Window or {}
		)
		-- Attach element API (both styles)
		ElementsModule.Load(
			section,
			section.UIElements and section.UIElements.Content or section.ContentFrame or Tab.UIElements.ContainerFrame,
			ElementsModule.Elements,
			Window or {},
			WindUI or {},
			nil,
			ElementsModule,
			UIScale or 1,
			Tab
		)
		-- Obsidian compat fields
		section.Tab      = Tab
		section.BoxHolder = Tab.UIElements.ContainerFrame
		section.__type   = "Groupbox"
		section.Destroyed= false
		section.Elements = section.Elements or {}
		section.DependencyBoxes = {}
		return section
	end

	function Tab:AddLeftGroupbox(Title)  return MakeGroupbox(Title, "Left")  end
	function Tab:AddRightGroupbox(Title) return MakeGroupbox(Title, "Right") end
	function Tab:AddGroupbox(Title)      return MakeGroupbox(Title, "Full")  end

	-- Obsidian alias: Tab:AddTab(Title, Icon) → Tab:Select() equivalent already exists
	-- WindUI already has Tab.Select(), so we just alias CreateTab→Tab on the window level

	return Tab
end
