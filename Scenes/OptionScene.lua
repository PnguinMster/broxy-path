require("Game.Sound")
require("Utility.ColorEnum")
local button = require("UI.Button")
local text = require("UI.Text")
local checkbox = require("UI.Checkbox")
local slider = require("UI.Slider")

local Option_scene = {}

Option_scene.interactables = {}
Option_scene.text_displays = {}
Option_scene.option_sliders = {}

--- UI Functiions
local back_pressed = function()
	print("Back pressed")
	Game:set_scene(SCENE.MENU)
end
local fullscreen_pressed = function(is_checked)
	print("Fullscreen" .. tostring(is_checked))
	love.window.setFullscreen(is_checked)
	Save.fullscreen = is_checked
end
local vsync_pressed = function(is_checked)
	print("Vsync" .. tostring(is_checked))
	love.window.setVSync(is_checked)
	Save.vsync = is_checked
end
local master_volume_changed = function(new_value)
	print("Master Changed to:" .. tostring(new_value))
	Sound:set_volume(new_value, SOUND_TYPE.MASTER)
	Save.master_volume = new_value
end
local music_volume_changed = function(new_value)
	print("Music Changed to:" .. tostring(new_value))
	Sound:set_volume(new_value, SOUND_TYPE.MUSIC)
	Save.music_volume = new_value
end
local effect_volume_changed = function(new_value)
	print("Sound Changed to:" .. tostring(new_value))
	Sound:set_volume(new_value, SOUND_TYPE.EFFECT)
	Save.effect_volume = new_value
end

function Option_scene:load()
	-- UI elements
	--
	--  Title
	self.title_text =
		text.new("Options", FONT_SCALE.LARGE, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 30, COLOR.WHITE)
	self.interactables[1] =
		button.new(111, 60, "Back", back_pressed, nil, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.BOTTOM, 15, -45)

	--Fullscreen
	self.text_displays[1] =
		text.new("Fullscreen", FONT_SCALE.MEDIUM, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 30, -115, COLOR.WHITE)
	self.interactables[2] =
		checkbox.new(false, 1, fullscreen_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, -30, -115)

	-- Vsync
	self.text_displays[2] =
		text.new("Vsync", FONT_SCALE.MEDIUM, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 30, -43, COLOR.WHITE)
	self.interactables[3] =
		checkbox.new(false, 1, vsync_pressed, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, -30, -43)

	-- Master Volume
	self.text_displays[3] =
		text.new("Master Volume", FONT_SCALE.MEDIUM, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 30, 29, COLOR.WHITE)
	self.option_sliders[1] = slider.new(
		Save.master_volume,
		0,
		1,
		100,
		7,
		200,
		4,
		master_volume_changed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		-30,
		29
	)

	-- Music Volume
	self.text_displays[4] =
		text.new("Music Volume", FONT_SCALE.MEDIUM, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 30, 101, COLOR.WHITE)
	self.option_sliders[2] = slider.new(
		Save.music_volume,
		0,
		1,
		100,
		7,
		200,
		4,
		music_volume_changed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		-30,
		101
	)

	-- Effect Volume
	self.text_displays[5] =
		text.new("Effect Volume", FONT_SCALE.MEDIUM, HORIZONTAL_ALIGN.LEFT, VERTICAL_ALIGN.CENTER, 30, 173, COLOR.WHITE)
	self.option_sliders[3] = slider.new(
		Save.effect_volume,
		0,
		1,
		100,
		7,
		200,
		4,
		effect_volume_changed,
		HORIZONTAL_ALIGN.RIGHT,
		VERTICAL_ALIGN.CENTER,
		-30,
		173
	)
end

function Option_scene:resize(width, height)
	self.title_text:auto_resize_x(width)
	self.title_text:auto_resize_y(height)

	for _, interactable in ipairs(self.interactables) do
		interactable:auto_resize_x(width)
		interactable:auto_resize_y(height)
	end
	for _, text_display in ipairs(self.text_displays) do
		text_display:auto_resize_x(width)
		text_display:auto_resize_y(height)
	end
	for _, option_slider in ipairs(self.option_sliders) do
		option_slider:auto_resize_x(width)
		option_slider:auto_resize_y(height)
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
	for x, element in ipairs(self.interactables) do
		element:unload()
		self.interactables[x] = nil
	end

	-- Unload Text
	for x, text_display in ipairs(self.text_displays) do
		text_display:unload()
		self.text_displays[x] = nil
	end

	-- Unload Slider
	for x, text_slider in ipairs(self.option_sliders) do
		text_slider:unload()
		self.text_displays[x] = nil
	end
end

return Option_scene
