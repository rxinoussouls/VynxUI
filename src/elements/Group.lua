local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local LinkCorners = Config.LinkCorners == true or typeof(Config.LinkCorners) == "table"
	local CornerLink = Config.CornerLink or (typeof(Config.LinkCorners) == "table" and Config.LinkCorners)
	local LinkedGap = typeof(CornerLink) == "table" and (CornerLink.Gap or CornerLink.Spacing) or nil
	local Gap = Config.Gap
		or Config.ElementGap
		or (LinkCorners and (tonumber(LinkedGap) or 1))
		or (Config.Tab and Config.Tab.Gap)
		or (Config.Window.NewElements and 1 or 6)
	local GroupModule = {
		__type = "Group",
		Elements = {},
		ElementFrame = nil,
		LinkCorners = LinkCorners,
		CornerLink = CornerLink,
	}

	local GroupFrame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = "Y",
		Parent = Config.Parent,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
			--VerticalAlignment = "Center",
			Padding = UDim.new(0, Gap),
		}),
	})

	GroupModule.ElementFrame = GroupFrame

	local ElementsModule = Config.ElementsModule
	ElementsModule.Load(
		GroupModule,
		GroupFrame,
		ElementsModule.Elements,
		Config.Window,
		Config.WindUI,
		function(CurrentElement, AllElements)
			local StretchableElements = {}
			local TotalFixedWidth = 0

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

			local ElementWidthScale = 1 / StretchCount

			local TotalGapWidth = Gap * (StretchCount - 1)

			local TotalOffset = -(TotalGapWidth + TotalFixedWidth)

			local BaseOffset = math.floor(TotalOffset / StretchCount)
			local Remainder = TotalOffset - (BaseOffset * StretchCount)

			for i, Element in next, StretchableElements do
				local Offset = BaseOffset
				if i <= math.abs(Remainder) then
					Offset = Offset - 1
				end

				if Element.ElementFrame then
					Element.ElementFrame.Size = UDim2.new(ElementWidthScale, Offset, 1, 0)
				end
			end
		end,
		ElementsModule,
		Config.UIScale,
		Config.Tab
	)

	return GroupModule.__type, GroupModule
end

return Element
