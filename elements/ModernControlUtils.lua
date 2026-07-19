local Utils = {}

function Utils.ToFiniteNumber(Value)
	local Number = tonumber(Value)
	if Number == nil or Number ~= Number or math.abs(Number) == math.huge then
		return nil
	end

	return Number
end

function Utils.FormatNumber(Value)
	if Value % 1 == 0 then
		return tostring(Value)
	end

	return tostring(tonumber(string.format("%.2f", Value)))
end

function Utils.NormalizeOptions(Options)
	local Normalized = {}

	for Index, Option in next, Options or {} do
		local Item
		if typeof(Option) == "table" then
			local Value = Option.Value
			if Value == nil then
				Value = Option.Id or Option.Key or Option.Title or Option.Name or Index
			end

			Item = {
				Title = tostring(Option.Title or Option.Name or Value),
				Desc = Option.Desc,
				Value = Value,
				Icon = Option.Icon,
				Disabled = Option.Disabled == true,
			}
		else
			Item = {
				Title = tostring(Option),
				Value = Option,
				Disabled = false,
			}
		end

		table.insert(Normalized, Item)
	end

	return Normalized
end

function Utils.FindOption(Options, Value)
	for Index, Option in next, Options or {} do
		if Option.Value == Value then
			return Option, Index
		end
	end

	return nil, nil
end

function Utils.ContainsValue(Values, Value)
	for _, Item in next, Values or {} do
		if Item == Value then
			return true
		end
	end

	return false
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

return Utils
