local VynxUI = require("../src/Init")

local Window = VynxUI:CreateWindow({
	Title = "Acrylic Theme Fallback Test",
	Theme = "ThemeThatDoesNotExist",
	Acrylic = true,
})

assert(Window ~= nil)
assert(VynxUI:GetCurrentTheme() == "Dark")
