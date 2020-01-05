cord = {
  util: require "cord.util"
}

Layout = require "cord.wim.layout"
Vector = require "cord.math.vector"

class Fit_Horizontal extends Layout
  new: =>
    super!
    table.insert(@__name, "cord.wim.layouts.fit.horizontal")
  apply_layout: (node) =>
    content_size = node\get_content_size!
    max = Vector()
    current = Vector()
    for k, child in pairs node.children
      if cord.util.is_object_class(child, "cord.wim.node")
        if child.current_style\get("visible") == true
          child_size = child\get_size!
          if (current.x + child_size.x) > content_size.x
            current.x = 0
            current.y = max.y
          child\apply_layout_change(self, current\copy!, content_size)
          if max.y < (current.y + child_size.y)
            max.y = current.y + child_size.y
          current.x += child_size.x

class Fit_Vertical extends Layout
  new: =>
    super!
    table.insert(@__name, "cord.wim.layouts.fit.vertical")
  apply_layout: (node) =>
    content_size = node\get_content_size!
    max = Vector()
    current = Vector()
    for k, child in pairs node.children
      if cord.util.is_object_class(child, "cord.wim.node")
        if child.current_style\get("visible") == false
          continue
        child_size = child\get_size!
        if (current.y + child_size.y) > content_size.y
          current.x = max.x
          current.y = 0
        if max.x < (current.x + child_size.x)
          max.x = current.x + child_size.x
        child\apply_layout_change(self, current\copy!, content_size)
        current.y += child_size.y

return {
  manual: Layout,
  fit: {
    horizontal: Fit_Horizontal,
    vertical: Fit_Vertical
  }
}
