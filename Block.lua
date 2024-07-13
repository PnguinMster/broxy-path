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

	local move = nil

	if body_type == "kinematic" then
		if map_info.type == BLOCK_TYPE.VERTICAL_BLOCK or map_info.type == BLOCK_TYPE.VERTICAL_BOUNCE then
			local first = body:getY()
			local last = first - (BLOCK_MOVE_DISTANCE * BLOCK_SIZE)
			local is_go_to = true
			move = function()
				if is_go_to then
					if body:getY() <= last then
						is_go_to = false
					end
					body:setLinearVelocity(0, -BLOCK_MOVE_SPEED)
				else
					if body:getY() >= first then
						is_go_to = true
					end
					body:setLinearVelocity(0, BLOCK_MOVE_SPEED)
				end
			end
		elseif map_info.type == BLOCK_TYPE.HORIZONTAL_BLOCK or map_info.type == BLOCK_TYPE.HORIZONTAL_BOUNCE then
			local first = body:getX()
			local last = first + (BLOCK_MOVE_DISTANCE * BLOCK_SIZE)
			local is_go_to = true
			move = function()
				if is_go_to then
					if body:getX() >= last then
						is_go_to = false
					end
					body:setLinearVelocity(BLOCK_MOVE_SPEED, 0)
				else
					if body:getX() <= first then
						is_go_to = true
					end
					body:setLinearVelocity(-BLOCK_MOVE_SPEED, 0)
				end
			end
		else
			move = function()
				body:setAngularVelocity(BLOCK_ROTATE_SPEED)
			end
		end
	end

	return setmetatable({
		map_info = map_info or Map_info.new(),
		body = body,
		shape = shape,
		fixture = fixture,
		move = move,
	}, Block_info)
end