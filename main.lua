_G.love = require("love")

function love.load()
	World = love.physics.newWorld(0, 30, true)

	Player = {}
	Player.x = 300
	Player.y = 100
	Player.width = 30
	Player.height = 60
	Player.body = love.physics.newBody(World, Player.x, Player.y, "dynamic")
	Player.shape = love.physics.newRectangleShape(Player.width, Player.height)
	Player.fixture = love.physics.newFixture(Player.body, Player.shape, 3)

	Ground = {}

	Ground.x = 300
	Ground.y = 400
	Ground.width = 90
	Ground.height = 30
	Ground.body = love.physics.newBody(World, Ground.x, Ground.y, "static")
	Ground.shape = love.physics.newRectangleShape(Ground.width, Ground.height)
	Ground.fixture = love.physics.newFixture(Ground.body, Ground.shape, 3)
end

function love.update(dt)
	World:update(dt)
end

function love.draw()
	love.graphics.rectangle("line", Player.x, Player.y, Player.width, Player.height, 3, 3)
	love.graphics.rectangle("line", Ground.x, Ground.y, Ground.width, Ground.height)
end
