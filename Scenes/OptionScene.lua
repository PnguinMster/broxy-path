local button = require("UI.Button")
local text = require("UI.Text")
local checkbox = require("UI.checkbox")

Option_scene = {}
Option_scene.__index = Option_scene
setmetatable({}, Option_scene)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

function Option_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.interactables = {}

	self.start_pressed = function()
		print("Start button pressed")
	end
	self.back_pressed = function()
		print("Back pressed")
		Game:set_scene(SCENE.MENU)
	end

	self.title_text = text.new("Options", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.interactables[1] =
		button.new(70, 50, "Start", self.start_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)

	self.interactables[2] = checkbox.new(false, 1, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 80)

	self.interactables[3] =
		button.new(100, 50, "Back", self.back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 50, -50)
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
end

function Option_scene:unload()
	setmetatable(Option_scene, nil)
end
