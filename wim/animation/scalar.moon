cord = {
	math: require "cord.math"
}

Animation = require "cord.wim.animation.node_data"

Base = (f = ((x)->x), duration) ->
	return class extends Animation
		@__name: "cord.wim.animation.scalar"

		new: (node, data_index, target, start, ...) =>
			super(node, data_index, target, start)
			@frame = 0
			@length = @animator\duration(duration)
			@delta = @target - @start

		tick: =>
			@frame += 1
			
			if @frame >= @length
				@node.data\set(@data_index, @target)
				return true
			
			k = f(@frame / @length)

			@current = @start + @delta * k

			@node.data\set(@data_index, @current)

			return false

return setmetatable({
	base: Base
}, {
	__call: (...) => Base(...)
})
