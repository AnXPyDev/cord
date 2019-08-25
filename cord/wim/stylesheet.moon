Object = require "cord.object"
Style = require "cord.wim.style"

class StyleSheet extends Object
  new: =>
    super!
    @by_category = {}
    @by_label = {}

