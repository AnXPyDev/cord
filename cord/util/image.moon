gears = require "gears"

Object = require "cord.util.object"

class Image extends Object
  new: (path) =>
    @__name = "cord.util.image"
    @base_surface = gears.surface(path)
    @color_cache = {}
  get: (color) =>
    local string_color
    if type(color) == "table" and color.__name == "cord.util.color"
      string_color = color\to_rgba_string!
    elseif type(color) != "string"
      return @base_surface
    if not @color_cache[string_color]
      @color_cache[string_color] = gears.color.recolor_image(gears.surface.duplicate_surface(@base_surface), string_color)
    return @color_cache[string_color]

    
