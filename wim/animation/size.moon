cord = {
	math: require "cord.math"
	util: require "cord.util"
	log: require "cord.log"
}

Animation = require "cord.wim.animation.node_data"
Vector = require "cord.math.vector"

Size = (f = ((x)->x), duration) ->
	return class extends Animation
		@__name: "cord.wim.animation.position"

		new: (node, target, start, layout_size, ...) =>
			super(node, "size", target, start, ...)
			@frame = 0
			@length = @animator\duration(duration)
			@delta = Vector(@target.x - @start.x, @target.y - @start.x)

			@node.data\set("layout_size", @target)

		tick: =>
			@frame += 1
			
			if @frame >= @length
				@node.data\set(@data_index, @target)
				@node.data\set("layout_size", nil, true)
				return true
			
			k = f(@frame / @length)

			@current.x = @start.x + @delta.x * k
			@current.y = @start.y + @delta.y * k

			@node.data\set(@data_index, @current)

			return false


return setmetatable({
	base: Size
}, {
	__call: (...) => Size(...)
})
