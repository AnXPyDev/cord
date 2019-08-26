gears = { color: require "gears.color" }

normalize_as_pattern_or_color = (x = 69) ->
  if type(x) == "string"
    return x
  elseif type(x) == "table"
    if x.__name and x.__name == "Pattern"
      return x\create_pattern!
    elseif x.__name and x.__name == "Color"
      return x\to_rgba_string!
  else
    return gears.color.transparent

return {
  margin: require "cord.util.margin",
  color: require "cord.util.color",
  pattern: require "cord.util.pattern",
  object: require "cord.util.object",
  normalize_as_pattern_or_color: normalize_as_pattern_or_color
}
