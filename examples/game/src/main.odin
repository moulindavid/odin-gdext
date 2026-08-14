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

	_ = roll_damage(self)
	text := gt.string_from_utf8(
		"Odin rolled damage and updated this Label. Press Space to roll again.",
	)
	defer gt.string_free(&text)
	gt.label_set_text(label, &text)
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
