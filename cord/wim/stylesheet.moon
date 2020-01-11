Object = require "cord.util.object"
Style = require "cord.wim.style"

class Stylesheet extends Object
  new: =>
    super!
    table.insert(@__name, "cord.wim.stylsheet")
    @by_category = {}
    @by_label = {}

  add_style: (identification = {}, style, parents = {}) =>
    category = identification[1]
    label = identification[2]
    if label and label != "__empty_label__"
      @by_label[label] = @by_label[label] or style
      @by_label[label]\join(style)
    elseif category and category != "__empty_category__"
      @by_category[category] = @by_category[category] or style
      @by_category[category]\join(style)
    style = @\get_style(identification)
    for k, v in pairs parents
      style\add_parent(@\get_style(v))
    return style

  get_style: (identification = {}) =>
    category = identification[1]
    label = identification[2]
    if label and label != "__empty_label__" and @by_label[label]
      return @by_label[label]
    elseif category and category != "__empty_category__" and @by_category[category]
      return @by_category[category]
    return Style()

return Stylesheet
