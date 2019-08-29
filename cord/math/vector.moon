class Vector
  new: (x = 0, y = x, metric = "undefined") =>
    @__name = "cord.math.vector"
    @x = x
    @y = y
    @metric = metric
  to_primitive: =>
    return {
      x: @x,
      y: @y
    }

return Vector
