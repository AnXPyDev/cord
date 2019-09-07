local Vector
do
  local _class_0
  local _base_0 = {
    to_primitive = function(self)
      return {
        x = self.x,
        y = self.y
      }
    end,
    copy = function(self)
      return Vector(self.x, self.y, self.metric)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, metric)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = x
      end
      if metric == nil then
        metric = "undefined"
      end
      self.__name = "cord.math.vector"
      self.x = x
      self.y = y
      self.metric = metric
    end,
    __base = _base_0,
    __name = "Vector"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Vector = _class_0
end
return Vector
