local wibox = awesome and require("wibox" or { })
local gears = {
  color = require("gears.color")
}
local cord = {
  log = require("cord.log")
}
local Node = require("cord.wim.node")
local Nodebox
do
  local _class_0
  local _parent_0 = Node
  local _base_0 = {
    add_signals = function(self)
      self:connect_signal("geometry_changed", function()
        return self:restylize("wibox_pos", "wibox_size")
      end)
      return self:connect_signal("visibility_changed", function()
        self.wibox.visible = self.current_style:get("visible")
        return self.wibox:emit_signal("widget::redraw_needed")
      end)
    end,
    add_style_data = function(self) end,
    add_stylizers = function(self)
      self.stylizers.wibox_shape = function()
        self.wibox.shape = self.style_data.background_shape
        return self.wibox:emit_signal("widget::redraw_needed")
      end
      self.stylizers.wibox_size = function()
        local size = self:get_size()
        self.wibox.width = size.x
        self.wibox.height = size.y
      end
      self.stylizers.wibox_pos = function()
        self.wibox.x = self.pos.x + (self.parent and self.parent.pos.x or 0)
        self.wibox.y = self.pos.y + (self.parent and self.parent.pos.y or 0)
        return self.wibox:emit_signal("widget::redraw_needed")
      end
    end,
    create_wibox = function(self)
      self.wibox = wibox({
        visible = false,
        widget = self.widget,
        bg = gears.color.transparent
      })
    end,
    set_pos = function(self, pos)
      self.pos.x = pos.x
      self.pos.y = pos.y
      return self:restylize("wibox_pos")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.__name = "cord.wim.nodebox"
      self.wibox = nil
      self.visible = false
      self:create_wibox()
      self:add_style_data()
      self:add_stylizers()
      self:add_signals()
      return self:restylize()
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
end
return Nodebox
