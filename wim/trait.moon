Object = require "cord.util.object"

class Trait extends Object
	@__name: "cord.wim.trait"

	new: (...) =>
		super!

	connect: (node) => nil
	disconnect: (node) => nil

return Trait
