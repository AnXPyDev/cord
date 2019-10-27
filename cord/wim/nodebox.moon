wibox = awesome and require "wibox" or {}
gears = { color: require "gears.color" }

cord = { log: require "cord.log" }
  
Node = require "cord.wim.node"

class Nodebox extends Node
  new: (...) =>
    super(...)
    @__name = "cord.wim.nodebox"
    @wibox = nil
    @visible = false
    @\create_wibox!
    @\add_style_data!
    @\add_stylizers!
    @\add_signals!
    @\emit_signal("request_stylize")

  add_signals: () =>
    @\connect_signal("geometry_changed", () ->
      @stylizers.wibox!
    )

    @\connect_signal("visibility_changed", () ->
      if @visible
        @wibox.visible = true
      else
        @wibox.visible = false
      @wibox\emit_signal("widget::redraw_needed")
    )
    
  add_style_data: () =>
    
  add_stylizers: () =>
    @stylizers.wibox = () ->
      @wibox.shape = @style_data.background_shape
      size = @\get_size!
      @wibox.width = size.x
      @wibox.height = size.y
      @wibox.x = @pos.x
      @wibox.y = @pos.y
      @wibox\emit_signal("widget::redraw_needed")

    @stylizers.wibox_pos = () ->
      @wibox.x = @pos.x + (@parent and @parent.pos.x or 0)
      @wibox.y = @pos.y + (@parent and @parent.pos.y or 0)
      @wibox\emit_signal("widget::redraw_needed")

  create_wibox: () =>
    @wibox = wibox({
      visible: false,
      widget: @widget,
      bg: gears.color.transparent
    })

  set_pos: (pos) =>
    @pos.x = pos.x
    @pos.y = pos.y
    @stylizers.wibox_pos!

return Nodebox
