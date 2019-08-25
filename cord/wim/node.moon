Object = require "cord.object"

container_order = {
  "place",
  "padding",
  "background",
  "margin",
  "content",
  "overlay"
}
  
class Node extends Object
  new: (category, label, stylesheet) =>
    super!
    @category = category or "__empty_node_category__"
    @label = label or "__empty_node_label__"
    @style = stylesheet\get_style(@category, @label)
    @children = {}
    @containers = {}
    @widget = nil
  reorder_containers: () =>
    last_required = nil
    for i, val in ipairs container_order
      if @containers[val]
        if not last_required then
          @widget = @containers[val]
        else
          last_required.widget = @containers[val]
        last_required = @containers[val]
        
    

     
return Node
