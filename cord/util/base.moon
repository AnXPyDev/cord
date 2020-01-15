call = (...) ->
  for i, fn in ipairs {...}
    fn()

return {
  call: call
}
