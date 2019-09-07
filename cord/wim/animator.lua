local gears = {
  timer = require("gears.timer")
}
local Object = require("cord.util.object")
local Animator
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    add = function(self, animation)
      table.insert(self.queue, animation)
      if #self.queue > 0 then
        return self.timer:again()
      end
    end,
    remove = function(self, animation)
      for i, v in ipairs(self.queue) do
        if v == animation then
          table.remove(self.queue, i)
          break
        end
      end
      if #self.queue == 0 then
        return self.timer:stop()
      end
    end,
    set_tps = function(self, tps)
      if tps == nil then
        tps = self.tps
      end
      self.tps = tps
      self.timer.timeout = 1 / self.tps
    end,
    update = function(self)
      local i = 1
      while i <= #self.queue do
        local is_not_error, ret
        local do_remove = false
        if self.queue[i].done == false then
          is_not_error, ret = pcall(function()
            return self.queue[i]:update()
          end)
        else
          do_remove = true
        end
        if is_not_error == false then
          print("animation error", ret)
          do_remove = true
        end
        if do_remove then
          for k, v in pairs(self.queue[i].callbacks) do
            pcall(v)
          end
          table.remove(self.queue, i)
          i = i - 1
        end
        i = i + 1
      end
      if #self.queue == 0 then
        return self.timer:stop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, tps)
      if tps == nil then
        tps = 60
      end
      self.queue = { }
      self.tps = tps
      self.timer = gears.timer({
        timeout = 1 / self.tps,
        call_now = false,
        autostart = false,
        single_shot = false,
        callback = function()
          return self:update()
        end
      })
    end,
    __base = _base_0,
    __name = "Animator",
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
  Animator = _class_0
end
return Animator
