--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /
    |__/|__/_/_//_/\_,_/\____/___/

    v1.6.65  |  2026-07-13  |  Roblox UI Library for scripts

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

function m.SetType(u,v)
m.Type=v
local x=GetShape(v)
r.Image=x.Image
r.SliceCenter=x.Rect
m:SetRadius(m.Radius)
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

b.AddSignal(r:GetPropertyChangedSignal"AbsoluteSize",function()
local u=GetShape(m.Type)
if u.AutoChange==false then
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

return d end function a.b()

local b=(cloneref or clonereference or function(b)return b end)

local d=b(game:GetService"ReplicatedStorage":WaitForChild("GetIcons",99999):InvokeServer())

local function parseIconString(e)
if type(e)=="string"then
local f=e:find":"
if f then
local g=e:sub(1,f-1)
local h=e:sub(f+1)
return g,h
end
end
return nil,e
end

function d.AddIcons(e,f)
if type(e)~="string"or type(f)~="table"then
error"AddIcons: packName must be string, iconsData must be table"
return
end

if not d.Icons[e]then
d.Icons[e]={
Icons={},
Spritesheets={}
}
end

for g,h in pairs(f)do
if type(h)=="number"or(type(h)=="string"and h:match"^rbxassetid://")then
local i=h
if type(h)=="number"then
i="rbxassetid://"..tostring(h)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=Vector2.new(0,0),
ImageRectPosition=Vector2.new(0,0),
Parts=nil
}
d.Icons[e].Spritesheets[i]=i

elseif type(h)=="table"then
if h.Image and h.ImageRectSize and h.ImageRectPosition then
local i=h.Image
if type(i)=="number"then
i="rbxassetid://"..tostring(i)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=h.ImageRectSize,
ImageRectPosition=h.ImageRectPosition,
Parts=h.Parts
}

if not d.Icons[e].Spritesheets[i]then
d.Icons[e].Spritesheets[i]=i
end
else
warn("AddIcons: Invalid spritesheet data format for icon '"..g.."'")
end
else
warn("AddIcons: Unsupported data type for icon '"..g.."': "..type(h))
end
end
end

function d.SetIconsType(e)
d.IconsType=e
end

local e
function d.Init(f,g)
d.New=f
d.IconThemeTag=g

e=f
return d
end

function d.Icon(f,g,h)
h=h~=false
local i,j=parseIconString(f)

local l=i or g or d.IconsType
local m=j

local p=d.Icons[l]

if p and p.Icons and p.Icons[m]then
return{
p.Spritesheets[tostring(p.Icons[m].Image)],
p.Icons[m],
}
elseif p and p[m]and string.find(p[m],"rbxassetid://")then
return h and{
p[m],
{ImageRectSize=Vector2.new(0,0),ImageRectPosition=Vector2.new(0,0)}
}or p[m]
end
return nil
end

function d.GetIcon(f,g)
return d.Icon(f,g,false)
end


function d.Icon2(f,g,h)
return d.Icon(f,g,true)
end

function d.Image(f)
local g={
Icon=f.Icon or nil,
Type=f.Type,
Colors=f.Colors or{(d.IconThemeTag or Color3.new(1,1,1)),Color3.new(1,1,1)},
Transparency=f.Transparency or{0,0},
Size=f.Size or UDim2.new(0,24,0,24),

IconFrame=nil,
}

local h={}
local i={}

for j,l in next,g.Colors do
h[j]={
ThemeTag=typeof(l)=="string"and l,
Color=typeof(l)=="Color3"and l,
}
end

for j,l in next,g.Transparency do
i[j]={
ThemeTag=typeof(l)=="string"and l,
Value=typeof(l)=="number"and l,
}
end


local j=d.Icon2(g.Icon,g.Type)
local l=typeof(j)=="string"and string.find(j,'rbxassetid://')

if d.New then
local m=e or d.New



local p=m("ImageLabel",{
Size=g.Size,
BackgroundTransparency=1,
ImageColor3=h[1].Color or nil,
ImageTransparency=i[1].Value or nil,
ThemeTag=h[1].ThemeTag and{
ImageColor3=h[1].ThemeTag,
ImageTransparency=i[1].ThemeTag,
},
Image=l and j or j[1],
ImageRectSize=l and nil or j[2].ImageRectSize,
ImageRectOffset=l and nil or j[2].ImageRectPosition,
})


if not l and j[2].Parts then
for r,u in next,j[2].Parts do
local v=d.Icon(u,g.Type)

m("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=h[1+r].Color or nil,
ImageTransparency=i[1+r].Value or nil,
ThemeTag=h[1+r].ThemeTag and{
ImageColor3=h[1+r].ThemeTag,
ImageTransparency=i[1+r].ThemeTag,
},
Image=v[1],
ImageRectSize=v[2].ImageRectSize,
ImageRectOffset=v[2].ImageRectPosition,
Parent=p,
})
end
end

g.IconFrame=p
else
local m=Instance.new"ImageLabel"
m.Size=g.Size
m.BackgroundTransparency=1
m.ImageColor3=h[1].Color
m.ImageTransparency=i[1].Value or nil
m.Image=l and j or j[1]
m.ImageRectSize=l and nil or j[2].ImageRectSize
m.ImageRectOffset=l and nil or j[2].ImageRectPosition


if not l and j[2].Parts then
for p,r in next,j[2].Parts do
local u=d.Icon(r,g.Type)

local v=Instance.New"ImageLabel"
v.Size=UDim2.new(1,0,1,0)
v.BackgroundTransparency=1
v.ImageColor3=h[1+p].Color
v.ImageTransparency=i[1+p].Value or nil
v.Image=u[1]
v.ImageRectSize=u[2].ImageRectSize
v.ImageRectOffset=u[2].ImageRectPosition
v.Parent=m
end
end

g.IconFrame=m
end


return g
end

return d end function a.c()
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

Notification="Background",
Notification2="White",
Notification2Transparency=0.92,
NotificationTitle="Text",
NotificationTitleTransparency=0,
NotificationContent="Text",
NotificationContentTransparency=0.4,
NotificationDuration="White",
NotificationDurationTransparency=0.95,
NotificationBorder="White",
NotificationBorderTransparency=0.75,

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

local i=a.load'a'local j=

d.Heartbeat

local l="https://article-hub-studio.github.io/WindUI-Skibidi/vendor/icons/Main-v2.lua"

local m
if d:IsStudio()or not writefile then
m=a.load'b'
else
m=loadstring(
game.HttpGet and game:HttpGet(l)or h:GetAsync(l)
)()
end

m.SetIconsType"lucide"

local p

local r
r={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=m,
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

function r.Init(u)
p=u

r.ThemeFallbacks=a.load'c'(r)

r.UIScale=u.UIScale

i:Init(r)
end

function r.AddSignal(u,v)
local x=u:Connect(v)
table.insert(r.Signals,x)
return x
end

function r.DisconnectAll()
for u,v in next,r.Signals do
local x=table.remove(r.Signals,u)
x:Disconnect()
end
end

function r.SafeCallback(u,...)
if not u then
return
end

local v,x=pcall(u,...)
if not v then
if p and p.Window and p.Window.Debug then local
z, A=x:find":%d+: "

warn("[ WindUI: DEBUG Mode ] "..x)

return p:Notify{
Title="DEBUG Mode: Error",
Content=not A and x or x:sub(A+1),
Duration=8,
}
end
end
end

function r.Gradient(u,v)
if p and p.Gradient then
return p:Gradient(u,v)
end

local x={}
local z={}

for A,B in next,u do
local C=tonumber(A)
if C then
C=math.clamp(C/100,0,1)
table.insert(x,ColorSequenceKeypoint.new(C,B.Color))
table.insert(z,NumberSequenceKeypoint.new(C,B.Transparency or 0))
end
end

table.sort(x,function(A,B)
return A.Time<B.Time
end)
table.sort(z,function(A,B)
return A.Time<B.Time
end)

if#x<2 then
error"ColorSequence requires at least 2 keypoints"
end

local A={
Color=ColorSequence.new(x),
Transparency=NumberSequence.new(z),
}

if v then
for B,C in pairs(v)do
A[B]=C
end
end

return A
end

function r.SetTheme(u)
local v=r.Theme
r.Theme=u
r.UpdateTheme(nil,false)

for x,z in next,r.ThemeChangeCallbacks do
r.SafeCallback(z,u,v)
end
end

function r.AddFontObject(u)
table.insert(r.FontObjects,u)
r.UpdateFont(r.Font)
end

function r.UpdateFont(u)
r.Font=u
for v,x in next,r.FontObjects do
x.FontFace=Font.new(u,x.FontFace.Weight,x.FontFace.Style)
end
end

function r.GetThemeProperty(u,v)
local function getValue(x,z)
local A=z[x]

if A==nil then
return nil
end

if typeof(A)=="string"and string.sub(A,1,1)=="#"then
return Color3.fromHex(A)
end

if typeof(A)=="Color3"then
return A
end

if typeof(A)=="number"then
return A
end

if typeof(A)=="table"and A.Color and A.Transparency then
return A
end

if typeof(A)=="function"then
return A(z)
end

return A
end

local x=getValue(u,v)
if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
local z=r.GetThemeProperty(x,v)
if z~=nil then
return z
end
else
return x
end
end

local z=r.ThemeFallbacks[u]
if z~=nil then
if typeof(z)=="string"and string.sub(z,1,1)~="#"then
return r.GetThemeProperty(z,v)
else
return getValue(u,{[u]=z})
end
end

x=getValue(u,r.Themes.Dark)
if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
local A=r.GetThemeProperty(x,r.Themes.Dark)
if A~=nil then
return A
end
else
return x
end
end

if z~=nil then
if typeof(z)=="string"and string.sub(z,1,1)~="#"then
return r.GetThemeProperty(z,r.Themes.Dark)
else
return getValue(u,{[u]=z})
end
end

return nil
end

function r.AddThemeObject(u,v,x)
if r.Objects[u]then
for z,A in pairs(v)do
r.Objects[u].Properties[z]=A
end
else
r.Objects[u]={Object=u,Properties=v}
end

if not x then
r.UpdateTheme(u,false)
end
return u
end

function r.AddLangObject(u)
local v=r.LocalizationObjects[u]
if not v then
return
end

local x=v.Object

r.SetLangForObject(u)

return x
end

function r.UpdateTheme(u,v,x,z,A,B)
local function ApplyTheme(C)
for F,G in pairs(C.Properties or{})do
local H=r.GetThemeProperty(G,r.Theme)
if H~=nil then
if typeof(H)=="Color3"then
local J=C.Object:FindFirstChild"LibraryGradient"
if J then
J:Destroy()
end

if x then
r.Tween(
C.Object,
z or 0.2,
{[F]=H},
A or Enum.EasingStyle.Quint,
B or Enum.EasingDirection.Out
):Play()
elseif v then
r.Tween(C.Object,0.08,{[F]=H}):Play()
else
C.Object[F]=H
end
elseif typeof(H)=="table"and H.Color and H.Transparency then
C.Object[F]=Color3.new(1,1,1)

local J=C.Object:FindFirstChild"LibraryGradient"
if not J then
J=Instance.new"UIGradient"
J.Name="LibraryGradient"
J.Parent=C.Object
end

J.Color=H.Color
J.Transparency=H.Transparency

for L,M in pairs(H)do
if L~="Color"and L~="Transparency"and J[L]~=nil then
J[L]=M
end
end
elseif typeof(H)=="number"then
if x then
r.Tween(
C.Object,
z or 0.2,
{[F]=H},
A or Enum.EasingStyle.Quint,
B or Enum.EasingDirection.Out
):Play()
elseif v then
r.Tween(C.Object,0.08,{[F]=H}):Play()
else
C.Object[F]=H
end
end
else
local J=C.Object:FindFirstChild"LibraryGradient"
if J then
J:Destroy()
end
end
end
end

if u then
local C=r.Objects[u]
if C then
ApplyTheme(C)
end
else
for C,F in pairs(r.Objects)do
ApplyTheme(F)
end
end
end

function r.SetThemeTag(u,v,x,z,A)
r.AddThemeObject(u,v)
r.UpdateTheme(u,false,true,x,z,A)
end

function r.SetLangForObject(u)
if r.Localization and r.Localization.Enabled then
local v=r.LocalizationObjects[u]
if not v then
return
end

local x=v.Object
local z=v.TranslationId

local A=r.Localization.Translations[r.Language]
if A and A[z]then
x.Text=A[z]
else
local B=r.Localization
and r.Localization.Translations
and r.Localization.Translations.en
or nil
if B and B[z]then
x.Text=B[z]
else
x.Text="["..z.."]"
end
end
end
end

function r.ChangeTranslationKey(u,v,x)
if r.Localization and r.Localization.Enabled then
local z=string.match(x,"^"..r.Localization.Prefix.."(.+)")
if z then
for A,B in ipairs(r.LocalizationObjects)do
if B.Object==v then
B.TranslationId=z
r.SetLangForObject(A)
return
end
end

table.insert(r.LocalizationObjects,{
TranslationId=z,
Object=v,
})
r.SetLangForObject(#r.LocalizationObjects)
end
end
end

function r.UpdateLang(u)
if u then
r.Language=u
end

for v=1,#r.LocalizationObjects do
local x=r.LocalizationObjects[v]
if x.Object and x.Object.Parent~=nil then
r.SetLangForObject(v)
else
r.LocalizationObjects[v]=nil
end
end
end

function r.SetLanguage(u)
r.Language=u
r.UpdateLang()
end

function r.Icon(u,v)
return m.Icon2(u,nil,v~=false)
end

function r.AddIcons(u,v)
return m.AddIcons(u,v)
end

function r.New(u,v,x)
local z=Instance.new(u)

for A,B in next,r.DefaultProperties[u]or{}do
z[A]=B
end

for A,B in next,v or{}do
if A~="ThemeTag"then
z[A]=B
end
if r.Localization and r.Localization.Enabled and A=="Text"then
local C=string.match(B,"^"..r.Localization.Prefix.."(.+)")
if C then
local F=#r.LocalizationObjects+1
r.LocalizationObjects[F]={TranslationId=C,Object=z}

r.SetLangForObject(F)
end
end
end

for A,B in next,x or{}do
B.Parent=z
end

if v and v.ThemeTag then
r.AddThemeObject(z,v.ThemeTag)
end
if v and v.FontFace then
r.AddFontObject(z)
end
return z
end

function r.Tween(u,v,x,...)
return f:Create(u,TweenInfo.new(v,...),x)
end

function r.ClampTransparency(u,v)
local x=tonumber(u)
if x==nil then
return v
end

return math.clamp(x,0,1)
end

function r.ToUDimRadius(u,v)
if typeof(u)=="UDim"then
return u
end

if typeof(v)=="UDim"then
return v
end

return UDim.new(0,tonumber(u)or tonumber(v)or 0)
end

function r.ApplyCornerRadii(u,v,x)
if typeof(u)~="Instance"or not u:IsA"UICorner"then
return u
end

local z=r.ToUDimRadius(v,u.CornerRadius)
local A=UDim.new(0,0)
local B=x or{
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}

u.CornerRadius=z

pcall(function()
u.TopLeftRadius=B.TopLeft~=false and z or A
u.TopRightRadius=B.TopRight~=false and z or A
u.BottomRightRadius=B.BottomRight~=false and z or A
u.BottomLeftRadius=B.BottomLeft~=false and z or A
end)

return u
end

function r.DefaultCornerMap()
return{
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}
end

function r.GetLinkedCornerDirection(u,v)
local x=v or(u and u.__type)

if x=="Group"then
return true
end

if x=="HStack"then
if u and u.IsStacked==true then
return false
end

local z=u and u.ElementFrame
local A=z and z:FindFirstChildWhichIsA"UIListLayout"
if A then
return A.FillDirection==Enum.FillDirection.Horizontal
end

return true
end

return false
end

function r.GetLinkedCornerShape(u,v,x,z)
return r:GetElementPosition(u,v,r.GetLinkedCornerDirection(x,z))
end








































































function r.NewRoundFrame(u,v,x,z,A,B)
return i:New(u,v,x,z,A,nil)
end

local u=r.New local v=
r.Tween

function r.SetDraggable(x)
r.CanDraggable=x
end

function r.Drag(x,z,A)
local B=p.GenerateGUID()

local C
local F=false
local G,H
local J

local L={
CanDraggable=true,
}

if not z or typeof(z)~="table"then
z={x}
end

local function update(M)
if not F or not L.CanDraggable then
return
end

local N=M.Position-G
r.Tween(x,0.02,{
Position=UDim2.new(
H.X.Scale,
H.X.Offset+N.X,
H.Y.Scale,
H.Y.Offset+N.Y
),
}):Play()
end

for M,N in pairs(z)do
N.InputBegan:Connect(function(O)
if not L.CanDraggable or F then
return
end

if
O.UserInputType==Enum.UserInputType.MouseButton1
or O.UserInputType==Enum.UserInputType.Touch
then
if p and p.CurrentInput and p.CurrentInput~=B then
return
end

p.CurrentInput=B

F=true
J=O
C=N
G=O.Position
H=x.Position

if A and typeof(A)=="function"then
A(true,C)
end
end
end)
end

e.InputChanged:Connect(function(M)
if not F then
return
end
if p.CurrentInput and p.CurrentInput~=B then
return
end

if J.UserInputType==Enum.UserInputType.MouseButton1 then
if M.UserInputType==Enum.UserInputType.MouseMovement then
update(M)
end
elseif J.UserInputType==Enum.UserInputType.Touch then
if M==J then
update(M)
end
end
end)

e.InputEnded:Connect(function(M)
if not F or p.CurrentInput~=B then
return
end

if
M==J
or(
J.UserInputType==Enum.UserInputType.MouseButton1
and M.UserInputType==Enum.UserInputType.MouseButton1
)
then
p.CurrentInput=nil
F=false
J=nil
C=nil

if A and typeof(A)=="function"then
A(false,nil)
end
end
end)

function L.Set(M,N)
L.CanDraggable=N
end

return L
end

m.Init(u,"Icon")

function r.SanitizeFilename(x)
local z=x:match"([^/]+)$"or x

z=z:gsub("%.[^%.]+$","")

z=z:gsub("[^%w%-_]","_")

if#z>50 then
z=z:sub(1,50)
end

return z
end

function r.Image(x,z,A,B,C,F,G,H)
B=B or"Temp"
z=r.SanitizeFilename(z)

local J=u("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
u("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(r.Icon(x)or G)and{
ImageColor3=F and(H or"Icon")or nil,
}or nil,
},{
u("UICorner",{
CornerRadius=UDim.new(0,A),
}),
}),
})
if r.Icon(x)then
J.ImageLabel:Destroy()

local L=m.Image{
Icon=x,
Size=UDim2.new(1,0,1,0),
Colors={
(F and(H or"Icon")or false),
"Button",
},
}.IconFrame
L.Parent=J
elseif string.find(x,"http")and not string.find(x,"roblox.com")then
local L="WindUI/"..B.."/assets/."..C.."-"..z..".png"
local M,N=pcall(function()
task.spawn(function()
local M=r.Request
and r.Request{
Url=x,
Method="GET",
}.Body
or{}

if not d:IsStudio()and writefile then
writefile(L,M)
end


local N,O=pcall(getcustomasset,L)
if N then
J.ImageLabel.Image=O
else
warn(
string.format(
"[ WindUI.Creator ] Failed to load custom asset '%s': %s",
L,
tostring(O)
)
)
J:Destroy()

return
end
end)
end)
if not M then
warn(
"[ WindUI.Creator ]  '"..identifyexecutor()
or"Studio".."' doesnt support the URL Images. Error: "..N
)

J:Destroy()
end
elseif x==""then
J.Visible=false
else
J.ImageLabel.Image=x
end

return J
end

function r.Color3ToHSB(x)
local z,A,B=x.R,x.G,x.B
local C=math.max(z,A,B)
local F=math.min(z,A,B)
local G=C-F

local H=0
if G~=0 then
if C==z then
H=(A-B)/G%6
elseif C==A then
H=(B-z)/G+2
else
H=(z-A)/G+4
end
H=H*60
else
H=0
end

local J=(C==0)and 0 or(G/C)
local L=C

return{
h=math.floor(H+0.5),
s=J,
b=L,
}
end

function r.GetPerceivedBrightness(x)
local z=x.R
local A=x.G
local B=x.B
return 0.299*z+0.587*A+0.114*B
end

function r.GetTextColorForHSB(x,z)
local A=r.Color3ToHSB(x)local
B, C, F=A.h, A.s, A.b
if r.GetPerceivedBrightness(x)>(z or 0.5)then
return Color3.fromHSV(B/360,0,0.05)
else
return Color3.fromHSV(B/360,0,0.98)
end
end

function r.GetAverageColor(x)
local z,A,B=0,0,0
local C=x.Color.Keypoints
for F,G in ipairs(C)do

z=z+G.Value.R
A=A+G.Value.G
B=B+G.Value.B
end
local F=#C
return Color3.new(z/F,A/F,B/F)
end

function r.GenerateUniqueID(x)
return h:GenerateGUID(false)
end

function r.OnThemeChange(x,z)
if typeof(z)~="function"then
return
end

local A=h:GenerateGUID(false)
r.ThemeChangeCallbacks[A]=z

return{
Disconnect=function()
r.ThemeChangeCallbacks[A]=nil
end,
}
end

function r.AddColor(x,z,A,B)
B=math.clamp(B or 1,0,1)
if typeof(A)=="string"then
A=Color3.fromHex(A)
end

return function(C)
local F
if typeof(z)=="string"and string.sub(z,1,1)~="#"then
F=r.GetThemeProperty(z,C)
elseif typeof(z)=="string"then
F=Color3.fromHex(z)
else
F=z
end

if not F or typeof(F)~="Color3"then
return nil
end

return Color3.new(
math.clamp(F.R+A.R*B,0,1),
math.clamp(F.G+A.G*B,0,1),
math.clamp(F.B+A.B*B,0,1)
)
end
end

function r.GetElementPosition(x,z,A,B)
if type(A)~="number"or A~=math.floor(A)then
return"Squircle",r.DefaultCornerMap()
end

local C=0
for F in next,z or{}do
if type(F)=="number"and F>C then
C=F
end
end

if C==0 or A<1 or A>C then
return"Squircle",r.DefaultCornerMap()
end

local function isDelimiter(F)
if F==nil then
return true
end
local G=F.__type
return G=="Divider"or G=="Space"or G=="Section"
end

if isDelimiter(z[A])then
return"Squircle",r.DefaultCornerMap()
end

local function calculate(F,G)
if G==1 then
return"Squircle",{
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}
end
if F==1 then
if B then
return"Squircle-TL-BL",{
TopLeft=true,
TopRight=false,
BottomLeft=true,
BottomRight=false,
}
end

return"Squircle-TL-TR",{
TopLeft=true,
TopRight=true,
BottomLeft=false,
BottomRight=false,
}
end
if F==G then
if B then
return"Squircle-TR-BR",{
TopLeft=false,
TopRight=true,
BottomLeft=false,
BottomRight=true,
}
end

return"Squircle-BL-BR",{
TopLeft=false,
TopRight=false,
BottomLeft=true,
BottomRight=true,
}
end
return"Square",{
TopLeft=false,
TopRight=false,
BottomLeft=false,
BottomRight=false,
}
end

local F={}
local function flush()
if#F==0 then
return nil
end

for G,H in ipairs(F)do
if H==A then
return calculate(G,#F)
end
end

table.clear(F)
return nil
end

for G=1,C do
local H=z[G]
if isDelimiter(H)then
local J,L=flush()
if J then
return J,L
end
else
table.insert(F,G)
end
end

local G,H=flush()
if G then
return G,H
end

return"Squircle",r.DefaultCornerMap()
end

return r end function a.e()

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
for l,m in next,i or{}do
h[l]=m
end
end

local function SplitReducedProperties(h)
local i={}
local l={}
local m=false
local p=false

for r,u in next,h or{}do
if g[r]then
i[r]=u
m=true
else
l[r]=u
p=true
end
end

return m and i or nil,p and l or nil
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

local l=e[h]
if not l then
return
end

i=i or"Default"
local m=l[i]
if m then
m:Cancel()
l[i]=nil
end
end

function d.Tween(h,i,l,m,p,r)
if not h or typeof(h)~="Instance"then
return f
end

local u=d.GetDuration(i)
r=r or"Default"

local v
local x=l
if d.Reduced then
v,x=SplitReducedProperties(l)
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
ApplyProperties(h,x or l)
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

function d.Play(h,i,l,m,p,r)
local u=d.Tween(h,i,l,m,p,r)
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

function d.Press(h,i,l)
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
{Scale=i and(l or d.PresetPressAmount[d.Preset]or 0.97)or 1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
end

function d.AttachPress(h,i,l)
if not h or not i then
return nil
end

l=l or{}
local m=l.Amount or 0.97
local p=l.Enabled

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

local g={
Size=UDim2.new(0,300,1,-156),
SizeLower=UDim2.new(0,300,1,-56),
UICorner=18,
UIPadding=14,

Holder=nil,
NotificationIndex=0,
Notifications={},
}

function g.Init(h)
local i={
Lower=false,
}

function i.SetLower(l)
i.Lower=l
i.Frame.Size=l and g.SizeLower or g.Size
end

i.Frame=e("Frame",{
Position=UDim2.new(1,-29,0,56),
AnchorPoint=Vector2.new(1,0),
Size=g.Size,
Parent=h,
BackgroundTransparency=1,




},{
e("UIListLayout",{
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
VerticalAlignment="Bottom",
Padding=UDim.new(0,8),
}),
e("UIPadding",{
PaddingBottom=UDim.new(0,29),
}),
})
return i
end

function g.New(h)
local i={
Title=h.Title or"Notification",
Content=h.Content or nil,
Icon=h.Icon or nil,
IconThemed=h.IconThemed,
Background=h.Background,
BackgroundImageTransparency=h.BackgroundImageTransparency,
Duration=h.Duration or 5,
Buttons=h.Buttons or{},
CanClose=h.CanClose~=false,
UIElements={},
Closed=false,
}



g.NotificationIndex=g.NotificationIndex+1
g.Notifications[g.NotificationIndex]=i









local l

if i.Icon then





















l=b.Image(
i.Icon,
i.Title..":"..i.Icon,
0,
h.Window,
"Notification",
i.IconThemed
)
l.Size=UDim2.new(0,26,0,26)
l.Position=UDim2.new(0,g.UIPadding,0,g.UIPadding)

end

local m
if i.CanClose then
m=e("ImageButton",{
Image=b.Icon"x"[1],
ImageRectSize=b.Icon"x"[2].ImageRectSize,
ImageRectOffset=b.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(1,-g.UIPadding,0,g.UIPadding),
AnchorPoint=Vector2.new(1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.4,
},{
e("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
}),
})
end

local p=b.NewRoundFrame(g.UICorner,"Squircle",{
Size=UDim2.new(0,0,1,0),
ThemeTag={
ImageTransparency="NotificationDurationTransparency",
ImageColor3="NotificationDuration",
},

})

local r=e("Frame",{
Size=UDim2.new(1,i.Icon and-28-g.UIPadding or 0,1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
e("UIPadding",{
PaddingTop=UDim.new(0,g.UIPadding),
PaddingLeft=UDim.new(0,g.UIPadding),
PaddingRight=UDim.new(0,g.UIPadding),
PaddingBottom=UDim.new(0,g.UIPadding),
}),
e("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,-30-g.UIPadding,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=18,
ThemeTag={
TextColor3="NotificationTitle",
TextTransparency="NotificationTitleTransparency",
},
Text=i.Title,
FontFace=Font.new(b.Font,Enum.FontWeight.SemiBold),
}),
e("UIListLayout",{
Padding=UDim.new(0,g.UIPadding/3),
}),
})

if i.Content then
e("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,

TextSize=15,
ThemeTag={
TextColor3="NotificationContent",
TextTransparency="NotificationContentTransparency",
},
Text=i.Content,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium),
Parent=r,
})
end

local u=b.NewRoundFrame(g.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(2,0,1,0),
AnchorPoint=Vector2.new(0,1),
AutomaticSize="Y",
ImageTransparency=0.05,
ThemeTag={
ImageColor3="Notification",
},

},{
b.NewRoundFrame(g.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Notification2",
ImageTransparency="Notification2Transparency",
},
}),
e("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="DurationFrame",
},{






e("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ClipsDescendants=true,
},{
p,
}),




}),
e("ImageLabel",{
Name="Background",
Image=i.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=i.BackgroundImageTransparency,

},{
e("UICorner",{
CornerRadius=UDim.new(0,g.UICorner),
}),
}),

r,
l,
m,
})

local v=e("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=h.Holder,
},{
u,
})

function i.Close(x)
if not i.Closed then
i.Closed=true
d.Play(
v,
"NotificationClose",
{Size=UDim2.new(1,0,0,-8)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Close"
)
d.Play(
u,
"NotificationClose",
{Position=UDim2.new(2,0,1,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Close"
)
task.wait(d.GetDuration"NotificationClose"+0.03)
v:Destroy()
end
end

task.spawn(function()
task.wait()
d.Play(
v,
"Notification",
{Size=UDim2.new(1,0,0,u.AbsoluteSize.Y)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Open"
)
d.Play(
u,
"Notification",
{Position=UDim2.new(0,0,1,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Open"
)
if i.Duration then
p.Size=UDim2.new(0,u.DurationFrame.AbsoluteSize.X,1,0)
f(
u.DurationFrame.Frame,
i.Duration,
{Size=UDim2.new(0,0,1,0)},
Enum.EasingStyle.Linear,
Enum.EasingDirection.InOut
):Play()
task.wait(i.Duration)
i:Close()
end
end)

if m then
b.AddSignal(m.TextButton.MouseButton1Click,function()
i:Close()
end)
end


return i
end

return g end function a.h()












local b=4294967296;local d=b-1;local function c(e,f)local g,h=0,1;while e~=0 or f~=0 do local i,l=e%2,f%2;local m=(i+l)%2;g=g+m*h;e=math.floor(e/2)f=math.floor(f/2)h=h*2 end;return g%b end;local function k(e,f,g,...)local h;if f then e=e%b;f=f%b;h=c(e,f)if g then h=k(h,g,...)end;return h elseif e then return e%b else return 0 end end;local function n(e,f,g,...)local h;if f then e=e%b;f=f%b;h=(e+f-c(e,f))/2;if g then h=n(h,g,...)end;return h elseif e then return e%b else return d end end;local function o(e)return d-e end;local function q(e,f)if f<0 then return lshift(e,-f)end;return math.floor(e%4294967296/2^f)end;local function s(e,f)if f>31 or f<-31 then return 0 end;return q(e%b,f)end;local function lshift(e,f)if f<0 then return s(e,-f)end;return e*2^f%4294967296 end;local function t(e,f)e=e%b;f=f%32;local g=n(e,2^f-1)return s(e,f)+lshift(g,32-f)end;local e={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(f)return string.gsub(f,".",function(g)return string.format("%02x",string.byte(g))end)end;local function y(f,g)local h=""for i=1,g do local l=f%256;h=string.char(l)..h;f=(f-l)/256 end;return h end;local function D(f,g)local h=0;for i=g,g+3 do h=h*256+string.byte(f,i)end;return h end;local function E(f,g)local h=64-(g+9)%64;g=y(8*g,8)f=f.."\128"..string.rep("\0",h)..g;assert(#f%64==0)return f end;local function I(f)f[1]=0x6a09e667;f[2]=0xbb67ae85;f[3]=0x3c6ef372;f[4]=0xa54ff53a;f[5]=0x510e527f;f[6]=0x9b05688c;f[7]=0x1f83d9ab;f[8]=0x5be0cd19;return f end;local function K(f,g,h)local i={}for l=1,16 do i[l]=D(f,g+(l-1)*4)end;for l=17,64 do local m=i[l-15]local p=k(t(m,7),t(m,18),s(m,3))m=i[l-2]i[l]=(i[l-16]+p+i[l-7]+k(t(m,17),t(m,19),s(m,10)))%b end;local l,m,p,r,u,v,x,z=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]for A=1,64 do local B=k(t(l,2),t(l,13),t(l,22))local C=k(n(l,m),n(l,p),n(m,p))local F=(B+C)%b;local G=k(t(u,6),t(u,11),t(u,25))local H=k(n(u,v),n(o(u),x))local J=(z+G+H+e[A]+i[A])%b;z=x;x=v;v=u;u=(r+J)%b;r=p;p=m;m=l;l=(J+F)%b end;h[1]=(h[1]+l)%b;h[2]=(h[2]+m)%b;h[3]=(h[3]+p)%b;h[4]=(h[4]+r)%b;h[5]=(h[5]+u)%b;h[6]=(h[6]+v)%b;h[7]=(h[7]+x)%b;h[8]=(h[8]+z)%b end;local function Z(f)f=E(f,#f)local g=I{}for h=1,#f,64 do K(f,h,g)end;return w(y(g[1],4)..y(g[2],4)..y(g[3],4)..y(g[4],4)..y(g[5],4)..y(g[6],4)..y(g[7],4)..y(g[8],4))end;local f;local g={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local h={["/"]="/"}for i,l in pairs(g)do h[l]=i end;local i=function(i)return"\\"..(g[i]or string.format("u%04x",i:byte()))end;local l=function(l)return"null"end;local m=function(m,p)local r={}p=p or{}if p[m]then error"circular reference"end;p[m]=true;if rawget(m,1)~=nil or next(m)==nil then local u=0;for v in pairs(m)do if type(v)~="number"then error"invalid table: mixed or invalid key types"end;u=u+1 end;if u~=#m then error"invalid table: sparse array"end;for v,x in ipairs(m)do table.insert(r,f(x,p))end;p[m]=nil;return"["..table.concat(r,",").."]"else for u,v in pairs(m)do if type(u)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(r,f(u,p)..":"..f(v,p))end;p[m]=nil;return"{"..table.concat(r,",").."}"end end;local p=function(p)return'"'..p:gsub('[%z\1-\31\\"]',i)..'"'end;local r=function(r)if r~=r or r<=-math.huge or r>=math.huge then error("unexpected number value '"..tostring(r).."'")end;return string.format("%.14g",r)end;local u={["nil"]=l,table=m,string=p,number=r,boolean=tostring}f=function(v,x)local z=type(v)local A=u[z]if A then return A(v,x)end;error("unexpected type '"..z.."'")end;local v=function(v)return f(v)end;local x;local z=function(...)local z={}for A=1,select("#",...)do z[select(A,...)]=true end;return z end;local A=z(" ","\t","\r","\n")local B=z(" ","\t","\r","\n","]","}",",")local C=z("\\","/",'"',"b","f","n","r","t","u")local F=z("true","false","null")local G={["true"]=true,["false"]=false,null=nil}local H=function(H,J,L,M)for N=J,#H do if L[H:sub(N,N)]~=M then return N end end;return#H+1 end;local J=function(J,L,M)local N=1;local O=1;for P=1,L-1 do O=O+1;if J:sub(P,P)=="\n"then N=N+1;O=1 end end;error(string.format("%s at line %d col %d",M,N,O))end;local L=function(L)local M=math.floor;if L<=0x7f then return string.char(L)elseif L<=0x7ff then return string.char(M(L/64)+192,L%64+128)elseif L<=0xffff then return string.char(M(L/4096)+224,M(L%4096/64)+128,L%64+128)elseif L<=0x10ffff then return string.char(M(L/262144)+240,M(L%262144/4096)+128,M(L%4096/64)+128,L%64+128)end;error(string.format("invalid unicode codepoint '%x'",L))end;local M=function(M)local N=tonumber(M:sub(1,4),16)local O=tonumber(M:sub(7,10),16)if O then return L((N-0xd800)*0x400+O-0xdc00+0x10000)else return L(N)end end;local N=function(N,O)local P=""local Q=O+1;local R=Q;while Q<=#N do local S=N:byte(Q)if S<32 then J(N,Q,"control character in string")elseif S==92 then P=P..N:sub(R,Q-1)Q=Q+1;local T=N:sub(Q,Q)if T=="u"then local U=N:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",Q+1)or N:match("^%x%x%x%x",Q+1)or J(N,Q-1,"invalid unicode escape in string")P=P..M(U)Q=Q+#U else if not C[T]then J(N,Q-1,"invalid escape char '"..T.."' in string")end;P=P..h[T]end;R=Q+1 elseif S==34 then P=P..N:sub(R,Q-1)return P,Q+1 end;Q=Q+1 end;J(N,O,"expected closing quote for string")end;local O=function(O,P)local Q=H(O,P,B)local R=O:sub(P,Q-1)local S=tonumber(R)if not S then J(O,P,"invalid number '"..R.."'")end;return S,Q end;local P=function(P,Q)local R=H(P,Q,B)local S=P:sub(Q,R-1)if not F[S]then J(P,Q,"invalid literal '"..S.."'")end;return G[S],R end;local Q=function(Q,R)local S={}local T=1;R=R+1;while 1 do local U;R=H(Q,R,A,true)if Q:sub(R,R)=="]"then R=R+1;break end;U,R=x(Q,R)S[T]=U;T=T+1;R=H(Q,R,A,true)local V=Q:sub(R,R)R=R+1;if V=="]"then break end;if V~=","then J(Q,R,"expected ']' or ','")end end;return S,R end;local R=function(R,S)local T={}S=S+1;while 1 do local U,V;S=H(R,S,A,true)if R:sub(S,S)=="}"then S=S+1;break end;if R:sub(S,S)~='"'then J(R,S,"expected string for key")end;U,S=x(R,S)S=H(R,S,A,true)if R:sub(S,S)~=":"then J(R,S,"expected ':' after key")end;S=H(R,S+1,A,true)V,S=x(R,S)T[U]=V;S=H(R,S,A,true)local W=R:sub(S,S)S=S+1;if W=="}"then break end;if W~=","then J(R,S,"expected '}' or ','")end end;return T,S end;local S={['"']=N,["0"]=O,["1"]=O,["2"]=O,["3"]=O,["4"]=O,["5"]=O,["6"]=O,["7"]=O,["8"]=O,["9"]=O,["-"]=O,t=P,f=P,n=P,["["]=Q,["{"]=R}x=function(T,U)local V=T:sub(U,U)local W=S[V]if W then return W(T,U)end;J(T,U,"unexpected character '"..V.."'")end;local T=function(T)if type(T)~="string"then error("expected argument of type string, got "..type(T))end;local U,V=x(T,H(T,1,A,true))V=H(T,V,A,true)if V<=#T then J(T,V,"trailing garbage")end;return U end;
local U,V,W=v,T,Z;





local X={}

local Y=(cloneref or clonereference or function(Y)return Y end)


function X.New(_,aa)

local ab=_;
local ac=aa;
local ad=true;


local ae=function(ae)end;


repeat task.wait(1)until game:IsLoaded();


local af=false;
local ag,ah,ai,aj,ak,al,am,an,ao=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return Y(game:GetService"Players").LocalPlayer.UserId end
local ap,aq="",0;


local ar="https://api.platoboost.app";
local as=ah{
Url=ar.."/public/connectivity",
Method="GET"
};
if as.StatusCode~=200 and as.StatusCode~=429 then
ar="https://api.platoboost.net";
end


function cacheLink()
if aq+(600)<al()then
local at=ah{
Url=ar.."/public/start",
Method="POST",
Body=U{
service=ab,
identifier=W(ao())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if at.StatusCode==200 then
local au=V(at.Body);

if au.success==true then
ap=au.data.url;
aq=al();
return true,ap
else
ae(au.message);
return false,au.message
end
elseif at.StatusCode==429 then
local au="you are being rate limited, please wait 20 seconds and try again.";
ae(au);
return false,au
end

local au="Failed to cache link.";
ae(au);
return false,au
else
return true,ap
end
end

cacheLink();


local at=function()
local at=""
for au=1,16 do
at=at..ai(an(am()*(26))+97)
end
return at
end


for au=1,5 do
local av=at();
task.wait(0.2)
if at()==av then
local aw="platoboost nonce error.";
ae(aw);
error(aw);
end
end


local au=function()
local au,av=cacheLink();

if au then
ag(av);
end
end


local av=function(av)
local aw=at();
local ax=ar.."/public/redeem/"..aj(ab);

local ay={
identifier=W(ao()),
key=av
}

if ad then
ay.nonce=aw;
end

local az=ah{
Url=ax,
Method="POST",
Body=U(ay),
Headers={
["Content-Type"]="application/json"
}
};

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..aw.."-"..ac)then
return true
else
ae"failed to verify integrity.";
return false
end
else
return true
end
else
ae"key is invalid.";
return false
end
else
if ak(aA.message,1,27)=="unique constraint violation"then
ae"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
ae(aA.message);
return false
end
end
elseif az.StatusCode==429 then
ae"you are being rate limited, please wait 20 seconds and try again.";
return false
else
ae"server returned an invalid status code, please try again later.";
return false
end
end


local aw=function(aw)
if af==true then
return false,("A request is already being sent, please slow down.")
else
af=true;
end

local ax=at();
local ay=ar.."/public/whitelist/"..aj(ab).."?identifier="..W(ao()).."&key="..aw;

if ad then
ay=ay.."&nonce="..ax;
end

local az=ah{
Url=ay,
Method="GET",
};

af=false;

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..ax.."-"..ac)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if ak(aw,1,4)=="KEY_"then
return true,av(aw)
else
return false,("Key is invalid.")
end
end
else
return false,(aA.message)
end
elseif az.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local ax=function(ax)
local ay=at();
local az=ar.."/public/flag/"..aj(ab).."?name="..ax;

if ad then
az=az.."&nonce="..ay;
end

local aA=ah{
Url=az,
Method="GET",
};

if aA.StatusCode==200 then
local aB=V(aA.Body);

if aB.success==true then
if ad then
if aB.data.hash==W(aj(aB.data.value).."-"..ay.."-"..ac)then
return aB.data.value
else
ae"failed to verify integrity.";
return nil
end
else
return aB.data.value
end
else
ae(aB.message);
return nil
end
else
return nil
end
end


return{
Verify=aw,
GetFlag=ax,
Copy=au,
}
end


return X end function a.i()






local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ab=aa(game:GetService"HttpService")
local ac={}

function ac.New(ad)
local ae=gethwid or function()
return aa(game:GetService"Players").LocalPlayer.UserId
end
local af,ag=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ah)
local ai="https://api.pandauth.com/api/v1/keys/validate"

local aj={
ServiceID=ad,
HWID=tostring(ae()),
Key=tostring(ah),
}

local ak=ab:JSONEncode(aj)
local al,am=pcall(function()
return af{
Url=ai,
Method="POST",
Headers={
["User-Agent"]="Roblox/Exploit",
["Content-Type"]="application/json",
},
Body=ak,
}
end)

if al and am then
if am.Success then
local an,ao=pcall(function()
return ab:JSONDecode(am.Body)
end)

if an and ao then
if ao.Authenticated_Status and ao.Authenticated_Status=="Success"then
return true,"Authenticated"
else
local ap=ao.Note or"Unknown reason"
return false,"Authentication failed: "..ap
end
else
return false,"JSON decode error"
end
else
warn(
" HTTP request was not successful. Code: "
..tostring(am.StatusCode)
.." Message: "
..am.StatusMessage
)
return false,"HTTP request failed: "..am.StatusMessage
end
else
return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://new.pandadevelopment.net/getkey/"..tostring(ad).."?hwid="..tostring(ae())
end

function CopyLink()
return ag(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink,
}
end

return ac end function a.j()







local aa={}

function aa.New(ab,ac)
local ad="https://sdkapi-public.luarmor.net/library.lua"

local ae=loadstring(game.HttpGet and game:HttpGet(ad)or HttpService:GetAsync(ad))()
local af=setclipboard or toclipboard

ae.script_id=ab

function ValidateKey(ag)
local ah=ae.check_key(ag)


if ah.code=="KEY_VALID"then
return true,"Whitelisted!"
elseif ah.code=="KEY_HWID_LOCKED"then
return false,"Key linked to a different HWID. Please reset it using our bot"
elseif ah.code=="KEY_INCORRECT"then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ah.message.." Code: "..ah.code
end
end

function CopyLink()
af(tostring(ac))
end

return{
Verify=ValidateKey,
Copy=CopyLink,
}
end

return aa end function a.k()









local aa={}

function aa.New(ab,ac,ad)
JunkieProtected.API_KEY=ac
JunkieProtected.PROVIDER=ad
JunkieProtected.SERVICE_ID=ab

local function ValidateKey(ae)
if not ae or ae==""then
print"No key provided!"

return false,"No key provided. Please get a key."
end

local af=JunkieProtected.IsKeylessMode()
if af and af.keyless_mode then
print"Keyless mode enabled. Starting script..."
return true,"Keyless mode enabled. Starting script..."
end

local ag=JunkieProtected.ValidateKey{Key=ae}
if ag=="valid"then
print"Key is valid! Starting script..."
load()
if _G.JD_IsPremium then
print"Premium user detected!"
else
print"Standard user"
end

return true,"Key is valid!"
else
local ah=JunkieProtected.GetKeyLink()
print"Invalid key!"

return false,"Invalid key. Get one from:"..ah
end
end

local function copyLink()
local ae=JunkieProtected.GetKeyLink()

if setclipboard then
setclipboard(ae)
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
        "docs:start": "npm --prefix website run start"
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
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Primary"
local am=al or(not ak and 10 or 999)
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="White"and 0.4 or 0,
ThemeTag={
ImageColor3=ah~="White"and"Icon"or nil,
},
})
end

local ao=ac("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=ai,
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3=ah~="White"and"Button"or nil,
},
ImageColor3=ah=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ah=="Primary"and 0 or ah=="White"and 0 or 0.9,
}),

ab.NewRoundFrame(am,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ah=="Secondary"and 0.95 or 1,
}),

ab.NewRoundFrame(am,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not ak,
}),

ab.NewRoundFrame(am,"SquircleGlass",{
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

ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ah~="White"and"Text"or nil,
},
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1,
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
an,
ac("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ae or"Button",
ThemeTag={
TextColor3=(ah~="Primary"and ah~="White")and"Text",
},
TextColor3=ah=="Primary"and Color3.new(1,1,1)
or ah=="White"and Color3.new(0,0,0)
or nil,
AutomaticSize="XY",
TextSize=18,
}),
}),
})

ab.AddSignal(ao.MouseEnter,function()
ad(ao.Frame,0.047,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(ao.MouseLeave,function()
ad(ao.Frame,0.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(ao.MouseButton1Click,function()
if aj then
aj:Close()()
end
if ag then
ab.SafeCallback(ag)
end
end)

return ao
end

return aa end function a.o()

local aa={}

local ab=a.load'd'
local ac=a.load'e'
local ad=ab.New

function aa.New(ae,af,ag,ah,ai,aj,ak,al,am)
ah=ah or"Input"
local an=ak or 10
local ao
if af and af~=""then
ao=ad("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
})
end

local ap=ah=="Textarea"

local aq=ad("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,ao and-29 or 0,1,0),
PlaceholderText=ae,
ClearTextOnFocus=al or false,
ClipsDescendants=true,
TextWrapped=ap,
MultiLine=ap,
TextXAlignment="Left",
TextYAlignment=ah~="Textarea"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local ar=ab.NewRoundFrame(an,"Squircle",{
ThemeTag={
ImageColor3="Placeholder",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.85,
})
local as=not am and ab.NewRoundFrame(an-1,"SquircleGlass",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.8,
})or nil
local at=ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ad("UIPadding",{
PaddingTop=UDim.new(0,ah~="Textarea"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ah~="Textarea"and 0 or 12),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ah~="Textarea"and"Center"or"Top",
HorizontalAlignment="Left",
}),
ao,
aq,
})

local au=ad("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
},{
ad("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ar,
as,
at,
}),
})










if aj then
ab.AddSignal(aq:GetPropertyChangedSignal"Text",function()
if ai then
ab.SafeCallback(ai,aq.Text)
end
end)
else
ab.AddSignal(aq.FocusLost,function()
if ai then
ab.SafeCallback(ai,aq.Text)
end
end)
end

ab.AddSignal(aq.Focused,function()
ac.Play(ar,"Focus",{ImageTransparency=0.78},nil,nil,"Focus")
if as then
ac.Play(as,"Focus",{ImageTransparency=0.65},nil,nil,"Focus")
end
end)
ab.AddSignal(aq.FocusLost,function()
ac.Play(ar,"Focus",{ImageTransparency=0.85},nil,nil,"Focus")
if as then
ac.Play(as,"Focus",{ImageTransparency=0.8},nil,nil,"Focus")
end
end)

return au
end

return aa end function a.p()

local aa=a.load'd'
local ab=aa.New
local ac=aa.Tween




local ad={
Holder=nil,

Parent=nil,
}

function ad.Create(ae,af,ag,ah,ai)
local aj={
UICorner=28,
UIPadding=12,

Window=ag,
WindUI=ah,

UIElements={},
}

if ae then
aj.UIPadding=0
end
if ae then
aj.UICorner=26
end

af=af or"Dialog"

if not ae then
aj.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=ad.Parent
or(ag and ag.UIElements and ag.UIElements.Main and ag.UIElements.Main.Main),
},{
ab("UICorner",{
CornerRadius=UDim.new(0,ag.UICorner),
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

aj.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=af.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,aj.UIPadding),
PaddingLeft=UDim.new(0,aj.UIPadding),
PaddingRight=UDim.new(0,aj.UIPadding),
PaddingBottom=UDim.new(0,aj.UIPadding),
}),
})

aj.UIElements.MainContainer=aa.NewRoundFrame(aj.UICorner,"Squircle",{
Visible=false,

ImageTransparency=ae and 0.15 or 0,
Parent=ai or aj.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=af.."Background",
ImageTransparency=af.."BackgroundTransparency",
},
ZIndex=9999,
},{






aj.UIElements.Main,




















})

function aj.Open(ak)
if not ae then
aj.UIElements.FullScreen.Visible=true
aj.UIElements.FullScreen.Active=true
end

task.spawn(function()
aj.UIElements.MainContainer.Visible=true

if not ae then
ac(aj.UIElements.FullScreen,0.1,{BackgroundTransparency=0.65}):Play()
end
ac(aj.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
aj.UIElements.Main.Visible=true
end)
end)
end
function aj.Close(ak)
if not ae then
ac(aj.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
aj.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(0.1)
aj.UIElements.FullScreen.Visible=false
end)
end
aj.UIElements.Main.Visible=false

ac(aj.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(0.1)
if not ae then
aj.UIElements.FullScreen:Destroy()
else
aj.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return aj
end

return ad end function a.q()

local aa={}

local ab=a.load'd'
local ac=a.load'e'
local ad=ab.New
local ae=game:GetService"Workspace"

local af=a.load'n'.New
local ag=a.load'o'.New

local function GetViewportSize()
local ah=ae.CurrentCamera
return ah and ah.ViewportSize or Vector2.new(1280,720)
end

function aa.new(ah,ai,aj,ak)
local al=a.load'p'
local am=al.Create(true,"Popup",ah.Window,ah.WindUI,ah.WindUI.ScreenGui.KeySystem)

local an={}

local ao

local ap=GetViewportSize()
local aq=ap.X<560
local ar=ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Image and not aq
local as=(ar and ah.KeySystem.Thumbnail.Width)or 200

local at=ah.KeySystem.Width or 430
if ar then
at=430+(as/2)
end
at=math.floor(math.min(at,math.max(300,ap.X-24)))

am.UIElements.Main.AutomaticSize="Y"
am.UIElements.Main.Size=UDim2.new(0,at,0,0)
am.UIElements.MainContainer.ClipsDescendants=true

local au=ad("UIScale",{
Name="Scale",
Scale=0.96,
Parent=am.UIElements.MainContainer,
})

ab.NewRoundFrame(26,"SquircleGlass",{
Name="GlassLayer",
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.84,
ZIndex=9998,
Parent=am.UIElements.MainContainer,
ThemeTag={
ImageColor3="Primary",
},
})

ab.NewRoundFrame(26,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.62,
ZIndex=9998,
Parent=am.UIElements.MainContainer,
ThemeTag={
ImageColor3="Outline",
},
})

local av

if ah.Icon then
av=
ab.Image(ah.Icon,ah.Title..":"..ah.Icon,0,"Temp","KeySystem",ah.IconThemed)
av.Size=UDim2.new(0,24,0,24)
av.LayoutOrder=-1
end

local aw=ad("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ah.KeySystem.Title or ah.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20,
})

local ax=ad("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Text=ah.KeySystem.Subtitle or ah.KeySystem.Description or"Secure access gate",
TextXAlignment="Left",
TextTransparency=0.34,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=13,
})

local ay=ad("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ad("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
av,
aw,
})

local az=ad("TextLabel",{
BackgroundTransparency=1,
Text="Waiting",
TextSize=12,
TextTransparency=0.08,
AutomaticSize="XY",
FontFace=Font.new(ab.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Text",
},
})

local aA=ab.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,0,0,28),
AutomaticSize="X",
ImageTransparency=0.84,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ad("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ad("UIListLayout",{
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
az,
})

local aB=ad("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ay,
aA,
})

ay.Size=UDim2.new(1,-112,0,0)

local b=ab.NewRoundFrame(18,"Squircle",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.86,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ad("UIGradient",{
Rotation=18,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.06),
NumberSequenceKeypoint.new(1,0.34),
},
}),
ad("UIPadding",{
PaddingTop=UDim.new(0,14),
PaddingLeft=UDim.new(0,14),
PaddingRight=UDim.new(0,14),
PaddingBottom=UDim.new(0,14),
}),
ad("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
}),
aB,
ax,
})

local d=ag(ah.KeySystem.Placeholder or"Enter Key","key",nil,"Input",function(d)
ao=d
end)

local f
if ah.KeySystem.Note and ah.KeySystem.Note~=""then
f=ad("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ah.KeySystem.Note,
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

local g=ad("UIGradient",{
Name="FillGradient",
Rotation=0,
Offset=Vector2.new(-0.2,0),
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.08),
NumberSequenceKeypoint.new(0.45,0),
NumberSequenceKeypoint.new(1,0.2),
},
})
local h=ab.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(0.18,0,1,0),
ClipsDescendants=true,
ImageTransparency=0.02,
ZIndex=3,
ThemeTag={
ImageColor3="Primary",
},
},{
g,
ab.NewRoundFrame(999,"SquircleGlass",{
Name="LiquidSheen",
Size=UDim2.new(0.42,0,1,0),
Position=UDim2.new(0.18,0,0,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.7,
ZIndex=4,
},{
ad("UIGradient",{
Rotation=0,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.48,0.22),
NumberSequenceKeypoint.new(1,1),
},
}),
}),
})
local i=ad("TextLabel",{
Size=UDim2.new(1,0,0,16),
BackgroundTransparency=1,
Text="Access check ready",
TextSize=12,
TextTransparency=0.34,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})
local l=ab.NewRoundFrame(999,"Squircle",{
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
h,
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
local m=ad("Frame",{
Size=UDim2.new(1,0,0,30),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,6),
}),
i,
l,
})

local function SetState(p,r,u)
az.Text=tostring(p or az.Text)
i.Text=tostring(p or i.Text)
if u then
aA.Dot.ImageColor3=Color3.fromRGB(255,94,94)
h.ImageColor3=Color3.fromRGB(255,94,94)
else
ab.SetThemeTag(aA.Dot,{
ImageColor3="Primary",
},0.12)
ab.SetThemeTag(h,{
ImageColor3="Primary",
},0.12)
end
if r~=nil then
g.Offset=Vector2.new(-0.2,0)
ac.Play(h,"Switch",{
Size=UDim2.new(math.clamp(tonumber(r)or 0,0,1),0,1,0),
},nil,nil,"KeySystemProgress")
ac.Play(g,"Background",{
Offset=Vector2.new(0.45,0),
},Enum.EasingStyle.Sine,Enum.EasingDirection.Out,"KeySystemProgressSheen")
end
end

local p=ad("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ad("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ad("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
}),
}),
})

local r
if ar then
local u
if ah.KeySystem.Thumbnail.Title then
u=ad("TextLabel",{
Text=ah.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
r=ad("ImageLabel",{
Image=ah.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,as,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=am.UIElements.Main,
ScaleType="Crop",
},{
u,
ad("UICorner",{
CornerRadius=UDim.new(0,20),
}),
})
end

ad("Frame",{

Size=UDim2.new(1,r and-as or 0,1,0),
Position=UDim2.new(0,r and as or 0,0,0),
BackgroundTransparency=1,
Parent=am.UIElements.Main,
},{
ad("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
b,
f,
d,
m,
p,
ad("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
}),
})





local u=af("Exit","log-out",function()
am:Close()()
end,"Tertiary",p.Frame)

if r then
u.Parent=r
u.Size=UDim2.new(0,0,0,42)
u.Position=UDim2.new(0,10,1,-10)
u.AnchorPoint=Vector2.new(0,1)
end

if ah.KeySystem.URL then
af("Get key","key",function()
if setclipboard then
setclipboard(ah.KeySystem.URL)
end
SetState("Key link copied",0.36)
end,"Secondary",p.Frame)
end

if ah.KeySystem.API then








local v=math.min(240,math.max(190,at-42))
local x=false
local z=af("Get key","key",nil,"Secondary",p.Frame)

local A=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
})

ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=z.Frame,
},{
A,
ad("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
}),
})

local B=ab.Image("chevron-down","chevron-down",0,"Temp","KeySystem",true)

B.Size=UDim2.new(1,0,1,0)

ad("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=z.Frame,
BackgroundTransparency=1,
},{
B,
})

local C=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Background",
},
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
}),
})

local F=ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,v,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=z,
Position=UDim2.new(1,0,1,15),
},{
C,
})

ad("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=C,
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
})

for G,H in next,ah.KeySystem.API do
local J=ah.WindUI.Services[H.Type]
if J then
local L={}
for M,N in next,J.Args do
table.insert(L,H[N])
end

local M=J.New(table.unpack(L))
M.Type=H.Type
table.insert(an,M)

local N=H.Icon or J.Icon or"key-round"
local O=ab.Image(N,N,0,"Temp","KeySystem",true)
O.Size=UDim2.new(0,24,0,24)

local P=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=C,
AutomaticSize="Y",
},{
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
O,
ad("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ad("TextLabel",{
Text=H.Title or J.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
}),
ad("TextLabel",{
Text=H.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=H.Desc and true or false,
TextXAlignment="Left",
}),
}),
},true)

ab.AddSignal(P.MouseEnter,function()
ac.Play(P,"Hover",{ImageTransparency=0.94},nil,nil,"ServiceHover")
end)
ab.AddSignal(P.InputEnded,function()
ac.Play(P,"Hover",{ImageTransparency=1},nil,nil,"ServiceHover")
end)
ac.AttachPress(P,ab,{
Amount=0.985,
})
ab.AddSignal(P.MouseButton1Click,function()
M.Copy()
SetState("Key link copied",0.36)
ah.WindUI:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Icon="key",
}
end)
end
end

ab.AddSignal(z.MouseButton1Click,function()
if not x then
ac.Play(
F,
"Expand",
{Size=UDim2.new(0,v,0,C.AbsoluteSize.Y+1)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"KeyService"
)
ac.Play(B,"Expand",{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"KeyServiceChevron")
else
ac.Play(
F,
"Expand",
{Size=UDim2.new(0,v,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"KeyService"
)
ac.Play(B,"Expand",{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"KeyServiceChevron")
end
x=not x
end)
end

local function handleSuccess(v,x)
SetState("Access granted",1)
am:Close()()
if x and writefile then
pcall(function()
writefile((ah.Folder or"Temp").."/"..ai..".key",tostring(v))
end)
end
task.wait(0.35)
aj(true)
end

local v=false
local x=af("Submit","arrow-right",function()
if v then
return
end
v=true
SetState("Checking key",0.72)

local x=tostring(ao or"empty")
local function Reject(z)
v=false
SetState("Invalid key",0.08,true)
ah.WindUI:Notify{
Title="Key System",
Content=z or"Invalid key.",
Icon="triangle-alert",
}
end

if ah.KeySystem.KeyValidator then
local z,A,B=pcall(ah.KeySystem.KeyValidator,x)
if not z then
Reject(tostring(A))
return
end

if A then
handleSuccess(x,ah.KeySystem.SaveKey)
else
Reject(B or"Invalid key.")
end
elseif not ah.KeySystem.API then
local z=type(ah.KeySystem.Key)=="table"and table.find(ah.KeySystem.Key,x)
or ah.KeySystem.Key==x

if z then
handleSuccess(x,ah.KeySystem.SaveKey)
else
Reject"Invalid key."
end
else
local z,A
for B,C in next,an do
local F,G,H=pcall(C.Verify,x)
if not F then
local J=G
G=false
H=tostring(J)
end
if G then
z,A=true,H
break
end
A=H
end

if z then
handleSuccess(x,ah.KeySystem.SaveKey~=false)
else
Reject(A or"Invalid key.")
end
end
end,"Primary",p)

x.AnchorPoint=Vector2.new(1,0.5)
x.Position=UDim2.new(1,0,0.5,0)










SetState("Waiting for key",0.18)
am:Open()
ac.Play(au,"DropdownOpen",{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"KeySystemScale")
end

return aa end function a.r()

local aa={}

local ab=a.load'd'
local ac=a.load'e'
local ad=ab.New
local ae=game:GetService"Workspace"

local function AsConfig(af)
if af==true then
return{}
end
return typeof(af)=="table"and af or{}
end

local function ClampProgress(af)
return math.clamp(tonumber(af)or 0,0,1)
end

local function CreateIcon(af,ag,ah,ai)
local aj=ab.Image(af or"sparkles",af or"sparkles",0,ai or"Temp","LoadingScreen",true,true)
aj.Size=UDim2.fromOffset(ah or 22,ah or 22)
aj.Parent=ag
return aj
end

local function GetViewportSize()
local af=ae.CurrentCamera
return af and af.ViewportSize or Vector2.new(1280,720)
end

function aa.new(af,ag)
ag=AsConfig(ag)

local ah=ag.Steps or{"Theme","Motion","Interface"}
local ai=GetViewportSize()
local aj=math.floor(math.min(ag.Width or 360,math.max(286,ai.X-28)))
local ak={
Closed=false,
Progress=ClampProgress(ag.Progress or 0.08),
UIElements={},
}

local al=ad("Frame",{
Name=ag.Name or"WindUILoadingScreen",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Active=true,
ZIndex=ag.ZIndex or 11000,
Parent=ag.Parent or af.ScreenGui,
})

local am=ad("Frame",{
Name="Scrim",
Size=UDim2.new(1,0,1,0),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,
ZIndex=al.ZIndex,
Parent=al,
})

local an=ad("CanvasGroup",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
ZIndex=al.ZIndex+1,
Parent=al,
})

local ao=ab.NewRoundFrame(ag.Corner or 28,"Squircle",{
Name="Card",
Size=UDim2.fromOffset(aj,230),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=1,
ZIndex=al.ZIndex+2,
Parent=an,
ThemeTag={
ImageColor3="Background",
},
},{
ad("UIScale",{
Name="Scale",
Scale=0.96,
}),
ab.NewRoundFrame(ag.Corner or 28,"SquircleGlass",{
Name="Glass",
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.82,
ZIndex=al.ZIndex+3,
ThemeTag={
ImageColor3="Primary",
},
}),
ab.NewRoundFrame(ag.Corner or 28,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.64,
ZIndex=al.ZIndex+4,
ThemeTag={
ImageColor3="Outline",
},
}),
ad("UIPadding",{
PaddingTop=UDim.new(0,18),
PaddingLeft=UDim.new(0,18),
PaddingRight=UDim.new(0,18),
PaddingBottom=UDim.new(0,18),
}),
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,14),
SortOrder="LayoutOrder",
}),
})

local ap=ab.NewRoundFrame(24,"Squircle",{
Name="Accent",
Size=UDim2.new(1,0,0,72),
ImageTransparency=0.82,
LayoutOrder=1,
ZIndex=al.ZIndex+5,
Parent=ao,
ThemeTag={
ImageColor3="Primary",
},
},{
ad("UIGradient",{
Name="AccentGradient",
Rotation=18,
Offset=Vector2.new(-0.25,0),
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.1),
NumberSequenceKeypoint.new(0.5,0.24),
NumberSequenceKeypoint.new(1,0.5),
},
}),
ad("UIPadding",{
PaddingLeft=UDim.new(0,14),
PaddingRight=UDim.new(0,14),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,12),
}),
})

local aq=ab.NewRoundFrame(999,"Squircle",{
Size=UDim2.fromOffset(42,42),
ImageTransparency=0.72,
ZIndex=al.ZIndex+6,
Parent=ap,
ThemeTag={
ImageColor3="ElementBackground",
},
})
local ar=CreateIcon(ag.Icon or"sparkles",aq,21,ag.Folder)
ar.AnchorPoint=Vector2.new(0.5,0.5)
ar.Position=UDim2.new(0.5,0,0.5,0)

local as=ad("Frame",{
Size=UDim2.new(1,-54,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap,
ZIndex=al.ZIndex+6,
},{
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,3),
}),
})

ad("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ag.Title or"WindUI",
TextSize=18,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(ab.Font,Enum.FontWeight.Bold),
Parent=as,
ThemeTag={
TextColor3="Text",
},
})

ad("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ag.Desc or"Preparing interface",
TextSize=13,
TextTransparency=0.34,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Parent=as,
ThemeTag={
TextColor3="Text",
},
})

local at=ad("TextLabel",{
Name="Status",
Size=UDim2.new(1,0,0,18),
BackgroundTransparency=1,
Text=ag.Status or ah[1]or"Loading",
TextSize=13,
TextTransparency=0.18,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
LayoutOrder=2,
Parent=ao,
ThemeTag={
TextColor3="Text",
},
})

local au=ab.NewRoundFrame(999,"Squircle",{
Name="ProgressTrack",
Size=UDim2.new(1,0,0,10),
ImageTransparency=0.82,
LayoutOrder=3,
ZIndex=al.ZIndex+5,
Parent=ao,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ab.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(ak.Progress,0,1,0),
ImageTransparency=0.06,
ZIndex=al.ZIndex+6,
ThemeTag={
ImageColor3="Primary",
},
},{
ad("UIGradient",{
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

local av=ad("Frame",{
Name="Steps",
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
LayoutOrder=4,
Parent=ao,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
}),
})

local aw={}
for ax,ay in next,ah do
local az=ab.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1/#ah,-6,1,0),
ImageTransparency=ax==1 and 0.84 or 0.94,
Parent=av,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ad("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
ad("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text=tostring(ay),
TextSize=11,
TextTransparency=ax==1 and 0.08 or 0.4,
TextTruncate="AtEnd",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
})
table.insert(aw,az)
end

function ak.SetStatus(ax,ay)
at.Text=tostring(ay or"")
return ak
end

function ak.SetProgress(ax,ay)
ak.Progress=ClampProgress(ay)
ac.Play(au.Fill,"Switch",{
Size=UDim2.new(ak.Progress,0,1,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"LoadingProgress")
return ak
end

function ak.Step(ax,ay,az)
local aA=math.max(#aw,1)
local aB=math.clamp(tonumber(ay)or 1,1,aA)
if az then
ak:SetStatus(az)
else
ak:SetStatus(ah[aB]or at.Text)
end
ak:SetProgress(aB/aA)

for b,d in next,aw do
local f=b<=aB
ac.Play(d,"Switch",{ImageTransparency=f and 0.84 or 0.94},nil,nil,"Step")
if d.Title then
ac.Play(d.Title,"Switch",{TextTransparency=f and 0.08 or 0.4},nil,nil,"StepText")
end
end
return ak
end

function ak.Close(ax,ay)
if ak.Closed then
return ak
end
ak.Closed=true
task.delay(tonumber(ay)or 0,function()
ac.Play(an,"DropdownClose",{GroupTransparency=1},nil,nil,"LoadingContent")
ac.Play(am,"DropdownClose",{BackgroundTransparency=1},nil,nil,"LoadingScrim")
ac.Play(ao,"DropdownClose",{ImageTransparency=1},nil,nil,"LoadingCard")
ac.Play(ao.Scale,"DropdownClose",{Scale=0.96},nil,nil,"LoadingScale")
task.wait(ac.GetDuration"DropdownClose"+0.03)
if al then
al:Destroy()
end
end)
return ak
end

function ak.Open(ax)
ak.Closed=false
al.Visible=true
am.BackgroundTransparency=1
an.GroupTransparency=1
ao.ImageTransparency=1
ao.Scale.Scale=0.96
ac.Play(am,"DropdownOpen",{
BackgroundTransparency=ag.ScrimTransparency or 0.2,
},nil,nil,"LoadingScrim")
ac.Play(an,"DropdownOpen",{GroupTransparency=0},nil,nil,"LoadingContent")
ac.Play(ao,"DropdownOpen",{ImageTransparency=ag.CardTransparency or 0.16},nil,nil,"LoadingCard")
ac.Play(ao.Scale,"DropdownOpen",{Scale=1},nil,nil,"LoadingScale")
return ak
end

ak.UIElements.Root=al
ak.UIElements.Scrim=am
ak.UIElements.Content=an
ak.UIElements.Card=ao
ak.UIElements.Status=at
ak.UIElements.ProgressFill=au.Fill

ak:Open()

if ac:IsEnabled()and not ac.Reduced then
task.spawn(function()
local ax=1
while not ak.Closed and ap and ap.Parent do
local ay=ap:FindFirstChild"AccentGradient"
local az=au.Fill and au.Fill:FindFirstChild"FillGradient"
if ay then
ac.Play(ay,"Background",{Offset=Vector2.new(ax*0.28,0)},Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,"LoadingSheen")
end
if az then
ac.Play(az,"Background",{Offset=Vector2.new(ax*0.38,0)},Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,"LoadingFillSheen")
end
ax*=-1
task.wait(ac.GetDuration"Background"+0.18)
end
end)
end

if ag.Duration or ag.AutoClose then
task.delay(tonumber(ag.Duration)or 1.2,function()
ak:SetProgress(1)
ak:Close(ag.CloseDelay or 0.15)
end)
end

return ak
end

return aa end function a.s()




local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ac,ad,ae,af)
return(ab-ac)*(af-ae)/(ad-ac)+ae
end

local function viewportPointToWorld(ab,ac)
local ad=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ad.Origin+ad.Direction*ac
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.t()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.load'd'
local ac=ab.New


local ad,ae=unpack(a.load's')
local af=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ag=ac("Part",{
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
ac("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ag
end


local function createAcrylicBlur(ag)
local ah={}

ag=ag or 0.001
local ai={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local aj=createAcrylic()
aj.Parent=af

local function updatePositions(ak,al)
ai.topLeft=al
ai.topRight=al+Vector2.new(ak.X,0)
ai.bottomRight=al+ak
end

local function render()
local ak=aa(game:GetService"Workspace").CurrentCamera
if ak then
ak=ak.CFrame
end
local al=ak
if not al then
al=CFrame.new()
end

local am=al
local an=ai.topLeft
local ao=ai.topRight
local ap=ai.bottomRight

local aq=ad(an,ag)
local ar=ad(ao,ag)
local as=ad(ap,ag)

local at=(ar-aq).Magnitude
local au=(ar-as).Magnitude

aj.CFrame=
CFrame.fromMatrix((aq+as)/2,am.XVector,am.YVector,am.ZVector)
aj.Mesh.Scale=Vector3.new(at,au,0)
end

local function onChange(ak)
local al=ae()
local am=ak.AbsoluteSize-Vector2.new(al,al)
local an=ak.AbsolutePosition+Vector2.new(al/2,al/2)

updatePositions(am,an)
task.spawn(render)
end

local function renderOnChange()
local ak=aa(game:GetService"Workspace").CurrentCamera
if not ak then
return
end

table.insert(ah,ak:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

aj.Destroying:Connect(function()
for ak,al in ah do
pcall(function()
al:Disconnect()
end)
end
end)

renderOnChange()

return onChange,aj
end

return function(ag)
local ah={}
local ai,aj=createAcrylicBlur(ag)

local ak=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(ak:GetPropertyChangedSignal"AbsolutePosition",function()
ai(ak)
end)

ab.AddSignal(ak:GetPropertyChangedSignal"AbsoluteSize",function()
ai(ak)
end)

ah.AddParent=function(al)
ab.AddSignal(al:GetPropertyChangedSignal"Visible",function()

end)
end

ah.SetVisibility=function(al)
aj.Transparency=al and 0.98 or 1
end

ah.Frame=ak
ah.Model=aj

return ah
end end function a.u()


local aa=a.load'd'
local ab=a.load't'

local ac=aa.New

return function(ad)
local ae={}

ae.Frame=ac("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ac("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("ImageLabel",{
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
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local af

task.wait()
if ad.UseAcrylic then
af=ab()

af.Frame.Parent=ae.Frame
ae.Model=af.Model
ae.AddParent=af.AddParent
ae.SetVisibility=af.SetVisibility
end

return ae,af
end end function a.v()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.load't',

AcrylicPaint=a.load'u',
}

function ab.init()
local ac=Instance.new"DepthOfFieldEffect"
ac.FarIntensity=0
ac.InFocusRadius=0.1
ac.NearIntensity=1

local ad={}

function ab.Enable()
for ae,af in pairs(ad)do
af.Enabled=false
end
ac.Parent=aa(game:GetService"Lighting")
end

function ab.Disable()
for ae,af in pairs(ad)do
af.Enabled=af.enabled
end
ac.Parent=nil
end

local function registerDefaults()
local function register(ae)
if ae:IsA"DepthOfFieldEffect"then
ad[ae]={enabled=ae.Enabled}
end
end

for ae,af in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(af)
end

if aa(game:GetService"Workspace").CurrentCamera then
for ae,af in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(af)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.w()

local aa={}

local ab=a.load'd'
local ac=ab.New local ad=
ab.Tween


function aa.new(ae,af)
local ag={
Title=ae.Title or"Dialog",
Content=ae.Content,
Icon=ae.Icon,
IconThemed=ae.IconThemed,
Thumbnail=ae.Thumbnail,
Buttons=ae.Buttons,

IconSize=22,
}

local ah=a.load'p'
local ai=ah.Create(true,"Popup",ae.WindUI.Window,ae.WindUI,af)

local aj=200

local ak=430
if ag.Thumbnail and ag.Thumbnail.Image then
ak=430+(aj/2)
end

ai.UIElements.Main.AutomaticSize="Y"
ai.UIElements.Main.Size=UDim2.new(0,ak,0,0)



local al

if ag.Icon then
al=ab.Image(
ag.Icon,
ag.Title..":"..ag.Icon,
0,
ae.WindUI.Window,
"Popup",
true,
ae.IconThemed,
"PopupIcon"
)
al.Size=UDim2.new(0,ag.IconSize,0,ag.IconSize)
al.LayoutOrder=-1
end


local am=ac("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ag.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,al and-ag.IconSize-14 or 0,0,0)
})

local an=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
al,am
})

local ao=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





an,
})

local ap
if ag.Content and ag.Content~=""then
ap=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.Content,
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

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local ar
if ag.Thumbnail and ag.Thumbnail.Image then
local as
if ag.Thumbnail.Title then
as=ac("TextLabel",{
Text=ag.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
ar=ac("ImageLabel",{
Image=ag.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,aj,1,0),
Parent=ai.UIElements.Main,
ScaleType="Crop"
},{
as,
ac("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ac("Frame",{

Size=UDim2.new(1,ar and-aj or 0,1,0),
Position=UDim2.new(0,ar and aj or 0,0,0),
BackgroundTransparency=1,
Parent=ai.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
ao,
ap,
aq,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local as=a.load'n'.New

for at,au in next,ag.Buttons do
as(au.Title,au.Icon,au.Callback,au.Variant,aq,ai)
end

ai:Open()


return ag
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
local ac=ab.New local ad=
ab.Tween

function aa.New(ae,af,ag,ah,ai,aj)
local ak=ai or 10
local al
if af and af~=""then
al=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
})
end

local am=ac("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,al and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ah and"Placeholder"or"Text",
},
Text=ae,
})

local an=ac("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
Text="",
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(ak,"Squircle",{
ThemeTag={
ImageColor3="Placeholder",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.85,
}),
not aj and ab.NewRoundFrame(ak,"SquircleGlass",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,1,1,1),
ImageTransparency=0.9,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})or nil,
ab.NewRoundFrame(ak,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
al,
am,
}),
}),
})

return an
end

return aa end function a.z()

local aa={}

local ab=cloneref or clonereference or function(ab)
return ab
end
local ac=ab(game:GetService"UserInputService")

local ad=a.load'd'
local ae=ad.New

function aa.New(af,ag,ah,ai,aj)
local ak=ae("Frame",{
Size=UDim2.new(0,ai,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ag,
ZIndex=999,
Active=true,
})

local al=ad.NewRoundFrame(ai/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=ak,
})

local am=ae("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=al,
})

local an=ad:GenerateUniqueID()
local ao=false
local ap,aq

local function UpdateVisuals()
local ar=af.AbsoluteCanvasSize.Y
local as=af.AbsoluteWindowSize.Y

if ar<=as then
al.Visible=false
return
end

al.Visible=true

local at=math.clamp(as/ar,0.05,1)
al.Size=UDim2.new(1,0,at,0)

local au=ar-as
local av=1-at

if au>0 then
local aw=af.CanvasPosition.Y/au
al.Position=UDim2.new(0,0,math.clamp(aw*av,0,av),0)
else
al.Position=UDim2.new(0,0,0,0)
end
end

local function StopDrag()
if aj.CurrentInput==an then
aj.CurrentInput=nil
end
ao=false
af.ScrollingEnabled=true
if ap then
ap:Disconnect()
end
if aq then
aq:Disconnect()
end
end

ad.AddSignal(am.InputBegan,function(ar)
if
ar.UserInputType~=Enum.UserInputType.MouseButton1
and ar.UserInputType~=Enum.UserInputType.Touch
then
return
end
if ao then
return
end
if aj.CurrentInput and aj.CurrentInput~=an then
return
end

aj.CurrentInput=an

ao=true
af.ScrollingEnabled=false

local as=ar.Position.Y
local at=af.CanvasPosition.Y

ap=ac.InputChanged:Connect(function(au)
if
au.UserInputType==Enum.UserInputType.MouseMovement
or au.UserInputType==Enum.UserInputType.Touch
then
local av=au.Position.Y-as

local aw=af.AbsoluteCanvasSize.Y
local ax=af.AbsoluteWindowSize.Y
local ay=math.max(aw-ax,0)

local az=ak.AbsoluteSize.Y
local aA=al.AbsoluteSize.Y
local aB=math.max(az-aA,1)

local b=av*(ay/aB)

af.CanvasPosition=
Vector2.new(af.CanvasPosition.X,math.clamp(at+b,0,ay))
end
end)

aq=ac.InputEnded:Connect(function(au)
if au.UserInputType==ar.UserInputType then
if aj.CurrentInput and aj.CurrentInput~=an then
return
end

aj.CurrentInput=nil

StopDrag()
end
end)
end)

ad.AddSignal(af:GetPropertyChangedSignal"AbsoluteWindowSize",UpdateVisuals)
ad.AddSignal(af:GetPropertyChangedSignal"AbsoluteCanvasSize",UpdateVisuals)
ad.AddSignal(af:GetPropertyChangedSignal"CanvasPosition",UpdateVisuals)

UpdateVisuals()

return ak
end

return aa end function a.A()

local aa={}

local ab=a.load'd'
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag)
local ah={
Title=af.Title or"Tag",
Icon=af.Icon,
Color=af.Color or Color3.fromHex"#315dff",
Radius=af.Radius or 999,
Border=af.Border or false,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local ai
if ah.Icon then
ai=ab.Image(ah.Icon,ah.Icon,0,af.Window,"Tag",false)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.ImageLabel.ImageColor3=typeof(ah.Color)=="Color3"
and ab.GetTextColorForHSB(ah.Color)
or typeof(ah.Color)=="string"
and(ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme)))
end

local aj=ac("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ah.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ah.Title,
TextColor3=typeof(ah.Color)=="Color3"and ab.GetTextColorForHSB(ah.Color)or typeof(
ah.Color
)=="string"and(ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))),
})

local ak

if typeof(ah.Color)=="table"then
ak=ac"UIGradient"
for al,am in next,ah.Color do
ak[al]=am
end

aj.TextColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
if ai then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
end

local al=ab.NewRoundFrame(ah.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ah.Height),
Parent=ag,
ImageColor3=typeof(ah.Color)=="Color3"and ah.Color
or typeof(ah.Color)=="table"and Color3.new(1,1,1)
or nil,
ThemeTag=typeof(ah.Color)=="string"and{
ImageColor3=ah.Color,
},
},{
ak,
ab.NewRoundFrame(ah.Radius+1,"SquircleGlass",{
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0.75,
}),
ac("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Name="Content",
BackgroundTransparency=1,
},{
ai,
aj,
ac("UIPadding",{
PaddingLeft=UDim.new(0,ah.Padding),
PaddingRight=UDim.new(0,ah.Padding),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ah.Padding/1.5),
}),
}),
})

function ah.SetTitle(am,an)
ah.Title=an
aj.Text=an

return ah
end

function ah.SetColor(am,an)
ah.Color=an
if typeof(an)=="table"then
local ao=ab.GetAverageColor(an)
ad(aj,0.06,{TextColor3=ab.GetTextColorForHSB(ao)}):Play()
local ap=al:FindFirstChildOfClass"UIGradient"or ac("UIGradient",{Parent=al})
for aq,ar in next,an do
ap[aq]=ar
end
ad(al,0.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if ak then
ak:Destroy()
end
ad(aj,0.06,{TextColor3=ab.GetTextColorForHSB(an)}):Play()
if ai then
ad(ai.ImageLabel,0.06,{ImageColor3=ab.GetTextColorForHSB(an)}):Play()
end
ad(al,0.06,{ImageColor3=an}):Play()
end

return ah
end

function ah.SetIcon(am,an)
ah.Icon=an

if an then
ai=ab.Image(an,an,0,af.Window,"Tag",false)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.Parent=al

if typeof(ah.Color)=="Color3"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ah.Color)
elseif typeof(ah.Color)=="table"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
else
if ai then
ai:Destroy()
ai=nil
end
end
return ah
end

function ah.Destroy(am)
al:Destroy()
return ah
end

ab:OnThemeChange(function(am,an)
aj.TextColor3=ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))
ai.ImageLabel.ImageColor3=
ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))
end)

return ah
end

return aa end function a.B()

local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"RunService")
local ac=aa(game:GetService"HttpService")

local ad

local ae
ae={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(af)
return{
__type=af.__type,
value=af.Default:ToHex(),
transparency=af.Transparency or nil,
}
end,
Load=function(af,ag)
if af and af.Update then
af:Update(Color3.fromHex(ag.value),ag.transparency or nil)
end
end
},
Dropdown={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value)
end
end
},
Input={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Keybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
RadioGroup={
Save=function(af)
return{
__type=af.__type,
value=af.Get and af:Get()or af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value,false)
end
end
},
CheckboxGroup={
Save=function(af)
return{
__type=af.__type,
value=af.Get and af:Get()or af.Values,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value or{},false)
end
end
},
SegmentedControl={
Save=function(af)
return{
__type=af.__type,
value=af.Get and af:Get()or af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value,false)
end
end
},
TextArea={
Save=function(af)
return{
__type=af.__type,
value=af.Get and af:Get()or af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value or"",false)
end
end
},
Slider={
Save=function(af)
return{
__type=af.__type,
value=af.Value.Default,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(tonumber(ag.value))
end
end
},
Stepper={
Save=function(af)
return{
__type=af.__type,
value=af.Get and af:Get()or af.Value.Default,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(tonumber(ag.value),false)
end
end
},
TabBox={
Save=function(af)
return{
__type=af.__type,
value=af.Get and af:Get()or af.SelectedValue,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
ChipList={
Save=function(af)
return{
__type=af.__type,
value=af.Get and af:Get()or af.Values,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value,false)
end
end
},
Toggle={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
}
}

function ae.Init(af,ag)
if not ag.Folder then
warn"[ WindUI.ConfigManager ] Window.Folder is not specified."
return false
end
if ab:IsStudio()or not writefile then
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return false
end

ad=ag
ae.Folder=ad.Folder
ae.Path="WindUI/"..tostring(ae.Folder).."/config/"

if not isfolder(ae.Path)then
makefolder(ae.Path)
end

local ah=ae:AllConfigs()

for ai,aj in next,ah do
local ak=ae.Path..tostring(aj)..".json"
if isfile and readfile and isfile(ak)then
local al,am=pcall(function()
return readfile(ak)
end)
if al then
ae.Configs[aj]=am
end
end
end

return ae
end

function ae.SetPath(af,ag)
if not ag then
warn"[ WindUI.ConfigManager ] Custom path is not specified."
return false
end

ae.Path=ag
if not ag:match"/$"then
ae.Path=ag.."/"
end

if not isfolder(ae.Path)then
makefolder(ae.Path)
end

return true
end

function ae.CreateConfig(af,ag,ah)
local ai={
Path=ae.Path..ag..".json",
Elements={},
CustomData={},
AutoLoad=ah or false,
Version=1.2,
}

if not ag then
return false,"No config file is selected"
end

function ai.SetAsCurrent(aj)
ad:SetCurrentConfig(ai)
end

function ai.Register(aj,ak,al)
ai.Elements[ak]=al
end

function ai.Set(aj,ak,al)
ai.CustomData[ak]=al
end

function ai.Get(aj,ak)
return ai.CustomData[ak]
end

function ai.SetAutoLoad(aj,ak)
ai.AutoLoad=ak
end

function ai.Save(aj)
if ad.PendingFlags then
for ak,al in next,ad.PendingFlags do
ai:Register(ak,al)
end
end

local ak={
__version=ai.Version,
__elements={},
__autoload=ai.AutoLoad,
__custom=ai.CustomData
}

for al,am in next,ai.Elements do
if ae.Parser[am.__type]then
ak.__elements[tostring(al)]=ae.Parser[am.__type].Save(am)
end
end

local al=ac:JSONEncode(ak)
if writefile then
local am,an=pcall(function()
writefile(ai.Path,al)
end)
if not am then
return false,"Failed to save config: "..tostring(an)
end
else
return false,"writefile function is not available"
end

return ak
end

function ai.Load(aj)
if isfile and not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
local ak=readfile or function()
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ac:JSONDecode(ak(ai.Path))
end)

if not ak then
return false,"Failed to parse config file"
end

if not al.__version then
local am={
__version=ai.Version,
__elements=al,
__custom={}
}
al=am
end

if ad.PendingFlags then
for am,an in next,ad.PendingFlags do
ai:Register(am,an)
end
end

ad.PendingConfigData=al.__elements or{}

for am,an in next,(al.__elements or{})do
if typeof(an)=="table"and ai.Elements[am]and ae.Parser[an.__type]then
task.spawn(function()
local ao,ap=pcall(function()
ae.Parser[an.__type].Load(ai.Elements[am],an)
end)
if not ao then
warn("[ WindUI.ConfigManager ] Failed to load element '"..tostring(am).."': "..tostring(ap))
end
end)
end
end

ai.CustomData=al.__custom or{}

return ai.CustomData
end

function ai.Delete(aj)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
delfile(ai.Path)
end)

if not ak then
return false,"Failed to delete config file: "..tostring(al)
end

ae.Configs[ag]=nil

if ad.CurrentConfig==ai then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ai.GetData(aj)
return{
elements=ai.Elements,
custom=ai.CustomData,
autoload=ai.AutoLoad
}
end


if isfile(ai.Path)then
local aj,ak=pcall(function()
return ac:JSONDecode(readfile(ai.Path))
end)

if aj and ak and ak.__autoload then
ai.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local al,am=pcall(function()
return ai:Load()
end)
if al then
if ad.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: "..ag)end
else
warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: "..ag.." - "..tostring(am))
end
end)
end
end


ai:SetAsCurrent()
ae.Configs[ag]=ai
return ai
end

function ae.Config(af,ag,ah)
return ae:CreateConfig(ag,ah)
end

function ae.GetAutoLoadConfigs(af)
local ag={}

for ah,ai in pairs(ae.Configs)do
if ai.AutoLoad then
table.insert(ag,ah)
end
end

return ag
end

function ae.DeleteConfig(af,ag)
if not delfile then
return false,"delfile function is not available"
end

local ah=ae.Path..ag..".json"

if not isfile(ah)then
return false,"Config file does not exist"
end

local ai,aj=pcall(function()
delfile(ah)
end)

if not ai then
return false,"Failed to delete config file: "..tostring(aj)
end

ae.Configs[ag]=nil

if ad.CurrentConfig and ad.CurrentConfig.Path==ah then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ae.AllConfigs(af)
if not listfiles then return{}end

local ag={}
if not isfolder(ae.Path)then
makefolder(ae.Path)
return ag
end

for ah,ai in next,listfiles(ae.Path)do
local aj=ai:match"([^\\/]+)%.json$"
if aj then
table.insert(ag,aj)
end
end

return ag
end

function ae.GetConfig(af,ag)
return ae.Configs[ag]
end

return ae end function a.C()

local aa={}

local ab=a.load'd'
local ac=ab.New
local ad=ab.Tween


local ae=(cloneref or clonereference or function(ae)return ae end)


ae(game:GetService"UserInputService")

local af={
TopCenter=UDim2.new(0.5,0,0,28),
TopLeft=UDim2.new(0,36,0,28),
TopRight=UDim2.new(1,-36,0,28),
BottomCenter=UDim2.new(0.5,0,1,-36),
BottomLeft=UDim2.new(0,36,1,-36),
BottomRight=UDim2.new(1,-36,1,-36),
}

local function ResolvePosition(ag)
if typeof(ag)=="UDim2"then
return ag
end
return af[tostring(ag or"TopCenter")]or af.TopCenter
end


function aa.New(ag)
local ah={
Button=nil,
IconSize=22,
}

local ai

local function GetInnerCornerRadius(aj,ak)
if typeof(aj)~="UDim"then
return UDim.new(1,0)
end

if aj.Scale~=0 then
return UDim.new(aj.Scale,math.max(aj.Offset,0))
end

return UDim.new(0,math.max(aj.Offset-ak,0))
end













local aj=ac("TextLabel",{
Text=ag.Title,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})

local ak=ac("Frame",{
Size=UDim2.new(0,36,0,36),
BackgroundTransparency=1,
Name="Drag",
},{
ac("ImageLabel",{
Image=ab.Icon"move"[1],
ImageRectOffset=ab.Icon"move"[2].ImageRectPosition,
ImageRectSize=ab.Icon"move"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.3,
})
})
local al=ac("Frame",{
Size=UDim2.new(0,1,1,0),
Position=UDim2.new(0,36,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local am=ac("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,28),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=ag.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})


local an=ac("UIScale",{
Scale=1,
})

local ao=ac("Frame",{
Size=UDim2.new(0,0,0,44),
AutomaticSize="X",
Parent=am,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{
an,
ac("UICorner",{
CornerRadius=UDim.new(1,0)
}),
ac("UIStroke",{
Thickness=1,
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0,
},{
ac("UIGradient",{
Color=ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff")
})
}),
ak,
al,

ac("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

ac("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,36),

BackgroundColor3=Color3.new(1,1,1),
},{
ac("UICorner",{
CornerRadius=GetInnerCornerRadius(UDim.new(1,0),4)
}),
ai,
ac("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj,
ac("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
}),
}),
ac("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

ah.Button=ao



function ah.SetIcon(ap,aq)
if ai then
ai:Destroy()
end
if aq then
ai=ab.Image(
aq,
ag.Title,
0,
ag.Folder,
"OpenButton",
true,
ag.IconThemed
)
ai.Size=UDim2.new(0,22,0,22)
ai.LayoutOrder=-1
ai.Parent=ah.Button.TextButton
ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
end
end

if ag.Icon then
ah:SetIcon(ag.Icon)
end



ab.AddSignal(ao:GetPropertyChangedSignal"AbsoluteSize",function()
am.Size=UDim2.new(
0,ao.AbsoluteSize.X,
0,ao.AbsoluteSize.Y
)
end)

ab.AddSignal(ao.TextButton.MouseEnter,function()
ad(ao.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
ab.AddSignal(ao.TextButton.MouseLeave,function()
ad(ao.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

local ap=ab.Drag(am)


function ah.Visible(aq,ar)
am.Visible=ar
end

function ah.SetScale(aq,ar)
an.Scale=ar
end

function ah.Pulse(aq)
ad(an,.08,{Scale=an.Scale*0.94},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.delay(.08,function()
if an.Parent then
ad(an,.12,{Scale=ah.Scale or 1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)
end

function ah.Edit(aq,ar)
local as={
Title=ar.Title,
Icon=ar.Icon,
Enabled=ar.Enabled,
Position=ar.Position or ar.Preset,
OnlyIcon=ar.OnlyIcon or ar.Style=="Circle"or false,
Draggable=ar.Draggable or nil,
OnlyMobile=ar.OnlyMobile,
CornerRadius=ar.CornerRadius or UDim.new(1,0),
StrokeThickness=ar.StrokeThickness or 2,
StrokeTransparency=ar.StrokeTransparency,
Scale=ar.Scale or 1,
Height=math.max(tonumber(ar.Height)or 44,34),
IconSize=math.max(tonumber(ar.IconSize)or ah.IconSize or 22,14),
Padding=math.max(tonumber(ar.Padding)or 11,6),
BackgroundColor=ar.BackgroundColor,
BackgroundTransparency=ar.BackgroundTransparency or ar.Transparency,
TextColor=ar.TextColor,
TextTransparency=ar.TextTransparency,
Glass=ar.Glass or ar.LiquidGlass or ar.GlassLiquid,
Visible=ar.Visible,
Color=ar.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}



if as.Enabled==false then
ag.IsOpenButtonEnabled=false
end

if as.OnlyMobile~=false then
as.OnlyMobile=true
else
ag.IsPC=false
end


if as.Draggable==false and ak and al then
ak.Visible=as.Draggable
al.Visible=as.Draggable

if ap then
ap:Set(as.Draggable)
end
end

if as.Position and am then
am.Position=ResolvePosition(as.Position)
end

ah.IconSize=as.IconSize
ah.Scale=as.Scale

ao.Size=UDim2.new(0,0,0,as.Height)
ao.TextButton.Size=UDim2.new(0,0,0,as.Height-8)
ak.Size=UDim2.new(0,as.Height-8,0,as.Height-8)
al.Position=UDim2.new(0,(as.Height-8)+8,0.5,0)

if as.OnlyIcon==true and aj then
aj.Visible=false
ao.TextButton.UIPadding.PaddingLeft=UDim.new(0,7)
ao.TextButton.UIPadding.PaddingRight=UDim.new(0,7)
elseif as.OnlyIcon==false then
aj.Visible=true
ao.TextButton.UIPadding.PaddingLeft=UDim.new(0,as.Padding)
ao.TextButton.UIPadding.PaddingRight=UDim.new(0,as.Padding)
end





if aj then
if as.Title then
aj.Text=as.Title
ab:ChangeTranslationKey(aj,as.Title)
elseif as.Title==nil then

end
end

if as.Icon then
ah:SetIcon(as.Icon)
elseif ai then
ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
end

ao.UIStroke.UIGradient.Color=as.Color
if as.StrokeTransparency~=nil then
ao.UIStroke.Transparency=ab.ClampTransparency(as.StrokeTransparency,ao.UIStroke.Transparency)
elseif as.Glass then
ao.UIStroke.Transparency=0.38
end
if Glow then
Glow.UIGradient.Color=as.Color
end

if as.BackgroundColor then
ao.BackgroundColor3=as.BackgroundColor
end
if as.BackgroundTransparency~=nil then
ao.BackgroundTransparency=ab.ClampTransparency(as.BackgroundTransparency,ao.BackgroundTransparency)
elseif as.Glass then
ao.BackgroundTransparency=0.44
end
if as.TextColor then
aj.TextColor3=as.TextColor
end
if as.TextTransparency~=nil then
aj.TextTransparency=ab.ClampTransparency(as.TextTransparency,aj.TextTransparency)
end

ao.UICorner.CornerRadius=as.CornerRadius
ao.TextButton.UICorner.CornerRadius=GetInnerCornerRadius(as.CornerRadius,4)
ao.UIStroke.Thickness=as.StrokeThickness

ah:SetScale(as.Scale)
if as.Visible~=nil then
ah:Visible(as.Visible)
end
end

return ah
end



return aa end function a.D()

local aa={}

local ab=a.load'd'
local ac=a.load'e'
local ad=ab.New

local ae={
TopLeft={UDim2.new(0,14,0,14),Vector2.new(0,0)},
TopRight={UDim2.new(1,-14,0,14),Vector2.new(1,0)},
BottomLeft={UDim2.new(0,14,1,-14),Vector2.new(0,1)},
BottomRight={UDim2.new(1,-14,1,-14),Vector2.new(1,1)},
TopCenter={UDim2.new(0.5,0,0,14),Vector2.new(0.5,0)},
BottomCenter={UDim2.new(0.5,0,1,-14),Vector2.new(0.5,1)},
}

local function NormalizeConfig(af)
if af==false then
return{Visible=false}
end
if typeof(af)=="string"then
return{Title=af}
end
if typeof(af)~="table"then
return{}
end
return af or{}
end

function aa.New(af,ag)
local ah={}
local ai
local aj

local ak=ad("TextLabel",{
BackgroundTransparency=1,
Text=af.Title or"WindUI",
TextSize=13,
TextXAlignment="Left",
AutomaticSize="XY",
FontFace=Font.new(ab.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Text",
},
})

local al=ad("TextLabel",{
BackgroundTransparency=1,
Text="v"..tostring(ag and ag.Version or""),
TextSize=11,
TextTransparency=0.42,
TextXAlignment="Left",
AutomaticSize="XY",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})

local am=ad("Frame",{
Size=UDim2.new(0,0,0,0),
Position=ae.BottomRight[1],
AnchorPoint=ae.BottomRight[2],
BackgroundTransparency=1,
Parent=af.Parent,
Active=true,
Visible=false,
ZIndex=120,
})

local an=ab.NewRoundFrame(14,"Squircle",{
Name="Watermark",
Size=UDim2.new(0,0,0,36),
AutomaticSize="XY",
ImageTransparency=0.18,
Parent=am,
ZIndex=120,
ThemeTag={
ImageColor3="Background",
},
},{
ad("UIStroke",{
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0.82,
Thickness=1,
}),
ad("UIGradient",{
Rotation=24,
Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(210,235,255)),
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.96),
NumberSequenceKeypoint.new(0.48,0.76),
NumberSequenceKeypoint.new(1,0.96),
},
}),
ad("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ad("Frame",{
Name="Text",
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,1),
}),
ak,
al,
}),
ad("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingTop=UDim.new(0,7),
PaddingBottom=UDim.new(0,7),
}),
})

ab.AddSignal(an:GetPropertyChangedSignal"AbsoluteSize",function()
am.Size=UDim2.fromOffset(an.AbsoluteSize.X,an.AbsoluteSize.Y)
end)

aj=ab.Drag(am)

local function SetIcon(ao)
if ai then
ai:Destroy()
ai=nil
end
if not ao or ao==""then
return
end

ai=ab.Image(ao,ao,0,af.Folder,"Watermark",true,true,"Icon")
ai.Size=UDim2.new(0,16,0,16)
ai.LayoutOrder=-1
ai.Parent=an
end

function ah.Visible(ao,ap)
am.Visible=ap~=false
end

function ah.Edit(ao,ap)
ap=NormalizeConfig(ap)

if ap.Visible==false or ap.Enabled==false then
ah:Visible(false)
return ah
end

if ap.Title~=nil then
ak.Text=tostring(ap.Title)
ab:ChangeTranslationKey(ak,ak.Text)
end
if ap.Desc~=nil or ap.Subtitle~=nil then
al.Text=tostring(ap.Desc or ap.Subtitle or"")
al.Visible=al.Text~=""
ab:ChangeTranslationKey(al,al.Text)
end
if ap.Icon~=nil then
SetIcon(ap.Icon)
end
if ap.Position and ae[ap.Position]then
am.Position=ae[ap.Position][1]
am.AnchorPoint=ae[ap.Position][2]
elseif typeof(ap.Position)=="UDim2"then
am.Position=ap.Position
end
if typeof(ap.AnchorPoint)=="Vector2"then
am.AnchorPoint=ap.AnchorPoint
end
if ap.Transparency~=nil then
an.ImageTransparency=ab.ClampTransparency(ap.Transparency,an.ImageTransparency)
end
if ap.Scale then
local aq=an:FindFirstChildOfClass"UIScale"or ad("UIScale",{Parent=an})
aq.Scale=tonumber(ap.Scale)or 1
end
if aj then
aj:Set(ap.Draggable~=false)
end

ah:Visible(true)
ac.Play(an,"Reveal",{ImageTransparency=an.ImageTransparency},nil,nil,"Watermark")
return ah
end

function ah.SetTitle(ao,ap)
ak.Text=tostring(ap or"")
end

function ah.SetDesc(ao,ap)
al.Text=tostring(ap or"")
al.Visible=al.Text~=""
end

function ah.Destroy(ao)
am:Destroy()
end

ah.Container=am
ah.Main=an

return ah
end

return aa end function a.E()

local aa=game:GetService"UserInputService"
local ab=game:GetService"Workspace"

local ac=a.load'd'
local ad=a.load'e'
local ae=ac.New

local af={}

local function GetImageTarget(ag)
if typeof(ag)~="Instance"then
return nil
end

if ag:IsA"ImageLabel"or ag:IsA"ImageButton"then
return ag
end

return ag:FindFirstChildWhichIsA"ImageLabel"or ag:FindFirstChildWhichIsA"ImageButton"
end

local function ContainsPoint(ag,ah)
if typeof(ag)~="Instance"or not ag.Visible then
return false
end

local ai=ag.AbsolutePosition
local aj=ag.AbsoluteSize

return ah.X>=ai.X
and ah.X<=ai.X+aj.X
and ah.Y>=ai.Y
and ah.Y<=ai.Y+aj.Y
end

local function Trim(ag)
ag=tostring(ag or"")
ag=string.gsub(ag,"^%s+","")
ag=string.gsub(ag,"%s+$","")
return ag
end

local function GetThemeList(ag)
local ah={}

for ai,aj in next,ag:GetThemes()or{}do
table.insert(ah,{
Key=ai,
Name=aj.Name or ai,
})
end

table.sort(ah,function(ai,aj)
return ai.Name<aj.Name
end)

return ah
end

function af.New(ag,ah,ai)
local aj=typeof(ag.Settings)=="table"and ag.Settings or{}
local ak=aj.DefaultConfig or"default"
local al=aj.Width or 360
local am=aj.Height or 410
local an=aj.PageHeight or(am-142)
local ao={
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
local ap=ab.CurrentCamera
return ap and ap.ViewportSize or Vector2.new(1280,720)
end

local function Notify(ap,aq,ar)
if ah.Notify then
ah:Notify{
Title=ap,
Content=aq,
Icon=ar,
}
end
end

local function CreateIcon(ap,aq,ar)
local as=ac.Image(ap,ap,0,ag.Folder,"SettingsMenu",true,true,"Icon")
as.Size=UDim2.new(0,ar or 16,0,ar or 16)
as.Parent=aq
return as
end

local function CreateText(ap,aq,ar,as,at)
return ae("TextLabel",{
BackgroundTransparency=1,
Text=aq or"",
TextSize=ar or 14,
TextTransparency=at or 0,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Parent=ap,
FontFace=Font.new(ac.Font,as or Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})
end

local function CreatePanel(ap)
return ac.NewRoundFrame(ag.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=0.9,
Parent=ap,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIGradient",{
Rotation=35,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.05),
NumberSequenceKeypoint.new(1,0.2),
},
}),
ae("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})
end

local function CreateActionButton(ap,aq,ar,as,at)
local au=ac.NewRoundFrame(14,"Squircle",{
Size=UDim2.new(1,0,0,34),
ImageTransparency=as=="Primary"and 0 or 0.9,
ThemeTag={
ImageColor3=as=="Primary"and"Primary"or"ElementBackground",
},
Parent=ap,
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ae("UIListLayout",{
Padding=UDim.new(0,7),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
ar and CreateIcon(ar,nil,15)or nil,
ae("TextLabel",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=aq,
TextSize=13,
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
TextColor3=as=="Primary"and Color3.new(1,1,1)or nil,
ThemeTag={
TextColor3=as~="Primary"and"Text"or nil,
},
}),
},true)

ad.AttachPress(au,ac,{
Amount=0.97,
})

ac.AddSignal(au.MouseButton1Click,function()
ac.SafeCallback(at)
end)

return au
end

local ap=ac.NewRoundFrame(ag.ElementConfig.UICorner,"Squircle",{
Name="SettingsDropdown",
Size=UDim2.new(0,al,0,am),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.fromOffset(0,0),
ImageTransparency=1,
Visible=false,
Active=false,
ZIndex=10000,
Parent=ah.ScreenGui,
ThemeTag={
ImageColor3="Background",
},
},{
ae("UIScale",{
Name="Scale",
Scale=0.98,
}),
ac.NewRoundFrame(ag.ElementConfig.UICorner,"SquircleGlass",{
Name="GlassLayer",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.72,
ZIndex=10000,
ThemeTag={
ImageColor3="Primary",
},
}),
ac.NewRoundFrame(ag.ElementConfig.UICorner,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.72,
ZIndex=10001,
ThemeTag={
ImageColor3="Outline",
},
}),
})

local aq=ae("Frame",{
Name="SettingsScrim",
Size=UDim2.new(1,0,1,0),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,
Visible=false,
Active=false,
ZIndex=9998,
Parent=ah.ScreenGui,
})

local ar=ae("CanvasGroup",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
ZIndex=10002,
Parent=ap,
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,12),
}),
ae("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

ao.UIElements.Root=ap
ao.UIElements.Scale=ap.Scale
ao.UIElements.Scrim=aq
ao.UIElements.Content=ar
ao.UIElements.GlassLayer=ap.GlassLayer
ao.UIElements.Outline=ap.Outline

local as
local at

local function UpdateRootPosition()
local au=GetViewportSize()
local av=12
local aw=math.floor(math.min(al,math.max(280,au.X-(av*2))))
local ax=math.floor(math.min(am,math.max(300,au.Y-(av*2))))
local ay=Vector2.new(1,0)
local az=au.X-av
local aA=av+ag.Topbar.Height

ap.Size=UDim2.fromOffset(aw,ax)
if as then
as.Size=UDim2.new(1,0,0,math.max(154,ax-142))
end
if at then
at.Size=UDim2.new(1,0,0,math.max(116,ax-238))
end

if ao.Button and ao.Button.AbsoluteSize.X>0 then
local aB=ao.Button.AbsolutePosition
local b=ao.Button.AbsoluteSize
az=aB.X+b.X
aA=aB.Y+b.Y+10
end

if az-aw<av then
az=math.min(au.X-av,av+aw)
end
if aA+ax>au.Y-av then
aA=math.max(av,au.Y-ax-av)
end

ap.AnchorPoint=ay
ap.Position=UDim2.fromOffset(az,aA)
aq.Size=UDim2.fromOffset(au.X,au.Y)
end

local au=ae("Frame",{
Name="Header",
LayoutOrder=1,
Size=UDim2.new(1,0,0,40),
BackgroundTransparency=1,
Parent=ar,
},{
ae("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local av=CreateIcon("settings",nil,17)
ac.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,36,0,36),
ImageTransparency=0.86,
ThemeTag={
ImageColor3="Primary",
},
Parent=au,
},{
av,
ac.NewRoundFrame(999,"SquircleGlass",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.8,
ThemeTag={
ImageColor3="Primary",
},
}),
})
av.Position=UDim2.new(0.5,0,0.5,0)
av.AnchorPoint=Vector2.new(0.5,0.5)
av.ZIndex=10002

local aw=ae("Frame",{
Size=UDim2.new(1,-46,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=au,
},{
ae("UIListLayout",{
Padding=UDim.new(0,2),
FillDirection="Vertical",
}),
})
CreateText(aw,"Settings",16,Enum.FontWeight.Bold,0)
CreateText(aw,"Config, theme and runtime controls",12,Enum.FontWeight.Medium,0.42)

local ax=ac.NewRoundFrame(16,"Squircle",{
Name="SettingsTabs",
LayoutOrder=2,
Size=UDim2.new(1,0,0,38),
ImageTransparency=0.9,
Parent=ar,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,4),
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
}),
ae("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
}),
})

as=ae("Frame",{
Name="Pages",
LayoutOrder=3,
Size=UDim2.new(1,0,0,an),
BackgroundTransparency=1,
ClipsDescendants=true,
Parent=ar,
})

local function CreateTabButton(ay,az,aA,aB)
local b=CreateIcon(aA,nil,14)
local d=ae("TextLabel",{
Name="Title",
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=az,
TextSize=12,
TextTruncate="AtEnd",
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
})

local f=ac.NewRoundFrame(12,"Squircle",{
Name=ay,
LayoutOrder=aB,
Size=UDim2.new(0.3333333333333333,-3,1,0),
ImageTransparency=1,
Parent=ax,
ThemeTag={
ImageColor3="Primary",
},
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
ae("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
b,
d,
},true)

local g=GetImageTarget(b)
ao.TabButtons[ay]={
Button=f,
Label=d,
Icon=g,
}

ad.AttachPress(f,ac,{
Amount=0.98,
})

ac.AddSignal(f.MouseButton1Click,function()
ao:SelectTab(ay)
end)

return f
end

local function CreatePage(ay)
local az=ae("CanvasGroup",{
Name=ay,
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
Visible=false,
Active=false,
Parent=as,
},{
ae("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

ao.Pages[ay]=az
return az
end

local ay=CreatePage"config"
local az=CreatePage"theme"
local aA=CreatePage"about"

CreateTabButton("config","Config","save",1)
CreateTabButton("theme","Theme","palette",2)
CreateTabButton("about","Info","badge-info",3)

local aB=CreatePanel(ay)
CreateText(aB,"Config Profile",13,Enum.FontWeight.Bold,0.05)

local b=ac.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,36),
ImageTransparency=0.9,
ThemeTag={
ImageColor3="ElementBackground",
},
Parent=aB,
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
})

local d=ae("TextBox",{
Name="ConfigName",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ClearTextOnFocus=false,
Text=ak,
PlaceholderText="default",
TextSize=13,
TextXAlignment="Left",
FontFace=Font.new(ac.Font,Enum.FontWeight.Medium),
Parent=b,
ThemeTag={
TextColor3="Text",
PlaceholderColor3="Placeholder",
},
})

local f=CreateText(aB,"No saved configs",12,Enum.FontWeight.Medium,0.45)

local g=ae("Frame",{
Name="HStack",
Size=UDim2.new(1,0,0,34),
BackgroundTransparency=1,
Parent=aB,
},{
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Center",
VerticalAlignment="Center",
}),
})

local h=CreatePanel(ay)
CreateText(h,"Runtime",13,Enum.FontWeight.Bold,0.05)
local i=CreateText(h,"Theme: "..tostring(ah:GetCurrentTheme()),12,Enum.FontWeight.Medium,0.28)
CreateText(h,"Settings use glass morph layers and tabbed pages.",12,Enum.FontWeight.Medium,0.45)

local function GetConfigName()
local l=Trim(d.Text)
return l~=""and l or ak
end

local function RefreshConfigMeta()
local l=ag.ConfigManager
if not l or typeof(l)~="table"then
f.Text="Config is unavailable in this environment"
return
end

local m,p=pcall(function()
return l:AllConfigs()
end)
local r=m and#p or 0
f.Text=r==1 and"1 saved config"or tostring(r).." saved configs"
end

local l=CreateActionButton(g,"Save","save","Primary",function()
local l=ag.ConfigManager
if not l or typeof(l)~="table"then
Notify("Config unavailable","Config save needs file access.","triangle-alert")
return
end

local m=GetConfigName()
local p,r,u=pcall(function()
local p=l:Config(m)
p:Set("theme",ah:GetCurrentTheme())
return p:Save()
end)

if p and r then
RefreshConfigMeta()
Notify("Config saved","Saved '"..m.."'.","check")
else
Notify("Config save failed",tostring(u or r),"triangle-alert")
end
end)
l.Size=UDim2.new(0.5,-4,1,0)

local m=CreateActionButton(g,"Load","download","Secondary",function()
local m=ag.ConfigManager
if not m or typeof(m)~="table"then
Notify("Config unavailable","Config load needs file access.","triangle-alert")
return
end

local p=GetConfigName()
local r,u,v=pcall(function()
local r=m:Config(p)
local u=r:Load()
if u and u.theme then
ah:SetTheme(u.theme)
end
return u
end)

if r and u then
i.Text="Theme: "..tostring(ah:GetCurrentTheme())
Notify("Config loaded","Loaded '"..p.."'.","refresh-cw")
else
Notify("Config load failed",tostring(v or u),"triangle-alert")
end
end)
m.Size=UDim2.new(0.5,-4,1,0)

local p=CreatePanel(az)
CreateText(p,"Theme Picker",13,Enum.FontWeight.Bold,0.05)
CreateText(p,"Tap a theme to apply it instantly.",12,Enum.FontWeight.Medium,0.45)

at=ae("ScrollingFrame",{
Name="ThemeList",
Size=UDim2.new(1,0,0,aj.ThemeListHeight or 214),
BackgroundTransparency=1,
ScrollBarThickness=0,
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
Parent=p,
},{
ae("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

local function UpdateThemeButtons()
local r=ah:GetCurrentTheme()
i.Text="Theme: "..tostring(r)
for u,v in next,ao.ThemeButtons do
local x=u==r
ad.Play(v.Button,"Switch",{ImageTransparency=x and 0.82 or 0.94},nil,nil,"Theme")
ad.Play(v.Label,"Switch",{TextTransparency=x and 0 or 0.24},nil,nil,"Theme")
if v.Check then
ad.Play(v.Check,"Switch",{ImageTransparency=x and 0 or 1},nil,nil,"Theme")
end
end
end

for r,u in next,GetThemeList(ah)do
local v=CreateIcon("check",nil,14)
local x=ac.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,32),
ImageTransparency=0.94,
ThemeTag={
ImageColor3="Primary",
},
Parent=at,
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ae("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
}),
ae("TextLabel",{
Name="Title",
Size=UDim2.new(1,-22,1,0),
BackgroundTransparency=1,
Text=u.Name,
TextSize=13,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
v,
},true)

local z=GetImageTarget(v)
if z then
z.ImageTransparency=1
end

ao.ThemeButtons[u.Key]={
Button=x,
Label=x.Title,
Check=z,
}

ad.AttachPress(x,ac,{
Amount=0.985,
})

ac.AddSignal(x.MouseButton1Click,function()
ah:SetTheme(u.Key)
UpdateThemeButtons()
end)
end

local r=CreatePanel(aA)
CreateText(r,"WindUI Settings",13,Enum.FontWeight.Bold,0.05)
CreateText(r,"Use Config for save/load and Theme for quick visual switching.",12,Enum.FontWeight.Medium,0.36)

local u=ae("Frame",{
Name="VStack",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=r,
},{
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

local function CreateInfoRow(v,x)
return ac.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,34),
ImageTransparency=0.94,
ThemeTag={
ImageColor3="ElementBackground",
},
Parent=u,
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ae("TextLabel",{
Size=UDim2.new(0.44,0,1,0),
BackgroundTransparency=1,
Text=v,
TextSize=12,
TextXAlignment="Left",
TextTransparency=0.38,
FontFace=Font.new(ac.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
}),
ae("TextLabel",{
Size=UDim2.new(0.56,0,1,0),
BackgroundTransparency=1,
Text=x,
TextSize=12,
TextXAlignment="Right",
TextTruncate="AtEnd",
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
})
end

CreateInfoRow("Folder",tostring(ag.Folder or"WindUI"))
CreateInfoRow("Topbar",tostring(ag.Topbar.ButtonsType or"Default"))
CreateInfoRow("Motion",tostring(ad:GetConfig().Preset))

function ao.SetButton(v,x)
ao.Button=x
end

function ao.SelectTab(v,x)
if not ao.Pages[x]then
return
end

ao.SelectedTab=x
for z,A in next,ao.TabButtons do
local B=z==x
ad.Play(A.Button,"Switch",{ImageTransparency=B and 0.82 or 1},nil,nil,"SettingsTab")
ad.Play(A.Label,"Switch",{TextTransparency=B and 0 or 0.3},nil,nil,"SettingsTab")
if A.Icon then
ad.Play(A.Icon,"Switch",{ImageTransparency=B and 0 or 0.35},nil,nil,"SettingsTab")
end
end

for z,A in next,ao.Pages do
local B=z==x
A.Active=B
if B then
A.Visible=true
A.GroupTransparency=1
ad.Play(A,"Reveal",{GroupTransparency=0},nil,nil,"SettingsPage")
else
A.Visible=false
A.GroupTransparency=1
end
end
end

function ao.OpenMenu(v)
if ao.Open then
return
end

ao.Open=true
ao.Token=ao.Token+1
RefreshConfigMeta()
UpdateThemeButtons()
ao:SelectTab(ao.SelectedTab)
UpdateRootPosition()
ap.Visible=true
ap.Active=true
ao.UIElements.Scrim.Visible=true
ap.ImageTransparency=1
ao.UIElements.Scrim.BackgroundTransparency=1
ao.UIElements.Content.GroupTransparency=1
ao.UIElements.GlassLayer.ImageTransparency=1
ao.UIElements.Outline.ImageTransparency=1
ao.UIElements.Scale.Scale=0.98
ad.Play(ap,"DropdownOpen",{ImageTransparency=0.18},nil,nil,"Settings")
ad.Play(ao.UIElements.Scrim,"DropdownOpen",{BackgroundTransparency=aj.ScrimTransparency or 0.72},nil,nil,"SettingsScrim")
ad.Play(ao.UIElements.Content,"DropdownOpen",{GroupTransparency=0},nil,nil,"SettingsContent")
ad.Play(ao.UIElements.GlassLayer,"DropdownOpen",{ImageTransparency=0.78},nil,nil,"SettingsGlass")
ad.Play(ao.UIElements.Outline,"DropdownOpen",{ImageTransparency=0.72},nil,nil,"SettingsOutline")
ad.Play(ao.UIElements.Scale,"DropdownOpen",{Scale=1},nil,nil,"SettingsScale")
end

function ao.CloseMenu(v)
if not ao.Open then
return
end

ao.Open=false
ao.Token=ao.Token+1
local x=ao.Token
ap.Active=false
ad.Play(ap,"DropdownClose",{ImageTransparency=1},nil,nil,"Settings")
ad.Play(ao.UIElements.Scrim,"DropdownClose",{BackgroundTransparency=1},nil,nil,"SettingsScrim")
ad.Play(ao.UIElements.Content,"DropdownClose",{GroupTransparency=1},nil,nil,"SettingsContent")
ad.Play(ao.UIElements.GlassLayer,"DropdownClose",{ImageTransparency=1},nil,nil,"SettingsGlass")
ad.Play(ao.UIElements.Outline,"DropdownClose",{ImageTransparency=1},nil,nil,"SettingsOutline")
ad.Play(ao.UIElements.Scale,"DropdownClose",{Scale=0.98},nil,nil,"SettingsScale")
task.delay(ad.GetDuration"DropdownClose",function()
if x==ao.Token then
ap.Visible=false
ao.UIElements.Scrim.Visible=false
end
end)
end

function ao.Toggle(v)
if ao.Open then
ao:CloseMenu()
else
ao:OpenMenu()
end
end

ac.AddSignal(aa.InputBegan,function(v)
if not ao.Open then
return
end
if v.UserInputType~=Enum.UserInputType.MouseButton1 and v.UserInputType~=Enum.UserInputType.Touch then
return
end

if ContainsPoint(ap,v.Position)or ContainsPoint(ao.Button,v.Position)then
return
end

ao:CloseMenu()
end)

RefreshConfigMeta()
UpdateThemeButtons()
ao:SelectTab"config"

return ao
end

return af end function a.F()

local aa=game:GetService"UserInputService"
local ab=game:GetService"Workspace"

local ac=a.load'd'
local ad=a.load'e'
local ae=ac.New

local af={}

local function ContainsPoint(ag,ah)
if typeof(ag)~="Instance"or not ag.Visible then
return false
end

local ai=ag.AbsolutePosition
local aj=ag.AbsoluteSize

return ah.X>=ai.X
and ah.X<=ai.X+aj.X
and ah.Y>=ai.Y
and ah.Y<=ai.Y+aj.Y
end

local function NormalizeKey(ag)
if typeof(ag)=="EnumItem"then
return ag.Name,ag
end
if typeof(ag)=="string"and Enum.KeyCode[ag]then
return ag,Enum.KeyCode[ag]
end
return"None",nil
end

function af.New(ag,ah,ai)
local aj=typeof(ag.KeyBindMenu)=="table"and ag.KeyBindMenu or{}
local ak=(aa.TouchEnabled and not aa.KeyboardEnabled)or ag.IsPC==false
local al=aj.Compact==true or(aj.Compact~=false and ak)
local am=aj.Width or(al and 330 or 326)
local an=aj.Height or(al and 300 or 354)
local ao=al and 10 or 14
local ap=al and 6 or 10
local aq=aj.QuickKeys or{"RightShift","F","LeftControl"}
local ar={
Open=false,
Button=nil,
Token=0,
Capturing=false,
UserMoved=false,
StoredPosition=nil,
TargetPosition=nil,
UIElements={},
}

local function Notify(as,at,au)
if ah.Notify then
ah:Notify{
Title=as,
Content=at,
Icon=au,
}
end
end

local function GetViewportSize()
local as=ab.CurrentCamera
return as and as.ViewportSize or Vector2.new(1280,720)
end

local function GetScrimTransparency()
if aj.Scrim==false or aj.ShowScrim==false then
return 1
end
if aj.ScrimTransparency~=nil then
return aj.ScrimTransparency
end
return al and 1 or 0.78
end

local function CreateIcon(as,at,au)
local av=ac.Image(as,as,0,ag.Folder,"KeyBindMenu",true,true,"Icon")
av.Size=UDim2.new(0,au or 16,0,au or 16)
av.Parent=at
return av
end

local function CreateText(as,at,au,av,aw)
return ae("TextLabel",{
BackgroundTransparency=1,
Text=at or"",
TextSize=au or 14,
TextTransparency=aw or 0,
TextXAlignment="Left",
TextWrapped=true,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Parent=as,
FontFace=Font.new(ac.Font,av or Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})
end

local as=ac.NewRoundFrame(ag.ElementConfig.UICorner,"Squircle",{
Name="KeyBindMenu",
Size=UDim2.new(0,am,0,an),
AnchorPoint=al and Vector2.new(0.5,1)or Vector2.new(1,0),
Position=UDim2.fromOffset(0,0),
ImageTransparency=1,
Visible=false,
Active=false,
ClipsDescendants=true,
ZIndex=10020,
Parent=ah.ScreenGui,
ThemeTag={
ImageColor3="Background",
},
},{
ae("UIScale",{
Name="Scale",
Scale=0.98,
}),
ac.NewRoundFrame(ag.ElementConfig.UICorner,"SquircleGlass",{
Name="GlassLayer",
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ZIndex=10020,
ThemeTag={
ImageColor3="Primary",
},
}),
ac.NewRoundFrame(ag.ElementConfig.UICorner,"SquircleOutline",{
Name="Outline",
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ZIndex=10021,
ThemeTag={
ImageColor3="Outline",
},
}),
})

local at=ae("Frame",{
Name="KeyBindScrim",
Size=UDim2.new(1,0,1,0),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,
Visible=false,
Active=false,
ZIndex=10018,
Parent=ah.ScreenGui,
})

local au=ae("CanvasGroup",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
ZIndex=10022,
Parent=as,
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,ao),
PaddingLeft=UDim.new(0,ao),
PaddingRight=UDim.new(0,ao),
PaddingBottom=UDim.new(0,ao),
}),
ae("UIListLayout",{
Padding=UDim.new(0,ap),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

ar.UIElements.Root=as
ar.UIElements.Scale=as.Scale
ar.UIElements.Scrim=at
ar.UIElements.Content=au
ar.UIElements.GlassLayer=as.GlassLayer
ar.UIElements.Outline=as.Outline

local function IsImageBackground(av)
if typeof(av)~="string"then
return false
end
if string.sub(av,1,1)=="#"then
return false
end
if string.match(av,"^video:")then
return false
end
return av~=""
end

local function GetBackgroundKind(av)
if av==nil or av==false then
return nil,nil,{}
end

if typeof(av)=="table"then
local aw=av.Type or av.Kind or av.Mode
if av.Video or aw=="Video"or aw=="video"then
return"Video",av.Video or av.Url or av.URL or av.Source or av.Asset or av.Path,av
end
if av.Image or av.Url or av.URL or av.Asset or av.Path or aw=="Image"or aw=="image"then
return"Image",av.Image or av.Url or av.URL or av.Asset or av.Path or av.Source,av
end
if av.Gradient then
return"Gradient",av.Gradient,av
end
if aw=="Gradient"or aw=="gradient"or av.Rotation~=nil or av.Offset~=nil then
return"Gradient",av,av
end
if typeof(av.Color)=="ColorSequence"or typeof(av.Transparency)=="NumberSequence"then
return"Gradient",av,av
end
return nil,nil,av
end

if typeof(av)=="string"then
local aw=string.match(av,"^video:(.+)")
local ax=av:match"^([^?#]+)"or av
if aw or string.match(ax:lower(),"%.webm$")then
return"Video",aw or av,{}
end
if IsImageBackground(av)then
return"Image",av,{}
end
end

return nil,nil,{}
end

local function FindWindowBackgroundVideo()
local av=ag.UIElements and ag.UIElements.Main
local aw=av and av:FindFirstChild"Background"
local ax=aw and aw:FindFirstChild"BackgroundVideo"
if ax and ax:IsA"VideoFrame"then
return ax.Video
end
return nil
end

local function ApplyGradientProperty(av,aw,ax)
if aw=="Transparency"and typeof(ax)=="number"then
return
end
pcall(function()
av[aw]=ax
end)
end

local function ApplyBackgroundMedia()
if aj.UseWindowBackground==false then
return
end

local av,aw=GetBackgroundKind(aj.Background)
local ax,ay=GetBackgroundKind(ag.Background)
local az=aj.BackgroundGradient
or(av=="Gradient"and aw)
or ag.BackgroundGradient
or(ax=="Gradient"and ay)
local aA=aj.BackgroundImage
or(av=="Image"and aw)
or(ax=="Image"and ay)
local aB=(av=="Video"and aw)
or(ax=="Video"and(FindWindowBackgroundVideo()or ay))

if aA then
ar.UIElements.BackgroundImage=ae("ImageLabel",{
Name="BackgroundImage",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=tostring(aA),
ImageTransparency=aj.BackgroundImageTransparency or ag.BackgroundImageTransparency or 0.46,
ScaleType=aj.BackgroundScaleType or ag.BackgroundScaleType or"Crop",
ZIndex=10019,
Parent=as,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,ag.ElementConfig.UICorner),
}),
})
end

if aB then
ar.UIElements.BackgroundVideo=ae("VideoFrame",{
Name="BackgroundVideo",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Video=tostring(aB),
Looped=true,
Volume=0,
ZIndex=10019,
Parent=as,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,ag.ElementConfig.UICorner),
}),
})
ar.UIElements.BackgroundVideo:Play()
end

if az then
local b=ae"UIGradient"
for d,f in next,az do
ApplyGradientProperty(b,d,f)
end

ar.UIElements.BackgroundGradient=ac.NewRoundFrame(ag.ElementConfig.UICorner,"Squircle",{
Name="BackgroundGradient",
Size=UDim2.new(1,0,1,0),
ImageTransparency=aj.BackgroundGradientTransparency
or aj.BackgroundOverlayTransparency
or ag.BackgroundOverlayTransparency
or 0.55,
ZIndex=10019,
Parent=as,
},{
b,
})
end
end

ApplyBackgroundMedia()

local av=ae("Frame",{
Name="DragHandle",
Size=UDim2.new(1,0,0,8),
BackgroundTransparency=1,
LayoutOrder=0,
Visible=al,
Parent=au,
},{
ae("Frame",{
Size=UDim2.new(0,42,0,4),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=0.72,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
})

local aw=ae("Frame",{
Name="Header",
Size=UDim2.new(1,0,0,al and 34 or 42),
BackgroundTransparency=1,
Active=true,
LayoutOrder=1,
Parent=au,
},{
ae("UIListLayout",{
Padding=UDim.new(0,al and 8 or 10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local ax=CreateIcon("keyboard",nil,al and 15 or 18)
ac.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,al and 32 or 38,0,al and 32 or 38),
ImageTransparency=0.86,
Parent=aw,
ThemeTag={
ImageColor3="Primary",
},
},{
ax,
})
ax.Position=UDim2.new(0.5,0,0.5,0)
ax.AnchorPoint=Vector2.new(0.5,0.5)

local ay=ae("Frame",{
Size=UDim2.new(1,al and-78 or-48,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aw,
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,2),
}),
})
CreateText(ay,aj.Title or(al and"Keybind"or"KeyBind Menu"),al and 14 or 16,Enum.FontWeight.Bold,0)
local az=CreateText(
ay,
aj.Desc or(al and"Mobile quick toggle controls."or"Set the window toggle shortcut."),
al and 11 or 12,
Enum.FontWeight.Medium,
0.42
)
if aj.HideDesc~=nil then
az.Visible=not aj.HideDesc
else
az.Visible=not al
end

local aA=CreateIcon("x",nil,13)
local aB=ac.NewRoundFrame(999,"Squircle",{
Size=al and UDim2.new(0,28,0,28)or UDim2.new(0,0,0,0),
ImageTransparency=0.9,
Visible=al,
Parent=aw,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
aA,
},true)
aA.Position=UDim2.new(0.5,0,0.5,0)
aA.AnchorPoint=Vector2.new(0.5,0.5)

ac.AddSignal(aB.MouseButton1Click,function()
ar:CloseMenu()
end)

local b=ac.NewRoundFrame(16,"Squircle",{
Size=UDim2.new(1,0,0,al and 48 or 58),
ImageTransparency=al and 0.8 or 0.88,
LayoutOrder=2,
Parent=au,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIStroke",{
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=al and 0.8 or 0.88,
Thickness=1,
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local d=NormalizeKey(ag.ToggleKey or aj.DefaultKey or aj.Value)
ae("TextLabel",{
Size=UDim2.new(0.4,0,1,0),
BackgroundTransparency=1,
Text="Current",
TextSize=al and 11 or 12,
TextXAlignment="Left",
TextTransparency=0.44,
FontFace=Font.new(ac.Font,Enum.FontWeight.Medium),
Parent=b,
ThemeTag={
TextColor3="Text",
},
})

local f=ae("TextLabel",{
Size=UDim2.new(0.6,0,1,0),
BackgroundTransparency=1,
Text=d,
TextSize=al and 16 or 18,
TextXAlignment="Right",
FontFace=Font.new(ac.Font,Enum.FontWeight.Bold),
Parent=b,
ThemeTag={
TextColor3="Text",
},
})

local g=ac.NewRoundFrame(16,"Squircle",{
Name="ElementBindings",
Size=UDim2.new(1,0,0,al and 84 or 94),
ImageTransparency=al and 0.86 or 0.9,
LayoutOrder=3,
Parent=au,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIStroke",{
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=al and 0.82 or 0.9,
Thickness=1,
}),
ae("UIPadding",{
PaddingTop=UDim.new(0,8),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,8),
}),
ae("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Vertical",
SortOrder="LayoutOrder",
}),
})

local h=ae("TextLabel",{
Name="Header",
Size=UDim2.new(1,0,0,14),
BackgroundTransparency=1,
Text="Element keybinds",
TextSize=al and 11 or 12,
TextXAlignment="Left",
TextTransparency=0.3,
LayoutOrder=1,
Parent=g,
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
})

local i=ae("ScrollingFrame",{
Name="List",
Size=UDim2.new(1,0,1,-19),
BackgroundTransparency=1,
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ScrollBarThickness=0,
LayoutOrder=2,
Parent=g,
},{
ae("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Vertical",
SortOrder="LayoutOrder",
}),
})

local l=ae("TextLabel",{
Name="Empty",
Size=UDim2.new(1,0,0,28),
BackgroundTransparency=1,
Text="No element keybinds",
TextSize=al and 11 or 12,
TextTransparency=0.48,
FontFace=Font.new(ac.Font,Enum.FontWeight.Medium),
Parent=i,
ThemeTag={
TextColor3="Text",
},
})

local m=ae("Frame",{
Size=UDim2.new(1,0,0,al and 38 or 38),
BackgroundTransparency=1,
LayoutOrder=4,
Parent=au,
},{
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Center",
}),
})

local function CreateButton(p,r,u,v,x)
local z=ac.NewRoundFrame(14,"Squircle",{
Size=UDim2.new(0.5,-4,1,0),
ImageTransparency=v=="Primary"and(al and 0.08 or 0.18)or(al and 0.84 or 0.9),
Parent=p,
ThemeTag={
ImageColor3=v=="Primary"and"Primary"or"ElementBackground",
},
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,al and 8 or 10),
PaddingRight=UDim.new(0,al and 8 or 10),
}),
ae("UIListLayout",{
Padding=UDim.new(0,al and 5 or 7),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
u and CreateIcon(u,nil,al and 13 or 15)or nil,
ae("TextLabel",{
Name="Title",
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=r,
TextSize=al and 12 or 13,
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
},true)

ad.AttachPress(z,ac,{
Amount=0.97,
})

ac.AddSignal(z.MouseButton1Click,function()
ac.SafeCallback(x)
end)

return z
end

local p

local function ApplyKey(r,u)
local v,x=NormalizeKey(r)
ag:SetToggleKey(x)
f.Text=v
if not u then
Notify("Keybind updated",x and("Toggle key: "..v)or"Toggle key cleared.","keyboard")
end
end

local function StopCapture()
ar.Capturing=false
if p then
p:Disconnect()
p=nil
end
end

function ar.Capture(r)
if ar.Capturing then
return
end

ar.Capturing=true
f.Text="Press key..."

p=aa.InputBegan:Connect(function(u)
if u.UserInputType~=Enum.UserInputType.Keyboard then
return
end
if u.KeyCode==Enum.KeyCode.Unknown then
return
end
if u.KeyCode==Enum.KeyCode.Escape then
StopCapture()
local v=NormalizeKey(ag.ToggleKey)
f.Text=v
return
end

ApplyKey(u.KeyCode)
StopCapture()
end)
end

local r=CreateButton(m,al and"Bind"or"Set Key","scan-line","Primary",function()
ar:Capture()
end)
local u=CreateButton(m,"Clear","x","Secondary",function()
StopCapture()
ApplyKey(nil)
end)

local v=ae("Frame",{
Name="QuickKeys",
Size=UDim2.new(1,0,0,al and 34 or 32),
BackgroundTransparency=1,
LayoutOrder=5,
Parent=au,
},{
ae("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Center",
}),
})

local function ShortKeyName(x)
local z=tostring(x)
if not al then
return z
end

z=z:gsub("Right","R")
z=z:gsub("Left","L")
z=z:gsub("Control","Ctrl")
return z
end

for x,z in next,aq do local
A, B=NormalizeKey(z)
if B then
CreateButton(v,ShortKeyName(z),nil,"Secondary",function()
StopCapture()
ApplyKey(B)
end).Size=UDim2.new(1/#aq,-4,1,0)
end
end

local x={}
local z={}

local function ClearElementRows()
for A,B in next,z do
if B then
B:Disconnect()
end
end
for A,B in next,x do
if B and B.Destroy then
B:Destroy()
end
end
for A in next,z do
z[A]=nil
end
for A in next,x do
x[A]=nil
end
end

local function NormalizeElementKey(A)
local B,C=NormalizeKey(A)
if C then
return ShortKeyName(B),C
end
if typeof(A)=="string"and A~=""then
return ShortKeyName(A),nil
end
return nil,nil
end

local function GetElementKeybind(A)
if typeof(A)~="table"then
return nil,nil
end

local B=A.Keybind
or A.KeyBind
or A.Shortcut
or A.Bind
or A.Hotkey
or(A.__type=="Keybind"and A.Value)
return NormalizeElementKey(B)
end

local function GetElementIcon(A)
if A.__type=="Toggle"then
return"toggle-right"
elseif A.__type=="Button"then
return"mouse-pointer-click"
end
return"keyboard"
end

local function ActivateElement(A,B)
if typeof(A)~="table"then
return
end
if A.Locked then
return
end
if A.__type=="Toggle"and A.Toggle then
A:Toggle()
return
end
if A.__type=="Button"and A.Press then
A:Press()
return
end
if A.Callback then
ac.SafeCallback(A.Callback,B)
end
end

local function CreateElementRow(A,B,C)
local F=ac.NewRoundFrame(12,"Squircle",{
Name="ElementBind",
Size=UDim2.new(1,0,0,al and 28 or 32),
ImageTransparency=al and 0.9 or 0.92,
LayoutOrder=C,
Parent=i,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
ae("UIListLayout",{
Padding=UDim.new(0,7),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
CreateIcon(GetElementIcon(A),nil,al and 13 or 14),
ae("TextLabel",{
Name="Title",
Size=UDim2.new(1,-84,1,0),
BackgroundTransparency=1,
Text=A.Title or A.__type or"Element",
TextSize=al and 11 or 12,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
ae("TextLabel",{
Name="Key",
Size=UDim2.new(0,56,0,al and 20 or 22),
BackgroundTransparency=1,
Text=B,
TextSize=al and 11 or 12,
TextXAlignment="Right",
TextTransparency=0.14,
FontFace=Font.new(ac.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Text",
},
}),
},true)

ad.AttachPress(F,ac,{
Amount=0.98,
})

local G=F.MouseButton1Click:Connect(function()
ActivateElement(A,B)
end)

table.insert(z,G)
table.insert(x,F)
end

local function RenderElementBindings()
ClearElementRows()

local A=0
for B,C in next,ag.AllElements or{}do
local F=GetElementKeybind(C)
if F then
A+=1
CreateElementRow(C,F,A)
end
end

l.Visible=A==0
h.Text=A>0 and("Element keybinds ("..A..")")or"Element keybinds"
end

if ag.ToggleKey==nil and aj.DefaultKey and aj.ApplyDefault~=false then local
A, B=NormalizeKey(aj.DefaultKey)
if B then
ApplyKey(B,true)
end
end

local function UpdateRootPosition()
local A=GetViewportSize()
local B=12

if al then
am=math.min(aj.Width or 330,math.max(240,A.X-(B*2)))
an=aj.Height or 300
as.Size=UDim2.fromOffset(am,an)
as.AnchorPoint=Vector2.new(0.5,1)
ar.TargetPosition=UDim2.fromOffset(A.X/2,A.Y-B)
as.Position=ar.TargetPosition
at.Size=UDim2.fromOffset(A.X,A.Y)

if ar.UserMoved and ar.StoredPosition then
as.Position=ar.StoredPosition
ar.TargetPosition=ar.StoredPosition
end

return
end

local C=A.X-B
local F=B+ag.Topbar.Height

if ar.Button and ar.Button.AbsoluteSize.X>0 then
local G=ar.Button.AbsolutePosition
local H=ar.Button.AbsoluteSize
C=G.X+H.X
F=G.Y+H.Y+10
end

if C-am<B then
C=math.min(A.X-B,B+am)
end
if F+an>A.Y-B then
F=math.max(B,A.Y-an-B)
end

as.Position=UDim2.fromOffset(C,F)
ar.TargetPosition=as.Position
at.Size=UDim2.fromOffset(A.X,A.Y)

if ar.UserMoved and ar.StoredPosition then
as.Position=ar.StoredPosition
end
end

function ar.SetButton(A,B)
ar.Button=B
end

local A=ac.Drag(as,{aw,av},function(A)
if not A then
ar.UserMoved=true
ar.StoredPosition=as.Position
end
end)
ar.UIElements.Drag=A

function ar.OpenMenu(B)
if ar.Open then
return
end

ar.Open=true
ar.Token+=1
RenderElementBindings()
UpdateRootPosition()
local C=ar.TargetPosition or as.Position
as.Visible=true
as.Active=true
at.Visible=true
if al then
as.Position=UDim2.new(
C.X.Scale,
C.X.Offset,
C.Y.Scale,
C.Y.Offset+18
)
end
as.ImageTransparency=1
au.GroupTransparency=1
as.GlassLayer.ImageTransparency=1
as.Outline.ImageTransparency=1
as.Scale.Scale=0.98
at.BackgroundTransparency=1
ad.Play(as,"DropdownOpen",{
ImageTransparency=aj.BackgroundTransparency or(al and 0.48 or 0.18),
Position=C,
},nil,nil,"KeyBindMenu")
ad.Play(au,"DropdownOpen",{GroupTransparency=0},nil,nil,"KeyBindContent")
ad.Play(as.GlassLayer,"DropdownOpen",{ImageTransparency=al and 0.92 or 0.78},nil,nil,"KeyBindGlass")
ad.Play(as.Outline,"DropdownOpen",{ImageTransparency=al and 0.48 or 0.72},nil,nil,"KeyBindOutline")
ad.Play(as.Scale,"DropdownOpen",{Scale=1},nil,nil,"KeyBindScale")
ad.Play(
at,
"DropdownOpen",
{BackgroundTransparency=GetScrimTransparency()},
nil,
nil,
"KeyBindScrim"
)
end

function ar.CloseMenu(B)
if not ar.Open then
return
end

ar.Open=false
ar.Token+=1
local C=ar.Token
StopCapture()
as.Active=false
local F=as.Position
if al then
F=UDim2.new(
as.Position.X.Scale,
as.Position.X.Offset,
as.Position.Y.Scale,
as.Position.Y.Offset+18
)
end
ad.Play(as,"DropdownClose",{ImageTransparency=1,Position=F},nil,nil,"KeyBindMenu")
ad.Play(au,"DropdownClose",{GroupTransparency=1},nil,nil,"KeyBindContent")
ad.Play(as.GlassLayer,"DropdownClose",{ImageTransparency=1},nil,nil,"KeyBindGlass")
ad.Play(as.Outline,"DropdownClose",{ImageTransparency=1},nil,nil,"KeyBindOutline")
ad.Play(as.Scale,"DropdownClose",{Scale=0.98},nil,nil,"KeyBindScale")
ad.Play(at,"DropdownClose",{BackgroundTransparency=1},nil,nil,"KeyBindScrim")
task.delay(ad.GetDuration"DropdownClose",function()
if C==ar.Token then
as.Visible=false
at.Visible=false
end
end)
end

function ar.Toggle(B)
if ar.Open then
ar:CloseMenu()
else
ar:OpenMenu()
end
end

ac.AddSignal(aa.InputBegan,function(B)
if not ar.Open then
return
end
if B.UserInputType~=Enum.UserInputType.MouseButton1 and B.UserInputType~=Enum.UserInputType.Touch then
return
end
if ContainsPoint(as,B.Position)or ContainsPoint(ar.Button,B.Position)then
return
end
ar:CloseMenu()
end)

ar.UIElements.CurrentKey=f
ar.UIElements.SetButton=r
ar.UIElements.ClearButton=u

return ar
end

return af end function a.G()

local aa={}

local ab=a.load'd'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={
Container=nil,
TooltipSize=16,

TooltipArrowSizeX=ai=="Small"and 16 or 24,
TooltipArrowSizeY=ai=="Small"and 6 or 9,

PaddingX=ai=="Small"and 12 or 14,
PaddingY=ai=="Small"and 7 or 9,

Radius=999,

TitleFrame=nil,
}

ah=ah or""
aj=aj~=false

local al=ac("TextLabel",{
AutomaticSize="XY",
TextWrapped=aj,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=ae,
TextSize=ai=="Small"and 15 or 17,
TextTransparency=1,
ThemeTag={
TextColor3="Tooltip"..ah.."Text",
}
})

ak.TitleFrame=al

local am=ac("UIScale",{
Scale=.9
})

local an=ac("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=af,

Visible=false
},{
ac("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ac("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=ag,
Name="Arrow",
},{
ac("ImageLabel",{
Size=UDim2.new(0,ak.TooltipArrowSizeX,0,ak.TooltipArrowSizeY),
BackgroundTransparency=1,

Image="rbxassetid://105854070513330",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
},{










}),
}),
ab.NewRoundFrame(ak.Radius,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
ImageTransparency=1,
Name="Background",
},{



ac("Frame",{



AutomaticSize="XY",
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ac("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

al,
ac("UIPadding",{
PaddingTop=UDim.new(0,ak.PaddingY),
PaddingLeft=UDim.new(0,ak.PaddingX),
PaddingRight=UDim.new(0,ak.PaddingX),
PaddingBottom=UDim.new(0,ak.PaddingY),
}),
})
}),
am,
ac("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ak.Container=an

function ak.Open(ao)
an.Visible=true


ad(an.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.22,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ak.Close(ao,ap)

ad(an.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()

ap=ap~=false
if ap then
task.wait(.35)

an.Visible=false
an:Destroy()
end
end

return ak
end



return aa end function a.H()
local aa=game:GetService"TweenService"

local ab=a.load'd'
local ac=a.load'e'
local ad=ab.New

local ae={}

local function GetImageTarget(af)
if typeof(af)~="Instance"then
return nil
end

if af:IsA"ImageLabel"or af:IsA"ImageButton"then
return af
end

return af:FindFirstChildWhichIsA("ImageLabel",true)or af:FindFirstChildWhichIsA("ImageButton",true)
end

local function AsColor(af,ag)
if typeof(af)=="Color3"then
return af
end

if typeof(af)=="string"then
local ah,ai=pcall(function()
return Color3.fromHex(af)
end)
if ah then
return ai
end
end

return ag
end

local function NewGradient(af,ag,ah,ai)
return ad("UIGradient",{
Rotation=af or 0,
Offset=ag or Vector2.new(0,0),
Color=ColorSequence.new(ah),
Transparency=NumberSequence.new(ai),
})
end

function ae.Apply(af,ag)
if typeof(af)~="Instance"then
return nil
end

ag=typeof(ag)=="table"and ag or{}

local ah=ag.Corner or 16
local ai=ag.ZIndex or af.ZIndex or 1
local aj=ag.Compact==true
local ak=ag.Animated~=false

local al=AsColor(ag.EdgeColor,Color3.fromRGB(255,215,92))
local am=AsColor(ag.DeepColor,Color3.fromRGB(84,54,10))
local an=AsColor(ag.MidColor,Color3.fromRGB(206,147,39))
local ao=AsColor(ag.HotColor,Color3.fromRGB(255,241,166))

pcall(function()
af.ClipsDescendants=true
end)

local ap=ad("Frame",{
Name=ag.Name or"GoldenEffect",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Active=false,
ZIndex=ai+20,
Parent=af,
})

local aq=ab.NewRoundFrame(ah,"Squircle",{
Name="GoldenFill",
Size=UDim2.new(1,0,1,0),
ImageColor3=am,
ImageTransparency=ag.FillTransparency or 0.76,
Active=false,
ZIndex=ai+20,
Parent=ap,
},{
NewGradient(24,Vector2.new(-0.1,0),{
ColorSequenceKeypoint.new(0,am),
ColorSequenceKeypoint.new(0.42,an),
ColorSequenceKeypoint.new(0.72,ao),
ColorSequenceKeypoint.new(1,am),
},{
NumberSequenceKeypoint.new(0,0.18),
NumberSequenceKeypoint.new(0.52,0.04),
NumberSequenceKeypoint.new(1,0.22),
}),
})

local ar=ab.NewRoundFrame(ah,"SquircleOutline",{
Name="GoldenOutline",
Size=UDim2.new(1,0,1,0),
ImageColor3=al,
ImageTransparency=ag.OutlineTransparency or 0.22,
Active=false,
ZIndex=ai+22,
Parent=ap,
},{
NewGradient(35,Vector2.new(0,0),{
ColorSequenceKeypoint.new(0,al),
ColorSequenceKeypoint.new(0.5,ao),
ColorSequenceKeypoint.new(1,an),
},{
NumberSequenceKeypoint.new(0,0.04),
NumberSequenceKeypoint.new(0.48,0),
NumberSequenceKeypoint.new(1,0.12),
}),
})

local as=NewGradient(18,Vector2.new(-1.15,0),{
ColorSequenceKeypoint.new(0,ao),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,ao),
},{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.42,1),
NumberSequenceKeypoint.new(0.5,0.15),
NumberSequenceKeypoint.new(0.58,1),
NumberSequenceKeypoint.new(1,1),
})

local at=ab.NewRoundFrame(ah,"Squircle",{
Name="GoldenSheen",
Size=UDim2.new(1,0,1,0),
ImageColor3=ao,
ImageTransparency=ag.SheenTransparency or 0.74,
Active=false,
ZIndex=ai+23,
Parent=ap,
},{
as,
})

local au=ad("Frame",{
Name="Sparkles",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Active=false,
ClipsDescendants=true,
ZIndex=ai+24,
Parent=ap,
})

local av={}
local aw=ag.Points or{
{0.16,0.28,0},
{0.76,0.22,0.42},
{0.34,0.72,0.82},
{0.88,0.64,1.12},
}

for ax,ay in ipairs(aw)do
local az=aj and 9 or 12
local aA=ab.Image("sparkles","GoldenSparkle"..ax,0,"Temp","GoldenEffect",false,true)
aA.Name="Sparkle"..ax
aA.Size=UDim2.fromOffset(az,az)
aA.AnchorPoint=Vector2.new(0.5,0.5)
aA.Position=UDim2.fromScale(ay[1],ay[2])
aA.BackgroundTransparency=1
aA.ZIndex=ai+24
aA.Parent=au

local aB=GetImageTarget(aA)
if aB then
aB.ImageColor3=ao
aB.ImageTransparency=0.62
aB.ZIndex=ai+24
end

local b=ad("UIScale",{
Scale=0.72,
Parent=aA,
})

table.insert(av,{
Frame=aA,
Image=aB,
Scale=b,
Delay=ay[3]or 0,
})
end

local ax={
Root=ap,
Fill=aq,
Outline=ar,
Sheen=at,
Sparkles=av,
Running=true,
}

function ax.Destroy(ay)
ay.Running=false
if ay.Root then
ay.Root:Destroy()
end
end

if ac:IsEnabled()and not ac.Reduced and ak then
task.spawn(function()
while ax.Running and ap.Parent do
as.Offset=Vector2.new(-1.15,0)
local ay=aa:Create(
as,
TweenInfo.new(ag.SheenDuration or 1.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
{Offset=Vector2.new(1.15,0)}
)
ay:Play()
ay.Completed:Wait()
task.wait(ag.SheenPause or 0.42)
end
end)

for ay,az in ipairs(av)do
task.spawn(function()
task.wait(az.Delay)
while ax.Running and ap.Parent and az.Frame.Parent do
az.Scale.Scale=0.72
az.Frame.Rotation=-18
if az.Image then
az.Image.ImageTransparency=0.68
end

local aA=aa:Create(
az.Scale,
TweenInfo.new(0.34,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
{Scale=1.12}
)
local aB=az.Image and aa:Create(
az.Image,
TweenInfo.new(0.22,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
{ImageTransparency=0.12}
)
local b=aa:Create(
az.Frame,
TweenInfo.new(0.58,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
{Rotation=22}
)

aA:Play()
b:Play()
if aB then
aB:Play()
end
aA.Completed:Wait()

local d=aa:Create(
az.Scale,
TweenInfo.new(0.24,Enum.EasingStyle.Sine,Enum.EasingDirection.In),
{Scale=0.78}
)
local f=az.Image and aa:Create(
az.Image,
TweenInfo.new(0.28,Enum.EasingStyle.Sine,Enum.EasingDirection.In),
{ImageTransparency=0.72}
)
d:Play()
if f then
f:Play()
end
d.Completed:Wait()
task.wait(ag.SparklePause or 1.2)
end
end)
end
end

return ax
end

return ae end function a.I()

game:GetService"ReplicatedStorage"
local aa=a.load'd'
local ab=a.load'e'
local ac=aa.New
local ad=aa.NewRoundFrame
local ae=a.load'H'

local af=(cloneref or clonereference or function(af)
return af
end)

af(game:GetService"UserInputService")

local ag=a.load'A'

local function Color3ToHSB(ah)
local ai,aj,ak=ah.R,ah.G,ah.B
local al=math.max(ai,aj,ak)
local am=math.min(ai,aj,ak)
local an=al-am

local ao=0
if an~=0 then
if al==ai then
ao=(aj-ak)/an%6
elseif al==aj then
ao=(ak-ai)/an+2
else
ao=(ai-aj)/an+4
end
ao=ao*60
else
ao=0
end

local ap=(al==0)and 0 or(an/al)
local aq=al

return{
h=math.floor(ao+0.5),
s=ap,
b=aq,
}
end

local function GetPerceivedBrightness(ah)
local ai=ah.R
local aj=ah.G
local ak=ah.B
return 0.299*ai+0.587*aj+0.114*ak
end

local function GetTextColorForHSB(ah)
local ai=Color3ToHSB(ah)local
aj, ak, al=ai.h, ai.s, ai.b
if GetPerceivedBrightness(ah)>0.5 then
return Color3.fromHSV(aj/360,0,0.05)
else
return Color3.fromHSV(aj/360,0,0.98)
end
end

local function Coalesce(...)
for ah=1,select("#",...)do
local ai=select(ah,...)
if ai~=nil then
return ai
end
end
return nil
end

return function(ah)
local ai={
Title=ah.Title,
Desc=ah.Desc or nil,
Hover=ah.Hover,
Thumbnail=ah.Thumbnail,
ThumbnailSize=ah.ThumbnailSize or 80,
Image=ah.Image,
IconThemed=ah.IconThemed or false,
ImageSize=ah.ImageSize or 30,
Color=ah.Color,
Scalable=ah.Scalable,
Parent=ah.Parent,
Justify=ah.Justify or"Between",
UIPadding=ah.Window.ElementConfig.UIPadding,
UICorner=ah.Window.ElementConfig.UICorner,
Transparency=Coalesce(
ah.Transparency,
ah.ParentConfig and ah.ParentConfig.Transparency,
ah.ParentConfig and ah.ParentConfig.ElementTransparency,
ah.Window.ElementConfig.Transparency
),
GlassTransparency=Coalesce(
ah.GlassTransparency,
ah.ParentConfig and ah.ParentConfig.GlassTransparency,
ah.Window.ElementConfig.GlassTransparency
),
LiquidGlass=Coalesce(
ah.LiquidGlass,
ah.ParentConfig and ah.ParentConfig.LiquidGlass,
ah.ParentConfig and ah.ParentConfig.GlassLiquid,
ah.Window.ElementConfig.LiquidGlass
),
Golden=ah.Golden==true
or ah.Premium==true
or(ah.ParentConfig and(ah.ParentConfig.Golden==true or ah.ParentConfig.Premium==true)),
CornerStyle=Coalesce(
ah.CornerStyle,
ah.ParentConfig and ah.ParentConfig.CornerStyle,
ah.ParentConfig and ah.ParentConfig.ElementCornerStyle,
ah.Window.ElementConfig.CornerStyle
),
Size=ah.Size or"Default",
Tags=ah.Tags or{},
UIElements={},

Index=ah.Index,
}

local aj=ai.Size=="Small"and-4 or ai.Size=="Large"and 4 or 0
local ak=ai.Size=="Small"and-4 or ai.Size=="Large"and 4 or 0

local al=ai.ImageSize
local am=ai.ThumbnailSize
local an=true

local ao=ai.CornerStyle=="Native"or ai.CornerStyle=="PerCorner"
local ap=aa.ClampTransparency(ai.Transparency,nil)
local aq
local ar
local as
local at={
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}

local au=0

local av
local aw
if ai.Thumbnail then
av=aa.Image(
ai.Thumbnail,
ai.Title,
ah.Window.NewElements and ai.UICorner-11 or(ai.UICorner-4),
ah.Window.Folder,
"Thumbnail",
false,
ai.IconThemed
)
av.Size=UDim2.new(1,0,0,am)
end
if ai.Image then
aw=aa.Image(
ai.Image,
ai.Title,
ah.Window.NewElements and ai.UICorner-11 or(ai.UICorner-4),
ah.Window.Folder,
"Image",
ai.IconThemed,
not ai.Color and true or false,
"ElementIcon"
)

if typeof(ai.Color)=="string"and not string.find(ai.Image,"rbxthumb")then
aw.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ai.Color]))
elseif typeof(ai.Color)=="Color3"and not string.find(ai.Image,"rbxthumb")then
aw.ImageLabel.ImageColor3=GetTextColorForHSB(ai.Color)
end

aw.Size=UDim2.new(0,al,0,al)

au=al
end

local function CreateText(ax,ay)
local az=typeof(ai.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ai.Color]))
or typeof(ai.Color)=="Color3"and GetTextColorForHSB(ai.Color)

return ac("TextLabel",{
BackgroundTransparency=1,
Text=ax or"",
TextSize=ay=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not ai.Color and("Element"..ay)or nil,
},
TextColor3=ai.Color and az or nil,
TextTransparency=ay=="Desc"and 0.3 or 0,
TextWrapped=true,
Size=UDim2.new(ai.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=ai.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,ay=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
})
end

local ax=CreateText(ai.Title,"Title")
local ay=CreateText(ai.Desc,"Desc")
if not ai.Title or ai.Title==""then
ay.Visible=false
end
if not ai.Desc or ai.Desc==""then
ay.Visible=false
end

ai.UIElements.Title=ax
ai.UIElements.Desc=ay

ai.UIElements.Container=ac("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,ai.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=ai.Justify=="Between"and"Left"or"Center",
}),
av,
ac("Frame",{
Size=UDim2.new(
ai.Justify=="Between"and 1 or 0,
ai.Justify=="Between"and-ah.TextOffset or 0,
0,
0
),
AutomaticSize=ai.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ac("UIListLayout",{
Padding=UDim.new(0,ai.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=ah.Window.NewElements and(ai.Justify=="Between"and"Top"or"Center")
or"Center",
HorizontalAlignment=ai.Justify~="Between"and ai.Justify or"Center",
}),
aw,
ac("Frame",{
BackgroundTransparency=1,
AutomaticSize=ai.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
ai.Justify=="Between"and 1 or 0,
ai.Justify=="Between"and(aw and-au-ai.UIPadding or-au)
or 0,
1,
0
),
Name="TitleFrame",
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,(ah.Window.NewElements and ai.UIPadding/2 or 0)+ak),
PaddingLeft=UDim.new(0,(ah.Window.NewElements and ai.UIPadding/2 or 0)+aj),
PaddingRight=UDim.new(
0,
(ah.Window.NewElements and ai.UIPadding/2 or 0)+aj
),
PaddingBottom=UDim.new(
0,
(ah.Window.NewElements and ai.UIPadding/2 or 0)+ak
),
}),
ac("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ac("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=-99,
BackgroundTransparency=1,
ScrollingDirection="X",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
Visible=false,
},{
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,ah.Window.UIPadding/2),
}),
}),
ac("Frame",{
Name="Space",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Visible=false,
}),
ax,
ay,
}),
}),
})

for az,aA in next,ah.Tags or{}do
if not ai.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible then
ai.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Visible=true
ai.UIElements.Container.TitleFrame.TitleFrame.Space.Visible=true
end
ag:New(aA,ai.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame)
end

aa.AddSignal(
ai.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout:GetPropertyChangedSignal
"AbsoluteContentSize"
,
function()
ai.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.Size=UDim2.new(
1,
0,
0,
ai.UIElements.Container.TitleFrame.TitleFrame.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y
/ah.ParentConfig.UIScale
)
end
)





local az=aa.Image("lock","lock",0,ah.Window.Folder,"Lock",false)
az.Size=UDim2.new(0,20,0,20)
az.ImageLabel.ImageColor3=Color3.new(1,1,1)
az.ImageLabel.ImageTransparency=0.4

local aA=ac("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.05,
})

local aB=ac("Frame",{
Size=UDim2.new(1,ai.UIPadding*2,1,ai.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local b,d=ad(ai.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=aB,
},{
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
az,
aA,
},nil,true)local

f=ad(ai.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aB,
},{
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local g,h=ad(ai.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aB,
},{
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)local

i=ad(ai.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Visible=false,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aB,
},{
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ac("UIGradient",{
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

local l,m=ad(ai.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aB,
},{
ac("UIGradient",{
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
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local function GetElementColor()
if typeof(ai.Color)=="string"then
return Color3.fromHex(aa.Colors[ai.Color])
end
if typeof(ai.Color)=="Color3"then
return ai.Color
end
return nil
end

local function GetBackgroundTransparency()
if ap~=nil then
return ap
end
if ai.LiquidGlass then
return aa.ClampTransparency(ai.GlassTransparency,0.24)
end
if ai.Color then
return 0.05
end
if not ah.Window.NewElements then
return 0.93
end
return nil
end

local function ApplyNativeCorners(p)
at=p or at
if ar then
aa.ApplyCornerRadii(ar,UDim.new(0,ai.UICorner),at)
end
end

local function CreateLiquidGlassChildren()
if not ai.LiquidGlass then
return{}
end

as=ac("UIGradient",{
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
ac("UIStroke",{
ApplyStrokeMode="Border",
Thickness=1,
Color=Color3.new(1,1,1),
Transparency=0.88,
}),
as,
}
end

local function CreateNativeBackground()
ar=ac("UICorner",{
CornerRadius=UDim.new(0,ai.UICorner),
})

local p={
ar,
}

for r,u in next,CreateLiquidGlassChildren()do
table.insert(p,u)
end

return ac("Frame",{
Name="NativeBackground",
Size=UDim2.new(1,ai.UIPadding*2,1,ai.UIPadding*2),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
BackgroundColor3=GetElementColor()or nil,
BackgroundTransparency=GetBackgroundTransparency()or 0,
ThemeTag=not ai.Color and{
BackgroundColor3="ElementBackground",
BackgroundTransparency=ap==nil and not ai.LiquidGlass and"ElementBackgroundTransparency"
or nil,
}or nil,
ZIndex=0,
Active=false,
},p)
end

local p={}
if ao then
aq=CreateNativeBackground()
table.insert(p,aq)
end

table.insert(p,ai.UIElements.Container)
table.insert(p,aB)
table.insert(p,ac("UIPadding",{
PaddingTop=UDim.new(0,ai.UIPadding),
PaddingLeft=UDim.new(0,ai.UIPadding),
PaddingRight=UDim.new(0,ai.UIPadding),
PaddingBottom=UDim.new(0,ai.UIPadding),
}))

local r,u=ad(ai.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ao and 1 or GetBackgroundTransparency(),



Parent=ah.Parent,
ThemeTag={
ImageColor3=not ao
and not ai.Color
and(ah.Window.NewElements and"ElementBackground"or"Text")
or nil,
ImageTransparency=not ao
and not ai.Color
and ap==nil
and not ai.LiquidGlass
and(ah.Window.NewElements and"ElementBackgroundTransparency"or nil)
or nil,
},
ImageColor3=not ao and GetElementColor()or nil,
},p,true,true)

ai.UIElements.Main=r
ai.UIElements.Locked=b
ApplyNativeCorners(at)

if ai.Golden then
ai.UIElements.GoldenEffect=ae.Apply(aB,{
Corner=ai.UICorner,
Compact=ai.Size=="Small",
FillTransparency=0.8,
OutlineTransparency=0.18,
SheenTransparency=0.82,
})

ax.TextColor3=Color3.fromRGB(255,232,144)
ay.TextColor3=Color3.fromRGB(255,224,138)
ay.TextTransparency=math.min(ay.TextTransparency+0.08,0.72)
end

if ai.Hover then
aa.AddSignal(r.MouseMoved,function(v,x)
if an and r.AbsoluteSize.X>0 then
l.HoverGradient.Offset=Vector2.new(((v-r.AbsolutePosition.X)/r.AbsoluteSize.X)-0.5,0)
i.HoverGradient.Offset=
Vector2.new(((v-r.AbsolutePosition.X)/r.AbsoluteSize.X)-0.5,0)
if as then
as.Offset=Vector2.new(((v-r.AbsolutePosition.X)/r.AbsoluteSize.X)-0.5,0)
end
end
end)

aa.AddSignal(r.MouseEnter,function()
if an then

i.Visible=true
ab.Play(l,"Hover",{ImageTransparency=0.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Hover")
ab.Play(
i,
"Hover",
{ImageTransparency=0.8},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
if aq and ai.LiquidGlass then
ab.Play(
aq,
"Hover",
{BackgroundTransparency=math.max((ap or ai.GlassTransparency or 0.24)-0.06,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end
end
end)
aa.AddSignal(r.InputEnded,function()
if an then

ab.Play(l,"Hover",{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Hover")
ab.Play(
i,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
if aq and ai.LiquidGlass then
ab.Play(
aq,
"Hover",
{BackgroundTransparency=GetBackgroundTransparency()or 0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end
end
end)
aa.AddSignal(r.MouseLeave,function()
if an then
ab.Play(l,"Hover",{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Hover")
ab.Play(
i,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
if aq and ai.LiquidGlass then
ab.Play(
aq,
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

if ai.Scalable then
ab.AttachPress(r,aa,{
Amount=0.985,
Enabled=function()
return an
end,
})
end

function ai.SetTitle(v,x)
ai.Title=x
ax.Text=x
end

function ai.SetDesc(v,x)
ai.Desc=x
ay.Text=x or""
if not x then
ay.Visible=false
elseif not ay.Visible then
ay.Visible=true
end
end

function ai.SetTransparency(v,x)
ap=aa.ClampTransparency(x,ap or 0)
ai.Transparency=ap

if aq then
ab.Play(
aq,
"Focus",
{BackgroundTransparency=ap},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"ElementTransparency"
)
else
ab.Play(
r,
"Focus",
{ImageTransparency=ap},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"ElementTransparency"
)
end
end

function ai.SetLiquidGlass(v,x)
ai.LiquidGlass=x==true
if aq then
for z,A in next,aq:GetChildren()do
if A:IsA"UIStroke"or A:IsA"UIGradient"then
pcall(function()
A.Enabled=ai.LiquidGlass
end)
end
end
if ap==nil then
aq.BackgroundTransparency=GetBackgroundTransparency()or 0
end
end
end

function ai.Colorize(v,x,z)
if ai.Color then
x[z]=typeof(ai.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ai.Color]))
or typeof(ai.Color)=="Color3"and GetTextColorForHSB(ai.Color)
or nil
end
end

if ah.ElementTable then
aa.AddSignal(ax:GetPropertyChangedSignal"Text",function()
if ai.Title~=ax.Text then
ai:SetTitle(ax.Text)
ah.ElementTable.Title=ax.Text
end
end)
aa.AddSignal(ay:GetPropertyChangedSignal"Text",function()
if ai.Desc~=ay.Text then
ai:SetDesc(ay.Text)
ah.ElementTable.Desc=ay.Text
end
end)
end





function ai.SetThumbnail(v,x,z)
ai.Thumbnail=x
if z then
ai.ThumbnailSize=z
am=z
end

if av then
if x then
av:Destroy()
av=aa.Image(
x,
ai.Title,
ai.UICorner-3,
ah.Window.Folder,
"Thumbnail",
false,
ai.IconThemed
)
if av then
av.Size=UDim2.new(1,0,0,am)
av.Parent=ai.UIElements.Container
local A=ai.UIElements.Container:FindFirstChild"UIListLayout"
if A then
av.LayoutOrder=-1
end
end
else
av.Visible=false
end
else
if x then
av=aa.Image(
x,
ai.Title,
ai.UICorner-3,
ah.Window.Folder,
"Thumbnail",
false,
ai.IconThemed
)
if av then
av.Size=UDim2.new(1,0,0,am)
av.Parent=ai.UIElements.Container
local A=ai.UIElements.Container:FindFirstChild"UIListLayout"
if A then
av.LayoutOrder=-1
end
end
end
end
end

function ai.SetImage(v,x,z)
ai.Image=x
if z then
ai.ImageSize=z
al=z
end

if x then
local A=aw and aw.Parent or ai.UIElements.Container.TitleFrame
if aw then
aw:Destroy()
end

aw=aa.Image(
x,
x,
ai.UICorner-3,
ah.Window.Folder,
"Image",
not ai.Color and true or false
)
if aw then
if typeof(ai.Color)=="string"and not string.find(ai.Image,"rbxthumb")then
aw.ImageLabel.ImageColor3=
GetTextColorForHSB(Color3.fromHex(aa.Colors[ai.Color]))
elseif typeof(ai.Color)=="Color3"and not string.find(ai.Image,"rbxthumb")then
aw.ImageLabel.ImageColor3=GetTextColorForHSB(ai.Color)
end

aw.Visible=true
aw.Parent=A
aw.LayoutOrder=-99

aw.Size=UDim2.new(0,al,0,al)
au=ai.ImageSize+ai.UIPadding
end
else
if aw then
aw.Visible=true
end
au=0
end

ai.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-au,1,0)
end

function ai.Destroy(v)
r:Destroy()
end

function ai.Lock(v,x)
an=false
b.Active=true
b.Visible=true
aA.Text=x or"Locked"
end

function ai.Unlock(v)
an=true
b.Active=false
b.Visible=false
end

function ai.Highlight(v)
local x=ac("UIGradient",{
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
Parent=f,
})

local z=ac("UIGradient",{
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
Parent=g,
})

f.ImageTransparency=0.65
g.ImageTransparency=0.88

ab.Play(x,"Highlight",{
Offset=Vector2.new(1,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Highlight")

ab.Play(z,"Highlight",{
Offset=Vector2.new(1,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Highlight")

task.spawn(function()
task.wait(ab.GetDuration"Highlight")
f.ImageTransparency=1
g.ImageTransparency=1
x:Destroy()
z:Destroy()
end)
end

function ai.UpdateShape(v)
if ah.Window.NewElements then
local x=ah.ParentConfig
and ah.ParentConfig.ParentTable
and ah.ParentConfig.ParentTable.__type
or ah.ParentType
local z=ah.Window.ElementConfig.LinkCorners
or(ah.ParentConfig and ah.ParentConfig.LinkCorners==true)

local A="Squircle"
local B={
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}

if z then
A,B=aa.GetLinkedCornerShape(
v.Elements,
ai.Index,
v,
x
)
end

if A and r then
local C=(A=="Squircle-TL-BL"or A=="Squircle-TR-BR")and"Squircle"
or A

u:SetType(C)
d:SetType(C)
h:SetType(C)

m:SetType(C)

ApplyNativeCorners(B)
end
end
end





return ai
end end function a.J()

local aa=a.load'd'
local ab=aa.New

local ac={}

local ad=a.load'n'.New

function ac.New(ae,af)
af.Hover=false
af.TextOffset=0
af.ParentConfig=af
af.IsButtons=af.Buttons and#af.Buttons>0 and true or false

local ag={
__type="Paragraph",
Title=af.Title or"Paragraph",
Desc=af.Desc or nil,

Locked=af.Locked or false,
}
local ah=a.load'I'(af)

ag.ParagraphFrame=ah
if af.Buttons and#af.Buttons>0 then
local ai=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ah.UIElements.Container,
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
}),
})

for aj,ak in next,af.Buttons do
local al=ad(
ak.Title,
ak.Icon,
ak.Callback,
ak.Variant or"White",
ai,
nil,
nil,
af.Window.NewElements and 999 or 10
)
al.Size=UDim2.new(1,0,0,38)

end
end

return ag.__type,ag
end

return ac end function a.K()

local aa=a.load'd'local ab=
aa.New
local ac=game:GetService"UserInputService"

local ad={}

local function NormalizeKey(ae)
if typeof(ae)=="EnumItem"then
return ae.Name,ae
end
if typeof(ae)=="string"and Enum.KeyCode[ae]then
return ae,Enum.KeyCode[ae]
end
return nil,nil
end

local function GetImageTarget(ae)
if typeof(ae)~="Instance"then
return nil
end

if ae:IsA"ImageLabel"or ae:IsA"ImageButton"then
return ae
end

return ae:FindFirstChildWhichIsA("ImageLabel",true)or ae:FindFirstChildWhichIsA("ImageButton",true)
end

function ad.New(ae,af)
local ag,ah=
NormalizeKey(af.Keybind or af.KeyBind or af.Shortcut or af.Bind or af.Hotkey)
local ai={
__type="Button",
Title=af.Title or"Button",
Desc=af.Desc or nil,
Icon=af.Icon or"mouse-pointer-click",
IconThemed=af.IconThemed or false,
IconColor=af.IconColor or nil,
Color=af.Color,
Justify=af.Justify or"Between",
IconAlign=af.IconAlign or"Right",
Locked=af.Locked or false,
LockedTitle=af.LockedTitle,
Golden=af.Golden==true or af.Premium==true,
Premium=af.Premium==true or af.Golden==true,
Keybind=ag,
KeyCode=ah,
Callback=af.Callback or function()end,
UIElements={},
}

local aj=true

ai.ButtonFrame=a.load'I'{
Title=ai.Title,
Desc=ai.Desc,
Parent=af.Parent,




Window=af.Window,
Color=ai.Color,
Justify=ai.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=af.Tab,
Index=af.Index,
ElementTable=ai,
ParentConfig=af,
Size=af.Size,
Tags=af.Tags,
Golden=ai.Golden,
Premium=ai.Premium,
}














ai.UIElements.ButtonIcon=aa.Image(
ai.Icon,
ai.Icon,
0,
af.Window.Folder,
"Button",
not(ai.Color or ai.IconColor)and true or nil,
ai.IconThemed
)

ai.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
ai.UIElements.ButtonIcon.Parent=ai.Justify=="Between"and ai.ButtonFrame.UIElements.Main
or ai.ButtonFrame.UIElements.Container.TitleFrame
ai.UIElements.ButtonIcon.LayoutOrder=ai.IconAlign=="Left"and-99999 or 99999
ai.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
ai.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

local ak=GetImageTarget(ai.UIElements.ButtonIcon)
if ak then
if ai.IconColor then
ak.ImageColor3=ai.IconColor
elseif ai.Golden then
ak.ImageColor3=Color3.fromRGB(255,222,105)
end
ai.ButtonFrame:Colorize(ak,"ImageColor3")
end

function ai.Lock(al)
ai.Locked=true
aj=false
return ai.ButtonFrame:Lock(ai.LockedTitle)
end
function ai.Unlock(al)
ai.Locked=false
aj=true
return ai.ButtonFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end

function ai.Press(al)
if aj then
task.spawn(function()
aa.SafeCallback(ai.Callback)
end)
end
end

aa.AddSignal(ai.ButtonFrame.UIElements.Main.MouseButton1Click,function()
ai:Press()
end)

if ai.KeyCode then
aa.AddSignal(ac.InputBegan,function(al,am)
if am or ac:GetFocusedTextBox()then
return
end
if al.UserInputType==Enum.UserInputType.Keyboard and al.KeyCode==ai.KeyCode then
ai:Press()
end
end)
end

return ai.__type,ai
end

return ad end function a.L()

local aa={}

local ab=a.load'd'
local ac=a.load'e'
local ad=ab.New

local ae=game:GetService"UserInputService"

function aa.New(af,ag,ah,ai,aj,ak,al)
local am={
GlassSpritesheet={
Id="rbxassetid://77297718671545",
MirroredId="rbxassetid://92258969882244",
Size=Vector2.new(102,128),
Total=80,
Cols=10,
},
}

function am.GetGlassFrame(an,ao:number):(string,Vector2,Vector2)
local ap=am.GlassSpritesheet
local aq:number

if ao<=0.4 then
aq=math.floor((ao/0.4)*(ap.Total-1))
elseif ao<0.6 then
aq=ap.Total-1
else
aq=math.floor(((ao-0.6)/0.4)*(ap.Total-1))
end

aq=math.clamp(aq,0,ap.Total-1)

local ar=ao>=0.6
if ar then
aq=(ap.Total-1)-aq
end

local as=ar and ap.MirroredId or ap.Id

return as,ap.Size,Vector2.new((aq%ap.Cols)*ap.Size.X,math.floor(aq/ap.Cols)*ap.Size.Y)
end

local an=12
local ao
if ag and ag~=""then
ao=ad("ImageLabel",{
Size=UDim2.new(0,13,0,13),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(ag)[1],
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local ap=ad("Frame",{
Size=UDim2.new(0,2,0,26),
BackgroundTransparency=1,
Parent=ai,
})

local aq=ab.NewRoundFrame(an,"Squircle",{
ImageTransparency=0.85,
ThemeTag={
ImageColor3="Text",
},
Parent=ap,
Size=UDim2.new(0,ak and(52)or(40.8),0,24),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,0,0.5,0),
Name="ToggleFrame",
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Toggle",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(an,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ad("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
}),
}),


ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(0,ak and 30 or 20,0,20),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Bar",
},{
ab.New("Frame",{
Size=UDim2.new(1,0,1,0),
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
Position=UDim2.new(0.5,0,0.5,0),
}),
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="GlassBackground",
ImageTransparency=0,
ThemeTag={
ImageColor3="ElementBackground",
},
ZIndex=-1,
}),
ad("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Glass",
ImageTransparency=0,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),






ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="BarOverlay",
ThemeTag={
ImageColor3="ToggleBar",
},
ZIndex=999,
}),
}),
ao,
ad("UIScale",{
Scale=1,
}),
}),
}),
ad("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Name="Hitbox",
Text="",
}),
})

local ar
local as

local at=ak and 30 or 20
local au=aq.Size.X.Offset

function am.Set(av,aw,ax,ay)
local az=aw and UDim2.new(0,au-at-2,0.5,0)
or UDim2.new(0,2,0.5,0)

if not ay then
ac.Play(
aq.Frame,
"Select",
{Position=az},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Position"
)
if aw then
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Toggle"},0.15)

ac.Play(
aq.Frame.Bar.Highlight.Glass,
"Select",
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Glass"
)
else
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Text"},0.15)
ac.Play(
aq.Frame.Bar.Highlight.Glass,
"Select",
{ImageTransparency=0.85},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Glass"
)
end
else
aq.Frame.Position=az
end

if aw then
ac.Play(aq.Layer,"Fast",{
ImageTransparency=0,
},nil,nil,"Layer")
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Toggle"},0.1)
ac.Play(
aq.Frame.Bar.Highlight.Glass,
"Fast",
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Glass"
)

if ao then
ac.Play(ao,"Fast",{
ImageTransparency=0,
},nil,nil,"Icon")
end

local aA,aB,b=am:GetGlassFrame(1)

aq.Frame.Bar.Highlight.Glass.Image=aA
aq.Frame.Bar.Highlight.Glass.ImageRectSize=aB
aq.Frame.Bar.Highlight.Glass.ImageRectOffset=b
else
ac.Play(aq.Layer,"Fast",{
ImageTransparency=1,
},nil,nil,"Layer")
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Text"},0.1)
ac.Play(
aq.Frame.Bar.Highlight.Glass,
"Fast",
{ImageTransparency=0.85},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Glass"
)

if ao then
ac.Play(ao,"Fast",{
ImageTransparency=1,
},nil,nil,"Icon")
end

local aA,aB,b=am:GetGlassFrame(0)

aq.Frame.Bar.Highlight.Glass.Image=aA
aq.Frame.Bar.Highlight.Glass.ImageRectSize=aB
aq.Frame.Bar.Highlight.Glass.ImageRectOffset=b
end

ax=ax~=false

task.spawn(function()
if aj and ax then
ab.SafeCallback(aj,aw)
end
end)
end

function am.Animate(av,aw,ax)
if not al.Window.IsToggleDragging then
al.Window.IsToggleDragging=true

local ay=aw.Position.X
local az=aw.Position.Y
local aA=aq.Frame.Position.X.Offset
local aB=false
local b=false

ac.Play(
aq.Frame.Bar.UIScale,
"Focus",
{Scale=1.5},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
ac.Play(
aq.Frame.Bar.Highlight.BarOverlay,
"Focus",
{ImageTransparency=0.86},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)

if ar then
ar:Disconnect()
end

ar=ae.InputChanged:Connect(function(d)
if not al.Window.IsToggleDragging then
return
end
if
d.UserInputType~=Enum.UserInputType.MouseMovement
and d.UserInputType~=Enum.UserInputType.Touch
then
return
end
if aB then
return
end

local f=math.abs(d.Position.X-ay)
math.abs(d.Position.Y-az)

if not b and f>8 then
b=true
end

local g=d.Position.X-ay
local h=math.max(2,math.min(aA+g,au-at-2))

local i=math.clamp((h-2)/(au-at-4),0,1)

local l,m,p=am:GetGlassFrame(i)
aq.Frame.Bar.Highlight.Glass.Image=l
aq.Frame.Bar.Highlight.Glass.ImageRectSize=m
aq.Frame.Bar.Highlight.Glass.ImageRectOffset=p

aq.Frame.Position=UDim2.new(0,h,0.5,0)
end)

if as then
as:Disconnect()
end

as=ae.InputEnded:Connect(function(d)
if not al.Window.IsToggleDragging then
return
end
if
d.UserInputType~=Enum.UserInputType.MouseButton1
and d.UserInputType~=Enum.UserInputType.Touch
then
return
end

al.Window.IsToggleDragging=false

if ar then
ar:Disconnect()
ar=nil
end
if as then
as:Disconnect()
as=nil
end

al.WindUI.CurrentInput=nil

if aB then
return
end

if not b then
ax:Set(not ax.Value,true,false)
else
local f=aq.Frame.Position.X.Offset
local g=f+at/2
local h=g>au/2
ax:Set(h,true,false)
end

ac.Play(
aq.Frame.Bar.UIScale,
"Focus",
{Scale=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
ac.Play(
aq.Frame.Bar.Highlight.BarOverlay,
"Focus",
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Press"
)
end)
end
end

return ap,am
end

return aa end function a.M()

local aa={}

local ab=a.load'd'
local ac=a.load'e'local ad=
ab.New


function aa.New(ae,af,ag,ah,ai,aj)
local ak={}

af=af or"sfsymbols:checkmark"

local al=9

local am=ab.Image(
af,
af,
0,
(aj and aj.Window.Folder or"Temp"),
"Checkbox",
true,
false,
"CheckboxIcon"
)
am.Size=UDim2.new(1,-26+ag,1,-26+ag)
am.AnchorPoint=Vector2.new(0.5,0.5)
am.Position=UDim2.new(0.5,0,0.5,0)


local an=ab.NewRoundFrame(al,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ah,
Size=UDim2.new(0,26,0,26),
},{
ab.NewRoundFrame(al,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Checkbox",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(al,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ThemeTag={
ImageColor3="CheckboxBorder",
ImageTransparency="CheckboxBorderTransparency",
},
},{







}),

am,
},true)

function ak.Set(ao,ap)
if ap then
ac.Play(an.Layer,"Fast",{
ImageTransparency=0,
},nil,nil,"State")



ac.Play(am.ImageLabel,"Fast",{
ImageTransparency=0,
},nil,nil,"State")
else
ac.Play(an.Layer,"Fast",{
ImageTransparency=1,
},nil,nil,"State")



ac.Play(am.ImageLabel,"Fast",{
ImageTransparency=1,
},nil,nil,"State")
end

task.spawn(function()
if ai then
ab.SafeCallback(ai,ap)
end
end)
end

return an,ak
end


return aa end function a.N()

local aa=a.load'd'local ab=
aa.New local ac=
aa.Tween
local ad=game:GetService"UserInputService"

local ae=a.load'L'.New
local af=a.load'M'.New

local ag={}

local function NormalizeKey(ah)
if typeof(ah)=="EnumItem"then
return ah.Name,ah
end
if typeof(ah)=="string"and Enum.KeyCode[ah]then
return ah,Enum.KeyCode[ah]
end
return nil,nil
end

function ag.New(ah,ai)
local aj,ak=
NormalizeKey(ai.Keybind or ai.KeyBind or ai.Shortcut or ai.Bind or ai.Hotkey)
local al={
__type="Toggle",
Title=ai.Title or"Toggle",
Desc=ai.Desc or nil,
Locked=ai.Locked or false,
LockedTitle=ai.LockedTitle,
Value=ai.Value,
Icon=ai.Icon or nil,
IconSize=ai.IconSize or 23,
Type=ai.Type or"Toggle",
Keybind=aj,
KeyCode=ak,
Callback=ai.Callback or function()end,
UIElements={},
}
al.ToggleFrame=a.load'I'{
Title=al.Title,
Desc=al.Desc,




Window=ai.Window,
Parent=ai.Parent,
TextOffset=(52),
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
ElementTable=al,
ParentConfig=ai,
Tags=ai.Tags,
}

local am=true

if al.Value==nil then
al.Value=false
end

function al.Lock(an)
al.Locked=true
am=false
return al.ToggleFrame:Lock(al.LockedTitle)
end
function al.Unlock(an)
al.Locked=false
am=true
return al.ToggleFrame:Unlock()
end

if al.Locked then
al:Lock()
end

local an=al.Value

local ao,ap
if al.Type=="Toggle"then
ao,ap=ae(
an,
al.Icon,
al.IconSize,
al.ToggleFrame.UIElements.Main,
al.Callback,
ai.Window.NewElements,
ai
)
elseif al.Type=="Checkbox"then
ao,ap=af(
an,
al.Icon,
al.IconSize,
al.ToggleFrame.UIElements.Main,
al.Callback,
ai
)
else
error("Unknown Toggle Type: "..tostring(al.Type))
end

ao.AnchorPoint=Vector2.new(1,ai.Window.NewElements and 0 or 0.5)
ao.Position=UDim2.new(1,0,ai.Window.NewElements and 0 or 0.5,0)

function al.Set(aq,ar,as,at)
if am then
ap:Set(ar,as,at or false)
an=ar
al.Value=ar
end
end

function al.Toggle(aq,ar,as)
al:Set(not al.Value,ar,as or ai.Window.NewElements)
end

al:Set(an,false,ai.Window.NewElements)

local aq=ai.WindUI.GenerateGUID()

if ai.Window.NewElements and ap.Animate then
if al.Type=="Toggle"then
aa.AddSignal(ao.ToggleFrame.Hitbox.InputBegan,function(ar)
if
not ai.Window.IsToggleDragging
and(
ar.UserInputType==Enum.UserInputType.MouseButton1
or ar.UserInputType==Enum.UserInputType.Touch
)
then
if ai.WindUI.CurrentInput and ai.WindUI.CurrentInput~=aq then
return
end

ai.WindUI.CurrentInput=aq
ap:Animate(ar,al)
end
end)
end





else
if al.Type=="Toggle"then
aa.AddSignal(ao.ToggleFrame.Hitbox.MouseButton1Click,function()
al:Toggle(nil,ai.Window.NewElements)
end)
elseif al.Type=="Checkbox"then
aa.AddSignal(ao.MouseButton1Click,function()
al:Toggle(nil,ai.Window.NewElements)
end)
end
end

if al.KeyCode then
aa.AddSignal(ad.InputBegan,function(ar,as)
if as or ad:GetFocusedTextBox()then
return
end
if ar.UserInputType==Enum.UserInputType.Keyboard and ar.KeyCode==al.KeyCode then
al:Toggle(nil,ai.Window.NewElements)
end
end)
end

return al.__type,al
end

return ag end function a.O()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ac=aa(game:GetService"UserInputService")
local ad=aa(game:GetService"RunService")

local ae=a.load'd'
local af=a.load'e'
local ag=ae.New

local ah={}

local ai=false

function ah.New(aj,ak)
local al={
__type="Slider",
Title=ak.Title or nil,
Desc=ak.Desc or nil,
Locked=ak.Locked or nil,
LockedTitle=ak.LockedTitle,
Value=ak.Value or{},
Icons=ak.Icons or nil,
IsTooltip=ak.IsTooltip or false,
IsTextbox=ak.IsTextbox,
Step=ak.Step or 1,
Callback=ak.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=ak.Width or 130,
TextBoxWidth=ak.Window.NewElements and 40 or 30,
ThumbSize=13,
IconSize=26,
}
if al.Icons=={}then
al.Icons={
From="sfsymbols:sunMinFill",
To="sfsymbols:sunMaxFill",
}
end
if al.IsTextbox==nil and al.Title==nil then
al.IsTextbox=false
else
al.IsTextbox=al.IsTextbox~=false
end

local am
local an
local ao
local ap=al.Value.Default or al.Value.Min or 0

local aq=ap
local ar=(ap-(al.Value.Min or 0))/((al.Value.Max or 100)-(al.Value.Min or 0))

local as=true
local at=al.Step%1~=0

local function FormatValue(au)
if at then
return tonumber(string.format("%.2f",au))
end
return math.floor(au+0.5)
end

local function CalculateValue(au)
if at then
return math.floor(au/al.Step+0.5)*al.Step
else
return math.floor(au/al.Step+0.5)*al.Step
end
end

local au,av
local aw=32
if al.Icons then
if al.Icons.From then
au=ae.Image(
al.Icons.From,
al.Icons.From,
0,
ak.Window.Folder,
"SliderIconFrom",
true,
true,
"SliderIconFrom"
)
au.Size=UDim2.new(0,al.IconSize,0,al.IconSize)
aw=aw+al.IconSize-2
end
if al.Icons.To then
av=ae.Image(
al.Icons.To,
al.Icons.To,
0,
ak.Window.Folder,
"SliderIconTo",
true,
true,
"SliderIconTo"
)
av.Size=UDim2.new(0,al.IconSize,0,al.IconSize)
aw=aw+al.IconSize-2
end
end
al.SliderFrame=a.load'I'{
Title=al.Title,
Desc=al.Desc,
Parent=ak.Parent,
TextOffset=al.Width,
Hover=false,
Tab=ak.Tab,
Index=ak.Index,
Window=ak.Window,
ElementTable=al,
ParentConfig=ak,
Tags=ak.Tags,
}

al.UIElements.SliderIcon=ae.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.95,
Size=UDim2.new(1,not al.IsTextbox and-aw or(-al.TextBoxWidth-8),0,4),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{
ae.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(ar,0,1,0),
ImageTransparency=0.1,
ThemeTag={
ImageColor3="Slider",
},
},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(
0,
ak.Window.NewElements and(al.ThumbSize*2)or(al.ThumbSize+2),
0,
ak.Window.NewElements and(al.ThumbSize+4)or(al.ThumbSize+2)
),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="SliderThumb",
},
Name="Thumb",
},{
ae.NewRoundFrame(999,"SquircleGlass",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.5,
}),
}),
}),
})

al.UIElements.SliderContainer=ag("Frame",{
Size=UDim2.new(al.Title==nil and 1 or 0,al.Title==nil and 0 or al.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,al.IsTextbox and(ak.Window.NewElements and-16 or 0)or 0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=al.SliderFrame.UIElements.Main,
},{
ag("UIListLayout",{
Padding=UDim.new(0,al.Title~=nil and 8 or 12),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=al.Icons
and(al.Icons.From and(al.Icons.To and"Center"or"Left")or al.Icons.To and"Right")
or"Center",
}),
au,
al.UIElements.SliderIcon,
av,
ag("TextBox",{
Size=UDim2.new(0,al.TextBoxWidth,0,0),
TextXAlignment="Left",
Text=FormatValue(ap),
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.4,
AutomaticSize="Y",
TextSize=15,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
LayoutOrder=-1,
Visible=al.IsTextbox,
}),
})

local ax
if al.IsTooltip then
ax=a.load'G'.New(
ap,
al.UIElements.SliderIcon.Frame.Thumb,
true,
"Secondary",
"Small",
false
)
ax.Container.AnchorPoint=Vector2.new(0.5,1)
ax.Container.Position=UDim2.new(0.5,0,0,-8)
end

local function SetFillSize(ay,az)
local aA=UDim2.new(ay,0,1,0)
if az==0 or not af.ShouldAnimate(ak)then
al.UIElements.SliderIcon.Frame.Size=aA
else
af.Play(al.UIElements.SliderIcon.Frame,az or"Fast",{Size=aA},nil,nil,"Fill")
end
end

function al.Lock(ay)
al.Locked=true
as=false
return al.SliderFrame:Lock(al.LockedTitle)
end
function al.Unlock(ay)
al.Locked=false
as=true
return al.SliderFrame:Unlock()
end

if al.Locked then
al:Lock()
end


local ay=ak.Tab.UIElements.ContainerFrame

function al.Set(az,aA,aB)
if as then
if
not al.IsFocusing
and not ai
and(
not aB
or(
aB.UserInputType==Enum.UserInputType.MouseButton1
or aB.UserInputType==Enum.UserInputType.Touch
)
)
then
if aB then
am=(aB.UserInputType==Enum.UserInputType.Touch)
ay.ScrollingEnabled=false
ai=true

local b=am and aB.Position.X or ac:GetMouseLocation().X
local d=math.clamp(
(b-al.UIElements.SliderIcon.AbsolutePosition.X)
/al.UIElements.SliderIcon.AbsoluteSize.X,
0,
1
)
aA=CalculateValue(al.Value.Min+d*(al.Value.Max-al.Value.Min))
aA=math.clamp(aA,al.Value.Min or 0,al.Value.Max or 100)

if aA~=aq then
SetFillSize(d,0)
al.UIElements.SliderContainer.TextBox.Text=FormatValue(aA)
if ax then
ax.TitleFrame.Text=FormatValue(aA)
end
al.Value.Default=FormatValue(aA)
aq=aA
ae.SafeCallback(al.Callback,FormatValue(aA))
end

an=ad.RenderStepped:Connect(function()
local f=am and aB.Position.X or ac:GetMouseLocation().X
local g=math.clamp(
(f-al.UIElements.SliderIcon.AbsolutePosition.X)
/al.UIElements.SliderIcon.AbsoluteSize.X,
0,
1
)
aA=CalculateValue(al.Value.Min+g*(al.Value.Max-al.Value.Min))

if aA~=aq then
SetFillSize(g,0)
al.UIElements.SliderContainer.TextBox.Text=FormatValue(aA)
if ax then
ax.TitleFrame.Text=FormatValue(aA)
end
al.Value.Default=FormatValue(aA)
aq=aA
ae.SafeCallback(al.Callback,FormatValue(aA))
end
end)


ao=ac.InputEnded:Connect(function(f)
if
(
f.UserInputType==Enum.UserInputType.MouseButton1
or f.UserInputType==Enum.UserInputType.Touch
)and aB==f
then
an:Disconnect()
ao:Disconnect()
ai=false
ay.ScrollingEnabled=true

ak.WindUI.CurrentInput=nil

if ak.Window.NewElements then
af.Play(al.UIElements.SliderIcon.Frame.Thumb,"Focus",{
ImageTransparency=0,
Size=UDim2.new(
0,
ak.Window.NewElements and(al.ThumbSize*2)or(al.ThumbSize+2),
0,
ak.Window.NewElements and(al.ThumbSize+4)or(al.ThumbSize+2)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Thumb")
end
if ax then
ax:Close(false)
end
end
end)
else
aA=math.clamp(aA,al.Value.Min or 0,al.Value.Max or 100)

local b=math.clamp(
(aA-(al.Value.Min or 0))/((al.Value.Max or 100)-(al.Value.Min or 0)),
0,
1
)
aA=CalculateValue(al.Value.Min+b*(al.Value.Max-al.Value.Min))

if aA~=aq then
SetFillSize(b,"Fast")
al.UIElements.SliderContainer.TextBox.Text=FormatValue(aA)
if ax then
ax.TitleFrame.Text=FormatValue(aA)
end
al.Value.Default=FormatValue(aA)
aq=aA
ae.SafeCallback(al.Callback,FormatValue(aA))
end
end
end
end
end

function al.SetMax(az,aA)
al.Value.Max=aA

local aB=tonumber(al.Value.Default)or aq
if aB>aA then
al:Set(aA)
else
local b=
math.clamp((aB-(al.Value.Min or 0))/(aA-(al.Value.Min or 0)),0,1)
SetFillSize(b,"Fast")
end
end

function al.SetMin(az,aA)
al.Value.Min=aA

local aB=tonumber(al.Value.Default)or aq
if aB<aA then
al:Set(aA)
else
local b=math.clamp((aB-aA)/((al.Value.Max or 100)-aA),0,1)
SetFillSize(b,"Fast")
end
end

ae.AddSignal(al.UIElements.SliderContainer.TextBox.FocusLost,function(az)
local aA=tonumber(al.UIElements.SliderContainer.TextBox.Text)
if aA then
al:Set(aA)
else
al.UIElements.SliderContainer.TextBox.Text=FormatValue(aq)
if ax then
ax.TitleFrame.Text=FormatValue(aq)
end
end
end)

local az=ak.WindUI.GenerateGUID()

ae.AddSignal(al.UIElements.SliderContainer.InputBegan,function(aA)
if al.Locked or ai then
return
end
if
aA.UserInputType==Enum.UserInputType.MouseButton1
or aA.UserInputType==Enum.UserInputType.Touch
then
if ak.WindUI.CurrentInput and ak.WindUI.CurrentInput~=az then
return
end
ak.WindUI.CurrentInput=az

al:Set(ap,aA)


if ak.Window.NewElements then
af.Play(al.UIElements.SliderIcon.Frame.Thumb,"Focus",{
ImageTransparency=0.85,
Size=UDim2.new(
0,
(ak.Window.NewElements and(al.ThumbSize*2)or al.ThumbSize)+8,
0,
al.ThumbSize+8
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Thumb")
end
if ax then
ax:Open()
end

end
end)

return al.__type,al
end

return ah end function a.P()

local aa=a.load'd'
local ac=aa.New
local ad=aa.Tween

local ae={}

local function ToFiniteNumber(af)
local ag=tonumber(af)
if ag==nil or ag~=ag or math.abs(ag)==math.huge then
return nil
end

return ag
end

local function FormatNumber(af)
if af%1==0 then
return tostring(af)
end

return tostring(tonumber(string.format("%.2f",af)))
end

function ae.New(af,ag)
local ah=typeof(ag.Value)=="table"and ag.Value or{}
local ai=ToFiniteNumber(ah.Min)or ToFiniteNumber(ag.Min)or 0
local aj=ToFiniteNumber(ah.Max)or ToFiniteNumber(ag.Max)or 100

if ai>aj then
ai,aj=aj,ai
end

local ak=typeof(ag.Value)=="number"and ag.Value
or ToFiniteNumber(ah.Default)
or ToFiniteNumber(ag.Default)
or ai
ak=ToFiniteNumber(ak)or ai

local al=ag.Indeterminate==true

local am=ag.ShowValue
if am==nil then
am=not al
end

local an=math.max(ToFiniteNumber(ag.ValueWidth)or 44,0)

local ao={
__type="ProgressBar",
Title=ag.Title or"Progress",
Desc=ag.Desc or nil,
Value={
Min=ai,
Max=aj,
Default=math.clamp(ak,ai,aj),
},
ShowValue=am,
DisplayMode=ag.DisplayMode or"Percent",
Format=ag.Format,
Animate=ag.Animate~=false,
AnimationDuration=math.max(ToFiniteNumber(ag.AnimationDuration)or 0.15,0),
Indeterminate=al,
IndeterminateText=ag.IndeterminateText or"",
Speed=math.max(ToFiniteNumber(ag.Speed)or 1,0.01),
ControlGap=math.max(ToFiniteNumber(ag.ControlGap)or 16,0),
UIElements={},

Width=math.max(ToFiniteNumber(ag.Width)or 160,0),
ValueWidth=an,
}

local function GetRatio(ap)
if ao.Value.Max==ao.Value.Min then
return ap>=ao.Value.Max and 1 or 0
end

return math.clamp((ap-ao.Value.Min)/(ao.Value.Max-ao.Value.Min),0,1)
end

local function GetValueText(ap,aq)
if ao.Indeterminate then
return tostring(ao.IndeterminateText)
end

local ar=aq*100

if typeof(ao.Format)=="function"then
local as,at=
pcall(ao.Format,ap,ar,ao.Value.Min,ao.Value.Max)

if as and at~=nil then
return tostring(at)
end
end

if ao.DisplayMode=="Value"then
return FormatNumber(ap)
elseif ao.DisplayMode=="Fraction"then
return FormatNumber(ap).."/"..FormatNumber(ao.Value.Max)
end

return tostring(math.floor(ar+0.5)).."%"
end

ao.ProgressBarFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=ag.Parent,
TextOffset=ao.Width+ao.ControlGap,
Hover=false,
Tab=ag.Tab,
Index=ag.Index,
Window=ag.Window,
ElementTable=ao,
ParentConfig=ag,
Tags=ag.Tags,
}

ao.UIElements.Fill=aa.NewRoundFrame(99,"Squircle",{
Name="Fill",
Size=ao.Indeterminate and UDim2.new(0.3,0,1,0)
or UDim2.new(GetRatio(ao.Value.Default),0,1,0),
Position=ao.Indeterminate and UDim2.new(-0.3,0,0,0)or UDim2.new(0,0,0,0),
ThemeTag={
ImageColor3="ProgressBar",
},
})

ao.UIElements.Bar=aa.NewRoundFrame(99,"Squircle",{
Name="Bar",
Size=UDim2.new(1,ao.ShowValue and-(ao.ValueWidth+8)or 0,0,6),
ClipsDescendants=true,
ImageTransparency=0.9,
ThemeTag={
ImageColor3="ProgressBarTrack",
ImageTransparency="ProgressBarTrackTransparency",
},
},{
ao.UIElements.Fill,
})

ao.UIElements.Value=ac("TextLabel",{
Name="Value",
Size=UDim2.new(0,ao.ValueWidth,0,20),
BackgroundTransparency=1,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
Text=GetValueText(ao.Value.Default,GetRatio(ao.Value.Default)),
TextSize=14,
TextTransparency=0.25,
TextTruncate="AtEnd",
TextXAlignment="Right",
Visible=ao.ShowValue,
ThemeTag={
TextColor3="ProgressBarText",
},
})

ao.UIElements.Container=ac("Frame",{
Name="ProgressBarContainer",
Size=UDim2.new(0,ao.Width,0,36),
Position=UDim2.new(1,0,ag.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ag.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ao.ProgressBarFrame.UIElements.Main,
},{
ac("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Right",
VerticalAlignment="Center",
}),
ao.UIElements.Bar,
ao.UIElements.Value,
})

if ao.Indeterminate then
local ap=ad(
ao.UIElements.Fill,
1/ao.Speed,
{Position=UDim2.new(1,0,0,0)},
Enum.EasingStyle.Linear,
Enum.EasingDirection.InOut,-1

)
aa.AddSignal(ao.UIElements.Bar.Destroying,function()
ap:Cancel()
end)
ap:Play()
end

local function Update(ap,aq)
local ar=ToFiniteNumber(ap)
if ar==nil then
return ao.Value.Default
end

ar=math.clamp(ar,ao.Value.Min,ao.Value.Max)
ao.Value.Default=ar

local as=GetRatio(ar)
local at=UDim2.new(as,0,1,0)

if ao.UIElements.Fill and not ao.Indeterminate then
if aq or not ao.Animate or ao.AnimationDuration<=0 then
ao.UIElements.Fill.Size=at
else
ad(
ao.UIElements.Fill,
ao.AnimationDuration,
{Size=at},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end

ao.UIElements.Value.Text=GetValueText(ar,as)

return ar
end

function ao.Set(ap,aq)
return Update(aq,false)
end

function ao.Get(ap)
return ao.Value.Default
end

function ao.GetPercentage(ap)
return GetRatio(ao.Value.Default)*100
end

function ao.SetRange(ap,aq,ar)
aq=ToFiniteNumber(aq)
ar=ToFiniteNumber(ar)

if aq==nil or ar==nil then
return ao.Value.Min,ao.Value.Max
end

if aq>ar then
aq,ar=ar,aq
end

ao.Value.Min=aq
ao.Value.Max=ar
Update(ao.Value.Default,false)

return aq,ar
end

function ao.SetMin(ap,aq)
aq=ToFiniteNumber(aq)
if aq==nil then
return ao.Value.Min
end

ao:SetRange(aq,math.max(aq,ao.Value.Max))
return ao.Value.Min
end

function ao.SetMax(ap,aq)
aq=ToFiniteNumber(aq)
if aq==nil then
return ao.Value.Max
end

ao:SetRange(math.min(ao.Value.Min,aq),aq)
return ao.Value.Max
end

Update(ao.Value.Default,true)

return ao.__type,ao
end

return ae end function a.Q()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ac=aa(game:GetService"UserInputService")

local ad=a.load'd'
local ae=ad.New local af=
ad.Tween

local ag={
UICorner=6,
UIPadding=8,
}

local ah=a.load'y'.New

function ag.New(ai,aj)
local function NormalizeKeyCode(ak)
if typeof(ak)=="EnumItem"then
return ak.Name
elseif type(ak)=="string"then
return ak
else
return"F"
end
end

local ak={
__type="Keybind",
Title=aj.Title or"Keybind",
Desc=aj.Desc or nil,
Locked=aj.Locked or false,
LockedTitle=aj.LockedTitle,
Value=NormalizeKeyCode(aj.Value)or"F",
Callback=aj.Callback or function()end,
CanChange=aj.CanChange~=false,
Blacklist=aj.Blacklist or{},
Picking=false,
UIElements={},
}

local al={}

for am,an in next,ak.Blacklist do
table.insert(al,Enum.KeyCode[NormalizeKeyCode(an)])
end
table.insert(al,Enum.KeyCode[NormalizeKeyCode"Escape"])

local am=true

ak.KeybindFrame=a.load'I'{
Title=ak.Title,
Desc=ak.Desc,
Parent=aj.Parent,
TextOffset=85,
Hover=ak.CanChange,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
Tags=aj.Tags,
}

ak.UIElements.Keybind=ah(
ak.Value,
nil,
ak.KeybindFrame.UIElements.Main,
nil,
aj.Window.NewElements and 12 or 10
)

ak.UIElements.Keybind.Size=
UDim2.new(0,24+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,0,42)
ak.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
ak.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)
ak.UIElements.Keybind.Interactable=false

ae("UIScale",{
Parent=ak.UIElements.Keybind,
Scale=0.85,
})

ad.AddSignal(
ak.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",
function()
ak.UIElements.Keybind.Size=
UDim2.new(0,24+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,0,42)
end
)

function ak.Lock(an)
ak.Locked=true
am=false
return ak.KeybindFrame:Lock(ak.LockedTitle)
end
function ak.Unlock(an)
ak.Locked=false
am=true
return ak.KeybindFrame:Unlock()
end

function ak.Set(an,ao)
local ap=NormalizeKeyCode(ao)
ak.Value=ap
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=ap
end

if ak.Locked then
ak:Lock()
end

local an

ad.AddSignal(ak.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if am then
if ak.CanChange then
ak.Picking=true
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."



local ao
ao=ac.InputBegan:Connect(function(ap)
local aq

if ap.UserInputType==Enum.UserInputType.Keyboard then
if table.find(al,ap.KeyCode)then
aq=nil
return
else
aq=ap.KeyCode.Name
end
elseif
ap.UserInputType==Enum.UserInputType.MouseButton1
and not table.find(al,"MouseLeftButton")
then
aq="MouseLeftButton"
elseif
ap.UserInputType==Enum.UserInputType.MouseButton2
and not table.find(al,"MouseRightButton")
then
aq="MouseRightButton"
end

if an then
an:Disconnect()
end

an=ac.InputEnded:Connect(function(ar)
if
aq
and(
ar.KeyCode.Name==aq
or aq=="MouseLeft"and ar.UserInputType==Enum.UserInputType.MouseButton1
or aq=="MouseRight"and ar.UserInputType==Enum.UserInputType.MouseButton2
)
then
ak.Picking=false

ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=aq
ak.Value=aq

ao:Disconnect()
an:Disconnect()
end
end)
end)
end
end
end)

ad.AddSignal(ac.InputBegan,function(ao,ap)
if ac:GetFocusedTextBox()then
return
end
if not am then
return
end
if ak.Picking then
return
end

if ao.UserInputType==Enum.UserInputType.Keyboard then
if ao.KeyCode.Name==ak.Value then
ad.SafeCallback(ak.Callback,ao.KeyCode.Name)
end
elseif ao.UserInputType==Enum.UserInputType.MouseButton1 and ak.Value=="MouseLeft"then
ad.SafeCallback(ak.Callback,"MouseLeft")
elseif ao.UserInputType==Enum.UserInputType.MouseButton2 and ak.Value=="MouseRight"then
ad.SafeCallback(ak.Callback,"MouseRight")
end
end)

return ak.__type,ak
end

return ag end function a.R()

local aa=a.load'd'local ac=
aa.New local ad=
aa.Tween

local ae={
UICorner=8,
UIPadding=8,
}local af=a.load'n'

.New
local ag=a.load'o'.New

function ae.New(ah,ai)
local aj={
__type="Input",
Title=ai.Title or"Input",
Desc=ai.Desc or nil,
Type=ai.Type or"Input",
Locked=ai.Locked or false,
LockedTitle=ai.LockedTitle,
InputIcon=ai.InputIcon or false,
Placeholder=ai.Placeholder or"Enter Text...",
Value=ai.Value or"",
Callback=ai.Callback or function()end,
ClearTextOnFocus=ai.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local ak=true

aj.InputFrame=a.load'I'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=aj.Width,
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
Tags=ai.Tags,
}

local al=ag(
aj.Placeholder,
aj.InputIcon,
aj.Type=="Textarea"and aj.InputFrame.UIElements.Container or aj.InputFrame.UIElements.Main,
aj.Type,
function(al)
aj:Set(al,true)
end,
nil,
ai.Window.NewElements and 12 or 10,
aj.ClearTextOnFocus
)

if aj.Type~="Textarea"then
al.Size=UDim2.new(0,aj.Width,0,36)
al.Position=UDim2.new(1,0,ai.Window.NewElements and 0 or 0.5,0)
al.AnchorPoint=Vector2.new(1,ai.Window.NewElements and 0 or 0.5)
else
al.Size=UDim2.new(1,0,0,148)
end






function aj.Lock(am)
aj.Locked=true
ak=false
return aj.InputFrame:Lock(aj.LockedTitle)
end
function aj.Unlock(am)
aj.Locked=false
ak=true
return aj.InputFrame:Unlock()
end

function aj.Set(am,an,ao)
if ak then
aj.Value=an
aa.SafeCallback(aj.Callback,an)

if not ao then
al.Frame.Frame.TextBox.Text=an
end
end
end

function aj.SetPlaceholder(am,an)
al.Frame.Frame.TextBox.PlaceholderText=an
aj.Placeholder=an
end

aj:Set(aj.Value)

if aj.Locked then
aj:Lock()
end

return aj.__type,aj
end

return ae end function a.S()

local aa=a.load'd'
local ae=aa.New

local af={}

function af.New(ag,ah)
local ai=ae("Frame",{
Size=ah.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local aj=ae("Frame",{
Parent=ah.Parent,
Size=ah.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
ai
})

return"Divider",{__type="Divider",ElementFrame=aj}
end

return af end function a.T()
local aa={}

local ae=(cloneref or clonereference or function(ae)
return ae
end)

local af=ae(game:GetService"UserInputService")
local ag=ae(game:GetService"Players").LocalPlayer:GetMouse()
local ah=ae(game:GetService"Workspace")
local ai=ah.CurrentCamera local aj=

workspace.CurrentCamera

local ak=a.load'd'
local al=a.load'e'
local am=ak.New
local an=ak.Tween

local ao=0.76

function aa.New(ap,aq,ar,as)
local at={}

if not aq.Callback then
as="Menu"
end

aq.UIElements.UIListLayout=am("UIListLayout",{
Padding=UDim.new(0,ar.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

aq.UIElements.Menu=ak.NewRoundFrame(ar.MenuCorner,aq.Glass and"SquircleGlass"or"Squircle",{
ThemeTag={
ImageColor3="DropdownBackground",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
am("UIPadding",{
PaddingTop=UDim.new(0,ar.MenuPadding),
PaddingLeft=UDim.new(0,ar.MenuPadding),
PaddingRight=UDim.new(0,ar.MenuPadding),
PaddingBottom=UDim.new(0,ar.MenuPadding),
}),
am("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ar.MenuPadding),
}),
am("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,aq.SearchBarEnabled and-ar.MenuPadding-ar.SearchBarHeight),

ClipsDescendants=true,
LayoutOrder=999,
Name="Frame",
},{
am("UICorner",{
CornerRadius=UDim.new(0,ar.MenuCorner-ar.MenuPadding),
}),
am("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
aq.UIElements.UIListLayout,
}),
}),
})

aq.UIElements.MenuCanvas=am("Frame",{
Size=UDim2.new(0,aq.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,

Parent=ap.WindUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
aq.UIElements.Menu,
am("UISizeConstraint",{
MinSize=Vector2.new(aq.Compact and 148 or 170,0),
MaxSize=Vector2.new(aq.MenuMaxWidth or 420,aq.MenuMaxHeight or 340),
}),
})

local function GetLayoutScale()
local au=ap.UIScale or ak.UIScale or 1
return au>0 and au or 1
end

local function GetVisibleContentHeight()
local au=0
local av=0
local aw=GetLayoutScale()
local ax=aq.UIElements.Menu.Frame.ScrollingFrame

for ay,az in next,ax:GetChildren()do
if az:IsA"GuiObject"and az.Visible then
local aA=az.AbsoluteSize.Y/aw
if aA<=0 then
aA=az.Size.Y.Offset>0 and az.Size.Y.Offset or aq.ItemHeight
end

au+=aA
av+=1
end
end

if av>1 then
au+=aq.UIElements.UIListLayout.Padding.Offset*(av-1)
end

return au
end

local function RecalculateCanvasSize()
aq.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,GetVisibleContentHeight())
end

local function GetDropdownButton()
return aq.UIElements.Dropdown or aq.DropdownFrame.UIElements.Main
end

local function GetViewportSize()
if ap.WindUI.DropdownGui and ap.WindUI.DropdownGui.AbsoluteSize.X>0 then
return ap.WindUI.DropdownGui.AbsoluteSize
end
local au=ah.CurrentCamera or ai
return au and au.ViewportSize or Vector2.new(1280,720)
end

local function GetInputPosition(au)
if au and typeof(au.Position)=="Vector3"then
return Vector2.new(au.Position.X,au.Position.Y)
end
return Vector2.new(ag.X,ag.Y)
end

local function ContainsPoint(au,av)
if typeof(au)~="Instance"or not au.Visible then
return false
end

local aw=au.AbsolutePosition
local ax=au.AbsoluteSize

return av.X>=aw.X
and av.X<=aw.X+ax.X
and av.Y>=aw.Y
and av.Y<=aw.Y+ax.Y
end

local function NormalizeDirection(au,av)
local aw=tostring(au or av or"Auto")
aw=aw:sub(1,1):upper()..aw:sub(2):lower()
if aw~="Auto"and aw~="Down"and aw~="Up"and aw~="Left"and aw~="Right"then
return av or"Auto"
end
return aw
end

local function NormalizeSide(au,av)
local aw=tostring(au or av or"Right")
aw=aw:sub(1,1):upper()..aw:sub(2):lower()
if aw~="Left"and aw~="Center"and aw~="Right"then
return av or"Right"
end
return aw
end

local function IsMobileViewport()
local au=GetViewportSize()
return ap.Window.IsPC==false
or(af.TouchEnabled and not af.KeyboardEnabled)
or au.X<=640
end

local function GetCanvasWidth()
local au=GetDropdownButton()
local av=GetViewportSize()
local aw=math.max(ar.MenuPadding*2,8)
local ax=math.max(
120,
math.min(aq.MenuMaxWidth or(IsMobileViewport()and 320 or 420),av.X-(aw*2))
)
local ay=math.min(aq.Compact and 148 or 170,ax)
local az=au.AbsoluteSize.X>0 and au.AbsoluteSize.X or aq.MenuWidth
local aA=aq.FullWidth and math.max(az,aq.MenuWidth)or aq.MenuWidth

return math.floor(math.clamp(aA,ay,ax)+0.5)
end

local function ApplyCanvasWidth()
local au=GetCanvasWidth()
aq.UIElements.MenuCanvas.Size=UDim2.new(
0,
au,
aq.UIElements.MenuCanvas.Size.Y.Scale,
aq.UIElements.MenuCanvas.Size.Y.Offset
)
end

local function RecalculateListSize()
ApplyCanvasWidth()

local au=GetViewportSize()
local av=aq.SearchBarEnabled and(ar.SearchBarHeight+44)or 44
local aw=math.max(
av,
math.min(aq.MenuMaxHeight or(IsMobileViewport()and 280 or 340),au.Y-(ar.MenuPadding*4))
)

local ax=GetVisibleContentHeight()
local ay=aq.SearchBarEnabled and(ar.SearchBarHeight+(ar.MenuPadding*3))
or(ar.MenuPadding*2)
local az=ax+ay

if az>aw then
aq.UIElements.MenuCanvas.Size=
UDim2.fromOffset(aq.UIElements.MenuCanvas.AbsoluteSize.X,aw)
else
aq.UIElements.MenuCanvas.Size=
UDim2.fromOffset(aq.UIElements.MenuCanvas.AbsoluteSize.X,az)
end
end

function UpdatePosition()
local au=GetDropdownButton()
local av=aq.UIElements.MenuCanvas
local aw=GetViewportSize()
local ax=ar.MenuPadding*2
local ay=IsMobileViewport()
local az=NormalizeDirection(ay and(aq.MobileDirection or aq.Direction)or aq.Direction,"Auto")
local aA=NormalizeSide(ay and(aq.MobileSide or"Center")or aq.Side,ay and"Center"or"Right")
local aB=au.AbsolutePosition
local b=au.AbsoluteSize
local d=av.AbsoluteSize

if d.X<=0 or d.Y<=0 then
d=Vector2.new(av.Size.X.Offset,av.Size.Y.Offset)
end

if ay and not aq.MobileDirection and(az=="Left"or az=="Right")then
az="Auto"
end

if az=="Left"and aB.X-ax<d.X then
az="Auto"
elseif az=="Right"and aw.X-(aB.X+b.X)-ax<d.X then
az="Auto"
end

if az=="Auto"then
local f=aw.Y-(aB.Y+b.Y)-ax
local g=aB.Y-ax
if f>=d.Y or f>=g then
az="Down"
else
az="Up"
end
end

if az~="Up"and az~="Left"and az~="Right"then
az="Down"
end

local f
local g
local h=Vector2.new(1,0)

if az=="Left"then
f=aB.X-ax
g=aB.Y
h=Vector2.new(1,0)
elseif az=="Right"then
f=aB.X+b.X+ax
g=aB.Y
h=Vector2.new(0,0)
elseif az=="Up"then
g=aB.Y-ax
h=Vector2.new(aA=="Left"and 0 or aA=="Center"and 0.5 or 1,1)
if aA=="Left"then
f=aB.X
elseif aA=="Center"then
f=aB.X+(b.X/2)
else
f=aB.X+b.X
end
else
g=aB.Y+b.Y+ax
h=Vector2.new(aA=="Left"and 0 or aA=="Center"and 0.5 or 1,0)
if aA=="Left"then
f=aB.X
elseif aA=="Center"then
f=aB.X+(b.X/2)
else
f=aB.X+b.X
end
end

local i=f-(h.X*d.X)
local l=g-(h.Y*d.Y)

if i<ax then
f+=ax-i
elseif i+d.X>aw.X-ax then
f-=(i+d.X)-(aw.X-ax)
end

if l<ax then
g+=ax-l
elseif l+d.Y>aw.Y-ax then
g-=(l+d.Y)-(aw.Y-ax)
end

av.AnchorPoint=h
av.Position=UDim2.fromOffset(math.floor(f+0.5),math.floor(g+0.5))
aq.UIElements.Menu.AnchorPoint=az=="Left"and Vector2.new(1,0)
or az=="Right"and Vector2.new(0,0)
or az=="Up"and Vector2.new(1,1)
or Vector2.new(1,0)
aq.UIElements.Menu.Position=az=="Left"and UDim2.new(1,0,0,0)
or az=="Right"and UDim2.new(0,0,0,0)
or az=="Up"and UDim2.new(1,0,1,0)
or UDim2.new(1,0,0,0)

return az
end

local au
local av=""
local aw
local ax

local function CreateSearchBar()
local ay=math.max(ar.MenuCorner-ar.MenuPadding,6)
local az=ak.Icon"search"

aw=am("TextBox",{
Name="TextBox",
BackgroundTransparency=1,
ClearTextOnFocus=false,
ClipsDescendants=true,
FontFace=Font.new(ak.Font,Enum.FontWeight.Regular),
PlaceholderText=aq.SearchPlaceholder,
Text=av,
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

local aA=ak.NewRoundFrame(ay,"Squircle",{
Name="SearchBar",
LayoutOrder=0,
Parent=aq.UIElements.Menu,
Size=UDim2.new(1,0,0,ar.SearchBarHeight),
ImageTransparency=0,
ThemeTag={
ImageColor3="DropdownTabBackground",
},
},{
ak.NewRoundFrame(ay,"Squircle",{
Name="Outline",
Size=UDim2.new(1,1,1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageTransparency=0.8,
ThemeTag={
ImageColor3="DropdownTabBorder",
},
}),
am("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
},{
am("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
am("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Left",
VerticalAlignment="Center",
Padding=UDim.new(0,8),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
am("ImageLabel",{
Name="Icon",
BackgroundTransparency=1,
Image=az[1],
ImageRectOffset=az[2].ImageRectPosition,
ImageRectSize=az[2].ImageRectSize,
ImageTransparency=0.18,
Size=UDim2.new(0,19,0,19),
ThemeTag={
ImageColor3="Icon",
},
}),
aw,
}),
})

ak.AddSignal(aw:GetPropertyChangedSignal"Text",function()
ax(aw.Text)
end)

ak.AddSignal(aw.Focused,function()
an(aA.Outline,0.12,{ImageTransparency=0.48}):Play()
end)

ak.AddSignal(aw.FocusLost,function()
an(aA.Outline,0.12,{ImageTransparency=0.8}):Play()
end)

return aA
end

local function GetSearchText(ay)
local az={
ay.Name,
ay.Desc,
}

if typeof(ay.Original)=="table"then
table.insert(az,ay.Original.Value)
table.insert(az,ay.Original.Id)
table.insert(az,ay.Original.Key)
end

local aA={}
for aB,b in next,az do
if b~=nil then
table.insert(aA,tostring(b))
end
end

return string.lower(table.concat(aA," "))
end

function ax(ay)
av=tostring(ay or"")
local az=string.lower(av)

for aA,aB in next,aq.Tabs do
if aB.UIElements and aB.UIElements.TabItem then
local b=aB.UIElements.TabItem
local d=az==""or string.find(GetSearchText(aB),az,1,true)~=nil
if d then
if not b.Parent then
b.Parent=aq.UIElements.Menu.Frame.ScrollingFrame
end
b.Visible=true
b.Size=aB.Size
b.AutomaticSize=aB.AutomaticSize
else
b.Visible=false
end
end
end

RecalculateCanvasSize()
RecalculateListSize()

if aq.UIElements.MenuCanvas.Visible then
UpdatePosition()
end

task.defer(function()
if ap.Window.Destroyed then
return
end

RecalculateCanvasSize()
RecalculateListSize()

if aq.UIElements.MenuCanvas.Visible then
UpdatePosition()
end
end)
end

function at.Display(ay)
local az=aq.Values
local aA=""

if aq.Multi then
local aB={}
if typeof(aq.Value)=="table"then
for b,d in ipairs(aq.Value)do
local f=typeof(d)=="table"and d.Title or d
aB[f]=true
end
end

for b,d in ipairs(az)do
local f=typeof(d)=="table"and d.Title or d
if aB[f]then
aA=aA..f..", "
end
end

if#aA>0 then
aA=aA:sub(1,#aA-2)
end
else
aA=typeof(aq.Value)=="table"and(aq.Value.Title or aq.Value[1])
or aq.Value
or""
end

if aq.UIElements.Dropdown then
aq.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(aA==""and"--"or aA)
end
end

local function Callback(ay)
at:Display()
if aq.Locked then
return
end

if aq.Callback then
task.spawn(function()
if aq.Locked then
return
end
ak.SafeCallback(aq.Callback,aq.Value)
end)
else
task.spawn(function()
if aq.Locked then
return
end
ak.SafeCallback(ay)
end)
end
end

function at.LockValues(ay,az)
if not az then
return
end

for aA,aB in next,aq.Tabs do
if aB and aB.UIElements and aB.UIElements.TabItem then
local b=aB.Name
local d=false

for f,g in next,az do
if b==g then
d=true
break
end
end

if d then
an(aB.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

an(aB.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if aB.UIElements.TabIcon then
an(aB.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

aB.UIElements.TabItem.Active=false
aB.Locked=true
else
if aB.Selected then
an(aB.UIElements.TabItem,0.1,{ImageTransparency=ao}):Play()

an(aB.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aB.UIElements.TabIcon then
an(aB.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
an(aB.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

an(
aB.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=as=="Dropdown"and 0.4 or 0.05}
):Play()
if aB.UIElements.TabIcon then
an(
aB.UIElements.TabIcon.ImageLabel,
0.1,
{ImageTransparency=as=="Dropdown"and 0.2 or 0}
):Play()
end
end

aB.UIElements.TabItem.Active=true
aB.Locked=false
end
end
end
end

function at.Refresh(ay,az)
if ap.Window.Destroyed then
return
end

for aA,aB in next,aq.Tabs do
if aB.UIElements and aB.UIElements.TabItem then
aB.UIElements.TabItem:Destroy()
end
end

for aA,aB in next,aq.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not aB:IsA"UIListLayout"then
aB:Destroy()
end
end

aq.Tabs={}

if aq.SearchBarEnabled then
if not au then
au=CreateSearchBar()
elseif aw then
aw.PlaceholderText=aq.SearchPlaceholder
end
end

for aA,aB in next,az do
if typeof(aB)~="table"or aB.Type~="Divider"then
local b={
Name=typeof(aB)=="table"and aB.Title or aB,
Desc=typeof(aB)=="table"and aB.Desc or nil,
Icon=typeof(aB)=="table"and aB.Icon or nil,
IconSize=typeof(aB)=="table"and aB.IconSize or nil,
Original=aB,
Selected=false,
Locked=typeof(aB)=="table"and aB.Locked or false,
UIElements={},
}
local d
if b.Icon then
d=ak.Image(b.Icon,b.Icon,0,ap.Window.Folder,"Dropdown",true)
d.Size=
UDim2.new(0,b.IconSize or ar.TabIcon,0,b.IconSize or ar.TabIcon)
d.ImageLabel.ImageTransparency=as=="Dropdown"and 0.2 or 0
b.UIElements.TabIcon=d
end
b.UIElements.TabItem=ak.NewRoundFrame(
ar.MenuCorner-ar.MenuPadding,
"Squircle",
{
Size=UDim2.new(1,0,0,aq.ItemHeight),
AutomaticSize=b.Desc and"Y",
LayoutOrder=typeof(aA)=="number"and aA or 0,
ImageTransparency=1,
Parent=aq.UIElements.Menu.Frame.ScrollingFrame,

ThemeTag={
ImageColor3="DropdownTabBackground",
},
Active=not b.Locked,
},
{
ak.NewRoundFrame(ar.MenuCorner-ar.MenuPadding,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="DropdownTabBorder",
},
ImageTransparency=1,
Name="Highlight",
},{













}),
am("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
am("UIListLayout",{
Padding=UDim.new(0,ar.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
am("UIPadding",{
PaddingTop=UDim.new(0,ar.TabPadding),
PaddingLeft=UDim.new(0,ar.TabPadding),
PaddingRight=UDim.new(0,ar.TabPadding),
PaddingBottom=UDim.new(0,ar.TabPadding),
}),
am("UICorner",{
CornerRadius=UDim.new(0,ar.MenuCorner-ar.MenuPadding),
}),
d,
am("Frame",{
Size=UDim2.new(1,d and-ar.TabPadding-ar.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
am("TextLabel",{
Text=b.Name,
TextXAlignment="Left",
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=14,
BackgroundTransparency=1,
TextTransparency=as=="Dropdown"and 0.4 or 0.05,
LayoutOrder=999,
AutomaticSize="Y",
TextTruncate="AtEnd",
Size=UDim2.new(1,0,0,0),
}),
am("TextLabel",{
Text=b.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(ak.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=13,
BackgroundTransparency=1,
TextTransparency=as=="Dropdown"and 0.6 or 0.35,
LayoutOrder=999,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=b.Desc and true or false,
Name="Desc",
}),
am("UIListLayout",{
Padding=UDim.new(0,ar.TabPadding/3),
FillDirection="Vertical",
}),
}),
}),
},
true
)
b.Size=b.UIElements.TabItem.Size
b.AutomaticSize=b.UIElements.TabItem.AutomaticSize

if b.Locked then
b.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if b.UIElements.TabIcon then
b.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if aq.Multi and typeof(aq.Value)=="string"then
for f,g in next,aq.Values do
if typeof(g)=="table"then
if g.Title==aq.Value then
aq.Value={g}
end
else
if g==aq.Value then
aq.Value={aq.Value}
end
end
end
end

if aq.Multi then
local f=false
if typeof(aq.Value)=="table"then
for g,h in ipairs(aq.Value)do
local i=typeof(h)=="table"and h.Title or h
if i==b.Name then
f=true
break
end
end
end
b.Selected=f
else
local f=typeof(aq.Value)=="table"and aq.Value.Title or aq.Value
b.Selected=f==b.Name
end

if b.Selected and not b.Locked then
b.UIElements.TabItem.ImageTransparency=ao

b.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if b.UIElements.TabIcon then
b.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

aq.Tabs[aA]=b

at:Display()

if as=="Dropdown"then
ak.AddSignal(b.UIElements.TabItem.MouseButton1Click,function()
if aq.Locked or b.Locked then
return
end

if aq.Multi then
if not b.Selected then
b.Selected=true
an(
b.UIElements.TabItem,
0.1,
{ImageTransparency=ao}
):Play()

an(b.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if b.UIElements.TabIcon then
an(b.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(aq.Value,b.Original)
else
if not aq.AllowNone and#aq.Value==1 then
return
end
b.Selected=false
an(b.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

an(b.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.4}):Play()
if b.UIElements.TabIcon then
an(b.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end

for f,g in next,aq.Value do
if typeof(g)=="table"and(g.Title==b.Name)or(g==b.Name)then
table.remove(aq.Value,f)
break
end
end
end
else
for f,g in next,aq.Tabs do
an(g.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()

an(
g.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=0.4}
):Play()
if g.UIElements.TabIcon then
an(g.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end
g.Selected=false
end
b.Selected=true
an(b.UIElements.TabItem,0.1,{ImageTransparency=ao}):Play()

an(b.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if b.UIElements.TabIcon then
an(b.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
aq.Value=b.Original
end
Callback()
if not aq.Multi then
at:Close()
end
end)
elseif as=="Menu"then
if not b.Locked then
ak.AddSignal(b.UIElements.TabItem.MouseEnter,function()
an(b.UIElements.TabItem,0.08,{ImageTransparency=ao}):Play()
end)
ak.AddSignal(b.UIElements.TabItem.InputEnded,function()
an(b.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()
end)
end
ak.AddSignal(b.UIElements.TabItem.MouseButton1Click,function()
if aq.Locked or b.Locked then
return
end
Callback(aB.Callback or function()end)
at:Close()
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.load'S'
:New{Parent=aq.UIElements.Menu.Frame.ScrollingFrame}
end
end










ApplyCanvasWidth()
ax(av)
Callback()

aq.Values=az
end

at:Refresh(aq.Values)

function at.Select(ay,az)
if az then
aq.Value=az
else
if aq.Multi then
aq.Value={}
else
aq.Value=nil
end
end
at:Refresh(aq.Values)
end

RecalculateListSize()
RecalculateCanvasSize()

local ay=0
local az="Down"

function at.Open(aA)
if not aq.Locked then
ay+=1
local aB=ay
aq.UIElements.Menu.Visible=true
aq.UIElements.MenuCanvas.Visible=true
aq.UIElements.MenuCanvas.Active=true
RecalculateListSize()
RecalculateCanvasSize()
az=UpdatePosition()
local b=az=="Left"or az=="Right"
aq.UIElements.Menu.Size=b and UDim2.new(0,0,1,0)or UDim2.new(1,0,0,0)
al.Play(aq.UIElements.Menu,"DropdownOpen",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=aq.Glass and aq.GlassTransparency or 0,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out,"OpenClose")

task.spawn(function()
task.wait(al.GetDuration"DropdownOpen")
if aq.Locked or ay~=aB then
return
end
aq.Opened=true
end)

UpdatePosition()
end
end

function at.Close(aA)
ay+=1
local aB=ay
aq.Opened=false

local b=az=="Left"or az=="Right"
al.Play(aq.UIElements.Menu,"DropdownClose",{
Size=b and UDim2.new(0,0,1,0)or UDim2.new(1,0,0,0),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out,"OpenClose")

task.spawn(function()
task.wait(al.GetDuration"DropdownClose")
if ay~=aB then
return
end
aq.UIElements.Menu.Visible=false
aq.UIElements.MenuCanvas.Visible=false
aq.UIElements.MenuCanvas.Active=false
end)
end

ak.AddSignal(
(
aq.UIElements.Dropdown and aq.UIElements.Dropdown.MouseButton1Click
or aq.DropdownFrame.UIElements.Main.MouseButton1Click
),
function()
if aq.Opened or aq.UIElements.MenuCanvas.Visible then
at:Close()
else
at:Open()
end
end
)

ak.AddSignal(af.InputBegan,function(aA)
if
aA.UserInputType==Enum.UserInputType.MouseButton1
or aA.UserInputType==Enum.UserInputType.Touch
then
local aB=aq.UIElements.MenuCanvas
local b=aq.UIElements.Dropdown or aq.DropdownFrame.UIElements.Main
local d=GetInputPosition(aA)
local f=ContainsPoint(b,d)
local g=ContainsPoint(aB,d)

if
ap.Window.CanDropdown
and(aq.Opened or aB.Visible)
and not f
and not g
then
at:Close()
end
end
end)

ak.AddSignal(
aq.UIElements.Dropdown and aq.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"
or aq.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

if ap.WindUI.DropdownGui then
ak.AddSignal(ap.WindUI.DropdownGui:GetPropertyChangedSignal"AbsoluteSize",function()
if aq.UIElements.MenuCanvas.Visible then
RecalculateListSize()
UpdatePosition()
end
end)
end

return at
end

return aa end function a.U()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ae=
aa(game:GetService"Workspace").CurrentCamera

local af=a.load'd'
local ag=af.New local ah=
af.Tween

local ai=a.load'y'.New local aj=a.load'o'
.New
local ak=a.load'T'.New local al=

workspace.CurrentCamera

local am={
UICorner=10,
UIPadding=12,
MenuCorner=14,
MenuPadding=4,
TabPadding=8,
SearchBarHeight=36,
TabIcon=16,
ItemHeight=32,
}

function am.New(an,ao)
local ap=ao.Values or{}
local aq=ao.SearchBarEnabled
if aq==nil then
if ao.Search~=nil then
aq=ao.Search
elseif ao.EnableSearch~=nil then
aq=ao.EnableSearch
else
aq=#ap>=(ao.SearchThreshold or 7)
end
end

local ar=ao.Compact~=false

local as={
__type="Dropdown",
Title=ao.Title or"Dropdown",
Desc=ao.Desc or nil,
Locked=ao.Locked or false,
LockedTitle=ao.LockedTitle,
Values=ap,
MenuWidth=ao.MenuWidth or(ar and 164 or 180),
MenuMaxWidth=ao.MenuMaxWidth,
FullWidth=ao.FullWidth or ao.Full or ao.Mode=="Full"or ao.MenuMode=="Full",
Direction=ao.Direction or ao.OpenDirection or"Auto",
Side=ao.Side or ao.Align or ao.Alignment or"Right",
MobileDirection=ao.MobileDirection or ao.MobileOpenDirection,
MobileSide=ao.MobileSide or ao.MobileAlign,
Value=ao.Value,
AllowNone=ao.AllowNone,
SearchBarEnabled=aq==true,
SearchPlaceholder=ao.SearchPlaceholder or"Search...",
Compact=ar,
Glass=ao.Glass==true,
GlassTransparency=ao.GlassTransparency or ao.MenuTransparency or 0,
ItemHeight=ao.ItemHeight or(ar and am.ItemHeight or 36),
Multi=ao.Multi,
Callback=ao.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=ao.Width or(ar and 136 or 150),
}

if as.Multi and not as.Value then
as.Value={}
end
if as.Values and typeof(as.Value)=="number"then
as.Value=as.Values[as.Value]
end

as.DropdownFrame=a.load'I'{
Title=as.Title,
Desc=as.Desc,
Parent=ao.Parent,
TextOffset=as.Callback and as.Width or 20,
Hover=not as.Callback and true or false,
Tab=ao.Tab,
Index=ao.Index,
Window=ao.Window,
ElementTable=as,
ParentConfig=ao,
Tags=ao.Tags,
}

if as.Callback then
as.UIElements.Dropdown=
ai("",nil,as.DropdownFrame.UIElements.Main,nil,ao.Window.NewElements and 12 or 10)

as.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
as.UIElements.Dropdown.Frame.Frame.TextLabel.Size=
UDim2.new(1,as.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

as.UIElements.Dropdown.Size=UDim2.new(0,as.Width,0,ar and 32 or 36)
as.UIElements.Dropdown.Position=UDim2.new(1,0,ao.Window.NewElements and 0 or 0.5,0)
as.UIElements.Dropdown.AnchorPoint=Vector2.new(1,ao.Window.NewElements and 0 or 0.5)





end

as.DropdownMenu=ak(ao,as,am,"Dropdown")

as.Display=as.DropdownMenu.Display
as.Refresh=as.DropdownMenu.Refresh
as.Select=as.DropdownMenu.Select
as.Open=as.DropdownMenu.Open
as.Close=as.DropdownMenu.Close

ag("ImageLabel",{
Image=af.Icon"chevrons-up-down"[1],
ImageRectOffset=af.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=af.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,as.UIElements.Dropdown and-12 or 0,0.5,0),
ThemeTag={
ImageColor3="Icon",
},
AnchorPoint=Vector2.new(1,0.5),
Parent=as.UIElements.Dropdown and as.UIElements.Dropdown.Frame
or as.DropdownFrame.UIElements.Main,
})

function as.Lock(at)
as.Locked=true
if as.Opened or as.UIElements.MenuCanvas.Visible then
as:Close()
end
return as.DropdownFrame:Lock(as.LockedTitle)
end
function as.Unlock(at)
as.Locked=false
return as.DropdownFrame:Unlock()
end

if as.Locked then
as:Lock()
end

return as.__type,as
end

return am end function a.V()




local aa={}
local af={
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

local ag={
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

local function createKeywordSet(ai)
local ak={}
for al,am in ipairs(ai)do
ak[am]=true
end
return ak
end

local ai=createKeywordSet(af.lua)
local ak=createKeywordSet(af.rbx)
local al=createKeywordSet(af.operators)

local function getHighlight(am,an)
local ao=am[an]

if ag[ao.."_color"]then
return ag[ao.."_color"]
end

if tonumber(ao)then
return ag.numbers
elseif ao=="nil"then
return ag.null
elseif ao:sub(1,2)=="--"then
return ag.comment
elseif al[ao]then
return ag.operator
elseif ai[ao]then
return ag.lua
elseif ak[ao]then
return ag.rbx
elseif ao:sub(1,1)=='"'or ao:sub(1,1)=="'"then
return ag.str
elseif ao=="true"or ao=="false"then
return ag.boolean
end

if am[an+1]=="("then
if am[an-1]==":"then
return ag.self_call
end

return ag.call
end

if am[an-1]=="."then
if am[an-2]=="Enum"then
return ag.rbx
end

return ag.local_property
end
end

function aa.run(am,an)
if an~=nil then
for ao,ap in next,an do
ag[ao]=ap
end
end

local ao={}
local ap=""

local aq=false
local ar=false
local as=false

for at=1,#am do
local au=am:sub(at,at)

if ar then
if au=="\n"and not as then
table.insert(ao,ap)
table.insert(ao,au)
ap=""

ar=false
elseif am:sub(at-1,at)=="]]"and as then
ap=ap.."]"

table.insert(ao,ap)
ap=""

ar=false
as=false
else
ap=ap..au
end
elseif aq then
if au==aq and am:sub(at-1,at-1)~="\\"or au=="\n"then
ap=ap..au
aq=false
else
ap=ap..au
end
else
if am:sub(at,at+1)=="--"then
table.insert(ao,ap)
ap="-"
ar=true
as=am:sub(at+2,at+3)=="[["
elseif au=='"'or au=="'"then
table.insert(ao,ap)
ap=au
aq=au
elseif al[au]then
table.insert(ao,ap)
table.insert(ao,au)
ap=""
elseif au:match"[%w_]"then
ap=ap..au
else
table.insert(ao,ap)
table.insert(ao,au)
ap=""
end
end
end

table.insert(ao,ap)

local at={}

for au,av in ipairs(ao)do
local aw=getHighlight(ao,au)

if aw then
local ax=string.format(
'<font color = "#%s">%s</font>',
aw:ToHex(),
av:gsub("<","&lt;"):gsub(">","&gt;")
)

table.insert(at,ax)
else
table.insert(at,av)
end
end

return table.concat(at)
end

return aa end function a.W()

local aa={}

local af=a.load'd'
local ag=af.New
local ai=af.Tween

local ak=a.load'V'

function aa.New(al,am,an,ao,ap)
local aq={
Radius=am.ElementConfig.UICorner,
Padding=am.NewElements and am.ElementConfig.UIPadding+4 or am.ElementConfig.UIPadding,

CodeFrame=nil,
}

local ar=ag("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=al.CodeSize,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ag("UIPadding",{
PaddingTop=UDim.new(0,aq.Padding+3),
PaddingLeft=UDim.new(0,aq.Padding+3),
PaddingRight=UDim.new(0,aq.Padding+3),
PaddingBottom=UDim.new(0,aq.Padding+3),
}),
})
ar.Font="Code"

local as=ag("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize=al.Height~=nil and"XY"or"X",
ScrollingDirection=al.Height~=nil and"XY"or"X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
ar,
})

local at=al.CanCopied
and ag("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,35,0,35),
Position=UDim2.new(1,-aq.Padding/2,0,aq.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=ao and true or false,
},{
af.NewRoundFrame(aq.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
ag("UIScale",{
Scale=1,
}),
ag("ImageLabel",{
Image=af.Icon"copy"[1],
ImageRectSize=af.Icon"copy"[2].ImageRectSize,
ImageRectOffset=af.Icon"copy"[2].ImageRectPosition,
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

local au,av=af.NewRoundFrame(aq.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=0.955,
Visible=false,
})

local aw,ax=af.NewRoundFrame(aq.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=0.96,
Size=UDim2.new(1,0,0,20+(aq.Padding*2)),
Visible=al.Title and true or false,
},{










ag("TextLabel",{
Text=al.Title,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=0.2,
TextSize=18,
AutomaticSize="Y",
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,at and-20-(aq.Padding*2),0,0),
}),
ag("UIPadding",{

PaddingLeft=UDim.new(0,aq.Padding+3),
PaddingRight=UDim.new(0,aq.Padding+3),

}),
ag("UIListLayout",{
Padding=UDim.new(0,aq.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local ay,az=af.NewRoundFrame(aq.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=0.035,
Size=al.Height~=nil
and UDim2.new(1,0,al.Height.Scale,al.Height.Offset==0 and-40 or al.Height.Offset)
or UDim2.new(1,0,0,20+(aq.Padding*2)),
AutomaticSize=al.Height~=nil and"None"or"Y",
Parent=an,
},{
au,
ag("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,al.Height~=nil and 1 or 0,0),
AutomaticSize=al.Height~=nil and"None"or"Y",
},{
aw,
as,
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
at,
},nil,true)

aq.CodeFrame=ay
aq.CodeFrameModule=az
aq.OutlineFrame=au
aq.OutlineFrameModule=av
aq.TopbarFrame=aw
aq.TopbarFrameModule=ax

af.AddSignal(ar:GetPropertyChangedSignal"TextBounds",function()
if al.Height~=nil then
as.Size=UDim2.new(1,0,1,al.Title~=nil and-(20+(aq.Padding*2))or nil)
else
as.Size=
UDim2.new(1,0,0,(ar.TextBounds.Y/(ap or 1))+((aq.Padding+3)*2))
end
end)

function aq.Set(aA)
ar.Text=ak.run(aA,al.CodeTheme)
end

function aq.Destroy()
ay:Destroy()
aq=nil
end

aq.Set(al.Code)

if at then
af.AddSignal(at.InputBegan,function(aA:InputObject)
if
aA.UserInputType==Enum.UserInputType.MouseButton1
or aA.UserInputType==Enum.UserInputType.Touch
then
ai(at.Button,0.05,{ImageTransparency=0.95}):Play()
ai(at.Button.UIScale,0.05,{Scale=0.9}):Play()
end
end)
af.AddSignal(at.InputEnded,function()
ai(at.Button,0.08,{ImageTransparency=1}):Play()
ai(at.Button.UIScale,0.08,{Scale=1}):Play()
end)
af.AddSignal(at.MouseButton1Click,function()
if ao then
ao()
local aA=af.Icon"check"
at.Button.ImageLabel.Image=aA[1]
at.Button.ImageLabel.ImageRectSize=aA[2].ImageRectSize
at.Button.ImageLabel.ImageRectOffset=aA[2].ImageRectPosition

task.delay(1,function()
local aB=af.Icon"copy"
at.Button.ImageLabel.Image=aB[1]
at.Button.ImageLabel.ImageRectSize=aB[2].ImageRectSize
at.Button.ImageLabel.ImageRectOffset=aB[2].ImageRectPosition
end)
end
end)
end

return aq
end

return aa end function a.X()

local aa=a.load'd'local af=
aa.New


local ag=a.load'W'

local ai={}

function ai.New(ak,al)
local am={
__type="Code",
Title=al.Title,
Code=al.Code,
CodeSize=al.CodeSize or 18,
Height=al.Height,
CodeTheme=al.CodeTheme,
Locked=false,
CanCopied=al.CanCopied~=false,
OnCopy=al.OnCopy,

Index=al.Index,
}

local an=not am.Locked











local ao=ag.New(am,al.Window,al.Parent,function()
if an then
local ao=am.Title or"code"
local ap,aq=pcall(function()
if toclipboard then
toclipboard(am.Code)
end
if setclipboard then
setclipboard(am.Code)
end

if am.OnCopy then
am.OnCopy()
end
end)
if not ap then
al.WindUI:Notify{
Title="Error",
Content="The "..ao.." is not copied. Error: "..aq,
Icon="x",
Duration=5,
}
end
end
end,al.WindUI.UIScale)

function am.SetCode(ap,aq)
ao.Set(aq)
am.Code=aq
end

function am.Set(ap,aq)
return am.SetCode(aq)
end

function am.Destroy(ap)
ao.Destroy()
am=nil
end

function am.UpdateShape(ap)
if al.Window.NewElements then
local aq=al.Window.ElementConfig.LinkCorners or al.LinkCorners==true
local ar="Squircle"

if aq then
ar=aa.GetLinkedCornerShape(
ap.Elements,
am.Index,
ap,
al.ParentType
)
end

if ar and ao.CodeFrameModule then
local as=(ar=="Squircle-TL-BL"or ar=="Squircle-TR-BR")and"Squircle"
or ar

ao.CodeFrameModule:SetType(as)

ao.TopbarFrameModule:SetType(
table.find({"Squircle-BL-BR","SquircleH-BL-BR","Squircle-TR-BR"},ar)~=nil and"Square"
or as
)
end
end
end

am.UIElements={Main=ao.CodeFrame}
am.ElementFrame=ao.CodeFrame

return am.__type,am
end

return ai end function a.Y()

local aa=a.load'd'
local af=aa.New local ag=
aa.Tween

local ai=(cloneref or clonereference or function(ai)
return ai
end)

local ak=ai(game:GetService"UserInputService")
ai(game:GetService"TouchInputService")
local al=ai(game:GetService"RunService")
local am=ai(game:GetService"Players")local an=

al.RenderStepped
local ao=am.LocalPlayer
local ap=ao:GetMouse()

local aq=a.load'n'.New
local ar=a.load'o'.New

local as={
UICorner=9,

}

local at

function as.Colorpicker(au,av,aw,ax,ay)
local az={
__type="Colorpicker",
Title=av.Title,
Desc=av.Desc,
Default=av.Value or av.Default,
Callback=av.Callback,
Transparency=av.Transparency,
UIElements=av.UIElements,

TextPadding=10,
}

local aA={}
local aB=az.Transparency~=nil

function az.SetHSVFromRGB(b,d)
local f,g,h=Color3.toHSV(d)
az.Hue=f
az.Sat=g
az.Vib=h
end

az:SetHSVFromRGB(az.Default)

local b=a.load'p'
local d=b.Create(nil,"Dialog",aw,ax,aw.UIElements.Main.Main)

az.ColorpickerFrame=d

d.UIElements.Main.Size=UDim2.new(1,0,0,0)



local f,g,h=az.Hue,az.Sat,az.Vib

az.UIElements.Title=af("TextLabel",{
Text=az.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=d.UIElements.Main,
},{
af("UIPadding",{
PaddingTop=UDim.new(0,az.TextPadding/2),
PaddingLeft=UDim.new(0,az.TextPadding/2),
PaddingRight=UDim.new(0,az.TextPadding/2),
PaddingBottom=UDim.new(0,az.TextPadding/2),
}),
})





local i=af("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local l=af("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=i,
BackgroundColor3=az.Default,
},{
af("UIStroke",{
Thickness=2,
Transparency=0.1,
ThemeTag={
Color="Text",
},
}),
af("UICorner",{
CornerRadius=UDim.new(1,0),
}),
})

az.UIElements.SatVibMap=af("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+az.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(f,1,1),
BackgroundTransparency=0,
Parent=d.UIElements.Main,
},{
af("UICorner",{
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
af("UIGradient",{
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

l,
})

az.UIElements.Inputs=af("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(
aB and 240 or 210,
40+az.TextPadding
),
BackgroundTransparency=1,
Parent=d.UIElements.Main,
},{
af("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
}),
})





local m=af("Frame",{
BackgroundColor3=az.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=az.Transparency,
},{
af("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

af("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+az.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=d.UIElements.Main,
},{
af("UICorner",{
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
af("UIGradient",{
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







m,
})

local p=af("Frame",{
BackgroundColor3=az.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
af("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

af("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+az.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=d.UIElements.Main,
},{
af("UICorner",{
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
af("UIGradient",{
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
p,
})

local r={}

for u=0,1,0.1 do
table.insert(r,ColorSequenceKeypoint.new(u,Color3.fromHSV(u,1,1)))
end

local u=af("UIGradient",{
Color=ColorSequence.new(r),
Rotation=90,
})

local v=af("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=i,


BackgroundColor3=az.Default,
},{
af("UIStroke",{
Thickness=2,
Transparency=0.1,
ThemeTag={
Color="Text",
},
}),
af("UICorner",{
CornerRadius=UDim.new(1,0),
}),
})

local x=af("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+az.TextPadding),
Parent=d.UIElements.Main,
},{
af("UICorner",{
CornerRadius=UDim.new(1,0),
}),
u,
i,
})

local function CreateNewInput(z,A)
local B=ar(z,nil,az.UIElements.Inputs,nil,nil,nil,nil,nil,true)

af("TextLabel",{
BackgroundTransparency=1,
TextTransparency=0.4,
TextSize=17,
FontFace=Font.new(aa.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=B.Frame,
Text=z,
})

af("UIScale",{
Parent=B,
Scale=0.85,
})

B.Frame.Frame.TextBox.Text=A
B.Size=UDim2.new(0,150,0,42)

return B
end

local function ToRGB(z)
return{
R=math.floor(z.R*255),
G=math.floor(z.G*255),
B=math.floor(z.B*255),
}
end

local z=CreateNewInput("Hex","#"..az.Default:ToHex())

local A=CreateNewInput("Red",ToRGB(az.Default).R)
local B=CreateNewInput("Green",ToRGB(az.Default).G)
local C=CreateNewInput("Blue",ToRGB(az.Default).B)
local F
if aB then
F=CreateNewInput("Alpha",((1-az.Transparency)*100).."%")
end

local G=af("Frame",{
Size=UDim2.new(0,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+az.TextPadding),
BackgroundTransparency=1,
Parent=d.UIElements.Main,
LayoutOrder=4,
},{
af("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

aa.AddSignal(d.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",function()
az.UIElements.Title.Size=UDim2.new(
0,
d.UIElements.Main.AbsoluteSize.X/av.UIScale-(d.UIPadding*2),
0,
0
)
G.Size=UDim2.new(
0,
d.UIElements.Main.AbsoluteSize.X/av.UIScale-d.UIPadding*2,
0,
40
)
end)

local H={
{
Title="Cancel",
Variant="Secondary",
Callback=function()
av.IsShowed=false
for H,J in next,aA do
J:Disconnect()
end
aA={}
end,
},
{
Title="Apply",

Variant="Primary",
Callback=function()
av.IsShowed=false
for H,J in next,aA do
J:Disconnect()
end
aA={}

ay(Color3.fromHSV(az.Hue,az.Sat,az.Vib),az.Transparency)
end,
},
}

for J,L in next,H do
local M=aq(
L.Title,
L.Icon,
L.Callback,
L.Variant,
G,
d,
true
)
M.Size=UDim2.new(0.5,-3,0,40)
M.AutomaticSize="None"
end

local J,L,M
if aB then
local N=af("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

L=af("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=N,
},{
af("UIStroke",{
Thickness=2,
Transparency=0.1,
ThemeTag={
Color="Text",
},
}),
af("UICorner",{
CornerRadius=UDim.new(1,0),
}),
})

M=af("Frame",{
Size=UDim2.fromScale(1,1),
},{
af("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
af("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

J=af("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+az.TextPadding),
Parent=d.UIElements.Main,
BackgroundTransparency=1,
},{
af("UICorner",{
CornerRadius=UDim.new(1,0),
}),
af("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
af("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
M,
N,
})
end

function az.Round(N,O,P)
if P==0 then
return math.floor(O)
end
O=tostring(O)
return O:find"%."and tonumber(O:sub(1,O:find"%."+P))or O
end

function az.Update(N,O,P)
if O then
f,g,h=Color3.toHSV(O)
else
f,g,h=az.Hue,az.Sat,az.Vib
end

az.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(f,1,1)
l.Position=UDim2.new(g,0,1-h,0)
l.BackgroundColor3=Color3.fromHSV(f,g,h)
p.BackgroundColor3=Color3.fromHSV(f,g,h)
v.BackgroundColor3=Color3.fromHSV(f,1,1)
v.Position=UDim2.new(0.5,0,f,0)

z.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(f,g,h):ToHex()
A.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(f,g,h)).R
B.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(f,g,h)).G
C.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(f,g,h)).B

if P or aB then
p.BackgroundTransparency=az.Transparency or P
M.BackgroundColor3=Color3.fromHSV(f,g,h)
L.BackgroundColor3=Color3.fromHSV(f,g,h)
L.BackgroundTransparency=az.Transparency or P
L.Position=UDim2.new(0.5,0,1-az.Transparency or P,0)
F.Frame.Frame.TextBox.Text=az:Round(
(1-az.Transparency or P)*100,
0
).."%"
end
end

az:Update(az.Default,az.Transparency)

local function GetRGB()
local N=Color3.fromHSV(az.Hue,az.Sat,az.Vib)
return{R=math.floor(N.r*255),G=math.floor(N.g*255),B=math.floor(N.b*255)}
end



local function clamp(N,O,P)
return math.clamp(tonumber(N)or 0,O,P)
end

table.insert(
aA,
aa.AddSignal(z.Frame.Frame.TextBox.FocusLost,function(N)
if N then
local O=z.Frame.Frame.TextBox.Text:gsub("#","")
local P,Q=pcall(Color3.fromHex,O)
if P and typeof(Q)=="Color3"then
az.Hue,az.Sat,az.Vib=Color3.toHSV(Q)
az:Update()
az.Default=Q
end
end
end)
)

local function updateColorFromInput(N,O)
aa.AddSignal(N.Frame.Frame.TextBox.FocusLost,function(P)
if P then
local Q=N.Frame.Frame.TextBox
local R=GetRGB()
local S=clamp(Q.Text,0,255)
Q.Text=tostring(S)

R[O]=S
local T=Color3.fromRGB(R.R,R.G,R.B)
az.Hue,az.Sat,az.Vib=Color3.toHSV(T)
az:Update()
end
end)
end

updateColorFromInput(A,"R")
updateColorFromInput(B,"G")
updateColorFromInput(C,"B")

if aB then
aa.AddSignal(F.Frame.Frame.TextBox.FocusLost,function(N)
if N then
local O=F.Frame.Frame.TextBox
local P=clamp(O.Text,0,100)
O.Text=tostring(P)

az.Transparency=1-P*0.01
az:Update(nil,az.Transparency)
end
end)
end



local function UpdateSatVib(N,O)
local P=N.AbsolutePosition.X
local Q=P+N.AbsoluteSize.X
local R=N.AbsolutePosition.Y
local S=R+N.AbsoluteSize.Y

local T=math.clamp(ap.X,P,Q)
local U=math.clamp(ap.Y,R,S)

O.Sat=(T-P)/(Q-P)
O.Vib=1-((U-R)/(S-R))

O:Update()
end

local function UpdateHue(N,O)
local P=N.AbsolutePosition.Y
local Q=P+N.AbsoluteSize.Y

local R=math.clamp(ap.Y,P,Q)

O.Hue=(R-P)/(Q-P)

O:Update()
end

local function UpdateTransparency(N,O)
local P=N.AbsolutePosition.Y
local Q=P+N.AbsoluteSize.Y

local R=math.clamp(ap.Y,P,Q)

O.Transparency=1-((R-P)/(Q-P))

O:Update()
end

local N=ax.GenerateGUID()

table.insert(
aA,
ak.InputChanged:Connect(function(O)
if
O.UserInputType~=Enum.UserInputType.MouseMovement
and O.UserInputType~=Enum.UserInputType.Touch
then
return
end

if at=="SatVib"then
UpdateSatVib(az.UIElements.SatVibMap,az)
elseif at=="Hue"then
UpdateHue(x,az)
elseif at=="Transparency"then
UpdateTransparency(J,az)
end
end)
)

table.insert(
aA,
az.UIElements.SatVibMap.InputBegan:Connect(function(O)
if
O.UserInputType~=Enum.UserInputType.MouseButton1
and O.UserInputType~=Enum.UserInputType.Touch
then
return
end

if ax.CurrentInput and ax.CurrentInput~=N then
return
end
ax.CurrentInput=N

if at and at~="SatVib"then
return
end

at="SatVib"

UpdateSatVib(az.UIElements.SatVibMap,az)
end)
)

table.insert(
aA,
x.InputBegan:Connect(function(O)
if
O.UserInputType~=Enum.UserInputType.MouseButton1
and O.UserInputType~=Enum.UserInputType.Touch
then
return
end

if ax.CurrentInput and ax.CurrentInput~=N then
return
end
ax.CurrentInput=N

if at and at~="Hue"then
return
end

at="Hue"

UpdateHue(x,az)
end)
)

if J then
table.insert(
aA,
J.InputBegan:Connect(function(O)
if
O.UserInputType~=Enum.UserInputType.MouseButton1
and O.UserInputType~=Enum.UserInputType.Touch
then
return
end

if ax.CurrentInput and ax.CurrentInput~=N then
return
end
ax.CurrentInput=N

if at and at~="Transparency"then
return
end

at="Transparency"

UpdateTransparency(J,az)
end)
)
end

table.insert(
aA,
ak.InputEnded:Connect(function(O)
at=nil

if ax.CurrentInput and ax.CurrentInput~=N then
return
end
ax.CurrentInput=nil
end)
)

return az
end

function as.New(au,av)
local aw={
__type="Colorpicker",
Title=av.Title or"Colorpicker",
Desc=av.Desc or nil,
Locked=av.Locked or false,
LockedTitle=av.LockedTitle,
Default=av.Default or Color3.new(1,1,1),
Callback=av.Callback or function()end,

UIScale=av.UIScale,
Transparency=av.Transparency,
UIElements={},

IsShowed=false,
}

local ax=true



aw.ColorpickerFrame=a.load'I'{
Title=aw.Title,
Desc=aw.Desc,
Parent=av.Parent,
TextOffset=40,
Hover=false,
Tab=av.Tab,
Index=av.Index,
Window=av.Window,
ElementTable=aw,
ParentConfig=av,
Tags=av.Tags,
}

aw.UIElements.Colorpicker=aa.NewRoundFrame(as.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=aw.Default,
Parent=aw.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2,
},{
aa.NewRoundFrame(as.UICorner,"SquircleGlass",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=0.55,
}),
},true)

function aw.Lock(ay)
aw.Locked=true
ax=false
return aw.ColorpickerFrame:Lock(aw.LockedTitle)
end
function aw.Unlock(ay)
aw.Locked=false
ax=true
return aw.ColorpickerFrame:Unlock()
end

if aw.Locked then
aw:Lock()
end

function aw.Update(ay,az,aA)
aw.UIElements.Colorpicker.ImageTransparency=aA or 0
aw.UIElements.Colorpicker.ImageColor3=az
aw.Default=az
if aA then
aw.Transparency=aA
end
end

function aw.Set(ay,az,aA)
return aw:Update(az,aA)
end

aa.AddSignal(aw.UIElements.Colorpicker.MouseButton1Click,function()
if ax and not aw.IsShowed then
aw.IsShowed=true

as:Colorpicker(aw,av.Window,av.WindUI,function(ay,az)
aw:Update(ay,az)
aw.Default=ay
aw.Transparency=az
aa.SafeCallback(aw.Callback,ay,az)
end).ColorpickerFrame
:Open()
end
end)

return aw.__type,aw
end

return as end function a.Z()

local aa={}

function aa.ToFiniteNumber(af)
local ai=tonumber(af)
if ai==nil or ai~=ai or math.abs(ai)==math.huge then
return nil
end

return ai
end

function aa.FormatNumber(af)
if af%1==0 then
return tostring(af)
end

return tostring(tonumber(string.format("%.2f",af)))
end

function aa.NormalizeOptions(af)
local ai={}

for ak,al in next,af or{}do
local am
if typeof(al)=="table"then
local an=al.Value
if an==nil then
an=al.Id or al.Key or al.Title or al.Name or ak
end

am={
Title=tostring(al.Title or al.Name or an),
Desc=al.Desc,
Value=an,
Icon=al.Icon,
Disabled=al.Disabled==true,
}
else
am={
Title=tostring(al),
Value=al,
Disabled=false,
}
end

table.insert(ai,am)
end

return ai
end

function aa.FindOption(af,ai)
for ak,al in next,af or{}do
if al.Value==ai then
return al,ak
end
end

return nil,nil
end

function aa.ContainsValue(af,ai)
for ak,al in next,af or{}do
if al==ai then
return true
end
end

return false
end

function aa.CloneArray(af)
local ai={}
for ak,al in next,af or{}do
table.insert(ai,al)
end
return ai
end

function aa.NormalizeValues(af)
if af==nil then
return{}
end

if typeof(af)~="table"then
return{af}
end

return aa.CloneArray(af)
end

function aa.ToggleValue(af,ai)
local ak=aa.CloneArray(af)

for al,am in next,ak do
if am==ai then
table.remove(ak,al)
return ak,false
end
end

table.insert(ak,ai)
return ak,true
end

return aa end function a._()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'Z'

local al={}

local function GetControlWidth(am)
return math.max(ak.ToFiniteNumber(am.Width)or ak.ToFiniteNumber(am.ControlWidth)or 220,120)
end

function al.New(am,an)
local ao={
__type="RadioGroup",
Title=an.Title or"Radio Group",
Desc=an.Desc or nil,
Locked=an.Locked or false,
LockedTitle=an.LockedTitle,
Options=ak.NormalizeOptions(an.Options or an.Values or{}),
Value=an.Value,
AllowNone=an.AllowNone==true,
Callback=an.Callback or function()end,
UIElements={},
OptionFrames={},
Animation=an.Animation~=false,

Width=GetControlWidth(an),
}

if ao.Value==nil then
ao.Value=an.Default
end
if typeof(ao.Value)=="number"and ao.Options[ao.Value]then
ao.Value=ao.Options[ao.Value].Value
end
if ao.Value==nil and not ao.AllowNone and ao.Options[1]then
ao.Value=ao.Options[1].Value
end

local ap=true

ao.RadioGroupFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=ao.Width+14,
Hover=false,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.Options=ai("Frame",{
Name="RadioGroupOptions",
Size=UDim2.new(0,ao.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ao.RadioGroupFrame.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Right",
SortOrder="LayoutOrder",
}),
})

local function UpdateOptionVisuals(aq)
for ar,as in next,ao.OptionFrames do
local at=as.Option.Value==ao.Value
local au=at and 0.84 or 0.94
local av=at and 0 or 1
local aw=as.Option.Disabled and 0.55 or(at and 0 or 0.18)

if aq and ao.Animation then
af.Play(as.Row,"Select",{ImageTransparency=au},nil,nil,"Select")
af.Play(as.Dot,"Select",{ImageTransparency=av},nil,nil,"Select")
af.Play(as.Title,"Select",{TextTransparency=aw},nil,nil,"Select")
else
as.Row.ImageTransparency=au
as.Dot.ImageTransparency=av
as.Title.TextTransparency=aw
end
end
end

local function CreateOption(aq,ar)
local as=aa.NewRoundFrame(99,"Circle",{
Name="Dot",
Size=UDim2.new(0,8,0,8),
ImageTransparency=1,
ThemeTag={
ImageColor3="RadioGroupActive",
},
})

local at=aa.NewRoundFrame(99,"CircleOutline",{
Name="Ring",
Size=UDim2.new(0,18,0,18),
ImageTransparency=aq.Disabled and 0.75 or 0.45,
ThemeTag={
ImageColor3="RadioGroupBorder",
},
},{
as,
})
as.Position=UDim2.new(0.5,0,0.5,0)
as.AnchorPoint=Vector2.new(0.5,0.5)

local au=ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,-28,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=aq.Title,
TextSize=14,
TextWrapped=true,
TextXAlignment="Left",
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="RadioGroupText",
},
})

local av=aa.NewRoundFrame(12,"Squircle",{
Name="Option",
Size=UDim2.new(1,0,0,36),
LayoutOrder=ar,
ImageTransparency=0.94,
Active=not aq.Disabled,
ThemeTag={
ImageColor3="RadioGroupBackground",
},
},{
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
at,
au,
},true)

av.Parent=ao.UIElements.Options

local aw={
Row=av,
Ring=at,
Dot=as,
Title=au,
Option=aq,
}
ao.OptionFrames[ar]=aw

af.AttachPress(av,aa,{
Enabled=function()
return ao.Animation and not ao.Locked and not aq.Disabled
end,
})

aa.AddSignal(av.MouseButton1Click,function()
if not aq.Disabled then
ao:Select(aq.Value)
end
end)
end

local function RenderOptions()
for aq,ar in next,ao.OptionFrames do
if ar.Row then
ar.Row:Destroy()
end
end

ao.OptionFrames={}

for aq,ar in next,ao.Options do
CreateOption(ar,aq)
end

UpdateOptionVisuals(false)
end

function ao.Lock(aq)
ao.Locked=true
ap=false
return ao.RadioGroupFrame:Lock(ao.LockedTitle)
end
function ao.Unlock(aq)
ao.Locked=false
ap=true
return ao.RadioGroupFrame:Unlock()
end

function ao.Get(aq)
return ao.Value
end

function ao.Select(aq,ar,as)
local at=ak.FindOption(ao.Options,ar)
if not at and not ao.AllowNone then
return ao.Value
end
if at and at.Disabled then
return ao.Value
end

ao.Value=ar
UpdateOptionVisuals(true)

if ap and as~=false then
aa.SafeCallback(ao.Callback,ar,at)
end

return ao.Value
end

function ao.SetOptions(aq,ar)
ao.Options=ak.NormalizeOptions(ar)

if not ak.FindOption(ao.Options,ao.Value)then
ao.Value=ao.AllowNone and nil or(ao.Options[1]and ao.Options[1].Value)
end

RenderOptions()
return ao.Options
end

RenderOptions()

if ao.Locked then
ao:Lock()
end

return ao.__type,ao
end

return al end function a.aa()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'Z'

local al={}

local function GetControlWidth(am)
return math.max(ak.ToFiniteNumber(am.Width)or ak.ToFiniteNumber(am.ControlWidth)or 220,120)
end

function al.New(am,an)
local ao={
__type="CheckboxGroup",
Title=an.Title or"Checkbox Group",
Desc=an.Desc or nil,
Locked=an.Locked or false,
LockedTitle=an.LockedTitle,
Options=ak.NormalizeOptions(an.Options or an.Values or{}),
Values=ak.NormalizeValues(an.ValuesSelected or an.SelectedValues or an.Value or an.ValuesDefault),
Callback=an.Callback or function()end,
UIElements={},
OptionFrames={},
Animation=an.Animation~=false,

Width=GetControlWidth(an),
}

local ap=true

ao.CheckboxGroupFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=ao.Width+14,
Hover=false,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.Options=ai("Frame",{
Name="CheckboxGroupOptions",
Size=UDim2.new(0,ao.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ao.CheckboxGroupFrame.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Right",
SortOrder="LayoutOrder",
}),
})

local function SanitizeValues(aq)
local ar={}

for as,at in next,aq or{}do
local au=ak.FindOption(ao.Options,at)
if au and not au.Disabled and not ak.ContainsValue(ar,at)then
table.insert(ar,at)
end
end

return ar
end

local function UpdateOptionVisuals(aq)
for ar,as in next,ao.OptionFrames do
local at=ak.ContainsValue(ao.Values,as.Option.Value)
local au=at and 0.84 or 0.94
local av=at and 0 or 1
local aw=at and 0 or 1
local ax=as.Option.Disabled and 0.55 or(at and 0 or 0.18)

if aq and ao.Animation then
af.Play(as.Row,"Select",{ImageTransparency=au},nil,nil,"Select")
af.Play(as.Fill,"Select",{ImageTransparency=av},nil,nil,"Select")
af.Play(as.Icon,"Select",{ImageTransparency=aw},nil,nil,"Select")
af.Play(as.Title,"Select",{TextTransparency=ax},nil,nil,"Select")
else
as.Row.ImageTransparency=au
as.Fill.ImageTransparency=av
as.Icon.ImageTransparency=aw
as.Title.TextTransparency=ax
end
end
end

local function CreateOption(aq,ar)
local as=aa.Icon"check"
local at=ai("ImageLabel",{
Name="Check",
Size=UDim2.new(0,12,0,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Image=as[1],
ImageRectOffset=as[2].ImageRectPosition,
ImageRectSize=as[2].ImageRectSize,
ImageTransparency=1,
ThemeTag={
ImageColor3="CheckboxGroupIcon",
},
})

local au=aa.NewRoundFrame(5,"Squircle",{
Name="Fill",
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ThemeTag={
ImageColor3="CheckboxGroupActive",
},
},{
at,
})

local av=aa.NewRoundFrame(5,"SquircleOutline",{
Name="Box",
Size=UDim2.new(0,18,0,18),
ImageTransparency=aq.Disabled and 0.75 or 0.45,
ThemeTag={
ImageColor3="CheckboxGroupBorder",
},
},{
au,
})

local aw=ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,-28,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=aq.Title,
TextSize=14,
TextWrapped=true,
TextXAlignment="Left",
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="CheckboxGroupText",
},
})

local ax=aa.NewRoundFrame(12,"Squircle",{
Name="Option",
Size=UDim2.new(1,0,0,36),
LayoutOrder=ar,
ImageTransparency=0.94,
Active=not aq.Disabled,
ThemeTag={
ImageColor3="CheckboxGroupBackground",
},
},{
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
av,
aw,
},true)

ax.Parent=ao.UIElements.Options

local ay={
Row=ax,
Fill=au,
Icon=at,
Title=aw,
Option=aq,
}
ao.OptionFrames[ar]=ay

af.AttachPress(ax,aa,{
Enabled=function()
return ao.Animation and not ao.Locked and not aq.Disabled
end,
})

aa.AddSignal(ax.MouseButton1Click,function()
if not aq.Disabled then
ao:Toggle(aq.Value)
end
end)
end

local function RenderOptions()
for aq,ar in next,ao.OptionFrames do
if ar.Row then
ar.Row:Destroy()
end
end

ao.OptionFrames={}

for aq,ar in next,ao.Options do
CreateOption(ar,aq)
end

ao.Values=SanitizeValues(ao.Values)
UpdateOptionVisuals(false)
end

function ao.Lock(aq)
ao.Locked=true
ap=false
return ao.CheckboxGroupFrame:Lock(ao.LockedTitle)
end
function ao.Unlock(aq)
ao.Locked=false
ap=true
return ao.CheckboxGroupFrame:Unlock()
end

function ao.Get(aq)
return ak.CloneArray(ao.Values)
end

function ao.Set(aq,ar,as)
ao.Values=SanitizeValues(ak.NormalizeValues(ar))
UpdateOptionVisuals(true)

if ap and as~=false then
aa.SafeCallback(ao.Callback,ao:Get())
end

return ao:Get()
end

function ao.Toggle(aq,ar,as)
local at=ak.FindOption(ao.Options,ar)
if not at or at.Disabled then
return ao:Get()
end

ao.Values=ak.ToggleValue(ao.Values,ar)
return ao:Set(ao.Values,as)
end

function ao.SetOptions(aq,ar)
ao.Options=ak.NormalizeOptions(ar)
RenderOptions()
return ao.Options
end

RenderOptions()

if ao.Locked then
ao:Lock()
end

return ao.__type,ao
end

return al end function a.ab()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'Z'

local al={}

local function GetControlWidth(am)
return math.max(ak.ToFiniteNumber(am.Width)or ak.ToFiniteNumber(am.ControlWidth)or 220,120)
end

function al.New(am,an)
local ao={
__type="SegmentedControl",
Title=an.Title or"Segmented Control",
Desc=an.Desc or nil,
Locked=an.Locked or false,
LockedTitle=an.LockedTitle,
Options=ak.NormalizeOptions(an.Options or an.Values or{}),
Value=an.Value or an.Default,
Callback=an.Callback or function()end,
UIElements={},
Segments={},
Animation=an.Animation~=false,

Width=GetControlWidth(an),
}

if typeof(ao.Value)=="number"and ao.Options[ao.Value]then
ao.Value=ao.Options[ao.Value].Value
end
if ao.Value==nil and ao.Options[1]then
ao.Value=ao.Options[1].Value
end

local ap=true

ao.SegmentedControlFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=ao.Width+14,
Hover=false,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.Container=aa.NewRoundFrame(13,"Squircle",{
Name="SegmentedControl",
Size=UDim2.new(0,ao.Width,0,36),
Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5),
ImageTransparency=0.93,
ThemeTag={
ImageColor3="SegmentedControlBackground",
},
Parent=ao.SegmentedControlFrame.UIElements.Main,
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,4),
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
}),
})

local function UpdateSegmentVisuals(aq)
for ar,as in next,ao.Segments do
local at=as.Option.Value==ao.Value
local au=at and 0.82 or 1
local av=as.Option.Disabled and 0.55 or(at and 0 or 0.25)

if aq and ao.Animation then
af.Play(as.Button,"Select",{ImageTransparency=au},nil,nil,"Select")
af.Play(as.Title,"Select",{TextTransparency=av},nil,nil,"Select")
else
as.Button.ImageTransparency=au
as.Title.TextTransparency=av
end
end
end

local function CreateSegment(aq,ar,as)
local at=4
local au=math.max((ao.Width-8-(at*(as-1)))/math.max(as,1),24)

local av=ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,-10,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Text=aq.Title,
TextSize=13,
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="SegmentedControlText",
},
})

local aw=aa.NewRoundFrame(10,"Squircle",{
Name="Segment",
Size=UDim2.new(0,au,1,0),
Position=UDim2.new(0,(ar-1)*(au+at)+4,0,4),
ImageTransparency=1,
Active=not aq.Disabled,
ThemeTag={
ImageColor3="SegmentedControlActive",
},
},{
av,
},true)

aw.Parent=ao.UIElements.Container

local ax={
Button=aw,
Title=av,
Option=aq,
}
ao.Segments[ar]=ax

af.AttachPress(aw,aa,{
Amount=0.96,
Enabled=function()
return ao.Animation and not ao.Locked and not aq.Disabled
end,
})

aa.AddSignal(aw.MouseButton1Click,function()
if not aq.Disabled then
ao:Select(aq.Value)
end
end)
end

local function RenderSegments()
for aq,ar in next,ao.Segments do
if ar.Button then
ar.Button:Destroy()
end
end

ao.Segments={}

local aq=#ao.Options
for ar,as in next,ao.Options do
CreateSegment(as,ar,aq)
end

UpdateSegmentVisuals(false)
end

function ao.Lock(aq)
ao.Locked=true
ap=false
return ao.SegmentedControlFrame:Lock(ao.LockedTitle)
end
function ao.Unlock(aq)
ao.Locked=false
ap=true
return ao.SegmentedControlFrame:Unlock()
end

function ao.Get(aq)
return ao.Value
end

function ao.Select(aq,ar,as)
local at=ak.FindOption(ao.Options,ar)
if not at or at.Disabled then
return ao.Value
end

ao.Value=ar
UpdateSegmentVisuals(true)

if ap and as~=false then
aa.SafeCallback(ao.Callback,ar,at)
end

return ao.Value
end

function ao.SetOptions(aq,ar)
ao.Options=ak.NormalizeOptions(ar)

if not ak.FindOption(ao.Options,ao.Value)then
ao.Value=ao.Options[1]and ao.Options[1].Value or nil
end

RenderSegments()
return ao.Options
end

RenderSegments()

if ao.Locked then
ao:Lock()
end

return ao.__type,ao
end

return al end function a.ac()

local aa=a.load'd'

local af=a.load'o'.New

local ai={}

function ai.New(ak,al)
local am={
__type="TextArea",
Title=al.Title or"Text Area",
Desc=al.Desc or nil,
Locked=al.Locked or false,
LockedTitle=al.LockedTitle,
InputIcon=al.InputIcon or false,
Placeholder=al.Placeholder or"Enter Text...",
Value=al.Value or"",
Callback=al.Callback or function()end,
ClearTextOnFocus=al.ClearTextOnFocus or false,
UIElements={},
}

local an=true

am.TextAreaFrame=a.load'I'{
Title=am.Title,
Desc=am.Desc,
Parent=al.Parent,
TextOffset=0,
Hover=false,
Tab=al.Tab,
Index=al.Index,
Window=al.Window,
ElementTable=am,
ParentConfig=al,
Tags=al.Tags,
}

local ao=af(
am.Placeholder,
am.InputIcon,
am.TextAreaFrame.UIElements.Container,
"Textarea",
function(ao)
am:Set(ao,true,true)
end,
nil,
al.Window.NewElements and 12 or 10,
am.ClearTextOnFocus
)
ao.Size=UDim2.new(1,0,0,al.Height or 148)
ao.LayoutOrder=99

local ap=ao.Frame.Frame.TextBox

function am.Lock(aq)
am.Locked=true
an=false
return am.TextAreaFrame:Lock(am.LockedTitle)
end
function am.Unlock(aq)
am.Locked=false
an=true
return am.TextAreaFrame:Unlock()
end

function am.Get(aq)
return am.Value
end

function am.Set(aq,ar,as,at)
if not an then
return am.Value
end

am.Value=tostring(ar or"")

if not at then
ap.Text=am.Value
end

if as~=false then
aa.SafeCallback(am.Callback,am.Value)
end

return am.Value
end

function am.SetPlaceholder(aq,ar)
am.Placeholder=tostring(ar or"")
ap.PlaceholderText=am.Placeholder
end

am:Set(am.Value,false)

if am.Locked then
am:Lock()
end

return am.__type,am
end

return ai end function a.ad()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local af=aa(game:GetService"UserInputService")

local ai=a.load'd'
local ak=a.load'e'
local al=ai.New

local am=a.load'Z'

local an={}

local function ReadValueConfig(ao)
local ap=typeof(ao.Value)=="table"and ao.Value or{}
local aq=am.ToFiniteNumber(ap.Min)or am.ToFiniteNumber(ao.Min)or 0
local ar=am.ToFiniteNumber(ap.Max)or am.ToFiniteNumber(ao.Max)or 100

if aq>ar then
aq,ar=ar,aq
end

local as=typeof(ao.Value)=="number"and ao.Value
or am.ToFiniteNumber(ap.Default)
or am.ToFiniteNumber(ao.Default)
or aq
local at=am.ToFiniteNumber(ap.Increment)or am.ToFiniteNumber(ao.Increment)or 1

return aq,ar,math.clamp(am.ToFiniteNumber(as)or aq,aq,ar),math.max(math.abs(at),0.0001)
end

function an.New(ao,ap)
local aq,ar,as,at=ReadValueConfig(ap)
local au=af.TouchEnabled and not af.KeyboardEnabled
local av=ap.Buttons~=false and ap.ShowButtons~=false
local aw=au and 38 or 34
local ax=au and 40 or 36
local ay=av and 164 or 128

local az={
__type="Stepper",
Title=ap.Title or"Stepper",
Desc=ap.Desc or nil,
Locked=ap.Locked or false,
LockedTitle=ap.LockedTitle,
Value={
Min=aq,
Max=ar,
Default=as,
Increment=at,
},
Callback=ap.Callback or function()end,
Format=ap.Format,
UIElements={},
Animation=ap.Animation~=false,
Draggable=ap.Draggable~=false,
ShowButtons=av,
Width=math.max(am.ToFiniteNumber(ap.Width)or am.ToFiniteNumber(ap.ControlWidth)or(au and 188 or 176),ay),
}

local aA=true

az.StepperFrame=a.load'I'{
Title=az.Title,
Desc=az.Desc,
Parent=ap.Parent,
TextOffset=az.Width+14,
Hover=false,
Tab=ap.Tab,
Index=ap.Index,
Window=ap.Window,
ElementTable=az,
ParentConfig=ap,
Tags=ap.Tags,
}

local function FormatValue(aB)
if typeof(az.Format)=="function"then
local b,d=pcall(az.Format,aB,az.Value.Min,az.Value.Max)
if b and d~=nil then
return tostring(d)
end
end

return am.FormatNumber(aB)
end

local function GetRange()
return math.max(az.Value.Max-az.Value.Min,az.Value.Increment)
end

local function SnapValue(aB)
local b=am.ToFiniteNumber(aB)
if b==nil then
return az.Value.Default
end

local d=math.floor(((b-az.Value.Min)/az.Value.Increment)+0.5)
local f=az.Value.Min+(d*az.Value.Increment)
return math.clamp(f,az.Value.Min,az.Value.Max)
end

local function ValueToDelta(aB)
return math.clamp((aB-az.Value.Min)/GetRange(),0,1)
end

local function CreateIconButton(aB,b)
local d=ai.Icon(b)
local f=al("ImageLabel",{
Name="Icon",
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Image=d[1],
ImageRectOffset=d[2].ImageRectPosition,
ImageRectSize=d[2].ImageRectSize,
ThemeTag={
ImageColor3="StepperIcon",
},
})

local g=ai.NewRoundFrame(12,"Squircle",{
Name=aB,
Size=UDim2.fromOffset(aw,aw),
ImageTransparency=0.88,
ThemeTag={
ImageColor3="StepperButton",
},
},{
f,
},true)

return g,f
end

local aB,b
local d,f
if az.ShowButtons then
aB,b=CreateIconButton("Minus","minus")
d,f=CreateIconButton("Plus","plus")

ak.AttachPress(aB,ai,{
Amount=0.94,
Enabled=function()
return az.Animation and not az.Locked and az.Value.Default>az.Value.Min
end,
})
ak.AttachPress(d,ai,{
Amount=0.94,
Enabled=function()
return az.Animation and not az.Locked and az.Value.Default<az.Value.Max
end,
})
end

local g=ai.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(ValueToDelta(az.Value.Default),0,1,0),
ImageTransparency=0.12,
ThemeTag={
ImageColor3="Primary",
},
})

local h=ai.NewRoundFrame(999,"Squircle",{
Name="Thumb",
Size=UDim2.fromOffset(9,9),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(ValueToDelta(az.Value.Default),0,0.5,0),
ImageTransparency=0,
ThemeTag={
ImageColor3="SliderThumb",
},
})

local i=ai.NewRoundFrame(999,"Squircle",{
Name="Track",
Size=UDim2.new(1,-18,0,4),
Position=UDim2.new(0.5,0,1,-7),
AnchorPoint=Vector2.new(0.5,1),
ImageTransparency=0.88,
ThemeTag={
ImageColor3="Text",
},
},{
g,
h,
})

az.UIElements.ValueLabel=al("TextLabel",{
Name="Value",
Size=UDim2.new(1,-18,1,-10),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
Text=FormatValue(az.Value.Default),
TextSize=au and 15 or 14,
TextTruncate="AtEnd",
FontFace=Font.new(ai.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="StepperText",
},
})

local l=az.ShowButtons and((aw*2)+10)or 0
local m=ai.NewRoundFrame(12,"Squircle",{
Name="ValueBackground",
Size=UDim2.new(1,-l,0,ax),
ImageTransparency=0.92,
Active=true,
ClipsDescendants=true,
ThemeTag={
ImageColor3="StepperValueBackground",
},
},{
az.UIElements.ValueLabel,
i,
},true)

az.UIElements.Track=i
az.UIElements.TrackFill=g
az.UIElements.TrackThumb=h
az.UIElements.ValueBackground=m

az.UIElements.Container=al("Frame",{
Name="Stepper",
Size=UDim2.new(0,az.Width,0,ax),
Position=UDim2.new(1,0,ap.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,ap.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=az.StepperFrame.UIElements.Main,
},{
al("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Horizontal",
HorizontalAlignment="Right",
VerticalAlignment="Center",
}),
aB,
m,
d,
})

local function SetProgressVisual(p,r)
local u=ValueToDelta(p)
local v=UDim2.new(u,0,1,0)
local x=UDim2.new(u,0,0.5,0)

if r and az.Animation then
ak.Play(g,"Fast",{Size=v},nil,nil,"StepperFill")
ak.Play(h,"Fast",{Position=x},nil,nil,"StepperThumb")
else
g.Size=v
h.Position=x
end
end

local function UpdateButtonStates(p)
if not az.ShowButtons then
return
end

local r=az.Value.Default<=az.Value.Min
local u=az.Value.Default>=az.Value.Max
local v=r and 0.62 or 0
local x=u and 0.62 or 0
local z=r and 0.94 or 0.88
local A=u and 0.94 or 0.88

if p and az.Animation then
ak.Play(b,"Fast",{ImageTransparency=v},nil,nil,"State")
ak.Play(f,"Fast",{ImageTransparency=x},nil,nil,"State")
ak.Play(aB,"Fast",{ImageTransparency=z},nil,nil,"State")
ak.Play(d,"Fast",{ImageTransparency=A},nil,nil,"State")
else
b.ImageTransparency=v
f.ImageTransparency=x
aB.ImageTransparency=z
d.ImageTransparency=A
end
end

local function UpdateValue(p,r,u)
local v=am.ToFiniteNumber(p)
if v==nil then
return az.Value.Default
end

local x=az.Value.Default
az.Value.Default=u==false and math.clamp(v,az.Value.Min,az.Value.Max)or SnapValue(v)
az.UIElements.ValueLabel.Text=FormatValue(az.Value.Default)
SetProgressVisual(az.Value.Default,true)
UpdateButtonStates(true)

if az.Animation and x~=az.Value.Default then
ak.Play(m,"Fast",{ImageTransparency=0.86},nil,nil,"Pulse")
task.delay(ak.GetDuration"Fast",function()
if m.Parent then
ak.Play(m,"Select",{ImageTransparency=0.92},nil,nil,"Pulse")
end
end)
end

if aA and r~=false and x~=az.Value.Default then
ai.SafeCallback(az.Callback,az.Value.Default)
end

return az.Value.Default
end

function az.Lock(p)
az.Locked=true
aA=false
UpdateButtonStates(true)
return az.StepperFrame:Lock(az.LockedTitle)
end
function az.Unlock(p)
az.Locked=false
aA=true
UpdateButtonStates(true)
return az.StepperFrame:Unlock()
end

function az.Get(p)
return az.Value.Default
end

function az.Set(p,r,u)
return UpdateValue(r,u)
end

function az.SetRange(p,r,u)
r=am.ToFiniteNumber(r)
u=am.ToFiniteNumber(u)

if r==nil or u==nil then
return az.Value.Min,az.Value.Max
end

if r>u then
r,u=u,r
end

az.Value.Min=r
az.Value.Max=u
UpdateValue(az.Value.Default,false)

return az.Value.Min,az.Value.Max
end

function az.SetMin(p,r)
az:SetRange(r,math.max(am.ToFiniteNumber(r)or az.Value.Min,az.Value.Max))
return az.Value.Min
end

function az.SetMax(p,r)
az:SetRange(math.min(az.Value.Min,am.ToFiniteNumber(r)or az.Value.Max),r)
return az.Value.Max
end

local p=ap.WindUI.GenerateGUID()
local r
local u
local v
local x=ap.Tab and ap.Tab.UIElements and ap.Tab.UIElements.ContainerFrame

local function DisconnectDrag()
if u then
u:Disconnect()
u=nil
end
if v then
v:Disconnect()
v=nil
end
if x then
x.ScrollingEnabled=true
end
if ap.WindUI.CurrentInput==p then
ap.WindUI.CurrentInput=nil
end
r=nil
if az.Animation then
ak.Play(h,"Focus",{Size=UDim2.fromOffset(9,9)},nil,nil,"StepperDrag")
end
end

local function GetInputX(z)
if z.UserInputType==Enum.UserInputType.Touch then
return z.Position.X
end
return af:GetMouseLocation().X
end

local function UpdateFromInput(z)
if not i or i.AbsoluteSize.X<=0 then
return
end

local A=math.clamp((GetInputX(z)-i.AbsolutePosition.X)/i.AbsoluteSize.X,0,1)
local B=az.Value.Min+(A*GetRange())
UpdateValue(B,true)
end

if az.ShowButtons then
ai.AddSignal(aB.MouseButton1Click,function()
if not az.Locked then
az:Set(az.Value.Default-az.Value.Increment)
end
end)
ai.AddSignal(d.MouseButton1Click,function()
if not az.Locked then
az:Set(az.Value.Default+az.Value.Increment)
end
end)
end

ai.AddSignal(m.InputBegan,function(z)
if az.Locked or not az.Draggable then
return
end
if z.UserInputType~=Enum.UserInputType.MouseButton1 and z.UserInputType~=Enum.UserInputType.Touch then
return
end
if ap.WindUI.CurrentInput and ap.WindUI.CurrentInput~=p then
return
end

ap.WindUI.CurrentInput=p
r=z
if x then
x.ScrollingEnabled=false
end
if az.Animation then
ak.Play(h,"Focus",{Size=UDim2.fromOffset(13,13)},nil,nil,"StepperDrag")
end
UpdateFromInput(z)

u=af.InputChanged:Connect(function(A)
if not r then
return
end
if r.UserInputType==Enum.UserInputType.Touch and A.UserInputType~=Enum.UserInputType.Touch then
return
end
if r.UserInputType==Enum.UserInputType.MouseButton1 and A.UserInputType~=Enum.UserInputType.MouseMovement then
return
end
UpdateFromInput(A)
end)

v=af.InputEnded:Connect(function(A)
if not r then
return
end
local B=r.UserInputType==Enum.UserInputType.Touch and A==r
local C=r.UserInputType==Enum.UserInputType.MouseButton1
and A.UserInputType==Enum.UserInputType.MouseButton1
if B or C then
DisconnectDrag()
end
end)
end)

UpdateButtonStates(false)
SetProgressVisual(az.Value.Default,false)

if az.Locked then
az:Lock()
end

return az.__type,az
end

return an end function a.ae()

local aa={}

local af={
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

function aa.New(ai,ak)
local al=ak.Variant or"Info"
local am=af[al]or af.Info

local an={
__type="Callout",
Title=ak.Title or al,
Desc=ak.Desc or ak.Content,
Icon=ak.Icon or am.Icon,
Variant=al,
Color=ak.Color or am.Color,
UIElements={},
}

an.CalloutFrame=a.load'I'{
Title=an.Title,
Desc=an.Desc,
Image=an.Icon,
IconThemed=ak.IconThemed,
Color=an.Color,
Parent=ak.Parent,
TextOffset=0,
Hover=ak.Hover==true,
Tab=ak.Tab,
Index=ak.Index,
Window=ak.Window,
ElementTable=an,
ParentConfig=ak,
Tags=ak.Tags,
Size=ak.Size,
}

return an.__type,an
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

function aa.ToFiniteNumber(af)
local ai=tonumber(af)
if ai==nil or ai~=ai or math.abs(ai)==math.huge then
return nil
end

return ai
end

function aa.GetVariant(af)
return aa.Variants[af or"Info"]or aa.Variants.Info
end

function aa.GetColor(af,ai)
if typeof(af)=="Color3"then
return af
end
if typeof(af)=="string"and string.sub(af,1,1)=="#"then
return Color3.fromHex(af)
end
return ai
end

function aa.NormalizeItems(af,ai,ak)
local al={}

for am,an in next,af or{}do
if typeof(an)=="table"then
local ao=an[ak or"Value"]
if ao==nil then
ao=an.Id or an.Key or an.Title or an.Name or am
end

table.insert(al,{
Title=tostring(an[ai or"Title"]or an.Name or ao),
Desc=an.Desc or an.Content,
Value=ao,
Icon=an.Icon,
Color=an.Color,
Disabled=an.Disabled==true,
Items=an.Items,
})
else
table.insert(al,{
Title=tostring(an),
Value=an,
Disabled=false,
})
end
end

return al
end

function aa.CloneArray(af)
local ai={}
for ak,al in next,af or{}do
table.insert(ai,al)
end
return ai
end

function aa.NormalizeValues(af)
if af==nil then
return{}
end
if typeof(af)~="table"then
return{af}
end
return aa.CloneArray(af)
end

function aa.ContainsValue(af,ai)
for ak,al in next,af or{}do
if al==ai then
return true
end
end
return false
end

function aa.ToggleValue(af,ai)
local ak=aa.CloneArray(af)

for al,am in next,ak do
if am==ai then
table.remove(ak,al)
return ak,false
end
end

table.insert(ak,ai)
return ak,true
end

function aa.CreateIcon(af,ai,ak,al,am,an)
if not ai or ai==""then
return nil
end

local ao=af.Image(ai,ai,0,ak,al or"Element",am~=false,true,an)
ao.Size=UDim2.new(0,18,0,18)
return ao
end

function aa.GetImageTarget(af)
if typeof(af)~="Instance"then
return nil
end

if af:IsA"ImageLabel"or af:IsA"ImageButton"then
return af
end

return af:FindFirstChildWhichIsA"ImageLabel"or af:FindFirstChildWhichIsA"ImageButton"
end

function aa.CreateText(af,ai,ak,al,am,an)
return af("TextLabel",{
BackgroundTransparency=1,
Text=tostring(ak or""),
TextSize=al or 14,
TextTransparency=an or 0,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ai.Font,am or Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})
end

return aa end function a.ag()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

function al.New(am,an)
local ao=an.Variant or"Info"
local ap=ak.GetVariant(ao)
local aq={
__type="Badge",
Title=an.Title or"Badge",
Desc=an.Desc or nil,
Value=an.Value or an.Badge or ao,
Variant=ao,
Color=ak.GetColor(an.Color,ap.Color),
Icon=an.Icon or ap.Icon,
Callback=an.Callback,
UIElements={},

Width=math.max(ak.ToFiniteNumber(an.Width)or 96,72),
}

aq.BadgeFrame=a.load'I'{
Title=aq.Title,
Desc=aq.Desc,
Parent=an.Parent,
TextOffset=aq.Width+14,
Hover=an.Hover==true or aq.Callback~=nil,
Scalable=aq.Callback~=nil,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=aq,
ParentConfig=an,
Tags=an.Tags,
}

local ar=ak.CreateIcon(aa,aq.Icon,an.Window.Folder,"Badge",false,"BadgeIcon")
if ar then
ar.ImageLabel.ImageColor3=Color3.new(1,1,1)
ar.ImageLabel.ImageTransparency=0
ar.Size=UDim2.new(0,14,0,14)
end

aq.UIElements.Label=ai("TextLabel",{
Name="Label",
BackgroundTransparency=1,
Text=tostring(aq.Value),
TextSize=13,
TextTruncate="AtEnd",
TextXAlignment="Center",
Size=UDim2.new(1,ar and-20 or 0,1,0),
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextColor3=Color3.new(1,1,1),
})

aq.UIElements.Pill=aa.NewRoundFrame(999,"Squircle",{
Name="Badge",
Size=UDim2.new(0,aq.Width,0,28),
Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5),
ImageTransparency=0,
ImageColor3=aq.Color,
Parent=aq.BadgeFrame.UIElements.Main,
},{
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
ar,
aq.UIElements.Label,
})

function aq.SetValue(as,at)
aq.Value=at
aq.UIElements.Label.Text=tostring(at or"")
af.Play(aq.UIElements.Pill,"Fast",{ImageTransparency=0.08},nil,nil,"Pulse")
task.delay(af.GetDuration"Fast",function()
if aq.UIElements.Pill.Parent then
af.Play(aq.UIElements.Pill,"Select",{ImageTransparency=0},nil,nil,"Pulse")
end
end)
return aq.Value
end

function aq.SetVariant(as,at)
local au=ak.GetVariant(at)
aq.Variant=at
aq.Color=au.Color
af.Play(aq.UIElements.Pill,"Select",{ImageColor3=aq.Color},nil,nil,"Variant")
return aq.Variant
end

if aq.Callback then
aa.AddSignal(aq.BadgeFrame.UIElements.Main.MouseButton1Click,function()
aa.SafeCallback(aq.Callback,aq.Value)
end)
end

return aq.__type,aq
end

return al end function a.ah()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

function al.New(am,an)
local ao=an.Status or an.Variant or"Info"
local ap=ak.GetVariant(ao)
local aq={
__type="StatusCard",
Title=an.Title or"Status",
Desc=an.Desc or an.Content,
Value=an.Value or ao,
Status=ao,
Color=ak.GetColor(an.Color,ap.Color),
Callback=an.Callback,
UIElements={},

Width=math.max(ak.ToFiniteNumber(an.Width)or 136,96),
}

aq.StatusCardFrame=a.load'I'{
Title=aq.Title,
Desc=aq.Desc,
Parent=an.Parent,
TextOffset=aq.Width+14,
Hover=an.Hover==true or aq.Callback~=nil,
Scalable=aq.Callback~=nil,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=aq,
ParentConfig=an,
Tags=an.Tags,
}

aq.UIElements.Dot=aa.NewRoundFrame(999,"Circle",{
Name="Dot",
Size=UDim2.new(0,10,0,10),
ImageColor3=aq.Color,
})

aq.UIElements.Value=ai("TextLabel",{
Name="Value",
BackgroundTransparency=1,
Text=tostring(aq.Value),
TextSize=14,
TextTransparency=0.08,
TextTruncate="AtEnd",
AutomaticSize="Y",
Size=UDim2.new(1,-18,0,0),
TextXAlignment="Left",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
})

aq.UIElements.Status=ai("Frame",{
Name="StatusCard",
Size=UDim2.new(0,aq.Width,0,34),
Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=aq.StatusCardFrame.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Right",
}),
aq.UIElements.Dot,
aq.UIElements.Value,
})

function aq.SetValue(ar,as)
aq.Value=as
aq.UIElements.Value.Text=tostring(as or"")
return aq.Value
end

function aq.SetStatus(ar,as,at)
local au=ak.GetVariant(as)
aq.Status=as
aq.Color=au.Color
if at~=nil then
aq:SetValue(at)
end
af.Play(aq.UIElements.Dot,"Select",{ImageColor3=aq.Color},nil,nil,"Status")
return aq.Status
end

if aq.Callback then
aa.AddSignal(aq.StatusCardFrame.UIElements.Main.MouseButton1Click,function()
aa.SafeCallback(aq.Callback,aq.Status,aq.Value)
end)
end

return aq.__type,aq
end

return al end function a.ai()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local function GetTrendColor(am)
if am=="Down"or am=="Negative"then
return Color3.fromHex"#dc2626"
end
if am=="Neutral"then
return Color3.fromHex"#71717a"
end
return Color3.fromHex"#16a34a"
end

function al.New(am,an)
local ao={
__type="StatCard",
Title=an.Title or"Stat",
Desc=an.Desc,
Value=an.Value or an.Default or"0",
SubValue=an.SubValue or an.TrendText,
Trend=an.Trend or"Up",
Icon=an.Icon,
UIElements={},
}

ao.StatCardFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Image=ao.Icon,
Parent=an.Parent,
TextOffset=0,
Hover=an.Hover==true,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.Value=ai("TextLabel",{
Name="Value",
LayoutOrder=-1,
BackgroundTransparency=1,
Text=tostring(ao.Value),
TextSize=ak.ToFiniteNumber(an.ValueTextSize)or 24,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Text",
},
})

ao.UIElements.TrendDot=aa.NewRoundFrame(999,"Circle",{
Name="TrendDot",
Size=UDim2.new(0,8,0,8),
ImageColor3=ak.GetColor(an.TrendColor,GetTrendColor(ao.Trend)),
})

ao.UIElements.SubValue=ai("TextLabel",{
Name="SubValue",
BackgroundTransparency=1,
Text=tostring(ao.SubValue or""),
TextSize=13,
TextTransparency=0.35,
TextWrapped=true,
TextXAlignment="Left",
AutomaticSize="Y",
Size=UDim2.new(1,-16,0,0),
Visible=ao.SubValue~=nil,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})

ao.UIElements.Footer=ai("Frame",{
Name="Footer",
LayoutOrder=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.StatCardFrame.UIElements.Container,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ao.UIElements.TrendDot,
ao.UIElements.SubValue,
})
ao.UIElements.Value.Parent=ao.StatCardFrame.UIElements.Container

function ao.SetValue(ap,aq,ar)
ao.Value=aq
ao.UIElements.Value.Text=tostring(aq or"")
if ar~=nil then
ao.SubValue=ar
ao.UIElements.SubValue.Text=tostring(ar)
ao.UIElements.SubValue.Visible=true
end
af.Play(ao.UIElements.Value,"Fast",{TextTransparency=0.18},nil,nil,"Pulse")
task.delay(af.GetDuration"Fast",function()
if ao.UIElements.Value.Parent then
af.Play(ao.UIElements.Value,"Select",{TextTransparency=0},nil,nil,"Pulse")
end
end)
return ao.Value
end

function ao.SetTrend(ap,aq,ar)
ao.Trend=aq
local as=ak.GetColor(ar,GetTrendColor(aq))
af.Play(ao.UIElements.TrendDot,"Select",{ImageColor3=as},nil,nil,"Trend")
return ao.Trend
end

return ao.__type,ao
end

return al end function a.aj()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

function al.New(am,an)
local ao={
__type="KeyValue",
Title=an.Title or"Details",
Desc=an.Desc,
Items=ak.NormalizeItems(an.Items or an.Rows or an.Values or{},"Key","Value"),
UIElements={},
Rows={},
}

ao.KeyValueFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=0,
Hover=an.Hover==true,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.List=ai("Frame",{
Name="KeyValueList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.KeyValueFrame.UIElements.Container,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

local function Render()
for ap,aq in next,ao.Rows do
aq:Destroy()
end
ao.Rows={}

for ap,aq in next,ao.Items do
local ar=ak.CreateIcon(aa,aq.Icon,an.Window.Folder,"KeyValue",true,"KeyValueIcon")
if ar then
ar.Size=UDim2.new(0,16,0,16)
end

local as=ai("TextLabel",{
Name="Key",
BackgroundTransparency=1,
Text=tostring(aq.Title),
TextSize=14,
TextTransparency=0.35,
TextTruncate="AtEnd",
TextXAlignment="Left",
Size=UDim2.new(0.45,ar and-24 or 0,0,0),
AutomaticSize="Y",
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})

local at=ai("TextLabel",{
Name="Value",
BackgroundTransparency=1,
Text=tostring(aq.Value or""),
TextSize=14,
TextTransparency=0.05,
TextWrapped=true,
TextXAlignment="Right",
Size=UDim2.new(0.55,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
})

local au=ai("Frame",{
Name="Row",
LayoutOrder=ap,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.UIElements.List,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
ar,
as,
at,
})

table.insert(ao.Rows,au)
end
end

function ao.SetItems(ap,aq)
ao.Items=ak.NormalizeItems(aq or{},"Key","Value")
Render()
af.Play(ao.UIElements.List,"Reveal",{BackgroundTransparency=1},nil,nil,"Render")
return ao.Items
end

Render()

return ao.__type,ao
end

return al end function a.ak()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local function GetWidth(am)
return math.max(ak.ToFiniteNumber(am.Width)or ak.ToFiniteNumber(am.ControlWidth)or 190,120)
end

function al.New(am,an)
local ao={
__type="ChipList",
Title=an.Title or"Chips",
Desc=an.Desc,
Options=ak.NormalizeItems(an.Options or an.Values or{}),
Values=ak.NormalizeValues(an.Value or an.ValuesSelected or an.SelectedValues),
Multi=an.Multi~=false,
Callback=an.Callback or function()end,
Locked=an.Locked or false,
LockedTitle=an.LockedTitle,
Animation=an.Animation~=false,
UIElements={},
Chips={},

Width=GetWidth(an),
}

local ap=true

ao.ChipListFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=ao.Width+14,
Hover=false,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.List=ai("Frame",{
Name="ChipList",
Size=UDim2.new(0,ao.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0),
AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5),
BackgroundTransparency=1,
Parent=ao.ChipListFrame.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Right",
SortOrder="LayoutOrder",
}),
})

local function IsSelected(aq)
return ak.ContainsValue(ao.Values,aq)
end

local function UpdateVisuals(aq)
for ar,as in next,ao.Chips do
local at=IsSelected(as.Option.Value)
local au=at and 0.82 or 0.94
local av=as.Option.Disabled and 0.55 or(at and 0 or 0.2)

if aq and ao.Animation then
af.Play(as.Button,"Select",{ImageTransparency=au},nil,nil,"State")
af.Play(as.Title,"Select",{TextTransparency=av},nil,nil,"State")
else
as.Button.ImageTransparency=au
as.Title.TextTransparency=av
end
end
end

local function Sanitize(aq)
local ar={}
for as,at in next,aq or{}do
for au,av in next,ao.Options do
if av.Value==at and not av.Disabled and not ak.ContainsValue(ar,at)then
table.insert(ar,at)
break
end
end
end
return ar
end

local function CreateChip(aq,ar)
local as=ai("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Text=aq.Title,
TextSize=13,
TextTruncate="AtEnd",
TextXAlignment="Center",
Size=UDim2.new(1,-16,1,0),
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
})

local at=aa.NewRoundFrame(999,"Squircle",{
Name="Chip",
Size=UDim2.new(1,0,0,30),
LayoutOrder=ar,
ImageTransparency=0.94,
Active=not aq.Disabled,
ThemeTag={
ImageColor3="ChipListBackground",
},
Parent=ao.UIElements.List,
},{
as,
},true)

local au={
Button=at,
Title=as,
Option=aq,
}
ao.Chips[ar]=au

af.AttachPress(at,aa,{
Amount=0.96,
Enabled=function()
return ao.Animation and not ao.Locked and not aq.Disabled
end,
})

aa.AddSignal(at.MouseButton1Click,function()
if not aq.Disabled then
ao:Toggle(aq.Value)
end
end)
end

local function Render()
for aq,ar in next,ao.Chips do
ar.Button:Destroy()
end
ao.Chips={}

for aq,ar in next,ao.Options do
CreateChip(ar,aq)
end

ao.Values=Sanitize(ao.Values)
UpdateVisuals(false)
end

function ao.Lock(aq)
ao.Locked=true
ap=false
return ao.ChipListFrame:Lock(ao.LockedTitle)
end

function ao.Unlock(aq)
ao.Locked=false
ap=true
return ao.ChipListFrame:Unlock()
end

function ao.Get(aq)
return ao.Multi and ak.CloneArray(ao.Values)or ao.Values[1]
end

function ao.Set(aq,ar,as)
local at=ak.NormalizeValues(ar)
if not ao.Multi and at[1]~=nil then
at={at[1]}
end

ao.Values=Sanitize(at)
UpdateVisuals(true)

if ap and as~=false then
aa.SafeCallback(ao.Callback,ao:Get())
end

return ao:Get()
end

function ao.Toggle(aq,ar,as)
if ao.Multi then
ao.Values=ak.ToggleValue(ao.Values,ar)
return ao:Set(ao.Values,as)
end

return ao:Set(ar,as)
end

function ao.SetOptions(aq,ar)
ao.Options=ak.NormalizeItems(ar or{})
Render()
return ao.Options
end

Render()

if ao.Locked then
ao:Lock()
end

return ao.__type,ao
end

return al end function a.al()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local function NormalizeActions(am)
local an={}

for ao,ap in next,am or{}do
if typeof(ap)=="table"then
table.insert(an,{
Title=tostring(ap.Title or ap.Name or ap.Value or("Action "..tostring(ao))),
Desc=ap.Desc or ap.Content,
Value=ap.Value or ap.Badge,
Icon=ap.Icon,
Color=ak.GetColor(ap.Color,nil),
Disabled=ap.Disabled==true,
Callback=ap.Callback,
})
else
table.insert(an,{
Title=tostring(ap),
Disabled=false,
})
end
end

return an
end

function al.New(am,an)
local ao={
__type="ActionList",
Title=an.Title or"Actions",
Desc=an.Desc,
Actions=NormalizeActions(an.Actions or an.Items or an.Values or{}),
Rows={},
UIElements={},
}

ao.ActionListFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=0,
Hover=an.Hover==true,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.List=ai("Frame",{
Name="ActionList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.ActionListFrame.UIElements.Container,
},{
ai("UIListLayout",{
Padding=UDim.new(0,an.Window.NewElements and 6 or 8),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

local function Render()
for ap,aq in next,ao.Rows do
aq:Destroy()
end
ao.Rows={}

for ap,aq in next,ao.Actions do
local ar=ak.CreateIcon(aa,aq.Icon or"circle-dot",an.Window.Folder,"ActionList",true,"ActionListIcon")
if ar then
ar.Size=UDim2.fromOffset(17,17)
end
local as=ak.GetImageTarget(ar)
if as and aq.Color then
as.ImageColor3=aq.Color
end

local at=ai("Frame",{
Name="Texts",
Size=UDim2.new(1,aq.Value and-96 or-42,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ai("UIListLayout",{
Padding=UDim.new(0,2),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=aq.Title,
TextSize=14,
TextTransparency=aq.Disabled and 0.46 or 0.04,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
aq.Desc and ai("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=tostring(aq.Desc),
TextSize=12,
TextTransparency=aq.Disabled and 0.62 or 0.38,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})or nil,
})

local au
if aq.Value~=nil then
au=aa.NewRoundFrame(999,"Squircle",{
Name="Value",
Size=UDim2.new(0,0,0,26),
AutomaticSize="X",
ImageTransparency=0.88,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ai("TextLabel",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
Text=tostring(aq.Value),
TextSize=12,
TextTransparency=0.12,
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Text",
},
}),
})
end

local av=aa.NewRoundFrame(14,"Squircle",{
Name="Action",
LayoutOrder=ap,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=aq.Disabled and 0.96 or 0.92,
Parent=ao.UIElements.List,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ar,
at,
au,
},not aq.Disabled)

if not aq.Disabled then
af.AttachPress(av,aa,{
Amount=0.985,
})
aa.AddSignal(av.MouseButton1Click,function()
if typeof(aq.Callback)=="function"then
aa.SafeCallback(aq.Callback,aq,ap)
elseif typeof(an.Callback)=="function"then
aa.SafeCallback(an.Callback,aq,ap)
end
end)
end

table.insert(ao.Rows,av)
end
end

function ao.SetActions(ap,aq)
ao.Actions=NormalizeActions(aq)
Render()
return ao.Actions
end

function ao.AddAction(ap,aq)
local ar=NormalizeActions{aq}[1]
if ar then
table.insert(ao.Actions,ar)
Render()
end
return ar
end

Render()

return ao.__type,ao
end

return al end function a.am()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local function NormalizeMeters(am)
local an={}

for ao,ap in next,am or{}do
if typeof(ap)=="table"then
local aq=ak.ToFiniteNumber(ap.Max)or 100
local ar=ak.ToFiniteNumber(ap.Value or ap.Default)or 0
table.insert(an,{
Title=tostring(ap.Title or ap.Name or("Meter "..tostring(ao))),
Value=math.clamp(ar,0,aq),
Max=math.max(aq,0.0001),
Desc=ap.Desc,
Color=ak.GetColor(ap.Color,nil),
Format=ap.Format,
})
else
table.insert(an,{
Title=tostring(ao),
Value=math.clamp(ak.ToFiniteNumber(ap)or 0,0,100),
Max=100,
})
end
end

return an
end

function al.New(am,an)
local ao={
__type="MeterGroup",
Title=an.Title or"Meters",
Desc=an.Desc,
Meters=NormalizeMeters(an.Meters or an.Items or an.Values or{}),
Rows={},
UIElements={},
}

ao.MeterGroupFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=0,
Hover=an.Hover==true,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.List=ai("Frame",{
Name="MeterGroup",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.MeterGroupFrame.UIElements.Container,
},{
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

local function FormatValue(ap)
local aq=math.clamp(ap.Value/ap.Max,0,1)
if typeof(ap.Format)=="function"then
local ar,as=pcall(ap.Format,ap.Value,ap.Max,aq)
if ar and as~=nil then
return tostring(as)
end
end
return tostring(math.floor((aq*100)+0.5)).."%"
end

local function Render()
for ap,aq in next,ao.Rows do
aq.Frame:Destroy()
end
ao.Rows={}

for ap,aq in next,ao.Meters do
local ar=math.clamp(aq.Value/aq.Max,0,1)
local as=aa.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(ar,0,1,0),
ImageTransparency=0.08,
ImageColor3=aq.Color,
ThemeTag=not aq.Color and{
ImageColor3="Primary",
}or nil,
})

local at=ai("TextLabel",{
Name="Value",
Size=UDim2.new(0,52,0,18),
BackgroundTransparency=1,
Text=FormatValue(aq),
TextSize=12,
TextTransparency=0.22,
TextXAlignment="Right",
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Text",
},
})

local au=ai("Frame",{
Name="Meter",
LayoutOrder=ap,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.UIElements.List,
},{
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
ai("Frame",{
Name="Header",
Size=UDim2.new(1,0,0,18),
BackgroundTransparency=1,
},{
ai("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,-58,1,0),
BackgroundTransparency=1,
Text=aq.Title,
TextSize=13,
TextTransparency=0.1,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
at,
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
as,
}),
aq.Desc and ai("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=tostring(aq.Desc),
TextSize=12,
TextTransparency=0.42,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
})or nil,
})

ao.Rows[ap]={
Frame=au,
Fill=as,
ValueLabel=at,
}
end
end

function ao.SetValue(ap,aq,ar)
local as=ao.Meters[aq]
local at=ao.Rows[aq]
if not as or not at then
return nil
end

as.Value=math.clamp(ak.ToFiniteNumber(ar)or as.Value,0,as.Max)
local au=math.clamp(as.Value/as.Max,0,1)
at.ValueLabel.Text=FormatValue(as)
af.Play(at.Fill,"Fast",{
Size=UDim2.new(au,0,1,0),
},nil,nil,"Meter")
return as.Value
end

function ao.SetMeters(ap,aq)
ao.Meters=NormalizeMeters(aq)
Render()
return ao.Meters
end

Render()

return ao.__type,ao
end

return al end function a.an()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

function al.New(am,an)
local ao={
__type="Timeline",
Title=an.Title or"Timeline",
Desc=an.Desc,
Items=ak.NormalizeItems(an.Items or an.Events or{}),
UIElements={},
Rows={},
}

ao.TimelineFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=0,
Hover=an.Hover==true,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.List=ai("Frame",{
Name="TimelineList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.TimelineFrame.UIElements.Container,
},{
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

local function Render()
for ap,aq in next,ao.Rows do
aq:Destroy()
end
ao.Rows={}

for ap,aq in next,ao.Items do
local ar=ak.GetVariant(aq.Value)
local as=ak.GetColor(aq.Color,ar.Color)

local at=aa.NewRoundFrame(999,"Circle",{
Name="Dot",
Size=UDim2.new(0,10,0,10),
Position=UDim2.new(0.5,0,0,5),
AnchorPoint=Vector2.new(0.5,0),
ImageTransparency=1,
ImageColor3=as,
})

local au=ai("Frame",{
Name="Rail",
Size=UDim2.new(0,24,0,aq.Desc and 46 or 30),
BackgroundTransparency=1,
},{
ai("Frame",{
Name="Line",
Size=UDim2.new(0,1,1,ap==#ao.Items and-8 or 0),
Position=UDim2.new(0.5,0,0,16),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=0.86,
ThemeTag={
BackgroundColor3="TimelineLine",
},
}),
at,
})

local av=ai("Frame",{
Name="Text",
Size=UDim2.new(1,-32,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ai("UIListLayout",{
Padding=UDim.new(0,3),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
ak.CreateText(ai,aa,aq.Title,14,Enum.FontWeight.SemiBold,0),
aq.Desc and ak.CreateText(ai,aa,aq.Desc,13,Enum.FontWeight.Medium,0.4)or nil,
})

local aw=ai("Frame",{
Name="Item",
LayoutOrder=ap,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.UIElements.List,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
au,
av,
})

table.insert(ao.Rows,aw)
task.delay((ap-1)*0.025,function()
if at.Parent then
af.Play(at,"Reveal",{ImageTransparency=0},nil,nil,"Reveal")
end
end)
end
end

function ao.SetItems(ap,aq)
ao.Items=ak.NormalizeItems(aq or{})
Render()
return ao.Items
end

Render()

return ao.__type,ao
end

return al end function a.ao()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local am=34

function al.New(an,ao)
local ap={
__type="Accordion",
Title=ao.Title or"Accordion",
Desc=ao.Desc,
Items=ak.NormalizeItems(ao.Items or ao.Sections or{}),
OpenIndex=ak.ToFiniteNumber(ao.OpenIndex or ao.DefaultOpen),
Multiple=ao.Multiple==true,
UIElements={},
Rows={},
}

local aq={}
if ap.OpenIndex then
aq[ap.OpenIndex]=true
end

ap.AccordionFrame=a.load'I'{
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

ap.UIElements.List=ai("Frame",{
Name="AccordionList",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.AccordionFrame.UIElements.Container,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

local function GetOpenHeight(ar)
return am+(ar.Content.AbsoluteSize.Y/ao.UIScale)+10
end

local function SetRowOpen(ar,as,at)
local au=ap.Rows[ar]
if not au then
return
end

aq[ar]=as or nil
au.Open=as

local av=UDim2.new(1,0,0,as and GetOpenHeight(au)or am)
if at then
au.Frame.Size=av
au.Chevron.Rotation=as and 180 or 0
else
af.Play(au.Frame,"Expand",{Size=av},nil,nil,"Expand")
af.Play(au.Chevron,"Expand",{Rotation=as and 180 or 0},nil,nil,"Chevron")
end
end

local function Render()
for ar,as in next,ap.Rows do
as.Frame:Destroy()
end
ap.Rows={}

for ar,as in next,ap.Items do
local at=ak.CreateIcon(aa,as.Icon,ao.Window.Folder,"Accordion",true,"AccordionIcon")
if at then
at.Size=UDim2.new(0,16,0,16)
end

local au=aa.Icon"chevron-down"
local av=ai("ImageLabel",{
Name="Chevron",
Size=UDim2.new(0,16,0,16),
BackgroundTransparency=1,
Image=au[1],
ImageRectOffset=au[2].ImageRectPosition,
ImageRectSize=au[2].ImageRectSize,
ImageTransparency=0.4,
ThemeTag={
ImageColor3="Icon",
},
})

local aw=ai("TextButton",{
Name="Header",
Size=UDim2.new(1,0,0,am),
BackgroundTransparency=1,
Text="",
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
at,
ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,at and-48 or-24,1,0),
BackgroundTransparency=1,
Text=as.Title,
TextSize=14,
TextTruncate="AtEnd",
TextXAlignment="Left",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
}),
av,
})

local ax=ai("Frame",{
Name="Content",
Size=UDim2.new(1,-20,0,0),
Position=UDim2.new(0,10,0,am),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ak.CreateText(ai,aa,as.Desc or"",13,Enum.FontWeight.Medium,0.4),
})

local ay=aa.NewRoundFrame(12,"Squircle",{
Name="Item",
LayoutOrder=ar,
Size=UDim2.new(1,0,0,am),
ClipsDescendants=true,
ImageTransparency=0.94,
ThemeTag={
ImageColor3="AccordionBackground",
},
Parent=ap.UIElements.List,
},{
aw,
ax,
})

ap.Rows[ar]={
Frame=ay,
Header=aw,
Content=ax,
Chevron=av,
Open=false,
}

af.AttachPress(aw,aa,{
Amount=0.985,
})

aa.AddSignal(aw.MouseButton1Click,function()
ap:Toggle(ar)
end)

aa.AddSignal(ax:GetPropertyChangedSignal"AbsoluteSize",function()
if ap.Rows[ar]and ap.Rows[ar].Open then
SetRowOpen(ar,true,true)
end
end)
end

for ar in next,aq do
SetRowOpen(ar,true,true)
end
end

function ap.Open(ar,as)
if not ap.Multiple then
for at in next,aq do
if at~=as then
SetRowOpen(at,false)
end
end
end

SetRowOpen(as,true)
end

function ap.Close(ar,as)
SetRowOpen(as,false)
end

function ap.Toggle(ar,as)
local at=ap.Rows[as]
if not at then
return
end
if at.Open then
ap:Close(as)
else
ap:Open(as)
end
end

function ap.SetItems(ar,as)
ap.Items=ak.NormalizeItems(as or{})
aq={}
Render()
return ap.Items
end

Render()

return ap.__type,ap
end

return al end function a.ap()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'n'.New

local al={}

function al.New(am,an)
local ao={
__type="EmptyState",
Title=an.Title or"Nothing here",
Desc=an.Desc or an.Content,
Icon=an.Icon or"inbox",
Buttons=an.Buttons or{},
UIElements={},
}

local ap=math.max(tonumber(an.Height)or 138,96)

ao.UIElements.Main=aa.NewRoundFrame(an.Window.ElementConfig.UICorner,"Squircle",{
Name="EmptyState",
Size=UDim2.new(1,0,0,ap),
AutomaticSize=#ao.Buttons>0 and"Y"or"None",
ImageTransparency=0.94,
Parent=an.Parent,
ThemeTag={
ImageColor3="ElementBackground",
},
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})

local aq=aa.Image(ao.Icon,ao.Icon,0,an.Window.Folder,"EmptyState",true,true,"EmptyStateIcon")
aq.Size=UDim2.new(0,tonumber(an.IconSize)or 34,0,tonumber(an.IconSize)or 34)
aq.ImageLabel.ImageTransparency=0.2
aq.Parent=ao.UIElements.Main

ao.UIElements.Title=ai("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Text=ao.Title,
TextSize=17,
TextWrapped=true,
TextXAlignment="Center",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
Parent=ao.UIElements.Main,
ThemeTag={
TextColor3="Text",
},
})

ao.UIElements.Desc=ai("TextLabel",{
Name="Desc",
BackgroundTransparency=1,
Text=ao.Desc or"",
TextSize=14,
TextTransparency=0.4,
TextWrapped=true,
TextXAlignment="Center",
AutomaticSize="Y",
Visible=ao.Desc~=nil,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
Parent=ao.UIElements.Main,
ThemeTag={
TextColor3="Text",
},
})

if#ao.Buttons>0 then
local ar=ai("Frame",{
Name="Buttons",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ao.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Center",
}),
})

for as,at in next,ao.Buttons do
local au=ak(
at.Title,
at.Icon,
at.Callback,
at.Variant or"White",
ar,
nil,
nil,
an.Window.NewElements and 999 or 10
)
au.Size=UDim2.new(1,0,0,36)
end
end

function ao.SetTitle(ar,as)
ao.Title=as
ao.UIElements.Title.Text=as
end

function ao.SetDesc(ar,as)
ao.Desc=as
ao.UIElements.Desc.Text=as or""
ao.UIElements.Desc.Visible=as~=nil
end

function ao.Highlight(ar)
af.Play(ao.UIElements.Main,"Highlight",{ImageTransparency=0.9},nil,nil,"Highlight")
task.delay(af.GetDuration"Highlight",function()
if ao.UIElements.Main.Parent then
af.Play(ao.UIElements.Main,"Highlight",{ImageTransparency=0.94},nil,nil,"Highlight")
end
end)
end

function ao.Destroy(ar)
ao.UIElements.Main:Destroy()
end

return ao.__type,ao
end

return al end function a.aq()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local am=Color3.fromHex"#5865F2"
local an=Color3.fromHex"#1E1F2A"

local function Trim(ao)
ao=tostring(ao or"")
ao=string.gsub(ao,"^%s+","")
ao=string.gsub(ao,"%s+$","")
return ao
end

local function GetInviteUrl(ao)
local ap=Trim(ao)
if ap==""then
return"https://discord.gg/"
end

if string.match(ap,"^https?://")then
return ap
end
if string.match(ap,"^discord%.gg/")or string.match(ap,"^discord%.com/invite/")then
return"https://"..ap
end

return"https://discord.gg/"..ap
end

local function CopyText(ao)
if typeof(setclipboard)=="function"then
local ap=pcall(function()
setclipboard(ao)
end)
return ap
end
if typeof(toclipboard)=="function"then
local ap=pcall(function()
toclipboard(ao)
end)
return ap
end
return false
end

local function Notify(ao,ap,aq,ar)
if ao and ao.Notify then
ao:Notify{
Title=ap,
Content=aq,
Icon=ar,
}
end
end

function al.New(ao,ap)
local aq=ap.Url or ap.Invite or ap.InviteCode or ap.Code
local ar=GetInviteUrl(aq)
local as={
__type="DiscordCard",
Title=ap.Title or ap.ServerName or"Discord Server",
Desc=ap.Desc or ap.Content or"Join the community and get updates.",
Invite=aq,
Url=ar,
Icon=ap.Icon or"message-circle",
Members=ap.Members or ap.MemberCount,
Online=ap.Online or ap.OnlineCount,
Callback=ap.Callback,
UIElements={},
}

local at=math.max(tonumber(ap.Height)or 152,126)

as.UIElements.Main=aa.NewRoundFrame(ap.Window.ElementConfig.UICorner,"Squircle",{
Name="DiscordCard",
Size=UDim2.new(1,0,0,at),
AutomaticSize="Y",
ImageColor3=an,
ImageTransparency=0,
Parent=ap.Parent,
},{
ai("UIGradient",{
Rotation=22,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,an),
ColorSequenceKeypoint.new(1,am),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.02),
NumberSequenceKeypoint.new(1,0.18),
},
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,14),
PaddingLeft=UDim.new(0,14),
PaddingRight=UDim.new(0,14),
PaddingBottom=UDim.new(0,14),
}),
ai("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

local au=ai("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=as.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
})

local av=aa.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,42,0,42),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.9,
Parent=au,
},{
ak.CreateIcon(aa,as.Icon,ap.Window.Folder,"DiscordCard",false,nil),
})

local aw=av:FindFirstChildWhichIsA"Frame"or av:FindFirstChildWhichIsA"ImageLabel"
if aw then
aw.Size=UDim2.new(0,20,0,20)
aw.Position=UDim2.new(0.5,0,0.5,0)
aw.AnchorPoint=Vector2.new(0.5,0.5)
local ax=ak.GetImageTarget(aw)
if ax then
ax.ImageColor3=Color3.new(1,1,1)
ax.ImageTransparency=0
end
end

local ax=ai("Frame",{
Size=UDim2.new(1,-52,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=au,
},{
ai("UIListLayout",{
Padding=UDim.new(0,3),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

as.UIElements.Title=ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=as.Title,
TextSize=18,
TextWrapped=true,
TextXAlignment="Left",
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
Parent=ax,
})

as.UIElements.Desc=ai("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=as.Desc,
TextSize=13,
TextWrapped=true,
TextXAlignment="Left",
TextColor3=Color3.new(1,1,1),
TextTransparency=0.26,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
Parent=ax,
})

local ay=ai("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=as.Members~=nil or as.Online~=nil,
Parent=as.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Left",
VerticalAlignment="Center",
}),
})

local function CreateStat(az,aA,aB)
return aa.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,0,0,28),
AutomaticSize="X",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.9,
Parent=ay,
},{
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aa.NewRoundFrame(999,"Circle",{
Size=UDim2.new(0,7,0,7),
ImageColor3=aB,
}),
ai("TextLabel",{
BackgroundTransparency=1,
Text=tostring(aA).." "..az,
TextSize=12,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.08,
AutomaticSize="XY",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
}),
})
end

if as.Members then
CreateStat("members",as.Members,Color3.fromHex"#B6C2FF")
end
if as.Online then
CreateStat("online",as.Online,Color3.fromHex"#23A55A")
end

local az=ai("Frame",{
Size=UDim2.new(1,0,0,36),
BackgroundTransparency=1,
Parent=as.UIElements.Main,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
HorizontalAlignment="Center",
}),
})

local function CreateButton(aA,aB,b,d)
local f=aa.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0.5,-4,1,0),
ImageColor3=b=="Primary"and Color3.new(1,1,1)or Color3.new(1,1,1),
ImageTransparency=b=="Primary"and 0.08 or 0.9,
Parent=az,
},{
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ai("UIListLayout",{
Padding=UDim.new(0,7),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
ak.CreateIcon(aa,aB,ap.Window.Folder,"DiscordCard",false,nil),
ai("TextLabel",{
BackgroundTransparency=1,
Text=aA,
TextSize=13,
TextColor3=b=="Primary"and Color3.fromHex"#111827"or Color3.new(1,1,1),
TextTransparency=0,
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
AutomaticSize="XY",
}),
},true)

local g=f:FindFirstChildWhichIsA"Frame"or f:FindFirstChildWhichIsA"ImageLabel"
local h=ak.GetImageTarget(g)
if h then
h.ImageColor3=b=="Primary"and Color3.fromHex"#111827"or Color3.new(1,1,1)
h.ImageTransparency=0
end

af.AttachPress(f,aa,{
Amount=0.97,
})

aa.AddSignal(f.MouseButton1Click,function()
aa.SafeCallback(d)
end)

return f
end

local function CopyInvite(aA)
if CopyText(as.Url)then
Notify(ap.WindUI,aA or"Discord link copied",as.Url,"check")
return true
else
Notify(ap.WindUI,"Discord invite",as.Url,"link")
return false
end
end

CreateButton(ap.CopyTitle or"Copy Link","link","Secondary",function()
CopyInvite"Discord link copied"
end)

CreateButton(ap.JoinTitle or"Join","external-link","Primary",function()
if as.Callback then
aa.SafeCallback(as.Callback,as.Url,as)
end

CopyInvite"Discord invite ready"
end)

function as.SetInvite(aA,aB)
as.Invite=aB
as.Url=GetInviteUrl(aB)
return as.Url
end

function as.GetUrl(aA)
return as.Url
end

function as.Copy(aA)
return CopyInvite"Discord link copied"
end

function as.Open(aA)
if as.Callback then
aa.SafeCallback(as.Callback,as.Url,as)
end
return CopyInvite"Discord invite ready"
end

function as.SetTitle(aA,aB)
as.Title=aB
as.UIElements.Title.Text=aB
end

function as.SetDesc(aA,aB)
as.Desc=aB
as.UIElements.Desc.Text=aB or""
end

function as.Highlight(aA)
af.Play(as.UIElements.Main,"Highlight",{ImageTransparency=0.08},nil,nil,"Highlight")
task.delay(af.GetDuration"Highlight",function()
if as.UIElements.Main.Parent then
af.Play(as.UIElements.Main,"Highlight",{ImageTransparency=0},nil,nil,"Highlight")
end
end)
end

function as.Destroy(aA)
as.UIElements.Main:Destroy()
end

return as.__type,as
end

return al end function a.ar()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

function al.New(am,an)
local ao={
__type="TabBox",
Title=an.Title or"Tabs",
Desc=an.Desc,
Tabs={},
Selected=nil,
SelectedValue=nil,
UIElements={},
}

ao.TabBoxFrame=a.load'I'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=0,
Hover=an.Hover==true,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
Tags=an.Tags,
}

ao.UIElements.Tabs=ai("ScrollingFrame",{
Name="Tabs",
Size=UDim2.new(1,0,0,an.TabHeight or 36),
BackgroundTransparency=1,
ScrollBarThickness=0,
ScrollingDirection="X",
ScrollingEnabled=true,
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
ElasticBehavior="Never",
Active=true,
Parent=ao.TabBoxFrame.UIElements.Container,
},{
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

ao.UIElements.Pages=ai("Frame",{
Name="Pages",
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=1,
ClipsDescendants=false,
Parent=ao.TabBoxFrame.UIElements.Container,
})

local function UpdateTabVisuals()
for ap,aq in next,ao.Tabs do
local ar=ao.Selected==ap
af.Play(aq.Button,"Switch",{ImageTransparency=ar and 0.82 or 0.94},nil,nil,"State")
af.Play(aq.TitleLabel,"Switch",{TextTransparency=ar and 0 or 0.25},nil,nil,"State")
if aq.IconTarget then
af.Play(aq.IconTarget,"Switch",{ImageTransparency=ar and 0 or 0.35},nil,nil,"State")
end
end
end

local function GetPageHeight(ap)
local aq=ap.UIElements.Container.UIListLayout
local ar=an.Window.ElementConfig.UIPadding/2
local as=aq.AbsoluteContentSize.Y/an.UIScale+ar
return math.max(as,ar)
end

local function UpdatePageHeight(ap)
if not ap or not ap.UIElements.Container then
return
end

local aq=GetPageHeight(ap)
ap.UIElements.Container.Size=UDim2.new(1,0,0,aq)
ao.UIElements.Pages.Size=UDim2.new(1,0,0,aq)
return aq
end

local function ScrollTabIntoView(ap)
task.defer(function()
if not ap or not ap.Button or not ap.Button.Parent then
return
end

local aq=ao.UIElements.Tabs
local ar=aq.AbsoluteSize.X
local as=ap.Button.AbsolutePosition.X-aq.AbsolutePosition.X+aq.CanvasPosition.X
local at=as+ap.Button.AbsoluteSize.X
local au=aq.CanvasPosition.X
local av=au+ar
local aw=au

if as<au then
aw=as
elseif at>av then
aw=at-ar
end

if math.abs(aw-au)>1 then
aq.CanvasPosition=Vector2.new(math.max(aw,0),0)
end
end)
end

local function QueuePageHeightUpdate(ap,aq)
task.defer(function()
if ao.Selected==aq and ap and ap.UIElements.Container.Parent then
UpdatePageHeight(ap)
end
end)
end

function ao.Select(ap,aq)
local ar=ao.Tabs[aq]
if not ar then
return nil
end

ao.Selected=aq
ao.SelectedValue=ar.Value
for as,at in next,ao.Tabs do
local au=as==aq
at.UIElements.Container.Visible=au
at.UIElements.Container.Active=au
at.UIElements.Container.GroupTransparency=1
if au then
at.UIElements.Container.Position=UDim2.new(0,0,0,8)
end
end

UpdatePageHeight(ar)
af.Play(ar.UIElements.Container,"Switch",{GroupTransparency=0},nil,nil,"Page")
af.Play(ar.UIElements.Container,"Switch",{Position=UDim2.new(0,0,0,0)},nil,nil,"PageSlide")
QueuePageHeightUpdate(ar,aq)
UpdateTabVisuals()
ScrollTabIntoView(ar)
return ar
end

function ao.GetSelected(ap)
return ao.Selected and ao.Tabs[ao.Selected]or nil
end

function ao.Get(ap)
return ao.SelectedValue
end

function ao.SelectValue(ap,aq)
for ar,as in next,ao.Tabs do
if as.Value==aq then
return ao:Select(ar)
end
end
return nil
end

function ao.Set(ap,aq)
return ao:SelectValue(aq)
end

function ao.Tab(ap,aq)
aq=aq or{}
local ar=#ao.Tabs+1
local as={
__type="TabBoxPage",
Title=aq.Title or("Tab "..tostring(ar)),
Value=aq.Value or aq.Id or ar,
Icon=aq.Icon,
Elements={},
UIElements={},
Gap=an.Tab and an.Tab.Gap or 6,
}

local at=ak.CreateIcon(aa,as.Icon,an.Window.Folder,"TabBox",true,"TabBoxIcon")
if at then
at.Size=UDim2.new(0,15,0,15)
end
local au=ak.GetImageTarget(at)
local av=string.len(as.Title)*(an.Window.IsPC==false and 6 or 7)
local aw=math.clamp(av+(at and 40 or 26),an.MinTabWidth or 68,an.MaxTabWidth or 154)

local ax=ai("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Text=as.Title,
TextSize=an.Window.IsPC==false and 12 or 13,
TextTruncate="AtEnd",
Size=UDim2.new(0,math.max(aw-(at and 42 or 20),24),1,0),
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
})

local ay=aa.NewRoundFrame(999,"Squircle",{
Name="Tab",
LayoutOrder=ar,
Size=UDim2.new(0,aw,0,an.TabButtonHeight or 30),
ImageTransparency=0.94,
ClipsDescendants=true,
ThemeTag={
ImageColor3="TabBoxTabBackground",
},
Parent=ao.UIElements.Tabs,
},{
ai("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
}),
ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
at,
ax,
},true)

local az=ai("CanvasGroup",{
Name="Page",
LayoutOrder=ar,
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
GroupTransparency=1,
Visible=false,
Active=false,
Parent=ao.UIElements.Pages,
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,an.Window.ElementConfig.UIPadding/2),
}),
ai("UIListLayout",{
Padding=UDim.new(0,as.Gap),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

as.Button=ay
as.TitleLabel=ax
as.Icon=at
as.IconTarget=au
as.ElementFrame=az
as.UIElements.Container=az
as.UIElements.Title=ax

an.ElementsModule.Load(
as,
az,
an.ElementsModule.Elements,
an.Window,
an.WindUI,
function()
QueuePageHeightUpdate(as,ar)
end,
an.ElementsModule,
an.UIScale,
an.Tab
)

function as.Select(aA)
return ao:Select(ar)
end

function as.Destroy(aA)
ay:Destroy()
az:Destroy()
table.remove(ao.Tabs,ar)
if ao.Selected==ar then
ao.Selected=nil
if ao.Tabs[1]then
ao:Select(1)
end
end
end

ao.Tabs[ar]=as

af.AttachPress(ay,aa,{
Amount=0.97,
})

aa.AddSignal(ay.MouseButton1Click,function()
ao:Select(ar)
end)

aa.AddSignal(az.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
QueuePageHeightUpdate(as,ar)
end)

if not ao.Selected or aq.Selected==true or aq.Value==an.Value then
ao:Select(ar)
else
UpdateTabVisuals()
end

if typeof(aq.Elements)=="function"then
task.defer(function()
aa.SafeCallback(aq.Elements,as)
end)
end

return as
end

function ao.CreateTab(ap,aq)
return ao:Tab(aq)
end

for ap,aq in next,an.Tabs or{}do
ao:Tab(aq)
end

return ao.__type,ao
end

return al end function a.as()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local am={
Vector2.new(0.08,0.72),
Vector2.new(0.28,0.38),
Vector2.new(0.52,0.56),
Vector2.new(0.72,0.24),
Vector2.new(0.92,0.42),
}

local function NormalizePoint(an)
if typeof(an)=="Vector2"then
return Vector2.new(math.clamp(an.X,0,1),math.clamp(an.Y,0,1))
end

if typeof(an)=="table"then
local ao=ak.ToFiniteNumber(an.X or an.x or an[1])or 0
local ap=ak.ToFiniteNumber(an.Y or an.y or an[2])or 0
return Vector2.new(math.clamp(ao,0,1),math.clamp(ap,0,1))
end

return Vector2.new(0,0)
end

local function NormalizePoints(an)
local ao={}
for ap,aq in next,an or am do
table.insert(ao,NormalizePoint(aq))
end

if#ao<2 then
ao=am
end

return ao
end

local function PointToUDim2(an)
return UDim2.new(an.X,0,an.Y,0)
end

local function PixelToUDim2(an)
return UDim2.fromOffset(an.X,an.Y)
end

local function GetAngle(an,ao)
if math.atan2 then
return math.atan2(an,ao)
end

if ao==0 then
return an>=0 and math.pi/2 or-math.pi/2
end

local ap=math.atan(an/ao)
if ao<0 then
ap+=math.pi
end
return ap
end

function al.New(an,ao)
local ap={
__type="Path2D",
Title=ao.Title or"Path 2D",
Desc=ao.Desc,
Points=NormalizePoints(ao.Points or ao.Path),
Labels=ao.Labels or{},
Height=math.max(ak.ToFiniteNumber(ao.Height)or 156,96),
Thickness=math.max(ak.ToFiniteNumber(ao.Thickness)or 4,2),
Padding=math.max(ak.ToFiniteNumber(ao.PathPadding or ao.Padding)or 20,0),
Duration=math.max(ak.ToFiniteNumber(ao.Duration)or 1.2,0.18),
StepDelay=math.max(ak.ToFiniteNumber(ao.StepDelay)or 0.055,0),
Loop=ao.Loop==true,
AutoPlay=ao.AutoPlay~=false,
UIElements={},
Segments={},
Dots={},
LabelObjects={},
PlayToken=0,
HasRendered=false,
Destroyed=false,
}

ap.Path2DFrame=a.load'I'{
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

ap.UIElements.Canvas=aa.NewRoundFrame(ao.Window.ElementConfig.UICorner,"Squircle",{
Name="Path2DCanvas",
Size=UDim2.new(1,0,0,ap.Height),
ClipsDescendants=true,
ImageTransparency=0.93,
Parent=ap.Path2DFrame.UIElements.Container,
ThemeTag={
ImageColor3="Path2DBackground",
},
},{
ai("UIGradient",{
Rotation=25,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.08),
NumberSequenceKeypoint.new(1,0.28),
},
}),
})

local function ClearObjects()
for aq,ar in next,ap.Segments do
ar.Track:Destroy()
end
for aq,ar in next,ap.Dots do
ar:Destroy()
end
for aq,ar in next,ap.LabelObjects do
ar:Destroy()
end

ap.Segments={}
ap.Dots={}
ap.LabelObjects={}
end

local function GetCanvasSize()
local aq=ap.UIElements.Canvas.AbsoluteSize
return Vector2.new(aq.X/ao.UIScale,aq.Y/ao.UIScale)
end

local function GetPixelPoint(aq,ar)
local as=math.min(ap.Padding,math.max(ar.X,ar.Y)/3)
local at=Vector2.new(
math.max(ar.X-(as*2),1),
math.max(ar.Y-(as*2),1)
)

return Vector2.new(
as+(aq.X*at.X),
as+(aq.Y*at.Y)
)
end

function ap.Render(aq,ar)
local as=GetCanvasSize()
if as.X<=0 or as.Y<=0 then
return
end

local at=ar~=false and ap.AutoPlay
ap.PlayToken=ap.PlayToken+1
ap.HasRendered=true
ClearObjects()

for au,av in next,ap.Points do
local aw=GetPixelPoint(av,as)
local ax=aa.NewRoundFrame(999,"Circle",{
Name="Point"..tostring(au),
Size=UDim2.new(0,au==1 and 12 or 9,0,au==1 and 12 or 9),
Position=PixelToUDim2(aw),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=at and 0.35 or 0.16,
Parent=ap.UIElements.Canvas,
ThemeTag={
ImageColor3=au==#ap.Points and"Path2DMarker"or"Path2DLine",
},
})
table.insert(ap.Dots,ax)
end

for au=1,#ap.Points-1 do
local av=GetPixelPoint(ap.Points[au],as)
local aw=GetPixelPoint(ap.Points[au+1],as)
local ax=aw-av
local ay=ax.Magnitude
local az=math.deg(GetAngle(ax.Y,ax.X))
local aA=(av+aw)/2

local aB=aa.NewRoundFrame(999,"Squircle",{
Name="Segment"..tostring(au),
Size=UDim2.new(0,ay,0,ap.Thickness),
Position=PixelToUDim2(aA),
AnchorPoint=Vector2.new(0.5,0.5),
Rotation=az,
ImageTransparency=0.84,
Parent=ap.UIElements.Canvas,
ThemeTag={
ImageColor3="Path2DTrack",
},
})

local b=aa.NewRoundFrame(999,"Squircle",{
Name="Fill",
Size=UDim2.new(0,at and 0 or ay,1,0),
ImageTransparency=0,
Parent=aB,
ThemeTag={
ImageColor3="Path2DLine",
},
})

table.insert(ap.Segments,{
Track=aB,
Fill=b,
Length=ay,
From=ap.Points[au],
To=ap.Points[au+1],
FromPosition=PixelToUDim2(av),
ToPosition=PixelToUDim2(aw),
})
end

for au,av in next,ap.Labels do
if typeof(av)~="table"then
av={
Text=tostring(av),
}
end
local aw=math.clamp(math.floor(ak.ToFiniteNumber(av.Point or av.Index)or 1),1,#ap.Points)
local ax=GetPixelPoint(ap.Points[aw],as)
local ay=ai("TextLabel",{
Name="PathLabel",
Size=UDim2.new(0,86,0,20),
Position=PixelToUDim2(ax),
AnchorPoint=Vector2.new(0.5,av.Above==false and 0 or 1),
BackgroundTransparency=1,
Text=tostring(av.Text or av.Title or aw),
TextSize=12,
TextTransparency=0.22,
TextXAlignment="Center",
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
Parent=ap.UIElements.Canvas,
ThemeTag={
TextColor3="Path2DLabel",
},
})
table.insert(ap.LabelObjects,ay)
end

local au=aa.NewRoundFrame(999,"Circle",{
Name="Marker",
Size=UDim2.new(0,16,0,16),
Position=at and ap.Segments[1]and ap.Segments[1].FromPosition
or PixelToUDim2(GetPixelPoint(ap.Points[#ap.Points],as)),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=0,
Parent=ap.UIElements.Canvas,
ThemeTag={
ImageColor3="Path2DMarker",
},
},{
aa.NewRoundFrame(999,"Circle",{
Name="Core",
Size=UDim2.new(0,6,0,6),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
}),
})
ap.UIElements.Marker=au

if at then
ap:Play()
end
end

function ap.Play(aq)
ap.PlayToken=ap.PlayToken+1
local ar=ap.PlayToken
local as=ap.Duration/math.max(#ap.Segments,1)

if ap.UIElements.Marker then
ap.UIElements.Marker.Position=ap.Segments[1]and ap.Segments[1].FromPosition
or PointToUDim2(ap.Points[1])
end
for at,au in next,ap.Dots do
au.ImageTransparency=0.72
end
for at,au in next,ap.Segments do
au.Fill.Size=UDim2.new(0,0,1,0)
end

for at,au in next,ap.Segments do
local av=(at-1)*(as+ap.StepDelay)
task.delay(av,function()
if ar~=ap.PlayToken or ap.Destroyed then
return
end

if ap.Dots[at]then
af.Play(ap.Dots[at],"Reveal",{ImageTransparency=0.12},nil,nil,"Point")
end
af.Play(
au.Fill,
as,
{Size=UDim2.new(0,au.Length,1,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Draw"
)
if ap.UIElements.Marker then
af.Play(
ap.UIElements.Marker,
as,
{Position=au.ToPosition},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Path"
)
end
end)
end

local at=#ap.Segments*(as+ap.StepDelay)
task.delay(at,function()
if ar~=ap.PlayToken or ap.Destroyed then
return
end
if ap.Dots[#ap.Dots]then
af.Play(ap.Dots[#ap.Dots],"Reveal",{ImageTransparency=0},nil,nil,"Point")
end
if ap.Loop then
task.delay(0.4,function()
if ar==ap.PlayToken and not ap.Destroyed then
ap:Play()
end
end)
end
end)
end

function ap.Stop(aq)
ap.PlayToken=ap.PlayToken+1
if ap.UIElements.Marker then
af.Cancel(ap.UIElements.Marker,"Path")
end
for ar,as in next,ap.Segments do
af.Cancel(as.Fill,"Draw")
end
end

function ap.SetPoints(aq,ar)
ap.Points=NormalizePoints(ar)
ap:Render(true)
return ap.Points
end

function ap.Destroy(aq)
ap.Destroyed=true
ap:Stop()
ap.Path2DFrame:Destroy()
end

aa.AddSignal(ap.UIElements.Canvas:GetPropertyChangedSignal"AbsoluteSize",function()
ap:Render(not ap.HasRendered)
end)

task.defer(function()
ap:Render(true)
end)

return ap.__type,ap
end

return al end function a.at()

local aa=a.load'd'
local af=a.load'e'
local ai=aa.New

local ak=a.load'af'

local al={}

local function GetText(am,an)
if am==nil then
return an
end
return tostring(am)
end

local function GetCardColor(am,an)
return ak.GetColor(am,an)
end

function al.New(am,an)
local ao={
__type="Card",
Title=GetText(an.Title,"Card"),
Desc=an.Desc or an.Content,
Icon=an.Icon,
Image=an.Image or an.Background or an.BackgroundImage,
Callback=an.Callback,
OpenTab=an.OpenTab==true or an.CardTab==true or typeof(an.Build)=="function",
Elements={},
UIElements={},
ElementFrame=nil,
LinkCorners=an.LinkCorners==true,
}

local ap=an.Radius or an.Window.ElementConfig.UICorner
local aq=GetCardColor(an.Color or an.Accent,nil)
local ar=tonumber(an.Height)or 0
local as=typeof(ao.Callback)=="function"or ao.OpenTab
local at
local au
local av

ao.UIElements.Main,at=aa.NewRoundFrame(ap,"Squircle",{
Name="Card",
Size=UDim2.new(1,0,0,ar),
AutomaticSize="Y",
ImageTransparency=1,
Parent=an.Parent,
ClipsDescendants=true,
},{},as)
ao.ElementFrame=ao.UIElements.Main

ao.UIElements.Background=ai("Frame",{
Name="Background",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=aa.ClampTransparency(
an.Transparency,
an.Window.LiquidGlass and 0.84 or 0.9
),
BackgroundColor3=aq or nil,
ZIndex=0,
Parent=ao.UIElements.Main,
ThemeTag=aq and nil or{
BackgroundColor3="ElementBackground",
},
},{
ai("UICorner",{
CornerRadius=UDim.new(0,ap),
}),
})
au=ao.UIElements.Background.UICorner

ao.UIElements.Content=ai("Frame",{
Name="Content",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
ZIndex=2,
Parent=ao.UIElements.Main,
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,an.Padding or 14),
PaddingLeft=UDim.new(0,an.Padding or 14),
PaddingRight=UDim.new(0,an.Padding or 14),
PaddingBottom=UDim.new(0,an.Padding or 14),
}),
ai("UIListLayout",{
Padding=UDim.new(0,an.Gap or 12),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

if ao.Image then
ao.UIElements.Image=aa.Image(ao.Image,ao.Title.."-card-image",0,an.Window.Folder,"Card",false,false)
ao.UIElements.Image.Size=UDim2.new(1,0,1,0)
ao.UIElements.Image.Position=UDim2.new(0.5,0,0.5,0)
ao.UIElements.Image.AnchorPoint=Vector2.new(0.5,0.5)
ao.UIElements.Image.Parent=ao.UIElements.Main
ao.UIElements.Image.ZIndex=0

local aw=ak.GetImageTarget(ao.UIElements.Image)
if aw then
aw.ZIndex=0
aw.ImageTransparency=an.ImageTransparency or 0.32
aw.ScaleType=an.ScaleType or Enum.ScaleType.Crop
av=ai("UICorner",{
CornerRadius=UDim.new(0,ap),
Parent=aw,
})
end
end

local aw=ai("Frame",{
Name="Header",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
LayoutOrder=1,
Parent=ao.UIElements.Content,
},{
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
})

if ao.Icon then
local ax=ak.CreateIcon(aa,ao.Icon,an.Window.Folder,"Card",true,"CardIcon")
if ax then
ax.Size=UDim2.new(0,22,0,22)
ax.Parent=aw
local ay=ak.GetImageTarget(ax)
if ay and aq then
ay.ImageColor3=aq
ay.ImageTransparency=0
end
end
end

local ax=ai("Frame",{
Name="Texts",
Size=UDim2.new(1,ao.Icon and-32 or 0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aw,
},{
ai("UIListLayout",{
Padding=UDim.new(0,3),
FillDirection="Vertical",
HorizontalAlignment="Left",
}),
})

ao.UIElements.Title=ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ao.Title,
TextSize=an.TitleSize or 17,
TextTransparency=0.02,
TextXAlignment="Left",
TextWrapped=true,
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
Parent=ax,
ThemeTag={
TextColor3="Text",
},
})

ao.UIElements.Desc=ai("TextLabel",{
Name="Desc",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ao.Desc or"",
TextSize=an.DescSize or 13,
TextTransparency=0.34,
TextXAlignment="Left",
TextWrapped=true,
Visible=ao.Desc~=nil,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
Parent=ax,
ThemeTag={
TextColor3="Text",
},
})

ao.UIElements.Body=ai("Frame",{
Name="Body",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
LayoutOrder=2,
Parent=ao.UIElements.Content,
},{
ai("UIListLayout",{
Padding=UDim.new(0,an.BodyGap or(an.Window.NewElements and 6 or 8)),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

local function EnsureActions()
if ao.UIElements.Actions then
return ao.UIElements.Actions
end

ao.UIElements.Actions=ai("Frame",{
Name="Actions",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
LayoutOrder=3,
Parent=ao.UIElements.Content,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Vertical",
HorizontalAlignment="Left",
SortOrder="LayoutOrder",
}),
})

return ao.UIElements.Actions
end

local function CreateActionButton(ay,az)
ay=ay or{}
local aA=GetCardColor(ay.Color,aq)
local aB=aa.NewRoundFrame(ay.Radius or 14,"Squircle",{
Name=ay.Name or"CardButton",
Size=UDim2.new(1,0,0,ay.Height or 44),
ImageColor3=aA or nil,
ImageTransparency=ay.Transparency or(aA and 0.18 or 0.9),
Parent=EnsureActions(),
ThemeTag=aA and nil or{
ImageColor3="ElementBackground",
},
},{
ai("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ai("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ak.CreateIcon(aa,ay.Icon or"arrow-right",an.Window.Folder,"Card",not aA,"CardButtonIcon"),
ai("TextLabel",{
Name="Title",
Size=UDim2.new(1,-34,1,0),
BackgroundTransparency=1,
Text=GetText(ay.Title or ay.Name,"Open"),
TextSize=ay.TextSize or 14,
TextTransparency=0.04,
TextXAlignment="Left",
TextTruncate="AtEnd",
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Text",
},
}),
},true)

local b=aB:FindFirstChildWhichIsA"Frame"or aB:FindFirstChildWhichIsA"ImageLabel"
local d=ak.GetImageTarget(b)
if d and aA then
d.ImageColor3=aA
d.ImageTransparency=0
end

af.AttachPress(aB,aa,{
Amount=0.975,
})
aa.AddSignal(aB.MouseButton1Click,function()
if az then
az()
end
if typeof(ay.Callback)=="function"then
aa.SafeCallback(ay.Callback,ao)
end
end)

return aB
end

local ay
local function CreateCardTab(az)
az=az or{}
local aA=az.Tab

if typeof(aA)~="table"and az.CreateTab~=false and an.Window and an.Window.Tab then
aA=an.Window:Tab{
Title=az.TabTitle or az.Title or ao.Title,
Desc=az.TabDesc or az.Desc,
Icon=az.TabIcon or az.Icon or ao.Icon or"panels-top-left",
ShowTabTitle=az.ShowTabTitle,
Golden=az.Golden,
Premium=az.Premium,
LinkCorners=az.LinkCorners,
Gap=az.Gap,
}

if typeof(az.Build)=="function"then
aa.SafeCallback(az.Build,aA,ao)
end
end

return{
Tab=aA,
Select=function()
if aA and aA.Select then
return aA:Select()
end
end,
}
end

function ao.CardButton(az,aA)
return CreateActionButton(aA)
end

function ao.CardTab(az,aA)
aA=aA or{}
local aB=CreateCardTab(aA)

local b=CreateActionButton({
Title=aA.Title or"Open Card Tab",
Icon=aA.Icon or"panels-top-left",
Color=aA.Color,
Callback=aA.Callback,
},function()
aB.Select()
end)

aB.Button=b
return aB
end

if ao.OpenTab then
local az=typeof(an.CardTab)=="table"and an.CardTab or{}
ay=CreateCardTab{
Tab=an.TabTarget or an.Page or az.Tab,
CreateTab=an.CreateTab~=false and az.CreateTab~=false,
Title=an.TabTitle or an.PageTitle or az.Title or ao.Title,
TabTitle=an.TabTitle or an.PageTitle or az.TabTitle or ao.Title,
TabDesc=an.TabDesc or an.PageDesc or az.TabDesc or ao.Desc,
Icon=an.TabIcon or an.PageIcon or az.Icon or ao.Icon,
TabIcon=an.TabIcon or an.PageIcon or az.TabIcon or ao.Icon,
ShowTabTitle=an.ShowTabTitle or az.ShowTabTitle,
Golden=an.Golden or az.Golden,
Premium=an.Premium or az.Premium,
LinkCorners=an.PageLinkCorners or az.LinkCorners,
Gap=an.PageGap or az.Gap,
Build=an.Build or az.Build,
}

ao.Page=ay.Tab
ao.PageController=ay
end

function ao.Open(az)
if ay then
return ay.Select()
end
if typeof(ao.Callback)=="function"then
return aa.SafeCallback(ao.Callback,ao)
end
end

function ao.GetPage(az)
return ay and ay.Tab
end

function ao.SetPage(az,aA)
ay={
Tab=aA,
Select=function()
if aA and aA.Select then
return aA:Select()
end
end,
}
ao.Page=aA
ao.PageController=ay
return{
Tab=aA,
Select=ay.Select,
}
end

if as then
af.AttachPress(ao.UIElements.Main,aa,{
Amount=0.985,
})
aa.AddSignal(ao.UIElements.Main.MouseButton1Click,function()
if ay then
ay.Select()
end
if typeof(ao.Callback)=="function"then
aa.SafeCallback(ao.Callback,ao)
end
end)
end

local az=an.ElementsModule
az.Load(
ao,
ao.UIElements.Body,
az.Elements,
an.Window,
an.WindUI,
nil,
az,
an.UIScale,
an.Tab
)

function ao.SetTitle(aA,aB)
ao.Title=tostring(aB or"")
ao.UIElements.Title.Text=ao.Title
end

function ao.SetDesc(aA,aB)
ao.Desc=aB
ao.UIElements.Desc.Text=tostring(aB or"")
ao.UIElements.Desc.Visible=aB~=nil
end

function ao.Highlight(aA)
af.Play(ao.UIElements.Background,"Highlight",{BackgroundTransparency=0.78},nil,nil,"CardHighlight")
task.delay(af.GetDuration"Highlight",function()
if ao.UIElements.Main.Parent then
af.Play(
ao.UIElements.Background,
"Highlight",
{
BackgroundTransparency=aa.ClampTransparency(
an.Transparency,
an.Window.LiquidGlass and 0.84 or 0.9
),
},
nil,
nil,
"CardHighlight"
)
end
end)
end

function ao.UpdateShape(aA)
local aB=an.Window.ElementConfig.LinkCorners
or ao.LinkCorners
or(an.ParentTable and an.ParentTable.LinkCorners==true)

local b={
TopLeft=true,
TopRight=true,
BottomLeft=true,
BottomRight=true,
}
local d="Squircle"

if aB and aA and aA.Elements then
local f=an.ParentConfig
and an.ParentConfig.ParentTable
and an.ParentConfig.ParentTable.__type
or an.ParentType
or(an.ParentTable and an.ParentTable.__type)
d,b=aa.GetLinkedCornerShape(
aA.Elements,
ao.Index,
aA,
f
)
end

if d and at then
local f=(d=="Squircle-TL-BL"or d=="Squircle-TR-BR")and"Squircle"
or d
at:SetType(f)
end

aa.ApplyCornerRadii(au,UDim.new(0,ap),b)
aa.ApplyCornerRadii(av,UDim.new(0,ap),b)
end

ao.UpdateShape(an.Tab or an.ParentTable)

function ao.Destroy(aA)
ao.UIElements.Main:Destroy()
end

return ao.__type,ao
end

return al end function a.au()

local aa=a.load'd'
local af=aa.New
local ai=aa.Tween

local ak={}

function ak.New(al,am)
local an={
__type="Section",
Title=am.Title or"Section",
Desc=am.Desc,
Icon=am.Icon,
IconThemed=am.IconThemed,
TextXAlignment=am.TextXAlignment or"Left",
TextSize=am.TextSize or 19,
DescTextSize=am.DescTextSize or 16,
Box=am.Box or false,
BoxBorder=am.BoxBorder or false,
FontWeight=am.FontWeight or Enum.FontWeight.SemiBold,
DescFontWeight=am.DescFontWeight or Enum.FontWeight.Medium,
TextTransparency=am.TextTransparency or 0.05,
DescTextTransparency=am.DescTextTransparency or 0.4,
Opened=am.Opened or false,
UIElements={},

HeaderSize=48,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local ao

function an.SetIcon(ap,aq)
an.Icon=aq or nil
if ao then
ao:Destroy()
end
if aq then
ao=aa.Image(
aq,
aq..":"..an.Title,
0,
am.Window.Folder,
an.__type,
true,
an.IconThemed,
"SectionIcon"
)
ao.Size=UDim2.new(0,an.IconSize,0,an.IconSize)
end
end

local ap=af("Frame",{
Size=UDim2.new(0,an.IconSize,0,an.IconSize),
BackgroundTransparency=1,
Visible=false,
},{
af("ImageLabel",{
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

if an.Icon then
an:SetIcon(an.Icon)
end

local aq=af("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
af("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=an.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4),
}),
})

local ar,as

local function createTitle(at,au)
return af("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=an.TextXAlignment,
AutomaticSize="Y",
TextSize=au=="Title"and an.TextSize or an.DescTextSize,
TextTransparency=au=="Title"and an.TextTransparency or an.DescTextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,au=="Title"and an.FontWeight or an.DescFontWeight),


Text=at,
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
Parent=aq,
})
end

ar=createTitle(an.Title,"Title")
if an.Desc then
as=createTitle(an.Desc,"Desc")
end

local function UpdateTitleSize()
local at=0
if ao then
at=at-(an.IconSize+8)
end
if ap.Visible then
at=at-(an.IconSize+8)
end
aq.Size=UDim2.new(1,at,0,0)
end

local at=aa.NewRoundFrame(am.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=am.Parent,

AutomaticSize="Y",
ThemeTag={
ImageTransparency=an.Box and"SectionBoxBackgroundTransparency"or nil,
ImageColor3="SectionBoxBackground",
},
ImageTransparency=not an.Box and 1 or nil,
},{
aa.NewRoundFrame(am.Window.ElementConfig.UICorner-1,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ThemeTag={

ImageColor3="SectionBoxBorder",
},
ImageTransparency=an.Box and an.BoxBorder and 0.92 or 1,
Name="Outline",
ClipsDescendants=true,
},{
af("TextButton",{
Size=UDim2.new(1,0,0,an.Expandable and 0 or(not as and an.HeaderSize or 0)),
BackgroundTransparency=1,
AutomaticSize=(not an.Expandable or as)and"Y"or nil,
Text="",
Name="Top",
},{
an.Box and af("UIPadding",{
PaddingTop=UDim.new(
0,
am.Window.ElementConfig.UIPadding+(am.Window.NewElements and 4 or 0)
),
PaddingLeft=UDim.new(
0,
am.Window.ElementConfig.UIPadding+(am.Window.NewElements and 4 or 0)
),
PaddingRight=UDim.new(
0,
am.Window.ElementConfig.UIPadding+(am.Window.NewElements and 4 or 0)
),
PaddingBottom=UDim.new(
0,
am.Window.ElementConfig.UIPadding+(am.Window.NewElements and 4 or 0)
),
})or nil,
ao,
aq,
af("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ap,
}),
af("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,an.HeaderSize+10),
},{
an.Box and af("UIPadding",{
PaddingLeft=UDim.new(0,am.Window.ElementConfig.UIPadding/1.5),
PaddingRight=UDim.new(0,am.Window.ElementConfig.UIPadding/1.5),
PaddingBottom=UDim.new(0,am.Window.ElementConfig.UIPadding/1.5),
})or nil,
af("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,am.Tab.Gap),
VerticalAlignment="Top",
}),
}),
}),
})





an.ElementFrame=at

at.Outline.Top:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
at.Outline.Content.Position=UDim2.new(0,0,0,(at.Outline.Top.AbsoluteSize.Y/am.UIScale)+10)

if an.Opened then
an:Open(true)
else
an.Close(true)
end
end)

local au=am.ElementsModule

au.Load(an,at.Outline.Content,au.Elements,am.Window,am.WindUI,function()
if not an.Expandable then
an.Expandable=true
ap.Visible=true
UpdateTitleSize()
end
end,au,am.UIScale,am.Tab)

UpdateTitleSize()

function an.SetTitle(av,aw)
an.Title=aw
ar.Text=aw
end

function an.SetDesc(av,aw)
an.Desc=aw
if not as then
as=createTitle(aw,"Desc")
end
as.Text=aw
end

function an.Destroy(av)
for aw,ax in next,an.Elements do
ax:Destroy()
end








at:Destroy()
end

function an.Open(av,aw)
if an.Expandable then
an.Opened=true
if aw then
at.Size=UDim2.new(
at.Size.X.Scale,
at.Size.X.Offset,
0,
at.Outline.Top.AbsoluteSize.Y/am.UIScale
+(at.Outline.Content.AbsoluteSize.Y/am.UIScale)
+10
)
ap.ImageLabel.Rotation=180
else
ai(at,0.33,{
Size=UDim2.new(
at.Size.X.Scale,
at.Size.X.Offset,
0,
at.Outline.Top.AbsoluteSize.Y/am.UIScale
+(at.Outline.Content.AbsoluteSize.Y/am.UIScale)
+10
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ai(
ap.ImageLabel,
0.2,
{Rotation=180},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end
function an.Close(av,aw)
if an.Expandable then
an.Opened=false
if aw then
at.Size=UDim2.new(
at.Size.X.Scale,
at.Size.X.Offset,
0,
(at.Outline.Top.AbsoluteSize.Y/am.UIScale)
)
ap.ImageLabel.Rotation=0
else
ai(at,0.26,{
Size=UDim2.new(
at.Size.X.Scale,
at.Size.X.Offset,
0,
(at.Outline.Top.AbsoluteSize.Y/am.UIScale)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ai(
ap.ImageLabel,
0.2,
{Rotation=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end

aa.AddSignal(at.Outline.Top.MouseButton1Click,function()
if an.Expandable then
if an.Opened then
an:Close()
else
an:Open()
end
end
end)

aa.AddSignal(at.Outline.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if an.Opened then
an:Open(true)
else
an:Close(true)
end
end)

task.defer(function()
if an.Expandable then








at.Size=
UDim2.new(at.Size.X.Scale,at.Size.X.Offset,0,at.Outline.Top.AbsoluteSize.Y/am.UIScale)
at.AutomaticSize="None"
at.Outline.Top.Size=UDim2.new(1,0,0,(not as and an.HeaderSize or 0))
at.Outline.Top.AutomaticSize=(not an.Expandable or as)and"Y"or"None"
at.Outline.Content.Visible=true
end
if an.Opened then
an:Open()
else
an:Close(true)
end
end)

return an.__type,an
end

return ak end function a.av()

local aa=a.load'd'
local af=aa.New

local ai={}

function ai.New(ak,al)
local am=af("Frame",{
Parent=al.Parent,
Size=not table.find({"Group","HStack"},al.ParentType)and UDim2.new(1,-7,0,7*(al.Columns or 1))or UDim2.new(0,7*(al.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=am}
end

return ai end function a.aw()
local aa=a.load'd'
local af=aa.New

local ai={}

local function ParseAspectRatio(ak)
if type(ak)=="string"then
local al,am=ak:match"(%d+):(%d+)"
if al and am then
return tonumber(al)/tonumber(am)
end
elseif type(ak)=="number"then
return ak
end
return nil
end

function ai.New(ak,al)
local am={
__type="Image",
Image=al.Image or"",
AspectRatio=al.AspectRatio or"16:9",
Radius=al.Radius or al.Window.ElementConfig.UICorner,
}
local an=aa.Image(
am.Image,
am.Image,
am.Radius,
al.Window.Folder,
"Image",
false
)
if an and an.Parent then
an.Parent=al.Parent
an.Size=UDim2.new(1,0,0,0)
an.BackgroundTransparency=1












local ao=ParseAspectRatio(am.AspectRatio)
local ap

if ao then
ap=af("UIAspectRatioConstraint",{
Parent=an,
AspectRatio=ao,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function am.Destroy(aq)
an:Destroy()
end
end

return am.__type,am
end

return ai end function a.ax()
local aa=a.load'd'
local af=aa.New

local ai={}

function ai.New(ak,al)
local am={
__type="Group",
Elements={},
ElementFrame=nil,
LinkCorners=al.LinkCorners==true,
}

local an=af("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=al.Parent,
},{
af("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,al.Tab and al.Tab.Gap or(al.Window.NewElements and 1 or 6))
}),
})

am.ElementFrame=an

local ao=al.ElementsModule
ao.Load(
am,
an,
ao.Elements,
al.Window,
al.WindUI,
function(ap,aq)
local ar=al.Tab and al.Tab.Gap or(al.Window.NewElements and 1 or 6)

local as={}
local at=0

for au,av in next,aq do
if av.__type=="Space"then
at=at+(av.ElementFrame.Size.X.Offset or 6)
elseif av.__type=="Divider"then
at=at+(av.ElementFrame.Size.X.Offset or 1)
else
table.insert(as,av)
end
end

local au=#as
if au==0 then return end

local av=1/au

local aw=ar*(au-1)

local ax=-(aw+at)

local ay=math.floor(ax/au)
local az=ax-(ay*au)

for aA,aB in next,as do
local b=ay
if aA<=math.abs(az)then
b=b-1
end

if aB.ElementFrame then
aB.ElementFrame.Size=UDim2.new(av,b,1,0)
end
end
end,
ao,
al.UIScale,
al.Tab
)



return am.__type,am
end

return ai end function a.ay()

local aa=a.load'd'
local af=aa.New

local ai={}

function ai.New(ak,al)
local am={
__type="HStack",
AutoSpace=al.AutoSpace or false,
Elements={},
ElementFrame=nil,
LinkCorners=al.LinkCorners==true,
MinChildWidth=math.max(tonumber(al.MinChildWidth)or 128,40),
IsStacked=false,
}

local an=af("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=al.Parent,
},{
af("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,al.Tab and al.Tab.Gap or(al.Window.NewElements and 1 or 6)),
}),
})

am.ElementFrame=an

local ao=al.ElementsModule
local function UpdateLayout(ap)
ap=ap or am.Elements
local aq=al.Tab and al.Tab.Gap or(al.Window.NewElements and 1 or 6)

local ar={}
local as=0
local at=an.AbsoluteSize.X/al.UIScale

for au,av in next,ap do
if av.__type=="Space"then
as=as+(av.ElementFrame.Size.X.Offset or 6)
elseif av.__type=="Divider"then
as=as+(av.ElementFrame.Size.X.Offset or 1)
else
table.insert(ar,av)
end
end

local au=#ar
if au==0 then
return
end

local av=aq*(au-1)
local aw=at-av-as
local ax=at>0 and aw/au<am.MinChildWidth
local ay=am.IsStacked~=ax
am.IsStacked=ax
local az=ax and 1 or(1/au)
local aA=ax and 0 or-(av+as)
local aB=math.floor(aA/au)
local b=aA-(aB*au)

an.UIListLayout.FillDirection=ax and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
an.UIListLayout.HorizontalAlignment=ax and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center

for d,f in next,ar do
local g=ax and 0 or aB
if not ax and d<=math.abs(b)then
g=g-1
end

if f.ElementFrame then
local h=f.ElementFrame.Size
f.ElementFrame.Size=UDim2.new(
az,
g,
h.Y.Scale==1 and 0 or h.Y.Scale,
h.Y.Scale==1 and 0 or h.Y.Offset
)
end
end

if ay and am.UpdateAllElementShapes then
am:UpdateAllElementShapes(am)
end
end

ao.Load(
am,
an,
ao.Elements,
al.Window,
al.WindUI,
function(ap,aq)
UpdateLayout(aq)
end,
ao,
al.UIScale,
al.Tab
)

aa.AddSignal(an:GetPropertyChangedSignal"AbsoluteSize",function()
UpdateLayout()
end)

if am.AutoSpace then
for ap in next,ao.Elements do
if ap~="Space"and ap~="Divider"then
local aq=am[ap]
am[ap]=function(ar,as)
if#am.Elements>0 then
am:Space()
end
return aq(ar,as)
end
end
end
end

return am.__type,am
end

return ai end function a.az()

local aa=a.load'd'
local af=aa.New

local ai={}

function ai.New(ak,al)
local am={
__type="VStack",
Elements={},
ElementFrame=nil,
LinkCorners=al.LinkCorners==true,
}

local an=af("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=al.Parent,
},{
af("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment="Center",

Padding=UDim.new(0,al.Tab and al.Tab.Gap or(al.Window.NewElements and 1 or 6))
}),
})

am.ElementFrame=an

local ao=al.ElementsModule
ao.Load(
am,
an,
ao.Elements,
al.Window,
al.WindUI,







































nil,
ao,
al.UIScale,
al.Tab
)



return am.__type,am
end

return ai end function a.aA()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local af=aa(game:GetService"UserInputService")

local ai=a.load'd'
local ak=ai.New

local al={}














function al.New(am,an:ConfigType__DARKLUA_TYPE_a)
local ao={
__type="Viewport",
Object=an.Object,
Camera=an.Camera or Instance.new"Camera",
Interactive=an.Interactive or false,
Height=an.Height or 200,
Focused=an.Focused~=false,
}

local ap=false
local aq=false
local ar,as=0

local at=ai.NewRoundFrame(an.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,ao.Height),
Parent=an.Parent,
ThemeTag={
ImageColor3="ViewportBackground",
ImageTransparency="ViewportBackgroundTransparency",
},
},{
ak("CanvasGroup",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,an.Window.ElementConfig.UICorner),
}),
ak("ViewportFrame",{
Name="Viewport",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
CurrentCamera=ao.Camera,
Active=ao.Interactive,
},{
ao.Object,
}),
}),
})

local function IsTouchInsideViewport(au)
local av=at.CanvasGroup.Viewport.AbsolutePosition
local aw=at.CanvasGroup.Viewport.AbsoluteSize

return au.X>=av.X
and au.X<=av.X+aw.X
and au.Y>=av.Y
and au.Y<=av.Y+aw.Y
end

local au=an.WindUI.GenerateGUID()

ai.AddSignal(at.CanvasGroup.Viewport.MouseEnter,function()
if ao.Interactive then
an.Tab.UIElements.ContainerFrame.ScrollingEnabled=false
end
end)

ai.AddSignal(at.CanvasGroup.Viewport.InputEnded,function(av)
if
av.UserInputType==Enum.UserInputType.MouseMovement
or av.UserInputType==Enum.UserInputType.Touch
then
an.Tab.UIElements.ContainerFrame.ScrollingEnabled=true
end
end)

ai.AddSignal(at.CanvasGroup.Viewport.InputBegan,function(av)
if ao.Interactive then
if
(av.UserInputType==Enum.UserInputType.MouseButton1)
or(av.UserInputType==Enum.UserInputType.Touch and not aq)
then
if an.WindUI.CurrentInput and an.WindUI.CurrentInput~=au then
return
end

an.WindUI.CurrentInput=au

ap=true
as=av.Position
end
end
end)

ai.AddSignal(af.InputEnded,function(av)
if ao.Interactive then
if
av.UserInputType==Enum.UserInputType.MouseButton1
or av.UserInputType==Enum.UserInputType.Touch
then
if an.WindUI.CurrentInput and an.WindUI.CurrentInput~=au then
return
end

an.WindUI.CurrentInput=nil

ap=false
end
end
end)

ai.AddSignal(af.InputChanged,function(av)
if ao.Interactive and ap and not aq then
if
av.UserInputType==Enum.UserInputType.MouseMovement
or av.UserInputType==Enum.UserInputType.Touch
then
local aw=av.Position-as
as=av.Position

local ax=ao.Object:GetPivot().Position
local ay=ao.Camera

local az=CFrame.fromAxisAngle(Vector3.new(0,1,0),-aw.X*0.02)
ay.CFrame=CFrame.new(ax)*az*CFrame.new(-ax)*ay.CFrame

local aA=CFrame.fromAxisAngle(ay.CFrame.RightVector,-aw.Y*0.02)
local aB=CFrame.new(ax)*aA*CFrame.new(-ax)*ay.CFrame

if aB.UpVector.Y>0.1 then
ay.CFrame=aB
end
end
end
end)

ai.AddSignal(at.CanvasGroup.Viewport.InputChanged,function(av)
if ao.Interactive then
if av.UserInputType==Enum.UserInputType.MouseWheel then
local aw=av.Position.Z*2
ao.Camera.CFrame+=ao.Camera.CFrame.LookVector*aw
end
end
end)

ai.AddSignal(af.TouchPinch,function(av,aw,ax,ay)
if not IsTouchInsideViewport(av[1])or not IsTouchInsideViewport(av[2])then
return
end
if ao.Interactive then
if ay==Enum.UserInputState.Begin then
aq=true
ap=false
ar=(av[1]-av[2]).Magnitude
elseif ay==Enum.UserInputState.Change then
if aq then
local az=(av[1]-av[2]).Magnitude
local aA=(az-ar)*0.03
ar=az
ao.Camera.CFrame+=ao.Camera.CFrame.LookVector*aA
end
elseif ay==Enum.UserInputState.End or ay==Enum.UserInputState.Cancel then
aq=false
end
end
end)

local function FocusCamera()
local av=ao.Object:IsA"BasePart"and ao.Object.Size
or select(2,ao.Object:GetBoundingBox(0))
local aw=math.max(av.X,av.Y,av.Z)
local ax=aw*2
local ay=ao.Object:GetPivot().Position

ao.Camera.CFrame=
CFrame.new(ay+Vector3.new(0,aw/2,ax),ay)
end

if ao.Focused then
FocusCamera()
end

function ao.SetObject(av,aw,ax)
if ax then
aw=aw:Clone()
end
if ao.Object then
ao.Object:Destroy()
end

ao.Object=aw
ao.Object.Parent=at.CanvasGroup.Viewport
end

function ao.SetHeight(av,aw)
at.Size=UDim2.new(1,0,0,aw)
end

function ao.Focus(av)
if ao.Object then
FocusCamera()
end
end

function ao.SetCamera(av,aw)
ao.Camera=aw
at.CanvasGroup.Viewport.CurrentCamera=aw
end

function ao.SetInteractive(av,aw)
ao.Interactive=aw
at.CanvasGroup.Viewport.Active=aw
end

ao.Main=at

return ao.__type,ao
end

return al end function a.aB()



local aa=a.load'd'
local af=aa.New

local ai={}

local function ParseAspectRatio(ak)
if type(ak)=="string"then
local al,am=ak:match"(%d+):(%d+)"
if al and am then
return tonumber(al)/tonumber(am)
end
elseif type(ak)=="number"then
return ak
end
return nil
end


function ai.New(ak,al)
local am={
__type="Video",
Video=al.Video or"",
AspectRatio=al.AspectRatio or"16:9",
Radius=al.Radius or al.Window.ElementConfig.UICorner,
ElementFrame=nil,
}

local an

if am.Video then
local ao
if string.find(am.Video,"http")then
local ap=al.Window.Folder or"Temp"
if makefolder and isfolder then
if not isfolder(ap)then
makefolder(ap)
end
if not isfolder(ap.."/assets")then
makefolder(ap.."/assets")
end
end
local aq=ap.."/assets/."..aa.SanitizeFilename(am.Video)..".webm"
if not isfile or not isfile(aq)then
local ar,as=pcall(function()
local ar=game.HttpGet and game:HttpGet(am.Video)or nil
if not ar and aa.Request then
local as=aa.Request{
Url=am.Video,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"},
}
ar=as and as.Body
end
if ar and writefile then
writefile(aq,ar)
end
end)
if not ar then
warn("[ Window.Background ] Failed to download video: "..tostring(as))
return
end
end

local ar,as=pcall(function()
return typeof(getcustomasset)=="function"and getcustomasset(aq)or aq
end)
if not ar then
warn("[ WindUI.Video ] Failed to load custom asset: "..tostring(as))
end
ao=as
else
ao=am.Video
end

an=af("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ao,
Looped=false,
Volume=0,
Parent=al.Parent
},{
af("UICorner",{
CornerRadius=UDim.new(0,am.Radius)
}),
})
am.ElementFrame=an
an:Play()


local ap=ParseAspectRatio(am.AspectRatio)
local aq

if ap then
aq=af("UIAspectRatioConstraint",{
Parent=an,
AspectRatio=ap,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end
end


function am.Destroy(ao)
if an then an:Destroy()end
end

return am.__type,am
end

return ai end function a.aC()

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
Load=function(aa,af,ai,ak,al,am,an,ao,ap)
for aq,ar in next,ai do
aa[aq]=function(as,at)
at=at or{}
at.Tab=ap or aa
at.ParentType=aa.__type
at.ParentTable=aa
at.Index=#aa.Elements+1
at.GlobalIndex=#ak.AllElements+1
if at.LinkCorners==nil then
at.LinkCorners=aa.LinkCorners==true or(ap and ap.LinkCorners==true)
end
at.Parent=af
at.Window=ak
at.WindUI=al
at.UIScale=ao
at.ElementsModule=an local

au, av=ar:New(at)

if at.Flag and typeof(at.Flag)=="string"then
if ak.CurrentConfig then
ak.CurrentConfig:Register(at.Flag,av)

if ak.PendingConfigData and ak.PendingConfigData[at.Flag]then
local aw=ak.PendingConfigData[at.Flag]

local ax=ak.ConfigManager
if typeof(aw)=="table"and ax.Parser[aw.__type]then
task.defer(function()
local ay,az=pcall(function()
ax.Parser[aw.__type].Load(av,aw)
end)

if ay then
ak.PendingConfigData[at.Flag]=nil
else
warn(
"[ WindUI ] Failed to apply pending config for '"
..at.Flag
.."': "
..tostring(az)
)
end
end)
end
end
else
ak.PendingFlags=ak.PendingFlags or{}
ak.PendingFlags[at.Flag]=av
end
end

local aw
for ax,ay in next,av do
if typeof(ay)=="table"and ax~="ElementFrame"and ax:match"Frame$"then
aw=ay
break
end
end

if aw then
av.ElementFrame=aw.UIElements.Main
function av.SetTitle(ax,ay)
return aw.SetTitle and aw:SetTitle(ay)
end
function av.SetDesc(ax,ay)
return aw.SetDesc and aw:SetDesc(ay)
end
function av.SetImage(ax,ay,az)
return aw.SetImage and aw:SetImage(ay,az)
end
function av.SetThumbnail(ax,ay,az)
return aw.SetThumbnail and aw:SetThumbnail(ay,az)
end
function av.SetTransparency(ax,ay)
return aw.SetTransparency and aw:SetTransparency(ay)
end
function av.SetLiquidGlass(ax,ay)
return aw.SetLiquidGlass and aw:SetLiquidGlass(ay)
end
function av.Highlight(ax)
aw:Highlight()
end
function av.Destroy(ax)
aw:Destroy()

table.remove(ak.AllElements,at.GlobalIndex)
table.remove(aa.Elements,at.Index)
table.remove(ap.Elements,at.Index)
aa:UpdateAllElementShapes(aa)
end
end

ak.AllElements[at.GlobalIndex]=av
aa.Elements[at.Index]=av
if ap then
ap.Elements[at.Index]=av
end

if ak.NewElements then
aa:UpdateAllElementShapes(aa)
end

if am then
am(av,aa.Elements)
end
return av
end
end
function aa.UpdateAllElementShapes(aq,ar)
for as,at in next,ar.Elements do
local au
for av,aw in pairs(at)do
if typeof(aw)=="table"and av:match"Frame$"then
au=aw
break
end
end

if not au and at.UpdateShape then
au=at
end

if au then

au.Index=as
if au.UpdateShape then

au.UpdateShape(ar)
end
end
end
end
end,
}end function a.aD()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local af=game:GetService"Players"
local ai=game:GetService"TweenService"

aa(game:GetService"UserInputService")
local ak=af.LocalPlayer:GetMouse()

local al=a.load'd'
local am=a.load'e'
local an=al.New

local ao=a.load'G'.New
local ap=a.load'z'.New



local aq={


Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(aq)end,
}

local function GetImageTarget(ar)
if typeof(ar)~="Instance"then
return nil
end

if ar:IsA"ImageLabel"or ar:IsA"ImageButton"then
return ar
end

return ar:FindFirstChildWhichIsA("ImageLabel",true)or ar:FindFirstChildWhichIsA("ImageButton",true)
end

function aq.Init(ar,as,at,au)
Window=ar
WindUI=as
aq.ToolTipParent=at
aq.TabHighlight=au
return aq
end

function aq.New(ar,as)
local at={
__type="Tab",
Title=ar.Title or"Tab",
Desc=ar.Desc,
Icon=ar.Icon,
Golden=ar.Golden==true or ar.Premium==true,
Premium=ar.Premium==true or ar.Golden==true,
IconColor=ar.IconColor
or((ar.Golden==true or ar.Premium==true)and Color3.fromRGB(255,222,105)or nil),
IconShape=ar.IconShape,
IconThemed=ar.IconThemed,
Locked=ar.Locked,
ShowTabTitle=ar.ShowTabTitle,
TabTitleAlign=ar.TabTitleAlign or"Left",
CustomEmptyPage=(ar.CustomEmptyPage and next(ar.CustomEmptyPage)~=nil)and ar.CustomEmptyPage
or{Icon="lucide:frown",IconSize=48,Title="This tab is Empty",Desc=nil},
Border=ar.Border,
Selected=false,
Index=nil,
Parent=ar.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),
LinkCorners=ar.LinkCorners==true,

Gap=ar.Gap or ar.ElementGap or Window.ElementGap or(Window.NewElements and(Window.LiquidGlass and 6 or 1)or 6),

TabPaddingX=4+(Window.UIPadding/2),
TabPaddingY=3+(Window.UIPadding/2),
TitlePaddingY=0,
}









if at.IconShape then
at.TabPaddingX=2+(Window.UIPadding/4)
at.TabPaddingY=2+(Window.UIPadding/4)
at.TitlePaddingY=2+(Window.UIPadding/4)
end

aq.TabCount=aq.TabCount+1

local au=aq.TabCount
at.Index=au

at.UIElements.Main=al.NewRoundFrame(at.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=ar.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
al.NewRoundFrame(at.UICorner-1,"Glass-1.4",{
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
al.NewRoundFrame(999,"Squircle",{
Name="ActiveRail",
Size=UDim2.new(0,3,0,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,2,0.5,0),
ImageTransparency=1,
ThemeTag={
ImageColor3="Primary",
},
}),
al.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
an("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,2+(Window.UIPadding/2)),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
an("TextLabel",{
Text=at.Title,
ThemeTag=not at.Golden and{
TextColor3="TabTitle",
}or nil,
TextColor3=at.Golden and Color3.fromRGB(255,232,144)or nil,
TextTransparency=not at.Locked and(at.Golden and 0.12 or 0.4)or 0.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(al.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
},{
an("UIPadding",{
PaddingTop=UDim.new(0,at.TitlePaddingY),


PaddingBottom=UDim.new(0,at.TitlePaddingY),
}),
}),
an("UIPadding",{
PaddingTop=UDim.new(0,at.TabPaddingY),
PaddingLeft=UDim.new(0,at.TabPaddingX),
PaddingRight=UDim.new(0,at.TabPaddingX),
PaddingBottom=UDim.new(0,at.TabPaddingY),
}),
}),
},true)

if at.Golden then
at.UIElements.Main.Frame.ImageColor3=Color3.fromRGB(64,49,18)
at.UIElements.Main.Frame.ImageTransparency=0.88
at.UIElements.Main.Outline.ImageColor3=Color3.fromRGB(255,214,92)
at.UIElements.Main.Outline.ImageTransparency=0.78
at.UIElements.GoldenShine=an("UIGradient",{
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
Parent=at.UIElements.Main.Frame,
})

if am:IsEnabled()and not am.Reduced then
task.spawn(function()
while at.UIElements.Main and at.UIElements.Main.Parent and at.UIElements.GoldenShine do
at.UIElements.GoldenShine.Offset=Vector2.new(-1,0)
local av=ai:Create(
at.UIElements.GoldenShine,
TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
{Offset=Vector2.new(1,0)}
)
av:Play()
av.Completed:Wait()
task.wait(1.1)
end
end)
end
end

local av=0
local aw
local ax

if at.Icon then
aw=al.Image(
at.Icon,
at.Icon..":"..at.Title,
0,
Window.Folder,
at.__type,
at.IconColor and false or true,
at.IconThemed,
"TabIcon"
)
aw.Size=UDim2.new(0,16,0,16)
local ay=GetImageTarget(aw)
if at.IconColor and ay then
ay.ImageColor3=at.IconColor
end
if not at.IconShape then
aw.Parent=at.UIElements.Main.Frame
at.UIElements.Icon=aw
if ay then
ay.ImageTransparency=not at.Locked and 0 or 0.7
end
av=-18-(Window.UIPadding/2)
at.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,av,0,0)
elseif at.IconColor then
al.NewRoundFrame(
at.IconShape~="Circle"and(at.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Squircle",
{
Size=UDim2.new(0,26,0,26),
ImageColor3=at.IconColor,
Parent=at.UIElements.Main.Frame,
},
{
aw,
al.NewRoundFrame(
at.IconShape~="Circle"and(at.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
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
aw.AnchorPoint=Vector2.new(0.5,0.5)
aw.Position=UDim2.new(0.5,0,0.5,0)
if ay then
ay.ImageTransparency=0
ay.ImageColor3=al.GetTextColorForHSB(at.IconColor,0.68)
end
av=-28-(Window.UIPadding/2)
at.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,av,0,0)
end

ax=
al.Image(at.Icon,at.Icon..":"..at.Title,0,Window.Folder,at.__type,true,at.IconThemed)
ax.Size=UDim2.new(0,16,0,16)
local az=GetImageTarget(ax)
if az then
az.ImageTransparency=not at.Locked and 0 or 0.7
end
av=-30




end

at.UIElements.ContainerFrame=an("ScrollingFrame",{
Size=UDim2.new(1,0,1,at.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",

ScrollingDirection="Y",
},{
an("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
an("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,at.Gap),
HorizontalAlignment="Center",
}),
})





at.UIElements.ContainerFrameCanvas=an("CanvasGroup",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
GroupTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
at.UIElements.ContainerFrame,
an("Frame",{
Size=UDim2.new(1,-14,1,-14),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Name="ScrollSliderHolder",
}),
an("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=at.ShowTabTitle or false,
Name="TabTitle",
},{
ax,
an("TextLabel",{
Text=at.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=20,
TextTransparency=0.1,
Size=UDim2.new(0,0,1,0),
FontFace=Font.new(al.Font,Enum.FontWeight.SemiBold),

RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
AutomaticSize="X",
}),
an("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
an("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=at.TabTitleAlign,
}),
}),
an("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=at.ShowTabTitle or false,
}),
})

aq.Containers[au]=at.UIElements.ContainerFrameCanvas
aq.Tabs[au]=at

at.ContainerFrame=at.UIElements.ContainerFrameCanvas

al.AddSignal(at.UIElements.Main.MouseButton1Click,function()
if not at.Locked then
aq:SelectTab(au)
end
end)

am.AttachPress(at.UIElements.Main,al,{
Amount=0.985,
})

if Window.ScrollBarEnabled then
ap(
at.UIElements.ContainerFrame,
at.UIElements.ContainerFrameCanvas.ScrollSliderHolder,
Window,
4,
WindUI
)
end

local ay
local az
local aA
local aB=false


if at.Desc then
al.AddSignal(at.UIElements.Main.InputBegan,function()
aB=true
az=task.spawn(function()
task.wait(0.35)
if aB and not ay then
ay=ao(at.Desc,aq.ToolTipParent,true)
ay.Container.AnchorPoint=Vector2.new(0.5,0.5)

local function updatePosition()
if ay then
ay.Container.Position=UDim2.new(0,ak.X,0,ak.Y-4)
end
end

updatePosition()
aA=ak.Move:Connect(updatePosition)
ay:Open()
end
end)
end)
end

al.AddSignal(at.UIElements.Main.MouseEnter,function()
if not at.Locked and not at.Selected then
al.SetThemeTag(at.UIElements.Main.Frame,{
ImageTransparency="TabBackgroundHoverTransparency",
ImageColor3="TabBackgroundHover",
},0.1)
end
end)
al.AddSignal(at.UIElements.Main.MouseLeave,function()
if not at.Locked and not at.Selected then
am.Play(at.UIElements.Main.Frame,"Hover",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabHover")
end
end)
al.AddSignal(at.UIElements.Main.InputEnded,function()
if at.Desc then
aB=false
if az then
task.cancel(az)
az=nil
end
if aA then
aA:Disconnect()
aA=nil
end
if ay then
ay:Close()
ay=nil
end
end

if not at.Locked and not at.Selected then
am.Play(at.UIElements.Main.Frame,"Hover",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabHover")
end
end)

function at.ScrollToTheElement(b,d)
at.UIElements.ContainerFrame.ScrollingEnabled=false

am.Play(at.UIElements.ContainerFrame,"Resize",{
CanvasPosition=Vector2.new(
0,
at.Elements[d].ElementFrame.AbsolutePosition.Y
-at.UIElements.ContainerFrame.AbsolutePosition.Y
-at.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"ScrollToElement")

task.spawn(function()
task.wait(am.GetDuration"Resize"+0.03)

if at.Elements[d].Highlight then
at.Elements[d]:Highlight()
end
at.UIElements.ContainerFrame.ScrollingEnabled=true
end)

return at
end



local b=a.load'aC'

b.Load(
at,
at.UIElements.ContainerFrame,
b.Elements,
Window,
WindUI,
nil,
b,
as,
at
)

function at.LockAll(d)

for f,g in next,Window.AllElements do
if g.Tab and g.Tab.Index and g.Tab.Index==at.Index and g.Lock then
g:Lock()
end
end
end
function at.UnlockAll(d)
for f,g in next,Window.AllElements do
if g.Tab and g.Tab.Index and g.Tab.Index==at.Index and g.Unlock then
g:Unlock()
end
end
end
function at.GetLocked(d)
local f={}

for g,h in next,Window.AllElements do
if h.Tab and h.Tab.Index and h.Tab.Index==at.Index and h.Locked==true then
table.insert(f,h)
end
end

return f
end
function at.GetUnlocked(d)
local f={}

for g,h in next,Window.AllElements do
if h.Tab and h.Tab.Index and h.Tab.Index==at.Index and h.Locked==false then
table.insert(f,h)
end
end

return f
end

function at.Select(d)
return aq:SelectTab(at.Index)
end

task.spawn(function()
local d
if at.CustomEmptyPage.Icon then
d=
al.Image(at.CustomEmptyPage.Icon,at.CustomEmptyPage.Icon,0,"Temp","EmptyPage",true)
d.Size=
UDim2.fromOffset(at.CustomEmptyPage.IconSize or 48,at.CustomEmptyPage.IconSize or 48)
end

local f=an("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=at.UIElements.ContainerFrame,
},{
an("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),











d,
at.CustomEmptyPage.Title and an("TextLabel",{
AutomaticSize="XY",
Text=at.CustomEmptyPage.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
TextTransparency=0.5,
BackgroundTransparency=1,
FontFace=Font.new(al.Font,Enum.FontWeight.Medium),
})or nil,
at.CustomEmptyPage.Desc and an("TextLabel",{
AutomaticSize="XY",
Text=at.CustomEmptyPage.Desc,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.65,
BackgroundTransparency=1,
FontFace=Font.new(al.Font,Enum.FontWeight.Regular),
})or nil,
})





local g
g=al.AddSignal(at.UIElements.ContainerFrame.ChildAdded,function()
f.Visible=false
g:Disconnect()
end)
end)

return at
end

function aq.OnChange(ar,as)
aq.OnChangeFunc=as
end

local function ApplyGoldenTabVisual(ar,as)
if not ar or not ar.Golden then
return
end

local at=ar.UIElements
and ar.UIElements.Main
and ar.UIElements.Main.Frame
and ar.UIElements.Main.Frame.TextLabel
if at then
at.TextColor3=as and Color3.fromRGB(255,244,184)or Color3.fromRGB(255,224,120)
at.TextTransparency=as and 0 or 0.12
end

local au=ar.UIElements and ar.UIElements.Icon and GetImageTarget(ar.UIElements.Icon)
if au then
au.ImageColor3=ar.IconColor or Color3.fromRGB(255,222,105)
au.ImageTransparency=as and 0 or 0.08
end

local av=ar.UIElements and ar.UIElements.Main and ar.UIElements.Main.Outline
if av then
av.ImageColor3=as and Color3.fromRGB(255,232,132)or Color3.fromRGB(255,214,92)
av.ImageTransparency=as and 0.58 or 0.78
end
end

local function ApplyTabMotionVisual(ar,as)
if not ar or not ar.UIElements or not ar.UIElements.Main then
return
end

local at=ar.UIElements.Main.ActiveRail
if at then
if ar.Golden then
at.ImageColor3=as and Color3.fromRGB(255,232,132)or Color3.fromRGB(255,214,92)
end

am.Play(at,"Switch",{
Size=as and UDim2.new(0,3,1,-12)or UDim2.new(0,3,0,0),
ImageTransparency=as and 0.08 or 1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabRail")
end

if not as and ar.UIElements.Main.Frame then
am.Play(ar.UIElements.Main.Frame,"Hover",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"TabHover")
end
end

function aq.SelectTab(ar,as)
local at=aq.Tabs[as]
if at and not at.Locked and aq.SelectedTab~=as then
aq.SelectedTab=as

for au,av in next,aq.Tabs do
if not av.Locked then
al.SetThemeTag(av.UIElements.Main,{
ImageTransparency="TabBorderTransparency",
},0.15)
if av.Border then
al.SetThemeTag(av.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparency",
},0.15)
end
al.SetThemeTag(av.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparency",
},0.15)
local aw=av.UIElements.Icon and GetImageTarget(av.UIElements.Icon)
if aw and not av.IconColor then
al.SetThemeTag(aw,{
ImageTransparency="TabIconTransparency",
},0.15)
end
av.Selected=false
ApplyGoldenTabVisual(av,false)
ApplyTabMotionVisual(av,false)
end
end
al.SetThemeTag(at.UIElements.Main,{
ImageColor3="TabBackgroundActive",
ImageTransparency="TabBackgroundActiveTransparency",
},0.15)
if at.Border then
al.SetThemeTag(at.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparencyActive",
},0.15)
end
al.SetThemeTag(at.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparencyActive",
},0.15)
local au=at.UIElements.Icon and GetImageTarget(at.UIElements.Icon)
if au and not at.IconColor then
al.SetThemeTag(au,{
ImageTransparency="TabIconTransparencyActive",
},0.15)
end
at.Selected=true
ApplyGoldenTabVisual(at,true)
ApplyTabMotionVisual(at,true)

task.spawn(function()
local av=aq.Containers[as]
for aw,ax in next,aq.Containers do
if ax~=av then
ax.AnchorPoint=Vector2.new(0,0.035)
ax.GroupTransparency=1
ax.Visible=false
end
end
av.AnchorPoint=Vector2.new(0,0.035)
av.GroupTransparency=1
av.Visible=true
am.Play(av,"Switch",{
AnchorPoint=Vector2.new(0,0),
GroupTransparency=0,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out,"Select")
end)

aq.OnChangeFunc(as)
end
end

return aq end function a.aE()

local aa={}


local af=a.load'd'
local ai=af.New
local ak=af.Tween

local al=a.load'aD'

function aa.New(am,an,ao,ap,aq)
local ar={
Title=am.Title or"Section",
Icon=am.Icon,
IconThemed=am.IconThemed,
Opened=am.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local as
if ar.Icon then
as=af.Image(
ar.Icon,
ar.Icon,
0,
ao,
"Section",
true,
ar.IconThemed,
"TabSectionIcon"
)

as.Size=UDim2.new(0,ar.IconSize,0,ar.IconSize)
as.ImageLabel.ImageTransparency=.25
end

local at=ai("Frame",{
Size=UDim2.new(0,ar.IconSize,0,ar.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ai("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=af.Icon"chevron-down"[1],
ImageRectSize=af.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=af.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local au=ai("Frame",{
Size=UDim2.new(1,0,0,ar.HeaderSize),
BackgroundTransparency=1,
Parent=an,
ClipsDescendants=true,
},{
ai("TextButton",{
Size=UDim2.new(1,0,0,ar.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
as,
ai("TextLabel",{
Text=ar.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
as and(-ar.IconSize-10)*2
or(-ar.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(af.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
ai("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
at,
ai("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
ai("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ar.HeaderSize)
},{
ai("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,aq.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ar.Tab(av,aw)
if not ar.Expandable then
ar.Expandable=true
at.Visible=true
end
aw.Parent=au.Content
return al.New(aw,ap)
end

function ar.Open(av)
if ar.Expandable then
ar.Opened=true
ak(au,0.33,{
Size=UDim2.new(1,0,0,ar.HeaderSize+(au.Content.AbsoluteSize.Y/ap))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ak(at.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ar.Close(av)
if ar.Expandable then
ar.Opened=false
ak(au,0.26,{
Size=UDim2.new(1,0,0,ar.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ak(at.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

af.AddSignal(au.TextButton.MouseButton1Click,function()
if ar.Expandable then
if ar.Opened then
ar:Close()
else
ar:Open()
end
end
end)

af.AddSignal(au.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ar.Opened then
ar:Open()
end
end)

if ar.Opened then
task.spawn(function()
task.wait()
ar:Open()
end)
end



return ar
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

local af={
Margin=8,
Padding=9,
}

local ai=a.load'd'
local ak=ai.New
local al=ai.Tween

function af.new(am,an,ao)
local ap={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'aF',
}

local aq=ak("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(1,-((ap.IconSize*2)+(ap.Padding*2)),0,0),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ar=ak("ImageLabel",{
Image=ai.Icon"x"[1],
ImageRectSize=ai.Icon"x"[2].ImageRectSize,
ImageRectOffset=ai.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,ap.IconSize,0,ap.IconSize),
},{
ak("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
}),
})

local as=ak("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false,
},{
ak("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,ap.Padding),
PaddingLeft=UDim.new(0,ap.Padding),
PaddingRight=UDim.new(0,ap.Padding),
PaddingBottom=UDim.new(0,ap.Padding),
}),
})

local at=ai.NewRoundFrame(ap.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="WindowSearchBarBackground",
},
ImageTransparency=0,
},{
ai.NewRoundFrame(ap.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Frame",
},{
ak("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ak("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ak("ImageLabel",{
Image=ai.Icon"search"[1],
ImageRectSize=ai.Icon"search"[2].ImageRectSize,
ImageRectOffset=ai.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,ap.IconSize,0,ap.IconSize),
}),
aq,
ar,
ak("UIListLayout",{
Padding=UDim.new(0,ap.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ak("UIPadding",{
PaddingLeft=UDim.new(0,ap.Padding),
PaddingRight=UDim.new(0,ap.Padding),
}),
}),
}),
ak("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ak("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.9,
Visible=false,
}),
as,
ak("UISizeConstraint",{
MaxSize=Vector2.new(ap.Width,ap.MaxHeight),
}),
}),
ak("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
})

local au=ak("Frame",{
Size=UDim2.new(0,ap.Width,0,0),
AutomaticSize="Y",
Parent=an,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ak("UIScale",{
Scale=0.9,
}),
at,















})

local function CreateSearchTab(av,aw,ax,ay,az,aA)
local aB=ak("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ay or nil,
},{
ai.NewRoundFrame(ap.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main",
},{
ai.NewRoundFrame(ap.Radius-11,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Outline",
},{








ak("UIPadding",{
PaddingTop=UDim.new(0,ap.Padding-2),
PaddingLeft=UDim.new(0,ap.Padding),
PaddingRight=UDim.new(0,ap.Padding),
PaddingBottom=UDim.new(0,ap.Padding-2),
}),
ak("ImageLabel",{
Image=ai.Icon(ax)[1],
ImageRectSize=ai.Icon(ax)[2].ImageRectSize,
ImageRectOffset=ai.Icon(ax)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,ap.IconSize,0,ap.IconSize),
}),
ak("Frame",{
Size=UDim2.new(1,-ap.IconSize-ap.Padding,0,0),
BackgroundTransparency=1,
},{
ak("TextLabel",{
Text=av,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title",
}),
ak("TextLabel",{
Text=aw or"",
Visible=aw and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc",
})or nil,
ak("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
}),
}),
ak("UIListLayout",{
Padding=UDim.new(0,ap.Padding),
FillDirection="Horizontal",
}),
}),
},true),
ak("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-ap.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=az,

},{
ai.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
}),
ak("Frame",{
Size=UDim2.new(1,-ap.Padding-2,0,0),
Position=UDim2.new(0,ap.Padding+2,0,0),
BackgroundTransparency=1,
},{
ak("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ak("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right",
}),
})



aB.Main.Size=UDim2.new(
1,
0,
0,
aB.Main.Outline.Frame.Desc.Visible
and(((ap.Padding-2)*2)+aB.Main.Outline.Frame.Title.TextBounds.Y+6+aB.Main.Outline.Frame.Desc.TextBounds.Y)
or(((ap.Padding-2)*2)+aB.Main.Outline.Frame.Title.TextBounds.Y)
)

ai.AddSignal(aB.Main.MouseEnter,function()
al(aB.Main,0.04,{ImageTransparency=0.95}):Play()

end)
ai.AddSignal(aB.Main.InputEnded,function()
al(aB.Main,0.08,{ImageTransparency=1}):Play()

end)
ai.AddSignal(aB.Main.MouseButton1Click,function()
if aA then
aA()
end
end)

return aB
end

local function ContainsText(av,aw)
if not aw or aw==""then
return false
end

if not av or av==""then
return false
end

local ax=string.lower(av)
local ay=string.lower(aw)

return string.find(ax,ay,1,true)~=nil
end

local function Search(av)
if not av or av==""then
return{}
end

local aw={}
for ax,ay in next,am.Tabs do
local az=ContainsText(ay.Title or"",av)
local aA={}

for aB,b in next,ay.Elements do
if b.__type~="Section"then
local d=ContainsText(b.Title or"",av)
local f=ContainsText(b.Desc or"",av)

if d or f then
aA[aB]={
Title=b.Title,
Desc=b.Desc,
Original=b,
__type=b.__type,
Index=aB,
}
end
end
end

if az or next(aA)~=nil then
aw[ax]={
Tab=ay,
Title=ay.Title,
Icon=ay.Icon,
Elements=aA,
}
end
end
return aw
end

ai.AddSignal(as.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

al(as,0.06,{
Size=UDim2.new(
1,
0,
0,
math.clamp(
as.UIListLayout.AbsoluteContentSize.Y+(ap.Padding*2),
0,
ap.MaxHeight
)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function ap.Open(av)
task.spawn(function()
at.Frame.Visible=true
au.Visible=true
al(au.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function ap.Close(av,aw)
task.spawn(function()
ao()
at.Frame.Visible=false
al(au.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(0.12)
au.Visible=false
if aw then
au:Destroy()
end
end)
end

ai.AddSignal(ar.TextButton.MouseButton1Click,function()
ap:Close(true)
end)

ap:Open()

function ap.Search(av,aw)
aw=aw or""

local ax=Search(aw)

as.Visible=true
at.Frame.Results.Frame.Visible=true
for ay,az in next,as:GetChildren()do
if az.ClassName~="UIListLayout"and az.ClassName~="UIPadding"then
az:Destroy()
end
end

if ax and next(ax)~=nil then
for ay,az in next,ax do
local aA=ap.Icons.Tab
local aB=CreateSearchTab(az.Title,nil,aA,as,true,function()
ap:Close()
am:SelectTab(ay)
end)
if az.Elements and next(az.Elements)~=nil then
for b,d in next,az.Elements do
local f=ap.Icons[d.__type]
CreateSearchTab(
d.Title,
d.Desc,
f,
aB:FindFirstChild"ParentContainer"and aB.ParentContainer.Frame
or nil,
false,
function()
ap:Close()
am:SelectTab(ay)
if az.Tab.ScrollToTheElement then

az.Tab:ScrollToTheElement(d.Index)
end

end
)

end
end
end
elseif aw~=""then
ak("TextLabel",{
Size=UDim2.new(1,0,0,70),
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.2,
BackgroundTransparency=1,
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
Parent=as,
Name="NotFound",
})
else
as.Visible=false
at.Frame.Results.Frame.Visible=false
end
end

ai.AddSignal(aq:GetPropertyChangedSignal"Text",function()
ap:Search(aq.Text)
end)

return ap
end

return af end function a.aH()



local aa=(cloneref or clonereference or function(aa)
return aa
end)

local af=aa(game:GetService"UserInputService")
local ai=aa(game:GetService"RunService")
local ak=aa(game:GetService"Players")

local al=workspace.CurrentCamera

local am=a.load'v'

local an=a.load'd'
local ao=a.load'e'
local ap=an.New
local aq=an.Tween


local ar=a.load'y'.New
local as=a.load'n'.New
local at=a.load'z'.New
local au=a.load'A'

local av=a.load'B'



return function(aw)
local ax=aw.Default==true or aw.Preset=="Default"or aw.Preset=="Obsidian"
local function Pick(ay,az)
if ay~=nil then
return ay
end
return az
end
local function PickAlias(ay,az,aA)
if ay~=nil then
return ay
end
if az~=nil then
return az
end
return aA
end

if ax then
aw.NewElements=Pick(aw.NewElements,true)
aw.LiquidGlass=PickAlias(aw.LiquidGlass,aw.GlassLiquid,true)
aw.HideSearchBar=Pick(aw.HideSearchBar,false)
aw.LinkElementCorners=PickAlias(aw.LinkElementCorners,aw.ElementsLinkCorners,true)
aw.ElementGap=PickAlias(aw.ElementGap,aw.ElementsGap,8)
aw.ElementTransparency=PickAlias(aw.ElementTransparency,aw.ElementsTransparency,0.18)
aw.BackgroundOverlayTransparency=Pick(aw.BackgroundOverlayTransparency,0.5)
aw.BackgroundColor=Pick(aw.BackgroundColor,Color3.fromHex"#101821")
aw.Radius=Pick(aw.Radius,20)
aw.SideBarWidth=Pick(aw.SideBarWidth,210)
aw.Topbar=aw.Topbar or{
Height=48,
ButtonsType="Mac",
}
end

local ay={
Title=aw.Title or"UI Library",
Author=aw.Author,
Icon=aw.Icon,
IconSize=aw.IconSize or 22,
IconThemed=aw.IconThemed,
IconRadius=aw.IconRadius or 0,
Folder=aw.Folder,
Resizable=aw.Resizable~=false,
Background=aw.Background or aw.BackgroundImage,
BackgroundColor=aw.BackgroundColor,
BackgroundGradient=aw.BackgroundGradient,
BackgroundImageTransparency=aw.BackgroundImageTransparency or 0,
BackgroundOverlayTransparency=aw.BackgroundOverlayTransparency or 0.62,
BackgroundScaleType=aw.BackgroundScaleType or"Crop",
ShadowTransparency=aw.ShadowTransparency or 0.6,
User=aw.User or{},
Footer=aw.Footer or{},
Topbar=aw.Topbar or{Height=52,ButtonsType="Default"},

Size=aw.Size,

MinSize=aw.MinSize or Vector2.new(560,350),
MaxSize=aw.MaxSize or Vector2.new(850,560),

TopBarButtonIconSize=aw.TopBarButtonIconSize,

ToggleKey=aw.ToggleKey,
ElementsRadius=aw.ElementsRadius,
Radius=aw.Radius or 16,
Transparent=aw.Transparent or false,
ElementTransparency=aw.ElementTransparency or aw.ElementsTransparency,
ElementGlassTransparency=aw.ElementGlassTransparency or aw.GlassTransparency,
LiquidGlass=aw.LiquidGlass or aw.GlassLiquid or aw.ElementGlass or false,
ElementCornerStyle=aw.ElementCornerStyle or aw.ElementsCornerStyle or aw.CornerStyle,
ElementGap=aw.ElementGap or aw.ElementsGap,
LinkElementCorners=aw.LinkElementCorners==true or aw.ElementsLinkCorners==true,
Watermark=aw.Watermark~=nil and aw.Watermark or aw.WaterMark,
KeyBindMenu=aw.KeyBindMenu==false and false or(aw.KeyBindMenu or{}),
HideSearchBar=aw.HideSearchBar~=false,
ScrollBarEnabled=aw.ScrollBarEnabled or false,
SideBarWidth=aw.SideBarWidth or 200,
Acrylic=aw.Acrylic or false,
NewElements=aw.NewElements or false,
Motion=aw.Motion,
Settings=aw.Settings==false and false or(aw.Settings or{}),
IgnoreAlerts=aw.IgnoreAlerts or false,
HidePanelBackground=aw.HidePanelBackground or false,
AutoScale=aw.AutoScale~=false,
OpenButton=aw.OpenButton,
DragFrameSize=160,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=16,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=aw.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=aw.Resizable~=false,
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

ay.UICorner=ay.Radius

ay.TopBarButtonIconSize=ay.TopBarButtonIconSize or(ay.Topbar.ButtonsType=="Mac"and 11 or 16)

ay.ElementConfig={
UIPadding=(ay.NewElements and 10 or 13),
UICorner=ay.ElementsRadius or(ay.NewElements and 23 or 16),
Transparency=ay.ElementTransparency,
GlassTransparency=ay.ElementGlassTransparency or 0.24,
LiquidGlass=ay.LiquidGlass,
CornerStyle=ay.ElementCornerStyle or(ay.NewElements and"Native"or"Shape"),
LinkCorners=ay.LinkElementCorners,
}

local az=ay.Size or UDim2.new(0,580,0,460)
ay.Size=UDim2.new(
az.X.Scale,
math.clamp(az.X.Offset,ay.MinSize.X,ay.MaxSize.X),
az.Y.Scale,
math.clamp(az.Y.Offset,ay.MinSize.Y,ay.MaxSize.Y)
)

if ay.Topbar=={}then
ay.Topbar={Height=52,ButtonsType="Default"}
end

if not ai:IsStudio()and ay.Folder and writefile then
if not isfolder("WindUI/"..ay.Folder)then
makefolder("WindUI/"..ay.Folder)
end
if not isfolder("WindUI/"..ay.Folder.."/assets")then
makefolder("WindUI/"..ay.Folder.."/assets")
end
if not isfolder(ay.Folder)then
makefolder(ay.Folder)
end
if not isfolder(ay.Folder.."/assets")then
makefolder(ay.Folder.."/assets")
end
end

local aA=ap("UICorner",{
CornerRadius=UDim.new(0,ay.UICorner),
})

if ay.Folder then
ay.ConfigManager=av:Init(ay)
end

if ay.Acrylic then local
aB=am.AcrylicPaint{UseAcrylic=ay.Acrylic}

ay.AcrylicPaint=aB
end

local aB=ap("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true,
},{
ap("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})
local b=an.NewRoundFrame(ay.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
ap("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=an.Icon"expand"[1],
ImageRectOffset=an.Icon"expand"[2].ImageRectPosition,
ImageRectSize=an.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local d=an.NewRoundFrame(ay.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})









ay.UIElements.SideBar=ap("ScrollingFrame",{
Size=UDim2.new(
1,
ay.ScrollBarEnabled and-3-(ay.UIPadding/2)or 0,
1,
not ay.HideSearchBar and-45 or 0
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
ap("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
ap("UIPadding",{



PaddingBottom=UDim.new(0,ay.UIPadding/2),
}),
ap("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ay.Gap),
}),
}),
ap("UIPadding",{

PaddingLeft=UDim.new(0,ay.UIPadding/2),
PaddingRight=UDim.new(0,ay.UIPadding/2),
PaddingBottom=UDim.new(0,ay.UIPadding/2),
}),

})

ay.UIElements.SideBarContainer=ap("Frame",{
Size=UDim2.new(
0,
ay.SideBarWidth,
1,
ay.User.Enabled and-ay.Topbar.Height-42-(ay.UIPadding*2)or-ay.Topbar.Height
),
Position=UDim2.new(0,0,0,ay.Topbar.Height),
BackgroundTransparency=1,
Visible=true,
},{
ap("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,not ay.HideSearchBar and-45-ay.UIPadding or-ay.UIPadding/2),
Position=UDim2.new(0,0,1,-ay.UIPadding/2),
AnchorPoint=Vector2.new(0,1),
}),
ay.UIElements.SideBar,
})

if ay.ScrollBarEnabled then
at(
ay.UIElements.SideBar,
ay.UIElements.SideBarContainer.Content,
ay,
3,
aw.WindUI
)
end

ay.UIElements.MainBar=ap("Frame",{
Size=UDim2.new(1,-ay.UIElements.SideBarContainer.AbsoluteSize.X,1,-ay.Topbar.Height),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
an.NewRoundFrame(ay.UICorner-(ay.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="PanelBackground",
ImageTransparency="PanelBackgroundTransparency",
},


ZIndex=3,
Name="Background",
Visible=not ay.HidePanelBackground,
}),
ap("UIPadding",{

PaddingLeft=UDim.new(0,ay.UIPadding/2),
PaddingRight=UDim.new(0,ay.UIPadding/2),
PaddingBottom=UDim.new(0,ay.UIPadding/2),
}),
})

local f=ap("ImageLabel",{
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

if af.TouchEnabled and not af.KeyboardEnabled then
ay.IsPC=false
elseif af.KeyboardEnabled then
ay.IsPC=true
else
ay.IsPC=nil
end







local g
if ay.User then
local function GetUserThumb()local
h=ak:GetUserThumbnailAsync(
ay.User.Anonymous and 1 or ak.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return h
end

g=ap("TextButton",{
Size=UDim2.new(
0,
ay.UIElements.SideBarContainer.AbsoluteSize.X-(ay.UIPadding/2),
0,
42+ay.UIPadding
),
Position=UDim2.new(0,ay.UIPadding/2,1,-(ay.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=ay.User.Enabled or false,
},{
an.NewRoundFrame(ay.UICorner-(ay.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline",
},{
ap("UIGradient",{
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
an.NewRoundFrame(ay.UICorner-(ay.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
ap("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=0.93,
},{
ap("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
ap("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ap("TextLabel",{
Text=ay.User.Anonymous and"Anonymous"or ak.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(an.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName",
}),
ap("TextLabel",{
Text=ay.User.Anonymous and"anonymous"or ak.LocalPlayer.Name,
TextSize=15,
TextTransparency=0.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(an.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName",
}),
ap("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
}),
}),
ap("UIListLayout",{
Padding=UDim.new(0,ay.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ap("UIPadding",{
PaddingLeft=UDim.new(0,ay.UIPadding/2),
PaddingRight=UDim.new(0,ay.UIPadding/2),
}),
}),
})

function ay.User.Enable(h)
ay.User.Enabled=true
aq(
ay.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,ay.SideBarWidth,1,-ay.Topbar.Height-42-(ay.UIPadding*2))},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
g.Visible=true
end
function ay.User.Disable(h)
ay.User.Enabled=false
aq(
ay.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,ay.SideBarWidth,1,-ay.Topbar.Height)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
g.Visible=false
end
function ay.User.SetAnonymous(h,i)
if i~=false then
i=true
end
ay.User.Anonymous=i
g.UserIcon.ImageLabel.Image=GetUserThumb()
g.UserIcon.Frame.DisplayName.Text=i and"Anonymous"or ak.LocalPlayer.DisplayName
g.UserIcon.Frame.UserName.Text=i and"anonymous"or ak.LocalPlayer.Name
end

if ay.User.Enabled then
ay.User:Enable()
else
ay.User:Disable()
end

if ay.User.Callback then
an.AddSignal(g.MouseButton1Click,function()
ay.User.Callback()
end)
an.AddSignal(g.MouseEnter,function()
aq(g.UserIcon,0.04,{ImageTransparency=0.95}):Play()
aq(g.Outline,0.04,{ImageTransparency=0.85}):Play()
end)
an.AddSignal(g.InputEnded,function()
aq(g.UserIcon,0.04,{ImageTransparency=1}):Play()
aq(g.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local h
local i

local l=false
local m

local function GetTransparencyValue(p,r)
local u=tonumber(p)
if u==nil then
return r
end
return math.clamp(math.floor(u*100+0.5)/100,0,1)
end

local function ParseColorValue(p)
if typeof(p)=="Color3"then
return p
end
if typeof(p)=="string"and string.sub(p,1,1)=="#"then
local r,u=pcall(function()
return Color3.fromHex(p)
end)
return r and u or nil
end
return nil
end

local function GetUrlExtension(p,r)
if not p or typeof(p)~="string"then
return r or".png"
end
local u=p:match"^([^?#]+)"or p
local v=u:match"%.(%w+)$"
if v then
v=v:lower()
if v=="jpg"or v=="jpeg"or v=="png"or v=="webp"or v=="webm"then
return"."..v
end
end
return r or".png"
end

local function EnsureAssetFolder()
if ai:IsStudio()or not makefolder or not isfolder then
return
end

local p=ay.Folder or"Temp"
if not isfolder(p)then
makefolder(p)
end
if not isfolder(p.."/assets")then
makefolder(p.."/assets")
end
end

local function ReadHttp(p)
if game.HttpGet then
return game:HttpGet(p)
end
if an.Request then
local r=an.Request{
Url=p,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"},
}
return r and r.Body
end
return nil
end

local function GetCustomAsset(p)
if typeof(getcustomasset)~="function"then
return p
end

local r,u=pcall(function()
return getcustomasset(p)
end)
if r then
return u
end

warn("[ WindUI.Window.Background ] Failed to load custom asset: "..tostring(u))
return p
end

local function CacheHttpAsset(p,r)
if not writefile then
return p
end

EnsureAssetFolder()
local u=(ay.Folder or"Temp")
.."/assets/."
..an.SanitizeFilename(p)
..GetUrlExtension(p,r)

if not isfile or not isfile(u)then
local v,x=pcall(function()
local v=ReadHttp(p)
if v then
writefile(u,v)
end
end)

if not v then
warn("[ WindUI.Window.Background ] Failed to download asset: "..tostring(x))
return p
end
end

return GetCustomAsset(u)
end

local function ResolveBackgroundAsset(p,r)
if typeof(p)~="string"then
return""
end

local u=string.match(p,"^video:(.+)")
if u then
p=u
r="Video"
end

local v=string.match(p,"^customasset:(.+)")
or string.match(p,"^getcustomasset:(.+)")
or string.match(p,"^file:(.+)")
if v then
return GetCustomAsset(v)
end

if isfile and isfile(p)then
return GetCustomAsset(p)
end

if string.match(p,"^https?://")then
return CacheHttpAsset(p,r=="Video"and".webm"or".png")
end

return p
end

local function GetBackgroundKind(p)
if p==nil or p==false then
return nil,nil,{}
end

if typeof(p)=="table"then
local r=p.Type or p.Kind or p.Mode
if p.Video or r=="Video"or r=="video"then
return"Video",p.Video or p.Url or p.URL or p.Source or p.Asset or p.Path,p
end
if p.Image or p.Url or p.URL or p.Asset or p.Path or r=="Image"or r=="image"then
return"Image",p.Image or p.Url or p.URL or p.Asset or p.Path or p.Source,p
end
if p.Color or r=="Color"or r=="color"then
return"Color",p.Color or p.Value,p
end
return"Gradient",p.Gradient or p,p
end

local r=ParseColorValue(p)
if r then
return"Color",r,{}
end

if typeof(p)=="string"then
local u=string.match(p,"^video:(.+)")
local v=p:match"^([^?#]+)"or p
if u or string.match(v:lower(),"%.webm$")then
return"Video",u or p,{}
end
return"Image",p,{}
end

return nil,nil,{}
end

local function CreateDetachedMediaBackground(p,r,u)
if p=="Image"then
ay.BackgroundScaleType=u.ScaleType or ay.BackgroundScaleType
ay.BackgroundImageTransparency=GetTransparencyValue(
u.Transparency or u.ImageTransparency,
ay.BackgroundImageTransparency
)
return ap("ImageLabel",{
Name="BackgroundImage",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=ResolveBackgroundAsset(r,"Image"),
ImageTransparency=ay.BackgroundImageTransparency,
ScaleType=ay.BackgroundScaleType,
ZIndex=-10,
},{
ap("UICorner",{
CornerRadius=UDim.new(0,ay.UICorner),
}),
})
end

if p=="Video"then
local v=ap("VideoFrame",{
Name="BackgroundVideo",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ResolveBackgroundAsset(r,"Video"),
Looped=u.Looped~=false,
Volume=math.clamp(tonumber(u.Volume)or 0,0,1),
ZIndex=-10,
},{
ap("UICorner",{
CornerRadius=UDim.new(0,ay.UICorner),
}),
})
v:Play()
return v
end

return nil
end

local p,r,u=GetBackgroundKind(ay.Background)
l=p=="Video"
m=CreateDetachedMediaBackground(p,r,u)

local v=an.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
ap("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
}),
})

function createAuthor(x)
return ap("TextLabel",{
Text=x,
FontFace=Font.new(an.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=ay.UIElements.Main and ay.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor",
},
Name="Author",
})
end

local x
local z

if ay.Author then
x=createAuthor(ay.Author)
end

local A=ap("TextLabel",{
Text=ay.Title,
FontFace=Font.new(an.Font,Enum.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="WindowTopbarTitle",
},
})

ay.UIElements.Main=ap("Frame",{
Size=UDim2.new(ay.Size.X.Scale,ay.Size.X.Offset,0,0),
Position=ay.Position,
BackgroundTransparency=1,
Parent=aw.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,

},{
aw.WindUI.UIScaleObj,
ay.AcrylicPaint and ay.AcrylicPaint.Frame or nil,
f,
an.NewRoundFrame(ay.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground",
},

},{
m,
v,
aB,
}),




aA,
b,
d,
ap("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
ap("UICorner",{
CornerRadius=UDim.new(0,ay.UICorner),
}),
ay.UIElements.SideBarContainer,
ay.UIElements.MainBar,

g,

i,
ap("Frame",{
Size=UDim2.new(1,0,0,ay.Topbar.Height),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar",
},{
h,






ap("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left",
},{
ap("UIListLayout",{
Padding=UDim.new(0,ay.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ap("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
ap("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
A,
x,
}),
ap("UIPadding",{
PaddingLeft=UDim.new(0,4),
}),
}),
ap("CanvasGroup",{
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Center",
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
AutomaticSize="Y",
Visible=false,
},{



ap("ScrollingFrame",{
Name="Holder",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
Size=UDim2.new(1,0,1,0),


},{

ap("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,ay.UIPadding/2),
}),
}),
}),
ap("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(ay.Topbar.ButtonsType=="Default"and 1 or 0,0,0.5,0),
AnchorPoint=Vector2.new(ay.Topbar.ButtonsType=="Default"and 1 or 0,0.5),
Name="Right",
},{
ap("UIListLayout",{
Padding=UDim.new(0,ay.Topbar.ButtonsType=="Default"and 9 or 0),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),
}),
ap("UIPadding",{
PaddingTop=UDim.new(0,ay.UIPadding),
PaddingLeft=UDim.new(
0,
ay.Topbar.ButtonsType=="Default"and ay.UIPadding or ay.UIPadding-2
),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,ay.UIPadding),
}),
}),
}),
})

an.AddSignal(ay.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local B=0
local C=ay.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X
/aw.WindUI.UIScale

B=ay.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X/aw.WindUI.UIScale
if ay.Topbar.ButtonsType~="Default"then
B=B+C+ay.UIPadding-4
end

ay.UIElements.Main.Main.Topbar.Center.Position=
UDim2.new(0,B+(ay.UIPadding/aw.WindUI.UIScale),0.5,0)
ay.UIElements.Main.Main.Topbar.Center.Size=UDim2.new(
1,
-B
-(ay.UIPadding/aw.WindUI.UIScale)
-(ay.Topbar.ButtonsType=="Default"and C+ay.UIPadding or 0),
1,
0
)
end)

if ay.Topbar.ButtonsType~="Default"then
an.AddSignal(ay.UIElements.Main.Main.Topbar.Right:GetPropertyChangedSignal"AbsoluteSize",function()
ay.UIElements.Main.Main.Topbar.Left.Position=UDim2.new(
0,
(ay.UIElements.Main.Main.Topbar.Right.AbsoluteSize.X/aw.WindUI.UIScale)+ay.UIPadding-4,
0,
0
)
end)
end

local function GetImageTarget(B)
if typeof(B)~="Instance"then
return nil
end

if B:IsA"ImageLabel"or B:IsA"ImageButton"then
return B
end

return B:FindFirstChildWhichIsA"ImageLabel"or B:FindFirstChildWhichIsA"ImageButton"
end

function ay.CreateTopbarButton(B,C,F,G,H,J,L,M,N)
local O=H or 999
N=N or{}
local P=N.ForceIcon==true
local Q=ay.Topbar.ButtonsType=="Default"or P
local R=ay.Topbar.ButtonsType~="Default"and not P
local S=an.Image(
F,
F,
0,
ay.Folder,
"WindowTopbarIcon",
Q,
J,
"WindowTopbarButtonIcon"
)
S.Size=Q
and UDim2.new(0,M or ay.TopBarButtonIconSize,0,M or ay.TopBarButtonIconSize)
or UDim2.new(0,0,0,0)
S.AnchorPoint=Vector2.new(0.5,0.5)
S.Position=UDim2.new(0.5,0,0.5,0)
local T=GetImageTarget(S)
if T then
T.ImageTransparency=Q and 0 or 1
end

if R and T then
T.ImageColor3=an.GetTextColorForHSB(L or Color3.fromHex"#ff3030")
end

local U=an.NewRoundFrame(
Q and ay.UICorner-(ay.UIPadding/2)or 999,
"Squircle",
{
Size=Q
and UDim2.new(0,ay.Topbar.Height-16,0,ay.Topbar.Height-16)
or UDim2.new(0,14,0,14),
LayoutOrder=O,


ZIndex=9999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageColor3=R and(L or Color3.fromHex"#ff3030")or nil,
ThemeTag=Q and{
ImageColor3="Text",
}or nil,
ImageTransparency=Q and 1 or 0,
},
{












S,
ap("UIScale",{
Scale=1,
}),
},
true
)

local V=ap("Frame",{
Size=R and UDim2.new(0,24,0,24)
or UDim2.new(0,ay.Topbar.Height-16,0,ay.Topbar.Height-16),
BackgroundTransparency=1,
Parent=ay.UIElements.Main.Main.Topbar.Right,
LayoutOrder=O,
},{
U,
})



ay.TopBarButtons[100-O]={
Name=C,
Object=V,
}

an.AddSignal(U.MouseButton1Click,function()
if G then
G()
end
end)
an.AddSignal(U.MouseEnter,function()
if Q then
ao.Play(U,"Hover",{ImageTransparency=0.93},nil,nil,"Hover")


else

ao.Play(
T,
"Hover",
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
ao.Play(S,"Hover",{
Size=UDim2.new(
0,
M or ay.TopBarButtonIconSize,
0,
M or ay.TopBarButtonIconSize
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Hover")
end
end)

an.AddSignal(U.MouseButton1Down,function()
ao.Play(U.UIScale,"Press",{Scale=0.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Press")
end)

an.AddSignal(U.MouseLeave,function()
if Q then
ao.Play(U,"Hover",{ImageTransparency=1},nil,nil,"Hover")


else

ao.Play(
T,
"Hover",
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
ao.Play(
S,
"Hover",
{Size=UDim2.new(0,0,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Hover"
)
end
end)

an.AddSignal(U.InputEnded,function()
ao.Play(U.UIScale,"Press",{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Press")
end)

return U
end

function ay.Topbar.Button(B,C:{
Name:string,
Icon:string,
Callback:any,
LayoutOrder:number,
IconThemed:boolean,
Color:Color3,
IconSize:number,
Options:table,
})
return ay:CreateTopbarButton(
C.Name,
C.Icon,
C.Callback,
C.LayoutOrder or 0,
C.IconThemed,
C.Color,
C.IconSize,
C.Options
)
end



local B=an.Drag(
ay.UIElements.Main,
{ay.UIElements.Main.Main.Topbar,v.Frame},
function(B,C)
if not ay.Closed then
if B and C==v.Frame then
aq(v,0.1,{ImageTransparency=0.35}):Play()
else
aq(v,0.2,{ImageTransparency=0.8}):Play()
end
ay.Position=ay.UIElements.Main.Position
ay.Dragging=B
end
end
)

local function ParseBackgroundColor(C)
return ParseColorValue(C)
end

local function ApplyBackgroundColor(C)
local F=ParseBackgroundColor(C)
if F then
ay.BackgroundColor=C
ao.Play(
ay.UIElements.Main.Background,
"Background",
{ImageColor3=F},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundColor"
)
end
return F
end

local function SetBackgroundGradientObject(C,F)
if ay.UIElements.BackgroundGradient then
ay.UIElements.BackgroundGradient:Destroy()
ay.UIElements.BackgroundGradient=nil
end

if typeof(C)~="table"then
return nil
end

local G=C.Color~=nil
or C.Transparency~=nil
or C.Rotation~=nil
or C.Offset~=nil
if not G then
return nil
end

local H=ap"UIGradient"
for J,L in next,C do
if J=="Transparency"and typeof(L)=="number"then
continue
end
pcall(function()
H[J]=L
end)
end

local J=an.NewRoundFrame(ay.UICorner,"Squircle",{
Name="BackgroundGradient",
Size=UDim2.new(1,0,1,0),
Parent=ay.UIElements.Main.Background,
ImageTransparency=F or ay.BackgroundOverlayTransparency,
ZIndex=-9,
},{
H,
})

ay.UIElements.BackgroundGradient=J
return J
end

local function ClearDetachedBackgroundMedia(C)
if C~="Image"and m and m:IsA"ImageLabel"then
m:Destroy()
m=nil
elseif C~="Video"and m and m:IsA"VideoFrame"then
m:Destroy()
m=nil
end

if C~="Gradient"and ay.UIElements.BackgroundGradient then
ay.UIElements.BackgroundGradient:Destroy()
ay.UIElements.BackgroundGradient=nil
end
end

local function CreateImageBackground()
ClearDetachedBackgroundMedia"Image"

if m and m:IsA"ImageLabel"then
return m
end

if m then
m:Destroy()
end

m=ap("ImageLabel",{
Name="BackgroundImage",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ScaleType=ay.BackgroundScaleType,
ZIndex=-10,
Parent=ay.UIElements.Main.Background,
},{
ap("UICorner",{
CornerRadius=UDim.new(0,ay.UICorner),
}),
})

return m
end

local function CreateVideoBackground()
ClearDetachedBackgroundMedia"Video"

if m then
m:Destroy()
end

m=ap("VideoFrame",{
Name="BackgroundVideo",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Looped=true,
Volume=0,
ZIndex=-10,
Parent=ay.UIElements.Main.Background,
},{
ap("UICorner",{
CornerRadius=UDim.new(0,ay.UICorner),
}),
})

return m
end

if ay.BackgroundColor then
ApplyBackgroundColor(ay.BackgroundColor)
elseif p=="Color"then
ApplyBackgroundColor(r)
end

local C=ay.BackgroundGradient
or(p=="Gradient"and r or nil)
if C then
local F=ay.BackgroundGradient and ay.BackgroundOverlayTransparency
or(ay.Transparent and aw.WindUI.TransparencyValue or 0)
SetBackgroundGradientObject(C,F)
end














ay.OpenButtonMain=a.load'C'.New(ay)
ay.WatermarkMain=a.load'D'.New(ay,aw.WindUI)

function ay.SetWatermark(F,G)
ay.Watermark=G
return ay.WatermarkMain:Edit(G)
end

function ay.ToggleWatermark(F,G)
if ay.WatermarkMain then
ay.WatermarkMain:Visible(G)
end
end

if ay.Watermark~=nil and ay.Watermark~=false then
ay:SetWatermark(ay.Watermark)
end

task.spawn(function()
if ay.Icon then
local F=ap("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=ay.UIElements.Main.Main.Topbar.Left,
})

z=an.Image(
ay.Icon,
ay.Title,
ay.IconRadius,
ay.Folder,
"Window",
true,
ay.IconThemed,
"WindowTopbarIcon"
)
z.Parent=F
z.Size=UDim2.new(0,ay.IconSize,0,ay.IconSize)
z.Position=UDim2.new(0.5,0,0.5,0)
z.AnchorPoint=Vector2.new(0.5,0.5)

ay.OpenButtonMain:SetIcon(ay.Icon)











else
ay.OpenButtonMain:SetIcon(ay.Icon)

end
end)

function ay.SetToggleKey(F,G)
ay.ToggleKey=G
end

function ay.SetTitle(F,G)
ay.Title=G
A.Text=G
end

function ay.SetAuthor(F,G)
ay.Author=G
if not x then
x=createAuthor(ay.Author)
end

x.Text=G
end

function ay.SetSize(F,G)
if typeof(G)=="UDim2"then
ay.Size=G

aq(ay.UIElements.Main,0.08,{Size=G},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

local function GetBackgroundTransparency(F,G)
return GetTransparencyValue(F,G)
end

function ay.SetBackgroundImage(F,G,H)
H=typeof(H)=="table"and H or{Transparency=H}
ClearDetachedBackgroundMedia"Image"
local J=CreateImageBackground()
ay.Background=G
ay.BackgroundGradient=nil
ay.BackgroundScaleType=H.ScaleType or ay.BackgroundScaleType
ay.BackgroundImageTransparency=GetBackgroundTransparency(
H.Transparency or H.ImageTransparency,
ay.BackgroundImageTransparency
)
J.ScaleType=ay.BackgroundScaleType
J.Image=ResolveBackgroundAsset(G,"Image")
J.ImageTransparency=1
ao.Play(
J,
"Background",
{ImageTransparency=ay.BackgroundImageTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundImage"
)
return J
end

function ay.SetBackgroundVideo(F,G,H)
H=typeof(H)=="table"and H or{}
ClearDetachedBackgroundMedia"Video"
local J=CreateVideoBackground()
ay.Background="video:"..tostring(G or"")
ay.BackgroundGradient=nil
J.Video=ResolveBackgroundAsset(G,"Video")
J.Visible=true
J.Looped=H.Looped~=false
J.Volume=math.clamp(tonumber(H.Volume)or J.Volume or 0,0,1)
J:Play()
return J
end

function ay.SetBackgroundGradient(F,G,H)
ClearDetachedBackgroundMedia"Gradient"
ay.BackgroundGradient=G
ay.Background=nil
ay.BackgroundOverlayTransparency=GetBackgroundTransparency(H,ay.BackgroundOverlayTransparency)
local J=SetBackgroundGradientObject(G,1)
if J then
ao.Play(
J,
"Background",
{ImageTransparency=ay.BackgroundOverlayTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundGradient"
)
end
return J
end

function ay.SetBackgroundColor(F,G)
return ApplyBackgroundColor(G)
end

function ay.SetBackgroundOverlayTransparency(F,G)
ay.BackgroundOverlayTransparency=GetBackgroundTransparency(G,ay.BackgroundOverlayTransparency)
if ay.UIElements.BackgroundGradient then
ao.Play(
ay.UIElements.BackgroundGradient,
"Background",
{ImageTransparency=ay.BackgroundOverlayTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundGradient"
)
end
return ay.BackgroundOverlayTransparency
end

function ay.SetBackground(F,G,H)
if G==nil or G==false then
ay.Background=nil
ay.BackgroundGradient=nil
if m then
m:Destroy()
m=nil
end
if ay.UIElements.BackgroundGradient then
ay.UIElements.BackgroundGradient:Destroy()
ay.UIElements.BackgroundGradient=nil
end
return nil
end

local J,L,M=GetBackgroundKind(G)
local N={}
if typeof(M)=="table"then
for O,P in next,M do
N[O]=P
end
end
if typeof(H)=="table"then
for O,P in next,H do
N[O]=P
end
elseif H~=nil then
N.Transparency=H
end

if J=="Gradient"then
return ay:SetBackgroundGradient(L,N.Transparency or N.OverlayTransparency)
elseif J=="Color"then
return ay:SetBackgroundColor(L)
elseif J=="Video"then
return ay:SetBackgroundVideo(L,N)
elseif J=="Image"then
return ay:SetBackgroundImage(L,N)
end

return nil
end

function ay.SetBackgroundImageTransparency(F,G)
ay.BackgroundImageTransparency=GetBackgroundTransparency(G,ay.BackgroundImageTransparency)
if m and m:IsA"ImageLabel"then
ao.Play(
m,
"Background",
{ImageTransparency=ay.BackgroundImageTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"BackgroundImage"
)
end
end

function ay.SetBackgroundTransparency(F,G)
local H=math.floor(tonumber(G)*10+0.5)/10
aw.WindUI.TransparencyValue=H
ay:ToggleTransparency(H>0)
end

function ay.SetElementTransparency(F,G)
local H=math.floor(an.ClampTransparency(G,ay.ElementConfig.Transparency or 0)*100+0.5)
/100

ay.ElementTransparency=H
ay.ElementConfig.Transparency=H

for J,L in next,ay.AllElements do
if L and L.SetTransparency then
L:SetTransparency(H)
end
end

return H
end

function ay.SetLiquidGlass(F,G)
ay.LiquidGlass=G==true
ay.ElementConfig.LiquidGlass=ay.LiquidGlass

for H,J in next,ay.AllElements do
if J and J.SetLiquidGlass then
J:SetLiquidGlass(ay.LiquidGlass)
end
end
end

local F
local G
an.Icon"minimize"
an.Icon"maximize"

if ay.Settings~=false and ay.Topbar.Settings~=false then
local H=a.load'E'.New(ay,aw.WindUI,aw)
local J=ay:CreateTopbarButton(
"Settings",
"settings",
function()
H:Toggle()
end,
ay.Topbar.ButtonsType=="Default"and 997 or 1000,
true,
Color3.fromHex"#9B87F5",
nil,
{
ForceIcon=true,
}
)
H:SetButton(J)
ay.SettingsMenu=H
end

if ay.KeyBindMenu~=false and ay.Topbar.KeyBindMenu~=false then
local H=a.load'F'.New(ay,aw.WindUI,aw)
local J=ay:CreateTopbarButton(
"KeyBind",
"keyboard",
function()
H:Toggle()
end,
ay.Topbar.ButtonsType=="Default"and 996 or 1001,
true,
Color3.fromHex"#38BDF8",
nil,
{
ForceIcon=true,
}
)
H:SetButton(J)
ay.KeyBindMenuMain=H

function ay.ToggleKeyBindMenu(L)
return H:Toggle()
end

function ay.OpenKeyBindMenu(L)
return H:OpenMenu()
end
end

ay:CreateTopbarButton(
"Fullscreen",
ay.Topbar.ButtonsType=="Mac"and"rbxassetid://127426072704909"or"maximize",
function()
ay:ToggleFullscreen()
end,
(ay.Topbar.ButtonsType=="Default"and 998 or 999),
true,
Color3.fromHex"#60C762",
ay.Topbar.ButtonsType=="Mac"and 9 or nil
)

local function SetSize(H)
ao.Play(ay.UIElements.Main,"Resize",{
Size=not ay.IsFullscreen and G or UDim2.new(
0,
(aw.WindUI.ScreenGui.AbsoluteSize.X-20)/aw.WindUI.UIScale,
0,
(aw.WindUI.ScreenGui.AbsoluteSize.Y-20-52)/aw.WindUI.UIScale
),
Position=not ay.IsFullscreen and F or UDim2.new(0.5,0,0.5,26),
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Fullscreen"
)
end

function ay.ToggleFullscreen(H)
local J=ay.IsFullscreen

B:Set(J)

if not J then
F=ay.UIElements.Main.Position
G=ay.UIElements.Main.Size

ay.CanResize=false
else
if ay.Resizable then
ay.CanResize=true
end
end

ay.IsFullscreen=not J

SetSize(true)
end

an.AddSignal(aw.WindUI.ScreenGui:GetPropertyChangedSignal"AbsoluteSize",function()
if ay.IsFullscreen then
SetSize()
end
end)

ay:CreateTopbarButton("Minimize","minus",function()
if ay.Close then
ay:Close()
end






















end,(ay.Topbar.ButtonsType=="Default"and 997 or 998),nil,Color3.fromHex"#F4C948")

function ay.OnOpen(H,J)
ay.OnOpenCallback=J
end
function ay.OnClose(H,J)
ay.OnCloseCallback=J
end
function ay.OnDestroy(H,J)
ay.OnDestroyCallback=J
end

if aw.WindUI.UseAcrylic then
ay.AcrylicPaint.AddParent(ay.UIElements.Main)
end

function ay.SetIconSize(H,J)
local L
if typeof(J)=="number"then
L=UDim2.new(0,J,0,J)
ay.IconSize=J
elseif typeof(J)=="UDim2"then
L=J
ay.IconSize=J.X.Offset
end

if z then
z.Size=L
end
end

function ay.Open(H)
if ay.Destroyed then
return
end
task.spawn(function()
if ay.OnOpenCallback then
task.spawn(function()
an.SafeCallback(ay.OnOpenCallback)
end)
end

task.wait(0.06)
ay.Closed=false

ay.UIElements.Main.Size=UDim2.new(ay.Size.X.Scale,ay.Size.X.Offset,0,100)

ao.Play(ay.UIElements.Main,"WindowOpen",{

Size=ay.Size,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")

if ay.UIElements.BackgroundGradient then
ao.Play(ay.UIElements.BackgroundGradient,"Focus",{
ImageTransparency=ay.BackgroundGradient and ay.BackgroundOverlayTransparency or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end

ay.UIElements.Main.Background.ImageTransparency=1
ao.Play(ay.UIElements.Main.Background,"WindowOpen",{

ImageTransparency=ay.Transparent and aw.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,"WindowBackground")

if m then
if m:IsA"VideoFrame"then
m.Visible=true
else
ao.Play(m,"Focus",{
ImageTransparency=ay.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end
end

if ay.OpenButtonMain and ay.IsOpenButtonEnabled then
ay.OpenButtonMain:Visible(false)
end









ao.Play(
f,
"WindowOpen",
{ImageTransparency=ay.ShadowTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out,
"Window"
)




ao.Play(
v,
"WindowOpen",
{Size=UDim2.new(0,ay.DragFrameSize,0,4),ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
B:Set(true)

if ay.Resizable then
ao.Play(
aB.ImageLabel,
"WindowOpen",
{ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
ay.CanResize=true
end

ay.CanDropdown=true
ay.UIElements.Main.Visible=true



ay.UIElements.Main:WaitForChild"Main".Visible=true

aw.WindUI:ToggleAcrylic(true)

end)
end
function ay.Close(H)
if ay.Destroyed then
return
end

local J={}

if ay.OnCloseCallback then
task.spawn(function()
an.SafeCallback(ay.OnCloseCallback)
end)
end

aw.WindUI:ToggleAcrylic(false)

if ay.UIElements.Main and ay.UIElements.Main:WaitForChild"Main"then
ay.UIElements.Main.Main.Visible=false
end

ay.CanDropdown=false
ay.Closed=true

ao.Play(ay.UIElements.Main,"WindowClose",{

Size=UDim2.new(ay.Size.X.Scale,ay.Size.X.Offset,0,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
if ay.UIElements.BackgroundGradient then
ao.Play(ay.UIElements.BackgroundGradient,"Fast",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end

ao.Play(ay.UIElements.Main.Background,"WindowClose",{

ImageTransparency=1,
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,"WindowBackground")








if m then
if m:IsA"VideoFrame"then
m.Visible=false
else
ao.Play(m,"WindowClose",{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")
end
end
ao.Play(f,"WindowClose",{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out,"Window")




ao.Play(
v,
"WindowClose",
{Size=UDim2.new(0,0,0,4),ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
ao.Play(
aB.ImageLabel,
"WindowClose",
{ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out,
"Window"
)
B:Set(false)
ay.CanResize=false

task.spawn(function()
task.wait(ao.GetDuration"WindowClose"+0.05)

if not ay.Closed then
return
end

ay.UIElements.Main.Visible=false

if ay.OpenButtonMain and not ay.Destroyed and not ay.IsPC and ay.IsOpenButtonEnabled then
ay.OpenButtonMain:Visible(true)
end
end)

function J.Destroy(L)
task.spawn(function()
if ay.OnDestroyCallback then
task.spawn(function()
an.SafeCallback(ay.OnDestroyCallback)
end)
end

if ay.AcrylicPaint and ay.AcrylicPaint.Model then
ay.AcrylicPaint.Model:Destroy()
end

ay.Destroyed=true

task.wait(0.4)

aw.WindUI.ScreenGui:Destroy()
aw.WindUI.NotificationGui:Destroy()
aw.WindUI.DropdownGui:Destroy()
aw.WindUI.TooltipGui:Destroy()

an.DisconnectAll()

return
end)
end

return J
end
function ay.Destroy(H)
return ay:Close():Destroy()
end
function ay.Toggle(H)
if ay.Closed then
ay:Open()
else
ay:Close()
end
end

function ay.ToggleTransparency(H,J)

ay.Transparent=J
aw.WindUI.Transparent=J

ay.UIElements.Main.Background.ImageTransparency=J and aw.WindUI.TransparencyValue or 0
if ay.UIElements.BackgroundGradient then
ay.UIElements.BackgroundGradient.ImageTransparency=J and aw.WindUI.TransparencyValue
or ay.BackgroundOverlayTransparency
end


end

function ay.LockAll(H)
for J,L in next,ay.AllElements do
if L.Lock then
L:Lock()
end
end
end
function ay.UnlockAll(H)
for J,L in next,ay.AllElements do
if L.Unlock then
L:Unlock()
end
end
end
function ay.GetLocked(H)
local J={}

for L,M in next,ay.AllElements do
if M.Locked then
table.insert(J,M)
end
end

return J
end
function ay.GetUnlocked(H)
local J={}

for L,M in next,ay.AllElements do
if M.Locked==false then
table.insert(J,M)
end
end

return J
end

function ay.GetUIScale(H,J)
return aw.WindUI.UIScale
end

function ay.SetUIScale(H,J)
aw.WindUI.UIScale=J
aq(aw.WindUI.UIScaleObj,0.2,{Scale=J},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return ay
end

function ay.SetToTheCenter(H)
aq(
ay.UIElements.Main,
0.45,
{Position=UDim2.new(0.5,0,0.5,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
return ay
end

function ay.SetCurrentConfig(H,J)
ay.CurrentConfig=J
end

do
local H=40
local J=al.ViewportSize
local L=Vector2.new(ay.Size.X.Offset,ay.Size.Y.Offset)

if not ay.IsFullscreen and ay.AutoScale then
local M=J.X-(H*2)
local N=J.Y-(H*2)

local O=M/L.X
local P=N/L.Y

local Q=math.min(O,P)

local R=0.3
local S=1.0

local T=math.clamp(Q,R,S)

local U=ay:GetUIScale()or 1
local V=0.05

if math.abs(T-U)>V then
ay:SetUIScale(T)
end
end
end

if ay.OpenButtonMain and ay.OpenButtonMain.Button then
an.AddSignal(ay.OpenButtonMain.Button.TextButton.MouseButton1Click,function()


ay:Open()
end)
end

an.AddSignal(af.InputBegan,function(H,J)
if J then
return
end

if ay.ToggleKey then
if H.KeyCode==ay.ToggleKey then
ay:Toggle()
end
end
end)

task.spawn(function()

ay:Open()
end)

function ay.EditOpenButton(H,J)
return ay.OpenButtonMain:Edit(J)
end

if ay.OpenButton and typeof(ay.OpenButton)=="table"then
ay:EditOpenButton(ay.OpenButton)
end

local H=a.load'aD'
local J=a.load'aE'
local L=H.Init(ay,aw.WindUI,aw.WindUI.TooltipGui)
L:OnChange(function(M)
ay.CurrentTab=M
end)

ay.TabModule=L

function ay.Tab(M,N)
N.Parent=ay.UIElements.SideBar.Frame
return L.New(N,aw.WindUI.UIScale)
end

function ay.SelectTab(M,N)
L:SelectTab(N)
end

function ay.Section(M,N)
return J.New(
N,
ay.UIElements.SideBar.Frame,
ay.Folder,
aw.WindUI.UIScale,
ay
)
end

function ay.IsResizable(M,N)
ay.Resizable=N
ay.CanResize=N
end

function ay.SetPanelBackground(M,N)
if typeof(N)=="boolean"then
ay.HidePanelBackground=N

ay.UIElements.MainBar.Background.Visible=N

if L then
for O,P in next,L.Containers do
P.ScrollingFrame.UIPadding.PaddingTop=UDim.new(0,ay.HidePanelBackground and 20 or 10)
P.ScrollingFrame.UIPadding.PaddingLeft=
UDim.new(0,ay.HidePanelBackground and 20 or 10)
P.ScrollingFrame.UIPadding.PaddingRight=
UDim.new(0,ay.HidePanelBackground and 20 or 10)
P.ScrollingFrame.UIPadding.PaddingBottom=
UDim.new(0,ay.HidePanelBackground and 20 or 10)
end
end
end
end

function ay.Divider(M)
local N=ap("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
})
local O=ap("Frame",{
Parent=ay.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
N,
})

return O
end

local M=a.load'p'
function ay.Dialog(N,O)
local P={
Title=O.Title or"Dialog",
Width=O.Width or 320,
Content=O.Content,
Buttons=O.Buttons or{},

TextPadding=14,
}
local Q=M.Create(false,"Dialog",ay,aw.WindUI,ay.UIElements.Main.Main)

Q.UIElements.Main.Size=UDim2.new(0,P.Width,0,0)

local R=ap("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=Q.UIElements.Main,
},{
ap("UIListLayout",{
FillDirection="Vertical",

Padding=UDim.new(0,Q.UIPadding),
}),
})

local S=ap("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=R,
},{
ap("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,Q.UIPadding),
VerticalAlignment="Center",
}),
ap("UIPadding",{
PaddingTop=UDim.new(0,P.TextPadding/2),
PaddingLeft=UDim.new(0,P.TextPadding/2),
PaddingRight=UDim.new(0,P.TextPadding/2),
}),
})

local T
if O.Icon then
T=an.Image(
O.Icon,
P.Title..":"..O.Icon,
0,
ay,
"Dialog",
true,
O.IconThemed
)
T.Size=UDim2.new(0,22,0,22)
T.Parent=S
end

Q.UIElements.UIListLayout=ap("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
VerticalFlex="SpaceBetween",
Parent=Q.UIElements.Main,
})

ap("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=Q.UIElements.Main,
})

Q.UIElements.Title=ap("TextLabel",{
Text=P.Title,
TextSize=20,
FontFace=Font.new(an.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,T and-26-Q.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=S,
})
if P.Content then
ap("TextLabel",{
Text=P.Content,
TextSize=18,
TextTransparency=0.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(an.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=R,
},{
ap("UIPadding",{
PaddingLeft=UDim.new(0,P.TextPadding/2),
PaddingRight=UDim.new(0,P.TextPadding/2),
PaddingBottom=UDim.new(0,P.TextPadding/2),
}),
})
end

local U=ap("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Center",
HorizontalFlex="Fill",
})

local V=ap("Frame",{
Size=UDim2.new(1,0,0,36),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=Q.UIElements.Main,
LayoutOrder=4,
},{
U,






})

local W={}

for X,Y in next,P.Buttons do
local _=
as(Y.Title,Y.Icon,Y.Callback,Y.Variant,V,Q,true)
table.insert(W,_)
_.Size=UDim2.new(1,0,1,0)
end





















































Q:Open()

return Q
end

local N=false

ay:CreateTopbarButton("Close","x",function()
if not N then
if not ay.IgnoreAlerts then
N=true

ay:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()
N=false
end,
Variant="Secondary",
},
{
Title="Close Window",

Callback=function()
N=false
ay:Destroy()
end,
Variant="Primary",
},
},
}
else
ay:Destroy()
end
end
end,(ay.Topbar.ButtonsType=="Default"and 999 or 997),nil,Color3.fromHex"#F4695F")

function ay.Tag(O,P)
if ay.UIElements.Main.Main.Topbar.Center.Visible==false then
ay.UIElements.Main.Main.Topbar.Center.Visible=true
end
P.Window=ay
return au:New(P,ay.UIElements.Main.Main.Topbar.Center.Holder)
end

local O=aw.WindUI.GenerateGUID()

local function startResizing(P)
if ay.CanResize then
isResizing=true
b.Active=true
initialSize=ay.UIElements.Main.Size
initialInputPosition=P.Position


aq(aB.ImageLabel,0.1,{ImageTransparency=0.35}):Play()

an.AddSignal(P.Changed,function()
if P.UserInputState==Enum.UserInputState.End then
if aw.WindUI.CurrentInput and aw.WindUI.CurrentInput~=O then
return
end

aw.WindUI.CurrentInput=nil

isResizing=false
b.Active=false


aq(aB.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)
end
end

an.AddSignal(aB.InputBegan,function(P)
if
P.UserInputType==Enum.UserInputType.MouseButton1
or P.UserInputType==Enum.UserInputType.Touch
then
if aw.WindUI.CurrentInput and aw.WindUI.CurrentInput~=O then
return
end
aw.WindUI.CurrentInput=O

if ay.CanResize then
startResizing(P)
end
end
end)

an.AddSignal(af.InputChanged,function(P)
if
P.UserInputType==Enum.UserInputType.MouseMovement
or P.UserInputType==Enum.UserInputType.Touch
then
if isResizing and ay.CanResize then
local Q=P.Position-initialInputPosition
local R=UDim2.new(0,initialSize.X.Offset+Q.X*2,0,initialSize.Y.Offset+Q.Y*2)

R=UDim2.new(
R.X.Scale,
math.clamp(R.X.Offset,ay.MinSize.X,ay.MaxSize.X),
R.Y.Scale,
math.clamp(R.Y.Offset,ay.MinSize.Y,ay.MaxSize.Y)
)

aq(ay.UIElements.Main,0.08,{
Size=R,
},Enum.EasingStyle.Quad,Enum.EasingDirection.Out):Play()

ay.Size=R
end
end
end)

an.AddSignal(aB.MouseEnter,function()
if aw.WindUI.CurrentInput and aw.WindUI.CurrentInput~=O then
return
end
if not isResizing then
aq(aB.ImageLabel,0.1,{ImageTransparency=0.35}):Play()
end
end)
an.AddSignal(aB.MouseLeave,function()
if aw.WindUI.CurrentInput and aw.WindUI.CurrentInput~=O then
return
end
if not isResizing then
aq(aB.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)



local P=0
local Q=0.4
local R
local S=0

function onDoubleClick()
ay:SetToTheCenter()
end

an.AddSignal(v.Frame.MouseButton1Up,function()
local T=tick()
local U=ay.Position

S=S+1

if S==1 then
P=T
R=U

task.spawn(function()
task.wait(Q)
if S==1 then
S=0
R=nil
end
end)
elseif S==2 then
if T-P<=Q and U==R then
onDoubleClick()
end

S=0
R=nil
P=0
else
S=1
P=T
R=U
end
end)



if not ay.HideSearchBar then
local T=a.load'aG'
local U=false





















local V=ar("Search","search",ay.UIElements.SideBarContainer,true)
V.Size=UDim2.new(1,-ay.UIPadding/2,0,39)
V.Position=UDim2.new(0,ay.UIPadding/2,0,0)

an.AddSignal(V.MouseButton1Click,function()
if U then
return
end

T.new(ay.TabModule,ay.UIElements.Main,function()

U=false
if ay.Resizable then
ay.CanResize=true
end

aq(d,0.1,{ImageTransparency=1}):Play()
d.Active=false
end)
aq(d,0.1,{ImageTransparency=0.65}):Play()
d.Active=true

U=true
ay.CanResize=false
end)
end



function ay.DisableTopbarButtons(T,U)
for V,W in next,U do
for X,Y in next,ay.TopBarButtons do
if Y.Name==W then
Y.Object.Visible=false
end
end
end
end



























return ay
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

local af=(cloneref or clonereference or function(af)
return af
end)

aa.cloneref=af

local ai=af(game:GetService"HttpService")
local ak=af(game:GetService"Players")
local al=af(game:GetService"CoreGui")
local am=af(game:GetService"RunService")
local an=af(game:GetService"UserInputService")

function aa.GenerateGUID()
return ai:GenerateGUID(false)
end

local ao=aa.GenerateGUID()

an.InputBegan:Connect(function(ap,aq)




task.defer(function()
if
ap.UserInputType==Enum.UserInputType.MouseButton1
or ap.UserInputType==Enum.UserInputType.Touch
then
if aa.CurrentInput and aa.CurrentInput~=ao then
return
end

aa.CurrentInput=ao


end
end)
end)
an.InputEnded:Connect(function(ap,aq)
if ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch then
if aa.CurrentInput and aa.CurrentInput~=ao then
return
end

aa.CurrentInput=nil
end
end)

local ap=ak.LocalPlayer or nil

local aq=ai:JSONDecode(a.load'm')
if aq then
aa.Version=aq.version
end

local ar=a.load'q'
local as=a.load'r'

local at=aa.Creator

local au=at.New




local av=a.load'v'

local aw=protectgui or(syn and syn.protect_gui)or function()end

local ax=gethui and gethui()or(al or ap:WaitForChild"PlayerGui")

local ay=au("UIScale",{
Scale=aa.UIScale,
})

aa.UIScaleObj=ay

aa.ScreenGui=au("ScreenGui",{
Name="WindUI",
Parent=ax,
IgnoreGuiInset=true,
ScreenInsets="None",
DisplayOrder=-99999,
},{

au("Folder",{
Name="Window",
}),






au("Folder",{
Name="KeySystem",
}),
au("Folder",{
Name="Popups",
}),
au("Folder",{
Name="ToolTips",
}),
})

aa.NotificationGui=au("ScreenGui",{
Name="WindUI/Notifications",
Parent=ax,
IgnoreGuiInset=true,
})
aa.DropdownGui=au("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=ax,
IgnoreGuiInset=true,
})
aa.TooltipGui=au("ScreenGui",{
Name="WindUI/Tooltips",
Parent=ax,
IgnoreGuiInset=true,
})
aw(aa.ScreenGui)
aw(aa.NotificationGui)
aw(aa.DropdownGui)
aw(aa.TooltipGui)

at.Init(aa)

function aa.SetParent(az,aA)
if aa.ScreenGui then
aa.ScreenGui.Parent=aA
end
if aa.NotificationGui then
aa.NotificationGui.Parent=aA
end
if aa.DropdownGui then
aa.DropdownGui.Parent=aA
end
if aa.TooltipGui then
aa.TooltipGui.Parent=aA
end
end
math.clamp(aa.TransparencyValue,0,1)

local az=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(aA,aB)
aB.Holder=az.Frame
aB.Window=aa.Window

return aa.NotificationModule.New(aB)
end

function aa.SetNotificationLower(aA,aB)
az.SetLower(aB)
end

function aa.LoadingScreen(aA,aB)
return as.new(aa,aB)
end

function aa.LoadingCreate(aA,aB)
if aa.ActiveLoading and not aa.ActiveLoading.Closed then
aa.ActiveLoading:Close(0)
end

aa.ActiveLoading=as.new(aa,aB)
return aa.ActiveLoading
end

function aa.LoadingSet(aA,aB,b)
local d=aa.ActiveLoading
if not d or d.Closed then
d=aa:LoadingCreate{}
end

if typeof(aB)=="table"then
if aB.Status or aB.Text or aB.Title then
d:SetStatus(aB.Status or aB.Text or aB.Title)
end
if aB.Progress~=nil or aB.Value~=nil then
d:SetProgress(aB.Progress~=nil and aB.Progress or aB.Value)
end
if aB.Step then
d:Step(aB.Step,aB.Status or aB.Text)
end
if aB.Close then
d:Close(aB.Delay or aB.CloseDelay or 0)
end
return d
end

if typeof(aB)=="number"then
d:SetProgress(aB)
if b then
d:SetStatus(b)
end
elseif aB~=nil then
d:SetStatus(aB)
if typeof(b)=="number"then
d:SetProgress(b)
end
end

return d
end

function aa.SetFont(aA,aB)
at.UpdateFont(aB)
end

function aa.SetMotionPreset(aA,aB)
return aa.Motion:SetPreset(aB)
end

function aa.SetReducedMotion(aA,aB)
return aa.Motion:SetReducedMotion(aB)
end

function aa.OnThemeChange(aA,aB)
aa.OnThemeChangeFunction=aB
end

function aa.AddTheme(aA,aB)
aa.Themes[aB.Name]=aB
return aB
end

function aa.SetTheme(aA,aB)
if aa.Themes[aB]then
aa.Theme=aa.Themes[aB]
at.SetTheme(aa.Themes[aB])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(aB)
end

return aa.Themes[aB]
end
return nil
end

function aa.GetThemes(aA)
return aa.Themes
end
function aa.GetCurrentTheme(aA)
return aa.Theme.Name
end
function aa.GetTransparency(aA)
return aa.Transparent or false
end
function aa.GetWindowSize(aA)
return aa.Window.UIElements.Main.Size
end
function aa.Localization(aA,aB)
return aa.LocalizationModule:New(aB,at)
end

function aa.SetLanguage(aA,aB)
if at.Localization then
return at.SetLanguage(aB)
end
return false
end

function aa.ToggleAcrylic(aA,aB)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=aB
aa.Window.AcrylicPaint.Model.Transparency=aB and 0.98 or 1
if aB then
av.Enable()
else
av.Disable()
end
end
end

function aa.Gradient(aA,aB,b)
local d={}
local f={}

for g,h in next,aB do
local i=tonumber(g)
if i then
i=math.clamp(i/100,0,1)

local l=h.Color
if typeof(l)=="string"and string.sub(l,1,1)=="#"then
l=Color3.fromHex(l)
end

local m=h.Transparency or 0

table.insert(d,ColorSequenceKeypoint.new(i,l))
table.insert(f,NumberSequenceKeypoint.new(i,m))
end
end

table.sort(d,function(g,h)
return g.Time<h.Time
end)
table.sort(f,function(g,h)
return g.Time<h.Time
end)

if#d<2 then
table.insert(d,ColorSequenceKeypoint.new(1,d[1].Value))
table.insert(f,NumberSequenceKeypoint.new(1,f[1].Value))
end

local g={
Color=ColorSequence.new(d),
Transparency=NumberSequence.new(f),
}

if b then
for h,i in pairs(b)do
g[h]=i
end
end

return g
end

function aa.Popup(aA,aB)
aB.WindUI=aa
return a.load'w'.new(aB,aa.ScreenGui.Popups)
end

aa.Themes=a.load'x'(aa,at)

at.Themes=aa.Themes

aa:SetTheme"Dark"
aa:SetLanguage(at.Language)

function aa.CreateWindow(aA,aB)
local b=a.load'aH'

if not am:IsStudio()and writefile then
if not isfolder"WindUI"then
makefolder"WindUI"
end
if aB.Folder then
makefolder(aB.Folder)
else
makefolder(aB.Title)
end
end

aB.WindUI=aa
aB.Window=aa.Window
aB.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

aa.Motion:Configure(aB.Motion)

local d=true
local f=aB.LoadingScreen or aB.Loader or aB.Loading
local g

local function OpenLoader(h,i)
if f==nil or f==false then
return nil
end

if not g then
local l={}
if typeof(f)=="table"then
for m,p in next,f do
l[m]=p
end
end

l.Title=l.Title or aB.Title or"WindUI"
l.Desc=l.Desc or"Loading interface"
l.Icon=l.Icon or aB.Icon or"sparkles"
l.Folder=l.Folder or aB.Folder
g=as.new(aa,l)
end

if h then
g:SetStatus(h)
end
if i then
g:SetProgress(i)
end

return g
end

if not aB.KeySystem then
OpenLoader("Preparing interface",0.16)
end

local h=aa.Themes[aB.Theme or"Dark"]


at.SetTheme(h)

local i=gethwid or function()
return ak.LocalPlayer.UserId
end

local l=i()

local function PickField(m,p)
for r,u in next,p do
if m[u]~=nil then
return m[u]
end
end
return nil
end

local function NormalizeServiceType(m)
local p=string.lower(tostring(m or""))
p=string.gsub(p,"%s+","")
p=string.gsub(p,"[_%-%./]","")

local r={
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

return r[p]or p
end

local function NormalizeKeySystemAPI()
if not aB.KeySystem or typeof(aB.KeySystem.API)~="table"then
return
end

local m=aB.KeySystem.API
local p=m
if m.Type or m.type or m.Service or m.service then
p={m}
end

local r={}
for u,v in next,p do
if typeof(v)=="table"then
local x={}
for z,A in next,v do
x[z]=A
end

x.Type=NormalizeServiceType(PickField(v,{
"Type",
"type",
"Service",
"service",
"Provider",
"provider",
}))

x.ScriptId=PickField(v,{
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
})or x.ScriptId

x.ServiceId=PickField(v,{
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
})or x.ServiceId

x.Discord=PickField(v,{
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
})or x.Discord

x.Secret=PickField(v,{
"Secret",
"secret",
"ApiSecret",
"APISecret",
"apiSecret",
"api_secret",
})or x.Secret

x.ApiKey=PickField(v,{
"ApiKey",
"APIKey",
"apiKey",
"api_key",
"Key",
"key",
})or x.ApiKey

if x.Type and x.Type~=""then
table.insert(r,x)
end
end
end

aB.KeySystem.API=r
end

NormalizeKeySystemAPI()

if aB.KeySystem then
d=false

local function loadKeysystem()
ar.new(aB,l,function(m)
d=m
end)
end

local m=(aB.Folder or"Temp").."/"..l..".key"

if aB.KeySystem.KeyValidator then
if aB.KeySystem.SaveKey and isfile(m)then
local p=readfile(m)
local r=aB.KeySystem.KeyValidator(p)

if r then
d=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not aB.KeySystem.API then
if aB.KeySystem.SaveKey and isfile(m)then
local p=readfile(m)
local r=(type(aB.KeySystem.Key)=="table")and table.find(aB.KeySystem.Key,p)
or tostring(aB.KeySystem.Key)==tostring(p)

if r then
d=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(m)then
local p=readfile(m)
local r=false

for u,v in next,aB.KeySystem.API do
local x=aa.Services[v.Type]
if x then
local z={}
for A,B in next,x.Args do
table.insert(z,v[B])
end

local A=x.New(table.unpack(z))
local B=A.Verify(p)
if B then
r=true
break
end
end
end

d=r
if not r then
loadKeysystem()
end
else
loadKeysystem()
end
end

repeat
task.wait()
until d

OpenLoader("Access granted",0.42)
end

OpenLoader("Building window",0.72)
local m=b(aB)

aa.Transparent=aB.Transparent
aa.Window=m

if aB.Acrylic then
av.init()
end

if g then
g:SetStatus"Ready"
g:SetProgress(1)
g:Close((typeof(f)=="table"and f.CloseDelay)or 0.18)
end













return m
end

return aa