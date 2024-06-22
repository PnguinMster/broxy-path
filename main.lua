require("Game")

---@class love
local love = require("love")

function love.load()
	Game:load()
end

function love.update(dt)
	Game:update(dt)
end

function love.draw()
	Game:draw()
end
