require("Game.Game")
require("Game.Sound")

---@class love
local love = require("love")

function love.load()
	Game:load()
	Sound:load()
end

function love.update(dt)
	Game:update(dt)
	Sound:update(dt)
end

function love.draw()
	Game:draw()
end
