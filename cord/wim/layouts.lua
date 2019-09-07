local Layout = require("cord.wim.layout")
local Vector = require("cord.math.vector")
local animate_layout_change
animate_layout_change = function(layout, node, pos, layout_size)
  local last_time = layout:node_visible_last_time(node)
  local layout_anim, opacity_anim
  if last_time then
    if not node.visible then
      layout_anim = node.style_data.layout_hide_animation(node, node.pos:copy(), node.pos:copy(), layout_size)
      opacity_anim = node.style_data.opacity_hide_animation(node, 1, 0)
      return table.insert(opacity_anim.callbacks, (function()
        return node:set_visible(node.visible, true)
      end))
    else
      layout_anim = node.style_data.layout_move_animation(node, node.pos:copy(), pos, layout_size)
    end
  else
    if node.visible then
      node:set_visible(node.visible, true)
      layout_anim = node.style_data.layout_show_animation(node, node.pos:copy(), pos, layout_size)
      opacity_anim = node.style_data.opacity_show_animation(node, 0, 1)
    end
  end
end
local Fit_Horizontal
do
  local _class_0
  local _parent_0 = Layout
  local _base_0 = {
    apply_layout = function(self, node)
      local content_size = node:get_content_size()
      local max = Vector()
      local current = Vector()
      for k, child in pairs(node.children) do
        if child.__name and (child.__name == "cord.wim.node" or child.__name == "cord.wim.text") then
          if child.visible == true then
            local child_size = child:get_size()
            if (current.x + child_size.x) > content_size.x then
              current.x = 0
              current.y = max.y
            end
            animate_layout_change(self, child, current:copy(), content_size)
            if max.y < (current.y + child_size.y) then
              max.y = current.y + child_size.y
            end
            current.x = current.x + child_size.x
          else
            animate_layout_change(self, child, Vector(), content_size)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.__name = "cord.wim.layouts.fit.horizontal"
    end,
    __base = _base_0,
    __name = "Fit_Horizontal",
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
  Fit_Horizontal = _class_0
end
local Fit_Vertical
do
  local _class_0
  local _parent_0 = Layout
  local _base_0 = {
    apply_layout = function(self, node)
      local content_size = node:get_content_size()
      local max = Vector()
      local current = Vector()
      for k, child in pairs(node.children) do
        local _continue_0 = false
        repeat
          if child.__name and (child.__name == "cord.wim.node" or child.__name == "cord.wim.text") then
            if child.visible == false then
              _continue_0 = true
              break
            end
            local child_size = child:get_size()
            if (current.y + child_size.y) > content_size.y then
              current.x = max.x
              current.y = 0
            end
            if max.x < (current.x + child_size.x) then
              max.x = current.x + child_size.x
            end
            animate_layout_change(self, child, current:copy(), content_size)
            current.y = current.y + child_size.y
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.__name = "cord.wim.layouts.fit.vertical"
    end,
    __base = _base_0,
    __name = "Fit_Vertical",
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
  Fit_Vertical = _class_0
end
return {
  manual = Layout,
  fit = {
    horizontal = Fit_Horizontal,
    vertical = Fit_Vertical
  }
}
