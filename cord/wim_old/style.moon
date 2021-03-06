Object = require "cord.util.object"

gears = { table: require "gears.table" }
cord = { table: require "cord.table" }

class Style extends Object
  new: (values, parents) =>
    super!
    table.insert(@__name, "cord.wim.style")
    @values = values or {}
    @parents = parents or {}
  set: (key, value) =>
    cord.table.set_key(@values, key, value)
    @\emit_signal("value_changed", key)
  get: (key, shallow = false) =>
    ret = cord.table.get_key(@values, key)
    if shallow == false and (ret == nil)
      for k, v in pairs @parents
        ret = v\get(key)
        if ret then break
    return ret
  join: (other_style) =>
    gears.table.crush(@values, other_style.values)
  add_parent: (style) =>
    table.insert(@parents, style)
  
      
return Style
