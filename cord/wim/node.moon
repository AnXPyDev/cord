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
    if @style.values.align_horizontal or @style.values.align_vertical and not @containers.place
      @containers.place = wibox.container.place()
    if (@style.values.background_color or @style.values.color or @style.values.background_shape) and not @containers.background
      @containers.background = wibox.container.background()
    if cord.table.sum(@style.values.margin or {}) != 0 and not @containers.margin
      @containers.margin = wibox.container.margin()
    if (@style.values.overlay_color or @style.values.overlay_shape) and not @containers.overlay
      @containers.overlay = wibox.container.background(wibox.widget.textbox())

  stylize_containers: =>
    @style.values.size = @style.values.size or Vector(1, 1, "percentage")
    size = @\get_size!
    inside_size = @\get_inside_size!
    if @containers.padding
      @containers.padding.forced_width = size.x
      @containers.padding.forced_height = size.y
      if @style.values.padding
        @style.values.padding\apply(@containers.padding)
    if @containers.margin
      @containers.margin.forced_width = inside_size.x
      @containers.margin.forced_height = inside_size.y
      if @style.values.margin
        @style.values.margin\apply(@containers.margin)
    if @containers.background
      @containers.background.forced_width = inside_size.x
      @containers.background.forced_width = inside_size.y
      @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style.values.background_color or nil, unpack(@pattern_template)) or gears.color.transparent
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style.values.color or nil, unpack(@pattern_template)) or "#FFFFFF"
      @containers.background.shape = @style.values.background_shape or gears.shape.rectangle
    if @containers.place
      @containers.place.forced_width = size.x
      @containers.place.forced_height = size.y
      @containers.place.halign = @style.values.align_horizontal or "center"
      @containers.place.valign = @style.values.align_vertical or "center"
    if @containers.overlay
      @containers.overlay.forced_width = inside_size.x
      @containers.overlay.forced_width = inside_size.y
      @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style.values.overlay_color or nil, unpack(@pattern_template)) or gears.color.transparent
      @containers.overlay.shape = @style.values.overlay_shape or gears.shape.rectangle

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
    if @style.values.layout
      @style.values.layout(self)
    else
      cord.wim.layout.manual(self)
      
  get_content_size: =>
    result = Vector(0,0,"pixel")
    if not @style.values.size
      @style.values.size = Vector(1,1)
      @style.values.size.metric = "percentage"
    if @style.values.size.metric != "percentage"
      result.x = @style.values.size.x
      result.y = @style.values.size.y
    else
      result = @parent and @parent\get_content_size! or Vector(100,100)
      result.x *= @style.values.size.x
      result.y *= @style.values.size.y
    if @style.values.padding
      result.x -= (@style.values.padding.left + @style.values.padding.right)
      result.y -= (@style.values.padding.top + @style.values.padding.bottom)
    if @style.values.margin
      result.x -= (@style.values.margin.left + @style.values.margin.right)
      result.y -= (@style.values.margin.top + @style.values.margin.bottom)
    return result

  get_size: =>
    result = Vector(0, 0, "pixel")
    if not @style.values.size
      @style.values.size = Vector(1, 1, "percentage")
    if @style.values.size.metric != "percentage"
      result.x = @style.values.size.x
      result.y = @style.values.size.y
    else
      result = @parent and @parent\get_content_size! or Vector(100,100)
      result.x *= @style.values.size.x
      result.y *= @style.values.size.y
    return result

  get_inside_size: =>
    result = @\get_size!
    if @style.values.padding
      result.x -= (@style.values.padding.left + @style.values.padding.right)
      result.y -= (@style.values.padding.top + @style.values.padding.bottom)
    return result

  get_pos: =>
    local result
    if @style.values.pos
      if @style.values.pos.metric == "percentage"
        parent_content_size = @parent and @parent\get_content_size! or Vector(100,100)
        result = Vector(
          parent_content_size.x * @style.values.pos.x
          parent_content_size.y * @style.values.pos.y
        )
      else
        result = @style.values.pos
    else
      result = Vector()
    return result

  get_pattern_template: =>
    pattern_beginning = @style.values.pattern_beginning or Vector(0, 0, "percentage")
    pattern_ending = @style.values.pattern_ending or Vector(1, 0, "percentage")

    local size
    if pattern_beginning.metric == "percentage"
      size = size or @\get_inside_size!
      pattern_beginning = Vector(pattern_beginning.x * size.x, pattern_beginning.y * size.y)
    if pattern_ending.metric == "percentage"
      size = size or @\get_inside_size!
      pattern_ending = Vector(pattern_ending.x * size.x, pattern_ending.y * size.y)
    cord.log(@category, @label, "pattern_template", pattern_beginning, pattern_ending)
    return pattern_beginning, pattern_ending

return Node
