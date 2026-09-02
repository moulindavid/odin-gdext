package facade_tests

import gt "godot:godot"

FacadeInstanceData :: struct {
	object: gt.ObjectPtr,
}

nil_proc_create_instance :: proc "c" (
	class_userdata: rawptr,
	notify_postinitialize: bool,
) -> gt.ObjectPtr {
	return nil
}

nil_proc_free_instance :: proc "c" (class_userdata: rawptr, instance: gt.ClassInstancePtr) {
}

nil_method_void :: proc "contextless" (instance: gt.ClassInstancePtr) -> bool {
	return instance != nil
}

nil_method_get_real :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	return 0, instance != nil
}

nil_method_set_real :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: gt.GodotReal,
) -> bool {
	_ = value
	return instance != nil
}

nil_method_real2_real :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	a: gt.GodotReal,
	b: gt.GodotReal,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	return a + b, instance != nil
}

nil_method_get_string :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.String,
	ok: bool,
) {
	return gt.string_from_utf8(""), instance != nil
}

nil_method_set_string :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: ^gt.String,
) -> bool {
	_ = value
	return instance != nil
}

// Compile-only facade smoke coverage. Users should not need internal generated imports.
class_facade_compile_smoke :: proc "contextless" (
	object: gt.Object,
	node2d: gt.Node2D,
	canvas_item: gt.CanvasItem,
	control: gt.Control,
	sprite2d: gt.Sprite2D,
	label: gt.Label,
	timer: gt.Timer,
	collision_object2d: gt.CollisionObject2D,
	area2d: gt.Area2D,
	physics_body2d: gt.PhysicsBody2D,
	character_body2d: gt.CharacterBody2D,
	rigid_body2d: gt.RigidBody2D,
	static_body2d: gt.StaticBody2D,
	collision_shape2d: gt.CollisionShape2D,
	packed_scene: gt.PackedScene,
	resource_loader: gt.ResourceLoader,
	input: gt.Input,
	input_event: gt.InputEvent,
	input_event_from_window: gt.InputEventFromWindow,
	input_event_with_modifiers: gt.InputEventWithModifiers,
	input_event_key: gt.InputEventKey,
	input_event_mouse: gt.InputEventMouse,
	input_event_mouse_button: gt.InputEventMouseButton,
	input_event_mouse_motion: gt.InputEventMouseMotion,
	viewport: gt.Viewport,
	scene_tree: gt.SceneTree,
	resource: gt.Resource,
	ref_counted: gt.RefCounted,
	meta_name: ^gt.StringName,
	meta_value: ^gt.Variant,
	callable: ^gt.Callable,
	signal: ^gt.Signal,
	registration_name: ^gt.RegistrationStringName,
	registration_string: ^gt.RegistrationString,
	registration_names: ^gt.ClassRegistrationNames,
) {
	_ = gt.registration_string_name_ptr(registration_name)
	_ = gt.registration_string_name_mut_ptr(registration_name)
	_ = gt.registration_string_ptr(registration_string)
	_ = gt.registration_string_mut_ptr(registration_string)
	_ = gt.class_registration_class_name(registration_names)
	_ = gt.class_registration_parent_name(registration_names)
	builder := gt.class_builder_begin(
		gt.class_registration_class_name(registration_names),
		gt.class_registration_parent_name(registration_names),
		nil_proc_create_instance,
		nil_proc_free_instance,
	)
	gt.class_builder_methods(&builder, nil)
	gt.class_builder_properties(&builder, nil)
	gt.class_builder_signals(&builder, nil)
	_ = gt.class_builder_finalize(&builder)
	method_info: gt.ClassMethodInfo
	method_storage: gt.ClassFixedMethodStorage
	method_storage_2: gt.ClassFixedMethodStorage
	method_storage_3: gt.ClassFixedMethodStorage
	void_adapter := gt.ClassMethodVoidAdapter {
		method = nil_method_void,
	}
	get_real_adapter := gt.ClassMethodGetGodotRealAdapter {
		method = nil_method_get_real,
	}
	set_real_adapter := gt.ClassMethodSetGodotRealAdapter {
		method = nil_method_set_real,
	}
	real2_adapter := gt.ClassMethodGodotReal2ToGodotRealAdapter {
		method = nil_method_real2_real,
	}
	defaults := gt.class_member_defaults(
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_mut_ptr(registration_string),
	)
	_ = gt.class_method_void(
		&method_info,
		gt.registration_string_name_mut_ptr(registration_name),
		&void_adapter,
	)
	_ = gt.class_method_get_godot_real(
		&method_storage,
		defaults,
		gt.registration_string_name_mut_ptr(registration_name),
		&get_real_adapter,
	)
	_ = gt.class_method_set_godot_real(
		&method_storage_2,
		defaults,
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
		&set_real_adapter,
	)
	_ = gt.class_method_godot_real2_to_godot_real(
		&method_storage_3,
		defaults,
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
		&real2_adapter,
	)
	property_storage: gt.ClassPrimitivePropertyStorage
	string_property_storage: gt.ClassPrimitivePropertyStorage
	string_get_adapter := gt.ClassMethodGetStringAdapter {
		method = nil_method_get_string,
	}
	string_set_adapter := gt.ClassMethodSetStringAdapter {
		method = nil_method_set_string,
	}
	property_desc := gt.class_typed_property_descriptor(
		defaults,
		.Float,
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
	)
	_ = gt.class_property_godot_real(
		&property_storage,
		property_desc,
		&get_real_adapter,
		&set_real_adapter,
	)
	string_property_desc := gt.class_typed_property_descriptor(
		defaults,
		.String,
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
	)
	_ = gt.class_property_string(
		&string_property_storage,
		string_property_desc,
		&string_get_adapter,
		&string_set_adapter,
	)
	signal_storage: gt.ClassSignalStorage
	signal_storage_2: gt.ClassSignalStorage
	_ = gt.class_signal_0(gt.registration_string_name_ptr(registration_name))
	_ = gt.class_signal_1_godot_real(
		&signal_storage,
		defaults,
		gt.registration_string_name_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
	)
	_ = gt.class_signal_2_godot_real(
		&signal_storage_2,
		defaults,
		gt.registration_string_name_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
		gt.registration_string_name_mut_ptr(registration_name),
	)
	instance_data := FacadeInstanceData {
		object = gt.ObjectPtr(object),
	}
	gt.attach_typed_instance(
		gt.ObjectPtr(object),
		gt.class_registration_class_name(registration_names),
		&instance_data,
		&gt.InstanceBindingCallbacks{},
	)
	_, _ = gt.class_instance_data(gt.ClassInstancePtr(&instance_data), FacadeInstanceData)
	_ = gt.class_instance_data_or_trap(gt.ClassInstancePtr(&instance_data), FacadeInstanceData)
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
	_, _ = gt.node_get_node_as_base_button(node, &path_from_node)
	_, _ = gt.node_get_node_as_button(node, &path_from_node)
	_, _ = gt.node_get_node_as_texture_rect(node, &path_from_node)
	_, _ = gt.node_get_node_as_panel(node, &path_from_node)
	_, _ = gt.node_get_node_as_container(node, &path_from_node)
	_, _ = gt.node_get_node_as_sprite2d(node, &path_from_node)
	_, _ = gt.node_get_node_as_label(node, &path_from_node)
	_, _ = gt.node_get_node_as_timer(node, &path_from_node)
	_, _ = gt.node_get_node_as_collision_object2d(node, &path_from_node)
	_, _ = gt.node_get_node_as_area2d(node, &path_from_node)
	_ = gt.node_get_node_or_null(node, &path_from_node)
	gt.node_path_free(&path_from_node)
	_ = gt.node_get_child_count(node, false)
	_ = gt.node_get_child_count_default(node)
	_ = gt.node_get_child(node, 0, false)
	_ = gt.node_get_child_default(node, 0)
	gt.node_remove_from_group(node, meta_name)
	_ = gt.node_is_in_group(node, meta_name)
	gt.node_set_process(node, true)
	_ = gt.node_is_processing(node)
	_ = gt.node_get_process_delta_time(node)
	gt.node_set_physics_process(node, true)
	_ = gt.node_is_physics_processing(node)
	_ = gt.node_get_physics_process_delta_time(node)
	callable_copy := gt.callable_copy(callable)
	_ = gt.callable_is_null(&callable_copy)
	_ = gt.callable_is_valid(&callable_copy)
	gt.callable_free(&callable_copy)

	signal_copy := gt.signal_copy(signal)
	_ = gt.signal_is_null(&signal_copy)
	signal_name_copy := gt.signal_get_name(&signal_copy)
	gt.string_name_free(&signal_name_copy)
	gt.signal_free(&signal_copy)

	_ = gt.signal_connect_checked(signal, callable, 0)
	_ = gt.object_signal_connect_checked(
		gt.Node2D(node2d),
		gt.const_string_name_ptr(meta_name),
		callable,
		0,
	)

	_ = gt.object_emit_signal_2_godot_real_checked(
		gt.Node2D(node2d),
		gt.const_string_name_ptr(meta_name),
		1,
		2,
	)

	_ = gt.timer_timeout_signal_name()
	timeout_signal := gt.timer_timeout_signal(timer)
	gt.signal_free(&timeout_signal)
	_ = gt.timer_connect_timeout_checked(timer, callable, 0)
	_ = gt.timer_emit_timeout_checked(timer)
	_ = gt.node_connect_child_entered_tree_checked(node, callable, 0)
	_ = gt.node_emit_child_entered_tree_checked(node, node)
	_ = gt.area2d_connect_body_entered_checked(area2d, callable, 0)
	_ = gt.area2d_emit_body_entered_checked(area2d, node2d)


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
	gt.control_set_position_default(control, gt.Vector2{})
	gt.control_set_size(control, gt.Vector2{64, 32}, false)
	gt.control_set_size_default(control, gt.Vector2{64, 32})
	gt.control_reset_size(control)
	gt.control_set_custom_maximum_size(control, gt.Vector2{128, 64})
	gt.control_set_global_position(control, gt.Vector2{}, false)
	gt.control_set_global_position_default(control, gt.Vector2{})
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
	_ = gt.control_has_focus_default(control)
	gt.control_grab_focus(control, false)
	gt.control_grab_focus_default(control)
	gt.control_release_focus(control)
	gt.control_set_mouse_filter(control, .mouse_filter_pass)
	_ = gt.control_get_mouse_filter(control)

	base_button := gt.BaseButton(nil)
	button := gt.Button(nil)
	texture_rect := gt.TextureRect(nil)
	panel := gt.Panel(nil)
	container := gt.Container(nil)
	_ = gt.base_button_is_nil(base_button)
	_ = gt.button_is_nil(button)
	_ = gt.texture_rect_is_nil(texture_rect)
	_ = gt.panel_is_nil(panel)
	_ = gt.container_is_nil(container)
	_ = gt.base_button_object_ptr(base_button)
	_ = gt.button_object_ptr(button)
	_ = gt.texture_rect_object_ptr(texture_rect)
	_ = gt.panel_object_ptr(panel)
	_ = gt.container_object_ptr(container)
	_ = gt.base_button_as_control(base_button)
	_ = gt.base_button_as_canvas_item(base_button)
	_ = gt.base_button_as_node(base_button)
	_ = gt.base_button_as_object(base_button)
	_ = gt.button_as_base_button(button)
	_ = gt.button_as_control(button)
	_ = gt.button_as_canvas_item(button)
	_ = gt.button_as_node(button)
	_ = gt.button_as_object(button)
	_ = gt.texture_rect_as_control(texture_rect)
	_ = gt.texture_rect_as_canvas_item(texture_rect)
	_ = gt.texture_rect_as_node(texture_rect)
	_ = gt.texture_rect_as_object(texture_rect)
	_ = gt.panel_as_control(panel)
	_ = gt.panel_as_canvas_item(panel)
	_ = gt.panel_as_node(panel)
	_ = gt.panel_as_object(panel)
	_ = gt.container_as_control(container)
	_ = gt.container_as_canvas_item(container)
	_ = gt.container_as_node(container)
	_ = gt.container_as_object(container)
	_, _ = gt.object_ptr_try_as_base_button(object)
	_, _ = gt.object_ptr_try_as_button(object)
	_, _ = gt.object_ptr_try_as_texture_rect(object)
	_, _ = gt.object_ptr_try_as_panel(object)
	_, _ = gt.object_ptr_try_as_container(object)
	_ = gt.object_is_base_button(object)
	_, _ = gt.object_try_as_base_button(object)
	_ = gt.object_is_button(object)
	_, _ = gt.object_try_as_button(object)
	_ = gt.object_is_texture_rect(object)
	_, _ = gt.object_try_as_texture_rect(object)
	_ = gt.object_is_panel(object)
	_, _ = gt.object_try_as_panel(object)
	_ = gt.object_is_container(object)
	_, _ = gt.object_try_as_container(object)
	_ = gt.node_is_base_button(node)
	_, _ = gt.node_try_as_base_button(node)
	_ = gt.node_is_button(node)
	_, _ = gt.node_try_as_button(node)
	_ = gt.node_is_texture_rect(node)
	_, _ = gt.node_try_as_texture_rect(node)
	_ = gt.node_is_panel(node)
	_, _ = gt.node_try_as_panel(node)
	_ = gt.node_is_container(node)
	_, _ = gt.node_try_as_container(node)
	_ = gt.canvas_item_is_base_button(canvas_item)
	_, _ = gt.canvas_item_try_as_base_button(canvas_item)
	_ = gt.canvas_item_is_button(canvas_item)
	_, _ = gt.canvas_item_try_as_button(canvas_item)
	_ = gt.canvas_item_is_texture_rect(canvas_item)
	_, _ = gt.canvas_item_try_as_texture_rect(canvas_item)
	_ = gt.canvas_item_is_panel(canvas_item)
	_, _ = gt.canvas_item_try_as_panel(canvas_item)
	_ = gt.canvas_item_is_container(canvas_item)
	_, _ = gt.canvas_item_try_as_container(canvas_item)
	_ = gt.control_is_base_button(control)
	_, _ = gt.control_try_as_base_button(control)
	_ = gt.control_is_button(control)
	_, _ = gt.control_try_as_button(control)
	_ = gt.control_is_texture_rect(control)
	_, _ = gt.control_try_as_texture_rect(control)
	_ = gt.control_is_panel(control)
	_, _ = gt.control_try_as_panel(control)
	_ = gt.control_is_container(control)
	_, _ = gt.control_try_as_container(control)
	_ = gt.base_button_is_button(base_button)
	_, _ = gt.base_button_try_as_button(base_button)
	gt.base_button_set_pressed(base_button, false)
	_ = gt.base_button_is_pressed(base_button)
	gt.base_button_set_pressed_no_signal(base_button, false)
	_ = gt.base_button_is_hovered(base_button)
	gt.base_button_set_toggle_mode(base_button, false)
	_ = gt.base_button_is_toggle_mode(base_button)
	gt.base_button_set_shortcut_in_tooltip(base_button, true)
	_ = gt.base_button_is_shortcut_in_tooltip_enabled(base_button)
	gt.base_button_set_disabled(base_button, false)
	_ = gt.base_button_is_disabled(base_button)
	gt.base_button_set_action_mode(base_button, .action_mode_button_release)
	_ = gt.base_button_get_action_mode(base_button)
	_ = gt.base_button_get_draw_mode(base_button)
	gt.base_button_set_keep_pressed_outside(base_button, false)
	_ = gt.base_button_is_keep_pressed_outside(base_button)
	gt.base_button_set_shortcut_feedback(base_button, true)
	_ = gt.base_button_is_shortcut_feedback(base_button)
	text_buffer: [64]u8
	_ = gt.button_set_text_utf8_checked(button, "Roll")
	_, _, _ = gt.button_get_text_utf8_checked(button, text_buffer[:])
	button_text := gt.string_from_utf8("Roll")
	defer gt.string_free(&button_text)
	gt.button_set_text(button, &button_text)
	button_text_copy := gt.button_get_text(button)
	gt.string_free(&button_text_copy)
	gt.button_set_flat(button, false)
	_ = gt.button_is_flat(button)
	gt.button_set_clip_text(button, true)
	_ = gt.button_get_clip_text(button)
	gt.button_set_text_alignment(button, .horizontal_alignment_center)
	_ = gt.button_get_text_alignment(button)
	gt.button_set_icon_alignment(button, .horizontal_alignment_center)
	_ = gt.button_get_icon_alignment(button)
	gt.button_set_vertical_icon_alignment(button, .vertical_alignment_center)
	_ = gt.button_get_vertical_icon_alignment(button)
	gt.button_set_expand_icon(button, false)
	_ = gt.button_is_expand_icon(button)
	gt.texture_rect_set_expand_mode(texture_rect, .expand_keep_size)
	_ = gt.texture_rect_get_expand_mode(texture_rect)
	gt.texture_rect_set_flip_h(texture_rect, false)
	_ = gt.texture_rect_is_flipped_h(texture_rect)
	gt.texture_rect_set_flip_v(texture_rect, false)
	_ = gt.texture_rect_is_flipped_v(texture_rect)
	gt.texture_rect_set_stretch_mode(texture_rect, .stretch_keep_aspect_centered)
	_ = gt.texture_rect_get_stretch_mode(texture_rect)
	gt.container_queue_sort(container)
	gt.container_fit_child_in_rect(container, control, gt.Rect2{})
	gt.container_set_accessibility_region(container, false)
	_ = gt.container_is_accessibility_region(container)

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
	_ = gt.label_set_text_utf8_checked(label, "Score: 0")
	_, _, _ = gt.label_get_text_utf8_checked(label, text_buffer[:])
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

	_ = gt.node_add_child_checked(node, node)

	path := gt.node_get_path_to(node, node, false)
	gt.node_path_free(&path)
	default_path := gt.node_get_path_to_default(node, node)
	gt.node_path_free(&default_path)

	_ = gt.object_is_node2d(object)
	_, _ = gt.object_try_as_node2d(object)
	_, _ = gt.object_try_as_node(object)
	_, _ = gt.global_get_singleton_checked(facade_method_name)
	_ = gt.global_get_singleton_or_trap
	_, _ = gt.input_singleton_checked()
	_, _ = gt.resource_loader_singleton_checked()
	_ = gt.object_is_input(object)
	_, _ = gt.object_try_as_input(object)
	_ = gt.resource_loader_as_object(resource_loader)
	resource_load_path := gt.string_from_utf8("res://missing.tscn")
	defer gt.string_free(&resource_load_path)
	_ = gt.resource_loader_exists(resource_loader, &resource_load_path, &resource_load_path)
	_ = gt.resource_loader_exists_default(resource_loader, &resource_load_path)
	loaded_resource, _, _ := gt.resource_loader_load_owned_checked(
		resource_loader,
		&resource_load_path,
	)
	_ = gt.owned_resource_destroy(&loaded_resource)
	_ = gt.resource_loader_load_owned
	_ = gt.input_as_object(input)
	_ = gt.input_is_anything_pressed(input)
	_ = gt.input_is_action_pressed(input, meta_name, false)
	_ = gt.input_is_action_pressed_default(input, meta_name)
	_ = gt.input_is_action_just_pressed(input, meta_name, false)
	_ = gt.input_is_action_just_pressed_default(input, meta_name)
	_ = gt.input_is_action_just_released(input, meta_name, false)
	_ = gt.input_is_action_just_released_default(input, meta_name)
	_ = gt.input_get_action_strength(input, meta_name, false)
	_ = gt.input_get_action_strength_default(input, meta_name)
	_ = gt.input_get_action_raw_strength(input, meta_name, false)
	_ = gt.input_get_action_raw_strength_default(input, meta_name)
	_ = gt.input_get_axis(input, meta_name, meta_name)
	_ = gt.input_get_vector(input, meta_name, meta_name, meta_name, meta_name, -1)
	_ = gt.input_get_vector_default(input, meta_name, meta_name, meta_name, meta_name)
	_ = gt.input_get_last_mouse_velocity(input)
	_ = gt.input_get_last_mouse_screen_velocity(input)
	gt.input_set_use_accumulated_input(input, false)
	_ = gt.input_is_using_accumulated_input(input)
	gt.input_flush_buffered_events(input)
	_ = gt.input_event_as_resource(input_event)
	_ = gt.input_event_as_ref_counted(input_event)
	_ = gt.input_event_as_object(input_event)
	_ = gt.input_event_from_window_as_input_event(input_event_from_window)
	_ = gt.input_event_with_modifiers_as_input_event(input_event_with_modifiers)
	_ = gt.input_event_key_as_input_event(input_event_key)
	_ = gt.input_event_key_as_input_event_with_modifiers(input_event_key)
	_ = gt.input_event_mouse_as_input_event(input_event_mouse)
	_ = gt.input_event_mouse_button_as_input_event_mouse(input_event_mouse_button)
	_ = gt.input_event_mouse_button_as_input_event(input_event_mouse_button)
	_ = gt.input_event_mouse_motion_as_input_event_mouse(input_event_mouse_motion)
	_ = gt.input_event_mouse_motion_as_input_event(input_event_mouse_motion)
	_ = gt.object_is_input_event(object)
	_, _ = gt.object_try_as_input_event(object)
	_ = gt.object_is_input_event_key(object)
	_, _ = gt.object_try_as_input_event_key(object)
	_ = gt.object_is_input_event_mouse_button(object)
	_, _ = gt.object_try_as_input_event_mouse_button(object)
	_ = gt.resource_is_input_event(resource)
	_, _ = gt.resource_try_as_input_event(resource)
	_ = gt.input_event_is_input_event_key(input_event)
	_, _ = gt.input_event_try_as_input_event_key(input_event)
	_ = gt.input_event_is_input_event_mouse_button(input_event)
	_, _ = gt.input_event_try_as_input_event_mouse_button(input_event)
	_ = gt.input_event_get_device(input_event)
	_ = gt.input_event_is_action(input_event, meta_name, false)
	_ = gt.input_event_is_action_default(input_event, meta_name)
	_ = gt.input_event_is_action_pressed(input_event, meta_name, false, true)
	_ = gt.input_event_is_action_pressed_default(input_event, meta_name)
	_ = gt.input_event_is_action_released(input_event, meta_name, true)
	_ = gt.input_event_is_action_released_default(input_event, meta_name)
	_ = gt.input_event_get_action_strength(input_event, meta_name, true)
	_ = gt.input_event_get_action_strength_default(input_event, meta_name)
	_ = gt.input_event_is_canceled(input_event)
	_ = gt.input_event_is_pressed(input_event)
	_ = gt.input_event_is_released(input_event)
	_ = gt.input_event_is_echo(input_event)
	_ = gt.input_event_as_text(input_event)
	_ = gt.input_event_is_match(input_event, input_event, true)
	_ = gt.input_event_is_match_default(input_event, input_event)
	_ = gt.input_event_is_action_type(input_event)
	_ = gt.input_event_from_window_get_window_id(input_event_from_window)
	_ = gt.input_event_with_modifiers_is_command_or_control_autoremap(input_event_with_modifiers)
	_ = gt.input_event_with_modifiers_is_command_or_control_pressed(input_event_with_modifiers)
	_ = gt.input_event_with_modifiers_is_alt_pressed(input_event_with_modifiers)
	_ = gt.input_event_with_modifiers_is_shift_pressed(input_event_with_modifiers)
	_ = gt.input_event_with_modifiers_is_ctrl_pressed(input_event_with_modifiers)
	_ = gt.input_event_with_modifiers_is_meta_pressed(input_event_with_modifiers)
	_ = gt.input_event_key_get_keycode(input_event_key)
	_ = gt.input_event_key_get_physical_keycode(input_event_key)
	_ = gt.input_event_key_get_key_label(input_event_key)
	_ = gt.input_event_key_get_unicode(input_event_key)
	_ = gt.input_event_key_get_location(input_event_key)
	_ = gt.input_event_key_get_keycode_with_modifiers(input_event_key)
	_ = gt.input_event_key_get_physical_keycode_with_modifiers(input_event_key)
	_ = gt.input_event_key_get_key_label_with_modifiers(input_event_key)
	_ = gt.input_event_key_as_text_keycode(input_event_key)
	_ = gt.input_event_key_as_text_physical_keycode(input_event_key)
	_ = gt.input_event_key_as_text_key_label(input_event_key)
	_ = gt.input_event_key_as_text_location(input_event_key)
	_ = gt.input_event_mouse_get_position(input_event_mouse)
	_ = gt.input_event_mouse_get_global_position(input_event_mouse)
	_ = gt.input_event_mouse_button_get_factor(input_event_mouse_button)
	_ = gt.input_event_mouse_button_get_button_index(input_event_mouse_button)
	_ = gt.input_event_mouse_button_is_double_click(input_event_mouse_button)
	_ = gt.input_event_mouse_motion_get_tilt(input_event_mouse_motion)
	_ = gt.input_event_mouse_motion_get_pressure(input_event_mouse_motion)
	_ = gt.input_event_mouse_motion_get_pen_inverted(input_event_mouse_motion)
	_ = gt.input_event_mouse_motion_get_relative(input_event_mouse_motion)
	_ = gt.input_event_mouse_motion_get_screen_relative(input_event_mouse_motion)
	_ = gt.input_event_mouse_motion_get_velocity(input_event_mouse_motion)
	_ = gt.input_event_mouse_motion_get_screen_velocity(input_event_mouse_motion)
	_ = gt.viewport_as_node(viewport)
	_ = gt.viewport_as_object(viewport)
	_ = gt.object_is_viewport(object)
	_, _ = gt.object_try_as_viewport(object)
	_ = gt.node_is_viewport(node)
	_, _ = gt.node_try_as_viewport(node)
	_ = gt.node_get_viewport(node)
	_ = gt.viewport_get_canvas_transform(viewport)
	_ = gt.viewport_get_global_canvas_transform(viewport)
	_ = gt.viewport_get_stretch_transform(viewport)
	_ = gt.viewport_get_final_transform(viewport)
	_ = gt.viewport_get_screen_transform(viewport)
	_ = gt.viewport_get_visible_rect(viewport)
	_ = gt.viewport_has_transparent_background(viewport)
	_ = gt.viewport_is_using_hdr_2d(viewport)
	_ = gt.viewport_is_using_taa(viewport)
	_ = gt.viewport_is_using_debanding(viewport)
	_ = gt.viewport_is_using_occlusion_culling(viewport)
	_ = gt.viewport_is_using_oversampling(viewport)
	_ = gt.viewport_get_oversampling_override(viewport)
	_ = gt.viewport_get_oversampling(viewport)
	_ = gt.viewport_get_physics_object_picking(viewport)
	_ = gt.viewport_get_physics_object_picking_sort(viewport)
	_ = gt.viewport_get_physics_object_picking_first_only(viewport)
	_ = gt.viewport_get_viewport_rid(viewport)
	_ = gt.viewport_get_mouse_position(viewport)
	_ = gt.viewport_gui_is_dragging(viewport)
	_ = gt.viewport_gui_is_drag_successful(viewport)
	_ = gt.viewport_gui_get_focus_owner(viewport)
	_ = gt.viewport_gui_get_hovered_control(viewport)
	_ = gt.viewport_is_input_disabled(viewport)
	_ = gt.viewport_get_positional_shadow_atlas_size(viewport)
	_ = gt.viewport_get_positional_shadow_atlas_16_bits(viewport)
	_ = gt.viewport_is_snap_controls_to_pixels_enabled(viewport)
	_ = gt.viewport_is_snap_2d_transforms_to_pixel_enabled(viewport)
	_ = gt.viewport_is_snap_2d_vertices_to_pixel_enabled(viewport)
	_ = gt.viewport_is_input_handled(viewport)
	_ = gt.viewport_is_handling_input_locally(viewport)
	_ = gt.viewport_is_embedding_subwindows(viewport)
	_ = gt.viewport_get_drag_threshold(viewport)
	_ = gt.viewport_get_canvas_cull_mask(viewport)
	_ = gt.viewport_get_canvas_cull_mask_bit(viewport, 1)
	_ = gt.viewport_get_mesh_lod_threshold(viewport)
	_ = gt.viewport_is_audio_listener_2d(viewport)
	_ = gt.viewport_is_using_own_world_3d(viewport)
	_ = gt.viewport_is_3d_disabled(viewport)
	_ = gt.viewport_is_using_xr(viewport)
	_ = gt.viewport_get_scaling_3d_scale(viewport)
	_ = gt.viewport_get_fsr_sharpness(viewport)
	_ = gt.viewport_get_texture_mipmap_bias(viewport)
	_ = gt.input_event_is_nil(input_event)
	_ = gt.input_event_key_is_nil(input_event_key)
	_ = gt.input_event_mouse_button_is_nil(input_event_mouse_button)
	_ = gt.input_event_mouse_motion_is_nil(input_event_mouse_motion)
	_ = gt.viewport_is_nil(viewport)
	_ = gt.input_event_object_ptr(input_event)
	_ = gt.input_event_key_object_ptr(input_event_key)
	_ = gt.input_event_mouse_button_object_ptr(input_event_mouse_button)
	_ = gt.input_event_mouse_motion_object_ptr(input_event_mouse_motion)
	_ = gt.viewport_object_ptr(viewport)
	_, _ = gt.object_ptr_try_as_input_event(gt.input_event_object_ptr(input_event))
	_, _ = gt.object_ptr_try_as_input_event_key(gt.input_event_key_object_ptr(input_event_key))
	_, _ = gt.object_ptr_try_as_input_event_mouse_button(
		gt.input_event_mouse_button_object_ptr(input_event_mouse_button),
	)
	_, _ = gt.object_ptr_try_as_input_event_mouse_motion(
		gt.input_event_mouse_motion_object_ptr(input_event_mouse_motion),
	)
	_, _ = gt.object_ptr_try_as_viewport(gt.viewport_object_ptr(viewport))
	_, _ = gt.input_event_try_key(input_event)
	_, _ = gt.input_event_try_mouse_button(input_event)
	_, _ = gt.input_event_try_mouse_motion(input_event)
	_ = gt.input_event_action_pressed(input_event, meta_name)
	_ = gt.input_event_action_released(input_event, meta_name)
	_ = gt.input_event_action_strength(input_event, meta_name)
	input_callback_desc := gt.input_event_callback_descriptor(
		input = facade_input_event_callback,
		unhandled_input = facade_input_event_callback,
	)
	node_input_callback_desc := gt.node_input_event_callback_descriptor(
		input = facade_node_input_event_callback,
		unhandled_input = facade_node_input_event_callback,
	)
	_ = input_callback_desc
	_ = node_input_callback_desc
	_, _ = gt.input_event_key_code_checked(input_event)
	_, _ = gt.input_event_mouse_button_index_checked(input_event)
	_, _ = gt.input_event_mouse_position_checked(input_event)
	_, _ = gt.viewport_mouse_position_checked(viewport)
	_, _ = gt.viewport_focused_control_checked(viewport)
	_ = gt.Key(0)
	_ = gt.KeyLocation(0)
	_ = gt.MouseButton(0)
	_ = gt.node_get_tree(node)
	_ = gt.scene_tree_as_object(scene_tree)
	_ = gt.scene_tree_has_group(scene_tree, meta_name)
	_ = gt.scene_tree_is_accessibility_enabled(scene_tree)
	_ = gt.scene_tree_is_accessibility_supported(scene_tree)
	_ = gt.scene_tree_is_debugging_collisions_hint(scene_tree)
	_ = gt.scene_tree_is_debugging_paths_hint(scene_tree)
	_ = gt.scene_tree_is_debugging_navigation_hint(scene_tree)
	_ = gt.scene_tree_get_edited_scene_root(scene_tree)
	_ = gt.scene_tree_is_paused(scene_tree)
	_ = gt.scene_tree_get_node_count(scene_tree)
	_ = gt.scene_tree_get_frame(scene_tree)
	_ = gt.scene_tree_is_physics_interpolation_enabled(scene_tree)
	group_nodes := gt.scene_tree_get_nodes_in_group(scene_tree, meta_name)
	gt.typed_array_free(&group_nodes)
	_ = gt.scene_tree_get_first_node_in_group(scene_tree, meta_name)
	_ = gt.scene_tree_get_node_count_in_group(scene_tree, meta_name)
	_ = gt.scene_tree_get_current_scene(scene_tree)
	_ = gt.scene_tree_is_multiplayer_poll_enabled(scene_tree)
	_ = gt.object_is_scene_tree(object)
	_, _ = gt.object_try_as_scene_tree(object)

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
	_ = gt.input_is_nil(input)
	_ = gt.scene_tree_is_nil(scene_tree)
	_ = gt.object_ptr_as_object(gt.node_object_ptr(node))
	_ = gt.ref_counted_object_ptr(ref_counted)
	_ = gt.resource_object_ptr(resource)
	_ = gt.canvas_item_object_ptr(canvas_item)
	_ = gt.control_object_ptr(control)
	_ = gt.sprite2d_object_ptr(sprite2d)
	_ = gt.label_object_ptr(label)
	_ = gt.timer_object_ptr(timer)
	_ = gt.input_object_ptr(input)
	_ = gt.scene_tree_object_ptr(scene_tree)
	_ = gt.collision_object2d_object_ptr(collision_object2d)
	_ = gt.area2d_object_ptr(area2d)
	_ = gt.physics_body2d_object_ptr(physics_body2d)
	_ = gt.character_body2d_object_ptr(character_body2d)
	_ = gt.rigid_body2d_object_ptr(rigid_body2d)
	_ = gt.static_body2d_object_ptr(static_body2d)
	_ = gt.collision_shape2d_object_ptr(collision_shape2d)
	_ = gt.packed_scene_object_ptr(packed_scene)
	_ = gt.resource_loader_object_ptr(resource_loader)
	_, _ = gt.object_ptr_try_as_ref_counted(gt.ref_counted_object_ptr(ref_counted))
	_, _ = gt.object_ptr_try_as_resource(gt.resource_object_ptr(resource))
	_, _ = gt.object_ptr_try_as_node(gt.node_object_ptr(node))
	_, _ = gt.object_ptr_try_as_canvas_item(gt.canvas_item_object_ptr(canvas_item))
	_, _ = gt.object_ptr_try_as_node2d(gt.node2d_object_ptr(node2d))
	_, _ = gt.object_ptr_try_as_control(gt.control_object_ptr(control))
	_, _ = gt.object_ptr_try_as_sprite2d(gt.sprite2d_object_ptr(sprite2d))
	_, _ = gt.object_ptr_try_as_label(gt.label_object_ptr(label))
	_, _ = gt.object_ptr_try_as_timer(gt.timer_object_ptr(timer))
	_, _ = gt.object_ptr_try_as_collision_object2d(
		gt.collision_object2d_object_ptr(collision_object2d),
	)

	_ = gt.sprite2d_as_node2d(sprite2d)
	_ = gt.sprite2d_as_canvas_item(sprite2d)
	_ = gt.sprite2d_as_node(sprite2d)
	_ = gt.sprite2d_as_object(sprite2d)
	_ = gt.label_as_control(label)
	_ = gt.label_as_canvas_item(label)
	_ = gt.label_as_node(label)
	_ = gt.label_as_object(label)
	_ = gt.timer_as_node(timer)
	_ = gt.timer_as_object(timer)

	_ = gt.timer_is_nil(timer)
	_ = gt.collision_object2d_is_nil(collision_object2d)
	_ = gt.area2d_is_nil(area2d)
	_ = gt.physics_body2d_is_nil(physics_body2d)
	_ = gt.character_body2d_is_nil(character_body2d)
	_ = gt.rigid_body2d_is_nil(rigid_body2d)
	_ = gt.static_body2d_is_nil(static_body2d)
	_ = gt.collision_shape2d_is_nil(collision_shape2d)
	_ = gt.packed_scene_is_nil(packed_scene)
	gt.timer_set_wait_time(timer, 0.5)
	_ = gt.timer_get_wait_time(timer)
	gt.timer_set_one_shot(timer, true)
	_ = gt.timer_is_one_shot(timer)
	gt.timer_set_autostart(timer, false)
	_ = gt.timer_has_autostart(timer)
	gt.timer_start(timer, 0.25)
	gt.timer_start_default(timer)
	gt.timer_stop(timer)
	gt.timer_set_paused(timer, false)
	_ = gt.timer_is_paused(timer)
	gt.timer_set_ignore_time_scale(timer, true)
	_ = gt.timer_is_ignoring_time_scale(timer)
	_ = gt.timer_is_stopped(timer)
	_ = gt.timer_get_time_left(timer)

	_ = gt.collision_object2d_as_node2d(collision_object2d)
	_ = gt.collision_object2d_as_canvas_item(collision_object2d)
	_ = gt.collision_object2d_as_node(collision_object2d)
	_ = gt.collision_object2d_as_object(collision_object2d)
	collision_rid := gt.collision_object2d_get_rid(collision_object2d)
	gt.rid_free(&collision_rid)
	gt.collision_object2d_set_collision_layer(collision_object2d, 1)
	_ = gt.collision_object2d_get_collision_layer(collision_object2d)
	gt.collision_object2d_set_collision_mask(collision_object2d, 1)
	_ = gt.collision_object2d_get_collision_mask(collision_object2d)
	gt.collision_object2d_set_collision_layer_value(collision_object2d, 1, true)
	_ = gt.collision_object2d_get_collision_layer_value(collision_object2d, 1)
	gt.collision_object2d_set_collision_mask_value(collision_object2d, 1, true)
	_ = gt.collision_object2d_get_collision_mask_value(collision_object2d, 1)
	gt.collision_object2d_set_collision_priority(collision_object2d, 1)
	_ = gt.collision_object2d_get_collision_priority(collision_object2d)
	gt.collision_object2d_set_disable_mode(collision_object2d, .disable_mode_remove)
	_ = gt.collision_object2d_get_disable_mode(collision_object2d)
	gt.collision_object2d_set_pickable(collision_object2d, true)
	_ = gt.collision_object2d_is_pickable(collision_object2d)

	_ = gt.area2d_as_collision_object2d(area2d)
	_ = gt.area2d_as_node2d(area2d)
	_ = gt.area2d_as_canvas_item(area2d)
	_ = gt.area2d_as_node(area2d)
	_ = gt.area2d_as_object(area2d)
	gt.area2d_set_gravity_space_override_mode(area2d, .space_override_combine)
	_ = gt.area2d_get_gravity_space_override_mode(area2d)
	gt.area2d_set_gravity_is_point(area2d, false)
	_ = gt.area2d_is_gravity_a_point(area2d)
	gt.area2d_set_gravity_point_unit_distance(area2d, 1)
	_ = gt.area2d_get_gravity_point_unit_distance(area2d)
	gt.area2d_set_gravity_point_center(area2d, gt.Vector2{})
	_ = gt.area2d_get_gravity_point_center(area2d)
	gt.area2d_set_gravity_direction(area2d, gt.Vector2{0, 1})
	_ = gt.area2d_get_gravity_direction(area2d)
	gt.area2d_set_gravity(area2d, 9.8)
	_ = gt.area2d_get_gravity(area2d)
	gt.area2d_set_linear_damp_space_override_mode(area2d, .space_override_disabled)
	_ = gt.area2d_get_linear_damp_space_override_mode(area2d)
	gt.area2d_set_angular_damp_space_override_mode(area2d, .space_override_disabled)
	_ = gt.area2d_get_angular_damp_space_override_mode(area2d)
	gt.area2d_set_linear_damp(area2d, 0.1)
	_ = gt.area2d_get_linear_damp(area2d)
	gt.area2d_set_angular_damp(area2d, 0.2)
	_ = gt.area2d_get_angular_damp(area2d)
	gt.area2d_set_priority(area2d, 2)
	_ = gt.area2d_get_priority(area2d)
	gt.area2d_set_monitoring(area2d, true)
	_ = gt.area2d_is_monitoring(area2d)
	gt.area2d_set_monitorable(area2d, true)
	_ = gt.area2d_is_monitorable(area2d)
	_ = gt.area2d_has_overlapping_bodies(area2d)
	_ = gt.area2d_has_overlapping_areas(area2d)
	gt.area2d_set_audio_bus_name(area2d, meta_name)
	audio_bus := gt.area2d_get_audio_bus_name(area2d)
	gt.string_name_free(&audio_bus)
	gt.area2d_set_audio_bus_override(area2d, false)
	_ = gt.area2d_is_overriding_audio_bus(area2d)
	bodies := gt.area2d_get_overlapping_bodies(area2d)
	_ = gt.typed_array_size(&bodies)
	_, _ = gt.typed_array_get_node2d(&bodies, 0)
	_, _ = gt.typed_array_get_collision_object2d(&bodies, 0)
	gt.typed_array_free(&bodies)
	areas := gt.area2d_get_overlapping_areas(area2d)
	_, _ = gt.typed_array_get_area2d(&areas, 0)
	gt.typed_array_free(&areas)

	_ = gt.physics_body2d_as_collision_object2d(physics_body2d)
	_ = gt.physics_body2d_as_node2d(physics_body2d)
	_ = gt.physics_body2d_as_canvas_item(physics_body2d)
	_ = gt.physics_body2d_as_node(physics_body2d)
	_ = gt.physics_body2d_as_object(physics_body2d)
	_ = gt.physics_body2d_get_gravity(physics_body2d)
	physics_exceptions := gt.physics_body2d_get_collision_exceptions(physics_body2d)
	gt.typed_array_free(&physics_exceptions)
	gt.physics_body2d_add_collision_exception_with(physics_body2d, node)
	gt.physics_body2d_remove_collision_exception_with(physics_body2d, node)

	_ = gt.character_body2d_as_physics_body2d(character_body2d)
	_ = gt.character_body2d_as_collision_object2d(character_body2d)
	_ = gt.character_body2d_as_node2d(character_body2d)
	_ = gt.character_body2d_as_canvas_item(character_body2d)
	_ = gt.character_body2d_as_node(character_body2d)
	_ = gt.character_body2d_as_object(character_body2d)
	gt.character_body2d_set_velocity(character_body2d, gt.Vector2{10, -4})
	_ = gt.character_body2d_get_velocity(character_body2d)
	_ = gt.character_body2d_move_and_slide(character_body2d)
	gt.character_body2d_apply_floor_snap(character_body2d)
	gt.character_body2d_set_safe_margin(character_body2d, 0.08)
	_ = gt.character_body2d_get_safe_margin(character_body2d)
	gt.character_body2d_set_up_direction(character_body2d, gt.Vector2{0, -1})
	_ = gt.character_body2d_get_up_direction(character_body2d)
	_ = gt.character_body2d_is_on_floor(character_body2d)
	_ = gt.character_body2d_is_on_wall(character_body2d)
	_ = gt.character_body2d_get_real_velocity(character_body2d)

	_ = gt.rigid_body2d_as_physics_body2d(rigid_body2d)
	_ = gt.rigid_body2d_as_collision_object2d(rigid_body2d)
	_ = gt.rigid_body2d_as_node2d(rigid_body2d)
	_ = gt.rigid_body2d_as_canvas_item(rigid_body2d)
	_ = gt.rigid_body2d_as_node(rigid_body2d)
	_ = gt.rigid_body2d_as_object(rigid_body2d)
	gt.rigid_body2d_set_mass(rigid_body2d, 2)
	_ = gt.rigid_body2d_get_mass(rigid_body2d)
	gt.rigid_body2d_set_gravity_scale(rigid_body2d, 1)
	_ = gt.rigid_body2d_get_gravity_scale(rigid_body2d)
	gt.rigid_body2d_set_linear_velocity(rigid_body2d, gt.Vector2{1, 2})
	_ = gt.rigid_body2d_get_linear_velocity(rigid_body2d)
	gt.rigid_body2d_set_contact_monitor(rigid_body2d, true)
	_ = gt.rigid_body2d_is_contact_monitor_enabled(rigid_body2d)
	_ = gt.rigid_body2d_get_contact_count(rigid_body2d)
	gt.rigid_body2d_apply_central_impulse(rigid_body2d, gt.Vector2{0, -10})
	gt.rigid_body2d_apply_central_force(rigid_body2d, gt.Vector2{0, 10})
	rigid_contacts := gt.rigid_body2d_get_colliding_bodies(rigid_body2d)
	gt.typed_array_free(&rigid_contacts)

	_ = gt.static_body2d_as_physics_body2d(static_body2d)
	_ = gt.static_body2d_as_collision_object2d(static_body2d)
	_ = gt.static_body2d_as_node2d(static_body2d)
	_ = gt.static_body2d_as_canvas_item(static_body2d)
	_ = gt.static_body2d_as_node(static_body2d)
	_ = gt.static_body2d_as_object(static_body2d)
	gt.static_body2d_set_constant_linear_velocity(static_body2d, gt.Vector2{3, 0})
	_ = gt.static_body2d_get_constant_linear_velocity(static_body2d)
	gt.static_body2d_set_constant_angular_velocity(static_body2d, 0.5)
	_ = gt.static_body2d_get_constant_angular_velocity(static_body2d)

	_ = gt.collision_shape2d_as_node2d(collision_shape2d)
	_ = gt.collision_shape2d_as_canvas_item(collision_shape2d)
	_ = gt.collision_shape2d_as_node(collision_shape2d)
	_ = gt.collision_shape2d_as_object(collision_shape2d)
	gt.collision_shape2d_set_disabled(collision_shape2d, false)
	_ = gt.collision_shape2d_is_disabled(collision_shape2d)
	gt.collision_shape2d_set_one_way_collision_direction(collision_shape2d, gt.Vector2{0, -1})
	_ = gt.collision_shape2d_get_one_way_collision_direction(collision_shape2d)
	gt.collision_shape2d_set_debug_color(collision_shape2d, gt.Color{1, 0, 0, 1})
	_ = gt.collision_shape2d_get_debug_color(collision_shape2d)

	_ = gt.packed_scene_as_resource(packed_scene)
	_ = gt.packed_scene_as_ref_counted(packed_scene)
	_ = gt.packed_scene_as_object(packed_scene)
	_ = gt.packed_scene_pack(packed_scene, node)
	_ = gt.packed_scene_can_instantiate(packed_scene)
	_, _ = gt.packed_scene_instantiate_node_checked(packed_scene)
	_ = gt.packed_scene_instantiate_node
	_, _, _ = gt.packed_scene_instantiate_node2d_checked(packed_scene)

	_ = gt.object_is_sprite2d(object)
	_, _ = gt.object_try_as_sprite2d(object)
	_ = gt.object_is_label(object)
	_, _ = gt.object_try_as_label(object)
	_ = gt.object_is_timer(object)
	_, _ = gt.object_try_as_timer(object)
	_ = gt.object_is_collision_object2d(object)
	_, _ = gt.object_try_as_collision_object2d(object)
	_ = gt.object_is_area2d(object)
	_, _ = gt.object_try_as_area2d(object)
	_ = gt.object_is_physics_body2d(object)
	_, _ = gt.object_try_as_physics_body2d(object)
	_ = gt.object_is_character_body2d(object)
	_, _ = gt.object_try_as_character_body2d(object)
	_ = gt.object_is_rigid_body2d(object)
	_, _ = gt.object_try_as_rigid_body2d(object)
	_ = gt.object_is_static_body2d(object)
	_, _ = gt.object_try_as_static_body2d(object)
	_ = gt.object_is_collision_shape2d(object)
	_, _ = gt.object_try_as_collision_shape2d(object)
	_, _ = gt.object_ptr_try_as_physics_body2d(gt.physics_body2d_object_ptr(physics_body2d))
	_, _ = gt.object_ptr_try_as_character_body2d(gt.character_body2d_object_ptr(character_body2d))
	_, _ = gt.object_ptr_try_as_rigid_body2d(gt.rigid_body2d_object_ptr(rigid_body2d))
	_, _ = gt.object_ptr_try_as_static_body2d(gt.static_body2d_object_ptr(static_body2d))
	_, _ = gt.object_ptr_try_as_collision_shape2d(
		gt.collision_shape2d_object_ptr(collision_shape2d),
	)
	physics_body_array := gt.physics_body2d_get_collision_exceptions(physics_body2d)
	_, _ = gt.typed_array_get_physics_body2d(&physics_body_array, 0)
	gt.typed_array_free(&physics_body_array)
	_ = gt.collision_object2d_is_physics_body2d(collision_object2d)
	_, _ = gt.collision_object2d_try_as_physics_body2d(collision_object2d)
	_ = gt.collision_object2d_is_character_body2d(collision_object2d)
	_, _ = gt.collision_object2d_try_as_character_body2d(collision_object2d)
	_ = gt.collision_object2d_is_rigid_body2d(collision_object2d)
	_, _ = gt.collision_object2d_try_as_rigid_body2d(collision_object2d)
	_ = gt.collision_object2d_is_static_body2d(collision_object2d)
	_, _ = gt.collision_object2d_try_as_static_body2d(collision_object2d)
	_ = gt.physics_body2d_is_character_body2d(physics_body2d)
	_, _ = gt.physics_body2d_try_as_character_body2d(physics_body2d)
	_ = gt.physics_body2d_is_rigid_body2d(physics_body2d)
	_, _ = gt.physics_body2d_try_as_rigid_body2d(physics_body2d)
	_ = gt.physics_body2d_is_static_body2d(physics_body2d)
	_, _ = gt.physics_body2d_try_as_static_body2d(physics_body2d)
	_ = gt.node_is_collision_shape2d(node)
	_, _ = gt.node_try_as_collision_shape2d(node)
	_ = gt.canvas_item_is_collision_shape2d(canvas_item)
	_, _ = gt.canvas_item_try_as_collision_shape2d(canvas_item)
	_ = gt.node2d_is_collision_shape2d(node2d)
	_, _ = gt.node2d_try_as_collision_shape2d(node2d)
	_ = gt.object_is_packed_scene(object)
	_, _ = gt.object_try_as_packed_scene(object)
	_ = gt.object_is_resource_loader(object)
	_, _ = gt.object_try_as_resource_loader(object)
	_, _ = gt.object_ptr_try_as_resource_loader(gt.resource_loader_object_ptr(resource_loader))
	_ = gt.node_is_sprite2d(node)
	_, _ = gt.node_try_as_sprite2d(node)
	_ = gt.node_is_label(node)
	_, _ = gt.node_try_as_label(node)
	_ = gt.node_is_timer(node)
	_, _ = gt.node_try_as_timer(node)
	_ = gt.canvas_item_is_sprite2d(canvas_item)
	_, _ = gt.canvas_item_try_as_sprite2d(canvas_item)
	_ = gt.canvas_item_is_label(canvas_item)
	_, _ = gt.canvas_item_try_as_label(canvas_item)
	_ = gt.canvas_item_is_collision_object2d(canvas_item)
	_, _ = gt.canvas_item_try_as_collision_object2d(canvas_item)
	_ = gt.canvas_item_is_area2d(canvas_item)
	_, _ = gt.canvas_item_try_as_area2d(canvas_item)
	_ = gt.node2d_is_sprite2d(node2d)
	_, _ = gt.node2d_try_as_sprite2d(node2d)
	_ = gt.node2d_is_collision_object2d(node2d)
	_, _ = gt.node2d_try_as_collision_object2d(node2d)
	_ = gt.node2d_is_area2d(node2d)
	_, _ = gt.node2d_try_as_area2d(node2d)
	_ = gt.collision_object2d_is_area2d(collision_object2d)
	_, _ = gt.collision_object2d_try_as_area2d(collision_object2d)
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

facade_ready_virtual :: proc(instance: gt.ClassInstancePtr, node: gt.Node, reversed: bool) {
	_ = instance
	_ = node
	_ = reversed
}


facade_input_event_callback :: proc(instance: gt.ClassInstancePtr, event: gt.InputEvent) -> bool {
	_ = instance
	_ = gt.input_event_object_ptr(event)
	return true
}

facade_node_input_event_callback :: proc(
	instance: gt.ClassInstancePtr,
	node: gt.Node,
	event: gt.InputEvent,
) -> bool {
	_ = instance
	_ = gt.node_object_ptr(node)
	_ = gt.input_event_object_ptr(event)
	return true
}

facade_process_virtual :: proc(
	instance: gt.ClassInstancePtr,
	node: gt.Node,
	delta: gt.GodotReal,
	reversed: bool,
) {
	_ = instance
	_ = node
	_ = delta
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

facade_node_virtual_descriptor := gt.node_virtual_callback_descriptor(
	ready = facade_ready_virtual,
	process = facade_process_virtual,
	physics_process = facade_process_virtual,
	raw_notification = facade_raw_notification,
)

facade_notification :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	context = gt.godot_context()
	if gt.dispatch_node_lifecycle_callbacks(instance, what, reversed, &facade_node_lifecycle) do return
	_ = gt.dispatch_node_virtual_callbacks(instance, what, reversed, &facade_node_lifecycle)
	_ = gt.dispatch_node_virtual_descriptor(
		instance,
		gt.Node(nil),
		what,
		reversed,
		&facade_node_virtual_descriptor,
	)
	_ = gt.node_enable_process_callback(gt.Node(nil))
	_ = gt.node_disable_process_callback(gt.Node(nil))
	_ = gt.node_enable_physics_process_callback(gt.Node(nil))
	_ = gt.node_disable_physics_process_callback(gt.Node(nil))
	_ = gt.dispatch_input_event_callback(instance, gt.ObjectPtr(nil), facade_input_event_callback)
	_ = gt.dispatch_node_input_event_callback(
		instance,
		gt.Node(nil),
		gt.ObjectPtr(nil),
		facade_node_input_event_callback,
	)
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
	_ = gt.ref_counted_is_packed_scene(ref_counted)
	_, _ = gt.ref_counted_try_as_packed_scene(ref_counted)
	_ = gt.resource_is_packed_scene(resource)
	_, _ = gt.resource_try_as_packed_scene(resource)
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
