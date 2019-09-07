local Object = require("cord.util.object")
local Style = require("cord.wim.style")
local StyleSheet
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    add_style = function(self, category, label, style, parents)
      if parents == nil then
        parents = { }
      end
      if category and category ~= "__empty_node_category__" then
        self.by_category[category] = self.by_category[category] or style
        self.by_category[category]:join(style)
      end
      if label and label ~= "__empty_node_label__" then
        self.by_label[label] = self.by_label[label] or style
        self.by_label[label]:join(style)
      end
      style = self:get_style(category, label)
      for k, v in pairs(parents) do
        style:add_parent(self:get_style(v[1], v[2]))
      end
      return style
    end,
    get_style = function(self, category, label)
      if label and label ~= "__empty_node_label__" and self.by_label[label] then
        return self.by_label[label]
      elseif category and category ~= "__empty_node_category__" and self.by_category[category] then
        return self.by_category[category]
      end
      return Style()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.__name = "cord.wim.stylsheet"
      self.by_category = { }
      self.by_label = { }
    end,
    __base = _base_0,
    __name = "StyleSheet",
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
  StyleSheet = _class_0
  return _class_0
end
