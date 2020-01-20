local wibox = require("wibox")
local gears = require("gears")
local normalize = require("cord.util.normalize")
local cord = {
  table = require("cord.table")
}
local Node = require("cord.wim.node")
local stylizers = {
  geometry = function(nodebox)
    local size = nodebox:get_size("outside")
    nodebox.wibox.width = size.x
    nodebox.wibox.height = size.y
  end,
  shape = function(nodebox)
    nodebox.wibox.shape = nodebox.data:get("shape") or gears.shape.rectangle
  end,
  visibility = function(nodebox)
    nodebox.wibox.visible = nodebox.data:get("visible") and not nodebox.data:get("hidden")
  end
}
local Nodebox
do
  local _class_0
  local _parent_0 = Node
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, stylesheet, identification, ...)
      _class_0.__parent.__init(self, stylesheet, identification, ...)
      table.insert(self.__name, "cord.wim.nodebox")
      self.data:set("shape", self.style:get("shape"))
      self.wibox = wibox()
      self.wibox.widget = self.children[1] and self.children[1].widget
      self.data:connect_signal("key_changed::pos", function(pos)
        local tpos = pos:copy()
        if self.parent then
          local ppos = self.parent.data:get("pos")
          tpos.x = tpos.x + ppos.x
          tpos.y = tpos.y + ppos.y
        end
        self.wibox.x = tpos.x
        self.wibox.y = tpos.y
      end)
      self.data:connect_signal("key_changed::shape", function()
        return self:stylize("shape")
      end)
      self.data:connect_signal("key_changed::visible", function()
        return self:stylize("visibility")
      end)
      self.data:connect_signal("key_changed::hidden", function()
        return self:stylize("visibility")
      end)
      cord.table.crush(self.stylizers, stylizers)
      return self:stylize()
    end,
    __base = _base_0,
    __name = "Nodebox",
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
  Nodebox = _class_0
  return _class_0
end
