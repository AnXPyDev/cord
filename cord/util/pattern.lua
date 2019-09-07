local gears = {
  table = require("gears.table"),
  color = require("gears.color")
}
local cord = {
  log = require("cord.log")
}
local Vector = require("cord.math.vector")
local Pattern
do
  local _class_0
  local _base_0 = {
    create_pattern = function(self, beginning, ending)
      if beginning == nil then
        beginning = self.beginning
      end
      if ending == nil then
        ending = self.ending
      end
      local stops = { }
      for i, stop in ipairs(self.stops) do
        table.insert(stops, {
          stop[2] or ((i - 1) / (#self.stops - 1)),
          type(stop[1]) == "string" and stop[1] or stop[1]:to_rgba_string()
        })
      end
      return gears.color.create_linear_pattern({
        from = {
          beginning.x,
          beginning.y
        },
        to = {
          ending.x,
          ending.y
        },
        stops = stops
      })
    end,
    copy = function(self)
      return Pattern(self.stops, self.beginning, self.ending)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, stops, beginning, ending)
      if beginning == nil then
        beginning = Vector()
      end
      if ending == nil then
        ending = Vector(100, 0)
      end
      self.__name = "cord.util.pattern"
      self.stops = stops
      self.beginning = beginning
      self.ending = ending
    end,
    __base = _base_0,
    __name = "Pattern"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Pattern = _class_0
end
return Pattern
