require("Game.Camera")
require("UI.PauseMenu")
require("UI.EndMenu")

local player = require("Game.Player")
local tilemap = require("Game.TileMap")

-- NOTE: Game Scene
game_scene = {}
game_scene.__index = game_scene
setmetatable({}, game_scene)

function game_scene:load()
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
