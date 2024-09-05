local button = require("UI.Button")
local text = require("UI.Text")

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

Level_scene = {}
Level_scene.__index = Level_scene
setmetatable({}, Level_scene)

function Level_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.level_0_pressed = function()
		print("Level 0 pressed")
		Game.level = LEVEL_IMAGES.level_0
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_1_pressed = function()
		print("Level 1 pressed")
		Game.level = LEVEL_IMAGES.level_1
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_2_pressed = function()
		print("Level 2 pressed")
		Game.level = LEVEL_IMAGES.level_2
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_3_pressed = function()
		print("Level 3 pressed")
		Game.level = LEVEL_IMAGES.level_3
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_4_pressed = function()
		print("Level 4 pressed")
		Game.level = LEVEL_IMAGES.level_4
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_5_pressed = function()
		print("Level 5 pressed")
		Game.level = LEVEL_IMAGES.level_5
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_6_pressed = function()
		print("Level 6 pressed")
		Game.level = LEVEL_IMAGES.level_6
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_7_pressed = function()
		print("Level 7 pressed")
		Game.level = LEVEL_IMAGES.level_7
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end
	self.level_8_pressed = function()
		print("Level 8 pressed")
		Game.level = LEVEL_IMAGES.level_8
		Game:set_scene(SCENE.GAME)
		Game:set_state(STATE.GAME)
	end

	self.back_pressed = function()
		print("Back pressed")
		Game:set_scene(SCENE.MENU)
	end

	self.title_text = text.new("Select Level", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.level_0_button =
		button.new(85, 50, "0", self.level_0_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, -100)
	self.level_1_button =
		button.new(85, 50, "1", self.level_1_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, -100)
	self.level_2_button =
		button.new(85, 50, "2", self.level_2_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, -100)
	self.level_3_button =
		button.new(85, 50, "3", self.level_3_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140)
	self.level_4_button =
		button.new(85, 50, "4", self.level_4_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.level_5_button =
		button.new(85, 50, "5", self.level_5_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140)
	self.level_6_button =
		button.new(85, 50, "6", self.level_6_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, 100)
	self.level_7_button =
		button.new(85, 50, "7", self.level_7_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 100)
	self.level_8_button =
		button.new(85, 50, "8", self.level_8_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, 100)
	self.back_button =
		button.new(50, 50, "<", self.back_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.BOTTOM, 0, -100)
end

function Level_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		self.level_0_button:auto_resize_x()
		self.level_1_button:auto_resize_x()
		self.level_2_button:auto_resize_x()
		self.level_3_button:auto_resize_x()
		self.level_4_button:auto_resize_x()
		self.level_5_button:auto_resize_x()
		self.level_6_button:auto_resize_x()
		self.level_7_button:auto_resize_x()
		self.level_8_button:auto_resize_x()
		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()
		self.level_0_button:auto_resize_y()
		self.level_1_button:auto_resize_y()
		self.level_2_button:auto_resize_y()
		self.level_3_button:auto_resize_y()
		self.level_4_button:auto_resize_y()
		self.level_5_button:auto_resize_y()
		self.level_6_button:auto_resize_y()
		self.level_7_button:auto_resize_y()
		self.level_8_button:auto_resize_y()
		window_y = love.graphics.getHeight()
	end
end

function Level_scene:draw()
	self.title_text:draw()
	self.level_0_button:draw()
	self.level_1_button:draw()
	self.level_2_button:draw()
	self.level_3_button:draw()
	self.level_4_button:draw()
	self.level_5_button:draw()
	self.level_6_button:draw()
	self.level_7_button:draw()
	self.level_8_button:draw()
	self.back_button:draw()
end

function Level_scene:unload()
	setmetatable(Level_scene, nil)
end
