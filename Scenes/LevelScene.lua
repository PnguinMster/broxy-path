require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")

local levels_unlocked = 1

local Level_scene = {}

Level_scene.interactables = {}

-- UI functions
local level_0_pressed = function()
	print("Level 0 pressed")
	Game.level = 1
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_1_pressed = function()
	print("Level 1 pressed")
	Game.level = 2
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_2_pressed = function()
	print("Level 2 pressed")
	Game.level = 3
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_3_pressed = function()
	print("Level 3 pressed")
	Game.level = 4
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_4_pressed = function()
	print("Level 4 pressed")
	Game.level = 5
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_5_pressed = function()
	print("Level 5 pressed")
	Game.level = 6
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_6_pressed = function()
	print("Level 6 pressed")
	Game.level = 7
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_7_pressed = function()
	print("Level 7 pressed")
	Game.level = 8
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local level_8_pressed = function()
	print("Level 8 pressed")
	Game.level = 9
	Game:set_scene(SCENE.GAME)
	Game:set_state(STATE.GAME)
end
local back_pressed = function()
	print("Back pressed")
	Game:set_scene(SCENE.MENU)
end

function Level_scene:load()
	levels_unlocked = Save.unlocked_levels

	--title
	self.title_text =
		text.new("Select Level", FONT_SCALE.LARGE, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 30, COLOR.WHITE)

	--buttons
	self.interactables[1] =
		button.new(63, 60, "0", level_0_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -125, -125)
	self.interactables[2] =
		button.new(63, 60, "1", level_1_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, -125)
	self.interactables[3] =
		button.new(63, 60, "2", level_2_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 125, -125)
	self.interactables[4] =
		button.new(63, 60, "3", level_3_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -125)
	self.interactables[5] =
		button.new(63, 60, "4", level_4_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	self.interactables[6] =
		button.new(63, 60, "5", level_5_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 125)
	self.interactables[7] =
		button.new(63, 60, "6", level_6_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, -125, 125)
	self.interactables[8] =
		button.new(63, 60, "7", level_7_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 125)
	self.interactables[9] =
		button.new(63, 60, "8", level_8_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 125, 125)
	self.interactables[10] =
		button.new(111, 60, "Back", back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 15, -45)

	-- Disabled locked levels
	for i = #self.interactables - 1, 2, -1 do
		if i > levels_unlocked then
			self.interactables[i]:set_disabled(true)
		else
			return
		end
	end
end

function Level_scene:resize(width, height)
	self.title_text:auto_resize_x(width)
	self.title_text:auto_resize_y(height)

	for _, interactable in ipairs(self.interactables) do
		interactable:auto_resize_x(width)
		interactable:auto_resize_y(height)
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
