function love.conf(t)
	t.window.width = 850
	t.window.height = 750
	t.window.icon = nil
	t.window.title = "Broxy Grath"
	t.window.resizable = true
	t.window.vsync = 0
	t.window.minwidth = 400
	t.window.minheight = 300
	t.window.display = 2

	t.modules.data = false
	t.modules.system = false
	t.modules.touch = false
	t.modules.video = false

	t.version = "11.5"
end
