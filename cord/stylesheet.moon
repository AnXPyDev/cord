Object = require "cord.object"

crush = (require "gears.table").crush


default_style = {
  margin = {left = 0, right = 0, top = 0, bottom = 0},
  padding = {left = 0, right = 0, top = 0, bottom = 0},
  vertical_place = "center",
  horizontal_place = "center",
  background = {"#000000", "#000000"},
  foreground = {"#FFFFFF", "#FFFFFF"},
  width = nil,
  height = nil
}

class Style extends Object
  new: (args) =>
    crush(self, default_style)
    crush(self, args or {})
  
class StyleSheet extends Object
  new: (class, id) =>
    super!
    @styles_class = {}
    @styles_id = {}

    
