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

    for i, child in ipairs @children
      @\add_to_content(child, i)
      
  add_to_content: (child, index) =>
    child.widget.point = {x:0,y:0}
    @content\insert(index, child.widget)
    @\update_in_content(child, index)
    child.data\connect_signal("key_changed::pos", () -> @\update_in_content(child, index), "#{@id}_layout_signal")

  update_in_content: (child, index) =>
    @content\move(index, child.data\get("pos")\to_primitive!)

  remove_from_content: (child, index) =>
    @content\remove(index)
    child.data\disconnect_signal("key_changed::pos", nil, "#{@id}_layout_signal")

return Layout
