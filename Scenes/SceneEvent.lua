require("Utility.StateEnum")
require("Utility.SceneEnum")
require("Utility.SoundEffectEnum")
require("Game.Sound")
local pause_menu = require("UI.PauseMenu")
local end_menu = require("UI.EndMenu")

local hovered_ui = nil
local is_holding = false

function love.keyreleased(key)
	if Game.scene == SCENE.GAME then
		if key == "escape" then
			if Game.state == STATE.GAME and end_menu.active == false then
				Game:set_state(STATE.MENU)
				pause_menu.active = true
			else
				Game:set_state(STATE.GAME)
				pause_menu.active = false
			end
		end
	end
end

function love.mousereleased(x, y, index)
	if index == 1 then
		--press button that is being hovered
		if hovered_ui then
			if hovered_ui.check_pressed then
				hovered_ui:check_pressed(x, y)
				Sound:play_sound_effect(SOUND_EFFECT.CLICK)
				hovered_ui = nil
			else
				--Slider Specific
				hovered_ui:mouse_released()
				is_holding = false
			end
		end
	end
end

function love.mousepressed(x, y, index)
	if index == 1 then
		--Slider Specific
		if hovered_ui and hovered_ui.check_held then
			hovered_ui:check_held(x, y)
			is_holding = true
		end
	end
end

function love.mousemoved(x, y)
	local check_display = nil
	check_display = Game.scene

	--get menu for game
	--pause or end menu since not always active
	if Game.scene == SCENE.GAME then
		if pause_menu.active then
			check_display = pause_menu
		elseif end_menu.active then
			check_display = end_menu
		end
	end

	--return if no ui elemnts found
	if check_display == nil or check_display.interactables == nil then
		hovered_ui = nil
		return
	end

	--Slider Specific
	if is_holding then
		if hovered_ui then
			hovered_ui:mouse_moved(x)
		end
		return
	end

	local ui_item = nil
	--check for basic interactables
	for _, interactable in ipairs(check_display.interactables) do
		ui_item = interactable:check_is_hovered(x, y)
		if ui_item then
			break
		end
	end

	--Slider Specific
	if check_display == SCENE.OPTION then
		for _, option_slider in ipairs(check_display.option_sliders) do
			if ui_item == nil then
				ui_item = option_slider:check_is_hovered(x, y)
				if ui_item then
					break
				end
			end
		end
	end

	--set which ui is being hovered on
	if ui_item ~= hovered_ui then
		--for when it is not hovering on anything
		if hovered_ui ~= nil and hovered_ui.set_hovered then
			hovered_ui:set_hovered(false)
		end

		hovered_ui = ui_item

		--play sound when hovered
		if hovered_ui then
			Sound:play_sound_effect(SOUND_EFFECT.UI_HOVER)
			if hovered_ui.set_hovered then
				hovered_ui:set_hovered(true)
			end
		end
	end
end
