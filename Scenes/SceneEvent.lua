require("Utility.StateEnum")
require("Utility.SceneEnum")
require("Utility.SoundEffectEnum")
require("Game.Sound")
local pause_menu = require("UI.PauseMenu")
local end_menu = require("UI.EndMenu")

local hovered_ui = nil

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
		if hovered_ui then
			if hovered_ui.check_pressed then
				hovered_ui:check_pressed(x, y)
				Sound:play_sound_effect(SOUND_EFFECT.CLICK)
				hovered_ui = nil
			else
				hovered_ui:mouse_released()
			end
		end
	end
end

function love.mousepressed(x, y, index)
	if index == 1 then
		if hovered_ui and hovered_ui.check_held then
			hovered_ui:check_held(x, y)
		end
	end
end

function love.mousemoved(x, y)
	local check_display = nil
	check_display = Game.scene

	if Game.scene == SCENE.GAME then
		if pause_menu.active then
			check_display = pause_menu
		elseif end_menu.active then
			check_display = end_menu
		end
	end

	local ui_item = nil
	for _, interactable in ipairs(check_display.interactables) do
		ui_item = interactable:check_is_hovered(x, y)
		if ui_item then
			break
		end
	end

	if check_display == SCENE.OPTION then
		for _, option_slider in ipairs(check_display.option_sliders) do
			option_slider:mouse_moved(x)
			if ui_item == nil then
				ui_item = option_slider:check_is_hovered(x, y)
				if ui_item then
					break
				end
			end
		end
	end

	if ui_item ~= hovered_ui then
		hovered_ui = ui_item
		if hovered_ui then
			--play sound
			--change visual
			Sound:play_sound_effect(SOUND_EFFECT.UI_HOVER)
		end
	end
end
