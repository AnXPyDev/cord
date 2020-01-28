wibox = require "wibox"
gears = require "gears"
awful = require "awful"
beautiful = require "beautiful"

cord = require "cord"


sheet = cord.wim.stylesheet()

sheet\add_style({"box"}, cord.wim.style({
  padding: cord.util.margin(10)
  background: "#FFFFFF"
  foreground: "#000000"
  size: cord.math.vector(1, 0.5, "percentage")
  shape: cord.util.shape.rectangle(20)
  position_show_animation: cord.wim.animation.position.lerp_from_edge
  position_animation: cord.wim.animation.position.lerp
  position_animation_speed: 0.2
  opacity_animation: cord.wim.animation.opacity.jump
  opacity_animation_speed: 0.01
  color_lerp_animation_speed: 0.3
  margin_lerp_animation_speed: 0.3
}))

sheet\add_style({"box", "container2"}, cord.wim.style({
  size: cord.math.vector(1, 0.5, "percentage")
  background: "#FF4444"
  hover_background: "#FF6666"
  hover_padding: cord.util.margin(15)
  margin: cord.util.margin(10)
  hidden: true
}), {{"box"}})

sheet\add_style({"box", "container3"}, cord.wim.style({
  size: cord.math.vector(1, 0.5, "percentage")
  background: "#FF4444"
  hover_background: "#FF6666"
  hover_padding: cord.util.margin(15)
  margin: cord.util.margin(10)
  hidden: true
}), {{"box"}})

sheet\add_style({"textbox"}, cord.wim.style({
  halign: "center"
  valign: "center"
  font_name: "Mono"
  font_size: 30
  visible: true
}))

sheet\add_style({"imagebox"}, cord.wim.style({
  color: "#000000"
}))

sheet\add_style({"box", "main"}, cord.wim.style({
  padding: cord.util.margin(0)
  size: cord.math.vector(1, 1, "percentage")
  background: "#FFFFFF"
  visible: true
}), {{"box"}})

sheet\add_style({"nodebox"}, cord.wim.style({
  size: cord.math.vector(400, 300)
  visible: true
}))

textbox1 = cord.wim.textbox(sheet, {"textbox"}, "text 1")
textbox2 = cord.wim.textbox(sheet, {"textbox"}, "text 2")
container2 = cord.wim.container(sheet, {"box", "container2"}, textbox1)
container3 = cord.wim.container(sheet, {"box", "container3"}, textbox2)
layout = cord.wim.layout.fit(sheet, {"layout"}, container2, container3)
container = cord.wim.container(sheet, {"box", "main"}, layout)
box = cord.wim.nodebox(sheet, {"nodebox"}, container)

for i, cont in ipairs {container2, container3}
  cont.data\set("hidden", false)

  cont\connect_signal("mouse_enter", () ->
    cord.wim.animation.color.lerp(cont, nil, cont.style\get("hover_background"), "background")
    cord.wim.animation.margin.lerp(cont, nil, cont.style\get("hover_padding"), "padding")
  )

  cont\connect_signal("mouse_leave", () ->
    cord.wim.animation.color.lerp(cont, nil, cont.style\get("background"), "background")
    cord.wim.animation.margin.lerp(cont, nil, cont.style\get("padding"), "padding")
  )
