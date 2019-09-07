local Margin
do
  local _class_0
  local _base_0 = {
    apply = function(self, tbl)
      tbl.left = self.left
      tbl.right = self.right
      tbl.top = self.top
      tbl.bottom = self.bottom
    end,
    join = function(self, margin)
      self.left = self.left + margin.left
      self.right = self.right + margin.right
      self.top = self.top + margin.top
      self.bottom = self.bottom + margin.bottom
    end,
    copy = function(self)
      return Margin(self.left, self.right, self.top, self.bottom)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, left, right, top, bottom)
      if left == nil then
        left = 0
      end
      if right == nil then
        right = left
      end
      if top == nil then
        top = right
      end
      if bottom == nil then
        bottom = top
      end
      self.left = left
      self.right = right
      self.top = top
      self.bottom = bottom
    end,
    __base = _base_0,
    __name = "Margin"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Margin = _class_0
end
return Margin
