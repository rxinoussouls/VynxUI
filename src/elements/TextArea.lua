local Creator = require("../modules/Creator")

local CreateInput = require("../components/ui/Input").New

local Element = {}

function Element:New(Config)
	local TextArea = {
		__type = "TextArea",
		Title = Config.Title or "Text Area",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		InputIcon = Config.InputIcon or false,
		Placeholder = Config.Placeholder or "Enter Text...",
		Value = Config.Value or "",
		Callback = Config.Callback or function() end,
		ClearTextOnFocus = Config.ClearTextOnFocus or false,
		UIElements = {},
	}

	local CanCallback = true

	TextArea.TextAreaFrame = require("../components/window/Element")({
		Title = TextArea.Title,
		Desc = TextArea.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = TextArea,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local InputComponent = CreateInput(
		TextArea.Placeholder,
		TextArea.InputIcon,
		TextArea.TextAreaFrame.UIElements.Container,
		"Textarea",
		function(Value)
			TextArea:Set(Value, true, true)
		end,
		nil,
		Config.Window.NewElements and 12 or 10,
		TextArea.ClearTextOnFocus
	)
	InputComponent.Size = UDim2.new(1, 0, 0, Config.Height or 148)
	InputComponent.LayoutOrder = 99

	local TextBox = InputComponent.Frame.Frame.TextBox

	function TextArea:Lock()
		TextArea.Locked = true
		CanCallback = false
		return TextArea.TextAreaFrame:Lock(TextArea.LockedTitle)
	end
	function TextArea:Unlock()
		TextArea.Locked = false
		CanCallback = true
		return TextArea.TextAreaFrame:Unlock()
	end

	function TextArea:Get()
		return TextArea.Value
	end

	function TextArea:Set(Value, IsCallback, IsUserInput)
		if not CanCallback then
			return TextArea.Value
		end

		TextArea.Value = tostring(Value or "")

		if not IsUserInput then
			TextBox.Text = TextArea.Value
		end

		if IsCallback ~= false then
			Creator.SafeCallback(TextArea.Callback, TextArea.Value)
		end

		return TextArea.Value
	end

	function TextArea:SetPlaceholder(Value)
		TextArea.Placeholder = tostring(Value or "")
		TextBox.PlaceholderText = TextArea.Placeholder
	end

	TextArea:Set(TextArea.Value, false)

	if TextArea.Locked then
		TextArea:Lock()
	end

	return TextArea.__type, TextArea
end

return Element
