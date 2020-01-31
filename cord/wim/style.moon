Object = require "cord.util.object"

gears = { table: require "gears.table" }
cord = { table: require "cord.table" }

types = require "cord.util.types"

class Style extends Object
  new: (values, parents) =>
    super!
    table.insert(@__name, "cord.wim.style")
    @values = values or {}
    @parents = parents or {}

  set: (key, value, silent) =>
    if value != nil and ((@values[key] != nil and @values[key] != value) or @values[key] == nil) and @values[key] != value then
      cord.table.set_key(@values, key, value)
      if not silent then @\update(key)

  update: (key) =>
    @\emit_signal("value_changed", key, @\get(key))
    @\emit_signal("key_changed::#{key}", @\get(key))

  get: (key, shallow = false) =>
    ret = cord.table.get_key(@values, key)
    if shallow == false and (ret == nil)
      for k, v in pairs @parents
        ret = v\get(key)
        if ret then break
    if types.match(ret, "cord.util.callback_value")
      return ret\get!
    return ret

  join: (other_style) =>
    gears.table.crush(@values, other_style.values)

  add_parent: (style) =>
    table.insert(@parents, style)
  
      
return Style
