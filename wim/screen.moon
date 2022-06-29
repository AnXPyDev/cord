Node = require "cord.wim.node"

Vector = require "cord.math.vector"
Callback_Value = require "cord.util.callback_value"

class Screen extends Node
	new: (config, screen, ...) =>
		super(config, ...)
		table.insert(@__name, "cord.wim.screen")

		@screen = screen

		@data\set("pos", Callback_Value(() ->
			return Vector(@screen.geometry.x, @screen.geometry.y)
		))

		@data\set("size", Callback_Value(() ->
			return @get_size!
		))

	get_size: =>
		return Vector(@screen.geometry.width, @screen.geometry.height)
