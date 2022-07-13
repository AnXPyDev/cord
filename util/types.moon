cord = { table: require "cord.table" }

match = (obj, name) ->
	T = type(obj)
	if T == name
		return true
	if T == "table"
		if obj.__class
			if obj.__class.__name == name
				return true
			elseif obj.__class.__lineage and cord.table.contains(obj.__class.__lineage, name)
				return true
	return false

get = (obj) ->
	if type(obj) == "table"
		return obj.__class.__name if obj.__class
	return type(obj)

return {
	match: match
	get: get
}
