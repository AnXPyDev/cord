log = require "cord.log"
cord = {
	table: require "cord.table"
}

class Object

	@__name = "cord.util.object"
	@__lineage = {}

	@__inherited: (child) =>
		child.__lineage = cord.table.deep_copy(@__lineage)
		table.insert(child.__lineage, @__name)
		--log(child.__lineage, child.__name)

	exit_code: {}

	new: =>
		@_signals = {}
		@_signal_callback_ids = {}
		@_muted = {}

	connect_signal: (name, callback, callback_id) =>
		if not @_signals[name] then @_signals[name] = {}
		table.insert(@_signals[name], callback)
		if callback_id
			if not @_signal_callback_ids[name] then @_signal_callback_ids[name] = {}
			if not @_signal_callback_ids[name][callback_id] then @_signal_callback_ids[name][callback_id] = {}
			table.insert(@_signal_callback_ids[name][callback_id], callback)

	mute_signal: (name) =>
		@_muted[name] = true

	unmute_signal: (name) =>
		@_muted[name] = nil

	emit_signal: (name, ...) =>
		if @_muted[name] or not @_signals[name] then return
		to_remove = {}
		for i, fn in ipairs @_signals[name]
			if fn(...) == @exit_code
				table.insert(to_remove, fn)
		for i, fn in ipairs to_remove
			@\disconnect_signal(name, fn)

	disconnect_signal: (name, callback, callback_id) =>
		if not @_signals[name] then return
		if not callback and callback_id
			if @_signal_callback_ids[name] and @_signal_callback_ids[name][callback_id]
				for i, callback in ipairs @_signal_callback_ids[name][callback_id]
					for e, fn in ipairs @_signals[name]
						if fn == callback
							table.remove(@_signals[name], e)
				@_signal_callback_ids[name][callback_id] = {}

		if callback
			for i, fn in ipairs @_signals[name]
				if fn == callback
					table.remove(@_signals[name], i)
					break
	
return Object
