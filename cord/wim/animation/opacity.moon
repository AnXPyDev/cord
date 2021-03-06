cord = {
  math: require "cord.math"
  util: require "cord.util"
}

Animation = require "cord.wim.animation.node_data"
Vector = require "cord.math.vector"

animator = require "cord.wim.default_animator"

class Base extends Animation
  new: (node, start, target, ...) =>
    super(node, start, target, "opacity", ...)
    table.insert(@__name, "cord.wim.animation.opacity")
    @speed = node.style\get("opacity_animation_speed") or 1

Jump = (node, start, target, ...) ->
  node and node.data\set("opacity", target)
  cord.util.call(...)
    
    
class Lerp extends Base
  new: (node, start, target, ...) =>
    super(node, start, target, ...)
    table.insert(@__name, "cord.wim.animation.opacity.lerp")
    @speed = node.style\get("opacity_lerp_animation_speed") or @speed
  tick: () =>
    @current = cord.math.lerp(@current, @target, @speed, 0.001)
    @node.data\set("opacity", @current)
    if @current == @target
      @done = true
    return @done

class Approach extends Base
  new: (node, start, target, ...) =>
    super(node, start, target, ...)
    table.insert(@__name, "cord.wim.animation.opacity.approach")
    @speed = node.style\get("opacity_approach_animation_speed") or @speed
  tick: () =>
    @current = cord.math.approach(@current, @target, @speed)
    @node.data\set("opacity", @current)
    if @current == @target
      @done = true
    return @done

return {
  base: Base
  jump: Jump,
  lerp: Lerp,
  approach: Approach
}
