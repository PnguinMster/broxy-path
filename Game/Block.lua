require("Utility.BlockTypeEnum")
require("Game.MapInfo")

Block_info = {}
Block_info.__index = Block_info

BLOCK_SIZE = 50
local BLOCK_MOVE_DISTANCE = 3
local BLOCK_ROTATE_SPEED = 1
local BLOCK_MOVE_SPEED
Enuwm = 25

function Block_info.new(map_info, x, y, offset_x, offset_y)
	-- Set body type
	local body_type = "kinematic"
	if
		map_info.type.r == BLOCK_TYPE.STATIC_BLOCK.r
		or map_info.type.r == BLOCK_TYPE.BOUNCE_BLOCK.r
		or map_info.type.r == BLOCK_TYPE.END.r
	then
		body_type = "static"
	end

	-- set block center
	local center_x = (x - (map_info.width / 2)) * BLOCK_SIZE
	local center_y = (y - (map_info.height / 2)) * BLOCK_SIZE

	-- set physics body variables
	local body = love.physics.newBody(World, offset_x + center_x, offset_y + center_y, body_type)
	local shape = love.physics.newRectangleShape(map_info.width * BLOCK_SIZE, map_info.height * BLOCK_SIZE)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(LAYERS.LEVEL)
	fixture:setFriction(0.8)

	-- check if block is bouncy
	if
		map_info.type == BLOCK_TYPE.BOUNCE_BLOCK
		or map_info.type == BLOCK_TYPE.ROTATING_BOUNCE
		or map_info.type == BLOCK_TYPE.VERTICAL_BOUNCE
		or map_info.type == BLOCK_TYPE.HORIZONTAL_BOUNCE
	then
		fixture:setRestitution(0.9)
	end

	-- check if block is end block
	if map_info.type == BLOCK_TYPE.END then
		fixture:setSensor(true)
		fixture:setCategory(LAYERS.TRIGGER)
		fixture:setUserData("trigger")
	end

	-- set specific move type function
	local move = nil

	if body_type == "kinematic" then
		local is_go_to = true
		-- Set for vertical movement
		if map_info.type == BLOCK_TYPE.VERTICAL_BLOCK or map_info.type == BLOCK_TYPE.VERTICAL_BOUNCE then
			local first = body:getY()
			local last = first - (BLOCK_MOVE_DISTANCE * BLOCK_SIZE)
			move = function(self)
				if self.is_go_to then
					if body:getY() <= last then
						self.is_go_to = false
					end
					body:setLinearVelocity(0, -BLOCK_MOVE_SPEED)
				else
					if body:getY() >= first then
						self.is_go_to = true
					end
					body:setLinearVelocity(0, BLOCK_MOVE_SPEED)
				end
			end
		-- Set for horizontal movement
		elseif map_info.type == BLOCK_TYPE.HORIZONTAL_BLOCK or map_info.type == BLOCK_TYPE.HORIZONTAL_BOUNCE then
			local first = body:getX()
			local last = first + (BLOCK_MOVE_DISTANCE * BLOCK_SIZE)
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
		-- Set for rotating block
		elseif map_info.type == BLOCK_TYPE.ROTATING_BLOCK or map_info.type == BLOCK_TYPE.ROTATING_BOUNCE then
			move = function(self)
				self.body:setAngularVelocity(BLOCK_ROTATE_SPEED)
			end
		end
	end

	return setmetatable({
		map_info = map_info or Map_info.new(),
		body = body,
		move = move,
	}, Block_info)
end

function Block_info:unload()
	self.map_info = nil
	self.body:destroy()
	self.move = nil

	-- Clear rest of data
	for k, _ in pairs(self) do
		self[k] = nil
	end
end

return Block_info
