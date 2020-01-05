gears = { color: require "gears.color" }
cord = {
  math: require "cord.math"
  table: require "cord.table"
}

is_object_class = (obj, class_name) ->
  if type(obj) == "table"
    if type(obj.__name) == "table"
      return cord.table.contains(obj.__name, class_name)
    else
      return obj.__name == class_name
  else
    return type(obj) == class_name

normalize_as_pattern_or_color = (x = nil, ...) ->
  if type(x) == "string"
    return x
  elseif is_object_class(x, "cord.util.pattern")
    return x\create_pattern(...)
  elseif is_object_class(x, "cord.util.color")
    return x\to_rgba_string!
  return gears.color.transparent

normalize_vector_in_context = (vec = cord.math.vector(), context = cord.math.vector()) ->
  result = cord.math.vector(0, 0, "undefined")
  if type(vec.x) == "table"
    if is_object_class(vec.x, "cord.math.value")
      if vec.x.metric == "percentage"
        result.x = vec.x.value * context.x + vec.x.offset
      else
        result.x = vec.x.value + vec.x.offset
  else if vec.metric == "percentage"
    result.x = vec.x * context.x
  else
    result.x = vec.x

  if type(vec.y) == "table"
    if is_object_class(vec.x, "cord.math.value")
      if vec.y.metric == "percentage"
        result.y = vec.y.value * context.y + vec.y.offset
      else
        result.y = vec.y.value + vec.y.offset
  else if vec.metric == "percentage"
    result.y = vec.y * context.y
  else
    result.y = vec.y

  return result

get_color_or_pattern_lightness = (color_or_pattern) ->
  if is_object_class(color_or_pattern, "cord.util.color")
    return color_or_pattern.L
  elseif is_object_class(color_or_pattern, "cord.util.color")
    return color_or_pattern\get_average_lightness!
  return 0
    
get_object_class = (obj) ->
  if type(obj) == "table"
    if type(obj.__name) == "table"
      return obj.__name[#obj.__name]
    else
      return obj.__name or "table"
  else
    return type(obj)

return {
  normalize_as_pattern_or_color: normalize_as_pattern_or_color,
  normalize_vector_in_context: normalize_vector_in_context
  get_object_class: get_object_class,
  is_object_class: is_object_class,
  get_color_or_pattern_lightness: get_color_or_pattern_lightness
}
