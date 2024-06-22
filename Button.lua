local Button = { x = 0, y = 0, width = 0, height = 0, text = "", func = nil, func_param = nil }
Button.__index = Button

function Button.new(x, y, width, height, text, func, func_param)
	return setmetatable({
		x = x or 0,
		y = y or 0,
		width = width or 0,
		height = height or 0,
		text = text or "Text",
		func = func or function()
			print("No Function")
		end,
		func_param = func_param or nil,
	}, Button)
end

function Button:check_pressed(mouse_x, mouse_y)
	local offset_x = self.width / 2
	local offset_y = self.height / 2

	if
		mouse_x <= self.x + offset_x
		and mouse_x >= self.x - offset_x
		and mouse_y <= self.y + offset_y
		and mouse_y >= self.y - offset_y
	then
		self.func(self.func_param)
	end
end

function Button:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.widht, self.height)
	love.graphics.print(self.text, self.x, self.y)
end

return Button
