require "class"

CreateWorldObject = class( CreateWorldObject )

function CreateWorldObject:create_ball( position, color, extension )
	ball = {}
	ball.body = love.physics.newBody(physics_world, position[1], position[2], "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	ball.shape = love.physics.newCircleShape( 16 ) --the ball's shape has a radius of 20
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	ball.fixture:setRestitution(0.9) --let the ball bounce
	ball.body:setLinearDamping( 1 )

	ball.fixture:setUserData( extension )

	return ball
end

function CreateWorldObject:create_rect( position, color, extension )
	rect = {}
	rect.body = love.physics.newBody( physics_world, position[1], position[2], "dynamic" )
	rect.shape = love.physics.newRectangleShape( 0, 0, 32, 8 )
	rect.fixture = love.physics.newFixture( rect.body, rect.shape, 0 )
	rect.fixture:setRestitution(0.9) --let the ball bounce
	rect.body:setLinearDamping( 0.05 )

	rect.fixture:setUserData( extension )

	return rect
end