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
}
CycleList.__index = CycleList

local current_element_index = 1
local max_element_index = 1
local list = {}
local ui_text

local buttons_size = 30
local button_offset = 55

local left_button_func = function()
	print("Left button pressed")

	current_element_index = current_element_index - 1
	if current_element_index < 1 then
		current_element_index = max_element_index
	end

	ui_text.text = list[current_element_index]
end

local right_button_func = function()
	print("Right button pressed")

	current_element_index = current_element_index + 1
	if current_element_index > max_element_index then
		current_element_index = 1
	end

	ui_text.text = list[current_element_index]
end

function CycleList.new(
	items,
	func,
	horizontal_align,
	vertical_align,
	offset_x,
	offset_y,
	text_color,
	button_color,
	text_button_color
)
	local x = offset_x or 0
	local y = offset_y or 0
	list = items

	if horizontal_align == HORIZONTAL_ALIGN.RIGHT then
		x = x + love.graphics:getWidth()
		offset_x = offset_x - button_offset - (buttons_size / 2)
	elseif horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
	end

	if vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	local first_item = "Empty"
	if items then
		first_item = items[1]
		max_element_index = #items
	end

	local ui_text_color = text_color or COLOR.WHITE
	ui_text = text.new(first_item, 1, horizontal_align, vertical_align, offset_x, offset_y, ui_text_color) or text.new()

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
		left_button = button.new(
			buttons_size,
			buttons_size,
			"<",
			left_button_func,
			nil,
			horizontal_align,
			vertical_align,
			offset_x - button_offset,
			offset_y,
			button_color,
			text_button_color
		) or button.new(),
		right_button = button.new(
			buttons_size,
			buttons_size,
			">",
			right_button_func,
			nil,
			horizontal_align,
			vertical_align,
			offset_x + button_offset,
			offset_y,
			button_color,
			text_button_color
		) or button.new(),
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
	elseif self.horizontal_align == HORIZONTAL_ALIGN.CENTER then
		x = (love.graphics:getWidth() / 2) + x
	end

	self.x = x
	ui_text:auto_resize_x()
	self.left_button:auto_resize_x()
	self.right_button:auto_resize_x()
end

function CycleList:auto_resize_y()
	local y = self.offset_y

	if self.vertical_align == VERTICAL_ALIGN.BOTTOM then
		y = y + love.graphics:getHeight()
	elseif self.vertical_align == VERTICAL_ALIGN.CENTER then
		y = (love.graphics:getHeight() / 2) + y
	end

	self.y = y
	ui_text:auto_resize_y()
	self.left_button:auto_resize_y()
	self.right_button:auto_resize_y()
end

function CycleList:draw()
	ui_text:draw()
	self.left_button:draw()
	self.right_button:draw()
end

function CycleList.unload()
	setmetatable(CycleList, nil)
end

return CycleList
