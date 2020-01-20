wibox = require "wibox"
gears = require "gears"

normalize = require "cord.util.normalize"
cord = {
  table: require "cord.table"
}
  
Node = require "cord.wim.node"

stylizers = {
  geometry: (nodebox) ->
    size = nodebox\get_size("outside")
    nodebox.wibox.width = size.x
    nodebox.wibox.height = size.y
    
  shape: (nodebox) ->
    nodebox.wibox.shape = nodebox.data\get("shape") or gears.shape.rectangle

  visibility: (nodebox) ->
    nodebox.wibox.visible = nodebox.data\get("visible") and not nodebox.data\get("hidden") or false

}

class Nodebox extends Node
  new: (stylesheet, identification, ...) =>
    super(stylesheet, identification, ...)
    table.insert(@__name, "cord.wim.nodebox")

    @data\set("shape", @style\get("shape"))

    @wibox = wibox!
    @wibox.widget = @children[1] and @children[1].widget

    @data\connect_signal("key_changed::pos", (pos) ->
      tpos = pos\copy!
      if @parent
        ppos = @parent.data\get("pos")
        tpos.x += ppos.x
        tpos.y += ppos.y
      @wibox.x = tpos.x
      @wibox.y = tpos.y
    )

    @data\connect_signal("key_changed::shape", () -> @\stylize("shape"))
    @data\connect_signal("key_changed::visible", () -> @stylize("visibility"))
    @data\connect_signal("key_changed::hidden", () -> @stylize("visibility"))

    cord.table.crush(@stylizers, stylizers)

    @stylize!
