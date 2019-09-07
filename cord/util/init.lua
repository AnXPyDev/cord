local gears = {
  color = require("gears.color")
}
local cord = {
  math = require("cord.math")
}
local normalize_as_pattern_or_color
normalize_as_pattern_or_color = function(x, ...)
  if x == nil then
    x = nil
  end
  if type(x) == "string" then
    return x
  elseif type(x) == "table" then
    if x.__name and x.__name == "cord.util.pattern" then
      return x:create_pattern(...)
    elseif x.__name and x.__name == "cord.util.color" then
      return x:to_rgba_string()
    end
  end
  return gears.color.transparent
end
local normalize_vector_in_context
normalize_vector_in_context = function(vec, context)
  if vec == nil then
    vec = cord.math.vector()
  end
  if context == nil then
    context = cord.math.vector()
  end
  local result = cord.math.vector(0, 0, "undefined")
  if type(vec.x) == "table" then
    if vec.x.__name and vec.x.__name == "cord.math.value" then
      if vec.x.metric == "percentage" then
        result.x = vec.x.value * context.x + vec.x.offset
      else
        result.x = vec.x.value + vec.x.offset
      end
    end
  else
    if vec.metric == "percentage" then
      result.x = vec.x * context.x
    else
      result.x = vec.x
    end
  end
  if type(vec.y) == "table" then
    if vec.y.__name and vec.y.__name == "cord.math.value" then
      if vec.y.metric == "percentage" then
        result.y = vec.y.value * context.y + vec.y.offset
      else
        result.y = vec.y.value + vec.y.offset
      end
    end
  else
    if vec.metric == "percentage" then
      result.y = vec.y * context.y
    else
      result.y = vec.y
    end
  end
  return result
end
local get_object_class
get_object_class = function(obj)
  if type(obj) == "table" then
    return obj.__name or "table"
  else
    return type(obj)
  end
end
return {
  margin = require("cord.util.margin"),
  color = require("cord.util.color"),
  pattern = require("cord.util.pattern"),
  object = require("cord.util.object"),
  shape = require("cord.util.shape"),
  normalize_as_pattern_or_color = normalize_as_pattern_or_color,
  normalize_vector_in_context = normalize_vector_in_context,
  set_node_pos = set_node_pos,
  get_object_class = get_object_class
}
