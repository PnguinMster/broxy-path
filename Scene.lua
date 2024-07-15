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

-- NOTE: Level Scene

local level = LEVEL_IMAGES.test

level_scene = {}
level_scene.__index = level_scene
setmetatable({}, level_scene)

function level_scene:load()
	self.level_0_pressed = function()
		print("Level 0 pressed")
		level = LEVEL_IMAGES.level_0
		Game:set_scene(SCENE.GAME)
	end
	self.level_1_pressed = function()
		print("Level 1 pressed")
		level = LEVEL_IMAGES.level_1
		Game:set_scene(SCENE.GAME)
	end
	self.level_2_pressed = function()
		print("Level 2 pressed")
		level = LEVEL_IMAGES.level_2
		Game:set_scene(SCENE.GAME)
	end
	self.level_3_pressed = function()
		print("Level 3 pressed")
		level = LEVEL_IMAGES.level_3
		Game:set_scene(SCENE.GAME)
	end
	self.level_4_pressed = function()
		print("Level 4 pressed")
		level = LEVEL_IMAGES.level_4
		Game:set_scene(SCENE.GAME)
	end
	self.level_5_pressed = function()
		print("Level 5 pressed")
		level = LEVEL_IMAGES.level_5
		Game:set_scene(SCENE.GAME)
	end
	self.level_6_pressed = function()
		print("Level 6 pressed")
		level = LEVEL_IMAGES.level_6
		Game:set_scene(SCENE.GAME)
	end
	self.level_7_pressed = function()
		print("Level 7 pressed")
		level = LEVEL_IMAGES.level_7
		Game:set_scene(SCENE.GAME)
	end
	self.level_8_pressed = function()
		print("Level 8 pressed")
		level = LEVEL_IMAGES.level_8
		Game:set_scene(SCENE.GAME)
	end

	self.level_0_button =
		button.new(85, 50, "0", self.level_0_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, -100)
	self.level_1_button =
		button.new(85, 50, "1", self.level_1_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, -100)
	self.level_2_button =
		button.new(85, 50, "2", self.level_2_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, -100)
	self.level_3_button =
		button.new(85, 50, "3", self.level_3_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140)
	self.level_4_button =
		button.new(85, 50, "4", self.level_4_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.level_5_button =
		button.new(85, 50, "5", self.level_5_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140)
	self.level_6_button =
		button.new(85, 50, "6", self.level_6_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, 100)
	self.level_7_button =
		button.new(85, 50, "7", self.level_7_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 100)
	self.level_8_button =
		button.new(85, 50, "8", self.level_8_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, 100)
end

function level_scene:update(dt) end

function level_scene:draw()
	self.level_0_button:draw()
	self.level_1_button:draw()
	self.level_2_button:draw()
	self.level_3_button:draw()
	self.level_4_button:draw()
	self.level_5_button:draw()
	self.level_6_button:draw()
	self.level_7_button:draw()
	self.level_8_button:draw()
end

function level_scene:unload()
	setmetatable(level_scene, nil)
end

-- NOTE: Game Scene
game_scene = {}
game_scene.__index = game_scene
setmetatable({}, game_scene)

function game_scene:load()
	World = love.physics.newWorld(0, 9.8 * 16, true)
	World:setCallbacks(self.on_begin_contact)

	Player = player.new()
	Tilemap = tilemap.new()

	Tilemap:create_map(level, Player.width, Player.height)
	Tilemap:load_map()

	Player:load()
	pause_menu:load()
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
	camera:set()
	Tilemap:draw_map()
	Player:draw()
	love.graphics.setColor(1, 0.5, 0)
	camera:unset()

	pause_menu:draw()
end

function game_scene.on_begin_contact(a, b, contact)
	local user_data_1 = a:getUserData()
	local user_data_2 = b:getUserData()

	if user_data_1 and user_data_2 then
		print(user_data_1 .. " triggered " .. user_data_2)
		end_menu.active = true
	end
end

function game_scene:unload()
	World:destroy()
	Player.unload()
	Tilemap.unload()
	pause_menu:unload()
	end_menu:unload()
	setmetatable(game_scene, nil)
end

-- NOTE: PAUSE MENU
pause_menu = { active = false }
pause_menu.__index = pause_menu
setmetatable({}, pause_menu)

function pause_menu:load()
	self.continue_pressed = function()
		print("Continue pressed")
		Game:set_state(STATE.GAME)
		self.active = false
	end
	self.retry_pressed = function()
		print("Retry pressed")
		Game:set_state(STATE.GAME)
		self.active = false
	end
	self.menu_pressed = function()
		print("Menu pressed")
		self.active = false
	end

	self.continue_button = button.new(
		85,
		50,
		"Continue",
		self.continue_pressed,
		nil,
		HORIZONTAL_ALIGN.CENTER,
		VERTICAL_ALIGN.CENTER,
		0,
		-140
	)
	self.retry_button =
		button.new(85, 50, "Retry", self.retry_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 0)
	self.menu_button =
		button.new(85, 50, "Main Menu", self.menu_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function pause_menu:draw()
	if self.active == false then
		return
	end

	self.continue_button:draw()
	self.retry_button:draw()
	self.menu_button:draw()
end

function pause_menu:unload()
	setmetatable(pause_menu, nil)
end

-- NOTE: END MENU
end_menu = { active = false }
end_menu.__index = end_menu
setmetatable({}, end_menu)

function end_menu:load()
	self.retry_pressed = function()
		print("Retry pressed")
		Game:set_state(STATE.GAME)
		self.active = false
	end
	self.menu_pressed = function()
		print("Menu pressed")
		self.active = false
	end

	self.retry_button =
		button.new(85, 50, "Retry", self.retry_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 0)
	self.menu_button =
		button.new(85, 50, "Main Menu", self.menu_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function end_menu:draw()
	if self.active == false then
		return
	end
	self.retry_button:draw()
	self.menu_button:draw()
end

function end_menu:unload()
	setmetatable(pause_menu, nil)
end

--NOTE: Check Key Released

function love.keyreleased(key)
	if Game.scene == SCENE.GAME then
		if key == "escape" then
			if Game.state == STATE.GAME and end_menu.active == false then
				Game:set_state(STATE.MENU)
				pause_menu.active = true
			else
				Game:set_state(STATE.GAME)
				pause_menu.active = false
			end
		end
	end
end

-- NOTE: Check Button

function love.mousereleased(x, y, index)
	if index == 1 then
		if Game.scene == SCENE.MENU then
			menu_scene.start_button:check_pressed(x, y)
			menu_scene.options_button:check_pressed(x, y)
			menu_scene.quit_button:check_pressed(x, y)
		elseif Game.scene == SCENE.LEVEL then
			level_scene.level_0_button:check_pressed(x, y)
			level_scene.level_1_button:check_pressed(x, y)
			level_scene.level_2_button:check_pressed(x, y)
			level_scene.level_3_button:check_pressed(x, y)
			level_scene.level_4_button:check_pressed(x, y)
			level_scene.level_5_button:check_pressed(x, y)
			level_scene.level_6_button:check_pressed(x, y)
			level_scene.level_7_button:check_pressed(x, y)
			level_scene.level_8_button:check_pressed(x, y)
		elseif Game.scene == SCENE.GAME then
			if pause_menu.active then
				pause_menu.continue_button:check_pressed(x, y)
				pause_menu.retry_button:check_pressed(x, y)
				pause_menu.menu_button:check_pressed(x, y)
			elseif end_menu.active then
				end_menu.retry_button:check_pressed(x, y)
				end_menu.menu_button:check_pressed(x, y)
			end
		end
	end
end
