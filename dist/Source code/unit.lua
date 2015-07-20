require "class"

Unit = class( Unit )

function Unit:init( type )
	self._type = type or "default"
	self._unit = nil
end

function Unit:get_type()
	return self._type
end

function Unit:beginContact( unit )
	-- print( unit:get_type() )
end

function Unit:preSolve( unit )
end

function Unit:postSolve( unit )
end

function Unit:get_unit()
	return self._unit
end