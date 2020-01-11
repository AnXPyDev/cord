Object = require "cord.util.object"
Style = require "cord.wim.style"
Vector = require "cord.math.vector"

types = require "cord.util.types"
normalize = require "cord.util.normalize"
  
id_counter = 0

class Node extends Object
  new: (stylesheet, identification, ...) =>
    super!
    table.insert(@__name, "cord.wim.node")

    @id = id_counter
    id_counter += 1

    @identification = identification or {}

    @style = stylesheet\get_style(@identification)
    @data = Style()

    @parent = nil
    @children = {}

    -- Create data
    @data\set("size", @style\get("size") or Vector(1, 1, "percentage"))
    @data\set("pos", @style\get("pos") or Vector())
    @data\set("visible", @style\get("visible") or true)
    @data\set("parent_index", 0)

    @stylizers = {}

    @\connect_signal("geometry_changed", () ->
      print(@id, "geometry_changed")
      for i, child in ipairs @children
        child\emit_signal("geometry_changed")
    )

    @\connect_signal("parent_changed", () -> @\emit_signal("geometry_changed"))

    -- Gather children
    for i, child in ipairs {...}
      @\add_child(child)

  stylize: (...) =>
    if #{...} == 0
      for k, stylizer in pairs @stylizers
        stylizer(self)
    for i, name in ipairs {...}
      @stylizers[name] and @stylizers[name](self)

  add_child: (child, index = #@children + 1) =>
    if types.match(child, "cord.wim.node")
      table.insert(@children, index, child)
      child\set_parent(self)
      @\emit_signal("added_child", child, index)

  remove_child: (to_remove) =>
    for i, child in ipairs @children
      if child.id == to_remove.id
        table.remove(@children, i)
        @\emit_signal("removed_child", child, i)
  
  set_parent: (parent) =>
    if types.match(parent, "cord.wim.node")
      @parent = parent
      for i, sibling in ipairs parent.children
        if sibling.id = @id
          @data\set("parent_index", i)
      @\emit_signal("parent_changed")

  get_size: () =>
    return normalize.vector(@data\get("size"), @parent and @parent\get_size!)

  set_visible: (visible) =>
    if visible != @data\get("visible")
      @data\set("visible", visible)
      @\emit_signal("visibility_changed")

return Node
