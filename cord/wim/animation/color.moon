Animation = require "cord.wim.animation.base"

cord = {
  util: require "cord.util",
  table: require "cord.table"
}


node_color_index = {
  background: {{"style_data", "background_color"}, {"stylizers", "background"}},
  overlay: {{"style_data", "overlay_color"}, {"stylizers", "overlay"}}
}

animator = require "cord.wim.default_animator"

class Color extends Animation
  new: (node, start, target, color_index = "background") =>
    super!
    @node = node
    @color_index = color_index
    if start
      @current = type(start) == "string" and cord.util.color(start) or start\copy!
    else
      if @node.data["#{@color_index}_color_animation"]
        @node.data["#{@color_index}_color_animation"].done = true
        @current = @node.data["#{@color_index}_color_animation"].current
      else
        @current = @node.current_style\get(@color_index)
    @target = type(target) == "string" and cord.util.color(target) or target\copy!
    @speed = node.style\get("color_animation_speed") or 1
    @node.current_style\set(@color_index, @current)
    animator\add(self)
    

class Color_Lerp extends Color
  new: (node, start, target, color_index) =>
    super(node, start, target, color_index)
    @speed = node.style\get("color_lerp_animation_speed") or @speed
  tick: =>
    @current\lerp(@target, @speed)
    @node\restylize(@color_index)
    if @current\equals(@target)
      @done = true
    return @done

class Color_Approach extends Color
  new: (node, start, target, color_index) =>
    super(node, start, target, color_index)
    @speed = node.style\get("color_approach_animation_speed") or @speed
  tick: =>
    @current\approach(@target, @speed)
    @node\restylize(@color_index)
    if @current\equals(@target)
      @done = true
    return @done

class Color_Jump extends Color
  new: (node, start, target, color_index) =>
    super(node, start, target, color_index)
    @current\lerp(@target, 1)
    @done = true
  tick: =>
    return @done

return {
  approach: Color_Approach,
  lerp: Color_Lerp,
  jump: Color_Jump
}
