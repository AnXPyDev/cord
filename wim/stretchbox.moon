Node = require "cord.wim.node"

class Stretchbox extends Node
	@__name: "cord.wim.stretchbox"

	new: (config, node) =>
		super(config, node)
		@node = node
	
	negotiate_size: (available) =>
		node\get_minimal_size

