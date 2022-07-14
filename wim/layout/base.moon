wibox = require "wibox"

types = require "cord.util.types"
	
Node = require "cord.wim.node"
animation = require "cord.wim.animation"

class Layout extends Node
	@__name: "cord.wim.layout"

	new: (config, ...) =>
		super(config, ...)

		@_constructors_finished = 0

		@child_visibility_cache = {}

		@content = wibox.layout({
			layout: wibox.layout.manual
		})
		@widget = @content

		@\connect_signal("added_child", (child, index) -> 
			@\add_to_content(child,index)
		)
		@\connect_signal("removed_child", (child, index) -> @\remove_from_content(child,index))
		@\connect_signal("geometry_changed", () -> @\emit_signal("layout_changed"))
		@\connect_signal("layout_changed", () -> @\apply_layout!)

		@\connect_signal("constructor_finished", () ->
			@_constructors_finished += 1
			if @_constructors_finished == (#@@__lineage - 1)
				@\emit_signal("layout_changed")
		)

		for index, child in ipairs @children
			@\add_to_content(child, index)

		@\emit_signal("constructor_finished")

	add_to_content: (child, index = @\get_index(child)) =>
		child.widget.point = {x:0,y:0}
		@content\insert(index, child.widget)
		@\update_in_content(child, index)
		@child_visibility_cache[child.id] = child.data\get("visible")

	update_in_content: (child, index = @\get_index(child)) =>
		@content\move(index, child.data\get("pos")\to_primitive!)

	remove_from_content: (child, index = @\get_index(child)) =>
		@content\remove(index)

	apply_layout: () =>

	apply_for_child: (child, target_pos, visible) =>

		index = @\get_index(child)
		if not index then return
		child.data\set("visible", visible or true, true)
		last_visibility = @child_visibility_cache[child.id]
		current_visibility = child.data\get("visible")
		@child_visibility_cache[child.id] = current_visibility
		target_opacity = child.data\get("opacity")
		opacity_animation = child.style\get("opacity_animation") or animation.scalar(nil, 0)
		position_animation = child.style\get("position_animation") or animation.position(nil, 0)
		if current_visibility and not last_visibility
			opacity_animation = child.style\get("opacity_show_animation") or opacity_animation
			position_animation = child.style\get("position_show_animation") or position_animation
			target_opacity = 1
		elseif not current_visibility and last_visibility
			opacity_animation = child.style\get("opacity_hide_animation") or opacity_animation
			position_animation = child.style\get("position_hide_animation") or position_animation
			target_opacity = 0

		opacity_animation(child, "opacity", target_opacity, nil)
		position_animation(child, target_pos, nil, @\get_size!)
		

return Layout
