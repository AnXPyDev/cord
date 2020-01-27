cord = {
  math: require "cord.math.base"
}

class Margin
  new: (left = 0, right = left, top = right, bottom = top, metric = "undefined") =>
    @__name = "cord.util.margin"
    @metric = metric
    @left = left
    @right = right
    @top = top
    @bottom = bottom
  copy: =>
    return Margin(@left, @right, @top, @bottom, @metric)
  lerp: (margin, ammount, treshold = 0.5) =>
    @left = cord.math.lerp(@left, margin.left, ammount, treshold)
    @right = cord.math.lerp(@right, margin.right, ammount, treshold)
    @top = cord.math.lerp(@top, margin.top, ammount, treshold)
    @bottom = cord.math.lerp(@bottom, margin.bottom, ammount, treshold)
  approach: (margin, ammount) =>
    @left = cord.math.approach(@left, margin.left, ammount)
    @right = cord.math.approach(@right, margin.right, ammount)
    @top = cord.math.approach(@top, margin.top, ammount)
    @bottom = cord.math.approach(@bottom, margin.bottom, ammount)

return Margin
