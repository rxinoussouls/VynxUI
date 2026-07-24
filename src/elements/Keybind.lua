local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {
	UICorner = 6,
	UIPadding = 8,
}

local CreateLabel = require("../components/ui/Label").New

local MouseKeyAliases = {
	MouseButton1 = "MouseLeft",
	MouseLeft = "MouseLeft",
	MouseLeftButton = "MouseLeft",
	MouseButton2 = "MouseRight",
	MouseRight = "MouseRight",
	MouseRightButton = "MouseRight",
}

local function NormalizeKeyCode(Value)
	local Name
	if typeof(Value) == "EnumItem" then
		Name = Value.Name
	elseif type(Value) == "string" then
		Name = Value
	else
		return "F"
	end

	return MouseKeyAliases[Name] or Name
end

local function GetInputKey(Input)
	if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode ~= Enum.KeyCode.Unknown then
		return Input.KeyCode.Name
	elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
		return "MouseLeft"
	elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
		return "MouseRight"
	end

	return nil
end

local function IsMatchingRelease(Input, Key)
	if Key == "MouseLeft" then
		return Input.UserInputType == Enum.UserInputType.MouseButton1
	elseif Key == "MouseRight" then
		return Input.UserInputType == Enum.UserInputType.MouseButton2
	end

	return Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key
end

function Element:New(Config)
	local Keybind = {
		__type = "Keybind",
		Title = Config.Title or "Keybind",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Value = NormalizeKeyCode(Config.Value) or "F",
		Callback = Config.Callback or function() end,
		CanChange = Config.CanChange ~= false,
		Blacklist = typeof(Config.Blacklist) == "table" and Config.Blacklist or {},
		Picking = false,
		UIElements = {},
	}

	local BlacklistedKeys = {}

	for _, Item in next, Keybind.Blacklist do
		BlacklistedKeys[NormalizeKeyCode(Item)] = true
	end

	local CanCallback = true

	Keybind.KeybindFrame = require("../components/window/Element")({
		Title = Keybind.Title,
		Desc = Keybind.Desc,
		Parent = Config.Parent,
		TextOffset = 85,
		Hover = Keybind.CanChange,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Keybind,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Keybind.UIElements.Keybind = CreateLabel(
		Keybind.Value,
		nil,
		Keybind.KeybindFrame.UIElements.Main,
		nil,
		Config.Window.NewElements and 12 or 10
	)

	Keybind.UIElements.Keybind.Size =
		UDim2.new(0, 12 + 12 + Keybind.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
	Keybind.UIElements.Keybind.AnchorPoint = Vector2.new(1, 0.5)
	Keybind.UIElements.Keybind.Position = UDim2.new(1, 0, 0.5, 0)
	Keybind.UIElements.Keybind.Interactable = false

	New("UIScale", {
		Parent = Keybind.UIElements.Keybind,
		Scale = 0.85,
	})

	Creator.AddSignal(
		Keybind.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal("TextBounds"),
		function()
			Keybind.UIElements.Keybind.Size =
				UDim2.new(0, 12 + 12 + Keybind.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
		end
	)

	local CaptureBeganConnection
	local CaptureEndedConnection

	local function DisconnectCaptureConnection(Connection)
		if Connection then
			Creator.DisconnectSignal(Connection)
		end
	end

	local function StopPicking(RestoreValue)
		DisconnectCaptureConnection(CaptureBeganConnection)
		DisconnectCaptureConnection(CaptureEndedConnection)
		CaptureBeganConnection = nil
		CaptureEndedConnection = nil
		Keybind.Picking = false

		if RestoreValue then
			Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = Keybind.Value
		end
	end

	function Keybind:Lock()
		StopPicking(true)
		Keybind.Locked = true
		CanCallback = false
		return Keybind.KeybindFrame:Lock(Keybind.LockedTitle)
	end
	function Keybind:Unlock()
		Keybind.Locked = false
		CanCallback = true
		return Keybind.KeybindFrame:Unlock()
	end

	function Keybind:Set(v)
		local normalizedValue = NormalizeKeyCode(v)
		StopPicking(false)
		Keybind.Value = normalizedValue
		Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = normalizedValue
	end

	if Keybind.Locked then
		Keybind:Lock()
	end

	Creator.AddSignal(Keybind.KeybindFrame.UIElements.Main.MouseButton1Click, function()
		if not CanCallback or not Keybind.CanChange then
			return
		end

		StopPicking(false)
		Keybind.Picking = true
		Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = "..."

		CaptureBeganConnection = Creator.AddSignal(UserInputService.InputBegan, function(Input)
			local Key = GetInputKey(Input)
			if not Key then
				return
			end
			if Key == "Escape" then
				StopPicking(true)
				return
			end
			if BlacklistedKeys[Key] then
				return
			end

			DisconnectCaptureConnection(CaptureBeganConnection)
			CaptureBeganConnection = nil

			CaptureEndedConnection = Creator.AddSignal(UserInputService.InputEnded, function(EndedInput)
				if not IsMatchingRelease(EndedInput, Key) then
					return
				end

				Keybind.Value = Key
				Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = Key
				StopPicking(false)
			end)
		end)
	end)

	Creator.AddSignal(UserInputService.InputBegan, function(input, gpe)
		if UserInputService:GetFocusedTextBox() then
			return
		end
		if not CanCallback then
			return
		end
		if Keybind.Picking then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode.Name == Keybind.Value then
				Creator.SafeCallback(Keybind.Callback, input.KeyCode.Name)
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Value == "MouseLeft" then
			Creator.SafeCallback(Keybind.Callback, "MouseLeft")
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Value == "MouseRight" then
			Creator.SafeCallback(Keybind.Callback, "MouseRight")
		end
	end)

	return Keybind.__type, Keybind
end

return Element
