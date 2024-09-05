local button = require("UI.Button")
local text = require("UI.Text")

Pause_menu = { active = false }
Pause_menu.__index = Pause_menu
setmetatable({}, Pause_menu)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

function Pause_menu:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.continue_pressed = function()
		print("Continue pressed")
		self.active = false
		Game:set_state(STATE.GAME)
	end
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

	self.title_text = text.new("Paused", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10)

	self.continue_button = button.new(
		85,
		50,
		"Continue",
		self.continue_pressed,
		nil,
		HORIZONTAL_ALIGN.CENTER,
		VERTICAL_ALIGN.CENTER,
		0,
		-140
	)
	self.retry_button =
		button.new(85, 50, "Retry", self.retry_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 0)
	self.menu_button =
		button.new(85, 50, "Main Menu", self.menu_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 140)
end

function Pause_menu:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()
		self.continue_button:auto_resize_x()
		self.retry_button:auto_resize_x()
		self.menu_button:auto_resize_x()
		window_x = love.graphics.getWidth()
	end

	if y_difference >= RESIZE_DIFFERENCE then
		self.continue_button:auto_resize_y()
		self.retry_button:auto_resize_y()
		self.menu_button:auto_resize_y()
		window_y = love.graphics.getHeight()
	end
end

function Pause_menu:draw()
	if self.active == false then
		return
	end

	self.title_text:draw()
	self.continue_button:draw()
	self.retry_button:draw()
	self.menu_button:draw()
end

function Pause_menu:unload()
	setmetatable(Pause_menu, nil)
end