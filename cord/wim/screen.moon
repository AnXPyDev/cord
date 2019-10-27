Object = require "cord.util.object"

Vector = require "cord.math.vector"

unique_id_counter = 0

class Screen extends Object
  new: (category="__empty_node_category__", label="__empty_node_label__", stylesheet, screen, children = {}) =>
    super!
    @__name = "cord.wim.screen"
    unique_id_counter += 1
    @unique_id = unique_id_counter
    @category = category
    @label = label
    @screen = screen
    @pos = Vector()
    @size = Vector()
    @\get_geometry!
    @children = children
    @style = stylesheet\get_style(@category, @label)
    @style_data = {}
    @\load_style_data!
    @\create_signals!

    for i, child in pairs @children
      child.parent = self


  create_signals: () =>
    @\connect_signal("layout_changed", () ->
      print("layout screen")
      @style_data.layout\apply_layout(self)
    )

  load_style_data: () =>
    @style_data = {
      layout: @style\get("layout")
    }

  get_geometry: () =>
    @pos.x = @screen.geometry.x
    @pos.y = @screen.geometry.y
    @size.x = @screen.geometry.width
    @size.y = @screen.geometry.height

  get_content_size: () =>
    return @size\copy!

  get_size: () =>
    return @size\copy!

return Screen
