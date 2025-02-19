require("Utility.StateEnum")
require("Utility.SceneEnum")
require("Utility.ColorEnum")
require("Scenes.SceneEvent")
require("Game.Save")

Game = {}

Game.scene = SCENE.MENU
Game.state = SCENE.MENU
Game.level = 0

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
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(COLOR.BLACK:rgb_color())
	Save:load_data()

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

function love.quit()
	print("Quitting the Game")
	Save:save_data()
end
