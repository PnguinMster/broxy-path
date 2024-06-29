BLOCK_TYPE = {
	START = { r = 168, g = 202, b = 88 }, -- Lime
	STATIC_BLOCK = { r = 235, g = 237, b = 233 }, -- White
	VERTICAL_BLOCK = { r = 115, g = 190, b = 211 }, -- Light Blue
	HORIZONTAL_BLOCK = { r = 37, g = 58, b = 94 }, -- Dark Blue
	BOUNCE_BLOCK = { r = 218, g = 134, b = 62 }, -- Orange
	VERTICAL_BOUNCE = { r = 207, g = 87, b = 60 }, -- Red
	HORIZONTAL_BOUNCE = { r = 117, g = 36, b = 56 }, -- Maroon
	ROTATING_BLOCK = { r = 122, g = 54, b = 123 }, -- Purple
	ROTATING_BOUNCE = { r = 223, g = 132, b = 165 }, -- Pink
	END = { r = 87, g = 114, b = 119 }, -- Gray
}

Block_info = {}
Block_info.__index = Block_info

BLOCK_SIZE = 50
local BLOCK_MOVE_DISTANCE = 3
local BLOCK_ROTATE_SPEED = 1
local BLOCK_MOVE_SPEED = 25

function Block_info.new(map_info, x, y, offset_x, offset_y)
	local body_type = "kinematic"
	if map_info.type.r == BLOCK_TYPE.STATIC_BLOCK.r or map_info.type.r == BLOCK_TYPE.BOUNCE_BLOCK.r then
		body_type = "static"
	end

	local center_x = (x - (map_info.width / 2)) * BLOCK_SIZE
	local center_y = (y - (map_info.height / 2)) * BLOCK_SIZE

	local body = love.physics.newBody(World, offset_x + center_x, offset_y + center_y, body_type)
	local shape = love.physics.newRectangleShape(map_info.width * BLOCK_SIZE, map_info.height * BLOCK_SIZE)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(LAYERS.LEVEL)
	fixture:setFriction(0.8)

	if
		map_info.type == BLOCK_TYPE.BOUNCE_BLOCK
		or map_info.type == BLOCK_TYPE.ROTATING_BOUNCE
		or map_info.type == BLOCK_TYPE.VERTICAL_BOUNCE
		or map_info.type == BLOCK_TYPE.HORIZONTAL_BOUNCE
	then
		fixture:setRestitution(0.9)
	end

	local start_x = body:getX()
	local start_y = body:getY()

	local local_end_x = start_x
	local local_end_y = start_y

	if body_type == "kinematic" then
		if map_info.type == BLOCK_TYPE.VERTICAL_BLOCK or map_info.type == BLOCK_TYPE.VERTICAL_BOUNCE then
			local_end_y = start_y - (BLOCK_MOVE_DISTANCE * BLOCK_SIZE)
		elseif map_info.type == BLOCK_TYPE.HORIZONTAL_BLOCK or map_info.type == BLOCK_TYPE.HORIZONTAL_BOUNCE then
			local_end_x = start_x + (BLOCK_MOVE_DISTANCE * BLOCK_SIZE)
		end
	end

	return setmetatable({
		map_info = map_info or Map_info.new(),
		body = body,
		shape = shape,
		fixture = fixture,
		first_x = start_x,
		first_y = start_y,
		last_x = local_end_x,
		last_y = local_end_y,
		is_up = true,
		is_right = true,
	}, Block_info)
end

function Block_info:move()
	if self.map_info.type == BLOCK_TYPE.VERTICAL_BLOCK or self.map_info.type == BLOCK_TYPE.VERTICAL_BOUNCE then
		if self.is_up then
			if self.body:getY() <= self.last_y then
				self.is_up = false
			end
			self.body:setLinearVelocity(0, -BLOCK_MOVE_SPEED)
		else
			if self.body:getY() >= self.first_y then
				self.is_up = true
			end
			self.body:setLinearVelocity(0, BLOCK_MOVE_SPEED)
		end
	elseif self.map_info.type == BLOCK_TYPE.HORIZONTAL_BLOCK or self.map_info.type == BLOCK_TYPE.HORIZONTAL_BOUNCE then
		if self.is_right then
			if self.body:getX() >= self.last_x then
				self.is_right = false
			end
			self.body:setLinearVelocity(BLOCK_MOVE_SPEED, 0)
		else
			if self.body:getX() <= self.first_x then
				self.is_right = true
			end
			self.body:setLinearVelocity(-BLOCK_MOVE_SPEED, 0)
		end
	end

	if self.map_info.type == BLOCK_TYPE.ROTATING_BLOCK or self.map_info.type == BLOCK_TYPE.ROTATING_BOUNCE then
		self.body:setAngularVelocity(BLOCK_ROTATE_SPEED)
	end
end
