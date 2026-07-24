--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /
    |__/|__/_/_//_/\_,_/\____/___/

    v1.6.65  |  2026-07-20  |  Roblox UI Library for scripts

    To view the source code, see the `src/` folder on the official GitHub repository.

    Author: Footagesus (Footages, .ftgs, oftgs)
    Github: https://github.com/article-hub-studio/WindUI-Skibidi
    Discord: https://discord.gg/ftgs-development-hub-1300692552005189632
    License: MIT
]]

type ConfigType__DARKLUA_TYPE_a={
Object:Instance,
Camera:Instance?,
Interactive:boolean?,
Height:number?,
Focused:boolean,

Window:any,
WindUI:any,
Tab:any,
Parent:Instance,
}local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()

local b

local d={
New=nil,
Init=nil,
Wrappers=setmetatable({},{__mode="k"}),
Shapes={
Circle={
Image="rbxassetid://111665032676235",
Rect=Rect.new(512,512,512,512),
Radius=512,
},
CircleOutline={
Image="rbxassetid://108556680453287",
Rect=Rect.new(512,512,512,512),
Radius=512,
},
CircleGlass={
Image="rbxassetid://95600044758841",
Rect=Rect.new(512,512,512,512),
Radius=512,
},



SquircleH={
Image="rbxassetid://125083578015333",
Rect=Rect.new(512,325,512,325),
Radius=325,
},
SquircleHOutline={
Image="rbxassetid://107043713170567",
Rect=Rect.new(512,325,512,325),
Radius=325,
},
SquircleHGlass={
Image="rbxassetid://84819521201001",
Rect=Rect.new(512,325,512,325),
Radius=325,
},
["SquircleH-TL-TR"]={
Image="rbxassetid://90680657206619",
Rect=Rect.new(807,512,807,512),
Radius=325,
AutoChange=false,
},
["SquircleH-BL-BR"]={
Image="rbxassetid://99216342056719",
Rect=Rect.new(0,512,0,512),
Radius=325,
AutoChange=false,
},

SquircleV={
Image="rbxassetid://124965260437653",
Rect=Rect.new(325,512,325,512),
Radius=325,
},
SquircleVOutline={
Image="rbxassetid://88808835404198",
Rect=Rect.new(325,512,325,512),
Radius=325,
},
SquircleVGlass={
Image="rbxassetid://124982801466667",
Rect=Rect.new(325,512,325,512),
Radius=325,
},

Squircle={
Image="rbxassetid://89641024074289",
Rect=Rect.new(460,460,460,460),
Radius=310,
},
SquircleOutline={
Image="rbxassetid://74029063732681",
Rect=Rect.new(512,512,512,512),
Radius=310,
},
SquircleGlass={
Image="rbxassetid://131126436897551",
Rect=Rect.new(512,512,512,512),
Radius=310,
},

["Squircle-TL-TR"]={
Image="rbxassetid://75712142040725",
Rect=Rect.new(512,512,512,512),
Radius=310,
AutoChange=false,
},
["Squircle-BL-BR"]={
Image="rbxassetid://83676684425544",
Rect=Rect.new(512,0,512,0),
Radius=310,
AutoChange=false,
},Square=
{
Image="rbxassetid://82909646051652",
Rect=Rect.new(512,512,512,512),
Radius=512,
AutoChange=false,
},
},
}

function d.Init(e,f)
b=f
return e.New
end

function d.New(e,f,g,h,i,j,l)
local m={
Radius=f or 0,
Type=g or"Circle",
GetRadius=nil,
GetType=nil,
SetRadius=nil,
SetType=nil,
SetLinkedCorners=nil,
}

local p={
["Glass-0.7"]="SquircleGlass",
["Glass-1"]="SquircleGlass",
["Glass-1.4"]="SquircleGlass",
["Squircle-Outline"]="SquircleOutline",
}

local function GetShape(r)
return d.Shapes[p[r]or r]or d.Shapes.Circle
end

local r=b.New(j and"ImageButton"or"ImageLabel",{
Image="",
ScaleType=l~=false and"Slice"or nil,
SliceCenter=m.Type~="Squircle"and Rect.new(512,512,512,512)or nil,
SliceScale=1,
ThemeTag=h and h.ThemeTag or nil,
BackgroundTransparency=1,
},i)

for u,v in next,h do
if not table.find({"ThemeTag"},u)then
r[u]=v
end
end

function m.SetRadius(u,v)
m.Radius=v
r.SliceScale=math.max(v/GetShape(m.Type).Radius,0.0001)
return m
end

local function ApplyType(u)
m.Type=u
local v=GetShape(u)
r.Image=v.Image
r.SliceCenter=v.Rect
m:SetRadius(m.Radius)
end

function m.SetType(u,v)
if m.LinkedCorners then
m.LinkedBaseType=v
return m
end

ApplyType(v)
return m
end

function m.SetLinkedCorners(u,v,x)
if v then
if not m.LinkedCorners then
m.LinkedBaseType=m.Type
end
m.LinkedCorners=v
ApplyType"Square"

local z=r:FindFirstChild"WindUILinkedCorner"
if not z then
z=b.New("UICorner",{
Name="WindUILinkedCorner",
Parent=r,
})
end
b.ApplyCornerRadii(z,x or m.Radius,v)
else
m.LinkedCorners=nil
ApplyType(m.LinkedBaseType or"Squircle")
m.LinkedBaseType=nil
local z=r:FindFirstChild"WindUILinkedCorner"
if z then
z:Destroy()
end
end
return m
end

function m.GetRadius(u)
return m.Radius
end

function m.GetType(u)
return m.Type
end

m:SetRadius(f)
m:SetType(g)
d.Wrappers[r]=m

b.AddSignal(r:GetPropertyChangedSignal"AbsoluteSize",function()
local u=GetShape(m.Type)
if u.AutoChange==false or m.LinkedCorners then
return
end

if string.find(m.Type,"Squircle")then
local v=string.find(m.Type,"Glass")and"Glass"or nil
local x=string.find(m.Type,"Outline")and"Outline"or nil

local z=math.round(r.AbsoluteSize.X/b.UIScale)
local A=math.round(r.AbsoluteSize.Y/b.UIScale)

local B=m.Radius~=0 and m.Radius or math.min(z,A)/2
local C=d.Shapes.Squircle.Radius/1024
local F=B/math.min(z,A)

local G

if z>A then
if F>=C then
G="SquircleH"..(x or v or"")
else
G="Squircle"..(x or v or"")
end
elseif z<A then
if F>=C then
G="SquircleV"..(x or v or"")
else
G="Squircle"..(x or v or"")
end
else
if F>=C then
G="Circle"..(x or v or"")
else
G="Squircle"..(x or v or"")
end
end

if G~=m:GetType()then
m:SetType(G)
end
end
end)

return r,m
end

function d.GetWrapper(e,f)
return d.Wrappers[f]
end

return d end function a.b()

local b=(cloneref or clonereference or function(b)
return b
end)

local d=b(game:GetService"ReplicatedStorage")
local e=b(game:GetService"HttpService")
local f=b(game:GetService"RunService")

local g="https://article-hub-studio.github.io/WindUI-Skibidi/vendor/icons/Main-v2.lua"

local function LoadBaseIcons()
local h=d:FindFirstChild"GetIcons"
if
h
and h:IsA"RemoteFunction"
and(f:IsStudio()or h:GetAttribute"WindUIIcons"==true)
then
local i,j=pcall(function()
return h:InvokeServer()
end)
if i and typeof(j)=="table"then
return j
end
end

local i,j=pcall(function()
if game.HttpGet then
return game:HttpGet(g)
end
return e:GetAsync(g)
end)
if i and type(j)=="string"and type(loadstring)=="function"then
local l=loadstring(j)
if l then
local m,p=pcall(l)
if m and typeof(p)=="table"then
return p
end
end
end

warn"[ WindUI.Icons ] Unable to load the base icon catalog; custom sources remain available"
return{}
end

local h=LoadBaseIcons()
h.AdapterVersion=3

local i={
lucidev="lucide",
lucideicons="lucide",
sf="sfsymbols",
sfsymbol="sfsymbols",
sf_symbols="sfsymbols",
gravityui="gravity",
gravity_ui="gravity",
}

h.Icons=if typeof(h.Icons)=="table"then h.Icons else{}
h.IconsType=h.IconsType or"lucide"
h.SourceAliases=if typeof(h.SourceAliases)=="table"then h.SourceAliases else{}
h.Resolvers=if typeof(h.Resolvers)=="table"then h.Resolvers else{}
h.FallbackAcrossSources=h.FallbackAcrossSources~=false

for j,l in i do
if h.SourceAliases[j]==nil then
h.SourceAliases[j]=l
end
end

local j

local function NormalizeSourceName(l)
if type(l)~="string"then
return nil
end

local m=l:lower():gsub("%s+",""):gsub("[^%w_%-]","")
if m==""then
return nil
end
return m
end

local function ResolveSourceAlias(l)
local m=NormalizeSourceName(l)
local p={}

for r=1,8 do
if not m or p[m]then
break
end
p[m]=true

local u=h.SourceAliases[m]
if not u then
break
end
m=NormalizeSourceName(u)
end

return m
end

local function NormalizeImage(l)
if type(l)=="number"then
return"rbxassetid://"..tostring(l)
end
if type(l)~="string"then
return nil
end

if l:match"^%d+$"then
return"rbxassetid://"..l
end
return l
end

local function IsDirectImage(l)
if type(l)=="number"then
return true
end
if type(l)~="string"then
return false
end

return l:match"^%d+$"~=nil
or l:match"^rbxassetid://"~=nil
or l:match"^rbxthumb://"~=nil
or l:match"^rbxgameasset://"~=nil
or l:match"^https?://"~=nil
end

local function NormalizeVector2(l)
if typeof(l)=="Vector2"then
return l
end
if typeof(l)=="table"then
return Vector2.new(tonumber(l.X or l.x or l[1])or 0,tonumber(l.Y or l.y or l[2])or 0)
end
return Vector2.zero
end

local function NormalizeDescriptor(l)
if IsDirectImage(l)then
return{
Image=NormalizeImage(l),
ImageRectSize=Vector2.zero,
ImageRectPosition=Vector2.zero,
Parts=nil,
}
end

if typeof(l)~="table"then
return nil
end

local m=l.Image or l.Asset or l.AssetId or l.Id or l.URL or l.Url
if not IsDirectImage(m)then
return nil
end

return{
Image=NormalizeImage(m),
ImageRectSize=NormalizeVector2(l.ImageRectSize or l.RectSize or l.Size),
ImageRectPosition=NormalizeVector2(
l.ImageRectPosition or l.ImageRectOffset or l.RectPosition or l.Offset
),
Parts=l.Parts,
}
end

local function ParseIconReference(l)
if typeof(l)=="table"then
return l.Source or l.Pack or l.Library or l.Type,l.Name or l.Icon or l.Key,l
end

if type(l)~="string"or IsDirectImage(l)then
return nil,l,l
end

local m,p=l:match"^@([%w_%-]+)/(.+)$"
if not m then
m,p=l:match"^([%w_%-]+):(.+)$"
end
if not m then
m,p=l:match"^([%w_%-]+)/(.+)$"
end

return m,p or l,l
end

local function FindSource(l)
local m=ResolveSourceAlias(l)
if not m then
return nil,nil
end

if h.Icons[m]then
return h.Icons[m],m
end

for p,r in h.Icons do
if NormalizeSourceName(p)==m then
return r,p
end
end

return nil,m
end

local function GetSourceNames()
local l={}
for m in h.Icons do
table.insert(l,tostring(m))
end
table.sort(l,function(m,p)
return m:lower()<p:lower()
end)
return l
end

local l

local function ResolvePackIcon(m,p,r)
if typeof(m)~="table"or p==nil then
return nil
end

local u=if typeof(m.Icons)=="table"then m.Icons else m
local v=u[p]
if v==nil then
local x=tostring(p):lower()
for z,A in u do
if tostring(z):lower()==x then
v=A
break
end
end
end

if typeof(v)=="table"and v.Alias then
return l(v.Alias,nil,(r or 0)+1)
end

local x=typeof(v)=="table"
and(v.Image or v.Asset or v.AssetId or v.Id or v.URL or v.Url)
or v
local z=NormalizeDescriptor(v)
if not z then
return nil
end

if typeof(m.Spritesheets)=="table"then
z.Image=m.Spritesheets[x]
or m.Spritesheets[tostring(x)]
or m.Spritesheets[z.Image]
or m.Spritesheets[tostring(z.Image)]
or z.Image
end

return z
end

local function ResolveProviderIcon(m,p)
local r=h.Resolvers[ResolveSourceAlias(m)]
if typeof(r)~="function"then
return nil
end

local u,v=pcall(r,p,m)
if not u then
warn(string.format("[ WindUI.Icons ] Source '%s' failed: %s",tostring(m),tostring(v)))
return nil
end

return NormalizeDescriptor(v)
end

l=function(m,p,r)
if(r or 0)>8 then
return nil
end

local u=NormalizeDescriptor(m)
if u then
return u
end

local v,x,z=ParseIconReference(m)
if typeof(z)=="table"and z.Alias then
return l(z.Alias,p,(r or 0)+1)
end

local A=ResolveSourceAlias(v or p or h.IconsType)
if A then
local B=FindSource(A)
local C=ResolvePackIcon(B,x,r)or ResolveProviderIcon(A,x)
if C then
return C
end
end

if v or not h.FallbackAcrossSources then
return nil
end

for B,C in GetSourceNames()do
if ResolveSourceAlias(C)~=A then
local F=ResolvePackIcon(h.Icons[C],x,r)
if F then
return F
end
end
end

for B,C in h.Resolvers do
if B~=A and typeof(C)=="function"then
local F=ResolveProviderIcon(B,x)
if F then
return F
end
end
end

return nil
end

local function FormatDescriptor(m,p)
if not m then
return nil
end

if p==false and m.ImageRectSize==Vector2.zero and not m.Parts then
return m.Image
end

return{m.Image,m}
end

function h.AddSourceAlias(m,p)
local r=NormalizeSourceName(m)
local u=NormalizeSourceName(p)
assert(r and u,"AddSourceAlias: alias and source must be non-empty strings")
h.SourceAliases[r]=u
return h
end

function h.RegisterIconSource(m,p,r)
local u=NormalizeSourceName(m)
assert(u,"RegisterIconSource: source must be a non-empty string")

if typeof(p)=="function"then
h.Resolvers[u]=p
elseif typeof(p)=="table"then
h.AddIcons(u,p)
else
error"RegisterIconSource: provider must be a function or icon table"
end

if typeof(r)=="table"then
for v,x in r.Aliases or{}do
h.AddSourceAlias(x,u)
end
end

return h
end

function h.AddIcons(m,p)
local r=NormalizeSourceName(m)
assert(r and typeof(p)=="table","AddIcons: packName must be string and iconsData must be table")

local u=h.Icons[r]
if typeof(u)~="table"or typeof(u.Icons)~="table"then
u={
Icons={},
Spritesheets={},
}
h.Icons[r]=u
end

for v,x in p do
local z=NormalizeDescriptor(x)
if z then
u.Icons[v]=z
u.Spritesheets[z.Image]=z.Image
elseif typeof(x)=="table"and x.Alias then
u.Icons[v]={Alias=x.Alias}
else
warn(string.format("[ WindUI.Icons ] Ignored invalid icon '%s:%s'",r,tostring(v)))
end
end

return h
end

h.RegisterIconPack=h.AddIcons
h.AddIconSource=h.RegisterIconSource

function h.AddIcon(m,p,r)
return h.AddIcons(m,{[p]=r})
end

function h.SetIconsType(m)
local p=ResolveSourceAlias(m)
assert(p,"SetIconsType: icon type must be a non-empty string")
h.IconsType=p
return h
end

function h.GetIconSources()
local m=GetSourceNames()
for p in h.Resolvers do
if not table.find(m,p)then
table.insert(m,p)
end
end
table.sort(m)
return m
end

function h.HasIcon(m,p)
return l(m,p,0)~=nil
end

function h.Init(m,p)
h.New=m
h.IconThemeTag=p
j=m
return h
end

function h.Icon(m,p,r)
return FormatDescriptor(l(m,p,0),r~=false)
end

function h.GetIcon(m,p)
return h.Icon(m,p,false)
end

function h.Icon2(m,p)
return h.Icon(m,p,true)
end

local function ResolveStyle(m,p,r)
local u=m[p]
if u==nil then
u=m[1]
end
if u==nil then
u=r
end

return{
ThemeTag=typeof(u)=="string"and u or nil,
Color=typeof(u)=="Color3"and u or nil,
Value=typeof(u)=="number"and u or nil,
}
end

local function CreateImageLabel(m)
if j then
return j("ImageLabel",m)
end

local p=Instance.new"ImageLabel"
for r,u in m do
if r~="ThemeTag"and u~=nil then
p[r]=u
end
end
return p
end

function h.Image(m)
m=if typeof(m)=="table"then m else{}
local p={
Icon=m.Icon,
Type=m.Type,
Colors=m.Colors or{h.IconThemeTag or Color3.new(1,1,1)},
Transparency=m.Transparency or{0},
Size=m.Size or UDim2.fromOffset(24,24),
IconFrame=nil,
}

local r=h.Icon2(p.Icon,p.Type)
local u=r and r[1]or""
local v=r and r[2]
or{
ImageRectSize=Vector2.zero,
ImageRectPosition=Vector2.zero,
}
local x=ResolveStyle(p.Colors,1,h.IconThemeTag or Color3.new(1,1,1))
local z=ResolveStyle(p.Transparency,1,0)

local A=CreateImageLabel{
Name="Icon",
Size=p.Size,
BackgroundTransparency=1,
ImageColor3=x.Color,
ImageTransparency=z.Value,
ThemeTag=x.ThemeTag and{
ImageColor3=x.ThemeTag,
ImageTransparency=z.ThemeTag,
}or nil,
Image=u,
ImageRectSize=v.ImageRectSize,
ImageRectOffset=v.ImageRectPosition,
}

local B=ParseIconReference(p.Icon)
for C,F in v.Parts or{}do
local G=h.Icon2(F,B or p.Type)
if G then
local H=ResolveStyle(p.Colors,C+1,x.Color or x.ThemeTag)
local J=ResolveStyle(p.Transparency,C+1,z.Value or 0)
CreateImageLabel{
Name="Part"..tostring(C),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ImageColor3=H.Color,
ImageTransparency=J.Value,
ThemeTag=H.ThemeTag and{
ImageColor3=H.ThemeTag,
ImageTransparency=J.ThemeTag,
}or nil,
Image=G[1],
ImageRectSize=G[2].ImageRectSize,
ImageRectOffset=G[2].ImageRectPosition,
Parent=A,
}
end
end

p.IconFrame=A
return p
end

return h end function a.c()

return function(b)
return{


Primary="Icon",

White=Color3.new(1,1,1),
Black=Color3.new(0,0,0),

Dialog="Accent",

Background="Accent",
BackgroundTransparency=0,
Hover="Text",

PanelBackground="White",
PanelBackgroundTransparency=0.95,

WindowBackground="Background",

WindowShadow="Black",


WindowTopbarTitle="Text",
WindowTopbarAuthor="Text",
WindowTopbarIcon="Icon",
WindowTopbarButtonIcon="Icon",


WindowSearchBarBackground="Dialog",

TabBackground="Hover",
TabBackgroundHover="Hover",
TabBackgroundHoverTransparency=0.97,
TabBackgroundActive="Hover",
TabBackgroundActiveTransparency=0.93,
TabText="Text",
TabTextTransparency=0.3,
TabTextTransparencyActive=0,
TabTitle="Text",
TabIcon="Icon",
TabIconTransparency=0.4,
TabIconTransparencyActive=0.1,
TabBorderTransparency=1,
TabBorderTransparencyActive=0.75,
TabBorder="White",

ElementBackground="Text",
ElementBackgroundTransparency=0.93,
ElementBackgroundHover=b:AddColor("ElementBackground","#ffffff",0.1),
ElementTitle="Text",
ElementDesc="Text",
ElementIcon="Icon",

RadioGroupBackground="ElementBackground",
RadioGroupText="Text",
RadioGroupBorder="Text",
RadioGroupActive="Primary",

CheckboxGroupBackground="ElementBackground",
CheckboxGroupText="Text",
CheckboxGroupBorder="Text",
CheckboxGroupActive="Primary",
CheckboxGroupIcon="White",

SegmentedControlBackground="ElementBackground",
SegmentedControlActive="Primary",
SegmentedControlText="Text",

StepperButton="ElementBackground",
StepperValueBackground="ElementBackground",
StepperIcon="Icon",
StepperText="Text",

BadgeBackground="Primary",
BadgeText="White",
BadgeIcon="White",

KeyValueIcon="Icon",
ChipListBackground="ElementBackground",
TimelineLine="Text",
AccordionBackground="ElementBackground",
AccordionIcon="Icon",
TabBoxTabBackground="ElementBackground",
TabBoxIcon="Icon",
EmptyStateIcon="Icon",
DiscordCardBackground="ElementBackground",
DiscordCardAccent="Primary",
Path2DBackground="ElementBackground",
Path2DTrack="ElementBackground",
Path2DLine="Primary",
Path2DMarker="Primary",
Path2DLabel="Text",

PopupBackground="Background",
PopupBackgroundTransparency="BackgroundTransparency",
PopupTitle="Text",
PopupContent="Text",
PopupIcon="Icon",

DialogBackground="Dialog",
DialogBackgroundTransparency="BackgroundTransparency",
DialogTitle="Text",
DialogContent="Text",
DialogIcon="Icon",

Toggle="Button",
ToggleBar="White",

Checkbox="Primary",
CheckboxIcon="White",
CheckboxBorder="White",
CheckboxBorderTransparency=0.75,

SliderIcon="Icon",

Slider="Primary",
SliderThumb="White",
SliderIconFrom="SliderIcon",
SliderIconTo="SliderIcon",

ProgressBar="Primary",
ProgressBarTrack="Text",
ProgressBarTrackTransparency=0.9,
ProgressBarText="Text",

Tooltip=Color3.fromHex"4C4C4C",
TooltipText="White",
TooltipSecondary="Primary",
TooltipSecondaryText="White",

TabSectionIcon="Icon",

SectionIcon="Icon",

SectionExpandIcon="Icon",
SectionExpandIconTransparency=0.4,
SectionBox="Text",
SectionBoxTransparency=0.95,
SectionBoxBorder="White",
SectionBoxBorderTransparency=0.75,
SectionBoxBackground="Text",
SectionBoxBackgroundTransparency=0.97,

SearchBarBorder="White",
SearchBarBorderTransparency=0.75,

Notification="Dialog",
NotificationTransparency=0.08,
NotificationGlass="Dialog",
NotificationGlassTransparency=0.28,
NotificationGlassSurface="White",
NotificationGlassSurfaceTransparency=0.91,
NotificationGlassHighlight="White",
NotificationGlassTextureTransparency=0.78,
Notification2="White",
Notification2Transparency=0.985,
NotificationTitle="Text",
NotificationTitleTransparency=0,
NotificationContent="Text",
NotificationContentTransparency=0.32,
NotificationDuration="White",
NotificationDurationTransparency=0.94,
NotificationBorder="White",
NotificationBorderTransparency=0.76,

DropdownTabBorder="White",
DropdownTabBackground="ElementBackground",
DropdownBackground="Background",

LabelBackground="White",
LabelBackgroundTransparency=0.95,

ViewportBackground="ElementBackground",
ViewportBackgroundTransparency="ElementBackgroundTransparency",
}
end end function a.d()

local b=(cloneref or clonereference or function(b)
return b
end)

local d=b(game:GetService"RunService")
local e=b(game:GetService"UserInputService")
local f=b(game:GetService"TweenService")
local g=b(game:GetService"LocalizationService")
local h=b(game:GetService"HttpService")

local i=a.load'a'
local j=a.load'b'local l=

d.Heartbeat

j.SetIconsType"lucide"

local m

local p
p={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=j,
IconAdapterVersion=j.AdapterVersion or 1,
Signals={},
Objects={},
LocalizationObjects={},
UIScale=1,
FontObjects={},
Language=string.match(g.SystemLocaleId,"^[a-z]+"),
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
},
VideoFrame={
BorderSizePixel=0,
},
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
},
ThemeFallbacks=nil,





















ThemeChangeCallbacks={},
}

function p.Init(r)
m=r

p.ThemeFallbacks=a.load'c'(p)

p.UIScale=r.UIScale

i:Init(p)
end

function p.AddSignal(r,u)
local v=r:Connect(u)
table.insert(p.Signals,v)
return v
end

function p.DisconnectAll()
for r,u in next,p.Signals do
local v=table.remove(p.Signals,r)
v:Disconnect()
end
end

function p.SafeCallback(r,...)
if not r then
return
end

local u,v=pcall(r,...)
if not u then
if m and m.Window and m.Window.Debug then local
x, z=v:find":%d+: "

warn("[ WindUI: DEBUG Mode ] "..v)

return m:Notify{
Title="DEBUG Mode: Error",
Content=not z and v or v:sub(z+1),
Style="Error",
Duration=8,
}
end
end
end

function p.Gradient(r,u)
if m and m.Gradient then
return m:Gradient(r,u)
end

local v={}
local x={}

for z,A in next,r do
local B=tonumber(z)
if B then
B=math.clamp(B/100,0,1)
table.insert(v,ColorSequenceKeypoint.new(B,A.Color))
table.insert(x,NumberSequenceKeypoint.new(B,A.Transparency or 0))
end
end

table.sort(v,function(z,A)
return z.Time<A.Time
end)
table.sort(x,function(z,A)
return z.Time<A.Time
end)

if#v<2 then
error"ColorSequence requires at least 2 keypoints"
end

local z={
Color=ColorSequence.new(v),
Transparency=NumberSequence.new(x),
}

if u then
for A,B in pairs(u)do
z[A]=B
end
end

return z
end

function p.SetTheme(r)
if typeof(r)~="table"then
r=p.Theme or(p.Themes and p.Themes.Dark)
end
if typeof(r)~="table"then
return nil
end

local u=p.Theme
p.Theme=r
p.UpdateTheme(nil,false)

for v,x in next,p.ThemeChangeCallbacks do
p.SafeCallback(x,r,u)
end

return r
end

function p.AddFontObject(r)
table.insert(p.FontObjects,r)
p.UpdateFont(p.Font)
end

function p.UpdateFont(r)
p.Font=r
for u,v in next,p.FontObjects do
v.FontFace=Font.new(r,v.FontFace.Weight,v.FontFace.Style)
end
end

function p.GetThemeProperty(r,u)
local function getValue(v,x)
if typeof(x)~="table"then
return nil
end

local z=x[v]

if z==nil then
return nil
end

if typeof(z)=="string"and string.sub(z,1,1)=="#"then
return Color3.fromHex(z)
end

if typeof(z)=="Color3"then
return z
end

if typeof(z)=="number"then
return z
end

if typeof(z)=="table"and z.Color and z.Transparency then
return z
end

if typeof(z)=="function"then
return z(x)
end

return z
end

u=if typeof(u)=="table"then u else p.Theme

local v=getValue(r,u)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local x=p.GetThemeProperty(v,u)
if x~=nil then
return x
end
else
return v
end
end

local x=p.ThemeFallbacks and p.ThemeFallbacks[r]
if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,u)
else
return getValue(r,{[r]=x})
end
end

local z=p.Themes and p.Themes.Dark
v=getValue(r,z)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local A=p.GetThemeProperty(v,z)
if A~=nil then
return A
end
else
return v
end
end

if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,z)
else
return getValue(r,{[r]=x})
end
end

return nil
end

function p.AddThemeObject(r,u,v)
if p.Objects[r]then
for x,z in pairs(u)do
p.Objects[r].Properties[x]=z
end
else
p.Objects[r]={Object=r,Properties=u}
end

if not v then
p.UpdateTheme(r,false)
end
return r
end

function p.AddLangObject(r)
local u=p.LocalizationObjects[r]
if not u then
return
end

local v=u.Object

p.SetLangForObject(r)

return v
end

function p.UpdateTheme(r,u,v,x,z,A)
local function ApplyTheme(B)
for C,F in pairs(B.Properties or{})do
local G=p.GetThemeProperty(F,p.Theme)
if G~=nil then
if typeof(G)=="Color3"then
local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end

if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
elseif typeof(G)=="table"and G.Color and G.Transparency then
B.Object[C]=Color3.new(1,1,1)

local H=B.Object:FindFirstChild"LibraryGradient"
if not H then
H=Instance.new"UIGradient"
H.Name="LibraryGradient"
H.Parent=B.Object
end

H.Color=G.Color
H.Transparency=G.Transparency

for J,L in pairs(G)do
if J~="Color"and J~="Transparency"and H[J]~=nil then
H[J]=L
end
end
elseif typeof(G)=="number"then
if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
end
else
local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end
end
end
end

if r then
local B=p.Objects[r]
if B then
ApplyTheme(B)
end
else
for B,C in pairs(p.Objects)do
ApplyTheme(C)
end
end
end

function p.SetThemeTag(r,u,v,x,z)
p.AddThemeObject(r,u)
p.UpdateTheme(r,false,true,v,x,z)
end

function p.SetLangForObject(r)
if p.Localization and p.Localization.Enabled then
local u=p.LocalizationObjects[r]
if not u then
return
end

local v=u.Object
local x=u.TranslationId

local z=p.Localization.Translations[p.Language]
if z and z[x]then
v.Text=z[x]
else
local A=p.Localization
and p.Localization.Translations
and p.Localization.Translations.en
or nil
if A and A[x]then
v.Text=A[x]
else
v.Text="["..x.."]"
end
end
end
end

function p.ChangeTranslationKey(r,u,v)
if p.Localization and p.Localization.Enabled then
local x=string.match(v,"^"..p.Localization.Prefix.."(.+)")
if x then
for z,A in ipairs(p.LocalizationObjects)do
if A.Object==u then
A.TranslationId=x
p.SetLangForObject(z)
return
end
end

table.insert(p.LocalizationObjects,{
TranslationId=x,
Object=u,
})
p.SetLangForObject(#p.LocalizationObjects)
end
end
end

function p.UpdateLang(r)
if r then
p.Language=r
end

for u=1,#p.LocalizationObjects do
local v=p.LocalizationObjects[u]
if v.Object and v.Object.Parent~=nil then
p.SetLangForObject(u)
else
p.LocalizationObjects[u]=nil
end
end
end

function p.SetLanguage(r)
p.Language=r
p.UpdateLang()
end

function p.Icon(r,u)
return j.Icon(r,nil,u~=false)
end

function p.AddIcons(r,u)
return j.AddIcons(r,u)
end

function p.AddIcon(r,u,v)
return j.AddIcon(r,u,v)
end

function p.RegisterIconSource(r,u,v)
return j.RegisterIconSource(r,u,v)
end

p.RegisterIconPack=p.AddIcons
p.AddIconSource=p.RegisterIconSource

function p.AddIconSourceAlias(r,u)
return j.AddSourceAlias(r,u)
end

function p.SetIconSource(r)
return j.SetIconsType(r)
end

function p.GetIconSources()
return j.GetIconSources()
end

function p.HasIcon(r,u)
return j.HasIcon(r,u)
end

function p.New(r,u,v)
local x=Instance.new(r)

for z,A in next,p.DefaultProperties[r]or{}do
x[z]=A
end

for z,A in next,u or{}do
if z~="ThemeTag"then
x[z]=A
end
if p.Localization and p.Localization.Enabled and z=="Text"then
local B=string.match(A,"^"..p.Localization.Prefix.."(.+)")
if B then
local C=#p.LocalizationObjects+1
p.LocalizationObjects[C]={TranslationId=B,Object=x}

p.SetLangForObject(C)
end
end
end

for z,A in next,v or{}do
A.Parent=x
end

if u and u.ThemeTag then
p.AddThemeObject(x,u.ThemeTag)
end
if u and u.FontFace then
p.AddFontObject(x)
end
return x
end

function p.Tween(r,u,v,...)
return f:Create(r,TweenInfo.new(u,...),v)
end

function p.ClampTransparency(r,u)
local v=tonumber(r)
if v==nil then
return u
end

return math.clamp(v,0,1)
end

function p.ToUDimRadius(r,u)
if typeof(r)=="UDim"then
return r
end
if type(r)=="number"then
return UDim.new(0,math.max(r,0))
end

if typeof(u)=="UDim"then
return u
end

return UDim.new(0,tonumber(r)or tonumber(u)or 0)
end

function p.ApplyCornerRadii(r,u,v)
if typeof(r)~="Instance"or not r:IsA"UICorner"then
return r
end

local x=p.ToUDimRadius(u,r.CornerRadius)
local z=v
or{
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}
local function ResolveCorner(A)
if A==false then
return UDim.new(0,0)
end
if typeof(A)=="UDim"then
return A
end
if type(A)=="number"then
return UDim.new(0,math.max(A,0))
end
return x
end

r.CornerRadius=x

pcall(function()
r.TopLeftRadius=ResolveCorner(z.TopLeft)
r.TopRightRadius=ResolveCorner(z.TopRight)
r.BottomRightRadius=ResolveCorner(z.BottomRight)
r.BottomLeftRadius=ResolveCorner(z.BottomLeft)
end)

return r
end

function p.CreateUIShadow(r,u)
local v
local x=pcall(function()
v=Instance.new"UIShadow"
for x,z in u or{}do
if x~="Parent"and x~="ThemeTag"then
v[x]=z
end
end
v.Parent=r or(u and u.Parent)
end)

if not x then
if v then
v:Destroy()
end
return nil
end

if u and u.ThemeTag then
p.AddThemeObject(v,u.ThemeTag)
end

return v
end

function p.ApplyLinkedCornerSurface(r,u,v,x)
if typeof(r)~="Instance"or not r:IsA"GuiObject"then
return nil
end

local z=i:GetWrapper(r)
if z and z.SetLinkedCorners then
z:SetLinkedCorners(x and v or nil,u)
return z
end

local A=r:FindFirstChild"WindUILinkedCorner"
local B=A or r:FindFirstChildWhichIsA"UICorner"
if not x then
if A then
A:Destroy()
elseif B then
p.ApplyCornerRadii(B,u,p.DefaultCornerMap())
end
return nil
end

A=B
if not A then
A=p.New("UICorner",{
Name="WindUILinkedCorner",
Parent=r,
})
end
p.ApplyCornerRadii(A,u,v)
return A
end

function p.DefaultCornerMap()
return{
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}
end

function p.GetLinkedCornerDirection(r,u,v)
if typeof(v)=="table"then
local x=tostring(v.Orientation or v.Direction or""):lower()
if x=="horizontal"or x=="row"or x=="x"then
return true
elseif x=="vertical"or x=="column"or x=="y"then
return false
end
end

local x=u or(r and r.__type)

if x=="Group"then
return true
end

if x=="HStack"then
if r and r.IsStacked==true then
return false
end

local z=r and r.ElementFrame
local A=z and z:FindFirstChildWhichIsA"UIListLayout"
if A then
return A.FillDirection==Enum.FillDirection.Horizontal
end

return true
end

return false
end

function p.GetLinkedCornerShape(r,u,v,x,z)
return p:GetElementPosition(
r,
u,
p.GetLinkedCornerDirection(v,x,z),
z
)
end








































































function p.NewRoundFrame(r,u,v,x,z,A)
return i:New(r,u,v,x,z,nil)
end

local r=p.New local u=
p.Tween

function p.SetDraggable(v)
p.CanDraggable=v
end

function p.Drag(v,x,z)
local A=m.GenerateGUID()

local B
local C=false
local F,G
local H

local J={
CanDraggable=true,
}

if not x or typeof(x)~="table"then
x={v}
end

local function update(L)
if not C or not J.CanDraggable then
return
end

local M=L.Position-F
p.Tween(v,0.02,{
Position=UDim2.new(
G.X.Scale,
G.X.Offset+M.X,
G.Y.Scale,
G.Y.Offset+M.Y
),
}):Play()
end

for L,M in pairs(x)do
M.InputBegan:Connect(function(N)
if not J.CanDraggable or C then
return
end

if
N.UserInputType==Enum.UserInputType.MouseButton1
or N.UserInputType==Enum.UserInputType.Touch
then
if m and m.CurrentInput and m.CurrentInput~=A then
return
end

m.CurrentInput=A

C=true
H=N
B=M
F=N.Position
G=v.Position

if z and typeof(z)=="function"then
z(true,B)
end
end
end)
end

e.InputChanged:Connect(function(L)
if not C then
return
end
if m.CurrentInput and m.CurrentInput~=A then
return
end

if H.UserInputType==Enum.UserInputType.MouseButton1 then
if L.UserInputType==Enum.UserInputType.MouseMovement then
update(L)
end
elseif H.UserInputType==Enum.UserInputType.Touch then
if L==H then
update(L)
end
end
end)

e.InputEnded:Connect(function(L)
if not C or m.CurrentInput~=A then
return
end

if
L==H
or(
H.UserInputType==Enum.UserInputType.MouseButton1
and L.UserInputType==Enum.UserInputType.MouseButton1
)
then
m.CurrentInput=nil
C=false
H=nil
B=nil

if z and typeof(z)=="function"then
z(false,nil)
end
end
end)

function J.Set(L,M)
J.CanDraggable=M
end

return J
end

j.Init(r,"Icon")

function p.SanitizeFilename(v)
local x=v:match"([^/]+)$"or v

x=x:gsub("%.[^%.]+$","")

x=x:gsub("[^%w%-_]","_")

if#x>50 then
x=x:sub(1,50)
end

return x
end

p.SupportsDirectImageLabel=true

function p.Image(v,x,z,A,B,C,F,G,H)
local J=if typeof(A)=="table"then A.Folder else A
J=tostring(J or"Temp")
x=p.SanitizeFilename(tostring(x or"Image"))
B=tostring(B or"Image")
H=H==true

if H and typeof(v)=="table"then
v=v.Image or v.Asset or v.AssetId or v.Id or v.Url or v.URL
end

local L=type(v)=="string"
and v:match"^https?://"~=nil
and v:find("roblox.com",1,true)==nil
local M=if H
or L
or typeof(v)=="Instance"
then nil
else p.Icon(v)
local N=(M or F)and C and(G or"Icon")or nil

local O=r("ImageLabel",{
Name="ImageLabel",
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ScaleType=Enum.ScaleType.Crop,
ThemeTag=N and{
ImageColor3=N,
}or nil,
},{
r("UICorner",{
CornerRadius=UDim.new(0,tonumber(z)or 0),
}),
})
local P=if H
then O
else r("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
O,
})

if typeof(v)=="Instance"then
if H then
local Q=if v:IsA"ImageLabel"or v:IsA"ImageButton"
then v
else v:FindFirstChildWhichIsA("ImageLabel",true)or v:FindFirstChildWhichIsA(
"ImageButton",
true
)
if Q then
O.Image=Q.Image
O.ImageRectOffset=Q.ImageRectOffset
O.ImageRectSize=Q.ImageRectSize
O.ImageColor3=Q.ImageColor3
O.ImageTransparency=Q.ImageTransparency
else
P.Visible=false
end
else
O:Destroy()
local Q=v:Clone()
Q.Name="ImageLabel"
if Q:IsA"GuiObject"then
Q.Size=UDim2.fromScale(1,1)
Q.Position=UDim2.fromScale(0.5,0.5)
Q.AnchorPoint=Vector2.new(0.5,0.5)
end
Q.Parent=P
end
elseif M then
O:Destroy()
local Q=j.Image{
Icon=v,
Size=UDim2.fromScale(1,1),
Colors={
N or false,
"Button",
},
}.IconFrame
Q.Name="ImageLabel"
Q.Parent=P
elseif L then
local Q="WindUI/"..J.."/assets/."..B.."-"..x..".png"
local R,S=pcall(function()
task.spawn(function()
local R=p.Request and p.Request{
Url=v,
Method="GET",
}or nil
local S=typeof(R)=="table"and R.Body or R

if S and writefile then
writefile(Q,S)
end

local T,U=pcall(getcustomasset,Q)
if T then
O.Image=U
elseif not T then
warn(string.format("[ WindUI.Creator ] Failed to load '%s': %s",Q,tostring(U)))
end
end)
end)

if not R then
warn(string.format("[ WindUI.Creator ] URL image is unavailable: %s",tostring(S)))
P.Visible=false
end
elseif v==nil or v==""then
P.Visible=false
elseif type(v)=="number"then
O.Image="rbxassetid://"..tostring(v)
elseif type(v)=="string"then
O.Image=v
else
warn(string.format("[ WindUI.Creator ] Unsupported image value: %s",typeof(v)))
P.Visible=false
end

return P
end

function p.Color3ToHSB(v)
local x,z,A=v.R,v.G,v.B
local B=math.max(x,z,A)
local C=math.min(x,z,A)
local F=B-C

local G=0
if F~=0 then
if B==x then
G=(z-A)/F%6
elseif B==z then
G=(A-x)/F+2
else
G=(x-z)/F+4
end
G=G*60
else
G=0
end

local H=(B==0)and 0 or(F/B)
local J=B

return{
h=math.floor(G+0.5),
s=H,
b=J,
}
end

function p.GetPerceivedBrightness(v)
local x=v.R
local z=v.G
local A=v.B
return 0.299*x+0.587*z+0.114*A
end

function p.GetTextColorForHSB(v,x)
local z=p.Color3ToHSB(v)local
A, B, C=z.h, z.s, z.b
if p.GetPerceivedBrightness(v)>(x or 0.5)then
return Color3.fromHSV(A/360,0,0.05)
else
return Color3.fromHSV(A/360,0,0.98)
end
end

function p.GetAverageColor(v)
local x,z,A=0,0,0
local B=v.Color.Keypoints
for C,F in ipairs(B)do

x=x+F.Value.R
z=z+F.Value.G
A=A+F.Value.B
end
local C=#B
return Color3.new(x/C,z/C,A/C)
end

function p.GenerateUniqueID(v)
return h:GenerateGUID(false)
end

function p.OnThemeChange(v,x)
if typeof(x)~="function"then
return
end

local z=h:GenerateGUID(false)
p.ThemeChangeCallbacks[z]=x

return{
Disconnect=function()
p.ThemeChangeCallbacks[z]=nil
end,
}
end

function p.AddColor(v,x,z,A)
A=math.clamp(A or 1,0,1)
if typeof(z)=="string"then
z=Color3.fromHex(z)
end

return function(B)
local C
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
C=p.GetThemeProperty(x,B)
elseif typeof(x)=="string"then
C=Color3.fromHex(x)
else
C=x
end

if not C or typeof(C)~="Color3"then
return nil
end

return Color3.new(
math.clamp(C.R+z.R*A,0,1),
math.clamp(C.G+z.G*A,0,1),
math.clamp(C.B+z.B*A,0,1)
)
end
end

function p.GetElementPosition(v,x,z,A,B)
B=if typeof(B)=="table"then B else{}
if type(z)~="number"or z~=math.floor(z)then
return"Squircle",p.DefaultCornerMap(),{Position="Single",Count=1}
end

local C=x and x[z]
if C==nil then
return"Squircle",p.DefaultCornerMap(),{Position="Single",Count=1}
end

local F=if B.IncludeDefaultBreaks==false
then{}
else{
Divider=true,
Space=true,
Section=true,
}
if typeof(B.BreakTypes)=="table"then
for G,H in B.BreakTypes do
if type(G)=="number"then
F[tostring(H)]=true
else
F[tostring(G)]=H==true
end
end
end

local function GetFrame(G)
return G and(G.ElementFrame or(G.UIElements and G.UIElements.Main))
end

local function IsHidden(G)
if B.IgnoreHidden==false then
return false
end
local H=GetFrame(G)
return typeof(H)=="Instance"and H:IsA"GuiObject"and H.Visible==false
end

local function IsDelimiter(G)
return G==nil
or G.CornerBreak==true
or G.LinkCornerBreak==true
or F[tostring(G.__type)]==true
end

local function GetGroup(G)
if typeof(B.GroupBy)=="function"then
local H,J=pcall(B.GroupBy,G)
if H then
return J
end
elseif type(B.GroupBy)=="string"then
return G[B.GroupBy]
end

return G.CornerGroup or G.LinkCornerGroup or G.LinkedCornerGroup
end

if IsDelimiter(C)or IsHidden(C)then
return"Squircle",p.DefaultCornerMap(),{Position="Single",Count=1}
end

local G={}
for H,J in x or{}do
if type(H)=="number"and J~=nil then
table.insert(G,H)
end
end
table.sort(G)

local H={}
local J={}
local L
local M

local function Flush()
if#J>0 then
table.insert(H,J)
J={}
end
L=nil
M=nil
end

for N,O in G do
local P=x[O]
if IsHidden(P)then
if B.BridgeHidden~=true then
Flush()
else
M=O
end
elseif IsDelimiter(P)then
Flush()
else
local Q=P.LinkCorners==false or P.LinkCorner==false
local R=P.CornerBreakBefore==true or P.LinkCornerBreakBefore==true
local S=M~=nil and O-M>1 and B.BridgeSparse~=true
local T=L~=nil and GetGroup(L)~=GetGroup(P)
local U=L
and(L.CornerBreakAfter==true or L.LinkCornerBreakAfter==true)

if#J>0 and(Q or R or S or T or U)then
Flush()
end

table.insert(J,O)
L=P
M=O

if Q then
Flush()
end
end
end
Flush()

local N
local O
for P,Q in H do
for R,S in Q do
if S==z then
N=Q
O=R
break
end
end
if N then
break
end
end

if not N or not O then
return"Squircle",p.DefaultCornerMap(),{Position="Single",Count=1}
end

local P=#N
local Q=if B.Reverse==true then P-O+1 else O
local R=if B.InnerRadius~=nil
then p.ToUDimRadius(B.InnerRadius,UDim.new(0,0))
else false
local S="Squircle"
local T=p.DefaultCornerMap()
local U="Single"

if P>1 and Q==1 then
U="First"
if A then
S="Squircle-TL-BL"
T.TopRight=R
T.BottomRight=R
else
S="Squircle-TL-TR"
T.BottomLeft=R
T.BottomRight=R
end
elseif P>1 and Q==P then
U="Last"
if A then
S="Squircle-TR-BR"
T.TopLeft=R
T.BottomLeft=R
else
S="Squircle-BL-BR"
T.TopLeft=R
T.TopRight=R
end
elseif P>1 then
U="Middle"
S="Square"
if A then
T.TopLeft=R
T.TopRight=R
T.BottomLeft=R
T.BottomRight=R
else
T.TopLeft=R
T.TopRight=R
T.BottomLeft=R
T.BottomRight=R
end
end

local V={
Position=U,
Index=Q,
Count=P,
Horizontal=A==true,
SourceIndex=z,
Group=GetGroup(C),
}

if typeof(B.Resolver)=="function"then
local W,X,Y=pcall(B.Resolver,V,S,T,C)
if W then
S=X or S
T=Y or T
end
end

return S,T,V
end

return p end function a.e()

local b=game:GetService"TweenService"

local d={
Preset="Subtle",
Enabled=true,
Reduced=false,
}

d.Durations={
Fast=0.08,
Hover=0.1,
Press=0.12,
Select=0.14,
Focus=0.14,
DropdownOpen=0.16,
DropdownClose=0.14,
Notification=0.24,
NotificationClose=0.2,
WindowOpen=0.26,
WindowClose=0.2,
WindowMorph=0.42,
Resize=0.22,
Highlight=0.28,
Background=0.22,
Expand=0.2,
Switch=0.16,
Reveal=0.18,
}

d.PresetDurations={
Liquid={
Fast=0.1,
Hover=0.14,
Press=0.1,
Select=0.2,
Focus=0.18,
DropdownOpen=0.2,
DropdownClose=0.16,
WindowOpen=0.32,
WindowClose=0.22,
WindowMorph=0.46,
Resize=0.28,
Highlight=0.34,
Background=0.28,
Expand=0.24,
Switch=0.22,
Reveal=0.22,
},
Snappy={
Fast=0.06,
Hover=0.08,
Press=0.08,
Select=0.11,
Focus=0.1,
DropdownOpen=0.12,
DropdownClose=0.1,
WindowOpen=0.2,
WindowClose=0.16,
WindowMorph=0.3,
Resize=0.16,
Highlight=0.22,
Background=0.16,
Expand=0.16,
Switch=0.12,
Reveal=0.14,
},
}

d.PresetEasing={
Liquid={
Style=Enum.EasingStyle.Quint,
Direction=Enum.EasingDirection.Out,
},
Snappy={
Style=Enum.EasingStyle.Quart,
Direction=Enum.EasingDirection.Out,
},
}

d.PresetPressAmount={
Liquid=0.965,
Snappy=0.975,
}

local e=setmetatable({},{__mode="k"})

local f={}
function f.Play(g)end
function f.Cancel(g)end

local g={
Position=true,
Size=true,
CanvasPosition=true,
Rotation=true,
Scale=true,
}

local function IsPointerInput(h)
return h.UserInputType==Enum.UserInputType.MouseButton1 or h.UserInputType==Enum.UserInputType.Touch
end

local function ApplyProperties(h,i)
for j,m in next,i or{}do
h[j]=m
end
end

local function SplitReducedProperties(h)
local i={}
local j={}
local m=false
local p=false

for r,u in next,h or{}do
if g[r]then
i[r]=u
m=true
else
j[r]=u
p=true
end
end

return m and i or nil,p and j or nil
end

function d.GetDuration(h)
if typeof(h)=="string"then
local i=d.PresetDurations[d.Preset]
return(i and i[h])or d.Durations[h]or d.Durations.Fast
end

return math.max(tonumber(h)or d.Durations.Fast,0)
end

function d.IsEnabled(h)
return d.Enabled and d.Preset~="None"
end

function d.Configure(h,i)
if i==false then
d.Enabled=false
d.Preset="None"
return d:GetConfig()
end

if typeof(i)=="string"then
return d:SetPreset(i)
end

if typeof(i)=="table"then
if i.Preset~=nil then
d:SetPreset(i.Preset)
elseif i.Enabled~=false and d.Preset=="None"then
d:SetPreset"Subtle"
end
d.Enabled=i.Enabled~=false and d.Preset~="None"
d.Reduced=i.Reduced==true
else
d.Enabled=true
if d.Preset=="None"then
d.Preset="Subtle"
end
d.Reduced=false
end

return d:GetConfig()
end

function d.SetPreset(h,i)
i=tostring(i or"Subtle")

if i~="Subtle"and i~="Liquid"and i~="Snappy"and i~="None"then
i="Subtle"
end

d.Preset=i
d.Enabled=i~="None"

return d:GetConfig()
end

function d.SetReducedMotion(h,i)
d.Reduced=i==true
return d:GetConfig()
end

function d.GetConfig(h)
return{
Preset=d.Preset,
Enabled=d.Enabled,
Reduced=d.Reduced,
}
end

function d.ShouldAnimate(h)
if h and(h.Animation==false or h.Motion==false)then
return false
end

return d:IsEnabled()
end

function d.Cancel(h,i)
if not h then
return
end

local j=e[h]
if not j then
return
end

i=i or"Default"
local m=j[i]
if m then
m:Cancel()
j[i]=nil
end
end

function d.Tween(h,i,j,m,p,r)
if not h or typeof(h)~="Instance"then
return f
end

local u=d.GetDuration(i)
r=r or"Default"

local v
local x=j
if d.Reduced then
v,x=SplitReducedProperties(j)
u=math.min(u,d.Durations.Focus)
end

local z={}
local A

function z.Play(B)
d.Cancel(h,r)

if v then
ApplyProperties(h,v)
end

if not d:IsEnabled()or u<=0 or not x then
ApplyProperties(h,x or j)
return
end

local C=d.PresetEasing[d.Preset]
A=b:Create(
h,
TweenInfo.new(
u,
m or(C and C.Style)or Enum.EasingStyle.Quint,
p or(C and C.Direction)or Enum.EasingDirection.Out
),
x
)

e[h]=e[h]or{}
e[h][r]=A

A.Completed:Connect(function()
local F=e[h]
if F and F[r]==A then
F[r]=nil
end
end)

A:Play()
end

function z.Cancel(B)
if A then
A:Cancel()
end
d.Cancel(h,r)
end

return z
end

function d.Play(h,i,j,m,p,r)
local u=d.Tween(h,i,j,m,p,r)
u:Play()
return u
end

function d.GetScale(h)
if not h then
return nil
end

if h:IsA"UIScale"then
return h
end

local i=h:FindFirstChildOfClass"UIScale"
if not i then
i=Instance.new"UIScale"
i.Scale=1
i.Parent=h
end

return i
end

function d.Press(h,i,j)
local m=d.GetScale(h)
if not m then
return
end

if not d:IsEnabled()or d.Reduced then
if not i then
m.Scale=1
end
return
end

d.Play(
m,
"Press",
{Scale=i and(j or d.PresetPressAmount[d.Preset]or 0.97)or 1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
end

function d.AttachPress(h,i,j)
if not h or not i then
return nil
end

j=j or{}
local m=j.Amount or 0.97
local p=j.Enabled

local r=d.GetScale(h)

local function CanPress()
if typeof(p)=="function"then
return p()
end
return p~=false
end

i.AddSignal(h.InputBegan,function(u)
if CanPress()and IsPointerInput(u)then
d.Press(r,true,m)
end
end)

i.AddSignal(h.InputEnded,function(u)
if IsPointerInput(u)then
d.Press(r,false,m)
end
end)

if h.MouseLeave then
i.AddSignal(h.MouseLeave,function()
d.Press(r,false,m)
end)
end

return r
end

return d end function a.f()

local b={}







function b.New(d,e,f)
local g={
Enabled=e.Enabled or false,
Translations=e.Translations or{},
Prefix=e.Prefix or"loc:",
DefaultLanguage=e.DefaultLanguage or"en"
}

f.Localization=g

return g
end



return b end function a.g()
local b=a.load'd'
local d=a.load'e'

local e=b.New
local f=b.Tween

local g=14
local h=58
local i=72
local j=420
local m=240
local p=18
local r=10
local u=8
local v=30
local x=40
local z=44
local A=24
local B=30
local C=36
local F=2
local G=38
local H=48
local J=2
local L=4
local M=18
local N=14
local O=4
local P=356
local Q=300
local R=404

local S={
Info={
Icon="info",
Color=Color3.fromHex"#60A5FA",
},
Notice={
Icon="bell",
Color=Color3.fromHex"#38BDF8",
},
Success={
Icon="circle-check",
Color=Color3.fromHex"#34D399",
},
Warning={
Icon="triangle-alert",
Color=Color3.fromHex"#FBBF24",
},
Error={
Icon="circle-x",
Color=Color3.fromHex"#FB7185",
},
Neutral={
Icon="message-circle",
Color=Color3.fromHex"#A1A1AA",
},
}

local T={
default="Info",
info="Info",
notice="Notice",
message="Notice",
success="Success",
successful="Success",
ok="Success",
green="Success",
warn="Warning",
warning="Warning",
caution="Warning",
error="Error",
fail="Error",
failed="Error",
danger="Error",
neutral="Neutral",
}

local U={
default="Compact",
compact="Compact",
minimal="Compact",
pill="Compact",
capsule="Compact",
card="Card",
avatar="Card",
glass="Glass",
liquid="Glass",
liquidglass="Glass",
frosted="Glass",
legacy="Glass",
}

local V={
default="Normal",
normal="Normal",
modern="Normal",
toast="Normal",
window="Window",
windows="Window",
desktop="Window",
windownotification="Window",
windownotify="Window",
original="Originally",
originally="Originally",
legacy="Originally",
classic="Originally",
}

local W={
Holder=nil,
NotificationIndex=0,
Notifications={},
}

local function ResolveColor(X,Y)
if typeof(X)=="Color3"then
return X
end

if typeof(X)=="string"and string.sub(X,1,1)=="#"then
local _,aa=pcall(Color3.fromHex,X)
if _ then
return aa
end
end

return Y
end

local function NormalizeStyleName(aa)
local X=tostring(aa or"Info"):lower():gsub("%s+","")
return T[X]or"Info"
end

local function NormalizeNotificationType(aa)
if aa==nil then
return nil
end

local X=tostring(aa):lower():gsub("%s+","")
return V[X]
end

local function NormalizeAppearance(aa,X)
if aa==nil and(X.Avatar~=nil or X.Timestamp~=nil or X.Time~=nil)then
return"Card"
end
local Y=tostring(aa or"Compact"):lower():gsub("%s+","")
return U[Y]or"Compact"
end

local function ResolveDuration(aa)
if aa==false then
return false
end

local X=tonumber(aa)
if X==nil then
return 5
end

return math.max(X,0)
end

local function NormalizeIcon(aa)
if typeof(aa)=="number"then
return"rbxassetid://"..tostring(aa)
end
if typeof(aa)=="string"then
return aa
end
if typeof(aa)=="table"or typeof(aa)=="Instance"then
return aa
end
return nil
end

local function PaintIcon(aa,X,Y)
if typeof(aa)~="Instance"then
return
end

local _={}
if aa:IsA"ImageLabel"or aa:IsA"ImageButton"then
table.insert(_,aa)
end

for ab,ac in aa:GetDescendants()do
if ac:IsA"ImageLabel"or ac:IsA"ImageButton"then
table.insert(_,ac)
end
end

for ab,ac in _ do
ac.ImageColor3=X
if Y~=nil then
ac.ImageTransparency=Y
end
end
end

local function CreateCorner(aa,ab)
local ac=e("UICorner",{
CornerRadius=UDim.new(0,aa),
})
return b.ApplyCornerRadii(ac,aa,ab)
end

local function ResolveCornerValue(aa,ab,ac)
local X=aa[ab]
if X==nil then
X=aa[ab.."Radius"]
end
if X==nil then
return ac
end
return X
end

local function GetActions(aa)
local ab={}
if typeof(aa)~="table"then
return ab
end

for ac=1,math.min(#aa,F)do
local X=aa[ac]
if typeof(X)=="table"then
table.insert(ab,X)
end
end

return ab
end

local function TrimNotifications(aa,ab)
local ac={}
for X,Y in W.Notifications do
if not Y.Closed then
table.insert(ac,Y)
end
end

table.sort(ac,function(X,Y)
return X.Index<Y.Index
end)

local X=math.max(#ac-1,0)*u
for Y,_ in ac do
X=X+(_.LayoutHeight or 64)
end

while#ac>1 and(#ac>aa or X>ab)do
local Y=table.remove(ac,1)
X=X-(Y.LayoutHeight or 64)-u
Y:Close"Overflow"
end
end

function W.Init(aa)
local ab={
Lower=false,
}

ab.Frame=e("Frame",{
Name="NotificationHolder",
Position=UDim2.new(1,-g,0,h),
AnchorPoint=Vector2.new(1,0),
Size=UDim2.new(1,-(g*2),1,-(h+i)),
Parent=aa,
BackgroundTransparency=1,
ClipsDescendants=false,
ZIndex=100,
},{
e("UISizeConstraint",{
MinSize=Vector2.new(m,0),
MaxSize=Vector2.new(j,10000),
}),
e("UIListLayout",{
HorizontalAlignment=Enum.HorizontalAlignment.Right,
SortOrder=Enum.SortOrder.LayoutOrder,
VerticalAlignment=Enum.VerticalAlignment.Top,
Padding=UDim.new(0,u),
}),
})

function ab.SetLower(ac)
ab.Lower=ac==true
local X=if ab.Lower then 12 else i
ab.Frame.Size=UDim2.new(1,-(g*2),1,-(h+X))
end

W.Holder=ab.Frame
return ab
end

function W.New(aa)
aa=if typeof(aa)=="table"then aa else{}

local ab=NormalizeNotificationType(aa.Type)
local ac=NormalizeNotificationType(aa.NotificationType)or ab
local X=ac or"Normal"
local Y=if ab==nil then aa.Type else nil
local _=NormalizeStyleName(aa.Style or aa.Variant or Y)
local ad=if X=="Window"
then"Window"
elseif X=="Originally"then"Originally"
else NormalizeAppearance(aa.Appearance or aa.Layout,aa)
local ae=S[_]or S.Info
local af=ResolveColor(aa.AccentColor or aa.Color,ae.Color)
local ag
local ah=if X=="Window"
then(if aa.Avatar~=nil then aa.Avatar else aa.BodyIcon)
else(if aa.Avatar~=nil then aa.Avatar else aa.Icon)
if ah==false or ah==""then
ag=nil
elseif ah~=nil then
ag=NormalizeIcon(ah)
elseif X~="Window"then
ag=ae.Icon
end
local ai=aa.LiquidGlass==true
or aa.Glass==true
or ad=="Glass"
or(X=="Window"and aa.LiquidGlass~=false and aa.Glass~=false)
local aj=aa.Decorated==true or aa.Accented==true or ad=="Glass"

local ak={
Type=X,
Title=tostring(aa.Title or"Notification"),
Content=aa.Content~=nil and tostring(aa.Content)or nil,
Icon=ag,
IsAvatar=aa.Avatar~=nil,
IconThemed=aa.IconThemed,
IconColor=ResolveColor(
aa.IconColor,
if aj
or aa.AccentColor~=nil
or aa.Color~=nil
then af
else Color3.fromHex"#A1A1AA"
),
Style=_,
Appearance=ad,
LiquidGlass=ai,
Decorated=aj,
DarkOverlay=aa.DarkOverlay==true or aa.Overlay==true or X=="Originally",
Timestamp=aa.Timestamp~=nil and tostring(aa.Timestamp)
or(aa.Time~=nil and tostring(aa.Time)or nil),
AppName=tostring(aa.AppName or aa.Application or aa.App or"WindUI"),
AppIcon=NormalizeIcon(
aa.AppIcon or aa.ApplicationIcon or(X=="Window"and aa.Icon)or"bell"
),
Selection=aa.Selection or aa.Dropdown or aa.Select,
AccentColor=af,
ProgressColor=ResolveColor(aa.ProgressColor,af),
Background=aa.Background,
BackgroundImageTransparency=b.ClampTransparency(aa.BackgroundImageTransparency,0.35),
Duration=ResolveDuration(aa.Duration),
Buttons=GetActions(aa.Buttons),
CanClose=aa.CanClose~=false,
PauseOnHover=aa.PauseOnHover~=false,
OnOpen=aa.OnOpen,
OnClose=aa.OnClose,
UIElements={},
Closed=false,
Paused=false,
}

W.NotificationIndex=W.NotificationIndex+1
ak.Index=W.NotificationIndex
W.Notifications[ak.Index]=ak

local al=aa.Holder or W.Holder
assert(al,"Notification holder is not initialized")

local am=ak.Type=="Window"
local an=ak.Type=="Originally"
local ao=ak.Appearance=="Card"or am
local ap=math.max(
tonumber(aa.Width)or(am and R or(an and Q or P)),
m
)
local aq=if am or an then 14 elseif ao then 12 else r
local ar=math.max(
tonumber(aa.Radius)or(am and 20 or(an and 18 or(ao and 20 or p))),
8
)
local as=if typeof(aa.Corners or aa.CornerRadii)=="table"
then aa.Corners or aa.CornerRadii
else aa
local at={
TopLeft=ResolveCornerValue(as,"TopLeft",ar),
TopRight=ResolveCornerValue(as,"TopRight",ar),
BottomRight=ResolveCornerValue(as,"BottomRight",ar),
BottomLeft=ResolveCornerValue(as,"BottomLeft",ar),
}
local au=if ao then x elseif an then 38 else v
local av=if ak.Timestamp and not am then 72 else 0
local aw=typeof(ak.Duration)=="number"and ak.Duration>0
local ax=ak.Icon and(au+9)or 0
local ay=(ak.CanClose and not am and B or 0)+av
local az=aa.Shadow~=false
local aA=aa.FallbackShadow==true
local aB=ak.DarkOverlay
local aC={
BackgroundColor3=if aB
then(if ak.LiquidGlass then"NotificationGlass"else"Notification")
else"NotificationGlassSurface",
}
if aa.Transparency==nil and aB then
aC.BackgroundTransparency=if ak.LiquidGlass
then"NotificationGlassTransparency"
else"NotificationTransparency"
end
local aD
local aE=0
local aF=if aw then ak.Duration else 0
local aG
local aH=false
local aI=false
local aJ=64
local aK={}

local function Connect(aL,aM)
local aN=aL:Connect(aM)
table.insert(aK,aN)
return aN
end

local function AttachPress(aL,aM)
Connect(aL.InputBegan,function(aN)
if
aN.UserInputType==Enum.UserInputType.MouseButton1
or aN.UserInputType==Enum.UserInputType.Touch
then
d.Press(aL,true,aM)
end
end)
Connect(aL.InputEnded,function(aN)
if
aN.UserInputType==Enum.UserInputType.MouseButton1
or aN.UserInputType==Enum.UserInputType.Touch
then
d.Press(aL,false,aM)
end
end)
Connect(aL.MouseLeave,function()
d.Press(aL,false,aM)
end)
end

local function AttachHover(aL,aM,aN,aO)
Connect(aL.MouseEnter,function()
d.Play(
aM,
"Hover",
{BackgroundTransparency=aN},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end)
Connect(aL.MouseLeave,function()
d.Play(
aM,
"Hover",
{BackgroundTransparency=aO},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end)
end

local function DisconnectSignals()
for aL,aM in aK do
aM:Disconnect()
end
table.clear(aK)
end

local aL=e("Frame",{
Name="NotificationContainer",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
ClipsDescendants=false,
LayoutOrder=-ak.Index,
ZIndex=100,
Parent=al,
},{
e("UISizeConstraint",{
MinSize=Vector2.new(math.min(ap,m),0),
MaxSize=Vector2.new(ap,10000),
}),
})

local aM=e("UIScale",{
Name="TransitionScale",
Scale=0.965,
})

local aN=e("CanvasGroup",{
Name="NotificationTransition",
Active=true,
BackgroundTransparency=1,
GroupTransparency=1,
BorderSizePixel=0,
Size=UDim2.new(1,0,0,aJ),
Position=UDim2.new(0,M,0,0),
ClipsDescendants=false,
ZIndex=101,
Parent=aL,
},{
aM,
})

local aO=e("Frame",{
Name="Shadow",
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.78,
BorderSizePixel=0,
Size=UDim2.new(1,-4,1,-4),
Position=UDim2.new(0,2,0,O),
Visible=az,
ZIndex=101,
Parent=aN,
},{
CreateCorner(ar,at),
})

local aP=e("UIStroke",{
Color=Color3.new(1,1,1),
Transparency=0.76,
Thickness=1,
ThemeTag={
Color="NotificationBorder",
Transparency="NotificationBorderTransparency",
},
})

local aQ=e("Frame",{
Name="Notification",
BackgroundColor3=if aB then Color3.fromRGB(24,25,29)else Color3.new(1,1,1),
BackgroundTransparency=b.ClampTransparency(
aa.Transparency,
if aB
then(if ak.LiquidGlass then 0.28 else 0.08)
else(if ak.LiquidGlass then 0.64 else 0.72)
),
BorderSizePixel=0,
Size=UDim2.fromScale(1,1),
ClipsDescendants=true,
ZIndex=102,
ThemeTag=aC,
Parent=aN,
},{
CreateCorner(ar,at),
aP,
})
aQ:SetAttribute("Appearance",ak.Appearance)
aQ:SetAttribute("Type",ak.Type)
aQ:SetAttribute("LiquidGlass",ak.LiquidGlass)
aQ:SetAttribute("DarkOverlay",aB)
aQ:SetAttribute("LayoutVersion",4)

local aR
if az then
aR=b.CreateUIShadow(aQ,{
Name="NativeShadow",
BlurRadius=b.ToUDimRadius(aa.ShadowBlur,UDim.new(0,16)),
Color=ResolveColor(aa.ShadowColor,Color3.new(0,0,0)),
Offset=if typeof(aa.ShadowOffset)=="UDim2"then aa.ShadowOffset else UDim2.fromOffset(0,5),
Spread=if typeof(aa.ShadowSpread)=="UDim2"then aa.ShadowSpread else UDim2.fromOffset(2,2),
Transparency=b.ClampTransparency(aa.ShadowTransparency,0.68),
ZIndex=0,
})
end
aO.Visible=az and aR==nil and aA

local aS=e("Frame",{
Name="CapsuleSurface",
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
BackgroundTransparency=if aB
then(if ak.LiquidGlass then 0.91 else 0.985)
else(if ak.LiquidGlass then 0.94 else 1),
Size=UDim2.fromScale(1,1),
ZIndex=103,
ThemeTag={
BackgroundColor3=if ak.LiquidGlass then"NotificationGlassSurface"else"Notification2",
BackgroundTransparency=if aB
then(if ak.LiquidGlass
then"NotificationGlassSurfaceTransparency"
else"Notification2Transparency")
else nil,
},
Parent=aQ,
},{
CreateCorner(ar,at),
})

local aT=b.NewRoundFrame(ar,"SquircleGlass",{
Name="LiquidGlass",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=b.ClampTransparency(aa.GlassTransparency,0.78),
Size=UDim2.fromScale(1,1),
Visible=ak.LiquidGlass,
ZIndex=104,
ThemeTag=if aa.GlassTransparency==nil
then{
ImageColor3="NotificationGlassHighlight",
ImageTransparency="NotificationGlassTextureTransparency",
}
else{
ImageColor3="NotificationGlassHighlight",
},
Parent=aQ,
})

if typeof(ak.Background)=="string"and ak.Background~=""then
e("ImageLabel",{
Name="Background",
Image=ak.Background,
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ScaleType=Enum.ScaleType.Crop,
ImageTransparency=ak.BackgroundImageTransparency,
ZIndex=104,
Parent=aQ,
},{
CreateCorner(ar,at),
})
end

local aU=e("Frame",{
Name="ToneWash",
BackgroundColor3=ak.AccentColor,
BackgroundTransparency=0.94,
BorderSizePixel=0,
Size=UDim2.fromScale(1,1),
Visible=ak.Decorated,
ZIndex=105,
Parent=aQ,
},{
CreateCorner(ar,at),
e("UIGradient",{
Rotation=18,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.42),
NumberSequenceKeypoint.new(0.38,0.86),
NumberSequenceKeypoint.new(1,1),
},
}),
})

local aV=e("Frame",{
Name="AccentLine",
BackgroundColor3=ak.AccentColor,
BackgroundTransparency=0.08,
BorderSizePixel=0,
Size=UDim2.new(0,3,0.48,0),
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
Visible=ak.Decorated,
ZIndex=106,
Parent=aQ,
},{
CreateCorner(3,{
TopLeft=at.TopLeft,
TopRight=3,
BottomRight=3,
BottomLeft=at.BottomLeft,
}),
e("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.32,0.08),
NumberSequenceKeypoint.new(0.68,0.08),
NumberSequenceKeypoint.new(1,1),
},
}),
})

local aW=e("Frame",{
Name="TopHighlight",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.94,
BorderSizePixel=0,
Size=UDim2.new(0.72,0,0,1),
Position=UDim2.new(0.14,0,0,0),
ZIndex=106,
Parent=aQ,
},{
e("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.5,0.15),
NumberSequenceKeypoint.new(1,1),
},
}),
})

local aX=e("Frame",{
Name="Body",
BackgroundTransparency=1,
Size=UDim2.new(1,-(aq*2),0,0),
Position=UDim2.fromOffset(aq,aq),
ZIndex=107,
Parent=aQ,
})

local aY=e("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,if am then 10 elseif an then 5 else 8),
Parent=aX,
})

local aZ
local a_
local a0
local a1
if am then
aZ=e("Frame",{
Name="AppHeader",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,28),
LayoutOrder=0,
ZIndex=108,
Parent=aX,
})

if ak.AppIcon then
a_=b.Image(
ak.AppIcon,
ak.AppName..":AppIcon",
4,
aa.Window and aa.Window.Folder,
"NotificationApp",
true,
aa.AppIconThemed,
"NotificationTitle"
)
a_.Name="AppIcon"
a_.Size=UDim2.fromOffset(22,22)
a_.Position=UDim2.new(0,0,0.5,0)
a_.AnchorPoint=Vector2.new(0,0.5)
a_.ZIndex=109
a_.Parent=aZ
end

local a2=if a_ then 30 else 0
a0=e("TextLabel",{
Name="AppName",
Text=ak.AppName,
TextSize=13,
FontFace=Font.new(b.Font),
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
BackgroundTransparency=1,
Size=UDim2.new(1,-(a2+92),1,0),
Position=UDim2.fromOffset(a2,0),
ZIndex=109,
ThemeTag={
TextColor3="NotificationTitle",
},
Parent=aZ,
})

a1=e("TextLabel",{
Name="AppTimestamp",
Text=ak.Timestamp or os.date"%H:%M",
TextSize=11,
FontFace=Font.new(b.Font),
TextXAlignment=Enum.TextXAlignment.Right,
BackgroundTransparency=1,
Size=UDim2.fromOffset(48,28),
Position=UDim2.new(1,-(ak.CanClose and 46 or 0),0,0),
AnchorPoint=Vector2.new(1,0),
TextTransparency=0.3,
ZIndex=109,
ThemeTag={
TextColor3="NotificationContent",
},
Parent=aZ,
})
end

local a2=e("Frame",{
Name="Header",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,math.max(ak.Icon and au or 0,20)),
LayoutOrder=1,
ZIndex=107,
Parent=aX,
})

local a3
if ak.Timestamp and not am then
a3=e("TextLabel",{
Name="Timestamp",
Text=ak.Timestamp,
TextSize=11,
FontFace=Font.new(b.Font),
TextXAlignment=Enum.TextXAlignment.Right,
TextYAlignment=Enum.TextYAlignment.Top,
TextTruncate=Enum.TextTruncate.AtEnd,
BackgroundTransparency=1,
Size=UDim2.fromOffset(av,18),
Position=UDim2.new(1,-(ak.CanClose and B or 0),0,1),
AnchorPoint=Vector2.new(1,0),
TextTransparency=0.22,
ZIndex=109,
ThemeTag={
TextColor3="NotificationContent",
},
Parent=aZ or a2,
})
end

local a4=e("Frame",{
Name="TextContainer",
BackgroundTransparency=1,
Size=UDim2.new(1,-(ax+ay),0,0),
Position=UDim2.fromOffset(ax,0),
ZIndex=108,
Parent=a2,
})

local a5=e("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,2),
Parent=a4,
})

local a6=e("TextLabel",{
Name="Title",
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Text=ak.Title,
TextWrapped=ao or an or aa.Wrap==true,
TextTruncate=Enum.TextTruncate.AtEnd,
RichText=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
TextSize=if am then 19 elseif an then 18 elseif ao then 15 else 14,
LineHeight=1,
FontFace=Font.new(b.Font),
LayoutOrder=1,
ZIndex=108,
ThemeTag={
TextColor3="NotificationTitle",
TextTransparency="NotificationTitleTransparency",
},
Parent=a4,
},{
e("UISizeConstraint",{
MinSize=Vector2.new(0,18),
MaxSize=Vector2.new(10000,G),
}),
})

local a7=e("TextLabel",{
Name="Content",
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Text=ak.Content or"",
TextWrapped=ao or an or aa.Wrap==true,
TextTruncate=Enum.TextTruncate.AtEnd,
RichText=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
TextSize=if am then 14 elseif an then 15 else 12,
LineHeight=1.05,
FontFace=Font.new(b.Font),
LayoutOrder=2,
Visible=ak.Content~=nil,
ZIndex=108,
ThemeTag={
TextColor3="NotificationContent",
TextTransparency="NotificationContentTransparency",
},
Parent=a4,
},{
e("UISizeConstraint",{
MinSize=Vector2.new(0,16),
MaxSize=Vector2.new(10000,H),
}),
})

local a8
local a9
if ak.Icon then
local ba=not ak.IsAvatar
and(
type(ak.Icon)~="string"
or(ak.Icon:match"^rbxassetid://"==nil and ak.Icon:match"^https?://"==nil)
)
a9=b.Image(
ak.Icon,
ak.Title..":"..tostring(ak.Icon),
ak.IsAvatar and au/2 or 0,
aa.Window and aa.Window.Folder,
"Notification",
true,
ak.IconThemed,
nil,
ak.IsAvatar
)
a9.Name=if ak.IsAvatar then"Avatar"else"Icon"
a9.Size=if ak.IsAvatar
then UDim2.fromScale(1,1)
else UDim2.fromOffset(if ao then 22 else 18,if ao then 22 else 18)
a9.Position=UDim2.fromScale(0.5,0.5)
a9.AnchorPoint=Vector2.new(0.5,0.5)
a9.ZIndex=110
if ba and b.Icon(ak.Icon)and ak.IconThemed~=true then
PaintIcon(a9,ak.IconColor,0)
end

a8=e("Frame",{
Name="IconBubble",
BackgroundColor3=if ak.IsAvatar then Color3.new(1,1,1)else ak.IconColor,
BackgroundTransparency=if ak.IsAvatar then 0.9 elseif ak.Decorated then 0.88 else 0.95,
BorderSizePixel=0,
Size=UDim2.fromOffset(au,au),
ClipsDescendants=true,
ZIndex=109,
Parent=a2,
},{
CreateCorner(au/2),
e("UIStroke",{
Color=ak.IconColor,
Transparency=if ak.Decorated then 0.72 else 0.88,
Thickness=1,
}),
e("UIGradient",{
Rotation=35,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,ak.AccentColor:Lerp(Color3.new(1,1,1),0.16)),
ColorSequenceKeypoint.new(1,ak.AccentColor),
},
}),
a9,
})
end

local ba
local bb
if ak.CanClose then
local bc=b.Icon"x"
bb=e("Frame",{
Name="Surface",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.98,
BorderSizePixel=0,
Size=UDim2.fromOffset(A,A),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ZIndex=109,
ThemeTag={
BackgroundColor3="Notification2",
},
},{
CreateCorner(A/2),
e("ImageLabel",{
Name="Icon",
Image=bc and bc[1]or"",
ImageRectSize=bc and bc[2]and bc[2].ImageRectSize or Vector2.zero,
ImageRectOffset=bc and bc[2]and bc[2].ImageRectPosition
or Vector2.zero,
BackgroundTransparency=1,
Size=UDim2.fromOffset(14,14),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=0.46,
ZIndex=110,
ThemeTag={
ImageColor3="NotificationTitle",
},
}),
})

ba=e("TextButton",{
Name="CloseButton",
Text="",
AutoButtonColor=false,
BackgroundTransparency=1,
BorderSizePixel=0,
Size=UDim2.fromOffset(z,z),
Position=UDim2.new(1,4,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
ZIndex=109,
Parent=if am then aZ else a2,
},{
bb,
})
AttachPress(ba,0.96)
AttachHover(ba,bb,0.91,0.98)
end

local bc
local bd
if am and ak.Selection~=nil then
local be=if typeof(ak.Selection)=="table"
then ak.Selection
else{Value=ak.Selection}
local bf=if typeof(be.Values or be.Options)=="table"
then be.Values or be.Options
else{}
local bg=math.max(tonumber(be.Index)or 1,1)

local function GetSelectionValue(bh)
if typeof(bh)=="table"then
return bh.Value or bh.Title or bh.Name
end
return bh
end

local bh=be.Value or be.Default
if bh~=nil and#bf>0 then
for bi,bj in bf do
local bk=GetSelectionValue(bj)
if bk==bh or tostring(bk)==tostring(bh)then
bg=bi
break
end
end
end
if bh==nil and#bf>0 then
bh=GetSelectionValue(bf[bg]or bf[1])
end
bh=bh or"Select"

local bi=b.Icon"chevron-down"
bc=e("TextButton",{
Name="Selection",
Text="",
AutoButtonColor=false,
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.9,
BorderSizePixel=0,
Size=UDim2.new(1,0,0,40),
LayoutOrder=2,
ZIndex=108,
ThemeTag={
BackgroundColor3="Notification2",
},
Parent=aX,
},{
CreateCorner(10),
e("UIStroke",{
Color=Color3.new(1,1,1),
Transparency=0.8,
Thickness=1,
ThemeTag={
Color="NotificationBorder",
Transparency="NotificationBorderTransparency",
},
}),
e("TextLabel",{
Name="Value",
Text=tostring(bh),
TextSize=14,
FontFace=Font.new(b.Font),
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
BackgroundTransparency=1,
Size=UDim2.new(1,-48,1,0),
Position=UDim2.fromOffset(14,0),
ZIndex=109,
ThemeTag={
TextColor3="NotificationTitle",
},
}),
e("ImageLabel",{
Name="Chevron",
Image=bi and bi[1]or"",
ImageRectSize=bi and bi[2]and bi[2].ImageRectSize or Vector2.zero,
ImageRectOffset=bi and bi[2]and bi[2].ImageRectPosition or Vector2.zero,
ImageTransparency=0.35,
BackgroundTransparency=1,
Size=UDim2.fromOffset(16,16),
Position=UDim2.new(1,-14,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
ZIndex=109,
ThemeTag={
ImageColor3="NotificationTitle",
},
}),
})
bd=bc.Value
AttachPress(bc,0.985)
AttachHover(bc,bc,0.84,0.9)

Connect(bc.MouseButton1Click,function()
if#bf>0 then
bg=(bg%#bf)+1
bh=GetSelectionValue(bf[bg])
bd.Text=tostring(bh)
end
b.SafeCallback(be.Callback,bh,bg,ak)
end)
end

local be
local bf=if am then 40 else C
if#ak.Buttons>0 then
be=e("Frame",{
Name="Actions",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,bf),
LayoutOrder=if am then 3 else 2,
ZIndex=107,
Parent=aX,
})

e("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Left,
VerticalAlignment=Enum.VerticalAlignment.Top,
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,6),
Parent=be,
})

for bg,bh in ak.Buttons do
local bi=bg==1
local bj
if#ak.Buttons==2 then
bj=UDim2.new(0.5,-3,0,bf)
else
bj=UDim2.new(1,0,0,bf)
end

local bk=if bi then 0.16 else 0.93
local bl=e("UIStroke",{
Color=if bi then ak.AccentColor else Color3.new(1,1,1),
Transparency=if bi then 0.55 else 0.78,
Thickness=1,
ThemeTag=if bi
then nil
else{
Color="NotificationBorder",
Transparency="NotificationBorderTransparency",
},
})

local bm=e("TextButton",{
Name="Action"..bg,
Text=tostring(bh.Title or bh.Text or"Action"),
TextSize=12,
FontFace=Font.new(b.Font),
AutoButtonColor=false,
BackgroundColor3=if bi then ak.AccentColor else Color3.new(1,1,1),
BackgroundTransparency=bk,
BorderSizePixel=0,
Size=bj,
LayoutOrder=bg,
ZIndex=108,
ThemeTag=if bi
then{
TextColor3="White",
}
else{
BackgroundColor3="Notification2",
TextColor3="NotificationTitle",
},
Parent=be,
},{
CreateCorner(9),
bl,
})
AttachPress(bm,0.97)
AttachHover(bm,bm,if bi then 0.06 else 0.87,bk)

Connect(bm.MouseButton1Click,function()
b.SafeCallback(bh.Callback,ak,bh)
if bh.Close~=false and bh.CloseOnClick~=false then
ak:Close"Action"
end
end)
end
end

local bg=aw and d:IsEnabled()and not d.Reduced
local bh=e("Frame",{
Name="ProgressTrack",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.94,
BorderSizePixel=0,
Size=if an
then UDim2.new(1,-(aq*2),0,J)
else UDim2.new(0.32,0,0,J),
Position=UDim2.new(0.5,0,1,if an then-3 else-5),
AnchorPoint=Vector2.new(0.5,1),
Visible=aw,
ZIndex=111,
ThemeTag={
BackgroundColor3="NotificationDuration",
BackgroundTransparency="NotificationDurationTransparency",
},
Parent=aQ,
},{
CreateCorner(J),
})

local bi=e("Frame",{
Name="ProgressFill",
BackgroundColor3=ak.ProgressColor,
BackgroundTransparency=b.ClampTransparency(aa.ProgressTransparency,0.12),
BorderSizePixel=0,
Size=UDim2.fromScale(1,1),
ZIndex=112,
Parent=bh,
},{
CreateCorner(J),
e("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,ak.ProgressColor),
ColorSequenceKeypoint.new(1,ak.ProgressColor:Lerp(Color3.new(1,1,1),0.22)),
},
}),
})

local function UpdateContainerHeight(bj)
local bk=math.max(math.ceil(aY.AbsoluteContentSize.Y),a2.Size.Y.Offset)
aJ=aq+bk+aq
ak.LayoutHeight=aJ
aN.Size=UDim2.new(1,0,0,aJ)

if aH then
if bj==false then
aL.Size=UDim2.new(1,0,0,aJ)
else
d.Play(
aL,
"Resize",
{Size=UDim2.new(1,0,0,aJ)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Resize"
)
end
end

if aI then
local bl=math.max(al.AbsoluteSize.Y,aJ)
TrimNotifications(math.max(math.floor(tonumber(aa.MaxVisible)or L),1),bl)
end
end

local function UpdateTextHeight()
local bj=math.max(math.ceil(a5.AbsoluteContentSize.Y),20)
a4.Size=UDim2.new(1,-(ax+ay),0,bj)
a2.Size=UDim2.new(1,0,0,math.max(bj,ak.Icon and au or 0,20))
UpdateContainerHeight(aH)
end

Connect(a5:GetPropertyChangedSignal"AbsoluteContentSize",function()
UpdateTextHeight()
end)
Connect(aY:GetPropertyChangedSignal"AbsoluteContentSize",function()
UpdateContainerHeight(aH)
end)

local function StopProgressTween()
if aD then
aD:Cancel()
aD=nil
end
end

local function CaptureRemainingTime()
if aG then
aF=math.max(aF-(os.clock()-aG),0)
aG=nil
end
ak.Remaining=aF
end

local function SetProgressRatio(bj)
bi.Size=UDim2.new(math.clamp(bj,0,1),0,1,0)
end

local function StartTimer()
if not aw or not aH or ak.Closed or ak.Paused then
return
end

if aF<=0 then
ak:Close"Timeout"
return
end

aE=aE+1
local bj=aE
aG=os.clock()
ak.Remaining=aF

StopProgressTween()
local bk=aF/ak.Duration
SetProgressRatio(bk)
if bg then
aD=f(
bi,
aF,
{Size=UDim2.new(0,0,1,0)},
Enum.EasingStyle.Linear,
Enum.EasingDirection.InOut
)
aD:Play()
end

task.delay(aF,function()
if bj==aE and not ak.Closed and not ak.Paused then
aF=0
ak.Remaining=0
ak:Close"Timeout"
end
end)
end

function ak.Pause(bj)
if not aw or ak.Closed or ak.Paused then
return ak
end

ak.Paused=true
aE=aE+1
CaptureRemainingTime()
StopProgressTween()
SetProgressRatio(aF/ak.Duration)
return ak
end

function ak.Resume(bj)
if not aw or ak.Closed or not ak.Paused then
return ak
end

ak.Paused=false
StartTimer()
return ak
end

function ak.GetRemainingDuration(bj)
if not aw then
return 0
end

local bk=aF
if aG then
bk=math.max(bk-(os.clock()-aG),0)
end
return bk
end

function ak.Update(bj,bk)
if typeof(bk)~="table"or ak.Closed then
return ak
end

if bk.Title~=nil then
ak.Title=tostring(bk.Title)
a6.Text=ak.Title
end

if bk.Content~=nil then
ak.Content=if bk.Content==false then nil else tostring(bk.Content)
a7.Text=ak.Content or""
a7.Visible=ak.Content~=nil
end

if bk.Duration~=nil then
local bl=ak.Paused
aE=aE+1
CaptureRemainingTime()
StopProgressTween()
ak.Duration=ResolveDuration(bk.Duration)
aw=typeof(ak.Duration)=="number"and ak.Duration>0
bg=aw and d:IsEnabled()and not d.Reduced
aF=if aw then ak.Duration else 0
ak.Remaining=aF
ak.Paused=bl
bh.Visible=aw
SetProgressRatio(if aw then 1 else 0)
StartTimer()
end

UpdateTextHeight()
return ak
end

function ak.Close(bj,bk)
if ak.Closed then
return ak
end

ak.Closed=true
ak.CloseReason=tostring(bk or"Manual")
aE=aE+1
CaptureRemainingTime()
DisconnectSignals()
StopProgressTween()

d.Cancel(aL,"Open")
d.Cancel(aL,"Resize")
d.Cancel(aN,"Open")
d.Cancel(aM,"Open")
d.Play(
aL,
"NotificationClose",
{Size=UDim2.new(1,0,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Close"
)
d.Play(aN,"NotificationClose",{
Position=UDim2.new(0,N,0,0),
GroupTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Close")
d.Play(
aM,
"NotificationClose",
{Scale=0.98},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Close"
)

b.SafeCallback(ak.OnClose,ak,ak.CloseReason)

local bl=if d:IsEnabled()and not d.Reduced
then d.GetDuration"NotificationClose"+0.02
else 0
task.delay(bl,function()
W.Notifications[ak.Index]=nil
if aL.Parent then
aL:Destroy()
end
end)

return ak
end

if ba then
Connect(ba.MouseButton1Click,function()
ak:Close"Dismissed"
end)
end

if ak.PauseOnHover then
Connect(aN.MouseEnter,function()
ak:Pause()
end)
Connect(aN.MouseLeave,function()
ak:Resume()
end)
end

ak.UIElements={
Container=aL,
Main=aQ,
Card=aQ,
Type=ak.Type,
Transition=aN,
TransitionScale=aM,
Shadow=aO,
NativeShadow=aR,
Stroke=aP,
Surface=aS,
LiquidGlass=aT,
ToneWash=aU,
AccentLine=aV,
TopHighlight=aW,
Body=aX,
Header=a2,
AppHeader=aZ,
AppIcon=a_,
AppName=a0,
AppTimestamp=a1,
TextContainer=a4,
Title=a6,
Content=a7,
Timestamp=a3,
Icon=a9,
Avatar=if ak.IsAvatar then a9 else nil,
IconBubble=a8,
CloseButton=ba,
CloseSurface=bb,
Actions=be,
Selection=bc,
SelectionValue=bd,
ProgressTrack=bh,
ProgressFill=bi,
}

UpdateTextHeight()
aI=true
TrimNotifications(
math.max(math.floor(tonumber(aa.MaxVisible)or L),1),
math.max(al.AbsoluteSize.Y,aJ)
)

task.spawn(function()
task.wait()
if ak.Closed then
return
end

UpdateTextHeight()
aH=true
d.Play(
aL,
"Notification",
{Size=UDim2.new(1,0,0,aJ)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Open"
)
d.Play(aN,"Notification",{
Position=UDim2.new(0,0,0,0),
GroupTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Open")
d.Play(aM,"Notification",{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Open")

b.SafeCallback(ak.OnOpen,ak)
StartTimer()
end)

return ak
end

return W end function a.h()












local aa=4294967296;local ab=aa-1;local function c(ac,ad)local ae,af=0,1;while ac~=0 or ad~=0 do local ag,ah=ac%2,ad%2;local ai=(ag+ah)%2;ae=ae+ai*af;ac=math.floor(ac/2)ad=math.floor(ad/2)af=af*2 end;return ae%aa end;local function k(ac,ad,ae,...)local af;if ad then ac=ac%aa;ad=ad%aa;af=c(ac,ad)if ae then af=k(af,ae,...)end;return af elseif ac then return ac%aa else return 0 end end;local function n(ac,ad,ae,...)local af;if ad then ac=ac%aa;ad=ad%aa;af=(ac+ad-c(ac,ad))/2;if ae then af=n(af,ae,...)end;return af elseif ac then return ac%aa else return ab end end;local function o(ac)return ab-ac end;local function q(ac,ad)if ad<0 then return lshift(ac,-ad)end;return math.floor(ac%4294967296/2^ad)end;local function s(ac,ad)if ad>31 or ad<-31 then return 0 end;return q(ac%aa,ad)end;local function lshift(ac,ad)if ad<0 then return s(ac,-ad)end;return ac*2^ad%4294967296 end;local function t(ac,ad)ac=ac%aa;ad=ad%32;local ae=n(ac,2^ad-1)return s(ac,ad)+lshift(ae,32-ad)end;local ac={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(ad)return string.gsub(ad,".",function(ae)return string.format("%02x",string.byte(ae))end)end;local function y(ad,ae)local af=""for ag=1,ae do local ah=ad%256;af=string.char(ah)..af;ad=(ad-ah)/256 end;return af end;local function D(ad,ae)local af=0;for ag=ae,ae+3 do af=af*256+string.byte(ad,ag)end;return af end;local function E(ad,ae)local af=64-(ae+9)%64;ae=y(8*ae,8)ad=ad.."\128"..string.rep("\0",af)..ae;assert(#ad%64==0)return ad end;local function I(ad)ad[1]=0x6a09e667;ad[2]=0xbb67ae85;ad[3]=0x3c6ef372;ad[4]=0xa54ff53a;ad[5]=0x510e527f;ad[6]=0x9b05688c;ad[7]=0x1f83d9ab;ad[8]=0x5be0cd19;return ad end;local function K(ad,ae,af)local ag={}for ah=1,16 do ag[ah]=D(ad,ae+(ah-1)*4)end;for ah=17,64 do local ai=ag[ah-15]local aj=k(t(ai,7),t(ai,18),s(ai,3))ai=ag[ah-2]ag[ah]=(ag[ah-16]+aj+ag[ah-7]+k(t(ai,17),t(ai,19),s(ai,10)))%aa end;local ah,ai,aj,ak,al,am,an,ao=af[1],af[2],af[3],af[4],af[5],af[6],af[7],af[8]for ap=1,64 do local aq=k(t(ah,2),t(ah,13),t(ah,22))local ar=k(n(ah,ai),n(ah,aj),n(ai,aj))local as=(aq+ar)%aa;local at=k(t(al,6),t(al,11),t(al,25))local au=k(n(al,am),n(o(al),an))local av=(ao+at+au+ac[ap]+ag[ap])%aa;ao=an;an=am;am=al;al=(ak+av)%aa;ak=aj;aj=ai;ai=ah;ah=(av+as)%aa end;af[1]=(af[1]+ah)%aa;af[2]=(af[2]+ai)%aa;af[3]=(af[3]+aj)%aa;af[4]=(af[4]+ak)%aa;af[5]=(af[5]+al)%aa;af[6]=(af[6]+am)%aa;af[7]=(af[7]+an)%aa;af[8]=(af[8]+ao)%aa end;local function Z(ad)ad=E(ad,#ad)local ae=I{}for af=1,#ad,64 do K(ad,af,ae)end;return w(y(ae[1],4)..y(ae[2],4)..y(ae[3],4)..y(ae[4],4)..y(ae[5],4)..y(ae[6],4)..y(ae[7],4)..y(ae[8],4))end;local ad;local ae={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local af={["/"]="/"}for ag,ah in pairs(ae)do af[ah]=ag end;local ag=function(ag)return"\\"..(ae[ag]or string.format("u%04x",ag:byte()))end;local ah=function(ah)return"null"end;local ai=function(ai,aj)local ak={}aj=aj or{}if aj[ai]then error"circular reference"end;aj[ai]=true;if rawget(ai,1)~=nil or next(ai)==nil then local al=0;for am in pairs(ai)do if type(am)~="number"then error"invalid table: mixed or invalid key types"end;al=al+1 end;if al~=#ai then error"invalid table: sparse array"end;for am,an in ipairs(ai)do table.insert(ak,ad(an,aj))end;aj[ai]=nil;return"["..table.concat(ak,",").."]"else for al,am in pairs(ai)do if type(al)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(ak,ad(al,aj)..":"..ad(am,aj))end;aj[ai]=nil;return"{"..table.concat(ak,",").."}"end end;local aj=function(aj)return'"'..aj:gsub('[%z\1-\31\\"]',ag)..'"'end;local ak=function(ak)if ak~=ak or ak<=-math.huge or ak>=math.huge then error("unexpected number value '"..tostring(ak).."'")end;return string.format("%.14g",ak)end;local al={["nil"]=ah,table=ai,string=aj,number=ak,boolean=tostring}ad=function(am,an)local ao=type(am)local ap=al[ao]if ap then return ap(am,an)end;error("unexpected type '"..ao.."'")end;local am=function(am)return ad(am)end;local an;local ao=function(...)local ao={}for ap=1,select("#",...)do ao[select(ap,...)]=true end;return ao end;local ap=ao(" ","\t","\r","\n")local aq=ao(" ","\t","\r","\n","]","}",",")local ar=ao("\\","/",'"',"b","f","n","r","t","u")local as=ao("true","false","null")local at={["true"]=true,["false"]=false,null=nil}local au=function(au,av,aw,ax)for ay=av,#au do if aw[au:sub(ay,ay)]~=ax then return ay end end;return#au+1 end;local av=function(av,aw,ax)local ay=1;local az=1;for aA=1,aw-1 do az=az+1;if av:sub(aA,aA)=="\n"then ay=ay+1;az=1 end end;error(string.format("%s at line %d col %d",ax,ay,az))end;local aw=function(aw)local ax=math.floor;if aw<=0x7f then return string.char(aw)elseif aw<=0x7ff then return string.char(ax(aw/64)+192,aw%64+128)elseif aw<=0xffff then return string.char(ax(aw/4096)+224,ax(aw%4096/64)+128,aw%64+128)elseif aw<=0x10ffff then return string.char(ax(aw/262144)+240,ax(aw%262144/4096)+128,ax(aw%4096/64)+128,aw%64+128)end;error(string.format("invalid unicode codepoint '%x'",aw))end;local ax=function(ax)local ay=tonumber(ax:sub(1,4),16)local az=tonumber(ax:sub(7,10),16)if az then return aw((ay-0xd800)*0x400+az-0xdc00+0x10000)else return aw(ay)end end;local ay=function(ay,az)local aA=""local aB=az+1;local aC=aB;while aB<=#ay do local aD=ay:byte(aB)if aD<32 then av(ay,aB,"control character in string")elseif aD==92 then aA=aA..ay:sub(aC,aB-1)aB=aB+1;local aE=ay:sub(aB,aB)if aE=="u"then local aF=ay:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",aB+1)or ay:match("^%x%x%x%x",aB+1)or av(ay,aB-1,"invalid unicode escape in string")aA=aA..ax(aF)aB=aB+#aF else if not ar[aE]then av(ay,aB-1,"invalid escape char '"..aE.."' in string")end;aA=aA..af[aE]end;aC=aB+1 elseif aD==34 then aA=aA..ay:sub(aC,aB-1)return aA,aB+1 end;aB=aB+1 end;av(ay,az,"expected closing quote for string")end;local az=function(az,aA)local aB=au(az,aA,aq)local aC=az:sub(aA,aB-1)local aD=tonumber(aC)if not aD then av(az,aA,"invalid number '"..aC.."'")end;return aD,aB end;local aA=function(aA,aB)local aC=au(aA,aB,aq)local aD=aA:sub(aB,aC-1)if not as[aD]then av(aA,aB,"invalid literal '"..aD.."'")end;return at[aD],aC end;local aB=function(aB,aC)local aD={}local aE=1;aC=aC+1;while 1 do local aF;aC=au(aB,aC,ap,true)if aB:sub(aC,aC)=="]"then aC=aC+1;break end;aF,aC=an(aB,aC)aD[aE]=aF;aE=aE+1;aC=au(aB,aC,ap,true)local aG=aB:sub(aC,aC)aC=aC+1;if aG=="]"then break end;if aG~=","then av(aB,aC,"expected ']' or ','")end end;return aD,aC end;local aC=function(aC,aD)local aE={}aD=aD+1;while 1 do local aF,aG;aD=au(aC,aD,ap,true)if aC:sub(aD,aD)=="}"then aD=aD+1;break end;if aC:sub(aD,aD)~='"'then av(aC,aD,"expected string for key")end;aF,aD=an(aC,aD)aD=au(aC,aD,ap,true)if aC:sub(aD,aD)~=":"then av(aC,aD,"expected ':' after key")end;aD=au(aC,aD+1,ap,true)aG,aD=an(aC,aD)aE[aF]=aG;aD=au(aC,aD,ap,true)local aH=aC:sub(aD,aD)aD=aD+1;if aH=="}"then break end;if aH~=","then av(aC,aD,"expected '}' or ','")end end;return aE,aD end;local aD={['"']=ay,["0"]=az,["1"]=az,["2"]=az,["3"]=az,["4"]=az,["5"]=az,["6"]=az,["7"]=az,["8"]=az,["9"]=az,["-"]=az,t=aA,f=aA,n=aA,["["]=aB,["{"]=aC}an=function(aE,aF)local aG=aE:sub(aF,aF)local aH=aD[aG]if aH then return aH(aE,aF)end;av(aE,aF,"unexpected character '"..aG.."'")end;local aE=function(aE)if type(aE)~="string"then error("expected argument of type string, got "..type(aE))end;local aF,aG=an(aE,au(aE,1,ap,true))aG=au(aE,aG,ap,true)if aG<=#aE then av(aE,aG,"trailing garbage")end;return aF end;
local aF,aG,aH=am,aE,Z;





local aI={}

local aJ=(cloneref or clonereference or function(aJ)return aJ end)


function aI.New(aK,aL)

local aM=aK;
local aN=aL;
local aO=true;


local aP=function(aP)end;


repeat task.wait(1)until game:IsLoaded();


local aQ=false;
local aR,aS,aT,aU,aV,aW,aX,aY,aZ=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return aJ(game:GetService"Players").LocalPlayer.UserId end
local a_,a0="",0;


local a1="https://api.platoboost.app";
local a2=aS{
Url=a1 .."/public/connectivity",
Method="GET"
};
if a2.StatusCode~=200 and a2.StatusCode~=429 then
a1="https://api.platoboost.net";
end


function cacheLink()
if a0+(600)<aW()then
local a3=aS{
Url=a1 .."/public/start",
Method="POST",
Body=aF{
service=aM,
identifier=aH(aZ())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if a3.StatusCode==200 then
local a4=aG(a3.Body);

if a4.success==true then
a_=a4.data.url;
a0=aW();
return true,a_
else
aP(a4.message);
return false,a4.message
end
elseif a3.StatusCode==429 then
local a4="you are being rate limited, please wait 20 seconds and try again.";
aP(a4);
return false,a4
end

local a4="Failed to cache link.";
aP(a4);
return false,a4
else
return true,a_
end
end

cacheLink();


local a3=function()
local a3=""
for a4=1,16 do
a3=a3 ..aT(aY(aX()*(26))+97)
end
return a3
end


for a4=1,5 do
local a5=a3();
task.wait(0.2)
if a3()==a5 then
local a6="platoboost nonce error.";
aP(a6);
error(a6);
end
end


local a4=function()
local a4,a5=cacheLink();

if a4 then
aR(a5);
end
end


local a5=function(a5)
local a6=a3();
local a7=a1 .."/public/redeem/"..aU(aM);

local a8={
identifier=aH(aZ()),
key=a5
}

if aO then
a8.nonce=a6;
end

local a9=aS{
Url=a7,
Method="POST",
Body=aF(a8),
Headers={
["Content-Type"]="application/json"
}
};

if a9.StatusCode==200 then
local b=aG(a9.Body);

if b.success==true then
if b.data.valid==true then
if aO then
if b.data.hash==aH("true".."-"..a6 .."-"..aN)then
return true
else
aP"failed to verify integrity.";
return false
end
else
return true
end
else
aP"key is invalid.";
return false
end
else
if aV(b.message,1,27)=="unique constraint violation"then
aP"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
aP(b.message);
return false
end
end
elseif a9.StatusCode==429 then
aP"you are being rate limited, please wait 20 seconds and try again.";
return false
else
aP"server returned an invalid status code, please try again later.";
return false
end
end


local a6=function(a6)
if aQ==true then
return false,("A request is already being sent, please slow down.")
else
aQ=true;
end

local a7=a3();
local a8=a1 .."/public/whitelist/"..aU(aM).."?identifier="..aH(aZ()).."&key="..a6;

if aO then
a8=a8 .."&nonce="..a7;
end

local a9=aS{
Url=a8,
Method="GET",
};

aQ=false;

if a9.StatusCode==200 then
local b=aG(a9.Body);

if b.success==true then
if b.data.valid==true then
if aO then
if b.data.hash==aH("true".."-"..a7 .."-"..aN)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if aV(a6,1,4)=="KEY_"then
return true,a5(a6)
else
return false,("Key is invalid.")
end
end
else
return false,(b.message)
end
elseif a9.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local a7=function(a7)
local a8=a3();
local a9=a1 .."/public/flag/"..aU(aM).."?name="..a7;

if aO then
a9=a9 .."&nonce="..a8;
end

local b=aS{
Url=a9,
Method="GET",
};

if b.StatusCode==200 then
local ba=aG(b.Body);

if ba.success==true then
if aO then
if ba.data.hash==aH(aU(ba.data.value).."-"..a8 .."-"..aN)then
return ba.data.value
else
aP"failed to verify integrity.";
return nil
end
else
return ba.data.value
end
else
aP(ba.message);
return nil
end
else
return nil
end
end


return{
Verify=a6,
GetFlag=a7,
Copy=a4,
}
end


return aI end function a.i()






local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ab=aa(game:GetService"HttpService")
local ad={}

function ad.New(ae)
local af=gethwid or function()
return aa(game:GetService"Players").LocalPlayer.UserId
end
local ag,ah=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ai)
local aj="https://api.pandauth.com/api/v1/keys/validate"

local ak={
ServiceID=ae,
HWID=tostring(af()),
Key=tostring(ai),
}

local al=ab:JSONEncode(ak)
local am,an=pcall(function()
return ag{
Url=aj,
Method="POST",
Headers={
["User-Agent"]="Roblox/Exploit",
["Content-Type"]="application/json",
},
Body=al,
}
end)

if am and an then
if an.Success then
local ao,ap=pcall(function()
return ab:JSONDecode(an.Body)
end)

if ao and ap then
if ap.Authenticated_Status and ap.Authenticated_Status=="Success"then
return true,"Authenticated"
else
local aq=ap.Note or"Unknown reason"
return false,"Authentication failed: "..aq
end
else
return false,"JSON decode error"
end
else
warn(
" HTTP request was not successful. Code: "
..tostring(an.StatusCode)
.." Message: "
..an.StatusMessage
)
return false,"HTTP request failed: "..an.StatusMessage
end
else
return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://new.pandadevelopment.net/getkey/"..tostring(ae).."?hwid="..tostring(af())
end

function CopyLink()
return ah(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink,
}
end

return ad end function a.j()







local aa={}

function aa.New(ab,ad)
local ae="https://sdkapi-public.luarmor.net/library.lua"

local af=loadstring(game.HttpGet and game:HttpGet(ae)or HttpService:GetAsync(ae))()
local ag=setclipboard or toclipboard

af.script_id=ab

function ValidateKey(ah)
local ai=af.check_key(ah)


if ai.code=="KEY_VALID"then
return true,"Whitelisted!"
elseif ai.code=="KEY_HWID_LOCKED"then
return false,"Key linked to a different HWID. Please reset it using our bot"
elseif ai.code=="KEY_INCORRECT"then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ai.message.." Code: "..ai.code
end
end

function CopyLink()
ag(tostring(ad))
end

return{
Verify=ValidateKey,
Copy=CopyLink,
}
end

return aa end function a.k()









local aa={}

function aa.New(ab,ad,ae)
JunkieProtected.API_KEY=ad
JunkieProtected.PROVIDER=ae
JunkieProtected.SERVICE_ID=ab

local function ValidateKey(af)
if not af or af==""then
print"No key provided!"

return false,"No key provided. Please get a key."
end

local ag=JunkieProtected.IsKeylessMode()
if ag and ag.keyless_mode then
print"Keyless mode enabled. Starting script..."
return true,"Keyless mode enabled. Starting script..."
end

local ah=JunkieProtected.ValidateKey{Key=af}
if ah=="valid"then
print"Key is valid! Starting script..."
load()
if _G.JD_IsPremium then
print"Premium user detected!"
else
print"Standard user"
end

return true,"Key is valid!"
else
local ai=JunkieProtected.GetKeyLink()
print"Invalid key!"

return false,"Invalid key. Get one from:"..ai
end
end

local function copyLink()
local af=JunkieProtected.GetKeyLink()

if setclipboard then
setclipboard(af)
end
end
return{
Verify=ValidateKey,
Copy=copyLink
}
end

return aa end function a.l()



return{
platoboost={
Name="Platoboost",
Icon="rbxassetid://75920162824531",
Args={"ServiceId","Secret"},

New=a.load'h'.New
},
pandadevelopment={
Name="Panda Development",
Icon="panda",
Args={"ServiceId"},

New=a.load'i'.New
},
luarmor={
Name="Luarmor",
Icon="rbxassetid://130918283130165",
Args={"ScriptId","Discord"},

New=a.load'j'.New
},
junkiedevelopment={
Name="Junkie Development",
Icon="rbxassetid://106310347705078",
Args={"ServiceId","ApiKey","Provider"},

New=a.load'k'.New
},


}end function a.m()



return[[
{
    "name": "windui",
    "version": "1.6.65",
    "main": "./dist/main.lua",
    "repository": "https://github.com/article-hub-studio/WindUI-Skibidi",
    "discord": "https://discord.gg/ftgs-development-hub-1300692552005189632",
    "author": "Footagesus",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "bash build/build.sh dev $INPUT_FILE",
        "build": "bash build/build.sh build $INPUT_FILE",
        "live": "python3 -m http.server 8642",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
        "updater": "python3 updater/main.py",
        "docs:dev": "npm --prefix website run dev",
        "docs:build": "npm --prefix website run build",
        "docs:start": "npm --prefix website run start",
        "verify:notification": "stylua --syntax Luau --check src/components/Notification.lua tests/Notification.lua && node tests/notification-layout-safety.test.js",
        "verify:ui": "stylua --syntax Luau --check src/modules/Icons.lua src/modules/Creator.lua src/Init.lua src/components/Notification.lua src/components/window/Openbutton.lua src/themes/Fallbacks.lua tests/Notification.lua && node tests/notification-layout-safety.test.js && node tests/ui-library-advanced.test.js",
        "test:static": "node tests/acrylic-theme-safety.test.js && node tests/notification-layout-safety.test.js && node tests/ui-library-advanced.test.js"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}
]]end function a.n()

local aa={}

local ab=a.load'd'
local ad=ab.New
local ae=ab.Tween

function aa.New(af,ag,ah,ai,aj,ak,al,am)
ai=ai or"Primary"
local an=am or(not al and 10 or 999)
local ao
if ag and ag~=""then
ao=ad("ImageLabel",{
Image=ab.Icon(ag)[1],
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=ai=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ai=="White"and 0.4 or 0,
ThemeTag={
ImageColor3=ai~="White"and"Icon"or nil,
},
})
end

local ap=ad("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=aj,
BackgroundTransparency=1,
},{
ab.NewRoundFrame(an,"Squircle",{
ThemeTag={
ImageColor3=ai~="White"and"Button"or nil,
},
ImageColor3=ai=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ai=="Primary"and 0 or ai=="White"and 0 or 0.9,
}),

ab.NewRoundFrame(an,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ai=="Secondary"and 0.95 or 1,
}),

ab.NewRoundFrame(an,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not al,
}),

ab.NewRoundFrame(an,"SquircleGlass",{
ThemeTag={
ImageColor3="White",
},
Size=UDim2.new(1,1,1,1),

ImageTransparency=0.9,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Outline",
},{













}),

ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ai~="White"and"Text"or nil,
},
ImageColor3=ai=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1,
},{
ad("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
ao,
ad("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font),
Text=af or"Button",
ThemeTag={
TextColor3=(ai~="Primary"and ai~="White")and"Text",
},
TextColor3=ai=="Primary"and Color3.new(1,1,1)
or ai=="White"and Color3.new(0,0,0)
or nil,
AutomaticSize="XY",
TextSize=18,
}),
}),
})

ab.AddSignal(ap.MouseEnter,function()
ae(ap.Frame,0.047,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(ap.MouseLeave,function()
ae(ap.Frame,0.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(ap.MouseButton1Click,function()
if ak then
ak:Close()()
end
if ah then
ab.SafeCallback(ah)
end
end)

return ap
end

return aa end function a.o()

local aa={}

local ab=a.load'd'
local ad=a.load'e'
local ae=ab.New

function aa.New(af,ag,ah,ai,aj,ak,al,am,an)
ai=ai or"Input"
local ao=al or 10
local ap
if ag and ag~=""then
ap=ae("ImageLabel",{
Image=ab.Icon(ag)[1],
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
})
end

local aq=ai=="Textarea"

local ar=ae("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font),
Size=UDim2.new(1,ap and-29 or 0,1,0),
PlaceholderText=af,
ClearTextOnFocus=am or false,
ClipsDescendants=true,
TextWrapped=aq,
MultiLine=aq,
TextXAlignment="Left",
TextYAlignment=ai~="Textarea"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local as=ab.NewRoundFrame(ao,"Squircle",{
ThemeTag={
ImageColor3="Placeholder",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.85,
})
local at=not an and ab.NewRoundFrame(ao-1,"SquircleGlass",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.8,
})or nil
local au=ab.NewRoundFrame(ao,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ae("UIPadding",{
PaddingTop=UDim.new(0,ai~="Textarea"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ai~="Textarea"and 0 or 12),
}),
ae("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ai~="Textarea"and"Center"or"Top",
HorizontalAlignment="Left",
}),
ap,
ar,
})

local av=ae("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ah,
BackgroundTransparency=1,
},{
ae("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
as,
at,
au,
}),
})










if ak then
ab.AddSignal(ar:GetPropertyChangedSignal"Text",function()
if aj then
ab.SafeCallback(aj,ar.Text)
end
end)
else
ab.AddSignal(ar.FocusLost,function()
if aj then
ab.SafeCallback(aj,ar.Text)
end
end)
end

ab.AddSignal(ar.Focused,function()
ad.Play(as,"Focus",{ImageTransparency=0.78},nil,nil,"Focus")
if at then
ad.Play(at,"Focus",{ImageTransparency=0.65},nil,nil,"Focus")
end
end)
ab.AddSignal(ar.FocusLost,function()
ad.Play(as,"Focus",{ImageTransparency=0.85},nil,nil,"Focus")
if at then
ad.Play(at,"Focus",{ImageTransparency=0.8},nil,nil,"Focus")
end
end)

return av
end

return aa end function a.p()

local aa=a.load'd'
local ab=aa.New
local ad=aa.Tween




local ae={
Holder=nil,

Parent=nil,
}

function ae.Create(af,ag,ah,ai,aj)
local ak={
UICorner=28,
UIPadding=12,

Window=ah,
WindUI=ai,

UIElements={},
}

if af then
ak.UIPadding=0
end
if af then
ak.UICorner=26
end

ag=ag or"Dialog"

if not af then
ak.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=ae.Parent
or(ah and ah.UIElements and ah.UIElements.Main and ah.UIElements.Main.Main),
},{
ab("UICorner",{
CornerRadius=UDim.new(0,ah.UICorner),
}),
})
end

ab("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=UDim2.new(1,100,1,100),
Position=UDim2.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

ak.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=ag.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ak.UIPadding),
PaddingLeft=UDim.new(0,ak.UIPadding),
PaddingRight=UDim.new(0,ak.UIPadding),
PaddingBottom=UDim.new(0,ak.UIPadding),
}),
})

ak.UIElements.MainContainer=aa.NewRoundFrame(ak.UICorner,"Squircle",{
Visible=false,

ImageTransparency=af and 0.15 or 0,
Parent=aj or ak.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=ag.."Background",
ImageTransparency=ag.."BackgroundTransparency",
},
ZIndex=9999,
},{






ak.UIElements.Main,




















})

function ak.Open(al)
if not af then
ak.UIElements.FullScreen.Visible=true
ak.UIElements.FullScreen.Active=true
end

task.spawn(function()
ak.UIElements.MainContainer.Visible=true

if not af then
ad(ak.UIElements.FullScreen,0.1,{BackgroundTransparency=0.65}):Play()
end
ad(ak.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
ak.UIElements.Main.Visible=true
end)
end)
end
function ak.Close(al)
if not af then
ad(ak.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
ak.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(0.1)
ak.UIElements.FullScreen.Visible=false
end)
end
ak.UIElements.Main.Visible=false

ad(ak.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(0.1)
if not af then
ak.UIElements.FullScreen:Destroy()
else
ak.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return ak
end

return ae end function a.q()

local aa={}

local ab=a.load'd'
local ad=a.load'e'
local ae=ab.New
local af=game:GetService"Workspace"

local ag=a.load'n'.New
local ah=a.load'o'.New

local function GetViewportSize()
local ai=af.CurrentCamera
return ai and ai.ViewportSize or Vector2.new(1280,720)
end

function aa.new(ai,aj,ak,al)
local am=a.load'p'
local an=am.Create(true,"Popup",ai.Window,ai.WindUI,ai.WindUI.ScreenGui.KeySystem)

local ao={}

local ap

local aq=GetViewportSize()
local ar=aq.X<560
local as=ai.KeySystem.Thumbnail and ai.KeySystem.Thumbnail.Image and not ar
local at=(as and ai.KeySystem.Thumbnail.Width)or 200

local au=ai.KeySystem.Width or 430
if as then
au=430+(at/2)
end
au=math.floor(math.min(au,math.max(300,aq.X-24)))

an.UIElements.Main.AutomaticSize="Y"
an.UIElements.Main.Size=UDim2.new(0,au,0,0)
an.UIElements.MainContainer.ClipsDescendants=true

local av=ae("UIScale",{
Name="Scale",
Scale=0.96,
Parent=an.UIElements.MainContainer,
})

ab.NewRoundFrame(26,"SquircleGlass",{
Name="GlassLayer",
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.84,
ZIndex=9998,
Parent=an.UIElements.MainContainer,
ThemeTag={
ImageColor3="Primary",
},
})

ab.NewRoundFrame(26,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.62,
ZIndex=9998,
Parent=an.UIElements.MainContainer,
ThemeTag={
ImageColor3="Outline",
},
})

local aw

if ai.Icon then
aw=
ab.Image(ai.Icon,ai.Title..":"..ai.Icon,0,"Temp","KeySystem",ai.IconThemed)
aw.Size=UDim2.new(0,24,0,24)
aw.LayoutOrder=-1
end

local ax=ae("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ai.KeySystem.Title or ai.Title,
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="Text",
},
TextSize=20,
})

local ay=ae("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Text=ai.KeySystem.Subtitle or ai.KeySystem.Description or"Secure access gate",
TextXAlignment="Left",
TextTransparency=0.34,
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="Text",
},
TextSize=13,
})

local az=ae("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ae("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aw,
ax,
})

local aA=ae("TextLabel",{
BackgroundTransparency=1,
Text="Waiting",
TextSize=12,
TextTransparency=0.08,
AutomaticSize="XY",
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="Text",
},
})

local aB=ab.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,0,0,28),
AutomaticSize="X",
ImageTransparency=0.84,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,6),
}),
ab.NewRoundFrame(999,"Squircle",{
Name="Dot",
Size=UDim2.fromOffset(7,7),
ImageTransparency=0,
ThemeTag={
ImageColor3="Primary",
},
}),
aA,
})

local aC=ae("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{
ae("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
az,
aB,
})

az.Size=UDim2.new(1,-112,0,0)

local aD=ab.NewRoundFrame(18,"Squircle",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.86,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIGradient",{
Rotation=18,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.06),
NumberSequenceKeypoint.new(1,0.34),
},
}),
ae("UIPadding",{
PaddingTop=UDim.new(0,14),
PaddingLeft=UDim.new(0,14),
PaddingRight=UDim.new(0,14),
PaddingBottom=UDim.new(0,14),
}),
ae("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
}),
aC,
ay,
})

local aE=ah(ai.KeySystem.Placeholder or"Enter Key","key",nil,"Input",function(aE)
ap=aE
end)

local aF
if ai.KeySystem.Note and ai.KeySystem.Note~=""then
aF=ae("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font),
TextXAlignment="Left",
Text=ai.KeySystem.Note,
TextSize=18,
TextTransparency=0.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local aG=ae("UIGradient",{
Name="FillGradient",
Rotation=0,
Offset=Vector2.new(-0.2,0),
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.08),
NumberSequenceKeypoint.new(0.45,0),
NumberSequenceKeypoint.new(1,0.2),
},
})
local aH=ab.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(0.18,0,1,0),
ClipsDescendants=true,
ImageTransparency=0.02,
ZIndex=3,
ThemeTag={
ImageColor3="Primary",
},
},{
aG,
ab.NewRoundFrame(999,"SquircleGlass",{
Name="LiquidSheen",
Size=UDim2.new(0.42,0,1,0),
Position=UDim2.new(0.18,0,0,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.7,
ZIndex=4,
},{
ae("UIGradient",{
Rotation=0,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.48,0.22),
NumberSequenceKeypoint.new(1,1),
},
}),
}),
})
local aI=ae("TextLabel",{
Size=UDim2.new(1,0,0,16),
BackgroundTransparency=1,
Text="Access check ready",
TextSize=12,
TextTransparency=0.34,
TextXAlignment="Left",
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="Text",
},
})
local aJ=ab.NewRoundFrame(999,"Squircle",{
Name="ProgressTrack",
Size=UDim2.new(1,0,0,10),
ClipsDescendants=true,
ImageTransparency=0.84,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ab.NewRoundFrame(999,"SquircleGlass",{
Name="TrackGlass",
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.92,
ZIndex=2,
}),
aH,
ab.NewRoundFrame(999,"SquircleOutline",{
Name="TrackOutline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.72,
ZIndex=5,
ThemeTag={
ImageColor3="Outline",
},
}),
})
local aK=ae("Frame",{
Size=UDim2.new(1,0,0,30),
BackgroundTransparency=1,
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,6),
}),
aI,
aJ,
})

local function SetState(aL,aM,aN)
aA.Text=tostring(aL or aA.Text)
aI.Text=tostring(aL or aI.Text)
if aN then
aB.Dot.ImageColor3=Color3.fromRGB(255,94,94)
aH.ImageColor3=Color3.fromRGB(255,94,94)
else
ab.SetThemeTag(aB.Dot,{
ImageColor3="Primary",
},0.12)
ab.SetThemeTag(aH,{
ImageColor3="Primary",
},0.12)
end
if aM~=nil then
aG.Offset=Vector2.new(-0.2,0)
ad.Play(aH,"Switch",{
Size=UDim2.new(math.clamp(tonumber(aM)or 0,0,1),0,1,0),
},nil,nil,"KeySystemProgress")
ad.Play(aG,"Background",{
Offset=Vector2.new(0.45,0),
},Enum.EasingStyle.Sine,Enum.EasingDirection.Out,"KeySystemProgressSheen")
end
end

local aL=ae("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ae("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ae("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
}),
}),
})

local aM
if as then
local aN
if ai.KeySystem.Thumbnail.Title then
aN=ae("TextLabel",{
Text=ai.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
aM=ae("ImageLabel",{
Image=ai.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,at,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=an.UIElements.Main,
ScaleType="Crop",
},{
aN,
ae("UICorner",{
CornerRadius=UDim.new(0,20),
}),
})
end

ae("Frame",{

Size=UDim2.new(1,aM and-at or 0,1,0),
Position=UDim2.new(0,aM and at or 0,0,0),
BackgroundTransparency=1,
Parent=an.UIElements.Main,
},{
ae("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ae("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
aD,
aF,
aE,
aK,
aL,
ae("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
}),
})





local aN=ag("Exit","log-out",function()
an:Close()()
end,"Tertiary",aL.Frame)

if aM then
aN.Parent=aM
aN.Size=UDim2.new(0,0,0,42)
aN.Position=UDim2.new(0,10,1,-10)
aN.AnchorPoint=Vector2.new(0,1)
end

local function NotifyKeySystem(aO,aP,aQ)
if ai.WindUI and ai.WindUI.Notify then
ai.WindUI:Notify{
Title="Key System",
Content=aO,
Icon=aP or"key",
Style=aQ,
}
end
end

local function CopyRawLink(aO)
aO=aO and tostring(aO)or""
if aO==""then
return false,"No key link configured."
end

local aP=setclipboard or toclipboard
if not aP then
return false,"Clipboard is not available on this executor."
end

aP(aO)
return true
end

local function PickServiceLink(aO)
return aO.Discord
or aO.URL
or aO.Url
or aO.url
or aO.Link
or aO.link
end

local function CopyServiceLink(aO)
local aP=PickServiceLink(aO.Config)
local aQ,aR

if aP then
aQ,aR=CopyRawLink(aP)
elseif aO.Instance and type(aO.Instance.Copy)=="function"then
aQ,aR=pcall(aO.Instance.Copy)
else
aQ,aR=false,aO.Error or"Service link is not ready."
end

if aQ then
SetState("Key link copied",0.36)
NotifyKeySystem("Key link copied to clipboard.","key","Success")
else
SetState("Copy unavailable",0.08,true)
NotifyKeySystem(tostring(aR or"Unable to copy key link."),"triangle-alert","Warning")
end
end

if ai.KeySystem.URL and not ai.KeySystem.API then
ag("Get key","key",function()
local aO,aP=CopyRawLink(ai.KeySystem.URL)
if aO then
SetState("Key link copied",0.36)
NotifyKeySystem("Key link copied to clipboard.","key","Success")
else
SetState("Copy unavailable",0.08,true)
NotifyKeySystem(tostring(aP),"triangle-alert","Warning")
end
end,"Secondary",aL.Frame)
end

if ai.KeySystem.API then
local aO={}
for aP,aQ in next,ai.KeySystem.API do
local aR=ai.WindUI.Services[aQ.Type]
if aR then
local aS={}
for aT,aU in next,aR.Args do
table.insert(aS,aQ[aU])
end

local aT,aU=pcall(function()
return aR.New(table.unpack(aS))
end)

local aV={
Config=aQ,
Definition=aR,
Instance=nil,
Error=nil,
}

if aT and aU then
aU.Type=aQ.Type
aV.Instance=aU
table.insert(ao,aU)
else
aV.Error=aU
end

table.insert(aO,aV)
end
end

local aP=math.min(240,math.max(190,au-42))
local aQ=false

if#aO==1 then
ag("Get key","key",function()
CopyServiceLink(aO[1])
end,"Secondary",aL.Frame)
elseif#aO>1 then
local aR=ag("Get key","key",nil,"Secondary",aL.Frame)

local aS=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
})

ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=aR.Frame,
},{
aS,
ae("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
}),
})

local aT=ab.Image("chevron-down","chevron-down",0,"Temp","KeySystem",true)

aT.Size=UDim2.new(1,0,1,0)

ae("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=aR.Frame,
BackgroundTransparency=1,
},{
aT,
})

local aU=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ZIndex=99999,
ThemeTag={
ImageColor3="Background",
},
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
}),
})

local aV=ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,aP,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=aR,
Position=UDim2.new(1,0,1,10),
ZIndex=99999,
},{
aU,
})

ae("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=15,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=aU,
ZIndex=100000,
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,8),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,8),
}),
})

for aW,aX in next,aO do
local aY=aX.Config
local aZ=aX.Definition
local a_=aY.Icon or aZ.Icon or"key-round"
local a0=ab.Image(a_,a_,0,"Temp","KeySystem",true)
a0.Size=UDim2.new(0,20,0,20)
a0.ZIndex=100000

local a1=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=aU,
AutomaticSize="Y",
ZIndex=100000,
},{
ae("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
}),
a0,
ae("UIPadding",{
PaddingTop=UDim.new(0,9),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,9),
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-28,0,0),
AutomaticSize="Y",
ZIndex=100000,
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ae("TextLabel",{
Text=aY.Title or aZ.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
ZIndex=100001,
}),
ae("TextLabel",{
Text=aY.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=aY.Desc and true or false,
TextXAlignment="Left",
ZIndex=100001,
}),
}),
},true)

ab.AddSignal(a1.MouseEnter,function()
ad.Play(a1,"Hover",{ImageTransparency=0.94},nil,nil,"ServiceHover")
end)
ab.AddSignal(a1.InputEnded,function()
ad.Play(a1,"Hover",{ImageTransparency=1},nil,nil,"ServiceHover")
end)
ad.AttachPress(a1,ab,{
Amount=0.985,
})
ab.AddSignal(a1.MouseButton1Click,function()
CopyServiceLink(aX)
end)
end

ab.AddSignal(aR.MouseButton1Click,function()
if not aQ then
ad.Play(
aV,
"Expand",
{Size=UDim2.new(0,aP,0,aU.AbsoluteSize.Y+1)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"KeyService"
)
ad.Play(aT,"Expand",{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"KeyServiceChevron")
else
ad.Play(
aV,
"Expand",
{Size=UDim2.new(0,aP,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"KeyService"
)
ad.Play(aT,"Expand",{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"KeyServiceChevron")
end
aQ=not aQ
end)
end
end

local function handleSuccess(aO,aP)
SetState("Access granted",1)
an:Close()()
if aP and writefile then
pcall(function()
writefile((ai.Folder or"Temp").."/"..aj..".key",tostring(aO))
end)
end
task.wait(0.35)
ak(true)
end

local aO=false
local aP=ag("Submit","arrow-right",function()
if aO then
return
end
aO=true
SetState("Checking key",0.72)

local aP=tostring(ap or"empty")
local function Reject(aQ)
aO=false
SetState("Invalid key",0.08,true)
ai.WindUI:Notify{
Title="Key System",
Content=aQ or"Invalid key.",
Icon="triangle-alert",
Style="Error",
}
end

if ai.KeySystem.KeyValidator then
local aQ,aR,aS=pcall(ai.KeySystem.KeyValidator,aP)
if not aQ then
Reject(tostring(aR))
return
end

if aR then
handleSuccess(aP,ai.KeySystem.SaveKey)
else
Reject(aS or"Invalid key.")
end
elseif not ai.KeySystem.API then
local aQ=type(ai.KeySystem.Key)=="table"and table.find(ai.KeySystem.Key,aP)
or ai.KeySystem.Key==aP

if aQ then
handleSuccess(aP,ai.KeySystem.SaveKey)
else
Reject"Invalid key."
end
else
local aQ,aR
for aS,aT in next,ao do
local aU,aV,aW=pcall(aT.Verify,aP)
if not aU then
local aX=aV
aV=false
aW=tostring(aX)
end
if aV then
aQ,aR=true,aW
break
end
aR=aW
end

if aQ then
handleSuccess(aP,ai.KeySystem.SaveKey~=false)
else
Reject(aR or"Invalid key.")
end
end
end,"Primary",aL)

aP.AnchorPoint=Vector2.new(1,0.5)
aP.Position=UDim2.new(1,0,0.5,0)










SetState("Waiting for key",0.18)
an:Open()
ad.Play(av,"DropdownOpen",{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"KeySystemScale")
end

return aa end function a.r()

local aa={}

local ab=a.load'd'
local ad=a.load'e'
local ae=ab.New
local af=game:GetService"Workspace"

local function AsConfig(ag)
if ag==true then
return{}
end
return typeof(ag)=="table"and ag or{}
end

local function ClampProgress(ag)
return math.clamp(tonumber(ag)or 0,0,1)
end

local function CreateIcon(ag,ah,ai,aj)
local ak=
ab.Image(ag or"sparkles",ag or"sparkles",0,aj or"Temp","LoadingScreen",true,true)
ak.Size=UDim2.fromOffset(ai or 22,ai or 22)
ak.Parent=ah
return ak
end

local function GetViewportSize()
local ag=af.CurrentCamera
return ag and ag.ViewportSize or Vector2.new(1280,720)
end

function aa.new(ag,ah)
ah=AsConfig(ah)

local ai=ah.Steps or{"Theme","Motion","Interface"}
if#ai==0 then
ai={"Interface"}
end
local aj=GetViewportSize()
local ak=math.floor(math.min(ah.Width or 360,math.max(286,aj.X-28)))
local al=math.max(tonumber(ah.Height)or 188,168)
local am={
Closed=false,
Progress=ClampProgress(ah.Progress or 0.08),
UIElements={},
}

local an=ae("Frame",{
Name=ah.Name or"WindUILoadingScreen",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Active=true,
ZIndex=ah.ZIndex or 11000,
Parent=ah.Parent or ag.ScreenGui,
})

local ao=ae("Frame",{
Name="Scrim",
Size=UDim2.new(1,0,1,0),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,
ZIndex=an.ZIndex,
Parent=an,
})

local ap=ae("CanvasGroup",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
ZIndex=an.ZIndex+1,
Parent=an,
})

local aq=ab.NewRoundFrame(ah.Corner or 28,"Squircle",{
Name="Card",
Size=UDim2.fromOffset(ak,al),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=1,
ZIndex=an.ZIndex+2,
Parent=ap,
ThemeTag={
ImageColor3="Background",
},
},{
ae("UIScale",{
Name="Scale",
Scale=0.96,
}),
ab.NewRoundFrame(ah.Corner or 28,"SquircleGlass",{
Name="Glass",
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.82,
ZIndex=an.ZIndex+3,
ThemeTag={
ImageColor3="Primary",
},
}),
ab.NewRoundFrame(ah.Corner or 28,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.64,
ZIndex=an.ZIndex+4,
ThemeTag={
ImageColor3="Outline",
},
}),
})

ab.CreateUIShadow(aq,{
BlurRadius=UDim.new(0,tonumber(ah.ShadowBlur)or 24),
Color=Color3.new(0,0,0),
Offset=UDim2.fromOffset(0,8),
Spread=UDim2.fromOffset(2,2),
Transparency=ab.ClampTransparency(ah.ShadowTransparency,0.42),
ZIndex=0,
})

local ar=ae("Frame",{
Name="Body",
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ZIndex=an.ZIndex+5,
Parent=aq,
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,10),
SortOrder="LayoutOrder",
}),
})

local as=ab.NewRoundFrame(24,"Squircle",{
Name="Accent",
Size=UDim2.new(1,0,0,64),
ImageTransparency=0.82,
LayoutOrder=1,
ZIndex=an.ZIndex+5,
Parent=ar,
ThemeTag={
ImageColor3="Primary",
},
},{
ae("UIGradient",{
Name="AccentGradient",
Rotation=18,
Offset=Vector2.new(-0.25,0),
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.1),
NumberSequenceKeypoint.new(0.5,0.24),
NumberSequenceKeypoint.new(1,0.5),
},
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,14),
PaddingRight=UDim.new(0,14),
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,12),
}),
})

local at=ab.NewRoundFrame(999,"Squircle",{
Size=UDim2.fromOffset(42,42),
ImageTransparency=0.72,
ZIndex=an.ZIndex+6,
Parent=as,
ThemeTag={
ImageColor3="ElementBackground",
},
})
local au=CreateIcon(ah.Icon or"sparkles",at,21,ah.Folder)
au.AnchorPoint=Vector2.new(0.5,0.5)
au.Position=UDim2.new(0.5,0,0.5,0)

local av=ae("Frame",{
Size=UDim2.new(1,-54,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=as,
ZIndex=an.ZIndex+6,
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,3),
}),
})

ae("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ah.Title or"WindUI",
TextSize=18,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(ab.Font),
Parent=av,
ThemeTag={
TextColor3="Text",
},
})

ae("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ah.Desc or"Preparing interface",
TextSize=13,
TextTransparency=0.34,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(ab.Font),
Parent=av,
ThemeTag={
TextColor3="Text",
},
})

local aw=ae("Frame",{
Name="StatusRow",
Size=UDim2.new(1,0,0,18),
BackgroundTransparency=1,
LayoutOrder=2,
Parent=ar,
})

local ax=ae("TextLabel",{
Name="Status",
Size=UDim2.new(1,-48,1,0),
BackgroundTransparency=1,
Text=ah.Status or ai[1]or"Loading",
TextSize=13,
TextTransparency=0.18,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(ab.Font),
Parent=aw,
ThemeTag={
TextColor3="Text",
},
})

local ay=ae("TextLabel",{
Name="Percent",
Size=UDim2.new(0,44,1,0),
Position=UDim2.fromScale(1,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
Text=tostring(math.floor(am.Progress*100+0.5)).."%",
TextSize=12,
TextTransparency=0.36,
TextXAlignment="Right",
FontFace=Font.new(ab.Font),
Parent=aw,
ThemeTag={
TextColor3="Text",
},
})

local az=ab.NewRoundFrame(999,"Squircle",{
Name="ProgressTrack",
Size=UDim2.new(1,0,0,10),
ImageTransparency=0.82,
LayoutOrder=3,
ZIndex=an.ZIndex+5,
Parent=ar,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ab.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(am.Progress,0,1,0),
ImageTransparency=0.06,
ZIndex=an.ZIndex+6,
ThemeTag={
ImageColor3="Primary",
},
},{
ae("UIGradient",{
Name="FillGradient",
Rotation=0,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.05),
NumberSequenceKeypoint.new(0.5,0),
NumberSequenceKeypoint.new(1,0.18),
},
}),
}),
})

local aA=ae("Frame",{
Name="Steps",
Size=UDim2.new(1,0,0,28),
BackgroundTransparency=1,
LayoutOrder=4,
Parent=ar,
},{
ae("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
}),
})

local aB={}
for aC,aD in next,ai do
local aE=ab.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1/#ai,-6,1,0),
ImageTransparency=aC==1 and 0.84 or 0.94,
Parent=aA,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
ae("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text=tostring(aD),
TextSize=11,
TextTransparency=aC==1 and 0.08 or 0.4,
TextTruncate="AtEnd",
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="Text",
},
}),
})
table.insert(aB,aE)
end

local aC=0
local aD=1

local function UpdateStepVisuals(aE)
aD=math.clamp(tonumber(aE)or 1,1,math.max(#aB,1))
for aF,aG in next,aB do
local aH=aF<=aD
ad.Play(aG,"Switch",{ImageTransparency=aH and 0.84 or 0.94},nil,nil,"Step")
if aG.Title then
ad.Play(aG.Title,"Switch",{TextTransparency=aH and 0.08 or 0.4},nil,nil,"StepText")
end
end
end

function am.SetStatus(aE,aF)
ax.Text=tostring(aF or"")
return am
end

function am.SetProgress(aE,aF)
am.Progress=ClampProgress(aF)
ay.Text=tostring(math.floor(am.Progress*100+0.5)).."%"
ad.Play(az.Fill,"Switch",{
Size=UDim2.new(am.Progress,0,1,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"LoadingProgress")
if#aB>0 and ah.SyncSteps~=false then
UpdateStepVisuals(math.clamp(math.ceil(am.Progress*#aB),1,#aB))
end
return am
end

function am.Step(aE,aF,aG)
local aH=math.max(#aB,1)
local aI=math.clamp(tonumber(aF)or 1,1,aH)
if aG then
am:SetStatus(aG)
else
am:SetStatus(ai[aI]or ax.Text)
end
local aJ=aH==1 and 1 or(aI-1)/(aH-1)
am:SetProgress(aJ)
UpdateStepVisuals(aI)
return am
end

function am.Close(aE,aF)
if am.Closed then
return am
end
aC+=1
am.Closed=true
task.delay(tonumber(aF)or 0,function()
ad.Play(ap,"DropdownClose",{GroupTransparency=1},nil,nil,"LoadingContent")
ad.Play(ao,"DropdownClose",{BackgroundTransparency=1},nil,nil,"LoadingScrim")
ad.Play(aq,"DropdownClose",{ImageTransparency=1},nil,nil,"LoadingCard")
ad.Play(aq.Scale,"DropdownClose",{Scale=0.96},nil,nil,"LoadingScale")
task.wait(ad.GetDuration"DropdownClose"+0.03)
if an then
an:Destroy()
end
end)
return am
end

function am.Open(aE)
aC+=1
am.Closed=false
an.Visible=true
ao.BackgroundTransparency=1
ap.GroupTransparency=1
aq.ImageTransparency=1
aq.Scale.Scale=0.96
ad.Play(ao,"DropdownOpen",{
BackgroundTransparency=ah.ScrimTransparency or 0.2,
},nil,nil,"LoadingScrim")
ad.Play(ap,"DropdownOpen",{GroupTransparency=0},nil,nil,"LoadingContent")
ad.Play(
aq,
"DropdownOpen",
{ImageTransparency=ah.CardTransparency or 0.16},
nil,
nil,
"LoadingCard"
)
ad.Play(aq.Scale,"DropdownOpen",{Scale=1},nil,nil,"LoadingScale")
return am
end

function am.Play(aE,aF)
local aG=math.max(tonumber(aF)or tonumber(ah.Duration)or 1.2,0.05)
aC+=1
local aH=aC
local aI=os.clock()
local aJ=0

task.spawn(function()
while aH==aC and not am.Closed and an.Parent do
local aK=math.clamp((os.clock()-aI)/aG,0,1)
local aL=math.clamp(math.floor(aK*#ai)+1,1,math.max(#ai,1))

if aL~=aJ then
aJ=aL
if ah.AutoStatus~=false and ai[aL]then
am:SetStatus(ai[aL])
end
end

am:SetProgress(aK)
if aK>=1 then
break
end
task.wait(0.05)
end

if aH~=aC or am.Closed or not an.Parent then
return
end

am:SetStatus(ah.CompleteStatus or"Ready")
am:SetProgress(1)
am:Close(ah.CloseDelay or 0.18)
end)
return am
end

am.UIElements.Root=an
am.UIElements.Scrim=ao
am.UIElements.Content=ap
am.UIElements.Card=aq
am.UIElements.Body=ar
am.UIElements.Status=ax
am.UIElements.Percent=ay
am.UIElements.ProgressFill=az.Fill

am:Open()

if ad:IsEnabled()and not ad.Reduced then
task.spawn(function()
local aE=1
while not am.Closed and as and as.Parent do
local aF=as:FindFirstChild"AccentGradient"
local aG=az.Fill and az.Fill:FindFirstChild"FillGradient"
if aF then
ad.Play(
aF,
"Background",
{Offset=Vector2.new(aE*0.28,0)},
Enum.EasingStyle.Sine,
Enum.EasingDirection.InOut,
"LoadingSheen"
)
end
if aG then
ad.Play(
aG,
"Background",
{Offset=Vector2.new(aE*0.38,0)},
Enum.EasingStyle.Sine,
Enum.EasingDirection.InOut,
"LoadingFillSheen"
)
end
aE*=-1
task.wait(ad.GetDuration"Background"+0.18)
end
end)
end

if ah.Duration or ah.AutoClose then
am:Play(tonumber(ah.Duration)or 1.2)
end

return am
end

return aa end function a.s()




local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ad,ae,af,ag)
return(ab-ad)*(ag-af)/(ae-ad)+af
end

local function viewportPointToWorld(ab,ad)
local ae=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ae.Origin+ae.Direction*ad
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.t()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.load'd'
local ad=ab.New


local ae,af=unpack(a.load's')
local ag=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ah=ad("Part",{
Name="Body",
Color=Color3.new(0,0,0),
Material=Enum.Material.Glass,
Size=Vector3.new(1,1,0),
Anchored=true,
CanCollide=false,
Locked=true,
CastShadow=false,
Transparency=0.98,
},{
ad("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ah
end


local function createAcrylicBlur(ah)
local ai={}

ah=ah or 0.001
local aj={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local ak=createAcrylic()
ak.Parent=ag

local function updatePositions(al,am)
aj.topLeft=am
aj.topRight=am+Vector2.new(al.X,0)
aj.bottomRight=am+al
end

local function render()
local al=aa(game:GetService"Workspace").CurrentCamera
if al then
al=al.CFrame
end
local am=al
if not am then
am=CFrame.new()
end

local an=am
local ao=aj.topLeft
local ap=aj.topRight
local aq=aj.bottomRight

local ar=ae(ao,ah)
local as=ae(ap,ah)
local at=ae(aq,ah)

local au=(as-ar).Magnitude
local av=(as-at).Magnitude

ak.CFrame=
CFrame.fromMatrix((ar+at)/2,an.XVector,an.YVector,an.ZVector)
ak.Mesh.Scale=Vector3.new(au,av,0)
end

local function onChange(al)
local am=af()
local an=al.AbsoluteSize-Vector2.new(am,am)
local ao=al.AbsolutePosition+Vector2.new(am/2,am/2)

updatePositions(an,ao)
task.spawn(render)
end

local function renderOnChange()
local al=aa(game:GetService"Workspace").CurrentCamera
if not al then
return
end

table.insert(ai,al:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ai,al:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ai,al:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

ak.Destroying:Connect(function()
for al,am in ai do
pcall(function()
am:Disconnect()
end)
end
end)

renderOnChange()

return onChange,ak
end

return function(ah)
local ai={}
local aj,ak=createAcrylicBlur(ah)

local al=ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(al:GetPropertyChangedSignal"AbsolutePosition",function()
aj(al)
end)

ab.AddSignal(al:GetPropertyChangedSignal"AbsoluteSize",function()
aj(al)
end)

ai.AddParent=function(am)
ab.AddSignal(am:GetPropertyChangedSignal"Visible",function()

end)
end

ai.SetVisibility=function(am)
ak.Transparency=am and 0.98 or 1
end

ai.Frame=al
ai.Model=ak

return ai
end end function a.u()


local aa=a.load'd'
local ab=a.load't'

local ad=aa.New

return function(ae)
local af={}

af.Frame=ad("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ad("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ad("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ad("ImageLabel",{
Image="rbxassetid://9968344227",
ImageTransparency=0.9,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ThemeTag={
ImageTransparency="AcrylicNoise",
},
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local ag

task.wait()
if ae.UseAcrylic then
ag=ab()

ag.Frame.Parent=af.Frame
af.Model=ag.Model
af.AddParent=ag.AddParent
af.SetVisibility=ag.SetVisibility
end

return af,ag
end end function a.v()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.load't',

AcrylicPaint=a.load'u',
}

function ab.init()
local ad=Instance.new"DepthOfFieldEffect"
ad.FarIntensity=0
ad.InFocusRadius=0.1
ad.NearIntensity=1

local ae={}

function ab.Enable()
for af,ag in pairs(ae)do
ag.Enabled=false
end
ad.Parent=aa(game:GetService"Lighting")
end

function ab.Disable()
for af,ag in pairs(ae)do
ag.Enabled=ag.enabled
end
ad.Parent=nil
end

local function registerDefaults()
local function register(af)
if af:IsA"DepthOfFieldEffect"then
ae[af]={enabled=af.Enabled}
end
end

for af,ag in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(ag)
end

if aa(game:GetService"Workspace").CurrentCamera then
for af,ag in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(ag)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.w()

local aa={}

local ab=a.load'd'
local ad=ab.New local ae=
ab.Tween


function aa.new(af,ag)
local ah={
Title=af.Title or"Dialog",
Content=af.Content,
Icon=af.Icon,
IconThemed=af.IconThemed,
Thumbnail=af.Thumbnail,
Buttons=af.Buttons,

IconSize=22,
}

local ai=a.load'p'
local aj=ai.Create(true,"Popup",af.WindUI.Window,af.WindUI,ag)

local ak=200

local al=430
if ah.Thumbnail and ah.Thumbnail.Image then
al=430+(ak/2)
end

aj.UIElements.Main.AutomaticSize="Y"
aj.UIElements.Main.Size=UDim2.new(0,al,0,0)



local am

if ah.Icon then
am=ab.Image(
ah.Icon,
ah.Title..":"..ah.Icon,
0,
af.WindUI.Window,
"Popup",
true,
af.IconThemed,
"PopupIcon"
)
am.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
am.LayoutOrder=-1
end


local an=ad("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ah.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,am and-ah.IconSize-14 or 0,0,0)
})

local ao=ad("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ad("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
am,an
})

local ap=ad("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





ao,
})

local aq
if ah.Content and ah.Content~=""then
aq=ad("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font),
TextXAlignment="Left",
Text=ah.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="PopupContent",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ar=ad("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local as
if ah.Thumbnail and ah.Thumbnail.Image then
local at
if ah.Thumbnail.Title then
at=ad("TextLabel",{
Text=ah.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
as=ad("ImageLabel",{
Image=ah.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ak,1,0),
Parent=aj.UIElements.Main,
ScaleType="Crop"
},{
at,
ad("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ad("Frame",{

Size=UDim2.new(1,as and-ak or 0,1,0),
Position=UDim2.new(0,as and ak or 0,0,0),
BackgroundTransparency=1,
Parent=aj.UIElements.Main
},{
ad("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
ap,
aq,
ar,
ad("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local at=a.load'n'.New

for au,av in next,ah.Buttons do
at(av.Title,av.Icon,av.Callback,av.Variant,ar,aj)
end

aj:Open()


return ah
end

return aa end function a.x()
return function(aa,ab)
return{
Dark={
Name="Dark",

Accent=Color3.fromHex"#18181b",
Dialog=Color3.fromHex"#1a1a1a",
Outline=Color3.fromHex"#FFFFFF",
Text=Color3.fromHex"#FFFFFF",
Placeholder=Color3.fromHex"#a1a1a1",
Background=Color3.fromHex"#101010",
Button=Color3.fromHex"#52525b",
Icon=Color3.fromHex"#a1a1aa",
Toggle=Color3.fromHex"#33C759",
Slider=Color3.fromHex"#0091FF",
Checkbox=Color3.fromHex"#0091FF",

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,

SliderIcon=Color3.fromHex"#908F95",
Primary=Color3.fromHex"#0091FF",


LabelBackground=Color3.fromHex"#000000",
LabelBackgroundTransparency=0.83,

ElementBackground=Color3.fromHex"#2A2A2C",
ElementBackgroundTransparency=0,
},

Light={
Name="Light",

Accent=Color3.fromHex"#efefef",
Dialog=Color3.fromHex"#f4f4f5",
Outline=Color3.fromHex"#ffffff",
Text=Color3.fromHex"#000000",
Placeholder=Color3.fromHex"#555555",
Background=Color3.fromHex"#FFFFFF",
Button=Color3.fromHex"#18181b",
Icon=Color3.fromHex"#52525b",
Toggle=Color3.fromHex"#33C759",
Slider=Color3.fromHex"#0091FF",
Checkbox=Color3.fromHex"#0091FF",

DropdownTabBackground=Color3.fromHex"#bebebe",
DropdownBackground=Color3.fromHex"#ffffff",

TabBackground=Color3.fromHex"#ffffff",
TabBackgroundHover=Color3.fromHex"#f3f3f3",
TabBackgroundHoverTransparency=0,
TabBackgroundActive=Color3.fromHex"#efefef",
TabBackgroundActiveTransparency=0,

PanelBackground=Color3.fromHex"#efefef",
PanelBackgroundTransparency=0,

LabelBackground=Color3.fromHex"#efefef",
LabelBackgroundTransparency=0,

ElementBackground=Color3.fromHex"#ffffff",
ElementBackgroundTransparency=0,
},

Rose={
Name="Rose",

Accent=Color3.fromHex"#be185d",
Dialog=Color3.fromHex"#4c0519",

Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#d67aa6",
Background=Color3.fromHex"#1f0308",
Button=Color3.fromHex"#e95f74",
Icon=Color3.fromHex"#fb7185",

ElementBackground=Color3.fromHex"#381E23",
ElementBackgroundTransparency=0,
},

Plant={
Name="Plant",

Accent=Color3.fromHex"#166534",
Dialog=Color3.fromHex"#052e16",

Text=Color3.fromHex"#f0fdf4",
Placeholder=Color3.fromHex"#4fbf7a",
Background=Color3.fromHex"#0a1b0f",
Button=Color3.fromHex"#16a34a",
Icon=Color3.fromHex"#4ade80",

ElementBackground=Color3.fromHex"#28342A",
ElementBackgroundTransparency=0,
},

Red={
Name="Red",

Accent=Color3.fromHex"#991b1b",
Dialog=Color3.fromHex"#450a0a",

Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#d95353",
Background=Color3.fromHex"#1c0606",
Button=Color3.fromHex"#dc2626",
Icon=Color3.fromHex"#ef4444",

ElementBackground=Color3.fromHex"#322221",
ElementBackgroundTransparency=0,
},

Indigo={
Name="Indigo",

Accent=Color3.fromHex"#3730a3",
Dialog=Color3.fromHex"#1e1b4b",

Text=Color3.fromHex"#f1f5f9",
Placeholder=Color3.fromHex"#7078d9",
Background=Color3.fromHex"#0f0a2e",
Button=Color3.fromHex"#4f46e5",
Icon=Color3.fromHex"#6366f1",

ElementBackground=Color3.fromHex"#282543",
ElementBackgroundTransparency=0,
},

Sky={
Name="Sky",

Accent=Color3.fromHex"#00d4ff",
Dialog=Color3.fromHex"#0a4d66",

Text=Color3.fromHex"#e6f7ff",
Placeholder=Color3.fromHex"#66b3cc",
Background=Color3.fromHex"#051a26",
Button=Color3.fromHex"#00a8cc",
Icon=Color3.fromHex"#2db8d9",

Toggle=Color3.fromHex"#00d9d9",
Slider=Color3.fromHex"#00d4ff",
Checkbox=Color3.fromHex"#00d4ff",

PanelBackground=Color3.fromHex"#0d3a47",
PanelBackgroundTransparency=0.8,

ElementBackground=Color3.fromHex"#172E3B",
ElementBackgroundTransparency=0,
},

Violet={
Name="Violet",

Accent=Color3.fromHex"#6d28d9",
Dialog=Color3.fromHex"#3c1361",

Text=Color3.fromHex"#faf5ff",
Placeholder=Color3.fromHex"#8f7ee0",
Background=Color3.fromHex"#1e0a3e",
Button=Color3.fromHex"#7c3aed",
Icon=Color3.fromHex"#8b5cf6",

ElementBackground=Color3.fromHex"#342650",
ElementBackgroundTransparency=0,
},

Amber={
Name="Amber",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#b45309",Transparency=0},
["100"]={Color=Color3.fromHex"#d97706",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#451a03",Transparency=0},
["100"]={Color=Color3.fromHex"#6b2e05",Transparency=0},
},{Rotation=90}),






Text=aa:Gradient({
["0"]={Color=Color3.fromHex"#fffbeb",Transparency=0},
["100"]={Color=Color3.fromHex"#fff7ed",Transparency=0},
},{Rotation=45}),

Placeholder=aa:Gradient({
["0"]={Color=Color3.fromHex"#d1a326",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#1c1003",Transparency=0},
["100"]={Color=Color3.fromHex"#3f210d",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Icon=Color3.fromHex"#f59e0b",

Toggle=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Slider=Color3.fromHex"#d97706",

Checkbox=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,

ElementBackground=Color3.fromHex"#3A2E22",
ElementBackgroundTransparency=0,
},

Emerald={
Name="Emerald",

Accent=Color3.fromHex"#047857",
Dialog=Color3.fromHex"#022c22",

Text=Color3.fromHex"#ecfdf5",
Placeholder=Color3.fromHex"#3fbf8f",
Background=Color3.fromHex"#011411",
Button=Color3.fromHex"#059669",
Icon=Color3.fromHex"#10b981",

ElementBackground=Color3.fromHex"#202E2A",
ElementBackgroundTransparency=0,
},

Midnight={
Name="Midnight",

Accent=Color3.fromHex"#1e3a8a",
Dialog=Color3.fromHex"#0c1e42",

Text=Color3.fromHex"#dbeafe",
Placeholder=Color3.fromHex"#2f74d1",
Background=Color3.fromHex"#0a0f1e",
Button=Color3.fromHex"#2563eb",
Primary=Color3.fromHex"#2563eb",
Icon=Color3.fromHex"#5591f4",

ElementBackground=Color3.fromHex"#242836",
ElementBackgroundTransparency=0,
},

Crimson={
Name="Crimson",

Accent=Color3.fromHex"#b91c1c",
Dialog=Color3.fromHex"#450a0a",

Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#6f757b",
Background=Color3.fromHex"#0c0404",
Button=Color3.fromHex"#991b1b",
Icon=Color3.fromHex"#dc2626",

ElementBackground=Color3.fromHex"#251F1F",
ElementBackgroundTransparency=0,
},

MonokaiPro={
Name="Monokai Pro",

Accent=Color3.fromHex"#fc9867",
Dialog=Color3.fromHex"#1e1e1e",

Text=Color3.fromHex"#fcfcfa",
Placeholder=Color3.fromHex"#afafaf",
Background=Color3.fromHex"#191622",
Button=Color3.fromHex"#ab9df2",
Icon=Color3.fromHex"#a9dc76",

ElementBackground=Color3.fromHex"#323039",
ElementBackgroundTransparency=0,

Metadata={
PullRequest=23,
},
},

CottonCandy={
Name="Cotton Candy",

Accent=Color3.fromHex"#ec4899",
Dialog=Color3.fromHex"#2d1b3d",

Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#8a5fd3",
Background=Color3.fromHex"#1a0b2e",
Button=Color3.fromHex"#d946ef",
Slider=Color3.fromHex"#d946ef",
Icon=Color3.fromHex"#06b6d4",

ElementBackground=Color3.fromHex"#312643",
ElementBackgroundTransparency=0,
},

Mellowsi={
Name="Mellowsi",

Accent=Color3.fromHex"#342A1E",
Dialog=Color3.fromHex"#291C13",

Text=Color3.fromHex"#F5EBDD",
Placeholder=Color3.fromHex"#9C8A73",
Background=Color3.fromHex"#1C1002",
Button=Color3.fromHex"#342A1E",
Icon=Color3.fromHex"#C9B79C",

Toggle=Color3.fromHex"#a9873f",
Slider=Color3.fromHex"#C9A24D",
Checkbox=Color3.fromHex"#C9A24D",

ElementBackground=Color3.fromHex"#33291E",
ElementBackgroundTransparency=0,

Metadata={
PullRequest=52,
},
},

Rainbow={
Name="Rainbow",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00ff41",Transparency=0},
["33"]={Color=Color3.fromHex"#00ffff",Transparency=0},
["66"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["100"]={Color=Color3.fromHex"#8000ff",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#8000ff",Transparency=0},
["50"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["75"]={Color=Color3.fromHex"#00ff80",Transparency=0},
["100"]={Color=Color3.fromHex"#ff8000",Transparency=0},
},{Rotation=135}),


Text=Color3.fromHex"#ffffff",
Placeholder=Color3.fromHex"#00ff80",

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0040",Transparency=0},
["20"]={Color=Color3.fromHex"#ff4000",Transparency=0},
["40"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["60"]={Color=Color3.fromHex"#00ff40",Transparency=0},
["80"]={Color=Color3.fromHex"#0040ff",Transparency=0},
["100"]={Color=Color3.fromHex"#4000ff",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#ff8000",Transparency=0},
["50"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["75"]={Color=Color3.fromHex"#80ff00",Transparency=0},
["100"]={Color=Color3.fromHex"#00ffff",Transparency=0},
},{Rotation=60}),

Icon=Color3.fromHex"#ffffff",
},
}
end end function a.y()

local aa={}

local ab=a.load'd'
local ad=ab.New local ae=
ab.Tween

function aa.New(af,ag,ah,ai,aj,ak)
local al=aj or 10
local am
if ag and ag~=""then
am=ad("ImageLabel",{
Image=ab.Icon(ag)[1],
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
})
end

local an=ad("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font),
Size=UDim2.new(1,am and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ai and"Placeholder"or"Text",
},
Text=af,
})

local ao=ad("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ah,
BackgroundTransparency=1,
Text="",
},{
ad("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(al,"Squircle",{
ThemeTag={
ImageColor3="Placeholder",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.85,
}),
not ak and ab.NewRoundFrame(al,"SquircleGlass",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,1,1,1),
ImageTransparency=0.9,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})or nil,
ab.NewRoundFrame(al,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ad("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
am,
an,
}),
}),
})

return ao
end

return aa end function a.z()

local aa={}

local ab=cloneref or clonereference or function(ab)
return ab
end
local ad=ab(game:GetService"UserInputService")

local ae=a.load'd'
local af=ae.New

function aa.New(ag,ah,ai,aj,ak)
local al=af("Frame",{
Size=UDim2.new(0,aj,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ah,
ZIndex=999,
Active=true,
})

local am=ae.NewRoundFrame(aj/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=al,
})

local an=af("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=am,
})

local ao=ae:GenerateUniqueID()
local ap=false
local aq,ar

local function UpdateVisuals()
local as=ag.AbsoluteCanvasSize.Y
local at=ag.AbsoluteWindowSize.Y

if as<=at then
am.Visible=false
return
end

am.Visible=true

local au=math.clamp(at/as,0.05,1)
am.Size=UDim2.new(1,0,au,0)

local av=as-at
local aw=1-au

if av>0 then
local ax=ag.CanvasPosition.Y/av
am.Position=UDim2.new(0,0,math.clamp(ax*aw,0,aw),0)
else
am.Position=UDim2.new(0,0,0,0)
end
end

local function StopDrag()
if ak.CurrentInput==ao then
ak.CurrentInput=nil
end
ap=false
ag.ScrollingEnabled=true
if aq then
aq:Disconnect()
end
if ar then
ar:Disconnect()
end
end

ae.AddSignal(an.InputBegan,function(as)
if
as.UserInputType~=Enum.UserInputType.MouseButton1
and as.UserInputType~=Enum.UserInputType.Touch
then
return
end
if ap then
return
end
if ak.CurrentInput and ak.CurrentInput~=ao then
return
end

ak.CurrentInput=ao

ap=true
ag.ScrollingEnabled=false

local at=as.Position.Y
local au=ag.CanvasPosition.Y

aq=ad.InputChanged:Connect(function(av)
if
av.UserInputType==Enum.UserInputType.MouseMovement
or av.UserInputType==Enum.UserInputType.Touch
then
local aw=av.Position.Y-at

local ax=ag.AbsoluteCanvasSize.Y
local ay=ag.AbsoluteWindowSize.Y
local az=math.max(ax-ay,0)

local aA=al.AbsoluteSize.Y
local aB=am.AbsoluteSize.Y
local aC=math.max(aA-aB,1)

local aD=aw*(az/aC)

ag.CanvasPosition=
Vector2.new(ag.CanvasPosition.X,math.clamp(au+aD,0,az))
end
end)

ar=ad.InputEnded:Connect(function(av)
if av.UserInputType==as.UserInputType then
if ak.CurrentInput and ak.CurrentInput~=ao then
return
end

ak.CurrentInput=nil

StopDrag()
end
end)
end)

ae.AddSignal(ag:GetPropertyChangedSignal"AbsoluteWindowSize",UpdateVisuals)
ae.AddSignal(ag:GetPropertyChangedSignal"AbsoluteCanvasSize",UpdateVisuals)
ae.AddSignal(ag:GetPropertyChangedSignal"CanvasPosition",UpdateVisuals)

UpdateVisuals()

return al
end

return aa end function a.A()

local aa={}

local ab=a.load'd'
local ad=ab.New
local ae=ab.Tween

function aa.New(af,ag,ah)
local ai={
Title=ag.Title or"Tag",
Icon=ag.Icon,
Color=ag.Color or Color3.fromHex"#315dff",
Radius=ag.Radius or 999,
Border=ag.Border or false,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local aj
if ai.Icon then
aj=ab.Image(ai.Icon,ai.Icon,0,ag.Window,"Tag",false)

aj.Size=UDim2.new(0,ai.IconSize,0,ai.IconSize)
aj.ImageLabel.ImageColor3=typeof(ai.Color)=="Color3"
and ab.GetTextColorForHSB(ai.Color)
or typeof(ai.Color)=="string"
and(ab.GetTextColorForHSB(ab.GetThemeProperty(ai.Color,ab.Theme)))
end

local ak=ad("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ai.TextSize,
FontFace=Font.new(ab.Font),
Text=ai.Title,
TextColor3=typeof(ai.Color)=="Color3"and ab.GetTextColorForHSB(ai.Color)or typeof(
ai.Color
)=="string"and(ab.GetTextColorForHSB(ab.GetThemeProperty(ai.Color,ab.Theme))),
})

local al

if typeof(ai.Color)=="table"then
al=ad"UIGradient"
for am,an in next,ai.Color do
al[am]=an
end

ak.TextColor3=ab.GetTextColorForHSB(ab.GetAverageColor(al))
if aj then
aj.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(al))
end
end

local am=ab.NewRoundFrame(ai.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ai.Height),
Parent=ah,
ImageColor3=typeof(ai.Color)=="Color3"and ai.Color
or typeof(ai.Color)=="table"and Color3.new(1,1,1)
or nil,
ThemeTag=typeof(ai.Color)=="string"and{
ImageColor3=ai.Color,
},
},{
al,
ab.NewRoundFrame(ai.Radius+1,"SquircleGlass",{
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0.75,
}),
ad("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Name="Content",
BackgroundTransparency=1,
},{
aj,
ak,
ad("UIPadding",{
PaddingLeft=UDim.new(0,ai.Padding),
PaddingRight=UDim.new(0,ai.Padding),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ai.Padding/1.5),
}),
}),
})

function ai.SetTitle(an,ao)
ai.Title=ao
ak.Text=ao

return ai
end

function ai.SetColor(an,ao)
ai.Color=ao
if typeof(ao)=="table"then
local ap=ab.GetAverageColor(ao)
ae(ak,0.06,{TextColor3=ab.GetTextColorForHSB(ap)}):Play()
local aq=am:FindFirstChildOfClass"UIGradient"or ad("UIGradient",{Parent=am})
for ar,as in next,ao do
aq[ar]=as
end
ae(am,0.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if al then
al:Destroy()
end
ae(ak,0.06,{TextColor3=ab.GetTextColorForHSB(ao)}):Play()
if aj then
ae(aj.ImageLabel,0.06,{ImageColor3=ab.GetTextColorForHSB(ao)}):Play()
end
ae(am,0.06,{ImageColor3=ao}):Play()
end

return ai
end

function ai.SetIcon(an,ao)
ai.Icon=ao

if ao then
aj=ab.Image(ao,ao,0,ag.Window,"Tag",false)

aj.Size=UDim2.new(0,ai.IconSize,0,ai.IconSize)
aj.Parent=am

if typeof(ai.Color)=="Color3"then
aj.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ai.Color)
elseif typeof(ai.Color)=="table"then
aj.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(al))
end
else
if aj then
aj:Destroy()
aj=nil
end
end
return ai
end

function ai.Destroy(an)
am:Destroy()
return ai
end

ab:OnThemeChange(function(an,ao)
ak.TextColor3=ab.GetTextColorForHSB(ab.GetThemeProperty(ai.Color,ab.Theme))
aj.ImageLabel.ImageColor3=
ab.GetTextColorForHSB(ab.GetThemeProperty(ai.Color,ab.Theme))
end)

return ai
end

return aa end function a.B()

local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"RunService")
local ad=aa(game:GetService"HttpService")

local ae

local af
af={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Default:ToHex(),
transparency=ag.Transparency or nil,
}
end,
Load=function(ag,ah)
if ag and ag.Update then
ag:Update(Color3.fromHex(ah.value),ah.transparency or nil)
end
end
},
Dropdown={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Value,
}
end,
Load=function(ag,ah)
if ag and ag.Select then
ag:Select(ah.value)
end
end
},
Input={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Value,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(ah.value)
end
end
},
Keybind={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Value,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(ah.value)
end
end
},
RadioGroup={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Get and ag:Get()or ag.Value,
}
end,
Load=function(ag,ah)
if ag and ag.Select then
ag:Select(ah.value,false)
end
end
},
CheckboxGroup={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Get and ag:Get()or ag.Values,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(ah.value or{},false)
end
end
},
SegmentedControl={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Get and ag:Get()or ag.Value,
}
end,
Load=function(ag,ah)
if ag and ag.Select then
ag:Select(ah.value,false)
end
end
},
TextArea={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Get and ag:Get()or ag.Value,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(ah.value or"",false)
end
end
},
Slider={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Value.Default,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(tonumber(ah.value))
end
end
},
Stepper={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Get and ag:Get()or ag.Value.Default,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(tonumber(ah.value),false)
end
end
},
TabBox={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Get and ag:Get()or ag.SelectedValue,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(ah.value)
end
end
},
ChipList={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Get and ag:Get()or ag.Values,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(ah.value,false)
end
end
},
Toggle={
Save=function(ag)
return{
__type=ag.__type,
value=ag.Value,
}
end,
Load=function(ag,ah)
if ag and ag.Set then
ag:Set(ah.value)
end
end
},
}
}

function af.Init(ag,ah)
if not ah.Folder then
warn"[ WindUI.ConfigManager ] Window.Folder is not specified."
return false
end
if ab:IsStudio()or not writefile then
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return false
end

ae=ah
af.Folder=ae.Folder
af.Path="WindUI/"..tostring(af.Folder).."/config/"

if not isfolder(af.Path)then
makefolder(af.Path)
end

local ai=af:AllConfigs()

for aj,ak in next,ai do
local al=af.Path..tostring(ak)..".json"
if isfile and readfile and isfile(al)then
local am,an=pcall(function()
return readfile(al)
end)
if am then
af.Configs[ak]=an
end
end
end

return af
end

function af.SetPath(ag,ah)
if not ah then
warn"[ WindUI.ConfigManager ] Custom path is not specified."
return false
end

af.Path=ah
if not ah:match"/$"then
af.Path=ah.."/"
end

if not isfolder(af.Path)then
makefolder(af.Path)
end

return true
end

function af.CreateConfig(ag,ah,ai)
local aj={
Path=af.Path..ah..".json",
Elements={},
CustomData={},
AutoLoad=ai or false,
Version=1.2,
}

if not ah then
return false,"No config file is selected"
end

function aj.SetAsCurrent(ak)
ae:SetCurrentConfig(aj)
end

function aj.Register(ak,al,am)
aj.Elements[al]=am
end

function aj.Set(ak,al,am)
aj.CustomData[al]=am
end

function aj.Get(ak,al)
return aj.CustomData[al]
end

function aj.SetAutoLoad(ak,al)
aj.AutoLoad=al
end

function aj.Save(ak)
if ae.PendingFlags then
for al,am in next,ae.PendingFlags do
aj:Register(al,am)
end
end

local al={
__version=aj.Version,
__elements={},
__autoload=aj.AutoLoad,
__custom=aj.CustomData
}

for am,an in next,aj.Elements do
if af.Parser[an.__type]then
al.__elements[tostring(am)]=af.Parser[an.__type].Save(an)
end
end

local am=ad:JSONEncode(al)
if writefile then
local an,ao=pcall(function()
writefile(aj.Path,am)
end)
if not an then
return false,"Failed to save config: "..tostring(ao)
end
else
return false,"writefile function is not available"
end

return al
end

function aj.Load(ak)
if isfile and not isfile(aj.Path)then
return false,"Config file does not exist"
end

local al,am=pcall(function()
local al=readfile or function()
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ad:JSONDecode(al(aj.Path))
end)

if not al then
return false,"Failed to parse config file"
end

if not am.__version then
local an={
__version=aj.Version,
__elements=am,
__custom={}
}
am=an
end

if ae.PendingFlags then
for an,ao in next,ae.PendingFlags do
aj:Register(an,ao)
end
end

ae.PendingConfigData=am.__elements or{}

for an,ao in next,(am.__elements or{})do
if typeof(ao)=="table"and aj.Elements[an]and af.Parser[ao.__type]then
task.spawn(function()
local ap,aq=pcall(function()
af.Parser[ao.__type].Load(aj.Elements[an],ao)
end)
if not ap then
warn("[ WindUI.ConfigManager ] Failed to load element '"..tostring(an).."': "..tostring(aq))
end
end)
end
end

aj.CustomData=am.__custom or{}

return aj.CustomData
end

function aj.Delete(ak)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(aj.Path)then
return false,"Config file does not exist"
end

local al,am=pcall(function()
delfile(aj.Path)
end)

if not al then
return false,"Failed to delete config file: "..tostring(am)
end

af.Configs[ah]=nil

if ae.CurrentConfig==aj then
ae.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function aj.GetData(ak)
return{
elements=aj.Elements,
custom=aj.CustomData,
autoload=aj.AutoLoad
}
end


if isfile(aj.Path)then
local ak,al=pcall(function()
return ad:JSONDecode(readfile(aj.Path))
end)

if ak and al and al.__autoload then
aj.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local am,an=pcall(function()
return aj:Load()
end)
if am then
if ae.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: "..ah)end
else
warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: "..ah.." - "..tostring(an))
end
end)
end
end


aj:SetAsCurrent()
af.Configs[ah]=aj
return aj
end

function af.Config(ag,ah,ai)
return af:CreateConfig(ah,ai)
end

function af.GetAutoLoadConfigs(ag)
local ah={}

for ai,aj in pairs(af.Configs)do
if aj.AutoLoad then
table.insert(ah,ai)
end
end

return ah
end

function af.DeleteConfig(ag,ah)
if not delfile then
return false,"delfile function is not available"
end

local ai=af.Path..ah..".json"

if not isfile(ai)then
return false,"Config file does not exist"
end

local aj,ak=pcall(function()
delfile(ai)
end)

if not aj then
return false,"Failed to delete config file: "..tostring(ak)
end

af.Configs[ah]=nil

if ae.CurrentConfig and ae.CurrentConfig.Path==ai then
ae.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function af.AllConfigs(ag)
if not listfiles then return{}end

local ah={}
if not isfolder(af.Path)then
makefolder(af.Path)
return ah
end

for ai,aj in next,listfiles(af.Path)do
local ak=aj:match"([^\\/]+)%.json$"
if ak then
table.insert(ah,ak)
end
end

return ah
end

function af.GetConfig(ag,ah)
return af.Configs[ah]
end

return af end function a.C()

local aa={}

local ab=a.load'd'
local ad=ab.New
local ae=ab.Tween

local af=(cloneref or clonereference or function(af)
return af
end)

local ag=af(game:GetService"TextService")

local ah={
TopCenter={
Position=UDim2.new(0.5,0,0,8),
AnchorPoint=Vector2.new(0.5,0),
},
TopLeft={
Position=UDim2.new(0,14,0,8),
AnchorPoint=Vector2.new(0,0),
},
TopRight={
Position=UDim2.new(1,-14,0,8),
AnchorPoint=Vector2.new(1,0),
},
BottomCenter={
Position=UDim2.new(0.5,0,1,-14),
AnchorPoint=Vector2.new(0.5,1),
},
BottomLeft={
Position=UDim2.new(0,14,1,-14),
AnchorPoint=Vector2.new(0,1),
},
BottomRight={
Position=UDim2.new(1,-14,1,-14),
AnchorPoint=Vector2.new(1,1),
},
}

local ai={
hidden="Idle",
hide="Idle",
idle="Idle",
island="Idle",
closed="Collapsed",
circle="Collapsed",
icon="Collapsed",
mini="Collapsed",
collapsed="Collapsed",
compact="Compact",
default="Compact",
pill="Compact",
open="Expanded",
expanded="Expanded",
dynamic="Expanded",
}

local function Pick(aj,ak)
if aj~=nil then
return aj
end
return ak
end

local function NormalizeState(aj)
return ai[tostring(aj or"Compact"):lower()]or"Compact"
end

local function NormalizeColorSequence(aj,ak)
if typeof(aj)=="ColorSequence"then
return aj
end
if typeof(aj)=="Color3"then
return ColorSequence.new(aj)
end
return ak
end

local function GetInnerCornerRadius(aj,ak)
if typeof(aj)~="UDim"then
return UDim.new(1,0)
end
if aj.Scale~=0 then
return UDim.new(aj.Scale,math.max(aj.Offset,0))
end
return UDim.new(0,math.max(aj.Offset-ak,0))
end

local function MeasureText(aj,ak,al)
local am=
ag:GetTextSize(tostring(aj or""),ak,Enum.Font.GothamMedium,Vector2.new(al,1000))
return math.ceil(am.X),math.ceil(am.Y)
end

function aa.New(aj)
local ak=ColorSequence.new(Color3.fromHex"#40C9FF",Color3.fromHex"#E81CFF")
local al={
Title=aj.Title or"Open",
Content=nil,
Icon=aj.Icon,
Enabled=true,
Visible=false,
OnlyMobile=true,
Draggable=true,
Position="TopCenter",
State="Compact",
Height=44,
IdleWidth=78,
IdleHeight=28,
ExpandedHeight=68,
ExpandedWidth=220,
MaxWidth=380,
IconSize=22,
Padding=12,
Gap=9,
Scale=1,
CornerRadius=UDim.new(1,0),
StrokeThickness=1,
StrokeTransparency=0.7,
Color=ak,
BackgroundColor=Color3.fromRGB(7,8,11),
BackgroundTransparency=0.08,
TextColor=nil,
TextTransparency=nil,
AutoCollapse=nil,
AutoHide=4,
WakeOnShow=true,
Shadow=true,
ShadowBlur=UDim.new(0,18),
ShadowColor=Color3.new(0,0,0),
ShadowOffset=UDim2.fromOffset(0,5),
ShadowSpread=UDim2.fromOffset(2,2),
ShadowTransparency=0.5,
FallbackShadow=false,
MorphWindow=true,
MorphDuration=0.42,
OnStateChange=nil,
}

local am={
Button=nil,
Container=nil,
IconSize=al.IconSize,
Scale=al.Scale,
State=al.State,
Config=al,
UIElements={},
}

local an=0
local ao=0
local ap={}
local aq
local ar

local as=ad("Frame",{
Name="OpenButtonContainer",
Size=UDim2.fromOffset(al.Height,al.Height),
Position=ah.TopCenter.Position,
AnchorPoint=ah.TopCenter.AnchorPoint,
Parent=aj.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
ZIndex=98,
})

local at=ad("UIScale",{
Name="Scale",
Scale=al.Scale,
Parent=as,
})

local au=ad("Frame",{
Name="Shadow",
Size=UDim2.new(1,4,1,4),
Position=UDim2.fromOffset(-2,3),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.58,
BorderSizePixel=0,
ZIndex=98,
Parent=as,
},{
ad("UICorner",{
CornerRadius=al.CornerRadius,
}),
})

local av=ad("UIGradient",{
Name="UIGradient",
Color=al.Color,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.12),
NumberSequenceKeypoint.new(0.5,0.52),
NumberSequenceKeypoint.new(1,0.18),
},
})

local aw=ad("UIStroke",{
Name="UIStroke",
Thickness=al.StrokeThickness,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
Color=Color3.new(1,1,1),
Transparency=al.StrokeTransparency,
},{
av,
})

local ax=ad("Frame",{
Name="OpenButton",
Size=UDim2.fromScale(1,1),
BackgroundColor3=al.BackgroundColor,
BackgroundTransparency=al.BackgroundTransparency,
BorderSizePixel=0,
ClipsDescendants=true,
Active=true,
ZIndex=99,
Parent=as,
},{
ad("UICorner",{
CornerRadius=al.CornerRadius,
}),
aw,
ad("Frame",{
Name="Surface",
Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.965,
BorderSizePixel=0,
ZIndex=99,
},{
ad("UICorner",{
CornerRadius=al.CornerRadius,
}),
ad("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.48),
NumberSequenceKeypoint.new(0.45,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
}),
})

local ay=ab.CreateUIShadow(ax,{
Name="NativeShadow",
Enabled=al.Shadow,
BlurRadius=al.ShadowBlur,
Color=al.ShadowColor,
Offset=al.ShadowOffset,
Spread=al.ShadowSpread,
Transparency=al.ShadowTransparency,
ZIndex=0,
})
au.Visible=al.Shadow and ay==nil and al.FallbackShadow

local az=ad("Frame",{
Name="Drag",
Size=UDim2.fromOffset(36,36),
Position=UDim2.fromOffset(4,4),
BackgroundTransparency=1,
ZIndex=102,
Parent=ax,
})

local aA=ab.Image("move","OpenButtonDrag",0,aj.Folder,"OpenButton",true,true)
aA.Name="Icon"
aA.Size=UDim2.fromOffset(17,17)
aA.Position=UDim2.fromScale(0.5,0.5)
aA.AnchorPoint=Vector2.new(0.5,0.5)
aA.Parent=az
local aB=aA:FindFirstChildWhichIsA"ImageLabel"
if aB then
aB.ImageTransparency=0.42
end

local aC=ad("Frame",{
Name="Divider",
Size=UDim2.new(0,1,1,-18),
Position=UDim2.new(0,44,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.88,
BorderSizePixel=0,
ZIndex=102,
Parent=ax,
})

local aD=ad("TextButton",{
Name="TextButton",
Text="",
AutoButtonColor=false,
Size=UDim2.new(1,-45,1,0),
Position=UDim2.fromOffset(45,0),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
BorderSizePixel=0,
ClipsDescendants=true,
ZIndex=101,
Parent=ax,
},{
ad("UICorner",{
CornerRadius=GetInnerCornerRadius(al.CornerRadius,4),
}),
})

local aE=ad("Frame",{
Name="HoverSurface",
Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
BorderSizePixel=0,
ZIndex=101,
Parent=aD,
},{
ad("UICorner",{
CornerRadius=GetInnerCornerRadius(al.CornerRadius,4),
}),
})

local aF=ad("CanvasGroup",{
Name="TextStack",
Size=UDim2.new(1,-58,1,0),
Position=UDim2.fromOffset(46,0),
BackgroundTransparency=1,
GroupTransparency=0,
ZIndex=103,
Parent=aD,
})

local aG=ad("TextLabel",{
Name="Title",
Text=al.Title,
TextSize=15,
FontFace=Font.new(ab.Font),
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,
TextTruncate=Enum.TextTruncate.AtEnd,
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ZIndex=103,
ThemeTag={
TextColor3="Text",
},
Parent=aF,
})

local aH=ad("TextLabel",{
Name="Content",
Text="",
TextSize=12,
FontFace=Font.new(ab.Font),
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
TextTruncate=Enum.TextTruncate.AtEnd,
Size=UDim2.new(1,0,0,18),
Position=UDim2.fromOffset(0,35),
BackgroundTransparency=1,
TextTransparency=0.38,
Visible=false,
ZIndex=103,
ThemeTag={
TextColor3="Text",
},
Parent=aF,
})

local aI=ab.Image("chevron-up","OpenButtonExpand",0,aj.Folder,"OpenButton",true,true)
aI.Name="TrailingIcon"
aI.Size=UDim2.fromOffset(15,15)
aI.Position=UDim2.new(1,-17,0.5,0)
aI.AnchorPoint=Vector2.new(0.5,0.5)
aI.Visible=false
aI.ZIndex=103
aI.Parent=aD
local aJ=aI:FindFirstChildWhichIsA"ImageLabel"
if aJ then
aJ.ImageTransparency=0.48
end

local function StopTween(aK)
local aL=ap[aK]
if aL then
aL:Cancel()
ap[aK]=nil
end
end

local function Animate(aK,aL,aM)
StopTween(aK)
if aL<=0 then
for aN,aO in aM do
aK[aN]=aO
end
return nil
end

local aN=ae(aK,aL,aM,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
ap[aK]=aN
aN:Play()
return aN
end

local function ApplyPosition(aK)
if typeof(aK)=="UDim2"then
as.Position=aK
as.AnchorPoint=Vector2.new(0.5,0.5)
return
end

local aL=ah[tostring(aK or"TopCenter")]or ah.TopCenter
as.Position=aL.Position
as.AnchorPoint=aL.AnchorPoint
end

local function GetDragWidth(aK,aL)
if not al.Draggable or aK=="Collapsed"or aK=="Idle"then
return 0
end
return aL
end

local function GetTargetSize(aK)
if aK=="Idle"then
return Vector2.new(al.IdleWidth,al.IdleHeight)
end

local aL=if aK=="Expanded"then al.ExpandedHeight else al.Height
if aK=="Collapsed"then
return Vector2.new(al.Height,al.Height)
end

local aM=math.max(al.MaxWidth-120,80)
local aN=MeasureText(al.Title,15,aM)
local aO=if aK=="Expanded"and al.Content
then MeasureText(al.Content,12,aM)
else 0
local aP=math.max(aN,aO)
local aQ=GetDragWidth(aK,aL)
local aR=if aq then al.IconSize+al.Gap else 0
local aS=if aK=="Expanded"then 24 else 0
local aT=aQ+(al.Padding*2)+aR+aP+aS
if aK=="Expanded"then
aT=math.max(aT,al.ExpandedWidth)
end

return Vector2.new(math.clamp(aT,aL,al.MaxWidth),aL)
end

local function ApplyState(aK,aL)
aK=NormalizeState(aK)
local aM=if aL==false then 0 else 0.28
local aN=GetTargetSize(aK)
local aO=GetDragWidth(aK,aN.Y)
local aP=al.Padding
local aQ=aq~=nil
local aR=if aQ then al.IconSize+al.Gap else 0
local aS=if aK=="Expanded"then 24 else 0

am.State=aK
al.State=aK
az.Visible=aO>0
aC.Visible=aO>0
aG.Visible=aK~="Collapsed"and aK~="Idle"
aH.Visible=aK=="Expanded"and al.Content~=nil and al.Content~=""
aI.Visible=aK=="Expanded"

Animate(as,aM,{Size=UDim2.fromOffset(aN.X,aN.Y)})
Animate(aD,aM,{
Size=UDim2.new(1,-aO,1,0),
Position=UDim2.fromOffset(aO,0),
})

az.Size=UDim2.fromOffset(math.max(aN.Y-8,0),math.max(aN.Y-8,0))
az.Position=UDim2.fromOffset(4,4)
aC.Position=UDim2.new(0,aO,0.5,0)

if aq then
local aT=if aK=="Collapsed"or aK=="Idle"
then aN.X/2
else aP+al.IconSize/2
Animate(aq,aM,{
Position=UDim2.fromOffset(aT,aN.Y/2),
Size=UDim2.fromOffset(
if aK=="Idle"then 0 else al.IconSize,
if aK=="Idle"then 0 else al.IconSize
),
})
end

local aT=aP+aR
aF.Position=UDim2.fromOffset(aT,0)
aF.Size=UDim2.new(1,-(aT+aP+aS),1,0)
aG.Size=if aH.Visible then UDim2.new(1,0,0,22)else UDim2.fromScale(1,1)
aG.Position=if aH.Visible then UDim2.fromOffset(0,13)else UDim2.fromOffset(0,0)
aH.Text=tostring(al.Content or"")

ab.SafeCallback(al.OnStateChange,aK,am)
end

local function CancelAutoHide()
ao=ao+1
end

local function ScheduleAutoHide(aK)
CancelAutoHide()
if al.AutoHide==false or am.State=="Idle"or not as.Visible then
return
end

local aL=tonumber(aK)
if aL==nil then
aL=tonumber(al.AutoHide)
end
if aL==nil or aL<=0 then
return
end

local aM=ao
task.delay(aL,function()
if aM==ao and as.Parent and as.Visible then
am:SetState"Idle"
end
end)
end

function am.SetIcon(aK,aL,aM)
if aq then
aq:Destroy()
aq=nil
end

al.Icon=aL
if aL~=nil and aL~=false and aL~=""then
aq=ab.Image(
aL,
al.Title..":OpenButton",
0,
aj.Folder,
"OpenButton",
true,
aj.IconThemed
)
aq.Name="Icon"
aq.AnchorPoint=Vector2.new(0.5,0.5)
aq.ZIndex=103
aq.Parent=aD
end

if not aM then
ApplyState(am.State,false)
end
return am
end

function am.SetTitle(aK,aL)
al.Title=tostring(aL or"")
aG.Text=al.Title
ab:ChangeTranslationKey(aG,al.Title)
ApplyState(am.State,true)
return am
end

function am.SetContent(aK,aL)
al.Content=if aL==nil or aL==false then nil else tostring(aL)
aH.Text=al.Content or""
ApplyState(am.State,true)
return am
end

function am.SetState(aK,aL,aM,aN)
an=an+1
CancelAutoHide()
if typeof(aM)=="table"then
if aM.Title~=nil then
al.Title=tostring(aM.Title)
aG.Text=al.Title
end
if aM.Content~=nil or aM.Description~=nil then
local aO=if aM.Content~=nil then aM.Content else aM.Description
al.Content=if aO==false then nil else tostring(aO or"")
end
if aM.Icon~=nil then
am:SetIcon(aM.Icon,true)
end
end

ApplyState(aL,aN)
ScheduleAutoHide()
return am
end

function am.GetState(aK)
return am.State
end

function am.GetMorphTarget(aK)
local aL=ax or as
local aM=aL.AbsoluteSize
local aN=aL.AbsolutePosition+(aM/2)
return{
Position=aN,
Size=aM,
Duration=math.max(tonumber(al.MorphDuration)or 0.42,0),
Enabled=al.MorphWindow~=false and al.Enabled~=false,
}
end

function am.Expand(aK,aL,aM)
am:SetState("Expanded",aL)
local aN=an
local aO=tonumber(aM)or tonumber(al.AutoCollapse)
if aO and aO>0 then
CancelAutoHide()
task.delay(aO,function()
if aN==an and as.Parent then
am:Compact()
end
end)
end
return am
end

function am.Collapse(aK,aL)
return am:SetState("Collapsed",aL)
end

function am.Compact(aK,aL)
return am:SetState("Compact",aL)
end

function am.Idle(aK,aL)
return am:SetState("Idle",aL)
end

am.Hide=am.Idle

function am.Wake(aK,aL)
return am:Compact(aL)
end

function am.ToggleExpanded(aK,aL)
if am.State=="Expanded"then
return am:Compact(aL)
end
return am:Expand(aL)
end

function am.Push(aK,aL,aM)
local aN=am.State
am:SetState("Expanded",aL)
CancelAutoHide()
local aO=an
local aP=math.max(tonumber(aM)or 3,0)
task.delay(aP,function()
if aO==an and as.Parent then
am:SetState(aN)
end
end)
return am
end

am.Notify=am.Push

function am.Visible(aK,aL)
as.Visible=aL==true
if as.Visible then
if al.WakeOnShow and am.State=="Idle"then
am:SetState"Compact"
else
ScheduleAutoHide()
end
else
CancelAutoHide()
end
return am
end

function am.SetScale(aK,aL)
al.Scale=math.max(tonumber(aL)or 1,0.1)
am.Scale=al.Scale
StopTween(at)
at.Scale=al.Scale
return am
end

function am.Pulse(aK)
local aL=al.Scale
Animate(at,0.08,{Scale=aL*0.94})
task.delay(0.08,function()
if at.Parent then
Animate(at,0.16,{Scale=aL})
end
end)
return am
end

function am.Edit(aK,aL)
aL=if typeof(aL)=="table"then aL else{}
al.Title=tostring(Pick(aL.Title,al.Title))
local aM=Pick(aL.Content,Pick(aL.Description,al.Content))
al.Content=if aM==false or aM==nil then nil else tostring(aM)
al.Enabled=Pick(aL.Enabled,al.Enabled)
al.OnlyMobile=Pick(aL.OnlyMobile,al.OnlyMobile)
al.Draggable=Pick(aL.Draggable,al.Draggable)
al.Position=Pick(aL.Position,Pick(aL.Preset,al.Position))
al.Height=math.max(tonumber(Pick(aL.Height,al.Height))or 44,34)
al.IdleWidth=math.max(tonumber(Pick(aL.IdleWidth,al.IdleWidth))or 78,44)
al.IdleHeight=math.max(tonumber(Pick(aL.IdleHeight,al.IdleHeight))or 28,20)
al.ExpandedHeight=
math.max(tonumber(Pick(aL.ExpandedHeight,al.ExpandedHeight))or 68,al.Height)
al.ExpandedWidth=math.max(tonumber(Pick(aL.ExpandedWidth,al.ExpandedWidth))or 220,120)
al.MaxWidth=math.max(tonumber(Pick(aL.MaxWidth,al.MaxWidth))or 380,al.ExpandedWidth)
al.IconSize=math.max(tonumber(Pick(aL.IconSize,al.IconSize))or 22,12)
al.Padding=math.max(tonumber(Pick(aL.Padding,al.Padding))or 12,4)
al.Gap=math.max(tonumber(Pick(aL.Gap,al.Gap))or 9,0)
al.CornerRadius=Pick(aL.CornerRadius,al.CornerRadius)
al.StrokeThickness=math.max(tonumber(Pick(aL.StrokeThickness,al.StrokeThickness))or 1,0)
al.StrokeTransparency=
ab.ClampTransparency(Pick(aL.StrokeTransparency,al.StrokeTransparency),0.7)
al.Scale=math.max(tonumber(Pick(aL.Scale,al.Scale))or 1,0.1)
al.Color=NormalizeColorSequence(aL.Color,al.Color)
al.BackgroundColor=Pick(aL.BackgroundColor,al.BackgroundColor)
al.BackgroundTransparency=ab.ClampTransparency(
Pick(aL.BackgroundTransparency,Pick(aL.Transparency,al.BackgroundTransparency)),
0.08
)
al.TextColor=Pick(aL.TextColor,al.TextColor)
al.TextTransparency=ab.ClampTransparency(
Pick(aL.TextTransparency,al.TextTransparency),
al.TextTransparency
)
al.AutoCollapse=Pick(aL.AutoCollapse,al.AutoCollapse)
al.AutoHide=Pick(aL.AutoHide,al.AutoHide)
al.WakeOnShow=Pick(aL.WakeOnShow,al.WakeOnShow)
al.Shadow=Pick(aL.Shadow,al.Shadow)
al.ShadowBlur=ab.ToUDimRadius(aL.ShadowBlur,al.ShadowBlur)
al.ShadowColor=if typeof(aL.ShadowColor)=="Color3"
then aL.ShadowColor
else al.ShadowColor
al.ShadowOffset=if typeof(aL.ShadowOffset)=="UDim2"
then aL.ShadowOffset
else al.ShadowOffset
al.ShadowSpread=if typeof(aL.ShadowSpread)=="UDim2"
then aL.ShadowSpread
else al.ShadowSpread
al.ShadowTransparency=
ab.ClampTransparency(Pick(aL.ShadowTransparency,al.ShadowTransparency),0.5)
al.FallbackShadow=Pick(aL.FallbackShadow,al.FallbackShadow)
al.MorphWindow=Pick(aL.MorphWindow,Pick(aL.WindowMorph,al.MorphWindow))
al.MorphDuration=math.max(
tonumber(Pick(aL.MorphDuration,Pick(aL.WindowMorphDuration,al.MorphDuration)))or 0.42,
0
)
al.OnStateChange=Pick(aL.OnStateChange,al.OnStateChange)

local aN=aL.State or aL.Mode
if aL.OnlyIcon==true or aL.Style=="Circle"then
aN=aN or"Collapsed"
elseif aL.OnlyIcon==false and aN==nil then
aN="Compact"
end

aj.IsOpenButtonEnabled=al.Enabled~=false
if al.OnlyMobile==false then
aj.IsPC=false
end
if ar then
ar:Set(al.Draggable)
end

ApplyPosition(al.Position)
am:SetScale(al.Scale)
ax.BackgroundColor3=al.BackgroundColor
ax.BackgroundTransparency=al.BackgroundTransparency
ax.UICorner.CornerRadius=al.CornerRadius
aD.UICorner.CornerRadius=GetInnerCornerRadius(al.CornerRadius,4)
aE.UICorner.CornerRadius=GetInnerCornerRadius(al.CornerRadius,4)
au.UICorner.CornerRadius=al.CornerRadius
au.Visible=al.Shadow and ay==nil and al.FallbackShadow
if ay then
ay.Enabled=al.Shadow
ay.BlurRadius=al.ShadowBlur
ay.Color=al.ShadowColor
ay.Offset=al.ShadowOffset
ay.Spread=al.ShadowSpread
ay.Transparency=al.ShadowTransparency
end
aw.Thickness=al.StrokeThickness
aw.Transparency=al.StrokeTransparency
av.Color=al.Color
aG.Text=al.Title
aH.Text=tostring(al.Content or"")
if al.TextColor then
aG.TextColor3=al.TextColor
aH.TextColor3=al.TextColor
end
if al.TextTransparency~=nil then
aG.TextTransparency=al.TextTransparency
end

if aL.Icon~=nil then
am:SetIcon(aL.Icon,true)
elseif not aq and al.Icon then
am:SetIcon(al.Icon,true)
end

ApplyState(aN or am.State,aL.Animate~=false)
if aL.Visible~=nil then
am:Visible(aL.Visible)
elseif as.Visible then
ScheduleAutoHide()
end
return am
end

function am.Destroy(aK)
an=an+1
CancelAutoHide()
local aL={}
for aM in ap do
table.insert(aL,aM)
end
for aM,aN in aL do
StopTween(aN)
end
as:Destroy()
end

ab.AddSignal(aD.MouseEnter,function()
Animate(aE,0.12,{BackgroundTransparency=0.94})
end)
ab.AddSignal(aD.MouseLeave,function()
Animate(aE,0.16,{BackgroundTransparency=1})
end)
ab.AddSignal(aD.InputBegan,function(aK)
if
aK.UserInputType==Enum.UserInputType.MouseButton1
or aK.UserInputType==Enum.UserInputType.Touch
then
am:Pulse()
end
end)

ar=ab.Drag(as)
am.Button=ax
am.Container=as
am.UIElements={
Container=as,
Button=ax,
MainAction=aD,
Drag=az,
Divider=aC,
Title=aG,
Content=aH,
TextStack=aF,
HoverSurface=aE,
TrailingIcon=aI,
Stroke=aw,
Shadow=au,
NativeShadow=ay,
Scale=at,
}

if al.Icon then
am:SetIcon(al.Icon)
else
ApplyState(al.State,false)
end

return am
end

return aa end function a.D()

local aa={}

local ab=a.load'd'
local ad=a.load'e'
local ae=ab.New

local af={
TopLeft={UDim2.new(0,14,0,14),Vector2.new(0,0)},
TopRight={UDim2.new(1,-14,0,14),Vector2.new(1,0)},
BottomLeft={UDim2.new(0,14,1,-14),Vector2.new(0,1)},
BottomRight={UDim2.new(1,-14,1,-14),Vector2.new(1,1)},
TopCenter={UDim2.new(0.5,0,0,14),Vector2.new(0.5,0)},
BottomCenter={UDim2.new(0.5,0,1,-14),Vector2.new(0.5,1)},
}

local function NormalizeConfig(ag)
if ag==false then
return{Visible=false}
end
if typeof(ag)=="string"then
return{Title=ag}
end
if typeof(ag)~="table"then
return{}
end
return ag or{}
end

function aa.New(ag,ah)
local ai={}
local aj
local ak

local al=ae("TextLabel",{
BackgroundTransparency=1,
Text=ag.Title or"WindUI",
TextSize=13,
TextXAlignment="Left",
AutomaticSize="XY",
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="Text",
},
})

local am=ae("TextLabel",{
BackgroundTransparency=1,
Text="v"..tostring(ah and ah.Version or""),
TextSize=11,
TextTransparency=0.42,
TextXAlignment="Left",
AutomaticSize="XY",
FontFace=Font.new(ab.Font),
ThemeTag={
TextColor3="Text",
},
})

local an=ae("Frame",{
Size=UDim2.new(0,0,0,0),
Position=af.BottomRight[1],
AnchorPoint=af.BottomRight[2],
BackgroundTransparency=1,
Parent=ag.Parent,
Active=true,
Visible=false,
ZIndex=120,
})

local ao=ab.NewRoundFrame(14,"Squircle",{
Name="Watermark",
Size=UDim2.new(0,0,0,36),
AutomaticSize="XY",
ImageTransparency=0.18,
Parent=an,
ZIndex=120,
ThemeTag={
ImageColor3="Background",
},
},{
ae("UIStroke",{
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0.82,
Thickness=1,
}),
ae("UIGradient",{
Rotation=24,
Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(210,235,255)),
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.96),
NumberSequenceKeypoint.new(0.48,0.76),
NumberSequenceKeypoint.new(1,0.96),
},
}),
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ae("Frame",{
Name="Text",
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,1),
}),
al,
am,
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingTop=UDim.new(0,7),
PaddingBottom=UDim.new(0,7),
}),
})

ab.AddSignal(ao:GetPropertyChangedSignal"AbsoluteSize",function()
an.Size=UDim2.fromOffset(ao.AbsoluteSize.X,ao.AbsoluteSize.Y)
end)

ak=ab.Drag(an)

local function SetIcon(ap)
if aj then
aj:Destroy()
aj=nil
end
if not ap or ap==""then
return
end

aj=ab.Image(ap,ap,0,ag.Folder,"Watermark",true,true,"Icon")
aj.Size=UDim2.new(0,16,0,16)
aj.LayoutOrder=-1
aj.Parent=ao
end

function ai.Visible(ap,aq)
an.Visible=aq~=false
end

function ai.Edit(ap,aq)
aq=NormalizeConfig(aq)

if aq.Visible==false or aq.Enabled==false then
ai:Visible(false)
return ai
end

if aq.Title~=nil then
al.Text=tostring(aq.Title)
ab:ChangeTranslationKey(al,al.Text)
end
if aq.Desc~=nil or aq.Subtitle~=nil then
am.Text=tostring(aq.Desc or aq.Subtitle or"")
am.Visible=am.Text~=""
ab:ChangeTranslationKey(am,am.Text)
end
if aq.Icon~=nil then
SetIcon(aq.Icon)
end
if aq.Position and af[aq.Position]then
an.Position=af[aq.Position][1]
an.AnchorPoint=af[aq.Position][2]
elseif typeof(aq.Position)=="UDim2"then
an.Position=aq.Position
end
if typeof(aq.AnchorPoint)=="Vector2"then
an.AnchorPoint=aq.AnchorPoint
end
if aq.Transparency~=nil then
ao.ImageTransparency=ab.ClampTransparency(aq.Transparency,ao.ImageTransparency)
end
if aq.Scale then
local ar=ao:FindFirstChildOfClass"UIScale"or ae("UIScale",{Parent=ao})
ar.Scale=tonumber(aq.Scale)or 1
end
if ak then
ak:Set(aq.Draggable~=false)
end

ai:Visible(true)
ad.Play(ao,"Reveal",{ImageTransparency=ao.ImageTransparency},nil,nil,"Watermark")
return ai
end

function ai.SetTitle(ap,aq)
al.Text=tostring(aq or"")
end

function ai.SetDesc(ap,aq)
am.Text=tostring(aq or"")
am.Visible=am.Text~=""
end

function ai.Destroy(ap)
an:Destroy()
end

ai.Container=an
ai.Main=ao

return ai
end

return aa end function a.E()

local aa=game:GetService"UserInputService"
local ab=game:GetService"Workspace"

local ad=a.load'd'
local ae=a.load'e'
local af=ad.New

local ag={}

local function GetImageTarget(ah)
if typeof(ah)~="Instance"then
return nil
end

if ah:IsA"ImageLabel"or ah:IsA"ImageButton"then
return ah
end

return ah:FindFirstChildWhichIsA"ImageLabel"or ah:FindFirstChildWhichIsA"ImageButton"
end

local function ContainsPoint(ah,ai)
if typeof(ah)~="Instance"or not ah.Visible then
return false
end

local aj=ah.AbsolutePosition
local ak=ah.AbsoluteSize

return ai.X>=aj.X
and ai.X<=aj.X+ak.X
and ai.Y>=aj.Y
and ai.Y<=aj.Y+ak.Y
end

local function Trim(ah)
ah=tostring(ah or"")
ah=string.gsub(ah,"^%s+","")
ah=string.gsub(ah,"%s+$","")
return ah
end

local function GetThemeList(ah)
local ai={}

for aj,ak in next,ah:GetThemes()or{}do
table.insert(ai,{
Key=aj,
Name=ak.Name or aj,
})
end

table.sort(ai,function(aj,ak)
return aj.Name<ak.Name
end)

return ai
end

function ag.New(ah,ai,aj)
local ak=typeof(ah.Settings)=="table"and ah.Settings or{}
local al=ak.DefaultConfig or"default"
local am=ak.Width or 360
local an=ak.Height or 410
local ao=ak.PageHeight or(an-142)
local ap={
Open=false,
Button=nil,
Token=0,
SelectedTab="config",
UIElements={},
ThemeButtons={},
TabButtons={},
Pages={},
}

local function GetViewportSize()
local aq=ab.CurrentCamera
return aq and aq.ViewportSize or Vector2.new(1280,720)
end

local function Notify(aq,ar,as,at)
if ai.Notify then
ai:Notify{
Title=aq,
Content=ar,
Icon=as,
Style=at,
}
end
end

local function CreateIcon(aq,ar,as)
local at=ad.Image(aq,aq,0,ah.Folder,"SettingsMenu",true,true,"Icon")
at.Size=UDim2.new(0,as or 16,0,as or 16)
at.Parent=ar
return at
end

local function CreateText(aq,ar,as,at,au)
return af("TextLabel",{
BackgroundTransparency=1,
Text=ar or"",
TextSize=as or 14,
TextTransparency=au or 0,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Parent=aq,
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
})
end

local function CreatePanel(aq)
return ad.NewRoundFrame(ah.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=0.9,
Parent=aq,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
af("UIGradient",{
Rotation=35,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.05),
NumberSequenceKeypoint.new(1,0.2),
},
}),
af("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
af("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})
end

local function CreateActionButton(aq,ar,as,at,au)
local av=ad.NewRoundFrame(14,"Squircle",{
Size=UDim2.new(1,0,0,34),
ImageTransparency=at=="Primary"and 0 or 0.9,
ThemeTag={
ImageColor3=at=="Primary"and"Primary"or"ElementBackground",
},
Parent=aq,
},{
af("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
af("UIListLayout",{
Padding=UDim.new(0,7),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
as and CreateIcon(as,nil,15)or nil,
af("TextLabel",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=ar,
TextSize=13,
FontFace=Font.new(ad.Font),
TextColor3=at=="Primary"and Color3.new(1,1,1)or nil,
ThemeTag={
TextColor3=at~="Primary"and"Text"or nil,
},
}),
},true)

ae.AttachPress(av,ad,{
Amount=0.97,
})

ad.AddSignal(av.MouseButton1Click,function()
ad.SafeCallback(au)
end)

return av
end

local aq=ad.NewRoundFrame(ah.ElementConfig.UICorner,"Squircle",{
Name="SettingsDropdown",
Size=UDim2.new(0,am,0,an),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.fromOffset(0,0),
ImageTransparency=1,
Visible=false,
Active=false,
ZIndex=10000,
Parent=ai.ScreenGui,
ThemeTag={
ImageColor3="Background",
},
},{
af("UIScale",{
Name="Scale",
Scale=0.98,
}),
ad.NewRoundFrame(ah.ElementConfig.UICorner,"SquircleGlass",{
Name="GlassLayer",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.72,
ZIndex=10000,
ThemeTag={
ImageColor3="Primary",
},
}),
ad.NewRoundFrame(ah.ElementConfig.UICorner,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.72,
ZIndex=10001,
ThemeTag={
ImageColor3="Outline",
},
}),
})

local ar=af("Frame",{
Name="SettingsScrim",
Size=UDim2.new(1,0,1,0),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,
Visible=false,
Active=false,
ZIndex=9998,
Parent=ai.ScreenGui,
})

local as=af("CanvasGroup",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
ZIndex=10002,
Parent=aq,
},{
af("UIPadding",{
PaddingTop=UDim.new(0,12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,12),
}),
af("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

ap.UIElements.Root=aq
ap.UIElements.Scale=aq.Scale
ap.UIElements.Scrim=ar
ap.UIElements.Content=as
ap.UIElements.GlassLayer=aq.GlassLayer
ap.UIElements.Outline=aq.Outline

local at
local au

local function UpdateRootPosition()
local av=GetViewportSize()
local aw=12
local ax=math.floor(math.min(am,math.max(280,av.X-(aw*2))))
local ay=math.floor(math.min(an,math.max(300,av.Y-(aw*2))))
local az=Vector2.new(1,0)
local aA=av.X-aw
local aB=aw+ah.Topbar.Height

aq.Size=UDim2.fromOffset(ax,ay)
if at then
at.Size=UDim2.new(1,0,0,math.max(154,ay-142))
end
if au then
au.Size=UDim2.new(1,0,0,math.max(116,ay-238))
end

if ap.Button and ap.Button.AbsoluteSize.X>0 then
local aC=ap.Button.AbsolutePosition
local aD=ap.Button.AbsoluteSize
aA=aC.X+aD.X
aB=aC.Y+aD.Y+10
end

if aA-ax<aw then
aA=math.min(av.X-aw,aw+ax)
end
if aB+ay>av.Y-aw then
aB=math.max(aw,av.Y-ay-aw)
end

aq.AnchorPoint=az
aq.Position=UDim2.fromOffset(aA,aB)
ar.Size=UDim2.fromOffset(av.X,av.Y)
end

local av=af("Frame",{
Name="Header",
LayoutOrder=1,
Size=UDim2.new(1,0,0,40),
BackgroundTransparency=1,
Parent=as,
},{
af("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local aw=CreateIcon("settings",nil,17)
ad.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,36,0,36),
ImageTransparency=0.86,
ThemeTag={
ImageColor3="Primary",
},
Parent=av,
},{
aw,
ad.NewRoundFrame(999,"SquircleGlass",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.8,
ThemeTag={
ImageColor3="Primary",
},
}),
})
aw.Position=UDim2.new(0.5,0,0.5,0)
aw.AnchorPoint=Vector2.new(0.5,0.5)
aw.ZIndex=10002

local ax=af("Frame",{
Size=UDim2.new(1,-46,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=av,
},{
af("UIListLayout",{
Padding=UDim.new(0,2),
FillDirection="Vertical",
}),
})
CreateText(ax,"Settings",16,nil,0)
CreateText(ax,"Config, theme and runtime controls",12,nil,0.42)

local ay=ad.NewRoundFrame(16,"Squircle",{
Name="SettingsTabs",
LayoutOrder=2,
Size=UDim2.new(1,0,0,38),
ImageTransparency=0.9,
Parent=as,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
af("UIPadding",{
PaddingTop=UDim.new(0,4),
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
}),
af("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
}),
})

at=af("Frame",{
Name="Pages",
LayoutOrder=3,
Size=UDim2.new(1,0,0,ao),
BackgroundTransparency=1,
ClipsDescendants=true,
Parent=as,
})

local function CreateTabButton(az,aA,aB,aC)
local aD=CreateIcon(aB,nil,14)
local aE=af("TextLabel",{
Name="Title",
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=aA,
TextSize=12,
TextTruncate="AtEnd",
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
})

local aF=ad.NewRoundFrame(12,"Squircle",{
Name=az,
LayoutOrder=aC,
Size=UDim2.new(0.3333333333333333,-3,1,0),
ImageTransparency=1,
Parent=ay,
ThemeTag={
ImageColor3="Primary",
},
},{
af("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
af("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
aD,
aE,
},true)

local aG=GetImageTarget(aD)
ap.TabButtons[az]={
Button=aF,
Label=aE,
Icon=aG,
}

ae.AttachPress(aF,ad,{
Amount=0.98,
})

ad.AddSignal(aF.MouseButton1Click,function()
ap:SelectTab(az)
end)

return aF
end

local function CreatePage(az)
local aA=af("CanvasGroup",{
Name=az,
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
Visible=false,
Active=false,
Parent=at,
},{
af("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

ap.Pages[az]=aA
return aA
end

local az=CreatePage"config"
local aA=CreatePage"theme"
local aB=CreatePage"about"

CreateTabButton("config","Config","save",1)
CreateTabButton("theme","Theme","palette",2)
CreateTabButton("about","Info","badge-info",3)

local aC=CreatePanel(az)
CreateText(aC,"Config Profile",13,nil,0.05)

local aD=ad.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,36),
ImageTransparency=0.9,
ThemeTag={
ImageColor3="ElementBackground",
},
Parent=aC,
},{
af("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
})

local aE=af("TextBox",{
Name="ConfigName",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ClearTextOnFocus=false,
Text=al,
PlaceholderText="default",
TextSize=13,
TextXAlignment="Left",
FontFace=Font.new(ad.Font),
Parent=aD,
ThemeTag={
TextColor3="Text",
PlaceholderColor3="Placeholder",
},
})

local aF=CreateText(aC,"No saved configs",12,nil,0.45)

local aG=af("Frame",{
Name="HStack",
Size=UDim2.new(1,0,0,34),
BackgroundTransparency=1,
Parent=aC,
},{
af("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Center",
VerticalAlignment="Center",
}),
})

local aH=CreatePanel(az)
CreateText(aH,"Runtime",13,nil,0.05)
local aI=CreateText(aH,"Theme: "..tostring(ai:GetCurrentTheme()),12,nil,0.28)
CreateText(aH,"Settings use glass morph layers and tabbed pages.",12,nil,0.45)

local function GetConfigName()
local aJ=Trim(aE.Text)
return aJ~=""and aJ or al
end

local function RefreshConfigMeta()
local aJ=ah.ConfigManager
if not aJ or typeof(aJ)~="table"then
aF.Text="Config is unavailable in this environment"
return
end

local aK,aL=pcall(function()
return aJ:AllConfigs()
end)
local aM=aK and#aL or 0
aF.Text=aM==1 and"1 saved config"or tostring(aM).." saved configs"
end

local aJ=CreateActionButton(aG,"Save","save","Primary",function()
local aJ=ah.ConfigManager
if not aJ or typeof(aJ)~="table"then
Notify("Config unavailable","Config save needs file access.","triangle-alert","Warning")
return
end

local aK=GetConfigName()
local aL,aM,aN=pcall(function()
local aL=aJ:Config(aK)
aL:Set("theme",ai:GetCurrentTheme())
return aL:Save()
end)

if aL and aM then
RefreshConfigMeta()
Notify("Config saved","Saved '"..aK.."'.","check","Success")
else
Notify("Config save failed",tostring(aN or aM),"triangle-alert","Error")
end
end)
aJ.Size=UDim2.new(0.5,-4,1,0)

local aK=CreateActionButton(aG,"Load","download","Secondary",function()
local aK=ah.ConfigManager
if not aK or typeof(aK)~="table"then
Notify("Config unavailable","Config load needs file access.","triangle-alert","Warning")
return
end

local aL=GetConfigName()
local aM,aN,aO=pcall(function()
local aM=aK:Config(aL)
local aN=aM:Load()
if aN and aN.theme then
ai:SetTheme(aN.theme)
end
return aN
end)

if aM and aN then
aI.Text="Theme: "..tostring(ai:GetCurrentTheme())
Notify("Config loaded","Loaded '"..aL.."'.","refresh-cw","Success")
else
Notify("Config load failed",tostring(aO or aN),"triangle-alert","Error")
end
end)
aK.Size=UDim2.new(0.5,-4,1,0)

local aL=CreatePanel(aA)
CreateText(aL,"Theme Picker",13,nil,0.05)
CreateText(aL,"Tap a theme to apply it instantly.",12,nil,0.45)

au=af("ScrollingFrame",{
Name="ThemeList",
Size=UDim2.new(1,0,0,ak.ThemeListHeight or 214),
BackgroundTransparency=1,
ScrollBarThickness=0,
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
Parent=aL,
},{
af("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

local function UpdateThemeButtons()
local aM=ai:GetCurrentTheme()
aI.Text="Theme: "..tostring(aM)
for aN,aO in next,ap.ThemeButtons do
local aP=aN==aM
ae.Play(aO.Button,"Switch",{ImageTransparency=aP and 0.82 or 0.94},nil,nil,"Theme")
ae.Play(aO.Label,"Switch",{TextTransparency=aP and 0 or 0.24},nil,nil,"Theme")
if aO.Check then
ae.Play(aO.Check,"Switch",{ImageTransparency=aP and 0 or 1},nil,nil,"Theme")
end
end
end

for aM,aN in next,GetThemeList(ai)do
local aO=CreateIcon("check",nil,14)
local aP=ad.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,32),
ImageTransparency=0.94,
ThemeTag={
ImageColor3="Primary",
},
Parent=au,
},{
af("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
af("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
}),
af("TextLabel",{
Name="Title",
Size=UDim2.new(1,-22,1,0),
BackgroundTransparency=1,
Text=aN.Name,
TextSize=13,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
}),
aO,
},true)

local aQ=GetImageTarget(aO)
if aQ then
aQ.ImageTransparency=1
end

ap.ThemeButtons[aN.Key]={
Button=aP,
Label=aP.Title,
Check=aQ,
}

ae.AttachPress(aP,ad,{
Amount=0.985,
})

ad.AddSignal(aP.MouseButton1Click,function()
ai:SetTheme(aN.Key)
UpdateThemeButtons()
end)
end

local aM=CreatePanel(aB)
CreateText(aM,"WindUI Settings",13,nil,0.05)
CreateText(aM,"Use Config for save/load and Theme for quick visual switching.",12,nil,0.36)

local aN=af("Frame",{
Name="VStack",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aM,
},{
af("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

local function CreateInfoRow(aO,aP)
return ad.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,34),
ImageTransparency=0.94,
ThemeTag={
ImageColor3="ElementBackground",
},
Parent=aN,
},{
af("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
af("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
af("TextLabel",{
Size=UDim2.new(0.44,0,1,0),
BackgroundTransparency=1,
Text=aO,
TextSize=12,
TextXAlignment="Left",
TextTransparency=0.38,
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
}),
af("TextLabel",{
Size=UDim2.new(0.56,0,1,0),
BackgroundTransparency=1,
Text=aP,
TextSize=12,
TextXAlignment="Right",
TextTruncate="AtEnd",
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
}),
})
end

CreateInfoRow("Folder",tostring(ah.Folder or"WindUI"))
CreateInfoRow("Topbar",tostring(ah.Topbar.ButtonsType or"Default"))
CreateInfoRow("Motion",tostring(ae:GetConfig().Preset))

function ap.SetButton(aO,aP)
ap.Button=aP
end

function ap.SelectTab(aO,aP)
if not ap.Pages[aP]then
return
end

ap.SelectedTab=aP
for aQ,aR in next,ap.TabButtons do
local aS=aQ==aP
ae.Play(aR.Button,"Switch",{ImageTransparency=aS and 0.82 or 1},nil,nil,"SettingsTab")
ae.Play(aR.Label,"Switch",{TextTransparency=aS and 0 or 0.3},nil,nil,"SettingsTab")
if aR.Icon then
ae.Play(aR.Icon,"Switch",{ImageTransparency=aS and 0 or 0.35},nil,nil,"SettingsTab")
end
end

for aQ,aR in next,ap.Pages do
local aS=aQ==aP
aR.Active=aS
if aS then
aR.Visible=true
aR.GroupTransparency=1
ae.Play(aR,"Reveal",{GroupTransparency=0},nil,nil,"SettingsPage")
else
aR.Visible=false
aR.GroupTransparency=1
end
end
end

function ap.OpenMenu(aO)
if ap.Open then
return
end

ap.Open=true
ap.Token=ap.Token+1
RefreshConfigMeta()
UpdateThemeButtons()
ap:SelectTab(ap.SelectedTab)
UpdateRootPosition()
aq.Visible=true
aq.Active=true
ap.UIElements.Scrim.Visible=true
aq.ImageTransparency=1
ap.UIElements.Scrim.BackgroundTransparency=1
ap.UIElements.Content.GroupTransparency=1
ap.UIElements.GlassLayer.ImageTransparency=1
ap.UIElements.Outline.ImageTransparency=1
ap.UIElements.Scale.Scale=0.98
ae.Play(aq,"DropdownOpen",{ImageTransparency=0.18},nil,nil,"Settings")
ae.Play(ap.UIElements.Scrim,"DropdownOpen",{BackgroundTransparency=ak.ScrimTransparency or 0.72},nil,nil,"SettingsScrim")
ae.Play(ap.UIElements.Content,"DropdownOpen",{GroupTransparency=0},nil,nil,"SettingsContent")
ae.Play(ap.UIElements.GlassLayer,"DropdownOpen",{ImageTransparency=0.78},nil,nil,"SettingsGlass")
ae.Play(ap.UIElements.Outline,"DropdownOpen",{ImageTransparency=0.72},nil,nil,"SettingsOutline")
ae.Play(ap.UIElements.Scale,"DropdownOpen",{Scale=1},nil,nil,"SettingsScale")
end

function ap.CloseMenu(aO)
if not ap.Open then
return
end

ap.Open=false
ap.Token=ap.Token+1
local aP=ap.Token
aq.Active=false
ae.Play(aq,"DropdownClose",{ImageTransparency=1},nil,nil,"Settings")
ae.Play(ap.UIElements.Scrim,"DropdownClose",{BackgroundTransparency=1},nil,nil,"SettingsScrim")
ae.Play(ap.UIElements.Content,"DropdownClose",{GroupTransparency=1},nil,nil,"SettingsContent")
ae.Play(ap.UIElements.GlassLayer,"DropdownClose",{ImageTransparency=1},nil,nil,"SettingsGlass")
ae.Play(ap.UIElements.Outline,"DropdownClose",{ImageTransparency=1},nil,nil,"SettingsOutline")
ae.Play(ap.UIElements.Scale,"DropdownClose",{Scale=0.98},nil,nil,"SettingsScale")
task.delay(ae.GetDuration"DropdownClose",function()
if aP==ap.Token then
aq.Visible=false
ap.UIElements.Scrim.Visible=false
end
end)
end

function ap.Toggle(aO)
if ap.Open then
ap:CloseMenu()
else
ap:OpenMenu()
end
end

ad.AddSignal(aa.InputBegan,function(aO)
if not ap.Open then
return
end
if aO.UserInputType~=Enum.UserInputType.MouseButton1 and aO.UserInputType~=Enum.UserInputType.Touch then
return
end

if ContainsPoint(aq,aO.Position)or ContainsPoint(ap.Button,aO.Position)then
return
end

ap:CloseMenu()
end)

RefreshConfigMeta()
UpdateThemeButtons()
ap:SelectTab"config"

return ap
end

return ag end function a.F()

local aa=game:GetService"UserInputService"
local ab=game:GetService"Workspace"

local ad=a.load'd'
local ae=a.load'e'
local af=ad.New

local ag={}

local function ContainsPoint(ah,ai)
if typeof(ah)~="Instance"or not ah.Visible then
return false
end

local aj=ah.AbsolutePosition
local ak=ah.AbsoluteSize

return ai.X>=aj.X
and ai.X<=aj.X+ak.X
and ai.Y>=aj.Y
and ai.Y<=aj.Y+ak.Y
end

local function NormalizeKey(ah)
if typeof(ah)=="EnumItem"then
return ah.Name,ah
end
if typeof(ah)=="string"and Enum.KeyCode[ah]then
return ah,Enum.KeyCode[ah]
end
return"None",nil
end

function ag.New(ah,ai,aj)
local ak=typeof(ah.KeyBindMenu)=="table"and ah.KeyBindMenu or{}
local al=(aa.TouchEnabled and not aa.KeyboardEnabled)or ah.IsPC==false
local am=ak.Compact==true or(ak.Compact~=false and al)
local an=ak.Width or(am and 330 or 326)
local ao=ak.Height or(am and 300 or 354)
local ap=am and 10 or 14
local aq=am and 6 or 10
local ar=ak.QuickKeys or{"RightShift","F","LeftControl"}
local as={
Open=false,
Button=nil,
Token=0,
Capturing=false,
UserMoved=false,
StoredPosition=nil,
TargetPosition=nil,
UIElements={},
}

local function Notify(at,au,av,aw)
if ai.Notify then
ai:Notify{
Title=at,
Content=au,
Icon=av,
Style=aw,
}
end
end

local function GetViewportSize()
local at=ab.CurrentCamera
return at and at.ViewportSize or Vector2.new(1280,720)
end

local function GetScrimTransparency()
if ak.Scrim==false or ak.ShowScrim==false then
return 1
end
if ak.ScrimTransparency~=nil then
return ak.ScrimTransparency
end
return am and 1 or 0.78
end

local function CreateIcon(at,au,av)
local aw=ad.Image(at,at,0,ah.Folder,"KeyBindMenu",true,true,"Icon")
aw.Size=UDim2.new(0,av or 16,0,av or 16)
aw.Parent=au
return aw
end

local function CreateText(at,au,av,aw,ax)
return af("TextLabel",{
BackgroundTransparency=1,
Text=au or"",
TextSize=av or 14,
TextTransparency=ax or 0,
TextXAlignment="Left",
TextWrapped=true,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Parent=at,
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
})
end

local at=ad.NewRoundFrame(ah.ElementConfig.UICorner,"Squircle",{
Name="KeyBindMenu",
Size=UDim2.new(0,an,0,ao),
AnchorPoint=am and Vector2.new(0.5,1)or Vector2.new(1,0),
Position=UDim2.fromOffset(0,0),
ImageTransparency=1,
Visible=false,
Active=false,
ClipsDescendants=true,
ZIndex=10020,
Parent=ai.ScreenGui,
ThemeTag={
ImageColor3="Background",
},
},{
af("UIScale",{
Name="Scale",
Scale=0.98,
}),
ad.NewRoundFrame(ah.ElementConfig.UICorner,"SquircleGlass",{
Name="GlassLayer",
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ZIndex=10020,
ThemeTag={
ImageColor3="Primary",
},
}),
ad.NewRoundFrame(ah.ElementConfig.UICorner,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ZIndex=10021,
ThemeTag={
ImageColor3="Outline",
},
}),
})

local au=af("Frame",{
Name="KeyBindScrim",
Size=UDim2.new(1,0,1,0),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,
Visible=false,
Active=false,
ZIndex=10018,
Parent=ai.ScreenGui,
})

local av=af("CanvasGroup",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
ZIndex=10022,
Parent=at,
},{
af("UIPadding",{
PaddingTop=UDim.new(0,ap),
PaddingLeft=UDim.new(0,ap),
PaddingRight=UDim.new(0,ap),
PaddingBottom=UDim.new(0,ap),
}),
af("UIListLayout",{
Padding=UDim.new(0,aq),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

as.UIElements.Root=at
as.UIElements.Scale=at.Scale
as.UIElements.Scrim=au
as.UIElements.Content=av
as.UIElements.GlassLayer=at.GlassLayer
as.UIElements.Outline=at.Outline

local function IsImageBackground(aw)
if typeof(aw)~="string"then
return false
end
if string.sub(aw,1,1)=="#"then
return false
end
if string.match(aw,"^video:")then
return false
end
return aw~=""
end

local function GetBackgroundKind(aw)
if aw==nil or aw==false then
return nil,nil,{}
end

if typeof(aw)=="table"then
local ax=aw.Type or aw.Kind or aw.Mode
if aw.Video or ax=="Video"or ax=="video"then
return"Video",aw.Video or aw.Url or aw.URL or aw.Source or aw.Asset or aw.Path,aw
end
if aw.Image or aw.Url or aw.URL or aw.Asset or aw.Path or ax=="Image"or ax=="image"then
return"Image",aw.Image or aw.Url or aw.URL or aw.Asset or aw.Path or aw.Source,aw
end
if aw.Gradient then
return"Gradient",aw.Gradient,aw
end
if ax=="Gradient"or ax=="gradient"or aw.Rotation~=nil or aw.Offset~=nil then
return"Gradient",aw,aw
end
if typeof(aw.Color)=="ColorSequence"or typeof(aw.Transparency)=="NumberSequence"then
return"Gradient",aw,aw
end
return nil,nil,aw
end

if typeof(aw)=="string"then
local ax=string.match(aw,"^video:(.+)")
local ay=aw:match"^([^?#]+)"or aw
if ax or string.match(ay:lower(),"%.webm$")then
return"Video",ax or aw,{}
end
if IsImageBackground(aw)then
return"Image",aw,{}
end
end

return nil,nil,{}
end

local function FindWindowBackgroundVideo()
local aw=ah.UIElements and ah.UIElements.Main
local ax=aw and aw:FindFirstChild"Background"
local ay=ax and ax:FindFirstChild"BackgroundVideo"
if ay and ay:IsA"VideoFrame"then
return ay.Video
end
return nil
end

local function ApplyGradientProperty(aw,ax,ay)
if ax=="Transparency"and typeof(ay)=="number"then
return
end
pcall(function()
aw[ax]=ay
end)
end

local function ApplyBackgroundMedia()
if ak.UseWindowBackground==false then
return
end

local aw,ax=GetBackgroundKind(ak.Background)
local ay,az=GetBackgroundKind(ah.Background)
local aA=ak.BackgroundGradient
or(aw=="Gradient"and ax)
or ah.BackgroundGradient
or(ay=="Gradient"and az)
local aB=ak.BackgroundImage
or(aw=="Image"and ax)
or(ay=="Image"and az)
local aC=(aw=="Video"and ax)
or(ay=="Video"and(FindWindowBackgroundVideo()or az))

if aB then
as.UIElements.BackgroundImage=af("ImageLabel",{
Name="BackgroundImage",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=tostring(aB),
ImageTransparency=ak.BackgroundImageTransparency or ah.BackgroundImageTransparency or 0.46,
ScaleType=ak.BackgroundScaleType or ah.BackgroundScaleType or"Crop",
ZIndex=10019,
Parent=at,
},{
af("UICorner",{
CornerRadius=UDim.new(0,ah.ElementConfig.UICorner),
}),
})
end

if aC then
as.UIElements.BackgroundVideo=af("VideoFrame",{
Name="BackgroundVideo",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Video=tostring(aC),
Looped=true,
Volume=0,
ZIndex=10019,
Parent=at,
},{
af("UICorner",{
CornerRadius=UDim.new(0,ah.ElementConfig.UICorner),
}),
})
as.UIElements.BackgroundVideo:Play()
end

if aA then
local aD=af"UIGradient"
for aE,aF in next,aA do
ApplyGradientProperty(aD,aE,aF)
end

as.UIElements.BackgroundGradient=ad.NewRoundFrame(ah.ElementConfig.UICorner,"Squircle",{
Name="BackgroundGradient",
Size=UDim2.new(1,0,1,0),
ImageTransparency=ak.BackgroundGradientTransparency
or ak.BackgroundOverlayTransparency
or ah.BackgroundOverlayTransparency
or 0.55,
ZIndex=10019,
Parent=at,
},{
aD,
})
end
end

ApplyBackgroundMedia()

local aw=af("Frame",{
Name="DragHandle",
Size=UDim2.new(1,0,0,8),
BackgroundTransparency=1,
LayoutOrder=0,
Visible=am,
Parent=av,
},{
af("Frame",{
Size=UDim2.new(0,42,0,4),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=0.72,
},{
af("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
})

local ax=af("Frame",{
Name="Header",
Size=UDim2.new(1,0,0,am and 34 or 42),
BackgroundTransparency=1,
Active=true,
LayoutOrder=1,
Parent=av,
},{
af("UIListLayout",{
Padding=UDim.new(0,am and 8 or 10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local ay=CreateIcon("keyboard",nil,am and 15 or 18)
ad.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,am and 32 or 38,0,am and 32 or 38),
ImageTransparency=0.86,
Parent=ax,
ThemeTag={
ImageColor3="Primary",
},
},{
ay,
})
ay.Position=UDim2.new(0.5,0,0.5,0)
ay.AnchorPoint=Vector2.new(0.5,0.5)

local az=af("Frame",{
Size=UDim2.new(1,am and-78 or-48,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ax,
},{
af("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,2),
}),
})
CreateText(az,ak.Title or(am and"Keybind"or"KeyBind Menu"),am and 14 or 16,nil,0)
local aA=CreateText(
az,
ak.Desc or(am and"Mobile quick toggle controls."or"Set the window toggle shortcut."),
am and 11 or 12,
nil,
0.42
)
if ak.HideDesc~=nil then
aA.Visible=not ak.HideDesc
else
aA.Visible=not am
end

local aB=CreateIcon("x",nil,13)
local aC=ad.NewRoundFrame(999,"Squircle",{
Size=am and UDim2.new(0,28,0,28)or UDim2.new(0,0,0,0),
ImageTransparency=0.9,
Visible=am,
Parent=ax,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
aB,
},true)
aB.Position=UDim2.new(0.5,0,0.5,0)
aB.AnchorPoint=Vector2.new(0.5,0.5)

ad.AddSignal(aC.MouseButton1Click,function()
as:CloseMenu()
end)

local aD=ad.NewRoundFrame(16,"Squircle",{
Size=UDim2.new(1,0,0,am and 48 or 58),
ImageTransparency=am and 0.8 or 0.88,
LayoutOrder=2,
Parent=av,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
af("UIStroke",{
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=am and 0.8 or 0.88,
Thickness=1,
}),
af("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
af("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local aE=NormalizeKey(ah.ToggleKey or ak.DefaultKey or ak.Value)
af("TextLabel",{
Size=UDim2.new(0.4,0,1,0),
BackgroundTransparency=1,
Text="Current",
TextSize=am and 11 or 12,
TextXAlignment="Left",
TextTransparency=0.44,
FontFace=Font.new(ad.Font),
Parent=aD,
ThemeTag={
TextColor3="Text",
},
})

local aF=af("TextLabel",{
Size=UDim2.new(0.6,0,1,0),
BackgroundTransparency=1,
Text=aE,
TextSize=am and 16 or 18,
TextXAlignment="Right",
FontFace=Font.new(ad.Font),
Parent=aD,
ThemeTag={
TextColor3="Text",
},
})

local aG=ad.NewRoundFrame(16,"Squircle",{
Name="ElementBindings",
Size=UDim2.new(1,0,0,am and 84 or 94),
ImageTransparency=am and 0.86 or 0.9,
LayoutOrder=3,
Parent=av,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
af("UIStroke",{
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=am and 0.82 or 0.9,
Thickness=1,
}),
af("UIPadding",{
PaddingTop=UDim.new(0,8),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,8),
}),
af("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Vertical",
SortOrder="LayoutOrder",
}),
})

local aH=af("TextLabel",{
Name="Header",
Size=UDim2.new(1,0,0,14),
BackgroundTransparency=1,
Text="Element keybinds",
TextSize=am and 11 or 12,
TextXAlignment="Left",
TextTransparency=0.3,
LayoutOrder=1,
Parent=aG,
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
})

local aI=af("ScrollingFrame",{
Name="List",
Size=UDim2.new(1,0,1,-19),
BackgroundTransparency=1,
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ScrollBarThickness=0,
LayoutOrder=2,
Parent=aG,
},{
af("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Vertical",
SortOrder="LayoutOrder",
}),
})

local aJ=af("TextLabel",{
Name="Empty",
Size=UDim2.new(1,0,0,28),
BackgroundTransparency=1,
Text="No element keybinds",
TextSize=am and 11 or 12,
TextTransparency=0.48,
FontFace=Font.new(ad.Font),
Parent=aI,
ThemeTag={
TextColor3="Text",
},
})

local aK=af("Frame",{
Size=UDim2.new(1,0,0,am and 38 or 38),
BackgroundTransparency=1,
LayoutOrder=4,
Parent=av,
},{
af("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Center",
}),
})

local function CreateButton(aL,aM,aN,aO,aP)
local aQ=ad.NewRoundFrame(14,"Squircle",{
Size=UDim2.new(0.5,-4,1,0),
ImageTransparency=aO=="Primary"and(am and 0.08 or 0.18)or(am and 0.84 or 0.9),
Parent=aL,
ThemeTag={
ImageColor3=aO=="Primary"and"Primary"or"ElementBackground",
},
},{
af("UIPadding",{
PaddingLeft=UDim.new(0,am and 8 or 10),
PaddingRight=UDim.new(0,am and 8 or 10),
}),
af("UIListLayout",{
Padding=UDim.new(0,am and 5 or 7),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
aN and CreateIcon(aN,nil,am and 13 or 15)or nil,
af("TextLabel",{
Name="Title",
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=aM,
TextSize=am and 12 or 13,
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
}),
},true)

ae.AttachPress(aQ,ad,{
Amount=0.97,
})

ad.AddSignal(aQ.MouseButton1Click,function()
ad.SafeCallback(aP)
end)

return aQ
end

local aL

local function ApplyKey(aM,aN)
local aO,aP=NormalizeKey(aM)
ah:SetToggleKey(aP)
aF.Text=aO
if not aN then
Notify("Keybind updated",aP and("Toggle key: "..aO)or"Toggle key cleared.","keyboard","Success")
end
end

local function StopCapture()
as.Capturing=false
if aL then
aL:Disconnect()
aL=nil
end
end

function as.Capture(aM)
if as.Capturing then
return
end

as.Capturing=true
aF.Text="Press key..."

aL=aa.InputBegan:Connect(function(aN)
if aN.UserInputType~=Enum.UserInputType.Keyboard then
return
end
if aN.KeyCode==Enum.KeyCode.Unknown then
return
end
if aN.KeyCode==Enum.KeyCode.Escape then
StopCapture()
local aO=NormalizeKey(ah.ToggleKey)
aF.Text=aO
return
end

ApplyKey(aN.KeyCode)
StopCapture()
end)
end

local aM=CreateButton(aK,am and"Bind"or"Set Key","scan-line","Primary",function()
as:Capture()
end)
local aN=CreateButton(aK,"Clear","x","Secondary",function()
StopCapture()
ApplyKey(nil)
end)

local aO=af("Frame",{
Name="QuickKeys",
Size=UDim2.new(1,0,0,am and 34 or 32),
BackgroundTransparency=1,
LayoutOrder=5,
Parent=av,
},{
af("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Center",
}),
})

local function ShortKeyName(aP)
local aQ=tostring(aP)
if not am then
return aQ
end

aQ=aQ:gsub("Right","R")
aQ=aQ:gsub("Left","L")
aQ=aQ:gsub("Control","Ctrl")
return aQ
end

for aP,aQ in next,ar do local
aR, aS=NormalizeKey(aQ)
if aS then
CreateButton(aO,ShortKeyName(aQ),nil,"Secondary",function()
StopCapture()
ApplyKey(aS)
end).Size=UDim2.new(1/#ar,-4,1,0)
end
end

local aP={}
local aQ={}

local function ClearElementRows()
for aR,aS in next,aQ do
if aS then
aS:Disconnect()
end
end
for aR,aS in next,aP do
if aS and aS.Destroy then
aS:Destroy()
end
end
for aR in next,aQ do
aQ[aR]=nil
end
for aR in next,aP do
aP[aR]=nil
end
end

local function NormalizeElementKey(aR)
local aS,aT=NormalizeKey(aR)
if aT then
return ShortKeyName(aS),aT
end
if typeof(aR)=="string"and aR~=""then
return ShortKeyName(aR),nil
end
return nil,nil
end

local function GetElementKeybind(aR)
if typeof(aR)~="table"then
return nil,nil
end

local aS=aR.Keybind
or aR.KeyBind
or aR.Shortcut
or aR.Bind
or aR.Hotkey
or(aR.__type=="Keybind"and aR.Value)
return NormalizeElementKey(aS)
end

local function GetElementIcon(aR)
if aR.__type=="Toggle"then
return"toggle-right"
elseif aR.__type=="Button"then
return"mouse-pointer-click"
end
return"keyboard"
end

local function ActivateElement(aR,aS)
if typeof(aR)~="table"then
return
end
if aR.Locked then
return
end
if aR.__type=="Toggle"and aR.Toggle then
aR:Toggle()
return
end
if aR.__type=="Button"and aR.Press then
aR:Press()
return
end
if aR.Callback then
ad.SafeCallback(aR.Callback,aS)
end
end

local function CreateElementRow(aR,aS,aT)
local aU=ad.NewRoundFrame(12,"Squircle",{
Name="ElementBind",
Size=UDim2.new(1,0,0,am and 28 or 32),
ImageTransparency=am and 0.9 or 0.92,
LayoutOrder=aT,
Parent=aI,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
af("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
af("UIListLayout",{
Padding=UDim.new(0,7),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
CreateIcon(GetElementIcon(aR),nil,am and 13 or 14),
af("TextLabel",{
Name="Title",
Size=UDim2.new(1,-84,1,0),
BackgroundTransparency=1,
Text=aR.Title or aR.__type or"Element",
TextSize=am and 11 or 12,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
}),
af("TextLabel",{
Name="Key",
Size=UDim2.new(0,56,0,am and 20 or 22),
BackgroundTransparency=1,
Text=aS,
TextSize=am and 11 or 12,
TextXAlignment="Right",
TextTransparency=0.14,
FontFace=Font.new(ad.Font),
ThemeTag={
TextColor3="Text",
},
}),
},true)

ae.AttachPress(aU,ad,{
Amount=0.98,
})

local aV=aU.MouseButton1Click:Connect(function()
ActivateElement(aR,aS)
end)

table.insert(aQ,aV)
table.insert(aP,aU)
end

local function RenderElementBindings()
ClearElementRows()

local aR=0
for aS,aT in next,ah.AllElements or{}do
local aU=GetElementKeybind(aT)
if aU then
aR+=1
CreateElementRow(aT,aU,aR)
end
end

aJ.Visible=aR==0
aH.Text=aR>0 and("Element keybinds ("..aR..")")or"Element keybinds"
end

if ah.ToggleKey==nil and ak.DefaultKey and ak.ApplyDefault~=false then local
aR, aS=NormalizeKey(ak.DefaultKey)
if aS then
ApplyKey(aS,true)
end
end

local function UpdateRootPosition()
local aR=GetViewportSize()
local aS=12

if am then
an=math.min(ak.Width or 330,math.max(240,aR.X-(aS*2)))
ao=ak.Height or 300
at.Size=UDim2.fromOffset(an,ao)
at.AnchorPoint=Vector2.new(0.5,1)
as.TargetPosition=UDim2.fromOffset(aR.X/2,aR.Y-aS)
at.Position=as.TargetPosition
au.Size=UDim2.fromOffset(aR.X,aR.Y)

if as.UserMoved and as.StoredPosition then
at.Position=as.StoredPosition
as.TargetPosition=as.StoredPosition
end

return
end

local aT=aR.X-aS
local aU=aS+ah.Topbar.Height

if as.Button and as.Button.AbsoluteSize.X>0 then
local aV=as.Button.AbsolutePosition
local aW=as.Button.AbsoluteSize
aT=aV.X+aW.X
aU=aV.Y+aW.Y+10
end

if aT-an<aS then
aT=math.min(aR.X-aS,aS+an)
end
if aU+ao>aR.Y-aS then
aU=math.max(aS,aR.Y-ao-aS)
end

at.Position=UDim2.fromOffset(aT,aU)
as.TargetPosition=at.Position
au.Size=UDim2.fromOffset(aR.X,aR.Y)

if as.UserMoved and as.StoredPosition then
at.Position=as.StoredPosition
end
end

function as.SetButton(aR,aS)
as.Button=aS
end

local aR=ad.Drag(at,{ax,aw},function(aR)
if not aR then
as.UserMoved=true
as.StoredPosition=at.Position
end
end)
as.UIElements.Drag=aR

function as.OpenMenu(aS)
if as.Open then
return
end

as.Open=true
as.Token+=1
RenderElementBindings()
UpdateRootPosition()
local aT=as.TargetPosition or at.Position
at.Visible=true
at.Active=true
au.Visible=true
if am then
at.Position=UDim2.new(
aT.X.Scale,
aT.X.Offset,
aT.Y.Scale,
aT.Y.Offset+18
)
end
at.ImageTransparency=1
av.GroupTransparency=1
at.GlassLayer.ImageTransparency=1
at.Outline.ImageTransparency=1
at.Scale.Scale=0.98
au.BackgroundTransparency=1
ae.Play(at,"DropdownOpen",{
ImageTransparency=ak.BackgroundTransparency or(am and 0.48 or 0.18),
Position=aT,
},nil,nil,"KeyBindMenu")
ae.Play(av,"DropdownOpen",{GroupTransparency=0},nil,nil,"KeyBindContent")
ae.Play(at.GlassLayer,"DropdownOpen",{ImageTransparency=am and 0.92 or 0.78},nil,nil,"KeyBindGlass")
ae.Play(at.Outline,"DropdownOpen",{ImageTransparency=am and 0.48 or 0.72},nil,nil,"KeyBindOutline")
ae.Play(at.Scale,"DropdownOpen",{Scale=1},nil,nil,"KeyBindScale")
ae.Play(
au,
"DropdownOpen",
{BackgroundTransparency=GetScrimTransparency()},
nil,
nil,
"KeyBindScrim"
)
end

function as.CloseMenu(aS)
if not as.Open then
return
end

as.Open=false
as.Token+=1
local aT=as.Token
StopCapture()
at.Active=false
local aU=at.Position
if am then
aU=UDim2.new(
at.Position.X.Scale,
at.Position.X.Offset,
at.Position.Y.Scale,
at.Position.Y.Offset+18
)
end
ae.Play(at,"DropdownClose",{ImageTransparency=1,Position=aU},nil,nil,"KeyBindMenu")
ae.Play(av,"DropdownClose",{GroupTransparency=1},nil,nil,"KeyBindContent")
ae.Play(at.GlassLayer,"DropdownClose",{ImageTransparency=1},nil,nil,"KeyBindGlass")
ae.Play(at.Outline,"DropdownClose",{ImageTransparency=1},nil,nil,"KeyBindOutline")
ae.Play(at.Scale,"DropdownClose",{Scale=0.98},nil,nil,"KeyBindScale")
ae.Play(au,"DropdownClose",{BackgroundTransparency=1},nil,nil,"KeyBindScrim")
task.delay(ae.GetDuration"DropdownClose",function()
if aT==as.Token then
at.Visible=false
au.Visible=false
end
end)
end

function as.Toggle(aS)
if as.Open then
as:CloseMenu()
else
as:OpenMenu()
end
end

ad.AddSignal(aa.InputBegan,function(aS)
if not as.Open then
return
end
if aS.UserInputType~=Enum.UserInputType.MouseButton1 and aS.UserInputType~=Enum.UserInputType.Touch then
return
end
if ContainsPoint(at,aS.Position)or ContainsPoint(as.Button,aS.Position)then
return
end
as:CloseMenu()
end)

as.UIElements.CurrentKey=aF
as.UIElements.SetButton=aM
as.UIElements.ClearButton=aN

return as
end

return ag end function a.G()

local aa={}

local ab=a.load'd'
local ad=ab.New
local ae=ab.Tween


function aa.New(af,ag,ah,ai,aj,ak)
local al={
Container=nil,
TooltipSize=16,

TooltipArrowSizeX=aj=="Small"and 16 or 24,
TooltipArrowSizeY=aj=="Small"and 6 or 9,

PaddingX=aj=="Small"and 12 or 14,
PaddingY=aj=="Small"and 7 or 9,

Radius=999,

TitleFrame=nil,
}

ai=ai or""
ak=ak~=false

local am=ad("TextLabel",{
AutomaticSize="XY",
TextWrapped=ak,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font),
Text=af,
TextSize=aj=="Small"and 15 or 17,
TextTransparency=1,
ThemeTag={
TextColor3="Tooltip"..ai.."Text",
}
})

al.TitleFrame=am

local an=ad("UIScale",{
Scale=.9
})

local ao=ad("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=ag,

Visible=false
},{
ad("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ad("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=ah,
Name="Arrow",
},{
ad("ImageLabel",{
Size=UDim2.new(0,al.TooltipArrowSizeX,0,al.TooltipArrowSizeY),
BackgroundTransparency=1,

Image="rbxassetid://105854070513330",
ThemeTag={
ImageColor3="Tooltip"..ai,
},
},{










}),
}),
ab.NewRoundFrame(al.Radius,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Tooltip"..ai,
},
ImageTransparency=1,
Name="Background",
},{



ad("Frame",{



AutomaticSize="XY",
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ad("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

am,
ad("UIPadding",{
PaddingTop=UDim.new(0,al.PaddingY),
PaddingLeft=UDim.new(0,al.PaddingX),
PaddingRight=UDim.new(0,al.PaddingX),
PaddingBottom=UDim.new(0,al.PaddingY),
}),
})
}),
an,
ad("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
al.Container=ao

function al.Open(ap)
ao.Visible=true


ae(ao.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ao.Arrow.ImageLabel,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(am,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(an,.22,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function al.Close(ap,aq)

ae(ao.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ao.Arrow.ImageLabel,.2,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(am,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(an,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()

aq=aq~=false
if aq then
task.wait(.35)

ao.Visible=false
ao:Destroy()
end
end

return al
end



return aa end function a.H()
local aa=game:GetService"TweenService"

local ab=a.load'd'
local ad=a.load'e'
local ae=ab.New

local af={}

local function GetImageTarget(ag)
if typeof(ag)~="Instance"then
return nil
end

if ag:IsA"ImageLabel"or ag:IsA"ImageButton"then
return ag
end

return ag:FindFirstChildWhichIsA("ImageLabel",true)or ag:FindFirstChildWhichIsA("ImageButton",true)
end

local function AsColor(ag,ah)
if typeof(ag)=="Color3"then
return ag
end

if typeof(ag)=="string"then
local ai,aj=pcall(function()
return Color3.fromHex(ag)
end)
if ai then
return aj
end
end

return ah
end

local function NewGradient(ag,ah,ai,aj)
return ae("UIGradient",{
Rotation=ag or 0,
Offset=ah or Vector2.new(0,0),
Color=ColorSequence.new(ai),
Transparency=NumberSequence.new(aj),
})
end

function af.Apply(ag,ah)
if typeof(ag)~="Instance"then
return nil
end

ah=typeof(ah)=="table"and ah or{}

local ai=ah.Corner or 16
local aj=ah.ZIndex or ag.ZIndex or 1
local ak=ah.Compact==true
local al=ah.Animated~=false

local am=AsColor(ah.EdgeColor,Color3.fromRGB(255,215,92))
local an=AsColor(ah.DeepColor,Color3.fromRGB(84,54,10))
local ao=AsColor(ah.MidColor,Color3.fromRGB(206,147,39))
local ap=AsColor(ah.HotColor,Color3.fromRGB(255,241,166))

pcall(function()
ag.ClipsDescendants=true
end)

local aq=ae("Frame",{
Name=ah.Name or"GoldenEffect",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Active=false,
ZIndex=aj+20,
Parent=ag,
})

local ar=ab.NewRoundFrame(ai,"Squircle",{
Name="GoldenFill",
Size=UDim2.new(1,0,1,0),
ImageColor3=an,
ImageTransparency=ah.FillTransparency or 0.76,
Active=false,
ZIndex=aj+20,
Parent=aq,
},{
NewGradient(24,Vector2.new(-0.1,0),{
ColorSequenceKeypoint.new(0,an),
ColorSequenceKeypoint.new(0.42,ao),
ColorSequenceKeypoint.new(0.72,ap),
ColorSequenceKeypoint.new(1,an),
},{
NumberSequenceKeypoint.new(0,0.18),
NumberSequenceKeypoint.new(0.52,0.04),
NumberSequenceKeypoint.new(1,0.22),
}),
})

local as=ab.NewRoundFrame(ai,"SquircleOutline",{
Name="GoldenOutline",
Size=UDim2.new(1,0,1,0),
ImageColor3=am,
ImageTransparency=ah.OutlineTransparency or 0.22,
Active=false,
ZIndex=aj+22,
Parent=aq,
},{
NewGradient(35,Vector2.new(0,0),{
ColorSequenceKeypoint.new(0,am),
ColorSequenceKeypoint.new(0.5,ap),
ColorSequenceKeypoint.new(1,ao),
},{
NumberSequenceKeypoint.new(0,0.04),
NumberSequenceKeypoint.new(0.48,0),
NumberSequenceKeypoint.new(1,0.12),
}),
})

local at=NewGradient(18,Vector2.new(-1.15,0),{
ColorSequenceKeypoint.new(0,ap),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,ap),
},{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.42,1),
NumberSequenceKeypoint.new(0.5,0.15),
NumberSequenceKeypoint.new(0.58,1),
NumberSequenceKeypoint.new(1,1),
})

local au=ab.NewRoundFrame(ai,"Squircle",{
Name="GoldenSheen",
Size=UDim2.new(1,0,1,0),
ImageColor3=ap,
ImageTransparency=ah.SheenTransparency or 0.74,
Active=false,
ZIndex=aj+23,
Parent=aq,
},{
at,
})

local av=ae("Frame",{
Name="Sparkles",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Active=false,
ClipsDescendants=true,
ZIndex=aj+24,
Parent=aq,
})

local aw={}
local ax=ah.Points or{
{0.16,0.28,0},
{0.76,0.22,0.42},
{0.34,0.72,0.82},
{0.88,0.64,1.12},
}

for ay,az in ipairs(ax)do
local aA=ak and 9 or 12
local aB=ab.Image("sparkles","GoldenSparkle"..ay,0,"Temp","GoldenEffect",false,true)
aB.Name="Sparkle"..ay
aB.Size=UDim2.fromOffset(aA,aA)
aB.AnchorPoint=Vector2.new(0.5,0.5)
aB.Position=UDim2.fromScale(az[1],az[2])
aB.BackgroundTransparency=1
aB.ZIndex=aj+24
aB.Parent=av

local aC=GetImageTarget(aB)
if aC then
aC.ImageColor3=ap
aC.ImageTransparency=0.62
aC.ZIndex=aj+24
end

local aD=ae("UIScale",{
Scale=0.72,
Parent=aB,
})

table.insert(aw,{
Frame=aB,
Image=aC,
Scale=aD,
Delay=az[3]or 0,
})
end

local ay={
Root=aq,
Fill=ar,
Outline=as,
Sheen=au,
Sparkles=aw,
Running=true,
}

function ay.Destroy(az)
az.Running=false
if az.Root then
az.Root:Destroy()
end
end

if ad:IsEnabled()and not ad.Reduced and al then
task.spawn(function()
while ay.Running and aq.Parent do
at.Offset=Vector2.new(-1.15,0)
local az=aa:Create(
at,
TweenInfo.new(ah.SheenDuration or 1.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
{Offset=Vector2.new(1.15,0)}
)
az:Play()
az.Completed:Wait()
task.wait(ah.SheenPause or 0.42)
end
end)

for az,aA in ipairs(aw)do
task.spawn(function()
task.wait(aA.Delay)
while ay.Running and aq.Parent and aA.Frame.Parent do
aA.Scale.Scale=0.72
aA.Frame.Rotation=-18
if aA.Image then
aA.Image.ImageTransparency=0.68
end

local aB=aa:Create(
aA.Scale,
TweenInfo.new(0.34,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
{Scale=1.12}
)
local aC=aA.Image and aa:Create(
aA.Image,
TweenInfo.new(0.22,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
{ImageTransparency=0.12}
)
local aD=aa:Create(
aA.Frame,
TweenInfo.new(0.58,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
{Rotation=22}
)

aB:Play()
aD:Play()
if aC then
aC:Play()
end
aB.Completed:Wait()

local aE=aa:Create(
aA.Scale,
TweenInfo.new(0.24,Enum.EasingStyle.Sine,Enum.EasingDirection.In),
{Scale=0.78}
)
local aF=aA.Image and aa:Create(
aA.Image,
TweenInfo.new(0.28,Enum.EasingStyle.Sine,Enum.EasingDirection.In),
{ImageTransparency=0.72}
)
aE:Play()
if aF then
aF:Play()
end
aE.Completed:Wait()
task.wait(ah.SparklePause or 1.2)
end
end)
end
end

return ay
end

return af end function a.I()

game:GetService"ReplicatedStorage"
local aa=a.load'd'
local ab=a.load'e'
local ad=aa.New
local ae=aa.NewRoundFrame
local af=a.load'H'

local ag=(cloneref or clonereference or function(ag)
return ag
end)

ag(game:GetService"UserInputService")

local ah=a.load'A'

local function Color3ToHSB(ai)
local aj,ak,al=ai.R,ai.G,ai.B
local am=math.max(aj,ak,al)
local an=math.min(aj,ak,al)
local ao=am-an

local ap=0
if ao~=0 then
if am==aj then
ap=(ak-al)/ao%6
elseif am==ak then
ap=(al-aj)/ao+2
else
ap=(aj-ak)/ao+4
end
ap=ap*60
else
ap=0
end

local aq=(am==0)and 0 or(ao/am)
local ar=am

return{
h=math.floor(ap+0.5),
s=aq,
b=ar,
}
end

local function GetPerceivedBrightness(ai)
local aj=ai.R
local ak=ai.G
local al=ai.B
return 0.299*aj+0.587*ak+0.114*al
end

local function GetTextColorForHSB(ai)
local aj=Color3ToHSB(ai)local
ak, al, am=aj.h, aj.s, aj.b
if GetPerceivedBrightness(ai)>0.5 then
return Color3.fromHSV(ak/360,0,0.05)
else
return Color3.fromHSV(ak/360,0,0.98)
end
end

local function Coalesce(...)
for ai=1,select("#",...)do
local aj=select(ai,...)
if aj~=nil then
return aj
end
end
return nil
end

return function(ai)
local aj={
Title=ai.Title,
Desc=ai.Desc or nil,
Hover=ai.Hover,
Thumbnail=ai.Thumbnail,
ThumbnailSize=ai.ThumbnailSize or 80,
Image=ai.Image,
IconThemed=ai.IconThemed or false,
ImageSize=ai.ImageSize or 30,
Color=ai.Color,
Scalable=ai.Scalable,
Parent=ai.Parent,
Justify=ai.Justify or"Between",
UIPadding=ai.Window.ElementConfig.UIPadding,
UICorner=ai.Window.ElementConfig.UICorner,
Transparency=Coalesce(
ai.Transparency,
ai.ParentConfig and ai.ParentConfig.Transparency,
ai.ParentConfig and ai.ParentConfig.ElementTransparency,
ai.Window.ElementConfig.Transparency
),
GlassTransparency=Coalesce(
ai.GlassTransparency,
ai.ParentConfig and ai.ParentConfig.GlassTransparency,
ai.Window.ElementConfig.GlassTransparency
),
LiquidGlass=Coalesce(
ai.LiquidGlass,
ai.ParentConfig and ai.ParentConfig.LiquidGlass,
ai.ParentConfig and ai.ParentConfig.GlassLiquid,
ai.Window.ElementConfig.LiquidGlass
),
Golden=ai.Golden==true
or ai.Premium==true
or(ai.ParentConfig and(ai.ParentConfig.Golden==true or ai.ParentConfig.Premium==true)),
CornerStyle=Coalesce(
ai.CornerStyle,
ai.ParentConfig and ai.ParentConfig.CornerStyle,
ai.ParentConfig and ai.ParentConfig.ElementCornerStyle,
ai.Window.ElementConfig.CornerStyle
),
Size=ai.Size or"Default",
Tags=ai.Tags or{},
UIElements={},

Index=ai.Index,
LinkCorners=ai.LinkCorners,
CornerGroup=ai.CornerGroup or ai.LinkCornerGroup,
CornerBreak=ai.CornerBreak,
CornerBreakBefore=ai.CornerBreakBefore,
CornerBreakAfter=ai.CornerBreakAfter,
}

local ak=aj.Size=="Small"and-4 or aj.Size=="Large"and 4 or 0
local al=aj.Size=="Small"and-4 or aj.Size=="Large"and 4 or 0

local am=aj.ImageSize
local an=aj.ThumbnailSize
local ao=true

local ap=aj.CornerStyle=="Native"or aj.CornerStyle=="PerCorner"
local aq=aa.ClampTransparency(aj.Transparency,nil)
local ar
local as
local at
local au={}
local av={
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}

local aw=0

local function NewLayerCorner()
local ax=ad("UICorner",{
CornerRadius=UDim.new(0,aj.UICorner),
})
table.insert(au,ax)
return ax
end

local ax
local ay
if aj.Thumbnail then
ax=aa.Image(
aj.Thumbnail,
aj.Title,
ai.Window.NewElements and aj.UICorner-11 or(aj.UICorner-4),
ai.Window.Folder,
"Thumbnail",
false,
aj.IconThemed
)
ax.Size=UDim2.new(1,0,0,an)
end
if aj.Image then
ay=aa.Image(
aj.Image,
aj.Title,
ai.Window.NewElements and aj.UICorner-11 or(aj.UICorner-4),
ai.Window.Folder,
"Image",
aj.IconThemed,
not aj.Color and true or false,
"ElementIcon"
)

if typeof(aj.Color)=="string"and not string.find(aj.Image,"rbxthumb")then
ay.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[aj.Color]))
elseif typeof(aj.Color)=="Color3"and not string.find(aj.Image,"rbxthumb")then
ay.ImageLabel.ImageColor3=GetTextColorForHSB(aj.Color)
end

ay.Size=UDim2.new(0,am,0,am)

aw=am
end

local function CreateText(az,aA)
local aB=typeof(aj.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[aj.Color]))
or typeof(aj.Color)=="Color3"and GetTextColorForHSB(aj.Color)

return ad("TextLabel",{
BackgroundTransparency=1,
Text=az or"",
TextSize=aA=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not aj.Color and("Element"..aA)or nil,
},
TextColor3=aj.Color and aB or nil,
TextTransparency=aA=="Desc"and 0.3 or 0,
TextWrapped=true,
Size=UDim2.new(aj.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=aj.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font),
})
end

local az=CreateText(aj.Title,"Title")
local aA=CreateText(aj.Desc,"Desc")
if not aj.Title or aj.Title==""then
aA.Visible=false
end
if not aj.Desc or aj.Desc==""then
aA.Visible=false
end

aj.UIElements.Title=az
aj.UIElements.Desc=aA

aj.UIElements.Container=ad("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,aj.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=aj.Justify=="Between"and"Left"or"Center",
}),
ax,
ad("Frame",{
Size=UDim2.new(
aj.Justify=="Between"and 1 or 0,
aj.Justify=="Between"and-ai.TextOffset or 0,
0,
0
),
AutomaticSize=aj.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ad("UIListLayout",{
Padding=UDim.new(0,aj.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=ai.Window.NewElements and(aj.Justify=="Between"and"Top"or"Center")
or"Center",
HorizontalAlignment=aj.Justify~="Between"and aj.Justify or"Center",
}),
ay,
ad("Frame",{
BackgroundTransparency=1,
AutomaticSize=aj.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
aj.Justify=="Between"and 1 or 0,
aj.Justify=="Between"and(ay and-aw-aj.UIPadding or-aw)
or 0,
1,
0
),
Name="TitleFrame",
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,(ai.Window.NewElements and aj.UIPadding/2 or 0)+al),
PaddingLeft=UDim.new(0,(ai.Window.NewElements and aj.UIPadding/2 or 0)+ak),
PaddingRight=UDim.new(
0,
(ai.Window.NewElements and aj.UIPadding/2 or 0)+ak
),
PaddingBottom=UDim.new(
0,
(ai.Window.NewElements and aj.UIPadding/2 or 0)+al
),
}),
ad("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ad("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=-99,
BackgroundTransparency=1,
ScrollingDirection="X",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
Visible=false,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,ai.Window.UIPadding/2),
}),
}),
ad("Frame",{
Name="Space",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Visible=false,
}),
az,
aA,
}),
}),
})

for aB,aC in next,ai.Tags or{}do
if not aj.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible then
aj.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible=true
aj.UIElements.Container.TitleFrame.TitleFrame.Space.Visible=true
end
ah:New(aC,aj.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame)
end

aa.AddSignal(
aj.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout:GetPropertyChangedSignal
"AbsoluteContentSize"
,
function()
aj.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Size=UDim2.new(
1,
0,
0,
aj.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y
/ai.ParentConfig.UIScale
)
end
)





local aB=aa.Image("lock","lock",0,ai.Window.Folder,"Lock",false)
aB.Size=UDim2.new(0,20,0,20)
aB.ImageLabel.ImageColor3=Color3.new(1,1,1)
aB.ImageLabel.ImageTransparency=0.4

local aC=ad("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.05,
})

local aD=ad("Frame",{
Size=UDim2.new(1,aj.UIPadding*2,1,aj.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local aE,aF=ae(aj.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=aD,
},{
NewLayerCorner(),
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
aB,
aC,
},nil,true)local

aG=ae(aj.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aD,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local aH,aI=ae(aj.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aD,
},{
NewLayerCorner(),
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)local

aJ=ae(aj.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Visible=false,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aD,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ad("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
},nil,true)

local aK,aL=ae(aj.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aD,
},{
NewLayerCorner(),
ad("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local function GetElementColor()
if typeof(aj.Color)=="string"then
return Color3.fromHex(aa.Colors[aj.Color])
end
if typeof(aj.Color)=="Color3"then
return aj.Color
end
return nil
end

local function GetBackgroundTransparency()
if aq~=nil then
return aq
end
if aj.LiquidGlass then
return aa.ClampTransparency(aj.GlassTransparency,0.24)
end
if aj.Color then
return 0.05
end
if not ai.Window.NewElements then
return 0.93
end
return nil
end

local function ApplyNativeCorners(aM)
av=aM or av
if as then
aa.ApplyCornerRadii(as,UDim.new(0,aj.UICorner),av)
end
for aN,aO in au do
aa.ApplyCornerRadii(aO,UDim.new(0,aj.UICorner),av)
end
end

local function CreateLiquidGlassChildren()
if not aj.LiquidGlass then
return{}
end

at=ad("UIGradient",{
Rotation=25,
Offset=Vector2.new(-0.35,0),
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.45,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.94),
NumberSequenceKeypoint.new(0.45,0.78),
NumberSequenceKeypoint.new(1,0.98),
},
})

return{
ad("UIStroke",{
ApplyStrokeMode="Border",
Thickness=1,
Color=Color3.new(1,1,1),
Transparency=0.88,
}),
at,
}
end

local function CreateNativeBackground()
as=ad("UICorner",{
CornerRadius=UDim.new(0,aj.UICorner),
})

local aM={
as,
}

for aN,aO in next,CreateLiquidGlassChildren()do
table.insert(aM,aO)
end

return ad("Frame",{
Name="NativeBackground",
Size=UDim2.new(1,aj.UIPadding*2,1,aj.UIPadding*2),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
BackgroundColor3=GetElementColor()or nil,
BackgroundTransparency=GetBackgroundTransparency()or 0,
ThemeTag=not aj.Color and{
BackgroundColor3="ElementBackground",
BackgroundTransparency=aq==nil
and not aj.LiquidGlass
and"ElementBackgroundTransparency"
or nil,
}or nil,
ZIndex=0,
Active=false,
},aM)
end

local aM={}
if ap then
ar=CreateNativeBackground()
table.insert(aM,ar)
end

table.insert(aM,aj.UIElements.Container)
table.insert(aM,aD)
table.insert(
aM,
ad("UIPadding",{
PaddingTop=UDim.new(0,aj.UIPadding),
PaddingLeft=UDim.new(0,aj.UIPadding),
PaddingRight=UDim.new(0,aj.UIPadding),
PaddingBottom=UDim.new(0,aj.UIPadding),
})
)

local aN,aO=ae(aj.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ap and 1 or GetBackgroundTransparency(),



Parent=ai.Parent,
ThemeTag={
ImageColor3=not ap
and not aj.Color
and(ai.Window.NewElements and"ElementBackground"or"Text")
or nil,
ImageTransparency=not ap
and not aj.Color
and aq==nil
and not aj.LiquidGlass
and(ai.Window.NewElements and"ElementBackgroundTransparency"or nil)
or nil,
},
ImageColor3=not ap and GetElementColor()or nil,
},aM,true,true)

aj.UIElements.Main=aN
aj.UIElements.Locked=aE
ApplyNativeCorners(av)

if aj.Golden then
aj.UIElements.GoldenEffect=af.Apply(aD,{
Corner=aj.UICorner,
Compact=aj.Size=="Small",
FillTransparency=0.8,
OutlineTransparency=0.18,
SheenTransparency=0.82,
})

az.TextColor3=Color3.fromRGB(255,232,144)
aA.TextColor3=Color3.fromRGB(255,224,138)
aA.TextTransparency=math.min(aA.TextTransparency+0.08,0.72)
end

if aj.Hover then
aa.AddSignal(aN.MouseMoved,function(aP,aQ)
if ao and aN.AbsoluteSize.X>0 then
aK.HoverGradient.Offset=Vector2.new(((aP-aN.AbsolutePosition.X)/aN.AbsoluteSize.X)-0.5,0)
aJ.HoverGradient.Offset=
Vector2.new(((aP-aN.AbsolutePosition.X)/aN.AbsoluteSize.X)-0.5,0)
if at then
at.Offset=
Vector2.new(((aP-aN.AbsolutePosition.X)/aN.AbsoluteSize.X)-0.5,0)
end
end
end)

aa.AddSignal(aN.MouseEnter,function()
if ao then

aJ.Visible=true
ab.Play(
aK,
"Hover",
{ImageTransparency=0.9},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
ab.Play(
aJ,
"Hover",
{ImageTransparency=0.8},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
if ar and aj.LiquidGlass then
ab.Play(ar,"Hover",{
BackgroundTransparency=math.max(
(aq or aj.GlassTransparency or 0.24)-0.06,
0
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Hover")
end
end
end)
aa.AddSignal(aN.InputEnded,function()
if ao then

ab.Play(
aK,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
ab.Play(
aJ,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
if ar and aj.LiquidGlass then
ab.Play(
ar,
"Hover",
{BackgroundTransparency=GetBackgroundTransparency()or 0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end
end
end)
aa.AddSignal(aN.MouseLeave,function()
if ao then
ab.Play(
aK,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
ab.Play(
aJ,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
if ar and aj.LiquidGlass then
ab.Play(
ar,
"Hover",
{BackgroundTransparency=GetBackgroundTransparency()or 0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end
end
end)
end

if aj.Scalable then
ab.AttachPress(aN,aa,{
Amount=0.985,
Enabled=function()
return ao
end,
})
end

function aj.SetTitle(aP,aQ)
aj.Title=aQ
az.Text=aQ
end

function aj.SetDesc(aP,aQ)
aj.Desc=aQ
aA.Text=aQ or""
if not aQ then
aA.Visible=false
elseif not aA.Visible then
aA.Visible=true
end
end

function aj.SetTransparency(aP,aQ)
aq=aa.ClampTransparency(aQ,aq or 0)
aj.Transparency=aq

if ar then
ab.Play(
ar,
"Focus",
{BackgroundTransparency=aq},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"ElementTransparency"
)
else
ab.Play(
aN,
"Focus",
{ImageTransparency=aq},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"ElementTransparency"
)
end
end

function aj.SetLiquidGlass(aP,aQ)
aj.LiquidGlass=aQ==true
if ar then
for aR,aS in next,ar:GetChildren()do
if aS:IsA"UIStroke"or aS:IsA"UIGradient"then
pcall(function()
aS.Enabled=aj.LiquidGlass
end)
end
end
if aq==nil then
ar.BackgroundTransparency=GetBackgroundTransparency()or 0
end
end
end

function aj.Colorize(aP,aQ,aR)
if aj.Color then
aQ[aR]=typeof(aj.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[aj.Color]))
or typeof(aj.Color)=="Color3"and GetTextColorForHSB(aj.Color)
or nil
end
end

if ai.ElementTable then
aa.AddSignal(az:GetPropertyChangedSignal"Text",function()
if aj.Title~=az.Text then
aj:SetTitle(az.Text)
ai.ElementTable.Title=az.Text
end
end)
aa.AddSignal(aA:GetPropertyChangedSignal"Text",function()
if aj.Desc~=aA.Text then
aj:SetDesc(aA.Text)
ai.ElementTable.Desc=aA.Text
end
end)
end





function aj.SetThumbnail(aP,aQ,aR)
aj.Thumbnail=aQ
if aR then
aj.ThumbnailSize=aR
an=aR
end

if ax then
if aQ then
ax:Destroy()
ax=aa.Image(
aQ,
aj.Title,
aj.UICorner-3,
ai.Window.Folder,
"Thumbnail",
false,
aj.IconThemed
)
if ax then
ax.Size=UDim2.new(1,0,0,an)
ax.Parent=aj.UIElements.Container
local aS=aj.UIElements.Container:FindFirstChild"UIListLayout"
if aS then
ax.LayoutOrder=-1
end
end
else
ax.Visible=false
end
else
if aQ then
ax=aa.Image(
aQ,
aj.Title,
aj.UICorner-3,
ai.Window.Folder,
"Thumbnail",
false,
aj.IconThemed
)
if ax then
ax.Size=UDim2.new(1,0,0,an)
ax.Parent=aj.UIElements.Container
local aS=aj.UIElements.Container:FindFirstChild"UIListLayout"
if aS then
ax.LayoutOrder=-1
end
end
end
end
end

function aj.SetImage(aP,aQ,aR)
aj.Image=aQ
if aR then
aj.ImageSize=aR
am=aR
end

if aQ then
local aS=ay and ay.Parent or aj.UIElements.Container.TitleFrame
if ay then
ay:Destroy()
end

ay=aa.Image(
aQ,
aQ,
aj.UICorner-3,
ai.Window.Folder,
"Image",
not aj.Color and true or false
)
if ay then
if typeof(aj.Color)=="string"and not string.find(aj.Image,"rbxthumb")then
ay.ImageLabel.ImageColor3=
GetTextColorForHSB(Color3.fromHex(aa.Colors[aj.Color]))
elseif typeof(aj.Color)=="Color3"and not string.find(aj.Image,"rbxthumb")then
ay.ImageLabel.ImageColor3=GetTextColorForHSB(aj.Color)
end

ay.Visible=true
ay.Parent=aS
ay.LayoutOrder=-99

ay.Size=UDim2.new(0,am,0,am)
aw=aj.ImageSize+aj.UIPadding
end
else
if ay then
ay.Visible=true
end
aw=0
end

aj.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-aw,1,0)
end

function aj.Destroy(aP)
aN:Destroy()
end

function aj.Lock(aP,aQ)
ao=false
aE.Active=true
aE.Visible=true
aC.Text=aQ or"Locked"
end

function aj.Unlock(aP)
ao=true
aE.Active=false
aE.Visible=false
end

function aj.Highlight(aP)
local aQ=ad("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.1,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.9,0.9),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=aG,
})

local aR=ad("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.15,0.8),
NumberSequenceKeypoint.new(0.5,0.1),
NumberSequenceKeypoint.new(0.85,0.8),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=aH,
})

aG.ImageTransparency=0.65
aH.ImageTransparency=0.88

ab.Play(aQ,"Highlight",{
Offset=Vector2.new(1,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Highlight")

ab.Play(aR,"Highlight",{
Offset=Vector2.new(1,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Highlight")

task.spawn(function()
task.wait(ab.GetDuration"Highlight")
aG.ImageTransparency=1
aH.ImageTransparency=1
aQ:Destroy()
aR:Destroy()
end)
end

function aj.UpdateShape(aP)
if ai.Window.NewElements then
local aQ=ai.ParentConfig
and ai.ParentConfig.ParentTable
and ai.ParentConfig.ParentTable.__type
or ai.ParentType
local aR=aj.LinkCorners~=false
and(
aj.LinkCorners==true
or ai.Window.ElementConfig.LinkCorners
or(ai.ParentConfig and ai.ParentConfig.LinkCorners==true)
)

local aS="Squircle"
local aT={Position="Single",Count=1}
local aU={
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}

if aR then
aS,aU,aT=aa.GetLinkedCornerShape(
aP.Elements,
aj.Index,
aP,
aQ,
ai.CornerLink
or(ai.ParentConfig and ai.ParentConfig.CornerLink)
or ai.Window.ElementConfig.CornerLink
)
end

if aS and aN then
local aV=ap and aT.Count>1
local aW=if aV
then"Square"
else(aS=="Squircle-TL-BL"or aS=="Squircle-TR-BR")and"Squircle"or aS

aO:SetType(aW)
aF:SetType(aW)
aI:SetType(aW)

aL:SetType(aW)

ApplyNativeCorners(aU)
end
end
end





return aj
end end function a.J()

local aa=a.load'd'
local ab=aa.New

local ad={}

local ae=a.load'n'.New

function ad.New(af,ag)
ag.Hover=false
ag.TextOffset=0
ag.ParentConfig=ag
ag.IsButtons=ag.Buttons and#ag.Buttons>0 and true or false

local ah={
__type="Paragraph",
Title=ag.Title or"Paragraph",
Desc=ag.Desc or nil,

Locked=ag.Locked or false,
}
local ai=a.load'I'(ag)

ah.ParagraphFrame=ai
if ag.Buttons and#ag.Buttons>0 then
local aj=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.UIElements.Container,
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
}),
})

for ak,al in next,ag.Buttons do
local am=ae(
al.Title,
al.Icon,
al.Callback,
al.Variant or"White",
aj,
nil,
nil,
ag.Window.NewElements and 999 or 10
)
am.Size=UDim2.new(1,0,0,38)

end
end

return ah.__type,ah
end

return ad end function a.K()

local aa=a.load'd'local ab=
aa.New
local ad=game:GetService"UserInputService"

local ae={}

local function NormalizeKey(af)
if typeof(af)=="EnumItem"then
return af.Name,af
end
if typeof(af)=="string"and Enum.KeyCode[af]then
return af,Enum.KeyCode[af]
end
return nil,nil
end

local function GetImageTarget(af)
if typeof(af)~="Instance"then
return nil
end

if af:IsA"ImageLabel"or af:IsA"ImageButton"then
return af
end

return af:FindFirstChildWhichIsA("ImageLabel",true)or af:FindFirstChildWhichIsA("ImageButton",true)
end

function ae.New(af,ag)
local ah,ai=
NormalizeKey(ag.Keybind or ag.KeyBind or ag.Shortcut or ag.Bind or ag.Hotkey)
local aj={
__type="Button",
Title=ag.Title or"Button",
Desc=ag.Desc or nil,
Icon=ag.Icon or"mouse-pointer-click",
IconThemed=ag.IconThemed or false,
IconColor=ag.IconColor or nil,
Color=ag.Color,
Justify=ag.Justify or"Between",
IconAlign=ag.IconAlign or"Right",
Locked=ag.Locked or false,
LockedTitle=ag.LockedTitle,
Golden=ag.Golden==true or ag.Premium==true,
Premium=ag.Premium==true or ag.Golden==true,
Keybind=ah,
KeyCode=ai,
Callback=ag.Callback or function()end,
UIElements={},
}

local ak=true

aj.ButtonFrame=a.load'I'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ag.Parent,




Window=ag.Window,
Color=aj.Color,
Justify=aj.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=ag.Tab,
Index=ag.Index,
ElementTable=aj,
ParentConfig=ag,
Size=ag.Size,
Tags=ag.Tags,
Golden=aj.Golden,
Premium=aj.Premium,
}














aj.UIElements.ButtonIcon=aa.Image(
aj.Icon,
aj.Icon,
0,
ag.Window.Folder,
"Button",
not(aj.Color or aj.IconColor)and true or nil,
aj.IconThemed
)

aj.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
aj.UIElements.ButtonIcon.Parent=aj.Justify=="Between"and aj.ButtonFrame.UIElements.Main
or aj.ButtonFrame.UIElements.Container.TitleFrame
aj.UIElements.ButtonIcon.LayoutOrder=aj.IconAlign=="Left"and-99999 or 99999
aj.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
aj.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

local al=GetImageTarget(aj.UIElements.ButtonIcon)
if al then
if aj.IconColor then
al.ImageColor3=aj.IconColor
elseif aj.Golden then
al.ImageColor3=Color3.fromRGB(255,222,105)
end
aj.ButtonFrame:Colorize(al,"ImageColor3")
end

function aj.Lock(am)
aj.Locked=true
ak=false
return aj.ButtonFrame:Lock(aj.LockedTitle)
end
function aj.Unlock(am)
aj.Locked=false
ak=true
return aj.ButtonFrame:Unlock()
end

if aj.Locked then
aj:Lock()
end

function aj.Press(am)
if ak then
task.spawn(function()
aa.SafeCallback(aj.Callback)
end)
end
end

aa.AddSignal(aj.ButtonFrame.UIElements.Main.MouseButton1Click,function()
aj:Press()
end)

if aj.KeyCode then
aa.AddSignal(ad.InputBegan,function(am,an)
if an or ad:GetFocusedTextBox()then
return
end
if am.UserInputType==Enum.UserInputType.Keyboard and am.KeyCode==aj.KeyCode then
aj:Press()
end
end)
end

return aj.__type,aj
end

return ae end function a.L()

local aa={}

local ab=a.load'd'
local ad=a.load'e'
local ae=ab.New

local af=game:GetService"UserInputService"

function aa.New(ag,ah,ai,aj,ak,al,am)
am=if typeof(am)=="table"then am else{}

local an=am.GlassSpritesheet==true or am.Spritesheet==true
local ao=am.Drag==true or am.Draggable==true or am.Swipe==true
local ap=am.HoldAnimation~=false and am.Hold~=false
local aq={
UseGlassSpritesheet=an,
UseDrag=ao,
UseHoldAnimation=ap,
GlassSpritesheet={
Id="rbxassetid://77297718671545",
MirroredId="rbxassetid://92258969882244",
Size=Vector2.new(102,128),
Total=80,
Cols=10,
},
}

function aq.GetGlassFrame(ar,as:number):(string,Vector2,Vector2)
local at=aq.GlassSpritesheet
local au:number

if as<=0.4 then
au=math.floor((as/0.4)*(at.Total-1))
elseif as<0.6 then
au=at.Total-1
else
au=math.floor(((as-0.6)/0.4)*(at.Total-1))
end

au=math.clamp(au,0,at.Total-1)

local av=as>=0.6
if av then
au=(at.Total-1)-au
end

local aw=if av then at.MirroredId else at.Id
return aw,
at.Size,
Vector2.new(
(au%at.Cols)*at.Size.X,
math.floor(au/at.Cols)*at.Size.Y
)
end

local ar=12
local as
local at=if ah and ah~=""then ab.Icon(ah)else nil
if at then
local au=math.clamp(tonumber(ai)or 13,10,al and 16 or 13)
as=ae("ImageLabel",{
Size=UDim2.fromOffset(au,au),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Image=at[1],
ImageRectOffset=at[2].ImageRectPosition,
ImageRectSize=at[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local au=ae("Frame",{
Size=UDim2.new(0,2,0,26),
BackgroundTransparency=1,
Parent=aj,
})

local av=ab.NewRoundFrame(ar,"Squircle",{
ImageTransparency=0.85,
ThemeTag={
ImageColor3="Text",
},
Parent=au,
Size=UDim2.new(0,al and 52 or 41,0,24),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,0,0.5,0),
Name="ToggleFrame",
},{
ab.NewRoundFrame(ar,"Squircle",{
Size=UDim2.fromScale(1,1),
Name="Layer",
ThemeTag={
ImageColor3="Toggle",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(ar,"SquircleOutline",{
Size=UDim2.fromScale(1,1),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ae("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
}),
}),
ab.NewRoundFrame(ar,"Squircle",{
Size=UDim2.new(0,al and 30 or 20,0,20),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(ar,"Squircle",{
Size=UDim2.fromScale(1,1),
ImageTransparency=0,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Name="Bar",
},{
ab.New("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.new(1,1,1),
Name="Highlight",
BackgroundTransparency=1,
},{
ab.NewRoundFrame(9999,"SquircleGlass",{
Size=UDim2.new(1,1,1,1),
ImageColor3=Color3.new(1,1,1),
Name="SquircleGlass",
ImageTransparency=0.5,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
}),
ab.NewRoundFrame(ar,"Squircle",{
Size=UDim2.fromScale(1,1),
Name="GlassBackground",
ImageTransparency=0,
ThemeTag={
ImageColor3="ElementBackground",
},
ZIndex=-1,
}),
ae("ImageLabel",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
Name="Glass",
ImageTransparency=if an then 0.85 else 1,
Visible=an,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
ab.NewRoundFrame(ar,"Squircle",{
Size=UDim2.fromScale(1,1),
Name="BarOverlay",
ThemeTag={
ImageColor3="ToggleBar",
},
ZIndex=999,
}),
}),
as,
ae("UIScale",{
Scale=1,
}),
}),
}),
ae("TextButton",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
Name="Hitbox",
Text="",
}),
})

local aw
local ax
local ay=if al then 30 else 20
local az=av.Size.X.Offset
local aA

local function SetGlassFrame(aB)
if not an then
return
end

local aC,aD,aE=aq:GetGlassFrame(aB)
local aF=av.Frame.Bar.Highlight.Glass
aF.Image=aC
aF.ImageRectSize=aD
aF.ImageRectOffset=aE
end

local function Render(aB,aC)
local aD=if aB
then UDim2.new(0,az-ay-2,0.5,0)
else UDim2.new(0,2,0.5,0)
local aE=if aB then 0 else 1
local aF=if aB then 0 else 0.85
local aG=if aB then 0 else 1

if an then
ab.SetThemeTag(
av.Frame.Bar.Highlight.Glass,
{ImageColor3=if aB then"Toggle"else"Text"},
0.1
)
SetGlassFrame(if aB then 1 else 0)
end

if aC then
av.Frame.Position=aD
av.Layer.ImageTransparency=aE
av.Frame.Bar.Highlight.Glass.ImageTransparency=aF
if as then
as.ImageTransparency=aG
end
return
end

ad.Play(
av.Frame,
"Select",
{Position=aD},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Position"
)
ad.Play(av.Layer,"Select",{ImageTransparency=aE},nil,nil,"Layer")
if an then
ad.Play(
av.Frame.Bar.Highlight.Glass,
"Select",
{ImageTransparency=aF},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Glass"
)
end
if as then
ad.Play(as,"Select",{ImageTransparency=aG},nil,nil,"Icon")
end
end

function aq.Set(aB,aC,aD,aE)
aC=aC==true
if aA~=aC then
aA=aC
Render(aC,aE==true)
end

if ak and aD~=false then
task.defer(function()
ab.SafeCallback(ak,aC)
end)
end
end

function aq.BeginHold(aB)
if not ap then
return
end

ad.Play(
av.Frame.Bar.UIScale,
"Focus",
{Scale=1.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
ad.Play(
av.Frame.Bar.Highlight.BarOverlay,
"Focus",
{ImageTransparency=0.84},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
end

function aq.EndHold(aB)
if not ap then
return
end

ad.Play(
av.Frame.Bar.UIScale,
"Focus",
{Scale=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
ad.Play(
av.Frame.Bar.Highlight.BarOverlay,
"Focus",
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
end

local function DisconnectDrag()
if aw then
aw:Disconnect()
aw=nil
end
if ax then
ax:Disconnect()
ax=nil
end
end

function aq.Animate(aB,aC,aD)
if not ao or not am.Window or am.Window.IsToggleDragging then
return
end

am.Window.IsToggleDragging=true
local aE=aC.Position.X
local aF=aC.Position.Y
local aG=av.Frame.Position.X.Offset
local aH=false
local aI=false

aq:BeginHold()

DisconnectDrag()
aw=af.InputChanged:Connect(function(aJ)
if not am.Window.IsToggleDragging then
return
end
if
aJ.UserInputType~=Enum.UserInputType.MouseMovement
and aJ.UserInputType~=Enum.UserInputType.Touch
then
return
end

local aK=math.abs(aJ.Position.X-aE)
local aL=math.abs(aJ.Position.Y-aF)
if not aI and aL>10 and aL>aK then
aH=true
return
end
if aH then
return
end
if aK>6 then
aI=true
end

local aM=aJ.Position.X-aE
local aN=math.clamp(aG+aM,2,az-ay-2)
local aO=math.clamp((aN-2)/(az-ay-4),0,1)

SetGlassFrame(aO)
av.Frame.Position=UDim2.new(0,aN,0.5,0)
end)

ax=af.InputEnded:Connect(function(aJ)
if not am.Window.IsToggleDragging then
return
end
if
aJ.UserInputType~=Enum.UserInputType.MouseButton1
and aJ.UserInputType~=Enum.UserInputType.Touch
then
return
end

am.Window.IsToggleDragging=false
DisconnectDrag()
if am.WindUI then
am.WindUI.CurrentInput=nil
end
aA=nil

if aH then
aD:Set(aD.Value,false,false)
elseif not aI then
aD:Set(not aD.Value,true,false)
else
local aK=av.Frame.Position.X.Offset
local aL=aK+(ay/2)>az/2
aD:Set(aL,true,false)
end

aq:EndHold()
end)
end

function aq.Destroy(aB)
DisconnectDrag()
aq:EndHold()
if am.Window then
am.Window.IsToggleDragging=false
end
if am.WindUI then
am.WindUI.CurrentInput=nil
end
end

aq:Set(ag,false,true)
return au,aq
end

return aa end function a.M()

local aa={}

local ab=a.load'd'
local ad=a.load'e'local ae=
ab.New


function aa.New(af,ag,ah,ai,aj,ak)
local al={}

ag=ag or"sfsymbols:checkmark"

local am=9

local an=ab.Image(
ag,
ag,
0,
(ak and ak.Window.Folder or"Temp"),
"Checkbox",
true,
false,
"CheckboxIcon"
)
an.Size=UDim2.new(1,-26+ah,1,-26+ah)
an.AnchorPoint=Vector2.new(0.5,0.5)
an.Position=UDim2.new(0.5,0,0.5,0)


local ao=ab.NewRoundFrame(am,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ai,
Size=UDim2.new(0,26,0,26),
},{
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Checkbox",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(am,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ThemeTag={
ImageColor3="CheckboxBorder",
ImageTransparency="CheckboxBorderTransparency",
},
},{







}),

an,
},true)

function al.Set(ap,aq)
if aq then
ad.Play(ao.Layer,"Fast",{
ImageTransparency=0,
},nil,nil,"State")



ad.Play(an.ImageLabel,"Fast",{
ImageTransparency=0,
},nil,nil,"State")
else
ad.Play(ao.Layer,"Fast",{
ImageTransparency=1,
},nil,nil,"State")



ad.Play(an.ImageLabel,"Fast",{
ImageTransparency=1,
},nil,nil,"State")
end

task.spawn(function()
if aj then
ab.SafeCallback(aj,aq)
end
end)
end

return ao,al
end


return aa end function a.N()

local aa=a.load'd'local ab=
aa.New local ad=
aa.Tween
local ae=game:GetService"UserInputService"

local af=a.load'L'.New
local ag=a.load'M'.New

local ah={}

local function NormalizeKey(ai)
if typeof(ai)=="EnumItem"then
return ai.Name,ai
end
if typeof(ai)=="string"and Enum.KeyCode[ai]then
return ai,Enum.KeyCode[ai]
end
return nil,nil
end

function ah.New(ai,aj)
local ak,al=
NormalizeKey(aj.Keybind or aj.KeyBind or aj.Shortcut or aj.Bind or aj.Hotkey)
local am={
__type="Toggle",
Title=aj.Title or"Toggle",
Desc=aj.Desc or nil,
Locked=aj.Locked or false,
LockedTitle=aj.LockedTitle,
Value=aj.Value,
Icon=aj.Icon or nil,
IconSize=aj.IconSize or 23,
Type=aj.Type or"Toggle",
Keybind=ak,
KeyCode=al,
Callback=aj.Callback or function()end,
UIElements={},
}
am.ToggleFrame=a.load'I'{
Title=am.Title,
Desc=am.Desc,




Window=aj.Window,
Parent=aj.Parent,
TextOffset=(52),
Hover=false,
Tab=aj.Tab,
Index=aj.Index,
ElementTable=am,
ParentConfig=aj,
Tags=aj.Tags,
}

local an=true

if am.Value==nil then
am.Value=false
end

function am.Lock(ao)
am.Locked=true
an=false
return am.ToggleFrame:Lock(am.LockedTitle)
end
function am.Unlock(ao)
am.Locked=false
an=true
return am.ToggleFrame:Unlock()
end

if am.Locked then
am:Lock()
end

local ao=am.Value

local ap,aq
if am.Type=="Toggle"then
ap,aq=af(
ao,
am.Icon,
am.IconSize,
am.ToggleFrame.UIElements.Main,
am.Callback,
aj.Window.NewElements,
aj
)
elseif am.Type=="Checkbox"then
ap,aq=ag(
ao,
am.Icon,
am.IconSize,
am.ToggleFrame.UIElements.Main,
am.Callback,
aj
)
else
error("Unknown Toggle Type: "..tostring(am.Type))
end

ap.AnchorPoint=Vector2.new(1,aj.Window.NewElements and 0 or 0.5)
ap.Position=UDim2.new(1,0,aj.Window.NewElements and 0 or 0.5,0)

function am.Set(ar,as,at,au)
if an then
aq:Set(as,at,au or false)
ao=as
am.Value=as
end
end

function am.Toggle(ar,as,at)
am:Set(not am.Value,as,at==true)
end

am:Set(ao,false,true)

local ar=if aq.UseDrag then aj.WindUI.GenerateGUID()else nil

if aj.Window.NewElements and aq.Animate and aq.UseDrag then
if am.Type=="Toggle"then
aa.AddSignal(ap.ToggleFrame.Hitbox.InputBegan,function(as)
if
not am.Locked
and not aj.Window.IsToggleDragging
and(
as.UserInputType==Enum.UserInputType.MouseButton1
or as.UserInputType==Enum.UserInputType.Touch
)
then
if aj.WindUI.CurrentInput and aj.WindUI.CurrentInput~=ar then
return
end

aj.WindUI.CurrentInput=ar
aq:Animate(as,am)
end
end)
end





else
if am.Type=="Toggle"then
aa.AddSignal(ap.ToggleFrame.Hitbox.InputBegan,function(as)
if
not am.Locked
and(
as.UserInputType==Enum.UserInputType.MouseButton1
or as.UserInputType==Enum.UserInputType.Touch
)
then
aq:BeginHold()
end
end)
aa.AddSignal(ap.ToggleFrame.Hitbox.InputEnded,function(as)
if
as.UserInputType==Enum.UserInputType.MouseButton1
or as.UserInputType==Enum.UserInputType.Touch
then
aq:EndHold()
end
end)
aa.AddSignal(ap.ToggleFrame.Hitbox.MouseLeave,function()
aq:EndHold()
end)
aa.AddSignal(ap.ToggleFrame.Hitbox.MouseButton1Click,function()
if not am.Locked then
am:Toggle(nil,false)
end
end)
elseif am.Type=="Checkbox"then
aa.AddSignal(ap.MouseButton1Click,function()
am:Toggle(nil,false)
end)
end
end

function am.Cleanup(as)
if aq.Destroy then
aq:Destroy()
end
end

if am.KeyCode then
aa.AddSignal(ae.InputBegan,function(as,at)
if at or ae:GetFocusedTextBox()then
return
end
if as.UserInputType==Enum.UserInputType.Keyboard and as.KeyCode==am.KeyCode then
am:Toggle(nil,false)
end
end)
end

return am.__type,am
end

return ah end function a.O()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ad=aa(game:GetService"UserInputService")
local ae=aa(game:GetService"RunService")

local af=a.load'd'
local ag=a.load'e'
local ah=af.New

local ai={}

local aj=false

function ai.New(ak,al)
local am={
__type="Slider",
Title=al.Title or nil,
Desc=al.Desc or nil,
Locked=al.Locked or nil,
LockedTitle=al.LockedTitle,
Value=al.Value or{},
Icons=al.Icons or nil,
IsTooltip=al.IsTooltip or false,
IsTextbox=al.IsTextbox,
Step=al.Step or 1,
Callback=al.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=al.Width or 130,
TextBoxWidth=al.Window.NewElements and 40 or 30,
ThumbSize=13,
IconSize=26,
}
if am.Icons=={}then
am.Icons={
From="sfsymbols:sunMinFill",
To="sfsymbols:sunMaxFill",
}
end
if am.IsTextbox==nil and am.Title==nil then
am.IsTextbox=false
else
am.IsTextbox=am.IsTextbox~=false
end

local an
local ao
local ap
local aq=am.Value.Default or am.Value.Min or 0

local ar=aq
local as=(aq-(am.Value.Min or 0))/((am.Value.Max or 100)-(am.Value.Min or 0))

local at=true
local au=am.Step%1~=0

local function FormatValue(av)
if au then
return tonumber(string.format("%.2f",av))
end
return math.floor(av+0.5)
end

local function CalculateValue(av)
if au then
return math.floor(av/am.Step+0.5)*am.Step
else
return math.floor(av/am.Step+0.5)*am.Step
end
end

local av,aw
local ax=32
if am.Icons then
if am.Icons.From then
av=af.Image(
am.Icons.From,
am.Icons.From,
0,
al.Window.Folder,
"SliderIconFrom",
true,
true,
"SliderIconFrom"
)
av.Size=UDim2.new(0,am.IconSize,0,am.IconSize)
ax=ax+am.IconSize-2
end
if am.Icons.To then
aw=af.Image(
am.Icons.To,
am.Icons.To,
0,
al.Window.Folder,
"SliderIconTo",
true,
true,
"SliderIconTo"
)
aw.Size=UDim2.new(0,am.IconSize,0,am.IconSize)
ax=ax+am.IconSize-2
end
end
am.SliderFrame=a.load'I'{
Title=am.Title,
Desc=am.Desc,
Parent=al.Parent,
TextOffset=am.Width,
Hover=false,
Tab=al.Tab,
Index=al.Index,
Window=al.Window,
ElementTable=am,
ParentConfig=al,
Tags=al.Tags,
}

am.UIElements.SliderIcon=af.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.95,
Size=UDim2.new(1,not am.IsTextbox and-ax or(-am.TextBoxWidth-8),0,4),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{
af.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(as,0,1,0),
ImageTransparency=0.1,
ThemeTag={
ImageColor3="Slider",
},
},{
af.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(
0,
al.Window.NewElements and(am.ThumbSize*2)or(am.ThumbSize+2),
0,
al.Window.NewElements and(am.ThumbSize+4)or(am.ThumbSize+2)
),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="SliderThumb",
},
Name="Thumb",
},{
af.NewRoundFrame(999,"SquircleGlass",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.5,
}),
}),
}),
})

am.UIElements.SliderContainer=ah("Frame",{
Size=UDim2.new(am.Title==nil and 1 or 0,am.Title==nil and 0 or am.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,am.IsTextbox and(al.Window.NewElements and-16 or 0)or 0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=am.SliderFrame.UIElements.Main,
},{
ah("UIListLayout",{
Padding=UDim.new(0,am.Title~=nil and 8 or 12),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=am.Icons
and(am.Icons.From and(am.Icons.To and"Center"or"Left")or am.Icons.To and"Right")
or"Center",
}),
av,
am.UIElements.SliderIcon,
aw,
ah("TextBox",{
Size=UDim2.new(0,am.TextBoxWidth,0,0),
TextXAlignment="Left",
Text=FormatValue(aq),
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.4,
AutomaticSize="Y",
TextSize=15,
FontFace=Font.new(af.Font),
BackgroundTransparency=1,
LayoutOrder=-1,
Visible=am.IsTextbox,
}),
})

local ay
if am.IsTooltip then
ay=a.load'G'.New(
aq,
am.UIElements.SliderIcon.Frame.Thumb,
true,
"Secondary",
"Small",
false
)
ay.Container.AnchorPoint=Vector2.new(0.5,1)
ay.Container.Position=UDim2.new(0.5,0,0,-8)
end

local function SetFillSize(az,aA)
local aB=UDim2.new(az,0,1,0)
if aA==0 or not ag.ShouldAnimate(al)then
am.UIElements.SliderIcon.Frame.Size=aB
else
ag.Play(am.UIElements.SliderIcon.Frame,aA or"Fast",{Size=aB},nil,nil,"Fill")
end
end

function am.Lock(az)
am.Locked=true
at=false
return am.SliderFrame:Lock(am.LockedTitle)
end
function am.Unlock(az)
am.Locked=false
at=true
return am.SliderFrame:Unlock()
end

if am.Locked then
am:Lock()
end


local az=al.Tab.UIElements.ContainerFrame

function am.Set(aA,aB,aC)
if at then
if
not am.IsFocusing
and not aj
and(
not aC
or(
aC.UserInputType==Enum.UserInputType.MouseButton1
or aC.UserInputType==Enum.UserInputType.Touch
)
)
then
if aC then
an=(aC.UserInputType==Enum.UserInputType.Touch)
az.ScrollingEnabled=false
aj=true

local aD=an and aC.Position.X or ad:GetMouseLocation().X
local aE=math.clamp(
(aD-am.UIElements.SliderIcon.AbsolutePosition.X)
/am.UIElements.SliderIcon.AbsoluteSize.X,
0,
1
)
aB=CalculateValue(am.Value.Min+aE*(am.Value.Max-am.Value.Min))
aB=math.clamp(aB,am.Value.Min or 0,am.Value.Max or 100)

if aB~=ar then
SetFillSize(aE,0)
am.UIElements.SliderContainer.TextBox.Text=FormatValue(aB)
if ay then
ay.TitleFrame.Text=FormatValue(aB)
end
am.Value.Default=FormatValue(aB)
ar=aB
af.SafeCallback(am.Callback,FormatValue(aB))
end

ao=ae.RenderStepped:Connect(function()
local aF=an and aC.Position.X or ad:GetMouseLocation().X
local aG=math.clamp(
(aF-am.UIElements.SliderIcon.AbsolutePosition.X)
/am.UIElements.SliderIcon.AbsoluteSize.X,
0,
1
)
aB=CalculateValue(am.Value.Min+aG*(am.Value.Max-am.Value.Min))

if aB~=ar then
SetFillSize(aG,0)
am.UIElements.SliderContainer.TextBox.Text=FormatValue(aB)
if ay then
ay.TitleFrame.Text=FormatValue(aB)
end
am.Value.Default=FormatValue(aB)
ar=aB
af.SafeCallback(am.Callback,FormatValue(aB))
end
end)


ap=ad.InputEnded:Connect(function(aF)
if
(
aF.UserInputType==Enum.UserInputType.MouseButton1
or aF.UserInputType==Enum.UserInputType.Touch
)and aC==aF
then
ao:Disconnect()
ap:Disconnect()
aj=false
az.ScrollingEnabled=true

al.WindUI.CurrentInput=nil

if al.Window.NewElements then
ag.Play(am.UIElements.SliderIcon.Frame.Thumb,"Focus",{
ImageTransparency=0,
Size=UDim2.new(
0,
al.Window.NewElements and(am.ThumbSize*2)or(am.ThumbSize+2),
0,
al.Window.NewElements and(am.ThumbSize+4)or(am.ThumbSize+2)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Thumb")
end
if ay then
ay:Close(false)
end
end
end)
else
aB=math.clamp(aB,am.Value.Min or 0,am.Value.Max or 100)

local aD=math.clamp(
(aB-(am.Value.Min or 0))/((am.Value.Max or 100)-(am.Value.Min or 0)),
0,
1
)
aB=CalculateValue(am.Value.Min+aD*(am.Value.Max-am.Value.Min))

if aB~=ar then
SetFillSize(aD,"Fast")
am.UIElements.SliderContainer.TextBox.Text=FormatValue(aB)
if ay then
ay.TitleFrame.Text=FormatValue(aB)
end
am.Value.Default=FormatValue(aB)
ar=aB
af.SafeCallback(am.Callback,FormatValue(aB))
end
end
end
end
end

function am.SetMax(aA,aB)
am.Value.Max=aB

local aC=tonumber(am.Value.Default)or ar
if aC>aB then
am:Set(aB)
else
local aD=
math.clamp((aC-(am.Value.Min or 0))/(aB-(am.Value.Min or 0)),0,1)
SetFillSize(aD,"Fast")
end
end

function am.SetMin(aA,aB)
am.Value.Min=aB

local aC=tonumber(am.Value.Default)or ar
if aC<aB then
am:Set(aB)
else
local aD=math.clamp((aC-aB)/((am.Value.Max or 100)-aB),0,1)
SetFillSize(aD,"Fast")
end
end

af.AddSignal(am.UIElements.SliderContainer.TextBox.FocusLost,function(aA)
local aB=tonumber(am.UIElements.SliderContainer.TextBox.Text)
if aB then
am:Set(aB)
else
am.UIElements.SliderContainer.TextBox.Text=FormatValue(ar)
if ay then
ay.TitleFrame.Text=FormatValue(ar)
end
end
end)

local aA=al.WindUI.GenerateGUID()

af.AddSignal(am.UIElements.SliderContainer.InputBegan,function(aB)
if am.Locked or aj then
return
end
if
aB.UserInputType==Enum.UserInputType.MouseButton1
or aB.UserInputType==Enum.UserInputType.Touch
then
if al.WindUI.CurrentInput and al.WindUI.CurrentInput~=aA then
return
end
al.WindUI.CurrentInput=aA

am:Set(aq,aB)


if al.Window.NewElements then
ag.Play(am.UIElements.SliderIcon.Frame.Thumb,"Focus",{
ImageTransparency=0.85,
Size=UDim2.new(
0,
(al.Window.NewElements and(am.ThumbSize*2)or am.ThumbSize)+8,
0,
am.ThumbSize+8
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Thumb")
end
if ay then
ay:Open()
end

end
end)

return am.__type,am
end

return ai end function a.P()

local aa=a.load'd'
local ad=aa.New
local ae=aa.Tween

local af={}

local function ToFiniteNumber(ag)
local ah=tonumber(ag)
if ah==nil or ah~=ah or math.abs(ah)==math.huge then
return nil
end

return ah
end

local function FormatNumber(ag)
if ag%1==0 then
return tostring(ag)
end

return tostring(tonumber(string.format("%.2f",ag)))
end

function af.New(ag,ah)
local ai=typeof(ah.Value)=="table"and ah.Value or{}
local aj=ToFiniteNumber(ai.Min)or ToFiniteNumber(ah.Min)or 0
local ak=ToFiniteNumber(ai.Max)or ToFiniteNumber(ah.Max)or 100

if aj>ak then
aj,ak=ak,aj
end

local al=typeof(ah.Value)=="number"and ah.Value
or ToFiniteNumber(ai.Default)
or ToFiniteNumber(ah.Default)
or aj
al=ToFiniteNumber(al)or aj

local am=ah.Indeterminate==true

local an=ah.ShowValue
if an==nil then
an=not am
end

local ao=math.max(ToFiniteNumber(ah.ValueWidth)or 44,0)

local ap={
__type="ProgressBar",
Title=ah.Title or"Progress",
Desc=ah.Desc or nil,
Value={
Min=aj,
Max=ak,
Default=math.clamp(al,aj,ak),
},
ShowValue=an,
DisplayMode=ah.DisplayMode or"Percent",
Format=ah.Format,
Animate=ah.Animate~=false,
AnimationDuration=math.max(ToFiniteNumber(ah.AnimationDuration)or 0.15,0),
Indeterminate=am,
IndeterminateText=ah.IndeterminateText or"",
Speed=math.max(ToFiniteNumber(ah.Speed)or 1,0.01),
ControlGap=math.max(ToFiniteNumber(ah.ControlGap)or 16,0),
UIElements={},

Width=math.max(ToFiniteNumber(ah.Width)or 160,0),
ValueWidth=ao,
}

local function GetRatio(aq)
if ap.Value.Max==ap.Value.Min then
return aq>=ap.Value.Max and 1 or 0
end

return math.clamp((aq-ap.Value.Min)/(ap.Value.Max-ap.Value.Min),0,1)
end

local function GetValueText(aq,ar)
if ap.Indeterminate then
return tostring(ap.IndeterminateText)
end

local as=ar*100

if typeof(ap.Format)=="function"then
local at,au=
pcall(ap.Format,aq,as,ap.Value.Min,ap.Value.Max)

if at and au~=nil then
return tostring(au)
end
end

if ap.DisplayMode=="Value"then
return FormatNumber(aq)
elseif ap.DisplayMode=="Fraction"then
return FormatNumber(aq).."/"..FormatNumber(ap.Value.Max)
end

return tostring(math.floor(as+0.5)).."%"
end

ap.ProgressBarFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ah.Parent,
TextOffset=ap.Width+ap.ControlGap,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
Window=ah.Window,
ElementTable=ap,
ParentConfig=ah,
Tags=ah.Tags,
}

ap.UIElements.Fill=aa.NewRoundFrame(99,"Squircle",{
Name="Fill",
Size=ap.Indeterminate and UDim2.new(0.3,0,1,0)
or UDim2.new(GetRatio(ap.Value.Default),0,1,0),
Position=ap.Indeterminate and UDim2.new(-0.3,0,0,0)or UDim2.new(0,0,0,0),
ThemeTag={
ImageColor3="ProgressBar",
},
})

ap.UIElements.Bar=aa.NewRoundFrame(99,"Squircle",{
Name="Bar",
Size=UDim2.new(1,ap.ShowValue and-(ap.ValueWidth+8)or 0,0,6),
ClipsDescendants=true,
ImageTransparency=0.9,
ThemeTag={
ImageColor3="ProgressBarTrack",
ImageTransparency="ProgressBarTrackTransparency",
},
},{
ap.UIElements.Fill,
})

ap.UIElements.Value=ad("TextLabel",{
Name="Value",
Size=UDim2.new(0,ap.ValueWidth,0,20),
BackgroundTransparency=1,
FontFace=Font.new(aa.Font),
Text=GetValueText(ap.Value.Default,GetRatio(ap.Value.Default)),
TextSize=14,
TextTransparency=0.25,
TextTruncate="AtEnd",
TextXAlignment="Right",
Visible=ap.ShowValue,
ThemeTag={
TextColor3="ProgressBarText",
},
})

ap.UIElements.Container=ad("Frame",{
Name="ProgressBarContainer",
Size=UDim2.new(0,ap.Width,0,36),
Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ap.ProgressBarFrame.UIElements.Main,
},{
ad("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Right",
VerticalAlignment="Center",
}),
ap.UIElements.Bar,
ap.UIElements.Value,
})

if ap.Indeterminate then
local aq=ae(
ap.UIElements.Fill,
1/ap.Speed,
{Position=UDim2.new(1,0,0,0)},
Enum.EasingStyle.Linear,
Enum.EasingDirection.InOut,-1

)
aa.AddSignal(ap.UIElements.Bar.Destroying,function()
aq:Cancel()
end)
aq:Play()
end

local function Update(aq,ar)
local as=ToFiniteNumber(aq)
if as==nil then
return ap.Value.Default
end

as=math.clamp(as,ap.Value.Min,ap.Value.Max)
ap.Value.Default=as

local at=GetRatio(as)
local au=UDim2.new(at,0,1,0)

if ap.UIElements.Fill and not ap.Indeterminate then
if ar or not ap.Animate or ap.AnimationDuration<=0 then
ap.UIElements.Fill.Size=au
else
ae(
ap.UIElements.Fill,
ap.AnimationDuration,
{Size=au},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end

ap.UIElements.Value.Text=GetValueText(as,at)

return as
end

function ap.Set(aq,ar)
return Update(ar,false)
end

function ap.Get(aq)
return ap.Value.Default
end

function ap.GetPercentage(aq)
return GetRatio(ap.Value.Default)*100
end

function ap.SetRange(aq,ar,as)
ar=ToFiniteNumber(ar)
as=ToFiniteNumber(as)

if ar==nil or as==nil then
return ap.Value.Min,ap.Value.Max
end

if ar>as then
ar,as=as,ar
end

ap.Value.Min=ar
ap.Value.Max=as
Update(ap.Value.Default,false)

return ar,as
end

function ap.SetMin(aq,ar)
ar=ToFiniteNumber(ar)
if ar==nil then
return ap.Value.Min
end

ap:SetRange(ar,math.max(ar,ap.Value.Max))
return ap.Value.Min
end

function ap.SetMax(aq,ar)
ar=ToFiniteNumber(ar)
if ar==nil then
return ap.Value.Max
end

ap:SetRange(math.min(ap.Value.Min,ar),ar)
return ap.Value.Max
end

Update(ap.Value.Default,true)

return ap.__type,ap
end

return af end function a.Q()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ad=aa(game:GetService"UserInputService")

local ae=a.load'd'
local af=ae.New local ag=
ae.Tween

local ah={
UICorner=6,
UIPadding=8,
}

local ai=a.load'y'.New

function ah.New(aj,ak)
local function NormalizeKeyCode(al)
if typeof(al)=="EnumItem"then
return al.Name
elseif type(al)=="string"then
return al
else
return"F"
end
end

local al={
__type="Keybind",
Title=ak.Title or"Keybind",
Desc=ak.Desc or nil,
Locked=ak.Locked or false,
LockedTitle=ak.LockedTitle,
Value=NormalizeKeyCode(ak.Value)or"F",
Callback=ak.Callback or function()end,
CanChange=ak.CanChange~=false,
Blacklist=ak.Blacklist or{},
Picking=false,
UIElements={},
}

local am={}

for an,ao in next,al.Blacklist do
table.insert(am,Enum.KeyCode[NormalizeKeyCode(ao)])
end
table.insert(am,Enum.KeyCode[NormalizeKeyCode"Escape"])

local an=true

al.KeybindFrame=a.load'I'{
Title=al.Title,
Desc=al.Desc,
Parent=ak.Parent,
TextOffset=85,
Hover=al.CanChange,
Tab=ak.Tab,
Index=ak.Index,
Window=ak.Window,
ElementTable=al,
ParentConfig=ak,
Tags=ak.Tags,
}

al.UIElements.Keybind=ai(
al.Value,
nil,
al.KeybindFrame.UIElements.Main,
nil,
ak.Window.NewElements and 12 or 10
)

al.UIElements.Keybind.Size=
UDim2.new(0,24+al.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,0,42)
al.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
al.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)
al.UIElements.Keybind.Interactable=false

af("UIScale",{
Parent=al.UIElements.Keybind,
Scale=0.85,
})

ae.AddSignal(
al.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",
function()
al.UIElements.Keybind.Size=
UDim2.new(0,24+al.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,0,42)
end
)

function al.Lock(ao)
al.Locked=true
an=false
return al.KeybindFrame:Lock(al.LockedTitle)
end
function al.Unlock(ao)
al.Locked=false
an=true
return al.KeybindFrame:Unlock()
end

function al.Set(ao,ap)
local aq=NormalizeKeyCode(ap)
al.Value=aq
al.UIElements.Keybind.Frame.Frame.TextLabel.Text=aq
end

if al.Locked then
al:Lock()
end

local ao

ae.AddSignal(al.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if an then
if al.CanChange then
al.Picking=true
al.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."



local ap
ap=ad.InputBegan:Connect(function(aq)
local ar

if aq.UserInputType==Enum.UserInputType.Keyboard then
if table.find(am,aq.KeyCode)then
ar=nil
return
else
ar=aq.KeyCode.Name
end
elseif
aq.UserInputType==Enum.UserInputType.MouseButton1
and not table.find(am,"MouseLeftButton")
then
ar="MouseLeftButton"
elseif
aq.UserInputType==Enum.UserInputType.MouseButton2
and not table.find(am,"MouseRightButton")
then
ar="MouseRightButton"
end

if ao then
ao:Disconnect()
end

ao=ad.InputEnded:Connect(function(as)
if
ar
and(
as.KeyCode.Name==ar
or ar=="MouseLeft"and as.UserInputType==Enum.UserInputType.MouseButton1
or ar=="MouseRight"and as.UserInputType==Enum.UserInputType.MouseButton2
)
then
al.Picking=false

al.UIElements.Keybind.Frame.Frame.TextLabel.Text=ar
al.Value=ar

ap:Disconnect()
ao:Disconnect()
end
end)
end)
end
end
end)

ae.AddSignal(ad.InputBegan,function(ap,aq)
if ad:GetFocusedTextBox()then
return
end
if not an then
return
end
if al.Picking then
return
end

if ap.UserInputType==Enum.UserInputType.Keyboard then
if ap.KeyCode.Name==al.Value then
ae.SafeCallback(al.Callback,ap.KeyCode.Name)
end
elseif ap.UserInputType==Enum.UserInputType.MouseButton1 and al.Value=="MouseLeft"then
ae.SafeCallback(al.Callback,"MouseLeft")
elseif ap.UserInputType==Enum.UserInputType.MouseButton2 and al.Value=="MouseRight"then
ae.SafeCallback(al.Callback,"MouseRight")
end
end)

return al.__type,al
end

return ah end function a.R()

local aa=a.load'd'local ad=
aa.New local ae=
aa.Tween

local af={
UICorner=8,
UIPadding=8,
}local ag=a.load'n'

.New
local ah=a.load'o'.New

function af.New(ai,aj)
local ak={
__type="Input",
Title=aj.Title or"Input",
Desc=aj.Desc or nil,
Type=aj.Type or"Input",
Locked=aj.Locked or false,
LockedTitle=aj.LockedTitle,
InputIcon=aj.InputIcon or false,
Placeholder=aj.Placeholder or"Enter Text...",
Value=aj.Value or"",
Callback=aj.Callback or function()end,
ClearTextOnFocus=aj.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local al=true

ak.InputFrame=a.load'I'{
Title=ak.Title,
Desc=ak.Desc,
Parent=aj.Parent,
TextOffset=ak.Width,
Hover=false,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
Tags=aj.Tags,
}

local am=ah(
ak.Placeholder,
ak.InputIcon,
ak.Type=="Textarea"and ak.InputFrame.UIElements.Container or ak.InputFrame.UIElements.Main,
ak.Type,
function(am)
ak:Set(am,true)
end,
nil,
aj.Window.NewElements and 12 or 10,
ak.ClearTextOnFocus
)

if ak.Type~="Textarea"then
am.Size=UDim2.new(0,ak.Width,0,36)
am.Position=UDim2.new(1,0,aj.Window.NewElements and 0 or 0.5,0)
am.AnchorPoint=Vector2.new(1,aj.Window.NewElements and 0 or 0.5)
else
am.Size=UDim2.new(1,0,0,148)
end






function ak.Lock(an)
ak.Locked=true
al=false
return ak.InputFrame:Lock(ak.LockedTitle)
end
function ak.Unlock(an)
ak.Locked=false
al=true
return ak.InputFrame:Unlock()
end

function ak.Set(an,ao,ap)
if al then
ak.Value=ao
aa.SafeCallback(ak.Callback,ao)

if not ap then
am.Frame.Frame.TextBox.Text=ao
end
end
end

function ak.SetPlaceholder(an,ao)
am.Frame.Frame.TextBox.PlaceholderText=ao
ak.Placeholder=ao
end

ak:Set(ak.Value)

if ak.Locked then
ak:Lock()
end

return ak.__type,ak
end

return af end function a.S()

local aa=a.load'd'
local af=aa.New

local ag={}

function ag.New(ah,ai)
local aj=af("Frame",{
Size=ai.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ak=af("Frame",{
Parent=ai.Parent,
Size=ai.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
aj
})

return"Divider",{__type="Divider",ElementFrame=ak}
end

return ag end function a.T()
local aa={}

local af=(cloneref or clonereference or function(af)
return af
end)

local ag=af(game:GetService"UserInputService")
local ah=af(game:GetService"Players").LocalPlayer:GetMouse()
local ai=af(game:GetService"Workspace")
local aj=ai.CurrentCamera local ak=

workspace.CurrentCamera

local al=a.load'd'
local am=a.load'e'
local an=al.New
local ao=al.Tween

local ap=0.76

function aa.New(aq,ar,as,at)
local au={}
local av=string.lower(tostring(ar.CenterTarget or"Window"))
local aw=aq.Window and aq.Window.UIElements and aq.Window.UIElements.Main
local ax=if typeof(aw)=="Instance"
then aw:FindFirstChild"Main"or aw
else nil
local ay=ar.Centered
and av~="screen"
and av~="viewport"
and typeof(ax)=="Instance"
local az=if ay then ax else aq.WindUI.DropdownGui
local aA={}

ar.InternalCenter=ay
ar.PopupParent=az

if not ar.Callback then
at="Menu"
end

ar.UIElements.UIListLayout=an("UIListLayout",{
Padding=UDim.new(0,as.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

ar.UIElements.Menu=al.NewRoundFrame(
as.MenuCorner,
ar.Glass and"SquircleGlass"or"Squircle",
{
ThemeTag={
ImageColor3="DropdownBackground",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=242,
},
{
an("UIPadding",{
PaddingTop=UDim.new(0,as.MenuPadding),
PaddingLeft=UDim.new(0,as.MenuPadding),
PaddingRight=UDim.new(0,as.MenuPadding),
PaddingBottom=UDim.new(0,as.MenuPadding),
}),
an("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,as.MenuPadding),
}),
an("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,ar.SearchBarEnabled and-as.MenuPadding-as.SearchBarHeight),

ClipsDescendants=true,
LayoutOrder=999,
Name="Frame",
},{
an("UICorner",{
CornerRadius=UDim.new(0,as.MenuCorner-as.MenuPadding),
}),
an("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
ar.UIElements.UIListLayout,
}),
}),
}
)
ar.UIElements.MenuScale=an("UIScale",{
Name="MenuScale",
Scale=1,
Parent=ar.UIElements.Menu,
})

if ar.Centered and ar.Backdrop then
ar.UIElements.Backdrop=an("TextButton",{
Name="DropdownBackdrop",
Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
Visible=false,
Active=true,
ZIndex=240,
Parent=az,
})
end

ar.UIElements.MenuCanvas=an("Frame",{
Size=UDim2.new(0,ar.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,
ZIndex=241,

Parent=az,
AnchorPoint=Vector2.new(1,0),
},{
ar.UIElements.Menu,
an("UISizeConstraint",{
MinSize=Vector2.new(ar.Compact and 148 or 170,0),
MaxSize=Vector2.new(ar.MenuMaxWidth or 420,ar.MenuMaxHeight or 340),
}),
})

local function GetLayoutScale()
local aB=aq.UIScale or al.UIScale or 1
return aB>0 and aB or 1
end

local function GetVisibleContentHeight()
local aB=0
local aC=0
local aD=GetLayoutScale()
local aE=ar.UIElements.Menu.Frame.ScrollingFrame

for aF,aG in next,aE:GetChildren()do
if aG:IsA"GuiObject"and aG.Visible then
local aH=aG.AbsoluteSize.Y/aD
if aH<=0 then
aH=aG.Size.Y.Offset>0 and aG.Size.Y.Offset or ar.ItemHeight
end

aB+=aH
aC+=1
end
end

if aC>1 then
aB+=ar.UIElements.UIListLayout.Padding.Offset*(aC-1)
end

return aB
end

local function RecalculateCanvasSize()
ar.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,GetVisibleContentHeight())
end

local function GetDropdownButton()
return ar.UIElements.Dropdown or ar.DropdownFrame.UIElements.Main
end

local function GetViewportSize()
if ay and typeof(az)=="Instance"and az:IsA"GuiObject"then
return az.AbsoluteSize/GetLayoutScale()
end
if aq.WindUI.DropdownGui and aq.WindUI.DropdownGui.AbsoluteSize.X>0 then
return aq.WindUI.DropdownGui.AbsoluteSize
end
local aB=ai.CurrentCamera or aj
return aB and aB.ViewportSize or Vector2.new(1280,720)
end

local function GetInputPosition(aB)
if aB and typeof(aB.Position)=="Vector3"then
return Vector2.new(aB.Position.X,aB.Position.Y)
end
return Vector2.new(ah.X,ah.Y)
end

local function ContainsPoint(aB,aC)
if typeof(aB)~="Instance"or not aB.Visible then
return false
end

local aD=aB.AbsolutePosition
local aE=aB.AbsoluteSize

return aC.X>=aD.X
and aC.X<=aD.X+aE.X
and aC.Y>=aD.Y
and aC.Y<=aD.Y+aE.Y
end

local function NormalizeDirection(aB,aC)
local aD=tostring(aB or aC or"Auto")
aD=aD:sub(1,1):upper()..aD:sub(2):lower()
if
aD~="Auto"
and aD~="Down"
and aD~="Up"
and aD~="Left"
and aD~="Right"
then
return aC or"Auto"
end
return aD
end

local function NormalizeSide(aB,aC)
local aD=tostring(aB or aC or"Right")
aD=aD:sub(1,1):upper()..aD:sub(2):lower()
if aD~="Left"and aD~="Center"and aD~="Right"then
return aC or"Right"
end
return aD
end

local function IsMobileViewport()
local aB=GetViewportSize()
return aq.Window.IsPC==false
or(ag.TouchEnabled and not ag.KeyboardEnabled)
or aB.X<=640
end

local function GetCanvasWidth()
local aB=GetDropdownButton()
local aC=GetViewportSize()
local aD=math.max(as.MenuPadding*2,8)
local aE=math.max(
120,
math.min(ar.MenuMaxWidth or(IsMobileViewport()and 320 or 420),aC.X-(aD*2))
)
local aF=math.min(ar.Compact and 148 or 170,aE)
local aG=if aB.AbsoluteSize.X>0
then aB.AbsoluteSize.X/(ay and GetLayoutScale()or 1)
else ar.MenuWidth
local aH=ar.FullWidth and math.max(aG,ar.MenuWidth)or ar.MenuWidth

return math.floor(math.clamp(aH,aF,aE)+0.5)
end

local function ApplyCanvasWidth()
local aB=GetCanvasWidth()
ar.UIElements.MenuCanvas.Size=UDim2.new(
0,
aB,
ar.UIElements.MenuCanvas.Size.Y.Scale,
ar.UIElements.MenuCanvas.Size.Y.Offset
)
return aB
end

local function RecalculateListSize()
local aB=ApplyCanvasWidth()

local aC=GetViewportSize()
local aD=ar.SearchBarEnabled and(as.SearchBarHeight+44)or 44
local aE=math.max(
aD,
math.min(
ar.MenuMaxHeight or(IsMobileViewport()and 280 or 340),
aC.Y-(as.MenuPadding*4)
)
)

local aF=GetVisibleContentHeight()
local aG=ar.SearchBarEnabled and(as.SearchBarHeight+(as.MenuPadding*3))
or(as.MenuPadding*2)
local aH=aF+aG

if aH>aE then
ar.UIElements.MenuCanvas.Size=UDim2.fromOffset(aB,aE)
else
ar.UIElements.MenuCanvas.Size=UDim2.fromOffset(aB,aH)
end
end

function UpdatePosition()
local aB=GetDropdownButton()
local aC=ar.UIElements.MenuCanvas
local aD=GetViewportSize()
local aE=as.MenuPadding*2
local aF=IsMobileViewport()
local aG=NormalizeDirection(
aF and(ar.MobileDirection or ar.Direction)or ar.Direction,
"Auto"
)
local aH=
NormalizeSide(aF and(ar.MobileSide or"Center")or ar.Side,aF and"Center"or"Right")
local aI=aB.AbsolutePosition
local aJ=aB.AbsoluteSize
local aK=aC.AbsoluteSize/(ay and GetLayoutScale()or 1)

if aK.X<=0 or aK.Y<=0 then
aK=Vector2.new(aC.Size.X.Offset,aC.Size.Y.Offset)
end

if ar.Centered then
if ay then
local aL=ar.CenterOffset or Vector2.new(0,0)
local aM=aK.X/2
local aN=aK.Y/2
local aO=math.clamp((aD.X/2)+aL.X,aE+aM,aD.X-aE-aM)
local aP=
math.clamp((aD.Y/2)+aL.Y,aE+aN,aD.Y-aE-aN)

aC.AnchorPoint=Vector2.new(0.5,0.5)
aC.Position=UDim2.fromOffset(math.floor(aO+0.5),math.floor(aP+0.5))
ar.UIElements.Menu.AnchorPoint=Vector2.new(0.5,0.5)
ar.UIElements.Menu.Position=UDim2.fromScale(0.5,0.5)
return"Center"
end

local aL=Vector2.new(0,0)
local aM=aD
local aN=string.lower(tostring(ar.CenterTarget or"Window"))
local aO=aq.Window and aq.Window.UIElements and aq.Window.UIElements.Main

if
aN~="screen"
and aN~="viewport"
and typeof(aO)=="Instance"
and aO.Visible
and aO.AbsoluteSize.X>0
then
aL=aO.AbsolutePosition
aM=aO.AbsoluteSize
end

local aP=ar.CenterOffset or Vector2.new(0,0)
local aQ=aL.X+(aM.X/2)+aP.X
local aR=aL.Y+(aM.Y/2)+aP.Y
local aS=aK.X/2
local aT=aK.Y/2
aQ=math.clamp(aQ,aE+aS,aD.X-aE-aS)
aR=math.clamp(aR,aE+aT,aD.Y-aE-aT)

aC.AnchorPoint=Vector2.new(0.5,0.5)
aC.Position=UDim2.fromOffset(math.floor(aQ+0.5),math.floor(aR+0.5))
ar.UIElements.Menu.AnchorPoint=Vector2.new(0.5,0.5)
ar.UIElements.Menu.Position=UDim2.fromScale(0.5,0.5)
return"Center"
end

if aF and not ar.MobileDirection and(aG=="Left"or aG=="Right")then
aG="Auto"
end

if aG=="Left"and aI.X-aE<aK.X then
aG="Auto"
elseif aG=="Right"and aD.X-(aI.X+aJ.X)-aE<aK.X then
aG="Auto"
end

if aG=="Auto"then
local aL=aD.Y-(aI.Y+aJ.Y)-aE
local aM=aI.Y-aE
if aL>=aK.Y or aL>=aM then
aG="Down"
else
aG="Up"
end
end

if aG~="Up"and aG~="Left"and aG~="Right"then
aG="Down"
end

local aL
local aM
local aN=Vector2.new(1,0)

if aG=="Left"then
aL=aI.X-aE
aM=aI.Y
aN=Vector2.new(1,0)
elseif aG=="Right"then
aL=aI.X+aJ.X+aE
aM=aI.Y
aN=Vector2.new(0,0)
elseif aG=="Up"then
aM=aI.Y-aE
aN=Vector2.new(aH=="Left"and 0 or aH=="Center"and 0.5 or 1,1)
if aH=="Left"then
aL=aI.X
elseif aH=="Center"then
aL=aI.X+(aJ.X/2)
else
aL=aI.X+aJ.X
end
else
aM=aI.Y+aJ.Y+aE
aN=Vector2.new(aH=="Left"and 0 or aH=="Center"and 0.5 or 1,0)
if aH=="Left"then
aL=aI.X
elseif aH=="Center"then
aL=aI.X+(aJ.X/2)
else
aL=aI.X+aJ.X
end
end

local aO=aL-(aN.X*aK.X)
local aP=aM-(aN.Y*aK.Y)

if aO<aE then
aL+=aE-aO
elseif aO+aK.X>aD.X-aE then
aL-=(aO+aK.X)-(aD.X-aE)
end

if aP<aE then
aM+=aE-aP
elseif aP+aK.Y>aD.Y-aE then
aM-=(aP+aK.Y)-(aD.Y-aE)
end

aC.AnchorPoint=aN
aC.Position=UDim2.fromOffset(math.floor(aL+0.5),math.floor(aM+0.5))
ar.UIElements.Menu.AnchorPoint=aG=="Left"and Vector2.new(1,0)
or aG=="Right"and Vector2.new(0,0)
or aG=="Up"and Vector2.new(1,1)
or Vector2.new(1,0)
ar.UIElements.Menu.Position=aG=="Left"and UDim2.new(1,0,0,0)
or aG=="Right"and UDim2.new(0,0,0,0)
or aG=="Up"and UDim2.new(1,0,1,0)
or UDim2.new(1,0,0,0)

return aG
end

local aB
local aC=""
local aD
local aE

local function CreateSearchBar()
local aF=math.max(as.MenuCorner-as.MenuPadding,6)
local aG=al.Icon"search"

aD=an("TextBox",{
Name="TextBox",
BackgroundTransparency=1,
ClearTextOnFocus=false,
ClipsDescendants=true,
FontFace=Font.new(al.Font),
PlaceholderText=ar.SearchPlaceholder,
Text=aC,
TextColor3=Color3.new(1,1,1),
TextSize=16,
TextScaled=false,
TextTruncate=Enum.TextTruncate.AtEnd,
TextWrapped=false,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,
ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
Size=UDim2.new(1,-31,1,0),
})

local aH=al.NewRoundFrame(aF,"Squircle",{
Name="SearchBar",
LayoutOrder=0,
Parent=ar.UIElements.Menu,
Size=UDim2.new(1,0,0,as.SearchBarHeight),
ImageTransparency=0,
ThemeTag={
ImageColor3="DropdownTabBackground",
},
},{
al.NewRoundFrame(aF,"Squircle",{
Name="Outline",
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.8,
ThemeTag={
ImageColor3="DropdownTabBorder",
},
}),
an("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
},{
an("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
an("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Left",
VerticalAlignment="Center",
Padding=UDim.new(0,8),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
an("ImageLabel",{
Name="Icon",
BackgroundTransparency=1,
Image=aG[1],
ImageRectOffset=aG[2].ImageRectPosition,
ImageRectSize=aG[2].ImageRectSize,
ImageTransparency=0.18,
Size=UDim2.new(0,19,0,19),
ThemeTag={
ImageColor3="Icon",
},
}),
aD,
}),
})

al.AddSignal(aD:GetPropertyChangedSignal"Text",function()
aE(aD.Text)
end)

al.AddSignal(aD.Focused,function()
ao(aH.Outline,0.12,{ImageTransparency=0.48}):Play()
end)

al.AddSignal(aD.FocusLost,function()
ao(aH.Outline,0.12,{ImageTransparency=0.8}):Play()
end)

return aH
end

local function GetSearchText(aF)
local aG={
aF.Name,
aF.Desc,
}

if typeof(aF.Original)=="table"then
table.insert(aG,aF.Original.Value)
table.insert(aG,aF.Original.Id)
table.insert(aG,aF.Original.Key)
end

local aH={}
for aI,aJ in next,aG do
if aJ~=nil then
table.insert(aH,tostring(aJ))
end
end

return string.lower(table.concat(aH," "))
end

function aE(aF)
aC=tostring(aF or"")
local aG=string.lower(aC)

for aH,aI in next,ar.Tabs do
if aI.UIElements and aI.UIElements.TabItem then
local aJ=aI.UIElements.TabItem
local aK=aG==""
or string.find(GetSearchText(aI),aG,1,true)~=nil
if aK then
if not aJ.Parent then
aJ.Parent=ar.UIElements.Menu.Frame.ScrollingFrame
end
aJ.Visible=true
aJ.Size=aI.Size
aJ.AutomaticSize=aI.AutomaticSize
else
aJ.Visible=false
end
end
end

RecalculateCanvasSize()
RecalculateListSize()

if ar.UIElements.MenuCanvas.Visible then
UpdatePosition()
end

task.defer(function()
if aq.Window.Destroyed then
return
end

RecalculateCanvasSize()
RecalculateListSize()

if ar.UIElements.MenuCanvas.Visible then
UpdatePosition()
end
end)
end

function au.Display(aF)
local aG=ar.Values
local aH=""

if ar.Multi then
local aI={}
if typeof(ar.Value)=="table"then
for aJ,aK in ipairs(ar.Value)do
local aL=typeof(aK)=="table"and aK.Title or aK
aI[aL]=true
end
end

for aJ,aK in ipairs(aG)do
local aL=typeof(aK)=="table"and aK.Title or aK
if aI[aL]then
aH=aH..aL..", "
end
end

if#aH>0 then
aH=aH:sub(1,#aH-2)
end
else
aH=typeof(ar.Value)=="table"and(ar.Value.Title or ar.Value[1])
or ar.Value
or""
end

if ar.UIElements.Dropdown then
ar.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(aH==""and"--"or aH)
end
end

local function Callback(aF)
au:Display()
if ar.Locked then
return
end

if ar.Callback then
task.spawn(function()
if ar.Locked then
return
end
al.SafeCallback(ar.Callback,ar.Value)
end)
else
task.spawn(function()
if ar.Locked then
return
end
al.SafeCallback(aF)
end)
end
end

function au.LockValues(aF,aG)
if not aG then
return
end

for aH,aI in next,ar.Tabs do
if aI and aI.UIElements and aI.UIElements.TabItem then
local aJ=aI.Name
local aK=false

for aL,aM in next,aG do
if aJ==aM then
aK=true
break
end
end

if aK then
ao(aI.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

ao(aI.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if aI.UIElements.TabIcon then
ao(aI.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

aI.UIElements.TabItem.Active=false
aI.Locked=true
else
if aI.Selected then
ao(aI.UIElements.TabItem,0.1,{ImageTransparency=ap}):Play()

ao(aI.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aI.UIElements.TabIcon then
ao(aI.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
ao(aI.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

ao(
aI.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=at=="Dropdown"and 0.4 or 0.05}
):Play()
if aI.UIElements.TabIcon then
ao(
aI.UIElements.TabIcon.ImageLabel,
0.1,
{ImageTransparency=at=="Dropdown"and 0.2 or 0}
):Play()
end
end

aI.UIElements.TabItem.Active=true
aI.Locked=false
end
end
end
end

function au.Refresh(aF,aG)
if aq.Window.Destroyed then
return
end

for aH,aI in next,ar.Tabs do
if aI.UIElements and aI.UIElements.TabItem then
aI.UIElements.TabItem:Destroy()
end
end

for aH,aI in next,ar.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not aI:IsA"UIListLayout"then
aI:Destroy()
end
end

ar.Tabs={}

if ar.SearchBarEnabled then
if not aB then
aB=CreateSearchBar()
elseif aD then
aD.PlaceholderText=ar.SearchPlaceholder
end
end

for aH,aI in next,aG do
if typeof(aI)~="table"or aI.Type~="Divider"then
local aJ={
Name=typeof(aI)=="table"and aI.Title or aI,
Desc=typeof(aI)=="table"and aI.Desc or nil,
Icon=typeof(aI)=="table"and aI.Icon or nil,
IconSize=typeof(aI)=="table"and aI.IconSize or nil,
Original=aI,
Selected=false,
Locked=typeof(aI)=="table"and aI.Locked or false,
UIElements={},
}
local aK
if aJ.Icon then
aK=al.Image(aJ.Icon,aJ.Icon,0,aq.Window.Folder,"Dropdown",true)
aK.Size=
UDim2.new(0,aJ.IconSize or as.TabIcon,0,aJ.IconSize or as.TabIcon)
aK.ImageLabel.ImageTransparency=at=="Dropdown"and 0.2 or 0
aJ.UIElements.TabIcon=aK
end
aJ.UIElements.TabItem=al.NewRoundFrame(
as.MenuCorner-as.MenuPadding,
"Squircle",
{
Size=UDim2.new(1,0,0,ar.ItemHeight),
AutomaticSize=aJ.Desc and"Y",
LayoutOrder=typeof(aH)=="number"and aH or 0,
ImageTransparency=1,
Parent=ar.UIElements.Menu.Frame.ScrollingFrame,

ThemeTag={
ImageColor3="DropdownTabBackground",
},
Active=not aJ.Locked,
},
{
al.NewRoundFrame(as.MenuCorner-as.MenuPadding,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="DropdownTabBorder",
},
ImageTransparency=1,
Name="Highlight",
},{













}),
an("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
an("UIListLayout",{
Padding=UDim.new(0,as.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
an("UIPadding",{
PaddingTop=UDim.new(0,as.TabPadding),
PaddingLeft=UDim.new(0,as.TabPadding),
PaddingRight=UDim.new(0,as.TabPadding),
PaddingBottom=UDim.new(0,as.TabPadding),
}),
an("UICorner",{
CornerRadius=UDim.new(0,as.MenuCorner-as.MenuPadding),
}),
aK,
an("Frame",{
Size=UDim2.new(1,aK and-as.TabPadding-as.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
an("TextLabel",{
Text=aJ.Name,
TextXAlignment="Left",
FontFace=Font.new(al.Font),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=14,
BackgroundTransparency=1,
TextTransparency=at=="Dropdown"and 0.4 or 0.05,
LayoutOrder=999,
AutomaticSize="Y",
TextTruncate="AtEnd",
Size=UDim2.new(1,0,0,0),
}),
an("TextLabel",{
Text=aJ.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(al.Font),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=13,
BackgroundTransparency=1,
TextTransparency=at=="Dropdown"and 0.6 or 0.35,
LayoutOrder=999,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=aJ.Desc and true or false,
Name="Desc",
}),
an("UIListLayout",{
Padding=UDim.new(0,as.TabPadding/3),
FillDirection="Vertical",
}),
}),
}),
},
true
)
aJ.Size=aJ.UIElements.TabItem.Size
aJ.AutomaticSize=aJ.UIElements.TabItem.AutomaticSize

if aJ.Locked then
aJ.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if aJ.UIElements.TabIcon then
aJ.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if ar.Multi and typeof(ar.Value)=="string"then
for aL,aM in next,ar.Values do
if typeof(aM)=="table"then
if aM.Title==ar.Value then
ar.Value={aM}
end
else
if aM==ar.Value then
ar.Value={ar.Value}
end
end
end
end

if ar.Multi then
local aL=false
if typeof(ar.Value)=="table"then
for aM,aN in ipairs(ar.Value)do
local aO=typeof(aN)=="table"and aN.Title or aN
if aO==aJ.Name then
aL=true
break
end
end
end
aJ.Selected=aL
else
local aL=typeof(ar.Value)=="table"and ar.Value.Title or ar.Value
aJ.Selected=aL==aJ.Name
end

if aJ.Selected and not aJ.Locked then
aJ.UIElements.TabItem.ImageTransparency=ap

aJ.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if aJ.UIElements.TabIcon then
aJ.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

ar.Tabs[aH]=aJ

au:Display()

if at=="Dropdown"then
al.AddSignal(aJ.UIElements.TabItem.MouseButton1Click,function()
if ar.Locked or aJ.Locked then
return
end

if ar.Multi then
if not aJ.Selected then
aJ.Selected=true
ao(
aJ.UIElements.TabItem,
0.1,
{ImageTransparency=ap}
):Play()

ao(aJ.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aJ.UIElements.TabIcon then
ao(aJ.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(ar.Value,aJ.Original)
else
if not ar.AllowNone and#ar.Value==1 then
return
end
aJ.Selected=false
ao(aJ.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

ao(aJ.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.4}):Play()
if aJ.UIElements.TabIcon then
ao(aJ.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end

for aL,aM in next,ar.Value do
if typeof(aM)=="table"and(aM.Title==aJ.Name)or(aM==aJ.Name)then
table.remove(ar.Value,aL)
break
end
end
end
else
for aL,aM in next,ar.Tabs do
ao(aM.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

ao(
aM.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=0.4}
):Play()
if aM.UIElements.TabIcon then
ao(aM.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end
aM.Selected=false
end
aJ.Selected=true
ao(aJ.UIElements.TabItem,0.1,{ImageTransparency=ap}):Play()

ao(aJ.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aJ.UIElements.TabIcon then
ao(aJ.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
ar.Value=aJ.Original
end
Callback()
if not ar.Multi then
au:Close()
end
end)
elseif at=="Menu"then
if not aJ.Locked then
al.AddSignal(aJ.UIElements.TabItem.MouseEnter,function()
ao(aJ.UIElements.TabItem,0.08,{ImageTransparency=ap}):Play()
end)
al.AddSignal(aJ.UIElements.TabItem.InputEnded,function()
ao(aJ.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()
end)
end
al.AddSignal(aJ.UIElements.TabItem.MouseButton1Click,function()
if ar.Locked or aJ.Locked then
return
end
Callback(aI.Callback or function()end)
au:Close()
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.load'S'
:New{Parent=ar.UIElements.Menu.Frame.ScrollingFrame}
end
end










ApplyCanvasWidth()
aE(aC)
Callback()

ar.Values=aG
end

au:Refresh(ar.Values)

function au.Select(aF,aG)
if aG then
ar.Value=aG
else
if ar.Multi then
ar.Value={}
else
ar.Value=nil
end
end
au:Refresh(ar.Values)
end

RecalculateListSize()
RecalculateCanvasSize()

local aF=0
local aG="Down"

function au.Open(aH)
if not ar.Locked then
aF+=1
local aI=aF
ar.UIElements.Menu.Visible=true
ar.UIElements.MenuCanvas.Visible=true
ar.UIElements.MenuCanvas.Active=true
RecalculateListSize()
RecalculateCanvasSize()
aG=UpdatePosition()
local aJ=aG=="Left"or aG=="Right"
if ar.Centered then
ar.UIElements.Menu.Size=UDim2.fromScale(1,1)
ar.UIElements.MenuScale.Scale=0.9
am.Play(
ar.UIElements.MenuScale,
"DropdownOpen",
{Scale=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"CenterScale"
)
if ar.UIElements.Backdrop then
ar.UIElements.Backdrop.Visible=true
ar.UIElements.Backdrop.BackgroundTransparency=1
am.Play(ar.UIElements.Backdrop,"DropdownOpen",{
BackgroundTransparency=ar.BackdropTransparency,
},nil,nil,"Backdrop")
end
else
ar.UIElements.Menu.Size=aJ and UDim2.new(0,0,1,0)or UDim2.new(1,0,0,0)
end
am.Play(ar.UIElements.Menu,"DropdownOpen",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=ar.Glass and ar.GlassTransparency or 0,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out,"OpenClose")

task.spawn(function()
task.wait(am.GetDuration"DropdownOpen")
if ar.Locked or aF~=aI then
return
end
ar.Opened=true
end)

UpdatePosition()
end
end

function au.Close(aH)
aF+=1
local aI=aF
ar.Opened=false

local aJ=aG=="Left"or aG=="Right"
local aK=if ar.Centered
then UDim2.fromScale(1,1)
else aJ and UDim2.new(0,0,1,0)or UDim2.new(1,0,0,0)
am.Play(ar.UIElements.Menu,"DropdownClose",{
Size=aK,
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out,"OpenClose")
if ar.Centered then
am.Play(ar.UIElements.MenuScale,"DropdownClose",{Scale=0.92},nil,nil,"CenterScale")
if ar.UIElements.Backdrop then
am.Play(
ar.UIElements.Backdrop,
"DropdownClose",
{BackgroundTransparency=1},
nil,
nil,
"Backdrop"
)
end
end

task.spawn(function()
task.wait(am.GetDuration"DropdownClose")
if aF~=aI then
return
end
ar.UIElements.Menu.Visible=false
ar.UIElements.MenuCanvas.Visible=false
ar.UIElements.MenuCanvas.Active=false
if ar.UIElements.Backdrop then
ar.UIElements.Backdrop.Visible=false
end
end)
end

if ar.UIElements.Backdrop then
al.AddSignal(ar.UIElements.Backdrop.MouseButton1Click,function()
au:Close()
end)
end

al.AddSignal(
(
ar.UIElements.Dropdown and ar.UIElements.Dropdown.MouseButton1Click
or ar.DropdownFrame.UIElements.Main.MouseButton1Click
),
function()
if ar.Opened or ar.UIElements.MenuCanvas.Visible then
au:Close()
else
au:Open()
end
end
)

table.insert(
aA,
al.AddSignal(ag.InputBegan,function(aH)
if
aH.UserInputType==Enum.UserInputType.MouseButton1
or aH.UserInputType==Enum.UserInputType.Touch
then
local aI=ar.UIElements.MenuCanvas
local aJ=ar.UIElements.Dropdown or ar.DropdownFrame.UIElements.Main
local aK=GetInputPosition(aH)
local aL=ContainsPoint(aJ,aK)
local aM=ContainsPoint(aI,aK)

if
aq.Window.CanDropdown
and(ar.Opened or aI.Visible)
and not aL
and not aM
then
au:Close()
end
end
end)
)

table.insert(
aA,
al.AddSignal(
ar.UIElements.Dropdown and ar.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"
or ar.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)
)

if typeof(az)=="Instance"and az:IsA"GuiObject"then
table.insert(
aA,
al.AddSignal(az:GetPropertyChangedSignal"AbsoluteSize",function()
if ar.UIElements.MenuCanvas.Visible then
RecalculateListSize()
UpdatePosition()
end
end)
)
end

function au.Destroy(aH)
aF+=1
ar.Opened=false

for aI,aJ in aA do
aJ:Disconnect()
end
table.clear(aA)

if ar.UIElements.Backdrop then
ar.UIElements.Backdrop:Destroy()
ar.UIElements.Backdrop=nil
end
if ar.UIElements.MenuCanvas then
ar.UIElements.MenuCanvas:Destroy()
end
end

return au
end

return aa end function a.U()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local af=
aa(game:GetService"Workspace").CurrentCamera

local ag=a.load'd'
local ah=ag.New local ai=
ag.Tween

local aj=a.load'y'.New local ak=a.load'o'
.New
local al=a.load'T'.New local am=

workspace.CurrentCamera

local an={
UICorner=10,
UIPadding=12,
MenuCorner=14,
MenuPadding=4,
TabPadding=8,
SearchBarHeight=36,
TabIcon=16,
ItemHeight=32,
}

function an.New(ao,ap)
local aq=ap.Values or{}
local ar=ap.SearchBarEnabled
if ar==nil then
if ap.Search~=nil then
ar=ap.Search
elseif ap.EnableSearch~=nil then
ar=ap.EnableSearch
else
ar=#aq>=(ap.SearchThreshold or 7)
end
end

local as=ap.Compact~=false
local at=string.lower(tostring(ap.Placement or ap.MenuPlacement or ap.Mode or""))
local au=string.lower(tostring(ap.Direction or ap.OpenDirection or""))
local av=ap.Centered==true
or ap.Modal==true
or at=="center"
or at=="middle"
or au=="center"
or au=="middle"

local aw={
__type="Dropdown",
Title=ap.Title or"Dropdown",
Desc=ap.Desc or nil,
Locked=ap.Locked or false,
LockedTitle=ap.LockedTitle,
Values=aq,
MenuWidth=ap.MenuWidth or(av and 236 or(as and 164 or 180)),
MenuMaxWidth=ap.MenuMaxWidth,
MenuMaxHeight=ap.MenuMaxHeight or(av and 240 or nil),
FullWidth=ap.FullWidth or ap.Full or ap.Mode=="Full"or ap.MenuMode=="Full",
Direction=av and"Center"or(ap.Direction or ap.OpenDirection or"Auto"),
Side=ap.Side or ap.Align or ap.Alignment or"Right",
MobileDirection=ap.MobileDirection or ap.MobileOpenDirection,
MobileSide=ap.MobileSide or ap.MobileAlign,
Centered=av,
CenterTarget=ap.CenterTarget or ap.CenterIn or"Window",
CenterOffset=typeof(ap.CenterOffset)=="Vector2"and ap.CenterOffset or Vector2.new(0,0),
Backdrop=av and ap.Backdrop~=false,
BackdropTransparency=ag.ClampTransparency(ap.BackdropTransparency,0.84),
Value=ap.Value,
AllowNone=ap.AllowNone,
SearchBarEnabled=ar==true,
SearchPlaceholder=ap.SearchPlaceholder or"Search...",
Compact=as,
Glass=ap.Glass==true,
GlassTransparency=ap.GlassTransparency or ap.MenuTransparency or 0,
ItemHeight=ap.ItemHeight or(as and an.ItemHeight or 36),
Multi=ap.Multi,
Callback=ap.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=ap.Width or(as and 136 or 150),
}

if aw.Multi and not aw.Value then
aw.Value={}
end
if aw.Values and typeof(aw.Value)=="number"then
aw.Value=aw.Values[aw.Value]
end

aw.DropdownFrame=a.load'I'{
Title=aw.Title,
Desc=aw.Desc,
Parent=ap.Parent,
TextOffset=aw.Callback and aw.Width or 20,
Hover=not aw.Callback and true or false,
Tab=ap.Tab,
Index=ap.Index,
Window=ap.Window,
ElementTable=aw,
ParentConfig=ap,
Tags=ap.Tags,
}

if aw.Callback then
aw.UIElements.Dropdown=
aj("",nil,aw.DropdownFrame.UIElements.Main,nil,ap.Window.NewElements and 12 or 10)

aw.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
aw.UIElements.Dropdown.Frame.Frame.TextLabel.Size=
UDim2.new(1,aw.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

aw.UIElements.Dropdown.Size=UDim2.new(0,aw.Width,0,as and 32 or 36)
aw.UIElements.Dropdown.Position=UDim2.new(1,0,ap.Window.NewElements and 0 or 0.5,0)
aw.UIElements.Dropdown.AnchorPoint=Vector2.new(1,ap.Window.NewElements and 0 or 0.5)





end

aw.DropdownMenu=al(ap,aw,an,"Dropdown")

aw.Display=aw.DropdownMenu.Display
aw.Refresh=aw.DropdownMenu.Refresh
aw.Select=aw.DropdownMenu.Select
aw.Open=aw.DropdownMenu.Open
aw.Close=aw.DropdownMenu.Close
function aw.Cleanup(ax)
aw.DropdownMenu:Destroy()
end

ah("ImageLabel",{
Image=ag.Icon"chevrons-up-down"[1],
ImageRectOffset=ag.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ag.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,aw.UIElements.Dropdown and-12 or 0,0.5,0),
ThemeTag={
ImageColor3="Icon",
},
AnchorPoint=Vector2.new(1,0.5),
Parent=aw.UIElements.Dropdown and aw.UIElements.Dropdown.Frame
or aw.DropdownFrame.UIElements.Main,
})

function aw.Lock(ax)
aw.Locked=true
if aw.Opened or aw.UIElements.MenuCanvas.Visible then
aw:Close()
end
return aw.DropdownFrame:Lock(aw.LockedTitle)
end
function aw.Unlock(ax)
aw.Locked=false
return aw.DropdownFrame:Unlock()
end

if aw.Locked then
aw:Lock()
end

return aw.__type,aw
end

return an end function a.V()




local aa={}
local ag={
lua={
"and",
"break",
"or",
"else",
"elseif",
"if",
"then",
"until",
"repeat",
"while",
"do",
"for",
"in",
"end",
"local",
"return",
"function",
"export",
},
rbx={
"game",
"workspace",
"script",
"math",
"string",
"table",
"task",
"wait",
"select",
"next",
"Enum",
"tick",
"assert",
"shared",
"loadstring",
"tonumber",
"tostring",
"type",
"typeof",
"unpack",
"Instance",
"CFrame",
"Vector3",
"Vector2",
"Color3",
"UDim",
"UDim2",
"Ray",
"BrickColor",
"OverlapParams",
"RaycastParams",
"Axes",
"Random",
"Region3",
"Rect",
"TweenInfo",
"collectgarbage",
"not",
"utf8",
"pcall",
"xpcall",
"_G",
"setmetatable",
"getmetatable",
"os",
"pairs",
"ipairs",
},
operators={
"#",
"+",
"-",
"*",
"%",
"/",
"^",
"=",
"~",
"=",
"<",
">",
},
}

local ah={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(aj)
local al={}
for am,an in ipairs(aj)do
al[an]=true
end
return al
end

local aj=createKeywordSet(ag.lua)
local al=createKeywordSet(ag.rbx)
local am=createKeywordSet(ag.operators)

local function getHighlight(an,ao)
local ap=an[ao]

if ah[ap.."_color"]then
return ah[ap.."_color"]
end

if tonumber(ap)then
return ah.numbers
elseif ap=="nil"then
return ah.null
elseif ap:sub(1,2)=="--"then
return ah.comment
elseif am[ap]then
return ah.operator
elseif aj[ap]then
return ah.lua
elseif al[ap]then
return ah.rbx
elseif ap:sub(1,1)=='"'or ap:sub(1,1)=="'"then
return ah.str
elseif ap=="true"or ap=="false"then
return ah.boolean
end

if an[ao+1]=="("then
if an[ao-1]==":"then
return ah.self_call
end

return ah.call
end

if an[ao-1]=="."then
if an[ao-2]=="Enum"then
return ah.rbx
end

return ah.local_property
end
end

function aa.run(an,ao)
if ao~=nil then
for ap,aq in next,ao do
ah[ap]=aq
end
end

local ap={}
local aq=""

local ar=false
local as=false
local at=false

for au=1,#an do
local av=an:sub(au,au)

if as then
if av=="\n"and not at then
table.insert(ap,aq)
table.insert(ap,av)
aq=""

as=false
elseif an:sub(au-1,au)=="]]"and at then
aq=aq.."]"

table.insert(ap,aq)
aq=""

as=false
at=false
else
aq=aq..av
end
elseif ar then
if av==ar and an:sub(au-1,au-1)~="\\"or av=="\n"then
aq=aq..av
ar=false
else
aq=aq..av
end
else
if an:sub(au,au+1)=="--"then
table.insert(ap,aq)
aq="-"
as=true
at=an:sub(au+2,au+3)=="[["
elseif av=='"'or av=="'"then
table.insert(ap,aq)
aq=av
ar=av
elseif am[av]then
table.insert(ap,aq)
table.insert(ap,av)
aq=""
elseif av:match"[%w_]"then
aq=aq..av
else
table.insert(ap,aq)
table.insert(ap,av)
aq=""
end
end
end

table.insert(ap,aq)

local au={}

for av,aw in ipairs(ap)do
local ax=getHighlight(ap,av)

if ax then
local ay=string.format(
'<font color = "#%s">%s</font>',
ax:ToHex(),
aw:gsub("<","&lt;"):gsub(">","&gt;")
)

table.insert(au,ay)
else
table.insert(au,aw)
end
end

return table.concat(au)
end

return aa end function a.W()

local aa={}

local ag=a.load'd'
local ah=ag.New
local aj=ag.Tween

local al=a.load'V'

function aa.New(am,an,ao,ap,aq)
local ar={
Radius=an.ElementConfig.UICorner,
Padding=an.NewElements and an.ElementConfig.UIPadding+4 or an.ElementConfig.UIPadding,

CodeFrame=nil,
}

local as=ah("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=am.CodeSize,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ah("UIPadding",{
PaddingTop=UDim.new(0,ar.Padding+3),
PaddingLeft=UDim.new(0,ar.Padding+3),
PaddingRight=UDim.new(0,ar.Padding+3),
PaddingBottom=UDim.new(0,ar.Padding+3),
}),
})
as.Font="Code"

local at=ah("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize=am.Height~=nil and"XY"or"X",
ScrollingDirection=am.Height~=nil and"XY"or"X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
as,
})

local au=am.CanCopied
and ah("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,35,0,35),
Position=UDim2.new(1,-ar.Padding/2,0,ar.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=ap and true or false,
},{
ag.NewRoundFrame(ar.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
ah("UIScale",{
Scale=1,
}),
ah("ImageLabel",{
Image=ag.Icon"copy"[1],
ImageRectSize=ag.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ag.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=0.1,
}),
}),
})
or nil

local av,aw=ag.NewRoundFrame(ar.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=0.955,
Visible=false,
})

local ax,ay=ag.NewRoundFrame(ar.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=0.96,
Size=UDim2.new(1,0,0,20+(ar.Padding*2)),
Visible=am.Title and true or false,
},{










ah("TextLabel",{
Text=am.Title,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=0.2,
TextSize=18,
AutomaticSize="Y",
FontFace=Font.new(ag.Font),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,au and-20-(ar.Padding*2),0,0),
}),
ah("UIPadding",{

PaddingLeft=UDim.new(0,ar.Padding+3),
PaddingRight=UDim.new(0,ar.Padding+3),

}),
ah("UIListLayout",{
Padding=UDim.new(0,ar.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local az,aA=ag.NewRoundFrame(ar.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=0.035,
Size=am.Height~=nil
and UDim2.new(1,0,am.Height.Scale,am.Height.Offset==0 and-40 or am.Height.Offset)
or UDim2.new(1,0,0,20+(ar.Padding*2)),
AutomaticSize=am.Height~=nil and"None"or"Y",
Parent=ao,
},{
av,
ah("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,am.Height~=nil and 1 or 0,0),
AutomaticSize=am.Height~=nil and"None"or"Y",
},{
ax,
at,
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
au,
},nil,true)

ar.CodeFrame=az
ar.CodeFrameModule=aA
ar.OutlineFrame=av
ar.OutlineFrameModule=aw
ar.TopbarFrame=ax
ar.TopbarFrameModule=ay

ag.AddSignal(as:GetPropertyChangedSignal"TextBounds",function()
if am.Height~=nil then
at.Size=UDim2.new(1,0,1,am.Title~=nil and-(20+(ar.Padding*2))or nil)
else
at.Size=
UDim2.new(1,0,0,(as.TextBounds.Y/(aq or 1))+((ar.Padding+3)*2))
end
end)

function ar.Set(aB)
as.Text=al.run(aB,am.CodeTheme)
end

function ar.Destroy()
az:Destroy()
ar=nil
end

ar.Set(am.Code)

if au then
ag.AddSignal(au.InputBegan,function(aB:InputObject)
if
aB.UserInputType==Enum.UserInputType.MouseButton1
or aB.UserInputType==Enum.UserInputType.Touch
then
aj(au.Button,0.05,{ImageTransparency=0.95}):Play()
aj(au.Button.UIScale,0.05,{Scale=0.9}):Play()
end
end)
ag.AddSignal(au.InputEnded,function()
aj(au.Button,0.08,{ImageTransparency=1}):Play()
aj(au.Button.UIScale,0.08,{Scale=1}):Play()
end)
ag.AddSignal(au.MouseButton1Click,function()
if ap then
ap()
local aB=ag.Icon"check"
au.Button.ImageLabel.Image=aB[1]
au.Button.ImageLabel.ImageRectSize=aB[2].ImageRectSize
au.Button.ImageLabel.ImageRectOffset=aB[2].ImageRectPosition

task.delay(1,function()
local aC=ag.Icon"copy"
au.Button.ImageLabel.Image=aC[1]
au.Button.ImageLabel.ImageRectSize=aC[2].ImageRectSize
au.Button.ImageLabel.ImageRectOffset=aC[2].ImageRectPosition
end)
end
end)
end

return ar
end

return aa end function a.X()

local aa=a.load'd'local ag=
aa.New


local ah=a.load'W'

local aj={}

function aj.New(al,am)
local an={
__type="Code",
Title=am.Title,
Code=am.Code,
CodeSize=am.CodeSize or 18,
Height=am.Height,
CodeTheme=am.CodeTheme,
Locked=false,
CanCopied=am.CanCopied~=false,
OnCopy=am.OnCopy,
LinkCorners=am.LinkCorners,
CornerGroup=am.CornerGroup or am.LinkCornerGroup,
CornerBreak=am.CornerBreak,
CornerBreakBefore=am.CornerBreakBefore,
CornerBreakAfter=am.CornerBreakAfter,

Index=am.Index,
}

local ao=not an.Locked











local ap=ah.New(an,am.Window,am.Parent,function()
if ao then
local ap=an.Title or"code"
local aq,ar=pcall(function()
if toclipboard then
toclipboard(an.Code)
end
if setclipboard then
setclipboard(an.Code)
end

if an.OnCopy then
an.OnCopy()
end
end)
if not aq then
am.WindUI:Notify{
Title="Error",
Content="The "..ap.." is not copied. Error: "..ar,
Icon="x",
Style="Error",
Duration=5,
}
end
end
end,am.WindUI.UIScale)

function an.SetCode(aq,ar)
ap.Set(ar)
an.Code=ar
end

function an.Set(aq,ar)
return an.SetCode(ar)
end

function an.Destroy(aq)
ap.Destroy()
an=nil
end

function an.UpdateShape(aq)
if am.Window.NewElements then
local ar=am.Window.ElementConfig.LinkCorners or am.LinkCorners==true
local as="Squircle"

if ar then
as=aa.GetLinkedCornerShape(
aq.Elements,
an.Index,
aq,
am.ParentType,
am.CornerLink
or(am.ParentConfig and am.ParentConfig.CornerLink)
or am.Window.ElementConfig.CornerLink
)
end

if as and ap.CodeFrameModule then
local at=(as=="Squircle-TL-BL"or as=="Squircle-TR-BR")and"Squircle"
or as

ap.CodeFrameModule:SetType(at)

ap.TopbarFrameModule:SetType(
table.find({"Squircle-BL-BR","SquircleH-BL-BR","Squircle-TR-BR"},as)~=nil and"Square"
or at
)
end
end
end

an.UIElements={Main=ap.CodeFrame}
an.ElementFrame=ap.CodeFrame

return an.__type,an
end

return aj end function a.Y()

local aa=a.load'd'
local ag=aa.New local ah=
aa.Tween

local aj=(cloneref or clonereference or function(aj)
return aj
end)

local al=aj(game:GetService"UserInputService")
aj(game:GetService"TouchInputService")
local am=aj(game:GetService"RunService")
local an=aj(game:GetService"Players")local ao=

am.RenderStepped
local ap=an.LocalPlayer
local aq=ap:GetMouse()

local ar=a.load'n'.New
local as=a.load'o'.New

local at={
UICorner=9,

}

local au

function at.Colorpicker(av,aw,ax,ay,az)
local aA={
__type="Colorpicker",
Title=aw.Title,
Desc=aw.Desc,
Default=aw.Value or aw.Default,
Callback=aw.Callback,
Transparency=aw.Transparency,
UIElements=aw.UIElements,

TextPadding=10,
}

local aB={}
local aC=aA.Transparency~=nil

function aA.SetHSVFromRGB(aD,aE)
local aF,aG,aH=Color3.toHSV(aE)
aA.Hue=aF
aA.Sat=aG
aA.Vib=aH
end

aA:SetHSVFromRGB(aA.Default)

local aD=a.load'p'
local aE=aD.Create(nil,"Dialog",ax,ay,ax.UIElements.Main.Main)

aA.ColorpickerFrame=aE

aE.UIElements.Main.Size=UDim2.new(1,0,0,0)



local aF,aG,aH=aA.Hue,aA.Sat,aA.Vib

aA.UIElements.Title=ag("TextLabel",{
Text=aA.Title,
TextSize=20,
FontFace=Font.new(aa.Font),
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=aE.UIElements.Main,
},{
ag("UIPadding",{
PaddingTop=UDim.new(0,aA.TextPadding/2),
PaddingLeft=UDim.new(0,aA.TextPadding/2),
PaddingRight=UDim.new(0,aA.TextPadding/2),
PaddingBottom=UDim.new(0,aA.TextPadding/2),
}),
})





local aI=ag("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local aJ=ag("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=aI,
BackgroundColor3=aA.Default,
},{
ag("UIStroke",{
Thickness=2,
Transparency=0.1,
ThemeTag={
Color="Text",
},
}),
ag("UICorner",{
CornerRadius=UDim.new(1,0),
}),
})

aA.UIElements.SatVibMap=ag("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+aA.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(aF,1,1),
BackgroundTransparency=0,
Parent=aE.UIElements.Main,
},{
ag("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.85,
ZIndex=99999,
},{
ag("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
},
}),
}),

aJ,
})

aA.UIElements.Inputs=ag("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(
aC and 240 or 210,
40+aA.TextPadding
),
BackgroundTransparency=1,
Parent=aE.UIElements.Main,
},{
ag("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
}),
})





local aK=ag("Frame",{
BackgroundColor3=aA.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=aA.Transparency,
},{
ag("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ag("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+aA.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=aE.UIElements.Main,
},{
ag("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.85,
ZIndex=99999,
},{
ag("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
},
}),
}),







aK,
})

local aL=ag("Frame",{
BackgroundColor3=aA.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ag("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ag("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+aA.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=aE.UIElements.Main,
},{
ag("UICorner",{
CornerRadius=UDim.new(0,8),
}),







aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.85,
ZIndex=99999,
},{
ag("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
},
}),
}),
aL,
})

local aM={}

for aN=0,1,0.1 do
table.insert(aM,ColorSequenceKeypoint.new(aN,Color3.fromHSV(aN,1,1)))
end

local aN=ag("UIGradient",{
Color=ColorSequence.new(aM),
Rotation=90,
})

local aO=ag("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=aI,


BackgroundColor3=aA.Default,
},{
ag("UIStroke",{
Thickness=2,
Transparency=0.1,
ThemeTag={
Color="Text",
},
}),
ag("UICorner",{
CornerRadius=UDim.new(1,0),
}),
})

local aP=ag("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+aA.TextPadding),
Parent=aE.UIElements.Main,
},{
ag("UICorner",{
CornerRadius=UDim.new(1,0),
}),
aN,
aI,
})

local function CreateNewInput(aQ,aR)
local aS=as(aQ,nil,aA.UIElements.Inputs,nil,nil,nil,nil,nil,true)

ag("TextLabel",{
BackgroundTransparency=1,
TextTransparency=0.4,
TextSize=17,
FontFace=Font.new(aa.Font),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=aS.Frame,
Text=aQ,
})

ag("UIScale",{
Parent=aS,
Scale=0.85,
})

aS.Frame.Frame.TextBox.Text=aR
aS.Size=UDim2.new(0,150,0,42)

return aS
end

local function ToRGB(aQ)
return{
R=math.floor(aQ.R*255),
G=math.floor(aQ.G*255),
B=math.floor(aQ.B*255),
}
end

local aQ=CreateNewInput("Hex","#"..aA.Default:ToHex())

local aR=CreateNewInput("Red",ToRGB(aA.Default).R)
local aS=CreateNewInput("Green",ToRGB(aA.Default).G)
local aT=CreateNewInput("Blue",ToRGB(aA.Default).B)
local aU
if aC then
aU=CreateNewInput("Alpha",((1-aA.Transparency)*100).."%")
end

local aV=ag("Frame",{
Size=UDim2.new(0,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+aA.TextPadding),
BackgroundTransparency=1,
Parent=aE.UIElements.Main,
LayoutOrder=4,
},{
ag("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

aa.AddSignal(aE.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",function()
aA.UIElements.Title.Size=UDim2.new(
0,
aE.UIElements.Main.AbsoluteSize.X/aw.UIScale-(aE.UIPadding*2),
0,
0
)
aV.Size=UDim2.new(
0,
aE.UIElements.Main.AbsoluteSize.X/aw.UIScale-aE.UIPadding*2,
0,
40
)
end)

local aW={
{
Title="Cancel",
Variant="Secondary",
Callback=function()
aw.IsShowed=false
for aW,aX in next,aB do
aX:Disconnect()
end
aB={}
end,
},
{
Title="Apply",

Variant="Primary",
Callback=function()
aw.IsShowed=false
for aW,aX in next,aB do
aX:Disconnect()
end
aB={}

az(Color3.fromHSV(aA.Hue,aA.Sat,aA.Vib),aA.Transparency)
end,
},
}

for aX,aY in next,aW do
local aZ=ar(
aY.Title,
aY.Icon,
aY.Callback,
aY.Variant,
aV,
aE,
true
)
aZ.Size=UDim2.new(0.5,-3,0,40)
aZ.AutomaticSize="None"
end

local aX,aY,aZ
if aC then
local a_=ag("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

aY=ag("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=a_,
},{
ag("UIStroke",{
Thickness=2,
Transparency=0.1,
ThemeTag={
Color="Text",
},
}),
ag("UICorner",{
CornerRadius=UDim.new(1,0),
}),
})

aZ=ag("Frame",{
Size=UDim2.fromScale(1,1),
},{
ag("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ag("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

aX=ag("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+aA.TextPadding),
Parent=aE.UIElements.Main,
BackgroundTransparency=1,
},{
ag("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ag("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ag("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
aZ,
a_,
})
end

function aA.Round(a_,a0,a1)
if a1==0 then
return math.floor(a0)
end
a0=tostring(a0)
return a0:find"%."and tonumber(a0:sub(1,a0:find"%."+a1))or a0
end

function aA.Update(a_,a0,a1)
if a0 then
aF,aG,aH=Color3.toHSV(a0)
else
aF,aG,aH=aA.Hue,aA.Sat,aA.Vib
end

aA.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(aF,1,1)
aJ.Position=UDim2.new(aG,0,1-aH,0)
aJ.BackgroundColor3=Color3.fromHSV(aF,aG,aH)
aL.BackgroundColor3=Color3.fromHSV(aF,aG,aH)
aO.BackgroundColor3=Color3.fromHSV(aF,1,1)
aO.Position=UDim2.new(0.5,0,aF,0)

aQ.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(aF,aG,aH):ToHex()
aR.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(aF,aG,aH)).R
aS.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(aF,aG,aH)).G
aT.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(aF,aG,aH)).B

if a1 or aC then
aL.BackgroundTransparency=aA.Transparency or a1
aZ.BackgroundColor3=Color3.fromHSV(aF,aG,aH)
aY.BackgroundColor3=Color3.fromHSV(aF,aG,aH)
aY.BackgroundTransparency=aA.Transparency or a1
aY.Position=UDim2.new(0.5,0,1-aA.Transparency or a1,0)
aU.Frame.Frame.TextBox.Text=aA:Round(
(1-aA.Transparency or a1)*100,
0
).."%"
end
end

aA:Update(aA.Default,aA.Transparency)

local function GetRGB()
local a_=Color3.fromHSV(aA.Hue,aA.Sat,aA.Vib)
return{R=math.floor(a_.r*255),G=math.floor(a_.g*255),B=math.floor(a_.b*255)}
end



local function clamp(a_,a0,a1)
return math.clamp(tonumber(a_)or 0,a0,a1)
end

table.insert(
aB,
aa.AddSignal(aQ.Frame.Frame.TextBox.FocusLost,function(a_)
if a_ then
local a0=aQ.Frame.Frame.TextBox.Text:gsub("#","")
local a1,a2=pcall(Color3.fromHex,a0)
if a1 and typeof(a2)=="Color3"then
aA.Hue,aA.Sat,aA.Vib=Color3.toHSV(a2)
aA:Update()
aA.Default=a2
end
end
end)
)

local function updateColorFromInput(a_,a0)
aa.AddSignal(a_.Frame.Frame.TextBox.FocusLost,function(a1)
if a1 then
local a2=a_.Frame.Frame.TextBox
local a3=GetRGB()
local a4=clamp(a2.Text,0,255)
a2.Text=tostring(a4)

a3[a0]=a4
local a5=Color3.fromRGB(a3.R,a3.G,a3.B)
aA.Hue,aA.Sat,aA.Vib=Color3.toHSV(a5)
aA:Update()
end
end)
end

updateColorFromInput(aR,"R")
updateColorFromInput(aS,"G")
updateColorFromInput(aT,"B")

if aC then
aa.AddSignal(aU.Frame.Frame.TextBox.FocusLost,function(a_)
if a_ then
local a0=aU.Frame.Frame.TextBox
local a1=clamp(a0.Text,0,100)
a0.Text=tostring(a1)

aA.Transparency=1-a1*0.01
aA:Update(nil,aA.Transparency)
end
end)
end



local function UpdateSatVib(a_,a0)
local a1=a_.AbsolutePosition.X
local a2=a1+a_.AbsoluteSize.X
local a3=a_.AbsolutePosition.Y
local a4=a3+a_.AbsoluteSize.Y

local a5=math.clamp(aq.X,a1,a2)
local a6=math.clamp(aq.Y,a3,a4)

a0.Sat=(a5-a1)/(a2-a1)
a0.Vib=1-((a6-a3)/(a4-a3))

a0:Update()
end

local function UpdateHue(a_,a0)
local a1=a_.AbsolutePosition.Y
local a2=a1+a_.AbsoluteSize.Y

local a3=math.clamp(aq.Y,a1,a2)

a0.Hue=(a3-a1)/(a2-a1)

a0:Update()
end

local function UpdateTransparency(a_,a0)
local a1=a_.AbsolutePosition.Y
local a2=a1+a_.AbsoluteSize.Y

local a3=math.clamp(aq.Y,a1,a2)

a0.Transparency=1-((a3-a1)/(a2-a1))

a0:Update()
end

local a_=ay.GenerateGUID()

table.insert(
aB,
al.InputChanged:Connect(function(a0)
if
a0.UserInputType~=Enum.UserInputType.MouseMovement
and a0.UserInputType~=Enum.UserInputType.Touch
then
return
end

if au=="SatVib"then
UpdateSatVib(aA.UIElements.SatVibMap,aA)
elseif au=="Hue"then
UpdateHue(aP,aA)
elseif au=="Transparency"then
UpdateTransparency(aX,aA)
end
end)
)

table.insert(
aB,
aA.UIElements.SatVibMap.InputBegan:Connect(function(a0)
if
a0.UserInputType~=Enum.UserInputType.MouseButton1
and a0.UserInputType~=Enum.UserInputType.Touch
then
return
end

if ay.CurrentInput and ay.CurrentInput~=a_ then
return
end
ay.CurrentInput=a_

if au and au~="SatVib"then
return
end

au="SatVib"

UpdateSatVib(aA.UIElements.SatVibMap,aA)
end)
)

table.insert(
aB,
aP.InputBegan:Connect(function(a0)
if
a0.UserInputType~=Enum.UserInputType.MouseButton1
and a0.UserInputType~=Enum.UserInputType.Touch
then
return
end

if ay.CurrentInput and ay.CurrentInput~=a_ then
return
end
ay.CurrentInput=a_

if au and au~="Hue"then
return
end

au="Hue"

UpdateHue(aP,aA)
end)
)

if aX then
table.insert(
aB,
aX.InputBegan:Connect(function(a0)
if
a0.UserInputType~=Enum.UserInputType.MouseButton1
and a0.UserInputType~=Enum.UserInputType.Touch
then
return
end

if ay.CurrentInput and ay.CurrentInput~=a_ then
return
end
ay.CurrentInput=a_

if au and au~="Transparency"then
return
end

au="Transparency"

UpdateTransparency(aX,aA)
end)
)
end

table.insert(
aB,
al.InputEnded:Connect(function(a0)
au=nil

if ay.CurrentInput and ay.CurrentInput~=a_ then
return
end
ay.CurrentInput=nil
end)
)

return aA
end

function at.New(av,aw)
local ax={
__type="Colorpicker",
Title=aw.Title or"Colorpicker",
Desc=aw.Desc or nil,
Locked=aw.Locked or false,
LockedTitle=aw.LockedTitle,
Default=aw.Default or Color3.new(1,1,1),
Callback=aw.Callback or function()end,

UIScale=aw.UIScale,
Transparency=aw.Transparency,
UIElements={},

IsShowed=false,
}

local ay=true



ax.ColorpickerFrame=a.load'I'{
Title=ax.Title,
Desc=ax.Desc,
Parent=aw.Parent,
TextOffset=40,
Hover=false,
Tab=aw.Tab,
Index=aw.Index,
Window=aw.Window,
ElementTable=ax,
ParentConfig=aw,
Tags=aw.Tags,
}

ax.UIElements.Colorpicker=aa.NewRoundFrame(at.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=ax.Default,
Parent=ax.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2,
},{
aa.NewRoundFrame(at.UICorner,"SquircleGlass",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=0.55,
}),
},true)

function ax.Lock(az)
ax.Locked=true
ay=false
return ax.ColorpickerFrame:Lock(ax.LockedTitle)
end
function ax.Unlock(az)
ax.Locked=false
ay=true
return ax.ColorpickerFrame:Unlock()
end

if ax.Locked then
ax:Lock()
end

function ax.Update(az,aA,aB)
ax.UIElements.Colorpicker.ImageTransparency=aB or 0
ax.UIElements.Colorpicker.ImageColor3=aA
ax.Default=aA
if aB then
ax.Transparency=aB
end
end

function ax.Set(az,aA,aB)
return ax:Update(aA,aB)
end

aa.AddSignal(ax.UIElements.Colorpicker.MouseButton1Click,function()
if ay and not ax.IsShowed then
ax.IsShowed=true

at:Colorpicker(ax,aw.Window,aw.WindUI,function(az,aA)
ax:Update(az,aA)
ax.Default=az
ax.Transparency=aA
aa.SafeCallback(ax.Callback,az,aA)
end).ColorpickerFrame
:Open()
end
end)

return ax.__type,ax
end

return at end function a.Z()

local aa={}

function aa.ToFiniteNumber(ag)
local aj=tonumber(ag)
if aj==nil or aj~=aj or math.abs(aj)==math.huge then
return nil
end

return aj
end

function aa.FormatNumber(ag)
if ag%1==0 then
return tostring(ag)
end

return tostring(tonumber(string.format("%.2f",ag)))
end

function aa.NormalizeOptions(ag)
local aj={}

for al,am in next,ag or{}do
local an
if typeof(am)=="table"then
local ao=am.Value
if ao==nil then
ao=am.Id or am.Key or am.Title or am.Name or al
end

an={
Title=tostring(am.Title or am.Name or ao),
Desc=am.Desc,
Value=ao,
Icon=am.Icon,
Disabled=am.Disabled==true,
}
else
an={
Title=tostring(am),
Value=am,
Disabled=false,
}
end

table.insert(aj,an)
end

return aj
end

function aa.FindOption(ag,aj)
for al,am in next,ag or{}do
if am.Value==aj then
return am,al
end
end

return nil,nil
end

function aa.ContainsValue(ag,aj)
for al,am in next,ag or{}do
if am==aj then
return true
end
end

return false
end

function aa.CloneArray(ag)
local aj={}
for al,am in next,ag or{}do
table.insert(aj,am)
end
return aj
end

function aa.NormalizeValues(ag)
if ag==nil then
return{}
end

if typeof(ag)~="table"then
return{ag}
end

return aa.CloneArray(ag)
end

function aa.ToggleValue(ag,aj)
local al=aa.CloneArray(ag)

for am,an in next,al do
if an==aj then
table.remove(al,am)
return al,false
end
end

table.insert(al,aj)
return al,true
end

return aa end function a._()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'Z'

local am={}

local function GetControlWidth(an)
return math.max(al.ToFiniteNumber(an.Width)or al.ToFiniteNumber(an.ControlWidth)or 220,120)
end

function am.New(an,ao)
local ap={
__type="RadioGroup",
Title=ao.Title or"Radio Group",
Desc=ao.Desc or nil,
Locked=ao.Locked or false,
LockedTitle=ao.LockedTitle,
Options=al.NormalizeOptions(ao.Options or ao.Values or{}),
Value=ao.Value,
AllowNone=ao.AllowNone==true,
Callback=ao.Callback or function()end,
UIElements={},
OptionFrames={},
Animation=ao.Animation~=false,

Width=GetControlWidth(ao),
}

if ap.Value==nil then
ap.Value=ao.Default
end
if typeof(ap.Value)=="number"and ap.Options[ap.Value]then
ap.Value=ap.Options[ap.Value].Value
end
if ap.Value==nil and not ap.AllowNone and ap.Options[1]then
ap.Value=ap.Options[1].Value
end

local aq=true

ap.RadioGroupFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=ap.Width+14,
Hover=false,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.Options=aj("Frame",{
Name="RadioGroupOptions",
Size=UDim2.new(0,ap.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,ao.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ao.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ap.RadioGroupFrame.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Right",
SortOrder="LayoutOrder",
}),
})

local function UpdateOptionVisuals(ar)
for as,at in next,ap.OptionFrames do
local au=at.Option.Value==ap.Value
local av=au and 0.84 or 0.94
local aw=au and 0 or 1
local ax=at.Option.Disabled and 0.55 or(au and 0 or 0.18)

if ar and ap.Animation then
ag.Play(at.Row,"Select",{ImageTransparency=av},nil,nil,"Select")
ag.Play(at.Dot,"Select",{ImageTransparency=aw},nil,nil,"Select")
ag.Play(at.Title,"Select",{TextTransparency=ax},nil,nil,"Select")
else
at.Row.ImageTransparency=av
at.Dot.ImageTransparency=aw
at.Title.TextTransparency=ax
end
end
end

local function CreateOption(ar,as)
local at=aa.NewRoundFrame(99,"Circle",{
Name="Dot",
Size=UDim2.new(0,8,0,8),
ImageTransparency=1,
ThemeTag={
ImageColor3="RadioGroupActive",
},
})

local au=aa.NewRoundFrame(99,"CircleOutline",{
Name="Ring",
Size=UDim2.new(0,18,0,18),
ImageTransparency=ar.Disabled and 0.75 or 0.45,
ThemeTag={
ImageColor3="RadioGroupBorder",
},
},{
at,
})
at.Position=UDim2.new(0.5,0,0.5,0)
at.AnchorPoint=Vector2.new(0.5,0.5)

local av=aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,-28,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ar.Title,
TextSize=14,
TextWrapped=true,
TextXAlignment="Left",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="RadioGroupText",
},
})

local aw=aa.NewRoundFrame(12,"Squircle",{
Name="Option",
Size=UDim2.new(1,0,0,36),
LayoutOrder=as,
ImageTransparency=0.94,
Active=not ar.Disabled,
ThemeTag={
ImageColor3="RadioGroupBackground",
},
},{
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
au,
av,
},true)

aw.Parent=ap.UIElements.Options

local ax={
Row=aw,
Ring=au,
Dot=at,
Title=av,
Option=ar,
}
ap.OptionFrames[as]=ax

ag.AttachPress(aw,aa,{
Enabled=function()
return ap.Animation and not ap.Locked and not ar.Disabled
end,
})

aa.AddSignal(aw.MouseButton1Click,function()
if not ar.Disabled then
ap:Select(ar.Value)
end
end)
end

local function RenderOptions()
for ar,as in next,ap.OptionFrames do
if as.Row then
as.Row:Destroy()
end
end

ap.OptionFrames={}

for ar,as in next,ap.Options do
CreateOption(as,ar)
end

UpdateOptionVisuals(false)
end

function ap.Lock(ar)
ap.Locked=true
aq=false
return ap.RadioGroupFrame:Lock(ap.LockedTitle)
end
function ap.Unlock(ar)
ap.Locked=false
aq=true
return ap.RadioGroupFrame:Unlock()
end

function ap.Get(ar)
return ap.Value
end

function ap.Select(ar,as,at)
local au=al.FindOption(ap.Options,as)
if not au and not ap.AllowNone then
return ap.Value
end
if au and au.Disabled then
return ap.Value
end

ap.Value=as
UpdateOptionVisuals(true)

if aq and at~=false then
aa.SafeCallback(ap.Callback,as,au)
end

return ap.Value
end

function ap.SetOptions(ar,as)
ap.Options=al.NormalizeOptions(as)

if not al.FindOption(ap.Options,ap.Value)then
ap.Value=ap.AllowNone and nil or(ap.Options[1]and ap.Options[1].Value)
end

RenderOptions()
return ap.Options
end

RenderOptions()

if ap.Locked then
ap:Lock()
end

return ap.__type,ap
end

return am end function a.aa()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'Z'

local am={}

local function GetControlWidth(an)
return math.max(al.ToFiniteNumber(an.Width)or al.ToFiniteNumber(an.ControlWidth)or 220,120)
end

function am.New(an,ao)
local ap={
__type="CheckboxGroup",
Title=ao.Title or"Checkbox Group",
Desc=ao.Desc or nil,
Locked=ao.Locked or false,
LockedTitle=ao.LockedTitle,
Options=al.NormalizeOptions(ao.Options or ao.Values or{}),
Values=al.NormalizeValues(ao.ValuesSelected or ao.SelectedValues or ao.Value or ao.ValuesDefault),
Callback=ao.Callback or function()end,
UIElements={},
OptionFrames={},
Animation=ao.Animation~=false,

Width=GetControlWidth(ao),
}

local aq=true

ap.CheckboxGroupFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=ap.Width+14,
Hover=false,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.Options=aj("Frame",{
Name="CheckboxGroupOptions",
Size=UDim2.new(0,ap.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,ao.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ao.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ap.CheckboxGroupFrame.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Right",
SortOrder="LayoutOrder",
}),
})

local function SanitizeValues(ar)
local as={}

for at,au in next,ar or{}do
local av=al.FindOption(ap.Options,au)
if av and not av.Disabled and not al.ContainsValue(as,au)then
table.insert(as,au)
end
end

return as
end

local function UpdateOptionVisuals(ar)
for as,at in next,ap.OptionFrames do
local au=al.ContainsValue(ap.Values,at.Option.Value)
local av=au and 0.84 or 0.94
local aw=au and 0 or 1
local ax=au and 0 or 1
local ay=at.Option.Disabled and 0.55 or(au and 0 or 0.18)

if ar and ap.Animation then
ag.Play(at.Row,"Select",{ImageTransparency=av},nil,nil,"Select")
ag.Play(at.Fill,"Select",{ImageTransparency=aw},nil,nil,"Select")
ag.Play(at.Icon,"Select",{ImageTransparency=ax},nil,nil,"Select")
ag.Play(at.Title,"Select",{TextTransparency=ay},nil,nil,"Select")
else
at.Row.ImageTransparency=av
at.Fill.ImageTransparency=aw
at.Icon.ImageTransparency=ax
at.Title.TextTransparency=ay
end
end
end

local function CreateOption(ar,as)
local at=aa.Icon"check"
local au=aj("ImageLabel",{
Name="Check",
Size=UDim2.new(0,12,0,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Image=at[1],
ImageRectOffset=at[2].ImageRectPosition,
ImageRectSize=at[2].ImageRectSize,
ImageTransparency=1,
ThemeTag={
ImageColor3="CheckboxGroupIcon",
},
})

local av=aa.NewRoundFrame(5,"Squircle",{
Name="Fill",
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ThemeTag={
ImageColor3="CheckboxGroupActive",
},
},{
au,
})

local aw=aa.NewRoundFrame(5,"SquircleOutline",{
Name="Box",
Size=UDim2.new(0,18,0,18),
ImageTransparency=ar.Disabled and 0.75 or 0.45,
ThemeTag={
ImageColor3="CheckboxGroupBorder",
},
},{
av,
})

local ax=aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,-28,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ar.Title,
TextSize=14,
TextWrapped=true,
TextXAlignment="Left",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="CheckboxGroupText",
},
})

local ay=aa.NewRoundFrame(12,"Squircle",{
Name="Option",
Size=UDim2.new(1,0,0,36),
LayoutOrder=as,
ImageTransparency=0.94,
Active=not ar.Disabled,
ThemeTag={
ImageColor3="CheckboxGroupBackground",
},
},{
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
aw,
ax,
},true)

ay.Parent=ap.UIElements.Options

local az={
Row=ay,
Fill=av,
Icon=au,
Title=ax,
Option=ar,
}
ap.OptionFrames[as]=az

ag.AttachPress(ay,aa,{
Enabled=function()
return ap.Animation and not ap.Locked and not ar.Disabled
end,
})

aa.AddSignal(ay.MouseButton1Click,function()
if not ar.Disabled then
ap:Toggle(ar.Value)
end
end)
end

local function RenderOptions()
for ar,as in next,ap.OptionFrames do
if as.Row then
as.Row:Destroy()
end
end

ap.OptionFrames={}

for ar,as in next,ap.Options do
CreateOption(as,ar)
end

ap.Values=SanitizeValues(ap.Values)
UpdateOptionVisuals(false)
end

function ap.Lock(ar)
ap.Locked=true
aq=false
return ap.CheckboxGroupFrame:Lock(ap.LockedTitle)
end
function ap.Unlock(ar)
ap.Locked=false
aq=true
return ap.CheckboxGroupFrame:Unlock()
end

function ap.Get(ar)
return al.CloneArray(ap.Values)
end

function ap.Set(ar,as,at)
ap.Values=SanitizeValues(al.NormalizeValues(as))
UpdateOptionVisuals(true)

if aq and at~=false then
aa.SafeCallback(ap.Callback,ap:Get())
end

return ap:Get()
end

function ap.Toggle(ar,as,at)
local au=al.FindOption(ap.Options,as)
if not au or au.Disabled then
return ap:Get()
end

ap.Values=al.ToggleValue(ap.Values,as)
return ap:Set(ap.Values,at)
end

function ap.SetOptions(ar,as)
ap.Options=al.NormalizeOptions(as)
RenderOptions()
return ap.Options
end

RenderOptions()

if ap.Locked then
ap:Lock()
end

return ap.__type,ap
end

return am end function a.ab()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'Z'

local am={}

local function GetControlWidth(an)
return math.max(al.ToFiniteNumber(an.Width)or al.ToFiniteNumber(an.ControlWidth)or 220,120)
end

function am.New(an,ao)
local ap={
__type="SegmentedControl",
Title=ao.Title or"Segmented Control",
Desc=ao.Desc or nil,
Locked=ao.Locked or false,
LockedTitle=ao.LockedTitle,
Options=al.NormalizeOptions(ao.Options or ao.Values or{}),
Value=ao.Value or ao.Default,
Callback=ao.Callback or function()end,
UIElements={},
Segments={},
Animation=ao.Animation~=false,

Width=GetControlWidth(ao),
}

if typeof(ap.Value)=="number"and ap.Options[ap.Value]then
ap.Value=ap.Options[ap.Value].Value
end
if ap.Value==nil and ap.Options[1]then
ap.Value=ap.Options[1].Value
end

local aq=true

ap.SegmentedControlFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=ap.Width+14,
Hover=false,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.Container=aa.NewRoundFrame(13,"Squircle",{
Name="SegmentedControl",
Size=UDim2.new(0,ap.Width,0,36),
Position=UDim2.new(1,0,ao.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ao.Window.NewElements and 0 or 0.5),
ImageTransparency=0.93,
ThemeTag={
ImageColor3="SegmentedControlBackground",
},
Parent=ap.SegmentedControlFrame.UIElements.Main,
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,4),
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
}),
})

local function UpdateSegmentVisuals(ar)
for as,at in next,ap.Segments do
local au=at.Option.Value==ap.Value
local av=au and 0.82 or 1
local aw=at.Option.Disabled and 0.55 or(au and 0 or 0.25)

if ar and ap.Animation then
ag.Play(at.Button,"Select",{ImageTransparency=av},nil,nil,"Select")
ag.Play(at.Title,"Select",{TextTransparency=aw},nil,nil,"Select")
else
at.Button.ImageTransparency=av
at.Title.TextTransparency=aw
end
end
end

local function CreateSegment(ar,as,at)
local au=4
local av=math.max((ap.Width-8-(au*(at-1)))/math.max(at,1),24)

local aw=aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,-10,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Text=ar.Title,
TextSize=13,
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="SegmentedControlText",
},
})

local ax=aa.NewRoundFrame(10,"Squircle",{
Name="Segment",
Size=UDim2.new(0,av,1,0),
Position=UDim2.new(0,(as-1)*(av+au)+4,0,4),
ImageTransparency=1,
Active=not ar.Disabled,
ThemeTag={
ImageColor3="SegmentedControlActive",
},
},{
aw,
},true)

ax.Parent=ap.UIElements.Container

local ay={
Button=ax,
Title=aw,
Option=ar,
}
ap.Segments[as]=ay

ag.AttachPress(ax,aa,{
Amount=0.96,
Enabled=function()
return ap.Animation and not ap.Locked and not ar.Disabled
end,
})

aa.AddSignal(ax.MouseButton1Click,function()
if not ar.Disabled then
ap:Select(ar.Value)
end
end)
end

local function RenderSegments()
for ar,as in next,ap.Segments do
if as.Button then
as.Button:Destroy()
end
end

ap.Segments={}

local ar=#ap.Options
for as,at in next,ap.Options do
CreateSegment(at,as,ar)
end

UpdateSegmentVisuals(false)
end

function ap.Lock(ar)
ap.Locked=true
aq=false
return ap.SegmentedControlFrame:Lock(ap.LockedTitle)
end
function ap.Unlock(ar)
ap.Locked=false
aq=true
return ap.SegmentedControlFrame:Unlock()
end

function ap.Get(ar)
return ap.Value
end

function ap.Select(ar,as,at)
local au=al.FindOption(ap.Options,as)
if not au or au.Disabled then
return ap.Value
end

ap.Value=as
UpdateSegmentVisuals(true)

if aq and at~=false then
aa.SafeCallback(ap.Callback,as,au)
end

return ap.Value
end

function ap.SetOptions(ar,as)
ap.Options=al.NormalizeOptions(as)

if not al.FindOption(ap.Options,ap.Value)then
ap.Value=ap.Options[1]and ap.Options[1].Value or nil
end

RenderSegments()
return ap.Options
end

RenderSegments()

if ap.Locked then
ap:Lock()
end

return ap.__type,ap
end

return am end function a.ac()

local aa=a.load'd'

local ag=a.load'o'.New

local aj={}

function aj.New(al,am)
local an={
__type="TextArea",
Title=am.Title or"Text Area",
Desc=am.Desc or nil,
Locked=am.Locked or false,
LockedTitle=am.LockedTitle,
InputIcon=am.InputIcon or false,
Placeholder=am.Placeholder or"Enter Text...",
Value=am.Value or"",
Callback=am.Callback or function()end,
ClearTextOnFocus=am.ClearTextOnFocus or false,
UIElements={},
}

local ao=true

an.TextAreaFrame=a.load'I'{
Title=an.Title,
Desc=an.Desc,
Parent=am.Parent,
TextOffset=0,
Hover=false,
Tab=am.Tab,
Index=am.Index,
Window=am.Window,
ElementTable=an,
ParentConfig=am,
Tags=am.Tags,
}

local ap=ag(
an.Placeholder,
an.InputIcon,
an.TextAreaFrame.UIElements.Container,
"Textarea",
function(ap)
an:Set(ap,true,true)
end,
nil,
am.Window.NewElements and 12 or 10,
an.ClearTextOnFocus
)
ap.Size=UDim2.new(1,0,0,am.Height or 148)
ap.LayoutOrder=99

local aq=ap.Frame.Frame.TextBox

function an.Lock(ar)
an.Locked=true
ao=false
return an.TextAreaFrame:Lock(an.LockedTitle)
end
function an.Unlock(ar)
an.Locked=false
ao=true
return an.TextAreaFrame:Unlock()
end

function an.Get(ar)
return an.Value
end

function an.Set(ar,as,at,au)
if not ao then
return an.Value
end

an.Value=tostring(as or"")

if not au then
aq.Text=an.Value
end

if at~=false then
aa.SafeCallback(an.Callback,an.Value)
end

return an.Value
end

function an.SetPlaceholder(ar,as)
an.Placeholder=tostring(as or"")
aq.PlaceholderText=an.Placeholder
end

an:Set(an.Value,false)

if an.Locked then
an:Lock()
end

return an.__type,an
end

return aj end function a.ad()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ag=aa(game:GetService"UserInputService")

local aj=a.load'd'
local al=a.load'e'
local am=aj.New

local an=a.load'Z'

local ao={}

local function ReadValueConfig(ap)
local aq=typeof(ap.Value)=="table"and ap.Value or{}
local ar=an.ToFiniteNumber(aq.Min)or an.ToFiniteNumber(ap.Min)or 0
local as=an.ToFiniteNumber(aq.Max)or an.ToFiniteNumber(ap.Max)or 100

if ar>as then
ar,as=as,ar
end

local at=typeof(ap.Value)=="number"and ap.Value
or an.ToFiniteNumber(aq.Default)
or an.ToFiniteNumber(ap.Default)
or ar
local au=an.ToFiniteNumber(aq.Increment)or an.ToFiniteNumber(ap.Increment)or 1

return ar,as,math.clamp(an.ToFiniteNumber(at)or ar,ar,as),math.max(math.abs(au),0.0001)
end

function ao.New(ap,aq)
local ar,as,at,au=ReadValueConfig(aq)
local av=ag.TouchEnabled and not ag.KeyboardEnabled
local aw=aq.Buttons~=false and aq.ShowButtons~=false
local ax=av and 38 or 34
local ay=av and 40 or 36
local az=aw and 164 or 128

local aA={
__type="Stepper",
Title=aq.Title or"Stepper",
Desc=aq.Desc or nil,
Locked=aq.Locked or false,
LockedTitle=aq.LockedTitle,
Value={
Min=ar,
Max=as,
Default=at,
Increment=au,
},
Callback=aq.Callback or function()end,
Format=aq.Format,
UIElements={},
Animation=aq.Animation~=false,
Draggable=aq.Draggable~=false,
ShowButtons=aw,
Width=math.max(an.ToFiniteNumber(aq.Width)or an.ToFiniteNumber(aq.ControlWidth)or(av and 188 or 176),az),
}

local aB=true

aA.StepperFrame=a.load'I'{
Title=aA.Title,
Desc=aA.Desc,
Parent=aq.Parent,
TextOffset=aA.Width+14,
Hover=false,
Tab=aq.Tab,
Index=aq.Index,
Window=aq.Window,
ElementTable=aA,
ParentConfig=aq,
Tags=aq.Tags,
}

local function FormatValue(aC)
if typeof(aA.Format)=="function"then
local aD,aE=pcall(aA.Format,aC,aA.Value.Min,aA.Value.Max)
if aD and aE~=nil then
return tostring(aE)
end
end

return an.FormatNumber(aC)
end

local function GetRange()
return math.max(aA.Value.Max-aA.Value.Min,aA.Value.Increment)
end

local function SnapValue(aC)
local aD=an.ToFiniteNumber(aC)
if aD==nil then
return aA.Value.Default
end

local aE=math.floor(((aD-aA.Value.Min)/aA.Value.Increment)+0.5)
local aF=aA.Value.Min+(aE*aA.Value.Increment)
return math.clamp(aF,aA.Value.Min,aA.Value.Max)
end

local function ValueToDelta(aC)
return math.clamp((aC-aA.Value.Min)/GetRange(),0,1)
end

local function CreateIconButton(aC,aD)
local aE=aj.Icon(aD)
local aF=am("ImageLabel",{
Name="Icon",
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Image=aE[1],
ImageRectOffset=aE[2].ImageRectPosition,
ImageRectSize=aE[2].ImageRectSize,
ThemeTag={
ImageColor3="StepperIcon",
},
})

local aG=aj.NewRoundFrame(12,"Squircle",{
Name=aC,
Size=UDim2.fromOffset(ax,ax),
ImageTransparency=0.88,
ThemeTag={
ImageColor3="StepperButton",
},
},{
aF,
},true)

return aG,aF
end

local aC,aD
local aE,aF
if aA.ShowButtons then
aC,aD=CreateIconButton("Minus","minus")
aE,aF=CreateIconButton("Plus","plus")

al.AttachPress(aC,aj,{
Amount=0.94,
Enabled=function()
return aA.Animation and not aA.Locked and aA.Value.Default>aA.Value.Min
end,
})
al.AttachPress(aE,aj,{
Amount=0.94,
Enabled=function()
return aA.Animation and not aA.Locked and aA.Value.Default<aA.Value.Max
end,
})
end

local aG=aj.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(ValueToDelta(aA.Value.Default),0,1,0),
ImageTransparency=0.12,
ThemeTag={
ImageColor3="Primary",
},
})

local aH=aj.NewRoundFrame(999,"Squircle",{
Name="Thumb",
Size=UDim2.fromOffset(9,9),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(ValueToDelta(aA.Value.Default),0,0.5,0),
ImageTransparency=0,
ThemeTag={
ImageColor3="SliderThumb",
},
})

local aI=aj.NewRoundFrame(999,"Squircle",{
Name="Track",
Size=UDim2.new(1,-18,0,4),
Position=UDim2.new(0.5,0,1,-7),
AnchorPoint=Vector2.new(0.5,1),
ImageTransparency=0.88,
ThemeTag={
ImageColor3="Text",
},
},{
aG,
aH,
})

aA.UIElements.ValueLabel=am("TextLabel",{
Name="Value",
Size=UDim2.new(1,-18,1,-10),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
Text=FormatValue(aA.Value.Default),
TextSize=av and 15 or 14,
TextTruncate="AtEnd",
FontFace=Font.new(aj.Font),
ThemeTag={
TextColor3="StepperText",
},
})

local aJ=aA.ShowButtons and((ax*2)+10)or 0
local aK=aj.NewRoundFrame(12,"Squircle",{
Name="ValueBackground",
Size=UDim2.new(1,-aJ,0,ay),
ImageTransparency=0.92,
Active=true,
ClipsDescendants=true,
ThemeTag={
ImageColor3="StepperValueBackground",
},
},{
aA.UIElements.ValueLabel,
aI,
},true)

aA.UIElements.Track=aI
aA.UIElements.TrackFill=aG
aA.UIElements.TrackThumb=aH
aA.UIElements.ValueBackground=aK

aA.UIElements.Container=am("Frame",{
Name="Stepper",
Size=UDim2.new(0,aA.Width,0,ay),
Position=UDim2.new(1,0,aq.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,aq.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=aA.StepperFrame.UIElements.Main,
},{
am("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Horizontal",
HorizontalAlignment="Right",
VerticalAlignment="Center",
}),
aC,
aK,
aE,
})

local function SetProgressVisual(aL,aM)
local aN=ValueToDelta(aL)
local aO=UDim2.new(aN,0,1,0)
local aP=UDim2.new(aN,0,0.5,0)

if aM and aA.Animation then
al.Play(aG,"Fast",{Size=aO},nil,nil,"StepperFill")
al.Play(aH,"Fast",{Position=aP},nil,nil,"StepperThumb")
else
aG.Size=aO
aH.Position=aP
end
end

local function UpdateButtonStates(aL)
if not aA.ShowButtons then
return
end

local aM=aA.Value.Default<=aA.Value.Min
local aN=aA.Value.Default>=aA.Value.Max
local aO=aM and 0.62 or 0
local aP=aN and 0.62 or 0
local aQ=aM and 0.94 or 0.88
local aR=aN and 0.94 or 0.88

if aL and aA.Animation then
al.Play(aD,"Fast",{ImageTransparency=aO},nil,nil,"State")
al.Play(aF,"Fast",{ImageTransparency=aP},nil,nil,"State")
al.Play(aC,"Fast",{ImageTransparency=aQ},nil,nil,"State")
al.Play(aE,"Fast",{ImageTransparency=aR},nil,nil,"State")
else
aD.ImageTransparency=aO
aF.ImageTransparency=aP
aC.ImageTransparency=aQ
aE.ImageTransparency=aR
end
end

local function UpdateValue(aL,aM,aN)
local aO=an.ToFiniteNumber(aL)
if aO==nil then
return aA.Value.Default
end

local aP=aA.Value.Default
aA.Value.Default=aN==false and math.clamp(aO,aA.Value.Min,aA.Value.Max)or SnapValue(aO)
aA.UIElements.ValueLabel.Text=FormatValue(aA.Value.Default)
SetProgressVisual(aA.Value.Default,true)
UpdateButtonStates(true)

if aA.Animation and aP~=aA.Value.Default then
al.Play(aK,"Fast",{ImageTransparency=0.86},nil,nil,"Pulse")
task.delay(al.GetDuration"Fast",function()
if aK.Parent then
al.Play(aK,"Select",{ImageTransparency=0.92},nil,nil,"Pulse")
end
end)
end

if aB and aM~=false and aP~=aA.Value.Default then
aj.SafeCallback(aA.Callback,aA.Value.Default)
end

return aA.Value.Default
end

function aA.Lock(aL)
aA.Locked=true
aB=false
UpdateButtonStates(true)
return aA.StepperFrame:Lock(aA.LockedTitle)
end
function aA.Unlock(aL)
aA.Locked=false
aB=true
UpdateButtonStates(true)
return aA.StepperFrame:Unlock()
end

function aA.Get(aL)
return aA.Value.Default
end

function aA.Set(aL,aM,aN)
return UpdateValue(aM,aN)
end

function aA.SetRange(aL,aM,aN)
aM=an.ToFiniteNumber(aM)
aN=an.ToFiniteNumber(aN)

if aM==nil or aN==nil then
return aA.Value.Min,aA.Value.Max
end

if aM>aN then
aM,aN=aN,aM
end

aA.Value.Min=aM
aA.Value.Max=aN
UpdateValue(aA.Value.Default,false)

return aA.Value.Min,aA.Value.Max
end

function aA.SetMin(aL,aM)
aA:SetRange(aM,math.max(an.ToFiniteNumber(aM)or aA.Value.Min,aA.Value.Max))
return aA.Value.Min
end

function aA.SetMax(aL,aM)
aA:SetRange(math.min(aA.Value.Min,an.ToFiniteNumber(aM)or aA.Value.Max),aM)
return aA.Value.Max
end

local aL=aq.WindUI.GenerateGUID()
local aM
local aN
local aO
local aP=aq.Tab and aq.Tab.UIElements and aq.Tab.UIElements.ContainerFrame

local function DisconnectDrag()
if aN then
aN:Disconnect()
aN=nil
end
if aO then
aO:Disconnect()
aO=nil
end
if aP then
aP.ScrollingEnabled=true
end
if aq.WindUI.CurrentInput==aL then
aq.WindUI.CurrentInput=nil
end
aM=nil
if aA.Animation then
al.Play(aH,"Focus",{Size=UDim2.fromOffset(9,9)},nil,nil,"StepperDrag")
end
end

local function GetInputX(aQ)
if aQ.UserInputType==Enum.UserInputType.Touch then
return aQ.Position.X
end
return ag:GetMouseLocation().X
end

local function UpdateFromInput(aQ)
if not aI or aI.AbsoluteSize.X<=0 then
return
end

local aR=math.clamp((GetInputX(aQ)-aI.AbsolutePosition.X)/aI.AbsoluteSize.X,0,1)
local aS=aA.Value.Min+(aR*GetRange())
UpdateValue(aS,true)
end

if aA.ShowButtons then
aj.AddSignal(aC.MouseButton1Click,function()
if not aA.Locked then
aA:Set(aA.Value.Default-aA.Value.Increment)
end
end)
aj.AddSignal(aE.MouseButton1Click,function()
if not aA.Locked then
aA:Set(aA.Value.Default+aA.Value.Increment)
end
end)
end

aj.AddSignal(aK.InputBegan,function(aQ)
if aA.Locked or not aA.Draggable then
return
end
if aQ.UserInputType~=Enum.UserInputType.MouseButton1 and aQ.UserInputType~=Enum.UserInputType.Touch then
return
end
if aq.WindUI.CurrentInput and aq.WindUI.CurrentInput~=aL then
return
end

aq.WindUI.CurrentInput=aL
aM=aQ
if aP then
aP.ScrollingEnabled=false
end
if aA.Animation then
al.Play(aH,"Focus",{Size=UDim2.fromOffset(13,13)},nil,nil,"StepperDrag")
end
UpdateFromInput(aQ)

aN=ag.InputChanged:Connect(function(aR)
if not aM then
return
end
if aM.UserInputType==Enum.UserInputType.Touch and aR.UserInputType~=Enum.UserInputType.Touch then
return
end
if aM.UserInputType==Enum.UserInputType.MouseButton1 and aR.UserInputType~=Enum.UserInputType.MouseMovement then
return
end
UpdateFromInput(aR)
end)

aO=ag.InputEnded:Connect(function(aR)
if not aM then
return
end
local aS=aM.UserInputType==Enum.UserInputType.Touch and aR==aM
local aT=aM.UserInputType==Enum.UserInputType.MouseButton1
and aR.UserInputType==Enum.UserInputType.MouseButton1
if aS or aT then
DisconnectDrag()
end
end)
end)

UpdateButtonStates(false)
SetProgressVisual(aA.Value.Default,false)

if aA.Locked then
aA:Lock()
end

return aA.__type,aA
end

return ao end function a.ae()

local aa={}

local ag={
Info={
Icon="info",
Color=Color3.fromHex"#2563eb",
},
Success={
Icon="circle-check",
Color=Color3.fromHex"#16a34a",
},
Warning={
Icon="triangle-alert",
Color=Color3.fromHex"#d97706",
},
Error={
Icon="circle-x",
Color=Color3.fromHex"#dc2626",
},
}

function aa.New(aj,al)
local am=al.Variant or"Info"
local an=ag[am]or ag.Info

local ao={
__type="Callout",
Title=al.Title or am,
Desc=al.Desc or al.Content,
Icon=al.Icon or an.Icon,
Variant=am,
Color=al.Color or an.Color,
UIElements={},
}

ao.CalloutFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Image=ao.Icon,
IconThemed=al.IconThemed,
Color=ao.Color,
Parent=al.Parent,
TextOffset=0,
Hover=al.Hover==true,
Tab=al.Tab,
Index=al.Index,
Window=al.Window,
ElementTable=ao,
ParentConfig=al,
Tags=al.Tags,
Size=al.Size,
}

return ao.__type,ao
end

return aa end function a.af()

local aa={}

aa.Variants={
Info={
Icon="info",
Color=Color3.fromHex"#2563eb",
},
Success={
Icon="circle-check",
Color=Color3.fromHex"#16a34a",
},
Warning={
Icon="triangle-alert",
Color=Color3.fromHex"#d97706",
},
Error={
Icon="circle-x",
Color=Color3.fromHex"#dc2626",
},
Neutral={
Icon="circle",
Color=Color3.fromHex"#71717a",
},
}

function aa.ToFiniteNumber(ag)
local aj=tonumber(ag)
if aj==nil or aj~=aj or math.abs(aj)==math.huge then
return nil
end

return aj
end

function aa.GetVariant(ag)
return aa.Variants[ag or"Info"]or aa.Variants.Info
end

function aa.GetColor(ag,aj)
if typeof(ag)=="Color3"then
return ag
end
if typeof(ag)=="string"and string.sub(ag,1,1)=="#"then
return Color3.fromHex(ag)
end
return aj
end

function aa.NormalizeItems(ag,aj,al)
local am={}

for an,ao in next,ag or{}do
if typeof(ao)=="table"then
local ap=ao[al or"Value"]
if ap==nil then
ap=ao.Id or ao.Key or ao.Title or ao.Name or an
end

table.insert(am,{
Title=tostring(ao[aj or"Title"]or ao.Name or ap),
Desc=ao.Desc or ao.Content,
Value=ap,
Icon=ao.Icon,
Color=ao.Color,
Disabled=ao.Disabled==true,
Items=ao.Items,
})
else
table.insert(am,{
Title=tostring(ao),
Value=ao,
Disabled=false,
})
end
end

return am
end

function aa.CloneArray(ag)
local aj={}
for al,am in next,ag or{}do
table.insert(aj,am)
end
return aj
end

function aa.NormalizeValues(ag)
if ag==nil then
return{}
end
if typeof(ag)~="table"then
return{ag}
end
return aa.CloneArray(ag)
end

function aa.ContainsValue(ag,aj)
for al,am in next,ag or{}do
if am==aj then
return true
end
end
return false
end

function aa.ToggleValue(ag,aj)
local al=aa.CloneArray(ag)

for am,an in next,al do
if an==aj then
table.remove(al,am)
return al,false
end
end

table.insert(al,aj)
return al,true
end

function aa.CreateIcon(ag,aj,al,am,an,ao)
if not aj or aj==""then
return nil
end

local ap=ag.Image(aj,aj,0,al,am or"Element",an~=false,true,ao)
ap.Size=UDim2.new(0,18,0,18)
return ap
end

function aa.GetImageTarget(ag)
if typeof(ag)~="Instance"then
return nil
end

if ag:IsA"ImageLabel"or ag:IsA"ImageButton"then
return ag
end

return ag:FindFirstChildWhichIsA"ImageLabel"or ag:FindFirstChildWhichIsA"ImageButton"
end

function aa.CreateText(ag,aj,al,am,an,ao)
return ag("TextLabel",{
BackgroundTransparency=1,
Text=tostring(al or""),
TextSize=am or 14,
TextTransparency=ao or 0,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(aj.Font),
ThemeTag={
TextColor3="Text",
},
})
end

return aa end function a.ag()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

function am.New(an,ao)
local ap=ao.Variant or"Info"
local aq=al.GetVariant(ap)
local ar={
__type="Badge",
Title=ao.Title or"Badge",
Desc=ao.Desc or nil,
Value=ao.Value or ao.Badge or ap,
Variant=ap,
Color=al.GetColor(ao.Color,aq.Color),
Icon=ao.Icon or aq.Icon,
Callback=ao.Callback,
UIElements={},

Width=math.max(al.ToFiniteNumber(ao.Width)or 96,72),
}

ar.BadgeFrame=a.load'I'{
Title=ar.Title,
Desc=ar.Desc,
Parent=ao.Parent,
TextOffset=ar.Width+14,
Hover=ao.Hover==true or ar.Callback~=nil,
Scalable=ar.Callback~=nil,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ar,
ParentConfig=ao,
Tags=ao.Tags,
}

local as=al.CreateIcon(aa,ar.Icon,ao.Window.Folder,"Badge",false,"BadgeIcon")
if as then
as.ImageLabel.ImageColor3=Color3.new(1,1,1)
as.ImageLabel.ImageTransparency=0
as.Size=UDim2.new(0,14,0,14)
end

ar.UIElements.Label=aj("TextLabel",{
Name="Label",
BackgroundTransparency=1,
Text=tostring(ar.Value),
TextSize=13,
TextTruncate="AtEnd",
TextXAlignment="Center",
Size=UDim2.new(1,as and-20 or 0,1,0),
FontFace=Font.new(aa.Font),
TextColor3=Color3.new(1,1,1),
})

ar.UIElements.Pill=aa.NewRoundFrame(999,"Squircle",{
Name="Badge",
Size=UDim2.new(0,ar.Width,0,28),
Position=UDim2.new(1,0,ao.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ao.Window.NewElements and 0 or 0.5),
ImageTransparency=0,
ImageColor3=ar.Color,
Parent=ar.BadgeFrame.UIElements.Main,
},{
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
as,
ar.UIElements.Label,
})

function ar.SetValue(at,au)
ar.Value=au
ar.UIElements.Label.Text=tostring(au or"")
ag.Play(ar.UIElements.Pill,"Fast",{ImageTransparency=0.08},nil,nil,"Pulse")
task.delay(ag.GetDuration"Fast",function()
if ar.UIElements.Pill.Parent then
ag.Play(ar.UIElements.Pill,"Select",{ImageTransparency=0},nil,nil,"Pulse")
end
end)
return ar.Value
end

function ar.SetVariant(at,au)
local av=al.GetVariant(au)
ar.Variant=au
ar.Color=av.Color
ag.Play(ar.UIElements.Pill,"Select",{ImageColor3=ar.Color},nil,nil,"Variant")
return ar.Variant
end

if ar.Callback then
aa.AddSignal(ar.BadgeFrame.UIElements.Main.MouseButton1Click,function()
aa.SafeCallback(ar.Callback,ar.Value)
end)
end

return ar.__type,ar
end

return am end function a.ah()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

function am.New(an,ao)
local ap=ao.Status or ao.Variant or"Info"
local aq=al.GetVariant(ap)
local ar={
__type="StatusCard",
Title=ao.Title or"Status",
Desc=ao.Desc or ao.Content,
Value=ao.Value or ap,
Status=ap,
Color=al.GetColor(ao.Color,aq.Color),
Callback=ao.Callback,
UIElements={},

Width=math.max(al.ToFiniteNumber(ao.Width)or 136,96),
}

ar.StatusCardFrame=a.load'I'{
Title=ar.Title,
Desc=ar.Desc,
Parent=ao.Parent,
TextOffset=ar.Width+14,
Hover=ao.Hover==true or ar.Callback~=nil,
Scalable=ar.Callback~=nil,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ar,
ParentConfig=ao,
Tags=ao.Tags,
}

ar.UIElements.Dot=aa.NewRoundFrame(999,"Circle",{
Name="Dot",
Size=UDim2.new(0,10,0,10),
ImageColor3=ar.Color,
})

ar.UIElements.Value=aj("TextLabel",{
Name="Value",
BackgroundTransparency=1,
Text=tostring(ar.Value),
TextSize=14,
TextTransparency=0.08,
TextTruncate="AtEnd",
AutomaticSize="Y",
Size=UDim2.new(1,-18,0,0),
TextXAlignment="Left",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

ar.UIElements.Status=aj("Frame",{
Name="StatusCard",
Size=UDim2.new(0,ar.Width,0,34),
Position=UDim2.new(1,0,ao.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ao.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ar.StatusCardFrame.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Right",
}),
ar.UIElements.Dot,
ar.UIElements.Value,
})

function ar.SetValue(as,at)
ar.Value=at
ar.UIElements.Value.Text=tostring(at or"")
return ar.Value
end

function ar.SetStatus(as,at,au)
local av=al.GetVariant(at)
ar.Status=at
ar.Color=av.Color
if au~=nil then
ar:SetValue(au)
end
ag.Play(ar.UIElements.Dot,"Select",{ImageColor3=ar.Color},nil,nil,"Status")
return ar.Status
end

if ar.Callback then
aa.AddSignal(ar.StatusCardFrame.UIElements.Main.MouseButton1Click,function()
aa.SafeCallback(ar.Callback,ar.Status,ar.Value)
end)
end

return ar.__type,ar
end

return am end function a.ai()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local function GetTrendColor(an)
if an=="Down"or an=="Negative"then
return Color3.fromHex"#dc2626"
end
if an=="Neutral"then
return Color3.fromHex"#71717a"
end
return Color3.fromHex"#16a34a"
end

function am.New(an,ao)
local ap={
__type="StatCard",
Title=ao.Title or"Stat",
Desc=ao.Desc,
Value=ao.Value or ao.Default or"0",
SubValue=ao.SubValue or ao.TrendText,
Trend=ao.Trend or"Up",
Icon=ao.Icon,
UIElements={},
}

ap.StatCardFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Image=ap.Icon,
Parent=ao.Parent,
TextOffset=0,
Hover=ao.Hover==true,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.Value=aj("TextLabel",{
Name="Value",
LayoutOrder=-1,
BackgroundTransparency=1,
Text=tostring(ap.Value),
TextSize=al.ToFiniteNumber(ao.ValueTextSize)or 24,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

ap.UIElements.TrendDot=aa.NewRoundFrame(999,"Circle",{
Name="TrendDot",
Size=UDim2.new(0,8,0,8),
ImageColor3=al.GetColor(ao.TrendColor,GetTrendColor(ap.Trend)),
})

ap.UIElements.SubValue=aj("TextLabel",{
Name="SubValue",
BackgroundTransparency=1,
Text=tostring(ap.SubValue or""),
TextSize=13,
TextTransparency=0.35,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,-16,0,0),
Visible=ap.SubValue~=nil,
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

ap.UIElements.Footer=aj("Frame",{
Name="Footer",
LayoutOrder=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.StatCardFrame.UIElements.Container,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ap.UIElements.TrendDot,
ap.UIElements.SubValue,
})
ap.UIElements.Value.Parent=ap.StatCardFrame.UIElements.Container

function ap.SetValue(aq,ar,as)
ap.Value=ar
ap.UIElements.Value.Text=tostring(ar or"")
if as~=nil then
ap.SubValue=as
ap.UIElements.SubValue.Text=tostring(as)
ap.UIElements.SubValue.Visible=true
end
ag.Play(ap.UIElements.Value,"Fast",{TextTransparency=0.18},nil,nil,"Pulse")
task.delay(ag.GetDuration"Fast",function()
if ap.UIElements.Value.Parent then
ag.Play(ap.UIElements.Value,"Select",{TextTransparency=0},nil,nil,"Pulse")
end
end)
return ap.Value
end

function ap.SetTrend(aq,ar,as)
ap.Trend=ar
local at=al.GetColor(as,GetTrendColor(ar))
ag.Play(ap.UIElements.TrendDot,"Select",{ImageColor3=at},nil,nil,"Trend")
return ap.Trend
end

return ap.__type,ap
end

return am end function a.aj()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

function am.New(an,ao)
local ap={
__type="KeyValue",
Title=ao.Title or"Details",
Desc=ao.Desc,
Items=al.NormalizeItems(ao.Items or ao.Rows or ao.Values or{},"Key","Value"),
UIElements={},
Rows={},
}

ap.KeyValueFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=0,
Hover=ao.Hover==true,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.List=aj("Frame",{
Name="KeyValueList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.KeyValueFrame.UIElements.Container,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

local function Render()
for aq,ar in next,ap.Rows do
ar:Destroy()
end
ap.Rows={}

for aq,ar in next,ap.Items do
local as=al.CreateIcon(aa,ar.Icon,ao.Window.Folder,"KeyValue",true,"KeyValueIcon")
if as then
as.Size=UDim2.new(0,16,0,16)
end

local at=aj("TextLabel",{
Name="Key",
BackgroundTransparency=1,
Text=tostring(ar.Title),
TextSize=14,
TextTransparency=0.35,
TextTruncate="AtEnd",
TextXAlignment="Left",
Size=UDim2.new(0.45,as and-24 or 0,0,0),
AutomaticSize="Y",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

local au=aj("TextLabel",{
Name="Value",
BackgroundTransparency=1,
Text=tostring(ar.Value or""),
TextSize=14,
TextTransparency=0.05,
TextWrapped=true,
TextXAlignment="Right",
Size=UDim2.new(0.55,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

local av=aj("Frame",{
Name="Row",
LayoutOrder=aq,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.UIElements.List,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
as,
at,
au,
})

table.insert(ap.Rows,av)
end
end

function ap.SetItems(aq,ar)
ap.Items=al.NormalizeItems(ar or{},"Key","Value")
Render()
ag.Play(ap.UIElements.List,"Reveal",{BackgroundTransparency=1},nil,nil,"Render")
return ap.Items
end

Render()

return ap.__type,ap
end

return am end function a.ak()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local function GetWidth(an)
return math.max(al.ToFiniteNumber(an.Width)or al.ToFiniteNumber(an.ControlWidth)or 190,120)
end

function am.New(an,ao)
local ap={
__type="ChipList",
Title=ao.Title or"Chips",
Desc=ao.Desc,
Options=al.NormalizeItems(ao.Options or ao.Values or{}),
Values=al.NormalizeValues(ao.Value or ao.ValuesSelected or ao.SelectedValues),
Multi=ao.Multi~=false,
Callback=ao.Callback or function()end,
Locked=ao.Locked or false,
LockedTitle=ao.LockedTitle,
Animation=ao.Animation~=false,
UIElements={},
Chips={},

Width=GetWidth(ao),
}

local aq=true

ap.ChipListFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=ap.Width+14,
Hover=false,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.List=aj("Frame",{
Name="ChipList",
Size=UDim2.new(0,ap.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,ao.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ao.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ap.ChipListFrame.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Right",
SortOrder="LayoutOrder",
}),
})

local function IsSelected(ar)
return al.ContainsValue(ap.Values,ar)
end

local function UpdateVisuals(ar)
for as,at in next,ap.Chips do
local au=IsSelected(at.Option.Value)
local av=au and 0.82 or 0.94
local aw=at.Option.Disabled and 0.55 or(au and 0 or 0.2)

if ar and ap.Animation then
ag.Play(at.Button,"Select",{ImageTransparency=av},nil,nil,"State")
ag.Play(at.Title,"Select",{TextTransparency=aw},nil,nil,"State")
else
at.Button.ImageTransparency=av
at.Title.TextTransparency=aw
end
end
end

local function Sanitize(ar)
local as={}
for at,au in next,ar or{}do
for av,aw in next,ap.Options do
if aw.Value==au and not aw.Disabled and not al.ContainsValue(as,au)then
table.insert(as,au)
break
end
end
end
return as
end

local function CreateChip(ar,as)
local at=aj("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Text=ar.Title,
TextSize=13,
TextTruncate="AtEnd",
TextXAlignment="Center",
Size=UDim2.new(1,-16,1,0),
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

local au=aa.NewRoundFrame(999,"Squircle",{
Name="Chip",
Size=UDim2.new(1,0,0,30),
LayoutOrder=as,
ImageTransparency=0.94,
Active=not ar.Disabled,
ThemeTag={
ImageColor3="ChipListBackground",
},
Parent=ap.UIElements.List,
},{
at,
},true)

local av={
Button=au,
Title=at,
Option=ar,
}
ap.Chips[as]=av

ag.AttachPress(au,aa,{
Amount=0.96,
Enabled=function()
return ap.Animation and not ap.Locked and not ar.Disabled
end,
})

aa.AddSignal(au.MouseButton1Click,function()
if not ar.Disabled then
ap:Toggle(ar.Value)
end
end)
end

local function Render()
for ar,as in next,ap.Chips do
as.Button:Destroy()
end
ap.Chips={}

for ar,as in next,ap.Options do
CreateChip(as,ar)
end

ap.Values=Sanitize(ap.Values)
UpdateVisuals(false)
end

function ap.Lock(ar)
ap.Locked=true
aq=false
return ap.ChipListFrame:Lock(ap.LockedTitle)
end

function ap.Unlock(ar)
ap.Locked=false
aq=true
return ap.ChipListFrame:Unlock()
end

function ap.Get(ar)
return ap.Multi and al.CloneArray(ap.Values)or ap.Values[1]
end

function ap.Set(ar,as,at)
local au=al.NormalizeValues(as)
if not ap.Multi and au[1]~=nil then
au={au[1]}
end

ap.Values=Sanitize(au)
UpdateVisuals(true)

if aq and at~=false then
aa.SafeCallback(ap.Callback,ap:Get())
end

return ap:Get()
end

function ap.Toggle(ar,as,at)
if ap.Multi then
ap.Values=al.ToggleValue(ap.Values,as)
return ap:Set(ap.Values,at)
end

return ap:Set(as,at)
end

function ap.SetOptions(ar,as)
ap.Options=al.NormalizeItems(as or{})
Render()
return ap.Options
end

Render()

if ap.Locked then
ap:Lock()
end

return ap.__type,ap
end

return am end function a.al()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local function NormalizeActions(an)
local ao={}

for ap,aq in next,an or{}do
if typeof(aq)=="table"then
table.insert(ao,{
Title=tostring(aq.Title or aq.Name or aq.Value or("Action "..tostring(ap))),
Desc=aq.Desc or aq.Content,
Value=aq.Value or aq.Badge,
Icon=aq.Icon,
Color=al.GetColor(aq.Color,nil),
Disabled=aq.Disabled==true,
Callback=aq.Callback,
})
else
table.insert(ao,{
Title=tostring(aq),
Disabled=false,
})
end
end

return ao
end

function am.New(an,ao)
local ap={
__type="ActionList",
Title=ao.Title or"Actions",
Desc=ao.Desc,
Actions=NormalizeActions(ao.Actions or ao.Items or ao.Values or{}),
Rows={},
UIElements={},
}

ap.ActionListFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=0,
Hover=ao.Hover==true,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.List=aj("Frame",{
Name="ActionList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.ActionListFrame.UIElements.Container,
},{
aj("UIListLayout",{
Padding=UDim.new(0,ao.Window.NewElements and 6 or 8),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

local function Render()
for aq,ar in next,ap.Rows do
ar:Destroy()
end
ap.Rows={}

for aq,ar in next,ap.Actions do
local as=al.CreateIcon(aa,ar.Icon or"circle-dot",ao.Window.Folder,"ActionList",true,"ActionListIcon")
if as then
as.Size=UDim2.fromOffset(17,17)
end
local at=al.GetImageTarget(as)
if at and ar.Color then
at.ImageColor3=ar.Color
end

local au=aj("Frame",{
Name="Texts",
Size=UDim2.new(1,ar.Value and-96 or-42,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
aj("UIListLayout",{
Padding=UDim.new(0,2),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ar.Title,
TextSize=14,
TextTransparency=ar.Disabled and 0.46 or 0.04,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
}),
ar.Desc and aj("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=tostring(ar.Desc),
TextSize=12,
TextTransparency=ar.Disabled and 0.62 or 0.38,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})or nil,
})

local av
if ar.Value~=nil then
av=aa.NewRoundFrame(999,"Squircle",{
Name="Value",
Size=UDim2.new(0,0,0,26),
AutomaticSize="X",
ImageTransparency=0.88,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
aj("TextLabel",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=tostring(ar.Value),
TextSize=12,
TextTransparency=0.12,
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
}),
})
end

local aw=aa.NewRoundFrame(14,"Squircle",{
Name="Action",
LayoutOrder=aq,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ar.Disabled and 0.96 or 0.92,
Parent=ap.UIElements.List,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
as,
au,
av,
},not ar.Disabled)

if not ar.Disabled then
ag.AttachPress(aw,aa,{
Amount=0.985,
})
aa.AddSignal(aw.MouseButton1Click,function()
if typeof(ar.Callback)=="function"then
aa.SafeCallback(ar.Callback,ar,aq)
elseif typeof(ao.Callback)=="function"then
aa.SafeCallback(ao.Callback,ar,aq)
end
end)
end

table.insert(ap.Rows,aw)
end
end

function ap.SetActions(aq,ar)
ap.Actions=NormalizeActions(ar)
Render()
return ap.Actions
end

function ap.AddAction(aq,ar)
local as=NormalizeActions{ar}[1]
if as then
table.insert(ap.Actions,as)
Render()
end
return as
end

Render()

return ap.__type,ap
end

return am end function a.am()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local function NormalizeMeters(an)
local ao={}

for ap,aq in next,an or{}do
if typeof(aq)=="table"then
local ar=al.ToFiniteNumber(aq.Max)or 100
local as=al.ToFiniteNumber(aq.Value or aq.Default)or 0
table.insert(ao,{
Title=tostring(aq.Title or aq.Name or("Meter "..tostring(ap))),
Value=math.clamp(as,0,ar),
Max=math.max(ar,0.0001),
Desc=aq.Desc,
Color=al.GetColor(aq.Color,nil),
Format=aq.Format,
})
else
table.insert(ao,{
Title=tostring(ap),
Value=math.clamp(al.ToFiniteNumber(aq)or 0,0,100),
Max=100,
})
end
end

return ao
end

function am.New(an,ao)
local ap={
__type="MeterGroup",
Title=ao.Title or"Meters",
Desc=ao.Desc,
Meters=NormalizeMeters(ao.Meters or ao.Items or ao.Values or{}),
Rows={},
UIElements={},
}

ap.MeterGroupFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=0,
Hover=ao.Hover==true,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.List=aj("Frame",{
Name="MeterGroup",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.MeterGroupFrame.UIElements.Container,
},{
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

local function FormatValue(aq)
local ar=math.clamp(aq.Value/aq.Max,0,1)
if typeof(aq.Format)=="function"then
local as,at=pcall(aq.Format,aq.Value,aq.Max,ar)
if as and at~=nil then
return tostring(at)
end
end
return tostring(math.floor((ar*100)+0.5)).."%"
end

local function Render()
for aq,ar in next,ap.Rows do
ar.Frame:Destroy()
end
ap.Rows={}

for aq,ar in next,ap.Meters do
local as=math.clamp(ar.Value/ar.Max,0,1)
local at=aa.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(as,0,1,0),
ImageTransparency=0.08,
ImageColor3=ar.Color,
ThemeTag=not ar.Color and{
ImageColor3="Primary",
}or nil,
})

local au=aj("TextLabel",{
Name="Value",
Size=UDim2.new(0,52,0,18),
BackgroundTransparency=1,
Text=FormatValue(ar),
TextSize=12,
TextTransparency=0.22,
TextXAlignment="Right",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

local av=aj("Frame",{
Name="Meter",
LayoutOrder=aq,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.UIElements.List,
},{
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
aj("Frame",{
Name="Header",
Size=UDim2.new(1,0,0,18),
BackgroundTransparency=1,
},{
aj("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,-58,1,0),
BackgroundTransparency=1,
Text=ar.Title,
TextSize=13,
TextTransparency=0.1,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
}),
au,
}),
aa.NewRoundFrame(999,"Squircle",{
Name="Track",
Size=UDim2.new(1,0,0,7),
ImageTransparency=0.9,
ClipsDescendants=true,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
at,
}),
ar.Desc and aj("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=tostring(ar.Desc),
TextSize=12,
TextTransparency=0.42,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})or nil,
})

ap.Rows[aq]={
Frame=av,
Fill=at,
ValueLabel=au,
}
end
end

function ap.SetValue(aq,ar,as)
local at=ap.Meters[ar]
local au=ap.Rows[ar]
if not at or not au then
return nil
end

at.Value=math.clamp(al.ToFiniteNumber(as)or at.Value,0,at.Max)
local av=math.clamp(at.Value/at.Max,0,1)
au.ValueLabel.Text=FormatValue(at)
ag.Play(au.Fill,"Fast",{
Size=UDim2.new(av,0,1,0),
},nil,nil,"Meter")
return at.Value
end

function ap.SetMeters(aq,ar)
ap.Meters=NormalizeMeters(ar)
Render()
return ap.Meters
end

Render()

return ap.__type,ap
end

return am end function a.an()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

function am.New(an,ao)
local ap={
__type="Timeline",
Title=ao.Title or"Timeline",
Desc=ao.Desc,
Items=al.NormalizeItems(ao.Items or ao.Events or{}),
UIElements={},
Rows={},
}

ap.TimelineFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=0,
Hover=ao.Hover==true,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.List=aj("Frame",{
Name="TimelineList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.TimelineFrame.UIElements.Container,
},{
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

local function Render()
for aq,ar in next,ap.Rows do
ar:Destroy()
end
ap.Rows={}

for aq,ar in next,ap.Items do
local as=al.GetVariant(ar.Value)
local at=al.GetColor(ar.Color,as.Color)

local au=aa.NewRoundFrame(999,"Circle",{
Name="Dot",
Size=UDim2.new(0,10,0,10),
Position=UDim2.new(0.5,0,0,5),
AnchorPoint=Vector2.new(0.5,0),
ImageTransparency=1,
ImageColor3=at,
})

local av=aj("Frame",{
Name="Rail",
Size=UDim2.new(0,24,0,ar.Desc and 46 or 30),
BackgroundTransparency=1,
},{
aj("Frame",{
Name="Line",
Size=UDim2.new(0,1,1,aq==#ap.Items and-8 or 0),
Position=UDim2.new(0.5,0,0,16),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=0.86,
ThemeTag={
BackgroundColor3="TimelineLine",
},
}),
au,
})

local aw=aj("Frame",{
Name="Text",
Size=UDim2.new(1,-32,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
aj("UIListLayout",{
Padding=UDim.new(0,3),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
al.CreateText(aj,aa,ar.Title,14,nil,0),
ar.Desc and al.CreateText(aj,aa,ar.Desc,13,nil,0.4)or nil,
})

local ax=aj("Frame",{
Name="Item",
LayoutOrder=aq,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.UIElements.List,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
av,
aw,
})

table.insert(ap.Rows,ax)
task.delay((aq-1)*0.025,function()
if au.Parent then
ag.Play(au,"Reveal",{ImageTransparency=0},nil,nil,"Reveal")
end
end)
end
end

function ap.SetItems(aq,ar)
ap.Items=al.NormalizeItems(ar or{})
Render()
return ap.Items
end

Render()

return ap.__type,ap
end

return am end function a.ao()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local an=34

function am.New(ao,ap)
local aq={
__type="Accordion",
Title=ap.Title or"Accordion",
Desc=ap.Desc,
Items=al.NormalizeItems(ap.Items or ap.Sections or{}),
OpenIndex=al.ToFiniteNumber(ap.OpenIndex or ap.DefaultOpen),
Multiple=ap.Multiple==true,
UIElements={},
Rows={},
}

local ar={}
if aq.OpenIndex then
ar[aq.OpenIndex]=true
end

aq.AccordionFrame=a.load'I'{
Title=aq.Title,
Desc=aq.Desc,
Parent=ap.Parent,
TextOffset=0,
Hover=ap.Hover==true,
Tab=ap.Tab,
Index=ap.Index,
Window=ap.Window,
ElementTable=aq,
ParentConfig=ap,
Tags=ap.Tags,
}

aq.UIElements.List=aj("Frame",{
Name="AccordionList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aq.AccordionFrame.UIElements.Container,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

local function GetOpenHeight(as)
return an+(as.Content.AbsoluteSize.Y/ap.UIScale)+10
end

local function SetRowOpen(as,at,au)
local av=aq.Rows[as]
if not av then
return
end

ar[as]=at or nil
av.Open=at

local aw=UDim2.new(1,0,0,at and GetOpenHeight(av)or an)
if au then
av.Frame.Size=aw
av.Chevron.Rotation=at and 180 or 0
else
ag.Play(av.Frame,"Expand",{Size=aw},nil,nil,"Expand")
ag.Play(av.Chevron,"Expand",{Rotation=at and 180 or 0},nil,nil,"Chevron")
end
end

local function Render()
for as,at in next,aq.Rows do
at.Frame:Destroy()
end
aq.Rows={}

for as,at in next,aq.Items do
local au=al.CreateIcon(aa,at.Icon,ap.Window.Folder,"Accordion",true,"AccordionIcon")
if au then
au.Size=UDim2.new(0,16,0,16)
end

local av=aa.Icon"chevron-down"
local aw=aj("ImageLabel",{
Name="Chevron",
Size=UDim2.new(0,16,0,16),
BackgroundTransparency=1,
Image=av[1],
ImageRectOffset=av[2].ImageRectPosition,
ImageRectSize=av[2].ImageRectSize,
ImageTransparency=0.4,
ThemeTag={
ImageColor3="Icon",
},
})

local ax=aj("TextButton",{
Name="Header",
Size=UDim2.new(1,0,0,an),
BackgroundTransparency=1,
Text="",
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
au,
aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,au and-48 or-24,1,0),
BackgroundTransparency=1,
Text=at.Title,
TextSize=14,
TextTruncate="AtEnd",
TextXAlignment="Left",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
}),
aw,
})

local ay=aj("Frame",{
Name="Content",
Size=UDim2.new(1,-20,0,0),
Position=UDim2.new(0,10,0,an),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
al.CreateText(aj,aa,at.Desc or"",13,nil,0.4),
})

local az=aa.NewRoundFrame(12,"Squircle",{
Name="Item",
LayoutOrder=as,
Size=UDim2.new(1,0,0,an),
ClipsDescendants=true,
ImageTransparency=0.94,
ThemeTag={
ImageColor3="AccordionBackground",
},
Parent=aq.UIElements.List,
},{
ax,
ay,
})

aq.Rows[as]={
Frame=az,
Header=ax,
Content=ay,
Chevron=aw,
Open=false,
}

ag.AttachPress(ax,aa,{
Amount=0.985,
})

aa.AddSignal(ax.MouseButton1Click,function()
aq:Toggle(as)
end)

aa.AddSignal(ay:GetPropertyChangedSignal"AbsoluteSize",function()
if aq.Rows[as]and aq.Rows[as].Open then
SetRowOpen(as,true,true)
end
end)
end

for as in next,ar do
SetRowOpen(as,true,true)
end
end

function aq.Open(as,at)
if not aq.Multiple then
for au in next,ar do
if au~=at then
SetRowOpen(au,false)
end
end
end

SetRowOpen(at,true)
end

function aq.Close(as,at)
SetRowOpen(at,false)
end

function aq.Toggle(as,at)
local au=aq.Rows[at]
if not au then
return
end
if au.Open then
aq:Close(at)
else
aq:Open(at)
end
end

function aq.SetItems(as,at)
aq.Items=al.NormalizeItems(at or{})
ar={}
Render()
return aq.Items
end

Render()

return aq.__type,aq
end

return am end function a.ap()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'n'.New

local am={}

function am.New(an,ao)
local ap={
__type="EmptyState",
Title=ao.Title or"Nothing here",
Desc=ao.Desc or ao.Content,
Icon=ao.Icon or"inbox",
Buttons=ao.Buttons or{},
UIElements={},
}

local aq=math.max(tonumber(ao.Height)or 138,96)

ap.UIElements.Main=aa.NewRoundFrame(ao.Window.ElementConfig.UICorner,"Squircle",{
Name="EmptyState",
Size=UDim2.new(1,0,0,aq),
AutomaticSize=#ap.Buttons>0 and"Y"or"None",
ImageTransparency=0.94,
Parent=ao.Parent,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})

local ar=aa.Image(ap.Icon,ap.Icon,0,ao.Window.Folder,"EmptyState",true,true,"EmptyStateIcon")
ar.Size=UDim2.new(0,tonumber(ao.IconSize)or 34,0,tonumber(ao.IconSize)or 34)
ar.ImageLabel.ImageTransparency=0.2
ar.Parent=ap.UIElements.Main

ap.UIElements.Title=aj("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Text=ap.Title,
TextSize=17,
TextWrapped=true,
TextXAlignment="Center",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(aa.Font),
Parent=ap.UIElements.Main,
ThemeTag={
TextColor3="Text",
},
})

ap.UIElements.Desc=aj("TextLabel",{
Name="Desc",
BackgroundTransparency=1,
Text=ap.Desc or"",
TextSize=14,
TextTransparency=0.4,
TextWrapped=true,
TextXAlignment="Center",
AutomaticSize="Y",
Visible=ap.Desc~=nil,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(aa.Font),
Parent=ap.UIElements.Main,
ThemeTag={
TextColor3="Text",
},
})

if#ap.Buttons>0 then
local as=aj("Frame",{
Name="Buttons",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Center",
}),
})

for at,au in next,ap.Buttons do
local av=al(
au.Title,
au.Icon,
au.Callback,
au.Variant or"White",
as,
nil,
nil,
ao.Window.NewElements and 999 or 10
)
av.Size=UDim2.new(1,0,0,36)
end
end

function ap.SetTitle(as,at)
ap.Title=at
ap.UIElements.Title.Text=at
end

function ap.SetDesc(as,at)
ap.Desc=at
ap.UIElements.Desc.Text=at or""
ap.UIElements.Desc.Visible=at~=nil
end

function ap.Highlight(as)
ag.Play(ap.UIElements.Main,"Highlight",{ImageTransparency=0.9},nil,nil,"Highlight")
task.delay(ag.GetDuration"Highlight",function()
if ap.UIElements.Main.Parent then
ag.Play(ap.UIElements.Main,"Highlight",{ImageTransparency=0.94},nil,nil,"Highlight")
end
end)
end

function ap.Destroy(as)
ap.UIElements.Main:Destroy()
end

return ap.__type,ap
end

return am end function a.aq()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local an=Color3.fromHex"#5865F2"
local ao=Color3.fromHex"#1E1F2A"

local function Trim(ap)
ap=tostring(ap or"")
ap=string.gsub(ap,"^%s+","")
ap=string.gsub(ap,"%s+$","")
return ap
end

local function GetInviteUrl(ap)
local aq=Trim(ap)
if aq==""then
return"https://discord.gg/"
end

if string.match(aq,"^https?://")then
return aq
end
if string.match(aq,"^discord%.gg/")or string.match(aq,"^discord%.com/invite/")then
return"https://"..aq
end

return"https://discord.gg/"..aq
end

local function CopyText(ap)
if typeof(setclipboard)=="function"then
local aq=pcall(function()
setclipboard(ap)
end)
return aq
end
if typeof(toclipboard)=="function"then
local aq=pcall(function()
toclipboard(ap)
end)
return aq
end
return false
end

local function Notify(ap,aq,ar,as,at)
if ap and ap.Notify then
ap:Notify{
Title=aq,
Content=ar,
Icon=as,
Style=at,
}
end
end

function am.New(ap,aq)
local ar=aq.Url or aq.Invite or aq.InviteCode or aq.Code
local as=GetInviteUrl(ar)
local at={
__type="DiscordCard",
Title=aq.Title or aq.ServerName or"Discord Server",
Desc=aq.Desc or aq.Content or"Join the community and get updates.",
Invite=ar,
Url=as,
Icon=aq.Icon or"message-circle",
Members=aq.Members or aq.MemberCount,
Online=aq.Online or aq.OnlineCount,
Callback=aq.Callback,
UIElements={},
}

local au=math.max(tonumber(aq.Height)or 152,126)

at.UIElements.Main=aa.NewRoundFrame(aq.Window.ElementConfig.UICorner,"Squircle",{
Name="DiscordCard",
Size=UDim2.new(1,0,0,au),
AutomaticSize="Y",
ImageColor3=ao,
ImageTransparency=0,
Parent=aq.Parent,
},{
aj("UIGradient",{
Rotation=22,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,ao),
ColorSequenceKeypoint.new(1,an),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.02),
NumberSequenceKeypoint.new(1,0.18),
},
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,14),
PaddingLeft=UDim.new(0,14),
PaddingRight=UDim.new(0,14),
PaddingBottom=UDim.new(0,14),
}),
aj("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

local av=aj("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=at.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local aw=aa.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,42,0,42),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.9,
Parent=av,
},{
al.CreateIcon(aa,at.Icon,aq.Window.Folder,"DiscordCard",false,nil),
})

local ax=aw:FindFirstChildWhichIsA"Frame"or aw:FindFirstChildWhichIsA"ImageLabel"
if ax then
ax.Size=UDim2.new(0,20,0,20)
ax.Position=UDim2.new(0.5,0,0.5,0)
ax.AnchorPoint=Vector2.new(0.5,0.5)
local ay=al.GetImageTarget(ax)
if ay then
ay.ImageColor3=Color3.new(1,1,1)
ay.ImageTransparency=0
end
end

local ay=aj("Frame",{
Size=UDim2.new(1,-52,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=av,
},{
aj("UIListLayout",{
Padding=UDim.new(0,3),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

at.UIElements.Title=aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=at.Title,
TextSize=18,
TextWrapped=true,
TextXAlignment="Left",
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aa.Font),
Parent=ay,
})

at.UIElements.Desc=aj("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=at.Desc,
TextSize=13,
TextWrapped=true,
TextXAlignment="Left",
TextColor3=Color3.new(1,1,1),
TextTransparency=0.26,
FontFace=Font.new(aa.Font),
Parent=ay,
})

local az=aj("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=at.Members~=nil or at.Online~=nil,
Parent=at.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Left",
VerticalAlignment="Center",
}),
})

local function CreateStat(aA,aB,aC)
return aa.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,0,0,28),
AutomaticSize="X",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.9,
Parent=az,
},{
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aa.NewRoundFrame(999,"Circle",{
Size=UDim2.new(0,7,0,7),
ImageColor3=aC,
}),
aj("TextLabel",{
BackgroundTransparency=1,
Text=tostring(aB).." "..aA,
TextSize=12,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.08,
AutomaticSize="XY",
FontFace=Font.new(aa.Font),
}),
})
end

if at.Members then
CreateStat("members",at.Members,Color3.fromHex"#B6C2FF")
end
if at.Online then
CreateStat("online",at.Online,Color3.fromHex"#23A55A")
end

local aA=aj("Frame",{
Size=UDim2.new(1,0,0,36),
BackgroundTransparency=1,
Parent=at.UIElements.Main,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Center",
}),
})

local function CreateButton(aB,aC,aD,aE)
local aF=aa.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0.5,-4,1,0),
ImageColor3=aD=="Primary"and Color3.new(1,1,1)or Color3.new(1,1,1),
ImageTransparency=aD=="Primary"and 0.08 or 0.9,
Parent=aA,
},{
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
aj("UIListLayout",{
Padding=UDim.new(0,7),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
al.CreateIcon(aa,aC,aq.Window.Folder,"DiscordCard",false,nil),
aj("TextLabel",{
BackgroundTransparency=1,
Text=aB,
TextSize=13,
TextColor3=aD=="Primary"and Color3.fromHex"#111827"or Color3.new(1,1,1),
TextTransparency=0,
FontFace=Font.new(aa.Font),
AutomaticSize="XY",
}),
},true)

local aG=aF:FindFirstChildWhichIsA"Frame"or aF:FindFirstChildWhichIsA"ImageLabel"
local aH=al.GetImageTarget(aG)
if aH then
aH.ImageColor3=aD=="Primary"and Color3.fromHex"#111827"or Color3.new(1,1,1)
aH.ImageTransparency=0
end

ag.AttachPress(aF,aa,{
Amount=0.97,
})

aa.AddSignal(aF.MouseButton1Click,function()
aa.SafeCallback(aE)
end)

return aF
end

local function CopyInvite(aB)
if CopyText(at.Url)then
Notify(aq.WindUI,aB or"Discord link copied",at.Url,"check","Success")
return true
else
Notify(aq.WindUI,"Discord invite",at.Url,"link","Warning")
return false
end
end

CreateButton(aq.CopyTitle or"Copy Link","link","Secondary",function()
CopyInvite"Discord link copied"
end)

CreateButton(aq.JoinTitle or"Join","external-link","Primary",function()
if at.Callback then
aa.SafeCallback(at.Callback,at.Url,at)
end

CopyInvite"Discord invite ready"
end)

function at.SetInvite(aB,aC)
at.Invite=aC
at.Url=GetInviteUrl(aC)
return at.Url
end

function at.GetUrl(aB)
return at.Url
end

function at.Copy(aB)
return CopyInvite"Discord link copied"
end

function at.Open(aB)
if at.Callback then
aa.SafeCallback(at.Callback,at.Url,at)
end
return CopyInvite"Discord invite ready"
end

function at.SetTitle(aB,aC)
at.Title=aC
at.UIElements.Title.Text=aC
end

function at.SetDesc(aB,aC)
at.Desc=aC
at.UIElements.Desc.Text=aC or""
end

function at.Highlight(aB)
ag.Play(at.UIElements.Main,"Highlight",{ImageTransparency=0.08},nil,nil,"Highlight")
task.delay(ag.GetDuration"Highlight",function()
if at.UIElements.Main.Parent then
ag.Play(at.UIElements.Main,"Highlight",{ImageTransparency=0},nil,nil,"Highlight")
end
end)
end

function at.Destroy(aB)
at.UIElements.Main:Destroy()
end

return at.__type,at
end

return am end function a.ar()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

function am.New(an,ao)
local ap={
__type="TabBox",
Title=ao.Title or"Tabs",
Desc=ao.Desc,
Tabs={},
Selected=nil,
SelectedValue=nil,
UIElements={},
}

ap.TabBoxFrame=a.load'I'{
Title=ap.Title,
Desc=ap.Desc,
Parent=ao.Parent,
TextOffset=0,
Hover=ao.Hover==true,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=ap,
ParentConfig=ao,
Tags=ao.Tags,
}

ap.UIElements.Tabs=aj("ScrollingFrame",{
Name="Tabs",
Size=UDim2.new(1,0,0,ao.TabHeight or 36),
BackgroundTransparency=1,
ScrollBarThickness=0,
ScrollingDirection="X",
ScrollingEnabled=true,
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
ElasticBehavior="Never",
Active=true,
Parent=ap.TabBoxFrame.UIElements.Container,
},{
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

ap.UIElements.Pages=aj("Frame",{
Name="Pages",
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=1,
ClipsDescendants=false,
Parent=ap.TabBoxFrame.UIElements.Container,
})

local function UpdateTabVisuals()
for aq,ar in next,ap.Tabs do
local as=ap.Selected==aq
ag.Play(ar.Button,"Switch",{ImageTransparency=as and 0.82 or 0.94},nil,nil,"State")
ag.Play(ar.TitleLabel,"Switch",{TextTransparency=as and 0 or 0.25},nil,nil,"State")
if ar.IconTarget then
ag.Play(ar.IconTarget,"Switch",{ImageTransparency=as and 0 or 0.35},nil,nil,"State")
end
end
end

local function GetPageHeight(aq)
local ar=aq.UIElements.Container.UIListLayout
local as=ao.Window.ElementConfig.UIPadding/2
local at=ar.AbsoluteContentSize.Y/ao.UIScale+as
return math.max(at,as)
end

local function UpdatePageHeight(aq)
if not aq or not aq.UIElements.Container then
return
end

local ar=GetPageHeight(aq)
aq.UIElements.Container.Size=UDim2.new(1,0,0,ar)
ap.UIElements.Pages.Size=UDim2.new(1,0,0,ar)
return ar
end

local function ScrollTabIntoView(aq)
task.defer(function()
if not aq or not aq.Button or not aq.Button.Parent then
return
end

local ar=ap.UIElements.Tabs
local as=ar.AbsoluteSize.X
local at=aq.Button.AbsolutePosition.X-ar.AbsolutePosition.X+ar.CanvasPosition.X
local au=at+aq.Button.AbsoluteSize.X
local av=ar.CanvasPosition.X
local aw=av+as
local ax=av

if at<av then
ax=at
elseif au>aw then
ax=au-as
end

if math.abs(ax-av)>1 then
ar.CanvasPosition=Vector2.new(math.max(ax,0),0)
end
end)
end

local function QueuePageHeightUpdate(aq,ar)
task.defer(function()
if ap.Selected==ar and aq and aq.UIElements.Container.Parent then
UpdatePageHeight(aq)
end
end)
end

function ap.Select(aq,ar)
local as=ap.Tabs[ar]
if not as then
return nil
end

ap.Selected=ar
ap.SelectedValue=as.Value
for at,au in next,ap.Tabs do
local av=at==ar
au.UIElements.Container.Visible=av
au.UIElements.Container.Active=av
au.UIElements.Container.GroupTransparency=1
if av then
au.UIElements.Container.Position=UDim2.new(0,0,0,8)
end
end

UpdatePageHeight(as)
ag.Play(as.UIElements.Container,"Switch",{GroupTransparency=0},nil,nil,"Page")
ag.Play(as.UIElements.Container,"Switch",{Position=UDim2.new(0,0,0,0)},nil,nil,"PageSlide")
QueuePageHeightUpdate(as,ar)
UpdateTabVisuals()
ScrollTabIntoView(as)
return as
end

function ap.GetSelected(aq)
return ap.Selected and ap.Tabs[ap.Selected]or nil
end

function ap.Get(aq)
return ap.SelectedValue
end

function ap.SelectValue(aq,ar)
for as,at in next,ap.Tabs do
if at.Value==ar then
return ap:Select(as)
end
end
return nil
end

function ap.Set(aq,ar)
return ap:SelectValue(ar)
end

function ap.Tab(aq,ar)
ar=ar or{}
local as=#ap.Tabs+1
local at={
__type="TabBoxPage",
Title=ar.Title or("Tab "..tostring(as)),
Value=ar.Value or ar.Id or as,
Icon=ar.Icon,
Elements={},
UIElements={},
Gap=ao.Tab and ao.Tab.Gap or 6,
}

local au=al.CreateIcon(aa,at.Icon,ao.Window.Folder,"TabBox",true,"TabBoxIcon")
if au then
au.Size=UDim2.new(0,15,0,15)
end
local av=al.GetImageTarget(au)
local aw=string.len(at.Title)*(ao.Window.IsPC==false and 6 or 7)
local ax=math.clamp(aw+(au and 40 or 26),ao.MinTabWidth or 68,ao.MaxTabWidth or 154)

local ay=aj("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Text=at.Title,
TextSize=ao.Window.IsPC==false and 12 or 13,
TextTruncate="AtEnd",
Size=UDim2.new(0,math.max(ax-(au and 42 or 20),24),1,0),
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
})

local az=aa.NewRoundFrame(999,"Squircle",{
Name="Tab",
LayoutOrder=as,
Size=UDim2.new(0,ax,0,ao.TabButtonHeight or 30),
ImageTransparency=0.94,
ClipsDescendants=true,
ThemeTag={
ImageColor3="TabBoxTabBackground",
},
Parent=ap.UIElements.Tabs,
},{
aj("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
au,
ay,
},true)

local aA=aj("CanvasGroup",{
Name="Page",
LayoutOrder=as,
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
GroupTransparency=1,
Visible=false,
Active=false,
Parent=ap.UIElements.Pages,
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,ao.Window.ElementConfig.UIPadding/2),
}),
aj("UIListLayout",{
Padding=UDim.new(0,at.Gap),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

at.Button=az
at.TitleLabel=ay
at.Icon=au
at.IconTarget=av
at.ElementFrame=aA
at.UIElements.Container=aA
at.UIElements.Title=ay

ao.ElementsModule.Load(
at,
aA,
ao.ElementsModule.Elements,
ao.Window,
ao.WindUI,
function()
QueuePageHeightUpdate(at,as)
end,
ao.ElementsModule,
ao.UIScale,
ao.Tab
)

function at.Select(aB)
return ap:Select(as)
end

function at.Destroy(aB)
az:Destroy()
aA:Destroy()
table.remove(ap.Tabs,as)
if ap.Selected==as then
ap.Selected=nil
if ap.Tabs[1]then
ap:Select(1)
end
end
end

ap.Tabs[as]=at

ag.AttachPress(az,aa,{
Amount=0.97,
})

aa.AddSignal(az.MouseButton1Click,function()
ap:Select(as)
end)

aa.AddSignal(aA.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
QueuePageHeightUpdate(at,as)
end)

if not ap.Selected or ar.Selected==true or ar.Value==ao.Value then
ap:Select(as)
else
UpdateTabVisuals()
end

if typeof(ar.Elements)=="function"then
task.defer(function()
aa.SafeCallback(ar.Elements,at)
end)
end

return at
end

function ap.CreateTab(aq,ar)
return ap:Tab(ar)
end

for aq,ar in next,ao.Tabs or{}do
ap:Tab(ar)
end

return ap.__type,ap
end

return am end function a.as()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local an={
Vector2.new(0.08,0.72),
Vector2.new(0.28,0.38),
Vector2.new(0.52,0.56),
Vector2.new(0.72,0.24),
Vector2.new(0.92,0.42),
}

local ao=92
local ap=22

local function NormalizePoint(aq)
if typeof(aq)=="Vector2"then
return Vector2.new(math.clamp(aq.X,0,1),math.clamp(aq.Y,0,1))
end

if typeof(aq)=="table"then
local ar=al.ToFiniteNumber(aq.X or aq.x or aq[1])or 0
local as=al.ToFiniteNumber(aq.Y or aq.y or aq[2])or 0
return Vector2.new(math.clamp(ar,0,1),math.clamp(as,0,1))
end

return Vector2.new(0,0)
end

local function NormalizePoints(aq)
local ar={}
local as=typeof(aq)=="table"and aq or an

if#as>0 then
for at=1,#as do
table.insert(ar,NormalizePoint(as[at]))
end
else
for at,au in next,as do
table.insert(ar,NormalizePoint(au))
end
end

if#ar<2 then
ar=an
end

return ar
end

local function PointToUDim2(aq)
return UDim2.new(aq.X,0,aq.Y,0)
end

local function PixelToUDim2(aq)
return UDim2.fromOffset(aq.X,aq.Y)
end

local function GetTweenPoint(aq,ar,as)
return aq:Lerp(ar,math.clamp(as,0,1))
end

local function GetAngle(aq,ar)
if math.atan2 then
return math.atan2(aq,ar)
end

if ar==0 then
return aq>=0 and math.pi/2 or-math.pi/2
end

local as=math.atan(aq/ar)
if ar<0 then
as+=math.pi
end
return as
end

function am.New(aq,ar)
local as={
__type="Path2D",
Title=ar.Title or"Path 2D",
Desc=ar.Desc,
Points=NormalizePoints(ar.Points or ar.Path),
Labels=ar.Labels or{},
Height=math.max(al.ToFiniteNumber(ar.Height)or 156,96),
Thickness=math.max(al.ToFiniteNumber(ar.Thickness)or 4,2),
Padding=math.max(al.ToFiniteNumber(ar.PathPadding or ar.Padding)or 20,0),
DotSize=math.max(al.ToFiniteNumber(ar.DotSize)or 9,5),
MarkerSize=math.max(al.ToFiniteNumber(ar.MarkerSize)or 16,10),
Duration=math.max(al.ToFiniteNumber(ar.Duration)or 1.2,0.18),
StepDelay=math.max(al.ToFiniteNumber(ar.StepDelay)or 0.055,0),
Loop=ar.Loop==true,
AutoPlay=ar.AutoPlay~=false,
Glow=ar.Glow~=false,
UIElements={},
Segments={},
Dots={},
LabelObjects={},
PlayToken=0,
HasRendered=false,
Destroyed=false,
}

as.Path2DFrame=a.load'I'{
Title=as.Title,
Desc=as.Desc,
Parent=ar.Parent,
TextOffset=0,
Hover=ar.Hover==true,
Tab=ar.Tab,
Index=ar.Index,
Window=ar.Window,
ElementTable=as,
ParentConfig=ar,
Tags=ar.Tags,
}

as.UIElements.Canvas=aa.NewRoundFrame(ar.Window.ElementConfig.UICorner,"Squircle",{
Name="Path2DCanvas",
Size=UDim2.new(1,0,0,as.Height),
ClipsDescendants=true,
ImageTransparency=aa.ClampTransparency(ar.BackgroundTransparency,0.92),
Parent=as.Path2DFrame.UIElements.Container,
ThemeTag={
ImageColor3="Path2DBackground",
},
},{
aj("UIGradient",{
Rotation=25,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.08),
NumberSequenceKeypoint.new(1,0.28),
},
}),
})

local function ClearObjects()
for at,au in next,as.Segments do
au.Track:Destroy()
end
for at,au in next,as.Dots do
au:Destroy()
end
for at,au in next,as.LabelObjects do
au:Destroy()
end
if as.UIElements.Marker then
as.UIElements.Marker:Destroy()
as.UIElements.Marker=nil
end

as.Segments={}
as.Dots={}
as.LabelObjects={}
end

local function GetCanvasSize()
local at=as.UIElements.Canvas.AbsoluteSize
return Vector2.new(at.X/ar.UIScale,at.Y/ar.UIScale)
end

local function GetPixelPoint(at,au)
local av=math.min(as.Padding,math.max(au.X,au.Y)/3)
local aw=Vector2.new(
math.max(au.X-(av*2),1),
math.max(au.Y-(av*2),1)
)

return Vector2.new(
av+(at.X*aw.X),
av+(at.Y*aw.Y)
)
end

local function GetLabelPosition(at,au,av)
local aw=math.max(al.ToFiniteNumber(av.Width)or ao,54)
local ax=math.max(al.ToFiniteNumber(av.Height)or ap,18)
local ay=al.ToFiniteNumber(av.OffsetX)or 0
local az=al.ToFiniteNumber(av.OffsetY)
if az==nil then
az=av.Above==false and 18 or-18
end

return Vector2.new(
math.clamp(at.X+ay,(aw/2)+6,math.max((aw/2)+6,au.X-(aw/2)-6)),
math.clamp(at.Y+az,(ax/2)+6,math.max((ax/2)+6,au.Y-(ax/2)-6))
),aw,ax
end

function as.Render(at,au)
local av=GetCanvasSize()
if av.X<=0 or av.Y<=0 then
return
end

local aw=au~=false and as.AutoPlay
as.PlayToken=as.PlayToken+1
as.HasRendered=true
ClearObjects()

for ax=1,#as.Points-1 do
local ay=GetPixelPoint(as.Points[ax],av)
local az=GetPixelPoint(as.Points[ax+1],av)
local aA=az-ay
local aB=aA.Magnitude
local aC=math.deg(GetAngle(aA.Y,aA.X))
local aD=(ay+az)/2

local aE=aa.NewRoundFrame(999,"Squircle",{
Name="Segment"..tostring(ax),
Size=UDim2.new(0,aB,0,as.Thickness),
Position=PixelToUDim2(aD),
AnchorPoint=Vector2.new(0.5,0.5),
Rotation=aC,
ImageTransparency=0.84,
Parent=as.UIElements.Canvas,
ZIndex=2,
ThemeTag={
ImageColor3="Path2DTrack",
},
})

local aF=as.Glow and aa.NewRoundFrame(999,"Squircle",{
Name="Glow",
Size=UDim2.new(0,aw and 0 or aB,0,as.Thickness+8),
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=0.84,
ZIndex=2,
Parent=aE,
ThemeTag={
ImageColor3="Path2DLine",
},
})or nil

local aG=aa.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(0,aw and 0 or aB,1,0),
ImageTransparency=0,
ZIndex=3,
Parent=aE,
ThemeTag={
ImageColor3="Path2DLine",
},
})

table.insert(as.Segments,{
Track=aE,
Glow=aF,
Fill=aG,
Length=aB,
From=as.Points[ax],
To=as.Points[ax+1],
FromPixel=ay,
ToPixel=az,
FromPosition=PixelToUDim2(ay),
ToPosition=PixelToUDim2(az),
})
end

for ax=1,#as.Points do
local ay=as.Points[ax]
local az=GetPixelPoint(ay,av)
local aA=ax==1 and as.DotSize+3 or as.DotSize
local aB=aa.NewRoundFrame(999,"Circle",{
Name="Point"..tostring(ax),
Size=UDim2.new(0,aA,0,aA),
Position=PixelToUDim2(az),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=aw and 0.54 or 0.12,
Parent=as.UIElements.Canvas,
ZIndex=4,
ThemeTag={
ImageColor3=ax==#as.Points and"Path2DMarker"or"Path2DLine",
},
},{
aa.NewRoundFrame(999,"Circle",{
Name="DotCore",
Size=UDim2.new(0,math.max(aA-5,3),0,math.max(aA-5,3)),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.22,
ZIndex=5,
}),
})
table.insert(as.Dots,aB)
end

for ax,ay in next,as.Labels do
if typeof(ay)~="table"then
ay={
Text=tostring(ay),
}
end
local az=math.clamp(math.floor(al.ToFiniteNumber(ay.Point or ay.Index)or 1),1,#as.Points)
local aA=GetPixelPoint(as.Points[az],av)
local aB,aC,aD=GetLabelPosition(aA,av,ay)
local aE=aj("TextLabel",{
Name="PathLabel",
Size=UDim2.new(0,aC,0,aD),
Position=PixelToUDim2(aB),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Text=tostring(ay.Text or ay.Title or az),
TextSize=12,
TextTransparency=0.22,
TextXAlignment="Center",
FontFace=Font.new(aa.Font),
Parent=as.UIElements.Canvas,
ZIndex=6,
ThemeTag={
TextColor3="Path2DLabel",
},
})
table.insert(as.LabelObjects,aE)
end

local ax=aa.NewRoundFrame(999,"Circle",{
Name="Marker",
Size=UDim2.new(0,as.MarkerSize,0,as.MarkerSize),
Position=aw and as.Segments[1]and as.Segments[1].FromPosition
or PixelToUDim2(GetPixelPoint(as.Points[#as.Points],av)),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=0,
Parent=as.UIElements.Canvas,
ZIndex=8,
ThemeTag={
ImageColor3="Path2DMarker",
},
},{
aa.NewRoundFrame(999,"Circle",{
Name="Halo",
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=0.78,
ZIndex=7,
ThemeTag={
ImageColor3="Path2DMarker",
},
}),
aa.NewRoundFrame(999,"Circle",{
Name="Core",
Size=UDim2.new(0,6,0,6),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ZIndex=9,
}),
})
as.UIElements.Marker=ax

if aw then
as:Play()
end
end

function as.Play(at)
as.PlayToken=as.PlayToken+1
local au=as.PlayToken
local av=as.Duration/math.max(#as.Segments,1)

if as.UIElements.Marker then
as.UIElements.Marker.Position=as.Segments[1]and as.Segments[1].FromPosition
or PointToUDim2(as.Points[1])
end
for aw,ax in next,as.Dots do
ax.ImageTransparency=0.72
end
for aw,ax in next,as.Segments do
ax.Fill.Size=UDim2.new(0,0,1,0)
if ax.Glow then
ax.Glow.Size=UDim2.new(0,0,0,as.Thickness+8)
end
end

for aw=1,#as.Segments do
local ax=as.Segments[aw]
local ay=(aw-1)*(av+as.StepDelay)
task.delay(ay,function()
if au~=as.PlayToken or as.Destroyed then
return
end

if as.Dots[aw]then
ag.Play(as.Dots[aw],"Reveal",{ImageTransparency=0.12},nil,nil,"Point")
end
ag.Play(
ax.Fill,
av,
{Size=UDim2.new(0,ax.Length,1,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Draw"
)
if ax.Glow then
ag.Play(
ax.Glow,
av,
{Size=UDim2.new(0,ax.Length,0,as.Thickness+8)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Glow"
)
end
if as.UIElements.Marker then
ag.Play(
as.UIElements.Marker,
av,
{Position=ax.ToPosition},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Path"
)
end
end)
end

local aw=#as.Segments*(av+as.StepDelay)
task.delay(aw,function()
if au~=as.PlayToken or as.Destroyed then
return
end
if as.Dots[#as.Dots]then
ag.Play(as.Dots[#as.Dots],"Reveal",{ImageTransparency=0},nil,nil,"Point")
end
if as.Loop then
task.delay(0.4,function()
if au==as.PlayToken and not as.Destroyed then
as:Play()
end
end)
end
end)
end

function as.Stop(at)
as.PlayToken=as.PlayToken+1
if as.UIElements.Marker then
ag.Cancel(as.UIElements.Marker,"Path")
end
for au,av in next,as.Segments do
ag.Cancel(av.Fill,"Draw")
if av.Glow then
ag.Cancel(av.Glow,"Glow")
end
end
end

function as.SetProgress(at,au)
as:Stop()
local av=math.clamp(al.ToFiniteNumber(au)or 0,0,1)
if#as.Segments==0 then
return av
end

local aw=math.max(#as.Segments,1)
local ax=av*aw

for ay=1,#as.Segments do
local az=as.Segments[ay]
local aA=math.clamp(ax-(ay-1),0,1)
az.Fill.Size=UDim2.new(0,az.Length*aA,1,0)
if az.Glow then
az.Glow.Size=UDim2.new(0,az.Length*aA,0,as.Thickness+8)
end
end

local ay=math.clamp(math.ceil(ax),1,#as.Segments)
local az=as.Segments[ay]
if az and as.UIElements.Marker then
local aA=math.clamp(ax-(ay-1),0,1)
as.UIElements.Marker.Position=PixelToUDim2(
GetTweenPoint(az.FromPixel,az.ToPixel,aA)
)
end

for aA=1,#as.Dots do
local aB=as.Dots[aA]
aB.ImageTransparency=aA<=math.floor(ax)+1 and 0.12 or 0.54
end

return av
end

function as.SetPoints(at,au)
as.Points=NormalizePoints(au)
as:Render(true)
return as.Points
end

function as.Destroy(at)
as.Destroyed=true
as:Stop()
as.Path2DFrame:Destroy()
end

aa.AddSignal(as.UIElements.Canvas:GetPropertyChangedSignal"AbsoluteSize",function()
as:Render(not as.HasRendered)
end)

task.defer(function()
as:Render(true)
end)

return as.__type,as
end

return am end function a.at()

local aa=a.load'd'
local ag=a.load'e'
local aj=aa.New

local al=a.load'af'

local am={}

local function GetText(an,ao)
if an==nil then
return ao
end
return tostring(an)
end

local function GetCardColor(an,ao)
return al.GetColor(an,ao)
end

function am.New(an,ao)
local ap={
__type="Card",
Title=GetText(ao.Title,"Card"),
Desc=ao.Desc or ao.Content,
Icon=ao.Icon,
Image=ao.Image or ao.Background or ao.BackgroundImage,
Callback=ao.Callback,
OpenTab=ao.OpenTab==true or ao.CardTab==true or typeof(ao.Build)=="function",
Elements={},
UIElements={},
ElementFrame=nil,
LinkCorners=ao.LinkCorners,
CornerGroup=ao.CornerGroup or ao.LinkCornerGroup,
CornerBreak=ao.CornerBreak,
CornerBreakBefore=ao.CornerBreakBefore,
CornerBreakAfter=ao.CornerBreakAfter,
}

local aq=ao.Radius or ao.Window.ElementConfig.UICorner
local ar=GetCardColor(ao.Color or ao.Accent,nil)
local as=tonumber(ao.Height)or 0
local at=typeof(ap.Callback)=="function"or ap.OpenTab
local au
local av
local aw

ap.UIElements.Main,au=aa.NewRoundFrame(aq,"Squircle",{
Name="Card",
Size=UDim2.new(1,0,0,as),
AutomaticSize="Y",
ImageTransparency=1,
Parent=ao.Parent,
ClipsDescendants=true,
},{},at)
ap.ElementFrame=ap.UIElements.Main

ap.UIElements.Background=aj("Frame",{
Name="Background",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=aa.ClampTransparency(
ao.Transparency,
ao.Window.LiquidGlass and 0.84 or 0.9
),
BackgroundColor3=ar or nil,
ZIndex=0,
Parent=ap.UIElements.Main,
ThemeTag=ar and nil or{
BackgroundColor3="ElementBackground",
},
},{
aj("UICorner",{
CornerRadius=UDim.new(0,aq),
}),
})
av=ap.UIElements.Background.UICorner

ap.UIElements.Content=aj("Frame",{
Name="Content",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
ZIndex=2,
Parent=ap.UIElements.Main,
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,ao.Padding or 14),
PaddingLeft=UDim.new(0,ao.Padding or 14),
PaddingRight=UDim.new(0,ao.Padding or 14),
PaddingBottom=UDim.new(0,ao.Padding or 14),
}),
aj("UIListLayout",{
Padding=UDim.new(0,ao.Gap or 12),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

if ap.Image then
ap.UIElements.Image=
aa.Image(ap.Image,ap.Title.."-card-image",0,ao.Window.Folder,"Card",false,false)
ap.UIElements.Image.Size=UDim2.new(1,0,1,0)
ap.UIElements.Image.Position=UDim2.new(0.5,0,0.5,0)
ap.UIElements.Image.AnchorPoint=Vector2.new(0.5,0.5)
ap.UIElements.Image.Parent=ap.UIElements.Main
ap.UIElements.Image.ZIndex=0

local ax=al.GetImageTarget(ap.UIElements.Image)
if ax then
ax.ZIndex=0
ax.ImageTransparency=ao.ImageTransparency or 0.32
ax.ScaleType=ao.ScaleType or Enum.ScaleType.Crop
aw=aj("UICorner",{
CornerRadius=UDim.new(0,aq),
Parent=ax,
})
end
end

local ax=aj("Frame",{
Name="Header",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
LayoutOrder=1,
Parent=ap.UIElements.Content,
},{
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

if ap.Icon then
local ay=al.CreateIcon(aa,ap.Icon,ao.Window.Folder,"Card",true,"CardIcon")
if ay then
ay.Size=UDim2.new(0,22,0,22)
ay.Parent=ax
local az=al.GetImageTarget(ay)
if az and ar then
az.ImageColor3=ar
az.ImageTransparency=0
end
end
end

local ay=aj("Frame",{
Name="Texts",
Size=UDim2.new(1,ap.Icon and-32 or 0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ax,
},{
aj("UIListLayout",{
Padding=UDim.new(0,3),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

ap.UIElements.Title=aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ap.Title,
TextSize=ao.TitleSize or 17,
TextTransparency=0.02,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(aa.Font),
Parent=ay,
ThemeTag={
TextColor3="Text",
},
})

ap.UIElements.Desc=aj("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ap.Desc or"",
TextSize=ao.DescSize or 13,
TextTransparency=0.34,
TextXAlignment="Left",
TextWrapped=true,
Visible=ap.Desc~=nil,
FontFace=Font.new(aa.Font),
Parent=ay,
ThemeTag={
TextColor3="Text",
},
})

ap.UIElements.Body=aj("Frame",{
Name="Body",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
LayoutOrder=2,
Parent=ap.UIElements.Content,
},{
aj("UIListLayout",{
Padding=UDim.new(0,ao.BodyGap or(ao.Window.NewElements and 6 or 8)),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

local function EnsureActions()
if ap.UIElements.Actions then
return ap.UIElements.Actions
end

ap.UIElements.Actions=aj("Frame",{
Name="Actions",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
LayoutOrder=3,
Parent=ap.UIElements.Content,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

return ap.UIElements.Actions
end

local function CreateActionButton(az,aA)
az=az or{}
local aB=GetCardColor(az.Color,ar)
local aC=aa.NewRoundFrame(az.Radius or 14,"Squircle",{
Name=az.Name or"CardButton",
Size=UDim2.new(1,0,0,az.Height or 44),
ImageColor3=aB or nil,
ImageTransparency=az.Transparency or(aB and 0.18 or 0.9),
Parent=EnsureActions(),
ThemeTag=aB and nil or{
ImageColor3="ElementBackground",
},
},{
aj("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
aj("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
al.CreateIcon(
aa,
az.Icon or"arrow-right",
ao.Window.Folder,
"Card",
not aB,
"CardButtonIcon"
),
aj("TextLabel",{
Name="Title",
Size=UDim2.new(1,-34,1,0),
BackgroundTransparency=1,
Text=GetText(az.Title or az.Name,"Open"),
TextSize=az.TextSize or 14,
TextTransparency=0.04,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font),
ThemeTag={
TextColor3="Text",
},
}),
},true)

local aD=aC:FindFirstChildWhichIsA"Frame"or aC:FindFirstChildWhichIsA"ImageLabel"
local aE=al.GetImageTarget(aD)
if aE and aB then
aE.ImageColor3=aB
aE.ImageTransparency=0
end

ag.AttachPress(aC,aa,{
Amount=0.975,
})
aa.AddSignal(aC.MouseButton1Click,function()
if aA then
aA()
end
if typeof(az.Callback)=="function"then
aa.SafeCallback(az.Callback,ap)
end
end)

return aC
end

local az
local function CreateCardTab(aA)
aA=aA or{}
local aB=aA.Tab

if typeof(aB)~="table"and aA.CreateTab~=false and ao.Window and ao.Window.Tab then
aB=ao.Window:Tab{
Title=aA.TabTitle or aA.Title or ap.Title,
Desc=aA.TabDesc or aA.Desc,
Icon=aA.TabIcon or aA.Icon or ap.Icon or"panels-top-left",
ShowTabTitle=aA.ShowTabTitle,
Golden=aA.Golden,
Premium=aA.Premium,
LinkCorners=aA.LinkCorners,
Gap=aA.Gap,
}

if typeof(aA.Build)=="function"then
aa.SafeCallback(aA.Build,aB,ap)
end
end

return{
Tab=aB,
Select=function()
if aB and aB.Select then
return aB:Select()
end
end,
}
end

function ap.CardButton(aA,aB)
return CreateActionButton(aB)
end

function ap.CardTab(aA,aB)
aB=aB or{}
local aC=CreateCardTab(aB)

local aD=CreateActionButton({
Title=aB.Title or"Open Card Tab",
Icon=aB.Icon or"panels-top-left",
Color=aB.Color,
Callback=aB.Callback,
},function()
aC.Select()
end)

aC.Button=aD
return aC
end

if ap.OpenTab then
local aA=typeof(ao.CardTab)=="table"and ao.CardTab or{}
az=CreateCardTab{
Tab=ao.TabTarget or ao.Page or aA.Tab,
CreateTab=ao.CreateTab~=false and aA.CreateTab~=false,
Title=ao.TabTitle or ao.PageTitle or aA.Title or ap.Title,
TabTitle=ao.TabTitle or ao.PageTitle or aA.TabTitle or ap.Title,
TabDesc=ao.TabDesc or ao.PageDesc or aA.TabDesc or ap.Desc,
Icon=ao.TabIcon or ao.PageIcon or aA.Icon or ap.Icon,
TabIcon=ao.TabIcon or ao.PageIcon or aA.TabIcon or ap.Icon,
ShowTabTitle=ao.ShowTabTitle or aA.ShowTabTitle,
Golden=ao.Golden or aA.Golden,
Premium=ao.Premium or aA.Premium,
LinkCorners=ao.PageLinkCorners or aA.LinkCorners,
Gap=ao.PageGap or aA.Gap,
Build=ao.Build or aA.Build,
}

ap.Page=az.Tab
ap.PageController=az
end

function ap.Open(aA)
if az then
return az.Select()
end
if typeof(ap.Callback)=="function"then
return aa.SafeCallback(ap.Callback,ap)
end
end

function ap.GetPage(aA)
return az and az.Tab
end

function ap.SetPage(aA,aB)
az={
Tab=aB,
Select=function()
if aB and aB.Select then
return aB:Select()
end
end,
}
ap.Page=aB
ap.PageController=az
return{
Tab=aB,
Select=az.Select,
}
end

if at then
ag.AttachPress(ap.UIElements.Main,aa,{
Amount=0.985,
})
aa.AddSignal(ap.UIElements.Main.MouseButton1Click,function()
if az then
az.Select()
end
if typeof(ap.Callback)=="function"then
aa.SafeCallback(ap.Callback,ap)
end
end)
end

local aA=ao.ElementsModule
aA.Load(
ap,
ap.UIElements.Body,
aA.Elements,
ao.Window,
ao.WindUI,
nil,
aA,
ao.UIScale,
ao.Tab
)

function ap.SetTitle(aB,aC)
ap.Title=tostring(aC or"")
ap.UIElements.Title.Text=ap.Title
end

function ap.SetDesc(aB,aC)
ap.Desc=aC
ap.UIElements.Desc.Text=tostring(aC or"")
ap.UIElements.Desc.Visible=aC~=nil
end

function ap.Highlight(aB)
ag.Play(
ap.UIElements.Background,
"Highlight",
{BackgroundTransparency=0.78},
nil,
nil,
"CardHighlight"
)
task.delay(ag.GetDuration"Highlight",function()
if ap.UIElements.Main.Parent then
ag.Play(ap.UIElements.Background,"Highlight",{
BackgroundTransparency=aa.ClampTransparency(
ao.Transparency,
ao.Window.LiquidGlass and 0.84 or 0.9
),
},nil,nil,"CardHighlight")
end
end)
end

function ap.UpdateShape(aB)
local aC=ap.LinkCorners~=false
and(
ap.LinkCorners==true
or ao.Window.ElementConfig.LinkCorners
or(ao.ParentTable and ao.ParentTable.LinkCorners==true)
)

local aD={
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}
local aE="Squircle"
local aF={Position="Single",Count=1}

if aC and aB and aB.Elements then
local aG=ao.ParentConfig
and ao.ParentConfig.ParentTable
and ao.ParentConfig.ParentTable.__type
or ao.ParentType
or(ao.ParentTable and ao.ParentTable.__type)
aE,aD,aF=aa.GetLinkedCornerShape(
aB.Elements,
ap.Index,
aB,
aG,
ao.CornerLink
or(ao.ParentConfig and ao.ParentConfig.CornerLink)
or ao.Window.ElementConfig.CornerLink
)
end

if aE and au then
local aG=if aF.Count>1
then"Square"
else(aE=="Squircle-TL-BL"or aE=="Squircle-TR-BR")and"Squircle"or aE
au:SetType(aG)
end

aa.ApplyCornerRadii(av,UDim.new(0,aq),aD)
aa.ApplyCornerRadii(aw,UDim.new(0,aq),aD)
end

ap.UpdateShape(ao.Tab or ao.ParentTable)

function ap.Destroy(aB)
ap.UIElements.Main:Destroy()
end

return ap.__type,ap
end

return am end function a.au()

local aa=a.load'd'
local ag=aa.New
local aj=aa.Tween

local al={}

function al.New(am,an)
local ao={
__type="Section",
Title=an.Title or"Section",
Desc=an.Desc,
Icon=an.Icon,
IconThemed=an.IconThemed,
TextXAlignment=an.TextXAlignment or"Left",
TextSize=an.TextSize or 19,
DescTextSize=an.DescTextSize or 16,
Box=an.Box or false,
BoxBorder=an.BoxBorder or false,
FontWeight=an.FontWeight or nil,
DescFontWeight=an.DescFontWeight or nil,
TextTransparency=an.TextTransparency or 0.05,
DescTextTransparency=an.DescTextTransparency or 0.4,
Opened=an.Opened or false,
UIElements={},

HeaderSize=48,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local ap

function ao.SetIcon(aq,ar)
ao.Icon=ar or nil
if ap then
ap:Destroy()
end
if ar then
ap=aa.Image(
ar,
ar..":"..ao.Title,
0,
an.Window.Folder,
ao.__type,
true,
ao.IconThemed,
"SectionIcon"
)
ap.Size=UDim2.new(0,ao.IconSize,0,ao.IconSize)
end
end

local aq=ag("Frame",{
Size=UDim2.new(0,ao.IconSize,0,ao.IconSize),
BackgroundTransparency=1,
Visible=false,
},{
ag("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageTransparency="SectionExpandIconTransparency",
ImageColor3="SectionExpandIcon",
},
}),
})

if ao.Icon then
ao:SetIcon(ao.Icon)
end

local ar=ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ag("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=ao.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4),
}),
})

local as,at

local function createTitle(au,av)
return ag("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=ao.TextXAlignment,
AutomaticSize="Y",
TextSize=av=="Title"and ao.TextSize or ao.DescTextSize,
TextTransparency=av=="Title"and ao.TextTransparency or ao.DescTextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,av=="Title"and ao.FontWeight or ao.DescFontWeight),


Text=au,
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
Parent=ar,
})
end

as=createTitle(ao.Title,"Title")
if ao.Desc then
at=createTitle(ao.Desc,"Desc")
end

local function UpdateTitleSize()
local au=0
if ap then
au=au-(ao.IconSize+8)
end
if aq.Visible then
au=au-(ao.IconSize+8)
end
ar.Size=UDim2.new(1,au,0,0)
end

local au=aa.NewRoundFrame(an.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=an.Parent,

AutomaticSize="Y",
ThemeTag={
ImageTransparency=ao.Box and"SectionBoxBackgroundTransparency"or nil,
ImageColor3="SectionBoxBackground",
},
ImageTransparency=not ao.Box and 1 or nil,
},{
aa.NewRoundFrame(an.Window.ElementConfig.UICorner-1,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ThemeTag={

ImageColor3="SectionBoxBorder",
},
ImageTransparency=ao.Box and ao.BoxBorder and 0.92 or 1,
Name="Outline",
ClipsDescendants=true,
},{
ag("TextButton",{
Size=UDim2.new(1,0,0,ao.Expandable and 0 or(not at and ao.HeaderSize or 0)),
BackgroundTransparency=1,
AutomaticSize=(not ao.Expandable or at)and"Y"or nil,
Text="",
Name="Top",
},{
ao.Box and ag("UIPadding",{
PaddingTop=UDim.new(
0,
an.Window.ElementConfig.UIPadding+(an.Window.NewElements and 4 or 0)
),
PaddingLeft=UDim.new(
0,
an.Window.ElementConfig.UIPadding+(an.Window.NewElements and 4 or 0)
),
PaddingRight=UDim.new(
0,
an.Window.ElementConfig.UIPadding+(an.Window.NewElements and 4 or 0)
),
PaddingBottom=UDim.new(
0,
an.Window.ElementConfig.UIPadding+(an.Window.NewElements and 4 or 0)
),
})or nil,
ap,
ar,
ag("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
aq,
}),
ag("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,ao.HeaderSize+10),
},{
ao.Box and ag("UIPadding",{
PaddingLeft=UDim.new(0,an.Window.ElementConfig.UIPadding/1.5),
PaddingRight=UDim.new(0,an.Window.ElementConfig.UIPadding/1.5),
PaddingBottom=UDim.new(0,an.Window.ElementConfig.UIPadding/1.5),
})or nil,
ag("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.Tab.Gap),
VerticalAlignment="Top",
}),
}),
}),
})





ao.ElementFrame=au

au.Outline.Top:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
au.Outline.Content.Position=UDim2.new(0,0,0,(au.Outline.Top.AbsoluteSize.Y/an.UIScale)+10)

if ao.Opened then
ao:Open(true)
else
ao.Close(true)
end
end)

local av=an.ElementsModule

av.Load(ao,au.Outline.Content,av.Elements,an.Window,an.WindUI,function()
if not ao.Expandable then
ao.Expandable=true
aq.Visible=true
UpdateTitleSize()
end
end,av,an.UIScale,an.Tab)

UpdateTitleSize()

function ao.SetTitle(aw,ax)
ao.Title=ax
as.Text=ax
end

function ao.SetDesc(aw,ax)
ao.Desc=ax
if not at then
at=createTitle(ax,"Desc")
end
at.Text=ax
end

function ao.Destroy(aw)
for ax,ay in next,ao.Elements do
ay:Destroy()
end








au:Destroy()
end

function ao.Open(aw,ax)
if ao.Expandable then
ao.Opened=true
if ax then
au.Size=UDim2.new(
au.Size.X.Scale,
au.Size.X.Offset,
0,
au.Outline.Top.AbsoluteSize.Y/an.UIScale
+(au.Outline.Content.AbsoluteSize.Y/an.UIScale)
+10
)
aq.ImageLabel.Rotation=180
else
aj(au,0.33,{
Size=UDim2.new(
au.Size.X.Scale,
au.Size.X.Offset,
0,
au.Outline.Top.AbsoluteSize.Y/an.UIScale
+(au.Outline.Content.AbsoluteSize.Y/an.UIScale)
+10
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

aj(
aq.ImageLabel,
0.2,
{Rotation=180},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end
function ao.Close(aw,ax)
if ao.Expandable then
ao.Opened=false
if ax then
au.Size=UDim2.new(
au.Size.X.Scale,
au.Size.X.Offset,
0,
(au.Outline.Top.AbsoluteSize.Y/an.UIScale)
)
aq.ImageLabel.Rotation=0
else
aj(au,0.26,{
Size=UDim2.new(
au.Size.X.Scale,
au.Size.X.Offset,
0,
(au.Outline.Top.AbsoluteSize.Y/an.UIScale)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
aj(
aq.ImageLabel,
0.2,
{Rotation=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end

aa.AddSignal(au.Outline.Top.MouseButton1Click,function()
if ao.Expandable then
if ao.Opened then
ao:Close()
else
ao:Open()
end
end
end)

aa.AddSignal(au.Outline.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ao.Opened then
ao:Open(true)
else
ao:Close(true)
end
end)

task.defer(function()
if ao.Expandable then








au.Size=
UDim2.new(au.Size.X.Scale,au.Size.X.Offset,0,au.Outline.Top.AbsoluteSize.Y/an.UIScale)
au.AutomaticSize="None"
au.Outline.Top.Size=UDim2.new(1,0,0,(not at and ao.HeaderSize or 0))
au.Outline.Top.AutomaticSize=(not ao.Expandable or at)and"Y"or"None"
au.Outline.Content.Visible=true
end
if ao.Opened then
ao:Open()
else
ao:Close(true)
end
end)

return ao.__type,ao
end

return al end function a.av()

local aa=a.load'd'
local ag=aa.New

local aj={}

function aj.New(al,am)
local an=ag("Frame",{
Parent=am.Parent,
Size=not table.find({"Group","HStack"},am.ParentType)and UDim2.new(1,-7,0,7*(am.Columns or 1))or UDim2.new(0,7*(am.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=an}
end

return aj end function a.aw()
local aa=a.load'd'
local ag=aa.New

local aj={}

local function ParseAspectRatio(al)
if type(al)=="string"then
local am,an=al:match"(%d+):(%d+)"
if am and an then
return tonumber(am)/tonumber(an)
end
elseif type(al)=="number"then
return al
end
return nil
end

function aj.New(al,am)
local an={
__type="Image",
Image=am.Image or"",
AspectRatio=am.AspectRatio or"16:9",
Radius=am.Radius or am.Window.ElementConfig.UICorner,
}
local ao=aa.Image(
an.Image,
an.Image,
an.Radius,
am.Window.Folder,
"Image",
false
)
if ao and ao.Parent then
ao.Parent=am.Parent
ao.Size=UDim2.new(1,0,0,0)
ao.BackgroundTransparency=1












local ap=ParseAspectRatio(an.AspectRatio)
local aq

if ap then
aq=ag("UIAspectRatioConstraint",{
Parent=ao,
AspectRatio=ap,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function an.Destroy(ar)
ao:Destroy()
end
end

return an.__type,an
end

return aj end function a.ax()
local aa=a.load'd'
local ag=aa.New

local aj={}

function aj.New(al,am)
local an=am.LinkCorners==true or typeof(am.LinkCorners)=="table"
local ao=am.CornerLink or(typeof(am.LinkCorners)=="table"and am.LinkCorners)
local ap=typeof(ao)=="table"and(ao.Gap or ao.Spacing)or nil
local aq=am.Gap
or am.ElementGap
or(an and(tonumber(ap)or 1))
or(am.Tab and am.Tab.Gap)
or(am.Window.NewElements and 1 or 6)
local ar={
__type="Group",
Elements={},
ElementFrame=nil,
LinkCorners=an,
CornerLink=ao,
}

local as=ag("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=am.Parent,
},{
ag("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,aq),
}),
})

ar.ElementFrame=as

local at=am.ElementsModule
at.Load(
ar,
as,
at.Elements,
am.Window,
am.WindUI,
function(au,av)
local aw={}
local ax=0

for ay,az in next,av do
if az.__type=="Space"then
ax=ax+(az.ElementFrame.Size.X.Offset or 6)
elseif az.__type=="Divider"then
ax=ax+(az.ElementFrame.Size.X.Offset or 1)
else
table.insert(aw,az)
end
end

local ay=#aw
if ay==0 then
return
end

local az=1/ay

local aA=aq*(ay-1)

local aB=-(aA+ax)

local aC=math.floor(aB/ay)
local aD=aB-(aC*ay)

for aE,aF in next,aw do
local aG=aC
if aE<=math.abs(aD)then
aG=aG-1
end

if aF.ElementFrame then
aF.ElementFrame.Size=UDim2.new(az,aG,1,0)
end
end
end,
at,
am.UIScale,
am.Tab
)

return ar.__type,ar
end

return aj end function a.ay()

local aa=a.load'd'
local ag=aa.New

local aj={}

function aj.New(al,am)
local an=am.LinkCorners==true or typeof(am.LinkCorners)=="table"
local ao=am.CornerLink or(typeof(am.LinkCorners)=="table"and am.LinkCorners)
local ap=typeof(ao)=="table"and(ao.Gap or ao.Spacing)or nil
local aq=am.Gap
or am.ElementGap
or(an and(tonumber(ap)or 1))
or(am.Tab and am.Tab.Gap)
or(am.Window.NewElements and 1 or 6)
local ar={
__type="HStack",
AutoSpace=am.AutoSpace or false,
Elements={},
ElementFrame=nil,
LinkCorners=an,
CornerLink=ao,
MinChildWidth=math.max(tonumber(am.MinChildWidth)or 128,40),
IsStacked=false,
}

local as=ag("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=am.Parent,
},{
ag("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,aq),
}),
})

ar.ElementFrame=as

local at=am.ElementsModule
local function UpdateLayout(au)
au=au or ar.Elements
local av={}
local aw=0
local ax=as.AbsoluteSize.X/am.UIScale

for ay,az in next,au do
if az.__type=="Space"then
aw=aw+(az.ElementFrame.Size.X.Offset or 6)
elseif az.__type=="Divider"then
aw=aw+(az.ElementFrame.Size.X.Offset or 1)
else
table.insert(av,az)
end
end

local ay=#av
if ay==0 then
return
end

local az=aq*(ay-1)
local aA=ax-az-aw
local aB=ax>0 and aA/ay<ar.MinChildWidth
local aC=ar.IsStacked~=aB
ar.IsStacked=aB
local aD=aB and 1 or(1/ay)
local aE=aB and 0 or-(az+aw)
local aF=math.floor(aE/ay)
local aG=aE-(aF*ay)

as.UIListLayout.FillDirection=aB and Enum.FillDirection.Vertical
or Enum.FillDirection.Horizontal
as.UIListLayout.HorizontalAlignment=aB and Enum.HorizontalAlignment.Left
or Enum.HorizontalAlignment.Center

for aH,aI in next,av do
local aJ=aB and 0 or aF
if not aB and aH<=math.abs(aG)then
aJ=aJ-1
end

if aI.ElementFrame then
local aK=aI.ElementFrame.Size
aI.ElementFrame.Size=UDim2.new(
aD,
aJ,
aK.Y.Scale==1 and 0 or aK.Y.Scale,
aK.Y.Scale==1 and 0 or aK.Y.Offset
)
end
end

if aC and ar.UpdateAllElementShapes then
ar:UpdateAllElementShapes(ar)
end
end

at.Load(
ar,
as,
at.Elements,
am.Window,
am.WindUI,
function(au,av)
UpdateLayout(av)
end,
at,
am.UIScale,
am.Tab
)

aa.AddSignal(as:GetPropertyChangedSignal"AbsoluteSize",function()
UpdateLayout()
end)

if ar.AutoSpace then
for au in next,at.Elements do
if au~="Space"and au~="Divider"then
local av=ar[au]
ar[au]=function(aw,ax)
if#ar.Elements>0 then
ar:Space()
end
return av(aw,ax)
end
end
end
end

return ar.__type,ar
end

return aj end function a.az()

local aa=a.load'd'
local ag=aa.New

local aj={}

function aj.New(al,am)
local an=am.LinkCorners==true or typeof(am.LinkCorners)=="table"
local ao=am.CornerLink or(typeof(am.LinkCorners)=="table"and am.LinkCorners)
local ap=typeof(ao)=="table"and(ao.Gap or ao.Spacing)or nil
local aq=am.Gap
or am.ElementGap
or(an and(tonumber(ap)or 1))
or(am.Tab and am.Tab.Gap)
or(am.Window.NewElements and 1 or 6)
local ar={
__type="VStack",
Elements={},
ElementFrame=nil,
LinkCorners=an,
CornerLink=ao,
}

local as=ag("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=am.Parent,
},{
ag("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment="Center",

Padding=UDim.new(0,aq),
}),
})

ar.ElementFrame=as

local at=am.ElementsModule
at.Load(
ar,
as,
at.Elements,
am.Window,
am.WindUI,







































nil,
at,
am.UIScale,
am.Tab
)

return ar.__type,ar
end

return aj end function a.aA()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ag=aa(game:GetService"UserInputService")

local aj=a.load'd'
local al=aj.New

local am={}














function am.New(an,ao:ConfigType__DARKLUA_TYPE_a)
local ap={
__type="Viewport",
Object=ao.Object,
Camera=ao.Camera or Instance.new"Camera",
Interactive=ao.Interactive or false,
Height=ao.Height or 200,
Focused=ao.Focused~=false,
}

local aq=false
local ar=false
local as,at=0

local au=aj.NewRoundFrame(ao.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,ap.Height),
Parent=ao.Parent,
ThemeTag={
ImageColor3="ViewportBackground",
ImageTransparency="ViewportBackgroundTransparency",
},
},{
al("CanvasGroup",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
al("UICorner",{
CornerRadius=UDim.new(0,ao.Window.ElementConfig.UICorner),
}),
al("ViewportFrame",{
Name="Viewport",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
CurrentCamera=ap.Camera,
Active=ap.Interactive,
},{
ap.Object,
}),
}),
})

local function IsTouchInsideViewport(av)
local aw=au.CanvasGroup.Viewport.AbsolutePosition
local ax=au.CanvasGroup.Viewport.AbsoluteSize

return av.X>=aw.X
and av.X<=aw.X+ax.X
and av.Y>=aw.Y
and av.Y<=aw.Y+ax.Y
end

local av=ao.WindUI.GenerateGUID()

aj.AddSignal(au.CanvasGroup.Viewport.MouseEnter,function()
if ap.Interactive then
ao.Tab.UIElements.ContainerFrame.ScrollingEnabled=false
end
end)

aj.AddSignal(au.CanvasGroup.Viewport.InputEnded,function(aw)
if
aw.UserInputType==Enum.UserInputType.MouseMovement
or aw.UserInputType==Enum.UserInputType.Touch
then
ao.Tab.UIElements.ContainerFrame.ScrollingEnabled=true
end
end)

aj.AddSignal(au.CanvasGroup.Viewport.InputBegan,function(aw)
if ap.Interactive then
if
(aw.UserInputType==Enum.UserInputType.MouseButton1)
or(aw.UserInputType==Enum.UserInputType.Touch and not ar)
then
if ao.WindUI.CurrentInput and ao.WindUI.CurrentInput~=av then
return
end

ao.WindUI.CurrentInput=av

aq=true
at=aw.Position
end
end
end)

aj.AddSignal(ag.InputEnded,function(aw)
if ap.Interactive then
if
aw.UserInputType==Enum.UserInputType.MouseButton1
or aw.UserInputType==Enum.UserInputType.Touch
then
if ao.WindUI.CurrentInput and ao.WindUI.CurrentInput~=av then
return
end

ao.WindUI.CurrentInput=nil

aq=false
end
end
end)

aj.AddSignal(ag.InputChanged,function(aw)
if ap.Interactive and aq and not ar then
if
aw.UserInputType==Enum.UserInputType.MouseMovement
or aw.UserInputType==Enum.UserInputType.Touch
then
local ax=aw.Position-at
at=aw.Position

local ay=ap.Object:GetPivot().Position
local az=ap.Camera

local aA=CFrame.fromAxisAngle(Vector3.new(0,1,0),-ax.X*0.02)
az.CFrame=CFrame.new(ay)*aA*CFrame.new(-ay)*az.CFrame

local aB=CFrame.fromAxisAngle(az.CFrame.RightVector,-ax.Y*0.02)
local aC=CFrame.new(ay)*aB*CFrame.new(-ay)*az.CFrame

if aC.UpVector.Y>0.1 then
az.CFrame=aC
end
end
end
end)

aj.AddSignal(au.CanvasGroup.Viewport.InputChanged,function(aw)
if ap.Interactive then
if aw.UserInputType==Enum.UserInputType.MouseWheel then
local ax=aw.Position.Z*2
ap.Camera.CFrame+=ap.Camera.CFrame.LookVector*ax
end
end
end)

aj.AddSignal(ag.TouchPinch,function(aw,ax,ay,az)
if not IsTouchInsideViewport(aw[1])or not IsTouchInsideViewport(aw[2])then
return
end
if ap.Interactive then
if az==Enum.UserInputState.Begin then
ar=true
aq=false
as=(aw[1]-aw[2]).Magnitude
elseif az==Enum.UserInputState.Change then
if ar then
local aA=(aw[1]-aw[2]).Magnitude
local aB=(aA-as)*0.03
as=aA
ap.Camera.CFrame+=ap.Camera.CFrame.LookVector*aB
end
elseif az==Enum.UserInputState.End or az==Enum.UserInputState.Cancel then
ar=false
end
end
end)

local function FocusCamera()
local aw=ap.Object:IsA"BasePart"and ap.Object.Size
or select(2,ap.Object:GetBoundingBox(0))
local ax=math.max(aw.X,aw.Y,aw.Z)
local ay=ax*2
local az=ap.Object:GetPivot().Position

ap.Camera.CFrame=
CFrame.new(az+Vector3.new(0,ax/2,ay),az)
end

if ap.Focused then
FocusCamera()
end

function ap.SetObject(aw,ax,ay)
if ay then
ax=ax:Clone()
end
if ap.Object then
ap.Object:Destroy()
end

ap.Object=ax
ap.Object.Parent=au.CanvasGroup.Viewport
end

function ap.SetHeight(aw,ax)
au.Size=UDim2.new(1,0,0,ax)
end

function ap.Focus(aw)
if ap.Object then
FocusCamera()
end
end

function ap.SetCamera(aw,ax)
ap.Camera=ax
au.CanvasGroup.Viewport.CurrentCamera=ax
end

function ap.SetInteractive(aw,ax)
ap.Interactive=ax
au.CanvasGroup.Viewport.Active=ax
end

ap.Main=au

return ap.__type,ap
end

return am end function a.aB()



local aa=a.load'd'
local ag=aa.New

local aj={}

local function ParseAspectRatio(al)
if type(al)=="string"then
local am,an=al:match"(%d+):(%d+)"
if am and an then
return tonumber(am)/tonumber(an)
end
elseif type(al)=="number"then
return al
end
return nil
end


function aj.New(al,am)
local an={
__type="Video",
Video=am.Video or"",
AspectRatio=am.AspectRatio or"16:9",
Radius=am.Radius or am.Window.ElementConfig.UICorner,
ElementFrame=nil,
}

local ao

if an.Video then
local ap
if string.find(an.Video,"http")then
local aq=am.Window.Folder or"Temp"
if makefolder and isfolder then
if not isfolder(aq)then
makefolder(aq)
end
if not isfolder(aq.."/assets")then
makefolder(aq.."/assets")
end
end
local ar=aq.."/assets/."..aa.SanitizeFilename(an.Video)..".webm"
if not isfile or not isfile(ar)then
local as,at=pcall(function()
local as=game.HttpGet and game:HttpGet(an.Video)or nil
if not as and aa.Request then
local at=aa.Request{
Url=an.Video,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"},
}
as=at and at.Body
end
if as and writefile then
writefile(ar,as)
end
end)
if not as then
warn("[ Window.Background ] Failed to download video: "..tostring(at))
return
end
end

local as,at=pcall(function()
return typeof(getcustomasset)=="function"and getcustomasset(ar)or ar
end)
if not as then
warn("[ WindUI.Video ] Failed to load custom asset: "..tostring(at))
end
ap=at
else
ap=an.Video
end

ao=ag("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ap,
Looped=false,
Volume=0,
Parent=am.Parent
},{
ag("UICorner",{
CornerRadius=UDim.new(0,an.Radius)
}),
})
an.ElementFrame=ao
ao:Play()


local aq=ParseAspectRatio(an.AspectRatio)
local ar

if aq then
ar=ag("UIAspectRatioConstraint",{
Parent=ao,
AspectRatio=aq,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end
end


function an.Destroy(ap)
if ao then ao:Destroy()end
end

return an.__type,an
end

return aj end function a.aC()

local aa=a.load'd'

return{
Elements={
Paragraph=a.load'J',
Button=a.load'K',
Toggle=a.load'N',
Slider=a.load'O',
ProgressBar=a.load'P',
Keybind=a.load'Q',
Input=a.load'R',
Dropdown=a.load'U',
Code=a.load'X',
Colorpicker=a.load'Y',
RadioGroup=a.load'_',
CheckboxGroup=a.load'aa',
SegmentedControl=a.load'ab',
TextArea=a.load'ac',
Stepper=a.load'ad',
Callout=a.load'ae',
Badge=a.load'ag',
StatusCard=a.load'ah',
StatCard=a.load'ai',
KeyValue=a.load'aj',
ChipList=a.load'ak',
ActionList=a.load'al',
MeterGroup=a.load'am',
Timeline=a.load'an',
Accordion=a.load'ao',
EmptyState=a.load'ap',
DiscordCard=a.load'aq',
TabBox=a.load'ar',
Path2D=a.load'as',
Card=a.load'at',
Section=a.load'au',
Divider=a.load'S',
Space=a.load'av',
Image=a.load'aw',
Group=a.load'ax',
HStack=a.load'ay',
VStack=a.load'az',
Viewport=a.load'aA',
Video=a.load'aB',
},
Load=function(ag,aj,al,am,an,ao,ap,aq,ar)
for as,at in next,al do
ag[as]=function(au,av)
av=av or{}
av.Tab=ar or ag
av.ParentType=ag.__type
av.ParentTable=ag
av.Index=#ag.Elements+1
av.GlobalIndex=#am.AllElements+1
if av.LinkCorners==nil then
av.LinkCorners=ag.LinkCorners==true
or typeof(ag.LinkCorners)=="table"
or(ar and(ar.LinkCorners==true or typeof(ar.LinkCorners)=="table"))
end
if av.CornerLink==nil then
av.CornerLink=ag.CornerLink or(ar and ar.CornerLink)or am.ElementConfig.CornerLink
end
av.Parent=aj
av.Window=am
av.WindUI=an
av.UIScale=aq
av.ElementsModule=ap local

aw, ax=at:New(av)

ax.Index=av.Index
ax.LinkCorners=av.LinkCorners
ax.CornerGroup=av.CornerGroup or av.LinkCornerGroup
ax.CornerBreak=av.CornerBreak
ax.CornerBreakBefore=av.CornerBreakBefore
ax.CornerBreakAfter=av.CornerBreakAfter

if av.Flag and typeof(av.Flag)=="string"then
if am.CurrentConfig then
am.CurrentConfig:Register(av.Flag,ax)

if am.PendingConfigData and am.PendingConfigData[av.Flag]then
local ay=am.PendingConfigData[av.Flag]

local az=am.ConfigManager
if typeof(ay)=="table"and az.Parser[ay.__type]then
task.defer(function()
local aA,aB=pcall(function()
az.Parser[ay.__type].Load(ax,ay)
end)

if aA then
am.PendingConfigData[av.Flag]=nil
else
warn(
"[ WindUI ] Failed to apply pending config for '"
..av.Flag
.."': "
..tostring(aB)
)
end
end)
end
end
else
am.PendingFlags=am.PendingFlags or{}
am.PendingFlags[av.Flag]=ax
end
end

local ay
for az,aA in next,ax do
if typeof(aA)=="table"and az~="ElementFrame"and az:match"Frame$"then
ay=aA
break
end
end

if ay then
ax.ElementFrame=ay.UIElements.Main
function ax.SetTitle(az,aA)
return ay.SetTitle and ay:SetTitle(aA)
end
function ax.SetDesc(az,aA)
return ay.SetDesc and ay:SetDesc(aA)
end
function ax.SetImage(az,aA,aB)
return ay.SetImage and ay:SetImage(aA,aB)
end
function ax.SetThumbnail(az,aA,aB)
return ay.SetThumbnail and ay:SetThumbnail(aA,aB)
end
function ax.SetTransparency(az,aA)
return ay.SetTransparency and ay:SetTransparency(aA)
end
function ax.SetLiquidGlass(az,aA)
return ay.SetLiquidGlass and ay:SetLiquidGlass(aA)
end
function ax.Highlight(az)
ay:Highlight()
end
function ax.Destroy(az)
if ax.Cleanup then
ax:Cleanup()
end
ay:Destroy()

table.remove(am.AllElements,av.GlobalIndex)
table.remove(ag.Elements,av.Index)
table.remove(ar.Elements,av.Index)
ag:UpdateAllElementShapes(ag)
end
end

if not ax.ElementFrame and ax.UIElements and ax.UIElements.Main then
ax.ElementFrame=ax.UIElements.Main
end

if not ax.UpdateShape and ax.ElementFrame then
function ax.UpdateShape(az)
local aA=ax.LinkCorners~=false
and(
ax.LinkCorners==true
or am.ElementConfig.LinkCorners
or(az and az.LinkCorners==true)
)
local aB=aa.DefaultCornerMap()
local aC={Count=1}

if aA and az and az.Elements then
_,aB,aC=aa.GetLinkedCornerShape(
az.Elements,
ax.Index,
az,
az.__type,
av.CornerLink or am.ElementConfig.CornerLink
)
end

aa.ApplyLinkedCornerSurface(
ax.ElementFrame,
UDim.new(0,am.ElementConfig.UICorner),
aB,
aA and aC.Count>1
)
end
end

am.AllElements[av.GlobalIndex]=ax
ag.Elements[av.Index]=ax
if ar then
ar.Elements[av.Index]=ax
end

if am.NewElements then
ag:UpdateAllElementShapes(ag)
end

if ao then
ao(ax,ag.Elements)
end
return ax
end
end
function ag.UpdateAllElementShapes(as,at)
for au,av in next,at.Elements do
local aw
for ax,ay in pairs(av)do
if typeof(ay)=="table"and ax:match"Frame$"then
aw=ay
break
end
end

if not aw and av.UpdateShape then
aw=av
end

if aw then

aw.Index=au
if aw.UpdateShape then

aw.UpdateShape(at)
end
end
end
end
end,
}end function a.aD()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ag=game:GetService"Players"
local aj=game:GetService"TweenService"

aa(game:GetService"UserInputService")
local al=ag.LocalPlayer:GetMouse()

local am=a.load'd'
local an=a.load'e'
local ao=am.New

local ap=a.load'G'.New
local aq=a.load'z'.New



local ar={


Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(ar)end,
}

local function GetImageTarget(as)
if typeof(as)~="Instance"then
return nil
end

if as:IsA"ImageLabel"or as:IsA"ImageButton"then
return as
end

return as:FindFirstChildWhichIsA("ImageLabel",true)or as:FindFirstChildWhichIsA("ImageButton",true)
end

function ar.Init(as,at,au,av)
Window=as
WindUI=at
ar.ToolTipParent=au
ar.TabHighlight=av
return ar
end

function ar.New(as,at)
local au=Window.TabHolderType=="top"
local av=Window.TabHolderType=="sidebar"and Window.SidebarCompact==true
local aw=av
local ax=if as.LinkCorners~=nil
then as.LinkCorners==true or typeof(as.LinkCorners)=="table"
else Window.LinkElementCorners==true
local ay=as.CornerLink
or(typeof(as.LinkCorners)=="table"and as.LinkCorners)
or Window.ElementCornerLink
local az=as.Gap or as.ElementGap
local aA=typeof(ay)=="table"and(ay.Gap or ay.Spacing)or nil

local aB={
__type="Tab",
Title=as.Title or"Tab",
Desc=as.Desc,
Icon=as.Icon or(aw and"circle"or nil),
Golden=as.Golden==true or as.Premium==true,
Premium=as.Premium==true or as.Golden==true,
IconColor=as.IconColor
or((as.Golden==true or as.Premium==true)and Color3.fromRGB(255,222,105)or nil),
IconShape=as.IconShape,
IconThemed=as.IconThemed,
Locked=as.Locked,
ShowTabTitle=as.ShowTabTitle,
TabTitleAlign=as.TabTitleAlign or"Left",
CustomEmptyPage=(as.CustomEmptyPage and next(as.CustomEmptyPage)~=nil)and as.CustomEmptyPage
or{Icon="lucide:frown",IconSize=48,Title="This tab is Empty",Desc=nil},
Border=as.Border,
Selected=false,
Index=nil,
Parent=as.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=if au then 12 else Window.UICorner-(Window.UIPadding/2),
HolderType=Window.TabHolderType,
IconOnly=aw,
LinkCorners=ax,
CornerLink=ay,

Gap=az
or(ax and(tonumber(aA)or 1))
or Window.ElementGap
or(Window.NewElements and(Window.LiquidGlass and 6 or 1)or 6),

TabPaddingX=if au then 12 elseif aw then 8 else 4+(Window.UIPadding/2),
TabPaddingY=if au then 7 elseif aw then 8 else 3+(Window.UIPadding/2),
TitlePaddingY=0,
}









if aB.IconShape then
aB.TabPaddingX=2+(Window.UIPadding/4)
aB.TabPaddingY=2+(Window.UIPadding/4)
aB.TitlePaddingY=2+(Window.UIPadding/4)
end

ar.TabCount=ar.TabCount+1

local aC=ar.TabCount
aB.Index=aC

aB.UIElements.Main=am.NewRoundFrame(aB.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=if au
then UDim2.new(0,0,0,36)
elseif aw then UDim2.new(1,-8,0,44)
else UDim2.new(1,-7,0,0),
AutomaticSize=if au
then Enum.AutomaticSize.X
elseif aw then Enum.AutomaticSize.None
else Enum.AutomaticSize.Y,
Parent=as.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
am.NewRoundFrame(aB.UICorner-1,"Glass-1.4",{
Size=UDim2.new(1,1,1,1),
ThemeTag={
ImageColor3="TabBorder",
},
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=1,
Name="Outline",
},{













}),
am.NewRoundFrame(999,"Squircle",{
Name="ActiveRail",
Size=if au then UDim2.new(0,0,0,3)else UDim2.new(0,3,0,0),
AnchorPoint=if au then Vector2.new(0.5,1)else Vector2.new(0,0.5),
Position=if au then UDim2.new(0.5,0,1,-1)else UDim2.new(0,2,0.5,0),
ImageTransparency=1,
ThemeTag={
ImageColor3="Primary",
},
}),
am.NewRoundFrame(aB.UICorner,"Squircle",{
Size=if au
then UDim2.new(0,0,1,0)
elseif aw then UDim2.fromScale(1,1)
else UDim2.new(1,0,0,0),
AutomaticSize=if au
then Enum.AutomaticSize.X
elseif aw then Enum.AutomaticSize.None
else Enum.AutomaticSize.Y,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
ao("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,2+(Window.UIPadding/2)),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=if aw
then Enum.HorizontalAlignment.Center
else Enum.HorizontalAlignment.Left,
}),
ao("TextLabel",{
Text=aB.Title,
ThemeTag=not aB.Golden and{
TextColor3="TabTitle",
}or nil,
TextColor3=aB.Golden and Color3.fromRGB(255,232,144)or nil,
TextTransparency=not aB.Locked and(aB.Golden and 0.12 or 0.4)or 0.7,
TextSize=15,
Size=if au then UDim2.new(0,0,1,0)else UDim2.new(1,0,0,0),
FontFace=Font.new(am.Font),
TextWrapped=true,
RichText=true,
AutomaticSize=if au then Enum.AutomaticSize.X else Enum.AutomaticSize.Y,
Visible=not aw,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
},{
ao("UIPadding",{
PaddingTop=UDim.new(0,aB.TitlePaddingY),


PaddingBottom=UDim.new(0,aB.TitlePaddingY),
}),
}),
ao("UIPadding",{
PaddingTop=UDim.new(0,aB.TabPaddingY),
PaddingLeft=UDim.new(0,aB.TabPaddingX),
PaddingRight=UDim.new(0,aB.TabPaddingX),
PaddingBottom=UDim.new(0,aB.TabPaddingY),
}),
}),
},true)

if aB.Golden then
aB.UIElements.Main.Frame.ImageColor3=Color3.fromRGB(64,49,18)
aB.UIElements.Main.Frame.ImageTransparency=0.88
aB.UIElements.Main.Outline.ImageColor3=Color3.fromRGB(255,214,92)
aB.UIElements.Main.Outline.ImageTransparency=0.78
aB.UIElements.GoldenShine=ao("UIGradient",{
Rotation=18,
Offset=Vector2.new(-1,0),
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.fromRGB(255,185,56)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,244,184)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(154,94,18)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.88),
NumberSequenceKeypoint.new(0.48,0.72),
NumberSequenceKeypoint.new(0.55,0.18),
NumberSequenceKeypoint.new(0.64,0.74),
NumberSequenceKeypoint.new(1,0.9),
},
Parent=aB.UIElements.Main.Frame,
})

if an:IsEnabled()and not an.Reduced then
task.spawn(function()
while aB.UIElements.Main and aB.UIElements.Main.Parent and aB.UIElements.GoldenShine do
aB.UIElements.GoldenShine.Offset=Vector2.new(-1,0)
local aD=aj:Create(
aB.UIElements.GoldenShine,
TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
{Offset=Vector2.new(1,0)}
)
aD:Play()
aD.Completed:Wait()
task.wait(1.1)
end
end)
end
end

local aD=0
local aE
local aF

if aB.Icon then
local aG=tostring(aB.Icon)..":"..aB.Title
aE=am.Image(
aB.Icon,
aG,
0,
Window.Folder,
aB.__type,
aB.IconColor and false or true,
aB.IconThemed,
"TabIcon"
)
aE.Size=UDim2.fromOffset(aw and 20 or 16,aw and 20 or 16)
local aH=GetImageTarget(aE)
if aB.IconColor and aH then
aH.ImageColor3=aB.IconColor
end
if not aB.IconShape or aw then
aE.Parent=aB.UIElements.Main.Frame
aB.UIElements.Icon=aE
if aH then
aH.ImageTransparency=not aB.Locked and 0 or 0.7
end
aD=-18-(Window.UIPadding/2)
if not au and not aw then
aB.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,aD,0,0)
end
elseif aB.IconColor then
am.NewRoundFrame(
aB.IconShape~="Circle"and(aB.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Squircle",
{
Size=UDim2.new(0,26,0,26),
ImageColor3=aB.IconColor,
Parent=aB.UIElements.Main.Frame,
},
{
aE,
am.NewRoundFrame(
aB.IconShape~="Circle"and(aB.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Glass-1.4",
{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0,
Name="Outline",
},
{













}
),
}
)
aE.AnchorPoint=Vector2.new(0.5,0.5)
aE.Position=UDim2.new(0.5,0,0.5,0)
if aH then
aH.ImageTransparency=0
aH.ImageColor3=am.GetTextColorForHSB(aB.IconColor,0.68)
end
aD=-28-(Window.UIPadding/2)
aB.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,aD,0,0)
end

aF=am.Image(aB.Icon,aG,0,Window.Folder,aB.__type,true,aB.IconThemed)
aF.Size=UDim2.new(0,16,0,16)
local aI=GetImageTarget(aF)
if aI then
aI.ImageTransparency=not aB.Locked and 0 or 0.7
end
aD=-30




end

aB.UIElements.ContainerFrame=ao("ScrollingFrame",{
Size=UDim2.new(1,0,1,aB.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",

ScrollingDirection="Y",
},{
ao("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
ao("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,aB.Gap),
HorizontalAlignment="Center",
}),
})





aB.UIElements.ContainerFrameCanvas=ao("CanvasGroup",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
aB.UIElements.ContainerFrame,
ao("Frame",{
Size=UDim2.new(1,-14,1,-14),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Name="ScrollSliderHolder",
}),
ao("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=aB.ShowTabTitle or false,
Name="TabTitle",
},{
aF,
ao("TextLabel",{
Text=aB.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=20,
TextTransparency=0.1,
Size=UDim2.new(0,0,1,0),
FontFace=Font.new(am.Font),

RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
AutomaticSize="X",
}),
ao("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
ao("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=aB.TabTitleAlign,
}),
}),
ao("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=aB.ShowTabTitle or false,
}),
})

ar.Containers[aC]=aB.UIElements.ContainerFrameCanvas
ar.Tabs[aC]=aB

aB.ContainerFrame=aB.UIElements.ContainerFrameCanvas

am.AddSignal(aB.UIElements.Main.MouseButton1Click,function()
if not aB.Locked then
ar:SelectTab(aC)
end
end)

an.AttachPress(aB.UIElements.Main,am,{
Amount=0.985,
})

if Window.ScrollBarEnabled then
aq(
aB.UIElements.ContainerFrame,
aB.UIElements.ContainerFrameCanvas.ScrollSliderHolder,
Window,
4,
WindUI
)
end

local aG
local aH=if aw then aB.Desc or aB.Title else aB.Desc
local aI
local aJ
local aK=false


if aH then
am.AddSignal(aB.UIElements.Main.InputBegan,function()
aK=true
aI=task.spawn(function()
task.wait(0.35)
if aK and not aG then
aG=ap(aH,ar.ToolTipParent,true)
aG.Container.AnchorPoint=Vector2.new(0.5,0.5)

local function updatePosition()
if aG then
aG.Container.Position=UDim2.new(0,al.X,0,al.Y-4)
end
end

updatePosition()
aJ=al.Move:Connect(updatePosition)
aG:Open()
end
end)
end)
end

am.AddSignal(aB.UIElements.Main.MouseEnter,function()
if not aB.Locked and not aB.Selected then
am.SetThemeTag(aB.UIElements.Main.Frame,{
ImageTransparency="TabBackgroundHoverTransparency",
ImageColor3="TabBackgroundHover",
},0.1)
end
end)
am.AddSignal(aB.UIElements.Main.MouseLeave,function()
if not aB.Locked and not aB.Selected then
an.Play(aB.UIElements.Main.Frame,"Hover",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabHover")
end
end)
am.AddSignal(aB.UIElements.Main.InputEnded,function()
if aH then
aK=false
if aI then
task.cancel(aI)
aI=nil
end
if aJ then
aJ:Disconnect()
aJ=nil
end
if aG then
aG:Close()
aG=nil
end
end

if not aB.Locked and not aB.Selected then
an.Play(aB.UIElements.Main.Frame,"Hover",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabHover")
end
end)

function aB.ScrollToTheElement(aL,aM)
aB.UIElements.ContainerFrame.ScrollingEnabled=false

an.Play(aB.UIElements.ContainerFrame,"Resize",{
CanvasPosition=Vector2.new(
0,
aB.Elements[aM].ElementFrame.AbsolutePosition.Y
-aB.UIElements.ContainerFrame.AbsolutePosition.Y
-aB.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"ScrollToElement")

task.spawn(function()
task.wait(an.GetDuration"Resize"+0.03)

if aB.Elements[aM].Highlight then
aB.Elements[aM]:Highlight()
end
aB.UIElements.ContainerFrame.ScrollingEnabled=true
end)

return aB
end



local aL=a.load'aC'

aL.Load(
aB,
aB.UIElements.ContainerFrame,
aL.Elements,
Window,
WindUI,
nil,
aL,
at,
aB
)

function aB.LockAll(aM)

for aN,aO in next,Window.AllElements do
if aO.Tab and aO.Tab.Index and aO.Tab.Index==aB.Index and aO.Lock then
aO:Lock()
end
end
end
function aB.UnlockAll(aM)
for aN,aO in next,Window.AllElements do
if aO.Tab and aO.Tab.Index and aO.Tab.Index==aB.Index and aO.Unlock then
aO:Unlock()
end
end
end
function aB.GetLocked(aM)
local aN={}

for aO,aP in next,Window.AllElements do
if aP.Tab and aP.Tab.Index and aP.Tab.Index==aB.Index and aP.Locked==true then
table.insert(aN,aP)
end
end

return aN
end
function aB.GetUnlocked(aM)
local aN={}

for aO,aP in next,Window.AllElements do
if aP.Tab and aP.Tab.Index and aP.Tab.Index==aB.Index and aP.Locked==false then
table.insert(aN,aP)
end
end

return aN
end

function aB.Select(aM)
return ar:SelectTab(aB.Index)
end

task.spawn(function()
local aM
if aB.CustomEmptyPage.Icon then
aM=
am.Image(aB.CustomEmptyPage.Icon,aB.CustomEmptyPage.Icon,0,"Temp","EmptyPage",true)
aM.Size=
UDim2.fromOffset(aB.CustomEmptyPage.IconSize or 48,aB.CustomEmptyPage.IconSize or 48)
end

local aN=ao("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=aB.UIElements.ContainerFrame,
},{
ao("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),











aM,
aB.CustomEmptyPage.Title
and ao("TextLabel",{
AutomaticSize="XY",
Text=aB.CustomEmptyPage.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
TextTransparency=0.5,
BackgroundTransparency=1,
FontFace=Font.new(am.Font),
})
or nil,
aB.CustomEmptyPage.Desc
and ao("TextLabel",{
AutomaticSize="XY",
Text=aB.CustomEmptyPage.Desc,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.65,
BackgroundTransparency=1,
FontFace=Font.new(am.Font),
})
or nil,
})





local aO
aO=am.AddSignal(aB.UIElements.ContainerFrame.ChildAdded,function()
aN.Visible=false
aO:Disconnect()
end)
end)

return aB
end

function ar.OnChange(as,at)
ar.OnChangeFunc=at
end

local function ApplyGoldenTabVisual(as,at)
if not as or not as.Golden then
return
end

local au=as.UIElements
and as.UIElements.Main
and as.UIElements.Main.Frame
and as.UIElements.Main.Frame.TextLabel
if au then
au.TextColor3=at and Color3.fromRGB(255,244,184)or Color3.fromRGB(255,224,120)
au.TextTransparency=at and 0 or 0.12
end

local av=as.UIElements and as.UIElements.Icon and GetImageTarget(as.UIElements.Icon)
if av then
av.ImageColor3=as.IconColor or Color3.fromRGB(255,222,105)
av.ImageTransparency=at and 0 or 0.08
end

local aw=as.UIElements and as.UIElements.Main and as.UIElements.Main.Outline
if aw then
aw.ImageColor3=at and Color3.fromRGB(255,232,132)or Color3.fromRGB(255,214,92)
aw.ImageTransparency=at and 0.58 or 0.78
end
end

local function ApplyTabMotionVisual(as,at)
if not as or not as.UIElements or not as.UIElements.Main then
return
end

local au=as.UIElements.Main.ActiveRail
if au then
if as.Golden then
au.ImageColor3=at and Color3.fromRGB(255,232,132)or Color3.fromRGB(255,214,92)
end

local av
if as.HolderType=="top"then
av=at and UDim2.new(1,-16,0,3)or UDim2.new(0,0,0,3)
else
av=at and UDim2.new(0,3,1,-12)or UDim2.new(0,3,0,0)
end

an.Play(au,"Switch",{
Size=av,
ImageTransparency=at and 0.08 or 1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabRail")
end

if not at and as.UIElements.Main.Frame then
an.Play(as.UIElements.Main.Frame,"Hover",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabHover")
end
end

function ar.SelectTab(as,at)
local au=ar.Tabs[at]
if au and not au.Locked and ar.SelectedTab~=at then
ar.SelectedTab=at

for av,aw in next,ar.Tabs do
if not aw.Locked then
am.SetThemeTag(aw.UIElements.Main,{
ImageTransparency="TabBorderTransparency",
},0.15)
if aw.Border then
am.SetThemeTag(aw.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparency",
},0.15)
end
am.SetThemeTag(aw.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparency",
},0.15)
local ax=aw.UIElements.Icon and GetImageTarget(aw.UIElements.Icon)
if ax and not aw.IconColor then
am.SetThemeTag(ax,{
ImageTransparency="TabIconTransparency",
},0.15)
end
aw.Selected=false
ApplyGoldenTabVisual(aw,false)
ApplyTabMotionVisual(aw,false)
end
end
am.SetThemeTag(au.UIElements.Main,{
ImageColor3="TabBackgroundActive",
ImageTransparency="TabBackgroundActiveTransparency",
},0.15)
if au.Border then
am.SetThemeTag(au.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparencyActive",
},0.15)
end
am.SetThemeTag(au.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparencyActive",
},0.15)
local av=au.UIElements.Icon and GetImageTarget(au.UIElements.Icon)
if av and not au.IconColor then
am.SetThemeTag(av,{
ImageTransparency="TabIconTransparencyActive",
},0.15)
end
au.Selected=true
ApplyGoldenTabVisual(au,true)
ApplyTabMotionVisual(au,true)

task.spawn(function()
local aw=ar.Containers[at]
for ax,ay in next,ar.Containers do
if ay~=aw then
ay.AnchorPoint=Vector2.new(0,0.035)
ay.GroupTransparency=1
ay.Visible=false
end
end
aw.AnchorPoint=Vector2.new(0,0.035)
aw.GroupTransparency=1
aw.Visible=true
an.Play(aw,"Switch",{
AnchorPoint=Vector2.new(0,0),
GroupTransparency=0,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out,"Select")
end)

ar.OnChangeFunc(at)
end
end

return ar end function a.aE()

local aa={}


local ag=a.load'd'
local aj=ag.New
local al=ag.Tween

local am=a.load'aD'

function aa.New(an,ao,ap,aq,ar)
local as={
Title=an.Title or"Section",
Icon=an.Icon,
IconThemed=an.IconThemed,
Opened=an.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local at
if as.Icon then
at=ag.Image(
as.Icon,
as.Icon,
0,
ap,
"Section",
true,
as.IconThemed,
"TabSectionIcon"
)

at.Size=UDim2.new(0,as.IconSize,0,as.IconSize)
at.ImageLabel.ImageTransparency=.25
end

local au=aj("Frame",{
Size=UDim2.new(0,as.IconSize,0,as.IconSize),
BackgroundTransparency=1,
Visible=false
},{
aj("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ag.Icon"chevron-down"[1],
ImageRectSize=ag.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ag.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local av=aj("Frame",{
Size=UDim2.new(1,0,0,as.HeaderSize),
BackgroundTransparency=1,
Parent=ao,
ClipsDescendants=true,
},{
aj("TextButton",{
Size=UDim2.new(1,0,0,as.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
at,
aj("TextLabel",{
Text=as.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
at and(-as.IconSize-10)*2
or(-as.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ag.Font),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
aj("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
au,
aj("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
aj("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,as.HeaderSize)
},{
aj("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ar.Gap),
VerticalAlignment="Bottom",
}),
})
})


function as.Tab(aw,ax)
if not as.Expandable then
as.Expandable=true
au.Visible=true
end
ax.Parent=av.Content
return am.New(ax,aq)
end

function as.Open(aw)
if as.Expandable then
as.Opened=true
al(av,0.33,{
Size=UDim2.new(1,0,0,as.HeaderSize+(av.Content.AbsoluteSize.Y/aq))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

al(au.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function as.Close(aw)
if as.Expandable then
as.Opened=false
al(av,0.26,{
Size=UDim2.new(1,0,0,as.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(au.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ag.AddSignal(av.TextButton.MouseButton1Click,function()
if as.Expandable then
if as.Opened then
as:Close()
else
as:Open()
end
end
end)

ag.AddSignal(av.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if as.Opened then
as:Open()
end
end)

if as.Opened then
task.spawn(function()
task.wait()
as:Open()
end)
end



return as
end


return aa end function a.aF()
return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
Toggle="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
}end function a.aG()
local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")

local ag={
Margin=8,
Padding=9,
}

local aj=a.load'd'
local al=aj.New
local am=aj.Tween

function ag.new(an,ao,ap)
local aq={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'aF',
}

local ar=al("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(1,-((aq.IconSize*2)+(aq.Padding*2)),0,0),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(aj.Font),
TextSize=18,
})

local as=al("ImageLabel",{
Image=aj.Icon"x"[1],
ImageRectSize=aj.Icon"x"[2].ImageRectSize,
ImageRectOffset=aj.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,aq.IconSize,0,aq.IconSize),
},{
al("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
}),
})

local at=al("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false,
},{
al("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
al("UIPadding",{
PaddingTop=UDim.new(0,aq.Padding),
PaddingLeft=UDim.new(0,aq.Padding),
PaddingRight=UDim.new(0,aq.Padding),
PaddingBottom=UDim.new(0,aq.Padding),
}),
})

local au=aj.NewRoundFrame(aq.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="WindowSearchBarBackground",
},
ImageTransparency=0,
},{
aj.NewRoundFrame(aq.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Frame",
},{
al("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








al("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
al("ImageLabel",{
Image=aj.Icon"search"[1],
ImageRectSize=aj.Icon"search"[2].ImageRectSize,
ImageRectOffset=aj.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,aq.IconSize,0,aq.IconSize),
}),
ar,
as,
al("UIListLayout",{
Padding=UDim.new(0,aq.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,aq.Padding),
PaddingRight=UDim.new(0,aq.Padding),
}),
}),
}),
al("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
al("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.9,
Visible=false,
}),
at,
al("UISizeConstraint",{
MaxSize=Vector2.new(aq.Width,aq.MaxHeight),
}),
}),
al("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
})

local av=al("Frame",{
Size=UDim2.new(0,aq.Width,0,0),
AutomaticSize="Y",
Parent=ao,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
al("UIScale",{
Scale=0.9,
}),
au,















})

local function CreateSearchTab(aw,ax,ay,az,aA,aB)
local aC=al("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=az or nil,
},{
aj.NewRoundFrame(aq.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main",
},{
aj.NewRoundFrame(aq.Radius-11,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Outline",
},{








al("UIPadding",{
PaddingTop=UDim.new(0,aq.Padding-2),
PaddingLeft=UDim.new(0,aq.Padding),
PaddingRight=UDim.new(0,aq.Padding),
PaddingBottom=UDim.new(0,aq.Padding-2),
}),
al("ImageLabel",{
Image=aj.Icon(ay)[1],
ImageRectSize=aj.Icon(ay)[2].ImageRectSize,
ImageRectOffset=aj.Icon(ay)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,aq.IconSize,0,aq.IconSize),
}),
al("Frame",{
Size=UDim2.new(1,-aq.IconSize-aq.Padding,0,0),
BackgroundTransparency=1,
},{
al("TextLabel",{
Text=aw,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(aj.Font),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title",
}),
al("TextLabel",{
Text=ax or"",
Visible=ax and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(aj.Font),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc",
})or nil,
al("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
}),
}),
al("UIListLayout",{
Padding=UDim.new(0,aq.Padding),
FillDirection="Horizontal",
}),
}),
},true),
al("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-aq.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=aA,

},{
aj.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
}),
al("Frame",{
Size=UDim2.new(1,-aq.Padding-2,0,0),
Position=UDim2.new(0,aq.Padding+2,0,0),
BackgroundTransparency=1,
},{
al("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
al("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right",
}),
})



aC.Main.Size=UDim2.new(
1,
0,
0,
aC.Main.Outline.Frame.Desc.Visible
and(((aq.Padding-2)*2)+aC.Main.Outline.Frame.Title.TextBounds.Y+6+aC.Main.Outline.Frame.Desc.TextBounds.Y)
or(((aq.Padding-2)*2)+aC.Main.Outline.Frame.Title.TextBounds.Y)
)

aj.AddSignal(aC.Main.MouseEnter,function()
am(aC.Main,0.04,{ImageTransparency=0.95}):Play()

end)
aj.AddSignal(aC.Main.InputEnded,function()
am(aC.Main,0.08,{ImageTransparency=1}):Play()

end)
aj.AddSignal(aC.Main.MouseButton1Click,function()
if aB then
aB()
end
end)

return aC
end

local function ContainsText(aw,ax)
if not ax or ax==""then
return false
end

if not aw or aw==""then
return false
end

local ay=string.lower(aw)
local az=string.lower(ax)

return string.find(ay,az,1,true)~=nil
end

local function Search(aw)
if not aw or aw==""then
return{}
end

local ax={}
for ay,az in next,an.Tabs do
local aA=ContainsText(az.Title or"",aw)
local aB={}

for aC,aD in next,az.Elements do
if aD.__type~="Section"then
local aE=ContainsText(aD.Title or"",aw)
local aF=ContainsText(aD.Desc or"",aw)

if aE or aF then
aB[aC]={
Title=aD.Title,
Desc=aD.Desc,
Original=aD,
__type=aD.__type,
Index=aC,
}
end
end
end

if aA or next(aB)~=nil then
ax[ay]={
Tab=az,
Title=az.Title,
Icon=az.Icon,
Elements=aB,
}
end
end
return ax
end

aj.AddSignal(at.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

am(at,0.06,{
Size=UDim2.new(
1,
0,
0,
math.clamp(
at.UIListLayout.AbsoluteContentSize.Y+(aq.Padding*2),
0,
aq.MaxHeight
)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function aq.Open(aw)
task.spawn(function()
au.Frame.Visible=true
av.Visible=true
am(av.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function aq.Close(aw,ax)
task.spawn(function()
ap()
au.Frame.Visible=false
am(av.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(0.12)
av.Visible=false
if ax then
av:Destroy()
end
end)
end

aj.AddSignal(as.TextButton.MouseButton1Click,function()
aq:Close(true)
end)

aq:Open()

function aq.Search(aw,ax)
ax=ax or""

local ay=Search(ax)

at.Visible=true
au.Frame.Results.Frame.Visible=true
for az,aA in next,at:GetChildren()do
if aA.ClassName~="UIListLayout"and aA.ClassName~="UIPadding"then
aA:Destroy()
end
end

if ay and next(ay)~=nil then
for az,aA in next,ay do
local aB=aq.Icons.Tab
local aC=CreateSearchTab(aA.Title,nil,aB,at,true,function()
aq:Close()
an:SelectTab(az)
end)
if aA.Elements and next(aA.Elements)~=nil then
for aD,aE in next,aA.Elements do
local aF=aq.Icons[aE.__type]
CreateSearchTab(
aE.Title,
aE.Desc,
aF,
aC:FindFirstChild"ParentContainer"and aC.ParentContainer.Frame
or nil,
false,
function()
aq:Close()
an:SelectTab(az)
if aA.Tab.ScrollToTheElement then

aA.Tab:ScrollToTheElement(aE.Index)
end

end
)

end
end
end
elseif ax~=""then
al("TextLabel",{
Size=UDim2.new(1,0,0,70),
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.2,
BackgroundTransparency=1,
FontFace=Font.new(aj.Font),
Parent=at,
Name="NotFound",
})
else
at.Visible=false
au.Frame.Results.Frame.Visible=false
end
end

aj.AddSignal(ar:GetPropertyChangedSignal"Text",function()
aq:Search(ar.Text)
end)

return aq
end

return ag end function a.aH()



local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ag=aa(game:GetService"UserInputService")
local aj=aa(game:GetService"RunService")
local al=aa(game:GetService"Players")

local am=workspace.CurrentCamera

local an=a.load'v'

local ao=a.load'd'
local ap=a.load'e'
local aq=ao.New
local ar=ao.Tween


local as=a.load'y'.New
local at=a.load'n'.New
local au=a.load'z'.New
local av=a.load'A'

local aw=a.load'B'



return function(ax)
local ay=ax.Default==true or ax.Preset=="Default"or ax.Preset=="Obsidian"
local az=ax.SideBarWidth~=nil
local function Pick(aA,aB)
if aA~=nil then
return aA
end
return aB
end
local function PickAlias(aA,aB,aC)
if aA~=nil then
return aA
end
if aB~=nil then
return aB
end
return aC
end

if ay then
ax.NewElements=Pick(ax.NewElements,true)
ax.LiquidGlass=PickAlias(ax.LiquidGlass,ax.GlassLiquid,true)
ax.HideSearchBar=Pick(ax.HideSearchBar,false)
ax.LinkElementCorners=PickAlias(ax.LinkElementCorners,ax.ElementsLinkCorners,true)
ax.CornerLink=ax.CornerLink
or ax.LinkedCornerOptions
or(typeof(ax.LinkElementCorners)=="table"and ax.LinkElementCorners)
or(typeof(ax.ElementsLinkCorners)=="table"and ax.ElementsLinkCorners)
or{
InnerRadius=0,
BridgeHidden=true,
}
local aA=typeof(ax.CornerLink)=="table"and(ax.CornerLink.Gap or ax.CornerLink.Spacing)
ax.ElementGap=PickAlias(
ax.ElementGap,
ax.ElementsGap,
ax.LinkElementCorners and(tonumber(aA)or 1)or 8
)
ax.ElementTransparency=PickAlias(ax.ElementTransparency,ax.ElementsTransparency,0.18)
ax.BackgroundOverlayTransparency=Pick(ax.BackgroundOverlayTransparency,0.5)
ax.BackgroundColor=Pick(ax.BackgroundColor,Color3.fromHex"#101821")
ax.Radius=Pick(ax.Radius,20)
ax.SideBarWidth=Pick(ax.SideBarWidth,210)
ax.Topbar=ax.Topbar or{
Height=48,
ButtonsType="Mac",
}
end

local aA=
tostring(ax.TabHolderType or ax.TabHolder or"sidebar"):lower():gsub("[%s_%-]","")
local aB=aA=="compact"
or aA=="sidebarcompact"
or aA=="icon"
or aA=="icononly"
local aC=if aA=="top"or aA=="horizontal"
then"top"
else"sidebar"
local aD=aC=="sidebar"
and(
aB
or ax.SidebarCompact==true
or ax.SideBarCompact==true
or ax.CompactSidebar==true
)
local aE=if aD
then(ax.CompactSideBarWidth or(az and ax.SideBarWidth or 68))
else(ax.SideBarWidth or 200)

local aF={
Title=ax.Title or"UI Library",
Author=ax.Author,
Icon=ax.Icon,
IconSize=ax.IconSize or 22,
IconThemed=ax.IconThemed,
IconRadius=ax.IconRadius or 0,
Folder=ax.Folder,
Resizable=ax.Resizable~=false,
Background=ax.Background or ax.BackgroundImage,
BackgroundColor=ax.BackgroundColor,
BackgroundGradient=ax.BackgroundGradient,
BackgroundImageTransparency=ax.BackgroundImageTransparency or 0,
BackgroundOverlayTransparency=ax.BackgroundOverlayTransparency or 0.62,
BackgroundScaleType=ax.BackgroundScaleType or"Crop",
ShadowTransparency=ax.ShadowTransparency or 0.6,
User=ax.User or{},
Footer=ax.Footer or{},
Topbar=ax.Topbar or{Height=52,ButtonsType="Default"},

Size=ax.Size,

MinSize=ax.MinSize or Vector2.new(560,350),
MaxSize=ax.MaxSize or Vector2.new(850,560),

TopBarButtonIconSize=ax.TopBarButtonIconSize,

ToggleKey=ax.ToggleKey,
ElementsRadius=ax.ElementsRadius,
Radius=ax.Radius or 16,
Transparent=ax.Transparent or false,
ElementTransparency=ax.ElementTransparency or ax.ElementsTransparency,
ElementGlassTransparency=ax.ElementGlassTransparency or ax.GlassTransparency,
LiquidGlass=ax.LiquidGlass or ax.GlassLiquid or ax.ElementGlass or false,
ElementCornerStyle=ax.ElementCornerStyle or ax.ElementsCornerStyle or ax.CornerStyle,
ElementGap=ax.ElementGap or ax.ElementsGap,
LinkElementCorners=ax.LinkElementCorners==true or ax.ElementsLinkCorners==true or typeof(
ax.LinkElementCorners
)=="table"or typeof(ax.ElementsLinkCorners)=="table",
ElementCornerLink=ax.CornerLink
or ax.LinkedCornerOptions
or(typeof(ax.LinkElementCorners)=="table"and ax.LinkElementCorners)
or(typeof(ax.ElementsLinkCorners)=="table"and ax.ElementsLinkCorners),
Watermark=ax.Watermark~=nil and ax.Watermark or ax.WaterMark,
KeyBindMenu=ax.KeyBindMenu==false and false or(ax.KeyBindMenu or{}),
HideSearchBar=ax.HideSearchBar~=false or aD,
ScrollBarEnabled=ax.ScrollBarEnabled or false,
SideBarWidth=aE,
TabHolderType=aC,
SidebarCompact=aD,
TopTabHeight=math.max(tonumber(ax.TopTabHeight or ax.TabHolderHeight)or 48,38),
Acrylic=ax.Acrylic or false,
NewElements=ax.NewElements or false,
Motion=ax.Motion,
Settings=ax.Settings==false and false or(ax.Settings or{}),
IgnoreAlerts=ax.IgnoreAlerts or false,
HidePanelBackground=ax.HidePanelBackground or false,
AutoScale=ax.AutoScale~=false,
OpenButton=ax.OpenButton,
DragFrameSize=160,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=16,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=ax.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=ax.Resizable~=false,
IsOpenButtonEnabled=true,

CurrentConfig=nil,
ConfigManager=nil,
AcrylicPaint=nil,
CurrentTab=nil,
TabModule=nil,

OnOpenCallback=nil,
OnCloseCallback=nil,
OnDestroyCallback=nil,

IsPC=false,

Gap=5,

TopBarButtons={},
AllElements={},

ElementConfig={},

PendingFlags={},

IsToggleDragging=false,
}

aF.UICorner=aF.Radius

aF.TopBarButtonIconSize=aF.TopBarButtonIconSize or(aF.Topbar.ButtonsType=="Mac"and 11 or 16)

aF.ElementConfig={
UIPadding=(aF.NewElements and 10 or 13),
UICorner=aF.ElementsRadius or(aF.NewElements and 23 or 16),
Transparency=aF.ElementTransparency,
GlassTransparency=aF.ElementGlassTransparency or 0.24,
LiquidGlass=aF.LiquidGlass,
CornerStyle=aF.ElementCornerStyle or(aF.NewElements and"Native"or"Shape"),
LinkCorners=aF.LinkElementCorners,
CornerLink=aF.ElementCornerLink,
}

local aG=aF.Size or UDim2.new(0,580,0,460)
aF.Size=UDim2.new(
aG.X.Scale,
math.clamp(aG.X.Offset,aF.MinSize.X,aF.MaxSize.X),
aG.Y.Scale,
math.clamp(aG.Y.Offset,aF.MinSize.Y,aF.MaxSize.Y)
)

if aF.Topbar=={}then
aF.Topbar={Height=52,ButtonsType="Default"}
end

if not aj:IsStudio()and aF.Folder and writefile then
if not isfolder("WindUI/"..aF.Folder)then
makefolder("WindUI/"..aF.Folder)
end
if not isfolder("WindUI/"..aF.Folder.."/assets")then
makefolder("WindUI/"..aF.Folder.."/assets")
end
if not isfolder(aF.Folder)then
makefolder(aF.Folder)
end
if not isfolder(aF.Folder.."/assets")then
makefolder(aF.Folder.."/assets")
end
end

local aH=aq("UICorner",{
CornerRadius=UDim.new(0,aF.UICorner),
})

if aF.Folder then
aF.ConfigManager=aw:Init(aF)
end

if aF.Acrylic then local
aI=an.AcrylicPaint{UseAcrylic=aF.Acrylic}

aF.AcrylicPaint=aI
end

local aI=aq("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true,
},{
aq("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})
local aJ=ao.NewRoundFrame(aF.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
aq("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=ao.Icon"expand"[1],
ImageRectOffset=ao.Icon"expand"[2].ImageRectPosition,
ImageRectSize=ao.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local aK=ao.NewRoundFrame(aF.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})









aF.UIElements.SideBar=aq("ScrollingFrame",{
Size=UDim2.new(
1,
aF.ScrollBarEnabled and-3-(aF.UIPadding/2)or 0,
1,
not aF.HideSearchBar and-45 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
aq("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
aq("UIPadding",{



PaddingBottom=UDim.new(0,aF.UIPadding/2),
}),
aq("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,aF.Gap),
}),
}),
aq("UIPadding",{

PaddingLeft=UDim.new(0,aF.UIPadding/2),
PaddingRight=UDim.new(0,aF.UIPadding/2),
PaddingBottom=UDim.new(0,aF.UIPadding/2),
}),

})

aF.UIElements.SideBarContainer=aq("Frame",{
Size=UDim2.new(
0,
aF.SideBarWidth,
1,
aF.User.Enabled and-aF.Topbar.Height-42-(aF.UIPadding*2)or-aF.Topbar.Height
),
Position=UDim2.new(0,0,0,aF.Topbar.Height),
BackgroundTransparency=1,
Visible=aF.TabHolderType=="sidebar",
},{
aq("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,not aF.HideSearchBar and-45-aF.UIPadding or-aF.UIPadding/2),
Position=UDim2.new(0,0,1,-aF.UIPadding/2),
AnchorPoint=Vector2.new(0,1),
}),
aF.UIElements.SideBar,
})

aF.UIElements.TopTabHolder=aq("ScrollingFrame",{
Name="TopTabHolder",
Size=UDim2.new(1,-aF.UIPadding,0,aF.TopTabHeight),
Position=UDim2.new(0,aF.UIPadding/2,0,aF.Topbar.Height),
BackgroundTransparency=1,
BorderSizePixel=0,
ScrollBarThickness=0,
ScrollingDirection=Enum.ScrollingDirection.X,
AutomaticCanvasSize=Enum.AutomaticSize.X,
CanvasSize=UDim2.new(0,0,0,0),
Visible=aF.TabHolderType=="top",
ClipsDescendants=true,
},{
aq("Frame",{
Name="Frame",
AutomaticSize=Enum.AutomaticSize.X,
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
},{
aq("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6),
}),
aq("UIPadding",{
PaddingLeft=UDim.new(0,aF.UIPadding/2),
PaddingRight=UDim.new(0,aF.UIPadding/2),
}),
}),
})
aF.UIElements.TabHolder=if aF.TabHolderType=="top"
then aF.UIElements.TopTabHolder.Frame
else aF.UIElements.SideBar.Frame

if aF.TabHolderType=="sidebar"and aF.ScrollBarEnabled then
au(
aF.UIElements.SideBar,
aF.UIElements.SideBarContainer.Content,
aF,
3,
ax.WindUI
)
end

aF.UIElements.MainBar=aq("Frame",{
Size=if aF.TabHolderType=="top"
then UDim2.new(1,0,1,-(aF.Topbar.Height+aF.TopTabHeight))
else UDim2.new(1,-aF.SideBarWidth,1,-aF.Topbar.Height),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
ao.NewRoundFrame(aF.UICorner-(aF.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="PanelBackground",
ImageTransparency="PanelBackgroundTransparency",
},


ZIndex=3,
Name="Background",
Visible=not aF.HidePanelBackground,
}),
aq("UIPadding",{

PaddingLeft=UDim.new(0,aF.UIPadding/2),
PaddingRight=UDim.new(0,aF.UIPadding/2),
PaddingBottom=UDim.new(0,aF.UIPadding/2),
}),
})

local aL=aq("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=UDim2.new(1,100,1,100),
Position=UDim2.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

if ag.TouchEnabled and not ag.KeyboardEnabled then
aF.IsPC=false
elseif ag.KeyboardEnabled then
aF.IsPC=true
else
aF.IsPC=nil
end







local aM
if aF.User then
local function GetUserThumb()local
aN=al:GetUserThumbnailAsync(
aF.User.Anonymous and 1 or al.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return aN
end

aM=aq("TextButton",{
Size=UDim2.new(
0,
aF.UIElements.SideBarContainer.AbsoluteSize.X-(aF.UIPadding/2),
0,
42+aF.UIPadding
),
Position=UDim2.new(0,aF.UIPadding/2,1,-(aF.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=aF.TabHolderType=="sidebar"and(aF.User.Enabled or false),
},{
ao.NewRoundFrame(aF.UICorner-(aF.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline",
},{
aq("UIGradient",{
Rotation=78,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
},
}),
}),
ao.NewRoundFrame(aF.UICorner-(aF.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
aq("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=0.93,
},{
aq("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
aq("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
aq("TextLabel",{
Text=aF.User.Anonymous and"Anonymous"or al.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ao.Font),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName",
}),
aq("TextLabel",{
Text=aF.User.Anonymous and"anonymous"or al.LocalPlayer.Name,
TextSize=15,
TextTransparency=0.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ao.Font),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName",
}),
aq("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
}),
}),
aq("UIListLayout",{
Padding=UDim.new(0,aF.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aq("UIPadding",{
PaddingLeft=UDim.new(0,aF.UIPadding/2),
PaddingRight=UDim.new(0,aF.UIPadding/2),
}),
}),
})

function aF.User.Enable(aN)
aF.User.Enabled=true
ar(
aF.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,aF.SideBarWidth,1,-aF.Topbar.Height-42-(aF.UIPadding*2))},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aM.Visible=aF.TabHolderType=="sidebar"
end
function aF.User.Disable(aN)
aF.User.Enabled=false
ar(
aF.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,aF.SideBarWidth,1,-aF.Topbar.Height)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aM.Visible=false
end
function aF.User.SetAnonymous(aN,aO)
if aO~=false then
aO=true
end
aF.User.Anonymous=aO
aM.UserIcon.ImageLabel.Image=GetUserThumb()
aM.UserIcon.Frame.DisplayName.Text=aO and"Anonymous"or al.LocalPlayer.DisplayName
aM.UserIcon.Frame.UserName.Text=aO and"anonymous"or al.LocalPlayer.Name
end

if aF.User.Enabled then
aF.User:Enable()
else
aF.User:Disable()
end

if aF.User.Callback then
ao.AddSignal(aM.MouseButton1Click,function()
aF.User.Callback()
end)
ao.AddSignal(aM.MouseEnter,function()
ar(aM.UserIcon,0.04,{ImageTransparency=0.95}):Play()
ar(aM.Outline,0.04,{ImageTransparency=0.85}):Play()
end)
ao.AddSignal(aM.InputEnded,function()
ar(aM.UserIcon,0.04,{ImageTransparency=1}):Play()
ar(aM.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local aN
local aO

local aP=false
local aQ

local function GetTransparencyValue(aR,aS)
local aT=tonumber(aR)
if aT==nil then
return aS
end
return math.clamp(math.floor(aT*100+0.5)/100,0,1)
end

local function ParseColorValue(aR)
if typeof(aR)=="Color3"then
return aR
end
if typeof(aR)=="string"and string.sub(aR,1,1)=="#"then
local aS,aT=pcall(function()
return Color3.fromHex(aR)
end)
return aS and aT or nil
end
return nil
end

local function GetUrlExtension(aR,aS)
if not aR or typeof(aR)~="string"then
return aS or".png"
end
local aT=aR:match"^([^?#]+)"or aR
local aU=aT:match"%.(%w+)$"
if aU then
aU=aU:lower()
if aU=="jpg"or aU=="jpeg"or aU=="png"or aU=="webp"or aU=="webm"then
return"."..aU
end
end
return aS or".png"
end

local function EnsureAssetFolder()
if aj:IsStudio()or not makefolder or not isfolder then
return
end

local aR=aF.Folder or"Temp"
if not isfolder(aR)then
makefolder(aR)
end
if not isfolder(aR.."/assets")then
makefolder(aR.."/assets")
end
end

local function ReadHttp(aR)
if game.HttpGet then
return game:HttpGet(aR)
end
if ao.Request then
local aS=ao.Request{
Url=aR,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"},
}
return aS and aS.Body
end
return nil
end

local function GetCustomAsset(aR)
if typeof(getcustomasset)~="function"then
return aR
end

local aS,aT=pcall(function()
return getcustomasset(aR)
end)
if aS then
return aT
end

warn("[ WindUI.Window.Background ] Failed to load custom asset: "..tostring(aT))
return aR
end

local function CacheHttpAsset(aR,aS)
if not writefile then
return aR
end

EnsureAssetFolder()
local aT=(aF.Folder or"Temp")
.."/assets/."
..ao.SanitizeFilename(aR)
..GetUrlExtension(aR,aS)

if not isfile or not isfile(aT)then
local aU,aV=pcall(function()
local aU=ReadHttp(aR)
if aU then
writefile(aT,aU)
end
end)

if not aU then
warn("[ WindUI.Window.Background ] Failed to download asset: "..tostring(aV))
return aR
end
end

return GetCustomAsset(aT)
end

local function ResolveBackgroundAsset(aR,aS)
if typeof(aR)~="string"then
return""
end

local aT=string.match(aR,"^video:(.+)")
if aT then
aR=aT
aS="Video"
end

local aU=string.match(aR,"^customasset:(.+)")
or string.match(aR,"^getcustomasset:(.+)")
or string.match(aR,"^file:(.+)")
if aU then
return GetCustomAsset(aU)
end

if isfile and isfile(aR)then
return GetCustomAsset(aR)
end

if string.match(aR,"^https?://")then
return CacheHttpAsset(aR,aS=="Video"and".webm"or".png")
end

return aR
end

local function GetBackgroundKind(aR)
if aR==nil or aR==false then
return nil,nil,{}
end

if typeof(aR)=="table"then
local aS=aR.Type or aR.Kind or aR.Mode
if aR.Video or aS=="Video"or aS=="video"then
return"Video",aR.Video or aR.Url or aR.URL or aR.Source or aR.Asset or aR.Path,aR
end
if aR.Image or aR.Url or aR.URL or aR.Asset or aR.Path or aS=="Image"or aS=="image"then
return"Image",aR.Image or aR.Url or aR.URL or aR.Asset or aR.Path or aR.Source,aR
end
if aR.Color or aS=="Color"or aS=="color"then
return"Color",aR.Color or aR.Value,aR
end
return"Gradient",aR.Gradient or aR,aR
end

local aS=ParseColorValue(aR)
if aS then
return"Color",aS,{}
end

if typeof(aR)=="string"then
local aT=string.match(aR,"^video:(.+)")
local aU=aR:match"^([^?#]+)"or aR
if aT or string.match(aU:lower(),"%.webm$")then
return"Video",aT or aR,{}
end
return"Image",aR,{}
end

return nil,nil,{}
end

local function CreateDetachedMediaBackground(aR,aS,aT)
if aR=="Image"then
aF.BackgroundScaleType=aT.ScaleType or aF.BackgroundScaleType
aF.BackgroundImageTransparency=GetTransparencyValue(
aT.Transparency or aT.ImageTransparency,
aF.BackgroundImageTransparency
)
return aq("ImageLabel",{
Name="BackgroundImage",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=ResolveBackgroundAsset(aS,"Image"),
ImageTransparency=aF.BackgroundImageTransparency,
ScaleType=aF.BackgroundScaleType,
ZIndex=-10,
},{
aq("UICorner",{
CornerRadius=UDim.new(0,aF.UICorner),
}),
})
end

if aR=="Video"then
local aU=aq("VideoFrame",{
Name="BackgroundVideo",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ResolveBackgroundAsset(aS,"Video"),
Looped=aT.Looped~=false,
Volume=math.clamp(tonumber(aT.Volume)or 0,0,1),
ZIndex=-10,
},{
aq("UICorner",{
CornerRadius=UDim.new(0,aF.UICorner),
}),
})
aU:Play()
return aU
end

return nil
end

local aR,aS,aT=GetBackgroundKind(aF.Background)
aP=aR=="Video"
aQ=CreateDetachedMediaBackground(aR,aS,aT)

local aU=ao.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
aq("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
}),
})

function createAuthor(aV)
return aq("TextLabel",{
Text=aV,
FontFace=Font.new(ao.Font),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=aF.UIElements.Main and aF.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor",
},
Name="Author",
})
end

local aV
local aW

if aF.Author then
aV=createAuthor(aF.Author)
end

local aX=aq("TextLabel",{
Text=aF.Title,
FontFace=Font.new(ao.Font),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="WindowTopbarTitle",
},
})

aF.UIElements.Main=aq("Frame",{
Size=UDim2.new(aF.Size.X.Scale,aF.Size.X.Offset,0,0),
Position=aF.Position,
BackgroundTransparency=1,
Parent=ax.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,

},{
ax.WindUI.UIScaleObj,
aF.AcrylicPaint and aF.AcrylicPaint.Frame or nil,
aL,
ao.NewRoundFrame(aF.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground",
},

},{
aQ,
aU,
aI,
}),




aH,
aJ,
aK,
aq("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
aq("UICorner",{
CornerRadius=UDim.new(0,aF.UICorner),
}),
aF.UIElements.SideBarContainer,
aF.UIElements.TopTabHolder,
aF.UIElements.MainBar,

aM,

aO,
aq("Frame",{
Size=UDim2.new(1,0,0,aF.Topbar.Height),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar",
},{
aN,






aq("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left",
},{
aq("UIListLayout",{
Padding=UDim.new(0,aF.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aq("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
aq("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
aX,
aV,
}),
aq("UIPadding",{
PaddingLeft=UDim.new(0,4),
}),
}),
aq("CanvasGroup",{
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Center",
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
AutomaticSize="Y",
Visible=false,
},{



aq("ScrollingFrame",{
Name="Holder",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
Size=UDim2.new(1,0,1,0),


},{

aq("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,aF.UIPadding/2),
}),
}),
}),
aq("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(aF.Topbar.ButtonsType=="Default"and 1 or 0,0,0.5,0),
AnchorPoint=Vector2.new(aF.Topbar.ButtonsType=="Default"and 1 or 0,0.5),
Name="Right",
},{
aq("UIListLayout",{
Padding=UDim.new(0,aF.Topbar.ButtonsType=="Default"and 9 or 0),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),
}),
aq("UIPadding",{
PaddingTop=UDim.new(0,aF.UIPadding),
PaddingLeft=UDim.new(
0,
aF.Topbar.ButtonsType=="Default"and aF.UIPadding or aF.UIPadding-2
),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,aF.UIPadding),
}),
}),
}),
})

ao.AddSignal(aF.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local aY=0
local aZ=aF.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X
/ax.WindUI.UIScale

aY=aF.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X/ax.WindUI.UIScale
if aF.Topbar.ButtonsType~="Default"then
aY=aY+aZ+aF.UIPadding-4
end

aF.UIElements.Main.Main.Topbar.Center.Position=
UDim2.new(0,aY+(aF.UIPadding/ax.WindUI.UIScale),0.5,0)
aF.UIElements.Main.Main.Topbar.Center.Size=UDim2.new(
1,
-aY
-(aF.UIPadding/ax.WindUI.UIScale)
-(aF.Topbar.ButtonsType=="Default"and aZ+aF.UIPadding or 0),
1,
0
)
end)

if aF.Topbar.ButtonsType~="Default"then
ao.AddSignal(aF.UIElements.Main.Main.Topbar.Right:GetPropertyChangedSignal"AbsoluteSize",function()
aF.UIElements.Main.Main.Topbar.Left.Position=UDim2.new(
0,
(aF.UIElements.Main.Main.Topbar.Right.AbsoluteSize.X/ax.WindUI.UIScale)+aF.UIPadding-4,
0,
0
)
end)
end

local function GetImageTarget(aY)
if typeof(aY)~="Instance"then
return nil
end

if aY:IsA"ImageLabel"or aY:IsA"ImageButton"then
return aY
end

return aY:FindFirstChildWhichIsA"ImageLabel"or aY:FindFirstChildWhichIsA"ImageButton"
end

function aF.CreateTopbarButton(aY,aZ,a_,a0,a1,a2,a3,a4,a5)
local a6=a1 or 999
a5=a5 or{}
local a7=a5.ForceIcon==true
local a8=aF.Topbar.ButtonsType=="Mac"and a5.MacAccent==true
local a9=aF.Topbar.ButtonsType=="Default"or a7
local b=aF.Topbar.ButtonsType~="Default"and not a7
local ba=math.max(tonumber(a5.Size)or aF.Topbar.Height-18,20)
local bb=ao.Image(
a_,
a_,
0,
aF.Folder,
"WindowTopbarIcon",
a9 and not a8,
a2,
"WindowTopbarButtonIcon"
)
bb.Size=a9
and UDim2.new(0,a4 or aF.TopBarButtonIconSize,0,a4 or aF.TopBarButtonIconSize)
or UDim2.new(0,0,0,0)
bb.AnchorPoint=Vector2.new(0.5,0.5)
bb.Position=UDim2.new(0.5,0,0.5,0)
local bc=GetImageTarget(bb)
if bc then
bc.ImageTransparency=a9 and 0 or 1
end
if a8 and bc then
bc.ImageColor3=ao.GetTextColorForHSB(a3 or Color3.fromHex"#A78BFA",0.72)
bc.ImageTransparency=0
end

if b and bc then
bc.ImageColor3=ao.GetTextColorForHSB(a3 or Color3.fromHex"#ff3030")
end

local bd=ao.NewRoundFrame(
a9 and(a8 and 999 or aF.UICorner-(aF.UIPadding/2))or 999,
"Squircle",
{
Size=a9 and UDim2.fromOffset(
a8 and ba or aF.Topbar.Height-16,
a8 and ba or aF.Topbar.Height-16
)or UDim2.new(0,14,0,14),
LayoutOrder=a6,


ZIndex=9999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageColor3=(b or a8)and(a3 or Color3.fromHex"#ff3030")or nil,
ThemeTag=a9 and not a8 and{
ImageColor3="Text",
}or nil,
ImageTransparency=a9 and(a8 and 0.08 or 1)or 0,
},
{












bb,
aq("UIScale",{
Scale=1,
}),
},
true
)

local be=aq("Frame",{
Size=b and UDim2.new(0,24,0,24)
or a8 and UDim2.fromOffset(ba+4,ba+4)
or UDim2.new(0,aF.Topbar.Height-16,0,aF.Topbar.Height-16),
BackgroundTransparency=1,
Parent=aF.UIElements.Main.Main.Topbar.Right,
LayoutOrder=a6,
},{
bd,
})



aF.TopBarButtons[100-a6]={
Name=aZ,
Object=be,
}

ao.AddSignal(bd.MouseButton1Click,function()
if a0 then
a0()
end
end)
ao.AddSignal(bd.MouseEnter,function()
if a9 then
ap.Play(bd,"Hover",{ImageTransparency=if a8 then 0 else 0.93},nil,nil,"Hover")


else

ap.Play(
bc,
"Hover",
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
ap.Play(bb,"Hover",{
Size=UDim2.new(
0,
a4 or aF.TopBarButtonIconSize,
0,
a4 or aF.TopBarButtonIconSize
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Hover")
end
end)

ao.AddSignal(bd.MouseButton1Down,function()
ap.Play(
bd.UIScale,
"Press",
{Scale=0.9},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
end)

ao.AddSignal(bd.MouseLeave,function()
if a9 then
ap.Play(bd,"Hover",{ImageTransparency=if a8 then 0.08 else 1},nil,nil,"Hover")


else

ap.Play(
bc,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
ap.Play(
bb,
"Hover",
{Size=UDim2.new(0,0,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end
end)

ao.AddSignal(bd.InputEnded,function()
ap.Play(
bd.UIScale,
"Press",
{Scale=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
end)

return bd
end

function aF.Topbar.Button(aY,aZ:{
Name:string,
Icon:string,
Callback:any,
LayoutOrder:number,
IconThemed:boolean,
Color:Color3,
IconSize:number,
Options:table,
})
return aF:CreateTopbarButton(
aZ.Name,
aZ.Icon,
aZ.Callback,
aZ.LayoutOrder or 0,
aZ.IconThemed,
aZ.Color,
aZ.IconSize,
aZ.Options
)
end



local aY=ao.Drag(
aF.UIElements.Main,
{aF.UIElements.Main.Main.Topbar,aU.Frame},
function(aY,aZ)
if not aF.Closed then
if aY and aZ==aU.Frame then
ar(aU,0.1,{ImageTransparency=0.35}):Play()
else
ar(aU,0.2,{ImageTransparency=0.8}):Play()
end
aF.Position=aF.UIElements.Main.Position
aF.Dragging=aY
end
end
)

local function ParseBackgroundColor(aZ)
return ParseColorValue(aZ)
end

local function ApplyBackgroundColor(aZ)
local a_=ParseBackgroundColor(aZ)
if a_ then
aF.BackgroundColor=aZ
ap.Play(
aF.UIElements.Main.Background,
"Background",
{ImageColor3=a_},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundColor"
)
end
return a_
end

local function SetBackgroundGradientObject(aZ,a_)
if aF.UIElements.BackgroundGradient then
aF.UIElements.BackgroundGradient:Destroy()
aF.UIElements.BackgroundGradient=nil
end

if typeof(aZ)~="table"then
return nil
end

local a0=aZ.Color~=nil
or aZ.Transparency~=nil
or aZ.Rotation~=nil
or aZ.Offset~=nil
if not a0 then
return nil
end

local a1=aq"UIGradient"
for a2,a3 in next,aZ do
if a2=="Transparency"and typeof(a3)=="number"then
continue
end
pcall(function()
a1[a2]=a3
end)
end

local a2=ao.NewRoundFrame(aF.UICorner,"Squircle",{
Name="BackgroundGradient",
Size=UDim2.new(1,0,1,0),
Parent=aF.UIElements.Main.Background,
ImageTransparency=a_ or aF.BackgroundOverlayTransparency,
ZIndex=-9,
},{
a1,
})

aF.UIElements.BackgroundGradient=a2
return a2
end

local function ClearDetachedBackgroundMedia(aZ)
if aZ~="Image"and aQ and aQ:IsA"ImageLabel"then
aQ:Destroy()
aQ=nil
elseif aZ~="Video"and aQ and aQ:IsA"VideoFrame"then
aQ:Destroy()
aQ=nil
end

if aZ~="Gradient"and aF.UIElements.BackgroundGradient then
aF.UIElements.BackgroundGradient:Destroy()
aF.UIElements.BackgroundGradient=nil
end
end

local function CreateImageBackground()
ClearDetachedBackgroundMedia"Image"

if aQ and aQ:IsA"ImageLabel"then
return aQ
end

if aQ then
aQ:Destroy()
end

aQ=aq("ImageLabel",{
Name="BackgroundImage",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ScaleType=aF.BackgroundScaleType,
ZIndex=-10,
Parent=aF.UIElements.Main.Background,
},{
aq("UICorner",{
CornerRadius=UDim.new(0,aF.UICorner),
}),
})

return aQ
end

local function CreateVideoBackground()
ClearDetachedBackgroundMedia"Video"

if aQ then
aQ:Destroy()
end

aQ=aq("VideoFrame",{
Name="BackgroundVideo",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Looped=true,
Volume=0,
ZIndex=-10,
Parent=aF.UIElements.Main.Background,
},{
aq("UICorner",{
CornerRadius=UDim.new(0,aF.UICorner),
}),
})

return aQ
end

if aF.BackgroundColor then
ApplyBackgroundColor(aF.BackgroundColor)
elseif aR=="Color"then
ApplyBackgroundColor(aS)
end

local aZ=aF.BackgroundGradient
or(aR=="Gradient"and aS or nil)
if aZ then
local a_=aF.BackgroundGradient and aF.BackgroundOverlayTransparency
or(aF.Transparent and ax.WindUI.TransparencyValue or 0)
SetBackgroundGradientObject(aZ,a_)
end














aF.OpenButtonMain=a.load'C'.New(aF)
aF.OpenButtonController=aF.OpenButtonMain
aF.WatermarkMain=a.load'D'.New(aF,ax.WindUI)

function aF.SetWatermark(a_,a0)
aF.Watermark=a0
return aF.WatermarkMain:Edit(a0)
end

function aF.ToggleWatermark(a_,a0)
if aF.WatermarkMain then
aF.WatermarkMain:Visible(a0)
end
end

if aF.Watermark~=nil and aF.Watermark~=false then
aF:SetWatermark(aF.Watermark)
end

task.spawn(function()
if aF.Icon then
local a_=aq("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=aF.UIElements.Main.Main.Topbar.Left,
})

aW=ao.Image(
aF.Icon,
aF.Title,
aF.IconRadius,
aF.Folder,
"Window",
true,
aF.IconThemed,
"WindowTopbarIcon"
)
aW.Parent=a_
aW.Size=UDim2.new(0,aF.IconSize,0,aF.IconSize)
aW.Position=UDim2.new(0.5,0,0.5,0)
aW.AnchorPoint=Vector2.new(0.5,0.5)

aF.OpenButtonMain:SetIcon(aF.Icon)











else
aF.OpenButtonMain:SetIcon(aF.Icon)

end
end)

function aF.SetToggleKey(a_,a0)
aF.ToggleKey=a0
end

function aF.SetTitle(a_,a0)
aF.Title=a0
aX.Text=a0
end

function aF.SetAuthor(a_,a0)
aF.Author=a0
if not aV then
aV=createAuthor(aF.Author)
end

aV.Text=a0
end

function aF.SetSize(a_,a0)
if typeof(a0)=="UDim2"then
aF.Size=a0

ar(aF.UIElements.Main,0.08,{Size=a0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

local function GetBackgroundTransparency(a_,a0)
return GetTransparencyValue(a_,a0)
end

function aF.SetBackgroundImage(a_,a0,a1)
a1=typeof(a1)=="table"and a1 or{Transparency=a1}
ClearDetachedBackgroundMedia"Image"
local a2=CreateImageBackground()
aF.Background=a0
aF.BackgroundGradient=nil
aF.BackgroundScaleType=a1.ScaleType or aF.BackgroundScaleType
aF.BackgroundImageTransparency=GetBackgroundTransparency(
a1.Transparency or a1.ImageTransparency,
aF.BackgroundImageTransparency
)
a2.ScaleType=aF.BackgroundScaleType
a2.Image=ResolveBackgroundAsset(a0,"Image")
a2.ImageTransparency=1
ap.Play(
a2,
"Background",
{ImageTransparency=aF.BackgroundImageTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundImage"
)
return a2
end

function aF.SetBackgroundVideo(a_,a0,a1)
a1=typeof(a1)=="table"and a1 or{}
ClearDetachedBackgroundMedia"Video"
local a2=CreateVideoBackground()
aF.Background="video:"..tostring(a0 or"")
aF.BackgroundGradient=nil
a2.Video=ResolveBackgroundAsset(a0,"Video")
a2.Visible=true
a2.Looped=a1.Looped~=false
a2.Volume=math.clamp(tonumber(a1.Volume)or a2.Volume or 0,0,1)
a2:Play()
return a2
end

function aF.SetBackgroundGradient(a_,a0,a1)
ClearDetachedBackgroundMedia"Gradient"
aF.BackgroundGradient=a0
aF.Background=nil
aF.BackgroundOverlayTransparency=GetBackgroundTransparency(a1,aF.BackgroundOverlayTransparency)
local a2=SetBackgroundGradientObject(a0,1)
if a2 then
ap.Play(
a2,
"Background",
{ImageTransparency=aF.BackgroundOverlayTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundGradient"
)
end
return a2
end

function aF.SetBackgroundColor(a_,a0)
return ApplyBackgroundColor(a0)
end

function aF.SetBackgroundOverlayTransparency(a_,a0)
aF.BackgroundOverlayTransparency=GetBackgroundTransparency(a0,aF.BackgroundOverlayTransparency)
if aF.UIElements.BackgroundGradient then
ap.Play(
aF.UIElements.BackgroundGradient,
"Background",
{ImageTransparency=aF.BackgroundOverlayTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundGradient"
)
end
return aF.BackgroundOverlayTransparency
end

function aF.SetBackground(a_,a0,a1)
if a0==nil or a0==false then
aF.Background=nil
aF.BackgroundGradient=nil
if aQ then
aQ:Destroy()
aQ=nil
end
if aF.UIElements.BackgroundGradient then
aF.UIElements.BackgroundGradient:Destroy()
aF.UIElements.BackgroundGradient=nil
end
return nil
end

local a2,a3,a4=GetBackgroundKind(a0)
local a5={}
if typeof(a4)=="table"then
for a6,a7 in next,a4 do
a5[a6]=a7
end
end
if typeof(a1)=="table"then
for a6,a7 in next,a1 do
a5[a6]=a7
end
elseif a1~=nil then
a5.Transparency=a1
end

if a2=="Gradient"then
return aF:SetBackgroundGradient(a3,a5.Transparency or a5.OverlayTransparency)
elseif a2=="Color"then
return aF:SetBackgroundColor(a3)
elseif a2=="Video"then
return aF:SetBackgroundVideo(a3,a5)
elseif a2=="Image"then
return aF:SetBackgroundImage(a3,a5)
end

return nil
end

function aF.SetBackgroundImageTransparency(a_,a0)
aF.BackgroundImageTransparency=GetBackgroundTransparency(a0,aF.BackgroundImageTransparency)
if aQ and aQ:IsA"ImageLabel"then
ap.Play(
aQ,
"Background",
{ImageTransparency=aF.BackgroundImageTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundImage"
)
end
end

function aF.SetBackgroundTransparency(a_,a0)
local a1=math.floor(tonumber(a0)*10+0.5)/10
ax.WindUI.TransparencyValue=a1
aF:ToggleTransparency(a1>0)
end

function aF.SetElementTransparency(a_,a0)
local a1=math.floor(ao.ClampTransparency(a0,aF.ElementConfig.Transparency or 0)*100+0.5)
/100

aF.ElementTransparency=a1
aF.ElementConfig.Transparency=a1

for a2,a3 in next,aF.AllElements do
if a3 and a3.SetTransparency then
a3:SetTransparency(a1)
end
end

return a1
end

function aF.SetLiquidGlass(a_,a0)
aF.LiquidGlass=a0==true
aF.ElementConfig.LiquidGlass=aF.LiquidGlass

for a1,a2 in next,aF.AllElements do
if a2 and a2.SetLiquidGlass then
a2:SetLiquidGlass(aF.LiquidGlass)
end
end
end

local a_
local a0
ao.Icon"minimize"
ao.Icon"maximize"

if aF.Settings~=false and aF.Topbar.Settings~=false then
local a1=a.load'E'.New(aF,ax.WindUI,ax)
local a2=aF:CreateTopbarButton(
"Settings",
"settings",
function()
a1:Toggle()
end,
aF.Topbar.ButtonsType=="Default"and 997 or 1000,
true,
Color3.fromHex"#9B87F5",
nil,
{
ForceIcon=true,
MacAccent=true,
}
)
a1:SetButton(a2)
aF.SettingsMenu=a1
end

if aF.KeyBindMenu~=false and aF.Topbar.KeyBindMenu~=false then
local a1=a.load'F'.New(aF,ax.WindUI,ax)
local a2=aF:CreateTopbarButton(
"KeyBind",
"keyboard",
function()
a1:Toggle()
end,
aF.Topbar.ButtonsType=="Default"and 996 or 1001,
true,
Color3.fromHex"#F472B6",
nil,
{
ForceIcon=true,
MacAccent=true,
}
)
a1:SetButton(a2)
aF.KeyBindMenuMain=a1

function aF.ToggleKeyBindMenu(a3)
return a1:Toggle()
end

function aF.OpenKeyBindMenu(a3)
return a1:OpenMenu()
end
end

aF:CreateTopbarButton(
"Fullscreen",
aF.Topbar.ButtonsType=="Mac"and"rbxassetid://127426072704909"or"maximize",
function()
aF:ToggleFullscreen()
end,
(aF.Topbar.ButtonsType=="Default"and 998 or 999),
true,
Color3.fromHex"#60C762",
aF.Topbar.ButtonsType=="Mac"and 9 or nil
)

local function SetSize(a1)
ap.Play(aF.UIElements.Main,"Resize",{
Size=not aF.IsFullscreen and a0 or UDim2.new(
0,
(ax.WindUI.ScreenGui.AbsoluteSize.X-20)/ax.WindUI.UIScale,
0,
(ax.WindUI.ScreenGui.AbsoluteSize.Y-20-52)/ax.WindUI.UIScale
),
Position=not aF.IsFullscreen and a_ or UDim2.new(0.5,0,0.5,26),
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Fullscreen"
)
end

function aF.ToggleFullscreen(a1)
local a2=aF.IsFullscreen

aY:Set(a2)

if not a2 then
a_=aF.UIElements.Main.Position
a0=aF.UIElements.Main.Size

aF.CanResize=false
else
if aF.Resizable then
aF.CanResize=true
end
end

aF.IsFullscreen=not a2

SetSize(true)
end

ao.AddSignal(ax.WindUI.ScreenGui:GetPropertyChangedSignal"AbsoluteSize",function()
if aF.IsFullscreen then
SetSize()
end
end)

aF:CreateTopbarButton("Minimize","minus",function()
if aF.Close then
aF:Close()
end






















end,(aF.Topbar.ButtonsType=="Default"and 997 or 998),nil,Color3.fromHex"#F4C948")

function aF.OnOpen(a1,a2)
aF.OnOpenCallback=a2
end
function aF.OnClose(a1,a2)
aF.OnCloseCallback=a2
end
function aF.OnDestroy(a1,a2)
aF.OnDestroyCallback=a2
end

if ax.WindUI.UseAcrylic then
aF.AcrylicPaint.AddParent(aF.UIElements.Main)
end

function aF.SetIconSize(a1,a2)
local a3
if typeof(a2)=="number"then
a3=UDim2.new(0,a2,0,a2)
aF.IconSize=a2
elseif typeof(a2)=="UDim2"then
a3=a2
aF.IconSize=a2.X.Offset
end

if aW then
aW.Size=a3
end
end

local a1={
Active=false,
RestorePosition=aF.UIElements.Main.Position,
TargetScale=nil,
}

local function GetWindowMorphTarget()
local a2=aF.OpenButtonMain
if not a2 or not aF.IsOpenButtonEnabled or aF.IsPC or not a2.GetMorphTarget then
return nil
end

local a3=a2:GetMorphTarget()
if not a3.Enabled or a3.Size.X<=0 or a3.Size.Y<=0 then
return nil
end

local a4=Vector2.new(0,0)
local a5=aF.UIElements.Main.Parent
if typeof(a5)=="Instance"and a5:IsA"GuiObject"then
a4=a5.AbsolutePosition
end

local a6=math.max(tonumber(ax.WindUI.UIScale)or 1,0.01)
local a7=aF.UIElements.Main.AbsoluteSize
local a8=math.max(aF.Size.X.Offset,a7.X/a6,1)
local a9=math.max(aF.Size.Y.Offset,a7.Y/a6,1)
local b=
math.clamp(math.min(a3.Size.X/a8,a3.Size.Y/a9),0.035,a6)

return{
Position=UDim2.fromOffset(a3.Position.X-a4.X,a3.Position.Y-a4.Y),
Scale=b,
Duration=a3.Duration>0 and a3.Duration or ap.GetDuration"WindowMorph",
}
end

function aF.Open(a2)
if aF.Destroyed then
return
end
task.spawn(function()
if aF.OnOpenCallback then
task.spawn(function()
ao.SafeCallback(aF.OnOpenCallback)
end)
end

task.wait(0.06)
aF.Closed=false
local a3=a1.Active
local a4=a3 and GetWindowMorphTarget()or nil

if a4 then
aF.UIElements.Main.Size=aF.Size
aF.UIElements.Main.Position=a4.Position
ax.WindUI.UIScaleObj.Scale=a1.TargetScale or a4.Scale
aF.UIElements.Main.Visible=true
aF.UIElements.Main:WaitForChild"Main".Visible=true
ap.Play(aF.UIElements.Main,a4.Duration,{
Position=a1.RestorePosition,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"WindowMorphPosition")
ap.Play(ax.WindUI.UIScaleObj,a4.Duration,{
Scale=ax.WindUI.UIScale,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"WindowMorphScale")
else
aF.UIElements.Main.Size=UDim2.new(aF.Size.X.Scale,aF.Size.X.Offset,0,100)
ap.Play(aF.UIElements.Main,"WindowOpen",{
Size=aF.Size,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end

if aF.UIElements.BackgroundGradient then
ap.Play(aF.UIElements.BackgroundGradient,"Focus",{
ImageTransparency=aF.BackgroundGradient and aF.BackgroundOverlayTransparency or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end

if not a4 then
aF.UIElements.Main.Background.ImageTransparency=1
end
ap.Play(aF.UIElements.Main.Background,"WindowOpen",{

ImageTransparency=aF.Transparent and ax.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,"WindowBackground")

if aQ then
if aQ:IsA"VideoFrame"then
aQ.Visible=true
else
ap.Play(aQ,"Focus",{
ImageTransparency=aF.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end
end

if aF.OpenButtonMain and aF.IsOpenButtonEnabled and not a4 then
aF.OpenButtonMain:Visible(false)
elseif a4 then
task.delay(math.min(a4.Duration*0.22,0.1),function()
if not aF.Closed and aF.OpenButtonMain then
aF.OpenButtonMain:Visible(false)
end
end)
end









ap.Play(
aL,
"WindowOpen",
{ImageTransparency=aF.ShadowTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Window"
)




ap.Play(
aU,
"WindowOpen",
{Size=UDim2.new(0,aF.DragFrameSize,0,4),ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
aY:Set(true)

if aF.Resizable then
ap.Play(
aI.ImageLabel,
"WindowOpen",
{ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
aF.CanResize=true
end

aF.CanDropdown=true
aF.UIElements.Main.Visible=true



aF.UIElements.Main:WaitForChild"Main".Visible=true

ax.WindUI:ToggleAcrylic(true)
a1.Active=false

end)
end
function aF.Close(a2)
if aF.Destroyed then
return
end

local a3={}
local a4
if aF.OpenButtonMain and aF.IsOpenButtonEnabled and not aF.IsPC then
aF.OpenButtonMain:SetState("Compact",nil,false)
aF.OpenButtonMain:Visible(true)
a4=GetWindowMorphTarget()
end
local a5=a4~=nil
local a6=a5 and a4.Duration or ap.GetDuration"WindowClose"
a1.Active=a5
a1.RestorePosition=aF.UIElements.Main.Position
a1.TargetScale=a5 and a4.Scale or nil

if aF.OnCloseCallback then
task.spawn(function()
ao.SafeCallback(aF.OnCloseCallback)
end)
end

if not a5 then
ax.WindUI:ToggleAcrylic(false)
end

if not a5 and aF.UIElements.Main and aF.UIElements.Main:WaitForChild"Main"then
aF.UIElements.Main.Main.Visible=false
end

aF.CanDropdown=false
aF.Closed=true

if a5 then
ap.Play(aF.UIElements.Main,a4.Duration,{
Position=a4.Position,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"WindowMorphPosition")
ap.Play(ax.WindUI.UIScaleObj,a4.Duration,{
Scale=a4.Scale,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"WindowMorphScale")
else
ap.Play(aF.UIElements.Main,"WindowClose",{
Size=UDim2.new(aF.Size.X.Scale,aF.Size.X.Offset,0,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end
if not a5 and aF.UIElements.BackgroundGradient then
ap.Play(aF.UIElements.BackgroundGradient,"Fast",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end

if not a5 then
ap.Play(aF.UIElements.Main.Background,"WindowClose",{

ImageTransparency=1,
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,"WindowBackground")
end








if aQ and not a5 then
if aQ:IsA"VideoFrame"then
aQ.Visible=false
else
ap.Play(aQ,"WindowClose",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end
end
if not a5 then
ap.Play(
aL,
"WindowClose",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Window"
)
end




ap.Play(
aU,
"WindowClose",
{Size=UDim2.new(0,0,0,4),ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
ap.Play(
aI.ImageLabel,
"WindowClose",
{ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
aY:Set(false)
aF.CanResize=false

task.spawn(function()
task.wait(a6+0.05)

if not aF.Closed then
return
end

aF.UIElements.Main.Visible=false
aF.UIElements.Main.Main.Visible=false
if a5 then
ax.WindUI:ToggleAcrylic(false)
if aQ and aQ:IsA"VideoFrame"then
aQ.Visible=false
end
end

if aF.OpenButtonMain and not aF.Destroyed and not aF.IsPC and aF.IsOpenButtonEnabled then
aF.OpenButtonMain:Visible(true)
end
end)

function a3.Destroy(a7)
task.spawn(function()
if aF.OnDestroyCallback then
task.spawn(function()
ao.SafeCallback(aF.OnDestroyCallback)
end)
end

if aF.AcrylicPaint and aF.AcrylicPaint.Model then
aF.AcrylicPaint.Model:Destroy()
end

aF.Destroyed=true

task.wait(0.4)

ax.WindUI.ScreenGui:Destroy()
ax.WindUI.NotificationGui:Destroy()
ax.WindUI.DropdownGui:Destroy()
ax.WindUI.TooltipGui:Destroy()

ao.DisconnectAll()

return
end)
end

return a3
end
function aF.Destroy(a2)
return aF:Close():Destroy()
end
function aF.Toggle(a2)
if aF.Closed then
aF:Open()
else
aF:Close()
end
end

function aF.ToggleTransparency(a2,a3)

aF.Transparent=a3
ax.WindUI.Transparent=a3

aF.UIElements.Main.Background.ImageTransparency=a3 and ax.WindUI.TransparencyValue or 0
if aF.UIElements.BackgroundGradient then
aF.UIElements.BackgroundGradient.ImageTransparency=a3 and ax.WindUI.TransparencyValue
or aF.BackgroundOverlayTransparency
end


end

function aF.LockAll(a2)
for a3,a4 in next,aF.AllElements do
if a4.Lock then
a4:Lock()
end
end
end
function aF.UnlockAll(a2)
for a3,a4 in next,aF.AllElements do
if a4.Unlock then
a4:Unlock()
end
end
end
function aF.GetLocked(a2)
local a3={}

for a4,a5 in next,aF.AllElements do
if a5.Locked then
table.insert(a3,a5)
end
end

return a3
end
function aF.GetUnlocked(a2)
local a3={}

for a4,a5 in next,aF.AllElements do
if a5.Locked==false then
table.insert(a3,a5)
end
end

return a3
end

function aF.GetUIScale(a2,a3)
return ax.WindUI.UIScale
end

function aF.SetUIScale(a2,a3)
ax.WindUI.UIScale=a3
ar(ax.WindUI.UIScaleObj,0.2,{Scale=a3},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return aF
end

function aF.SetToTheCenter(a2)
ar(
aF.UIElements.Main,
0.45,
{Position=UDim2.new(0.5,0,0.5,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
return aF
end

function aF.SetCurrentConfig(a2,a3)
aF.CurrentConfig=a3
end

do
local a2=40
local a3=am.ViewportSize
local a4=Vector2.new(aF.Size.X.Offset,aF.Size.Y.Offset)

if not aF.IsFullscreen and aF.AutoScale then
local a5=a3.X-(a2*2)
local a6=a3.Y-(a2*2)

local a7=a5/a4.X
local a8=a6/a4.Y

local a9=math.min(a7,a8)

local b=0.3
local ba=1.0

local bb=math.clamp(a9,b,ba)

local bc=aF:GetUIScale()or 1
local bd=0.05

if math.abs(bb-bc)>bd then
aF:SetUIScale(bb)
end
end
end

if aF.OpenButtonMain and aF.OpenButtonMain.Button then
ao.AddSignal(aF.OpenButtonMain.Button.TextButton.MouseButton1Click,function()


aF:Open()
end)
end

ao.AddSignal(ag.InputBegan,function(a2,a3)
if a3 then
return
end

if aF.ToggleKey then
if a2.KeyCode==aF.ToggleKey then
aF:Toggle()
end
end
end)

task.spawn(function()

aF:Open()
end)

function aF.EditOpenButton(a2,a3)
return aF.OpenButtonMain:Edit(a3)
end

function aF.GetOpenButton(a2)
return aF.OpenButtonMain
end

function aF.SetOpenButtonState(a2,a3,a4,a5)
return aF.OpenButtonMain:SetState(a3,a4,a5)
end

function aF.ExpandOpenButton(a2,a3,a4)
return aF.OpenButtonMain:Expand(a3,a4)
end

function aF.CollapseOpenButton(a2,a3)
return aF.OpenButtonMain:Collapse(a3)
end

function aF.CompactOpenButton(a2,a3)
return aF.OpenButtonMain:Compact(a3)
end

function aF.HideOpenButton(a2,a3)
return aF.OpenButtonMain:Idle(a3)
end

function aF.WakeOpenButton(a2,a3)
return aF.OpenButtonMain:Wake(a3)
end

function aF.PushOpenButton(a2,a3,a4)
return aF.OpenButtonMain:Push(a3,a4)
end

if aF.OpenButton and typeof(aF.OpenButton)=="table"then
aF:EditOpenButton(aF.OpenButton)
end

local a2=a.load'aD'
local a3=a.load'aE'
local a4=a2.Init(aF,ax.WindUI,ax.WindUI.TooltipGui)
a4:OnChange(function(a5)
aF.CurrentTab=a5
end)

aF.TabModule=a4

function aF.Tab(a5,a6)
a6.Parent=aF.UIElements.TabHolder
return a4.New(a6,ax.WindUI.UIScale)
end

function aF.SelectTab(a5,a6)
a4:SelectTab(a6)
end

function aF.Section(a5,a6)
return a3.New(
a6,
aF.UIElements.TabHolder,
aF.Folder,
ax.WindUI.UIScale,
aF
)
end

function aF.IsResizable(a5,a6)
aF.Resizable=a6
aF.CanResize=a6
end

function aF.SetPanelBackground(a5,a6)
if typeof(a6)=="boolean"then
aF.HidePanelBackground=a6

aF.UIElements.MainBar.Background.Visible=a6

if a4 then
for a7,a8 in next,a4.Containers do
a8.ScrollingFrame.UIPadding.PaddingTop=UDim.new(0,aF.HidePanelBackground and 20 or 10)
a8.ScrollingFrame.UIPadding.PaddingLeft=
UDim.new(0,aF.HidePanelBackground and 20 or 10)
a8.ScrollingFrame.UIPadding.PaddingRight=
UDim.new(0,aF.HidePanelBackground and 20 or 10)
a8.ScrollingFrame.UIPadding.PaddingBottom=
UDim.new(0,aF.HidePanelBackground and 20 or 10)
end
end
end
end

function aF.Divider(a5)
local a6=aq("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
})
local a7=aq("Frame",{
Parent=aF.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
a6,
})

return a7
end

local a5=a.load'p'
function aF.Dialog(a6,a7)
local a8={
Title=a7.Title or"Dialog",
Width=a7.Width or 320,
Content=a7.Content,
Buttons=a7.Buttons or{},

TextPadding=14,
}
local a9=a5.Create(false,"Dialog",aF,ax.WindUI,aF.UIElements.Main.Main)

a9.UIElements.Main.Size=UDim2.new(0,a8.Width,0,0)

local b=aq("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=a9.UIElements.Main,
},{
aq("UIListLayout",{
FillDirection="Vertical",

Padding=UDim.new(0,a9.UIPadding),
}),
})

local ba=aq("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=b,
},{
aq("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,a9.UIPadding),
VerticalAlignment="Center",
}),
aq("UIPadding",{
PaddingTop=UDim.new(0,a8.TextPadding/2),
PaddingLeft=UDim.new(0,a8.TextPadding/2),
PaddingRight=UDim.new(0,a8.TextPadding/2),
}),
})

local bb
if a7.Icon then
bb=ao.Image(
a7.Icon,
a8.Title..":"..a7.Icon,
0,
aF,
"Dialog",
true,
a7.IconThemed
)
bb.Size=UDim2.new(0,22,0,22)
bb.Parent=ba
end

a9.UIElements.UIListLayout=aq("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
VerticalFlex="SpaceBetween",
Parent=a9.UIElements.Main,
})

aq("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=a9.UIElements.Main,
})

a9.UIElements.Title=aq("TextLabel",{
Text=a8.Title,
TextSize=20,
FontFace=Font.new(ao.Font),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,bb and-26-a9.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=ba,
})
if a8.Content then
aq("TextLabel",{
Text=a8.Content,
TextSize=18,
TextTransparency=0.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(ao.Font),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=b,
},{
aq("UIPadding",{
PaddingLeft=UDim.new(0,a8.TextPadding/2),
PaddingRight=UDim.new(0,a8.TextPadding/2),
PaddingBottom=UDim.new(0,a8.TextPadding/2),
}),
})
end

local bc=aq("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Center",
HorizontalFlex="Fill",
})

local bd=aq("Frame",{
Size=UDim2.new(1,0,0,36),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=a9.UIElements.Main,
LayoutOrder=4,
},{
bc,






})

local be={}

for bf,bg in next,a8.Buttons do
local bh=
at(bg.Title,bg.Icon,bg.Callback,bg.Variant,bd,a9,true)
table.insert(be,bh)
bh.Size=UDim2.new(1,0,1,0)
end





















































a9:Open()

return a9
end

local a6=false

aF:CreateTopbarButton("Close","x",function()
if not a6 then
if not aF.IgnoreAlerts then
a6=true

aF:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()
a6=false
end,
Variant="Secondary",
},
{
Title="Close Window",

Callback=function()
a6=false
aF:Destroy()
end,
Variant="Primary",
},
},
}
else
aF:Destroy()
end
end
end,(aF.Topbar.ButtonsType=="Default"and 999 or 997),nil,Color3.fromHex"#F4695F")

function aF.Tag(a7,a8)
if aF.UIElements.Main.Main.Topbar.Center.Visible==false then
aF.UIElements.Main.Main.Topbar.Center.Visible=true
end
a8.Window=aF
return av:New(a8,aF.UIElements.Main.Main.Topbar.Center.Holder)
end

local a7=ax.WindUI.GenerateGUID()

local function startResizing(a8)
if aF.CanResize then
isResizing=true
aJ.Active=true
initialSize=aF.UIElements.Main.Size
initialInputPosition=a8.Position


ar(aI.ImageLabel,0.1,{ImageTransparency=0.35}):Play()

ao.AddSignal(a8.Changed,function()
if a8.UserInputState==Enum.UserInputState.End then
if ax.WindUI.CurrentInput and ax.WindUI.CurrentInput~=a7 then
return
end

ax.WindUI.CurrentInput=nil

isResizing=false
aJ.Active=false


ar(aI.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)
end
end

ao.AddSignal(aI.InputBegan,function(a8)
if
a8.UserInputType==Enum.UserInputType.MouseButton1
or a8.UserInputType==Enum.UserInputType.Touch
then
if ax.WindUI.CurrentInput and ax.WindUI.CurrentInput~=a7 then
return
end
ax.WindUI.CurrentInput=a7

if aF.CanResize then
startResizing(a8)
end
end
end)

ao.AddSignal(ag.InputChanged,function(a8)
if
a8.UserInputType==Enum.UserInputType.MouseMovement
or a8.UserInputType==Enum.UserInputType.Touch
then
if isResizing and aF.CanResize then
local a9=a8.Position-initialInputPosition
local b=UDim2.new(0,initialSize.X.Offset+a9.X*2,0,initialSize.Y.Offset+a9.Y*2)

b=UDim2.new(
b.X.Scale,
math.clamp(b.X.Offset,aF.MinSize.X,aF.MaxSize.X),
b.Y.Scale,
math.clamp(b.Y.Offset,aF.MinSize.Y,aF.MaxSize.Y)
)

ar(aF.UIElements.Main,0.08,{
Size=b,
},Enum.EasingStyle.Quad,Enum.EasingDirection.Out):Play()

aF.Size=b
end
end
end)

ao.AddSignal(aI.MouseEnter,function()
if ax.WindUI.CurrentInput and ax.WindUI.CurrentInput~=a7 then
return
end
if not isResizing then
ar(aI.ImageLabel,0.1,{ImageTransparency=0.35}):Play()
end
end)
ao.AddSignal(aI.MouseLeave,function()
if ax.WindUI.CurrentInput and ax.WindUI.CurrentInput~=a7 then
return
end
if not isResizing then
ar(aI.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)



local a8=0
local a9=0.4
local b
local ba=0

function onDoubleClick()
aF:SetToTheCenter()
end

ao.AddSignal(aU.Frame.MouseButton1Up,function()
local bb=tick()
local bc=aF.Position

ba=ba+1

if ba==1 then
a8=bb
b=bc

task.spawn(function()
task.wait(a9)
if ba==1 then
ba=0
b=nil
end
end)
elseif ba==2 then
if bb-a8<=a9 and bc==b then
onDoubleClick()
end

ba=0
b=nil
a8=0
else
ba=1
a8=bb
b=bc
end
end)



if aF.TabHolderType=="sidebar"and not aF.HideSearchBar then
local bb=a.load'aG'
local bc=false





















local bd=as("Search","search",aF.UIElements.SideBarContainer,true)
bd.Size=UDim2.new(1,-aF.UIPadding/2,0,39)
bd.Position=UDim2.new(0,aF.UIPadding/2,0,0)

ao.AddSignal(bd.MouseButton1Click,function()
if bc then
return
end

bb.new(aF.TabModule,aF.UIElements.Main,function()

bc=false
if aF.Resizable then
aF.CanResize=true
end

ar(aK,0.1,{ImageTransparency=1}):Play()
aK.Active=false
end)
ar(aK,0.1,{ImageTransparency=0.65}):Play()
aK.Active=true

bc=true
aF.CanResize=false
end)
end



function aF.DisableTopbarButtons(bb,bc)
for bd,be in next,bc do
for bf,bg in next,aF.TopBarButtons do
if bg.Name==be then
bg.Object.Visible=false
end
end
end
end



























return aF
end end end

local aa={
Window=nil,
Theme=nil,
Creator=a.load'd',
Motion=a.load'e',
LocalizationModule=a.load'f',
NotificationModule=a.load'g',
Themes=nil,
Transparent=false,

TransparencyValue=0.15,

UIScale=1,

ConfigManager=nil,
Version="0.0.0",

Services=a.load'l',

OnThemeChangeFunction=nil,

cloneref=nil,
UIScaleObj=nil,

CreateWindow=nil,

CurrentInput=nil,
}

aa.IconAdapterVersion=aa.Creator.IconAdapterVersion

local ag=(cloneref or clonereference or function(ag)
return ag
end)

aa.cloneref=ag

local aj=ag(game:GetService"HttpService")
local al=ag(game:GetService"Players")
local am=ag(game:GetService"CoreGui")
local an=ag(game:GetService"RunService")
local ao=ag(game:GetService"UserInputService")

function aa.GenerateGUID()
return aj:GenerateGUID(false)
end

local ap=aa.GenerateGUID()

ao.InputBegan:Connect(function(aq,ar)




task.defer(function()
if
aq.UserInputType==Enum.UserInputType.MouseButton1
or aq.UserInputType==Enum.UserInputType.Touch
then
if aa.CurrentInput and aa.CurrentInput~=ap then
return
end

aa.CurrentInput=ap


end
end)
end)
ao.InputEnded:Connect(function(aq,ar)
if aq.UserInputType==Enum.UserInputType.MouseButton1 or aq.UserInputType==Enum.UserInputType.Touch then
if aa.CurrentInput and aa.CurrentInput~=ap then
return
end

aa.CurrentInput=nil
end
end)

local aq=al.LocalPlayer or nil

local ar=aj:JSONDecode(a.load'm')
if ar then
aa.Version=ar.version
end

local as=a.load'q'
local at=a.load'r'

local au=aa.Creator

local av=au.New




local aw=a.load'v'

local ax=protectgui or(syn and syn.protect_gui)or function()end

local ay=gethui and gethui()or(am or aq:WaitForChild"PlayerGui")

local az=av("UIScale",{
Scale=aa.UIScale,
})

aa.UIScaleObj=az

aa.ScreenGui=av("ScreenGui",{
Name="WindUI",
Parent=ay,
IgnoreGuiInset=true,
ScreenInsets="None",
DisplayOrder=-99999,
},{

av("Folder",{
Name="Window",
}),






av("Folder",{
Name="KeySystem",
}),
av("Folder",{
Name="Popups",
}),
av("Folder",{
Name="ToolTips",
}),
})

aa.NotificationGui=av("ScreenGui",{
Name="WindUI/Notifications",
Parent=ay,
IgnoreGuiInset=true,
ScreenInsets="None",
ResetOnSpawn=false,
DisplayOrder=999999,
ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
})
aa.DropdownGui=av("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=ay,
IgnoreGuiInset=true,
})
aa.TooltipGui=av("ScreenGui",{
Name="WindUI/Tooltips",
Parent=ay,
IgnoreGuiInset=true,
})
ax(aa.ScreenGui)
ax(aa.NotificationGui)
ax(aa.DropdownGui)
ax(aa.TooltipGui)

au.Init(aa)

function aa.SetParent(aA,aB)
if aa.ScreenGui then
aa.ScreenGui.Parent=aB
end
if aa.NotificationGui then
aa.NotificationGui.Parent=aB
end
if aa.DropdownGui then
aa.DropdownGui.Parent=aB
end
if aa.TooltipGui then
aa.TooltipGui.Parent=aB
end
end
math.clamp(aa.TransparencyValue,0,1)

local aA=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(aB,aC)
aC.Holder=aA.Frame
aC.Window=aa.Window

return aa.NotificationModule.New(aC)
end

function aa.SetNotificationLower(aB,aC)
aA.SetLower(aC)
end

function aa.RegisterIconSource(aB,aC,aD,aE)
return au.RegisterIconSource(aC,aD,aE)
end

function aa.RegisterIconPack(aB,aC,aD)
return au.RegisterIconPack(aC,aD)
end

aa.AddIconSource=aa.RegisterIconSource
aa.AddIcons=aa.RegisterIconPack

function aa.AddIcon(aB,aC,aD,aE)
return au.AddIcon(aC,aD,aE)
end

function aa.AddIconSourceAlias(aB,aC,aD)
return au.AddIconSourceAlias(aC,aD)
end

function aa.SetIconSource(aB,aC)
return au.SetIconSource(aC)
end

function aa.GetIconSources(aB)
return au.GetIconSources()
end

function aa.HasIcon(aB,aC,aD)
return au.HasIcon(aC,aD)
end

function aa.LoadingScreen(aB,aC)
return at.new(aa,aC)
end

function aa.LoadingCreate(aB,aC)
if aa.ActiveLoading and not aa.ActiveLoading.Closed then
aa.ActiveLoading:Close(0)
end

aa.ActiveLoading=at.new(aa,aC)
return aa.ActiveLoading
end

function aa.LoadingSet(aB,aC,aD)
local aE=aa.ActiveLoading
if not aE or aE.Closed then
aE=aa:LoadingCreate{}
end

if typeof(aC)=="table"then
if aC.Status or aC.Text or aC.Title then
aE:SetStatus(aC.Status or aC.Text or aC.Title)
end
if aC.Progress~=nil or aC.Value~=nil then
aE:SetProgress(aC.Progress~=nil and aC.Progress or aC.Value)
end
if aC.Step then
aE:Step(aC.Step,aC.Status or aC.Text)
end
if aC.Close then
aE:Close(aC.Delay or aC.CloseDelay or 0)
end
return aE
end

if typeof(aC)=="number"then
aE:SetProgress(aC)
if aD then
aE:SetStatus(aD)
end
elseif aC~=nil then
aE:SetStatus(aC)
if typeof(aD)=="number"then
aE:SetProgress(aD)
end
end

return aE
end

function aa.SetFont(aB,aC)
au.UpdateFont(aC)
end

function aa.SetMotionPreset(aB,aC)
return aa.Motion:SetPreset(aC)
end

function aa.SetReducedMotion(aB,aC)
return aa.Motion:SetReducedMotion(aC)
end

function aa.OnThemeChange(aB,aC)
aa.OnThemeChangeFunction=aC
end

function aa.AddTheme(aB,aC)
aa.Themes[aC.Name]=aC
return aC
end

function aa.SetTheme(aB,aC)
if aa.Themes[aC]then
aa.Theme=aa.Themes[aC]
au.SetTheme(aa.Themes[aC])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(aC)
end

return aa.Themes[aC]
end
return nil
end

function aa.GetThemes(aB)
return aa.Themes
end
function aa.GetCurrentTheme(aB)
return aa.Theme.Name
end
function aa.GetTransparency(aB)
return aa.Transparent or false
end
function aa.GetWindowSize(aB)
return aa.Window.UIElements.Main.Size
end
function aa.Localization(aB,aC)
return aa.LocalizationModule:New(aC,au)
end

function aa.SetLanguage(aB,aC)
if au.Localization then
return au.SetLanguage(aC)
end
return false
end

function aa.ToggleAcrylic(aB,aC)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=aC
aa.Window.AcrylicPaint.Model.Transparency=aC and 0.98 or 1
if aC then
aw.Enable()
else
aw.Disable()
end
end
end

function aa.Gradient(aB,aC,aD)
local aE={}
local aF={}

for aG,aH in next,aC do
local aI=tonumber(aG)
if aI then
aI=math.clamp(aI/100,0,1)

local aJ=aH.Color
if typeof(aJ)=="string"and string.sub(aJ,1,1)=="#"then
aJ=Color3.fromHex(aJ)
end

local aK=aH.Transparency or 0

table.insert(aE,ColorSequenceKeypoint.new(aI,aJ))
table.insert(aF,NumberSequenceKeypoint.new(aI,aK))
end
end

table.sort(aE,function(aG,aH)
return aG.Time<aH.Time
end)
table.sort(aF,function(aG,aH)
return aG.Time<aH.Time
end)

if#aE<2 then
table.insert(aE,ColorSequenceKeypoint.new(1,aE[1].Value))
table.insert(aF,NumberSequenceKeypoint.new(1,aF[1].Value))
end

local aG={
Color=ColorSequence.new(aE),
Transparency=NumberSequence.new(aF),
}

if aD then
for aH,aI in pairs(aD)do
aG[aH]=aI
end
end

return aG
end

function aa.Popup(aB,aC)
aC.WindUI=aa
return a.load'w'.new(aC,aa.ScreenGui.Popups)
end

aa.Themes=a.load'x'(aa,au)

au.Themes=aa.Themes

aa:SetTheme"Dark"
aa:SetLanguage(au.Language)

function aa.CreateWindow(aB,aC)
local aD=a.load'aH'

if not an:IsStudio()and writefile then
if not isfolder"WindUI"then
makefolder"WindUI"
end
if aC.Folder then
makefolder(aC.Folder)
else
makefolder(aC.Title)
end
end

aC.WindUI=aa
aC.Window=aa.Window
aC.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

aa.Motion:Configure(aC.Motion)

local aE=true
local aF=aC.LoadingScreen or aC.Loader or aC.Loading
local aG

local function OpenLoader(aH,aI)
if aF==nil or aF==false then
return nil
end

if not aG then
local aJ={}
if typeof(aF)=="table"then
for aK,aL in next,aF do
aJ[aK]=aL
end
end

aJ.Title=aJ.Title or aC.Title or"WindUI"
aJ.Desc=aJ.Desc or"Loading interface"
aJ.Icon=aJ.Icon or aC.Icon or"sparkles"
aJ.Folder=aJ.Folder or aC.Folder
aG=at.new(aa,aJ)
end

if aH then
aG:SetStatus(aH)
end
if aI then
aG:SetProgress(aI)
end

return aG
end

if not aC.KeySystem then
OpenLoader("Preparing interface",0.16)
end

local aH=aC.Theme or"Dark"
local aI
if typeof(aH)=="table"then
aI=aH
elseif typeof(aH)=="string"then
aI=aa.Themes[aH]
end

aI=aI or aa.Theme or aa.Themes.Dark
aa.Theme=aI
au.SetTheme(aI)

local aJ=gethwid or function()
return al.LocalPlayer.UserId
end

local aK=aJ()

local function PickField(aL,aM)
for aN,aO in next,aM do
if aL[aO]~=nil then
return aL[aO]
end
end
return nil
end

local function NormalizeServiceType(aL)
local aM=string.lower(tostring(aL or""))
aM=string.gsub(aM,"%s+","")
aM=string.gsub(aM,"[_%-%./]","")

local aN={
luarmor="luarmor",
platoboost="platoboost",
plato="platoboost",
panda="pandadevelopment",
pandadev="pandadevelopment",
pandadevelopment="pandadevelopment",
junkie="junkiedevelopment",
junkiedev="junkiedevelopment",
junkiedevelopment="junkiedevelopment",
}

return aN[aM]or aM
end

local function NormalizeKeySystemAPI()
if not aC.KeySystem or typeof(aC.KeySystem.API)~="table"then
return
end

local aL=aC.KeySystem.API
local aM=aL
if aL.Type or aL.type or aL.Service or aL.service then
aM={aL}
end

local aN={}
for aO,aP in next,aM do
if typeof(aP)=="table"then
local aQ={}
for aR,aS in next,aP do
aQ[aR]=aS
end

aQ.Type=NormalizeServiceType(PickField(aP,{
"Type",
"type",
"Service",
"service",
"Provider",
"provider",
}))

aQ.ScriptId=PickField(aP,{
"ScriptId",
"ScriptID",
"scriptId",
"scriptID",
"script_id",
"Script",
"script",
"Id",
"ID",
"id",
})or aQ.ScriptId

aQ.ServiceId=PickField(aP,{
"ServiceId",
"ServiceID",
"serviceId",
"serviceID",
"service_id",
"Service",
"service",
"Id",
"ID",
"id",
})or aQ.ServiceId

aQ.Discord=PickField(aP,{
"Discord",
"discord",
"DiscordURL",
"DiscordUrl",
"discordUrl",
"discord_url",
"Invite",
"invite",
"URL",
"Url",
"url",
})or aQ.Discord

aQ.Secret=PickField(aP,{
"Secret",
"secret",
"ApiSecret",
"APISecret",
"apiSecret",
"api_secret",
})or aQ.Secret

aQ.ApiKey=PickField(aP,{
"ApiKey",
"APIKey",
"apiKey",
"api_key",
"Key",
"key",
})or aQ.ApiKey

if aQ.Type and aQ.Type~=""then
table.insert(aN,aQ)
end
end
end

aC.KeySystem.API=aN
end

NormalizeKeySystemAPI()

if aC.KeySystem then
aE=false

local function loadKeysystem()
as.new(aC,aK,function(aL)
aE=aL
end)
end

local aL=(aC.Folder or"Temp").."/"..aK..".key"

if aC.KeySystem.KeyValidator then
if aC.KeySystem.SaveKey and isfile(aL)then
local aM=readfile(aL)
local aN,aO=pcall(aC.KeySystem.KeyValidator,aM)

if aN and aO then
aE=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not aC.KeySystem.API then
if aC.KeySystem.SaveKey and isfile(aL)then
local aM=readfile(aL)
local aN=(type(aC.KeySystem.Key)=="table")and table.find(aC.KeySystem.Key,aM)
or tostring(aC.KeySystem.Key)==tostring(aM)

if aN then
aE=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(aL)then
local aM=readfile(aL)
local aN=false

for aO,aP in next,aC.KeySystem.API do
local aQ=aa.Services[aP.Type]
if aQ then
local aR={}
for aS,aT in next,aQ.Args do
table.insert(aR,aP[aT])
end

local aS,aT=pcall(function()
return aQ.New(table.unpack(aR))
end)
local aU,aV=false,false
if aS and aT and type(aT.Verify)=="function"then
aU,aV=pcall(aT.Verify,aM)
end
if aU and aV then
aN=true
break
end
end
end

aE=aN
if not aN then
loadKeysystem()
end
else
loadKeysystem()
end
end

repeat
task.wait()
until aE

OpenLoader("Access granted",0.42)
end

OpenLoader("Building window",0.72)
local aL=aD(aC)

aa.Transparent=aC.Transparent
aa.Window=aL

if aC.Acrylic then
aw.init()
end

if aG then
aG:SetStatus"Ready"
aG:SetProgress(1)
aG:Close((typeof(aF)=="table"and aF.CloseDelay)or 0.18)
end













return aL
end


-- ══════════════════════════════════════════════════════════════════════
--  VYNX UI PATCH v1.3
--  WindUI + Obsidian + NeverLose merged
--  github.com/rxinoussouls/VynxUI
-- ══════════════════════════════════════════════════════════════════════

local _UIS  = cloneref(game:GetService("UserInputService"))
local _TS   = cloneref(game:GetService("TweenService"))
local _PL   = cloneref(game:GetService("Players"))
local _LP   = _PL.LocalPlayer
local _Inst = Instance

local function _New(cls, props, children)
    local obj = _Inst.new(cls)
    if props then for k,v in pairs(props) do pcall(function() obj[k]=v end) end end
    if children then for _,c in ipairs(children) do if c then c.Parent=obj end end end
    return obj
end
local function mkFont()
    return Font.new("rbxasset://fonts/families/GothamSSm.json")
end
local function mkBold()
    return Font.new("rbxasset://fonts/families/GothamSSm.json")
end
local function mkTween(d)
    return TweenInfo.new(d or 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
end

-- ── 14 Themes ─────────────────────────────────────────────────────
local function T(name, bg, main, accent, outline, text, toggle, panel)
    return {Name=name,Background=bg,Dialog=main,Accent=main,
        Outline=outline,Text=text,Placeholder=Color3.fromHex("#888899"),
        Button=outline,Icon=text,Toggle=toggle,Slider=accent,Checkbox=accent,
        Primary=accent,LabelBackground=bg,LabelBackgroundTransparency=0,
        PanelBackground=panel,PanelBackgroundTransparency=0,
        ElementBackground=panel,ElementBackgroundTransparency=0,
        SliderIcon=accent}
end
local VynxThemes = {
    T("Vynx",      "#0A0814","#130e1f","#7C5CFF","#2f2150","#EDE8FF","#A374FF","#1D1530"),
    T("Dark",      "#0c0c12","#111116","#7C5CFF","#2e2e3e","#FFFFFF","#7C5CFF","#16161e"),
    T("Midnight",  "#06060F","#0e0e1c","#4466DD","#252540","#e0e0ff","#4488FF","#101025"),
    T("Rose",      "#1a020a","#3d0f1e","#e11d48","#7a1a35","#fdf2f8","#fb7185","#280d15"),
    T("Serenity",  "#030d12","#091820","#00A8C0","#1a4a58","#e0f4f9","#00c4df","#0a1e28"),
    T("Fatality",  "#080808","#101010","#cc2233","#3a1010","#ffffff","#ff3344","#140808"),
    T("Nord",      "#1e2230","#3b4252","#5e81ac","#4c566a","#eceff4","#88c0d0","#282e3e"),
    T("Dracula",   "#191a21","#282a36","#bd93f9","#44475a","#f8f8f2","#50fa7b","#21222c"),
    T("Catppuccin","#11111b","#1e1e2e","#cba6f7","#313244","#cdd6f4","#a6e3a1","#1e1e2e"),
    T("TokyoNight","#13131c","#1a1b26","#7aa2f7","#2a2b3d","#c0caf5","#9ece6a","#1f2035"),
    T("Gruvbox",   "#161616","#282828","#d79921","#3c3836","#ebdbb2","#b8bb26","#242424"),
    T("Cyberpunk", "#050510","#0d0d1a","#00ffff","#1a0033","#ffffff","#ff0066","#0d0d1f"),
    T("Aurora",    "#060e08","#0a1410","#00cc66","#1a3d2e","#e0ffe8","#4dff91","#0e1e14"),
    T("Light",     "#fafafa","#f4f4f5","#7C5CFF","#d4d4d8","#18181b","#7C5CFF","#ececf4"),
}
for _,t in VynxThemes do aa:AddTheme(t) end

-- ── Global state ──────────────────────────────────────────────────
aa.Toggles={};aa.Options={};aa.Labels={};aa.Buttons={}
aa.DependencyBoxes={};aa.Signals={};aa.UnloadCallbacks={}
aa.NotifySide="Right";aa.Unloaded=false;aa.DPIScale=1
aa.DynamicIsland=nil

-- ── Helpers ───────────────────────────────────────────────────────
function aa:GiveSignal(c) table.insert(aa.Signals,c);return c end
function aa:OnUnload(f)   table.insert(aa.UnloadCallbacks,f) end
function aa:Toggle(v)
    if aa.Window and aa.Window.Toggle then return aa.Window:Toggle(v) end
end
function aa:Unload()
    aa.Unloaded=true
    for _,f in aa.UnloadCallbacks do pcall(f) end
    for _,s in aa.Signals do if s and s.Connected then s:Disconnect() end end
    for _,g in {"ScreenGui","NotificationGui","DropdownGui"} do
        if aa[g] then pcall(function() aa[g]:Destroy() end) end
    end
end
function aa:SetDPIScale(s)    aa.DPIScale=math.max(0.5,math.min(s or 1,3)) end
function aa:SetNotifySide(s)  aa.NotifySide=(s=="Left" or s=="Right") and s or "Right" end
function aa:SetBackgroundImage(i) aa._bgImage=tostring(i or "") end
function aa:GetBetterColor(c,a) local h,s,v=c:ToHSV();return Color3.fromHSV(h,s,math.clamp(v+(a or 0)*0.05,0,1)) end
function aa:GetLighterColor(c) local h,s,v=c:ToHSV();return Color3.fromHSV(h,s,math.min(v+0.08,1)) end
function aa:GetDarkerColor(c)  local h,s,v=c:ToHSV();return Color3.fromHSV(h,s,math.max(v-0.08,0)) end
function aa:SafeCallback(f,...) if type(f)~="function" then return end;local ok,e=pcall(f,...);if not ok then warn("[VynxUI]",e) end end
function aa:GetKeyString(k)
    if typeof(k)~="EnumItem" then return tostring(k) end
    local s={LeftControl="LCtrl",RightControl="RCtrl",LeftShift="LShift",RightShift="RShift",Return="Enter",BackSpace="Back"}
    return s[k.Name] or k.Name
end
function aa:UpdateDependencyBoxes() for _,d in aa.DependencyBoxes do if d and d.Update then pcall(d.Update,d) end end end
function aa:UpdateSearch(t) aa.SearchText=t or "";aa.Searching=aa.SearchText~="" end
function aa:Validate(t,tmpl)
    if type(t)~="table" then t={} end
    for k,v in pairs(tmpl or {}) do if t[k]==nil then t[k]=type(v)=="function" and v() or v end end; return t
end

-- ── Scheme sync ───────────────────────────────────────────────────
local function SyncScheme()
    if not aa.Theme then return end
    aa.Scheme={
        BackgroundColor =aa.Theme.Background or Color3.fromHex("#0c0c12"),
        MainColor       =aa.Theme.Dialog     or Color3.fromHex("#111116"),
        AccentColor     =aa.Theme.Primary    or Color3.fromHex("#7C5CFF"),
        OutlineColor    =aa.Theme.Outline    or Color3.fromHex("#2e2e3e"),
        FontColor       =aa.Theme.Text       or Color3.new(1,1,1),
        Font            =mkFont(),
        RedColor        =Color3.fromRGB(255,50,50),
        DestructiveColor=Color3.fromRGB(220,38,38),
    }
end
local _oST=aa.SetTheme
function aa:SetTheme(n)
    local r=_oST(self,n)
    SyncScheme()
    if aa.DynamicIsland and aa.DynamicIsland._updateColors then
        aa.DynamicIsland._updateColors()
    end
    task.defer(function() task.wait(0.15);aa:_fixBg() end)
    return r
end

-- ── Fix white backgrounds ─────────────────────────────────────────
function aa:_fixBg()
    local gui=aa.ScreenGui; if not gui or not aa.Theme then return end
    local panel=aa.Theme.PanelBackground or Color3.fromHex("#16161e")
    for _,inst in gui:GetDescendants() do
        if inst:IsA("Frame") or inst:IsA("ScrollingFrame") then
            local ok,bg=pcall(function() return inst.BackgroundColor3 end)
            local ok2,tr=pcall(function() return inst.BackgroundTransparency end)
            if ok and ok2 and tr<0.5 then
                local r,g,b=bg.R,bg.G,bg.B
                if r>0.78 and g>0.78 and b>0.78 then
                    pcall(function()
                        inst.BackgroundColor3=panel
                        inst.BackgroundTransparency=0
                    end)
                end
            end
        end
    end
end

-- ── DependencyBox ─────────────────────────────────────────────────
local function MakeDepBox(sec,container)
    local DepFrame=_New("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),
        AutomaticSize=Enum.AutomaticSize.Y,Visible=false,ClipsDescendants=false,
        Parent=container},{_New("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder})})
    local DL=DepFrame:FindFirstChildOfClass("UIListLayout")
    local Dep={Type="DependencyBox",Destroyed=false,Visible=false,
        Dependencies={},Connections={},Elements={},_frame=DepFrame}

    local function pc()  return (aa.Theme and aa.Theme.PanelBackground) or Color3.fromHex("#16161e") end
    local function oc()  return (aa.Theme and aa.Theme.Outline)         or Color3.fromHex("#2e2e3e") end
    local function ac()  return (aa.Theme and aa.Theme.Primary)         or Color3.fromHex("#7C5CFF") end
    local function tc()  return (aa.Theme and aa.Theme.Text)            or Color3.new(1,1,1) end
    local function tgc() return (aa.Theme and aa.Theme.Toggle)          or Color3.fromHex("#7C5CFF") end

    function Dep:_resize() DepFrame.Size=UDim2.new(1,0,0,DL.AbsoluteContentSize.Y) end
    function Dep:Update()
        for _,d in Dep.Dependencies do
            local el,ex=d[1],d[2]; if not el then continue end
            local t,v=el.Type or "",el.Value
            if t=="Toggle" or t=="Checkbox" then
                if v~=ex then DepFrame.Visible=false;Dep.Visible=false;return end
            elseif t=="Dropdown" then
                if typeof(v)=="table" then if not v[ex] then DepFrame.Visible=false;Dep.Visible=false;return end
                else if v~=ex then DepFrame.Visible=false;Dep.Visible=false;return end end
            end
        end
        Dep.Visible=true;DepFrame.Visible=true
        task.defer(function() Dep:_resize() end)
    end
    function Dep:SetupDependencies(deps)
        for _,d in deps do
            local el=d[1]; if el then
                local sig=el.OnChanged or el._onChanged
                if sig then
                    local ev=typeof(sig)=="Instance" and sig.Event or sig
                    if typeof(ev)=="RBXScriptSignal" then
                        table.insert(Dep.Connections,ev:Connect(function() Dep:Update() end))
                    end
                end
            end
        end
        Dep.Dependencies=deps;Dep:Update()
    end
    DL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if Dep.Visible then Dep:_resize() end end)

    local function mkRow(h)
        return _New("Frame",{BackgroundColor3=pc(),BackgroundTransparency=0,
            Size=UDim2.new(1,0,0,h),Parent=DepFrame},{
            _New("UICorner",{CornerRadius=UDim.new(0,10)}),
            _New("UIStroke",{Color=oc(),Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border}),
            _New("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12)}),
        })
    end

    local function DepEl(eType,Idx,Info)
        Info=Info or {}
        local title=Info.Text or Info.Title or Info.Name or (type(Idx)=="string" and Idx) or ""
        local default=Info.Default; local cb=Info.Callback or Info.Changed or function()end
        local flag=(type(Idx)=="string" and Idx) or Info.Flag

        if eType=="Toggle" then
            local T={Type="Toggle",Value=default~=nil and default or false,_onChanged=_Inst.new("BindableEvent")}
            local row=mkRow(36)
            local lbl=_New("TextLabel",{BackgroundTransparency=1,Text=title,TextColor3=tc(),
                TextTransparency=0.3,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,-48,1,0),FontFace=mkFont(),Parent=row})
            local track=_New("Frame",{AnchorPoint=Vector2.new(1,0.5),BackgroundColor3=Color3.fromHex("#2a2a38"),
                Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(36,20),Parent=row},{
                _New("UICorner",{CornerRadius=UDim.new(1,0)}),
                _New("UIPadding",{PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2),PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)}),
            })
            local knob=_New("Frame",{BackgroundColor3=Color3.new(1,1,1),
                Size=UDim2.new(0,1,1,0),SizeConstraint=Enum.SizeConstraint.RelativeYY,Parent=track},{
                _New("UICorner",{CornerRadius=UDim.new(1,0)}),
            })
            local function updT(v)
                _TS:Create(track,mkTween(0.18),{BackgroundColor3=v and tgc() or Color3.fromHex("#2a2a38")}):Play()
                _TS:Create(knob,mkTween(0.2),{AnchorPoint=v and Vector2.new(1,0) or Vector2.new(0,0),Position=UDim2.fromScale(v and 1 or 0,0)}):Play()
                _TS:Create(lbl,mkTween(0.15),{TextTransparency=v and 0 or 0.3}):Play()
            end
            updT(T.Value)
            _New("TextButton",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text="",ZIndex=5,Parent=row})
                .MouseButton1Click:Connect(function()
                T.Value=not T.Value;updT(T.Value);T._onChanged:Fire(T.Value)
                aa:SafeCallback(cb,T.Value);aa:UpdateDependencyBoxes()
            end)
            function T:SetValue(v) T.Value=v;updT(v);T._onChanged:Fire(v);aa:SafeCallback(cb,v) end
            table.insert(Dep.Elements,T);if flag then aa.Toggles[flag]=T end;return T

        elseif eType=="Slider" then
            local min=Info.Min or 0;local max=Info.Max or 100;local sfx=Info.Suffix or Info.Float and "" or ""
            local S={Type="Slider",Value=math.clamp(default or min,min,max),_onChanged=_Inst.new("BindableEvent")}
            local row=mkRow(44)
            _New("TextLabel",{BackgroundTransparency=1,Text=title,TextColor3=tc(),TextTransparency=0.3,
                TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0.6,0,0,18),
                Position=UDim2.fromOffset(0,3),FontFace=mkFont(),Parent=row})
            local vLbl=_New("TextLabel",{BackgroundTransparency=1,TextColor3=ac(),TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Right,Size=UDim2.new(0.38,0,0,18),
                Position=UDim2.new(0.62,0,0,3),FontFace=mkFont(),Parent=row,
                Text=tostring(Info.Float and string.format("%.2f",S.Value) or S.Value)..sfx})
            local tBg=_New("Frame",{BackgroundColor3=oc(),Size=UDim2.new(1,0,0,5),
                Position=UDim2.new(0,0,0,26),Parent=row},{_New("UICorner",{CornerRadius=UDim.new(1,0)})})
            local fill=_New("Frame",{BackgroundColor3=ac(),
                Size=UDim2.fromScale(max>min and (S.Value-min)/(max-min) or 0,1),
                Parent=tBg},{_New("UICorner",{CornerRadius=UDim.new(1,0)})})
            local thumb=_New("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),
                Position=UDim2.fromScale(max>min and (S.Value-min)/(max-min) or 0,0.5),
                Size=UDim2.fromOffset(12,12),ZIndex=2,Parent=tBg},{
                _New("UICorner",{CornerRadius=UDim.new(1,0)}),
                _New("UIStroke",{Color=ac(),Thickness=2}),
            })
            local function updS(v)
                local dec=Info.Decimals or (Info.Float and 2 or 0)
                v=math.clamp(tonumber(string.format("%."..dec.."f",v)) or v,min,max)
                S.Value=v;local pct=max>min and (v-min)/(max-min) or 0
                _TS:Create(fill,mkTween(0.08),{Size=UDim2.fromScale(pct,1)}):Play()
                _TS:Create(thumb,mkTween(0.08),{Position=UDim2.fromScale(pct,0.5)}):Play()
                vLbl.Text=(dec>0 and string.format("%."..dec.."f",v) or tostring(v))..sfx
            end
            updS(S.Value)
            local dr=false
            tBg.InputBegan:Connect(function(inp)
                if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
                dr=true;local r=(inp.Position.X-tBg.AbsolutePosition.X)/tBg.AbsoluteSize.X
                updS(min+r*(max-min));S._onChanged:Fire(S.Value);aa:SafeCallback(cb,S.Value);aa:UpdateDependencyBoxes()
            end)
            _UIS.InputChanged:Connect(function(inp)
                if not dr then return end
                if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
                local r=(inp.Position.X-tBg.AbsolutePosition.X)/tBg.AbsoluteSize.X
                updS(min+r*(max-min));S._onChanged:Fire(S.Value);aa:SafeCallback(cb,S.Value);aa:UpdateDependencyBoxes()
            end)
            _UIS.InputEnded:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dr=false end
            end)
            function S:SetValue(v) updS(v);S._onChanged:Fire(S.Value);aa:SafeCallback(cb,S.Value) end
            table.insert(Dep.Elements,S);if flag then aa.Options[flag]=S end;return S

        elseif eType=="Dropdown" then
            local vals=Info.Values or {}
            local D={Type="Dropdown",Value=default,_onChanged=_Inst.new("BindableEvent")}
            local row=mkRow(36)
            _New("TextLabel",{BackgroundTransparency=1,Text=title,TextColor3=tc(),TextTransparency=0.3,
                TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0.5,0,1,0),FontFace=mkFont(),Parent=row})
            local dispFrame=_New("Frame",{AnchorPoint=Vector2.new(1,0.5),BackgroundColor3=oc(),
                Position=UDim2.new(1,0,0.5,0),Size=UDim2.new(0.46,0,0,24),Parent=row},{
                _New("UICorner",{CornerRadius=UDim.new(0,6)}),
                _New("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,22)}),
            })
            local dispLbl=_New("TextLabel",{BackgroundTransparency=1,TextColor3=tc(),TextSize=12,
                Size=UDim2.fromScale(1,1),TextXAlignment=Enum.TextXAlignment.Left,
                FontFace=mkFont(),Parent=dispFrame,Text=tostring(default or "Select...")})
            local chev=_New("TextLabel",{BackgroundTransparency=1,Text="▾",TextColor3=tc(),
                TextTransparency=0.5,TextSize=11,AnchorPoint=Vector2.new(1,0.5),
                Position=UDim2.new(1,-2,0.5,0),Size=UDim2.fromOffset(14,14),Parent=dispFrame})
            local listFrame=_New("Frame",{BackgroundColor3=pc(),Size=UDim2.new(0,140,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,AnchorPoint=Vector2.new(1,0),
                Position=UDim2.new(1,0,1,4),Visible=false,ZIndex=200,Parent=row},{
                _New("UICorner",{CornerRadius=UDim.new(0,8)}),
                _New("UIStroke",{Color=oc(),Thickness=1}),
                _New("UIListLayout",{Padding=UDim.new(0,1),SortOrder=Enum.SortOrder.LayoutOrder}),
                _New("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4)}),
            })
            for i,opt in vals do
                local ob=_New("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,24),
                    Text=tostring(opt),TextColor3=tc(),TextSize=12,FontFace=mkFont(),
                    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=201,LayoutOrder=i,Parent=listFrame},{
                    _New("UICorner",{CornerRadius=UDim.new(0,5)}),
                    _New("UIPadding",{PaddingLeft=UDim.new(0,8)}),
                })
                ob.MouseEnter:Connect(function() ob.BackgroundTransparency=0;ob.BackgroundColor3=ac();ob.TextColor3=Color3.new(1,1,1) end)
                ob.MouseLeave:Connect(function() ob.BackgroundTransparency=1;ob.TextColor3=tc() end)
                ob.MouseButton1Click:Connect(function()
                    D.Value=opt;dispLbl.Text=tostring(opt);listFrame.Visible=false
                    _TS:Create(chev,mkTween(0.12),{Rotation=0}):Play()
                    aa:SafeCallback(cb,opt);aa:UpdateDependencyBoxes();D._onChanged:Fire(opt)
                end)
            end
            local open=false
            _New("TextButton",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text="",ZIndex=5,Parent=dispFrame})
                .MouseButton1Click:Connect(function()
                open=not open;listFrame.Visible=open
                _TS:Create(chev,mkTween(0.15),{Rotation=open and 180 or 0}):Play()
            end)
            function D:SetValue(v) D.Value=v;dispLbl.Text=tostring(v);aa:SafeCallback(cb,v);aa:UpdateDependencyBoxes() end
            function D:SetValues(vs) vals=vs; for _,c in listFrame:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end end
            table.insert(Dep.Elements,D);if flag then aa.Options[flag]=D end;return D

        elseif eType=="Input" then
            local I={Type="Input",Value=default or "",_onChanged=_Inst.new("BindableEvent")}
            local row=mkRow(36)
            _New("TextLabel",{BackgroundTransparency=1,Text=title,TextColor3=tc(),TextTransparency=0.3,
                TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0.42,0,1,0),FontFace=mkFont(),Parent=row})
            local box=_New("TextBox",{BackgroundColor3=oc(),BackgroundTransparency=0,
                AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.new(0.55,0,0,22),
                Text=I.Value,PlaceholderText=Info.PlaceholderText or Info.Placeholder or Info.Default or "",
                TextColor3=tc(),PlaceholderColor3=Color3.fromHex("#666688"),TextSize=12,
                ClearTextOnFocus=false,FontFace=mkFont(),Parent=row},{
                _New("UICorner",{CornerRadius=UDim.new(0,6)}),
                _New("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)}),
            })
            box.Focused:Connect(function() _TS:Create(box,mkTween(0.1),{BackgroundColor3=aa:GetLighterColor(oc())}):Play() end)
            box.FocusLost:Connect(function() _TS:Create(box,mkTween(0.1),{BackgroundColor3=oc()}):Play()
                I.Value=box.Text;I._onChanged:Fire(I.Value);aa:SafeCallback(cb,I.Value) end)
            function I:SetValue(v) I.Value=v;box.Text=v end
            table.insert(Dep.Elements,I);if flag then aa.Options[flag]=I end;return I

        elseif eType=="Label" then
            local row=mkRow(28)
            local lbl=_New("TextLabel",{BackgroundTransparency=1,Text=title,TextColor3=tc(),TextTransparency=0.4,
                TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.fromScale(1,1),FontFace=mkFont(),Parent=row})
            local L={Type="Label",_label=lbl}; function L:SetText(t) lbl.Text=t end
            if flag then aa.Labels[flag]=L end;return L

        elseif eType=="Button" then
            local c=ac()
            local b=_New("TextButton",{BackgroundColor3=c,Size=UDim2.new(1,0,0,32),
                Text=title,TextColor3=Color3.new(1,1,1),TextSize=13,FontFace=mkFont(),Parent=DepFrame},{
                _New("UICorner",{CornerRadius=UDim.new(0,10)}),
            })
            b.MouseEnter:Connect(function() _TS:Create(b,mkTween(0.1),{BackgroundColor3=aa:GetLighterColor(c)}):Play() end)
            b.MouseLeave:Connect(function() _TS:Create(b,mkTween(0.1),{BackgroundColor3=c}):Play() end)
            b.MouseButton1Down:Connect(function() _TS:Create(b,mkTween(0.06),{BackgroundTransparency=0.15}):Play() end)
            b.MouseButton1Up:Connect(function() _TS:Create(b,mkTween(0.06),{BackgroundTransparency=0}):Play() end)
            b.MouseButton1Click:Connect(function() aa:SafeCallback(cb) end)
            local B={Type="Button"};if flag then aa.Buttons[flag]=B end;return B

        elseif eType=="Divider" then
            _New("Frame",{BackgroundColor3=oc(),Size=UDim2.new(1,-24,0,1),Position=UDim2.fromOffset(12,0),Parent=DepFrame}); return {}
        end
        return {}
    end

    -- Attach element API (supports both Obsidian AND NeverLose style)
    Dep.AddToggle      =function(s,I,i) return DepEl("Toggle",I,i or {}) end
    Dep.AddSlider      =function(s,I,i) return DepEl("Slider",I,i or {}) end
    Dep.AddDropdown    =function(s,I,i) return DepEl("Dropdown",I,i or {}) end
    Dep.AddInput       =function(s,I,i) return DepEl("Input",I,i or {}) end
    Dep.AddTextInput   =function(s,I,i) return DepEl("Input",I,i or {}) end  -- NeverLose alias
    Dep.AddLabel       =function(s,I,i) return DepEl("Label",I,type(i)=="table" and i or {Text=i}) end
    Dep.AddButton      =function(s,I,i) return DepEl("Button",I,i or {}) end
    Dep.AddDivider     =function(s,...) return DepEl("Divider",nil,nil) end
    Dep.AddCheckbox    =Dep.AddToggle
    Dep.AddKeyPicker   =function(s,I,i) return DepEl("Toggle",I,i or {}) end
    Dep.AddColorPicker =function(s,I,i) return DepEl("Label",I,i or {}) end
    Dep.AddKeybind     =Dep.AddKeyPicker  -- NeverLose alias
    Dep.AddOption      =function(s,...) return {} end  -- NeverLose (placeholder)

    function Dep:Destroy()
        Dep.Destroyed=true
        for _,c in Dep.Connections do if c.Connected then c:Disconnect() end end
        if DepFrame then pcall(function() DepFrame:Destroy() end) end
        local i=table.find(aa.DependencyBoxes,Dep);if i then table.remove(aa.DependencyBoxes,i) end
    end
    table.insert(aa.DependencyBoxes,Dep); return Dep
end

-- ── Inject Section API (Obsidian + NeverLose style) ───────────────
local function InjectSection(sec)
    if not sec or sec._vynxOk then return sec end
    sec._vynxOk=true
    local function C(Idx,Info)
        Info=Info or {}
        local flag=(type(Idx)=="string" and Idx) or Info.Flag
        return {Title=Info.Text or Info.Title or Info.Name or (type(Idx)=="string" and Idx) or "",
            Default=Info.Default,Flag=flag,
            Callback=Info.Callback or Info.Changed or function()end,
            Tooltip=Info.Tooltip,Locked=Info.Disabled or false,
            Min=Info.Min,Max=Info.Max,Suffix=Info.Suffix,Decimals=Info.Decimals,
            Values=Info.Values,Multi=Info.Multi,Searchable=Info.Searchable,
            Placeholder=Info.PlaceholderText or Info.Placeholder,
            Mode=Info.Mode,Transparency=Info.Transparency,
            Content=Info.Desc or Info.Content},flag
    end
    local function W(el,f,reg) if el and f then reg[f]=el end;return el end

    -- Obsidian + NeverLose AddToggle
    function sec:AddToggle(I,i)     local c,f=C(I,i); return W(self:Toggle(c),f,aa.Toggles) end
    function sec:AddSlider(I,i)     local c,f=C(I,i); return W(self:Slider(c),f,aa.Options) end
    function sec:AddDropdown(I,i)   local c,f=C(I,i); return W(self:Dropdown(c),f,aa.Options) end
    function sec:AddInput(I,i)      local c,f=C(I,i); return W(self:Input(c),f,aa.Options) end
    function sec:AddTextInput(I,i)  local c,f=C(I,i); return W(self:Input(c),f,aa.Options) end
    function sec:AddKeyPicker(I,i)  local c,f=C(I,i); return W(self:Keybind(c),f,aa.Options) end
    function sec:AddKeybind(I,i)    local c,f=C(I,i); return W(self:Keybind(c),f,aa.Options) end
    function sec:AddColorPicker(I,i) local c,f=C(I,i); return W(self:Colorpicker(c),f,aa.Options) end
    function sec:AddCheckbox(I,i)   local c,f=C(I,i); return W(self:Toggle(c),f,aa.Toggles) end
    function sec:AddButton(I,i)
        i=i or {};local nm=i.Text or i.Title or i.Name or (type(I)=="string" and I) or ""
        local el=self:Button({Title=nm,Callback=i.Callback or function()end})
        if type(I)=="string" then aa.Buttons[I]=el end;return el
    end
    function sec:AddLabel(I,i)
        i=i or {};local txt=i.Text or (type(i)=="string" and i) or (type(I)=="string" and I) or ""
        local el=self:Paragraph({Title=txt,Content=i.Desc or i.Content or ""})
        if type(I)=="string" then aa.Labels[I]=el end;return el
    end
    function sec:AddDivider() return self:Divider({}) end
    function sec:AddImage(I,i)    return self:Image(i or {}) end
    function sec:AddViewport(I,i) return self:Viewport(i or {}) end
    function sec:AddVideo(I,i)    return self:Video(i or {}) end
    function sec:AddProgressBar(I,i) return self:ProgressBar(i or {}) end
    function sec:AddSegmentedControl(I,i) local c,f=C(I,i); return W(self:SegmentedControl(c),f,aa.Options) end
    function sec:AddOption(GearIcon) return {} end -- NeverLose placeholder
    function sec:AddUserFrame(Name,Profile,Expires) return {} end -- NeverLose placeholder
    function sec:AddDependencyBox()
        local ct=nil
        if sec.UIElements then
            ct=sec.UIElements.ElementContainer or sec.UIElements.Content
                or sec.UIElements.Container or sec.UIElements.ScrollingFrame
        end
        return MakeDepBox(sec, ct or sec._frame)
    end
    function sec:AddDependencyGroupbox(t) return MakeDepBox(sec, sec._frame) end
    return sec
end

-- ── Inject Tab API ────────────────────────────────────────────────
local function InjectTab(tab)
    if not tab or tab._vynxTabOk then return tab end
    tab._vynxTabOk=true
    local oS=tab.Section or tab.CreateSection
    local function mkSec(n)
        if not oS then return InjectSection({_frame=nil,UIElements={}}) end
        local ok,r=pcall(oS,tab,{Title=n or ""});local s=ok and r or nil
        if s then InjectSection(s) end;return s
    end
    tab.AddGroupbox      =function(s,n) return mkSec(n) end
    tab.AddLeftGroupbox  =function(s,n) return mkSec(n) end
    tab.AddRightGroupbox =function(s,n) return mkSec(n) end
    tab.AddSection       =function(s,cfg) return mkSec(type(cfg)=="table" and (cfg.Name or cfg.Title) or cfg) end
    tab.AddTab           =tab.CreateTab
    if oS then
        tab.Section=function(s,c) local r=oS(s,c);if r then InjectSection(r) end;return r end
        tab.CreateSection=tab.Section
    end
    return tab
end

-- ── Dynamic Island ────────────────────────────────────────────────
local function CreateIsland(gui, cfg)
    cfg=cfg or {}
    local accent = (aa.Theme and aa.Theme.Primary) or Color3.fromHex("#7C5CFF")
    local title  = cfg.Title or "VYNX"

    -- Hide WindUI's original open button if exists
    task.defer(function()
        if gui then
            for _,v in gui:GetDescendants() do
                if v.Name == "OpenButton" or v.Name == "Openbutton" then
                    pcall(function() v.Visible=false end)
                end
            end
        end
    end)

    local island = _New("Frame",{
        Name="VynxIsland",
        AnchorPoint=Vector2.new(0.5,0),
        Position=UDim2.new(0.5,0,0,0),
        Size=UDim2.fromOffset(108,32),
        BackgroundColor3=Color3.fromHex("#050508"),
        BackgroundTransparency=0,
        ZIndex=9999, Active=true, Parent=gui,
    },{
        _New("UICorner",{CornerRadius=UDim.new(1,0)}),
        _New("UIStroke",{Color=Color3.fromHex("#1a1a2e"),Thickness=1}),
    })

    -- Camera dot (left)
    _New("Frame",{
        AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromOffset(10,16),
        Size=UDim2.fromOffset(5,5),BackgroundColor3=Color3.fromHex("#1a1a2e"),
        ZIndex=10000,Parent=island,
    },{_New("UICorner",{CornerRadius=UDim.new(1,0)})})

    -- Title (hidden by default)
    local titleLbl=_New("TextLabel",{
        AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromOffset(22,16),
        Size=UDim2.new(1,-44,0,16),BackgroundTransparency=1,
        Text=title,TextColor3=Color3.new(1,1,1),TextSize=11,
        FontFace=mkFont(),TextXAlignment=Enum.TextXAlignment.Left,
        TextTransparency=1,ZIndex=10000,Parent=island,
    })

    -- Activity dot (right)
    local dot=_New("Frame",{
        AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.5,0),
        Size=UDim2.fromOffset(5,5),BackgroundColor3=accent,
        ZIndex=10000,Parent=island,
    },{_New("UICorner",{CornerRadius=UDim.new(1,0)})})

    local hitBtn=_New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=10001,Parent=island})

    local baseW=108; local expW=170; local expanded=false; local hoverTimer=nil

    local function animIsland(expand)
        expanded=expand
        _TS:Create(island,mkTween(0.28),{Size=UDim2.fromOffset(expand and expW or baseW, 32)}):Play()
        _TS:Create(titleLbl,mkTween(0.18),{TextTransparency=expand and 0 or 1}):Play()
        _TS:Create(dot,mkTween(0.15),{BackgroundColor3=expand and Color3.fromHex("#33C759") or accent}):Play()
    end

    island.MouseEnter:Connect(function()
        if hoverTimer then hoverTimer:Disconnect() end
        animIsland(true)
    end)
    island.MouseLeave:Connect(function()
        hoverTimer=task.delay(0.7, function() animIsland(false) end)
    end)
    hitBtn.MouseButton1Click:Connect(function()
        if aa.Window and aa.Window.Toggle then aa.Window:Toggle() end
        local sz=expanded and expW or baseW
        _TS:Create(island,mkTween(0.06),{Size=UDim2.fromOffset(sz-5,28)}):Play()
        task.wait(0.08)
        _TS:Create(island,mkTween(0.12),{Size=UDim2.fromOffset(sz,32)}):Play()
    end)

    local API={}
    function API:Pulse(msg,color)
        titleLbl.Text=msg or title
        _TS:Create(island,mkTween(0.28),{Size=UDim2.fromOffset(expW,32)}):Play()
        _TS:Create(titleLbl,mkTween(0.18),{TextTransparency=0}):Play()
        _TS:Create(dot,mkTween(0.15),{BackgroundColor3=color or accent}):Play()
        task.delay(2.5,function()
            titleLbl.Text=title
            _TS:Create(island,mkTween(0.28),{Size=UDim2.fromOffset(baseW,32)}):Play()
            _TS:Create(titleLbl,mkTween(0.18),{TextTransparency=1}):Play()
            _TS:Create(dot,mkTween(0.15),{BackgroundColor3=accent}):Play()
        end)
    end
    function API:SetTitle(t) title=t;titleLbl.Text=t end
    function API:SetIcon(img) end
    function API:Destroy() island:Destroy() end
    function API:_updateColors()
        accent=(aa.Theme and aa.Theme.Primary) or accent
        dot.BackgroundColor3=accent
    end
    aa.DynamicIsland=API
    return API
end

-- ── Wrap CreateWindow ─────────────────────────────────────────────
local _oCW=aa.CreateWindow
function aa:CreateWindow(cfg)
    local win=_oCW(self,cfg)
    if not win then return win end

    -- Wrap CreateTab
    local _oCT=win.CreateTab or win.Tab
    if _oCT then
        win.CreateTab=function(s,c) local t=_oCT(s,c);if t then InjectTab(t) end;return t end
        win.Tab=win.CreateTab;win.AddTab=win.CreateTab
    end

    -- NeverLose Window methods
    function win:SetAccount(cfg2)
        cfg2=cfg2 or {}
        if aa.DynamicIsland then
            local name=cfg2.Username or (cfg2.Profile and cfg2.Profile~="" and cfg2.Username) or "User"
            aa.DynamicIsland:SetTitle(name)
        end
    end
    function win:AddTabLabel(Name)
        -- Creates a non-clickable label in the sidebar
        return {Label=Name}
    end
    function win:ToggleInterface() win:Toggle() end
    function win:SetSize(sz) end -- handled by WindUI internally

    -- Fix backgrounds + create island
    task.defer(function()
        task.wait(0.25)
        aa:_fixBg()
        local gui=aa.ScreenGui
        if gui and not aa.DynamicIsland then
            CreateIsland(gui,{Title=cfg.Title or "VYNX"})
        end
    end)

    return win
end

-- ── Override Notify → pulse island ───────────────────────────────
local _oNot=aa.Notify
if _oNot then
    aa.Notify=function(s,cfg2)
        local r=_oNot(s,cfg2)
        if aa.DynamicIsland and cfg2 then
            local cols={Success=Color3.fromHex("#33C759"),Error=Color3.fromHex("#ff3344"),
                Warning=Color3.fromHex("#ff9f0a"),Info=Color3.fromHex("#7C5CFF"),
                Notice=Color3.fromHex("#888899")}
            aa.DynamicIsland:Pulse(cfg2.Title or "Notice",cols[cfg2.Style] or cols.Info)
        end
        return r
    end
end

-- ── NeverLose compat: CreateWindow alias ─────────────────────────
aa.NeverLose={
    CreateWindow=function(self,cfg) return aa:CreateWindow({
        Title   =cfg.Name or cfg.Title or "Hub",
        Author  =cfg.Content or "",
        Icon    =cfg.Logo or "",
        Size    =cfg.Size or UDim2.fromOffset(600,440),
        ToggleKey=cfg.Keybind and Enum.KeyCode[cfg.Keybind] or Enum.KeyCode.Insert,
    }) end,
    AddSignal=function(self,sig) return aa:GiveSignal(sig) end,
}

-- ── Draggable overlays ────────────────────────────────────────────
function aa:MakeDraggable(ui,df)
    local d,s,sp=false,nil,nil
    df.InputBegan:Connect(function(inp)
        if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
        d=true;s=inp.Position;sp=ui.Position
        inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then d=false end end)
    end)
    _UIS.InputChanged:Connect(function(inp)
        if not d then return end
        if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
        local dt=inp.Position-s;ui.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y)
    end)
end

function aa:AddDraggableLabel(text,pos)
    local gui=aa.ScreenGui;if not gui then return {} end
    local lbl=_New("TextLabel",{BackgroundColor3=Color3.fromHex("#050508"),BackgroundTransparency=0,
        AutomaticSize=Enum.AutomaticSize.XY,Position=pos or UDim2.fromOffset(8,50),
        Text=text or "",TextColor3=Color3.new(1,1,1),TextSize=12,FontFace=mkFont(),
        ZIndex=9999,Active=true,Parent=gui},{
        _New("UICorner",{CornerRadius=UDim.new(0,20)}),
        _New("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6)}),
        _New("UIStroke",{Color=Color3.fromHex("#1a1a2e"),Thickness=1}),
    })
    aa:MakeDraggable(lbl,lbl)
    local L={Frame=lbl}
    function L:SetText(t) lbl.Text=t end
    function L:SetVisible(v) lbl.Visible=v end
    function L:Destroy() lbl:Destroy() end
    return L
end

function aa:AddDraggableButton(text,cb,vis)
    local gui=aa.ScreenGui;if not gui then return {} end
    local ac=(aa.Theme and aa.Theme.Primary) or Color3.fromHex("#7C5CFF")
    local b=_New("TextButton",{BackgroundColor3=ac,AutomaticSize=Enum.AutomaticSize.XY,
        Position=UDim2.fromOffset(8,90),Text=text or "",TextColor3=Color3.new(1,1,1),TextSize=12,
        FontFace=mkFont(),ZIndex=9999,Active=true,Visible=vis~=false,Parent=gui},{
        _New("UICorner",{CornerRadius=UDim.new(1,0)}),
        _New("UIPadding",{PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14),PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6)}),
    })
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    aa:MakeDraggable(b,b)
    local B={Button=b}; function B:SetText(t) b.Text=t end; function B:SetVisible(v) b.Visible=v end; function B:Destroy() b:Destroy() end; return B
end

function aa:AddDraggableMenu(name)
    local gui=aa.ScreenGui;if not gui then return {AddItem=function()end,SetVisible=function()end,Destroy=function()end} end
    local bg=(aa.Theme and aa.Theme.Dialog) or Color3.fromHex("#111116")
    local oc=(aa.Theme and aa.Theme.Outline) or Color3.fromHex("#2e2e3e")
    local frame=_New("Frame",{BackgroundColor3=bg,Size=UDim2.fromOffset(175,0),AutomaticSize=Enum.AutomaticSize.Y,
        Position=UDim2.fromOffset(8,130),ZIndex=9998,Active=true,Parent=gui},{
        _New("UICorner",{CornerRadius=UDim.new(0,12)}),_New("UIStroke",{Color=oc,Thickness=1}),
        _New("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8)}),
    })
    local hdr=_New("TextLabel",{BackgroundTransparency=1,Text=name or "Menu",TextColor3=Color3.fromHex("#888899"),
        TextSize=10,FontFace=mkFont(),Size=UDim2.new(1,0,0,14),LayoutOrder=0,TextXAlignment=Enum.TextXAlignment.Left,Parent=frame})
    local list=_New("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
        LayoutOrder=1,Parent=frame},{_New("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder})})
    aa:MakeDraggable(frame,hdr)
    local M={Frame=frame}
    function M:SetVisible(v) frame.Visible=v end
    function M:AddItem(text,cb)
        local ac2=(aa.Theme and aa.Theme.Primary) or Color3.fromHex("#7C5CFF")
        local b=_New("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,26),
            Text=tostring(text),TextColor3=Color3.new(1,1,1),TextSize=12,FontFace=mkFont(),
            TextXAlignment=Enum.TextXAlignment.Left,Parent=list},{
            _New("UICorner",{CornerRadius=UDim.new(0,6)}),_New("UIPadding",{PaddingLeft=UDim.new(0,8)})})
        b.MouseEnter:Connect(function() b.BackgroundTransparency=0;b.BackgroundColor3=ac2;b.TextColor3=Color3.new(1,1,1) end)
        b.MouseLeave:Connect(function() b.BackgroundTransparency=1 end)
        b.MouseButton1Click:Connect(function() if cb then cb() end end);return b
    end
    function M:Destroy() frame:Destroy() end;return M
end

-- ── Watermark (NeverLose port) ────────────────────────────────────
function aa:CreateWatermark()
    local gui=aa.ScreenGui; if not gui then return {} end
    local wm=_New("Frame",{BackgroundColor3=Color3.fromHex("#050508"),BackgroundTransparency=0,
        Position=UDim2.fromOffset(8,50),AutomaticSize=Enum.AutomaticSize.XY,ZIndex=9990,Active=true,Parent=gui},{
        _New("UICorner",{CornerRadius=UDim.new(0,8)}),
        _New("UIStroke",{Color=Color3.fromHex("#1a1a2e"),Thickness=1}),
        _New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),
            SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center}),
        _New("UIPadding",{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6)}),
    })
    aa:MakeDraggable(wm,wm)
    local renders={}; local visible=true; local WM={}
    function WM:SetRender(v) visible=v;wm.Visible=v;for _,r in renders do if r then r(v) end end end
    function WM:AddBlock(icon,name)
        local block=_New("Frame",{BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.XY,Parent=wm},{
            _New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),VerticalAlignment=Enum.VerticalAlignment.Center}),
        })
        if icon and icon~="" then
            _New("TextLabel",{BackgroundTransparency=1,Text=icon,TextColor3=(aa.Theme and aa.Theme.Primary) or Color3.fromHex("#7C5CFF"),TextSize=13,FontFace=mkFont(),AutomaticSize=Enum.AutomaticSize.XY,Parent=block})
        end
        local lbl=_New("TextLabel",{BackgroundTransparency=1,Text=name or "",TextColor3=Color3.new(1,1,1),TextSize=12,FontFace=mkFont(),AutomaticSize=Enum.AutomaticSize.XY,Parent=block})
        local sep=_New("Frame",{BackgroundColor3=Color3.fromHex("#2e2e3e"),Size=UDim2.fromOffset(1,14),BackgroundTransparency=0,Parent=wm})
        local IB={}
        function IB:SetVisible(v) block.Visible=v;sep.Visible=v end
        function IB:SetText(t) lbl.Text=t end
        table.insert(renders, function(v) block.Visible=v and block.Visible end)
        return IB
    end
    function WM:Destroy() wm:Destroy() end
    return WM
end

-- ── AddTooltip ────────────────────────────────────────────────────
function aa:AddTooltip(info,_,hover)
    local tip,conn=nil,nil
    if hover then
        hover.MouseEnter:Connect(function()
            tip=_New("TextLabel",{BackgroundColor3=Color3.fromHex("#050508"),BackgroundTransparency=0,
                AutomaticSize=Enum.AutomaticSize.XY,Text=info or "",TextColor3=Color3.new(1,1,1),TextSize=11,
                ZIndex=99999,FontFace=mkFont(),Parent=aa.ScreenGui or game:GetService("CoreGui")},{
                _New("UICorner",{CornerRadius=UDim.new(0,6)}),
                _New("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4)})})
            conn=_UIS.InputChanged:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseMovement and tip then
                    tip.Position=UDim2.fromOffset(inp.Position.X+14,inp.Position.Y+14) end end)
        end)
        hover.MouseLeave:Connect(function() if tip then tip:Destroy();tip=nil end;if conn then conn:Disconnect();conn=nil end end)
    end
    return {Destroy=function() if tip then tip:Destroy() end;if conn then conn:Disconnect() end end}
end

-- ── Apply default theme ───────────────────────────────────────────
aa:SetTheme("Dark")
SyncScheme()

return aa
