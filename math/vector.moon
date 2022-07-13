class Vector
	@__name: "cord.math.vector"

	new: (x = 0, y = x, metric = "undefined") =>
		@x = x
		@y = y
		@metric = metric
	to_primitive: =>
		return {
			x: @x,
			y: @y
		}
	copy: =>
		return Vector(@x, @y, @metric)

return Vector
