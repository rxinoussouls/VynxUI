local Creator = require("../modules/Creator")

return {
	Elements = {
		Paragraph = require("./Paragraph"),
		Button = require("./Button"),
		Toggle = require("./Toggle"),
		Slider = require("./Slider"),
		ProgressBar = require("./ProgressBar"),
		Keybind = require("./Keybind"),
		Input = require("./Input"),
		Dropdown = require("./Dropdown"),
		Code = require("./Code"),
		Colorpicker = require("./Colorpicker"),
		RadioGroup = require("./RadioGroup"),
		CheckboxGroup = require("./CheckboxGroup"),
		SegmentedControl = require("./SegmentedControl"),
		TextArea = require("./TextArea"),
		Stepper = require("./Stepper"),
		Callout = require("./Callout"),
		Badge = require("./Badge"),
		StatusCard = require("./StatusCard"),
		StatCard = require("./StatCard"),
		KeyValue = require("./KeyValue"),
		ChipList = require("./ChipList"),
		ActionList = require("./ActionList"),
		MeterGroup = require("./MeterGroup"),
		Timeline = require("./Timeline"),
		Accordion = require("./Accordion"),
		EmptyState = require("./EmptyState"),
		DiscordCard = require("./DiscordCard"),
		TabBox = require("./TabBox"),
		Path2D = require("./Path2D"),
		Card = require("./Card"),
		Section = require("./Section"),
		Divider = require("./Divider"),
		Space = require("./Space"),
		Image = require("./Image"),
		Group = require("./Group"),
		HStack = require("./HStack"),
		VStack = require("./VStack"),
		Viewport = require("./Viewport"),
		Video = require("./Video"),
	},
	Load = function(tbl, Container, Elements, Window, WindUI, OnElementCreateFunction, ElementsModule, UIScale, Tab)
		for name, module in next, Elements do
			tbl[name] = function(self, config)
				config = config or {}
				config.Tab = Tab or tbl
				config.ParentType = tbl.__type
				config.ParentTable = tbl
				config.Index = #tbl.Elements + 1
				config.GlobalIndex = #Window.AllElements + 1
				if config.LinkCorners == nil then
					config.LinkCorners = tbl.LinkCorners == true
						or typeof(tbl.LinkCorners) == "table"
						or (Tab and (Tab.LinkCorners == true or typeof(Tab.LinkCorners) == "table"))
				end
				if config.CornerLink == nil then
					config.CornerLink = tbl.CornerLink or (Tab and Tab.CornerLink) or Window.ElementConfig.CornerLink
				end
				config.Parent = Container
				config.Window = Window
				config.WindUI = WindUI
				config.UIScale = UIScale
				config.ElementsModule = ElementsModule

				local _elementInstance, content = module:New(config)

				content.Index = config.Index
				content.LinkCorners = config.LinkCorners
				content.CornerGroup = config.CornerGroup or config.LinkCornerGroup
				content.CornerBreak = config.CornerBreak
				content.CornerBreakBefore = config.CornerBreakBefore
				content.CornerBreakAfter = config.CornerBreakAfter

				if config.Flag and typeof(config.Flag) == "string" then
					if Window.CurrentConfig then
						Window.CurrentConfig:Register(config.Flag, content)

						if Window.PendingConfigData and Window.PendingConfigData[config.Flag] then
							local data = Window.PendingConfigData[config.Flag]

							local ConfigManager = Window.ConfigManager
							if typeof(data) == "table" and ConfigManager.Parser[data.__type] then
								task.defer(function()
									local success, err = pcall(function()
										ConfigManager.Parser[data.__type].Load(content, data)
									end)

									if success then
										Window.PendingConfigData[config.Flag] = nil
									else
										warn(
											"[ WindUI ] Failed to apply pending config for '"
												.. config.Flag
												.. "': "
												.. tostring(err)
										)
									end
								end)
							end
						end
					else
						Window.PendingFlags = Window.PendingFlags or {}
						Window.PendingFlags[config.Flag] = content
					end
				end

				local frame
				for key, value in next, content do
					if typeof(value) == "table" and key ~= "ElementFrame" and key:match("Frame$") then
						frame = value
						break
					end
				end

				if frame then
					content.ElementFrame = frame.UIElements.Main
					function content:SetTitle(title)
						return frame.SetTitle and frame:SetTitle(title)
					end
					function content:SetDesc(desc)
						return frame.SetDesc and frame:SetDesc(desc)
					end
					function content:SetImage(image, size)
						return frame.SetImage and frame:SetImage(image, size)
					end
					function content:SetThumbnail(image, size)
						return frame.SetThumbnail and frame:SetThumbnail(image, size)
					end
					function content:SetTransparency(value)
						return frame.SetTransparency and frame:SetTransparency(value)
					end
					function content:SetLiquidGlass(value)
						return frame.SetLiquidGlass and frame:SetLiquidGlass(value)
					end
					function content:Highlight()
						frame:Highlight()
					end
					function content:Destroy()
						if content.Cleanup then
							content:Cleanup()
						end
						frame:Destroy()

						table.remove(Window.AllElements, config.GlobalIndex)
						table.remove(tbl.Elements, config.Index)
						table.remove(Tab.Elements, config.Index)
						tbl:UpdateAllElementShapes(tbl)
					end
				end

				if not content.ElementFrame and content.UIElements and content.UIElements.Main then
					content.ElementFrame = content.UIElements.Main
				end

				if not content.UpdateShape and content.ElementFrame then
					function content.UpdateShape(ParentTable)
						local ShouldLink = content.LinkCorners ~= false
							and (
								content.LinkCorners == true
								or Window.ElementConfig.LinkCorners
								or (ParentTable and ParentTable.LinkCorners == true)
							)
						local Corners = Creator.DefaultCornerMap()
						local Metadata = { Count = 1 }

						if ShouldLink and ParentTable and ParentTable.Elements then
							_, Corners, Metadata = Creator.GetLinkedCornerShape(
								ParentTable.Elements,
								content.Index,
								ParentTable,
								ParentTable.__type,
								config.CornerLink or Window.ElementConfig.CornerLink
							)
						end

						Creator.ApplyLinkedCornerSurface(
							content.ElementFrame,
							UDim.new(0, Window.ElementConfig.UICorner),
							Corners,
							ShouldLink and Metadata.Count > 1
						)
					end
				end

				Window.AllElements[config.GlobalIndex] = content
				tbl.Elements[config.Index] = content
				if Tab then
					Tab.Elements[config.Index] = content
				end

				if Window.NewElements then
					tbl:UpdateAllElementShapes(tbl)
				end

				if OnElementCreateFunction then
					OnElementCreateFunction(content, tbl.Elements)
				end
				return content
			end
		end
		function tbl:UpdateAllElementShapes(bbb)
			for i, element in next, bbb.Elements do
				local frame
				for key, value in pairs(element) do
					if typeof(value) == "table" and key:match("Frame$") then
						frame = value
						break
					end
				end

				if not frame and element.UpdateShape then
					frame = element
				end

				if frame then
					--print("idx changed : " .. i .. " " .. (element.Title or "not found"))
					frame.Index = i
					if frame.UpdateShape then
						--print(" .changed: " .. i)
						frame.UpdateShape(bbb)
					end
				end
			end
		end
	end,
}
