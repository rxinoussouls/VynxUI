local Creator = require("../modules/Creator")
local Motion = require("../modules/Motion")
local New = Creator.New

local Utils = require("./DisplayElementUtils")

local Element = {}

local function NormalizeMeters(Meters)
	local Normalized = {}

	for Index, Meter in next, Meters or {} do
		if typeof(Meter) == "table" then
			local Max = Utils.ToFiniteNumber(Meter.Max) or 100
			local Value = Utils.ToFiniteNumber(Meter.Value or Meter.Default) or 0
			table.insert(Normalized, {
				Title = tostring(Meter.Title or Meter.Name or ("Meter " .. tostring(Index))),
				Value = math.clamp(Value, 0, Max),
				Max = math.max(Max, 0.0001),
				Desc = Meter.Desc,
				Color = Utils.GetColor(Meter.Color, nil),
				Format = Meter.Format,
			})
		else
			table.insert(Normalized, {
				Title = tostring(Index),
				Value = math.clamp(Utils.ToFiniteNumber(Meter) or 0, 0, 100),
				Max = 100,
			})
		end
	end

	return Normalized
end

function Element:New(Config)
	local MeterGroup = {
		__type = "MeterGroup",
		Title = Config.Title or "Meters",
		Desc = Config.Desc,
		Meters = NormalizeMeters(Config.Meters or Config.Items or Config.Values or {}),
		Rows = {},
		UIElements = {},
	}

	MeterGroup.MeterGroupFrame = require("../components/window/Element")({
		Title = MeterGroup.Title,
		Desc = MeterGroup.Desc,
		Parent = Config.Parent,
		TextOffset = 0,
		Hover = Config.Hover == true,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = MeterGroup,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	MeterGroup.UIElements.List = New("Frame", {
		Name = "MeterGroup",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Parent = MeterGroup.MeterGroupFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
		}),
	})

	local function FormatValue(Meter)
		local Ratio = math.clamp(Meter.Value / Meter.Max, 0, 1)
		if typeof(Meter.Format) == "function" then
			local Success, Result = pcall(Meter.Format, Meter.Value, Meter.Max, Ratio)
			if Success and Result ~= nil then
				return tostring(Result)
			end
		end
		return tostring(math.floor((Ratio * 100) + 0.5)) .. "%"
	end

	local function Render()
		for _, Row in next, MeterGroup.Rows do
			Row.Frame:Destroy()
		end
		MeterGroup.Rows = {}

		for Index, Meter in next, MeterGroup.Meters do
			local Ratio = math.clamp(Meter.Value / Meter.Max, 0, 1)
			local Fill = Creator.NewRoundFrame(999, "Squircle", {
				Name = "Fill",
				Size = UDim2.new(Ratio, 0, 1, 0),
				ImageTransparency = 0.08,
				ImageColor3 = Meter.Color,
				ThemeTag = not Meter.Color and {
					ImageColor3 = "Primary",
				} or nil,
			})

			local ValueLabel = New("TextLabel", {
				Name = "Value",
				Size = UDim2.new(0, 52, 0, 18),
				BackgroundTransparency = 1,
				Text = FormatValue(Meter),
				TextSize = 12,
				TextTransparency = 0.22,
				TextXAlignment = "Right",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local Row = New("Frame", {
				Name = "Meter",
				LayoutOrder = Index,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Parent = MeterGroup.UIElements.List,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = "Vertical",
					HorizontalAlignment = "Left",
				}),
				New("Frame", {
					Name = "Header",
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
				}, {
					New("UIListLayout", {
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
					}),
					New("TextLabel", {
						Name = "Title",
						Size = UDim2.new(1, -58, 1, 0),
						BackgroundTransparency = 1,
						Text = Meter.Title,
						TextSize = 13,
						TextTransparency = 0.1,
						TextXAlignment = "Left",
						TextTruncate = "AtEnd",
						FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
						ThemeTag = {
							TextColor3 = "Text",
						},
					}),
					ValueLabel,
				}),
				Creator.NewRoundFrame(999, "Squircle", {
					Name = "Track",
					Size = UDim2.new(1, 0, 0, 7),
					ImageTransparency = 0.9,
					ClipsDescendants = true,
					ThemeTag = {
						ImageColor3 = "ElementBackground",
					},
				}, {
					Fill,
				}),
				Meter.Desc and New("TextLabel", {
					Name = "Desc",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = tostring(Meter.Desc),
					TextSize = 12,
					TextTransparency = 0.42,
					TextXAlignment = "Left",
					TextWrapped = true,
					FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
					ThemeTag = {
						TextColor3 = "Text",
					},
				}) or nil,
			})

			MeterGroup.Rows[Index] = {
				Frame = Row,
				Fill = Fill,
				ValueLabel = ValueLabel,
			}
		end
	end

	function MeterGroup:SetValue(Index, Value)
		local Meter = MeterGroup.Meters[Index]
		local Row = MeterGroup.Rows[Index]
		if not Meter or not Row then
			return nil
		end

		Meter.Value = math.clamp(Utils.ToFiniteNumber(Value) or Meter.Value, 0, Meter.Max)
		local Ratio = math.clamp(Meter.Value / Meter.Max, 0, 1)
		Row.ValueLabel.Text = FormatValue(Meter)
		Motion.Play(Row.Fill, "Fast", {
			Size = UDim2.new(Ratio, 0, 1, 0),
		}, nil, nil, "Meter")
		return Meter.Value
	end

	function MeterGroup:SetMeters(Meters)
		MeterGroup.Meters = NormalizeMeters(Meters)
		Render()
		return MeterGroup.Meters
	end

	Render()

	return MeterGroup.__type, MeterGroup
end

return Element
