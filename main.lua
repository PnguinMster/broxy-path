require("Layers")
require("Camera")
require("TileMap")

---@class love
local love = require("love")
local player = require("Player")

function love.load()
	love.graphics.setBackgroundColor(25 / 255, 18 / 255, 28 / 255)

	World = love.physics.newWorld(0, 9.8 * 16, true)

	Player = player.new()

	Tilemap:create_map(Tilemap.test_level, Player.width, Player.height)
	Tilemap:load_map()

	Player:load()
end

function love.update(dt)
	World:update(dt)
	Player:update(dt)

	local x, y = Player:get_position()
	x = x - love.graphics.getWidth() / 2
	y = y - love.graphics.getHeight() / 2
	camera:smoothPosition(x, y, 0.05, dt)
end

function love.draw()
	-- Player:hud()
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

	camera:set()
	Tilemap:draw_map()
	Player:draw()
	love.graphics.setColor(1, 0.5, 0)
	camera:unset()
end
