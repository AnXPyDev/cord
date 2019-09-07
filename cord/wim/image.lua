local wibox = require("wibox")
local cord = {
  wim = {
    animations = require("cord.wim.animations")
  },
  util = require("cord.util")
}
local Vector = require("cord.math.vector")
local Node = require("cord.wim.node")
local Image
do
  local _class_0
  local _parent_0 = Node
  local _base_0 = {
    load_style_data = function(self)
      self.style_data = {
        size = self.style:get("size") or Vector(100),
        color = self.style:get("color") or nil,
        align_horizontal = self.style:get("align_horizontal") or "center",
        align_vertical = self.style:get("align_vertical") or "center",
        layout_hide_animation = self.style:get("layout_hide_animation") or cord.wim.animations.position.jump,
        layout_show_animation = self.style:get("layout_show_animation") or cord.wim.animations.position.jump,
        layout_move_animation = self.style:get("layout_move_animation") or cord.wim.animations.position.jump,
        opacity_show_animation = self.style:get("opacity_show_animation") or cord.wim.animations.opacity.jump,
        opacity_hide_animation = self.style:get("opacity_hide_animation") or cord.wim.animations.opacity.jump
      }
    end,
    create_containers = function(self)
      self.imagebox = wibox.widget.imagebox()
      self.widget = self.imagebox
      self.widget.visible = self.visible
    end,
    create_stylizers = function(self)
      self.stylizers.imagebox = function()
        local size = self:get_size()
        self.imagebox.forced_width = size.x
        self.imagebox.forced_height = size.y
        self.imagebox.image = self.image:get(self.style_data.color)
        self.imagebox.resize = true
        return self.imagebox:emit_signal("widget::redraw_needed")
      end
    end,
    create_content = function(self) end,
    create_signals = function(self)
      self:connect_signal("request_stylize", function(container_name)
        if container_name and self.stylizers[container_name] then
          return self.stylizers[container_name]()
        else
          for k, fn in pairs(self.stylizers) do
            fn()
          end
        end
      end)
      return self:connect_signal("geometry_changed", function()
        return self.parent and self.parent:emit_signal("layout_changed")
      end)
    end,
    set_image = function(self, image)
      if image == nil then
        image = self.image
      end
      self.image = image
      return self:emit_signal("request_stylize", "imagebox")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, category, label, stylesheet, image, data)
      self.image = image
      _class_0.__parent.__init(self, category, label, stylesheet, { }, data)
      self.__name = "cord.wim.text"
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
end
return Image
