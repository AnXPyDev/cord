cord = require "cord"
awful = require "awful"

Node = require "cord.wim.node"
Vector = require "cord.math.vector"
Value = require "cord.math.value"

log = require "cord.log"

stylizers = {
	position: =>
		@wibar.position = @data\get("position")

	geometry: =>
		size = @\get_size!
		@wibar.width = size.x
		@wibar.height = size.y

	background: =>
		@wibar.bg = cord.util.normalize.color_or_pattern(@data\get("background"))

	shape: =>
		@wibar.shape = @data\get("shape")

}

class Bar extends Node
	defaults: cord.table.crush({}, Node.defaults, {
		position: -> "top"
		size: -> Vector(Value(1, 0, "ratio"), 100)
		background: -> "#AA0000"
		shape: -> nil
	})


	new: (config, screen, ...) =>
		super(config, ...)
		table.insert(@__name, "cord.wim.bar")

		cord.table.crush(@stylizers, stylizers)
	
		@screen = screen
		@wibar = awful.wibar({
			screen: @screen.screen
			stretch: false
		})
		
		@data\set("position", @style\get("position"))
		@data\set("size", @style\get("size"))
		@data\set("background", @style\get("background"))
		@data\set("shape", @style\get("shape"))

		@\connect_signal("added_child", ->
			@wibar.widget = @children[1]
		)
		
		@\emit_signal("added_child")

		@data\connect_signal("key_changed::position", -> 
			@\stylize("position")
		)

		@data\connect_signal("key_changed::background", ->
			@\stylize("background")
		)

		@data\connect_signal("key_changed::shape", ->
			@\stylize("shape")
		)
		
		@data\connect_signal("key_changed::size", ->
			@\emit_signal("geometry_changed")
		)

		@\connect_signal("geometry_changed", ->
			@\stylize("geometry")
		)

		@\connect_signal("parent_changed", ->
			@\emit_signal("geometry_changed")
		)

		@\stylize!



return Bar
