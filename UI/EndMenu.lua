local button = require("UI.Button")
local text = require("UI.Text")

End_menu = { active = false }
End_menu.__index = End_menu
setmetatable({}, End_menu)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

function End_menu:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.interactables = {}

	self.retry_pressed = function()
		print("Retry pressed")
		Game:set_state(STATE.GAME)
		self.active = false
		Player:reset_player()
	end
	self.menu_pressed = function()
		print("Menu pressed")
		self.active = false
		Game:set_scene(SCENE.MENU)
	end

	self.title_text = text.new("Finished", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.interactables[1] =
		button.new(85, 50, "Retry", self.retry_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 0)
	self.interactables[2] =
		button.new(85, 50, "Main Menu", self.menu_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function End_menu:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_x()
		end
		self.retry_butt:auto_resize_x()
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
	setmetatable(Pause_menu, nil)
end
