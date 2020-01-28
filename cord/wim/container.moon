gears = require "gears"
wibox = require "wibox"

Node = require "cord.wim.node"

types = require "cord.util.types"
normalize = require "cord.util.normalize"

cord = {
  table: require "cord.table"
  log: require "cord.log"
}
  
Margin = require "cord.util.margin"
Vector = require "cord.math.vector"

stylizers = {
  geometry: =>
    if @layers.padding
      outside_size = @\get_size("outside")
      @layers.padding.forced_width = outside_size.x
      @layers.padding.forced_height = outside_size.y
      
      padding = @data\get("padding")
      if padding
        padding = normalize.margin(padding, outside_size)
        @layers.padding.left = padding.left
        @layers.padding.right = padding.right
        @layers.padding.top = padding.top
        @layers.padding.bottom = padding.bottom

    if @layers.background or @layers.margin
      inside_size = @\get_size("inside")
      if @layers.background
        @layers.background.forced_width = inside_size.x
        @layers.background.forced_height = inside_size.y

      if @layers.margin
        @layers.margin.forced_width = inside_size.x
        @layers.margin.forced_height = inside_size.y

        margin = @data\get("margin")
        if margin
          margin = normalize.margin(margin, inside_size)
          @layers.margin.left = margin.left
          @layers.margin.right = margin.right
          @layers.margin.top = margin.top
          @layers.margin.bottom = margin.bottom

    content_size = @\get_size("content")
    @content.force_width = content_size.x
    @content.force_height = content_size.y

  border: =>
    width = @data\get("border_width")
    color = @data\get("border_color")
    if width and color
      @layers.background.border_width = width
      @layers.background.border_color = normalize.color_or_pattern(color, @data\get("pattern_template"), @\get_size("inside"))

  background: =>
    background = @data\get("background")
    if @layers.background and background
      @layers.background.bg = normalize.color_or_pattern(background, @data\get("pattern_template"), @\get_size("inside"))

  foreground: =>
    foreground = @data\get("foreground")
    if @layers.background and foreground
      @layers.background.fg = normalize.color_or_pattern(foreground)

  shape: =>
    shape = @data\get("shape")
    if @layers.background and shape
      @layers.background.shape = shape

  opacity: =>
    @widget.opacity = @data\get("opacity")

  visibility: =>
    @widget.visible = @data\get("visible") and not @data\get("hidden")

}


class Container extends Node
  new: (stylesheet, identification, ...) =>
    super(stylesheet, identification, ...)
    table.insert(@__name, "cord.wim.container")

    -- Add to data
    @data\set("shape", @style\get("shape") or nil)
    @data\set("background", @style\get("background") or nil)
    @data\set("foreground", @style\get("foreground") or nil)
    @data\set("border_width", @style\get("border_width") or nil)
    @data\set("border_color", @style\get("border_color") or nil)
    @data\set("margin", @style\get("margin") or nil)
    @data\set("padding", @style\get("padding") or nil)
    @data\set("pattern_template", @style\get("pattern_template") or {Vector(0, 0, "percentage"), Vector(1, 0, "percentage")})

    @layers = {
      padding: nil
      background: nil
      margin: nil
    }

    -- Create base widget and layout
    @content = wibox.layout.stack!

    @\create_layers!
    @\reorder_layers!

    for i, layer_name in ipairs {"padding", "background", "margin"}
      if @layers[layer_name]
        @widget = @layers[layer_name]
        break

    -- Setup stylizers
    cord.table.crush(@stylizers, stylizers)

    -- Setup signals
    @\connect_signal("added_child", (child, index) -> @\add_to_content(child,index))
    @\connect_signal("removed_child", (child, index) -> @\remove_from_content(child,index))

    @\connect_signal("geometry_changed::inside", () ->
      @\stylize("geometry")
    )

    @data\connect_signal("key_changed::opacity", () -> @stylize("opacity"))
    @data\connect_signal("key_changed::visible", () -> @stylize("visibility"))
    @data\connect_signal("key_changed::hidden", () -> @stylize("visibility"))
    @data\connect_signal("key_changed::background", () -> @stylize("background"))
    @data\connect_signal("key_changed::foreground", () -> @stylize("foreground"))
    @data\connect_signal("key_changed::shape", () -> @stylize("shape"))
    @data\connect_signal("key_changed::border_width", () -> @stylize("border"))
    @data\connect_signal("key_changed::border_color", () -> @stylize("border"))
    @data\connect_signal("key_changed::margin", () -> @\emit_signal("geometry_changed::inside"))
    @data\connect_signal("key_changed::padding", () -> @\emit_signal("geometry_changed::inside"))

    -- Add children to content
    for i, child in ipairs @children
      @\add_to_content(child, i)
    
    @\stylize!

  -- Creates only necessary layers
  create_layers: () =>
    if @data\get("padding") and not @layers.padding
      @layers.padding = wibox.container.margin!

      @layers.padding\connect_signal("mouse::enter", () ->
        @\emit_signal("mouse_enter")
        @\emit_signal("mouse_enter::outside")
      )

      @layers.padding\connect_signal("mouse::leave", () ->
        @\emit_signal("mouse_leave")
        @\emit_signal("mouse_leave::outside")
      )

      @layers.padding\connect_signal("button::press", (w, x, y, button, mods) ->
        @\emit_signal("button_press", button, mods, x, y)
        @\emit_signal("button_press::outside", button, mods, x, y)
      )

      @layers.padding\connect_signal("button::release", (w, x, y, button, mods) ->
        @\emit_signal("button_release", button, mods, x, y)
        @\emit_signal("button_release::outside", button, mods, x, y)
      )

    if (@data\get("shape") or @data\get("background") or @data\get("foreground") or (@data\get("border_width") and @data\get("border_color"))) and not @layers.background
      @layers.background = wibox.container.background!

      if not @layers.margin
        @layers.background\connect_signal("mouse::enter", () ->
          if not @layers.padding
            @\emit_signal("mouse_enter")
          @\emit_signal("mouse_enter::inside")
        )

        @layers.background\connect_signal("mouse::leave", () ->
          if not @layers.padding
            @\emit_signal("mouse_leave")
          @\emit_signal("mouse_leave::inside")
        )

        @layers.background\connect_signal("button::press", (w, x, y, button, mods) ->
          if not @layers.padding
            @\emit_signal("button_press", button, mods, x, y)
          @\emit_signal("button_press::inside", button, mods, x, y)
        )

        @layers.background\connect_signal("button::release", (w, x, y, button, mods) ->
          if not @layers.padding
            @\emit_signal("button_release", button, mods, x, y)
          @\emit_signal("button_release::inside", button, mods, x, y)
        )

    if @data\get("margin") and not @layers.margin
      @layers.margin = wibox.container.margin!
      if not @layers.background
        @layers.margin\connect_signal("mouse::enter", () ->
          if not @layers.padding
            @\emit_signal("mouse_enter")
          @\emit_signal("mouse_enter::inside")
        )

        @layers.margin\connect_signal("mouse::leave", () ->
          if not @layers.padding
            @\emit_signal("mouse_leave")
          @\emit_signal("mouse_leave::inside")
        )

        @layers.margin\connect_signal("button::press", (w, x, y, button, mods) ->
          if not @layers.padding
            @\emit_signal("button_press", button, mods, x, y)
          @\emit_signal("button_press::inside", button, mods, x, y)
        )

        @layers.margin\connect_signal("button::release", (w, x, y, button, mods) ->
          if not @layers.padding
            @\emit_signal("button_release", button, mods, x, y)
          @\emit_signal("button_release::inside", button, mods, x, y)
        )

  reorder_layers: () =>
    last = {}
    for i, layer_name in ipairs {"padding", "background", "margin"}
      if @layers[layer_name]
        last.widget = @layers[layer_name]
        last = @layers[layer_name]

    last.widget = @content

  add_to_content: (child, index) =>
    @content\insert(index, child.widget)

  remove_from_content: (child, index) =>
    @content\remove(index)

  get_size: (scope = "outside") =>
    result = normalize.vector(@data\get("size"), @parent and @parent\get_size!)
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
