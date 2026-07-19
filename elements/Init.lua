-- VYNX UI — Elements Init
-- Supports: WindUI-style (Section:Toggle{}) + Obsidian-style (Group:AddToggle(Idx, Info))

local Elements = {
	-- WindUI originals (38 elements)
	Paragraph       = require("./Paragraph"),
	Button          = require("./Button"),
	Toggle          = require("./Toggle"),
	Slider          = require("./Slider"),
	ProgressBar     = require("./ProgressBar"),
	Keybind         = require("./Keybind"),
	Input           = require("./Input"),
	Dropdown        = require("./Dropdown"),
	Code            = require("./Code"),
	Colorpicker     = require("./Colorpicker"),
	RadioGroup      = require("./RadioGroup"),
	CheckboxGroup   = require("./CheckboxGroup"),
	SegmentedControl= require("./SegmentedControl"),
	TextArea        = require("./TextArea"),
	Stepper         = require("./Stepper"),
	Callout         = require("./Callout"),
	Badge           = require("./Badge"),
	StatusCard      = require("./StatusCard"),
	StatCard        = require("./StatCard"),
	KeyValue        = require("./KeyValue"),
	ChipList        = require("./ChipList"),
	ActionList      = require("./ActionList"),
	MeterGroup      = require("./MeterGroup"),
	Timeline        = require("./Timeline"),
	Accordion       = require("./Accordion"),
	EmptyState      = require("./EmptyState"),
	DiscordCard     = require("./DiscordCard"),
	TabBox          = require("./TabBox"),
	Path2D          = require("./Path2D"),
	Card            = require("./Card"),
	Section         = require("./Section"),
	Divider         = require("./Divider"),
	Space           = require("./Space"),
	Image           = require("./Image"),
	Group           = require("./Group"),
	HStack          = require("./HStack"),
	VStack          = require("./VStack"),
	Viewport        = require("./Viewport"),
	Video           = require("./Video"),
	-- Obsidian ports (new)
	Checkbox        = require("./Checkbox"),
	UIPassthrough   = require("./UIPassthrough"),
}

local DependencyBoxModule = require("./DependencyBox")

-- ── Registry helpers (Obsidian global access) ────────────────────────────────
local function RegisterInVynx(VynxUI, key, elem, idx)
	if not VynxUI or not idx then return end
	if key == "Toggle"       then VynxUI.Toggles[idx] = elem
	elseif key == "Slider" or key == "Dropdown" or key == "RadioGroup"
		or key == "Keybind"  or key == "Colorpicker" or key == "Input"
		or key == "Checkbox" or key == "SegmentedControl" or key == "Stepper"
		or key == "CheckboxGroup"
	then VynxUI.Options[idx] = elem
	elseif key == "Paragraph" or key == "Badge" then VynxUI.Labels[idx] = elem
	elseif key == "Button"   then VynxUI.Buttons[idx] = elem
	end
end

-- ── Obsidian-style method name → WindUI element name map ────────────────────
local ObsidianAliases = {
	AddToggle         = "Toggle",
	AddSlider         = "Slider",
	AddDropdown       = "Dropdown",
	AddInput          = "Input",
	AddButton         = "Button",
	AddLabel          = "Paragraph",
	AddCheckbox       = "Checkbox",
	AddKeyPicker      = "Keybind",
	AddColorPicker    = "Colorpicker",
	AddDivider        = "Divider",
	AddImage          = "Image",
	AddViewport       = "Viewport",
	AddVideo          = "Video",
	AddUIPassthrough  = "UIPassthrough",
	AddProgressBar    = "ProgressBar",
	AddSegmentedControl = "SegmentedControl",
	AddRadioGroup     = "RadioGroup",
}

-- ── Obsidian Info → WindUI Config translator ─────────────────────────────────
local function TranslateObsidianConfig(elemName, Idx, Info)
	Info = Info or {}
	local cfg = {}

	-- Common
	cfg.Title   = Info.Text or Info.Title or (typeof(Idx) == "string" and Idx) or ""
	cfg.Desc    = Info.Tooltip or Info.Desc
	cfg.Default = Info.Default
	cfg.Locked  = Info.Disabled or Info.Locked or false
	cfg.Visible = Info.Visible
	cfg.Flag    = typeof(Idx) == "string" and Idx or Info.Flag

	-- Callback normalise (Obsidian uses Callback OR Changed)
	cfg.Callback = Info.Callback or Info.Changed or function() end

	-- Element-specific
	if elemName == "Slider" then
		cfg.Min     = Info.Min or 0
		cfg.Max     = Info.Max or 100
		cfg.Suffix  = Info.Suffix or ""
		cfg.Decimals= Info.Decimals or 0
		cfg.Compact = Info.Compact
	elseif elemName == "Dropdown" then
		cfg.Values    = Info.Values or {}
		cfg.Multi     = Info.Multi or false
		cfg.Searchable= Info.Searchable or false
	elseif elemName == "Input" then
		cfg.Placeholder = Info.PlaceholderText or Info.Placeholder or ""
		cfg.MaxLength   = Info.MaxLength
		cfg.NumberOnly  = Info.NumbersOnly or Info.NumberOnly
		cfg.ClearButton = Info.ClearButton
	elseif elemName == "Keybind" then
		cfg.Default      = Info.Default
		cfg.Mode         = Info.Mode or "Toggle"
		cfg.SyncToggleState = Info.SyncToggleState
	elseif elemName == "Colorpicker" then
		cfg.Default     = Info.Default or Color3.new(1, 1, 1)
		cfg.Transparency= Info.Transparency or false
	elseif elemName == "Paragraph" then
		cfg.Title   = Info.Text or Info.Title or ""
		cfg.Content = Info.Desc or Info.Content or ""
	end

	return cfg
end

-- ── Main Load function ───────────────────────────────────────────────────────
local function Load(tbl, Container, Elems, Window, VynxUI, OnElementCreateFunction, ElementsModule, UIScale, Tab)

	-- WindUI style: Section:Toggle({...})
	for name, module in next, Elems do
		tbl[name] = function(self, config)
			config = config or {}
			config.Tab         = Tab or tbl
			config.ParentType  = tbl.__type
			config.ParentTable = tbl
			config.Index       = #tbl.Elements + 1
			config.GlobalIndex = Window.AllElements and (#Window.AllElements + 1) or 1
			if config.LinkCorners == nil then
				config.LinkCorners = tbl.LinkCorners == true or (Tab and Tab.LinkCorners == true)
			end
			config.Parent     = Container
			config.Window     = Window
			config.WindUI     = VynxUI
			config.UIScale    = UIScale
			config.ElementsModule = ElementsModule

			local _frame, content = module:New(config)

			-- Flag registration
			if config.Flag and typeof(config.Flag) == "string" and Window.CurrentConfig then
				Window.CurrentConfig:Register(config.Flag, content)
			end

			-- Obsidian global registry
			RegisterInVynx(VynxUI, name, content, config.Flag)

			if content then
				content.Tab    = Tab or tbl
				content.Window = Window
				table.insert(tbl.Elements, content)
				if Window.AllElements then
					table.insert(Window.AllElements, content)
				end
			end

			if OnElementCreateFunction then
				OnElementCreateFunction(name, content)
			end

			return content
		end
	end

	-- Obsidian style: Group:AddToggle(Idx, Info)
	for alias, elemName in next, ObsidianAliases do
		local module = Elems[elemName]
		if module then
			tbl[alias] = function(self, Idx, Info)
				-- Support single-table call: AddToggle({Text="x", Default=false})
				if typeof(Idx) == "table" and Info == nil then
					Info = Idx
					Idx  = Info.Flag or Info.Id or tostring(#tbl.Elements + 1)
				end

				local config = TranslateObsidianConfig(elemName, Idx, Info or {})
				config.Tab         = Tab or tbl
				config.ParentType  = tbl.__type
				config.ParentTable = tbl
				config.Index       = #tbl.Elements + 1
				config.GlobalIndex = Window.AllElements and (#Window.AllElements + 1) or 1
				config.Parent      = Container
				config.Window      = Window
				config.WindUI      = VynxUI
				config.UIScale     = UIScale
				config.ElementsModule = ElementsModule

				local _frame, content = module:New(config)

				-- Global registry (Obsidian pattern)
				if typeof(Idx) == "string" and Idx ~= "" then
					RegisterInVynx(VynxUI, elemName, content, Idx)
				end

				if content then
					content.Tab    = Tab or tbl
					content.Window = Window
					table.insert(tbl.Elements, content)
					if Window.AllElements then
						table.insert(Window.AllElements, content)
					end
				end

				return content
			end
		end
	end

	-- DependencyBox (Obsidian exclusive)
	DependencyBoxModule.AttachToSection(tbl, VynxUI)
end

return {
	Elements = Elements,
	Load     = Load,
}
