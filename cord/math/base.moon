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

wrap = (x, min, max) ->
  if x > max
    return (x - max) + min
  elseif x < min
    return max - (min - x)
  return x
      
distance = (v1, v2) ->
  return math.sqrt(math.pow(v1.x - v2.x, 2) + math.pow(v1.y - v2.y, 2))

flip = (x, a, b) ->
  return b - (x - a)

return {
  clamp: clamp
  lerp: lerp
  approach: approach
  distance: distance
  wrap: wrap
  flip: flip
}
