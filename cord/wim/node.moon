wibox = awesome and require "wibox" or {}

gears = {
  table: require "gears.table",
  color: require "gears.color",
  shape: require "gears.shape"
}

Object = require "cord.util.object"
Vector = require "cord.math.vector"
  
cord = {
  table: require "cord.table",
  util: require "cord.util",
  wim: { layout: require "cord.wim.layout" },
  log: require "cord.log"
}
  
container_order = {
  "place",
  "padding",
  "background",
  "margin"
}

class Node extends Object
  new: (category="__empty_node_category__", label="__empty_node_label__", stylesheet, children={}) =>
    super!
    @__name = "cord.wim.node"
    @category = category
    @label = label
    @style = stylesheet\get_style(@category, @label)
    @children = children
    @parent = nil
    @content = nil
    @containers = {}
    @last_container = nil
    @widget = nil
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
      @\reload_layout!
      cord.log(@category, @label, "size", @\get_size!, "inside_size", @\get_inside_size!, "content_size", @\get_content_size!)
    ))

    @\emit_signal("style_changed")

    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        child\emit_signal("style_changed")

  reorder_containers: =>
    last_required = nil
    for i, val in ipairs container_order
      if @containers[val]
        container = @containers[val]
        if val == "background" and @containers.overlay
          container = wibox.widget({
            @containers[val],
            @containers.overlay,
            layout: wibox.layout.stack
          })
        if not last_required then
          @widget = container
        else
          last_required.widget = container
        last_required = container
    last_required.widget = @content
    @last_container = last_required

  ensure_containers: =>
    if not @containers.padding
      @containers.padding = wibox.container.margin()
    if @style\get("align_horizontal") or @style\get("align_vertical") and not @containers.place
      @containers.place = wibox.container.place()
    if (@style\get("background_color") or @style\get("color") or @style\get("background_shape")) and not @containers.background
      @containers.background = wibox.container.background()
    if cord.table.sum(@style\get("margin") or {}) != 0 and not @containers.margin
      @containers.margin = wibox.container.margin()
    if (@style\get("overlay_color") or @style\get("overlay_shape")) and not @containers.overlay
      @containers.overlay = wibox.container.background(wibox.widget.textbox())

  stylize_containers: =>
    size = @\get_size!
    inside_size = @\get_inside_size!
    padding = @style\get("padding")
    margin = @style\get("margin")
    if @containers.padding
      @containers.padding.forced_width = size.x
      @containers.padding.forced_height = size.y
      if padding
        padding\apply(@containers.padding)
    if @containers.margin
      @containers.margin.forced_width = inside_size.x
      @containers.margin.forced_height = inside_size.y
      if margin
        margin\apply(@containers.margin)
    if @containers.background
      @containers.background.forced_width = inside_size.x
      @containers.background.forced_width = inside_size.y
      @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style\get("background_color"), unpack(@pattern_template)) or gears.color.transparent
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style\get("color") or nil, unpack(@pattern_template)) or "#FFFFFF"
      @containers.background.shape = @style\get("background_shape") or gears.shape.rectangle
    if @containers.place
      @containers.place.forced_width = size.x
      @containers.place.forced_height = size.y
      @containers.place.halign = @style\get("align_horizontal") or "center"
      @containers.place.valign = @style\get("align_vertical") or "center"
    if @containers.overlay
      @containers.overlay.forced_width = inside_size.x
      @containers.overlay.forced_width = inside_size.y
      @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style\get("overlay_color") or nil, unpack(@pattern_template)) or gears.color.transparent
      @containers.overlay.shape = @style\get("overlay_shape") or gears.shape.rectangle
    if @content
      content_size = @\get_content_size!
      @content.forced_width = content_size.x
      @content.forced_height = content_size.y

  create_content: =>
    @content = wibox.widget({
      layout: @layout,
      unpack(
        gears.table.map(
          ((child) ->
            local ret
            if child.__name and child.__name == "cord.wim.node"
              ret = child.widget
            else
              ret = child
            ret.point = {x:0, y:0}
            return ret),
          @children
        )
      )
    })

  search_node: (category, label) =>
    results = {}
    if (not category and true or @category == category) or (not label and true or @label == label)
      results = gears.table.join(results, {self})
    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        gears.table.join(results, child\search_node(category, label))
    return results

  reload_layout: =>
    if @style\get("layout")
      @style\get("layout")(self)
    else
      cord.wim.layout.manual(self)
      
  get_content_size: =>
    if not @style\get("size")
      @style\set("size", Vector(1,1))
      @style.values.size.metric = "percentage"
    size = @style\get("size")
    result = cord.util.normalize_vector_in_context(size, @parent and @parent\get_content_size! or Vector(100,100))
    padding = @style\get("padding")
    if padding
      result.x -= (padding.left + padding.right)
      result.y -= (padding.top + padding.bottom)
    margin = @style\get("margin")
    if margin
      result.x -= (margin.left + margin.right)
      result.y -= (margin.top + margin.bottom)
    return result

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
    padding = @style\get("padding")
    if padding
      result.x -= (padding.left + padding.right)
      result.y -= (padding.top + padding.bottom)
    return result

  get_pos: =>
    pos = @style\get("pos")
    result = cord.util.normalize_vector_in_context(pos, @parent and @parent\get_content_size! or Vector(100,100))
    return result

  get_pattern_template: =>
    size = @\get_inside_size!
    pattern_beginning = cord.util.normalize_vector_in_context(@style\get("pattern_beginning") or Vector(0, 0, "percentage"), size)
    pattern_ending = cord.util.normalize_vector_in_context(@style\get("pattern_ending") or Vector(1, 0, "percentage"), size)
    return pattern_beginning, pattern_ending

return Node
