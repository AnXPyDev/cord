local cord = {
  math = require("cord.math")
}
local Animation = require("cord.wim.animation")
local Vector = require("cord.math.vector")
local animator = require("cord.wim.default_animator")
local get_closest_edge
get_closest_edge = function(pos, size, layout_size)
  local distances = { }
  pos = Vector(pos.x + size.x / 2, pos.y + size.y / 2)
  local dist = { }
  dist["left"] = pos.x
  dist["right"] = layout_size.x - pos.x
  dist["top"] = pos.y
  dist["bottom"] = layout_size.y - pos.y
  local min = math.min(dist.left, dist.right, dist.top, dist.bottom)
  for k, v in pairs(dist) do
    if v == min then
      return k
    end
  end
end
local get_edge_start
get_edge_start = function(pos, size, layout_size)
  local edge = get_closest_edge(pos, size, layout_size)
  local start = pos:copy()
  if edge == "left" then
    start.x = -size.x
  elseif edge == "right" then
    start.x = layout_size.x
  elseif edge == "top" then
    start.y = -size.y
  elseif edge == "bottom" then
    start.y = layout_size.y
  end
  return start
end
local Position
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
      if self.node.data.position_animation then
        self.node.data.position_animation.done = true
      end
      self.node.data.position_animation = self
      self.current = start:copy()
      self.target = target
      self.speed = node.style:get("position_animation_speed") or 1
      node:set_pos(self.current)
      table.insert(self.callbacks, function()
        return self.node:set_pos(self.target)
      end)
      return animator:add(self)
    end,
    __base = _base_0,
    __name = "Position",
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
  Position = _class_0
end
local Position_Jump
do
  local _class_0
  local _parent_0 = Position
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self, node, start, target, layout_size)
      self.node:set_pos(self.target)
      self.done = true
    end,
    __base = _base_0,
    __name = "Position_Jump",
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
  Position_Jump = _class_0
end
local Position_Lerp
do
  local _class_0
  local _parent_0 = Position
  local _base_0 = {
    tick = function(self)
      self.current.x = cord.math.lerp(self.current.x, self.target.x, self.speed, 0.4)
      self.current.y = cord.math.lerp(self.current.y, self.target.y, self.speed, 0.4)
      self.node:set_pos(self.current)
      if self.current.x == self.target.x and self.current.y == self.target.y then
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
      self.speed = node.style:get("position_lerp_animation_speed") or self.speed
    end,
    __base = _base_0,
    __name = "Position_Lerp",
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
  Position_Lerp = _class_0
end
local Position_Approach
do
  local _class_0
  local _parent_0 = Position
  local _base_0 = {
    tick = function(self)
      self.current.x = cord.math.approach(self.current.x, self.target.x, self.speed)
      self.current.y = cord.math.approach(self.current.y, self.target.y, self.speed)
      self.node:set_pos(self.current)
      if self.current.x == self.target.x and self.current.y == self.target.y then
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
      self.speed = node.style:get("position_approach_animation_speed") or self.speed
    end,
    __base = _base_0,
    __name = "Position_Approach",
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
  Position_Approach = _class_0
end
local Position_Lerp_From_Edge
do
  local _class_0
  local _parent_0 = Position_Lerp
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self, node, get_edge_start(target, node:get_size(), layout_size), target, layout_size)
      self.speed = node.style:get("position_lerp_from_edge_animation_speed") or self.speed
    end,
    __base = _base_0,
    __name = "Position_Lerp_From_Edge",
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
  Position_Lerp_From_Edge = _class_0
end
local Position_Approach_From_Edge
do
  local _class_0
  local _parent_0 = Position_Approach
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self, node, get_edge_start(target, node:get_size(), layout_size), target, layout_size)
      self.speed = node.style:get("position_approach_from_edge_animation_speed") or self.speed
    end,
    __base = _base_0,
    __name = "Position_Approach_From_Edge",
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
  Position_Approach_From_Edge = _class_0
end
local Position_Lerp_To_Edge
do
  local _class_0
  local _parent_0 = Position_Lerp
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self, node, start, get_edge_start(target, node:get_size(), layout_size), layout_size)
      self.speed = node.style:get("position_lerp_to_edge_animation_speed") or self.speed
    end,
    __base = _base_0,
    __name = "Position_Lerp_To_Edge",
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
  Position_Lerp_To_Edge = _class_0
end
local Position_Approach_To_Edge
do
  local _class_0
  local _parent_0 = Position_Approach
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, node, start, target, layout_size)
      _class_0.__parent.__init(self, node, start, get_edge_start(target, node:get_size(), layout_size), layout_size)
      self.speed = node.style:get("position_approach_to_edge_animation_speed") or self.speed
    end,
    __base = _base_0,
    __name = "Position_Approach_To_Edge",
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
  Position_Approach_To_Edge = _class_0
end
return {
  jump = Position_Jump,
  lerp = Position_Lerp,
  approach = Position_Approach,
  lerp_from_edge = Position_Lerp_From_Edge,
  lerp_to_edge = Position_Lerp_To_Edge,
  approach_from_edge = Position_Approach_From_Edge,
  approach_to_edge = Position_Approach_To_Edge
}
