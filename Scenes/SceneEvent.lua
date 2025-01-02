require("Utility.StateEnum")
require("Utility.SceneEnum")
local pause_menu = require("UI.PauseMenu")
local end_menu = require("UI.EndMenu")

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
		local check_display = nil
		check_display = Game.scene

		if Game.scene == SCENE.GAME then
			if pause_menu.active then
				check_display = pause_menu
			elseif end_menu.active then
				check_display = end_menu
			end
		end

		for _, interactable in ipairs(check_display.interactables) do
			interactable:check_pressed(x, y)
		end

		if check_display == SCENE.OPTION then
			for _, option_slider in ipairs(check_display.option_sliders) do
				option_slider:mouse_released()
			end
		end
	end
end

function love.mousepressed(x, y, index)
	if index == 1 then
		if Game.scene == SCENE.OPTION then
			for _, option_slider in ipairs(Game.scene.option_sliders) do
				option_slider:check_pressed(x, y)
			end
		end
	end
end

function love.mousemoved(x)
	if Game.scene == SCENE.OPTION then
		for _, option_slider in ipairs(Game.scene.option_sliders) do
			option_slider:mouse_moved(x)
		end
	end
end
