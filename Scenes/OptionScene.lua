require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")
local checkbox = require("UI.Checkbox")
local slider = require("UI.Slider")
local cycle_list = require("UI.CycleList")

local Option_scene = {}

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

Option_scene.interactables = {}
Option_scene.text_displays = {}
Option_scene.option_sliders = {}

--- UI Functiions
local back_pressed = function()
	print("Back pressed")
	Game:set_scene(SCENE.MENU)
end
local mix_with_system_pressed = function(is_checked)
	print("Mix with system is: " .. tostring(is_checked))
end
local borderless_pressed = function(is_checked)
	print("Borderless" .. tostring(is_checked))
end
local fullscreen_pressed = function(is_checked)
	print("Fullscreen" .. tostring(is_checked))
end
local exclusive = function(is_checked)
	print("Exclusive" .. tostring(is_checked))
end
local vsync_pressed = function(is_checked)
	print("Vsync" .. tostring(is_checked))
end
local cycle_displays_pressed = function()
	print("Cycle Displays Pressed")
end
local master_volume_changed = function(new_value)
	print("Master Changed to:" .. tostring(new_value))
end
local music_volume_changed = function(new_value)
	print("Music Changed to:" .. tostring(new_value))
end
local sound_volume_changed = function(new_value)
	print("Sound Changed to:" .. tostring(new_value))
end

function Option_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()
	self.displays_list = { "1", "2", "3" }

	-- UI elements
	--  Title
	self.title_text = text.new("Options", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10, COLOR.WHITE)
	self.interactables[1] =
		button.new(100, 50, "Back", back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 50, -50)

	-- Audio plays in background
	self.text_displays[1] =
		text.new("Audio Plays in Background", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -270, COLOR.WHITE)
	self.interactables[2] =
		checkbox.new(true, 1, mix_with_system_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -270)

	-- Borderless
	self.text_displays[2] =
		text.new("Borderless", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -225, COLOR.WHITE)
	self.interactables[3] =
		checkbox.new(false, 1, borderless_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -225)

	--Fullscreen
	self.text_displays[3] =
		text.new("Fullscreen", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -180, COLOR.WHITE)
	self.interactables[4] =
		checkbox.new(false, 1, fullscreen_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -180)

	--Exculsive fullscreen
	self.text_displays[4] =
		text.new("Exclusive Fullscreen", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -135, COLOR.WHITE)
	self.interactables[5] = checkbox.new(false, 1, exclusive, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -135)

	-- Vsync
	self.text_displays[5] = text.new("Vsync", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -90, COLOR.WHITE)
	self.interactables[6] = checkbox.new(false, 1, vsync_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -90)

	-- Display
	self.text_displays[6] = text.new("Display", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -45, COLOR.WHITE)
	self.interactables[7] = cycle_list.new(
		self.displays_list,
		cycle_displays_pressed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		0,
		-45
	)

	-- Master Volume
	self.text_displays[7] =
		text.new("Master Volume", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, 0, COLOR.WHITE)
	self.option_sliders[1] =
		slider.new(100, 0, 100, 5, 200, 3, master_volume_changed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, 0)

	-- Music Volume
	self.text_displays[8] =
		text.new("Music Volume", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, 45, COLOR.WHITE)
	self.option_sliders[2] =
		slider.new(100, 0, 100, 5, 200, 3, music_volume_changed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, 45)

	-- Sound Volume
	self.text_displays[9] =
		text.new("Sound Volume", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, 90, COLOR.WHITE)
	self.option_sliders[3] =
		slider.new(100, 0, 100, 5, 200, 3, sound_volume_changed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, 90)
end

function Option_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

	-- Resize x
	if x_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_x()

		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_x()
		end
		for _, text_display in ipairs(self.text_displays) do
			text_display:auto_resize_x()
		end
		for _, option_slider in ipairs(self.option_sliders) do
			option_slider:auto_resize_x()
		end

		window_x = love.graphics.getWidth()
	end

	-- Resize y
	if y_difference >= RESIZE_DIFFERENCE then
		self.title_text:auto_resize_y()

		for _, interactable in ipairs(self.interactables) do
			interactable:auto_resize_y()
		end
		for _, text_display in ipairs(self.text_displays) do
			text_display:auto_resize_y()
		end
		for _, option_slider in ipairs(self.option_sliders) do
			option_slider:auto_resize_y()
		end

		window_y = love.graphics.getHeight()
	end
end

function Option_scene:draw()
	self.title_text:draw()
	for _, interactable in ipairs(self.interactables) do
		interactable:draw()
	end

	for _, text_display in ipairs(self.text_displays) do
		text_display:draw()
	end

	for _, option_slider in ipairs(self.option_sliders) do
		option_slider:draw()
	end
end

function Option_scene:unload()
	-- Title
	self.title_text:unload()
	self.title_text = nil

	-- Unload interactables
	for x, element in pairs(self.interactables) do
		element:unload()
		self.interactables[x] = nil
	end

	-- Unload Text
	for x, text_display in pairs(self.text_displays) do
		text_display:unload()
		self.text_displays[x] = nil
	end

	-- Unload Slider
	for x, text_slider in pairs(self.option_sliders) do
		text_slider:unload()
		self.text_displays[x] = nil
	end
end

return Option_scene
