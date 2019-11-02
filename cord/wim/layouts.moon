Layout = require "cord.wim.layout"
Vector = require "cord.math.vector"

class Fit_Horizontal extends Layout
  new: =>
    super!
    @__name = "cord.wim.layouts.fit.horizontal"
  apply_layout: (node) =>
    content_size = node\get_content_size!
    max = Vector()
    current = Vector()
    for k, child in pairs node.children
      if child.__name and (child.__name == "cord.wim.node" or child.__name == "cord.wim.text" or child.__name == "cord.wim.nodebox")
        if child.visible == true
          child_size = child\get_size!
          if (current.x + child_size.x) > content_size.x
            current.x = 0
            current.y = max.y
          child\apply_layout_change(self, current\copy!, content_size)
          if max.y < (current.y + child_size.y)
            max.y = current.y + child_size.y
          current.x += child_size.x
        else
          child\apply_layout_change(self, Vector(), content_size)

class Fit_Vertical extends Layout
  new: =>
    super!
    @__name = "cord.wim.layouts.fit.vertical"
  apply_layout: (node) =>
    content_size = node\get_content_size!
    max = Vector()
    current = Vector()
    for k, child in pairs node.children
      if child.__name and (child.__name == "cord.wim.node" or child.__name == "cord.wim.text" or child.__name == "cord.wim.nodebox")
        if child.visible == false
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
