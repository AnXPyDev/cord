awful = require "awful"
wibox = require "wibox"

cord = {
	util: require "cord.util"
	table: require "cord.table"
}

Node = require "cord.wim.node"
Vector = require "cord.math.vector"
Value = require "cord.math.value"

log = require "cord.log"

normalize = require "cord.util.normalize"

stylizers = {
	position: =>
		@titlebar.position = @data\get("position")

	geometry: =>
		size = @\get_size!

		@container.forced_width = size.x
		@container.forced_height = size.y

	background: =>
		@container.bg = normalize.color_or_pattern(@data\get("background"))

	foreground: =>
		@container.fg = normalize.color_or_pattern(@data\get("foreground"))


	shape: =>
		@container.shape = @data\get("shape")

}

class TitleBar extends Node
	@__name: "cord.wim.titlebar"

	defaults: cord.table.crush({}, Node.defaults, {
		position: "top"
		size: 40
		background: "#AA0000"
		foreground: "#FFFFFF"
		shape: nil
	})


	new: (config, client, buttons, ...) =>
		super(config, ...)

		cord.table.crush(@stylizers, stylizers)
	
		@client = client
		@buttons = buttons or config.buttons

		@data\set("position", @style\get("position"))
		@data\set("size", @style\get("size"))
		@data\set("background", @style\get("background"))
		@data\set("foreground", @style\get("foreground"))
		@data\set("shape", @style\get("shape"))

		@titlebar = awful.titlebar(@client.client, {
			bg: "#000000"
			size: @data\get("size")
			position: @data\get("position")
		})
		
		@container = wibox.container.background()

		@titlebar\setup({
			layout: wibox.layout.fixed.horizontal,
			buttons: @buttons
			@container
		})

		@\connect_signal("added_child", ->
			if not @children[1]
				return

			@container.widget = @children[1].widget
		)
		
		@\emit_signal("added_child")

		@data\connect_signal("updated::position", -> 
			@\stylize("position")
		)

		@data\connect_signal("updated::background", ->
			@\stylize("background")
		)
		
		@data\connect_signal("updated::foreground", ->
			@\stylize("foreground")
		)

		@data\connect_signal("updated::shape", ->
			@\stylize("shape")
		)
		
		@data\connect_signal("updated::size", ->
			@\emit_signal("geometry_changed")
		)

		@\connect_signal("geometry_changed", ->
			@\stylize("geometry")
		)

		@\connect_signal("parent_changed", ->
			@\emit_signal("geometry_changed")
			
			if cord.util.types.match(@parent, "cord.wim.client")
				@parent.titlebars[@data\get("position")] = @
		)

		@\stylize!

	get_size: =>
		position = @data\get("position")
		size = @data\get("size")
		client_size = @parent and @parent\get_size! or Vector(100)

		if position == "top" or position == "bottom"
			return Vector(client_size.x, size)
		return Vector(size, client_size.y)

return TitleBar
