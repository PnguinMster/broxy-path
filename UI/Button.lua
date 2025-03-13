require("Utility.ColorEnum")
require("Utility.FontScaleEnum")
local text = require("UI.Text")

local Button = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	text_block = {},
	func = nil,
	func_param = nil,
	offset_x = 0,
	offset_y = 0,
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
	is_hovered = false,
	is_disabled = false,
}
Button.__index = Button

function Button.new(
	width,
	height,
	text_block,
	func,
	func_param,
	horizontal_align,
	vertical_align,
	offset_x,
	offset_y,
	button_color,
	text_color,
	is_disabled
)
	--set local variables from parameters
	local x = offset_x or 0
	local y = offset_y or 0
	local text_offset_x = offset_x or 0
	local text_offset_y = offset_y or 0

	--align button horizontally
	if horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
		x = x - width / 2
	elseif horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
		x = x - width / 2
	elseif horizontal_align == HORIZONTAL_ALIGN.LEFT then
		local text_width = FONT_SCALE.MEDIUM:getWidth(text_block)
		text_offset_x = text_offset_x + (width / 2) - (text_width / 2)
	end

	--align button vertically
	if vertical_align == VERTICAL_ALIGN.BOTTOM then
		local text_height = FONT_SCALE.MEDIUM:getHeight()
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
		text_block = text.new(
			text_block,
			FONT_SCALE.MEDIUM,
			horizontal_align,
			vertical_align,
			text_offset_x,
			text_offset_y,
			text_color,
			is_disabled
		) or text.new(),
		func = func or function()
			print("No Function")
		end,
		func_param = func_param or nil,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
		button_color = button_color or COLOR.WHITE,
		is_disabled = is_disabled,
	}, Button)
end

function Button:check_pressed(mouse_x, mouse_y)
	local offset_x = self.width
	local offset_y = self.height

	if mouse_x <= self.x + offset_x and mouse_x >= self.x and mouse_y <= self.y + offset_y and mouse_y >= self.y then
		self.func(self.func_param)
	end
end

function Button:check_is_hovered(mouse_x, mouse_y)
	local offset_x = self.width
	local offset_y = self.height

	if mouse_x <= self.x + offset_x and mouse_x >= self.x and mouse_y <= self.y + offset_y and mouse_y >= self.y then
		return self
	end

	return nil
end

function Button:set_hovered(hovered)
	self.is_hovered = hovered
end

function Button:set_disabled(is_disabled)
	self.is_disabled = is_disabled
	self.text_block:set_disabled(is_disabled)
end

function Button:auto_resize_x(width)
	local x = self.offset_x

	if self.horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + width
		x = x - self.width / 2
	elseif self.horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (width / 2) + x
		x = x - self.width / 2
	end

	self.x = x
	self.text_block:auto_resize_x(width)
end

function Button:auto_resize_y(height)
	local y = self.offset_y

	if self.vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + height
		y = y - self.height / 2
	elseif self.vertical_align == VERTICAL_ALIGN.CENTER then
		y = (height / 2) + y
		y = y - self.height / 2
	end

	self.y = y
	self.text_block:auto_resize_y(height)
end

function Button:draw()
	love.graphics.setColor(COLOR.BLACK:rgb_color())
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 3, 3)

	local r, g, b = self.button_color:rgb_color()
	local alpha = 1

	if self.is_disabled then
		alpha = 0.5
	end

	love.graphics.setColor(r, g, b, alpha)

	if self.is_hovered then
		love.graphics.rectangle("line", self.x - 2, self.y - 2, self.width + 4, self.height + 4, 1, 3)
	else
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 1, 3)
	end
	self.text_block:draw()
end

function Button:unload()
	-- Unload text
	self.text_block:unload()
	self.text_block = nil

	for k, _ in pairs(self) do
		if k ~= "__index" then
			self[k] = nil
		end
	end
end

return Button
