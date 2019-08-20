require "moonscript"

cord = require "cord"

do -- test vector
  print("**Testing vector\n")
  
  local vectors = {
    cord.math.vector(),
    cord.math.vector(5),
    cord.math.vector(10, 20)
  }

  print("index", "x", "y")
  for key, value in pairs(vectors) do
    print(key, value.x, value.y)
  end

  print("\n**End of vector test\n")
end

do
  print("**Testing log\n")

  cord.log("log test", "testing", "testing", "attention", "please", {x = 5, y = {2, x = {y = 5, 1, 2, 3}}})

  print("\n**End of log test\n")
end

do
  print("**Testing fuzzy char distance\n")

  cord.log(cord.string.fuzzy.character("test", "test"))
  cord.log(cord.string.fuzzy.character("tess", "test"))
  cord.log(cord.string.fuzzy.character("nigg", "test"))

  print("\n**End of fuzzy char distance test\n")
end

do
  print("**Testing fuzzy word\n")

  cord.log(cord.string.fuzzy.word("test", "test"))
  cord.log(cord.string.fuzzy.word("tess", "test"))

  print("\n**End of fuzzy word test\n")
end

do
  print("**Testing object\n")

  local obj = cord.object()
  local log = cord.log

  local sig1 = function() log("signal 1") end
  local wsig1 = function() log("weak signal 1") end

  local sig2 = function() log("signal 2") end
  local wsig2 = function() log("weak signal 2") end

  obj:connect_signal("test", sig1)
  obj:weak_connect_signal("test", wsig1)

  obj:emit_signal("test")

  obj:connect_signal("test", sig2)
  obj:weak_connect_signal("test", wsig2)

  obj:emit_signal("test")

  obj:disconnect_signal("test", sig1)
  obj:weak_disconnect_signal("test", wsig1)

  obj:emit_signal("test")

  print("\n**End of object test\n")
  
end

do
  print("\n**Testing table")
  local log = cord.log
  local example = {
    x = {1,2,3}
  }
  
  local example_copy = cord.table.deep_copy(example)

  log(example)
  example.x[1] = "69 lol"
  log(example)
  log(example_copy)
  cord.table.deep_crush(example_copy, example)
  log(example_copy)
  
  
  print("\n**End of table test")
end
