wibox = require "wibox"
gears = require "gears"
awful = require "awful"
beautiful = require "beautiful"

cord = require "cord"


sheet = cord.wim.stylesheet()

sheet\add_style({"box"}, cord.wim.style({
  padding: cord.util.margin(25)
  background: "#FF0000"
  size: cord.math.vector(1, 1, "percentage")
  shape: cord.util.shape.rectangle(20)
}))

sheet\add_style({"box", "main"}, cord.wim.style({
  size: cord.math.vector(400)
  background: "#00FF00"
}), {{"box"}})

container = cord.wim.container(sheet, {"box", "main"}, cord.wim.container(sheet, {"box"}))

box = wibox({
  x: 0
  y: 0
  width: 400
  height: 400
  widget: container.widget
  visible: true
  bg: "#FFFFFF"
})
