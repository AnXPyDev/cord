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
    @category = category
    @label = label
    @style = stylesheet\get_style(@category, @label)
    @children = children

    if type(children) == "table"
      for k, child in pairs @children
        if child.__name == "Node"
          child.parent = self
      
    @parent = nil
    @content = nil
    @containers = {}
    @last_container = nil
    @widget = nil

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
          last_required = @containers[val]
        else
          last_required.widget = @containers[val]
        last_required = @containers[val]
    last_required.widget = @content
    @last_container = last_required

  ensure_containers: =>
    if @style.align_horizontal or @style.align_vertical and not @containers.place
      @containers.place = wibox.container.place()
    if (@style.background_color or @style.color or @style.background_shape) and not @containers.background
      @containers.background = wibox.container.background()
    if cord.table.sum(@style.margin or {}) != 0 and not @containers.margin
      @containers.margin = wibox.container.margin()
    if (@style.overlay_color or @style.overlay_shape) and not @containers.overlay
      @containers.overlay = wibox.container.background(wibox.widget.textbox())

  stylize_containers: =>
    @style.size = @style.size or Vector(1, 1, "percentage")
    if @style.size then
      size = @\get_size!
      @containers.padding.forced_width = size.x
      @containers.padding.forced_width = size.y
    if @containers.padding and @style.padding
      @style.padding\apply(@containers.padding)
    if @containers.margin and @style.margin
      @style.margin\apply(@containers.margin)
    if @containers.background
      @containers.background.bg = cord.util.normalize_as_pattern_or_color(@style.background_color) or gears.color.transparent
      @containers.background.fg = cord.util.normalize_as_pattern_or_color(@style.color) or "#FFFFFF"
      @containers.background.shape = @style.background_shape or gears.shape.rectangle
    if @containers.place
      @containers.place.halign = @style.align_horizontal or "center"
      @containers.place.valign = @style.align_vertical or "center"
    if @containers.overlay
      @containers.overlay.bg = cord.util.normalize_as_pattern_or_color(@style.overlay_color) or gears.color.transparent
      @containers.overlay.shape = @style.overlay_shape or gears.shape.rectangle

  create_content: =>
    if type(@children) == "table"
      @content = wibox.widget({
        layout: @style.layout or wibox.layout.fixed.horizontal,
        unpack(@children)
      })
    else
      @content = @children

  search_node: (category, label) =>
    results = {}
    if (not category and true or @category == category) or (not label and true or @label == label)
      results = gears.table.join(results, {self})
    if type(@children) == "table"
      for k, child in pairs @children
        if child.__name and child.__name == "Node"
          gears.table.join(results, child\search_node(category, label))
    else if @children.__name or @children.__name == "Node"
      gears.table.join(results, @children\search_node(category, label))
    return results

  get_content_size: =>
    result = Vector(0,0,"pixel")
    if not @style.size
      @style.size = Vector(1,1)
      @style.size.metric = "percentage"
    if @style.size.metric != "percentage"
      result.x = @style.size.x
      result.y = @style.size.y
    else
      result = @parent\get_content_size!
      result.x *= @style.size.x
      result.y *= @style.size.y
    if @style.padding
      result.x -= (@style.padding.left + @style.padding.right)
      result.y -= (@style.padding.top + @style.padding.bottom)
    if @style.margin
      result.x -= (@style.margin.left + @style.margin.right)
      result.y -= (@style.margin.top + @style.margin.bottom)
    return result

  get_size: =>
    result = Vector()
    result = Vector(0, 0, "pixel")
    if not @style.size
      @style.size = Vector(1, 1, "percentage")
    if @style.size.metric != "percentage"
      result.x = @style.size.x
      result.y = @style.size.y
    else
      result = @parent\get_content_size!
      result.x *= @style.size.x
      result.y *= @style.size.y
    return result

return Node
