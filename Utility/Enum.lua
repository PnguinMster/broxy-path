require("Scenes.MenuScene")
require("Scenes.LevelScene")
require("Scenes.GameScene")

SCENE = {
	MENU = menu_scene,
	GAME = game_scene,
	LEVEL = level_scene,
}

STATE = {
	MENU = 1,
	GAME = 2,
}

LAYERS = {
	DEFAULT = 1,
	LEVEL = 2,
	PLAYER = 3,
	TRIGGER = 5,
}

HORIZONTAL_ALIGN = {
	LEFT = 1,
	RIGHT = 2,
	CENTER = 3,
}

VERTICAL_ALIGN = {
	TOP = 1,
	BOTTOM = 2,
	CENTER = 3,
}

BLOCK_TYPE = {
	START = { r = 168, g = 202, b = 88 }, -- Lime
	STATIC_BLOCK = { r = 235, g = 237, b = 233 }, -- White
	VERTICAL_BLOCK = { r = 115, g = 190, b = 211 }, -- Light Blue
	HORIZONTAL_BLOCK = { r = 37, g = 58, b = 94 }, -- Dark Blue
	BOUNCE_BLOCK = { r = 218, g = 134, b = 62 }, -- Orange
	VERTICAL_BOUNCE = { r = 207, g = 87, b = 60 }, -- Red
	HORIZONTAL_BOUNCE = { r = 117, g = 36, b = 56 }, -- Maroon
	ROTATING_BLOCK = { r = 122, g = 54, b = 123 }, -- Purple
	ROTATING_BOUNCE = { r = 223, g = 132, b = 165 }, -- Pink
	END = { r = 87, g = 114, b = 119 }, -- Gray
}

LEVEL_IMAGES = {
	test = "Art/Level/test_block_colored.png",
	level_0 = "Art/Level/level_0.png",
	level_1 = "Art/Level/level_1.png",
	level_2 = "Art/Level/level_2.png",
	level_3 = "Art/Level/level_3.png",
	level_4 = "Art/Level/level_4.png",
	level_5 = "Art/Level/level_5.png",
	level_6 = "Art/Level/level_6.png",
	level_7 = "Art/Level/level_7.png",
	level_8 = "Art/Level/level_8.png",
}
