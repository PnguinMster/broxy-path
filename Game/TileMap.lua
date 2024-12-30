require("Game.Block")
require("Game.MapInfo")
require("Utility.BlockTypeEnum")
require("Utility.ColorEnum")

local love = require("love")

Tilemap = {}
Tilemap.__index = Tilemap

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
			local r, g, b = love.math.colorToBytes(level:getPixel(x - 1, y - 1))
			local type = self.has_block_value(r, g, b)

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

			self.map[x][y] = nil
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
		love.graphics.setColor(block.map_info.type:rgb_color())
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end

	for _, block in ipairs(self.movable_blocks) do
		love.graphics.setColor(block.map_info.type:rgb_color())
		love.graphics.polygon("line", block.body:getWorldPoints(block.shape:getPoints()))
	end
end

function Tilemap:unload()
	-- Unload Map
	for y, row in pairs(self.map) do
		for x, _ in pairs(row) do
			self.map[y][x] = nil
		end
		self.map[y] = nil
	end

	-- Unload physic blocks
	for x, block in pairs(self.static_blocks) do
		if block.body then
			block:unload()
			self.static_blocks[x] = nil
		end
	end

	for x, block in pairs(self.movable_blocks) do
		if block.body then
			block:unload()
			self.movable_blocks[x] = nil
		end
	end

	-- Clear rest of data
	for k, v in pairs(self) do
		self[k] = nil
	end
end

function Tilemap.has_block_value(r, g, b)
	for _, type in pairs(BLOCK_TYPE) do
		if type:has_values(r, g, b) then
			return type
		end
	end
	return nil
end

function Tilemap:get_spawnpoint()
	return self.start_x, self.start_y
end

return Tilemap
