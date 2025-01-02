require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")

local Menu_scene = {}

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

Menu_scene.interactables = {}

local start_pressed = function()
	print("Start button pressed")
	Game:set_scene(SCENE.LEVEL)
end

local options_pressed = function()
	print("Options button pressed")
	Game:set_scene(SCENE.OPTION)
end

local quit_pressed = function()
	print("Quit button pressed")
	love.event.push("quit")
end

function Menu_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.title_text = text.new("Broxy Grath", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10, COLOR.WHITE)

	self.interactables[1] =
		button.new(70, 50, "Start", start_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.interactables[2] =
		button.new(70, 50, "Options", options_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 70)
	self.interactables[3] =
		button.new(70, 50, "Quit", quit_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function Menu_scene:update(dt)
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

function Menu_scene:draw()
	self.title_text:draw()
	for _, interactable in ipairs(self.interactables) do
		interactable:draw()
	end
end

function Menu_scene:unload()
	-- Title
	self.title_text:unload()
	self.title_text = nil

	-- Unload interactables
	for x, element in pairs(self.interactables) do
		element:unload()
		self.interactables[x] = nil
	end

	-- Unload rest of data
	for k, _ in pairs(self) do
		self[k] = nil
	end
end

return Menu_scene
