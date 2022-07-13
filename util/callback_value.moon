class Callback_Value
	@__name: "cord.util.callback_value"

	new: (callback) =>
		@callback = callback
	get: =>
		return @callback!

return Callback_Value
