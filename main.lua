love = require("love")

function love.load()
	World = love.physics.newWorld(0, 9.81 * 15, true)

	local window_x, window_y = 750, 750

	LAYERS = {
		DEFAULT = 1,
		LEVEL = 2,
		PLAYER = 3,
		OBSTACLE = 4,
	}

	Player = {}
	Player.width = 30
	Player.height = 60
	Player.startX = (window_x / 2)
	Player.startY = (window_y / 2)
	Player.topBody = love.physics.newBody(World, Player.startX, Player.startY, "dynamic")
	Player.bottomBody = love.physics.newBody(World, Player.startX, Player.startY, "dynamic")
	Player.topShape = love.physics.newRectangleShape(0, -Player.height / 4, Player.width, Player.height / 2)
	Player.bottomShape = love.physics.newRectangleShape(0, Player.height / 4, Player.width, Player.height / 2)
	Player.topFixture = love.physics.newFixture(Player.topBody, Player.topShape, 2)
	Player.bottomFixture = love.physics.newFixture(Player.bottomBody, Player.bottomShape, 2)

	Player.joint = love.physics.newWeldJoint(Player.topBody, Player.bottomBody, Player.startX, Player.startY, false)
	Player.joint:setDampingRatio(1)
	Player.joint:setFrequency(2)

	Player.topFixture:setRestitution(0.2)
	Player.topFixture:setFriction(0.7)
	Player.bottomFixture:setRestitution(0.2)
	Player.bottomFixture:setFriction(0.3)
	Player.topBody:setAngularDamping(15)
	Player.bottomBody:setAngularDamping(15)

	Player.angular_force = 250
	Player.topFixture:setCategory(LAYERS.PLAYER)
	Player.bottomFixture:setCategory(LAYERS.PLAYER)

	Player.hoverStrength = 70
	Player.linear_force = 30

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

	local r, g, b = love.math.colorFromBytes(25, 18, 28)
	love.graphics.setBackgroundColor(r, g, b)

	love.window.setMode(window_x, window_y)
end

function love.update(dt)
	World:update(dt)

	if love.keyboard.isDown("right") then
		Player.topBody:applyAngularImpulse(Player.angular_force)
		Player.bottomBody:applyAngularImpulse(Player.angular_force)

		Player.topBody:applyForce(Player.linear_force, 0)
		Player.bottomBody:applyForce(Player.linear_force, 0)
	elseif love.keyboard.isDown("left") then
		Player.topBody:applyAngularImpulse(-Player.angular_force)
		Player.bottomBody:applyAngularImpulse(-Player.angular_force)

		Player.topBody:applyForce(-Player.linear_force * 0.25, 0)
		Player.bottomBody:applyForce(-Player.linear_force, 0)
	end

	if love.keyboard.isDown("up") then
		Player.topBody:applyForce(0, -9.8 * Player.hoverStrength)
		Player.bottomBody:applyForce(0, -9.8 * Player.hoverStrength)
	elseif love.keyboard.isDown("down") then
		Player.topBody:applyForce(0, 9.8 * Player.hoverStrength)
		Player.bottomBody:applyForce(0, 9.8 * Player.hoverStrength)
	end
end

function love.draw()
	love.graphics.setColor(1, 0.5, 0)
	local x1, y1, x2, y2, x5, y5, x6, y6 = Player.topBody:getWorldPoints(Player.topShape:getPoints())
	local x7, y7, x8, y8, x3, y3, x4, y4 = Player.bottomBody:getWorldPoints(Player.bottomShape:getPoints())

	local center_x1 = (x5 + x8) * 0.5
	local center_y1 = (y5 + y8) * 0.5
	local center_x2 = (x6 + x7) * 0.5
	local center_y2 = (y6 + y7) * 0.5

	love.graphics.polygon(
		"fill",
		x1,
		y1,
		x2,
		y2,
		center_x1,
		center_y1,
		center_x2,
		center_y2,
		x4,
		y4,
		x3,
		y3,
		center_x1,
		center_y1,
		center_x2,
		center_y2
	)
	-- love.graphics.polygon("line", x1, y1, x2, y2, x3, y3, x4, y4)
	-- love.graphics.polygon("line", Player.topBody:getWorldPoints(Player.topShape:getPoints()))
	-- love.graphics.polygon("line", Player.bottomBody:getWorldPoints(Player.bottomShape:getPoints()))
	love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
end
