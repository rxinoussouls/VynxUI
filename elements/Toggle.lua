local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween
local UserInputService = game:GetService("UserInputService")

local CreateToggle = require("./components/ui/Toggle").New
local CreateCheckbox = require("./components/ui/Checkbox").New

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

function Element:New(Config)
	local KeybindName, KeybindCode =
		NormalizeKey(Config.Keybind or Config.KeyBind or Config.Shortcut or Config.Bind or Config.Hotkey)
	local Toggle = {
		__type = "Toggle",
		Title = Config.Title or "Toggle",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Value = Config.Value,
		Icon = Config.Icon or nil,
		IconSize = Config.IconSize or 23, -- from 26 to 0
		Type = Config.Type or "Toggle",
		Keybind = KeybindName,
		KeyCode = KeybindCode,
		Callback = Config.Callback or function() end,
		UIElements = {},
	}
	Toggle.ToggleFrame = require("./components/window/Element")({
		Title = Toggle.Title,
		Desc = Toggle.Desc,
		-- Image = Config.Image,
		-- ImageSize = Config.ImageSize,
		-- Thumbnail = Config.Thumbnail,
		-- ThumbnailSize = Config.ThumbnailSize,
		Window = Config.Window,
		Parent = Config.Parent,
		TextOffset = (24 + 24 + 4),
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Toggle,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local CanCallback = true

	if Toggle.Value == nil then
		Toggle.Value = false
	end

	function Toggle:Lock()
		Toggle.Locked = true
		CanCallback = false
		return Toggle.ToggleFrame:Lock(Toggle.LockedTitle)
	end
	function Toggle:Unlock()
		Toggle.Locked = false
		CanCallback = true
		return Toggle.ToggleFrame:Unlock()
	end

	if Toggle.Locked then
		Toggle:Lock()
	end

	local Toggled = Toggle.Value

	local ToggleFrame, ToggleFunc
	if Toggle.Type == "Toggle" then
		ToggleFrame, ToggleFunc = CreateToggle(
			Toggled,
			Toggle.Icon,
			Toggle.IconSize,
			Toggle.ToggleFrame.UIElements.Main,
			Toggle.Callback,
			Config.Window.NewElements,
			Config
		)
	elseif Toggle.Type == "Checkbox" then
		ToggleFrame, ToggleFunc = CreateCheckbox(
			Toggled,
			Toggle.Icon,
			Toggle.IconSize,
			Toggle.ToggleFrame.UIElements.Main,
			Toggle.Callback,
			Config
		)
	else
		error("Unknown Toggle Type: " .. tostring(Toggle.Type))
	end

	ToggleFrame.AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5)
	ToggleFrame.Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0)

	function Toggle:Set(v, isCallback, isAnim)
		if CanCallback then
			ToggleFunc:Set(v, isCallback, isAnim or false)
			Toggled = v
			Toggle.Value = v
		end
	end

	function Toggle:Toggle(isCallback, isAnim)
		Toggle:Set(not Toggle.Value, isCallback, isAnim or Config.Window.NewElements)
	end

	Toggle:Set(Toggled, false, Config.Window.NewElements)

	local CurInput = Config.WindUI.GenerateGUID()

	if Config.Window.NewElements and ToggleFunc.Animate then
		if Toggle.Type == "Toggle" then
			Creator.AddSignal(ToggleFrame.ToggleFrame.Hitbox.InputBegan, function(Input)
				if
					not Config.Window.IsToggleDragging
					and (
						Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch
					)
				then
					if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then
						return
					end

					Config.WindUI.CurrentInput = CurInput
					ToggleFunc:Animate(Input, Toggle)
				end
			end)
		end
		-- Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.InputEnded, function(input)
		--     if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		--         ToggleFunc:Animate(input, true, Toggle)
		--     end
		-- end)
	else
		if Toggle.Type == "Toggle" then
			Creator.AddSignal(ToggleFrame.ToggleFrame.Hitbox.MouseButton1Click, function()
				Toggle:Toggle(nil, Config.Window.NewElements)
			end)
		elseif Toggle.Type == "Checkbox" then
			Creator.AddSignal(ToggleFrame.MouseButton1Click, function()
				Toggle:Toggle(nil, Config.Window.NewElements)
			end)
		end
	end

	if Toggle.KeyCode then
		Creator.AddSignal(UserInputService.InputBegan, function(Input, GameProcessed)
			if GameProcessed or UserInputService:GetFocusedTextBox() then
				return
			end
			if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Toggle.KeyCode then
				Toggle:Toggle(nil, Config.Window.NewElements)
			end
		end)
	end

	return Toggle.__type, Toggle
end

return Element
