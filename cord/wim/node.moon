Object = require "cord.object"

class Node extends Object
  new: (category, label, stylesheet) =>
    super!
    @category = category or "__empty_node_category__"
    @label = label or "__empty_node_label__"
    @style = stylesheet\get_style(@category, @label)

return Node
