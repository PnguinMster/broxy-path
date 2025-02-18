require("Utility.ColorEnum")
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
		local font = love.graphics:getFont()
		local text_width = font:getWidth(text_block)
		text_offset_x = text_offset_x + (width / 2) - (text_width / 2)
	end

	--align button vertically
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
		text_block = text.new(
			text_block,
			1,
			horizontal_align,
			vertical_align,
			text_offset_x,
			text_offset_y,
			text_color
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
	if self.is_disabled then
		return
	end

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
	self.text_block:auto_resize_x()
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
	self.text_block:auto_resize_y()
end

function Button:draw()
	if self.is_disabled then
		local r, g, b = self.button_color:rgb_color()
		love.graphics.setColor(r, g, b, 0.5)
	else
		love.graphics.setColor(self.button_color:rgb_color())
	end

	if self.is_hovered or self.is_disabled then
		love.graphics.rectangle("fill", self.x - 2, self.y - 2, self.width + 4, self.height + 4)
	else
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
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
