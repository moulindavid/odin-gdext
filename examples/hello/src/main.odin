package hello

import gt "godot:godot"

HelloNodeData :: struct {
	object: gt.ObjectPtr,
	speed:  gt.GodotReal,
}

create_instance :: proc "c" (class_userdata: rawptr, notify_postinitialize: bool) -> gt.ObjectPtr {
	context = gt.godot_context()
	object := gt.construct_object(hello_parent_name)
	if object == nil do return nil

	self := new_clone(HelloNodeData{object = object, speed = 1.0})
	gt.attach_instance(object, hello_class_name, self, &hello_instance_binding_callbacks)
	return object
}

free_instance :: proc "c" (class_userdata: rawptr, instance: gt.ClassInstancePtr) {
	context = gt.godot_context()
	self, ok := gt.class_instance_data(instance, HelloNodeData)
	if !ok do return
	free(self)
}

roll_math :: proc "contextless" (self: ^HelloNodeData) -> gt.GodotReal {
	r := gt.randf() * 10.0
	wave := gt.sin(r) + gt.cos(r * 0.5)
	return (r * r + wave * 5.0) * self.speed
}

roll_math_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	self, self_ok := gt.class_instance_data(instance, HelloNodeData)
	if !self_ok do return 0, false
	return roll_math(self), true
}

get_speed_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	self, self_ok := gt.class_instance_data(instance, HelloNodeData)
	if !self_ok do return 0, false
	return self.speed, true
}

set_speed_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: gt.GodotReal,
) -> bool {
	self, self_ok := gt.class_instance_data(instance, HelloNodeData)
	if !self_ok do return false
	self.speed = value
	gt.object_emit_signal_1_godot_real(self.object, speed_changed_signal_name, value)
	return true
}

roll_math_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = roll_math_adapter_method,
}
get_speed_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = get_speed_adapter_method,
}
set_speed_method_adapter := gt.ClassMethodSetGodotRealAdapter {
	method = set_speed_adapter_method,
}

hello_name_data: gt.ClassName
parent_name_data: gt.ClassName
hello_class_name := gt.class_name_ptr(&hello_name_data)
hello_parent_name := gt.class_name_ptr(&parent_name_data)

empty_name_data: gt.StaticStringName
empty_name := gt.const_static_string_name_ptr(&empty_name_data)
empty_str_data: gt.String
empty_str := gt.const_string_ptr(&empty_str_data)

roll_math_method_name_data: gt.StaticStringName
roll_math_method_name := gt.const_static_string_name_ptr(&roll_math_method_name_data)
roll_math_return_info: gt.PropertyInfo
roll_math_method_info: gt.ClassMethodInfo

speed_property_name_data: gt.StaticStringName
speed_setter_name_data: gt.StaticStringName
speed_getter_name_data: gt.StaticStringName
speed_property_name := gt.const_static_string_name_ptr(&speed_property_name_data)
speed_setter_name := gt.const_static_string_name_ptr(&speed_setter_name_data)
speed_getter_name := gt.const_static_string_name_ptr(&speed_getter_name_data)
speed_property_storage: gt.ClassPrimitivePropertyStorage

speed_changed_signal_name_data: gt.StaticStringName
speed_changed_arg_name_data: gt.StaticStringName
speed_changed_signal_name := gt.const_static_string_name_ptr(&speed_changed_signal_name_data)
speed_changed_arg_name := gt.const_static_string_name_ptr(&speed_changed_arg_name_data)
speed_changed_arg_info: gt.PropertyInfo

hello_instance_binding_callbacks := gt.InstanceBindingCallbacks{}

init_registration_metadata :: proc() {
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&roll_math_method_name_data),
		cstring("roll_math"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&empty_name_data),
		cstring(""),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&speed_property_name_data),
		cstring("speed"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&speed_setter_name_data),
		cstring("set_speed"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&speed_getter_name_data),
		cstring("get_speed"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&speed_changed_signal_name_data),
		cstring("speed_changed"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&speed_changed_arg_name_data),
		cstring("value"),
	)
	gt.string_init_utf8(gt.uninitialized_string_ptr(&empty_str_data), "")
	member_defaults := gt.class_member_defaults(empty_name, empty_str)

	gt.init_method_property_info(
		&roll_math_return_info,
		gt.class_member_property(member_defaults, .Float, roll_math_method_name),
	)
	gt.init_method_property_info(
		&speed_changed_arg_info,
		gt.class_member_property(member_defaults, .Float, speed_changed_arg_name),
	)
}

register_classes :: proc() {
	context = gt.godot_context()
	gt.class_name_init_latin1_cstring(&hello_name_data, cstring("HelloNode"))
	gt.class_name_init_latin1_cstring(&parent_name_data, cstring("Node"))
	gt.init_class_bindings()
	init_registration_metadata()

	member_defaults := gt.class_member_defaults(empty_name, empty_str)
	speed_property := gt.class_property_godot_real(
		&speed_property_storage,
		gt.ClassTypedPropertyDescriptor {
			property = gt.class_member_property(
				member_defaults,
				.Float,
				speed_property_name,
				gt.PropertyUsageDefault,
			),
			getter_name = speed_getter_name,
			setter_name = speed_setter_name,
		},
		&get_speed_method_adapter,
		&set_speed_method_adapter,
	)
	methods := [3]gt.OdinClassMethod {
		{
			info = &roll_math_method_info,
			descriptor = gt.ClassMethodDescriptor {
				name = roll_math_method_name,
				method_userdata = &roll_math_method_adapter,
				call_func = gt.class_method_get_godot_real_call,
				ptrcall_func = gt.class_method_get_godot_real_ptrcall,
				return_value_info = &roll_math_return_info,
				return_value_metadata = .None,
			},
		},
		speed_property.getter,
		speed_property.setter,
	}
	properties := [1]gt.OdinClassProperty{speed_property.property}
	signals := [1]gt.OdinClassSignal {
		{
			descriptor = gt.ClassSignalDescriptor {
				name = speed_changed_signal_name,
				argument_info = &speed_changed_arg_info,
				argument_count = 1,
			},
		},
	}

	gt.register_odin_class(
		gt.OdinClassDescriptor {
			class_name = hello_class_name,
			parent_class_name = hello_parent_name,
			create_instance_func = create_instance,
			free_instance_func = free_instance,
			methods = methods[:],
			properties = properties[:],
			signals = signals[:],
		},
	)
	gt.debug_print("[odin-gdext] HelloNode registered")
}

@(export)
hello_library_init :: proc "c" (
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
	gt.unregister_class(hello_class_name)
	gt.string_free(&empty_str_data)
	gt.debug_print("[odin-gdext] HelloNode unregistered")
}
