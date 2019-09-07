local deep_crush
deep_crush = function(tbl1, tbl2)
  if tbl1 == nil then
    tbl1 = { }
  end
  if tbl2 == nil then
    tbl2 = { }
  end
  for k, v in pairs(tbl2) do
    if type(v) == "table" then
      if not tbl1[k] then
        tbl1[k] = { }
      end
      deep_crush(tbl1[k], v)
    else
      tbl1[k] = v
    end
  end
  return tbl1
end
local deep_copy
deep_copy = function(tbl)
  if tbl == nil then
    tbl = { }
  end
  local result = { }
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      result[k] = deep_copy(v)
    else
      result[k] = v
    end
  end
  return result
end
local deep_copy_crush
deep_copy_crush = function(tbl1, tbl2)
  if tbl1 == nil then
    tbl1 = { }
  end
  if tbl2 == nil then
    tbl2 = { }
  end
  local result = deep_copy(tbl1)
  deep_crush(result, tbl2)
  return result
end
local set_key
set_key = function(tbl, keys, value)
  if type(keys) ~= "table" then
    tbl[keys] = value
  else
    local lastAccess = tbl
    for i, key in ipairs(keys) do
      if i == #tbl then
        lastAccess[key] = value
      else
        lastAccess[key] = lastAccess[key] or { }
        lastAccess = lastAccess[key]
      end
    end
  end
end
local get_key
get_key = function(tbl, keys)
  if type(keys) ~= "table" then
    return tbl[keys] or nil
  else
    local lastAccess = tbl
    for i, key in ipairs(keys) do
      if i == #tbl then
        return lastAccess[key] or nil
      else
        if not lastAccess[key] then
          return nil
        end
        lastAccess = lastAccess[key]
      end
    end
  end
end
local sum
sum = function(tbl)
  local result = 0
  for k, v in pairs(tbl) do
    result = result + v
  end
  return result
end
local concat
concat = function(tbl)
  local result = ""
  for k, v in pairs(tbl) do
    result = result + tostring(v)
  end
  return result
end
local equal
equal = function(tbl1, tbl2)
  for k, v in pairs(tbl1) do
    if not tbl2[k] then
      return false
    end
    if type(v) == type(tbl2[k]) then
      if type(v) == "table" and not equal(v, tbl2[k]) or not v == tbl2[k] or v ~= tbl2[k] then
        return false
      end
    end
  end
  return true
end
return {
  deep_crush = deep_crush,
  deep_copy = deep_copy,
  deep_copy_crush = deep_copy_crush,
  set_key = set_key,
  get_key = get_key,
  sum = sum,
  concat = concat,
  equal = equal
}
