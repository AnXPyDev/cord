class Object
  new: =>
    @__name = {"cord.util.object"}
    @_signals = {}
    @_signal_callback_ids = {}

  connect_signal: (name, callback, callback_id) =>
    if not @_signals[name] then @_signals[name] = {}
    table.insert(@_signals[name], callback)
    if callback_id
      if not @_signal_callback_ids[name] then @_signal_callback_ids[name] = {}
      if not @_signal_callback_ids[name][callback_id] then @_signal_callback_ids[name][callback_id] = {}
      table.insert(@_signal_callback_ids[name][callback_id], callback)

  emit_signal: (name, ...) =>
    if not @_signals[name] then return
    for i, fn in ipairs @_signals[name]
      fn(...)

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

return Object
