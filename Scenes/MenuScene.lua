local button = require("UI.Button")
local text = require("UI.Text")

Menu_scene = {}
Menu_scene.__index = Menu_scene
setmetatable({}, Menu_scene)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

function Menu_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.interactables = {}

	self.start_pressed = function()
		print("Start button pressed")
		Game:set_scene(SCENE.LEVEL)
	end

	self.options_pressed = function()
		print("Options button pressed")
		Game:set_scene(SCENE.OPTION)
	end

	self.quit_pressed = function()
		print("Quit button pressed")
		love.event.push("quit")
	end

	self.title_text = text.new("Broxy Grath", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.interactables[1] =
		button.new(70, 50, "Start", self.start_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.interactables[2] =
		button.new(70, 50, "Options", self.options_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 70)
	self.interactables[3] =
		button.new(70, 50, "Quit", self.quit_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function Menu_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		for _, interactable in ipairs(self.interactables) do
			interactable.auto_resize_x()
		end
		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()
		for _, interactable in ipairs(self.interactables) do
			interactable.auto_resize_y()
		end
		window_y = love.graphics.getHeight()
	end
end

function Menu_scene:draw()
	self.title_text:draw()
	for _, interactable in ipairs(self.interactables) do
		interactable:draw()
	end
end

function Menu_scene:unload()
	setmetatable(Menu_scene, nil)
end
