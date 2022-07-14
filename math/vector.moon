class Vector
	@__name: "cord.math.vector"

	new: (x = 0, y = x, unit = "undefined") =>
		@x = x
		@y = y
		@unit = unit
	to_primitive: =>
		return {
			x: @x,
			y: @y
		}
	copy: =>
		return Vector(@x, @y, @unit)

return Vector
