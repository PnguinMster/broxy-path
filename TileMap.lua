local love = require("love")

Tilemap = {}
Tilemap.__index = Tilemap

local BLOCK_SIZE = 50

LEVEL_IMAGES = {
	test = "Art/Level/test.png",
	tutorial = "Art/Level/tutorial.png",
	level_1 = "Art/Level/level_1.png",
	level_2 = "Art/Level/level_2.png",
	level_3 = "Art/Level/level_3.png",
}

--
-- TODO: Refactor all this
-- then add blocks movement
--

function Tilemap.new()
	return setmetatable({
		map = {},
		static_blocks = {},
		movable_blocks = {},
		start_x = 0,
		start_y = 0,
		player_offset_x = 0,
		player_offset_y = 0,
	}, Tilemap)
end

function Tilemap:create_map(image, player_width, player_height)
	local level = love.image.newImageData(image)

	self.player_offset_x = player_width / 2
	self.player_offset_y = player_height / 2

	for x = 1, level:getWidth() do
		self.map[x] = {}
		for y = 1, level:getHeight() do
			local r = love.math.colorToBytes(level:getPixel(x - 1, y - 1))
			local type = self.has_block_value(r)

			if r == BLOCK_TYPE.START.r then
				self.start_x = -x
				self.start_y = -y
			elseif type ~= nil then
				self.map[x][y] = Map_info.new(type)
			end
		end
	end
end

function Tilemap:optimize_map()
	for x, _ in pairs(self.map) do
		for y = 2, #self.map[1] do
			if
				self.map[x][y - 1] ~= nil
				and self.map[x][y] ~= nil
				and self.map[x][y].type == self.map[x][y - 1].type
			then
				self.map[x][y].height = self.map[x][y].height + self.map[x][y - 1].height
				self.map[x][y - 1] = nil
			end
		end
	end

	for x = 2, #self.map do
		for y, block in pairs(self.map[x]) do
			if
				self.map[x - 1][y] ~= nil
				and block.height == self.map[x - 1][y].height
				and block.type == self.map[x - 1][y].type
			then
				block.width = block.width + self.map[x - 1][y].width
				self.map[x - 1][y] = nil
			end
		end
	end
end

function Tilemap:load_map()
	self:optimize_map()

	local start_offset_x = self.start_x * BLOCK_SIZE + self.player_offset_x
	local start_offset_y = self.start_y * BLOCK_SIZE + self.player_offset_y

	for x, column in pairs(self.map) do
		for y, map_info in pairs(column) do
			local block = Block_info.new(map_info, x, y, start_offset_x, start_offset_y)
			if block.body:getType() == "kinematic" then
				table.insert(self.movable_blocks, block)
			else
				table.insert(self.static_blocks, block)
			end
		end
	end
end

function Tilemap:update(dt)
	-- NOTE: loop through moving blocks and move them
end

function Tilemap:draw_map()
	for _, block in ipairs(self.static_blocks) do
		love.graphics.setColor(
			love.math.colorFromBytes(block.map_info.type.r, block.map_info.type.g, block.map_info.type.b)
		)
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end

	for _, block in ipairs(self.movable_blocks) do
		love.graphics.setColor(
			love.math.colorFromBytes(block.map_info.type.r, block.map_info.type.g, block.map_info.type.b)
		)
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end
end

function Tilemap.unload()
	setmetatable(Tilemap, nil)
end

function Tilemap.has_block_value(value)
	for _, val in pairs(BLOCK_TYPE) do
		if value == val.r then
			return val
		end
	end
	return nil
end

BLOCK_TYPE = {
	START = { r = 218, g = 212, b = 94 }, -- Yellow
	STATIC_BLOCK = { r = 222, g = 238, b = 214 }, -- White
	VERTICAL_BLOCK = { r = 109, g = 194, b = 202 }, -- Teal Blue
	HORIZONTAL_BLOCK = { r = 210, g = 125, b = 44 }, -- Orange
	BOUNCE_BLOCK = { r = 52, g = 101, b = 36 }, --Green
	VERTICAL_BOUNCE = { r = 68, g = 36, b = 52 }, -- Wine
	HORIZONTAL_BOUNCE = { r = 208, g = 70, b = 72 }, -- Red
	ROTATING_BLOCK = { r = 89, g = 125, b = 206 }, -- Matte Blue
	ROTATING_BOUNCE = { r = 48, g = 52, b = 109 }, -- Dark Blue
}

Map_info = { width = 1, height = 1 }
Map_info.__index = Map_info

function Map_info.new(type)
	return setmetatable({ type = type or BLOCK_TYPE.STATIC_BLOCK }, Map_info)
end

Block_info = {}
Block_info.__index = Block_info

function Block_info.new(map_info, x, y, offset_x, offset_y)
	local body_type = "kinematic"
	if map_info.type.r == BLOCK_TYPE.STATIC_BLOCK.r or map_info.type.r == BLOCK_TYPE.BOUNCE_BLOCK.r then
		body_type = "static"
	end

	local body = love.physics.newBody(World, offset_x, offset_y, body_type)
	local shape = love.physics.newRectangleShape(
		(x - (map_info.width / 2)) * BLOCK_SIZE,
		(y - (map_info.height / 2)) * BLOCK_SIZE,
		map_info.width * BLOCK_SIZE,
		map_info.height * BLOCK_SIZE
	)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(LAYERS.LEVEL)
	fixture:setFriction(0.9)

	return setmetatable({
		map_info = map_info or Map_info.new(),
		body = body,
		shape = shape,
		fixture = fixture,
	}, Block_info)
end

-- Block = {
-- 	type = BLOCK_TYPE.STATIC_BLOCK,
-- 	width = 1,
-- 	height = 1,
-- 	is_rotating = false,
-- 	first = 0,
-- 	last = 0,
-- 	is_vertical = false,
-- }
-- Block.__index = Block
--
-- function Block.new(type, width, height, is_rotating, first, last, is_vertical)
-- 	return setmetatable({
-- 		type = type or BLOCK_TYPE.STATIC_BLOCK,
-- 		width = width or 1,
-- 		height = height or 1,
-- 		is_rotating = is_rotating or false,
-- 		first = first or 0,
-- 		last = last or 0,
-- 		is_vertical = is_vertical or false,
-- 	}, Block)
-- end
return Tilemap
