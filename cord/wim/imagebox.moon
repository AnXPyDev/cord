wibox = require "wibox"
gears = require "gears"

cord = {
	util: require "cord.util"
	table: require "cord.table"
}

Node = require "cord.wim.node"

stylizers = {
	geometry: (imagebox) ->
		size = imagebox\get_size!
		imagebox.imagebox.forced_width = size.x
		imagebox.imagebox.forced_height = size.y

	resize: (imagebox) ->
		imagebox.imagebox.resize = imagebox.data\get("resize")

	image: (imagebox) ->
		image = imagebox.data\get("image")
		imagebox.imagebox.image = image and image\get(imagebox.data\get("color"))
}  

class Imagebox extends Node
	defaults: cord.table.crush({}, Node.defaults, {
		resize: -> true
	})

	new: (config, image) =>
		super(config)
		table.insert(@__name, "cord.wim.imagebox")

		@data\set("image", image)
		@data\set("color", @style\get("color"))
		@data\set("resize", @style\get("resize") or true)

		@imagebox = wibox.widget.imagebox!
		@content = @imagebox
		@widget = @imagebox

		cord.table.crush(@stylizers, stylizers)
			
		@data\connect_signal("key_changed::color", () -> @\stylize("image"))
		@data\connect_signal("key_changed::image", () -> @\stylize("image"))
		@data\connect_signal("key_changed::resize", () -> @\stylize("resize"))
		@\connect_signal("geometry_changed", () -> @\stylize("geometry"))

		@\stylize!

return Imagebox
