class Margin
  new: (left = 0, right = left, top = right, bottom = top, metric = "undefined") =>
    @metric = metric
    @left = left
    @right = right
    @top = top
    @bottom = bottom
  copy: =>
    return Margin(@left, @right, @top, @bottom, @metric)
      
return Margin
