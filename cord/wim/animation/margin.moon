Animation = require "cord.wim.animation.base"
Margin = require "cord.util.margin"

class Margin extends Animation
  new: (node, start, target, data_index, ...) =>
    super(...)
    table.insert(@__name, "cord.wim.animation.margin")
    @node = node
    @data_index = data_index
    start = start or @node.data\get(@data_index)
    if not start
      return
    if @node.data\get("active_#{@data_index}_animation")
      @node.data\get("active_#{@data_index}_animation")
