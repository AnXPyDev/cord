DataStore = require"cord.util.data_store"

gears = { table: require "gears.table" }
cord = { table: require "cord.table" }

types = require "cord.util.types"

class Style extends DataStore
	@__name: "cord.wim.style"

	inherit: {}
	no_inherit: {}

	new: (values, parents, defaults) =>
		super(values)
		@parents = parents or {}
		@defaults = defaults or {}

	get_no_default: (key, shallow = false) =>
		ret = @values[key]
		if ret == @no_inherit
			return nil
		if shallow == false and ret == nil or ret == @inherit
			for i, v in ipairs @parents
				ret = v\get(key)
				if ret then break
		if types.match(ret, "cord.util.callback_value")
			ret = ret\get!
		return ret

	get_default: (key, shallow = false) =>
		ret = @defaults[key]
		if shallow == false and ret == nil or ret == @inherit
			for i, v in ipairs @parents
				ret = v\get_default(key)
				if ret then break
		if types.match(ret, "cord.util.callback_value")
			ret = ret\get!
		return ret

	get: (key, shallow = false) =>
		return @\get_no_default(key, shallow) or @\get_default(key, shallow)

	join: (other_style) =>
		gears.table.crush(@values, other_style.values)

	add_parent: (style) =>
		table.insert(@parents, style)

	set_defaults: (defaults) =>
		@defaults = defaults




return Style
