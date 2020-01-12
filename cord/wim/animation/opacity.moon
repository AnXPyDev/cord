cord = {
  math: require "cord.math"
}

Animation = require "cord.wim.animation.base"
Vector = require "cord.math.vector"

animator = require "cord.wim.default_animator"

class Opacity extends Animation
  new: (node, start, target, layout_size, ...) =>
    super(...)
    @node = node
    if @node.data\get("opacity_animation")
      @node.data\get("opacity_animation").done = true
      @current = @node.data\get("opacity_animation").current
    else
      @current = start
    @node.data\set("opacity_animation", self)
    @target = target
    @speed = node.style\get("opacity_animation_speed") or 1
    node\set_opacity(@current)
    table.insert(@callbacks, () ->
      @node\set_opacity(@target)
    )
    animator\add(self)

class Opacity_Jump extends Opacity
  new: (node, start, target, layout_size, ...) =>
    super(node, start, target, layout_size, ...)
    @node\set_opacity(@target)
    @done = true
    
class Opacity_Lerp extends Opacity
  new: (node, start, target, layout_size, ...) =>
    super(node, start, target, layout_size, ...)
    @speed = node.style\get("opacity_lerp_animation_speed") or @speed
  tick: () =>
    @current = cord.math.lerp(@current, @target, @speed, 0.005)
    @node\set_opacity(@current)
    if @current == @target
      @done = true
      return true
    return false

return {
  jump: Opacity_Jump,
  lerp: Opacity_Lerp,
  approach: Opacity_Approach
}
