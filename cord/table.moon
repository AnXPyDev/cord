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
  

return {
  deep_crush: deep_crush,
  deep_copy: deep_copy,
  deep_copy_crush: deep_copy_crush
}
