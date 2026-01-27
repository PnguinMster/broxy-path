require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")

local End_menu = { active = false }

End_menu.interactables = {}

-- UI Function
local retry_pressed = function()
	print("Retry pressed")
	Game:set_state(STATE.GAME)
	End_menu.active = false
	Player:reset_player()
end
local menu_pressed = function()
	print("Menu pressed")
	End_menu.active = false
	Game:set_scene(SCENE.MENU)
end

function End_menu:load()
	self.active = false

	--title
	self.title_text =
		text.new("Finished", FONT_SCALE.LARGE, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 30, COLOR.WHITE)

	--buttons
	self.interactables[1] =
		button.new(135, 63, "Retry", retry_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, -58)
	self.interactables[2] =
		button.new(231, 63, "Main Menu", menu_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 58)
end

function End_menu:resize(width, height)
	self.title_text:auto_resize_x(width)
	self.title_text:auto_resize_y(height)

	for _, interactable in ipairs(self.interactables) do
		interactable:auto_resize_x(width)
		interactable:auto_resize_y(height)
	end
end

function End_menu:draw()
	if self.active == false then
		return
	end

	self.title_text:draw()
	for _, interactable in ipairs(self.interactables) do
		interactable:draw()
	end
end

function End_menu:unload()
	-- Title
	self.title_text:unload()
	self.title_text = nil

	-- Unload interactables
	for x, element in pairs(self.interactables) do
		element:unload()
		self.interactables[x] = nil
	end
end

return End_menu
