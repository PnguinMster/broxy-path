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

			if r == BLOCK_TYPE.START then
				self.start_x = -x
				self.start_y = -y
			elseif self.has_block_value(r) then
				self.map[x][y] = Block.new(r)
			end
		end
	end
end

function Tilemap.has_block_value(value)
	for _, val in pairs(BLOCK_TYPE) do
		if value == val then
			return true
		end
	end
	return false
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

				info.type = BLOCK_TYPE.VERTICAL_BLOCK
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.HORIZONTAL_BLOCK then
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

				info.type = BLOCK_TYPE.VERTICAL_BOUNCE
				table.insert(self.blocks, info)
			elseif block.type == BLOCK_TYPE.HORIZONTAL_BOUNCE then
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

				info.type = BLOCK_TYPE.HORIZONTAL_BOUNCE
				table.insert(self.blocks, info)
			end
		end
	end
end

function Tilemap:draw_map()
	for _, block in ipairs(self.blocks) do
		local type = block.type

		if type == BLOCK_TYPE.STATIC_BLOCK then
			love.graphics.setColor(love.math.colorFromBytes(230, 237, 227))
		elseif type == BLOCK_TYPE.VERTICAL_BLOCK then
			love.graphics.setColor(love.math.colorFromBytes(109, 194, 202))
		elseif type == BLOCK_TYPE.HORIZONTAL_BLOCK then
			love.graphics.setColor(love.math.colorFromBytes(210, 125, 44))
		elseif type == BLOCK_TYPE.BOUNCE_BLOCK then
			love.graphics.setColor(love.math.colorFromBytes(52, 101, 36))
		elseif type == BLOCK_TYPE.VERTICAL_BOUNCE then
			love.graphics.setColor(love.math.colorFromBytes(68, 36, 52))
		elseif type == BLOCK_TYPE.HORIZONTAL_BOUNCE then
			love.graphics.setColor(love.math.colorFromBytes(208, 70, 72))
		end
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end
end

function Tilemap.unload()
	setmetatable(Tilemap, nil)
end

BLOCK_TYPE = {
	START = 218, -- Yellow
	STATIC_BLOCK = 0, -- Black
	VERTICAL_BLOCK = 109, -- Teal Blue
	HORIZONTAL_BLOCK = 210, -- Orange
	BOUNCE_BLOCK = 52, --Green
	VERTICAL_BOUNCE = 68, -- Wine
	HORIZONTAL_BOUNCE = 208, -- Red
}
Block = { type = BLOCK_TYPE.STATIC, width = 1, height = 1 }
Block.__index = Block

function Block.new(type, width, height)
	return setmetatable({
		type = type or BLOCK_TYPE.STATIC,
		width = width or 1,
		height = height or 1,
	}, Block)
end
return Tilemap
