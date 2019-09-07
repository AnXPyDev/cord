local Vector = require("cord.math.vector")
local Object = require("cord.util.object")
local cord = {
  util = require("cord.util")
}
cord.log = require("cord.log")
local Layout
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    node_visible_last_time = function(self, node)
      local ret = false
      if self.node_visibility[node.unique_id] == true then
        ret = self.node_visibility[node.unique_id]
      end
      self.node_visibility[node.unique_id] = node.visible
      return ret
    end,
    apply_layout = function(self, node) end,
    inherit = function(self, layout)
      if not layout then
        return 
      end
      self.node_visibility = layout.node_visibility
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.node_visibility = { }
    end,
    __base = _base_0,
    __name = "Layout",
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
  Layout = _class_0
end
return Layout
