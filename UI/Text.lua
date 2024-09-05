require("Utility.AlignEnum")

local Text = {
	text = "",
	offset_x = 0,
	offset_y = 0,
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
	x = 0,
	y = 0,
	scale = 1,
	origin_offset_x = 0,
	origin_offset_y = 0,
}
Text.__index = Text

function Text.new(text, scale, horizontal_align, vertical_align, offset_x, offset_y)
	local font = love.graphics:getFont()
	local text_width = font:getWidth(text)
	local text_height = font:getHeight()
	local x = offset_x or 0
	local y = offset_y or 0

	if horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
	elseif horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
		text_width = text_width / 2
	else -- horizontal_align == TEXT_HORIZONTAL_ALIGN.LEFT
		text_width = 0
	end

	if vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
		text_height = text_height / 2
	else -- vertical_align == TEXT_VERTICAL_ALIGN.TOP
		text_height = 0
	end

	return setmetatable({
		x = x or 0,
		y = y or 0,
		scale = scale or 1,
		origin_offset_x = text_width or 0,
		origin_offset_y = text_height or 0,
		text = text or "Text",
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
	}, Text)
end

function Text:auto_resize_x()
	local x = self.offset_x

	if self.horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
	elseif self.horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
	end

	self.x = x
end

function Text:auto_resize_y()
	local y = self.offset_y

	if self.vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif self.vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	self.y = y
end

function Text:draw()
	love.graphics.print(
		self.text,
		self.x,
		self.y,
		0,
		self.scale,
		self.scale,
		self.origin_offset_x,
		self.origin_offset_y
	)
end

function Text.unload()
	setmetatable(Text, nil)
end

return Text
