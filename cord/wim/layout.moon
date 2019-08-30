Vector = require "cord.math.vector"
Object = require "cord.util.object"
cord = { util: require "cord.util" }
cord.log = require "cord.log"


class Layout extends Object
  new: =>
    @node_visibility = {}

  node_visible_last_time: (node) =>
    ret = false
    if @node_visibility[node.unique_id]
      ret = @node_visibility[node.unique_id]
    else
      ret = false
    @node_visibility[node.unique_id] = node.visible
    return ret

  apply_layout: (node) =>

fit = (node) ->
  content_size = node\get_content_size!
  max = Vector()
  current = Vector()
  for k, child in pairs node.children
    if child.__name and child.__name == "cord.wim.node"
      if child.visible == false
        continue
      child_size = child\get_size!
      if (current.x + child_size.x) > content_size.x
        current.x = 0
        current.y = max.y

      anim = child.style\get("layout_appear_animation")
      if anim
        anim(child, Vector(current.x + 500, current.y), current\copy!)
      else
        cord.util.set_node_pos(child, current)

      if max.y < (current.y + child_size.y)
        max.y = current.y + child_size.y

      current.x += child_size.x

return Layout
