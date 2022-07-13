Object = require "cord.util.object"

class Trait extends Object
	@__name: "cord.wim.trait"

	new: (...) =>
		super!

	connect: (node = @node) => nil
	disconnect: (node = @node) => nil

return Trait
