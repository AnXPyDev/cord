local log_table
log_table = function(tbl, depth, max_depth)
  if depth == nil then
    depth = 0
  end
  if max_depth == nil then
    max_depth = 5
  end
  if depth > max_depth then
    return 
  end
  local prefix = tostring(string.rep("-", depth)) .. ">"
  for key, value in pairs(tbl) do
    local key_name = type(key) == "string" and "\"" .. tostring(key) .. "\"" or key
    if type(value) == "table" then
      print(tostring(prefix) .. " " .. tostring(key_name) .. ":")
      log_table(value, depth + 1, max_depth)
    else
      print(tostring(prefix) .. " " .. tostring(key_name) .. ": " .. tostring(value))
    end
  end
end
local log
log = function(...)
  local log_pairs = { }
  local last_table = false
  local _list_0 = ({
    ...
  })
  for _index_0 = 1, #_list_0 do
    local val = _list_0[_index_0]
    if type(val) ~= "table" then
      if not last_table and #log_pairs > 0 then
        table.insert(log_pairs[#log_pairs], val)
      else
        last_table = false
        table.insert(log_pairs, {
          val
        })
      end
    else
      last_table = true
      table.insert(log_pairs, {
        val
      })
    end
  end
  for _index_0 = 1, #log_pairs do
    local pair = log_pairs[_index_0]
    if type(pair[1]) == "table" then
      log_table(pair[1])
    else
      print(unpack(pair))
    end
  end
end
local module = {
  table = log_table
}
return setmetatable(module, {
  __call = function(self, ...)
    return log(...)
  end
})
