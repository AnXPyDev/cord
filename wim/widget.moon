Node = require "cord.wim.node"

class Widget extends Node
	@__name: "cord.wim.widget"

	new: (config, widget) =>
		super(config)
		@widget = widget or @widget
