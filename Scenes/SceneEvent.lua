require("Utility.StateEnum")
require("Utility.SceneEnum")

function love.keyreleased(key)
	if Game.scene == SCENE.GAME then
		if key == "escape" then
			if Game.state == STATE.GAME and End_menu.active == false then
				Game:set_state(STATE.MENU)
				Pause_menu.active = true
			else
				Game:set_state(STATE.GAME)
				Pause_menu.active = false
			end
		end
	end
end

function love.mousereleased(x, y, index)
	if index == 1 then
		local check_display = nil
		check_display = Game.scene

		if Game.scene == SCENE.GAME then
			if Pause_menu.active then
				check_display = Pause_menu
			elseif End_menu.active then
				check_display = End_menu
			end
		end

		for _, interactable in ipairs(check_display.interactables) do
			interactable:check_pressed(x, y)
		end

		if check_display == SCENE.OPTION then
			check_display.test_slider:mouse_released()
		end
	end
end

function love.mousepressed(x, y, index)
	if index == 1 then
		if Game.scene == SCENE.OPTION then
			Game.scene.test_slider:check_pressed(x, y)
		end
	end
end

function love.mousemoved(x)
	if Game.scene == SCENE.OPTION then
		Game.scene.test_slider:mouse_moved(x)
	end
end
