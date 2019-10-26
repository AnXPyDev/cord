local wibox = require("wibox")
local cord = {
  wim = {
    animations = require("cord.wim.animations")
  },
  util = require("cord.util"),
  log = require("cord.log")
}
local Vector = require("cord.math.vector")
local Node = require("cord.wim.node")
local Text
do
  local _class_0
  local _parent_0 = Node
  local _base_0 = {
    load_style_data = function(self)
      local color = self.style:get("color")
      local adaptive_color_on_light = self.style:get("adaptive_color_on_light")
      local adaptive_color_on_dark = self.style:get("adaptive_color_on_dark")
      self.style_data = {
        font = self.style:get("font") or "Unknown",
        size = self.style:get("size") or Vector(100),
        color = color and type(color) == "string" and cord.util.color(color) or type(color) == "table" and color:copy() or cord.util.color("#FFFFFF"),
        adaptive_colors = self.style:get("adaptive_colors") or nil,
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
      self.containers.background = wibox.container.background()
      self.containers.constraint = wibox.container.constraint()
      self.textbox = wibox.widget.textbox()
      self.containers.constraint.widget = self.textbox
      self.containers.background.widget = self.containers.constraint
      self.widget = self.containers.background
      self.widget.visible = self.visible
    end,
    create_stylizers = function(self)
      self.stylizers.background = function()
        local size = self:get_size()
        self.containers.background.forced_width = size.x
        self.containers.background.forced_height = size.y
        self.containers.background.fg = cord.util.normalize_as_pattern_or_color(self.style_data.color)
        return self.containers.background:emit_signal("widget::redraw_needed")
      end
      self.stylizers.textbox = function()
        self.textbox.markup = self.text
        self.textbox.font = self.style_data.font
        self.textbox.align = self.style_data.align_horizontal
        self.textbox.valign = self.style_data.align_vertical
        return self.textbox:emit_signal("widget::redraw_needed")
      end
      self.stylizers.constraint = function()
        local size = self:get_size()
        self.containers.constraint.forced_width = size.x
        self.containers.constraint.forced_height = size.y
        self.containers.constraint.width = size.x
        self.containers.constraint.height = size.y
        return self.containers.constraint:emit_signal("widget::redraw_needed")
      end
      self.stylizers.reset_color = function()
        self.containers.background.fg = cord.util.normalize_as_pattern_or_color(self.style_data.color)
        return self.containers.background:emit_signal("widget::redraw_needed")
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
      self:connect_signal("geometry_changed", function()
        return self.parent and self.parent:emit_signal("layout_changed")
      end)
      return self:connect_signal("background_color_changed", function(color)
        if self.style_data.adaptive_colors then
          local lightness = cord.util.get_color_or_pattern_lightness(color)
          for i, range_and_color in self.style_data.adaptive_colors do
            local range = range_and_color[1]
            if lightness >= range[1] and lightness <= range[2] then
              self.style_data.color = range_and_color[2]
              self.stylizers.reset_color()
              return 
            end
          end
        end
      end)
    end,
    set_text = function(self, text)
      if text == nil then
        text = self.text
      end
      self.text = text
      return self:emit_signal("request_stylize", "textbox")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, category, label, stylesheet, text, data)
      if text == nil then
        text = ""
      end
      _class_0.__parent.__init(self, category, label, stylesheet, { }, data)
      self.__name = "cord.wim.text"
      self.text = text
    end,
    __base = _base_0,
    __name = "Text",
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
  Text = _class_0
end
return Text
