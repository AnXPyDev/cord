local clamp
clamp = function(x, min, max)
  min, max = math.min(min, max), math.max(min, max)
  if x < min then
    return min
  elseif x > max then
    return max
  end
  return x
end
local lerp
lerp = function(x, target, perc, treshold)
  if treshold == nil then
    treshold = 0
  end
  local ret = x + (target - x) * perc
  if math.abs(target - ret) < treshold then
    return target
  end
  return ret
end
local approach
approach = function(x, target, ammount)
  if x < target then
    return clamp(x + ammount, x, target)
  elseif x > target then
    return clamp(x - ammount, x, target)
  else
    return x
  end
end
return {
  clamp = clamp,
  lerp = lerp,
  approach = approach,
  vector = require("cord.math.vector"),
  value = require("cord.math.value")
}
