local wibox = awesome and require("wibox" or { })
local gears = {
  table = require("gears.table"),
  color = require("gears.color"),
  shape = require("gears.shape")
}
local Object = require("cord.util.object")
local Vector = require("cord.math.vector")
local Margin = require("cord.util.margin")
local cord = {
  table = require("cord.table"),
  util = require("cord.util"),
  wim = {
    layouts = require("cord.wim.layouts"),
    animations = require("cord.wim.animations"),
    style = require("cord.wim.style")
  },
  log = require("cord.log"),
  math = require("cord.math")
}
local unique_id_counter = 0
local Node
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    set_parent = function(self, parent)
      self.parent = parent
      return self:restylize()
    end,
    for_each_node_child = function(self, fn)
      for k, child in pairs(self.children) do
        local cn = cord.util.get_object_class(child)
        if cn == "cord.wim.node" then
          fn(child)
        end
      end
    end,
    apply_layout_change = function(self, layout, pos, layout_size)
      local last_time = layout:node_visible_last_time(self)
      local layout_anim, opacity_anim
      if last_time then
        if not self.current_style:get("visible") then
          layout_anim = (self.style:get("layout_hide_animation") or cord.wim.animations.position.jump)(self, self.current_style:get("pos"):copy(), pos, layout_size)
          opacity_anim = (self.style:get("opacity_hide_animation") or cord.wim.animations.opacity.jump)(self, self.current_style:get("opacity"), 0)
          return table.insert(opacity_anim.callbacks, function()
            return self:set_visible(self.current_style:get("visible"), true)
          end)
        else
          layout_anim = (self.style:get("layout_move_animation") or cord.wim.animations.position.jump)(self, self.current_style:get("pos"):copy(), pos, layout_size)
        end
      else
        if self.current_style:get("visible") then
          self:set_visible(self.current_style:get("visible"), true)
          layout_anim = (self.style:get("layout_show_animation") or cord.wim.animations.position.jump)(self, self.current_style:get("pos"):copy(), pos, layout_size)
          opacity_anim = (self.style:get("opacity_show_animation") or cord.wim.animations.opacity.jump)(self, self.current_style:get("opacity"), 0)
        end
      end
    end,
    create_signals = function(self)
      self.current_style:connect_signal("value_changed", (function(key) end))
      self:connect_signal("geometry_changed", function()
        return self.parent and self.parent:emit_signal("layout_changed")
      end)
      return self:connect_signal("layout_changed", function()
        return self.style:get("layout"):apply_layout(self)
      end)
    end,
    restylize = function(self, stylizer_name)
      if stylizer_name then
        return self.stylizers[stylizer_name]()
      end
      for k, stylizer in pairs(self.stylizers) do
        stylizer()
      end
    end,
    create_stylizers = function(self)
      self.stylizers.size = function()
        local size = self:get_size()
        self.containers.padding.forced_width = size.x
        self.containers.padding.forced_height = size.y
        local inside_size = self:get_inside_size()
        self.containers.background.forced_width = inside_size.x
        self.containers.background.forced_height = inside_size.y
        self.containers.overlay.forced_width = inside_size.x
        self.containers.overlay.forced_height = inside_size.y
        self.containers.margin.forced_width = inside_size.x
        self.containers.margin.forced_height = inside_size.y
      end
      self.stylizers.padding = function()
        local padding = self.current_style:get("padding")
        return padding:apply(self.containers.padding)
      end
      self.stylizers.margin = function()
        local margin = self.current_style:get("margin")
        return margin:apply(self.containers.margin)
      end
      self.stylizers.background = function()
        local background = self.current_style:get("background")
        self.containers.background.bg = cord.util.normalize_as_pattern_or_color(background, nil, nil, self:get_inside_size())
      end
      self.stylizers.overlay = function()
        local overlay = self.current_style:get("overlay")
        self.containers.overlay.bg = cord.util.normalize_as_pattern_or_color(overlay, nil, nil, self:get_inside_size())
      end
      self.stylizers.background_shape = function()
        self.containers.background.shape = self.current_style:get("background_shape")
      end
      self.stylizers.overlay_shape = function()
        self.containers.background.shape = self.current_style:get("background_shape")
      end
    end,
    create_current_style = function(self)
      local padding = self.style:get("padding") or Margin(0)
      local margin = self.style:get("margin") or Margin(0)
      local size = self.style:get("size") or Vector(100)
      local background = self.style:get("background") or cord.util.color("#000000")
      local overlay = self.style:get("overlay") or cord.util.color("#00000000")
      if cord.util.get_object_class(background) == "string" then
        background = cord.util.color(background)
      end
      if cord.util.get_object_class(overlay) == "string" then
        overlay = cord.util.color(overlay)
      end
      local background_shape = self.style:get("background_shape") or self.style:get("shape") or gears.shape.rectangle
      local overlay_shape = self.style:get("overlay_shape") or self.style:get("shape") or gears.shape.rectangle
      self.current_style = cord.wim.style({
        padding = padding:copy(),
        margin = margin:copy(),
        background_shape = background_shape,
        overlay_shape = background_shape,
        background = background:copy(),
        overlay = overlay:copy(),
        size = size:copy(),
        pos = Vector(),
        visible = false,
        opacity = 1
      })
    end,
    create_containers = function(self)
      self.containers.padding = wibox.container.margin()
      self.containers.margin = wibox.container.margin()
      self.containers.background = wibox.container.background(wibox.widget.textbox())
      self.containers.overlay = wibox.container.background(wibox.widget.textbox())
      self.content_container = self.containers.margin
      self.containers.padding.widget = wibox.widget({
        layout = wibox.layout.stack,
        self.containers.background,
        self.containers.margin,
        self.containers.overlay
      })
      self.widget = self.containers.padding
      self.widget.visible = false
    end,
    create_content = function(self)
      self.content = wibox.layout({
        layout = wibox.layout.manual
      })
      for i, child in ipairs(self.children) do
        if child.__name and (child.__name == "cord.wim.node" or child.__name == "cord.wim.text") then
          self.content:add_at(child.widget, {
            x = 0,
            y = 0
          })
        else
          self.content:add_at(child, {
            x = 0,
            y = 0
          })
        end
      end
      self.content_container.widget = self.content
    end,
    get_size = function(self)
      return cord.util.normalize_vector_in_context(self.current_style:get("size"), self.parent and self.parent:get_content_size() or Vector(100, 100))
    end,
    get_inside_size = function(self)
      local result = self:get_size()
      local padding = self.current_style:get("padding")
      result.x = result.x - (padding.left + padding.right)
      result.y = result.y - (padding.top + padding.bottom)
      return result
    end,
    get_content_size = function(self)
      local result = self:get_inside_size()
      local margin = self.current_style:get("margin")
      result.x = result.x - (margin.left + margin.right)
      result.y = result.y - (margin.top + margin.bottom)
      return result
    end,
    set_pos = function(self, pos)
      self.current_style:get("pos").x = pos.x
      self.current_style:get("pos").y = pos.y
      if not self.parent then
        return 
      end
      return self.parent.content:move_widget(self.widget, self.current_style.values.pos:to_primitive())
    end,
    set_visible = function(self, visible, force)
      if visible == nil then
        visible = not self.current_style:get("visible")
      end
      if force == nil then
        force = false
      end
      local current = self.current_style:get("visible")
      if force then
        self.widget.visible = visible
      end
      self.current_style:set("visible", visible)
      if not (current == visible) then
        return self:emit_signal("geometry_changed")
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, category, label, stylesheet, children)
      if category == nil then
        category = "__empty_node_category__"
      end
      if label == nil then
        label = "__empty_node_label__"
      end
      if children == nil then
        children = { }
      end
      _class_0.__parent.__init(self)
      self.__name = "cord.wim.node"
      unique_id_counter = unique_id_counter + 1
      self.unique_id = unique_id_counter
      self.category = category
      self.label = label
      self.identification = tostring(self.category) .. " " .. tostring(self.label) .. " " .. tostring(self.unique_id)
      self.style = stylesheet:get_style(self.category, self.label)
      self.style_data = { }
      self.children = children
      self.parent = nil
      self.content = nil
      self.containers = { }
      self.stylizers = { }
      self.content_container = nil
      self.widget = nil
      self:create_current_style()
      self:create_signals()
      self:create_containers()
      self:create_content()
      self:create_stylizers()
      self:restylize()
      return self:for_each_node_child((function(child)
        return child:set_parent(self)
      end))
    end,
    __base = _base_0,
    __name = "Node",
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
  Node = _class_0
end
return Node
