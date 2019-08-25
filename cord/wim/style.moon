Object = require "cord.object"
cord = { table: require "cord.table" }

class Style extends Object
  new: (values) =>
    super!
    @values = values or {}
  set: (key, value) =>
    cord.table.set_key(@values, key, value)
    @\emit_signal("value_changed", key)
  get: (key) =>
    return cord.table.get_key(@values, key)

return Style
