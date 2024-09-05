local text = require("UI.Text")

local Button = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	text = nil,
	func = nil,
	func_param = nil,
	offset_x = 0,
	offset_y = 0,
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
}
Button.__index = Button

function Button.new(width, height, string, func, func_param, horizontal_align, vertical_align, offset_x, offset_y)
	local x = offset_x or 0
	local y = offset_y or 0
	local text_offset_x = offset_x or 0
	local text_offset_y = offset_y or 0

	if horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
		x = x - width / 2
	elseif horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
		x = x - width / 2
	elseif horizontal_align == HORIZONTAL_ALIGN.LEFT then
		local font = love.graphics:getFont()
		local text_width = font:getWidth(string)
		text_offset_x = text_offset_x + (width / 2) - (text_width / 2)
	end

	if vertical_align == VERTICAL_ALIGN.BOTTOM then
		local font = love.graphics:getFont()
		local text_height = font:getHeight()
		text_offset_y = text_offset_y + (text_height / 2)
		y = y + love.graphics:getHeight()
		y = y - height / 2
	elseif vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
		y = y - height / 2
	end

	return setmetatable({
		x = x or 0,
		y = y or 0,
		width = width or 0,
		height = height or 0,
		string = text.new(string, nil, horizontal_align, vertical_align, text_offset_x, text_offset_y) or text.new(),
		func = func or function()
			print("No Function")
		end,
		func_param = func_param or nil,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
	}, Button)
end

function Button:check_pressed(mouse_x, mouse_y)
	local offset_x = self.width
	local offset_y = self.height

	if mouse_x <= self.x + offset_x and mouse_x >= self.x and mouse_y <= self.y + offset_y and mouse_y >= self.y then
		self.func(self.func_param)
	end
end

function Button:auto_resize_x()
	local x = self.offset_x

	if self.horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
		x = x - self.width / 2
	elseif self.horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
		x = x - self.width / 2
	end

	self.x = x
	self.string:auto_resize_x()
end

function Button:auto_resize_y()
	local y = self.offset_y

	if self.vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
		y = y - self.height / 2
	elseif self.vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
		y = y - self.height / 2
	end

	self.y = y
	self.string:auto_resize_y()
end

function Button:draw()
	love.graphics.setColor(1, 1, 1, 0.8)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(love.math.colorFromBytes(25, 18, 28))
	self.string:draw()
end

function Button.unload()
	setmetatable(Button, nil)
end

return Button
