gears = require "gears"
wibox = require "wiobox"

Node = require "cord.wim.node"

types = require "cord.util.types"
normalize = require "cord.util.normalize"

cord = { table: require "cord.table" }
  
Margin = require "cord.util.margin"

layer_names = {"padding", "background", "margin"}

stylizers = {
  geometry: (container) ->
    if container.layers.padding
      outside_size = container\get_size("outside")

      container.layers.padding.forced_width = outside_size.x
      container.layers.padding.forced_height = outside_size.y
      
      padding = container.data\get("padding")
      if padding
        padding = normalize.margin(padding, outside_size)
        conatiner.layers.padding.left = padding.left
        conatiner.layers.padding.right = padding.right
        conatiner.layers.padding.top = padding.top
        conatiner.layers.padding.bottom = padding.bottom

    if container.layers.background or container.layers.margin
      inside_size = container\get_size("inside")

      if container.layers.background
        container.layers.background.forced_width = inside_size.x
        container.layers.background.forced_height = inside_size.y

      if container.layers.margin
        container.layers.margin.forced_width = inside_size.x
        container.layers.margin.forced_height = inside_size.y

        margin = container.data\get("margin")
        if margin
          margin = normalize.margin(margin, inside_size)
          conatiner.layers.margin.left = margin.left
          conatiner.layers.margin.right = margin.right
          conatiner.layers.margin.top = margin.top
          conatiner.layers.margin.bottom = margin.bottom

    content_size = container\get_size("content")
    container.content.force_width = content_size.x
    container.content.force_height = content_size.y

  background: (container) ->
    background = container.data\get("background")
    if container.layers.background and background
      container.layers.background.bg = normalize.color_or_pattern(background, container.data\get("pattern_template"), container\get_size("inside"))

  foreground: (container) ->
    foreground = container.data\get("foreground")
    if container.layers.background and foreground
      container.layers.background.fg = normalize.color_or_pattern(foreground)

  shape: (container) ->
    shape = container.data\get("shape")
    if container.layers.background and shape
      container.layers.background.shape = shape

}


class Container extends Node
  new: (stylesheet, identification, ...) =>
    super(stylesheet, identification, ...)
    table.insert(@__name, "cord.wim.container")

    -- Add to data
    @data\set("shape", @style\get("shape") or nil)
    @data\set("background", @style\get("background") or nil)
    @data\set("foreground", @style\get("foreground") or nil)
    @data\set("margin", @style\get("margin") or nil)
    @data\set("padding", @style\get("padding") or nil)
    @data\set("pattern_template", @style\get("pattern_template") or {Vector(0, 0, "percentage"), Vector(1, 0, "percentage")})

    @layers = {
      padding: nil
      background: nil
      margin: nil
    }

    -- Create base widget and layout
    @widget = wibox.widget!
    @content = wibox.layout.stack!

    @\create_layers!
    @\reorder_layers!

    -- Setup stylizers
    cord.table.crush(@stylizers, stylizers)

    -- Setup signals
    @\connect_signal("added_child", (child, index) -> @\add_to_content(child,index))
    @\connect_signal("removed_child", (child, index) -> @\remove_from_content(child,index))

    @\connect_signal("geometry_changed", () -> @\emit_signal("request_stylize", "geometry"))

    -- Add children to content
    for i, child in ipairs @children
      @\add_to_content(child, i)
    

  -- Creates only necessary layers
  create_layers: () =>
    if @data\get("padding") and not @layers.padding
      @layers.padding = wibox.container.margin!
    if (@data\get("shape") or @data\get("background") or @data\get("foreground")) and not @layers.background
      @layers.background = wibox.container.background!
    if @data\get("margin") and not @layers.margin
      @layers.margin = wibox.container.margin!
    
  reorder_layers: () =>
    last = @widget
    for i, layer_name in ipairs layer_names
      if @layers[layer_name]
        last.widget = @layers[layer_name]
        last = @layers[layer_name]

    last.widget = @content

  add_to_content: (child, index) =>
    @content\insert(index, child.widget)

  remove_from_content: (child, index) =>
    @content\remove(index)

  get_size: (scope = "content") ->
    result = normalize.vector(@data\get("size"), @parent and @parent\get_size!
    if scope == "content" or scope == "inside"
      padding = @data\get("padding")
      if padding
        padding = normalize.margin(padding, result)
        result.x -= padding.left + padding.right
        result.y -= padding.top + padding.bottom
      if scope == "content"
        margin = @data\get("margin")
        if margin
          margin = normalize.margin(margin, result)
          result.x -= margin.left + margin.right
          result.y -= margin.top + margin.bottom
        
    return result

return Container
