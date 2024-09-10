local text = require("UI.Text")
local button = require("UI.Button")

local CycleList = {
	x = 0,
	y = 0,
	func = nil,
	offset_x = 0,
	offset_y = 0,
	horizontal_align = HORIZONTAL_ALIGN.LEFT,
	vertical_align = VERTICAL_ALIGN.TOP,
	list = {},
	list_text = nil,
	left_button = nil,
	right_button = nil,
}
CycleList.__index = CycleList

local left_button_func = function()
	print("Left button pressed")
end

local right_button_func = function()
	print("Right button pressed")
end

function CycleList.new(list, func, horizontal_align, vertical_align, offset_x, offset_y)
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

	local first_item = "Empty"
	if list then
		first_item = list[0]
	end

	return setmetatable({
		x = x or 0,
		y = y or 0,
		func = func or function()
			print("No Function")
		end,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		horizontal_align = horizontal_align or HORIZONTAL_ALIGN.LEFT,
		vertical_align = vertical_align or VERTICAL_ALIGN.TOP,
		list = list or {},
		list_text = text.new(first_item, 1, horizontal_align, vertical_align, offset_x, offset_y) or text.new(),
		left_button = button.new(
			50,
			50,
			"<",
			left_button_func,
			nil,
			horizontal_align,
			vertical_align,
			offset_x - 55,
			offset_y
		) or nil,
		right_button = button.new(
			50,
			50,
			">",
			right_button_func,
			nil,
			horizontal_align,
			vertical_align,
			offset_x + 55,
			offset_y
		) or nil,
	}, CycleList)
end

function CycleList:check_pressed(mouse_x, mouse_y)
	self.left_button:check_pressed(mouse_x, mouse_y)
	self.right_button:check_pressed(mouse_x, mouse_y)
end

function CycleList:auto_resize_x()
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

function CycleList:auto_resize_y()
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

function CycleList:draw()
	love.graphics.setColor(1, 1, 1, 0.8)
	self.list_text:draw()
	self.left_button:draw()
	self.right_button:draw()
end

function CycleList.unload()
	setmetatable(CycleList, nil)
end

return CycleList
