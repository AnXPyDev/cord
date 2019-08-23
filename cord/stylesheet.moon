Object = require "cord.object"

color = require "cord.color"
deep_crush = (require "cord.table").deep_crush

default_style = {
  margin = {left = 0, right = 0, top = 0, bottom = 0},
  padding = {left = 0, right = 0, top = 0, bottom = 0},
  vertical_place = "center",
  horizontal_place = "center",
  background = {color("#000000"), color("#000000")},
  foreground = {color("#FFFFFF"), color("#FFFFFF")},
  width = nil,
  height = nil
}

class Style extends Object
  new: (args) =>
    super!
    deep_crush(self, default_style)
    deep_crush(self, args or {})
 
class StyleSheet extends Object
  new: (class, id) =>
    super!
    @styles_class = {}
    @styles_id = {}
  apply: (identifiers, style) =>
    for k, val in pairs identifiers.class or {}
      @styles_class[val] = deep_crush(@styles_class[val], style)
    for k, val in pairs identifiers.id or {}
      @styles_id[val] = deep_crush(@styles_id[val], style)
