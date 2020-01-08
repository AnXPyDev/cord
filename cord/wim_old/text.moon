wibox = require "wibox"

cord = {
  wim: {
    style: require "cord.wim.style"
  }
  util: require "cord.util"
}

Vector = require "cord.math.vector"
Node = require "cord.wim.node"

class Text extends Node
  new: (category, label, stylesheet, text = "") =>
    @text = text
    super(category, label, stylesheet)
    @identification = "text #{@category} #{@label} #{@unique_id}"
    table.insert(@__name, "cord.wim.text")

  create_signals: =>
    @\connect_signal("geometry_changed", () ->
      @parent and @parent\emit_signal("layout_changed")
    )

  create_current_style: =>
    color = @style\get("color") or cord.util.color("#FFFFFF")
    size = @style\get("size") or Vector(1, nil, "percentage")

    if cord.util.get_object_class(color) == "string"
      color = cord.util.color(color)

    @current_style = cord.wim.style({
      color: color\copy!
      font: @style\get("font") or "Unknown"
      halign: @style\get("halign") or "center"
      valign: @style\get("valign") or "center"
      pos: Vector()
      opacity: 0
      visible: false
      size: size\copy!
    })
    
  create_widgets: =>
    @textbox = wibox.widget.textbox()
    @containers.constraint = wibox.container.constraint(@textbox)
    @containers.background = wibox.container.background(@containers.constraint)
    @widget = @containers.background
    @widget.visible = false

  create_stylizers: =>
    @stylizers.size = (sole) ->
      size = @\get_size!
      @containers.background.forced_width = size.x
      @containers.background.forced_height = size.y
      @containers.constraint.forced_width = size.x
      @containers.constraint.forced_height = size.y
      @containers.constraint.width = size.x
      @containers.constraint.height = size.y
      @\emit_signal("stylized", "size")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.color = (sole) ->
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@current_style\get("color"))
      @\emit_signal("stylized", "color")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.align = (sole) ->
      @textbox.align = @current_style\get("halign")
      @textbox.valign = @current_style\get("valign")
      @\emit_signal("stylized", "align")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.text = (sole) ->
      @textbox.text = @text
      @\emit_signal("stylized", "text")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.font = (sole) ->
      @textbox.font = @current_style\get("font")
      @\emit_signal("stylized", "font")
      if sole
        @widget\emit_signal("widget::redraw_needed")

  create_content: =>

return Text
