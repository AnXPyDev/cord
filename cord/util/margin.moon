class Margin
  new: (left = 0, right = left, top = right, bottom = top) =>
    @left = left
    @right = right
    @top = top
    @bottom = bottom
  apply: (tbl) =>
    tbl.left = @left
    tbl.right = @right
    tbl.top = @top
    tbl.bottom = @bottom
  join: (margin) =>
    @left += margin.left
    @right += margin.right
    @top += margin.top
    @bottom += margin.bottom
  copy: =>
    return Margin(@left, @right, @top, @bottom)
      
return Margin
