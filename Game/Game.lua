require("Utility.StateEnum")
require("Utility.SceneEnum")
require("Utility.ColorEnum")
require("Utility.LevelImagesEnum")
require("Scenes.SceneEvent")

Game = {}
Game.__index = Game

Game.scene = SCENE.MENU
Game.state = SCENE.MENU
Game.level = LEVEL_IMAGES.test

function Game:set_scene(scene)
	self.scene:unload()
	self.scene = scene
	self.scene:load()
end

function Game:set_state(state)
	self.state = state

	love.mouse.setVisible(state == STATE.MENU)
end

function Game:load()
	love.graphics.setBackgroundColor(COLOR.BLACK:rgb_color())

	self.scene:load()
end

function Game:update(dt)
	self.scene:update(dt)
end

function Game:draw()
	love.graphics.setColor(COLOR.WHITE:rgb_color())
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

	self.scene:draw()
end
