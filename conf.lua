function love.conf(t)
	--Window Configuration
	t.window.title = "Broxy Grath"
	t.window.icon = nil
	t.window.width = 850
	t.window.height = 750
	t.window.minwidth = 350
	t.window.minheight = 350
	t.window.resizable = true
	t.window.vsync = 1
	t.console = false

	--Disable unused modules
	t.modules.data = false
	t.modules.system = false
	t.modules.touch = false
	t.modules.video = false

	t.version = "11.5" --LOVE version

	t.identity = "Broxy_Path" --save directory name
end
