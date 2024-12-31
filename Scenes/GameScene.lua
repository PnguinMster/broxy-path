require("Game.Camera")
require("UI.PauseMenu")
require("UI.EndMenu")

local player = require("Game.Player")
local tilemap = require("Game.TileMap")

Game_scene = {}
Game_scene.__index = Game_scene
setmetatable({}, Game_scene)

function Game_scene:load()
	World = love.physics.newWorld(0, 9.8 * 16, true)
	World:setCallbacks(self.on_begin_contact)

	Player = player.new()
	Tilemap = tilemap.new()

	Tilemap:create_map(Game.level, Player.width, Player.height)
	Tilemap:load_map()

	Player:load()
	Pause_menu:load()
	End_menu:load()
end

function Game_scene:update(dt)
	if Game.state ~= STATE.GAME then
		if Game.state == STATE.MENU then
			Pause_menu:update(dt)
			End_menu:update(dt)
		end

		return
	end

	World:update(dt)
	Player:update(dt)
	Tilemap:update(dt)

	local x, y = Player:get_position()
	x = x - love.graphics.getWidth() / 2
	y = y - love.graphics.getHeight() / 2
	Camera:smoothPosition(x, y, 0.05, dt)
end

function Game_scene:draw()
	Camera:set()
	Tilemap:draw_map()
	Player:draw()
	Camera:unset()

	Pause_menu:draw()
	End_menu:draw()
end

function Game_scene.on_begin_contact(a, b, contact)
	local user_data_1 = a:getUserData()
	local user_data_2 = b:getUserData()

	if user_data_1 and user_data_2 then
		print(user_data_1 .. " triggered " .. user_data_2)
		End_menu.active = true
		Game:set_state(STATE.MENU)
	end
end

function Game_scene:unload()
	World:destroy()
	Player:unload()
	Tilemap:unload()
	Pause_menu:unload()
	End_menu:unload()
end
