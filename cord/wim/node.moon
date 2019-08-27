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
  util: require "cord.util"
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

    if type(children) == "table"
      for k, child in pairs @children
        if child.__name and child.__name == "cord.wim.node"
          child.parent = self
      
    @parent = nil
    @content = nil
    @containers = {}
    @last_container = nil
    @widget = nil

    @\create_content!
    @\ensure_containers!
    @\reorder_containers!
    @\stylize_containers!

  reorder_containers: =>
    last_required = nil
    for i, val in ipairs container_order
      if @containers[val]
        container = @containers[val]
        if val == "background" and @containers.overlay
          print("background and overlay")
          container = wibox.widget({
            @containers[val],
            @containers.overlay,
            layout: wibox.layout.stack
          })
        if not last_required then
          print("make " .. val .. " first required")
          @widget = container
        else
          print("linked container " .. val .. " to last")
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
      @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style.values.background_color or nil) or gears.color.transparent
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style.values.color or nil) or "#FFFFFF"
      @containers.background.shape = @style.values.background_shape or gears.shape.rectangle
    if @containers.place
      @containers.place.forced_width = size.x
      @containers.place.forced_height = size.y
      @containers.place.halign = @style.values.align_horizontal or "center"
      @containers.place.valign = @style.values.align_vertical or "center"
    if @containers.overlay
      @containers.overlay.forced_width = inside_size.x
      @containers.overlay.forced_width = inside_size.y
      @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style.values.overlay_color or nil) or gears.color.transparent
      @containers.overlay.shape = @style.values.overlay_shape or gears.shape.rectangle

  create_content: =>
    @content = wibox.widget({
      layout: @style.values.layout or wibox.layout.fixed.horizontal,
      unpack(@children)
    })

  search_node: (category, label) =>
    results = {}
    if (not category and true or @category == category) or (not label and true or @label == label)
      results = gears.table.join(results, {self})
    for k, child in pairs @children
      if child.__name and child.__name == "cord.wim.node"
        gears.table.join(results, child\search_node(category, label))
    return results

  get_content_size: =>
    result = Vector(0,0,"pixel")
    if not @style.values.size
      @style.values.size = Vector(1,1)
      @style.values.size.metric = "percentage"
    if @style.values.size.metric != "percentage"
      result.x = @style.values.size.x
      result.y = @style.values.size.y
    else
      result = @parent\get_content_size!
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

return Node
