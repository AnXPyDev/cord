local Object = require("cord.util.object")
local Style = require("cord.wim.style")
local Vector = require("cord.math.vector")
local types = require("cord.util.types")
local normalize = require("cord.util.normalize")
local id_counter = 0
local Node
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    stylize = function(self, ...)
      if #{
        ...
      } == 0 then
        for k, stylizer in pairs(self.stylizers) do
          stylizer(self)
        end
      end
      for i, name in ipairs({
        ...
      }) do
        local _ = self.stylizers[name] and self.stylizers[name](self)
      end
      return self.widget and self.widget:emit_signal("widget::redraw_needed")
    end,
    add_child = function(self, child, index)
      if index == nil then
        index = #self.children + 1
      end
      if types.match(child, "cord.wim.node") then
        table.insert(self.children, index, child)
        child:set_parent(self, index)
        return self:emit_signal("added_child", child, index)
      end
    end,
    remove_child = function(self, to_remove)
      for i, child in ipairs(self.children) do
        if child.id == to_remove.id then
          table.remove(self.children, i)
          self:emit_signal("removed_child", child, i)
        end
      end
    end,
    set_parent = function(self, parent, index)
      if types.match(parent, "cord.wim.node") or parent == nil then
        self:emit_signal("before_parent_change")
        self.parent = parent
        self.data:set("parent_index", index or 1)
        return self:emit_signal("parent_changed")
      end
    end,
    get_size = function(self)
      return normalize.vector(self.data:get("size"), self.parent and self.parent:get_size())
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, stylesheet, identification, ...)
      _class_0.__parent.__init(self)
      table.insert(self.__name, "cord.wim.node")
      self.id = id_counter
      id_counter = id_counter + 1
      self.identification = identification or { }
      self.style = stylesheet:get_style(self.identification)
      self.data = Style()
      self.parent = nil
      self.children = { }
      self.widget = { }
      self.data:set("size", self.style:get("size") or Vector(1, 1, "percentage"))
      self.data:set("pos", self.style:get("pos") or Vector())
      self.data:set("visible", self.style:get("visible"))
      self.data:set("hidden", self.style:get("hidden"))
      self.data:set("opacity", 1)
      self.data:set("parent_index", 0)
      self.stylizers = { }
      self:connect_signal("geometry_changed", function()
        for i, child in ipairs(self.children) do
          child:emit_signal("geometry_changed")
        end
        return self.parent and self.parent:emit_signal("layout_changed")
      end)
      self.data:connect_signal("key_changed::hidden", function()
        return self.parent and self.parent:emit_signal("layout_changed")
      end)
      self.data:connect_signal("key_changed::pos", function()
        return self.parent and types.match(self.parent, "cord.wim.layout") and self.parent:update_in_content(self, self.data:get("parent_index"))
      end)
      self:connect_signal("parent_changed", function()
        return self:emit_signal("geometry_changed")
      end)
      for i, child in ipairs({
        ...
      }) do
        self:add_child(child)
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
