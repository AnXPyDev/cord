gears = { shape: require "gears.shape" }

rectangle = (radius = 0) ->
  return ((cr, w, h) ->
    return gears.shape.rounded_rect(cr, w, h, radius))

return {
  rectangle: rectangle
}
