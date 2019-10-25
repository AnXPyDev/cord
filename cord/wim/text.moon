wibox = require "wibox"

cord = {
  wim: {
    animations: require "cord.wim.animations"
  }
  util: require "cord.util",
  log: require "cord.log"
}

Vector = require "cord.math.vector"
Node = require "cord.wim.node"

class Text extends Node
  new: (category, label, stylesheet, text = "", data) =>
    super(category, label, stylesheet, {}, data)
    @__name = "cord.wim.text"
    @text = text

  load_style_data: =>
    color = @style\get("color")
    adaptive_color_on_light = @style\get("adaptive_color_on_light")
    adaptive_color_on_dark = @style\get("adaptive_color_on_dark")
    @style_data = {
      font: @style\get("font") or "Unknown",
      size: @style\get("size") or Vector(100),
      color: color and type(color) == "string" and cord.util.color(color) or type(color) == "table" and color\copy! or cord.util.color("#FFFFFF"),
      adaptive_color_on_light: adaptive_color_on_light and type(adaptive_color_on_light) == "string" and cord.util.color(adaptive_color_on_light) or type(adaptive_color_on_light) == "table" and adaptive_color_on_light\copy! or cord.util.color("#000000"),
      adaptive_color_on_dark: adaptive_color_on_dark and type(adaptive_color_on_dark) == "string" and cord.util.color(adaptive_color_on_dark) or type(adaptive_color_on_dark) == "table" and adaptive_color_on_dark\copy! or cord.util.color("#FFFFFF"),
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
    @containers.background = wibox.container.background()
    @containers.constraint = wibox.container.constraint()
    @textbox = wibox.widget.textbox()
    @containers.constraint.widget = @textbox
    @containers.background.widget = @containers.constraint
    @widget = @containers.background
    @widget.visible = @visible

  create_stylizers: =>
    @stylizers.background = () ->
      size = @\get_size!
      @containers.background.forced_width = size.x
      @containers.background.forced_height = size.y
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style_data.color)
      @containers.background\emit_signal("widget::redraw_needed")
    @stylizers.textbox = () ->
      @textbox.markup = @text
      @textbox.font = @style_data.font
      @textbox.align = @style_data.align_horizontal
      @textbox.valign = @style_data.align_vertical
      @textbox\emit_signal("widget::redraw_needed")
    @stylizers.constraint = () ->
      size = @\get_size!
      @containers.constraint.forced_width = size.x
      @containers.constraint.forced_height = size.y
      @containers.constraint.width = size.x
      @containers.constraint.height = size.y
      @containers.constraint\emit_signal("widget::redraw_needed")
    @stylizers.reset_color = () ->
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style_data.color)
      @containers.background\emit_signal("widget::redraw_needed")

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
      cord.log(color)
      if @style_data.adaptive_color
        if color\is_light!
          @style_data.color = @style_data.adaptive_color_on_light
        else
          @style_data.color = @style_data.adaptive_color_on_dark
        @stylizers.reset_color!
    )

  set_text: (text = @text) =>
    @text = text
    @\emit_signal("request_stylize", "textbox")
return Text
