require("Layers")

local love = require("love")

local Player = {}
Player.__index = Player

local DAMPING_RATIO = 1
local FREQUENCY = 2
local RESTITUTION = 0.2
local FRICTION = 0.7
local CATEGORY = LAYERS.PLAYER
local ANGULAR_DAMPENING = 15

function Player.new()
	return setmetatable({
		angular_force = 250,
		linear_force = 30,
		hover_force = 70,

		width = 30,
		height = 60,
		start_x = 0,
		start_y = 0,

		top_body = {},
		top_shape = {},
		top_fixture = {},
		bottom_body = {},
		bottom_shape = {},
		bottom_fixture = {},

		joint = {},
	}, Player)
end

function Player:load()
	self.start_x = love.graphics.getWidth() / 2
	self.start_y = love.graphics.getHeight() / 2

	self.top_body = love.physics.newBody(World, self.start_x, self.start_y, "dynamic")
	self.top_shape = love.physics.newRectangleShape(0, -self.height / 4, self.width, self.height / 2)
	self.top_fixture = love.physics.newFixture(self.top_body, self.top_shape, 2)
	self.bottom_body = love.physics.newBody(World, self.start_x, self.start_y, "dynamic")
	self.bottom_shape = love.physics.newRectangleShape(0, self.height / 4, self.width, self.height / 2)
	self.bottom_fixture = love.physics.newFixture(self.bottom_body, self.bottom_shape, 2)

	self.joint = love.physics.newWeldJoint(self.top_body, self.bottom_body, self.start_x, self.start_y, false)

	self.joint:setDampingRatio(DAMPING_RATIO)
	self.joint:setFrequency(FREQUENCY)

	self.top_fixture:setRestitution(RESTITUTION)
	self.top_fixture:setFriction(FRICTION)
	self.top_fixture:setCategory(CATEGORY)
	self.bottom_fixture:setRestitution(RESTITUTION)
	self.bottom_fixture:setFriction(FRICTION)
	self.bottom_fixture:setCategory(CATEGORY)

	self.top_body:setAngularDamping(ANGULAR_DAMPENING)
	self.bottom_body:setAngularDamping(ANGULAR_DAMPENING)
end

function Player:update()
	if love.keyboard.isDown("right") then
		self.top_body:applyAngularImpulse(self.angular_force)
		self.top_body:applyForce(self.linear_force, 0)
		self.bottom_body:applyAngularImpulse(self.angular_force)
		self.bottom_body:applyForce(self.linear_force, 0)
	elseif love.keyboard.isDown("left") then
		self.top_body:applyAngularImpulse(-self.angular_force)
		self.top_body:applyForce(-self.linear_force, 0)
		self.bottom_body:applyAngularImpulse(-self.angular_force)
		self.bottom_body:applyForce(-self.linear_force, 0)
	end

	if love.keyboard.isDown("up") then
		self.top_body:applyForce(0, -9.8 * self.hoverStrength)
		self.bottom_body:applyForce(0, -9.8 * self.hoverStrength)
	elseif love.keyboard.isDown("down") then
		self.top_body:applyForce(0, 9.8 * self.hoverStrength)
		self.bottom_body:applyForce(0, 9.8 * self.hoverStrength)
	end
end

function Player:draw()
	love.graphics.setColor(1, 0.5, 0)
	local x1, y1, x2, y2, x5, y5, x6, y6 = self.top_body:getWorldPoints(self.top_shape:getPoints())
	local x7, y7, x8, y8, x3, y3, x4, y4 = self.bottom_body:getWorldPoints(self.bottom_shape:getPoints())

	local center_x1 = (x5 + x8) * 0.5
	local center_y1 = (y5 + y8) * 0.5
	local center_x2 = (x6 + x7) * 0.5
	local center_y2 = (y6 + y7) * 0.5

	love.graphics.polygon(
		"line",
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
end

function Player.get_position()
end

return Player
