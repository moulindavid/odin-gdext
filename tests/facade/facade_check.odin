package facade_tests

import gt "godot:godot"

// Compile-only smoke coverage for public generated class APIs. This package
// intentionally imports only godot:godot, proving normal users do not need to
// import internal generated class packages directly.
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
	object: gt.ObjectPtr,
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

facade_notification :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	_ = instance
	_ = what
	_ = reversed
}

registration_facade_compile_smoke :: proc "contextless" () {
	gt.class_name_init_latin1_cstring(&facade_class_name_data, cstring("FacadeSmoke"))
	gt.class_name_init_latin1_cstring(&facade_parent_name_data, cstring("Node2D"))
	gt.register_class_with_defaults(
		facade_class_name,
		facade_parent_name,
		facade_create_instance,
		facade_free_instance,
		facade_notification,
	)
	gt.unregister_class(facade_class_name)
}

instance_binding_facade_compile_smoke :: proc "contextless" (
	object: gt.ObjectPtr,
	class_name: gt.ConstStringNamePtr,
	data: ^FacadeData,
	instance: gt.ClassInstancePtr,
) {
	gt.attach_instance(object, class_name, data, &facade_instance_binding_callbacks)
	checked, checked_ok := gt.class_instance_data(instance, FacadeData)
	_ = checked
	_ = checked_ok
}

facade_method_name_data: gt.StaticStringName
facade_method_arg_name_data: gt.StaticStringName
facade_method_empty_name_data: gt.StaticStringName
facade_method_empty_string_data: gt.String
facade_method_name := gt.const_static_string_name_ptr(&facade_method_name_data)
facade_method_arg_name := gt.const_static_string_name_ptr(&facade_method_arg_name_data)
facade_method_empty_name := gt.const_static_string_name_ptr(&facade_method_empty_name_data)
facade_method_empty_string := gt.const_string_ptr(&facade_method_empty_string_data)
facade_method_args: [1]gt.PropertyInfo
facade_method_arg_meta := [1]gt.ClassMethodArgumentMetadata{.None}
facade_method_return: gt.PropertyInfo
facade_method_info: gt.ClassMethodInfo

facade_method_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: gt.ClassInstancePtr,
	p_args: [^]gt.ConstVariantPtr,
	p_argument_count: i64,
	r_return: gt.VariantPtr,
	r_error: ^gt.CallError,
) {
	_ = method_userdata
	_ = p_instance
	_ = p_args
	_ = p_argument_count
	_ = r_return
	_ = r_error
}

facade_method_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: rawptr,
	p_args: [^]rawptr,
	r_ret: rawptr,
) {
	_ = method_userdata
	_ = p_instance
	_ = p_args
	_ = r_ret
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
			call_func = facade_method_call,
			ptrcall_func = facade_method_ptrcall,
			return_value_info = &facade_method_return,
			return_value_metadata = .None,
			argument_count = 1,
			arguments_info = &facade_method_args[0],
			arguments_metadata = &facade_method_arg_meta[0],
		},
	)
}
