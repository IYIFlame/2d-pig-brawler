-----------------------
-- Utility functions --
-----------------------
Utils = {}

function Utils.clamp(val, lower, upper)
    assert(val and lower and upper, "3 values plis tyvm")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function Utils.getNewQuad( x, y, tileW, tileH )
	return love.graphics.newQuad(x, y, tileW, tileH, tilesetW, tilesetH)
end