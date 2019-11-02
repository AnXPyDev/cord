crush = (require "gears.table").crush

return crush({
  margin: require "cord.util.margin",
  color: require "cord.util.color",
  pattern: require "cord.util.pattern",
  object: require "cord.util.object",
  shape: require "cord.util.shape",
  image: require "cord.util.image"
}, require "cord.util.base")
