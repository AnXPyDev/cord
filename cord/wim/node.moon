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
  wim: { layout: require "cord.wim.layout" },
  log: require "cord.log",
  math: require "cord.math"
}
  
unique_id_counter = 0
  
class Node extends Object
  new: (category="__empty_node_category__", label="__empty_node_label__", stylesheet, children={}) =>
    super!
    @__name = "cord.wim.node"
    unique_id_counter += 1
    @unique_id = unique_id_counter
    @category = category
    @label = label
    @style = stylesheet\get_style(@category, @label)
    @children = children
    @parent = nil
    @content = nil
    @containers = {}
    @stylizers = {}
    @content_container = nil
    @widget = nil
    @visible = false
    @pos = cord.math.vector()
    @layout = wibox.layout ({
      layout: wibox.layout.manual
    })

    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        child.parent = self

    @\create_content!

    @\connect_signal("style_changed", ((...) ->
      @\ensure_containers!
      @\reorder_containers!
      @pattern_template = {@\get_pattern_template!}
      @\stylize_containers!
      @\set_visible!
    ))

    @\connect_signal("layout_changed", ((...) ->
      @\reload_layout!
    ))

    @\emit_signal("style_changed")

    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        child\emit_signal("style_changed")

  load_style_data: =>
    @style_data = {

      background_padding = @style\get("background_padding") or @style\get("padding") or Margin(0),
      content_padding = @style\get("content_padding") or @style\get("padding") or Margin(0),
      content_margin = @style\get("content_margin") or @style\get("margin") or Margin(0),
      overlay_padding = @style\get("overlay_padding") or @style\get("padding") or Margin(0),

      background_shape = @style\get("background_shape") or @style\get("shape") or gears.shape.rectangle,
      overlay_shape = @style\get("overlay_shape") or @style\get("shape") or gears.shape.rectangle,

      background_color = @style\get("background_color") or gears.color.transparent,
      overlay_color = @style\get("background_color") or gears.color.transparent,
      color = @style\get("color") or "#FFFFFF",

      background_pattern_beginning = @style\get("background_pattern_beginning") or @style\get("pattern_beginning") or Vector(0, 0, "percentage")
      background_pattern_ending = @style\get("background_pattern_ending") or @style\get("pattern_ending") or Vector(1, 0, "percentage")
      overlay_pattern_beginning = @style\get("overlay_pattern_beginning") or @style\get("pattern_beginning") or Vector(0, 0, "percentage")
      overlay_pattern_ending = @style\get("overlay_pattern_ending") or @style\get("pattern_ending") or Vector(1, 0, "percentage")

      size = @style\get("size") or Vector(100)
    }

  create_containers: =>
    @containers.background_padding = wibox.container.margin()
    @containers.content_padding = wibox.container.margin()
    @containers.content_margin = wibox.container.margin()
    @containers.overlay_padding = wibox.container.margin()
    @containers.background = wibox.container.background()
    @containers.overlay = wibox.container.background()
    @containers.content_padding.widget = @containers.content_margin
    @containers.content_margin.widget = @content
    @content_container = @containers.content_margin
    @widget = wibox.widget({
      layout: wibox.layout.stack,
      @containers.background_padding,
      @containers.content_padding,
      @containers.overlay_padding
    })

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
      @style_data.content_padding\copy!\join(@style_data.content_margin)\apply(@containers.content_padding)
      @containers.content_padding\emit_signal("widget::redraw_needed")

    @stylizers.content_margin = () ->
      size = @\get_inside_size!
      @containers.content_margin.forced_width = size.x
      @containers.content_margin.forced_height = size.y
      @style_data.content_margin\apply(@containers.content_padding)
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
        @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style_data.background_color, @\get_background_pattern_template)
      else
        @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style_data.background_color)
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style_data.color)

    @stylizers.overlay = () ->
      size = @\get_overlay_size!
      if cord.util.get_object_class(@style_data.overlay_color) == "cord.util.pattern"
        @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style_data.overlay_color, @\get_overlay_pattern_template)
      else
        @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style_data.overlay_color)
      @containers.overlay.fg = gears.color.transparent

  stylize_containers: =>
    


  create_content: =>
    @content = wibox.layout({
      layout: wibox.layout.manual
    })
    for i, child in ipairs @children
      if child.__name and child.__name == "cord.wim.node"
        @content\add_at(child.widget, {x:0,y:0})
      else
        @content\add_at(child, {x:0,y:0})

  search_node: (category, label) =>
    results = {}
    if (not category and true or @category == category) or (not label and true or @label == label)
      results = gears.table.join(results, {self})
    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        gears.table.join(results, child\search_node(category, label))
    return results

  reload_layout: =>
    if not @style\get("layout")
      @style\set("layout", cord.wim.layout())
    @style\get("layout")\apply_layout(self)

  get_size: =>
    result = Vector(0, 0, "pixel")
    size = @style\get("size")
    if not size
      @style\set("size", Vector(1, 1, "percentage"))
    size = @style\get("size")
    result = cord.util.normalize_vector_in_context(size, @parent and @parent\get_content_size! or Vector(100,100))
    return result

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
    orig = @visible
    @visible = visible
    @widget.visible = @visible
    if visible == true and orig == false
      @parent and @parent\emit_signal("layout_changed")
      @\emit_signal("layout_changed")

return Node
