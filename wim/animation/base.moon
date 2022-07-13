Object = require "cord.util.object"

class Animation extends Object
	@__name: "cord.wim.animation"

	new: (...) =>
		super!
		@done = false
		@tick_function = ( -> )
		@callbacks = {...}
	update: =>
		@done = @\tick!
		@done = @tick_function! or @done
		return @done
	tick: =>
		return false

return Animation
