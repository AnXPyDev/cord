Vector = require "cord.math.vector"
cord = { log: require "cord.log" }
  
manual = (node) ->
  for k, child in pairs node.children
    widget = child
    pos = child.pos or Vector()
    if child.__name and child.__name == "cord.wim.node"
      widget = child.widget
      pos = child\get_pos!
    widget.point.x = pos.x
    widget.point.y = pos.y

fit = (node) ->
  content_size = node\get_content_size!
  max = Vector()
  current = Vector()
  for k, child in pairs node.children
    if child.__name and child.__name == "cord.wim.node"
      child_size = child\get_size!
      if (current.x + child_size.x) > content_size.x
        current.x = 0
        current.y = max.y

      child.widget.point.x = current.x
      child.widget.point.y = current.y

      if max.y < (current.y + child_size.y)
        max.y = current.y + child_size.y

      current.x += child_size.x

return {
  manual: manual,
  fit: fit
}
