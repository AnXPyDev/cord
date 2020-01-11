local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local cord = require("cord")
local sheet = cord.wim.stylesheet()
sheet:add_style("box", nil, cord.wim.style({
  padding = cord.util.margin(10),
  background = "#FF0000",
  size = cord.math.vector(400)
}))
local container = cord.wim.container(sheet, "box")
local box = wibox({
  x = 0,
  y = 0,
  width = 0,
  height = 0,
  widget = container.widget,
  visible = true
})
