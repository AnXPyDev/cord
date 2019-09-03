Object = require "cord.util.object"
Style = require "cord.wim.style"

class StyleSheet extends Object
  new: =>
    super!
    @__name = "cord.wim.stylsheet"
    @by_category = {}
    @by_label = {}
  add_style: (category, label, style, parents = {}) =>
    if category and category != "__empty_node_category__"
      @by_category[category] = @by_category[category] or style
      @by_category[category]\join(style)
    if label and label != "__empty_node_label__"
      @by_label[label] = @by_label[label] or style
      @by_label[label]\join(style)
    style = @\get_style(category, label)
    for k, v in pairs parents
      table.insert(style.parents, @\get_style(v[1], v[2]))
    return style
  get_style: (category, label) =>
    if label and label != "__empty_node_label__" and @by_label[label]
      return @by_label[label]
    elseif category and category != "__empty_node_category__" and @by_category[category]
      return @by_category[category]
    return Style()
