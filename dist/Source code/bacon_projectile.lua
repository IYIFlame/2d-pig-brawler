require "class"
require "utils"
require "create_world_object"

BaconProjectile = class( BaconProjectile, Unit )

function BaconProjectile:init( type, Tileset, tilesetW, tilesetH, pos_x, pos_y, fall_vel, orientation )
	self._type = type
	self.Tileset = Tileset
	self.tilesetW = tilesetW
	self.tilesetH = tilesetH
	self._bacon_img = Utils.getNewQuad( 256, 33, 32, 8 )

	self._unit = CreateWorldObject:create_rect( { pos_x, pos_y }, 0, self )
	self._unit_vel_x = 800
	self._unit_orientation = orientation 
	self._fall_vel = fall_vel < 0 and fall_vel - 400 or -800
	self._unit.body:applyLinearImpulse( self._unit_orientation*self._unit_vel_x, self._fall_vel )

	self._life = 3
end

function BaconProjectile:update( dt )
	if self._life <= 0 then
		self:destroy()
	end
end

function BaconProjectile:beginContact( unit )
	local unit_type = unit:get_type()
	if unit_type == "side" or unit_type == "top" or unit_type == "ground" then
		self._life = self._life - 1
	end
end

function BaconProjectile:preSolve( unit )
	local unit_type = unit:get_type()
	if unit_type == "pigeh" then
		self:destroy()
	end
end

function BaconProjectile:destroy()
	destroy_bacon( self )
end

function BaconProjectile:draw()
	local x, y = self._unit.body:getPosition()
	love.graphics.draw(self.Tileset, self._bacon_img, x - 16, y - 4 )
	-- love.graphics.polygon("fill", self._unit.body:getWorldPoints(self._unit.shape:getPoints()))
end