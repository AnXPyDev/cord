require "moonscript"

cord = require "cord"

do -- test vector
  print("Testing vector")
  
  local vectors = {
    cord.math.vector(),
    cord.math.vector(5),
    cord.math.vector(10, 20)
  }

  print("index", "x", "y")
  for key, value in pairs(vectors) do
    print(key, value.x, value.y)
  end
end

do
  print("Testing log")

  cord.log("log test", {x = 5, y = {2, x = {y = 5, 1, 2, 3}}})
  
end
