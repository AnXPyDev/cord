cord = {
  math: require "cord.math"
}

Animation = require "cord.wim.animation"
Vector = require "cord.math.vector"

animator = require "cord.wim.default_animator"

get_closest_edge = (pos, size, layout_size) ->
  distances = {}
  pos = Vector(pos.x + size.x / 2, pos.y + size.y / 2)

  -- top
  dist = {}
  dist["left"] = pos.x
  dist["right"] = layout_size.x - pos.x
  dist["top"] = pos.y
  dist["bottom"] = layout_size.y - pos.y

  min = math.min(dist.left, dist.right, dist.top, dist.bottom)
  for k, v in pairs dist
    if v == min
      return k

get_edge_start = (pos, size, layout_size) ->
  edge = get_closest_edge(pos, size, layout_size)
  start = pos\copy!
  if edge == "left"
    start.x = -size.x
  elseif edge == "right"
    start.x = layout_size.x
  elseif edge == "top"
    start.y = -size.y
  elseif edge == "bottom"
    start.y = layout_size.y
  return start

class Position extends Animation
  new: (node, start, target, layout_size) =>
    super!
    @node = node
    if @node.data.position_animation
      @node.data.position_animation.done = true
      @current = @node.data.position_animation.current
    else
      @current = start\copy!
    @node.data.position_animation = self
    @target = target
    @speed = node.style\get("position_animation_speed") or 1
    node\set_pos(@current)
    table.insert(@callbacks, () ->
      @node\set_pos(@target)
    )
    animator\add(self)

class Position_Jump extends Position
  new: (node, start, target, layout_size) =>
    super(node, start, target, layout_size)
    @node\set_pos(@target)
    @done = true

class Position_Lerp extends Position
  new: (node, start, target, layout_size) =>
    super(node, start, target, layout_size)
    @speed = node.style\get("position_lerp_animation_speed") or @speed
  tick: =>
    @current.x = cord.math.lerp(@current.x, @target.x, @speed, @speed)
    @current.y = cord.math.lerp(@current.y, @target.y, @speed, @speed)
    @node\set_pos(@current)
    if @current.x == @target.x and @current.y == @target.y
      @done = true
      return true
    return false

class Position_Approach extends Position
  new: (node, start, target, layout_size) =>
    super(node, start, target, layout_size)
    @speed = node.style\get("position_approach_animation_speed") or @speed
  tick: =>
    @current.x = cord.math.approach(@current.x, @target.x, @speed)
    @current.y = cord.math.approach(@current.y, @target.y, @speed)
    @node\set_pos(@current)
    if @current.x == @target.x and @current.y == @target.y
      @done = true
      return true
    return false


class Position_Lerp_From_Edge extends Position_Lerp
  new: (node, start, target, layout_size) =>
    super(node, get_edge_start(target, node\get_size!, layout_size), target, layout_size)
    @speed = node.style\get("position_lerp_from_edge_animation_speed") or @speed

class Position_Approach_From_Edge extends Position_Approach
  new: (node, start, target, layout_size) =>
    super(node, get_edge_start(target, node\get_size!, layout_size), target, layout_size)
    @speed = node.style\get("position_approach_from_edge_animation_speed") or @speed

class Position_Lerp_To_Edge extends Position_Lerp
  new: (node, start, target, layout_size) =>
    super(node, start, get_edge_start(target, node\get_size!, layout_size), layout_size)
    @speed = node.style\get("position_lerp_to_edge_animation_speed") or @speed

class Position_Approach_To_Edge extends Position_Approach
  new: (node, start, target, layout_size) =>
    super(node, start, get_edge_start(target, node\get_size!, layout_size), layout_size)
    @speed = node.style\get("position_approach_to_edge_animation_speed") or @speed

return {
  jump: Position_Jump,
  lerp: Position_Lerp,
  approach: Position_Approach,
  lerp_from_edge: Position_Lerp_From_Edge,
  lerp_to_edge: Position_Lerp_To_Edge,
  approach_from_edge: Position_Approach_From_Edge,
  approach_to_edge: Position_Approach_To_Edge
}
