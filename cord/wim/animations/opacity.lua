local cord = {
  math = require("cord.math")
}
local Animation = require("cord.wim.animation")
local Vector = require("cord.math.vector")
local animator = require("cord.wim.default_animator")
local Opacity
do
  local _class_0
  local _parent_0 = Animation
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self)
      self.node = node
      if self.node.data.opacity_animation then
        self.node.data.opacity_animation.done = true
      end
      self.node.data.opacity_animation = self
      self.current = start
      self.target = target
      self.speed = node.style:get("opacity_animation_speed") or 1
      node:set_opacity(self.current)
      table.insert(self.callbacks, function()
        return self.node:set_opacity(self.target)
      end)
      return animator:add(self)
    end,
    __base = _base_0,
    __name = "Opacity",
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
  Opacity = _class_0
end
local Opacity_Jump
do
  local _class_0
  local _parent_0 = Opacity
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self, node, start, target, layout_size)
      self.node:set_opacity(self.target)
      self.done = true
    end,
    __base = _base_0,
    __name = "Opacity_Jump",
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
  Opacity_Jump = _class_0
end
local Opacity_Lerp
do
  local _class_0
  local _parent_0 = Opacity
  local _base_0 = {
    tick = function(self)
      self.current = cord.math.lerp(self.current, self.target, self.speed, 0.005)
      self.node:set_opacity(self.current)
      if self.current == self.target then
        self.done = true
        return true
      end
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self, node, start, target, layout_size)
      self.speed = node.style:get("opacity_lerp_animation_speed") or self.speed
    end,
    __base = _base_0,
    __name = "Opacity_Lerp",
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
  Opacity_Lerp = _class_0
end
return {
  jump = Opacity_Jump,
  lerp = Opacity_Lerp,
  approach = Opacity_Approach
}
