-- ImageSurface.lua
-- Ported from Cascade (cascadeui/Cascade, src/components/ImageSurface/{init,ui}.luau)
-- and adapted from Cascade's `create()` + binder convention to VynxUI's own
-- Creator.New/ThemeTag convention (same adaptation Symbol.lua and
-- TitleStack.lua already went through). A small rounded "card" that frames
-- an icon/image with a subtle diagonal gradient behind it -- used by Cascade
-- for app-icon-style thumbnails (Dock icons, file/app rows).
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local Size = Config.Size or UDim2.fromOffset(26, 26)
	local ImageSize = Config.ImageSize or UDim2.fromOffset(20, 20)
	local Rounding = Config.Rounding or UDim.new(0, 5)
	local ShowGradient = Config.Gradient ~= false

	local Image = New("ImageLabel", {
		Name = "Image",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = ImageSize,
		BackgroundTransparency = 1,
		Image = Config.Image or "",
		ScaleType = Config.ScaleType or Enum.ScaleType.Fit,
		ThemeTag = {
			ImageColor3 = "White",
		},
	})

	local Gradient = New("UIGradient", {
		Name = "UIGradient",
		Rotation = Config.GradientRotation or 90,
		Enabled = ShowGradient,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190)),
		}),
	})

	local Corner = New("UICorner", {
		CornerRadius = Rounding,
	})

	local Surface = New("Frame", {
		Name = "Surface",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -2, 1, -2),
		BorderSizePixel = 0,
		ThemeTag = {
			BackgroundColor3 = "ImageSurfaceBackground",
		},
	}, { Image, Corner, Gradient })

	local SurfaceFrame = New("Frame", {
		Name = "ImageSurface",
		Parent = Config.Parent,
		Size = Size,
		BackgroundTransparency = 1,
	}, { Surface })

	local ImageSurface = {
		__type = "ImageSurface",
		UIElements = { Surface = Surface, Image = Image, Gradient = Gradient },
		ElementFrame = SurfaceFrame,
	}

	function ImageSurface:SetImage(image)
		Image.Image = image
	end

	function ImageSurface:SetGradient(enabled)
		Gradient.Enabled = enabled and true or false
	end

	function ImageSurface:SetSurfaceColor(color)
		-- Per-instance override; a later theme switch will re-apply the
		-- ThemeTag color unless the caller calls this again after switching.
		Surface.BackgroundColor3 = color
	end

	return ImageSurface.__type, ImageSurface
end

return Element
