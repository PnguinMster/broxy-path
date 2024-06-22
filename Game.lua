require("Scene")

STATE = {
	MENU = 1,
	GAME = 2,
}

SCENE = {
	MENU = menu_scene,
	GAME = game_scene,
}

Game = {}
Game.__index = Game

Game.scene = SCENE.MENU
Game.state = SCENE.MENU

function Game:set_scene(scene)
	self.scene:unload()
	self.scene = scene
	self.scene:load()
end

function Game:load()
	love.graphics.setBackgroundColor(love.math.colorFromBytes(25, 18, 28))

	self.scene:load()
end

function Game:update(dt)
	self.scene:update(dt)
end

function Game:draw()
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

	self.scene:draw()
end