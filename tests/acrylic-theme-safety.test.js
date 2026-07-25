const fs = require("fs")

const creator = fs.readFileSync("src/modules/Creator.lua", "utf8")
const init = fs.readFileSync("src/Init.lua", "utf8")

const safeLookup = /local function getValue\(prop, themeTable\)[\s\S]{0,180}if typeof\(themeTable\) ~= "table" then/.test(
	creator
)
const safeWindowTheme = /Theme = Theme or WindUI\.Theme or WindUI\.Themes\["Dark"\]/.test(init)

if (!safeLookup || !safeWindowTheme) {
	throw new Error(
		`Acrylic theme fallback is unsafe: nilLookupGuard=${safeLookup}, windowThemeFallback=${safeWindowTheme}`
	)
}

console.log("PASS acrylic theme safety")
