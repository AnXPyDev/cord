gears = { timer: require "gears.timer" }

Object = require "cord.util.object"

class Animator extends Object
  new: (tps = 60) =>
    @queue = {}
    @tps = tps
    @timer = gears.timer({
      timeout: 1000 / @tps,
      call_now: false,
      autostart: false,
      callback: () ->
        @\update!
    })
  add: (animation) =>
    table.insert(@queue, animation)
    if #@queue > 0
      @timer\start!
  remove: (animation)
    for i, v in ipairs @queue
      if v == animation
        table.remove(@queue, i)
        break
    if #@queue == 0
      @timer\stop!
  set_tps: (tps = @tps) =>
    @tps = tps
    @timer.timeout = 1000 / @tps
  update: =>
    i = 1
    while i <= #@queue
      is_not_error, ret = pcall(() ->
        return @queue[i]\update!
      )
      if (not is_not_error) or (is_not_error and (ret == true)) or @queue[i].done
        table.remove(@queue, i)
        i -= 1
      i += 1
    if #@queue == 0
      @timer\stop!
