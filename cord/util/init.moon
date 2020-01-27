crush = (require "cord.table").crush

return crush({
  margin: require "cord.util.margin"
  color: require "cord.util.color"
  pattern: require "cord.util.pattern"
  object: require "cord.util.object"
  shape: require "cord.util.shape"
  image: require "cord.util.image"
  normalize: require "cord.util.normalize"
  types: require "cord.util.types"
  callback_value: require "cord.util.callback_value"
}, (require "cord.util.base"))
