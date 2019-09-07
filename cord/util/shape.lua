local gears = {
  shape = require("gears.shape")
}
local rectangle
rectangle = function(radius)
  if radius == nil then
    radius = 0
  end
  return (function(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, radius)
  end)
end
return {
  rectangle = rectangle
}
