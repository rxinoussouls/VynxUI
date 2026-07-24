local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Creator = require("../../modules/Creator")
local Motion = require("../../modules/Motion")
local New = Creator.New
local NewRoundFrame = Creator.NewRoundFrame
local GoldenEffect = require("./GoldenEffect")

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))

local TagModule = require("../ui/Tag")

local function Color3ToHSB(color)
	local r, g, b = color.R, color.G, color.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h = 0
	if delta ~= 0 then
		if max == r then
			h = (g - b) / delta % 6
		elseif max == g then
			h = (b - r) / delta + 2
		else
			h = (r - g) / delta + 4
		end
		h = h * 60
	else
		h = 0
	end

	local s = (max == 0) and 0 or (delta / max)
	local v = max

	return {
		h = math.floor(h + 0.5),
		s = s,
		b = v,
	}
end

local function GetPerceivedBrightness(color)
	local r = color.R
	local g = color.G
	local b = color.B
	return 0.299 * r + 0.587 * g + 0.114 * b
end

local function GetTextColorForHSB(color)
	local hsb = Color3ToHSB(color)
	local h, s, b = hsb.h, hsb.s, hsb.b
	if GetPerceivedBrightness(color) > 0.5 then
		return Color3.fromHSV(h / 360, 0, 0.05)
	else
		return Color3.fromHSV(h / 360, 0, 0.98)
	end
end

local function Coalesce(...)
	for i = 1, select("#", ...) do
		local Value = select(i, ...)
		if Value ~= nil then
			return Value
		end
	end
	return nil
end

return function(Config)
	local Element = {
		Title = Config.Title,
		Desc = Config.Desc or nil,
		Hover = Config.Hover,
		Thumbnail = Config.Thumbnail,
		ThumbnailSize = Config.ThumbnailSize or 80,
		Image = Config.Image,
		IconThemed = Config.IconThemed or false,
		ImageSize = Config.ImageSize or 30,
		Color = Config.Color,
		Scalable = Config.Scalable,
		Parent = Config.Parent,
		Justify = Config.Justify or "Between", -- Center or Between
		UIPadding = Config.Window.ElementConfig.UIPadding,
		UICorner = Config.Window.ElementConfig.UICorner,
		Transparency = Coalesce(
			Config.Transparency,
			Config.ParentConfig and Config.ParentConfig.Transparency,
			Config.ParentConfig and Config.ParentConfig.ElementTransparency,
			Config.Window.ElementConfig.Transparency
		),
		GlassTransparency = Coalesce(
			Config.GlassTransparency,
			Config.ParentConfig and Config.ParentConfig.GlassTransparency,
			Config.Window.ElementConfig.GlassTransparency
		),
		LiquidGlass = Coalesce(
			Config.LiquidGlass,
			Config.ParentConfig and Config.ParentConfig.LiquidGlass,
			Config.ParentConfig and Config.ParentConfig.GlassLiquid,
			Config.Window.ElementConfig.LiquidGlass
		),
		Golden = Config.Golden == true
			or Config.Premium == true
			or (Config.ParentConfig and (Config.ParentConfig.Golden == true or Config.ParentConfig.Premium == true)),
		CornerStyle = Coalesce(
			Config.CornerStyle,
			Config.ParentConfig and Config.ParentConfig.CornerStyle,
			Config.ParentConfig and Config.ParentConfig.ElementCornerStyle,
			Config.Window.ElementConfig.CornerStyle
		),
		Size = Config.Size or "Default", -- Small, Default, Large
		Tags = Config.Tags or {},
		UIElements = {},

		Index = Config.Index,
		LinkCorners = Config.LinkCorners,
		CornerGroup = Config.CornerGroup or Config.LinkCornerGroup,
		CornerBreak = Config.CornerBreak,
		CornerBreakBefore = Config.CornerBreakBefore,
		CornerBreakAfter = Config.CornerBreakAfter,
	}

	local AddPaddingX = Element.Size == "Small" and -4 or Element.Size == "Large" and 4 or 0
	local AddPaddingY = Element.Size == "Small" and -4 or Element.Size == "Large" and 4 or 0

	local ImageSize = Element.ImageSize
	local ThumbnailSize = Element.ThumbnailSize
	local CanHover = true
	local Hovering = false
	local UseNativeCorners = Element.CornerStyle == "Native" or Element.CornerStyle == "PerCorner"
	local ElementTransparency = Creator.ClampTransparency(Element.Transparency, nil)
	local NativeBackground
	local NativeBackgroundCorner
	local NativeLiquidSheen
	local NativeLayerCorners = {}
	local CurrentCorners = {
		TopLeft = true,
		TopRight = true,
		BottomLeft = true,
		BottomRight = true,
	}

	local IconOffset = 0

	local function NewLayerCorner()
		local Corner = New("UICorner", {
			CornerRadius = UDim.new(0, Element.UICorner),
		})
		table.insert(NativeLayerCorners, Corner)
		return Corner
	end

	local ThumbnailFrame
	local ImageFrame
	if Element.Thumbnail then
		ThumbnailFrame = Creator.Image(
			Element.Thumbnail,
			Element.Title,
			Config.Window.NewElements and Element.UICorner - 11 or (Element.UICorner - 4),
			Config.Window.Folder,
			"Thumbnail",
			false,
			Element.IconThemed
		)
		ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
	end
	if Element.Image then
		ImageFrame = Creator.Image(
			Element.Image,
			Element.Title,
			Config.Window.NewElements and Element.UICorner - 11 or (Element.UICorner - 4),
			Config.Window.Folder,
			"Image",
			Element.IconThemed,
			not Element.Color and true or false,
			"ElementIcon"
		)
		--print(Creator.Colors[Element.Color])
		if typeof(Element.Color) == "string" and not string.find(Element.Image, "rbxthumb") then
			ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
		elseif typeof(Element.Color) == "Color3" and not string.find(Element.Image, "rbxthumb") then
			ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
		end

		ImageFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)

		IconOffset = ImageSize
	end

	local function CreateText(Title, Type)
		local TextColor = typeof(Element.Color) == "string"
				and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
			or typeof(Element.Color) == "Color3" and GetTextColorForHSB(Element.Color)

		return New("TextLabel", {
			BackgroundTransparency = 1,
			Text = Title or "",
			TextSize = Type == "Desc" and 15 or 17,
			TextXAlignment = "Left",
			ThemeTag = {
				TextColor3 = not Element.Color and ("Element" .. Type) or nil,
			},
			TextColor3 = Element.Color and TextColor or nil,
			TextTransparency = Type == "Desc" and 0.3 or 0,
			TextWrapped = true,
			Size = UDim2.new(Element.Justify == "Between" and 1 or 0, 0, 0, 0),
			AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
			FontFace = Font.new(Creator.Font, Type == "Desc" and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
		})
	end

	local Title = CreateText(Element.Title, "Title")
	local Desc = CreateText(Element.Desc, "Desc")
	if not Element.Title or Element.Title == "" then
		Desc.Visible = false
	end
	if not Element.Desc or Element.Desc == "" then
		Desc.Visible = false
	end

	Element.UIElements.Title = Title
	Element.UIElements.Desc = Desc

	Element.UIElements.Container = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Element.UIPadding),
			FillDirection = "Vertical",
			VerticalAlignment = "Center",
			HorizontalAlignment = Element.Justify == "Between" and "Left" or "Center",
		}),
		ThumbnailFrame,
		New("Frame", {
			Size = UDim2.new(
				Element.Justify == "Between" and 1 or 0,
				Element.Justify == "Between" and -Config.TextOffset or 0,
				0,
				0
			),
			AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
			BackgroundTransparency = 1,
			Name = "TitleFrame",
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, Element.UIPadding),
				FillDirection = "Horizontal",
				VerticalAlignment = Config.Window.NewElements and (Element.Justify == "Between" and "Top" or "Center")
					or "Center",
				HorizontalAlignment = Element.Justify ~= "Between" and Element.Justify or "Center",
			}),
			ImageFrame,
			New("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
				Size = UDim2.new(
					Element.Justify == "Between" and 1 or 0,
					Element.Justify == "Between" and (ImageFrame and -IconOffset - Element.UIPadding or -IconOffset)
						or 0,
					1,
					0
				),
				Name = "TitleFrame",
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingY),
					PaddingLeft = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingX),
					PaddingRight = UDim.new(
						0,
						(Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingX
					),
					PaddingBottom = UDim.new(
						0,
						(Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingY
					),
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = "Vertical",
					VerticalAlignment = "Center",
					HorizontalAlignment = "Left",
				}),
				New("ScrollingFrame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					LayoutOrder = -99,
					BackgroundTransparency = 1,
					ScrollingDirection = "X",
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ScrollBarThickness = 0,
					Visible = false,
				}, {
					New("UIListLayout", {
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
						HorizontalAlignment = "Left",
						Padding = UDim.new(0, Config.Window.UIPadding / 2),
					}),
				}),
				New("Frame", {
					Name = "Space",
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Visible = false,
				}),
				Title,
				Desc,
			}),
		}),
	})

	for _, TagConfig in next, Config.Tags or {} do
		if not Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible then
			Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible = true
			Element.UIElements.Container.TitleFrame.TitleFrame.Space.Visible = true
		end
		local Tag = TagModule:New(TagConfig, Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame)
	end

	Creator.AddSignal(
		Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout:GetPropertyChangedSignal(
			"AbsoluteContentSize"
		),
		function()
			Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Size = UDim2.new(
				1,
				0,
				0,
				Element.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y
					/ Config.ParentConfig.UIScale
			)
		end
	)

	-- print(Config.Tab.Elements)
	-- print(Config.Index)
	-- print("Squircle")

	local LockedIcon = Creator.Image("lock", "lock", 0, Config.Window.Folder, "Lock", false)
	LockedIcon.Size = UDim2.new(0, 20, 0, 20)
	LockedIcon.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
	LockedIcon.ImageLabel.ImageTransparency = 0.4

	local LockedTitle = New("TextLabel", {
		Text = "Locked",
		TextSize = 18,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0.05,
	})

	local ElementFullFrame = New("Frame", {
		Size = UDim2.new(1, Element.UIPadding * 2, 1, Element.UIPadding * 2),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ZIndex = 9999999,
	})

	local Locked, LockedTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 0.25,
		ImageColor3 = Color3.new(0, 0, 0),
		Visible = false,
		Active = false,
		Parent = ElementFullFrame,
	}, {
		NewLayerCorner(),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
		LockedIcon,
		LockedTitle,
	}, nil, true)

	local HighlightOutline, HighlightOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.25
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local Highlight, HighlightTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.88
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		NewLayerCorner(),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local HoverOutline, HoverOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.25
		Visible = false,
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
		New("UIGradient", {
			Name = "HoverGradient",
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.25, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.75, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	}, nil, true)

	local Hover, HoverTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- 0.88
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		NewLayerCorner(),
		New("UIGradient", {
			Name = "HoverGradient",
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.25, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.75, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local function GetElementColor()
		if typeof(Element.Color) == "string" then
			return Color3.fromHex(Creator.Colors[Element.Color])
		end
		if typeof(Element.Color) == "Color3" then
			return Element.Color
		end
		return nil
	end

	local function GetBackgroundTransparency()
		if ElementTransparency ~= nil then
			return ElementTransparency
		end
		if Element.LiquidGlass then
			return Creator.ClampTransparency(Element.GlassTransparency, 0.24)
		end
		if Element.Color then
			return 0.05
		end
		if not Config.Window.NewElements then
			return 0.93
		end
		return nil
	end

	local function ApplyNativeCorners(Corners)
		CurrentCorners = Corners or CurrentCorners
		if NativeBackgroundCorner then
			Creator.ApplyCornerRadii(NativeBackgroundCorner, UDim.new(0, Element.UICorner), CurrentCorners)
		end
		for _, Corner in NativeLayerCorners do
			Creator.ApplyCornerRadii(Corner, UDim.new(0, Element.UICorner), CurrentCorners)
		end
	end

	local function CreateLiquidGlassChildren()
		if not Element.LiquidGlass then
			return {}
		end

		NativeLiquidSheen = New("UIGradient", {
			Rotation = 25,
			Offset = Vector2.new(-0.35, 0),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.45, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.94),
				NumberSequenceKeypoint.new(0.45, 0.78),
				NumberSequenceKeypoint.new(1, 0.98),
			}),
		})

		return {
			New("UIStroke", {
				ApplyStrokeMode = "Border",
				Thickness = 1,
				Color = Color3.new(1, 1, 1),
				Transparency = 0.88,
			}),
			NativeLiquidSheen,
		}
	end

	local function CreateNativeBackground()
		NativeBackgroundCorner = New("UICorner", {
			CornerRadius = UDim.new(0, Element.UICorner),
		})

		local Children = {
			NativeBackgroundCorner,
		}

		for _, Child in next, CreateLiquidGlassChildren() do
			table.insert(Children, Child)
		end

		return New("Frame", {
			Name = "NativeBackground",
			Size = UDim2.new(1, Element.UIPadding * 2, 1, Element.UIPadding * 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = GetElementColor() or nil,
			BackgroundTransparency = GetBackgroundTransparency() or 0,
			ThemeTag = not Element.Color and {
				BackgroundColor3 = "ElementBackground",
				BackgroundTransparency = ElementTransparency == nil
						and not Element.LiquidGlass
						and "ElementBackgroundTransparency"
					or nil,
			} or nil,
			ZIndex = 0,
			Active = false,
		}, Children)
	end

	local MainChildren = {}
	if UseNativeCorners then
		NativeBackground = CreateNativeBackground()
		table.insert(MainChildren, NativeBackground)
	end

	table.insert(MainChildren, Element.UIElements.Container)
	table.insert(MainChildren, ElementFullFrame)
	table.insert(
		MainChildren,
		New("UIPadding", {
			PaddingTop = UDim.new(0, Element.UIPadding),
			PaddingLeft = UDim.new(0, Element.UIPadding),
			PaddingRight = UDim.new(0, Element.UIPadding),
			PaddingBottom = UDim.new(0, Element.UIPadding),
		})
	)

	local Main, MainTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		ImageTransparency = UseNativeCorners and 1 or GetBackgroundTransparency(),
		--Text = "",
		--TextTransparency = 1,
		--AutoButtonColor = false,
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = not UseNativeCorners
					and not Element.Color
					and (Config.Window.NewElements and "ElementBackground" or "Text")
				or nil,
			ImageTransparency = not UseNativeCorners
					and not Element.Color
					and ElementTransparency == nil
					and not Element.LiquidGlass
					and (Config.Window.NewElements and "ElementBackgroundTransparency" or nil)
				or nil,
		},
		ImageColor3 = not UseNativeCorners and GetElementColor() or nil,
	}, MainChildren, true, true)

	Element.UIElements.Main = Main
	Element.UIElements.Locked = Locked
	ApplyNativeCorners(CurrentCorners)

	if Element.Golden then
		Element.UIElements.GoldenEffect = GoldenEffect.Apply(ElementFullFrame, {
			Corner = Element.UICorner,
			Compact = Element.Size == "Small",
			FillTransparency = 0.8,
			OutlineTransparency = 0.18,
			SheenTransparency = 0.82,
		})

		Title.TextColor3 = Color3.fromRGB(255, 232, 144)
		Desc.TextColor3 = Color3.fromRGB(255, 224, 138)
		Desc.TextTransparency = math.min(Desc.TextTransparency + 0.08, 0.72)
	end

	if Element.Hover then
		Creator.AddSignal(Main.MouseMoved, function(x, y)
			if CanHover and Main.AbsoluteSize.X > 0 then
				Hover.HoverGradient.Offset = Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
				HoverOutline.HoverGradient.Offset =
					Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
				if NativeLiquidSheen then
					NativeLiquidSheen.Offset =
						Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
				end
			end
		end)

		Creator.AddSignal(Main.MouseEnter, function()
			if CanHover then
				--Tween(Main, 0.12, { ImageTransparency = Element.Color and 0.15 or 0.9 }):Play()
				HoverOutline.Visible = true
				Motion.Play(
					Hover,
					"Hover",
					{ ImageTransparency = 0.9 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				Motion.Play(
					HoverOutline,
					"Hover",
					{ ImageTransparency = 0.8 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				if NativeBackground and Element.LiquidGlass then
					Motion.Play(NativeBackground, "Hover", {
						BackgroundTransparency = math.max(
							(ElementTransparency or Element.GlassTransparency or 0.24) - 0.06,
							0
						),
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Hover")
				end
			end
		end)
		Creator.AddSignal(Main.InputEnded, function()
			if CanHover then
				--Tween(Main, 0.12, { ImageTransparency = Element.Color and 0.05 or 0.93 }):Play()
				Motion.Play(
					Hover,
					"Hover",
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				Motion.Play(
					HoverOutline,
					"Hover",
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				if NativeBackground and Element.LiquidGlass then
					Motion.Play(
						NativeBackground,
						"Hover",
						{ BackgroundTransparency = GetBackgroundTransparency() or 0 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"Hover"
					)
				end
			end
		end)
		Creator.AddSignal(Main.MouseLeave, function()
			if CanHover then
				Motion.Play(
					Hover,
					"Hover",
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				Motion.Play(
					HoverOutline,
					"Hover",
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out,
					"Hover"
				)
				if NativeBackground and Element.LiquidGlass then
					Motion.Play(
						NativeBackground,
						"Hover",
						{ BackgroundTransparency = GetBackgroundTransparency() or 0 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out,
						"Hover"
					)
				end
			end
		end)
	end

	if Element.Scalable then
		Motion.AttachPress(Main, Creator, {
			Amount = 0.985,
			Enabled = function()
				return CanHover
			end,
		})
	end

	function Element:SetTitle(text)
		Element.Title = text
		Title.Text = text
	end

	function Element:SetDesc(text)
		Element.Desc = text
		Desc.Text = text or ""
		if not text then
			Desc.Visible = false
		elseif not Desc.Visible then
			Desc.Visible = true
		end
	end

	function Element:SetTransparency(value)
		ElementTransparency = Creator.ClampTransparency(value, ElementTransparency or 0)
		Element.Transparency = ElementTransparency

		if NativeBackground then
			Motion.Play(
				NativeBackground,
				"Focus",
				{ BackgroundTransparency = ElementTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"ElementTransparency"
			)
		else
			Motion.Play(
				Main,
				"Focus",
				{ ImageTransparency = ElementTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"ElementTransparency"
			)
		end
	end

	function Element:SetLiquidGlass(value)
		Element.LiquidGlass = value == true
		if NativeBackground then
			for _, Child in next, NativeBackground:GetChildren() do
				if Child:IsA("UIStroke") or Child:IsA("UIGradient") then
					pcall(function()
						Child.Enabled = Element.LiquidGlass
					end)
				end
			end
			if ElementTransparency == nil then
				NativeBackground.BackgroundTransparency = GetBackgroundTransparency() or 0
			end
		end
	end

	function Element:Colorize(obj, prop)
		if Element.Color then
			obj[prop] = typeof(Element.Color) == "string"
					and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
				or typeof(Element.Color) == "Color3" and GetTextColorForHSB(Element.Color)
				or nil
		end
	end

	if Config.ElementTable then
		Creator.AddSignal(Title:GetPropertyChangedSignal("Text"), function()
			if Element.Title ~= Title.Text then
				Element:SetTitle(Title.Text)
				Config.ElementTable.Title = Title.Text
			end
		end)
		Creator.AddSignal(Desc:GetPropertyChangedSignal("Text"), function()
			if Element.Desc ~= Desc.Text then
				Element:SetDesc(Desc.Text)
				Config.ElementTable.Desc = Desc.Text
			end
		end)
	end

	-- function Element:Show()

	-- end

	function Element:SetThumbnail(newThumbnail, newSize)
		Element.Thumbnail = newThumbnail
		if newSize then
			Element.ThumbnailSize = newSize
			ThumbnailSize = newSize
		end

		if ThumbnailFrame then
			if newThumbnail then
				ThumbnailFrame:Destroy()
				ThumbnailFrame = Creator.Image(
					newThumbnail,
					Element.Title,
					Element.UICorner - 3,
					Config.Window.Folder,
					"Thumbnail",
					false,
					Element.IconThemed
				)
				if ThumbnailFrame then
					ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
					ThumbnailFrame.Parent = Element.UIElements.Container
					local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
					if layout then
						ThumbnailFrame.LayoutOrder = -1
					end
				end
			else
				ThumbnailFrame.Visible = false
			end
		else
			if newThumbnail then
				ThumbnailFrame = Creator.Image(
					newThumbnail,
					Element.Title,
					Element.UICorner - 3,
					Config.Window.Folder,
					"Thumbnail",
					false,
					Element.IconThemed
				)
				if ThumbnailFrame then
					ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
					ThumbnailFrame.Parent = Element.UIElements.Container
					local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
					if layout then
						ThumbnailFrame.LayoutOrder = -1
					end
				end
			end
		end
	end

	function Element:SetImage(newImage, newSize)
		Element.Image = newImage
		if newSize then
			Element.ImageSize = newSize
			ImageSize = newSize
		end

		if newImage then
			local OldImageParent = ImageFrame and ImageFrame.Parent or Element.UIElements.Container.TitleFrame
			if ImageFrame then
				ImageFrame:Destroy()
			end

			ImageFrame = Creator.Image(
				newImage,
				newImage,
				Element.UICorner - 3,
				Config.Window.Folder,
				"Image",
				not Element.Color and true or false
			)
			if ImageFrame then
				if typeof(Element.Color) == "string" and not string.find(Element.Image, "rbxthumb") then
					ImageFrame.ImageLabel.ImageColor3 =
						GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
				elseif typeof(Element.Color) == "Color3" and not string.find(Element.Image, "rbxthumb") then
					ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
				end

				ImageFrame.Visible = true
				ImageFrame.Parent = OldImageParent
				ImageFrame.LayoutOrder = -99

				ImageFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)
				IconOffset = Element.ImageSize + Element.UIPadding
			end
		else
			if ImageFrame then
				ImageFrame.Visible = true
			end
			IconOffset = 0
		end

		Element.UIElements.Container.TitleFrame.TitleFrame.Size = UDim2.new(1, -IconOffset, 1, 0)
	end

	function Element:Destroy()
		Main:Destroy()
	end

	function Element:Lock(newtitle)
		CanHover = false
		Locked.Active = true
		Locked.Visible = true
		LockedTitle.Text = newtitle or "Locked"
	end

	function Element:Unlock()
		CanHover = true
		Locked.Active = false
		Locked.Visible = false
	end

	function Element:Highlight()
		local OutlineGradient = New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.9, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Rotation = 0,
			Offset = Vector2.new(-1, 0),
			Parent = HighlightOutline,
		})

		local HighlightGradient = New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.15, 0.8),
				NumberSequenceKeypoint.new(0.5, 0.1),
				NumberSequenceKeypoint.new(0.85, 0.8),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Rotation = 0,
			Offset = Vector2.new(-1, 0),
			Parent = Highlight,
		})

		HighlightOutline.ImageTransparency = 0.65
		Highlight.ImageTransparency = 0.88

		Motion.Play(OutlineGradient, "Highlight", {
			Offset = Vector2.new(1, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Highlight")

		Motion.Play(HighlightGradient, "Highlight", {
			Offset = Vector2.new(1, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "Highlight")

		task.spawn(function()
			task.wait(Motion.GetDuration("Highlight"))
			HighlightOutline.ImageTransparency = 1
			Highlight.ImageTransparency = 1
			OutlineGradient:Destroy()
			HighlightGradient:Destroy()
		end)
	end

	function Element.UpdateShape(Tab)
		if Config.Window.NewElements then
			local ParentType = Config.ParentConfig
					and Config.ParentConfig.ParentTable
					and Config.ParentConfig.ParentTable.__type
				or Config.ParentType
			local ShouldLinkCorners = Element.LinkCorners ~= false
				and (
					Element.LinkCorners == true
					or Config.Window.ElementConfig.LinkCorners
					or (Config.ParentConfig and Config.ParentConfig.LinkCorners == true)
				)

			local newShape = "Squircle"
			local Metadata = { Position = "Single", Count = 1 }
			local corners = {
				TopLeft = true,
				TopRight = true,
				BottomLeft = true,
				BottomRight = true,
			}

			if ShouldLinkCorners then
				newShape, corners, Metadata = Creator.GetLinkedCornerShape(
					Tab.Elements,
					Element.Index,
					Tab,
					ParentType,
					Config.CornerLink
						or (Config.ParentConfig and Config.ParentConfig.CornerLink)
						or Config.Window.ElementConfig.CornerLink
				)
			end

			if newShape and Main then
				local UsesIndividualCorners = UseNativeCorners and Metadata.Count > 1
				local DynamicShape = if UsesIndividualCorners
					then "Square"
					else (newShape == "Squircle-TL-BL" or newShape == "Squircle-TR-BR") and "Squircle" or newShape

				MainTable:SetType(DynamicShape)
				LockedTable:SetType(DynamicShape)
				HighlightTable:SetType(DynamicShape)
				--HighlightOutlineTable:SetType(newShape .. "-Outline")
				HoverTable:SetType(DynamicShape)
				--HoverOutlineTable:SetType(newShape .. "-Outline")
				ApplyNativeCorners(corners)
			end
		end
	end

	--task.wait(.015)

	--Element:Show()

	return Element
end
