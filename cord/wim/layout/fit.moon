Vector = require "cord.math.vector"
Layout = require "cord.wim.layout.base"

cord = {
  math = require "cord.math.base"
}
  
corners = {
  top_left: {false, false}
  top_right: {true, false}
  bottom_left: {false, true}
  bottom_right: {true, true}
}

directions = {
  vertical = {"y", "x"}
  horizontal = {"x", "y"}
}
 
class Fit extends Layout
  new: (stylesheet, identification, ...) =>
    super(stylesheet, identification, ...)
    table.insert(@__name, "cord.wim.layout.fit")
    @corner = "top_left"
    @direction = "horizontal"
  apply_layout: =>
    results = {}
    size = @\get_size!
    current = Vector()
    max = 0
    m = directions[@direction]
    for i, child in ipairs @children
      if child.data\get("hidden")
        table.insert(results, {child, i, nil, false})
      child_size = child\get_size("outside")
      if (current[m[1]] + child_size[m[1]]) > size[m[1]]
        current[m[1]] = 0
        current[m[2]] = max
      if not (current[m[2]] + child_size[m[2]] > size[m[2]] or current[m[1]] + child_size[m[1]] > size[m[1]])
        current[m[1]] += child_size[m[1]]
        if max < (current[m[2]] + child_size[m[2]])
          max = current[m[2]] + child_size[m[2]]
        table.insert(results, {child, i, current\copy!, true})
      else
        table.insert(results, {child, i, nil, false})

    corner_translation = corners[@corner]
    for i, result in ipairs results
      if result[3]
        if corner_translation[1] then result[3].x = cord.math.flip(result[3].x, 0, size.x)
        if corner_translation[2] then result[3].y = cord.math.flip(result[3].y, 0, size.y)
      @\apply_for_child(unpack(result))
