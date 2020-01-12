wibox = require "wibox"

Node = require "cord.wim.node"

class Layout extends Node
  new: (stylesheet, identification, ...) =>
    super(stylesheet, identification, ...)
    table.insert(@__name, "cord.wim.layout")

    @node_visibility_cache = {}

    @content = wibox.layout({
      layout: wibox.layout.manual
    })
    @widget = @content

    @\connect_signal("added_child", (child, index) -> @\add_to_content(child,index))
    @\connect_signal("removed_child", (child, index) -> @\remove_from_content(child,index))
    @\connect_signal("geometry_changed", () -> @\emit_signal("layout_changed"))
    @\connect_signal("layout_changed", () -> @\apply_layout!)

    for i, child in ipairs @children
      @\add_to_content(child, i)
      
  add_to_content: (child, index) =>
    child.widget.point = {x:0,y:0}
    @content\insert(index, child.widget)
    @\update_in_content(child, index)
    @node_visibility_cache[child.id] = child.data\get("visible")

  update_in_content: (child, index) =>
    @content\move(index, child.data\get("pos")\to_primitive!)

  remove_from_content: (child, index) =>
    @content\remove(index)

  apply_layout: () =>

  apply_for_child: (child, index, target_pos) =>

return Layout
