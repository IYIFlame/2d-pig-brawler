require "class"
require "utils"
require "unit"
require "create_world_object"
require "bacon_projectile"

Pigeh_unit_locomotion = class( Pigeh_unit_locomotion, Unit )

function Pigeh_unit_locomotion:init( type, Tileset, tilesetW, tilesetH, player_settings )
	self._type = type
	self.Tileset = Tileset
	self.tilesetW = tilesetW
	self.tilesetH = tilesetH
	self._pig_left_img = Utils.getNewQuad( 256, 0, 32, 32 )
	self._pig_right_img = Utils.getNewQuad( 287, 0, 32, 32 )

	self._unit = CreateWorldObject:create_ball( player_settings.position, player_settings.color, self )
	self._color = player_settings.color
	self._player_index = player_settings.index

	self._unit_orientation = 1 --going to the right
	self._unit_vel_x = 120


	-- self._bacon_rashers = {}
	self._bacon_rashers = 0
end

function Pigeh_unit_locomotion:update( dt )
	local vel_x, vel_y = self._unit.body:getLinearVelocity()
	if vel_y < -800 then
		vel_y = -800
	end

	local unit_speed = self._unit_orientation * self._unit_vel_x
	if math.abs(vel_x) < self._unit_vel_x then
		vel_x = unit_speed
	end
	self._unit.body:setLinearVelocity( vel_x, vel_y )
end

function Pigeh_unit_locomotion:key_pressed(key, isrepeat)
	if key == "up" then
		self._unit.body:applyLinearImpulse(0, -2000)
	end
	if key == "left" then
		self._unit_orientation = -1
	end
	if key == "right" then
		self._unit_orientation = 1
	end
	if key == "shoot" then
		if self._bacon_rashers < 3 then
			local pos_x, pos_y = self._unit.body:getPosition()
			local _, vel_y = self._unit.body:getLinearVelocity()
			local bacon = BaconProjectile:new( "bacon", Tileset, tilesetW, tilesetH, pos_x, pos_y-32, vel_y, self._unit_orientation )
			
			self._bacon_rashers = self._bacon_rashers + 1
			register_bacon( bacon, self._player_index )
		end
	end
end

function Pigeh_unit_locomotion:bacon_destroyed()
	self._bacon_rashers = self._bacon_rashers - 1
end

function Pigeh_unit_locomotion:beginContact( unit )
	local unit_type = unit:get_type()
	if unit_type == "side" then
		self._unit_orientation = self._unit_orientation * -1
	elseif unit_type == "pigeh" then
		self._unit_orientation = - self._unit_orientation
		self._unit.body:applyLinearImpulse( self._unit_orientation * 500, -800 )
	end
end

function Pigeh_unit_locomotion:postSolve( unit )
	local unit_type = unit:get_type()
	if unit_type == "bacon" then
		self:destroy()
	end
end

function Pigeh_unit_locomotion:destroy()
	player_left( self._player_index )
end

function Pigeh_unit_locomotion:draw()
	local x, y = self._unit.body:getPosition()
	if self._unit_orientation > 0 then		
		love.graphics.draw(self.Tileset, self._pig_right_img, x - 16, y - 16 )
	else
		love.graphics.draw(self.Tileset, self._pig_left_img, x -16, y - 16 )
	end

	love.graphics.print( self._player_index, x - 6, y - 44, 0, 2, 2 )

	-- love.graphics.setColor(self._color[1],self._color[2],self._color[3])
	-- love.graphics.circle("fill", self._unit.body:getX(), self._unit.body:getY(), self._unit.shape:getRadius() )
end