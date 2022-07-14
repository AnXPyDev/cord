Animation = require "cord.wim.animation.node_data"
Margin = require "cord.util.margin"

cord = {
	util: require "cord.util"
}

Base = (f = ((x)->x), duration) ->
	return class extends Animation
		@__name: "cord.wim.animation.margin"

		new: (node, data_index, target, start, ...) =>
			super(node, data_index, target, start, ...)
			@frame = 0
			@length = @animator\duration(duration)
			@delta = Margin(
				@target.left - @start.left,
				@target.right - @start.right,
				@target.top - @start.top,
				@target.bottom - @start.bottom
			)

		tick: =>
			@frame += 1

			if @frame >= @length
				@node.data\set(@data_index, @target)
				return true

			k = f(@frame / @length)

			@current.left = @start.left + @delta.left * k
			@current.right = @start.right + @delta.right * k
			@current.top = @start.top + @delta.top * k
			@current.bottom = @start.bottom + @delta.bottom * k

			@node.data\set(@data_index, @current)
			
			return false

return setmetatable({
	base: Base
}, {
	__call: (...) => Base(...)
})
