Object = require "cord.util.object"

class Animation extends Object
  new: =>
    super!
    @__name = "cord.wim.animation"
    @done = false
    @tick_function = ( -> )
    @callback = ( -> )
  update: =>
    @done = @\tick!
    @done = @tick_function! or @done
    return @done
  tick: =>
    return false

return Animation
