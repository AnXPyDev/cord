wibox = require "wibox"

cord = {
  wim: {
    animations: require "cord.wim.animations"
  }
  util: require "cord.util"
}

Vector = require "cord.math.vector"
Node = require "cord.wim.node"

class Text extends Node
  new: (category, label, stylesheet, text = "", data) =>
    super(category, label, stylesheet, {}, data)
    @__name = "cord.wim.text"
    @text = text

  load_style_data: =>
    @style_data = {
      font: @style\get("font") or "Unknown",
      size: @style\get("size") or Vector(100),
      color: @style\get("color") or "#FFFFFF",
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

  set_text: (text = @text) =>
    @text = text
    @\emit_signal("request_stylize", "textbox")
return Text
