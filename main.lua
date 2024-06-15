require("Layers")
require("Camera")

---@class love
local love = require("love")
local player = require("Player")

-- TODO: Implement image to level map
-- and add bar max for hover

function love.load()
	love.graphics.setBackgroundColor(25 / 255, 18 / 255, 28 / 255)
	love.window.setMode(750, 750)

	World = love.physics.newWorld(0, 9.8 * 15, true)

	Player = player.new()
	Player:load()

	Ground = {}
	Ground.width = 700
	Ground.height = 30
	Ground.start_x = (love.graphics.getWidth() / 2)
	Ground.start_y = (love.graphics.getHeight() / 2) + 300
	Ground.body = love.physics.newBody(World, Ground.start_x, Ground.start_y, "static")
	Ground.shape = love.physics.newRectangleShape(Ground.width, Ground.height)
	Ground.fixture = love.physics.newFixture(Ground.body, Ground.shape, 3)
	Ground.body:setFixedRotation(true)
	Ground.fixture:setCategory(LAYERS.LEVEL)
	Ground.fixture:setFriction(0.7)
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
	Player:hud()
	camera:set()
	Player:draw()
	love.graphics.setColor(1, 0.5, 0)
	love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
	camera:unset()
end
