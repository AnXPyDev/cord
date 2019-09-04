Layout = require "cord.wim.layout"
Vector = require "cord.math.vector"

animate_layout_change = (layout, node, pos, layout_size) ->
  last_time = layout\node_visible_last_time(node)

  local layout_anim, opacity_anim
  if last_time
    if not node.visible
      layout_anim = node.style_data.layout_hide_animation(node, node.pos\copy!, node.pos\copy!, layout_size)
      opacity_anim = node.style_data.opacity_hide_animation(node, 1, 0)
      table.insert(opacity_anim.callbacks, (() ->
        node\set_visible(node.visible, true)))
    else
      layout_anim = node.style_data.layout_move_animation(node, node.pos\copy!, pos, layout_size)
  else
    if node.visible
      node\set_visible(node.visible, true)
      layout_anim = node.style_data.layout_show_animation(node, node.pos\copy!, pos, layout_size)
      opacity_anim = node.style_data.opacity_show_animation(node, 0, 1)

class Fit_Horizontal extends Layout
  new: =>
    super!
    @__name = "cord.wim.layouts.fit.horizontal"
  apply_layout: (node) =>
    content_size = node\get_content_size!
    max = Vector()
    current = Vector()
    for k, child in pairs node.children
      if child.__name and child.__name == "cord.wim.node"
        if child.visible == true
          child_size = child\get_size!
          if (current.x + child_size.x) > content_size.x
            current.x = 0
            current.y = max.y
          animate_layout_change(self, child, current\copy!, content_size)
          if max.y < (current.y + child_size.y)
            max.y = current.y + child_size.y
          current.x += child_size.x
        else
          animate_layout_change(self, child, Vector(), content_size)

class Fit_Vertical extends Layout
  new: =>
    super!
    @__name = "cord.wim.layouts.fit.vertical"
  apply_layout: (node) =>
    content_size = node\get_content_size!
    max = Vector()
    current = Vector()
    for k, child in pairs node.children
      if child.__name and child.__name == "cord.wim.node"
        if child.visible == false
          continue
        child_size = child\get_size!
        if (current.y + child_size.y) > content_size.y
          current.x = max.x
          current.y = 0
        if max.x < (current.x + child_size.x)
          max.x = current.x + child_size.x
        animate_layout_change(self, child, current\copy!, content_size)
        current.y += child_size.y

return {
  manual: Layout,
  fit: {
    horizontal: Fit_Horizontal,
    vertical: Fit_Vertical
  }
}
