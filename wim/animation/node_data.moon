cord = {
	util: require "cord.util"
	log: require "cord.log"
}

animator = require "cord.wim.default_animator"
	
Animation = require "cord.wim.animation.base"

class Node_Data extends Animation
	animator: animator

	new: (node, start, target, data_index, ...) =>
		super(...)
		table.insert(@__name, "cord.wim.animation.node_data")
		@node = node
		@data_index = data_index
		@start = start or @node.data\get(@data_index)
		@target = target
		if not @start or not @target
			return
		last_anim = @node.data\get("active_animation::#{@data_index}")
		if last_anim
			last_anim.done = true
		@current = @start and cord.util.copy(@start) or last_anim and last_anim.current
		@node.data\set("active_animation::#{@data_index}", self)
		--@node.data\set(@data_index, @current)
		@animator\add(self)

return Node_Data
