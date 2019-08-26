class Margin
  new: (left = 0, right = left, top = 0, bottom = top) =>
    @left = left
    @right = right
    @top = top
    @bottom = bottom
  apply: (tbl) =>
    tbl.left = @left
    tbl.right = @right
    tbl.top = @top
    tbl.bottom = @bottom
      
return Margin
