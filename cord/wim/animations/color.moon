Animation = require "cord.wim.animation"

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
    if @node.data["#{@color_index}_color_animation"]
      @node.data["#{@color_index}_color_animation"].done = true
      @current = @node.data["#{@color_index}_color_animation"].current
    else
      @current = type(start) == "string" and cord.util.color(start) or start\copy!
    @target = type(target) == "string" and cord.util.color(target) or target\copy!
    @speed = node.style\get("color_animation_speed") or 1
    @node.style_data["#{@color_index}_color"] = @current
    animator\add(self)
    

class Color_Lerp extends Color
  new: (node, start, target, color_index) =>
    super(node, start, target, color_index)
    @speed = node.style\get("color_lerp_animation_speed") or @speed
  tick: =>
    clr, result = @current\lerp(@target, @speed)
    @node\emit_signal("request_stylize", @color_index)
    if result == true
      @done = true
    return @done

class Color_Approach extends Color
  new: (node, start, target, color_index) =>
    super(node, start, target, color_index)
    @speed = node.style\get("color_lerp_animation_speed") or @speed
  tick: =>
    clr, result = @current\approach(@target, @speed)
    @node\emit_signal("request_stylize", @color_index)
    if result
      @done = true
    return @done

return {
  approach: Color_Approach,
  lerp: Color_Lerp
}
