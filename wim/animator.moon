gears = { timer: require "gears.timer" }

Object = require "cord.util.object"

class Animator extends Object
	new: (tps = 60) =>
		super!
		table.insert(@__name, "cord.wim.animator")
		@queue = {}
		@tps = tps
		@timer = gears.timer({
			timeout: 1 / @tps,
			call_now: false,
			autostart: false,
			single_shot: false,
			callback: () ->
				@\update!
		})

	add: (animation) =>
		table.insert(@queue, animation)
		if #@queue > 0
			@timer\again!

	remove: (animation) =>
		for i, v in ipairs @queue
			if v == animation
				table.remove(@queue, i)
				break
		if #@queue == 0
			@timer\stop!

	set_tps: (tps = @tps) =>
		@tps = tps
		@timer.timeout = 1 / @tps

	update: =>
		i = 1
		while i <= #@queue
			local is_not_error, ret
			do_remove = false
			if @queue[i].done == false
				is_not_error, ret = pcall(() ->  return @queue[i]\update!)
			else
				do_remove = true
			if is_not_error == false
				print("animation error", ret)
				do_remove = true
			if do_remove
				for k, v in pairs @queue[i].callbacks
					pcall(v)
				table.remove(@queue, i)
				i -= 1
			i += 1

		if #@queue == 0
			@timer\stop!

return Animator
