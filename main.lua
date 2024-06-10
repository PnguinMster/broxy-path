love = require("love")

function love.load()
	World = love.physics.newWorld(0, 9.81 * 15, true)

	local window_x, window_y = 750, 750

	LAYERS = {
		LEVEL = 1,
		PLAYER = 2,
		OBSTACLE = 3,
	}

	Player = {}
	Player.width = 30
	Player.height = 60
	Player.start_x = (window_x / 2)
	Player.start_y = (window_y / 2)
	Player.body = love.physics.newBody(World, Player.start_x, Player.start_y, "dynamic")
	Player.topShape = love.physics.newRectangleShape(0, Player.height / 4, Player.width, Player.height / 2)
	Player.bottomShape = love.physics.newRectangleShape(0, -Player.height / 4, Player.width, Player.height / 2)
	Player.topFixture = love.physics.newFixture(Player.body, Player.topShape, 2)
	Player.bottomFixture = love.physics.newFixture(Player.body, Player.bottomShape, 2)
	Player.topFixture:setRestitution(0.2)
	Player.topFixture:setFriction(0.3)
	Player.bottomFixture:setRestitution(0.2)
	Player.bottomFixture:setFriction(0.3)
	Player.body:setAngularDamping(10)

	Player.angular_force = 250

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

function love.update(dt)
	World:update(dt)

	if love.keyboard.isDown("right") then
		Player.body:applyAngularImpulse(Player.angular_force)
	elseif love.keyboard.isDown("left") then
		Player.body:applyAngularImpulse(-Player.angular_force)
	end
end

function love.draw()
	local _, _, _, _, x3, y3, x4, y4 = Player.body:getWorldPoints(Player.topShape:getPoints())
	local x1, y1, x2, y2 = Player.body:getWorldPoints(Player.bottomShape:getPoints())
	love.graphics.setColor(1, 0.5, 0)
	love.graphics.polygon("line", x1, y1, x2, y2, x3, y3, x4, y4)
	love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
end
