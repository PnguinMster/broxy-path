local love = require("love")

local color_block_key = {
	start = 218, -- Yellow
	static_block = 0, -- Black
	vertical_block = 109, -- Teal Blue
	horizontal_block = 210, -- Orange
	bounce_block = 52, --Green
	vertical_bounce = 68, -- Wine
	horizontal_bounce = 208, -- Red
}

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

			if r == color_block_key.start then
				self.start_x = -x
				self.start_y = -y
			elseif r == color_block_key.static_block then
				self.map[x][y] = Block.new(BLOCK_TYPE.STATIC_BLOCK)
			elseif r == color_block_key.vertical_block then
				self.map[x][y] = Block.new(BLOCK_TYPE.VERTICAL_BLOCK)
			elseif r == color_block_key.horizontal_block then
				self.map[x][y] = Block.new(BLOCK_TYPE.HORIZONTAL_BLOCK)
			elseif r == color_block_key.bounce_block then
				self.map[x][y] = Block.new(BLOCK_TYPE.BOUNCE_BLOCK)
			elseif r == color_block_key.vertical_bounce then
				self.map[x][y] = Block.new(BLOCK_TYPE.VERTICAL_BOUNCE)
			elseif r == color_block_key.horizontal_bounce then
				self.map[x][y] = Block.new(BLOCK_TYPE.HORIZONTAL_BOUNCE)
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

				table.insert(self.blocks, info)
			end
		end
	end
end

function Tilemap:draw_map()
	for _, block in ipairs(self.blocks) do
		if block.type == BLOCK_TYPE.STATIC then
			love.graphics.setColor(1, 0.5, 0)
		end
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end
end

function Tilemap.unload()
	setmetatable(Tilemap, nil)
end

BLOCK_TYPE = {
	STATIC_BLOCK = 0,
	START = 1,
	VERTICAL_BLOCK = 2,
	HORIZONTAL_BLOCK = 3,
	BOUNCE_BLOCK = 4,
	VERTICAL_BOUNCE = 5,
	HORIZONTAL_BOUNCE = 6,
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
