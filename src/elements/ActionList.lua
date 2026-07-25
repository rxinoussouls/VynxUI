local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function NormalizeActions(Actions)
	local Normalized = {}

	for Index, Action in next, Actions or {} do
		if typeof(Action) == "table" then
			table.insert(Normalized, {
				Title = tostring(Action.Title or Action.Name or Action.Value or ("Action " .. tostring(Index))),
				Desc = Action.Desc or Action.Content,
				Value = Action.Value or Action.Badge,
				Icon = Action.Icon,
				Color = Utils.GetColor(Action.Color, nil),
				Disabled = Action.Disabled == true,
				Callback = Action.Callback,
			})
		else
			table.insert(Normalized, {
				Title = tostring(Action),
				Disabled = false,
			})
		end
	end

	return Normalized
end

function Element:New(Config)
	local ActionList = {
		__type = "ActionList",
		Title = Config.Title or "Actions",
		Desc = Config.Desc,
		Actions = NormalizeActions(Config.Actions or Config.Items or Config.Values or {}),
		Rows = {},
		UIElements = {},
	}

	ActionList.ActionListFrame = require("../components/window/Element")({
		Title = ActionList.Title,
		Desc = ActionList.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = ActionList,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	ActionList.UIElements.List = New("Frame", {
		Name = "ActionList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = ActionList.ActionListFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Config.Window.NewElements and 6 or 8),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	local function Render()
		for _, Row in next, ActionList.Rows do
			Row:Destroy()
		end
		ActionList.Rows = {}

		for Index, Action in next, ActionList.Actions do
			local Icon = Utils.CreateIcon(Creator, Action.Icon or "circle-dot", Config.Window.Folder, "ActionList", true, "ActionListIcon")
			if Icon then
				Icon.Size = UDim2.fromOffset(17, 17)
			end
			local IconTarget = Utils.GetImageTarget(Icon)
			if IconTarget and Action.Color then
				IconTarget.ImageColor3 = Action.Color
			end

			local Texts = New("Frame", {
				Name = "Texts",
				Size = UDim2.new(1, Action.Value and -96 or -42, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 2),
					FillDirection = "Vertical",
					HorizontalAlignment = "Left",
				}),
				New("TextLabel", {
					Name = "Title",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = Action.Title,
					TextSize = 14,
					TextTransparency = Action.Disabled and 0.46 or 0.04,
					TextXAlignment = "Left",
					TextTruncate = "AtEnd",
					FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
					ThemeTag = {
						TextColor3 = "Text",
					},
				}),
				Action.Desc and New("TextLabel", {
					Name = "Desc",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = tostring(Action.Desc),
					TextSize = 12,
					TextTransparency = Action.Disabled and 0.62 or 0.38,
					TextXAlignment = "Left",
					TextWrapped = true,
					FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
					ThemeTag = {
						TextColor3 = "Text",
					},
				}) or nil,
			})

			local Value
			if Action.Value ~= nil then
				Value = Creator.NewRoundFrame(999, "Squircle", {
					Name = "Value",
					Size = UDim2.new(0, 0, 0, 26),
					AutomaticSize = "X",
					ImageTransparency = 0.88,
					ThemeTag = {
						ImageColor3 = "ElementBackground",
					},
				}, {
					New("UIPadding", {
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10),
					}),
					New("TextLabel", {
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = "X",
						BackgroundTransparency = 1,
						Text = tostring(Action.Value),
						TextSize = 12,
						TextTransparency = 0.12,
						FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
						ThemeTag = {
							TextColor3 = "Text",
						},
					}),
				})
			end

			local Row = Creator.NewRoundFrame(14, "Squircle", {
				Name = "Action",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				ImageTransparency = Action.Disabled and 0.96 or 0.92,
				Parent = ActionList.UIElements.List,
				ThemeTag = {
					ImageColor3 = "ElementBackground",
				},
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, 10),
					FillDirection = "Horizontal",
					VerticalAlignment = "Center",
					HorizontalAlignment = "Left",
				}),
				Icon,
				Texts,
				Value,
			}, not Action.Disabled)

			if not Action.Disabled then
				Motion.AttachPress(Row, Creator, {
					Amount = 0.985,
				})
				Creator.AddSignal(Row.MouseButton1Click, function()
					if typeof(Action.Callback) == "function" then
						Creator.SafeCallback(Action.Callback, Action, Index)
					elseif typeof(Config.Callback) == "function" then
						Creator.SafeCallback(Config.Callback, Action, Index)
					end
				end)
			end

			table.insert(ActionList.Rows, Row)
		end
	end

	function ActionList:SetActions(Actions)
		ActionList.Actions = NormalizeActions(Actions)
		Render()
		return ActionList.Actions
	end

	function ActionList:AddAction(Action)
		local Normalized = NormalizeActions({ Action })[1]
		if Normalized then
			table.insert(ActionList.Actions, Normalized)
			Render()
		end
		return Normalized
	end

	Render()

	return ActionList.__type, ActionList
end

return Element
