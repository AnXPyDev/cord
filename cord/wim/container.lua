local gears = require("gears")
local wibox = require("wibox")
local Node = require("cord.wim.node")
local types = require("cord.util.types")
local normalize = require("cord.util.normalize")
local cord = {
  table = require("cord.table")
}
local Margin = require("cord.util.margin")
local Vector = require("cord.math.vector")
local layer_names = {
  "padding",
  "background",
  "margin"
}
local stylizers = {
  geometry = function(container)
    if container.layers.padding then
      local outside_size = container:get_size("outside")
      container.layers.padding.forced_width = outside_size.x
      container.layers.padding.forced_height = outside_size.y
      local padding = container.data:get("padding")
      if padding then
        padding = normalize.margin(padding, outside_size)
        conatiner.layers.padding.left = padding.left
        conatiner.layers.padding.right = padding.right
        conatiner.layers.padding.top = padding.top
        conatiner.layers.padding.bottom = padding.bottom
      end
    end
    if container.layers.background or container.layers.margin then
      local inside_size = container:get_size("inside")
      if container.layers.background then
        container.layers.background.forced_width = inside_size.x
        container.layers.background.forced_height = inside_size.y
      end
      if container.layers.margin then
        container.layers.margin.forced_width = inside_size.x
        container.layers.margin.forced_height = inside_size.y
        local margin = container.data:get("margin")
        if margin then
          margin = normalize.margin(margin, inside_size)
          conatiner.layers.margin.left = margin.left
          conatiner.layers.margin.right = margin.right
          conatiner.layers.margin.top = margin.top
          conatiner.layers.margin.bottom = margin.bottom
        end
      end
    end
    local content_size = container:get_size("content")
    container.content.force_width = content_size.x
    container.content.force_height = content_size.y
  end,
  background = function(container)
    local background = container.data:get("background")
    if container.layers.background and background then
      container.layers.background.bg = normalize.color_or_pattern(background, container.data:get("pattern_template"), container:get_size("inside"))
    end
  end,
  foreground = function(container)
    local foreground = container.data:get("foreground")
    if container.layers.background and foreground then
      container.layers.background.fg = normalize.color_or_pattern(foreground)
    end
  end,
  shape = function(container)
    local shape = container.data:get("shape")
    if container.layers.background and shape then
      container.layers.background.shape = shape
    end
  end
}
local Container
do
  local _class_0
  local _parent_0 = Node
  local _base_0 = {
    create_layers = function(self)
      if self.data:get("padding") and not self.layers.padding then
        self.layers.padding = wibox.container.margin()
      end
      if (self.data:get("shape") or self.data:get("background") or self.data:get("foreground")) and not self.layers.background then
        self.layers.background = wibox.container.background()
      end
      if self.data:get("margin") and not self.layers.margin then
        self.layers.margin = wibox.container.margin()
      end
    end,
    reorder_layers = function(self)
      local last = self.widget
      for i, layer_name in ipairs(layer_names) do
        if self.layers[layer_name] then
          last.widget = self.layers[layer_name]
          last = self.layers[layer_name]
        end
      end
      last.widget = self.content
    end,
    add_to_content = function(self, child, index)
      return self.content:insert(index, child.widget)
    end,
    remove_from_content = function(self, child, index)
      return self.content:remove(index)
    end,
    get_size = function(self, scope)
      if scope == nil then
        scope = "content"
      end
      local result = normalize.vector(self.data:get("size"), self.parent and self.parent:get_size())
      if scope == "content" or scope == "inside" then
        local padding = self.data:get("padding")
        if padding then
          padding = normalize.margin(padding, result)
          result.x = result.x - (padding.left + padding.right)
          result.y = result.y - (padding.top + padding.bottom)
        end
        if scope == "content" then
          local margin = self.data:get("margin")
          if margin then
            margin = normalize.margin(margin, result)
            result.x = result.x - (margin.left + margin.right)
            result.y = result.y - (margin.top + margin.bottom)
          end
        end
      end
      return result
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, stylesheet, identification, ...)
      _class_0.__parent.__init(self, stylesheet, identification, ...)
      table.insert(self.__name, "cord.wim.container")
      self.data:set("shape", self.style:get("shape") or nil)
      self.data:set("background", self.style:get("background") or nil)
      self.data:set("foreground", self.style:get("foreground") or nil)
      self.data:set("margin", self.style:get("margin") or nil)
      self.data:set("padding", self.style:get("padding") or nil)
      self.data:set("pattern_template", self.style:get("pattern_template") or {
        Vector(0, 0, "percentage"),
        Vector(1, 0, "percentage")
      })
      self.layers = {
        padding = nil,
        background = nil,
        margin = nil
      }
      self.widget = wibox.widget()
      self.content = wibox.layout.stack()
      self:create_layers()
      self:reorder_layers()
      cord.table.crush(self.stylizers, stylizers)
      self:connect_signal("added_child", function(child, index)
        return self:add_to_content(child, index)
      end)
      self:connect_signal("removed_child", function(child, index)
        return self:remove_from_content(child, index)
      end)
      self:connect_signal("geometry_changed", function()
        return self:emit_signal("request_stylize", "geometry")
      end)
      for i, child in ipairs(self.children) do
        self:add_to_content(child, i)
      end
    end,
    __base = _base_0,
    __name = "Container",
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
  Container = _class_0
end
return Container
