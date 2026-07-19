local Creator = require("../modules/Creator")
local New = Creator.New

local DependencyBox = {}

function DependencyBox.AttachToSection(Section, VynxUI)
	function Section:AddDependencyBox()
		if self.Destroyed then
			return nil
		end

		local Groupbox = self
		local Container = Groupbox.Container or Groupbox.ElementContainer

		if not Container then
			return nil
		end

		local DepboxContainer = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Visible = false,
			ClipsDescendants = false,
			Parent = Container,
		})

		local DepboxList = New("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = DepboxContainer,
		})

		local Depbox = {
			__type        = "DependencyBox",
			Connections   = {},
			Destroyed     = false,
			Visible       = false,
			Dependencies  = {},
			Holder        = DepboxContainer,
			Container     = DepboxContainer,
			Elements      = {},
			DependencyBoxes = {},
			Window        = Groupbox.Window,
			WindUI        = Groupbox.WindUI or VynxUI,
		}

		function Depbox:Resize()
			local height = DepboxList.AbsoluteContentSize.Y
			DepboxContainer.Size = UDim2.new(1, 0, 0, height)
			if Groupbox.Resize then
				Groupbox:Resize()
			end
		end

		function Depbox:Update()
			for _, Dependency in Depbox.Dependencies do
				local Element = Dependency[1]
				local Expected = Dependency[2]

				if not Element then
					continue
				end

				local elemType = Element.__type or Element.Type or ""

				if elemType == "Toggle" or elemType == "Checkbox" then
					if Element.Value ~= Expected then
						DepboxContainer.Visible = false
						Depbox.Visible = false
						return
					end
				elseif elemType == "Dropdown" then
					local val = Element.Value
					if typeof(val) == "table" then
						if not val[Expected] then
							DepboxContainer.Visible = false
							Depbox.Visible = false
							return
						end
					else
						if val ~= Expected then
							DepboxContainer.Visible = false
							Depbox.Visible = false
							return
						end
					end
				end
			end

			Depbox.Visible = true
			DepboxContainer.Visible = true
			task.defer(function()
				Depbox:Resize()
			end)
		end

		DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if Depbox.Visible then
				Depbox:Resize()
			end
		end)

		function Depbox:SetupDependencies(Dependencies)
			for _, Dep in Dependencies do
				assert(typeof(Dep) == "table", "Each dependency must be a table: {element, expectedValue}")
				assert(Dep[1] ~= nil, "Dependency missing element reference")
				assert(Dep[2] ~= nil, "Dependency missing expected value")

				local Element = Dep[1]
				if Element.OnChanged then
					local conn = Element.OnChanged:Connect(function()
						Depbox:Update()
					end)
					table.insert(Depbox.Connections, conn)
				elseif Element.OnChange then
					local conn = Element.OnChange:Connect(function()
						Depbox:Update()
					end)
					table.insert(Depbox.Connections, conn)
				end
			end

			Depbox.Dependencies = Dependencies
			Depbox:Update()
		end

		function Depbox:Destroy()
			Depbox.Destroyed = true

			for _, conn in Depbox.Connections do
				if conn and conn.Connected then
					conn:Disconnect()
				end
			end

			for _, elem in Depbox.Elements do
				if elem and elem.Destroy then
					elem:Destroy()
				end
			end

			for _, sub in Depbox.DependencyBoxes do
				if sub and sub.Destroy then
					sub:Destroy()
				end
			end

			if DepboxContainer and DepboxContainer.Parent then
				DepboxContainer:Destroy()
			end

			if VynxUI and VynxUI.DependencyBoxes then
				local idx = table.find(VynxUI.DependencyBoxes, Depbox)
				if idx then
					table.remove(VynxUI.DependencyBoxes, idx)
				end
			end
		end

		local ElementsModule = require("./Init")
		ElementsModule.Load(
			Depbox,
			DepboxContainer,
			ElementsModule.Elements,
			Groupbox.Window,
			Groupbox.WindUI or VynxUI,
			nil,
			ElementsModule,
			Groupbox.UIScale or 1,
			Groupbox.Tab
		)

		if VynxUI and VynxUI.DependencyBoxes then
			table.insert(VynxUI.DependencyBoxes, Depbox)
		end

		return Depbox
	end

	function Section:AddDependencyGroupbox(Title)
		if self.Destroyed then
			return nil
		end

		local Groupbox = self
		local Container = Groupbox.Container or Groupbox.ElementContainer
		if not Container then
			return nil
		end

		local DepGroupboxOuter = New("Frame", {
			BackgroundColor3 = Color3.fromHex("#1E1E2C"),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = Container,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 8) }),
			New("UIStroke", {
				Color = Color3.fromHex("#2a2a3a"),
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),
			New("UIPadding", {
				PaddingTop    = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft   = UDim.new(0, 8),
				PaddingRight  = UDim.new(0, 8),
			}),
		})

		local DepGroupboxList = New("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = DepGroupboxOuter,
		})

		if Title then
			New("TextLabel", {
				BackgroundTransparency = 1,
				Text = Title,
				TextSize = 13,
				TextColor3 = Color3.fromHex("#a1a1aa"),
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, 16),
				LayoutOrder = 0,
				Parent = DepGroupboxOuter,
			})
		end

		local DepGroupbox = {
			__type        = "DependencyGroupbox",
			Connections   = {},
			Destroyed     = false,
			Visible       = false,
			Dependencies  = {},
			Holder        = DepGroupboxOuter,
			Container     = DepGroupboxOuter,
			Elements      = {},
			DependencyBoxes = {},
			Window        = Groupbox.Window,
			WindUI        = Groupbox.WindUI or VynxUI,
			Tab           = Groupbox.Tab,
		}

		function DepGroupbox:Resize()
			DepGroupboxOuter.Size = UDim2.new(1, 0, 0, DepGroupboxList.AbsoluteContentSize.Y + 16)
		end

		function DepGroupbox:Update()
			for _, Dep in DepGroupbox.Dependencies do
				local Element = Dep[1]
				local Expected = Dep[2]

				if not Element then
					continue
				end

				local elemType = Element.__type or Element.Type or ""

				if elemType == "Toggle" or elemType == "Checkbox" then
					if Element.Value ~= Expected then
						DepGroupboxOuter.Visible = false
						DepGroupbox.Visible = false
						return
					end
				elseif elemType == "Dropdown" then
					local val = Element.Value
					if typeof(val) == "table" then
						if not val[Expected] then
							DepGroupboxOuter.Visible = false
							DepGroupbox.Visible = false
							return
						end
					else
						if val ~= Expected then
							DepGroupboxOuter.Visible = false
							DepGroupbox.Visible = false
							return
						end
					end
				end
			end

			DepGroupbox.Visible = true
			DepGroupboxOuter.Visible = true
			task.defer(function()
				DepGroupbox:Resize()
			end)
		end

		function DepGroupbox:SetupDependencies(Dependencies)
			for _, Dep in Dependencies do
				assert(typeof(Dep) == "table", "Each dependency must be a table: {element, expectedValue}")
				assert(Dep[1] ~= nil, "Dependency missing element reference")
				assert(Dep[2] ~= nil, "Dependency missing expected value")

				local Element = Dep[1]
				if Element.OnChanged then
					local conn = Element.OnChanged:Connect(function()
						DepGroupbox:Update()
					end)
					table.insert(DepGroupbox.Connections, conn)
				elseif Element.OnChange then
					local conn = Element.OnChange:Connect(function()
						DepGroupbox:Update()
					end)
					table.insert(DepGroupbox.Connections, conn)
				end
			end

			DepGroupbox.Dependencies = Dependencies
			DepGroupbox:Update()
		end

		function DepGroupbox:Destroy()
			DepGroupbox.Destroyed = true

			for _, conn in DepGroupbox.Connections do
				if conn and conn.Connected then
					conn:Disconnect()
				end
			end

			for _, elem in DepGroupbox.Elements do
				if elem and elem.Destroy then
					elem:Destroy()
				end
			end

			for _, sub in DepGroupbox.DependencyBoxes do
				if sub and sub.Destroy then
					sub:Destroy()
				end
			end

			if DepGroupboxOuter and DepGroupboxOuter.Parent then
				DepGroupboxOuter:Destroy()
			end

			if VynxUI and VynxUI.DependencyBoxes then
				local idx = table.find(VynxUI.DependencyBoxes, DepGroupbox)
				if idx then
					table.remove(VynxUI.DependencyBoxes, idx)
				end
			end
		end

		local ElementsModule = require("./Init")
		ElementsModule.Load(
			DepGroupbox,
			DepGroupboxOuter,
			ElementsModule.Elements,
			Groupbox.Window,
			Groupbox.WindUI or VynxUI,
			nil,
			ElementsModule,
			Groupbox.UIScale or 1,
			Groupbox.Tab
		)

		if VynxUI and VynxUI.DependencyBoxes then
			table.insert(VynxUI.DependencyBoxes, DepGroupbox)
		end

		return DepGroupbox
	end
end

return DependencyBox
