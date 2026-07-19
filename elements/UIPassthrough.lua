local Element = {}

function Element:New(Config)
	assert(Config.Instance, "UIPassthrough: Instance must be provided")
	assert(
		typeof(Config.Instance) == "Instance" and Config.Instance:IsA("GuiBase2d"),
		"UIPassthrough: Instance must inherit GuiBase2d"
	)
	local height = Config.Height or 60
	assert(typeof(height) == "number" and height > 0, "UIPassthrough: Height must be > 0")

	local Passthrough = {
		__type   = "UIPassthrough",
		Type     = "UIPassthrough",
		Instance = Config.Instance,
		Height   = height,
		Visible  = Config.Visible ~= false,
	}

	local Holder
	do
		local New = function(cls, props)
			local inst = Instance.new(cls)
			for k, v in props do inst[k] = v end
			return inst
		end
		Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size    = UDim2.new(1, 0, 0, height),
			Visible = Passthrough.Visible,
			Parent  = Config.Parent,
		})
	end

	Config.Instance.Parent = Holder

	function Passthrough:SetHeight(h)
		assert(typeof(h) == "number" and h > 0, "Height must be > 0")
		Passthrough.Height = h
		Holder.Size = UDim2.new(1, 0, 0, h)
	end

	function Passthrough:SetInstance(inst)
		assert(inst and typeof(inst) == "Instance" and inst:IsA("GuiBase2d"),
			"Instance must inherit GuiBase2d")
		if Passthrough.Instance then Passthrough.Instance.Parent = nil end
		Passthrough.Instance = inst
		inst.Parent = Holder
	end

	function Passthrough:SetVisible(v)
		Passthrough.Visible = v
		Holder.Visible = v
	end

	function Passthrough:Destroy()
		if Holder then Holder:Destroy() end
	end

	Passthrough.Holder       = Holder
	Passthrough.ElementFrame = Holder
	return Holder, Passthrough
end

return Element
