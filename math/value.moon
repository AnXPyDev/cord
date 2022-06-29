class Value
	new: (value = 0, offset = 0, metric, base) =>
		@__name = "cord.math.value"
		@value = value
		@offset = offset
		@metric = metric
		@base = base

return Value
