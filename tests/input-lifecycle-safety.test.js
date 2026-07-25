const fs = require("fs")

const read = (file) => fs.readFileSync(file, "utf8")
const stripComments = (source) =>
	source
		.replace(/--\[\[[\s\S]*?\]\]/g, "")
		.replace(/--\[(=*)\[[\s\S]*?\]\1\]/g, "")
		.replace(/--[^\n]*/g, "")

const creator = stripComments(read("src/modules/Creator.lua"))
const init = stripComments(read("src/Init.lua"))
const keybind = stripComments(read("src/elements/Keybind.lua"))
const keyBindMenu = stripComments(read("src/components/window/KeyBindMenu.lua"))
const section = stripComments(read("src/elements/Section.lua"))
const slider = stripComments(read("src/elements/Slider.lua"))
const stepper = stripComments(read("src/elements/Stepper.lua"))
const colorpicker = stripComments(read("src/elements/Colorpicker.lua"))
const toggle = stripComments(read("src/components/ui/Toggle.lua"))
const scrollSlider = stripComments(read("src/components/ui/ScrollSlider.lua"))

const disconnectAll = creator.slice(
	creator.indexOf("function Creator.DisconnectAll()"),
	creator.indexOf("function Creator.SafeCallback")
)
const drag = creator.slice(creator.indexOf("function Creator.Drag"), creator.indexOf("Icons.Init"))

const sourceFiles = []
const collectLua = (directory) => {
	for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
		const fullPath = `${directory}/${entry.name}`
		if (entry.isDirectory()) {
			collectLua(fullPath)
		} else if (entry.isFile() && entry.name.endsWith(".lua")) {
			sourceFiles.push(fullPath)
		}
	}
}
collectLua("src")

const hasDeprecatedWait = sourceFiles.some((file) => {
	const source = stripComments(read(file))
	return /(^|[^\w.])wait\s*\(/m.test(source)
})

const checks = {
	disconnectAllDoesNotSkip:
		/for Index = #Creator\.Signals, 1, -1 do/.test(disconnectAll) &&
		/table\.clear\(Creator\.Signals\)/.test(disconnectAll) &&
		!tableRemoveIn(disconnectAll),
	individualSignalCleanup:
		/function Creator\.DisconnectSignal/.test(creator) &&
		/table\.find\(Creator\.Signals, Connection\)/.test(creator),
	dragConnectionsTracked:
		/TrackConnection\(dragFrame\.InputBegan/.test(drag) &&
		/TrackConnection\(UserInputService\.InputChanged/.test(drag) &&
		/TrackConnection\(UserInputService\.InputEnded/.test(drag) &&
		!/Input(?:Began|Changed|Ended):Connect/.test(drag),
	dragCanBeDestroyed:
		/function DragModule:Destroy/.test(drag) &&
		/Creator\.DisconnectSignal\(Connections\[Index\]\)/.test(drag),
	globalInputTracked:
		/Creator\.AddSignal\(UserInputService\.InputBegan/.test(init) &&
		/Creator\.AddSignal\(UserInputService\.InputEnded/.test(init),
	canonicalMouseKeybinds:
		/MouseLeftButton = "MouseLeft"/.test(keybind) &&
		/MouseRightButton = "MouseRight"/.test(keybind) &&
		/return "MouseLeft"/.test(keybind) &&
		/return "MouseRight"/.test(keybind) &&
		!/= "MouseLeftButton"/.test(keybind) &&
		!/= "MouseRightButton"/.test(keybind),
	keybindCaptureCleanup:
		/Creator\.DisconnectSignal\(Connection\)/.test(keybind) &&
		/CaptureBeganConnection = Creator\.AddSignal/.test(keybind) &&
		/CaptureEndedConnection = Creator\.AddSignal/.test(keybind) &&
		/if Key == "Escape" then[\s\S]*StopPicking\(true\)/.test(keybind),
	keybindBlacklistSupportsMouse:
		/BlacklistedKeys\[NormalizeKeyCode\(Item\)\] = true/.test(keybind) &&
		/if BlacklistedKeys\[Key\] then/.test(keybind),
	keybindMenuCaptureTracked:
		/CaptureConnection = Creator\.AddSignal\(UserInputService\.InputBegan/.test(keyBindMenu) &&
		/Creator\.DisconnectSignal\(CaptureConnection\)/.test(keyBindMenu),
	sectionResizeSafe:
		/Creator\.AddSignal\(Main\.Outline\.Top:GetPropertyChangedSignal\("AbsoluteSize"\)/.test(section) &&
		/Section:Close\(true\)/.test(section) &&
		!/Section\.Close\(true\)/.test(section),
	perSliderDragState:
		/function Element:New\(Config\)[\s\S]*local IsSliderHolding = false/.test(slider) &&
		!/local IsSliderHolding = false\s*\n\s*function Element:New/.test(slider),
	trackedControlDrags: [slider, stepper, toggle, scrollSlider].every(
		(source) =>
			/Creator\.AddSignal\(UserInputService\.Input(?:Changed|Ended)|Creator\.AddSignal\(RunService\.RenderStepped/.test(
				source
			) && !/UserInputService\.Input(?:Changed|Ended):Connect|RunService\.RenderStepped:Connect/.test(source)
	),
	controlDragCleanup: [slider, stepper, toggle, scrollSlider].every((source) =>
		/Creator\.DisconnectSignal/.test(source)
	),
	toggleInputOwnership:
		/local InputOwnerId/.test(toggle) &&
		/Config\.WindUI\.CurrentInput == InputOwnerId/.test(toggle) &&
		/if WasDragging and Config\.Window then/.test(toggle),
	colorpickerStateIsLocal:
		/function Element:Colorpicker[\s\S]*local ActiveSlider[\s\S]*local ActiveInput/.test(colorpicker) &&
		!/local ActiveSlider\s*=\s*nil\s*\n\s*function Element:Colorpicker/.test(colorpicker),
	colorpickerTouchTracking:
		/return Input\.Position\.X, Input\.Position\.Y/.test(colorpicker) &&
		/ActiveInput\.UserInputType == Enum\.UserInputType\.Touch and input == ActiveInput/.test(colorpicker) &&
		/if Width <= 0 or Height <= 0 then/.test(colorpicker),
	noDeprecatedWait: !hasDeprecatedWait,
}

function tableRemoveIn(source) {
	return /table\.remove\(Creator\.Signals/.test(source)
}

const failed = Object.entries(checks).filter(([, ok]) => !ok)
if (failed.length > 0) {
	throw new Error(`Input lifecycle regression: ${failed.map(([name]) => name).join(", ")}`)
}

console.log("PASS input lifecycle safety")
