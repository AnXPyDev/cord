Object = require "cord.object"

class Node extends Object
  new: (args) =>
    super!
    @class = args.class or "none"
    @id = args.id or "none"
    @style = {}
    @features = {}
