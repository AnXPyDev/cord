class Vector
  new: (x = 0, y = x, metric = "pixel") =>
    @__name = "cord.math.vector"
    @x = x
    @y = y
    @metric = metric

return Vector
