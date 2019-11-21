crush = (tbl1 = {}, tbl2 = {}) ->
  for k, v in pairs tbl2
    tbl1[k] = v
  return tbl1

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
  if type(keys) != "table"
    tbl[keys] = value
  else
    lastAccess = tbl
    for i, key in ipairs keys
      if i == #tbl
        lastAccess[key] = value
      else
        lastAccess[key] = lastAccess[key] or {}
        lastAccess = lastAccess[key]

get_key = (tbl, keys) ->
  if type(keys) != "table"
    if tbl[keys] != nil
      return tbl[keys]
    else
      return nil
  else
    lastAccess = tbl
    for i, key in ipairs keys
      if i == #keys
        if lastAccess[key] != nil
          return lastAccess[key]
        else
          return nil
      else
        if lastAccess[key] == nil then return nil
        lastAccess = lastAccess[key]

sum = (tbl) ->
  result = 0
  for k, v in pairs tbl
    result += v
  return result

concat = (tbl) ->
  result = ""
  for k, v in pairs tbl
    result += tostring(v)
  return result

equal = (tbl1, tbl2) ->
  for k, v in pairs tbl1
    if not tbl2[k] then return false
    if type(v) == type(tbl2[k])
      if type(v) == "table" and not equal(v, tbl2[k]) or not v == tbl2[k] or v != tbl2[k] then return false
  return true

contains = (tbl1, elm) ->
  for i, v in ipairs tbl1
    if v == elm
      return true
  return false
    
map = (tbl, fn) ->
  result = {}
  for k, v in pairs tbl
    result[k] = fn(v)
  return result

imap = (tbl, fn) ->
  result = {}
  for i, v in ipairs tbl
    result[i] = fn(v)
  return result

return {
  crush: crush
  deep_crush: deep_crush
  deep_copy: deep_copy
  deep_copy_crush: deep_copy_crush
  set_key: set_key
  get_key: get_key
  sum: sum
  concat: concat
  equal: equal
  map: map
  imap: imap
  contains: contains
}
