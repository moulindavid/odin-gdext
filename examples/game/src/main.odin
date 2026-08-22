package game

import gt "godot:godot"

GameBrain :: distinct gt.ObjectPtr

GameBrainData :: struct {
	object:     gt.ObjectPtr,
	difficulty: gt.GodotReal,
}

game_brain_object :: proc "contextless" (self: GameBrain) -> gt.ObjectPtr {
	return gt.ObjectPtr(self)
}

game_brain_from_instance :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: GameBrain,
	ok: bool,
) {
	data, data_ok := gt.class_instance_data(instance, GameBrainData)
	if !data_ok do return {}, false
	return GameBrain(data.object), true
}

create_instance :: proc "c" (class_userdata: rawptr, notify_postinitialize: bool) -> gt.ObjectPtr {
	context = gt.godot_context()
	object := gt.construct_object(game_parent_name)
	if object == nil do return nil

	self := new_clone(GameBrainData{object = object, difficulty = 1.0})
	gt.attach_instance(object, game_class_name, self, &game_instance_binding_callbacks)
	return object
}

free_instance :: proc "c" (class_userdata: rawptr, instance: gt.ClassInstancePtr) {
	context = gt.godot_context()
	self, ok := gt.class_instance_data(instance, GameBrainData)
	if !ok do return
	free(self)
}

roll_damage :: proc "contextless" (self: ^GameBrainData) -> gt.GodotReal {
	base := 6.0 + gt.randf() * 12.0
	wave := gt.sin(base) + gt.cos(base * 0.5)
	value := (base + wave) * self.difficulty
	gt.object_emit_signal_1_godot_real(self.object, damage_rolled_signal_name, value)
	return value
}

roll_damage_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return 0, false
	return roll_damage(self), true
}

get_difficulty_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return 0, false
	return self.difficulty, true
}

set_difficulty_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: gt.GodotReal,
) -> bool {
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return false
	self.difficulty = value
	return true
}

roll_into_label_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	object: gt.ObjectPtr,
) -> bool {
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return false
	label, label_ok := gt.object_ptr_try_as_label(object)
	if !label_ok do return false

	damage := roll_damage(self)
	label_node := gt.label_as_node(label)

	if input, input_ok := gt.input_singleton_checked(); input_ok {
		accept_action := gt.string_name_from_utf8_cstring(cstring("ui_accept"))
		defer gt.string_name_free(&accept_action)
		if gt.input_is_action_pressed_default(input, &accept_action) {
			damage += 5
		}
		_ = gt.input_get_action_strength_default(input, &accept_action)
		_ = gt.input_get_last_mouse_velocity(input)
	}

	tree := gt.node_get_tree(label_node)
	if !gt.scene_tree_is_nil(tree) {
		_ = gt.scene_tree_get_node_count(tree)
		_ = gt.scene_tree_get_frame(tree)
		_ = gt.scene_tree_get_current_scene(tree)
		group_name := gt.string_name_from_utf8_cstring(cstring("odin_gameplay"))
		defer gt.string_name_free(&group_name)
		group_nodes := gt.scene_tree_get_nodes_in_group(tree, &group_name)
		gt.typed_array_free(&group_nodes)
	}

	parent := gt.node_get_parent(label_node)
	if !gt.node_is_nil(parent) {
		timer_path := gt.node_path_from_utf8("RollTimer")
		timer, timer_ok := gt.node_get_node_as_timer(parent, &timer_path)
		gt.node_path_free(&timer_path)
		if timer_ok {
			gt.timer_set_wait_time(timer, 0.5)
			gt.timer_set_one_shot(timer, true)
			gt.timer_start_default(timer)
		}

		area_path := gt.node_path_from_utf8("DamageArea")
		area, area_ok := gt.node_get_node_as_area2d(parent, &area_path)
		gt.node_path_free(&area_path)
		if area_ok {
			gt.area2d_set_monitoring(area, true)
			gt.area2d_set_monitorable(area, true)
			gt.area2d_set_gravity(area, damage)
			gt.area2d_set_priority(area, 1)
		}
	}

	text := gt.string_from_utf8(
		"Odin read Input and SceneTree, rolled damage, updated this Label, armed a Timer, and configured an Area2D.",
	)
	defer gt.string_free(&text)
	gt.label_set_text(label, &text)
	gt.label_set_horizontal_alignment(label, .horizontal_alignment_center)
	gt.label_set_visible_ratio(label, 1)

	control := gt.label_as_control(label)
	gt.control_set_position_default(control, gt.Vector2{24, 24})
	gt.control_set_size_default(control, gt.Vector2{720, 64})

	canvas_item := gt.label_as_canvas_item(label)
	red := f32(0.35 + gt.sin(damage) * 0.15)
	green := f32(0.55 + gt.cos(damage * 0.5) * 0.20)
	gt.canvas_item_set_modulate(canvas_item, gt.Color{red, green, 1.0, 1.0})
	gt.canvas_item_set_z_index(canvas_item, 1)
	gt.canvas_item_queue_redraw(canvas_item)
	return true
}

roll_damage_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = roll_damage_adapter_method,
}
get_difficulty_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = get_difficulty_adapter_method,
}
set_difficulty_method_adapter := gt.ClassMethodSetGodotRealAdapter {
	method = set_difficulty_adapter_method,
}
roll_into_label_method_adapter := gt.ClassMethodSetObjectPtrAdapter {
	method = roll_into_label_adapter_method,
}

game_name_data: gt.ClassName
game_parent_name_data: gt.ClassName
game_class_name := gt.class_name_ptr(&game_name_data)
game_parent_name := gt.class_name_ptr(&game_parent_name_data)

empty_name_data: gt.StaticStringName
empty_name := gt.const_static_string_name_ptr(&empty_name_data)
empty_str_data: gt.String
empty_str := gt.const_string_ptr(&empty_str_data)

roll_damage_method_name_data: gt.StaticStringName
roll_damage_method_name := gt.const_static_string_name_ptr(&roll_damage_method_name_data)
roll_damage_return_info: gt.PropertyInfo
roll_damage_method_info: gt.ClassMethodInfo
roll_into_label_method_name_data: gt.StaticStringName
roll_into_label_arg_name_data: gt.StaticStringName
roll_into_label_method_name := gt.const_static_string_name_ptr(&roll_into_label_method_name_data)
roll_into_label_arg_name := gt.const_static_string_name_ptr(&roll_into_label_arg_name_data)
roll_into_label_arg_info: gt.PropertyInfo
roll_into_label_arg_meta := [1]gt.ClassMethodArgumentMetadata{.None}
roll_into_label_method_info: gt.ClassMethodInfo

difficulty_property_name_data: gt.StaticStringName
difficulty_setter_name_data: gt.StaticStringName
difficulty_getter_name_data: gt.StaticStringName
difficulty_property_name := gt.const_static_string_name_ptr(&difficulty_property_name_data)
difficulty_setter_name := gt.const_static_string_name_ptr(&difficulty_setter_name_data)
difficulty_getter_name := gt.const_static_string_name_ptr(&difficulty_getter_name_data)
difficulty_property_info: gt.PropertyInfo
difficulty_get_return_info: gt.PropertyInfo
difficulty_set_arg_info: gt.PropertyInfo
difficulty_set_arg_meta := [1]gt.ClassMethodArgumentMetadata{.None}
difficulty_get_method_info: gt.ClassMethodInfo
difficulty_set_method_info: gt.ClassMethodInfo

damage_rolled_signal_name_data: gt.StaticStringName
damage_rolled_arg_name_data: gt.StaticStringName
damage_rolled_signal_name := gt.const_static_string_name_ptr(&damage_rolled_signal_name_data)
damage_rolled_arg_name := gt.const_static_string_name_ptr(&damage_rolled_arg_name_data)
damage_rolled_arg_info: gt.PropertyInfo

game_instance_binding_callbacks := gt.InstanceBindingCallbacks{}

register_methods :: proc() {
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&roll_damage_method_name_data),
		cstring("roll_damage"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&roll_into_label_method_name_data),
		cstring("roll_into_label"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&roll_into_label_arg_name_data),
		cstring("label"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&empty_name_data),
		cstring(""),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&difficulty_property_name_data),
		cstring("difficulty"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&difficulty_setter_name_data),
		cstring("set_difficulty"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&difficulty_getter_name_data),
		cstring("get_difficulty"),
	)
	gt.string_init_utf8(gt.uninitialized_string_ptr(&empty_str_data), "")

	gt.init_method_property_info(
		&roll_damage_return_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = roll_damage_method_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_method_with_descriptor(
		game_class_name,
		&roll_damage_method_info,
		gt.ClassMethodDescriptor {
			name = roll_damage_method_name,
			method_userdata = &roll_damage_method_adapter,
			call_func = gt.class_method_get_godot_real_call,
			ptrcall_func = gt.class_method_get_godot_real_ptrcall,
			return_value_info = &roll_damage_return_info,
			return_value_metadata = .None,
		},
	)

	gt.init_method_property_info(
		&roll_into_label_arg_info,
		gt.MethodPropertyDescriptor {
			type = .Object,
			name = roll_into_label_arg_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_method_with_descriptor(
		game_class_name,
		&roll_into_label_method_info,
		gt.ClassMethodDescriptor {
			name = roll_into_label_method_name,
			method_userdata = &roll_into_label_method_adapter,
			call_func = gt.class_method_set_object_ptr_call,
			ptrcall_func = gt.class_method_set_object_ptr_ptrcall,
			argument_count = 1,
			arguments_info = &roll_into_label_arg_info,
			arguments_metadata = &roll_into_label_arg_meta[0],
		},
	)

	gt.init_method_property_info(
		&difficulty_get_return_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = difficulty_property_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_method_with_descriptor(
		game_class_name,
		&difficulty_get_method_info,
		gt.ClassMethodDescriptor {
			name = difficulty_getter_name,
			method_userdata = &get_difficulty_method_adapter,
			call_func = gt.class_method_get_godot_real_call,
			ptrcall_func = gt.class_method_get_godot_real_ptrcall,
			return_value_info = &difficulty_get_return_info,
			return_value_metadata = .None,
		},
	)

	gt.init_method_property_info(
		&difficulty_set_arg_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = difficulty_property_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_method_with_descriptor(
		game_class_name,
		&difficulty_set_method_info,
		gt.ClassMethodDescriptor {
			name = difficulty_setter_name,
			method_userdata = &set_difficulty_method_adapter,
			call_func = gt.class_method_set_godot_real_call,
			ptrcall_func = gt.class_method_set_godot_real_ptrcall,
			argument_count = 1,
			arguments_info = &difficulty_set_arg_info,
			arguments_metadata = &difficulty_set_arg_meta[0],
		},
	)
}

register_properties :: proc() {
	gt.register_class_property_with_descriptor(
		game_class_name,
		&difficulty_property_info,
		gt.ClassPropertyDescriptor {
			property = gt.MethodPropertyDescriptor {
				type = .Float,
				name = difficulty_property_name,
				class_name = empty_name,
				hint_string = empty_str,
				usage = gt.PropertyUsageDefault,
			},
			setter = difficulty_setter_name,
			getter = difficulty_getter_name,
		},
	)
}

register_signals :: proc() {
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&damage_rolled_signal_name_data),
		cstring("damage_rolled"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&damage_rolled_arg_name_data),
		cstring("value"),
	)
	gt.init_method_property_info(
		&damage_rolled_arg_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = damage_rolled_arg_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_signal_with_descriptor(
		game_class_name,
		gt.ClassSignalDescriptor {
			name = damage_rolled_signal_name,
			argument_info = &damage_rolled_arg_info,
			argument_count = 1,
		},
	)
}

register_classes :: proc() {
	context = gt.godot_context()
	gt.class_name_init_latin1_cstring(&game_name_data, cstring("GameBrain"))
	gt.class_name_init_latin1_cstring(&game_parent_name_data, cstring("Node"))
	gt.init_class_bindings()

	gt.register_editor_visible_class(
		gt.EditorVisibleClassDescriptor {
			class_name = game_class_name,
			parent_class_name = game_parent_name,
			create_instance_func = create_instance,
			free_instance_func = free_instance,
		},
	)

	register_methods()
	register_properties()
	register_signals()
	gt.debug_print("[odin-gdext] GameBrain registered")
}

@(export)
game_library_init :: proc "c" (
	get_proc_address: gt.InterfaceGetProcAddress,
	library: gt.ClassLibraryPtr,
	initialization: ^gt.Initialization,
) -> bool {
	gt.init(library, get_proc_address)

	initialization.initialize = initialize_module
	initialization.deinitialize = deinitialize_module
	initialization.minimum_initialization_level = .Scene
	initialization.userdata = nil
	return true
}

initialize_module :: proc "c" (user_data: rawptr, level: gt.InitializationLevel) {
	context = gt.godot_context()
	if level != .Scene do return
	register_classes()
}

deinitialize_module :: proc "c" (user_data: rawptr, level: gt.InitializationLevel) {
	context = gt.godot_context()
	if level != .Scene do return
	gt.unregister_class(game_class_name)
	gt.string_free(&empty_str_data)
	gt.debug_print("[odin-gdext] GameBrain unregistered")
}
