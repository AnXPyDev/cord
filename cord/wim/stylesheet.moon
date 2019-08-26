Object = require "cord.util.object"
Style = require "cord.wim.style"

class StyleSheet extends Object
  new: =>
    super!
    @by_category = {}
    @by_label = {}
  add_style: (category, label, style) =>
    if category and category != "__empty_node_category__"
      @by_category[category] = @by_category[category] or Style()
      @by_category[category]\join(style)
    if label and label != "__empty_node_label__"
      @by_label[label] = @by_label[label] or Style()
      @by_label[label]\join(style)
  get_style: (category, label) =>
    if label and label != "__empty_node_label__" and @by_label[label]
      return @by_label[label]
    elseif category and category != "__empty_node_category__" and @by_category[category]
      return @by_category[category]
    return Style()
