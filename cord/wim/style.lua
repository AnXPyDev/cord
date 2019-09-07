local Object = require("cord.util.object")
local gears = {
  table = require("gears.table")
}
local cord = {
  table = require("cord.table")
}
local Style
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    set = function(self, key, value)
      cord.table.set_key(self.values, key, value)
      return self:emit_signal("value_changed", key)
    end,
    get = function(self, key, shallow)
      if shallow == nil then
        shallow = false
      end
      local ret = cord.table.get_key(self.values, key)
      if shallow == false and not ret then
        for k, v in pairs(self.parents) do
          ret = v:get(key)
          if ret then
            break
          end
        end
      end
      return ret
    end,
    join = function(self, other_style)
      return gears.table.crush(self.values, other_style.values)
    end,
    add_parent = function(self, style)
      return table.insert(self.parents, style)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, values, parents)
      _class_0.__parent.__init(self)
      self.__name = "cord.wim.style"
      self.values = values or { }
      self.parents = parents or { }
    end,
    __base = _base_0,
    __name = "Style",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Style = _class_0
end
return Style
