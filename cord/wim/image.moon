wibox = require "wibox"

cord = {
  wim: {
    style: require "cord.wim.style"
  }
  util: require "cord.util"
}

Vector = require "cord.math.vector"
Node = require "cord.wim.node"


class Image extends Node
  new: (category, label, stylesheet, image) =>
    @image = image
    super(category, label, stylesheet)
    @identification = "image #{@category} #{@label} #{@unique_id}"
    @__name = "cord.wim.image"

  create_signals: =>
    @\connect_signal("geometry_changed", () ->
      print(@identification, "emitting layout_change to parent")
      @parent and @parent\emit_signal("layout_changed")
    )

  create_current_style: =>
    color = @style\get("color")
    size = @style\get("size") or Vector(1, nil, "percentage")

    if cord.util.get_object_class(color) == "string"
      color = cord.util.color(color)

    @current_style = cord.wim.style({
      color: color and color\copy!
      pos: Vector()
      opacity: 0
      visible: false
      size: size\copy!
    })
    
  create_widgets: =>
    @imagebox = wibox.widget.imagebox()
    @widget = @imagebox
    @widget.visible = false

  create_stylizers: =>
    @stylizers.size = (sole) ->
      size = @\get_size!
      @imagebox.forced_width = size.x
      @imagebox.forced_height = size.y
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.resize = (sole) ->
      @imagebox.resize = true
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.image = (sole) ->
      @imagebox.image = @image\get(@current_style\get("color"))
      @\emit_signal("stylized", "image")
      if sole
        @widget\emit_signal("widget::redraw_needed")

  create_content: =>

return Image
