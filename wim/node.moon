Object = require "cord.util.object"
Style = require "cord.wim.style"
Vector = require "cord.math.vector"

types = require "cord.util.types"
normalize = require "cord.util.normalize"
	
id_counter = 0

class Node extends Object
	defaults: {
		size: -> Vector(1, 1, "ratio")
		pos: -> Vector()
		visible: -> true
		hidden: -> false
		opacity: -> 1
		fake_parent_size: -> Vector(200, 200)
	}

	new: (config, ...) =>
		super!
		table.insert(@__name, "cord.wim.node")
	
		@id = id_counter
		id_counter += 1

		@identification = config.identification or config[2] or {config.class, config.label}
	
		@stylesheet = config.stylesheet or config.sheet or config[1]
		@style = @stylesheet and @stylesheet\get_mutable_style(@identification) or config.style or Style()
		@data = Style()
	
		@style.defaults = @defaults

		@parent = nil
		@children = {}
		@widget = nil

		@traits =  config.traits or config[3] or @style\get("traits") or {}

		for _, trait in pairs @traits
			trait\connect(self)	

		-- Create data
		@data\set("size", @style\get("size"))
		@data\set("pos", @style\get("pos"))
		@data\set("visible", @style\get("visible"))
		@data\set("hidden", @style\get("hidden"))
		@data\set("opacity", @style\get("opacity"))
		@data\set("parent_index", 0)
		@data\set("fake_parent_size", @style\get("fake_parent_size"))

		@stylizers = {}

		@\connect_signal("geometry_changed::inside", () ->
			for i, child in ipairs @children
				child\emit_signal("geometry_changed")
		)

		@\connect_signal("geometry_changed::local", () ->
			@\emit_signal("geometry_changed::inside")
		)

		@\connect_signal("geometry_changed", () ->
			@\emit_signal("geometry_changed::local")
			@parent and @parent\emit_signal("layout_changed")
		)

		@data\connect_signal("key_changed::hidden", () ->
			@parent and @parent\emit_signal("layout_changed")
		)

		@data\connect_signal("key_changed::pos", () ->
			@parent and types.match(@parent, "cord.wim.layout") and @parent\update_in_content(self)
		)

		@data\connect_signal("key_changed::size", () ->
			if @data\get("layout_size")
				@\emit_signal("geometry_changed::local")
			else
				@\emit_signal("geometry_changed")
		)
		
		@data\connect_signal("key_changed::layout_size", () ->
			@\emit_signal("geometry_changed")
		)

		@\connect_signal("parent_changed", () -> @\emit_signal("geometry_changed"))

		-- Gather children
		for i, child in ipairs {...}
			@\add_child(child)

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
			@\emit_signal("added_child", child, index)

	remove_child: (to_remove) =>
		for i, child in ipairs @children
			if child.id == to_remove.id
				table.remove(@children, i)
				@\emit_signal("removed_child", child, i)
	
	set_parent: (parent, index) =>
		if types.match(parent, "cord.wim.node") or parent == nil
			@\emit_signal("before_parent_change")
			@parent = parent
			@data\set("parent_index", index or 1)
			@\emit_signal("parent_changed")

	get_size: (scope = nil) =>
		if scope == "layout"
			return normalize.vector(@data\get("layout_size") or @data\get("size"), @parent and @parent\get_size! or @data\get("fake_parent_size"))
		return normalize.vector(@data\get("size"), @parent and @parent\get_size! or @data\get("fake_parent_size"))

return Node
