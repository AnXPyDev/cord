Animation = require "cord.wim.animation.node_data"
Color = require "cord.util.color"

cord = {
	util: require "cord.util",
	table: require "cord.table"
}

types = require "cord.util.types"

animator = require "cord.wim.default_animator"

class Base extends Animation
	@__name: "cord.wim.animation.color"

	new: (node, start, target, color_data_index = "background", ...) =>
		super(node, start, target, color_data_index, ...)
		@speed = @node.style\get("color_animation_speed") or 0.5
		if types.match(@start, "string") then @start = Color(@start)
		if types.match(@target, "string") then @target = Color(@target)
		if types.match(@current, "string") then @current = Color(@current)

class Lerp extends Base
	@__name: "cord.wim.animation.color.lerp"

	new: (node, start, target, color_data_index) =>
		super(node, start, target, color_data_index)
		@speed = @node.style\get("color_lerp_animation_speed") or @speed
	tick: =>
		@current\lerp(@target, @speed)
		@node.data\set(@data_index, @current)
		print("nigger")
		if @current\equals(@target)
			@done = true
		return @done

class Approach extends Base
	@__name: "cord.wim.animation.color.approach"

	new: (node, start, target, color_data_index) =>
		super(node, start, target, color_data_index)
		@speed = @node.style\get("color_approach_animation_speed") or @speed
	tick: =>
		print(@current\to_rgba_string!)
		@current\approach(@target, @speed)
		@node.data\set(@data_index, @current)
		if @current\equals(@target)
			@done = true
		return @done

Jump = (node, start, target, color_data_index, ...) ->
	node and node.data\set(color_data_index, target)
	cord.util.call(...)

return {
	base: Base
	approach: Approach
	lerp: Lerp
	jump: Jump
}
