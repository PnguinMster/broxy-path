local button = require("UI.Button")
local text = require("UI.Text")
local checkbox = require("UI.Checkbox")
local slider = require("UI.Slider")
local cycle_list = require("UI.CycleList")

Option_scene = {}
Option_scene.__index = Option_scene
setmetatable({}, Option_scene)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

local test_list = { "first", "second", "third", "last" }

function Option_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.interactables = {}

	self.start_pressed = function()
		print("Start button pressed")
	end
	self.checkbox_pressed = function(is_checked)
		print("Checkbox pressed")
		print("Value is: " .. tostring(is_checked))
	end
	self.back_pressed = function()
		print("Back pressed")
		Game:set_scene(SCENE.MENU)
	end
	self.slider_pressed = function()
		print("Slider pressed")
	end
	self.cycle_list_pressed = function()
		print("Cycle List pressed")
	end

	self.title_text = text.new("Options", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.interactables[1] =
		button.new(70, 50, "Start", self.start_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)

	self.interactables[2] =
		checkbox.new(false, 1, self.checkbox_pressed, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 80)

	self.test_slider =
		slider.new(5, 0, 10, 12, 240, 8, self.slider_pressed, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 120)

	self.interactables[3] =
		button.new(100, 50, "Back", self.back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 50, -50)

	self.interactables[4] =
		cycle_list.new(test_list, self.cycle_list_pressed, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 200)
end

function Option_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_x()
		end
		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()
		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_y()
		end
		window_y = love.graphics.getHeight()
	end
end

function Option_scene:draw()
	self.title_text:draw()
	for _, interactable in ipairs(self.interactables) do
		interactable:draw()
	end
	self.test_slider:draw()
end

function Option_scene:unload()
	setmetatable(Option_scene, nil)
end
