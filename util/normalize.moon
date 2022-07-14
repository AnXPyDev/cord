c_transparent = (require "gears.color").transparent

types = require "cord.util.types"

Vector = require "cord.math.vector"
Value = require "cord.math.value"
Margin = require "cord.util.margin"

value = (val = 0, context = 1, unit) ->
	if types.match(val, "cord.math.value")
		if val.unit == "ratio"
			return val.value * value(context) + val.offset
		else
			return val.value + val.offset
	elseif unit == "ratio"
		return val * value(context)
	else
		return val
	
vector = (vec = Vector(), context = Vector()) ->
	result = Vector()
	if types.match(vec.x, "cord.math.value") and vec.x.unit == "ratio"
		result.y = value(vec.y, context.y, vec.unit)
		result.x = value(vec.x, result.y, vec.unit)
	elseif types.match(vec.y, "cord.math.value") and vec.y.unit == "ratio"
		result.x = value(vec.x, context.x, vec.unit)
		result.y = value(vec.y, result.x, vec.unit)
	else
		result.x = value(vec.x, context.x, vec.unit)
		result.y = value(vec.y, context.y, vec.unit)
	return result

margin = (mar = Margin(), context = Vector()) ->
	return Margin(
		value(mar.left, context.x, mar.unit),
		value(mar.right, context.x, mar.unit),
		value(mar.top, context.y, mar.unit),
		value(mar.bottom, context.y, mar.unit)
	)

color_or_pattern = (cop, ...) ->
	if types.match(cop, "string")
		return cop
	elseif types.match(cop, "cord.util.color")
		return cop\to_rgba_string!
	elseif types.match(cop, "cord.util.pattern")
		return cop\create_pattern(...)
	return c_transparent
		
return {
	value: value
	vector: vector
	margin: margin
	color_or_pattern: color_or_pattern
	sum: sum
}
