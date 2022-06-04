Layout = require "cord.wim.layout.base"

class Align extends Layout
	new: (horizontal = "center", vertical = "center", direction = "horizontal") =>
		table.insert(@__name, "cord.wim.layout.align")
		@horizontal = horizontal
		@vertical = vertical
		@direction = direction

	apply_layout: =>
