Object = require "cord.util.object"

gears = { table: require "gears.table" }
cord = { table: require "cord.table" }

class Style extends Object
  new: (values, parent) =>
    super!
    @__name = "cord.wim.style"
    @values = values or {}
    @parent = parent or nil
  set: (key, value) =>
    cord.table.set_key(@values, key, value)
    @\emit_signal("value_changed", key)
  get: (key, shallow) =>
    return cord.table.get_key(@values, key) or (not shallow) and @parent and @parent\get(key) or nil
  join: (other_style) =>
    gears.table.crush(@values, other_style.values)
      
return Style
