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
  table: require "cord.table",
  util: require "cord.util",
  wim: { layout: require "cord.wim.layouts" },
  log: require "cord.log",
  math: require "cord.math"
}
  
unique_id_counter = 0
  
class Node extends Object
  new: (category="__empty_node_category__", label="__empty_node_label__", stylesheet, children={}, data = {}) =>
    super!
    @__name = "cord.wim.node"
    unique_id_counter += 1
    @unique_id = unique_id_counter
    @category = category
    @label = label
    @style = stylesheet\get_style(@category, @label)
    @style_data = {}
    @children = children
    @parent = nil
    @content = nil
    @containers = {}
    @stylizers = {}
    @content_container = nil
    @widget = nil
    @visible = true
    @pos = cord.math.vector()

    cord.table.deep_crush(self, data)

    @\for_each_node_child(((child) -> child.parent = self))
    
    @\create_signals!
    @\create_containers!
    @\create_content!
    @\create_stylizers!

    @\connect_signal("request_load_style", () ->
      @\load_style_data!
      @\stylize_containers!
      @\for_each_node_child(((child) -> child\emit_signal("request_load_style")))
    )

    @\emit_signal("request_load_style")

    if @visible
      @\emit_signal("geometry_changed")

  for_each_node_child: (fn) =>
    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        fn(child)

  create_signals: =>
    @\connect_signal("request_stylize", (container_name) ->
      if container_name and @stylizers[container_name]
        @stylizers[container_name]()
      else
        for k, fn in pairs @stylizers
          fn!
    )

    @\connect_signal("layout_changed", () ->
      @style_data.layout\apply_layout(self)
    )

    @\connect_signal("geometry_changed", () ->
      @\emit_signal("layout_changed")
      @parent and @parent\emit_signal("layout_changed")
    )
        
  load_style_data: =>
    @style_data = {
      background_padding: @style\get("background_padding") or @style\get("padding") or Margin(0),
      content_padding: @style\get("content_padding") or @style\get("padding") or Margin(0),
      content_margin: @style\get("content_margin") or @style\get("margin") or Margin(0),
      overlay_padding: @style\get("overlay_padding") or @style\get("padding") or Margin(0),

      background_shape: @style\get("background_shape") or @style\get("shape") or gears.shape.rectangle,
      overlay_shape: @style\get("overlay_shape") or @style\get("shape") or gears.shape.rectangle,

      background_color: @style\get("background_color") or gears.color.transparent,
      overlay_color: @style\get("overlay_color") or gears.color.transparent,
      color: @style\get("color") or "#FFFFFF",

      background_pattern_beginning: @style\get("background_pattern_beginning") or @style\get("pattern_beginning") or Vector(0, 0, "percentage"),
      background_pattern_ending: @style\get("background_pattern_ending") or @style\get("pattern_ending") or Vector(1, 0, "percentage"),
      overlay_pattern_beginning: @style\get("overlay_pattern_beginning") or @style\get("pattern_beginning") or Vector(0, 0, "percentage"),
      overlay_pattern_ending: @style\get("overlay_pattern_ending") or @style\get("pattern_ending") or Vector(1, 0, "percentage"),

      layout: @style\get("layout") or cord.wim.layout.manual(),
      size: @style\get("size") or Vector(100)

    }

  create_containers: =>
    @containers.background_padding = wibox.container.margin()
    @containers.content_padding = wibox.container.margin()
    @containers.content_margin = wibox.container.margin()
    @containers.overlay_padding = wibox.container.margin()
    @containers.background = wibox.container.background(wibox.widget.textbox())
    @containers.overlay = wibox.container.background(wibox.widget.textbox())
    @containers.content_padding.widget = @containers.content_margin
    @containers.background_padding.widget = @containers.background
    @containers.overlay_padding.widget = @containers.overlay
    @content_container = @containers.content_margin
    @widget = wibox.widget({
      layout: wibox.layout.stack,
      @containers.background_padding,
      @containers.content_padding,
      @containers.overlay_padding
    })
    @widget.visible = @visible

  create_stylizers: =>
    @stylizers.background_padding = () ->
      size = @\get_size!
      @containers.background_padding.forced_width = size.x
      @containers.background_padding.forced_height = size.y
      @style_data.background_padding\apply(@containers.background_padding)
      @containers.background_padding\emit_signal("widget::redraw_needed")

    @stylizers.content_padding = () ->
      size = @\get_size!
      @containers.content_padding.forced_width = size.x
      @containers.content_padding.forced_height = size.y
      @style_data.content_padding\apply(@containers.content_padding)
      @containers.content_padding\emit_signal("widget::redraw_needed")

    @stylizers.content_margin = () ->
      size = @\get_inside_size!
      @containers.content_margin.forced_width = size.x
      @containers.content_margin.forced_height = size.y
      @style_data.content_margin\apply(@containers.content_margin)
      @containers.content_margin\emit_signal("widget::redraw_needed")

    @stylizers.overlay_padding = () ->
      size = @\get_size!
      @containers.overlay_padding.forced_width = size.x
      @containers.overlay_padding.forced_height = size.y
      @style_data.overlay_padding\apply(@containers.overlay_padding)
      @containers.overlay_padding\emit_signal("widget::redraw_needed")

    @stylizers.background = () ->
      size = @\get_background_size!
      if cord.util.get_object_class(@style_data.background_color) == "cord.util.pattern"
        @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style_data.background_color, @\get_background_pattern_template!)
      else
        @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style_data.background_color)
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style_data.color)
      @containers.background.forced_width = size.x
      @containers.background.forced_height = size.y
      @containers.background.shape = @style_data.background_shape
      @containers.background\emit_signal("widget::redraw_needed")

    @stylizers.overlay = () ->
      size = @\get_overlay_size!
      if cord.util.get_object_class(@style_data.overlay_color) == "cord.util.pattern"
        @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style_data.overlay_color, @\get_overlay_pattern_template!)
      else
        @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style_data.overlay_color)
      @containers.overlay.fg = gears.color.transparent
      @containers.overlay.forced_width = size.x
      @containers.overlay.forced_height = size.y
      @containers.overlay.shape = @style_data.overlay_shape
      @containers.overlay\emit_signal("widget::redraw_needed")

    @stylizers.layout = () ->
      old_layout = @style_data.layout
      @style_data.layout = @style\get("layout") or @style_data.layout
      if old_layout
        @style_data.layout\inherit(old_layout)

    @stylizers.content = () ->
      size = @\get_content_size!
      @content.forced_width = size.x
      @content.forced_width = size.y

  stylize_containers: =>
    for k, fn in pairs @stylizers
      fn()
        
  create_content: =>
    @content = wibox.layout({
      layout: wibox.layout.manual
    })
    for i, child in ipairs @children
      if child.__name and child.__name == "cord.wim.node"
        @content\add_at(child.widget, {x:0,y:0})
      else
        @content\add_at(child, {x:0,y:0})

    @content_container.widget = @content
  

  search_node: (category, label) =>
    results = {}
    if (not category and true or @category == category) or (not label and true or @label == label)
      results = gears.table.join(results, {self})
    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        gears.table.join(results, child\search_node(category, label))
    return results

  get_size: =>
    return cord.util.normalize_vector_in_context(@style_data.size, @parent and @parent\get_content_size! or Vector(100,100))

  get_inside_size: =>
    result = @\get_size!
    result.x -= (@style_data.content_padding.left + @style_data.content_padding.right)
    result.y -= (@style_data.content_padding.top + @style_data.content_padding.bottom)
    return result

  get_content_size: =>
    result = @\get_inside_size!
    result.x -= (@style_data.content_margin.left + @style_data.content_margin.right)
    result.y -= (@style_data.content_margin.top + @style_data.content_margin.bottom)
    return result

  get_pos: =>
    pos = @style\get("pos")
    result = cord.util.normalize_vector_in_context(pos, @parent and @parent\get_content_size! or Vector(100,100))
    return result

  set_pos: (pos) =>
    if not @parent
      return
    @parent.content\move_widget(@widget, pos\to_primitive!)
    @pos.x = pos.x
    @pos.y = pos.y

  get_background_size: =>
    result = @\get_size!
    result.x -= (@style_data.background_padding.left + @style_data.background_padding.right)
    result.y -= (@style_data.background_padding.top + @style_data.background_padding.bottom)
    return result

  get_background_pattern_template: =>
    size = @\get_background_size!
    pattern_beginning = cord.util.normalize_vector_in_context(@style_data.background_pattern_beginning, size)
    pattern_ending = cord.util.normalize_vector_in_context(@style_data.background_pattern_ending, size)
    return pattern_beginning, pattern_ending

  get_overlay_size: =>
    result = @\get_size!
    result.x -= (@style_data.overlay_padding.left + @style_data.overlay_padding.right)
    result.y -= (@style_data.overlay_padding.top + @style_data.overlay_padding.bottom)
    return result

  get_overlay_pattern_template: =>
    size = @\get_overlay_size!
    pattern_beginning = cord.util.normalize_vector_in_context(@style_data.overlay_pattern_beginning, size)
    pattern_ending = cord.util.normalize_vector_in_context(@style_data.overlay_pattern_ending, size)
    return pattern_beginning, pattern_ending

  set_visible: (visible = @visible) =>
    og = @visible
    @widget.visible = visible
    @visible = visible
    if visible != og
      @\emit_signal("geometry_changed")

return Node
