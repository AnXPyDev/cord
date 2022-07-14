Animation = require "cord.wim.animation.node_data"
Color = require "cord.util.color"

cord = {
	util: require "cord.util",
	table: require "cord.table"
}

types = require "cord.util.types"

Base = (f = ((x)->x), duration) ->
	return class extends Animation
		@__name: "cord.wim.animation.color"

		new: (node, data_index, target, start, ...) =>
			super(node, data_index, target, start, ...)
			if not @target or not @start
				return
			
			@frame = 0
			@length = @animator\duration(duration)

			if types.match(@start, "string") then @start = Color(@start)
			if types.match(@target, "string") then @target = Color(@target)
			if types.match(@current, "string") then @current = Color(@current)

			@delta = Color(@target.R - @start.R, @target.G - @start.G, @target.B - @start.B, @target.A - @start.A, "rgba")

		tick: =>
			@frame += 1

			if @frame >= @length
				@node.data\set(@data_index, @target)
				return true

			k = f(@frame / @length)

			@current.R = @start.R + @delta.R * k
			@current.G = @start.G + @delta.G * k
			@current.B = @start.B + @delta.B * k
			@current.A = @start.A + @delta.A * k

			@node.data\set(@data_index, @current)

			return false

return setmetatable({
	base: Base
}, {
	__call: (...) => Base(...)
})
