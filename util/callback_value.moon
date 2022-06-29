class Callback_Value
	new: (callback) =>
		@__name = "cord.util.callback_value"
		@callback = callback
	get: =>
		return @callback!

return Callback_Value
