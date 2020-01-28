Animation = require "cord.wim.animation.node_data"
Margin = require "cord.util.margin"

cord = {
  util: require "cord.util"
}

class Base extends Animation
  new: (node, start, target, data_index = "padding", ...) =>
    super(node, start, target, data_index, ...)
    table.insert(@__name, "cord.wim.animation.margin")
    @speed = @node.style\get("margin_animation_speed") or 1

class Lerp extends Base
  new: (node, start, target, data_index, ...) =>
    super(node, start, target , data_index, ...)
    table.insert(@__name, "cord.wim.animation.margin.lerp")
    @speed = @node.style\get("margin_lerp_animation_speed")
  tick: =>
    @current\lerp(@target, @speed)
    @node.data\set(@data_index, @current, true)
    @node.data\update(@data_index)
    if @current\equal(@target)
      @done = true
    return @done

class Approach extends Base
  new: (node, start, target, data_index, ...) =>
    super(node, start, target , data_index, ...)
    table.insert(@__name, "cord.wim.animation.margin.approach")
    @speed = @node.style\get("margin_approach_animation_speed")
  tick: =>
    @current\approach(@target, @speed)
    @node.data\set(@data_index, @current, true)
    @node.data\update(@data_index)
    if @current\equal(@target)
      @done = true
    return @done

Jump = (node, start, target, data_index, ...) ->
  node and node.data\set(data_index, target)
  cord.util.call(...)

return {
  base: Base
  lerp: Lerp
  approach: Approach
  jump: Jump
}
