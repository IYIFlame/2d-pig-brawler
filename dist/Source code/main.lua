require "utils"
require "create_world"
require "pigeh_unit_locomotion"

io.stdout:setvbuf("no")

local player_settings = {
	{ index = 1, position = {30,30}, color = {255,50,50} 	},
	{ index = 2, position = {90,30}, color = {0,0,255} 		},
	{ index = 3, position = {30,90}, color = {0,255,0} 		},
	{ index = 4, position = {90,90}, color = {255,255,0} 	},
}

local player_keybindings = {
	w = 	 { 1, "up" 		},
	a = 	 { 1, "left" 	},
	d = 	 { 1, "right" 	},
	v =		 { 1, "shoot" 	},
	up = 	 { 2, "up" 		},
	left = 	 { 2, "left" 	},
	right =  { 2, "right" 	},
	rshift = { 2, "shoot" 	},
}

function love.load()
	love.physics.setMeter(32)
	physics_world = love.physics.newWorld(0, 80*32, true)
	physics_world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	Tileset = love.graphics.newImage( 'images/tileset.png' )
	tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
	background = Utils.getNewQuad( 0, 0, 256, 256 )
	backgroundW, backgroundH = 256, 256

	game_world = CreateWorld:new(physics_world)
	objects = game_world:get_world_objects()


	pigehs = {}
	bacon_rashers = {}
end

function love.update(dt)
	physics_world:update(dt) --this puts the world into motion
	for _, pigeh in pairs( pigehs ) do
		pigeh:update(dt)
	end

	for bacon, _ in pairs( bacon_rashers ) do
		bacon:update(dt)
	end
end

function love.keypressed(key, isrepeat)
	local number = tonumber( key )
	if number then
		if number > 0 and number < 5 then
			player_joined( number )
		end
	else
		local player_keybinds = player_keybindings[key]
		local player_index = player_keybinds and player_keybindings[key][1] or nil
		local pigeh = player_index and pigehs[ player_index ] or nil

		if pigeh then
			pigeh:key_pressed( player_keybindings[key][2], isrepeat )
		end
	end
end

function player_joined( player_index )
	if pigehs[ player_index ] ~= nil then --change players to be false instead of nil that way we can easily ask for how many are alive
		return
	end
	pigeh = Pigeh_unit_locomotion:new("pigeh", Tileset, tilesetW, tilesetH, player_settings[ player_index ])
	pigehs[ player_index ] = pigeh
end

function player_left( player_index )
	local pigeh = pigehs[ player_index ]
	local pigeh_unit = pigeh:get_unit()
	local pigeh_fixture = pigeh_unit.fixture
	pigehs[ player_index ] = nil
	pigeh = nil
	pigeh_fixture:destroy()
end

function register_bacon( bacon, player_index )
	bacon_rashers[ bacon ] = player_index
end

function destroy_bacon( bacon )
	local player_index = bacon_rashers[ bacon ]
	if player_index == nil then print("fuck my life")end
	local bacon_unit = bacon:get_unit()
	local bacon_fixture = bacon_unit.fixture
	bacon_rashers[ bacon ] = nil
	bacon = nil
	bacon_fixture:destroy()
	
	local pigeh = pigehs[ player_index ]
	if not pigeh then
		return
	end
	pigeh:bacon_destroyed()
end

function beginContact(fixture_a, fixture_b, collision)
	local unit_a, unit_b = fixture_a:getUserData(), fixture_b:getUserData()
	unit_a:beginContact(unit_b)
	unit_b:beginContact(unit_a)
end

function endContact(fixture_a, fixture_b, collision)
   
end

function preSolve(fixture_a, fixture_b, collision)
	local unit_a, unit_b = fixture_a:getUserData(), fixture_b:getUserData()
	unit_a:preSolve(unit_b)
	unit_b:preSolve(unit_a)
end

function postSolve(fixture_a, fixture_b, collision, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	local unit_a, unit_b = fixture_a:getUserData(), fixture_b:getUserData()
	unit_a:postSolve(unit_b)
	unit_b:postSolve(unit_a)
end

function love.draw()
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue

	for _, pigehh in pairs( pigehs ) do
		pigehh:draw()
	end

	for bacon, _ in pairs( bacon_rashers ) do
		bacon:draw()
	end

	-- love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
	-- love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

	-- love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	-- love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
end