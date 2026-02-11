require('Utility.ColorEnum')
local button = require('UI.Button')
local text = require('UI.Text')

local Menu_scene = {}

Menu_scene.interactables = {}

--UI Functions
local start_pressed = function()
  print('Start button pressed')
  Game:set_scene(SCENE.LEVEL)
end

local options_pressed = function()
  print('Options button pressed')
  Game:set_scene(SCENE.OPTION)
end

local quit_pressed = function()
  print('Quit button pressed')
  love.event.push('quit')
end

function Menu_scene:load()
  --title
  self.title_text = text.new('Broxy Grath', FONT_SCALE.LARGE, HORIZONTAL_ALIGN.CENTER, VERTICAL_ALIGN.TOP, 0, 30, COLOR.WHITE)

  --buttons
  local button_offset = 45
  -- Buttons size is roughly:
  -- Width = (FONT_SCALE) * (Character Count) + 15
  self.interactables[1] = button.new(135, 60, 'Start', start_pressed, nil, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, -68 - button_offset, -30)
  self.interactables[2] = button.new(183, 60, 'Options', options_pressed, nil, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, -92 - button_offset, 75)
  self.interactables[3] = button.new(111, 60, 'Quit', quit_pressed, nil, HORIZONTAL_ALIGN.RIGHT, VERTICAL_ALIGN.CENTER, -56 - button_offset, 180)
end

function Menu_scene:resize(width, height)
  self.title_text:auto_resize_x(width)
  self.title_text:auto_resize_y(height)

  for _, interactable in ipairs(self.interactables) do
    interactable:auto_resize_x(width)
    interactable:auto_resize_y(height)
  end
end

function Menu_scene:draw()
  self.title_text:draw()
  for _, interactable in ipairs(self.interactables) do
    interactable:draw()
  end
end

function Menu_scene:unload()
  -- Title
  self.title_text:unload()
  self.title_text = nil

  -- Unload interactables
  for x, element in pairs(self.interactables) do
    element:unload()
    self.interactables[x] = nil
  end
end

return Menu_scene
