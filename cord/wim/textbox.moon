wibox = require "wibox"

cord = {
  util: require "cord.util"
  table: require "cord.table"
}

Node = require "cord.wim.node"

stylizers = {
  geometry: (textbox) ->
    size = textbox\get_size!
    textbox.layers.constraint.forced_width = size.x
    textbox.layers.constraint.forced_height = size.y
    textbox.layers.constraint.width = size.x
    textbox.layers.constraint.height = size.y

  align: (textbox) ->
    textbox.textbox.align = textbox.data\get("halign")
    textbox.textbox.valign = textbox.data\get("vhalign")

  text: (textbox) ->
    textbox.textbox.text = textbox.data\get("text")

  font: (textbox) ->
    textbox.textbox.font = "#{textbox.data\get("font_name")} #{textbox.data\get("font_size")}"
}
  
class Textbox extends Node
  new: (stylesheet, identification, text = "") =>
    super(stylesheet, identification)
    table.insert(@__name, "cord.wim.textbox")

    @data\set("halign", @style\get("halign") or "center")
    @data\set("valign", @style\get("valign") or "center")
    @data\set("font_name", @style\get("font_name") or "Unknown")
    @data\set("font_size", @style\get("font_size") or 24)
    @data\set("text", text or "")

    @layers = {}
    @layers.constraint = wibox.container.constraint!
    @widget = @layers.constraint
    @textbox = wibox.widget.textbox!
    @content = @textbox
    @layers.constraint.widget = @content

    cord.table.crush(@stylizers, stylizers)
      
    @data\connect_signal("key_changed::text", () -> @\stylize("text"))
    @data\connect_signal("key_changed::font_size", () -> @\stylize("font"))
    @data\connect_signal("key_changed::font_name", () -> @\stylize("font"))
    @data\connect_signal("key_changed::halign", () -> @\stylize("align"))
    @data\connect_signal("key_changed::valign", () -> @\stylize("align"))
    @\connect_signal("geometry_changed", () -> @\stylize("geometry"))

    @\stylize!

return Textbox
