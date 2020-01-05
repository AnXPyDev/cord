Vector = require "cord.math.vector"
Object = require "cord.util.object"
cord = { util: require "cord.util" }
cord.log = require "cord.log"


class Layout extends Object
  new: =>
    super!
    @node_visibility = {}

  node_visible_last_time: (node) =>
    ret = false
    if @node_visibility[node.unique_id] == true
      ret = @node_visibility[node.unique_id]
    @node_visibility[node.unique_id] = node.visible
    return ret

  apply_layout: (node) =>

  inherit: (layout) =>
    if not layout then return
    @node_visibility = layout.node_visibility

return Layout
