local gears = require("gears")
local Object = require("cord.util.object")
local cord = {
  util = require("cord.util")
}
local Image
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    get = function(self, color)
      local string_color
      if not color then
        return self.base_surface
      elseif cord.util.is_object_class(color, "cord.util.color") then
        string_color = color:to_rgba_string()
      elseif type(color) == "string" then
        string_color = color
      end
      if not self.color_cache[string_color] then
        self.color_cache[string_color] = gears.color.recolor_image(gears.surface.duplicate_surface(self.base_surface), string_color)
      end
      return self.color_cache[string_color]
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, path)
      _class_0.__parent.__init(self)
      table.insert(self.__name, "cord.util.image")
      self.base_surface = gears.surface(path)
      self.color_cache = { }
    end,
    __base = _base_0,
    __name = "Image",
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
  Image = _class_0
  return _class_0
end
