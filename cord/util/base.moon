call = (...) ->
  for i, fn in ipairs {...}
    fn()

in_range_inclusive = (x, a, b) ->
  return math.min(a, b) <= x <= math.max(a, b)

in_range_not_inclusive = (x, a, b) ->
  return math.min(a, b) < x < math.max(a, b)

in_range = (x, a = -math.huge, b = math.huge, inclusive = false) ->
  if inclusive
    return in_range_inclusive(x, a, b)
  return in_range_not_inclusive(x, a, b)
      
return {
  call: call
  in_range: in_range
}
