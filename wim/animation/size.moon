cord = {
	math: require "cord.math"
	util: require "cord.util"
	log: require "cord.log"
}

Animation = require "cord.wim.animation.node_data"
Vector = require "cord.math.vector"

class Size extends Animation
	@__name: "cord.wim.animation.size"

	new: (node, start, target, ...) =>
		super(node, start, target, "size", ...)
	
		if @current.metric != @target.metric
			@done = true
			print("Size animation attempt on different metrics")

		@speed = node.style\get("size_animation_speed") or 1
		node.data\set("layout_size", target)
	disconnect: =>
		@node.data\set("layout_size", nil, true)
		-- @node\emit_signal("geometry_changed")

		
Size_Jump = (node, start, target, ...) ->
	if target then
		node.data\set("size", target, true)
		node.data\update("size")
	cord.util.call(...)

class Size_Lerp extends Size
	@__name: "cord.wim.animation.size.lerp"

	new: (node, start, target, ...) =>
		super(node, start, target, ...)
		@delta = @current.metric == "ratio" and 0.001 or 0.1
		@speed = node.style\get("size_lerp_animation_speed") or @speed
	tick: =>
		@current.x = cord.math.lerp(@current.x, @target.x, @speed, @delta)
		@current.y = cord.math.lerp(@current.y, @target.y, @speed, @delta)
		@node.data\set("size", @current, true)
		@node.data\update("size", self)
		if @current.x == @target.x and @current.y == @target.y
			@\disconnect!
			@done = true
			return true
		return false

class Size_Approach extends Size
	@__name: "cord.wim.animation.size.approach"

	new: (node, start, target, ...) =>
		super(node, start, target, ...)
		@speed = node.style\get("position_approach_animation_speed") or @speed
	tick: =>
		@current.x = cord.math.approach(@current.x, @target.x, @speed, @delta)
		@current.y = cord.math.approach(@current.y, @target.y, @speed, @delta)
		@node.data\set("size", @current, true)
		@node.data\update("size", self)
		if @current.x == @target.x and @current.y == @target.y
			@\disconnect!
			@done = true
			return true
		return false

return {
	jump: Size_Jump,
	lerp: Size_Lerp,
	approach: Size_Approach,
}
