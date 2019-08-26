wibox = awesome and require "wibox" or {}
gears = { table: require "gears.table" }

Object = require "cord.object"
cord = { table: require "cord.table" }
  
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
    if @style.place and not @containers.place
      @containers.place = wibox.container.place()
    if cord.table.sum(@style.padding or {}) != 0 and not @containers.padding
      @containers.padding = wibox.container.margin()
    if (@style.background_color or @style.content_color or @style.background_shape) and not @containers.background
      @containers.background = wibox.container.background()
    if cord.table.sum(@style.margin or {}) != 0 and not @containers.margin
      @containers.margin = wibox.container.margin()
    if (@style.overlay_color or @style.overlay_shape) and not @containers.overlay
      @containers.overlay = wibox.container.background(wibox.widget.textbox())

  stylyze_containers: =>
  
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

return Node
