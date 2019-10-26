wibox = require "wibox"
  
cord = {
  wim: {
    animations: require "cord.wim.animations"
  }
  util: require "cord.util"
}

Vector = require "cord.math.vector"
Node = require "cord.wim.node"

class Image extends Node
  new: (category, label, stylesheet, image, data) =>
    @image = image
    super(category, label, stylesheet, {}, data)
    @__name = "cord.wim.text"

  load_style_data: =>
    color = @style\get("color")
    @style_data = {
      size: @style\get("size") or Vector(100),
      color: color and type(color) == "string" and cord.util.color(color) or type(color) == "table" and color\copy! or nil,
      adaptive_colors: @style\get("adaptive_colors") or nil
      align_horizontal: @style\get("align_horizontal") or "center",
      align_vertical: @style\get("align_vertical") or "center",
      layout_hide_animation: @style\get("layout_hide_animation") or cord.wim.animations.position.jump,
      layout_show_animation: @style\get("layout_show_animation") or cord.wim.animations.position.jump,
      layout_move_animation: @style\get("layout_move_animation") or cord.wim.animations.position.jump,
      opacity_show_animation: @style\get("opacity_show_animation") or cord.wim.animations.opacity.jump,
      opacity_hide_animation: @style\get("opacity_hide_animation") or cord.wim.animations.opacity.jump
    }

  create_containers: =>
    @imagebox = wibox.widget.imagebox()
    @widget = @imagebox
    @widget.visible = @visible

  create_stylizers: =>
    @stylizers.imagebox = () ->
      size = @\get_size!
      @imagebox.forced_width = size.x
      @imagebox.forced_height = size.y
      @imagebox.image = @image\get(@style_data.color)
      @imagebox.resize = true
      @imagebox\emit_signal("widget::redraw_needed")

    @stylizers.reset_image = () ->
      @imagebox.image = @image\get(@style_data.color)
      @imagebox\emit_signal("widget::redraw_needed")

  create_content: =>

  create_signals: =>
    @\connect_signal("request_stylize", (container_name) ->
      if container_name and @stylizers[container_name]
        @stylizers[container_name]()
      else
        for k, fn in pairs @stylizers
          fn!
    )

    @\connect_signal("geometry_changed", () ->
      @parent and @parent\emit_signal("layout_changed")
    )

    @\connect_signal("background_color_changed", (color) ->
      if @style_data.adaptive_colors
        lightness = cord.util.get_color_or_pattern_lightness(color)
        for i, range_and_color in pairs @style_data.adaptive_colors
          range = range_and_color[1]
          if lightness >= range[1] and lightness <= range[2]
            @style_data.color = range_and_color[2]
            @stylizers.reset_image!
            return
    )

  set_image: (image = @image) =>
    @image = image
    @\emit_signal("request_stylize", "imagebox")

return Image
