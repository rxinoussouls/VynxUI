local WindUI = require("../src/Init")

local Window = WindUI:CreateWindow({
	Title = "Acrylic Theme Fallback Test",
	Theme = "ThemeThatDoesNotExist",
	Acrylic = true,
})

assert(Window ~= nil)
assert(WindUI:GetCurrentTheme() == "Dark")
