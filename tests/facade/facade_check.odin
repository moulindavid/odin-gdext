package facade_tests

import gt "godot:godot"

// Compile-only facade smoke coverage. Users should not need internal generated imports.
class_facade_compile_smoke :: proc "contextless" (
	object: gt.Object,
	node2d: gt.Node2D,
	canvas_item: gt.CanvasItem,
	control: gt.Control,
	sprite2d: gt.Sprite2D,
	label: gt.Label,
	resource: gt.Resource,
	ref_counted: gt.RefCounted,
	meta_name: ^gt.StringName,
	meta_value: ^gt.Variant,
) {
	gt.node2d_set_position(node2d, gt.Vector2{1, 2})
	_ = gt.node2d_get_position(node2d)
	gt.node2d_set_rotation(node2d, 0.5)
	_ = gt.node2d_get_rotation(node2d)
	gt.node2d_set_rotation_degrees(node2d, 90)
	_ = gt.node2d_get_rotation_degrees(node2d)
	gt.node2d_set_skew(node2d, 0)
	_ = gt.node2d_get_skew(node2d)
	gt.node2d_set_scale(node2d, gt.Vector2{1, 1})
	_ = gt.node2d_get_scale(node2d)
	gt.node2d_rotate(node2d, 0.25)
	gt.node2d_translate(node2d, gt.Vector2{2, 0})
	gt.node2d_global_translate(node2d, gt.Vector2{0, 2})
	gt.node2d_apply_scale(node2d, gt.Vector2{1, 1})
	gt.node2d_set_global_position(node2d, gt.Vector2{8, 16})
	_ = gt.node2d_get_global_position(node2d)
	gt.node2d_set_global_rotation(node2d, 0)
	_ = gt.node2d_get_global_rotation(node2d)
	gt.node2d_set_global_scale(node2d, gt.Vector2{1, 1})
	_ = gt.node2d_get_global_scale(node2d)
	gt.node2d_look_at(node2d, gt.Vector2{16, 16})
	_ = gt.node2d_get_angle_to(node2d, gt.Vector2{})
	_ = gt.node2d_to_local(node2d, gt.Vector2{})
	_ = gt.node2d_to_global(node2d, gt.Vector2{})
	transform := gt.canvas_item_get_transform(canvas_item)
	gt.node2d_set_transform(node2d, transform)
	gt.node2d_set_global_transform(node2d, transform)

	node := gt.node2d_as_node(node2d)
	_ = gt.node_as_object(node)
	_ = gt.node2d_as_object(node2d)
	gt.node_set_name(node, meta_name)
	name_copy := gt.node_get_name(node)
	gt.string_name_free(&name_copy)
	_ = gt.node_is_ancestor_of(node, node)
	_ = gt.node_is_inside_tree(node)
	path_from_node := gt.node_get_path(node)
	_ = gt.node_has_node(node, &path_from_node)
	_, _ = gt.node_get_node_checked(node, &path_from_node)
	_, _ = gt.node_get_node_as_canvas_item(node, &path_from_node)
	_, _ = gt.node_get_node_as_node2d(node, &path_from_node)
	_, _ = gt.node_get_node_as_control(node, &path_from_node)
	_, _ = gt.node_get_node_as_sprite2d(node, &path_from_node)
	_, _ = gt.node_get_node_as_label(node, &path_from_node)
	_ = gt.node_get_node_or_null(node, &path_from_node)
	gt.node_path_free(&path_from_node)
	_ = gt.node_get_child_count(node, false)
	_ = gt.node_get_child(node, 0, false)
	gt.node_remove_from_group(node, meta_name)
	_ = gt.node_is_in_group(node, meta_name)
	gt.node_set_process(node, true)
	_ = gt.node_is_processing(node)
	_ = gt.node_get_process_delta_time(node)
	gt.node_set_physics_process(node, true)
	_ = gt.node_is_physics_processing(node)
	_ = gt.node_get_physics_process_delta_time(node)

	gt.canvas_item_set_visible(canvas_item, true)
	_ = gt.canvas_item_is_visible(canvas_item)
	gt.canvas_item_hide(canvas_item)
	gt.canvas_item_show(canvas_item)
	gt.canvas_item_queue_redraw(canvas_item)
	gt.canvas_item_move_to_front(canvas_item)
	gt.canvas_item_set_as_top_level(canvas_item, false)
	_ = gt.canvas_item_is_set_as_top_level(canvas_item)
	gt.canvas_item_set_light_mask(canvas_item, 1)
	_ = gt.canvas_item_get_light_mask(canvas_item)
	gt.canvas_item_set_modulate(canvas_item, gt.Color{1, 1, 1, 1})
	_ = gt.canvas_item_get_modulate(canvas_item)
	gt.canvas_item_set_self_modulate(canvas_item, gt.Color{1, 1, 1, 1})
	_ = gt.canvas_item_get_self_modulate(canvas_item)
	gt.canvas_item_set_z_index(canvas_item, 0)
	_ = gt.canvas_item_get_z_index(canvas_item)
	gt.canvas_item_set_z_as_relative(canvas_item, true)
	_ = gt.canvas_item_is_z_relative(canvas_item)
	gt.canvas_item_set_y_sort_enabled(canvas_item, false)
	_ = gt.canvas_item_is_y_sort_enabled(canvas_item)
	gt.canvas_item_set_draw_behind_parent(canvas_item, false)
	_ = gt.canvas_item_is_draw_behind_parent_enabled(canvas_item)
	gt.canvas_item_draw_set_transform_matrix(canvas_item, transform)
	_ = gt.canvas_item_get_global_transform(canvas_item)
	_ = gt.canvas_item_get_global_transform_with_canvas(canvas_item)
	_ = gt.canvas_item_get_viewport_transform(canvas_item)
	_ = gt.canvas_item_get_viewport_rect(canvas_item)
	_ = gt.canvas_item_get_canvas_transform(canvas_item)
	_ = gt.canvas_item_get_screen_transform(canvas_item)
	_ = gt.canvas_item_get_local_mouse_position(canvas_item)
	_ = gt.canvas_item_get_global_mouse_position(canvas_item)
	canvas := gt.canvas_item_get_canvas(canvas_item)
	gt.rid_free(&canvas)
	canvas_item_rid := gt.canvas_item_get_canvas_item(canvas_item)
	gt.rid_free(&canvas_item_rid)

	gt.control_accept_event(control)
	gt.control_set_custom_minimum_size(control, gt.Vector2{32, 24})
	_ = gt.control_get_custom_minimum_size(control)
	_ = gt.control_get_maximum_size(control)
	_ = gt.control_get_combined_maximum_size(control)
	_ = gt.control_get_minimum_size(control)
	_ = gt.control_get_combined_minimum_size(control)
	gt.control_set_propagate_maximum_size(control, true)
	_ = gt.control_is_propagating_maximum_size(control)
	_ = gt.control_get_bound_minimum_size(control)
	_ = gt.control_get_anchor(control, .side_left)
	gt.control_set_offset(control, .side_left, 0)
	_ = gt.control_get_offset(control, .side_left)
	gt.control_set_begin(control, gt.Vector2{})
	gt.control_set_end(control, gt.Vector2{64, 32})
	gt.control_set_position(control, gt.Vector2{}, false)
	gt.control_set_size(control, gt.Vector2{64, 32}, false)
	gt.control_reset_size(control)
	gt.control_set_custom_maximum_size(control, gt.Vector2{128, 64})
	gt.control_set_global_position(control, gt.Vector2{}, false)
	gt.control_set_rotation(control, 0)
	gt.control_set_rotation_degrees(control, 0)
	gt.control_set_scale(control, gt.Vector2{1, 1})
	gt.control_set_pivot_offset(control, gt.Vector2{})
	_ = gt.control_get_begin(control)
	_ = gt.control_get_end(control)
	_ = gt.control_get_position(control)
	_ = gt.control_get_size(control)
	_ = gt.control_get_rotation(control)
	_ = gt.control_get_rotation_degrees(control)
	_ = gt.control_get_scale(control)
	_ = gt.control_get_pivot_offset(control)
	_ = gt.control_get_custom_maximum_size(control)
	_ = gt.control_get_parent_area_size(control)
	_ = gt.control_get_global_position(control)
	_ = gt.control_get_screen_position(control)
	_ = gt.control_get_rect(control)
	_ = gt.control_get_global_rect(control)
	gt.control_set_focus_mode(control, .focus_all)
	_ = gt.control_get_focus_mode(control)
	_ = gt.control_has_focus(control, false)
	gt.control_grab_focus(control, false)
	gt.control_release_focus(control)
	gt.control_set_mouse_filter(control, .mouse_filter_pass)
	_ = gt.control_get_mouse_filter(control)

	gt.sprite2d_set_centered(sprite2d, true)
	_ = gt.sprite2d_is_centered(sprite2d)
	gt.sprite2d_set_offset(sprite2d, gt.Vector2{4, 8})
	_ = gt.sprite2d_get_offset(sprite2d)
	gt.sprite2d_set_flip_h(sprite2d, true)
	_ = gt.sprite2d_is_flipped_h(sprite2d)
	gt.sprite2d_set_flip_v(sprite2d, false)
	_ = gt.sprite2d_is_flipped_v(sprite2d)
	gt.sprite2d_set_region_enabled(sprite2d, false)
	_ = gt.sprite2d_is_region_enabled(sprite2d)
	gt.sprite2d_set_region_rect(sprite2d, gt.Rect2{})
	_ = gt.sprite2d_get_region_rect(sprite2d)
	gt.sprite2d_set_region_filter_clip_enabled(sprite2d, false)
	_ = gt.sprite2d_is_region_filter_clip_enabled(sprite2d)
	_ = gt.sprite2d_is_pixel_opaque(sprite2d, gt.Vector2{})
	gt.sprite2d_set_frame(sprite2d, 0)
	_ = gt.sprite2d_get_frame(sprite2d)
	gt.sprite2d_set_vframes(sprite2d, 1)
	_ = gt.sprite2d_get_vframes(sprite2d)
	gt.sprite2d_set_hframes(sprite2d, 1)
	_ = gt.sprite2d_get_hframes(sprite2d)
	gt.sprite2d_set_frame_coords(sprite2d, gt.Vector2i{})
	_ = gt.sprite2d_get_frame_coords(sprite2d)
	_ = gt.sprite2d_get_rect(sprite2d)

	label_text := gt.string_from_utf8("Score: 0")
	defer gt.string_free(&label_text)
	gt.label_set_text(label, &label_text)
	label_text_copy := gt.label_get_text(label)
	gt.string_free(&label_text_copy)
	gt.label_set_clip_text(label, true)
	_ = gt.label_is_clipping_text(label)
	gt.label_set_horizontal_alignment(label, .horizontal_alignment_left)
	_ = gt.label_get_horizontal_alignment(label)
	gt.label_set_vertical_alignment(label, .vertical_alignment_top)
	_ = gt.label_get_vertical_alignment(label)
	language := gt.string_from_utf8("en")
	defer gt.string_free(&language)
	gt.label_set_language(label, &language)
	language_copy := gt.label_get_language(label)
	gt.string_free(&language_copy)
	paragraph_separator := gt.string_from_utf8("\n")
	defer gt.string_free(&paragraph_separator)
	gt.label_set_paragraph_separator(label, &paragraph_separator)
	paragraph_separator_copy := gt.label_get_paragraph_separator(label)
	gt.string_free(&paragraph_separator_copy)
	tab_stops := gt.packed_float32_array_new()
	defer gt.packed_float32_array_free(&tab_stops)
	gt.label_set_tab_stops(label, &tab_stops)
	tab_stops_copy := gt.label_get_tab_stops(label)
	gt.packed_float32_array_free(&tab_stops_copy)
	ellipsis := gt.string_from_utf8("...")
	defer gt.string_free(&ellipsis)
	gt.label_set_ellipsis_char(label, &ellipsis)
	ellipsis_copy := gt.label_get_ellipsis_char(label)
	gt.string_free(&ellipsis_copy)
	gt.label_set_uppercase(label, false)
	_ = gt.label_is_uppercase(label)
	_ = gt.label_get_line_count(label)
	_ = gt.label_get_visible_line_count(label)
	_ = gt.label_get_total_character_count(label)
	gt.label_set_visible_characters(label, -1)
	_ = gt.label_get_visible_characters(label)
	gt.label_set_visible_ratio(label, 1)
	_ = gt.label_get_visible_ratio(label)
	gt.label_set_lines_skipped(label, 0)
	_ = gt.label_get_lines_skipped(label)
	gt.label_set_max_lines_visible(label, -1)
	_ = gt.label_get_max_lines_visible(label)
	structured_text_args := gt.array_new()
	defer gt.array_free(&structured_text_args)
	gt.label_set_structured_text_bidi_override_options(label, &structured_text_args)
	structured_text_args_copy := gt.label_get_structured_text_bidi_override_options(label)
	gt.array_free(&structured_text_args_copy)
	_ = gt.label_get_character_bounds(label, 0)

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

	_ = gt.object_is_nil(object)
	_ = gt.ref_counted_is_nil(ref_counted)
	_ = gt.resource_is_nil(resource)
	_ = gt.node_is_nil(node)
	_ = gt.canvas_item_is_nil(canvas_item)
	_ = gt.node2d_is_nil(node2d)
	_ = gt.control_is_nil(control)
	_ = gt.sprite2d_is_nil(sprite2d)
	_ = gt.label_is_nil(label)
	_ = gt.object_ptr_is_nil(gt.node2d_object_ptr(node2d))
	_ = gt.object_ptr_as_object(gt.node_object_ptr(node))
	_ = gt.ref_counted_object_ptr(ref_counted)
	_ = gt.resource_object_ptr(resource)
	_ = gt.canvas_item_object_ptr(canvas_item)
	_ = gt.control_object_ptr(control)
	_ = gt.sprite2d_object_ptr(sprite2d)
	_ = gt.label_object_ptr(label)
	_, _ = gt.object_ptr_try_as_ref_counted(gt.ref_counted_object_ptr(ref_counted))
	_, _ = gt.object_ptr_try_as_resource(gt.resource_object_ptr(resource))
	_, _ = gt.object_ptr_try_as_node(gt.node_object_ptr(node))
	_, _ = gt.object_ptr_try_as_canvas_item(gt.canvas_item_object_ptr(canvas_item))
	_, _ = gt.object_ptr_try_as_node2d(gt.node2d_object_ptr(node2d))
	_, _ = gt.object_ptr_try_as_control(gt.control_object_ptr(control))
	_, _ = gt.object_ptr_try_as_sprite2d(gt.sprite2d_object_ptr(sprite2d))
	_, _ = gt.object_ptr_try_as_label(gt.label_object_ptr(label))

	_ = gt.sprite2d_as_node2d(sprite2d)
	_ = gt.sprite2d_as_canvas_item(sprite2d)
	_ = gt.sprite2d_as_node(sprite2d)
	_ = gt.sprite2d_as_object(sprite2d)
	_ = gt.label_as_control(label)
	_ = gt.label_as_canvas_item(label)
	_ = gt.label_as_node(label)
	_ = gt.label_as_object(label)

	_ = gt.object_is_sprite2d(object)
	_, _ = gt.object_try_as_sprite2d(object)
	_ = gt.object_is_label(object)
	_, _ = gt.object_try_as_label(object)
	_ = gt.node_is_sprite2d(node)
	_, _ = gt.node_try_as_sprite2d(node)
	_ = gt.node_is_label(node)
	_, _ = gt.node_try_as_label(node)
	_ = gt.canvas_item_is_sprite2d(canvas_item)
	_, _ = gt.canvas_item_try_as_sprite2d(canvas_item)
	_ = gt.canvas_item_is_label(canvas_item)
	_, _ = gt.canvas_item_try_as_label(canvas_item)
	_ = gt.node2d_is_sprite2d(node2d)
	_, _ = gt.node2d_try_as_sprite2d(node2d)
	_ = gt.control_is_label(control)
	_, _ = gt.control_try_as_label(control)

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

facade_node_lifecycle := gt.NodeLifecycleCallbacks {
	ready            = facade_ready_notification,
	process          = facade_process_notification,
	raw_notification = facade_raw_notification,
}

facade_notification :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	context = gt.godot_context()
	if gt.dispatch_node_lifecycle_callbacks(instance, what, reversed, &facade_node_lifecycle) do return
	_ = gt.dispatch_node_virtual_callbacks(instance, what, reversed, &facade_node_lifecycle)
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

	methods := [0]gt.OdinClassMethod{}
	properties := [0]gt.OdinClassProperty{}
	signals := [0]gt.OdinClassSignal{}
	class_desc := gt.OdinClassDescriptor {
		class_name           = facade_class_name,
		parent_class_name    = facade_parent_name,
		create_instance_func = facade_create_instance,
		free_instance_func   = facade_free_instance,
		notification_func    = facade_notification,
		methods              = methods[:],
		properties           = properties[:],
		signals              = signals[:],
	}
	gt.register_odin_class(class_desc)
	gt.unregister_odin_class(class_desc)
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

ref_counted_resource_borrowed_policy_compile_smoke :: proc "contextless" (
	ref_counted: gt.RefCounted,
	resource: gt.Resource,
) {
	_ = gt.ref_counted_is_nil(ref_counted)
	_ = gt.resource_is_nil(resource)
	_ = gt.ref_counted_get_reference_count(ref_counted)
	_ = gt.ref_counted_retain(ref_counted)
	_, _ = gt.ref_counted_unreference(ref_counted)
	_ = gt.object_destroy_checked(gt.ObjectPtr(nil))
	owned := gt.owned_ref_counted_nil()
	_ = gt.owned_ref_counted_is_nil(owned)
	_, _ = gt.owned_ref_counted_init_owned(ref_counted)
	_, _ = gt.owned_ref_counted_retain(ref_counted)
	_ = gt.owned_ref_counted_handle(owned)
	moved := gt.owned_ref_counted_take(&owned)
	_, _ = gt.owned_ref_counted_release(&moved)
	_ = gt.owned_ref_counted_destroy(&owned)
	_ = gt.resource_as_ref_counted(resource)
	_ = gt.resource_as_object(resource)
	owned_resource := gt.owned_resource_nil()
	_ = gt.owned_resource_is_nil(owned_resource)
	_, _ = gt.owned_resource_init_owned(resource)
	_, _ = gt.owned_resource_retain(resource)
	_ = gt.owned_resource_handle(owned_resource)
	moved_resource := gt.owned_resource_take(&owned_resource)
	_, _ = gt.owned_resource_release(&moved_resource)
	_ = gt.owned_resource_destroy(&owned_resource)
	_, _ = gt.ref_counted_try_as_resource(ref_counted)
	_, _ = gt.object_ptr_try_as_resource(gt.resource_object_ptr(resource))
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
	member_defaults := gt.class_member_defaults(
		facade_method_empty_name,
		facade_method_empty_string,
	)
	gt.init_method_property_info(
		&facade_method_args[0],
		gt.class_member_property(member_defaults, .Float, facade_method_arg_name),
	)
	gt.init_method_property_info(
		&facade_method_args[1],
		gt.class_member_property(member_defaults, .Float, facade_method_arg_name),
	)
	gt.init_method_property_info(
		&facade_method_return,
		gt.class_member_property(member_defaults, .Float, facade_method_name),
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

facade_void_method :: proc "contextless" (instance: gt.ClassInstancePtr) -> bool {
	_ = instance
	return true
}

facade_void_adapter := gt.ClassMethodVoidAdapter {
	method = facade_void_method,
}

void_method_adapter_facade_compile_smoke :: proc "contextless" () {
	_ = gt.ClassMethodVoid(facade_void_method)
	_ = facade_void_adapter
	_ = gt.class_method_void_call
	_ = gt.class_method_void_ptrcall
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

facade_real_property_storage: gt.ClassPrimitivePropertyStorage
facade_bool_property_storage: gt.ClassPrimitivePropertyStorage
facade_int_property_storage: gt.ClassPrimitivePropertyStorage

godot_real_property_adapter_facade_compile_smoke :: proc "contextless" () {
	_ = gt.ClassMethodGetGodotReal(facade_get_real_method)
	_ = gt.ClassMethodSetGodotReal(facade_set_real_method)
	_ = facade_get_real_adapter
	_ = facade_set_real_adapter
	_ = gt.class_method_get_godot_real_call
	_ = gt.class_method_get_godot_real_ptrcall
	_ = gt.class_method_set_godot_real_call
	_ = gt.class_method_set_godot_real_ptrcall

	property := gt.class_property_godot_real(
		&facade_real_property_storage,
		gt.ClassTypedPropertyDescriptor {
			property = gt.MethodPropertyDescriptor {
				type = .Float,
				name = facade_property_name,
				class_name = facade_method_empty_name,
				hint_string = facade_method_empty_string,
				usage = gt.PropertyUsageDefault,
			},
			getter_name = facade_property_getter_name,
			setter_name = facade_property_setter_name,
		},
		&facade_get_real_adapter,
		&facade_set_real_adapter,
	)
	_ = property
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

variant_conversion_proc_group_facade_compile_smoke :: proc "contextless" (
	object: gt.ObjectPtr,
	string_value: ^gt.String,
) {
	v_float := gt.variant_from(gt.GodotReal(2.5))
	v_int := gt.variant_from(i64(7))
	v_bool := gt.variant_from(true)
	v_string := gt.variant_from(string_value)
	v_object := gt.variant_from(object)
	defer gt.variant_free(&v_float)
	defer gt.variant_free(&v_int)
	defer gt.variant_free(&v_bool)
	defer gt.variant_free(&v_string)
	defer gt.variant_free(&v_object)

	_, _ = gt.variant_try.float(&v_float)
	_, _ = gt.variant_try.int(&v_int)
	_, _ = gt.variant_try.bool(&v_bool)
	string_back, string_ok := gt.variant_try.string(&v_string)
	if string_ok do gt.string_free(&string_back)
	_, _ = gt.variant_try.object(&v_object)
}

facade_get_string_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.String,
	ok: bool,
) {
	_ = instance
	return gt.string_from_utf8("facade"), true
}

facade_set_string_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: ^gt.String,
) -> bool {
	_ = instance
	copy := gt.string_copy(value)
	gt.string_free(&copy)
	return true
}

facade_set_object_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: gt.ObjectPtr,
) -> bool {
	_ = instance
	_ = value
	return true
}

facade_get_string_adapter := gt.ClassMethodGetStringAdapter {
	method = facade_get_string_method,
}

facade_set_string_adapter := gt.ClassMethodSetStringAdapter {
	method = facade_set_string_method,
}

facade_set_object_adapter := gt.ClassMethodSetObjectPtrAdapter {
	method = facade_set_object_method,
}

string_object_method_adapter_facade_compile_smoke :: proc "contextless" () {
	_ = gt.ClassMethodGetString(facade_get_string_method)
	_ = gt.ClassMethodSetString(facade_set_string_method)
	_ = gt.ClassMethodSetObjectPtr(facade_set_object_method)
	_ = facade_get_string_adapter
	_ = facade_set_string_adapter
	_ = facade_set_object_adapter
	_ = gt.class_method_get_string_call
	_ = gt.class_method_get_string_ptrcall
	_ = gt.class_method_set_string_call
	_ = gt.class_method_set_string_ptrcall
	_ = gt.class_method_set_object_ptr_call
	_ = gt.class_method_set_object_ptr_ptrcall
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

	bool_property := gt.class_property_bool(
		&facade_bool_property_storage,
		gt.ClassTypedPropertyDescriptor {
			property = gt.MethodPropertyDescriptor {
				type = .Bool,
				name = facade_property_name,
				class_name = facade_method_empty_name,
				hint_string = facade_method_empty_string,
				usage = gt.PropertyUsageDefault,
			},
			getter_name = facade_property_getter_name,
			setter_name = facade_property_setter_name,
		},
		&facade_get_bool_adapter,
		&facade_set_bool_adapter,
	)
	_ = bool_property

	_ = gt.ClassMethodGetInt(facade_get_int_method)
	_ = gt.ClassMethodSetInt(facade_set_int_method)
	_ = facade_get_int_adapter
	_ = facade_set_int_adapter
	_ = gt.class_method_get_int_call
	_ = gt.class_method_get_int_ptrcall
	_ = gt.class_method_set_int_call
	_ = gt.class_method_set_int_ptrcall

	int_property := gt.class_property_int(
		&facade_int_property_storage,
		gt.ClassTypedPropertyDescriptor {
			property = gt.MethodPropertyDescriptor {
				type = .Int,
				name = facade_property_name,
				class_name = facade_method_empty_name,
				hint_string = facade_method_empty_string,
				usage = gt.PropertyUsageDefault,
			},
			getter_name = facade_property_getter_name,
			setter_name = facade_property_setter_name,
		},
		&facade_get_int_adapter,
		&facade_set_int_adapter,
	)
	_ = int_property
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
