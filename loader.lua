local CACHE_KEY = "1.6.65-ui-runtime-9"
local REQUIRED_API = {
	"RegisterIconPack",
	"GetIconSources",
	"ExpandOpenButton",
	"HideOpenButton",
	"AdapterVersion=3",
	"CreateUIShadow",
	'LayoutVersion",4',
	"WindUILinkedCorner",
	"WindowMorphScale",
	"DropdownBackdrop",
	"InternalCenter",
	"DirectImageLabel",
	"UseGlassSpritesheet",
	"UseHoldAnimation",
	"TopTabHolder",
	"Originally",
	"MacAccent",
	"DarkOverlay",
	"LoadingProgress",
}
local SOURCE_URL = "https://article-hub-studio.github.io/WindUI-Skibidi/dist/main.lua?v=" .. CACHE_KEY

local Success, Source = pcall(function()
	return game:HttpGet(SOURCE_URL)
end)

if not Success or type(Source) ~= "string" or #Source <= 1000 then
	error("[WindUI Modded] Canonical runtime is unavailable: " .. tostring(Source))
end

local Prefix = string.lower(string.sub(Source, 1, 220))
if
	string.find(Prefix, "429:", 1, true)
	or string.find(Prefix, "too many requests", 1, true)
	or string.find(Prefix, "<html", 1, true)
	or string.find(Prefix, "<!doctype", 1, true)
then
	error("[WindUI Modded] Canonical runtime returned an invalid response")
end

for _, Method in REQUIRED_API do
	if not string.find(Source, Method, 1, true) then
		error("[WindUI Modded] Canonical runtime is outdated (missing " .. Method .. ")")
	end
end

local Chunk, CompileError = loadstring(Source)
if not Chunk then
	error("[WindUI Modded] Runtime compile failed: " .. tostring(CompileError))
end

local Ran, Library = pcall(Chunk)
if not Ran then
	error("[WindUI Modded] Runtime failed: " .. tostring(Library))
end

return Library
