cord = {
	math: require "cord.math"
}

Animation = require "cord.wim.animation.node_data"

class Base extends Animation
	@__name: "cord.wim.animation.scalar"

	new: (node, start, target, data_index, ...) =>
		super(node, start, target, data_index, ...)
		@speed = @node.style\get("scalar_animation_speed") or 1

class Lerp extends Base
	@__name: "cord.wim.animation.scalar.lerp"

	new: (node, start, target, data_index, ...) =>
		super(node, start, target, data_index, ...)
		@precision_treshold = 0.005
		@speed = @node.style\get("scalar_lerp_animation_speed") or @speed
	tick: =>
		@current = cord.math.lerp(@current, @target, @speed, @precision_treshold)
		@node.data\set(@data_index, @current)
		if @current == @target
			@done = true
		return @done

class Approach extends Base
	@__name: "cord.wim.animation.scalar.approach"

	new: (node, start, target, data_index, ...) =>
		super(node, start, target, data_index, ...)
		@speed = @node.style\get("scalar_approach_animation_speed") or @speed
	tick: =>
		@current = cord.math.approach(@current, @target, @speed)
		@node.data\set(@data_index, @current)
		if @current == @target
			@done = true
		return @done

return {
	base: Base
	lerp: Lerp
	approach: Approach
}
