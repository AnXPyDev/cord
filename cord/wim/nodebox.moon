wibox = awesome and require "wibox" or {}
gears = { color: require "gears.color" }

cord = { log: require "cord.log" }
  
Node = require "cord.wim.node"

class Nodebox extends Node
  new: (...) =>
    super(...)
    table.insert(@__name, "cord.wim.nodebox")
    @wibox = nil
    @visible = false
    @\create_wibox!
    @\add_style_data!
    @\add_stylizers!
    @\add_signals!
    @\restylize!

  add_signals: () =>
    @\connect_signal("geometry_changed", () ->
      @\restylize("wibox_pos", "wibox_size")
    )

    @\connect_signal("visibility_changed", () ->
      @wibox.visible = @current_style\get("visible")
      @wibox\emit_signal("widget::redraw_needed")
    )

  add_style_data: () =>
    
  add_stylizers: () =>
    @stylizers.wibox_shape = () ->
      @wibox.shape = @style_data.background_shape
      @wibox\emit_signal("widget::redraw_needed")

    @stylizers.wibox_size = () ->
      size = @\get_size!
      @wibox.width = size.x
      @wibox.height = size.y

    @stylizers.wibox_pos = () ->
      ppos = @parent and @parent.current_style\get("pos")
      pos = @current_style\get("pos")
      @wibox.x = pos.x + (ppos and ppos.x or 0)
      @wibox.y = pos.y + (ppos and ppos.y or 0)
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
    @\restylize("wibox_pos")

return Nodebox
