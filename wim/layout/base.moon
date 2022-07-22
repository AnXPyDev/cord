wibox = require "wibox"

types = require "cord.util.types"
	
Node = require "cord.wim.node"
animation = require "cord.wim.animation"

class Layout extends Node
	@__name: "cord.wim.layout"

	new: (config, ...) =>
		super(config, ...)

		--@_constructors_finished = 0

		@content = wibox.layout({
			layout: wibox.layout.manual
		})
		@widget = @content

		@\connect_signal("added_child::priority", (child, index) ->
			@\add_to_content(child,index)
		)

		@\connect_signal("removed_child", (child, index) -> @\remove_from_content(child,index))
		@\connect_signal("geometry_changed", () -> @\emit_signal("layout_changed"))
		@\connect_signal("layout_changed", () -> @\apply_layout!)

		for index, child in ipairs @children
			@\add_to_content(child, index)

	add_to_content: (child, index = @\get_index(child)) =>
		child.widget.point = {x:0,y:0}
		@content\insert(index, child.widget)
		@\update_in_content(child, index)

	update_in_content: (child, index = @\get_index(child), pos) =>
		@content\move(index, pos and pos\to_primitive! or child.data\get("pos")\to_primitive!)

	remove_from_content: (child, index = @\get_index(child)) =>
		@content\remove(index)

	apply_layout: () =>

return Layout
