Node = require "cord.wim.node"

Vector = require "cord.math.vector"
Callback_Value = require "cord.util.callback_value"

class Screen extends Node
	new: (stylesheet, identification, screen, ...) =>
		super(stylesheet, identification, ...)

		@screen = screen

		@data\set("pos", Callback_Value(() ->
			return Vector(@screen.geometry.x, @screen.geometry.y)
		))

	get_size: =>
		return Vector(@screen.geometry.width, @screen.geometry.height)
