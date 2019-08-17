log_table = (tbl, depth = 0, max_depth = 5) ->
  if depth > max_depth
    return
  prefix = "#{string.rep("-", depth)}>"
  for key, value in pairs tbl
    key_name = type(key) == "string" and "\"#{key}\"" or key
    if type(value) == "table"
      print "#{prefix} #{key_name}:"
      log_table(value, depth + 1, max_depth)
    else
      print "#{prefix} #{key_name}: #{value}"

log = (...) ->
  for index, value in pairs {...}
    if type(value) == "table"
      log_table(value)
    else
      print "#{value}"

return log
