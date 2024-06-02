_G.love = require("love")

function love.load()
	World = love.physics.newWorld(0, 30, true)

	Player = {}
	Player.start_x = 300
	Player.start_y = 100
	Player.width = 30
	Player.height = 60
	Player.body = love.physics.newBody(World, Player.start_x, Player.start_y, "dynamic")
	Player.shape = love.physics.newRectangleShape(Player.width, Player.height)
	Player.fixture = love.physics.newFixture(Player.body, Player.shape, 3)
	Player.body:setFixedRotation(true)
	Player.fixture:setRestitution(0.2)

	Ground = {}
	Ground.start_x = 300
	Ground.start_y = 400
	Ground.width = 90
	Ground.height = 30
	Ground.body = love.physics.newBody(World, Ground.start_x, Ground.start_y, "static")
	Ground.shape = love.physics.newRectangleShape(Ground.width, Ground.height)
	Ground.fixture = love.physics.newFixture(Ground.body, Ground.shape, 3)
	Ground.body:setFixedRotation(true)

	local r, g, b = love.math.colorFromBytes(25, 18, 28)
	love.graphics.setBackgroundColor(r, g, b)

	love.window.setMode(650, 650)
end

-- TODO: Add gravity and stuff maybe also seperate to differnt files and quick lua tutorial

function love.update(dt)
	World:update(dt)

	if love.keyboard.isDown("right") then
		Player.body:applyForce(400, 0)
	elseif love.keyboard.isDown("left") then
		Player.body:applyForce(-400, 0)
	elseif love.keyboard.isDown("up") then
		Player.body:setPosition(0, 0)
		Player.body:setLinearVelocity(0, 0)
	end
end

function love.draw()
	love.graphics.setColor(1, 0.5, 0)
	love.graphics.polygon("line", Player.body:getWorldPoints(Player.shape:getPoints()))
	love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
end
