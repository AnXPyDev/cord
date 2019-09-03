Layout = require "cord.wim.layout"
Vector = require "cord.math.vector"

animate_layout_change = (layout, node, pos, layout_size) ->
  print(node.category, node.label, node.visible, layout\node_visible_last_time(node))
  local layout_anim, opacity_anim
  if layout\node_visible_last_time(node)
    if not node.visible
      layout_anim = node.style_data.layout_hide_animation(node, (node\get_pos!)\copy!, pos, layout_size)
      opacity_anim = node.style_data.opacity_hide_animation(node, 1, 0)
      table.insert(opacity_anim.callbacks, (() ->
        print("nigga")
        node\set_visible(node.visible, true)))
    else
      layout_anim = node.style_data.layout_move_animation(node, (node\get_pos!)\copy!, pos, layout_size)
  else
    if node.visible
      node\set_visible(node.visible, true)
      layout_anim = node.style_data.layout_show_animation(node, (node\get_pos!)\copy!, pos, layout_size)
      opacity_anim = node.style_data.opacity_hide_animation(node, 0, 1)

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
        if child.visible == false
          continue
        child_size = child\get_size!
        if (current.x + child_size.x) > content_size.x
          current.x = 0
          current.y = max.y

        appear_anim = child.style\get("layout_appear_animation")
        move_anim = child.style\get("layout_move_animation")
        last_time = @\node_visible_last_time(child)


        if last_time == false
          if appear_anim
            appear_anim(child, child.pos\copy!, current\copy!, content_size)
          else
            child\set_pos(current)
        else
          if move_anim
            move_anim(child, child.pos\copy!, current\copy!, content_size)
          else
            child\set_pos(current)

        if max.y < (current.y + child_size.y)
          max.y = current.y + child_size.y
        animate_layout_change(self, child, current\copy!, content_size)
        current.x += child_size.x

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
        animate_layout_change(self, child, current\copy!, content_size)
        current.y += child_size.y

return {
  manual: Layout,
  fit: {
    horizontal: Fit_Horizontal,
    vertical: Fit_Vertical
  }
}
