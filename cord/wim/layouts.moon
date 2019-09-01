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
            appear_anim(child, Vector(current.x + 500, current.y), current\copy!)
          else
            child\set_pos(current)
        else
          if move_anim
            move_anim(child, child.pos\copy!, current\copy!)
          else
            child\set_pos(current)

        if max.y < (current.y + child_size.y)
          max.y = current.y + child_size.y

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

        appear_anim = child.style\get("layout_appear_animation")
        move_anim = child.style\get("layout_move_animation")
        last_time = @\node_visible_last_time(child)


        if last_time == false
          if appear_anim
            appear_anim(child, Vector(current.x, current.y + 500), current\copy!)
          else
            child\set_pos(current)
        else
          if move_anim
            move_anim(child, child.pos\copy!, current\copy!)
          else
            child\set_pos(current)

        if max.x < (current.x + child_size.x)
          max.x = current.x + child_size.x

        current.y += child_size.y
return {
  manual: Layout,
  fit: {
    horizontal: Fit_Horizontal,
    vertical: Fit_Vertical
  }
}
