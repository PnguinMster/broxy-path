require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

local Level_scene = {}

Level_scene.interactables = {}

-- UI functions
local level_0_pressed = function()
	print("Level 0 pressed")
	Game.level = LEVEL_IMAGES.level_0
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_1_pressed = function()
	print("Level 1 pressed")
	Game.level = LEVEL_IMAGES.level_1
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_2_pressed = function()
	print("Level 2 pressed")
	Game.level = LEVEL_IMAGES.level_2
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_3_pressed = function()
	print("Level 3 pressed")
	Game.level = LEVEL_IMAGES.level_3
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_4_pressed = function()
	print("Level 4 pressed")
	Game.level = LEVEL_IMAGES.level_4
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_5_pressed = function()
	print("Level 5 pressed")
	Game.level = LEVEL_IMAGES.level_5
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_6_pressed = function()
	print("Level 6 pressed")
	Game.level = LEVEL_IMAGES.level_6
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_7_pressed = function()
	print("Level 7 pressed")
	Game.level = LEVEL_IMAGES.level_7
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_8_pressed = function()
	print("Level 8 pressed")
	Game.level = LEVEL_IMAGES.level_8
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local back_pressed = function()
	print("Back pressed")
	Game:set_scene(SCENE.MENU)
end

function Level_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	--title
	self.title_text = text.new("Select Level", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10, COLOR.WHITE)

	--buttons
	self.interactables[1] =
		button.new(85, 50, "0", level_0_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, -100)
	self.interactables[2] =
		button.new(85, 50, "1", level_1_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, -100)
	self.interactables[3] =
		button.new(85, 50, "2", level_2_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, -100)
	self.interactables[4] =
		button.new(85, 50, "3", level_3_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140)
	self.interactables[5] =
		button.new(85, 50, "4", level_4_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.interactables[6] =
		button.new(85, 50, "5", level_5_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140)
	self.interactables[7] =
		button.new(85, 50, "6", level_6_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -140, 100)
	self.interactables[8] =
		button.new(85, 50, "7", level_7_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 100)
	self.interactables[9] =
		button.new(85, 50, "8", level_8_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 140, 100)
	self.interactables[10] =
		button.new(100, 50, "Back", back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 50, -50)
end

function Level_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	-- Resize horizontal size
	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()

		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_x()
		end

		window_x = love.graphics.getWidth()
	end

	-- Resize vertical size
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
	-- Title
	self.title_text:unload()
	self.title_text = nil

	-- Unload interactables
	for x, element in pairs(self.interactables) do
		element:unload()
		self.interactables[x] = nil
	end
end

return Level_scene
