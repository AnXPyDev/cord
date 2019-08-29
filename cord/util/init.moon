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

set_node_or_widget_pos = (node_or_widget, pos = Vector()) ->
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
  set_node_or_widget_pos: set_node_or_widget_pos
}
