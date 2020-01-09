Node = require "cord.wim.node"

class Layout extends Node
  new: (stylesheet, identification, ...) =>
    super(stylesheet, identification, ...)
    table.insert(@__name, "cord.wim.layout")

    @node_visibility_cache = {}

    @content = wibox.layout.manual!
    @widget = @content

    @\connect_signal("added_child", (child, index) -> @\add_to_content(child,index))
    @\connect_signal("removed_child", (child, index) -> @\remove_from_content(child,index))

    for i, child in ipairs @children
      @\add_to_content(child, i)
        
  add_to_content: (child, index) =>
    @content\insert(index, child.widget)

  update_in_content: (child, index) =>
    @content\move(index, child.data\get("pos")\to_primitive!)

  remove_from_content: (child, index) =>
    @content\remove(index)
