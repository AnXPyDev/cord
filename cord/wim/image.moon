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
    adaptive_color_on_light = @style\get("adaptive_color_on_light")
    adaptive_color_on_dark = @style\get("adaptive_color_on_dark")
    @style_data = {
      size: @style\get("size") or Vector(100),
      color: color and type(color) == "string" and cord.util.color(color) or type(color) == "table" and color\copy! or nil,
      adaptive_color_on_light: adaptive_color_on_light and type(adaptive_color_on_light) == "string" and cord.util.color(adaptive_color_on_light) or type(adaptive_color_on_light) == "table" and adaptive_color_on_light\copy! or nil,
      adaptive_color_on_dark: adaptive_color_on_dark and type(adaptive_color_on_dark) == "string" and cord.util.color(adaptive_color_on_dark) or type(adaptive_color_on_dark) == "table" and adaptive_color_on_dark\copy! or nil,
      adaptive_color: @style\get("adaptive_color") or nil
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
      if @style_data.adaptive_color
        if color\is_light!
          @style_data.color = @style_data.adaptive_color_on_light
        else
          @style_data.color = @style_data.adaptive_color_on_dark
        @stylizers.reset_image!
    )

  set_image: (image = @image) =>
    @image = image
    @\emit_signal("request_stylize", "imagebox")

return Image
