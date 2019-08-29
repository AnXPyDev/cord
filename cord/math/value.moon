class Value
  new: (value = 0, offset = 0, metric = "undefined") =>
    @__name = "cord.math.value"
    @value = value
    @offset = offset
    @metric = metric

return Value
