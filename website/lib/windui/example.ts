export default `local Window = WindUI:CreateWindow({
	Title = "Example",
	Theme = "Dark",
	Size = UDim2.new(0, 840, 0, 500),
	MinSize = Vector2.new(815, 400),
	MaxSize = Vector2.new(1000, 700),
	ToggleKey = Enum.KeyCode.RightShift,
})

local Tab = Window:Tab({
	Title = "Tab 1",
})`;
