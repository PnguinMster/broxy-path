require("Utility.AlignEnum")

local Slider = {
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
	x = 0,
	y = 0,
	bar_offset_x = 0,
	bar_offset_y = 0,
	handle_radius = 0,
	bar_height = 0,
	bar_width = 0,
	func = nil,
}
Slider.__index = Slider
local is_dragging_slider = false

function Slider.new(handle_radius, bar_width, bar_height, func, horizontal_align, vertical_align, offset_x, offset_y)
	local x = offset_x or 0
	local y = offset_y or 0

	if horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
	elseif horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
	end

	if vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	local bar_offset_x = bar_width / 2
	local bar_offset_y = bar_height / 2

	return setmetatable({
		x = x or 0,
		y = y or 0,
		handle_radius = handle_radius or 0,
		bar_height = bar_height or 0,
		bar_width = bar_width or 0,
		bar_offset_x = bar_offset_x or 0,
		bar_offset_y = bar_offset_y or 0,
		func = func or function()
			print("No Function")
		end,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
	}, Slider)
end

function Slider:check_pressed(mouse_x, mouse_y)
	local offset = self.handle_radius

	if mouse_x <= self.x + offset and mouse_x >= self.x and mouse_y <= self.y + offset and mouse_y >= self.y then
		is_dragging_slider = true
	end
end

function Slider:mouse_moved(x, y)
	if is_dragging_slider == true then

	end
end

function Slider:mouse_released()
	is_dragging_slider = false
end

function Slider:auto_resize_x()
	local x = self.offset_x - (self.box_size / 2)

	if self.horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
	elseif self.horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
	end

	self.x = x
end

function Slider:auto_resize_y()
	local y = self.offset_y - (self.box_size / 2)

	if self.vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif self.vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	self.y = y
end

function Slider:draw()
	love.graphics.setColor(1, 1, 1, 0.8)
	love.graphics.circle("line", self.x, self.y, self.handle_radius)
	love.graphics.rectangle(
		"line",
		self.x - self.bar_offset_x,
		self.y - self.bar_offset_y,
		self.bar_width,
		self.bar_height
	)
end

function Slider.unload()
	setmetatable(Slider, nil)
end

return Slider
