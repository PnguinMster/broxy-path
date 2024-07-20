require("Game.Camera")

local player = require("Game.Player")
local tilemap = require("Game.TileMap")
local button = require("UI.Button")
local text = require("UI.Text")

-- NOTE: Game Scene
game_scene = {}
game_scene.__index = game_scene
setmetatable({}, game_scene)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

function game_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	World = love.physics.newWorld(0, 9.8 * 16, true)
	World:setCallbacks(self.on_begin_contact)

	Player = player.new()
	Tilemap = tilemap.new()

	Tilemap:create_map(Game.level, Player.width, Player.height)
	Tilemap:load_map()

	Player:load()
	pause_menu:load()
	end_menu:load()
end

function game_scene:update(dt)
	if Game.state ~= STATE.GAME then
		if Game.state == STATE.MENU then
			pause_menu:update(dt)
			end_menu:update(dt)
		end

		return
	end

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
	end_menu:draw()
end

function game_scene.on_begin_contact(a, b, contact)
	local user_data_1 = a:getUserData()
	local user_data_2 = b:getUserData()

	if user_data_1 and user_data_2 then
		print(user_data_1 .. " triggered " .. user_data_2)
		end_menu.active = true
		Game:set_state(STATE.MENU)
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
		self.active = false
		Game:set_state(STATE.GAME)
	end
	self.retry_pressed = function()
		print("Retry pressed")
		Game:set_state(STATE.GAME)
		self.active = false
		Player:reset_player()
	end
	self.menu_pressed = function()
		print("Menu pressed")
		self.active = false
		Game:set_scene(SCENE.MENU)
	end

	self.title_text = text.new("Paused", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

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

function pause_menu:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		self.continue_button:auto_resize_x()
		self.retry_button:auto_resize_x()
		self.menu_button:auto_resize_x()
		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.continue_button:auto_resize_y()
		self.retry_button:auto_resize_y()
		self.menu_button:auto_resize_y()
		window_y = love.graphics.getHeight()
	end
end

function pause_menu:draw()
	if self.active == false then
		return
	end

	self.title_text:draw()
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
		Player:reset_player()
	end
	self.menu_pressed = function()
		print("Menu pressed")
		self.active = false
		Game:set_scene(SCENE.MENU)
	end

	self.title_text = text.new("Finished", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.retry_button =
		button.new(85, 50, "Retry", self.retry_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 0)
	self.menu_button =
		button.new(85, 50, "Main Menu", self.menu_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function end_menu:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		self.retry_button:auto_resize_x()
		self.menu_button:auto_resize_x()
		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()
		self.retry_button:auto_resize_y()
		self.menu_button:auto_resize_y()
		window_y = love.graphics.getHeight()
	end
end

function end_menu:draw()
	if self.active == false then
		return
	end

	self.title_text:draw()
	self.retry_button:draw()
	self.menu_button:draw()
end

function end_menu:unload()
	setmetatable(pause_menu, nil)
end
