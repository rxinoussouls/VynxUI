local CACHE_KEY = "1.2.0-vynx-runtime-1"
local REQUIRED_API = {
	"CreateWindow",
	"SetTheme",
	"SetMotionPreset",
	"DynamicIsland",
	"AddDraggableLabel",
	"AddDraggableButton",
	"DependencyBox",
	"Toggles",
	"Options",
	"GiveSignal",
	"OnUnload",
	"Unload",
	"VynxUI",
}
local SOURCE_URL = "https://raw.githubusercontent.com/rxinoussouls/VynxUI/main/build/VynxUI.lua?v=" .. CACHE_KEY

local Success, Source = pcall(function()
	return game:HttpGet(SOURCE_URL)
end)

if not Success or type(Source) ~= "string" or #Source <= 1000 then
	error("[VynxUI] Canonical runtime is unavailable: " .. tostring(Source))
end

local Prefix = string.lower(string.sub(Source, 1, 220))
if
	string.find(Prefix, "429:", 1, true)
	or string.find(Prefix, "too many requests", 1, true)
	or string.find(Prefix, "<html", 1, true)
	or string.find(Prefix, "<!doctype", 1, true)
then
	error("[VynxUI] Canonical runtime returned an invalid response")
end

for _, Method in REQUIRED_API do
	if not string.find(Source, Method, 1, true) then
		error("[VynxUI] Canonical runtime is outdated (missing " .. Method .. ")")
	end
end

local Chunk, CompileError = loadstring(Source)
if not Chunk then
	error("[VynxUI] Runtime compile failed: " .. tostring(CompileError))
end

local Ran, Library = pcall(Chunk)
if not Ran then
	error("[VynxUI] Runtime failed: " .. tostring(Library))
end

return Library
