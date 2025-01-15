require("Utility.AlignEnum")
require("Utility.Math")
require("Utility.ColorEnum")

local function handle_to_value(handle_x, bar_width, min_value, max_value)
	local ratio = handle_x / bar_width
	return min_value + ratio * (max_value - min_value)
end

local function value_to_handle(value, bar_width, min_value, max_value)
	local ratio = (value - min_value) / (max_value - min_value)
	return ratio * bar_width
end

local Slider = {
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
	x = 0,
	y = 0,
	offset_x = 0,
	offset_y = 0,
	handle_radius = 0,
	bar_height = 0,
	bar_width = 0,
	func = nil,
	handle_offset_postion = 0,
	bar_max_position = 0,
	is_dragging_slider = false,
	handle_drag_offset = 0,
	value = 0,
	min_value = 0,
	max_value = 10,
	is_hovered = false,
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
	offset_y,
	bar_color,
	handle_color
)
	local x = offset_x or 0
	local y = offset_y or 0

	if horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth() - bar_width
		x = x - handle_radius
	elseif horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x - (bar_width / 2)
	end

	if vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	local bar_max_position = x + bar_width
	local handle_drag_offset = value_to_handle(start_value, bar_width, min_value, max_value)

	return setmetatable({
		x = x or 0,
		y = y or 0,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		handle_radius = handle_radius or 0,
		bar_height = bar_height or 0,
		bar_width = bar_width or 0,
		handle_offset_postion = handle_drag_offset,
		func = func or function()
			print("No Function")
		end,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
		bar_max_position = bar_max_position or 0,
		value = start_value or 0,
		min_value = min_value or 0,
		max_value = max_value or 0,
		bar_color = bar_color or COLOR.WHITE,
		handle_color = handle_color or bar_color or COLOR.WHITE,
	}, Slider)
end

function Slider:check_held(mouse_x, mouse_y)
	local offset = self.handle_radius

	if
		mouse_x <= self.x + offset + self.handle_offset_postion
		and mouse_x >= self.x - offset + self.handle_offset_postion
		and mouse_y <= self.y + offset
		and mouse_y >= self.y - offset
	then
		self.is_dragging_slider = true
		self.handle_drag_offset = (self.x + self.handle_offset_postion) - mouse_x
	end
end

function Slider:check_is_hovered(mouse_x, mouse_y)
	local offset = self.handle_radius

	if
		mouse_x <= self.x + offset + self.handle_offset_postion
		and mouse_x >= self.x - offset + self.handle_offset_postion
		and mouse_y <= self.y + offset
		and mouse_y >= self.y - offset
	then
		return self
	end

	return nil
end

function Slider:set_hovered(hovered)
	self.is_hovered = hovered
end

function Slider:mouse_moved(x)
	if self.is_dragging_slider == true then
		local offset = x - self.x + self.handle_drag_offset
		local position = self.x + offset

		if position <= self.x then
			self.handle_offset_postion = 0
		elseif position > self.bar_max_position then
			self.handle_offset_postion = self.bar_width
		else
			self.handle_offset_postion =
				math.round_to_nearest_step(offset, 0, self.bar_width, self.max_value - self.min_value)
		end

		self.value = handle_to_value(self.handle_offset_postion, self.bar_width, self.min_value, self.max_value)
		self.func(self.value)
	end
end

function Slider:mouse_released()
	print(" mouse releades")
	self.is_dragging_slider = false
end

function Slider:auto_resize_x()
	local x = self.offset_x

	if self.horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth() - self.bar_width
	elseif self.horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x - (self.bar_width / 2)
	end

	self.x = x
end

function Slider:auto_resize_y()
	local y = self.offset_y

	if self.vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif self.vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	self.y = y
end

function Slider:draw()
	love.graphics.setColor(love.math.colorFromBytes(235, 237, 233))
	if self.is_hovered then
		love.graphics.circle("line", self.x + self.handle_offset_postion - 1, self.y - 1, self.handle_radius + 2)
	else
		love.graphics.circle("line", self.x + self.handle_offset_postion, self.y, self.handle_radius)
	end
	love.graphics.rectangle("line", self.x, self.y - (self.bar_height / 2), self.bar_width, self.bar_height)
end

function Slider:unload() end

return Slider
