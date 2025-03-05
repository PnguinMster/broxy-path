require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")

local End_menu = { active = false }

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

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

	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	--title
	self.title_text =
		text.new("Finished", FONT_SCALE.LARGE, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10, COLOR.WHITE)

	--buttons
	self.interactables[1] =
		button.new(85, 50, "Retry", retry_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 0)
	self.interactables[2] =
		button.new(85, 50, "Main Menu", menu_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function End_menu:update(_)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	--auto resize horizontally
	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_x()
		end
		self.retry_butt:auto_resize_x()
		window_x = love.graphics.getWidth()
	end

	--auto resize vertically
	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()
		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_y()
		end
		window_y = love.graphics.getHeight()
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
