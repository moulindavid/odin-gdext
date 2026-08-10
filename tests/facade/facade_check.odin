package facade_tests

import gt "godot:godot"

// Compile-only facade smoke coverage. Users should not need internal generated imports.
class_facade_compile_smoke :: proc "contextless" (
	object: gt.Object,
	node2d: gt.Node2D,
	canvas_item: gt.CanvasItem,
	control: gt.Control,
	resource: gt.Resource,
	ref_counted: gt.RefCounted,
	meta_name: ^gt.StringName,
	meta_value: ^gt.Variant,
) {
	gt.node2d_set_position(node2d, gt.Vector2{1, 2})
	_ = gt.node2d_get_position(node2d)
	gt.node2d_set_rotation(node2d, 0.5)
	_ = gt.node2d_get_rotation(node2d)

	node := gt.node2d_as_node(node2d)
	_ = gt.node_as_object(node)
	_ = gt.node2d_as_object(node2d)
	_ = gt.node_is_ancestor_of(node, node)

	gt.canvas_item_set_visible(canvas_item, true)
	_ = gt.canvas_item_is_visible(canvas_item)
	gt.canvas_item_hide(canvas_item)
	gt.canvas_item_show(canvas_item)
	gt.canvas_item_queue_redraw(canvas_item)
	canvas := gt.canvas_item_get_canvas(canvas_item)
	gt.rid_free(&canvas)

	gt.control_set_custom_minimum_size(control, gt.Vector2{32, 24})
	_ = gt.control_get_custom_minimum_size(control)
	gt.control_set_focus_mode(control, .focus_all)
	_ = gt.control_get_focus_mode(control)
	_ = gt.control_has_focus(control, false)
	gt.control_grab_focus(control, false)
	gt.control_release_focus(control)
	gt.control_set_mouse_filter(control, .mouse_filter_pass)
	_ = gt.control_get_mouse_filter(control)

	resource_path := gt.resource_get_path(resource)
	gt.string_free(&resource_path)
	resource_rid := gt.resource_get_rid(resource)
	gt.rid_free(&resource_rid)
	gt.resource_set_local_to_scene(resource, false)
	_ = gt.resource_is_local_to_scene(resource)
	_ = gt.ref_counted_get_reference_count(ref_counted)

	path := gt.node_get_path_to(node, node, false)
	gt.node_path_free(&path)

	_ = gt.object_is_node2d(object)
	_, _ = gt.object_try_as_node2d(object)
	_, _ = gt.object_try_as_node(object)

	gt.object_set_meta(object, meta_name, meta_value)
	meta := gt.object_get_meta(object, meta_name, meta_value)
	gt.variant_free(&meta)

	ready: int = gt.node_notification_ready
	_ = ready
	mode := gt.NodeProcessMode.process_mode_always
	_ = mode
}

facade_class_name_data: gt.ClassName
facade_parent_name_data: gt.ClassName
facade_class_name := gt.class_name_ptr(&facade_class_name_data)
facade_parent_name := gt.class_name_ptr(&facade_parent_name_data)

FacadeData :: struct {
	// Borrowed owner pointer. This does not retain, unref, or free the Godot object.
	object: gt.ObjectPtr,
}

FacadeStoredOwnerSmoke :: struct {
	// Safe only while Godot still owns the object and the instance binding is alive.
	owner: gt.ObjectPtr,
}

facade_instance_binding_callbacks := gt.InstanceBindingCallbacks {
	create_callback    = nil,
	free_callback      = nil,
	reference_callback = nil,
}

facade_create_instance :: proc "c" (
	class_userdata: rawptr,
	notify_postinitialize: bool,
) -> gt.ObjectPtr {
	_ = class_userdata
	_ = notify_postinitialize
	return nil
}

facade_free_instance :: proc "c" (class_userdata: rawptr, instance: gt.ClassInstancePtr) {
	_ = class_userdata
	_ = instance
}

facade_initialize_module :: proc "c" (user_data: rawptr, level: gt.InitializationLevel) {
	_ = user_data
	if level != .Scene {return}
}

facade_deinitialize_module :: proc "c" (user_data: rawptr, level: gt.InitializationLevel) {
	_ = user_data
	if level != .Scene {return}
}

facade_entrypoint_compile_smoke :: proc "c" (
	get_proc_address: gt.InterfaceGetProcAddress,
	library: gt.ClassLibraryPtr,
	initialization: ^gt.Initialization,
) -> bool {
	gt.init(library, get_proc_address)
	initialization.initialize = facade_initialize_module
	initialization.deinitialize = facade_deinitialize_module
	initialization.minimum_initialization_level = .Scene
	initialization.userdata = nil
	return true
}

facade_runtime_helper_compile_smoke :: proc(class_name: gt.ConstStringNamePtr) -> gt.ObjectPtr {
	context = gt.godot_context()
	object := gt.construct_object(class_name)
	gt.debug_print("facade runtime helper compile smoke")
	return object
}

facade_ready_notification :: proc(instance: gt.ClassInstancePtr, reversed: bool) {
	_ = instance
	_ = reversed
}

facade_process_notification :: proc(instance: gt.ClassInstancePtr, reversed: bool) {
	_ = instance
	_ = reversed
}

facade_raw_notification :: proc(instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	_ = instance
	_ = what
	_ = reversed
}

facade_node_notifications := gt.NodeNotificationHandlers {
	ready   = facade_ready_notification,
	process = facade_process_notification,
}

facade_node_virtuals := gt.NodeVirtualCallbacks {
	ready            = facade_ready_notification,
	process          = facade_process_notification,
	raw_notification = facade_raw_notification,
}

facade_notification :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	context = gt.godot_context()
	if gt.dispatch_node_virtual_callbacks(instance, what, reversed, &facade_node_virtuals) do return
	if gt.dispatch_node_notification(instance, what, reversed, &facade_node_notifications) do return
	if what == gt.node_notification_ready {
		_ = what
	}
}

registration_facade_compile_smoke :: proc "contextless" () {
	gt.class_name_init_latin1_cstring(&facade_class_name_data, cstring("FacadeSmoke"))
	gt.class_name_init_latin1_cstring(&facade_parent_name_data, cstring("Node2D"))
	gt.register_editor_visible_class(
		gt.EditorVisibleClassDescriptor {
			class_name = facade_class_name,
			parent_class_name = facade_parent_name,
			create_instance_func = facade_create_instance,
			free_instance_func = facade_free_instance,
			notification_func = facade_notification,
		},
	)
	_ = gt.register_class_with_defaults
	gt.unregister_class(facade_class_name)
}

instance_binding_facade_compile_smoke :: proc "contextless" (
	object: gt.ObjectPtr,
	class_name: gt.ConstStringNamePtr,
	data: ^FacadeData,
	instance: gt.ClassInstancePtr,
) {
	if data != nil do data.object = object
	gt.attach_instance(object, class_name, data, &facade_instance_binding_callbacks)
	checked, checked_ok := gt.class_instance_data(instance, FacadeData)
	_ = checked
	_ = checked_ok
}

borrowed_owner_storage_facade_compile_smoke :: proc "contextless" (object: gt.ObjectPtr) {
	storage := FacadeStoredOwnerSmoke {
		owner = object,
	}
	_ = storage
}

facade_method_name_data: gt.StaticStringName
facade_method_arg_name_data: gt.StaticStringName
facade_method_empty_name_data: gt.StaticStringName
facade_method_empty_string_data: gt.String
facade_method_name := gt.const_static_string_name_ptr(&facade_method_name_data)
facade_method_arg_name := gt.const_static_string_name_ptr(&facade_method_arg_name_data)
facade_method_empty_name := gt.const_static_string_name_ptr(&facade_method_empty_name_data)
facade_method_empty_string := gt.const_string_ptr(&facade_method_empty_string_data)
facade_method_args: [2]gt.PropertyInfo
facade_method_arg_meta := [2]gt.ClassMethodArgumentMetadata{.None, .None}
facade_method_return: gt.PropertyInfo
facade_method_info: gt.ClassMethodInfo

facade_real2_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	a: gt.GodotReal,
	b: gt.GodotReal,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	_ = instance
	return a + b, true
}

facade_real2_adapter := gt.ClassMethodGodotReal2ToGodotRealAdapter {
	method = facade_real2_method,
}

method_registration_facade_compile_smoke :: proc "contextless" (
	class_name: gt.ConstStringNamePtr,
) {
	gt.init_method_property_info(
		&facade_method_args[0],
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = facade_method_arg_name,
			class_name = facade_method_empty_name,
			hint_string = facade_method_empty_string,
		},
	)
	gt.init_method_property_info(
		&facade_method_args[1],
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = facade_method_arg_name,
			class_name = facade_method_empty_name,
			hint_string = facade_method_empty_string,
		},
	)
	gt.init_method_property_info(
		&facade_method_return,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = facade_method_name,
			class_name = facade_method_empty_name,
			hint_string = facade_method_empty_string,
		},
	)
	gt.register_class_method_with_descriptor(
		class_name,
		&facade_method_info,
		gt.ClassMethodDescriptor {
			name = facade_method_name,
			method_userdata = &facade_real2_adapter,
			call_func = gt.class_method_godot_real2_to_godot_real_call,
			ptrcall_func = gt.class_method_godot_real2_to_godot_real_ptrcall,
			return_value_info = &facade_method_return,
			return_value_metadata = .None,
			argument_count = 2,
			arguments_info = &facade_method_args[0],
			arguments_metadata = &facade_method_arg_meta[0],
		},
	)
}

facade_property_name_data: gt.StaticStringName
facade_property_setter_name_data: gt.StaticStringName
facade_property_getter_name_data: gt.StaticStringName
facade_property_name := gt.const_static_string_name_ptr(&facade_property_name_data)
facade_property_setter_name := gt.const_static_string_name_ptr(&facade_property_setter_name_data)
facade_property_getter_name := gt.const_static_string_name_ptr(&facade_property_getter_name_data)
facade_property_info: gt.PropertyInfo

property_registration_facade_compile_smoke :: proc "contextless" (
	class_name: gt.ConstStringNamePtr,
) {
	gt.init_class_property_info(
		&facade_property_info,
		gt.ClassPropertyDescriptor {
			property = gt.MethodPropertyDescriptor {
				type = .Float,
				name = facade_property_name,
				class_name = facade_method_empty_name,
				hint_string = facade_method_empty_string,
				usage = gt.PropertyUsageDefault,
			},
			setter = facade_property_setter_name,
			getter = facade_property_getter_name,
		},
	)
	gt.register_class_property_with_descriptor(
		class_name,
		&facade_property_info,
		gt.ClassPropertyDescriptor {
			property = gt.MethodPropertyDescriptor {
				type = .Float,
				name = facade_property_name,
				class_name = facade_method_empty_name,
				hint_string = facade_method_empty_string,
				usage = gt.PropertyUsageDefault,
			},
			setter = facade_property_setter_name,
			getter = facade_property_getter_name,
		},
	)
}

facade_get_real_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	_ = instance
	return 1, true
}

facade_set_real_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: gt.GodotReal,
) -> bool {
	_ = instance
	_ = value
	return true
}

facade_get_real_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = facade_get_real_method,
}

facade_set_real_adapter := gt.ClassMethodSetGodotRealAdapter {
	method = facade_set_real_method,
}

godot_real_property_adapter_facade_compile_smoke :: proc "contextless" () {
	_ = gt.ClassMethodGetGodotReal(facade_get_real_method)
	_ = gt.ClassMethodSetGodotReal(facade_set_real_method)
	_ = facade_get_real_adapter
	_ = facade_set_real_adapter
	_ = gt.class_method_get_godot_real_call
	_ = gt.class_method_get_godot_real_ptrcall
	_ = gt.class_method_set_godot_real_call
	_ = gt.class_method_set_godot_real_ptrcall
}

facade_get_bool_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: bool,
	ok: bool,
) {
	_ = instance
	return true, true
}

facade_set_bool_method :: proc "contextless" (instance: gt.ClassInstancePtr, value: bool) -> bool {
	_ = instance
	_ = value
	return true
}

facade_get_int_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: i64,
	ok: bool,
) {
	_ = instance
	return 42, true
}

facade_set_int_method :: proc "contextless" (instance: gt.ClassInstancePtr, value: i64) -> bool {
	_ = instance
	_ = value
	return true
}

facade_get_bool_adapter := gt.ClassMethodGetBoolAdapter {
	method = facade_get_bool_method,
}

facade_set_bool_adapter := gt.ClassMethodSetBoolAdapter {
	method = facade_set_bool_method,
}

facade_get_int_adapter := gt.ClassMethodGetIntAdapter {
	method = facade_get_int_method,
}

facade_set_int_adapter := gt.ClassMethodSetIntAdapter {
	method = facade_set_int_method,
}

bool_int_property_adapter_facade_compile_smoke :: proc "contextless" () {
	_ = gt.ClassMethodGetBool(facade_get_bool_method)
	_ = gt.ClassMethodSetBool(facade_set_bool_method)
	_ = facade_get_bool_adapter
	_ = facade_set_bool_adapter
	_ = gt.class_method_get_bool_call
	_ = gt.class_method_get_bool_ptrcall
	_ = gt.class_method_set_bool_call
	_ = gt.class_method_set_bool_ptrcall

	_ = gt.ClassMethodGetInt(facade_get_int_method)
	_ = gt.ClassMethodSetInt(facade_set_int_method)
	_ = facade_get_int_adapter
	_ = facade_set_int_adapter
	_ = gt.class_method_get_int_call
	_ = gt.class_method_get_int_ptrcall
	_ = gt.class_method_set_int_call
	_ = gt.class_method_set_int_ptrcall
}

facade_signal_name_data: gt.StaticStringName
facade_signal_name := gt.const_static_string_name_ptr(&facade_signal_name_data)

signal_registration_facade_compile_smoke :: proc "contextless" (
	class_name: gt.ConstStringNamePtr,
) {
	gt.register_class_signal_with_descriptor(
		class_name,
		gt.ClassSignalDescriptor{name = facade_signal_name},
	)
}

signal_emission_facade_compile_smoke :: proc "contextless" (
	object: gt.ObjectPtr,
	signal_name: gt.ConstStringNamePtr,
) {
	gt.init_signal_emission()
	err := gt.object_emit_signal_0_checked(object, signal_name)
	_ = err
	gt.object_emit_signal_0(object, signal_name)
	err = gt.object_emit_signal_1_godot_real_checked(object, signal_name, 1.5)
	_ = err
	gt.object_emit_signal_1_godot_real(object, signal_name, 1.5)
}
