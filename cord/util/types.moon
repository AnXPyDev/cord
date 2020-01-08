match = (obj, ...) ->
  for i, type_name in ipairs {...}
    if type(obj) == "table"
      if type(obj.__name) == "table"
        if cord.table.contains(obj.__name, type_name)
          return true
      else
        if obj.__name == type_name
          return true
    else
      if type(obj) == type_name
        return true

get = (obj) ->
  if type(obj) == "table"
    if type(obj.__name) == "table"
      return obj.__name[#obj.__name]
    else
      return obj.__name or "table"
  else
    return type(obj)

return {
  match: match
  get: get
}
