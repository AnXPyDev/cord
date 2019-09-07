local connect_signal
connect_signal = function(tbl, name, callback)
  if not tbl[name] then
    tbl[name] = { }
  end
  return table.insert(tbl[name], callback)
end
local emit_signal
emit_signal = function(tbl, name, ...)
  if not tbl[name] then
    return 
  end
  for i, fn in ipairs(tbl[name]) do
    fn(...)
  end
end
local disconnect_signal
disconnect_signal = function(tbl, name, callback)
  if not tbl[name] then
    return 
  end
  for i, fn in ipairs(tbl[name]) do
    if fn == callback then
      table.remove(tbl[name], i)
    end
  end
end
local Object
do
  local _class_0
  local _base_0 = {
    connect_signal = function(self, name, callback, tbl)
      return connect_signal(self._signals, name, callback)
    end,
    weak_connect_signal = function(self, name, callback)
      return connect_signal(self._weak_signals, name, callback)
    end,
    emit_signal = function(self, name, ...)
      emit_signal(self._signals, name, ...)
      return emit_signal(self._weak_signals, name, ...)
    end,
    disconnect_signal = function(self, name, callback)
      return disconnect_signal(self._signals, name, callback)
    end,
    weak_disconnect_signal = function(self, name, callback)
      return disconnect_signal(self._weak_signals, name, callback)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.__name = "cord.util.object"
      self._signals = { }
      self._weak_signals = { }
    end,
    __base = _base_0,
    __name = "Object"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Object = _class_0
end
return Object
