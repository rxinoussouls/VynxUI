local Utils = {}

Utils.Variants = {
	Info = {
		Icon = "info",
		Color = Color3.fromHex("#2563eb"),
	},
	Success = {
		Icon = "circle-check",
		Color = Color3.fromHex("#16a34a"),
	},
	Warning = {
		Icon = "triangle-alert",
		Color = Color3.fromHex("#d97706"),
	},
	Error = {
		Icon = "circle-x",
		Color = Color3.fromHex("#dc2626"),
	},
	Neutral = {
		Icon = "circle",
		Color = Color3.fromHex("#71717a"),
	},
}

function Utils.ToFiniteNumber(Value)
	local Number = tonumber(Value)
	if Number == nil or Number ~= Number or math.abs(Number) == math.huge then
		return nil
	end

	return Number
end

function Utils.GetVariant(Name)
	return Utils.Variants[Name or "Info"] or Utils.Variants.Info
end

function Utils.GetColor(Value, Fallback)
	if typeof(Value) == "Color3" then
		return Value
	end
	if typeof(Value) == "string" and string.sub(Value, 1, 1) == "#" then
		return Color3.fromHex(Value)
	end
	return Fallback
end

function Utils.NormalizeItems(Items, TitleKey, ValueKey)
	local Normalized = {}

	for Index, Item in next, Items or {} do
		if typeof(Item) == "table" then
			local Value = Item[ValueKey or "Value"]
			if Value == nil then
				Value = Item.Id or Item.Key or Item.Title or Item.Name or Index
			end

			table.insert(Normalized, {
				Title = tostring(Item[TitleKey or "Title"] or Item.Name or Value),
				Desc = Item.Desc or Item.Content,
				Value = Value,
				Icon = Item.Icon,
				Color = Item.Color,
				Disabled = Item.Disabled == true,
				Items = Item.Items,
			})
		else
			table.insert(Normalized, {
				Title = tostring(Item),
				Value = Item,
				Disabled = false,
			})
		end
	end

	return Normalized
end

function Utils.CloneArray(Values)
	local Clone = {}
	for _, Value in next, Values or {} do
		table.insert(Clone, Value)
	end
	return Clone
end

function Utils.NormalizeValues(Values)
	if Values == nil then
		return {}
	end
	if typeof(Values) ~= "table" then
		return { Values }
	end
	return Utils.CloneArray(Values)
end

function Utils.ContainsValue(Values, Value)
	for _, Item in next, Values or {} do
		if Item == Value then
			return true
		end
	end
	return false
end

function Utils.ToggleValue(Values, Value)
	local NextValues = Utils.CloneArray(Values)

	for Index, Item in next, NextValues do
		if Item == Value then
			table.remove(NextValues, Index)
			return NextValues, false
		end
	end

	table.insert(NextValues, Value)
	return NextValues, true
end

function Utils.CreateIcon(Creator, IconName, Folder, Type, Themed, ThemeTag)
	if not IconName or IconName == "" then
		return nil
	end

	local Icon = Creator.Image(IconName, IconName, 0, Folder, Type or "Element", Themed ~= false, true, ThemeTag)
	Icon.Size = UDim2.new(0, 18, 0, 18)
	return Icon
end

function Utils.GetImageTarget(Icon)
	if typeof(Icon) ~= "Instance" then
		return nil
	end

	if Icon:IsA("ImageLabel") or Icon:IsA("ImageButton") then
		return Icon
	end

	return Icon:FindFirstChildWhichIsA("ImageLabel") or Icon:FindFirstChildWhichIsA("ImageButton")
end

function Utils.CreateText(New, Creator, Text, Size, Weight, Transparency)
	return New("TextLabel", {
		BackgroundTransparency = 1,
		Text = tostring(Text or ""),
		TextSize = Size or 14,
		TextTransparency = Transparency or 0,
		TextWrapped = true,
		TextXAlignment = "Left",
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = Font.new(Creator.Font, Weight or Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})
end

return Utils
