gears = { color: require "gears.color" }

cord = { math: require "cord.math" }
  
normalize_as_pattern_or_color = (x = nil, ...) ->
  if type(x) == "string"
    return x
  elseif type(x) == "table"
    if x.__name and x.__name == "cord.util.pattern"
      return x\create_pattern(...)
    elseif x.__name and x.__name == "cord.util.color"
      return x\to_rgba_string!
  return gears.color.transparent

normalize_vector_in_context = (vec = cord.math.vector(), context = cord.math.vector()) ->
  result = cord.math.vector(0, 0, "undefined")
  if type(vec.x) == "table"
    if vec.x.__name and vec.x.__name == "cord.math.value"
      if vec.x.metric == "percentage"
        result.x = vec.x.value * context.x + vec.x.offset
      else
        result.x = vec.x.value + vec.x.offset
  else if vec.metric == "percentage"
    result.x = vec.x * context.x
  else
    result.x = vec.x

  if type(vec.y) == "table"
    if vec.y.__name and vec.y.__name == "cord.math.value"
      if vec.y.metric == "percentage"
        result.y = vec.y.value * context.y + vec.y.offset
      else
        result.y = vec.y.value + vec.y.offset
  else if vec.metric == "percentage"
    result.y = vec.y * context.y
  else
    result.y = vec.y

  return result

set_node_or_widget_pos = (node_or_widget, pos = cord.math.vector()) ->
  if node_or_widget.__name and node_or_widget.__name == "cord.wim.node"
    node_or_widget.widget.point.x = pos.x
    node_or_widget.widget.point.y = pos.y
  else
    node_or_widget.point.x = pos.x
    node_or_widget.point.y = pos.y

return {
  margin: require "cord.util.margin",
  color: require "cord.util.color",
  pattern: require "cord.util.pattern",
  object: require "cord.util.object",
  shape: require "cord.util.shape",
  normalize_as_pattern_or_color: normalize_as_pattern_or_color,
  normalize_vector_in_context: normalize_vector_in_context
  set_node_or_widget_pos: set_node_or_widget_pos
}
