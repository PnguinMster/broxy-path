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
local MIN_OFFSET = 0.4
local MAX_OFFSET = 0.7

local AMPLITUDE = (MAX_OFFSET - MIN_OFFSET) / 2
local MIDPOINT = (MAX_OFFSET + MIN_OFFSET) / 2

local gradient_shader
local star_shader
local nebula_shader
local crt_shader

local game_canvas

local function setup_background_shader()
	-- Gradient Shader
	gradient_shader = love.graphics.newShader("Art/Shaders/gradient.glsl")
	local r1, g1, b1 = COLOR.DARK_BLUE:rgb_color()
	local r2, g2, b2 = COLOR.BLACK:rgb_color()

	gradient_shader:send("start_color", { r1, g1, b1, 0.2 })
	gradient_shader:send("end_color", { r2, g2, b2, 1 })
	gradient_shader:send("direction", { -1, 1 })
	gradient_shader:send("offset", MIN_OFFSET)

	-- Star Shader
	star_shader = love.graphics.newShader("Art/Shaders/stars.glsl")

	-- Nebula Shader
	nebula_shader = love.graphics.newShader("Art/Shaders/nebula.glsl")

	-- CRT Shader
	crt_shader = love.graphics.newShader("Art/Shaders/crt.glsl")
end

local function dynamic_shader()
	local time = love.timer.getTime()

	-- Gradient Shader
	local current_offset = MIDPOINT + AMPLITUDE * math.sin(time * OFFSET_SPEED)
	gradient_shader:send("offset", current_offset)

	-- Star Shader
	star_shader:send("time", time)

	-- Nebula Shader
	nebula_shader:send("time", time)
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

	game_canvas = love.graphics.newCanvas()
	setup_background_shader()

	self.scene:load()
end

function Game:update(dt)
	dynamic_shader()

	self.scene:update(dt)
end

function Game:draw()
	-- Bakground Shaders
	love.graphics.setCanvas(game_canvas)
	love.graphics.clear(0, 0, 0, 1)

	love.graphics.setShader(gradient_shader)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.setShader(star_shader)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.setShader(nebula_shader)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.setShader()

	-- love.graphics.setColor(COLOR.WHITE:rgb_color())
	-- love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

	-- Game Scene
	self.scene:draw()
	love.graphics.setColor(COLOR.WHITE:rgb_color())

	-- CRT Shader
	love.graphics.setCanvas()

	love.graphics.setShader(crt_shader)
	love.graphics.draw(game_canvas, 0, 0)
	love.graphics.setShader()
end

function love.resize(w, h)
	game_canvas = love.graphics.newCanvas(w, h)
end

function love.quit()
	print("Quitting the Game")
	Save:save_data()
end
