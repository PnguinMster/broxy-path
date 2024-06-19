require("Layers")
require("Camera")
require("TileMap")

---@class love
local love = require("love")
local player = require("Player")

function love.load()
	love.graphics.setBackgroundColor(25 / 255, 18 / 255, 28 / 255)
	-- love.window.setMode(750, 750, { resizable = true, vsync = 0, minwidth = 400, minheight = 300 })
	-- love.window.setMode(750, 750)
	love.window.setMode(750, 750, { vsync = 0 })

	World = love.physics.newWorld(0, 9.8 * 16, true)

	Player = player.new()

	Tilemap:create_map(Tilemap.test_level)
	Tilemap:load_map(Player)

	Player:load()

	-- Ground = {}
	-- Ground.width = 1700
	-- Ground.height = 30
	-- Ground.start_x = (love.graphics.getWidth() / 2)
	-- Ground.start_y = (love.graphics.getHeight() / 2) + 300
	-- Ground.body = love.physics.newBody(World, Ground.start_x, Ground.start_y, "static")
	-- Ground.shape = love.physics.newRectangleShape(Ground.width, Ground.height)
	-- Ground.fixture = love.physics.newFixture(Ground.body, Ground.shape, 3)
	-- Ground.body:setFixedRotation(true)
	-- Ground.fixture:setCategory(LAYERS.LEVEL)
	-- Ground.fixture:setFriction(0.7)
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
	-- love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
	camera:unset()
end
