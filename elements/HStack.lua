local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local HStackModule = {
		__type = "HStack",
		AutoSpace = Config.AutoSpace or false,
		Elements = {},
		ElementFrame = nil,
		LinkCorners = Config.LinkCorners == true,
		CornerLink = Config.CornerLink,
		MinChildWidth = math.max(tonumber(Config.MinChildWidth) or 128, 40),
		IsStacked = false,
	}

	local HStackFrame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = "Y",
		Parent = Config.Parent,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
			--VerticalAlignment = "Center",
			Padding = UDim.new(0, Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6)),
		}),
	})

	HStackModule.ElementFrame = HStackFrame

	local ElementsModule = Config.ElementsModule
	local function UpdateLayout(AllElements)
		AllElements = AllElements or HStackModule.Elements
		local Gap = Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6)

		local StretchableElements = {}
		local TotalFixedWidth = 0
		local ParentWidth = HStackFrame.AbsoluteSize.X / Config.UIScale

		for _, Element in next, AllElements do
			if Element.__type == "Space" then
				TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 6)
			elseif Element.__type == "Divider" then
				TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 1)
			else
				table.insert(StretchableElements, Element)
			end
		end

		local StretchCount = #StretchableElements
		if StretchCount == 0 then
			return
		end

		local TotalGapWidth = Gap * (StretchCount - 1)
		local AvailableWidth = ParentWidth - TotalGapWidth - TotalFixedWidth
		local ShouldStack = ParentWidth > 0 and AvailableWidth / StretchCount < HStackModule.MinChildWidth
		local OrientationChanged = HStackModule.IsStacked ~= ShouldStack
		HStackModule.IsStacked = ShouldStack
		local ElementWidthScale = ShouldStack and 1 or (1 / StretchCount)
		local TotalOffset = ShouldStack and 0 or -(TotalGapWidth + TotalFixedWidth)
		local BaseOffset = math.floor(TotalOffset / StretchCount)
		local Remainder = TotalOffset - (BaseOffset * StretchCount)

		HStackFrame.UIListLayout.FillDirection = ShouldStack and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		HStackFrame.UIListLayout.HorizontalAlignment = ShouldStack and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center

		for i, Element in next, StretchableElements do
			local Offset = ShouldStack and 0 or BaseOffset
			if not ShouldStack and i <= math.abs(Remainder) then
				Offset = Offset - 1
			end

			if Element.ElementFrame then
				local CurrentSize = Element.ElementFrame.Size
				Element.ElementFrame.Size = UDim2.new(
					ElementWidthScale,
					Offset,
					CurrentSize.Y.Scale == 1 and 0 or CurrentSize.Y.Scale,
					CurrentSize.Y.Scale == 1 and 0 or CurrentSize.Y.Offset
				)
			end
		end

		if OrientationChanged and HStackModule.UpdateAllElementShapes then
			HStackModule:UpdateAllElementShapes(HStackModule)
		end
	end

	ElementsModule.Load(
		HStackModule,
		HStackFrame,
		ElementsModule.Elements,
		Config.Window,
		Config.WindUI,
		function(CurrentElement, AllElements)
			UpdateLayout(AllElements)
		end,
		ElementsModule,
		Config.UIScale,
		Config.Tab
	)

	Creator.AddSignal(HStackFrame:GetPropertyChangedSignal("AbsoluteSize"), function()
		UpdateLayout()
	end)

	if HStackModule.AutoSpace then
		for name in next, ElementsModule.Elements do
			if name ~= "Space" and name ~= "Divider" then
				local original = HStackModule[name]
				HStackModule[name] = function(self, config)
					if #HStackModule.Elements > 0 then
						HStackModule:Space()
					end
					return original(self, config)
				end
			end
		end
	end

	return HStackModule.__type, HStackModule
end

return Element
