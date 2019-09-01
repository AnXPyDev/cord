Vector = require "cord.math.vector"

cord = {
  wim: {
    animations: require "cord.wim.animations"
  }
}


  

layout_appear_from_edge = (node, target, speed = node.style\get("layout_appear_speed"), layout_size) ->
  animation = node.style\get("layout_appear_animation")
  size = node\get_size!
  start = target\copy!
  edge = get_closest_edge(target, size, layout_size)
  if edge == "left"
    start.x = -size.x
  elseif edge == "right"
    start.x = layout_size.x
  elseif edge == "top"
    start.y = -size.y
  elseif edget == "bottom"
    start.y = layout_size.y
  animation(node, start, target, speed)
  if animation
    return animation(node, start, target, speed)
  node\set_pos(target)

layout_move = (node, target, speed = node.style\get("layout_appear_speed"), layout_size) ->
  animation = node.style\get("layout_move_animation")
  start = node.pos\copy!
  if animation
    return animation(node, start, target, speed)
  node\set_pos(target)

return {
  layout: {
    move: layout_move,
    appear: layout_appear
  }
  
}
