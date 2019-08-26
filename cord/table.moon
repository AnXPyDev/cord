deep_crush = (tbl1 = {}, tbl2 = {}) ->
  for k, v in pairs tbl2
    if type(v) == "table" then
      if not tbl1[k] then tbl1[k] = {}
      deep_crush(tbl1[k], v)
    else
      tbl1[k] = v
  return tbl1

deep_copy = (tbl = {}) ->
  result = {}
  for k, v in pairs tbl
    if type(v) == "table"
      result[k] = deep_copy(v)
    else
      result[k] = v
  return result

deep_copy_crush = (tbl1 = {}, tbl2 = {}) ->
  result = deep_copy(tbl1)
  deep_crush(result, tbl2)
  return result

set_key = (tbl, keys, value) ->
  if type(key) != "table"
    tbl[key] = value
  else
    lastAccess = tbl
    for i, key in ipairs keys
      if i == #tbl
        lastAccess[key] = value
      else
        lastAccess[key] = lastAccess[key] or {}
        lastAccess = lastAccess[key]

get_key = (tbl, key) ->
  if type(key) != "table"
    return tbl[key] or nil
  else
    lastAccess = tbl
    for i, key in ipairs keys
      if i == #tbl
        return lastAccess[key] or nil
      else
        if not lastAccess[key] then return nil
        lastAccess = lastAccess[key]

sum = (tbl) ->
  result = 0
  for v in pairs tbl
    result += v
  return result

concat = (tbl) ->
  result = ""
  for v in pairs tbl
    result += tostring(v)
  return result

equal = (tbl1, tbl2) ->
  for k, v in pairs tbl1
    if not tbl2[k] then return false
    if type(v) == type(tbl2[k])
      if type(v) == "table" and not equal(v, tbl2[k]) or not v == tbl2[k] or v != tbl2[k] then return false
  return true

return {
  deep_crush: deep_crush,
  deep_copy: deep_copy,
  deep_copy_crush: deep_copy_crush,
  set_key: set_key,
  get_key: get_key,
  sum: sum,
  concat: concat,
  equal: equal
}
