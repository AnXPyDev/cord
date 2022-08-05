Vector = require "cord.math.vector"
Layout = require "cord.wim.layout.base"
cord = {
	math: require "cord.math.base"
	table: require "cord.table"
}

	
corners = {
	top_left: {false, false}
	top_right: {true, false}
	bottom_left: {false, true}
	bottom_right: {true, true}
}

directions = {
	vertical: {"y", "x"}
	horizontal: {"x", "y"}
}
 
class Fit extends Layout
	@__name: "cord.wim.layout.fit"

	defaults: cord.table.crush({}, Layout.defaults, {
		corner: "top_left"
		direction: "horizontal"
	})
	new: (config, ...) =>
		super(config, ...)
		
		@data\set("corner", config.corner or @style\get("corner"))
		@data\set("direction", config.direction or @style\get("direction"))

		@\emit_signal("constructor_finished")

	apply_layout: =>
		results = {}
		size = @\get_size!
		current = Vector()
		max = 0
		m = directions[@data\get("direction")]
		for i, child in ipairs @children
			child_size = child\get_size("layout")
			if not child.data\get("visible")
				table.insert(results, {child, nil, false})
				continue
			if current[m[1]] + child_size[m[1]] > size[m[1]]
				if not (max + child_size[m[2]] > size[m[2]] or child_size[m[1]] > size[m[1]])
					current[m[2]] = max
					current[m[1]] = 0
				else
					table.insert(results, {child, nil, false})
					continue
			elseif current[m[2]] + child_size[m[2]] > size[m[2]]
				table.insert(results, {child, nil, false})
				continue
			table.insert(results, {child, current\copy!, true})
			current[m[1]] += child_size[m[1]]
			if current[m[2]] + child_size[m[2]] > max
				max = current[m[2]] + child_size[m[2]]

		corner_translation = corners[@data\get("corner")]
		for i, result in ipairs results
			if result[2]
				child_size = result[1]\get_size("layout")
				if corner_translation[1] then result[2].x = cord.math.flip(result[2].x, 0, size.x) - child_size.x
				if corner_translation[2] then result[2].y = cord.math.flip(result[2].y, 0, size.y) - child_size.y
			@\apply_for_child(table.unpack(result))
