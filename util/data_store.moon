Object = require "cord.util.object"
types = require "cord.util.types"

class DataStore extends Object
	@__name: "cord.util.data_store"

	new: (values) =>
		super!
		@values = values or {}

	set: (key, value, silent, ...) =>
		if key == nil
			return
		@values[key] = value
		if not silent then @\update(key, value, ...)
	
	update: (key, value, ...) =>
		@\emit_signal("updated::#{key}", value or @\get(key), ...)

	get: (key) =>
		ret = @values[key]
		if types.match(ret, "cord.util.callback_value")
			ret = ret\get!
		return ret
		
return DataStore
