require("Layers")

---@class love
local love = require("love")
local player = require("Player")

function love.load()
	local r, g, b = love.math.colorFromBytes(25, 18, 28)
	love.graphics.setBackgroundColor(r, g, b)

	local window_x, window_y = 750, 750
	love.window.setMode(window_x, window_y)

	World = love.physics.newWorld(0, 9.81 * 15, true)

	Player = player.new()
	Player:load()

	Ground = {}
	Ground.width = 700
	Ground.height = 30
	Ground.start_x = (window_x / 2)
	Ground.start_y = (window_y / 2) + 300
	Ground.body = love.physics.newBody(World, Ground.start_x, Ground.start_y, "static")
	Ground.shape = love.physics.newRectangleShape(Ground.width, Ground.height)
	Ground.fixture = love.physics.newFixture(Ground.body, Ground.shape, 3)
	Ground.body:setFixedRotation(true)
	Ground.fixture:setCategory(LAYERS.LEVEL)
	Ground.fixture:setFriction(0.7)
end

function love.update(dt)
	World:update(dt)
	Player:update()
end

function love.draw()
	Player:draw()
	love.graphics.setColor(1, 0.5, 0)
	love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
end

