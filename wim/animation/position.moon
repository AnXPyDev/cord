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

class Position extends Animation
	@__name: "cord.wim.animation.position"

	new: (node, start, target, layout_size, ...) =>
		super(node, start, target, "pos", ...)
		@speed = node.style\get("position_animation_speed") or 1
		
Position_Jump = (node, start, target, layout_size, ...) ->
	if target then
		node.data\set("pos", target, true)
		node.data\update("pos")
	cord.util.call(...)

class Position_Lerp extends Position
	@__name: "cord.wim.animation.position.lerp"

	new: (node, start, target, layout_size, ...) =>
		super(node, start, target, layout_size, ...)
		@speed = node.style\get("position_lerp_animation_speed") or @speed
	tick: =>
		@current.x = cord.math.lerp(@current.x, @target.x, @speed, 0.1)
		@current.y = cord.math.lerp(@current.y, @target.y, @speed, 0.1)
		@node.data\set("pos", @current, true)
		@node.data\update("pos")
		if @current.x == @target.x and @current.y == @target.y
			@done = true
			return true
		return false

class Position_Approach extends Position
	@__name: "cord.wim.animation.position.approach"

	new: (node, start, target, layout_size, ...) =>
		super(node, start, target, layout_size, ...)
		@speed = node.style\get("position_approach_animation_speed") or @speed
	tick: =>
		@current.x = cord.math.approach(@current.x, @target.x, @speed)
		@current.y = cord.math.approach(@current.y, @target.y, @speed)
		@node.data\set("pos", @current, true)
		@node.data\update("pos")
		if @current.x == @target.x and @current.y == @target.y
			@done = true
			return true
		return false


class Position_Lerp_From_Edge extends Position_Lerp
	@__name: "cord.wim.animation.position.lerp_from_edge"

	new: (node, start, target, layout_size, ...) =>
		super(node, get_edge_start(target, node\get_size("outside"), layout_size), target, layout_size, ...)
		@speed = node.style\get("position_lerp_from_edge_animation_speed") or @speed

class Position_Approach_From_Edge extends Position_Approach
	@__name: "cord.wim.animation.position.approach_from_edge"

	new: (node, start, target, layout_size, ...) =>
		super(node, get_edge_start(target, node\get_size("outside"), layout_size), target, layout_size, ...)
		@speed = node.style\get("position_approach_from_edge_animation_speed") or @speed

class Position_Lerp_To_Edge extends Position_Lerp
	@__name: "cord.wim.animation.position.lerp_to_edge"

	new: (node, start, target, layout_size, ...) =>
		super(node, start, get_edge_start(target, node\get_size("outside"), layout_size), layout_size, ...)
		@speed = node.style\get("position_lerp_to_edge_animation_speed") or @speed

class Position_Approach_To_Edge extends Position_Approach
	@__name: "cord.wim.animation.position.approach_to_edge"

	new: (node, start, target, layout_size, ...) =>
		super(node, start, get_edge_start(target, node\get_size("outside"), layout_size), layout_size, ...)
		@speed = node.style\get("position_approach_to_edge_animation_speed") or @speed

return {
	jump: Position_Jump,
	lerp: Position_Lerp,
	approach: Position_Approach,
	lerp_from_edge: Position_Lerp_From_Edge,
	lerp_to_edge: Position_Lerp_To_Edge,
	approach_from_edge: Position_Approach_From_Edge,
	approach_to_edge: Position_Approach_To_Edge
}
