local Value
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, value, offset, metric)
      if value == nil then
        value = 0
      end
      if offset == nil then
        offset = 0
      end
      if metric == nil then
        metric = "undefined"
      end
      self.__name = "cord.math.value"
      self.value = value
      self.offset = offset
      self.metric = metric
    end,
    __base = _base_0,
    __name = "Value"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Value = _class_0
end
return Value
