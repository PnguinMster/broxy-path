require("Utility.LayerEnum")
require("Utility.Math")
require("Utility.ColorEnum")

local Player = {
	angular_force = 250 * 100,
	linear_force = 30,
	hover_force = 70,

	width = 30,
	height = 60,
	start_x = 0,
	start_y = 0,

	top_body = {},
	top_shape = {},
	bottom_body = {},
	bottom_shape = {},

	joint = {},

	hover_timer = 1,
	can_hover_timer = 0,
	hover_enabled = true,
}
Player.__index = Player

local DAMPING_RATIO = 1
local FREQUENCY = 2
local RESTITUTION = 0.1
local FRICTION = 0.9
local CATEGORY = LAYERS.PLAYER
local USER_DATA = "player"
local ANGULAR_DAMPENING = 12
local HOVER_TIME_GAIN = 1.5
local HOVER_TIME_LOSE = 1
local CAN_HOVER_TIME = 0.15

function Player.new()
	return setmetatable({}, Player)
end

function Player:load()
	self.top_body = love.physics.newBody(World, self.start_x, self.start_y, "dynamic")
	self.top_shape = love.physics.newRectangleShape(0, -self.height / 4, self.width, self.height / 2)
	local top_fixture = love.physics.newFixture(self.top_body, self.top_shape, 2)
	self.bottom_body = love.physics.newBody(World, self.start_x, self.start_y, "dynamic")
	self.bottom_shape = love.physics.newRectangleShape(0, self.height / 4, self.width, self.height / 2)
	local bottom_fixture = love.physics.newFixture(self.bottom_body, self.bottom_shape, 2)

	self.joint = love.physics.newWeldJoint(self.top_body, self.bottom_body, self.start_x, self.start_y, false)

	self.joint:setDampingRatio(DAMPING_RATIO)
	self.joint:setFrequency(FREQUENCY)

	top_fixture:setRestitution(RESTITUTION)
	top_fixture:setFriction(FRICTION)
	top_fixture:setCategory(CATEGORY)
	top_fixture:setUserData(USER_DATA)
	bottom_fixture:setRestitution(RESTITUTION)
	bottom_fixture:setFriction(FRICTION)
	bottom_fixture:setCategory(CATEGORY)
	bottom_fixture:setUserData(USER_DATA)

	self.top_body:setAngularDamping(ANGULAR_DAMPENING)
	self.bottom_body:setAngularDamping(ANGULAR_DAMPENING)
end

function Player:update(dt)
	if love.keyboard.isDown("right") then
		self.top_body:applyTorque(self.angular_force)
		self.top_body:applyForce(self.linear_force, 0)
		self.bottom_body:applyTorque(self.angular_force)
		self.bottom_body:applyForce(self.linear_force, 0)
	elseif love.keyboard.isDown("left") then
		self.top_body:applyTorque(-self.angular_force)
		self.top_body:applyForce(-self.linear_force, 0)
		self.bottom_body:applyTorque(-self.angular_force)
		self.bottom_body:applyForce(-self.linear_force, 0)
	end

	if love.keyboard.isDown("up") and self.hover_enabled then
		self.top_body:applyForce(0, -9.8 * self.hover_force)
		self.bottom_body:applyForce(0, -9.8 * self.hover_force)
		self.hover_timer = self.hover_timer - dt * HOVER_TIME_LOSE
	elseif love.keyboard.isDown("down") and self.hover_enabled then
		self.top_body:applyForce(0, 9.8 * self.hover_force)
		self.bottom_body:applyForce(0, 9.8 * self.hover_force)
		self.hover_timer = self.hover_timer - dt / HOVER_TIME_LOSE
	elseif self.hover_enabled then
		self.hover_timer = self.hover_timer + dt / HOVER_TIME_GAIN
	end

	if self.hover_timer <= 0 then
		self.can_hover_timer = self.can_hover_timer + dt / CAN_HOVER_TIME
		self.hover_enabled = false
		if self.can_hover_timer > 1 then
			self.hover_enabled = true
			self.can_hover_timer = 0
			self.hover_timer = 0
		end
	end

	self.hover_timer = math.clamp(self.hover_timer, -1, 1)
end

function Player:draw()
	love.graphics.setColor(COLOR.ORANGE:rgb_color())

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

	self:hover_bar()
end

function Player:hover_bar()
	local bar_height = math.lerp(self.height, 0, self.hover_timer)

	love.graphics.setColor(COLOR.GREEN:rgb_color())
	local x1, y1, x2, y2, x5, y5, x6, y6 = self.top_body:getWorldPoints(self.top_shape:getPoints())
	local x7, y7, x8, y8, x3, y3, x4, y4 = self.bottom_body:getWorldPoints(self.bottom_shape:getPoints())

	local center_x1 = (x5 + x8) * 0.5
	local center_y1 = (y5 + y8) * 0.5
	local center_x2 = (x6 + x7) * 0.5
	local center_y2 = (y6 + y7) * 0.5

	x1, y1 = self.top_body:getLocalPoint(x1, y1)
	x2, y2 = self.top_body:getLocalPoint(x2, y2)
	center_x1, center_y1 = self.top_body:getLocalPoint(center_x1, center_y1)
	center_x2, center_y2 = self.top_body:getLocalPoint(center_x2, center_y2)

	y1 = y1 + bar_height
	y2 = y2 + bar_height
	center_y1 = math.clamp(center_y1, y1, center_y1)
	center_y2 = math.clamp(center_y2, y2, center_y2)

	x1, y1 = self.top_body:getWorldPoint(x1, y1)
	x2, y2 = self.top_body:getWorldPoint(x2, y2)
	center_x1, center_y1 = self.top_body:getWorldPoint(center_x1, center_y1)
	center_x2, center_y2 = self.top_body:getWorldPoint(center_x2, center_y2)

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

function Player:get_position()
	local x1, y1, x2, y2 = self.joint:getAnchors()
	local x_average = (x1 + x2) * 0.5
	local y_average = (y1 + y2) * 0.5
	return x_average, y_average
end

function Player:reset_player()
	self.top_body:setPosition(0, 0)
	self.top_body:setAngle(0)
	self.top_body:setLinearVelocity(0, 0)
	self.top_body:setAngularVelocity(0)

	self.bottom_body:setPosition(0, 0)
	self.bottom_body:setAngle(0)
	self.bottom_body:setLinearVelocity(0, 0)
	self.bottom_body:setAngularVelocity(0)

	self.hover_timer = 1
	self.hover_enabled = true
end

function Player:unload()
	self.top_body = nil
	self.bottom_body = nil

	-- Clear rest of data
	for k, _ in pairs(self) do
		self[k] = nil
	end
end

return Player
