Object = require "cord.util.object"

class Animation extends Object
	@__name: "cord.wim.animation"

	new: (...) =>
		super!
		@done = false
		@callbacks = {...}
	update: =>
		@done = @\tick!
		if @done
			@\emit_signal("animation_finished")
		return @done
	tick: =>
		return true

return Animation
