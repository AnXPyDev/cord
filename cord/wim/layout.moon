Vector = require "cord.math.vector"
cord = { util: require "cord.util", log: require "cord.log" }
  
manual = (node) ->
  for k, child in pairs node.children
    pos = child.pos or Vector()
    if child.__name and child.__name == "cord.wim.node"
      pos = child\get_pos!
    set_node_or_widget_pos(child, pos)

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

      cord.util.set_node_or_widget_pos(child, current)

      if max.y < (current.y + child_size.y)
        max.y = current.y + child_size.y

      current.x += child_size.x

return {
  manual: manual,
  fit: fit
}
