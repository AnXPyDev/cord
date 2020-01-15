log_table = (tbl, max_depth = 5, depth = 0) ->
  if depth > max_depth
    return
  prefix = "#{string.rep("-", depth)}>"
  for key, value in pairs tbl
    key_name = type(key) == "string" and "\"#{key}\"" or key
    if type(value) == "table"
      if depth + 1 <= max_depth
        print "#{prefix} #{key_name}:"
        log_table(value, max_depth, depth + 1)
      else
        print "#{prefix} #{key_name}: #{value}"
    
    else
      print "#{prefix} #{key_name}: #{value}"

log = (...) ->
  log_pairs = {}
  last_table = false
  for val in *({...})
    if type(val) != "table"
      if not last_table and #log_pairs > 0
        table.insert(log_pairs[#log_pairs], val)
      else
        last_table = false
        table.insert(log_pairs, {val})
    else
      last_table = true
      table.insert(log_pairs, {val})
  for pair in *log_pairs
    if type(pair[1]) == "table"
      log_table(pair[1])
    else
      print(unpack(pair))

module = {
  table: log_table
}
  
return setmetatable(module, { __call: (...) => log(...) })
