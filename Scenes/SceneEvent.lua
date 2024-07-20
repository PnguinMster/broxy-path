require("Utility.Enum")
require("Scenes.GameScene")
require("Scenes.MenuScene")
require("Scenes.LevelScene")

--NOTE: Check Key Released

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

-- NOTE: Check Button

function love.mousereleased(x, y, index)
	if index == 1 then
		if Game.scene == SCENE.MENU then
			menu_scene.start_button:check_pressed(x, y)
			menu_scene.options_button:check_pressed(x, y)
			menu_scene.quit_button:check_pressed(x, y)
		elseif Game.scene == SCENE.LEVEL then
			level_scene.level_0_button:check_pressed(x, y)
			level_scene.level_1_button:check_pressed(x, y)
			level_scene.level_2_button:check_pressed(x, y)
			level_scene.level_3_button:check_pressed(x, y)
			level_scene.level_4_button:check_pressed(x, y)
			level_scene.level_5_button:check_pressed(x, y)
			level_scene.level_6_button:check_pressed(x, y)
			level_scene.level_7_button:check_pressed(x, y)
			level_scene.level_8_button:check_pressed(x, y)
		elseif Game.scene == SCENE.GAME then
			if pause_menu.active then
				pause_menu.continue_button:check_pressed(x, y)
				pause_menu.retry_button:check_pressed(x, y)
				pause_menu.menu_button:check_pressed(x, y)
			elseif end_menu.active then
				end_menu.retry_button:check_pressed(x, y)
				end_menu.menu_button:check_pressed(x, y)
			end
		end
	end
end
