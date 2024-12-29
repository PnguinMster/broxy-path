require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")
local checkbox = require("UI.Checkbox")
local slider = require("UI.Slider")
local cycle_list = require("UI.CycleList")

Option_scene = {}
Option_scene.__index = Option_scene
setmetatable({}, Option_scene)

local RESIZE_DIFFERENCE = 5
local window_x = 0
local window_y = 0

-- local test_list = { "first", "second", "third", "last" }

function Option_scene:load()
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	self.interactables = {}
	self.text_displays = {}
	self.option_sliders = {}
	self.displays_list = { "1", "2", "3" }

	-- self.start_pressed = function()
	-- 	print("Start button pressed")
	-- end
	-- self.checkbox_pressed = function(is_checked)
	-- 	print("Checkbox pressed")
	-- 	print("Value is: " .. tostring(is_checked))
	-- end
	self.back_pressed = function()
		print("Back pressed")
		Game:set_scene(SCENE.MENU)
	end
	-- self.slider_pressed = function()
	-- 	print("Slider pressed")
	-- end
	-- self.cycle_list_pressed = function()
	-- 	print("Cycle List pressed")
	-- end
	self.mix_with_system_pressed = function(is_checked)
		print("Mix with system is: " .. tostring(is_checked))
	end
	self.borderless_pressed = function(is_checked)
		print("Borderless" .. tostring(is_checked))
	end
	self.fullscreen_pressed = function(is_checked)
		print("Fullscreen" .. tostring(is_checked))
	end
	self.exclusive = function(is_checked)
		print("Exclusive" .. tostring(is_checked))
	end
	self.vsync_pressed = function(is_checked)
		print("Vsync" .. tostring(is_checked))
	end
	self.cycle_displays_pressed = function()
		print("Cycle Displays Pressed")
	end
	self.master_volume_changed = function(new_value)
		print("Master Changed to:" .. tostring(new_value))
	end
	self.music_volume_changed = function(new_value)
		print("Music Changed to:" .. tostring(new_value))
	end
	self.sound_volume_changed = function(new_value)
		print("Sound Changed to:" .. tostring(new_value))
	end

	self.title_text = text.new("Options", 3, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 10, COLOR.WHITE)
	--
	-- self.interactables[7] =
	-- 	button.new(70, 50, "Start", self.start_pressed, nil, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER)
	--
	-- self.interactables[2] =
	-- 	checkbox.new(false, 1, self.checkbox_pressed, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 80)
	--
	-- self.test_slider =
	-- 	slider.new(5, 0, 10, 12, 240, 8, self.slider_pressed, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 120)
	--
	-- self.interactables[7] =
	-- 	cycle_list.new(test_list, self.cycle_list_pressed, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.CENTER, 0, 200)
	--
	self.interactables[1] =
		button.new(100, 50, "Back", self.back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 50, -50)

	self.text_displays[1] =
		text.new("Audio Plays in Background", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -270, COLOR.WHITE)
	self.interactables[2] =
		checkbox.new(true, 1, self.mix_with_system_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -270)

	self.text_displays[2] =
		text.new("Borderless", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -225, COLOR.WHITE)
	self.interactables[3] =
		checkbox.new(false, 1, self.borderless_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -225)

	self.text_displays[3] =
		text.new("Fullscreen", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -180, COLOR.WHITE)
	self.interactables[4] =
		checkbox.new(false, 1, self.fullscreen_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -180)

	self.text_displays[4] =
		text.new("Exclusive Fullscreen", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -135, COLOR.WHITE)
	self.interactables[5] =
		checkbox.new(false, 1, self.exclusive, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -135)

	self.text_displays[5] = text.new("Vsync", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -90, COLOR.WHITE)
	self.interactables[6] =
		checkbox.new(false, 1, self.vsync_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, 0, -90)

	self.text_displays[6] = text.new("Display", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, -45, COLOR.WHITE)
	self.interactables[7] = cycle_list.new(
		self.displays_list,
		self.cycle_displays_pressed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		0,
		-45
	)

	self.text_displays[7] =
		text.new("Master Volume", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, 0, COLOR.WHITE)
	self.option_sliders[1] = slider.new(
		100,
		0,
		100,
		5,
		200,
		3,
		self.master_volume_changed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		0,
		0
	)

	self.text_displays[8] =
		text.new("Music Volume", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, 45, COLOR.WHITE)
	self.option_sliders[2] = slider.new(
		100,
		0,
		100,
		5,
		200,
		3,
		self.music_volume_changed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		0,
		45
	)

	self.text_displays[9] =
		text.new("Sound Volume", 1, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 0, 90, COLOR.WHITE)
	self.option_sliders[3] = slider.new(
		100,
		0,
		100,
		5,
		200,
		3,
		self.sound_volume_changed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		0,
		90
	)
end

function Option_scene:update(dt)
	local x_difference = math.abs(window_x - love.graphics.getWidth())
	local y_difference = math.abs(window_y - love.graphics.getHeight())

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
	-- self.test_slider:draw()
end

function Option_scene:unload()
	setmetatable(Option_scene, nil)
end
