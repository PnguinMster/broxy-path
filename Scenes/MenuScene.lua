local button = require("UI.Button")
local text = require("UI.Text")

-- NOTE: Menu Scene
menu_scene = {}
menu_scene.__index = menu_scene
setmetatable({}, menu_scene)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

function menu_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.start_pressed = function()
		print("Start button pressed")
		Game:set_scene(SCENE.LEVEL)
	end

	self.options_pressed = function()
		print("Options button pressed")
	end

	self.quit_pressed = function()
		print("Quit button pressed")
		love.event.push("quit")
	end

	self.title_text = text.new("Broxy Grath", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.start_button =
		button.new(70, 50, "Start", self.start_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.options_button =
		button.new(70, 50, "Options", self.options_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 70)
	self.quit_button =
		button.new(70, 50, "Quit", self.quit_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function menu_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		self.start_button:auto_resize_x()
		self.options_button:auto_resize_x()
		self.quit_button:auto_resize_x()
		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()
		self.start_button:auto_resize_y()
		self.options_button:auto_resize_y()
		self.quit_button:auto_resize_y()
		window_y = love.graphics.getHeight()
	end
end

function menu_scene:draw()
	self.title_text:draw()
	self.start_button:draw()
	self.options_button:draw()
	self.quit_button:draw()
end

function menu_scene:unload()
	setmetatable(menu_scene, nil)
end
