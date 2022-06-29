gears = {
	table: require "gears.table",
	color: require "gears.color"
}

cord = {
	log: require "cord.log"
	table: require "cord.table"
	util: require "cord.util.base"
}

Color = require "cord.util.color"
	
Vector = require "cord.math.vector"
	
class Pattern
	new: (stops, beginning = Vector(0, 0, "ratio"), ending = Vector(1, 0, "ratio")) =>
		@__name = "cord.util.pattern"
		@stops = cord.table.map(stops, (stop) ->
			return {type(stop[1]) == "table" and stop[1] or type(stop[1] == "string") and Color(stop[1]), stop[2]}
		)
		@beginning = beginning
		@ending = ending
	create_pattern: (beginning = @beginning, ending = @ending, context = Vector(100)) =>
		beginning = cord.util.normalize_vector_in_context(beginning, context)
		ending = cord.util.normalize_vector_in_context(ending, context)
		stops = {}
		for i, stop in ipairs @stops
			table.insert(stops, {stop[2] or ((i - 1) / (#@stops - 1)), stop[1]\to_rgba_string!})
		return gears.color.create_linear_pattern(
			{
				from: {beginning.x, beginning.y},
				to: {ending.x, ending.y},
				stops: stops
			}
		)

	get_average_lightness: () =>
		total = 0
		for i, stop in ipairs @stops
			total += stop[1].L
		return total / #@stops
			
	copy: =>
		return Pattern(@stops, @beginning, @ending)


return Pattern
