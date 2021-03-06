wibox = awesome and require "wibox" or {}

gears = {
  table: require "gears.table",
  color: require "gears.color",
  shape: require "gears.shape"
}

Object = require "cord.util.object"
Vector = require "cord.math.vector"
Margin = require "cord.util.margin"

cord = {
  table: require "cord.table"
  util: require "cord.util"
  wim: {
    layouts: require "cord.wim.layouts"
    animations: require "cord.wim.animations"
    style: require "cord.wim.style"
  }
  log: require "cord.log"
  math: require "cord.math"
}
  
unique_id_counter = 0
  
class Node extends Object
  new: (category="__empty_node_category__", label="__empty_node_label__", stylesheet, children={}) =>
    super!
    table.insert(@__name, "cord.wim.node")
    unique_id_counter += 1
    @unique_id = unique_id_counter
    @category = category
    @label = label
    @identification = "node #{@category} #{@label} #{@unique_id}"
    @style = stylesheet\get_style(@category, @label)
    @style_data = {}
    @children = children
    @parent = nil
    @content = nil
    @containers = {}
    @stylizers = {}
    @content_container = nil
    @widget = nil
    @data = {}
    
    @\create_current_style!
    @\create_signals!
    @\create_widgets!
    @\create_content!
    @\create_stylizers!
    @\restylize!

    @\for_each_node_child(((child) -> child\set_parent(self)))

  set_parent: (parent) =>
    @parent = parent
    @\restylize!

  for_each_node_child: (fn) =>
    for k, child in pairs @children
      if cord.util.is_object_class(child, "cord.wim.node")
        fn(child)


  apply_layout_change: (layout, pos, layout_size) =>
    print(@identification, "layout change", pos.x, pos.y)
    last_time = layout\node_visible_last_time(self)
    local layout_anim, opacity_anim
    if last_time
      if not @current_style\get("visible")
        opacity_anim = (@style\get("opacity_hide_animation") or cord.wim.animations.opacity.jump)(self, @current_style\get("opacity"), 0)
        layout_anim = (@style\get("layout_hide_animation") or cord.wim.animations.position.jump)(self, self.current_style\get("pos")\copy!, pos, layout_size)
        table.insert(opacity_anim.callbacks, () -> @\set_visible(@current_style\get("visible"), true))
      else
        layout_anim = (@style\get("layout_move_animation") or cord.wim.animations.position.jump)(self, self.current_style\get("pos")\copy!, pos, layout_size)
    else
      if @current_style\get("visible")
        @\set_visible(@current_style\get("visible"), true)
        opacity_anim = (@style\get("opacity_show_animation") or cord.wim.animations.opacity.jump)(self, @current_style\get("opacity"), 1)
        layout_anim = (@style\get("layout_show_animation") or cord.wim.animations.position.jump)(self, self.current_style\get("pos")\copy!, pos, layout_size)
        table.insert(opacity_anim.callbacks, () -> @\set_visible(@current_style\get("visible"), true))

  create_signals: =>
    @current_style\connect_signal("value_changed", (key) ->
      if key == "layout"
        new_layout = @style\get("layout")!
        new_layout\inherit(@current_style\get("layout"))
        @current_style\set("layout", new_layout)
        @\emit_signal("layout_changed")
    )

    @\connect_signal("geometry_changed", () ->
      @parent and @parent\emit_signal("layout_changed")
      @\for_each_node_child((node) -> node\restylize("size"))
    )

    @\connect_signal("layout_changed", () ->
      print("relayouting")
      @current_style\get("layout")\apply_layout(self)
    )

  restylize: (...) =>
    names = {...}
    if #names > 0
      for i, name in ipairs names
        if @stylizers[name]
          @stylizers[name]!
      return
    for k, stylizer in pairs @stylizers
      stylizer!

  create_stylizers: =>
    @stylizers.size = (sole) ->
      size = @\get_size!
      @containers.padding.forced_width = size.x
      @containers.padding.forced_height = size.y
      inside_size = @\get_inside_size!
      @containers.background.forced_width = inside_size.x
      @containers.background.forced_height = inside_size.y
      @containers.overlay.forced_width = inside_size.x
      @containers.overlay.forced_height = inside_size.y
      @containers.margin.forced_width = inside_size.x
      @containers.margin.forced_height = inside_size.y
      @\emit_signal("stylized", "size")
      @\emit_signal("geometry_changed")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.padding = (sole) ->
      padding = @current_style\get("padding")
      padding\apply(@containers.padding)
      @\emit_signal("stylized", "padding")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.margin = (sole) ->
      margin = @current_style\get("margin")
      margin\apply(@containers.margin)
      @\emit_signal("stylized", "margin")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.background = (sole) ->
      background = @current_style\get("background")
      @containers.background.bg = cord.util.normalize_as_pattern_or_color(background, nil, nil, @\get_inside_size!)
      @\emit_signal("stylized", "background")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.overlay = (sole) ->
      overlay = @current_style\get("overlay")
      @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(overlay, nil, nil, @\get_inside_size!)
      @\emit_signal("stylized", "overlay")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.background_shape = (sole) ->
      @containers.background.shape = @current_style\get("background_shape")
      @\emit_signal("stylized", "background_shape")
      if sole
        @widget\emit_signal("widget::redraw_needed")

    @stylizers.overlay_shape = (sole) ->
      @containers.background.shape = @current_style\get("background_shape")
      @\emit_signal("stylized", "overlay_shape")
      if sole
        @widget\emit_signal("widget::redraw_needed")

  create_current_style: =>
    padding = @style\get("padding") or Margin(0)
    margin = @style\get("margin") or Margin(0)
    size = @style\get("size") or Vector(100)
    layout = @style\get("layout") or cord.wim.layouts.manual

    background = @style\get("background") or cord.util.color("#000000")
    overlay = @style\get("overlay") or cord.util.color("#00000000")

    if cord.util.get_object_class(background) == "string"
      background = cord.util.color(background)
    if cord.util.get_object_class(overlay) == "string"
      overlay = cord.util.color(overlay)

    background_shape = @style\get("background_shape") or @style\get("shape") or gears.shape.rectangle
    overlay_shape = @style\get("overlay_shape") or @style\get("shape") or gears.shape.rectangle

    @current_style = cord.wim.style({
      padding: padding\copy!
      margin: margin\copy!
      background_shape: background_shape
      overlay_shape: background_shape
      background: background\copy!
      overlay: overlay\copy!
      size: size\copy!
      pos: Vector()
      visible: false
      opacity: 0
      layout: layout!
    })

  create_widgets: =>
    @containers.padding = wibox.container.margin()
    @containers.margin = wibox.container.margin()
    @containers.background = wibox.container.background(wibox.widget.textbox())
    @containers.overlay = wibox.container.background(wibox.widget.textbox())
    @content_container = @containers.margin
    @containers.padding.widget = wibox.widget({
      layout: wibox.layout.stack,
      @containers.background,
      @containers.margin,
      @containers.overlay
    })
    @widget = @containers.padding
    @widget.visible = false

  create_content: =>
    @content = wibox.layout({
      layout: wibox.layout.manual
    })
    for i, child in ipairs @children
      if cord.util.is_object_class(child, "cord.wim.node")
        @content\add_at(child.widget, {x:0,y:0})
      else
        @content\add_at(child, {x:0,y:0})

    @content_container.widget = @content
  
  get_size: =>
    size = cord.util.normalize_vector_in_context(@current_style\get("size"), @parent and @parent\get_content_size! or Vector(100,100))
    return size

  get_inside_size: =>
    result = @\get_size!
    padding = @current_style\get("padding")
    result.x -= (padding.left + padding.right)
    result.y -= (padding.top + padding.bottom)
    return result

  get_content_size: =>
    result = @\get_inside_size!
    margin = @current_style\get("margin")
    result.x -= (margin.left + margin.right)
    result.y -= (margin.top + margin.bottom)
    return result

  set_pos: (pos) =>
    @current_style\get("pos").x = pos.x
    @current_style\get("pos").y = pos.y
    if not @parent
      return
    @parent.content\move_widget(@widget, @current_style\get("pos")\to_primitive!)

  set_visible: (visible = not @current_style\get("visible"), force = false) =>
    current = @current_style\get("visible")
    if force
      @widget.visible = visible
    @current_style\set("visible", visible)
    if not (current == visible)
      @\emit_signal("geometry_changed")
      @\emit_signal("visibility_changed")

  set_opacity: (opacity) =>
    @current_style\set("opacity", opacity)
    @widget.opacity = @current_style\get("opacity")
    @widget\emit_signal("widget::redraw_needed")

return Node
