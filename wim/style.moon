Object = require "cord.util.object"

gears = { table: require "gears.table" }
cord = { table: require "cord.table" }

types = require "cord.util.types"

class Style extends Object
	new: (values, parents) =>
		super!
		table.insert(@__name, "cord.wim.style")
		@values = values or {}
		@parents = parents or {}
		@defaults = {}

	set: (key, value, silent, ...) =>
		if key == nil
			return
		cord.table.set_key(@values, key, value)
		if not silent then @\update(key, ...)

	update: (key, ...) =>
		value = @\get(key)
		@\emit_signal("value_changed", key, value, ...)
		@\emit_signal("key_changed::#{key}", value, ...)

	get: (key, shallow = false) =>
		ret = @values[key]
		default = false
		local parent_default
		if shallow == false and ret == nil
			for k, v in pairs @parents
				lret, default = v\get(key)
				if lret 
					if not default then
						ret = lret
						break
					elseif not parent_default
						parent_default = true
						ret = parent_default
		if (not ret or default) and @defaults[key]
			ret = @defaults[key]!
			default = true
		if types.match(ret, "cord.util.callback_value")
			ret = ret\get!
		return ret, default

	join: (other_style) =>
		gears.table.crush(@values, other_style.values)

	add_parent: (style) =>
		table.insert(@parents, style)

	add_defaults: (...) =>
		gears.table.crush(@defaults, ...)


return Style
