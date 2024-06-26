local love = require("love")

Tilemap = {}
Tilemap.__index = Tilemap

function Tilemap.new()
	return setmetatable({
		test_level = love.image.newImageData("Art/Level/test.png"),
		-- test_level = love.image.newImageData("Art/Level/testlarge.png"),
		map = {},
		blocks = {},
		start_x = 0,
		start_y = 0,
		player_offset_x = 0,
		player_offset_y = 0,
	}, Tilemap)
end

local block_size = 50

function Tilemap:create_map(image, player_width, player_height)
	self.player_offset_x = player_width / 2
	self.player_offset_y = player_height / 2
	for x = 1, image:getWidth() do
		self.map[x] = {}
		for y = 1, image:getHeight() do
			local r = love.math.colorToBytes(image:getPixel(x - 1, y - 1))
			local type = self.has_block_value(r)

			if r == BLOCK_TYPE.START.r then
				self.start_x = -x
				self.start_y = -y
			elseif type ~= nil then
				print(type.r)
				self.map[x][y] = Block.new(type)
			end
		end
	end
end

function Tilemap.has_block_value(value)
	for _, val in pairs(BLOCK_TYPE) do
		if value == val.r then
			return val
		end
	end
	return nil
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

	local start_offset_x = self.start_x * block_size + self.player_offset_x
	local start_offset_y = self.start_y * block_size + self.player_offset_y

	for x, column in pairs(self.map) do
		for y, block in pairs(column) do
			if block.type == BLOCK_TYPE.STATIC_BLOCK then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "static")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.STATIC_BLOCK
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.VERTICAL_BLOCK then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "kinematic")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.VERTICAL_BLOCK
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.HORIZONTAL_BLOCK then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "kinematic")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.HORIZONTAL_BLOCK
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.BOUNCE_BLOCK then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "static")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.BOUNCE_BLOCK
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.VERTICAL_BOUNCE then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "kinematic")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.VERTICAL_BOUNCE
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.HORIZONTAL_BOUNCE then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "kinematic")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.HORIZONTAL_BOUNCE
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.ROTATING_BLOCK then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "kinematic")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.ROTATING_BLOCK
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.ROTATING_BOUNCE then
				local info = {}
				info.body = love.physics.newBody(World, start_offset_x, start_offset_y, "kinematic")
				info.shape = love.physics.newRectangleShape(
					(x - (block.width / 2)) * block_size,
					(y - (block.height / 2)) * block_size,
					block.width * block_size,
					block.height * block_size
				)

				info.fixture = love.physics.newFixture(info.body, info.shape)
				info.fixture:setCategory(LAYERS.LEVEL)
				info.fixture:setFriction(0.9)

				info.type = BLOCK_TYPE.ROTATING_BOUNCE
				table.insert(self.blocks, info)
			end
		end
	end
end

function Tilemap:draw_map()
	for _, block in ipairs(self.blocks) do
		love.graphics.setColor(love.math.colorFromBytes(block.type.r, block.type.g, block.type.b))
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end
end

function Tilemap.unload()
	setmetatable(Tilemap, nil)
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
Block = { type = BLOCK_TYPE.STATIC_BLOCK, width = 1, height = 1 }
Block.__index = Block

function Block.new(type, width, height)
	return setmetatable({
		type = type or BLOCK_TYPE.STATIC_BLOCK,
		width = width or 1,
		height = height or 1,
	}, Block)
end
return Tilemap
