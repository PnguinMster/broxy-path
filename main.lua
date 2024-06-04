love = require("love")

function love.load()
	World = love.physics.newWorld(0, 30, true)

	local window_x, window_y = 750, 750

	Player = {}
	Player.width = 30
	Player.height = 60
	Player.start_x = (window_x / 2)
	Player.start_y = (window_y / 2)
	Player.body = love.physics.newBody(World, Player.start_x, Player.start_y, "dynamic")
	Player.shape = love.physics.newRectangleShape(Player.width, Player.height)
	Player.fixture = love.physics.newFixture(Player.body, Player.shape, 3)
	Player.fixture:setRestitution(0.2)

	Ground = {}
	Ground.width = 700
	Ground.height = 30
	Ground.start_x = (window_x / 2)
	Ground.start_y = (window_y / 2) + 300
	Ground.body = love.physics.newBody(World, Ground.start_x, Ground.start_y, "static")
	Ground.shape = love.physics.newRectangleShape(Ground.width, Ground.height)
	Ground.fixture = love.physics.newFixture(Ground.body, Ground.shape, 3)
	Ground.body:setFixedRotation(true)

	local r, g, b = love.math.colorFromBytes(25, 18, 28)
	love.graphics.setBackgroundColor(r, g, b)

	love.window.setMode(window_x, window_y)
end

-- NOTE:Have two square colliders that got to the center and seperate for effect

function love.update(dt)
	World:update(dt)

	if love.keyboard.isDown("right") then
		Player.body:applyAngularImpulse(50)
	elseif love.keyboard.isDown("left") then
		Player.body:applyAngularImpulse(-50)
	end
end

function love.draw()
	love.graphics.setColor(1, 0.5, 0)
	love.graphics.polygon("line", Player.body:getWorldPoints(Player.shape:getPoints()))
	love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
end
