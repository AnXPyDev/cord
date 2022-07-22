Node = require "cord.wim.node"

Vector = require "cord.math.vector"
Callback_Value = require "cord.util.callback_value"

normalize = require "cord.util.normalize"

cord = {
	table: require "cord.table"
	util: require "cord.util"
}


stylizers = {
	border: =>
		@client.border_width = @data\get("border_width")
		@client.border_color = normalize.color_or_pattern(@data\get("border_color"))
}

class Client extends Node
	defaults: cord.table.crush({}, Node.defaults, {
		border_color: "#000000"
		border_width: 0
	})

	@__name: "cord.wim.client"

	new: (config, client, ...) =>
		super(config, ...)

		@client = client

		@data\set("pos", Callback_Value(() ->
			return Vector(@client.x, @client.y)
		))

		@data\set("size", Callback_Value(() ->
			return @get_size!
		))

		@data\set("border_width", config.border_width or @style\get("border_width"))
		@data\set("border_color", config.border_color or @style\get("border_color"))
		
		@data\set("name", @client.name or "client")

		cord.table.crush(@stylizers, stylizers)

		@data\connect_signal("updated::border_width", -> @\stylize("border"))
		@data\connect_signal("updated::border_color", -> @\stylize("border"))

		@client\connect_signal("property::size", -> @\emit_signal("geometry_changed"))
		@client\connect_signal("property::position", -> @\emit_signal("position_changed"))
		@client\connect_signal("request::titlebars", -> 
			@\emit_signal("request_titlebars", @)
		)

		@client\connect_signal("property::name", ->
			@data\set("name", @client.name)
		)

		@client\connect_signal("unmanage", ->
			@dead = true
			for k, v in pairs @data.values
				if k\find("animation::")
					v.done = true

		)

		@client\connect_signal("focus", -> @\emit_signal("focus"))
		@client\connect_signal("unfocus", -> @\emit_signal("unfocus"))
		
		@titlebars = {}

		@\stylize!
	
	get_size: =>
		return Vector(@client.width, @client.height)
