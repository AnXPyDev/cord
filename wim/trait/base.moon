Object = require "cord.util.object"

class Trait extends Object
	new: (...) =>
		super!
		table.insert(@__name, "cord.wim.trait")

	connect: (node = @node) => nil
	disconnect: (node = @node) => nil

return Trait
