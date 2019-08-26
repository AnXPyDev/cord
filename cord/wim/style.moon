Object = require "cord.util.object"

cord = { table: require "cord.table" }

class Style extends Object
  new: (values, parent) =>
    super!
    @values = values or {}
    @parent = parent or nil
  set: (key, value) =>
    cord.table.set_key(@values, key, value)
    @\emit_signal("value_changed", key)
  get: (key) =>
    return cord.table.get_key(@values, key) or @parent and @parent\get(key)
  join: (other_style) =>
    cord.table.deep_crush(@values, other_style.values)
      
return Style
