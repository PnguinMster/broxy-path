require("Utility.ColorEnum")
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

	self.interactables = {}

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

	self.title_text = text.new("Select Level", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10, COLOR.WHITE)

	self.interactables[1] =
		button.new(85, 50, "0", self.level_0_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, -100)
	self.interactables[2] =
		button.new(85, 50, "1", self.level_1_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, -100)
	self.interactables[3] =
		button.new(85, 50, "2", self.level_2_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, -100)
	self.interactables[4] =
		button.new(85, 50, "3", self.level_3_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140)
	self.interactables[5] =
		button.new(85, 50, "4", self.level_4_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.interactables[6] =
		button.new(85, 50, "5", self.level_5_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140)
	self.interactables[7] =
		button.new(85, 50, "6", self.level_6_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, 100)
	self.interactables[8] =
		button.new(85, 50, "7", self.level_7_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 100)
	self.interactables[9] =
		button.new(85, 50, "8", self.level_8_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, 100)
	self.interactables[10] =
		button.new(100, 50, "Back", self.back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 50, -50)
end

function Level_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()

		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_x()
		end

		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()

		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_y()
		end

		window_y = love.graphics.getHeight()
	end
end

function Level_scene:draw()
	self.title_text:draw()

	for _, interactable in ipairs(self.interactables) do
		interactable:draw()
	end
end

function Level_scene:unload()
	setmetatable(Level_scene, nil)
end
