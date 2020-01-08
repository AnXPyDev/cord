c_transparent = (require "gears.color").transparent

types = require "cord.util.types"

Vector = require "cord.math.vector"
Value = require "cord.math.value"
Margin = require "cord.util.margin"

value = (val = 0, context = 1, metric) ->
  if types.match(val) == "cord.math.value"
    if val.metric == "percentage"
      return val.value * value(context) + val.offset
    else
      return val.value + val.offset
  elseif metric == "percentage"
    return val * value(context)
  else
    return val
  
vector = (vec = Vector(), context = Vector()) ->
  return Vector(value(vec.x, context.x, vec.metric), value(vec.y, context.y, vec.metric))

margin = (mar = Margin(), context = Vector()) ->
  return Margin(
    value(mar.left, context.x, mar.metric),
    value(mar.right, context.x, mar.metric),
    value(mar.top, context.y, mar.metric),
    value(mar.bottom, context.y, mar.metric)
  )

color_or_pattern = (cop, ...) ->
  if types.match(cop, "string")
    return cop
  elseif types.match(cop, "cord.util.color")
    return cop\to_rgba_string!
  elseif types.match(cop, "cord.util.pattern")
    return cop\create_pattern(...)
  return c_transparent
    
return {
  value: value
  vector: vector
  color_or_pattern: color_or_pattern
  sum: sum
}
