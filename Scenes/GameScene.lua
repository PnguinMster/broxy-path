require("Game.Camera")
require("Game.Sound")
local pause_menu = require("UI.PauseMenu")
local end_menu = require("UI.EndMenu")
local player = require("Game.Player")
local tilemap = require("Game.TileMap")

local Game_scene = {}
local last_part_contact = ""

function Game_scene:load()
	last_part_contact = ""

	World = love.physics.newWorld(0, 9.8 * 16, true)
	World:setCallbacks(self.on_begin_contact, self.on_end_contact)

	Player = player.new()
	Tilemap = tilemap.new(Player.width, Player.height)

	Tilemap:create_map(Game.level)
	Tilemap:load_map()

	Player:load()
	pause_menu:load()
	end_menu:load()
end

function Game_scene:update(dt)
	--handle which menu to show
	if Game.state ~= STATE.GAME then
		if Game.state == STATE.MENU then
			if pause_menu.active then
				pause_menu:update(dt)
			elseif end_menu.active then
				end_menu:update(dt)
			end
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

	pause_menu:draw()
	end_menu:draw()
end

function Game_scene.on_begin_contact(a, b, _)
	local user_data_1 = a:getUserData()
	local user_data_2 = b:getUserData()
	local player_part = ""
	local block_part = ""

	-- check for player and block
	if user_data_1.entity == "player" and user_data_2.entity == "block" then
		player_part = user_data_1.part
		block_part = user_data_2.part
	elseif user_data_1.entity == "block" and user_data_2.entity == "player" then
		block_part = user_data_1.part
		player_part = user_data_2.part
	else
		return
	end

	-- check which type of block it is
	if block_part == "end" then
		end_menu.active = true
		Game:set_state(STATE.MENU)
		-- end sound effect?
	elseif block_part == "solid" then
		if player_part ~= last_part_contact or Player:is_airborne() then
			Sound:play_sound_effect(SOUND_EFFECT.BLOCK_STEP)
			last_part_contact = player_part
		end
	elseif block_part == "bounce" then
		if player_part ~= last_part_contact or Player:is_airborne() then
			Sound:play_sound_effect(SOUND_EFFECT.BLOCK_BOUNCE)
			last_part_contact = player_part
		end
	end
end

function Game_scene:unload()
	World:destroy()
	Player:unload()
	Tilemap:unload()
	pause_menu:unload()
	end_menu:unload()
end

return Game_scene
