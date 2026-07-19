local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local Checkbox = {
		__type    = "Checkbox",
		Type      = "Checkbox",
		Title     = Config.Title or Config.Text or "Checkbox",
		Value     = Config.Default ~= nil and Config.Default or false,
		Locked    = Config.Locked or false,
		Callback  = Config.Callback or function() end,
		OnChanged = Instance.new("BindableEvent"),
		UIElements = {},
	}

	local Frame = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 28),
		Parent = Config.Parent,
	})

	local Box = New("Frame", {
		AnchorPoint      = Vector2.new(0, 0.5),
		Position         = UDim2.new(0, 0, 0.5, 0),
		Size             = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Color3.fromHex("#2A2A38"),
		Parent           = Frame,
	}, {
		New("UICorner", { CornerRadius = UDim.new(0, 4) }),
		New("UIStroke", { Color = Color3.fromHex("#2a2a3a"), Thickness = 1 }),
	})

	local Check = New("ImageLabel", {
		Size                 = UDim2.fromScale(0.75, 0.75),
		AnchorPoint          = Vector2.new(0.5, 0.5),
		Position             = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Image                = "rbxassetid://97682394690683",
		ImageColor3          = Color3.new(1, 1, 1),
		ImageTransparency    = 1,
		Parent               = Box,
	})

	New("TextLabel", {
		AnchorPoint          = Vector2.new(0, 0.5),
		Position             = UDim2.new(0, 24, 0.5, 0),
		Size                 = UDim2.new(1, -24, 1, 0),
		BackgroundTransparency = 1,
		Text                 = Checkbox.Title,
		TextColor3           = Color3.new(1, 1, 1),
		TextTransparency     = 0.35,
		TextSize             = 13,
		TextXAlignment       = Enum.TextXAlignment.Left,
		FontFace             = Font.fromEnum(Enum.Font.GothamSsm),
		Parent               = Frame,
	})

	local Hit = New("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text                 = "",
		ZIndex               = 5,
		Parent               = Frame,
	})

	local function UpdateVisual(v)
		Box.BackgroundColor3 = v and Color3.fromHex("#7C5CFF") or Color3.fromHex("#2A2A38")
		Check.ImageTransparency = v and 0 or 1
	end

	UpdateVisual(Checkbox.Value)

	Hit.MouseButton1Click:Connect(function()
		if Checkbox.Locked then return end
		Checkbox.Value = not Checkbox.Value
		UpdateVisual(Checkbox.Value)
		Checkbox.Callback(Checkbox.Value)
		Checkbox.OnChanged:Fire(Checkbox.Value)
	end)

	function Checkbox:SetValue(v)
		Checkbox.Value = v
		UpdateVisual(v)
	end

	function Checkbox:Destroy()
		Frame:Destroy()
		Checkbox.OnChanged:Destroy()
	end

	Checkbox.UIElements.Frame = Frame
	Checkbox.ElementFrame     = Frame
	return Frame, Checkbox
end

return Element
