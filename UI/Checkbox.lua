require("Utility.AlignEnum")

local Checkbox = {
	checked = false,
	offset_x = 0,
	offset_y = 0,
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
	x = 0,
	y = 0,
	box_size = 0,
	check_size = 0,
}
Checkbox.__index = Checkbox

local check_scale = 0.8
local default_size = 25

function Checkbox.new(checked, scale, horizontal_align, vertical_align, offset_x, offset_y)
	local x = offset_x or 0
	local y = offset_y or 0
	local box_size = default_size * scale
	local check_size = box_size * check_scale

	x = x - (box_size / 2)
	y = y - (box_size / 2)

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

	return setmetatable({
		checked = checked or false,
		x = x or 0,
		y = y or 0,
		scale = scale or 1,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
		box_size = box_size or default_size,
		check_size = check_size or default_size * check_size,
	}, Checkbox)
end

function Checkbox:is_checked()
	return self.checked
end

function Checkbox:check_pressed(mouse_x, mouse_y)
	local offset_x = self.box_size / 2
	local offset_y = self.box_size / 2

	if
		mouse_x <= self.x + offset_x
		and mouse_x >= self.x - offset_x
		and mouse_y <= self.y + offset_y
		and mouse_y >= self.y - offset_y
	then
		self.checked = not self.checked
	end
end

function Checkbox:auto_resize_x()
	local x = self.offset_x - (self.box_size / 2)

	if self.horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
	elseif self.horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
	end

	self.x = x
end

function Checkbox:auto_resize_y()
	local y = self.offset_y - (self.box_size / 2)

	if self.vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif self.vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	self.y = y
end

function Checkbox:draw()
	love.graphics.rectangle("line", self.x, self.y, self.box_size, self.box_size)

	if self.checked then
		love.graphics.rectangle("fill", self.x, self.y, self.check_size, self.check_size)
	end
end

function Checkbox.unload()
	setmetatable(Checkbox, nil)
end

return Checkbox
