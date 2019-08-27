gears = { color: require "gears.color" }
log = require "cord.log"
  
normalize_as_pattern_or_color = (x = nil) ->
  log(x)
  if type(x) == "string"
    return x
  elseif type(x) == "table"
    if x.__name and x.__name == "cord.util.pattern"
      return x\create_pattern!
    elseif x.__name and x.__name == "cord.util.color"
      return x\to_rgba_string!
  return gears.color.transparent

return {
  margin: require "cord.util.margin",
  color: require "cord.util.color",
  pattern: require "cord.util.pattern",
  object: require "cord.util.object",
  normalize_as_pattern_or_color: normalize_as_pattern_or_color
}
