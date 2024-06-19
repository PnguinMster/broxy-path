local love = require("love")

Tilemap = {}

Tilemap.test_level = love.image.newImageData("Art/Level/test.png")
-- Tilemap.test_level = love.image.newImageData("Art/Level/testlarge.png")
Tilemap.map = {}
Tilemap.blocks = {}

local block_size = 50

function Tilemap:create_map(image)
	for x = 0, image:getWidth() - 1 do
		for y = 0, image:getHeight() - 1 do
			local r = love.math.colorToBytes(image:getPixel(x, y))

			if r == 0 then -- Black
				table.insert(self.map, Block.new(x, y, BLOCK_TYPE.BLOCK))
			elseif r == 218 then -- Yellow
				table.insert(self.map, Block.new(x, y, BLOCK_TYPE.START))
			end
		end
	end
end

function Tilemap:load_map(player)
	for _, block in ipairs(self.map) do
		if block.type == BLOCK_TYPE.BLOCK then
			local info = {}
			info.body = love.physics.newBody(World, block.x * block_size, block.y * block_size, "static")
			info.shape = love.physics.newRectangleShape(block_size, block_size)
			info.fixture = love.physics.newFixture(info.body, info.shape)

			info.fixture:setCategory(LAYERS.LEVEL)
			info.fixture:setFriction(0.9)

			table.insert(self.blocks, info)
		elseif block.type == BLOCK_TYPE.START then
			player.start_x = block_size * block.x
			player.start_y = block_size * block.y
		end
	end
end

function Tilemap:draw_map()
	for _, block in ipairs(self.blocks) do
		love.graphics.setColor(1, 0.5, 0)
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end
end

BLOCK_TYPE = {
	BLOCK = 0,
	START = 1,
}

Block = { type = BLOCK_TYPE.BLOCK, x = 0, y = 0 }
Block.__index = Block

function Block.new(x, y, type)
	return setmetatable({
		type = type or BLOCK_TYPE.BLOCK,
		x = x or 0,
		y = y or 0,
	}, Block)
end
return Block
