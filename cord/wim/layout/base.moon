wibox = require "wibox"

types = require "cord.util.types"
	
Node = require "cord.wim.node"
animation = require "cord.wim.animation"

class Layout extends Node
	new: (config, ...) =>
		super(config, ...)
		table.insert(@__name, "cord.wim.layout")

		@child_visibility_cache = {}

		@content = wibox.layout({
			layout: wibox.layout.manual
		})
		@widget = @content

		@\connect_signal("added_child", (child, index) -> @\add_to_content(child,index))
		@\connect_signal("removed_child", (child, index) -> @\remove_from_content(child,index))
		@\connect_signal("geometry_changed", () -> @\emit_signal("layout_changed"))
		@\connect_signal("layout_changed", () -> @\apply_layout!)

		@widget_children = {}
		
		for i, child in ipairs @children
			if not types.match(child, "cord.wim.nodebox") and not types.match(child, "cord.wim.screen")
				table.insert(@widget_children, child)
				@\add_to_content(child)

	get_index: (node) =>
		if types.match(node, "cord.wim.nodebox") or types.match(node, "cord.wim.screen")
			return
		for i, child in ipairs @widget_children
			if node == child
				return i

	add_to_content: (child) =>
		index = @\get_index(child)
		if not index then return
		child.widget.point = {x:0,y:0}
		@content\insert(index, child.widget)
		@\update_in_content(child, index)
		@child_visibility_cache[child.id] = child.data\get("visible")

	update_in_content: (child) =>
		index = @\get_index(child)
		if not index then return
		@content\move(index, child.data\get("pos")\to_primitive!)

	remove_from_content: (child) =>
		index = @\get_index(child)
		if not index then return
		@content\remove(index)

	apply_layout: () =>

	apply_for_child: (child, target_pos, visible) =>
		index = @\get_index(child)
		if not index then return
		child.data\set("visible", visible, true)
		last_visibility = @child_visibility_cache[child.id]
		current_visibility = child.data\get("visible") and not child.data\get("hidden")
		@child_visibility_cache[child.id] = current_visibility
		target_opacity = child.data\get("opacity")
		opacity_animation = child.style\get("opacity_animation") or animation.opacity.jump
		position_animation = child.style\get("position_animation") or animation.position.jump
		if current_visibility and not last_visibility
			opacity_animation = child.style\get("opacity_show_animation") or opacity_animation
			position_animation = child.style\get("position_show_animation") or position_animation
			target_opacity = 1
		elseif not current_visibility and last_visibility
			opacity_animation = child.style\get("opacity_hide_animation") or opacity_animation
			position_animation = child.style\get("position_hide_animation") or position_animation
			target_opacity = 0
		opacity_animation(child, nil, target_opacity, () -> child.data\update("visible"))
		position_animation(child, nil, target_pos, @\get_size!)
		

return Layout
