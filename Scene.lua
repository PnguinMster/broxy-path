require("Layers")
require("Camera")
require("TileMap")
local player = require("Player")

-- NOTE: Menu Scene
menu_scene = {}
menu_scene.__index = menu_scene
setmetatable({}, menu_scene)

function menu_scene:load() end

function menu_scene:update(dt) end

function menu_scene:draw() end

-- NOTE: Game Scene
game_scene = {}
game_scene.__index = game_scene
setmetatable({}, game_scene)

function game_scene:load()
	World = love.physics.newWorld(0, 9.8 * 16, true)

	Player = player.new()

	Tilemap:create_map(Tilemap.test_level, Player.width, Player.height)
	Tilemap:load_map()

	Player:load()
end

function game_scene:update(dt)
	World:update(dt)
	Player:update(dt)

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
