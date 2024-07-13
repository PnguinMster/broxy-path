require("Layers")
require("Camera")

local player = require("Player")
local tilemap = require("TileMap")
local button = require("Button")
local text = require("Text")

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
		Game:set_scene(SCENE.GAME)
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

function love.mousereleased(x, y, index)
	if index == 1 then
		menu_scene.start_button:check_pressed(x, y)
		menu_scene.options_button:check_pressed(x, y)
		menu_scene.quit_button:check_pressed(x, y)
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

-- NOTE: Level Scene
level_scene = {}
level_scene.__index = level_scene
setmetatable({}, level_scene)

function level_scene:load() end

function level_scene:update(dt) end

function level_scene:draw() end

function level_scene:unload()
	setmetatable(level_scene, nil)
end

-- NOTE: Game Scene
game_scene = {}
game_scene.__index = game_scene
setmetatable({}, game_scene)

function game_scene:load()
	World = love.physics.newWorld(0, 9.8 * 16, true)

	Player = player.new()
	Tilemap = tilemap.new()

	Tilemap:create_map(LEVEL_IMAGES.level_0, Player.width, Player.height)
	Tilemap:load_map()

	Player:load()
end

function game_scene:update(dt)
	World:update(dt)
	Player:update(dt)
	Tilemap:update(dt)

	local x, y = Player:get_position()
	x = x - love.graphics.getWidth() / 2
	y = y - love.graphics.getHeight() / 2
	camera:smoothPosition(x, y, 0.05, dt)
end

function game_scene:draw()
	-- Player:hud()

	camera:set()
	Tilemap:draw_map()
	Player:draw()
	love.graphics.setColor(1, 0.5, 0)
	camera:unset()
end

function game_scene:unload()
	World:destroy()
	Player.unload()
	Tilemap.unload()
end
