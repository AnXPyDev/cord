clamp = (x, min, max) ->
  min, max = math.min(min, max), math.max(min, max)
  if x < min
    return min
  elseif x > max
    return max
  return x

lerp = (x, target, perc = 0.5, treshold = 0) ->
  ret = x + (target - x) * perc
  if math.abs(target - ret) < treshold
    return target
  return ret

approach = (x, target, ammount) ->
  if x < target
    return clamp(x + ammount, x, target)
  elseif x > target
    return clamp(x - ammount, x, target)
  else
    return x

return {
  clamp: clamp,
  lerp: lerp,
  approach: approach,
  vector: require "cord.math.vector",
  value: require "cord.math.value"
}

