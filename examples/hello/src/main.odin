package hello

import gt "godot:godot"

HelloNodeData :: struct {
	object: gt.ObjectPtr,
	speed:  gt.GodotReal,
}

hello_names: gt.ClassRegistrationNames
hello_class_name := gt.class_registration_class_name(&hello_names)
hello_parent_name := gt.class_registration_parent_name(&hello_names)

empty_name_data: gt.RegistrationStringName
empty_name := gt.registration_string_name_mut_ptr(&empty_name_data)
empty_hint_data: gt.RegistrationString
empty_hint := gt.registration_string_mut_ptr(&empty_hint_data)

roll_math_name_data: gt.RegistrationStringName
roll_math_name := gt.registration_string_name_mut_ptr(&roll_math_name_data)
roll_math_method_storage: gt.ClassFixedMethodStorage
roll_math_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = roll_math_adapter_method,
}

speed_name_data: gt.RegistrationStringName
speed_getter_name_data: gt.RegistrationStringName
speed_setter_name_data: gt.RegistrationStringName
speed_name := gt.registration_string_name_mut_ptr(&speed_name_data)
speed_getter_name := gt.registration_string_name_mut_ptr(&speed_getter_name_data)
speed_setter_name := gt.registration_string_name_mut_ptr(&speed_setter_name_data)
speed_property_storage: gt.ClassPrimitivePropertyStorage
get_speed_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = get_speed_adapter_method,
}
set_speed_method_adapter := gt.ClassMethodSetGodotRealAdapter {
	method = set_speed_adapter_method,
}

speed_changed_name_data: gt.RegistrationStringName
speed_changed_value_name_data: gt.RegistrationStringName
speed_changed_name := gt.registration_string_name_ptr(&speed_changed_name_data)
speed_changed_value_name := gt.registration_string_name_mut_ptr(&speed_changed_value_name_data)
speed_changed_storage: gt.ClassSignalStorage

hello_instance_binding_callbacks := gt.InstanceBindingCallbacks{}

create_instance :: proc "c" (class_userdata: rawptr, notify_postinitialize: bool) -> gt.ObjectPtr {
	context = gt.godot_context()
	_ = class_userdata
	_ = notify_postinitialize

	object := gt.construct_object(hello_parent_name)
	if object == nil do return nil

	self := new_clone(HelloNodeData{object = object, speed = 1.0})
	gt.attach_typed_instance(object, hello_class_name, self, &hello_instance_binding_callbacks)
	return object
}

free_instance :: proc "c" (class_userdata: rawptr, instance: gt.ClassInstancePtr) {
	context = gt.godot_context()
	_ = class_userdata

	self, ok := gt.class_instance_data(instance, HelloNodeData)
	if !ok do return
	free(self)
}

hello_ready :: proc(instance: gt.ClassInstancePtr, node: gt.Node, reversed: bool) {
	_ = reversed
	_, ok := gt.class_instance_data(instance, HelloNodeData)
	if !ok do return

	gt.debug_print("HelloNode ready from Odin")
	_ = gt.node_enable_process_callback(node)
}

hello_process :: proc(
	instance: gt.ClassInstancePtr,
	node: gt.Node,
	delta: gt.GodotReal,
	reversed: bool,
) {
	_ = reversed
	self, ok := gt.class_instance_data(instance, HelloNodeData)
	if !ok do return

	self.speed += delta
	gt.object_emit_signal_1_godot_real(self.object, speed_changed_name, self.speed)
	_ = gt.node_disable_process_callback(node)
}

hello_virtuals := gt.NodeVirtualCallbackDescriptor {
	ready   = hello_ready,
	process = hello_process,
}

notification_instance :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	context = gt.godot_context()
	self, ok := gt.class_instance_data(instance, HelloNodeData)
	if !ok do return

	node, node_ok := gt.object_ptr_try_as_node(self.object)
	if !node_ok do return
	if gt.dispatch_node_virtual_descriptor(instance, node, what, reversed, &hello_virtuals) do return
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
	gt.object_emit_signal_1_godot_real(self.object, speed_changed_name, value)
	return true
}

init_registration_metadata :: proc() {
	gt.registration_string_name_init_latin1_cstring(&empty_name_data, cstring(""))
	gt.registration_string_init_utf8(&empty_hint_data, "")
	gt.registration_string_name_init_latin1_cstring(&roll_math_name_data, cstring("roll_math"))
	gt.registration_string_name_init_latin1_cstring(&speed_name_data, cstring("speed"))
	gt.registration_string_name_init_latin1_cstring(&speed_getter_name_data, cstring("get_speed"))
	gt.registration_string_name_init_latin1_cstring(&speed_setter_name_data, cstring("set_speed"))
	gt.registration_string_name_init_latin1_cstring(
		&speed_changed_name_data,
		cstring("speed_changed"),
	)
	gt.registration_string_name_init_latin1_cstring(
		&speed_changed_value_name_data,
		cstring("value"),
	)
}

register_classes :: proc() {
	context = gt.godot_context()
	gt.class_registration_names_init(&hello_names, cstring("HelloNode"), cstring("Node"))
	gt.init_class_bindings()
	init_registration_metadata()

	defaults := gt.class_member_defaults(empty_name, empty_hint)
	roll_math_method := gt.class_method_get_godot_real(
		&roll_math_method_storage,
		defaults,
		roll_math_name,
		&roll_math_method_adapter,
	)
	speed_property := gt.class_property_godot_real(
		&speed_property_storage,
		gt.class_typed_property_descriptor(
			defaults,
			.Float,
			speed_name,
			speed_getter_name,
			speed_setter_name,
		),
		&get_speed_method_adapter,
		&set_speed_method_adapter,
	)
	speed_changed_signal := gt.class_signal_1_godot_real(
		&speed_changed_storage,
		defaults,
		speed_changed_name,
		speed_changed_value_name,
	)

	methods := [3]gt.OdinClassMethod {
		roll_math_method,
		speed_property.getter,
		speed_property.setter,
	}
	properties := [1]gt.OdinClassProperty{speed_property.property}
	signals := [1]gt.OdinClassSignal{speed_changed_signal}
	builder := gt.class_builder_begin(
		hello_class_name,
		hello_parent_name,
		create_instance,
		free_instance,
		notification_instance,
	)
	gt.class_builder_methods(&builder, methods[:])
	gt.class_builder_properties(&builder, properties[:])
	gt.class_builder_signals(&builder, signals[:])
	gt.class_builder_register(&builder)
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
	_ = user_data
	if level != .Scene do return
	register_classes()
}

deinitialize_module :: proc "c" (user_data: rawptr, level: gt.InitializationLevel) {
	context = gt.godot_context()
	_ = user_data
	if level != .Scene do return
	gt.unregister_class(hello_class_name)
	gt.registration_string_free(&empty_hint_data)
	gt.debug_print("[odin-gdext] HelloNode unregistered")
}
