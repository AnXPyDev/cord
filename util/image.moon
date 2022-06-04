gears = require "gears"

Object = require "cord.util.object"

cord = {
	util: require "cord.util.base"
}

types = require "cord.util.types"

class Image extends Object
	new: (path) =>
		super!
		table.insert(@__name, "cord.util.image")
		@base_surface = gears.surface(path)
		@color_cache = {}
	get: (color) =>
		local string_color
		if not color
			return @base_surface
		elseif types.match(color, "cord.util.color")
			string_color = color\to_rgba_string!
		elseif type(color) == "string"
			string_color = color
		if not @color_cache[string_color]
			@color_cache[string_color] = gears.color.recolor_image(gears.surface.duplicate_surface(@base_surface), string_color)
		return @color_cache[string_color]

		
