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
			for _, interactable in ipairs(Menu_scene.interactables) do
				interactable:check_pressed(x, y)
			end
		elseif Game.scene == SCENE.LEVEL then
			for _, interactable in ipairs(Level_scene.interactables) do
				interactable:check_pressed(x, y)
			end
		elseif Game.scene == SCENE.GAME then
			if Pause_menu.active then
				for _, interactable in ipairs(Pause_menu.interactables) do
					interactable:check_pressed(x, y)
				end
			elseif End_menu.active then
				for _, interactable in ipairs(End_menu.interactables) do
					interactable:check_pressed(x, y)
				end
			end
		elseif Game.scene == SCENE.OPTION then
			for _, interactable in ipairs(Option_scene.interactables) do
				interactable:check_pressed(x, y)
			end
		end
	end
end
