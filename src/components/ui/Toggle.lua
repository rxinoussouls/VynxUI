local Toggle = {}

local Creator = require("../../modules/Creator")
local Motion = require("../../modules/Motion")
local New = Creator.New

local UserInputService = game:GetService("UserInputService")

function Toggle.New(Value, Icon, IconSize, Parent, Callback, NewElement, Config)
	Config = if typeof(Config) == "table" then Config else {}

	local UseGlassSpritesheet = Config.GlassSpritesheet == true or Config.Spritesheet == true
	local UseDrag = Config.Drag == true or Config.Draggable == true or Config.Swipe == true
	local UseHoldAnimation = Config.HoldAnimation ~= false and Config.Hold ~= false
	local Control = {
		UseGlassSpritesheet = UseGlassSpritesheet,
		UseDrag = UseDrag,
		UseHoldAnimation = UseHoldAnimation,
		GlassSpritesheet = {
			Id = "rbxassetid://77297718671545",
			MirroredId = "rbxassetid://92258969882244",
			Size = Vector2.new(102, 128),
			Total = 80,
			Cols = 10,
		},
	}

	function Control:GetGlassFrame(T: number): (string, Vector2, Vector2)
		local Spritesheet = Control.GlassSpritesheet
		local Frame: number

		if T <= 0.4 then
			Frame = math.floor((T / 0.4) * (Spritesheet.Total - 1))
		elseif T < 0.6 then
			Frame = Spritesheet.Total - 1
		else
			Frame = math.floor(((T - 0.6) / 0.4) * (Spritesheet.Total - 1))
		end

		Frame = math.clamp(Frame, 0, Spritesheet.Total - 1)

		local Mirrored = T >= 0.6
		if Mirrored then
			Frame = (Spritesheet.Total - 1) - Frame
		end

		local Id = if Mirrored then Spritesheet.MirroredId else Spritesheet.Id
		return Id,
			Spritesheet.Size,
			Vector2.new(
				(Frame % Spritesheet.Cols) * Spritesheet.Size.X,
				math.floor(Frame / Spritesheet.Cols) * Spritesheet.Size.Y
			)
	end

	local Radius = 12
	local IconToggleFrame
	local IconData = if Icon and Icon ~= "" then Creator.Icon(Icon) else nil
	if IconData then
		local KnobIconSize = math.clamp(tonumber(IconSize) or 13, 10, NewElement and 16 or 13)
		IconToggleFrame = New("ImageLabel", {
			Size = UDim2.fromOffset(KnobIconSize, KnobIconSize),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = IconData[1],
			ImageRectOffset = IconData[2].ImageRectPosition,
			ImageRectSize = IconData[2].ImageRectSize,
			ImageTransparency = 1,
			ImageColor3 = Color3.new(0, 0, 0),
		})
	end

	local ToggleContainer = New("Frame", {
		Size = UDim2.new(0, 2, 0, 26),
		BackgroundTransparency = 1,
		Parent = Parent,
	})

	local ToggleFrame = Creator.NewRoundFrame(Radius, "Squircle", {
		ImageTransparency = 0.85,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ToggleContainer,
		Size = UDim2.new(0, NewElement and 52 or 41, 0, 24),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Name = "ToggleFrame",
	}, {
		Creator.NewRoundFrame(Radius, "Squircle", {
			Size = UDim2.fromScale(1, 1),
			Name = "Layer",
			ThemeTag = {
				ImageColor3 = "Toggle",
			},
			ImageTransparency = 1,
		}),
		Creator.NewRoundFrame(Radius, "SquircleOutline", {
			Size = UDim2.fromScale(1, 1),
			Name = "Stroke",
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 1,
		}, {
			New("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		}),
		Creator.NewRoundFrame(Radius, "Squircle", {
			Size = UDim2.new(0, NewElement and 30 or 20, 0, 20),
			Position = UDim2.new(0, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ImageTransparency = 1,
			Name = "Frame",
		}, {
			Creator.NewRoundFrame(Radius, "Squircle", {
				Size = UDim2.fromScale(1, 1),
				ImageTransparency = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Name = "Bar",
			}, {
				Creator.New("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Color3.new(1, 1, 1),
					Name = "Highlight",
					BackgroundTransparency = 1,
				}, {
					Creator.NewRoundFrame(9999, "SquircleGlass", {
						Size = UDim2.new(1, 1, 1, 1),
						ImageColor3 = Color3.new(1, 1, 1),
						Name = "SquircleGlass",
						ImageTransparency = 0.5,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
					}),
					Creator.NewRoundFrame(Radius, "Squircle", {
						Size = UDim2.fromScale(1, 1),
						Name = "GlassBackground",
						ImageTransparency = 0,
						ThemeTag = {
							ImageColor3 = "ElementBackground",
						},
						ZIndex = -1,
					}),
					New("ImageLabel", {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Name = "Glass",
						ImageTransparency = if UseGlassSpritesheet then 0.85 else 1,
						Visible = UseGlassSpritesheet,
					}, {
						New("UICorner", {
							CornerRadius = UDim.new(1, 0),
						}),
					}),
					Creator.NewRoundFrame(Radius, "Squircle", {
						Size = UDim2.fromScale(1, 1),
						Name = "BarOverlay",
						ThemeTag = {
							ImageColor3 = "ToggleBar",
						},
						ZIndex = 999,
					}),
				}),
				IconToggleFrame,
				New("UIScale", {
					Scale = 1,
				}),
			}),
		}),
		New("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Name = "Hitbox",
			Text = "",
		}),
	})

	local DragConnection
	local EndConnection
	local InputOwnerId
	local FrameWidth = if NewElement then 30 else 20
	local ToggleWidth = ToggleFrame.Size.X.Offset
	local RenderedValue

	local function SetGlassFrame(Percent)
		if not UseGlassSpritesheet then
			return
		end

		local Id, RectSize, RectOffset = Control:GetGlassFrame(Percent)
		local Glass = ToggleFrame.Frame.Bar.Highlight.Glass
		Glass.Image = Id
		Glass.ImageRectSize = RectSize
		Glass.ImageRectOffset = RectOffset
	end

	local function Render(Toggled, Instant)
		local TargetPosition = if Toggled
			then UDim2.new(0, ToggleWidth - FrameWidth - 2, 0.5, 0)
			else UDim2.new(0, 2, 0.5, 0)
		local LayerTransparency = if Toggled then 0 else 1
		local GlassTransparency = if Toggled then 0 else 0.85
		local IconTransparency = if Toggled then 0 else 1

		if UseGlassSpritesheet then
			Creator.SetThemeTag(
				ToggleFrame.Frame.Bar.Highlight.Glass,
				{ ImageColor3 = if Toggled then "Toggle" else "Text" },
				0.1
			)
			SetGlassFrame(if Toggled then 1 else 0)
		end

		if Instant then
			ToggleFrame.Frame.Position = TargetPosition
			ToggleFrame.Layer.ImageTransparency = LayerTransparency
			ToggleFrame.Frame.Bar.Highlight.Glass.ImageTransparency = GlassTransparency
			if IconToggleFrame then
				IconToggleFrame.ImageTransparency = IconTransparency
			end
			return
		end

		Motion.Play(
			ToggleFrame.Frame,
			"Select",
			{ Position = TargetPosition },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Position"
		)
		Motion.Play(ToggleFrame.Layer, "Select", { ImageTransparency = LayerTransparency }, nil, nil, "Layer")
		if UseGlassSpritesheet then
			Motion.Play(
				ToggleFrame.Frame.Bar.Highlight.Glass,
				"Select",
				{ ImageTransparency = GlassTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out,
				"Glass"
			)
		end
		if IconToggleFrame then
			Motion.Play(IconToggleFrame, "Select", { ImageTransparency = IconTransparency }, nil, nil, "Icon")
		end
	end

	function Control:Set(Toggled, IsCallback, Instant)
		Toggled = Toggled == true
		if RenderedValue ~= Toggled then
			RenderedValue = Toggled
			Render(Toggled, Instant == true)
		end

		if Callback and IsCallback ~= false then
			task.defer(function()
				Creator.SafeCallback(Callback, Toggled)
			end)
		end
	end

	function Control:BeginHold()
		if not UseHoldAnimation then
			return
		end

		Motion.Play(
			ToggleFrame.Frame.Bar.UIScale,
			"Focus",
			{ Scale = 1.22 },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Press"
		)
		Motion.Play(
			ToggleFrame.Frame.Bar.Highlight.BarOverlay,
			"Focus",
			{ ImageTransparency = 0.84 },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Press"
		)
	end

	function Control:EndHold()
		if not UseHoldAnimation then
			return
		end

		Motion.Play(
			ToggleFrame.Frame.Bar.UIScale,
			"Focus",
			{ Scale = 1 },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Press"
		)
		Motion.Play(
			ToggleFrame.Frame.Bar.Highlight.BarOverlay,
			"Focus",
			{ ImageTransparency = 0 },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			"Press"
		)
	end

	local function DisconnectDrag()
		if DragConnection then
			Creator.DisconnectSignal(DragConnection)
			DragConnection = nil
		end
		if EndConnection then
			Creator.DisconnectSignal(EndConnection)
			EndConnection = nil
		end
	end

	local function ReleaseOwnedInput()
		if Config.WindUI and InputOwnerId and Config.WindUI.CurrentInput == InputOwnerId then
			Config.WindUI.CurrentInput = nil
		end
		InputOwnerId = nil
	end

	function Control:Animate(Input, ToggleObject)
		if not UseDrag or not Config.Window or Config.Window.IsToggleDragging then
			return
		end

		Config.Window.IsToggleDragging = true
		InputOwnerId = Config.WindUI and Config.WindUI.CurrentInput or nil
		local StartMouseX = Input.Position.X
		local StartMouseY = Input.Position.Y
		local StartFrameX = ToggleFrame.Frame.Position.X.Offset
		local IsScrolling = false
		local HasDragged = false

		Control:BeginHold()

		DisconnectDrag()
		DragConnection = Creator.AddSignal(UserInputService.InputChanged, function(InputChanged)
			if not Config.Window.IsToggleDragging then
				return
			end
			if
				InputChanged.UserInputType ~= Enum.UserInputType.MouseMovement
				and InputChanged.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end
			if Input.UserInputType == Enum.UserInputType.Touch and InputChanged ~= Input then
				return
			end

			local DeltaX = math.abs(InputChanged.Position.X - StartMouseX)
			local DeltaY = math.abs(InputChanged.Position.Y - StartMouseY)
			if not HasDragged and DeltaY > 10 and DeltaY > DeltaX then
				IsScrolling = true
				return
			end
			if IsScrolling then
				return
			end
			if DeltaX > 6 then
				HasDragged = true
			end

			local MouseDelta = InputChanged.Position.X - StartMouseX
			local NewX = math.clamp(StartFrameX + MouseDelta, 2, ToggleWidth - FrameWidth - 2)
			local Percent = math.clamp((NewX - 2) / (ToggleWidth - FrameWidth - 4), 0, 1)

			SetGlassFrame(Percent)
			ToggleFrame.Frame.Position = UDim2.new(0, NewX, 0.5, 0)
		end)

		EndConnection = Creator.AddSignal(UserInputService.InputEnded, function(InputEnded)
			if not Config.Window.IsToggleDragging then
				return
			end
			local ReleasedTouch = Input.UserInputType == Enum.UserInputType.Touch and InputEnded == Input
			local ReleasedMouse = Input.UserInputType == Enum.UserInputType.MouseButton1
				and InputEnded.UserInputType == Enum.UserInputType.MouseButton1
			if not ReleasedTouch and not ReleasedMouse then
				return
			end

			Config.Window.IsToggleDragging = false
			DisconnectDrag()
			ReleaseOwnedInput()
			RenderedValue = nil

			if IsScrolling then
				ToggleObject:Set(ToggleObject.Value, false, false)
			elseif not HasDragged then
				ToggleObject:Set(not ToggleObject.Value, true, false)
			else
				local CurrentX = ToggleFrame.Frame.Position.X.Offset
				local NewValue = CurrentX + (FrameWidth / 2) > ToggleWidth / 2
				ToggleObject:Set(NewValue, true, false)
			end

			Control:EndHold()
		end)
	end

	function Control:Destroy()
		local WasDragging = InputOwnerId ~= nil or DragConnection ~= nil or EndConnection ~= nil
		DisconnectDrag()
		Control:EndHold()
		if WasDragging and Config.Window then
			Config.Window.IsToggleDragging = false
		end
		ReleaseOwnedInput()
	end

	Control:Set(Value, false, true)
	return ToggleContainer, Control
end

return Toggle
