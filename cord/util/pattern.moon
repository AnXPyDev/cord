gears = {
  table: require "gears.table",
  color: require "gears.color"
}

cord = { log: require "cord.log" }
  
Vector = require "cord.math.vector"
  
class Pattern
  new: (stops, beginning = Vector(), ending = Vector(100, 0)) =>
    @__name = "cord.util.pattern"
    @stops = stops
    @beginning = beginning
    @ending = ending
  create_pattern: (beginning = @beginning, ending = @ending) =>
    stops = {}
    for i, stop in ipairs @stops
      table.insert(stops, {stop[2] or ((i - 1) / (#@stops - 1)), type(stop[1]) == "string" and stop[1] or stop[1]\to_rgba_string!})
    return gears.color.create_linear_pattern(
      {
        from: {beginning.x, beginning.y},
        to: {ending.x, ending.y},
        stops: stops
      }
    )
  copy: =>
    return Pattern(@stops, @beginning, @ending)


return Pattern
