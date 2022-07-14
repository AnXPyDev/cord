wibox = require "wibox"
gears = require "gears"

normalize = require "cord.util.normalize"
cord = {
	table: require "cord.table"
}
types = require "cord.util.types"
	
Node = require "cord.wim.node"

stylizers = {
	geometry: =>
		size = @\get_size("outside")
		@wibox.width = size.x
		@wibox.height = size.y
		
	shape: =>
		@wibox.shape = @data\get("shape") or gears.shape.rectangle

	visibility: =>
		@wibox.visible = @data\get("visible")

}

class Nodebox extends Node
	@__name: "cord.wim.nodebox"

	defaults: cord.table.crush({}, Node.defaults, {
		shape: -> gears.shape.rectangle
	})

	new: (config, child) =>
		super(config, child)

		@data\set("shape", @style\get("shape"))

		@wibox = wibox!
		@wibox.widget = @children[1] and @children[1].widget

		@data\connect_signal("key_changed::pos", (pos) ->
			tpos = pos\copy!
			if @parent and @parent.parent and types.match(@parent.parent, "cord.wim.screen")
				ppos = @parent.parent.data\get("pos")
				tpos.x += ppos.x
				tpos.y += ppos.y
			@wibox.x = tpos.x
			@wibox.y = tpos.y
		)

		@data\connect_signal("key_changed::shape", () -> @\stylize("shape"))
		@data\connect_signal("key_changed::visible", () -> @stylize("visibility"))

		cord.table.crush(@stylizers, stylizers)

		@stylize!
