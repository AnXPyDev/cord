Object = require "cord.util.object"
Style = require "cord.wim.style"
DataStore = require "cord.util.data_store"
Vector = require "cord.math.vector"

types = require "cord.util.types"
normalize = require "cord.util.normalize"
	
id_counter = 0

class Node extends Object
	@__name: "cord.wim.node"

	defaults: {
		size: Vector(1, 1, "ratio")
		min_size: Vector(0, 0)
		max_size: Vector(math.huge, math.huge)
		pos: Vector()
		visible: true
		opacity: 1
		flexible: false
		size_priority: 1
		layout_align: "center"
		layout_justify: "center"
		fake_parent_size: Vector(200, 200)
	}

	new: (config, ...) =>
		super!
	
		@id = id_counter
		id_counter += 1

		@identification = config.identification or config[2] or {config.category, config.label}
	
		@stylesheet = config.stylesheet or config.sheet or config[1]
		@style = @stylesheet and @stylesheet\get_mutable_style(@identification)

		if config.style
			@style and config.style\add_parent(@style)
			@style = config.style
		if not @style
			@style = Style()

		@style\set_defaults(@defaults)
		@data = DataStore!
	

		@parent = nil
		@children = {}
		@widget = nil

		@traits =  config.traits or config[3] or @style\get("traits") or {}

		for _, trait in pairs @traits
			trait\connect(self)

		-- Create data
		@data\set("size", @style\get("size"))
		@data\set("preferred_size", @style\get_no_default("preferred_size") or @data.values["size"])
		@data\set("preferred_visible", @style\get_no_default("preferred_visible") or @data.values["visible"])
		@data\set("preferred_opacity", @style\get_no_default("preferred_opacity") or @data.values["opacity"])
		@data\set("min_size", @style\get_no_default("min_size"))
		@data\set("max_size", @style\get_no_default("max_size"))
		@data\set("pos", @style\get("pos"))
		@data\set("visible", @style\get("visible"))
		@data\set("opacity", @style\get("opacity"))
		@data\set("parent_index", 0)
		@data\set("fake_parent_size", @style\get("fake_parent_size"))

		@stylizers = {}

		@\connect_signal("geometry_changed::local", () ->
			for i, child in ipairs @children
				child\emit_signal("geometry_changed")
		)

		@\connect_signal("geometry_changed", () ->
			@\emit_signal("geometry_changed::local")
			@\emit_signal("geometry_changed::layout")
		)

		@\connect_signal("geometry_changed::layout", ->
			@parent and @parent\emit_signal("layout_changed")
		)

		@data\connect_signal("updated::visible", () ->
			@parent and @parent\emit_signal("layout_changed")
		)
		
		@data\connect_signal("updated::preferred_visible", () ->
			@parent and @parent\emit_signal("layout_changed")
		)
		
		@update_layout_pos = () => nil

		@data\connect_signal("updated::pos", (pos) ->
			@\update_layout_pos(pos)
		)

		@data\connect_signal("updated::size", () ->
			if @data\get("layout_size")
				@\emit_signal("geometry_changed::local")
			else
				@\emit_signal("geometry_changed")
		)
		
		@data\connect_signal("updated::layout_size", () ->
			@\emit_signal("geometry_changed::layout")
		)
		
		-- TODO check if layout update is required
		@data\connect_signal("updated::min_size", -> @data\get("flexible") and @\emit_signal("geometry_changed::layout"))
		@data\connect_signal("updated::max_size", -> @data\get("flexible") and @\emit_signal("geometry_changed::layout"))
		@data\connect_signal("updated::preferred_size", -> @data\get("flexible") and @\emit_signal("geometry_changed::layout"))

		@\connect_signal("parent_changed", () -> @\emit_signal("geometry_changed"))

		-- Gather children
		for i, child in ipairs {...}
			@\add_child(child)

	propagate: (signal_name, ...) =>
		@\emit_signal(signal_name, ...)
		for i, child in ipairs @parent
			child\propagate(signal_name, ...)

	request_property: (name, default) =>
		if not @data\get(name)
			@data\set(name, @style\get(name) or default)

	stylize: (...) =>
		if #{...} == 0
			for k, stylizer in pairs @stylizers
				stylizer(self)
		for i, name in ipairs {...}
			@stylizers[name] and @stylizers[name](self)
		@widget and @widget\emit_signal("widget::redraw_needed")

	add_child: (child, index = #@children + 1) =>
		if types.match(child, "cord.wim.node")
			table.insert(@children, index, child)
			child\set_parent(self, index)
			@\emit_signal("added_child::priority", child, index)
			@\emit_signal("added_child", child, index)

	remove_child: (to_remove) =>
		for i, child in ipairs @children
			if child.id == to_remove.id
				table.remove(@children, i)
				@\emit_signal("removed_child", child, i)

	get_index: (node) =>
		for i, child in ipairs @children
			if child == node
				return i

	set_parent: (parent, index) =>
		unless types.match(parent, "cord.wim.node")
			return

		@\emit_signal("before_parent_change")
		@parent = parent
		if @style_parent_index
			@style.parents[@style_parent_index] = @parent.style
		else
			table.insert(@style.parents, @parent.style)
			@style_parent_index = #@style.parents

		if types.match(parent, "cord.wim.layout")
			@update_layout_pos = (pos) =>
				@parent\update_in_content(self, nil, pos)
		else
			@update_layout_pos = () =>

		@data\set("parent_index", index or 1)
		@\mute_signal("geometry_changed::layout")
		@\emit_signal("parent_changed")
		@\unmute_signal("geometry_changed::layout")

	normalize_size: (size) =>
		return normalize.vector(size, @parent and @parent\get_size! or @data\get("fake_parent_size"))

	get_size: (scope = nil) =>
		if scope == "layout"
			return @normalize_size(@data\get("layout_size"))
		return @normalize_size(@data\get("size"))

	set_size: (size) =>
		csize = @data\get("size")

		if csize.x == size.x and csize.y == size.y
			return

		if anim = @style\get("size_animation")
			anim(self, size)
			return

		@data\set("size", size)

	set_pos: (pos) =>
		unless canim = @data\get("active_animation::pos")
			@data\set("target_pos", nil)
		
		cpos = @data\get("target_pos") or @data\get("pos")
		if cpos.x == pos.x and cpos.y == pos.y
			@data\update("pos")
			return

		if anim = @style\get("position_animation")
			@data\set("target_pos", pos)
			a = anim(self, pos)
			return

		@data\set("pos", pos)

	set_visible: (visible) =>
		if visible == @data\get("visible")
			return

		@data\set("visible", visible)

		if anim = @style\get("opacity_animation")
			anim(self, "opacity", visible and @data\get("preferred_opacity") or 0)
			return
		
		@data\set("opacity", @data\get("preferred_opacity"))


return Node
