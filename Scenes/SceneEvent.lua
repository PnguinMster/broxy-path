require("Utility.StateEnum")
require("Utility.SceneEnum")
require("Scenes.GameScene")
require("Scenes.MenuScene")
require("Scenes.LevelScene")

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
		if Game.scene == SCENE.MENU then
			Menu_scene.start_button:check_pressed(x, y)
			Menu_scene.options_button:check_pressed(x, y)
			Menu_scene.quit_button:check_pressed(x, y)
		elseif Game.scene == SCENE.LEVEL then
			Level_scene.level_0_button:check_pressed(x, y)
			Level_scene.level_1_button:check_pressed(x, y)
			Level_scene.level_2_button:check_pressed(x, y)
			Level_scene.level_3_button:check_pressed(x, y)
			Level_scene.level_4_button:check_pressed(x, y)
			Level_scene.level_5_button:check_pressed(x, y)
			Level_scene.level_6_button:check_pressed(x, y)
			Level_scene.level_7_button:check_pressed(x, y)
			Level_scene.level_8_button:check_pressed(x, y)
		elseif Game.scene == SCENE.GAME then
			if Pause_menu.active then
				Pause_menu.continue_button:check_pressed(x, y)
				Pause_menu.retry_button:check_pressed(x, y)
				Pause_menu.menu_button:check_pressed(x, y)
			elseif End_menu.active then
				End_menu.retry_button:check_pressed(x, y)
				End_menu.menu_button:check_pressed(x, y)
			end
		elseif Game.scene == SCENE.OPTION then
			Option_scene.start_button:check_pressed(x, y)
			Option_scene.test_checkbox:check_pressed(x, y)
		end
	end
end
