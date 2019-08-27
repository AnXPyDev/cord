gears = {
  table: require "gears.table",
  color: require "gears.color"
}

Vector = require "cord.math.vector"
  
class Pattern
  new: (beggining = Vector(), ending = Vector(100,0), stops) =>
    @__name = "cord.util.pattern"
    @stops = stops
    @beggining = beginning
    @ending = ending
  create_pattern: () =>
    stops = {}
    for i, stop in ipairs @stops
      stops.insert({stop[2] or (i - 1) / (#@stops - 1), stop[1]\to_rgba_string!})
    return gears.color.create_linear_pattern(
      {
        from: {@beggining.x, @beggining.y},
        to: {@ending.x, @ending.y},
        stops: stops
      }
    )


return Pattern
