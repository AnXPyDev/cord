cord = {
	math: require "cord.math"
	util: require "cord.util"
	log: require "cord.log"
}

Animation = require "cord.wim.animation.node_data"
Vector = require "cord.math.vector"

animator = require "cord.wim.default_animator"

get_closest_edge = (pos, size, layout_size) ->
	distances = {}
	pos = Vector(pos.x + size.x / 2, pos.y + size.y / 2)

	-- top
	dist = {}
	dist["left"] = pos.x
	dist["right"] = layout_size.x - pos.x
	dist["top"] = pos.y
	dist["bottom"] = layout_size.y - pos.y

	min = math.min(dist.left, dist.right, dist.top, dist.bottom)
	for i, k in ipairs {"left", "right", "top", "bottom"}
		if dist[k] == min
			return k

get_edge_start = (pos, size, layout_size, edge) ->
	edge = edge or get_closest_edge(pos, size, layout_size)
	start = pos\copy!
	if edge == "left"
		start.x = -size.x
	elseif edge == "right"
		start.x = layout_size.x
	elseif edge == "top"
		start.y = -size.y
	elseif edge == "bottom"
		start.y = layout_size.y
	return start

Position = (f = ((x)->x), duration) ->
	return class extends Animation
		@__name: "cord.wim.animation.position"

		new: (node, target, start, layout_size, ...) =>
			super(node, "pos", target, start, ...)
			if not @start or not @target
				return
		
			@frame = 0
			@length = @animator\duration(duration)
			@delta = Vector(@target.x - @start.x, @target.y - @start.y)

		tick: =>
			@frame += 1

			
			if @frame >= @length
				@node.data\set(@data_index, @target)
				return true
			
			k = f(@frame / @length)

			@current.x = @start.x + @delta.x * k
			@current.y = @start.y + @delta.y * k

			@node.data\set("pos", @current)
			
			return false


Position_To_Edge = (f, d, edge, ...) ->
	return class extends Position(f, d, ...)
		@__name: "cord.wim.animation.position_to_edge"

		new: (node, target, start, layout_size, ...) =>
			super(node, get_edge_start(start or node.data\get("pos"), node\get_size("outside"), layout_size, edge), start, nil, ...)

Position_From_Edge = (f, d, edge, ...) ->
	return class extends Position(f, d, ...)
		@__name: "cord.wim.animation.position_from_edge"

		new: (node, target, start, layout_size, ...) =>
			super(node, target, get_edge_start(start or node.data\get("pos"), node\get_size("outside"), layout_size, edge), nil, ...)

return setmetatable({
	base: Position
	to_edge: Position_To_Edge
	from_edge: Position_From_Edge
}, {
	__call: (...) => Position(...)
})
