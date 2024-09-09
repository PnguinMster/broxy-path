require("Utility.AlignEnum")
require("Utility/Math")

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
	handle_offset_postion = 0,
	bar_min_position = 0,
	bar_max_position = 0,
	is_dragging_slider = false,
	value = 0,
	min_value = 0,
	max_value = 10,
}
Slider.__index = Slider

function Slider.new(
	start_value,
	min_value,
	max_value,
	handle_radius,
	bar_width,
	bar_height,
	func,
	horizontal_align,
	vertical_align,
	offset_x,
	offset_y
)
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
	local bar_min_position = x - bar_offset_x
	local bar_max_position = x + bar_offset_x

	print("bar widht is:" .. bar_min_position)
	print("bar height is:" .. bar_max_position)

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
		bar_min_position = bar_min_position or 0,
		bar_max_position = bar_max_position or 0,
		value = start_value or 0,
		min_value = min_value or 0,
		max_value = max_value or 0,
	}, Slider)
end

function Slider:check_pressed(mouse_x, mouse_y)
	local offset = self.handle_radius
	print("check pressed")

	if
		mouse_x <= self.x + offset + self.handle_offset_postion
		and mouse_x >= self.x - offset + self.handle_offset_postion
		and mouse_y <= self.y + offset
		and mouse_y >= self.y - offset
	then
		self.is_dragging_slider = true
	end
end

function Slider:mouse_moved(x)
	if self.is_dragging_slider == true then
		local offset = x - self.x
		local position = self.x + offset

		if position <= self.bar_min_position then
			self.handle_offset_postion = -self.bar_offset_x
		elseif position > self.bar_max_position then
			self.handle_offset_postion = self.bar_offset_x
		else
			self.handle_offset_postion = offset
		end
	end
end

function Slider:mouse_released()
	print(" mouse releades")
	self.is_dragging_slider = false
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
	love.graphics.circle("line", self.x + self.handle_offset_postion, self.y, self.handle_radius)
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
