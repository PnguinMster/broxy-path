require("Block")

local love = require("love")

Tilemap = {}
Tilemap.__index = Tilemap

LEVEL_IMAGES = {
	test = "Art/Level/test_block_colored.png",
	level_0 = "Art/Level/level_0.png",
	level_1 = "Art/Level/level_1.png",
	level_2 = "Art/Level/level_2.png",
	level_3 = "Art/Level/level_3.png",
}

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
		for y, _ in pairs(self.map[x]) do
			if self.map[x][y - 1] ~= nil and self.map[x][y].type == self.map[x][y - 1].type then
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
	for _, block in ipairs(self.movable_blocks) do
		block:move()
	end
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

Map_info = { width = 1, height = 1 }
Map_info.__index = Map_info

function Map_info.new(type)
	return setmetatable({ type = type or BLOCK_TYPE.STATIC_BLOCK }, Map_info)
end

return Tilemap
