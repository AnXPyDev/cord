local cord = {
  math = require("cord.math")
}
local hsla_to_rgba
hsla_to_rgba = function(hsla_array)
  local h, s, l, a = unpack(hsla_array)
  local m1, m2
  if l <= 0.5 then
    m2 = l * (s + 1)
  else
    m2 = l + s - l * s
  end
  m1 = l * 2 - m2
  local _h2rgb
  _h2rgb = function(m1, m2, h)
    if h < 0 then
      h = h + 1
    end
    if h > 1 then
      h = h - 1
    end
    if h * 6 < 1 then
      return m1 + (m2 - m1) * h * 6
    elseif h * 2 < 1 then
      return m2
    elseif h * 3 < 2 then
      return m1 + (m2 - m1) * (2 / 3 - h) * 6
    else
      return m1
    end
  end
  return {
    _h2rgb(m1, m2, h + 1 / 3),
    _h2rgb(m1, m2, h),
    _h2rgb(m1, m2, h - 1 / 3),
    a or 1
  }
end
local rgba_to_hsla
rgba_to_hsla = function(rgba_array)
  local r, g, b, a = unpack(rgba_array)
  local min = math.min(r, g, b)
  local max = math.max(r, g, b)
  local delta = max - min
  local h, s, l = 0, 0, ((min + max) / 2)
  if l > 0 and l < 0.5 then
    s = delta / (max + min)
  end
  if l >= 0.5 and l < 1 then
    s = delta / (2 - max - min)
  end
  if delta > 0 then
    if max == r and max ~= g then
      h = h + (g - b) / delta
    end
    if max == g and max ~= b then
      h = h + 2 + (b - r) / delta
    end
    if max == b and max ~= r then
      h = h + 4 + (r - g) / delta
    end
    h = h / 6
  end
  if h < 0 then
    h = h + 1
  end
  if h > 1 then
    h = h - 1
  end
  return {
    h,
    s,
    l,
    a or 1
  }
end
local hex_string_to_array
hex_string_to_array = function(hex_string)
  local result = { }
  if hex_string:sub(1, 1) == "#" then
    hex_string = hex_string:sub(2)
  end
  for i = 1, math.floor(hex_string:len() / 2) do
    table.insert(result, tonumber(hex_string:sub(i * 2 - 1, i * 2), 16) / 255.0)
  end
  return result
end
local array_to_hex_string
array_to_hex_string = function(array)
  local result = "#"
  for _index_0 = 1, #array do
    local val = array[_index_0]
    result = result .. string.format("%02x", math.floor(val * 255 + 0.5))
  end
  return result
end
local edit_translations = {
  R = "rgb",
  G = "rgb",
  B = "rgb",
  A = "none",
  H = "hsl",
  S = "hsl",
  L = "hsl"
}
local Color
do
  local _class_0
  local _base_0 = {
    refresh_hsl = function(self)
      self.H, self.S, self.L, self.A = unpack(rgba_to_hsla({
        self.R,
        self.G,
        self.B,
        self.A
      }))
    end,
    refresh_rgb = function(self)
      self.R, self.G, self.B, self.A = unpack(hsla_to_rgba({
        self.H,
        self.S,
        self.L,
        self.A
      }))
    end,
    set = function(self, property, value, offset)
      if value == nil then
        value = self[property]
      end
      if offset == nil then
        offset = 0
      end
      self[property] = value + offset
      if edit_translations[property] == "rgb" then
        return self:refresh_hsl()
      elseif edit_translations[property] == "hsl" then
        return self:refresh_rgb()
      end
    end,
    to_rgba_string = function(self)
      return array_to_hex_string({
        self.R,
        self.G,
        self.B,
        self.A
      })
    end,
    to_hsla_string = function(self)
      return array_to_hex_string({
        self.H,
        self.S,
        self.L,
        self.A
      })
    end,
    copy = function(self)
      return Color(self:to_rgba_string())
    end,
    approach = function(self, color, ammount)
      self.R = cord.math.approach(self.R, color.R, ammount)
      self.G = cord.math.approach(self.G, color.G, ammount)
      self.B = cord.math.approach(self.B, color.B, ammount)
      self.A = cord.math.approach(self.A, color.A, ammount)
      return self:refresh_hsl()
    end,
    lerp = function(self, color, ammount, treshold)
      if treshold == nil then
        treshold = 0.05
      end
      self.R = cord.math.lerp(self.R, color.R, ammount, treshold)
      self.G = cord.math.lerp(self.G, color.G, ammount, treshold)
      self.B = cord.math.lerp(self.B, color.B, ammount, treshold)
      self.A = cord.math.lerp(self.A, color.A, ammount, treshold)
      return self:refresh_hsl()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, rgba_string)
      self.__name = "cord.util.color"
      self.R, self.G, self.B, self.A = unpack(hex_string_to_array(rgba_string))
      self.H, self.S, self.L, self.A = unpack(rgba_to_hsla({
        self.R,
        self.G,
        self.B,
        self.A
      }))
    end,
    __base = _base_0,
    __name = "Color"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Color = _class_0
end
return Color
