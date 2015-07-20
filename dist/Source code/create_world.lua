require "class"
require "unit"

CreateWorld = class ( CreateWorld )

function CreateWorld:init( physics_world )
	--let's create the ground

	self.objects = {}
	self.objects.ground = {}
	self.objects.ground.body = love.physics.newBody(physics_world, love.window.getWidth()/2, love.window.getHeight()-50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	self.objects.ground.shape = love.physics.newRectangleShape(love.window.getWidth(), 50) --make a rectangle with a width of 650 and a height of 50
	self.objects.ground.fixture = love.physics.newFixture(self.objects.ground.body, self.objects.ground.shape) --attach shape to body

	unit = Unit:new("ground")
	-- unit:init( "ground" )
	self.objects.ground.fixture:setUserData( unit )


	--let's create a ball
	-- self.objects.ball = {}
	-- self.objects.ball.body = love.physics.newBody(physics_world, 650/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	-- self.objects.ball.shape = love.physics.newCircleShape( 20) --the ball's shape has a radius of 20
	-- self.objects.ball.fixture = love.physics.newFixture(self.objects.ball.body, self.objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	-- self.objects.ball.fixture:setRestitution(0.9) --let the ball bounce
	-- self.objects.ball.body:setLinearDamping( 1 )
	
	-- asd = Asd:new()
	-- asd:init()
	-- self.objects.ball.fixture:setUserData( asd )


	-- borders
	self.objects.top = {}
	self.objects.top.body = love.physics.newBody( physics_world, 0, 0 )
	self.objects.top.shape = love.physics.newEdgeShape( 0, 0, love.window.getWidth(), 0 )
	self.objects.top.fixture = love.physics.newFixture( self.objects.top.body, self.objects.top.shape, 0 )
	-- self.objects.top.fixture:setUserData( "top" )
	unit = Unit:new("top")
	-- unit:init( "top" )
	self.objects.top.fixture:setUserData( unit )

	self.objects.left = {}
	self.objects.left.body = love.physics.newBody( physics_world, 0, 0 )
	self.objects.left.shape = love.physics.newEdgeShape( 0, 0, 0, love.window.getHeight() )
	self.objects.left.fixture = love.physics.newFixture( self.objects.left.body, self.objects.left.shape, 0 )
	-- self.objects.left.fixture:setUserData( "left" )
	unit = Unit:new("side")
	-- unit:init( "side" )
	self.objects.left.fixture:setUserData( unit )

	self.objects.right = {}
	self.objects.right.body = love.physics.newBody( physics_world, love.window.getWidth(), 0 )
	self.objects.right.shape = love.physics.newEdgeShape( 0, 0, 0, love.window.getHeight() )
	self.objects.right.fixture = love.physics.newFixture( self.objects.right.body, self.objects.right.shape, 0 )
	-- self.objects.right.fixture:setUserData( "right" )
	unit = Unit:new("side")
	-- unit:init( "side" )
	self.objects.right.fixture:setUserData( unit )
end

function CreateWorld:get_world_objects()
	return self.objects
end