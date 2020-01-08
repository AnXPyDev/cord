connect_signal = (tbl, name, callback) ->
  if not tbl[name] then tbl[name] = {}
  table.insert(tbl[name], callback)

emit_signal = (tbl, name, ...) ->
  if not tbl[name] then return
  for i, fn in ipairs tbl[name]
    fn(...)

disconnect_signal = (tbl, name, callback) ->
  if not tbl[name] then return
  for i, fn in ipairs tbl[name]
    if fn == callback
      table.remove(tbl[name], i)
    
class Object
  new: =>
    @__name = {"cord.util.object"}
    @_signals = {}
    @_weak_signals = {}

  connect_signal: (name, callback, tbl) =>
    connect_signal(@_signals, name, callback)

  weak_connect_signal: (name, callback) =>
    connect_signal(@_weak_signals, name, callback)

  emit_signal: (name, ...) =>
    emit_signal(@_signals, name, ...)
    emit_signal(@_weak_signals, name, ...)

  disconnect_signal: (name, callback) =>
    disconnect_signal(@_signals, name, callback)

  weak_disconnect_signal: (name, callback) =>
    disconnect_signal(@_weak_signals, name, callback)

return Object
