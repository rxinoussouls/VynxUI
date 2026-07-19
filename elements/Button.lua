local Creator = require("../modules/Creator")
local New = Creator.New
local UserInputService = game:GetService("UserInputService")

local Element = {}

local function NormalizeKey(Value)
	if typeof(Value) == "EnumItem" then
		return Value.Name, Value
	end
	if typeof(Value) == "string" and Enum.KeyCode[Value] then
		return Value, Enum.KeyCode[Value]
	end
	return nil, nil
end

local function GetImageTarget(Object)
	if typeof(Object) ~= "Instance" then
		return nil
	end

	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return Object
	end

	return Object:FindFirstChildWhichIsA("ImageLabel", true) or Object:FindFirstChildWhichIsA("ImageButton", true)
end

function Element:New(Config)
	local KeybindName, KeybindCode =
		NormalizeKey(Config.Keybind or Config.KeyBind or Config.Shortcut or Config.Bind or Config.Hotkey)
	local Button = {
		__type = "Button",
		Title = Config.Title or "Button",
		Desc = Config.Desc or nil,
		Icon = Config.Icon or "mouse-pointer-click",
		IconThemed = Config.IconThemed or false,
		IconColor = Config.IconColor or nil,
		Color = Config.Color,
		Justify = Config.Justify or "Between",
		IconAlign = Config.IconAlign or "Right",
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Golden = Config.Golden == true or Config.Premium == true,
		Premium = Config.Premium == true or Config.Golden == true,
		Keybind = KeybindName,
		KeyCode = KeybindCode,
		Callback = Config.Callback or function() end,
		UIElements = {},
	}

	local CanCallback = true

	Button.ButtonFrame = require("./components/window/Element")({
		Title = Button.Title,
		Desc = Button.Desc,
		Parent = Config.Parent,
		-- Image = Config.Image,
		-- ImageSize = Config.ImageSize,
		-- Thumbnail = Config.Thumbnail,
		-- ThumbnailSize = Config.ThumbnailSize,
		Window = Config.Window,
		Color = Button.Color,
		Justify = Button.Justify,
		TextOffset = 20,
		Hover = true,
		Scalable = true,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Button,
		ParentConfig = Config,
		Size = Config.Size,
		Tags = Config.Tags,
		Golden = Button.Golden,
		Premium = Button.Premium,
	})

	-- Button.UIElements.ButtonIcon = New("ImageLabel",{
	--     Image = Creator.Icon("mouse-pointer-click")[1],
	--     ImageRectOffset = Creator.Icon("mouse-pointer-click")[2].ImageRectPosition,
	--     ImageRectSize = Creator.Icon("mouse-pointer-click")[2].ImageRectSize,
	--     BackgroundTransparency = 1,
	--     Parent = Button.ButtonFrame.UIElements.Main,
	--     Size = UDim2.new(0,20,0,20),
	--     AnchorPoint = Vector2.new(1,0.5),
	--     Position = UDim2.new(1,0,0.5,0),
	--     ThemeTag = {
	--         ImageColor3 = "Text"
	--     }
	-- })
	Button.UIElements.ButtonIcon = Creator.Image(
		Button.Icon,
		Button.Icon,
		0,
		Config.Window.Folder,
		"Button",
		not (Button.Color or Button.IconColor) and true or nil,
		Button.IconThemed
	)

	Button.UIElements.ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
	Button.UIElements.ButtonIcon.Parent = Button.Justify == "Between" and Button.ButtonFrame.UIElements.Main
		or Button.ButtonFrame.UIElements.Container.TitleFrame
	Button.UIElements.ButtonIcon.LayoutOrder = Button.IconAlign == "Left" and -99999 or 99999
	Button.UIElements.ButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
	Button.UIElements.ButtonIcon.Position = UDim2.new(1, 0, 0.5, 0)

	local ButtonIconTarget = GetImageTarget(Button.UIElements.ButtonIcon)
	if ButtonIconTarget then
		if Button.IconColor then
			ButtonIconTarget.ImageColor3 = Button.IconColor
		elseif Button.Golden then
			ButtonIconTarget.ImageColor3 = Color3.fromRGB(255, 222, 105)
		end
		Button.ButtonFrame:Colorize(ButtonIconTarget, "ImageColor3")
	end

	function Button:Lock()
		Button.Locked = true
		CanCallback = false
		return Button.ButtonFrame:Lock(Button.LockedTitle)
	end
	function Button:Unlock()
		Button.Locked = false
		CanCallback = true
		return Button.ButtonFrame:Unlock()
	end

	if Button.Locked then
		Button:Lock()
	end

	function Button:Press()
		if CanCallback then
			task.spawn(function()
				Creator.SafeCallback(Button.Callback)
			end)
		end
	end

	Creator.AddSignal(Button.ButtonFrame.UIElements.Main.MouseButton1Click, function()
		Button:Press()
	end)

	if Button.KeyCode then
		Creator.AddSignal(UserInputService.InputBegan, function(Input, GameProcessed)
			if GameProcessed or UserInputService:GetFocusedTextBox() then
				return
			end
			if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Button.KeyCode then
				Button:Press()
			end
		end)
	end

	return Button.__type, Button
end

return Element
