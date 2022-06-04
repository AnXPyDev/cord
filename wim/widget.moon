Node = require "cord.wim.node"

class Widget extends Node
	new: (stylesheet, identification, widget) =>
		super(stylesheet, identification)
		table.insert(@__name, "cord.wim.widget")
		@widget = widget or @widget
