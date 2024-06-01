_G.love = require("love")

function love.load()
	_G.player = {}
	player.x = 400
	player.y = 200
	player.speed = 300
end

function love.update(dt)
	if love.keyboard.isDown("right", "d") then
		player.x = player.x + player.speed * dt
	elseif love.keyboard.isDown("left", "a") then
		player.x = player.x - player.speed * dt
	end

	if love.keyboard.isDown("down", "s") then
		player.y = player.y + player.speed * dt
	elseif love.keyboard.isDown("up", "w") then
		player.y = player.y - player.speed * dt
	end
end

function love.draw()
	love.graphics.rectangle("line", player.x, player.y, 30, 60)
end
