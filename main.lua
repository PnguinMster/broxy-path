love = require("love")

-- NOTE: NEW DIRECTION add toggle hover thing ability

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
	Player.topBody:setAngularDamping(10)
	Player.bottomBody:setAngularDamping(10)

	Player.angular_force = 250
	Player.topFixture:setCategory(LAYERS.PLAYER)
	Player.bottomFixture:setCategory(LAYERS.PLAYER)

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
	elseif love.keyboard.isDown("left") then
		Player.topBody:applyAngularImpulse(-Player.angular_force)
		Player.bottomBody:applyAngularImpulse(-Player.angular_force)
	end
end

function love.draw()
	-- TODO: Get Average from points
	local x1, y1, x2, y2, x5, y5, x6, y6 = Player.topBody:getWorldPoints(Player.topShape:getPoints())
	local _, _, _, _, x3, y3, x4, y4 = Player.bottomBody:getWorldPoints(Player.bottomShape:getPoints())
	love.graphics.setColor(1, 0.5, 0)

	love.graphics.polygon("line", x1, y1, x2, y2, x5, y5, x6, y6, x4, y4, x3, y3, x5, y5, x6, y6)
	-- love.graphics.polygon("line", x1, y1, x2, y2, x3, y3, x4, y4)
	-- love.graphics.polygon("line", Player.topBody:getWorldPoints(Player.topShape:getPoints()))
	-- love.graphics.polygon("line", Player.bottomBody:getWorldPoints(Player.bottomShape:getPoints()))
	love.graphics.polygon("line", Ground.body:getWorldPoints(Ground.shape:getPoints()))
end
