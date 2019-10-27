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
    animations = require("cord.wim.animations")
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
    for_each_node_child = function(self, fn)
      for k, child in pairs(self.children) do
        if child.__name and (child.__name == "cord.wim.node" or child.__name == "cord.wim.text") then
          fn(child)
        end
      end
    end,
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
      self:connect_signal("layout_changed", function()
        return self.style_data.layout:apply_layout(self)
      end)
      self:connect_signal("geometry_changed", function()
        self:emit_signal("layout_changed")
        return self.parent and self.parent:emit_signal("layout_changed")
      end)
      return self:connect_signal("background_color_changed", function(color)
        if self.style_data.background_color == gears.color.transparent then
          for k, child in pairs(self.children) do
            child:emit_signal("background_color_changed", color)
          end
        end
      end)
    end,
    load_style_data = function(self)
      local background_padding = self.style:get("background_padding") or self.style:get("padding")
      local content_padding = self.style:get("content_padding") or self.style:get("padding")
      local content_margin = self.style:get("content_margin") or self.style:get("margin")
      local overlay_padding = self.style:get("content_padding") or self.style:get("padding")
      local size = self.style:get("size") or Vector(100)
      local background_pattern_beginning = self.style:get("background_pattern_beginning") or self.style:get("pattern_beginning")
      local background_pattern_ending = self.style:get("background_pattern_ending") or self.style:get("pattern_ending")
      local overlay_pattern_beginning = self.style:get("overlay_pattern_beginning") or self.style:get("pattern_beginning")
      local overlay_pattern_ending = self.style:get("overlay_pattern_ending") or self.style:get("pattern_ending")
      local background_color = self.style:get("background_color")
      local overlay_color = self.style:get("overlay_color")
      local color = self.style:get("color")
      self.style_data = {
        background_padding = background_padding and background_padding:copy() or Margin(0),
        content_padding = content_padding and content_padding:copy() or Margin(0),
        content_margin = content_margin and content_margin:copy() or Margin(0),
        overlay_padding = overlay_padding and overlay_padding:copy() or Margin(0),
        background_shape = self.style:get("background_shape") or self.style:get("shape") or gears.shape.rectangle,
        overlay_shape = self.style:get("overlay_shape") or self.style:get("shape") or gears.shape.rectangle,
        background_color = type(background_color) == "string" and cord.util.color(background_color) or type(background_color) == "table" and background_color:copy() or gears.color.transparent,
        overlay_color = type(overlay_color) == "string" and cord.util.color(overlay_color) or type(overlay_color) == "table" and overlay_color:copy() or gears.color.transparent,
        color = type(color) == "string" and cord.util.color(color) or color and color:copy() or "#FFFFFF",
        background_pattern_beginning = background_pattern_beginning and background_pattern_beginning:copy() or Vector(0, 0, "percentage"),
        background_pattern_ending = background_pattern_ending and background_pattern_ending:copy() or Vector(1, 0, "percentage"),
        overlay_pattern_beginning = overlay_pattern_beginning and overlay_pattern_beginning:copy() or Vector(0, 0, "percentage"),
        overlay_pattern_ending = overlay_pattern_ending and overlay_pattern_ending:copy()(pppp or Vector(1, 0, "percentage")),
        content_clip_shape = self.style:get("content_clip_shape") or gears.shape.rectangle,
        layout_hide_animation = self.style:get("layout_hide_animation") or cord.wim.animations.position.jump,
        layout_show_animation = self.style:get("layout_show_animation") or cord.wim.animations.position.jump,
        layout_move_animation = self.style:get("layout_move_animation") or cord.wim.animations.position.jump,
        opacity_show_animation = self.style:get("opacity_show_animation") or cord.wim.animations.opacity.jump,
        opacity_hide_animation = self.style:get("opacity_hide_animation") or cord.wim.animations.opacity.jump,
        layout = self.style:get("layout") or cord.wim.layouts.manual(),
        size = size or Vector(100),
        align_horizontal = self.style:get("align_horizontal") or "center",
        align_vertical = self.style:get("align_vertical") or "center"
      }
    end,
    create_containers = function(self)
      self.containers.background_padding = wibox.container.margin()
      self.containers.content_padding = wibox.container.margin()
      self.containers.content_margin = wibox.container.margin()
      self.containers.content_clip = wibox.container.background()
      self.containers.overlay_padding = wibox.container.margin()
      self.containers.background = wibox.container.background(wibox.widget.textbox())
      self.containers.overlay = wibox.container.background(wibox.widget.textbox())
      self.containers.content_padding.widget = self.containers.content_clip
      self.containers.content_clip.widget = self.containers.content_margin
      self.containers.background_padding.widget = self.containers.background
      self.containers.overlay_padding.widget = self.containers.overlay
      self.content_container = self.containers.content_margin
      self.widget = wibox.widget({
        layout = wibox.layout.stack,
        self.containers.background_padding,
        self.containers.content_padding,
        self.containers.overlay_padding
      })
      self.widget.visible = self.visible
    end,
    create_stylizers = function(self)
      self.stylizers.background_padding = function()
        local size = self:get_size()
        self.containers.background_padding.forced_width = size.x
        self.containers.background_padding.forced_height = size.y
        self.style_data.background_padding:apply(self.containers.background_padding)
        return self.containers.background_padding:emit_signal("widget::redraw_needed")
      end
      self.stylizers.content_padding = function()
        local size = self:get_size()
        self.containers.content_padding.forced_width = size.x
        self.containers.content_padding.forced_height = size.y
        self.style_data.content_padding:apply(self.containers.content_padding)
        return self.containers.content_padding:emit_signal("widget::redraw_needed")
      end
      self.stylizers.content_margin = function()
        local size = self:get_inside_size()
        self.containers.content_margin.forced_width = size.x
        self.containers.content_margin.forced_height = size.y
        self.style_data.content_margin:apply(self.containers.content_margin)
        return self.containers.content_margin:emit_signal("widget::redraw_needed")
      end
      self.stylizers.overlay_padding = function()
        local size = self:get_size()
        self.containers.overlay_padding.forced_width = size.x
        self.containers.overlay_padding.forced_height = size.y
        self.style_data.overlay_padding:apply(self.containers.overlay_padding)
        return self.containers.overlay_padding:emit_signal("widget::redraw_needed")
      end
      self.stylizers.background = function()
        local size = self:get_background_size()
        if cord.util.get_object_class(self.style_data.background_color) == "cord.util.pattern" then
          self.containers.background.bg = cord.util.normalize_as_pattern_or_color(self.style_data.background_color, self:get_background_pattern_template())
        else
          self.containers.background.bg = cord.util.normalize_as_pattern_or_color(self.style_data.background_color)
        end
        self.containers.background.fg = cord.util.normalize_as_pattern_or_color(self.style_data.color)
        self.containers.background.forced_width = size.x
        self.containers.background.forced_height = size.y
        self.containers.background.shape = self.style_data.background_shape
        return self.containers.background:emit_signal("widget::redraw_needed")
      end
      self.stylizers.overlay = function()
        local size = self:get_overlay_size()
        if cord.util.get_object_class(self.style_data.overlay_color) == "cord.util.pattern" then
          self.containers.overlay.bg = cord.util.normalize_as_pattern_or_color(self.style_data.overlay_color, self:get_overlay_pattern_template())
        else
          self.containers.overlay.bg = cord.util.normalize_as_pattern_or_color(self.style_data.overlay_color)
        end
        self.containers.overlay.fg = gears.color.transparent
        self.containers.overlay.forced_width = size.x
        self.containers.overlay.forced_height = size.y
        self.containers.overlay.shape = self.style_data.overlay_shape
        return self.containers.overlay:emit_signal("widget::redraw_needed")
      end
      self.stylizers.layout = function()
        local old_layout = self.style_data.layout
        self.style_data.layout = self.style:get("layout") or self.style_data.layout
        if old_layout then
          return self.style_data.layout:inherit(old_layout)
        end
      end
      self.stylizers.content_clip = function()
        local size = self:get_inside_size()
        self.containers.content_clip.forced_width = size.x
        self.containers.content_clip.forced_height = size.y
        self.containers.content_clip.shape_clip = true
        self.containers.content_clip.shape = self.style_data.content_clip_shape
        return self.containers.content_clip:emit_signal("widget::redraw_needed")
      end
      self.stylizers.content = function()
        local size = self:get_content_size()
        self.content.forced_width = size.x
        self.content.forced_width = size.y
      end
    end,
    stylize_containers = function(self)
      for k, fn in pairs(self.stylizers) do
        fn()
      end
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
    search_node = function(self, category, label)
      local results = { }
      if (not category and true or self.category == category) or (not label and true or self.label == label) then
        results = gears.table.join(results, {
          self
        })
      end
      for k, child in pairs(self.children) do
        if child.__name and (child.__name == "cord.wim.node" or child.__name == "cord.wim.text") then
          gears.table.join(results, child:search_node(category, label))
        end
      end
      return results
    end,
    get_size = function(self)
      return cord.util.normalize_vector_in_context(self.style_data.size, self.parent and self.parent:get_content_size() or Vector(100, 100))
    end,
    get_inside_size = function(self)
      local result = self:get_size()
      result.x = result.x - (self.style_data.content_padding.left + self.style_data.content_padding.right)
      result.y = result.y - (self.style_data.content_padding.top + self.style_data.content_padding.bottom)
      return result
    end,
    get_content_size = function(self)
      local result = self:get_inside_size()
      result.x = result.x - (self.style_data.content_margin.left + self.style_data.content_margin.right)
      result.y = result.y - (self.style_data.content_margin.top + self.style_data.content_margin.bottom)
      return result
    end,
    get_pos = function(self)
      local pos = self.style:get("pos")
      local result = cord.util.normalize_vector_in_context(pos, self.parent and self.parent:get_content_size() or Vector(100, 100))
      return result
    end,
    set_pos = function(self, pos)
      if not self.parent then
        return 
      end
      self.parent.content:move_widget(self.widget, pos:to_primitive())
      self.pos.x = pos.x
      self.pos.y = pos.y
    end,
    get_background_size = function(self)
      local result = self:get_size()
      result.x = result.x - (self.style_data.background_padding.left + self.style_data.background_padding.right)
      result.y = result.y - (self.style_data.background_padding.top + self.style_data.background_padding.bottom)
      return result
    end,
    get_background_pattern_template = function(self)
      local size = self:get_background_size()
      local pattern_beginning = cord.util.normalize_vector_in_context(self.style_data.background_pattern_beginning, size)
      local pattern_ending = cord.util.normalize_vector_in_context(self.style_data.background_pattern_ending, size)
      return pattern_beginning, pattern_ending
    end,
    get_overlay_size = function(self)
      local result = self:get_size()
      result.x = result.x - (self.style_data.overlay_padding.left + self.style_data.overlay_padding.right)
      result.y = result.y - (self.style_data.overlay_padding.top + self.style_data.overlay_padding.bottom)
      return result
    end,
    get_overlay_pattern_template = function(self)
      local size = self:get_overlay_size()
      local pattern_beginning = cord.util.normalize_vector_in_context(self.style_data.overlay_pattern_beginning, size)
      local pattern_ending = cord.util.normalize_vector_in_context(self.style_data.overlay_pattern_ending, size)
      return pattern_beginning, pattern_ending
    end,
    set_visible = function(self, visible, force)
      if visible == nil then
        visible = not self.visible
      end
      if force == nil then
        force = false
      end
      local og = self.visible
      self.visible = visible
      if force == true then
        self.widget.visible = self.visible
        self.widget:emit_signal("widget::redraw_needed")
      end
      if self.visible ~= og then
        self:emit_signal("geometry_changed")
      end
      return self:emit_signal("visibility_changed")
    end,
    set_opacity = function(self, opacity)
      if opacity == nil then
        opacity = 1
      end
      self.widget.opacity = opacity
      return self.widget:emit_signal("widget::redraw_needed")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, category, label, stylesheet, children, data)
      if category == nil then
        category = "__empty_node_category__"
      end
      if label == nil then
        label = "__empty_node_label__"
      end
      if children == nil then
        children = { }
      end
      if data == nil then
        data = { }
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
      self.visible = true
      self.pos = cord.math.vector()
      self.data = { }
      cord.table.deep_crush(self, data)
      self:for_each_node_child((function(child)
        child.parent = self
      end))
      self:create_signals()
      self:create_containers()
      self:create_content()
      self:create_stylizers()
      self:connect_signal("request_load_style", function()
        self:load_style_data()
        self:stylize_containers()
        return self:for_each_node_child((function(child)
          return child:emit_signal("request_load_style")
        end))
      end)
      self:emit_signal("request_load_style")
      if self.visible then
        return self:emit_signal("geometry_changed")
      end
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
