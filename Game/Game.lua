require("Utility.StateEnum")
require("Utility.SceneEnum")
require("Utility.ColorEnum")
require("Scenes.SceneEvent")
require("Game.Save")

Game = {}

Game.scene = SCENE.MENU
Game.state = SCENE.MENU
Game.level = 1

local OFFSET_SPEED = 0.1
local MIN_OFFSET = 0.2
local MAX_OFFSET = 0.3

local AMPLITUDE = (MAX_OFFSET - MIN_OFFSET) / 2
local MIDPOINT = (MAX_OFFSET + MIN_OFFSET) / 2

local gradient_shader

local function setup_background_shader()
	gradient_shader = love.graphics.newShader("Art/Shaders/gradient.glsl")
	local r1, g1, b1 = COLOR.DARK_BLUE:rgb_color()
	local r2, g2, b2 = COLOR.BLACK:rgb_color()

	gradient_shader:send("start_color", { r1, g1, b1, 0.2 })
	gradient_shader:send("end_color", { r2, g2, b2, 1 })
	gradient_shader:send("direction", { -1, 1 })
	gradient_shader:send("offset", MIN_OFFSET)
end

local function dynamic_shader_offset()
	local time = love.timer.getTime()
	local current_offset = MIDPOINT + AMPLITUDE * math.sin(time * OFFSET_SPEED)

	gradient_shader:send("offset", current_offset)
end

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
	Save:load_data()
	love.window.setFullscreen(Save.fullscreen)
	love.window.setVSync(Save.vsync)

	math.randomseed(os.time())
	love.graphics.setBackgroundColor(COLOR.BLACK:rgb_color())

	setup_background_shader()

	self.scene:load()
end

function Game:update(dt)
	dynamic_shader_offset()
	self.scene:update(dt)
end

function Game:draw()
	love.graphics.setShader(gradient_shader)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setShader()

	-- love.graphics.setColor(COLOR.WHITE:rgb_color())
	-- love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

	self.scene:draw()
end

function love.quit()
	print("Quitting the Game")
	Save:save_data()
end
