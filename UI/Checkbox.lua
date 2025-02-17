require("Utility.ColorEnum")
require("Utility.AlignEnum")

local Checkbox = {
	checked = false,
	offset_x = 0,
	offset_y = 0,
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
	x = 0,
	y = 0,
	func = nil,
	box_size = 0,
	check_size = 0,
	check_offset = 0,
	is_hovered = false,
}
Checkbox.__index = Checkbox

local check_scale = 0.8
local default_size = 25

function Checkbox.new(
	checked,
	scale,
	func,
	horizontal_align,
	vertical_align,
	offset_x,
	offset_y,
	outer_color,
	inner_color
)
	--set parameters to local variables
	local x = offset_x or 0
	local y = offset_y or 0
	local box_size = default_size * scale
	local check_size = box_size * check_scale

	--offset position based of box size
	x = x - (box_size / 2)
	y = y - (box_size / 2)

	--align horizontally
	if horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
		x = x - (box_size / 2)
	elseif horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
	end

	--align vertically
	if vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	local check_offset = (box_size - check_size) / 2

	return setmetatable({
		checked = checked or false,
		x = x or 0,
		y = y or 0,
		scale = scale or 1,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		func = func or function()
			print("No Function")
		end,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
		box_size = box_size or default_size,
		check_size = check_size or default_size * check_size,
		check_offset = check_offset,
		outer_color = outer_color or COLOR.WHITE,
		inner_color = inner_color or outer_color or COLOR.WHITE,
	}, Checkbox)
end

function Checkbox:check_pressed(mouse_x, mouse_y)
	local offset = self.box_size

	if mouse_x <= self.x + offset and mouse_x >= self.x and mouse_y <= self.y + offset and mouse_y >= self.y then
		self.checked = not self.checked
		self.func(self.checked)
	end
end

function Checkbox:check_is_hovered(mouse_x, mouse_y)
	local offset = self.box_size

	if mouse_x <= self.x + offset and mouse_x >= self.x and mouse_y <= self.y + offset and mouse_y >= self.y then
		return self
	end

	return nil
end

function Checkbox:set_hovered(hovered)
	self.is_hovered = hovered
end

function Checkbox:auto_resize_x()
	local x = self.offset_x - (self.box_size / 2)

	if self.horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
		x = x - (self.box_size / 2)
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
	love.graphics.setColor(self.outer_color:rgb_color())
	if self.is_hovered then
		love.graphics.rectangle("line", self.x - 2, self.y - 2, self.box_size + 4, self.box_size + 4)
	else
		love.graphics.rectangle("line", self.x, self.y, self.box_size, self.box_size)
	end

	if self.checked then
		love.graphics.setColor(self.inner_color:rgb_color())
		love.graphics.rectangle(
			"fill",
			self.x + self.check_offset,
			self.y + self.check_offset,
			self.check_size,
			self.check_size
		)
	end
end

function Checkbox:unload() end

return Checkbox
