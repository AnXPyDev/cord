cord = {
	util: require "cord.util"
	log: require "cord.log"
}

animator = require "cord.wim.default_animator"
	
Animation = require "cord.wim.animation.base"

class Node_Data extends Animation
	@__name: "cord.wim.animation.node_data"

	animator: animator

	new: (node, data_index, target, start, ...) =>
		super(...)
		@node = node
		@data_index = data_index
		@start = start or @node.data\get(@data_index)
		@target = target
		if not @start or not @target
			return
		last_anim = @node.data\get("active_animation::#{@data_index}")
		if last_anim
			last_anim.done = true
		@current = cord.util.copy(@start)
		@node.data\set("active_animation::#{@data_index}", self)
		@animator\add(self)

return Node_Data
