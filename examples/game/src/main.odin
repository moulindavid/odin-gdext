package game

import gt "godot:godot"

GameBrain :: distinct gt.ObjectPtr

GameBrainData :: struct {
	object:       gt.ObjectPtr,
	difficulty:   gt.GodotReal,
	process_tick: i64,
	input_tick:   i64,
	icon_texture: gt.OwnedResource,
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
	if !gt.owned_resource_is_nil(self.icon_texture) {
		gt.owned_resource_destroy(&self.icon_texture)
	}
	free(self)
}

game_ready :: proc(instance: gt.ClassInstancePtr, node: gt.Node, reversed: bool) {
	_ = reversed
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return

	_ = gt.node_enable_process_callback(node)
	_ = gt.dispatch_node_input_event_callback(
		instance,
		node,
		gt.ObjectPtr(nil),
		game_input_callbacks.input,
	)
	gt.debug_print("[odin-gdext] GameBrain ready virtual callback")
	if loader, loader_ok := gt.resource_loader_singleton_checked(); loader_ok {
		_, _, _, diagnostic, diagnostic_ok :=
			gt.resource_loader_load_texture2d_owned_diagnostic_checked(
				loader,
				nil,
				gt.diagnostic_descriptor("load optional texture", "nil path smoke"),
			)
		if !diagnostic_ok {
			gt.debug_print_diagnostic(diagnostic)
		}
	}
	gt.object_emit_signal_1_godot_real(self.object, damage_rolled_signal_name, self.difficulty)
}

game_process :: proc(
	instance: gt.ClassInstancePtr,
	node: gt.Node,
	delta: gt.GodotReal,
	reversed: bool,
) {
	_ = reversed
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return

	self.process_tick += 1
	self.difficulty += delta
	if self.process_tick >= 1 {
		_ = gt.node_disable_process_callback(node)
	}
}

game_input_event :: proc(
	instance: gt.ClassInstancePtr,
	node: gt.Node,
	event: gt.InputEvent,
) -> bool {
	_ = node
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return false

	self.input_tick += 1
	_, _ = gt.input_event_key_code_checked(event)
	_, _ = gt.input_event_mouse_button_index_checked(event)
	_, _ = gt.input_event_mouse_position_checked(event)
	return true
}

game_unhandled_input_event :: proc(
	instance: gt.ClassInstancePtr,
	node: gt.Node,
	event: gt.InputEvent,
) -> bool {
	return game_input_event(instance, node, event)
}

game_virtuals := gt.NodeVirtualCallbackDescriptor {
		ready   = game_ready,
		process = game_process,
	}

game_input_callbacks := gt.NodeInputEventCallbackDescriptor {
		input           = game_input_event,
		unhandled_input = game_unhandled_input_event,
	}

notification_func :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	context = gt.godot_context()
	self, self_ok := gt.class_instance_data(instance, GameBrainData)
	if !self_ok do return
	node, node_ok := gt.object_ptr_try_as_node(self.object)
	if !node_ok do return
	if gt.dispatch_node_virtual_descriptor(instance, node, what, reversed, &game_virtuals) do return
}

ensure_icon_texture :: proc "contextless" (
	self: ^GameBrainData,
) -> (
	texture: gt.Texture2D,
	ok: bool,
) {
	if self == nil do return {}, false
	if !gt.owned_resource_is_nil(self.icon_texture) {
		return gt.owned_resource_try_as_texture2d(self.icon_texture)
	}
	loader, loader_ok := gt.resource_loader_singleton_checked()
	if !loader_ok do return {}, false
	path := gt.string_from_utf8("res://odin_texture.tres")
	defer gt.string_free(&path)
	owned, loaded_texture, err, loaded_ok := gt.resource_loader_load_texture2d_owned_checked(
		loader,
		&path,
	)
	gt.require_call_ok(&err)
	if !loaded_ok do return {}, false
	self.icon_texture = gt.owned_resource_take(&owned)
	return loaded_texture, true
}

roll_damage :: proc "contextless" (self: ^GameBrainData) -> gt.GodotReal {
	base := 6.0 + gt.randf() * 12.0
	wave := gt.sin(base) + gt.cos(base * 0.5)
	value := (base + wave) * self.difficulty
	gt.object_emit_signal_1_godot_real(self.object, damage_rolled_signal_name, value)
	return value
}

exercise_input_viewport_helpers :: proc "contextless" (parent: gt.Node) {
	viewport := gt.node_get_viewport(parent)
	if !gt.viewport_is_nil(viewport) {
		_, _ = gt.viewport_mouse_position_checked(viewport)
		_, _ = gt.viewport_focused_control_checked(viewport)
		_ = gt.viewport_get_visible_rect(viewport)
		_ = gt.viewport_get_mouse_position(viewport)
		_ = gt.viewport_get_viewport_rid(viewport)
		_ = gt.viewport_is_input_disabled(viewport)
		if window, window_ok := gt.viewport_try_as_window(viewport); window_ok {
			_ = gt.window_get_window_id(window)
			_ = gt.window_get_size(window)
			_ = gt.window_is_visible(window)
		}
	}

	window := gt.node_get_window(parent)
	if !gt.window_is_nil(window) {
		title := gt.string_from_utf8("Odin GDExtension Game")
		gt.window_set_title(window, &title)
		gt.string_free(&title)
		current_title := gt.window_get_title(window)
		gt.string_free(&current_title)
		_ = gt.window_get_current_screen(window)
		_ = gt.window_get_position(window)
		_ = gt.window_get_size(window)
		_ = gt.window_get_position_with_decorations(window)
		_ = gt.window_get_size_with_decorations(window)
		_ = gt.window_get_contents_minimum_size(window)
		_ = gt.window_get_content_scale_size(window)
		_ = gt.window_get_content_scale_factor(window)
		_ = gt.window_get_window_id(window)
		_ = gt.window_is_embedded(window)
		_ = gt.window_can_draw(window)
	}

	if tree := gt.node_get_tree(parent); !gt.scene_tree_is_nil(tree) {
		root := gt.scene_tree_get_root(tree)
		if !gt.window_is_nil(root) {
			_ = gt.window_get_window_id(root)
			_ = gt.window_get_size(root)
		}
	}

	event := gt.InputEvent(nil)
	_, key_ok := gt.input_event_try_key(event)
	_, button_ok := gt.input_event_try_mouse_button(event)
	_, motion_ok := gt.input_event_try_mouse_motion(event)
	_ = !key_ok && !button_ok && !motion_ok
}

configure_physics_nodes :: proc "contextless" (parent: gt.Node, damage: gt.GodotReal) {
	character_object := gt.construct_object(character_body2d_class_name)
	if character, character_ok := gt.object_ptr_try_as_character_body2d(character_object);
	   character_ok {
		gt.character_body2d_set_velocity(character, gt.Vector2{f32(damage), f32(-damage * 0.25)})
		gt.character_body2d_set_safe_margin(character, 0.08)
		gt.character_body2d_set_up_direction(character, gt.Vector2{0, -1})
		_ = gt.character_body2d_get_velocity(character)
		_ = gt.character_body2d_get_safe_margin(character)
		_ = gt.character_body2d_get_up_direction(character)
		_ = gt.character_body2d_is_on_floor(character)
		_ = gt.character_body2d_is_on_wall(character)
		_ = gt.character_body2d_get_real_velocity(character)
		physics := gt.character_body2d_as_physics_body2d(character)
		exceptions := gt.physics_body2d_get_collision_exceptions(physics)
		gt.typed_array_free(&exceptions)
		if !gt.node_add_child_checked(parent, gt.character_body2d_as_node(character)) {
			_ = gt.object_destroy_checked(gt.character_body2d_object_ptr(character))
		}
	} else if character_object != nil {
		_ = gt.object_destroy_checked(character_object)
	}

	rigid_object := gt.construct_object(rigid_body2d_class_name)
	if rigid, rigid_ok := gt.object_ptr_try_as_rigid_body2d(rigid_object); rigid_ok {
		gt.rigid_body2d_set_mass(rigid, 2)
		gt.rigid_body2d_set_gravity_scale(rigid, 1)
		gt.rigid_body2d_set_linear_velocity(rigid, gt.Vector2{f32(damage * 0.1), 0})
		gt.rigid_body2d_set_contact_monitor(rigid, true)
		gt.rigid_body2d_apply_central_impulse(rigid, gt.Vector2{0, f32(-damage)})
		gt.rigid_body2d_apply_central_force(rigid, gt.Vector2{0, f32(damage)})
		_ = gt.rigid_body2d_get_mass(rigid)
		_ = gt.rigid_body2d_get_gravity_scale(rigid)
		_ = gt.rigid_body2d_get_linear_velocity(rigid)
		_ = gt.rigid_body2d_is_contact_monitor_enabled(rigid)
		_ = gt.rigid_body2d_get_contact_count(rigid)
		contacts := gt.rigid_body2d_get_colliding_bodies(rigid)
		gt.typed_array_free(&contacts)
		if !gt.node_add_child_checked(parent, gt.rigid_body2d_as_node(rigid)) {
			_ = gt.object_destroy_checked(gt.rigid_body2d_object_ptr(rigid))
		}
	} else if rigid_object != nil {
		_ = gt.object_destroy_checked(rigid_object)
	}

	static_object := gt.construct_object(static_body2d_class_name)
	if static_body, static_ok := gt.object_ptr_try_as_static_body2d(static_object); static_ok {
		gt.static_body2d_set_constant_linear_velocity(
			static_body,
			gt.Vector2{f32(damage * 0.05), 0},
		)
		gt.static_body2d_set_constant_angular_velocity(static_body, 0.25)
		_ = gt.static_body2d_get_constant_linear_velocity(static_body)
		_ = gt.static_body2d_get_constant_angular_velocity(static_body)
		if !gt.node_add_child_checked(parent, gt.static_body2d_as_node(static_body)) {
			_ = gt.object_destroy_checked(gt.static_body2d_object_ptr(static_body))
		}
	} else if static_object != nil {
		_ = gt.object_destroy_checked(static_object)
	}

	shape_object := gt.construct_object(collision_shape2d_class_name)
	if shape, shape_ok := gt.object_ptr_try_as_collision_shape2d(shape_object); shape_ok {
		gt.collision_shape2d_set_disabled(shape, true)
		gt.collision_shape2d_set_one_way_collision_direction(shape, gt.Vector2{0, -1})
		gt.collision_shape2d_set_debug_color(shape, gt.Color{0.2, 0.8, 1.0, 0.5})
		_ = gt.collision_shape2d_is_disabled(shape)
		_ = gt.collision_shape2d_get_one_way_collision_direction(shape)
		_ = gt.collision_shape2d_get_debug_color(shape)
		if !gt.node_add_child_checked(parent, gt.collision_shape2d_as_node(shape)) {
			_ = gt.object_destroy_checked(gt.collision_shape2d_object_ptr(shape))
		}
	} else if shape_object != nil {
		_ = gt.object_destroy_checked(shape_object)
	}
}


configure_2d_gameplay_nodes :: proc "contextless" (parent: gt.Node, damage: gt.GodotReal) {
	camera_object := gt.construct_object(camera2d_class_name)
	if camera, camera_ok := gt.object_ptr_try_as_camera2d(camera_object); camera_ok {
		gt.camera2d_set_enabled(camera, true)
		gt.camera2d_set_zoom(camera, gt.Vector2{1.25, 1.25})
		gt.camera2d_set_position_smoothing_enabled(camera, true)
		gt.camera2d_set_position_smoothing_speed(camera, 4)
		gt.camera2d_set_offset(camera, gt.Vector2{f32(damage), f32(-damage * 0.25)})
		_ = gt.camera2d_get_zoom(camera)
		_ = gt.camera2d_get_offset(camera)
		_ = gt.camera2d_is_enabled(camera)
		_ = gt.camera2d_get_screen_center_position(camera)
		if !gt.node_add_child_checked(parent, gt.camera2d_as_node(camera)) {
			_ = gt.object_destroy_checked(gt.camera2d_object_ptr(camera))
		}
	} else if camera_object != nil {
		_ = gt.object_destroy_checked(camera_object)
	}

	marker_object := gt.construct_object(marker2d_class_name)
	if marker, marker_ok := gt.object_ptr_try_as_marker2d(marker_object); marker_ok {
		marker_node := gt.marker2d_as_node2d(marker)
		gt.node2d_set_position(marker_node, gt.Vector2{f32(damage * 2), f32(damage)})
		gt.marker2d_set_gizmo_extents(marker, 12)
		_ = gt.marker2d_get_gizmo_extents(marker)
		if !gt.node_add_child_checked(parent, gt.marker2d_as_node(marker)) {
			_ = gt.object_destroy_checked(gt.marker2d_object_ptr(marker))
		}
	} else if marker_object != nil {
		_ = gt.object_destroy_checked(marker_object)
	}

	raycast_object := gt.construct_object(ray_cast2d_class_name)
	if raycast, raycast_ok := gt.object_ptr_try_as_ray_cast2d(raycast_object); raycast_ok {
		gt.ray_cast2d_set_enabled(raycast, true)
		gt.ray_cast2d_set_target_position(raycast, gt.Vector2{0, 96})
		gt.ray_cast2d_set_collision_mask(raycast, 1)
		gt.ray_cast2d_set_collide_with_bodies(raycast, true)
		gt.ray_cast2d_set_collide_with_areas(raycast, true)
		if gt.node_add_child_checked(parent, gt.ray_cast2d_as_node(raycast)) {
			gt.ray_cast2d_force_raycast_update(raycast)
			_ = gt.ray_cast2d_get_target_position(raycast)
			_ = gt.ray_cast2d_is_colliding(raycast)
			_ = gt.ray_cast2d_get_collision_point(raycast)
			_ = gt.ray_cast2d_get_collision_normal(raycast)
			collider_rid := gt.ray_cast2d_get_collider_rid(raycast)
			gt.rid_free(&collider_rid)
		} else {
			_ = gt.object_destroy_checked(gt.ray_cast2d_object_ptr(raycast))
		}
	} else if raycast_object != nil {
		_ = gt.object_destroy_checked(raycast_object)
	}

	navigation_agent_object := gt.construct_object(navigation_agent2d_class_name)
	if agent, agent_ok := gt.object_ptr_try_as_navigation_agent2d(navigation_agent_object);
	   agent_ok {
		gt.navigation_agent2d_set_radius(agent, 12)
		gt.navigation_agent2d_set_max_speed(agent, 160)
		gt.navigation_agent2d_set_path_desired_distance(agent, 8)
		gt.navigation_agent2d_set_target_desired_distance(agent, 6)
		gt.navigation_agent2d_set_navigation_layers(agent, 1)
		gt.navigation_agent2d_set_navigation_layer_value(agent, 1, true)
		gt.navigation_agent2d_set_target_position(agent, gt.Vector2{f32(damage), 64})
		gt.navigation_agent2d_set_simplify_path(agent, true)
		gt.navigation_agent2d_set_debug_enabled(agent, true)
		gt.navigation_agent2d_set_debug_use_custom(agent, true)
		gt.navigation_agent2d_set_debug_path_custom_color(agent, gt.Color{0.2, 1.0, 0.4, 1.0})
		gt.navigation_agent2d_set_debug_path_custom_point_size(agent, 4)
		gt.navigation_agent2d_set_debug_path_custom_line_width(agent, 2)
		_ = gt.navigation_agent2d_get_radius(agent)
		_ = gt.navigation_agent2d_get_max_speed(agent)
		_ = gt.navigation_agent2d_get_path_desired_distance(agent)
		_ = gt.navigation_agent2d_get_target_position(agent)
		_ = gt.navigation_agent2d_get_navigation_layers(agent)
		_ = gt.navigation_agent2d_get_debug_path_custom_color(agent)
		_ = gt.navigation_agent2d_is_navigation_finished(agent)
		if !gt.node_add_child_checked(parent, gt.navigation_agent2d_as_node(agent)) {
			_ = gt.object_destroy_checked(gt.navigation_agent2d_object_ptr(agent))
		}
	} else if navigation_agent_object != nil {
		_ = gt.object_destroy_checked(navigation_agent_object)
	}

	theme_object := gt.construct_object(theme_class_name)
	if theme, theme_ok := gt.object_ptr_try_as_theme(theme_object); theme_ok {
		owned_theme, owned_theme_ok := gt.owned_resource_init_owned(gt.theme_as_resource(theme))
		if owned_theme_ok {
			item_name := gt.string_name_from_utf8_cstring(cstring("value"))
			type_name := gt.string_name_from_utf8_cstring(cstring("Label"))
			type_string := gt.string_from_utf8("Label")
			gt.theme_set_default_base_scale(theme, 1)
			_ = gt.theme_get_default_base_scale(theme)
			_ = gt.theme_has_default_base_scale(theme)
			gt.theme_set_default_font_size(theme, 16)
			_ = gt.theme_get_default_font_size(theme)
			_ = gt.theme_has_default_font_size(theme)
			gt.theme_set_color(theme, &item_name, &type_name, gt.Color{1, 1, 1, 1})
			_ = gt.theme_get_color(theme, &item_name, &type_name)
			_ = gt.theme_has_color(theme, &item_name, &type_name)
			gt.theme_clear_color(theme, &item_name, &type_name)
			gt.theme_set_constant(theme, &item_name, &type_name, 1)
			_ = gt.theme_get_constant(theme, &item_name, &type_name)
			_ = gt.theme_has_constant(theme, &item_name, &type_name)
			gt.theme_clear_constant(theme, &item_name, &type_name)
			theme_color_list := gt.theme_get_color_list(theme, &type_string)
			gt.packed_string_array_free(&theme_color_list)
			theme_type_list := gt.theme_get_type_list(theme)
			gt.packed_string_array_free(&theme_type_list)
			gt.string_free(&type_string)
			gt.string_name_free(&type_name)
			gt.string_name_free(&item_name)
			_ = gt.owned_resource_destroy(&owned_theme)
		} else {
			_ = gt.object_destroy_checked(gt.theme_object_ptr(theme))
		}
	} else if theme_object != nil {
		_ = gt.object_destroy_checked(theme_object)
	}

	font_file_object := gt.construct_object(font_file_class_name)
	if font, font_ok := gt.object_ptr_try_as_font(font_file_object); font_ok {
		owned_font, owned_font_ok := gt.owned_resource_init_owned(gt.font_as_resource(font))
		if owned_font_ok {
			_ = gt.font_get_height(font, 16)
			_ = gt.font_get_height_default(font)
			_ = gt.font_get_ascent(font, 16)
			_ = gt.font_get_descent(font, 16)
			_ = gt.font_get_underline_position(font, 16)
			_ = gt.font_get_underline_thickness(font, 16)
			font_name := gt.font_get_font_name(font)
			gt.string_free(&font_name)
			font_style_name := gt.font_get_font_style_name(font)
			gt.string_free(&font_style_name)
			_ = gt.font_get_font_weight(font)
			_ = gt.font_get_font_stretch(font)
			_ = gt.font_get_palette_count(font)
			_ = gt.font_get_char_size(font, i64('A'), 16)
			_ = gt.font_has_char(font, i64('A'))
			supported_chars := gt.font_get_supported_chars(font)
			gt.string_free(&supported_chars)
			_ = gt.font_get_face_count(font)
			_ = gt.owned_resource_destroy(&owned_font)
		} else {
			_ = gt.object_destroy_checked(gt.font_object_ptr(font))
		}
	} else if font_file_object != nil {
		_ = gt.object_destroy_checked(font_file_object)
	}

	tile_map_object := gt.construct_object(tile_map_class_name)
	if tile_map, tile_map_ok := gt.object_ptr_try_as_tile_map(tile_map_object); tile_map_ok {
		gt.tile_map_set_rendering_quadrant_size(tile_map, 16)
		gt.tile_map_set_collision_animatable(tile_map, false)
		_ = gt.tile_map_get_rendering_quadrant_size(tile_map)
		_ = gt.tile_map_is_collision_animatable(tile_map)
		_ = gt.tile_map_get_layers_count(tile_map)
		_ = gt.tile_map_get_used_rect(tile_map)
		used_cells := gt.tile_map_get_used_cells(tile_map, 0)
		gt.typed_array_free(&used_cells)
		if !gt.node_add_child_checked(parent, gt.tile_map_as_node(tile_map)) {
			_ = gt.object_destroy_checked(gt.tile_map_object_ptr(tile_map))
		}
	} else if tile_map_object != nil {
		_ = gt.object_destroy_checked(tile_map_object)
	}

	tile_map_layer_object := gt.construct_object(tile_map_layer_class_name)
	if tile_layer, tile_layer_ok := gt.object_ptr_try_as_tile_map_layer(tile_map_layer_object);
	   tile_layer_ok {
		gt.tile_map_layer_set_enabled(tile_layer, true)
		gt.tile_map_layer_set_y_sort_origin(tile_layer, 0)
		gt.tile_map_layer_set_x_draw_order_reversed(tile_layer, false)
		gt.tile_map_layer_set_rendering_quadrant_size(tile_layer, 16)
		gt.tile_map_layer_set_collision_enabled(tile_layer, false)
		gt.tile_map_layer_set_use_kinematic_bodies(tile_layer, false)
		gt.tile_map_layer_set_physics_quadrant_size(tile_layer, 16)
		gt.tile_map_layer_set_occlusion_enabled(tile_layer, false)
		gt.tile_map_layer_set_navigation_enabled(tile_layer, false)
		_ = gt.tile_map_layer_is_enabled(tile_layer)
		_ = gt.tile_map_layer_get_y_sort_origin(tile_layer)
		_ = gt.tile_map_layer_is_x_draw_order_reversed(tile_layer)
		_ = gt.tile_map_layer_get_rendering_quadrant_size(tile_layer)
		_ = gt.tile_map_layer_is_collision_enabled(tile_layer)
		_ = gt.tile_map_layer_is_using_kinematic_bodies(tile_layer)
		_ = gt.tile_map_layer_get_physics_quadrant_size(tile_layer)
		_ = gt.tile_map_layer_is_occlusion_enabled(tile_layer)
		_ = gt.tile_map_layer_is_navigation_enabled(tile_layer)
		used_cells := gt.tile_map_layer_get_used_cells(tile_layer)
		gt.typed_array_free(&used_cells)
		_ = gt.tile_map_layer_get_used_rect(tile_layer)
		if !gt.node_add_child_checked(parent, gt.tile_map_layer_as_node(tile_layer)) {
			_ = gt.object_destroy_checked(gt.tile_map_layer_object_ptr(tile_layer))
		}
	} else if tile_map_layer_object != nil {
		_ = gt.object_destroy_checked(tile_map_layer_object)
	}

	curve_object := gt.construct_object(curve2d_class_name)
	path_object := gt.construct_object(path2d_class_name)
	if curve, curve_ok := gt.object_ptr_try_as_curve2d(curve_object); curve_ok {
		owned_curve, owned_curve_ok := gt.owned_resource_init_owned(gt.curve2d_as_resource(curve))
		if owned_curve_ok {
			gt.curve2d_add_point(curve, gt.Vector2{0, 0}, gt.Vector2{}, gt.Vector2{16, 0}, -1)
			gt.curve2d_add_point(curve, gt.Vector2{64, 24}, gt.Vector2{-16, 0}, gt.Vector2{}, -1)
			_ = gt.curve2d_get_point_count(curve)
			_ = gt.curve2d_get_point_position(curve, 0)
			gt.curve2d_set_bake_interval(curve, 8)
			_ = gt.curve2d_get_bake_interval(curve)
			_ = gt.curve2d_get_baked_length(curve)
			_ = gt.curve2d_sample(curve, 0, 0.5)
			_ = gt.curve2d_samplef(curve, 0.5)
			_ = gt.curve2d_sample_baked(curve, 8, false)
			_ = gt.curve2d_get_closest_point(curve, gt.Vector2{8, 8})
			_ = gt.curve2d_get_closest_offset(curve, gt.Vector2{8, 8})
			baked_points := gt.curve2d_get_baked_points(curve)
			gt.packed_vector2_array_free(&baked_points)
			if path, path_ok := gt.object_ptr_try_as_path2d(path_object); path_ok {
				gt.path2d_set_curve(path, curve)
				if !gt.node_add_child_checked(parent, gt.path2d_as_node(path)) {
					_ = gt.object_destroy_checked(gt.path2d_object_ptr(path))
				}
			} else if path_object != nil {
				_ = gt.object_destroy_checked(path_object)
			}
			_ = gt.owned_resource_destroy(&owned_curve)
		} else {
			_ = gt.object_destroy_checked(gt.curve2d_object_ptr(curve))
			if path_object != nil {
				_ = gt.object_destroy_checked(path_object)
			}
		}
	} else {
		if curve_object != nil {
			_ = gt.object_destroy_checked(curve_object)
		}
		if path_object != nil {
			_ = gt.object_destroy_checked(path_object)
		}
	}


	canvas_layer_object := gt.construct_object(canvas_layer_class_name)
	if canvas_layer, canvas_layer_ok := gt.object_ptr_try_as_canvas_layer(canvas_layer_object);
	   canvas_layer_ok {
		gt.canvas_layer_set_layer(canvas_layer, 2)
		_ = gt.canvas_layer_get_layer(canvas_layer)
		gt.canvas_layer_set_visible(canvas_layer, true)
		_ = gt.canvas_layer_is_visible(canvas_layer)
		gt.canvas_layer_hide(canvas_layer)
		gt.canvas_layer_show(canvas_layer)
		identity := gt.Transform2D {
			x      = gt.Vector2{1, 0},
			y      = gt.Vector2{0, 1},
			origin = gt.Vector2{},
		}
		gt.canvas_layer_set_transform(canvas_layer, identity)
		_ = gt.canvas_layer_get_transform(canvas_layer)
		_ = gt.canvas_layer_get_final_transform(canvas_layer)
		gt.canvas_layer_set_offset(canvas_layer, gt.Vector2{4, 8})
		_ = gt.canvas_layer_get_offset(canvas_layer)
		gt.canvas_layer_set_rotation(canvas_layer, 0.25)
		_ = gt.canvas_layer_get_rotation(canvas_layer)
		gt.canvas_layer_set_scale(canvas_layer, gt.Vector2{1, 1})
		_ = gt.canvas_layer_get_scale(canvas_layer)
		gt.canvas_layer_set_follow_viewport(canvas_layer, false)
		_ = gt.canvas_layer_is_following_viewport(canvas_layer)
		gt.canvas_layer_set_follow_viewport_scale(canvas_layer, 1)
		_ = gt.canvas_layer_get_follow_viewport_scale(canvas_layer)
		_ = gt.canvas_layer_get_custom_viewport(canvas_layer)
		canvas_rid := gt.canvas_layer_get_canvas(canvas_layer)
		gt.rid_free(&canvas_rid)
		if !gt.node_add_child_checked(parent, gt.canvas_layer_as_node(canvas_layer)) {
			_ = gt.object_destroy_checked(gt.canvas_layer_object_ptr(canvas_layer))
		}
	} else if canvas_layer_object != nil {
		_ = gt.object_destroy_checked(canvas_layer_object)
	}

	polygon2d_object := gt.construct_object(polygon2d_class_name)
	if polygon2d, polygon2d_ok := gt.object_ptr_try_as_polygon2d(polygon2d_object); polygon2d_ok {
		points := gt.packed_vector2_array_new()
		gt.packed_vector2_array_push(&points, gt.Vector2{0, 0})
		gt.packed_vector2_array_push(&points, gt.Vector2{32, 0})
		gt.packed_vector2_array_push(&points, gt.Vector2{0, 32})
		gt.polygon2d_set_polygon(polygon2d, &points)
		points_copy := gt.polygon2d_get_polygon(polygon2d)
		gt.packed_vector2_array_free(&points_copy)
		gt.polygon2d_set_uv(polygon2d, &points)
		uv_copy := gt.polygon2d_get_uv(polygon2d)
		gt.packed_vector2_array_free(&uv_copy)
		gt.packed_vector2_array_free(&points)
		vertex_colors := gt.packed_color_array_new()
		gt.polygon2d_set_vertex_colors(polygon2d, &vertex_colors)
		vertex_colors_copy := gt.polygon2d_get_vertex_colors(polygon2d)
		gt.packed_color_array_free(&vertex_colors_copy)
		gt.packed_color_array_free(&vertex_colors)
		gt.polygon2d_set_color(polygon2d, gt.Color{1, 0.5, 0.25, 1})
		gt.polygon2d_set_texture_offset(polygon2d, gt.Vector2{1, 2})
		gt.polygon2d_set_texture_rotation(polygon2d, 0.25)
		gt.polygon2d_set_texture_scale(polygon2d, gt.Vector2{1, 1})
		gt.polygon2d_set_invert_enabled(polygon2d, false)
		gt.polygon2d_set_antialiased(polygon2d, true)
		gt.polygon2d_set_invert_border(polygon2d, 4)
		gt.polygon2d_set_offset(polygon2d, gt.Vector2{2, 3})
		gt.polygon2d_clear_bones(polygon2d)
		gt.polygon2d_set_internal_vertex_count(polygon2d, 0)
		_ = gt.polygon2d_get_color(polygon2d)
		_ = gt.polygon2d_get_texture_offset(polygon2d)
		_ = gt.polygon2d_get_texture_rotation(polygon2d)
		_ = gt.polygon2d_get_texture_scale(polygon2d)
		_ = gt.polygon2d_get_invert_enabled(polygon2d)
		_ = gt.polygon2d_get_antialiased(polygon2d)
		_ = gt.polygon2d_get_invert_border(polygon2d)
		_ = gt.polygon2d_get_offset(polygon2d)
		_ = gt.polygon2d_get_bone_count(polygon2d)
		_ = gt.polygon2d_get_internal_vertex_count(polygon2d)
		if !gt.node_add_child_checked(parent, gt.polygon2d_as_node(polygon2d)) {
			_ = gt.object_destroy_checked(gt.polygon2d_object_ptr(polygon2d))
		}
	} else if polygon2d_object != nil {
		_ = gt.object_destroy_checked(polygon2d_object)
	}

	line2d_object := gt.construct_object(line2d_class_name)
	if line2d, line2d_ok := gt.object_ptr_try_as_line2d(line2d_object); line2d_ok {
		points := gt.packed_vector2_array_new()
		gt.packed_vector2_array_push(&points, gt.Vector2{0, 0})
		gt.packed_vector2_array_push(&points, gt.Vector2{32, 12})
		gt.line2d_set_points(line2d, &points)
		line_points_copy := gt.line2d_get_points(line2d)
		gt.packed_vector2_array_free(&line_points_copy)
		gt.packed_vector2_array_free(&points)
		gt.line2d_add_point(line2d, gt.Vector2{40, 16}, -1)
		gt.line2d_add_point_default(line2d, gt.Vector2{48, 24})
		gt.line2d_set_point_position(line2d, 0, gt.Vector2{1, 1})
		_ = gt.line2d_get_point_position(line2d, 0)
		_ = gt.line2d_get_point_count(line2d)
		gt.line2d_set_closed(line2d, false)
		gt.line2d_set_width(line2d, 2)
		gt.line2d_set_default_color(line2d, gt.Color{0.2, 0.6, 1, 1})
		gt.line2d_set_texture_mode(line2d, gt.Line2DLineTextureMode(0))
		gt.line2d_set_joint_mode(line2d, gt.Line2DLineJointMode(0))
		gt.line2d_set_begin_cap_mode(line2d, gt.Line2DLineCapMode(0))
		gt.line2d_set_end_cap_mode(line2d, gt.Line2DLineCapMode(0))
		gt.line2d_set_sharp_limit(line2d, 2)
		gt.line2d_set_round_precision(line2d, 4)
		gt.line2d_set_antialiased(line2d, true)
		_ = gt.line2d_is_closed(line2d)
		_ = gt.line2d_get_width(line2d)
		_ = gt.line2d_get_default_color(line2d)
		_ = gt.line2d_get_texture_mode(line2d)
		_ = gt.line2d_get_joint_mode(line2d)
		_ = gt.line2d_get_begin_cap_mode(line2d)
		_ = gt.line2d_get_end_cap_mode(line2d)
		_ = gt.line2d_get_sharp_limit(line2d)
		_ = gt.line2d_get_round_precision(line2d)
		_ = gt.line2d_get_antialiased(line2d)
		if !gt.node_add_child_checked(parent, gt.line2d_as_node(line2d)) {
			_ = gt.object_destroy_checked(gt.line2d_object_ptr(line2d))
		}
	} else if line2d_object != nil {
		_ = gt.object_destroy_checked(line2d_object)
	}

	back_buffer_copy_object := gt.construct_object(back_buffer_copy_class_name)
	if back_buffer_copy, back_buffer_copy_ok := gt.object_ptr_try_as_back_buffer_copy(
		back_buffer_copy_object,
	); back_buffer_copy_ok {
		gt.back_buffer_copy_set_rect(
			back_buffer_copy,
			gt.Rect2{position = gt.Vector2{-16, -16}, size = gt.Vector2{32, 32}},
		)
		_ = gt.back_buffer_copy_get_rect(back_buffer_copy)
		gt.back_buffer_copy_set_copy_mode(back_buffer_copy, gt.BackBufferCopyCopyMode(0))
		_ = gt.back_buffer_copy_get_copy_mode(back_buffer_copy)
		if !gt.node_add_child_checked(parent, gt.back_buffer_copy_as_node(back_buffer_copy)) {
			_ = gt.object_destroy_checked(gt.back_buffer_copy_object_ptr(back_buffer_copy))
		}
	} else if back_buffer_copy_object != nil {
		_ = gt.object_destroy_checked(back_buffer_copy_object)
	}

	collision_polygon_object := gt.construct_object(collision_polygon2d_class_name)
	if collision_polygon, collision_polygon_ok := gt.object_ptr_try_as_collision_polygon2d(
		collision_polygon_object,
	); collision_polygon_ok {
		polygon := gt.packed_vector2_array_new()
		gt.packed_vector2_array_push(&polygon, gt.Vector2{0, 0})
		gt.packed_vector2_array_push(&polygon, gt.Vector2{24, 0})
		gt.packed_vector2_array_push(&polygon, gt.Vector2{0, 24})
		gt.collision_polygon2d_set_polygon(collision_polygon, &polygon)
		polygon_copy := gt.collision_polygon2d_get_polygon(collision_polygon)
		gt.packed_vector2_array_free(&polygon_copy)
		gt.packed_vector2_array_free(&polygon)
		gt.collision_polygon2d_set_build_mode(collision_polygon, gt.CollisionPolygon2DBuildMode(0))
		_ = gt.collision_polygon2d_get_build_mode(collision_polygon)
		gt.collision_polygon2d_set_disabled(collision_polygon, false)
		_ = gt.collision_polygon2d_is_disabled(collision_polygon)
		gt.collision_polygon2d_set_one_way_collision(collision_polygon, true)
		_ = gt.collision_polygon2d_is_one_way_collision_enabled(collision_polygon)
		gt.collision_polygon2d_set_one_way_collision_margin(collision_polygon, 2)
		_ = gt.collision_polygon2d_get_one_way_collision_margin(collision_polygon)
		gt.collision_polygon2d_set_one_way_collision_direction(
			collision_polygon,
			gt.Vector2{0, -1},
		)
		_ = gt.collision_polygon2d_get_one_way_collision_direction(collision_polygon)
		if !gt.node_add_child_checked(parent, gt.collision_polygon2d_as_node(collision_polygon)) {
			_ = gt.object_destroy_checked(gt.collision_polygon2d_object_ptr(collision_polygon))
		}
	} else if collision_polygon_object != nil {
		_ = gt.object_destroy_checked(collision_polygon_object)
	}

	circle_shape_object := gt.construct_object(circle_shape2d_class_name)
	rectangle_shape_object := gt.construct_object(rectangle_shape2d_class_name)
	if circle_shape, circle_shape_ok := gt.object_ptr_try_as_circle_shape2d(circle_shape_object);
	   circle_shape_ok {
		owned_circle_shape, owned_circle_shape_ok := gt.owned_resource_init_owned(
			gt.circle_shape2d_as_resource(circle_shape),
		)
		if owned_circle_shape_ok {
			gt.circle_shape2d_set_radius(circle_shape, 10)
			_ = gt.circle_shape2d_get_radius(circle_shape)
			circle_shape2d := gt.circle_shape2d_as_shape2d(circle_shape)
			gt.shape2d_set_custom_solver_bias(circle_shape2d, 0.05)
			_ = gt.shape2d_get_custom_solver_bias(circle_shape2d)
			_ = gt.shape2d_get_rect(circle_shape2d)
			if rectangle_shape, rectangle_shape_ok := gt.object_ptr_try_as_rectangle_shape2d(
				rectangle_shape_object,
			); rectangle_shape_ok {
				owned_rectangle_shape, owned_rectangle_shape_ok := gt.owned_resource_init_owned(
					gt.rectangle_shape2d_as_resource(rectangle_shape),
				)
				if owned_rectangle_shape_ok {
					gt.rectangle_shape2d_set_size(rectangle_shape, gt.Vector2{18, 12})
					_ = gt.rectangle_shape2d_get_size(rectangle_shape)
					rectangle_shape2d := gt.rectangle_shape2d_as_shape2d(rectangle_shape)
					shape_identity := gt.Transform2D {
						x      = gt.Vector2{1, 0},
						y      = gt.Vector2{0, 1},
						origin = gt.Vector2{},
					}
					_ = gt.shape2d_collide(
						circle_shape2d,
						shape_identity,
						rectangle_shape2d,
						shape_identity,
					)
					_ = gt.shape2d_collide_with_motion(
						circle_shape2d,
						shape_identity,
						gt.Vector2{},
						rectangle_shape2d,
						shape_identity,
						gt.Vector2{},
					)
					shape_contacts := gt.shape2d_collide_and_get_contacts(
						circle_shape2d,
						shape_identity,
						rectangle_shape2d,
						shape_identity,
					)
					gt.packed_vector2_array_free(&shape_contacts)
					motion_contacts := gt.shape2d_collide_with_motion_and_get_contacts(
						circle_shape2d,
						shape_identity,
						gt.Vector2{},
						rectangle_shape2d,
						shape_identity,
						gt.Vector2{},
					)
					gt.packed_vector2_array_free(&motion_contacts)
					_ = gt.owned_resource_destroy(&owned_rectangle_shape)
				} else {
					_ = gt.object_destroy_checked(gt.rectangle_shape2d_object_ptr(rectangle_shape))
				}
			} else if rectangle_shape_object != nil {
				_ = gt.object_destroy_checked(rectangle_shape_object)
			}
			_ = gt.owned_resource_destroy(&owned_circle_shape)
		} else {
			_ = gt.object_destroy_checked(gt.circle_shape2d_object_ptr(circle_shape))
			if rectangle_shape_object != nil {
				_ = gt.object_destroy_checked(rectangle_shape_object)
			}
		}
	} else {
		if circle_shape_object != nil {
			_ = gt.object_destroy_checked(circle_shape_object)
		}
		if rectangle_shape_object != nil {
			_ = gt.object_destroy_checked(rectangle_shape_object)
		}
	}

	segment_shape_object := gt.construct_object(segment_shape2d_class_name)
	if segment_shape, segment_shape_ok := gt.object_ptr_try_as_segment_shape2d(
		segment_shape_object,
	); segment_shape_ok {
		owned_segment_shape, owned_segment_shape_ok := gt.owned_resource_init_owned(
			gt.segment_shape2d_as_resource(segment_shape),
		)
		if owned_segment_shape_ok {
			gt.segment_shape2d_set_a(segment_shape, gt.Vector2{-8, 0})
			_ = gt.segment_shape2d_get_a(segment_shape)
			gt.segment_shape2d_set_b(segment_shape, gt.Vector2{8, 0})
			_ = gt.segment_shape2d_get_b(segment_shape)
			_ = gt.owned_resource_destroy(&owned_segment_shape)
		} else {
			_ = gt.object_destroy_checked(gt.segment_shape2d_object_ptr(segment_shape))
		}
	} else if segment_shape_object != nil {
		_ = gt.object_destroy_checked(segment_shape_object)
	}

	separation_ray_shape_object := gt.construct_object(separation_ray_shape2d_class_name)
	if separation_ray_shape, separation_ray_shape_ok :=
		gt.object_ptr_try_as_separation_ray_shape2d(separation_ray_shape_object);
	separation_ray_shape_ok {
		owned_separation_ray_shape, owned_separation_ray_shape_ok := gt.owned_resource_init_owned(
			gt.separation_ray_shape2d_as_resource(separation_ray_shape),
		)
		if owned_separation_ray_shape_ok {
			gt.separation_ray_shape2d_set_length(separation_ray_shape, 12)
			_ = gt.separation_ray_shape2d_get_length(separation_ray_shape)
			gt.separation_ray_shape2d_set_slide_on_slope(separation_ray_shape, true)
			_ = gt.separation_ray_shape2d_get_slide_on_slope(separation_ray_shape)
			_ = gt.owned_resource_destroy(&owned_separation_ray_shape)
		} else {
			_ = gt.object_destroy_checked(
				gt.separation_ray_shape2d_object_ptr(separation_ray_shape),
			)
		}
	} else if separation_ray_shape_object != nil {
		_ = gt.object_destroy_checked(separation_ray_shape_object)
	}

	world_boundary_shape_object := gt.construct_object(world_boundary_shape2d_class_name)
	if world_boundary_shape, world_boundary_shape_ok :=
		gt.object_ptr_try_as_world_boundary_shape2d(world_boundary_shape_object);
	world_boundary_shape_ok {
		owned_world_boundary_shape, owned_world_boundary_shape_ok := gt.owned_resource_init_owned(
			gt.world_boundary_shape2d_as_resource(world_boundary_shape),
		)
		if owned_world_boundary_shape_ok {
			gt.world_boundary_shape2d_set_normal(world_boundary_shape, gt.Vector2{0, -1})
			_ = gt.world_boundary_shape2d_get_normal(world_boundary_shape)
			gt.world_boundary_shape2d_set_distance(world_boundary_shape, 32)
			_ = gt.world_boundary_shape2d_get_distance(world_boundary_shape)
			_ = gt.owned_resource_destroy(&owned_world_boundary_shape)
		} else {
			_ = gt.object_destroy_checked(
				gt.world_boundary_shape2d_object_ptr(world_boundary_shape),
			)
		}
	} else if world_boundary_shape_object != nil {
		_ = gt.object_destroy_checked(world_boundary_shape_object)
	}

	capsule_shape_object := gt.construct_object(capsule_shape2d_class_name)
	if capsule_shape, capsule_shape_ok := gt.object_ptr_try_as_capsule_shape2d(
		capsule_shape_object,
	); capsule_shape_ok {
		owned_capsule_shape, owned_capsule_shape_ok := gt.owned_resource_init_owned(
			gt.capsule_shape2d_as_resource(capsule_shape),
		)
		if owned_capsule_shape_ok {
			gt.capsule_shape2d_set_radius(capsule_shape, 6)
			_ = gt.capsule_shape2d_get_radius(capsule_shape)
			gt.capsule_shape2d_set_height(capsule_shape, 18)
			_ = gt.capsule_shape2d_get_height(capsule_shape)
			gt.capsule_shape2d_set_mid_height(capsule_shape, 6)
			_ = gt.capsule_shape2d_get_mid_height(capsule_shape)
			_ = gt.owned_resource_destroy(&owned_capsule_shape)
		} else {
			_ = gt.object_destroy_checked(gt.capsule_shape2d_object_ptr(capsule_shape))
		}
	} else if capsule_shape_object != nil {
		_ = gt.object_destroy_checked(capsule_shape_object)
	}

	canvas_modulate_object := gt.construct_object(canvas_modulate_class_name)
	if canvas_modulate, canvas_modulate_ok := gt.object_ptr_try_as_canvas_modulate(
		canvas_modulate_object,
	); canvas_modulate_ok {
		gt.canvas_modulate_set_color(canvas_modulate, gt.Color{0.9, 0.95, 1.0, 1.0})
		_ = gt.canvas_modulate_get_color(canvas_modulate)
		if !gt.node_add_child_checked(parent, gt.canvas_modulate_as_node(canvas_modulate)) {
			_ = gt.object_destroy_checked(gt.canvas_modulate_object_ptr(canvas_modulate))
		}
	} else if canvas_modulate_object != nil {
		_ = gt.object_destroy_checked(canvas_modulate_object)
	}

	parallax_object := gt.construct_object(parallax2d_class_name)
	if parallax, parallax_ok := gt.object_ptr_try_as_parallax2d(parallax_object); parallax_ok {
		gt.parallax2d_set_scroll_scale(parallax, gt.Vector2{0.5, 0.5})
		gt.parallax2d_set_repeat_size(parallax, gt.Vector2{256, 128})
		gt.parallax2d_set_repeat_times(parallax, 2)
		gt.parallax2d_set_autoscroll(parallax, gt.Vector2{4, 0})
		gt.parallax2d_set_scroll_offset(parallax, gt.Vector2{8, 4})
		gt.parallax2d_set_screen_offset(parallax, gt.Vector2{1, 2})
		gt.parallax2d_set_limit_begin(parallax, gt.Vector2{-128, -128})
		gt.parallax2d_set_limit_end(parallax, gt.Vector2{128, 128})
		gt.parallax2d_set_follow_viewport(parallax, true)
		gt.parallax2d_set_ignore_camera_scroll(parallax, false)
		_ = gt.parallax2d_get_scroll_scale(parallax)
		_ = gt.parallax2d_get_repeat_size(parallax)
		_ = gt.parallax2d_get_repeat_times(parallax)
		_ = gt.parallax2d_get_autoscroll(parallax)
		_ = gt.parallax2d_get_scroll_offset(parallax)
		_ = gt.parallax2d_get_screen_offset(parallax)
		_ = gt.parallax2d_get_limit_begin(parallax)
		_ = gt.parallax2d_get_limit_end(parallax)
		_ = gt.parallax2d_get_follow_viewport(parallax)
		_ = gt.parallax2d_is_ignore_camera_scroll(parallax)
		if !gt.node_add_child_checked(parent, gt.parallax2d_as_node(parallax)) {
			_ = gt.object_destroy_checked(gt.parallax2d_object_ptr(parallax))
		}
	} else if parallax_object != nil {
		_ = gt.object_destroy_checked(parallax_object)
	}

	path_follow_object := gt.construct_object(path_follow2d_class_name)
	if path_follow, path_follow_ok := gt.object_ptr_try_as_path_follow2d(path_follow_object);
	   path_follow_ok {
		gt.path_follow2d_set_progress(path_follow, damage)
		gt.path_follow2d_set_h_offset(path_follow, damage * 0.1)
		gt.path_follow2d_set_v_offset(path_follow, -damage * 0.05)
		gt.path_follow2d_set_rotates(path_follow, true)
		gt.path_follow2d_set_cubic_interpolation(path_follow, false)
		gt.path_follow2d_set_loop(path_follow, true)
		_ = gt.path_follow2d_get_progress(path_follow)
		_ = gt.path_follow2d_get_h_offset(path_follow)
		_ = gt.path_follow2d_get_v_offset(path_follow)
		_ = gt.path_follow2d_is_rotating(path_follow)
		_ = gt.path_follow2d_get_cubic_interpolation(path_follow)
		_ = gt.path_follow2d_has_loop(path_follow)
		if !gt.node_add_child_checked(parent, gt.path_follow2d_as_node(path_follow)) {
			_ = gt.object_destroy_checked(gt.path_follow2d_object_ptr(path_follow))
		}
	} else if path_follow_object != nil {
		_ = gt.object_destroy_checked(path_follow_object)
	}

	notifier_object := gt.construct_object(visible_on_screen_notifier2d_class_name)
	if notifier, notifier_ok := gt.object_ptr_try_as_visible_on_screen_notifier2d(notifier_object);
	   notifier_ok {
		gt.visible_on_screen_notifier2d_set_rect(
			notifier,
			gt.Rect2{position = gt.Vector2{-16, -16}, size = gt.Vector2{32, 32}},
		)
		gt.visible_on_screen_notifier2d_set_show_rect(notifier, true)
		_ = gt.visible_on_screen_notifier2d_get_rect(notifier)
		_ = gt.visible_on_screen_notifier2d_is_showing_rect(notifier)
		_ = gt.visible_on_screen_notifier2d_is_on_screen(notifier)
		if !gt.node_add_child_checked(parent, gt.visible_on_screen_notifier2d_as_node(notifier)) {
			_ = gt.object_destroy_checked(gt.visible_on_screen_notifier2d_object_ptr(notifier))
		}
	} else if notifier_object != nil {
		_ = gt.object_destroy_checked(notifier_object)
	}
}

configure_animation_tween_nodes :: proc "contextless" (parent: gt.Node, damage: gt.GodotReal) {
	animation_object := gt.construct_object(animation_player_class_name)
	if player, player_ok := gt.object_ptr_try_as_animation_player(animation_object); player_ok {
		gt.animation_player_set_default_blend_time(player, 0.05)
		gt.animation_player_set_speed_scale(player, 1.0 + damage * 0.01)
		gt.animation_player_set_auto_capture(player, false)
		_ = gt.animation_player_get_default_blend_time(player)
		_ = gt.animation_player_get_speed_scale(player)
		_ = gt.animation_player_is_playing(player)
		_ = gt.animation_player_stop_checked(player)
		_ = gt.object_destroy_checked(gt.ObjectPtr(player))
	} else if animation_object != nil {
		_ = gt.object_destroy_checked(animation_object)
	}

	audio_object := gt.construct_object(audio_stream_player_class_name)
	if audio, audio_ok := gt.object_ptr_try_as_audio_stream_player(audio_object); audio_ok {
		gt.audio_stream_player_set_volume_db(audio, -6)
		gt.audio_stream_player_set_volume_linear(audio, 0.5)
		gt.audio_stream_player_set_pitch_scale(audio, 1.0)
		gt.audio_stream_player_set_autoplay(audio, false)
		gt.audio_stream_player_set_stream_paused(audio, true)
		gt.audio_stream_player_set_max_polyphony(audio, 1)
		master_bus := gt.string_name_from_utf8_cstring(cstring("Master"))
		gt.audio_stream_player_set_bus(audio, &master_bus)
		gt.string_name_free(&master_bus)
		_ = gt.audio_stream_player_get_volume_db(audio)
		_ = gt.audio_stream_player_get_volume_linear(audio)
		_ = gt.audio_stream_player_get_pitch_scale(audio)
		_ = gt.audio_stream_player_is_autoplay_enabled(audio)
		_ = gt.audio_stream_player_get_stream_paused(audio)
		_ = gt.audio_stream_player_get_max_polyphony(audio)
		_ = gt.audio_stream_player_is_playing(audio)
		_ = gt.audio_stream_player_get_playback_position(audio)
		_ = gt.audio_stream_player_has_stream_playback(audio)
		bus := gt.audio_stream_player_get_bus(audio)
		gt.string_name_free(&bus)
		if !gt.node_add_child_checked(parent, gt.audio_stream_player_as_node(audio)) {
			_ = gt.object_destroy_checked(gt.audio_stream_player_object_ptr(audio))
		}
	} else if audio_object != nil {
		_ = gt.object_destroy_checked(audio_object)
	}


	audio_listener_object := gt.construct_object(audio_listener2d_class_name)
	if audio_listener, audio_listener_ok := gt.object_ptr_try_as_audio_listener2d(
		audio_listener_object,
	); audio_listener_ok {
		gt.audio_listener2d_make_current(audio_listener)
		_ = gt.audio_listener2d_is_current(audio_listener)
		gt.audio_listener2d_clear_current(audio_listener)
		if !gt.node_add_child_checked(parent, gt.audio_listener2d_as_node(audio_listener)) {
			_ = gt.object_destroy_checked(gt.audio_listener2d_object_ptr(audio_listener))
		}
	} else if audio_listener_object != nil {
		_ = gt.object_destroy_checked(audio_listener_object)
	}

	remote_object := gt.construct_object(remote_transform2d_class_name)
	if remote, remote_ok := gt.object_ptr_try_as_remote_transform2d(remote_object); remote_ok {
		// Leave the remote path empty: this smoke has no target node to update.
		empty_remote_path := gt.node_path_from_utf8("")
		gt.remote_transform2d_set_remote_node(remote, &empty_remote_path)
		gt.node_path_free(&empty_remote_path)
		remote_path := gt.remote_transform2d_get_remote_node(remote)
		gt.node_path_free(&remote_path)
		gt.remote_transform2d_set_use_global_coordinates(remote, true)
		_ = gt.remote_transform2d_get_use_global_coordinates(remote)
		gt.remote_transform2d_set_update_position(remote, true)
		_ = gt.remote_transform2d_get_update_position(remote)
		gt.remote_transform2d_set_update_rotation(remote, false)
		_ = gt.remote_transform2d_get_update_rotation(remote)
		gt.remote_transform2d_set_update_scale(remote, false)
		_ = gt.remote_transform2d_get_update_scale(remote)
		if !gt.node_add_child_checked(parent, gt.remote_transform2d_as_node(remote)) {
			_ = gt.object_destroy_checked(gt.remote_transform2d_object_ptr(remote))
		}
	} else if remote_object != nil {
		_ = gt.object_destroy_checked(remote_object)
	}

	audio_2d_object := gt.construct_object(audio_stream_player2d_class_name)
	if audio_2d, audio_2d_ok := gt.object_ptr_try_as_audio_stream_player2d(audio_2d_object);
	   audio_2d_ok {
		gt.audio_stream_player2d_set_volume_db(audio_2d, -8)
		gt.audio_stream_player2d_set_volume_linear(audio_2d, 0.4)
		gt.audio_stream_player2d_set_pitch_scale(audio_2d, 1.0)
		gt.audio_stream_player2d_set_autoplay(audio_2d, false)
		gt.audio_stream_player2d_set_playing(audio_2d, false)
		gt.audio_stream_player2d_set_stream_paused(audio_2d, true)
		gt.audio_stream_player2d_set_max_polyphony(audio_2d, 1)
		gt.audio_stream_player2d_set_max_distance(audio_2d, 512)
		gt.audio_stream_player2d_set_attenuation(audio_2d, 1)
		gt.audio_stream_player2d_set_area_mask(audio_2d, 1)
		gt.audio_stream_player2d_set_panning_strength(audio_2d, 1)
		master_bus := gt.string_name_from_utf8_cstring(cstring("Master"))
		gt.audio_stream_player2d_set_bus(audio_2d, &master_bus)
		gt.string_name_free(&master_bus)
		_ = gt.audio_stream_player2d_get_volume_db(audio_2d)
		_ = gt.audio_stream_player2d_get_volume_linear(audio_2d)
		_ = gt.audio_stream_player2d_get_pitch_scale(audio_2d)
		_ = gt.audio_stream_player2d_is_autoplay_enabled(audio_2d)
		_ = gt.audio_stream_player2d_get_stream_paused(audio_2d)
		_ = gt.audio_stream_player2d_get_max_polyphony(audio_2d)
		_ = gt.audio_stream_player2d_get_max_distance(audio_2d)
		_ = gt.audio_stream_player2d_get_attenuation(audio_2d)
		_ = gt.audio_stream_player2d_get_area_mask(audio_2d)
		_ = gt.audio_stream_player2d_get_panning_strength(audio_2d)
		_ = gt.audio_stream_player2d_is_playing(audio_2d)
		_ = gt.audio_stream_player2d_get_playback_position(audio_2d)
		_ = gt.audio_stream_player2d_has_stream_playback(audio_2d)
		bus := gt.audio_stream_player2d_get_bus(audio_2d)
		gt.string_name_free(&bus)
		gt.audio_stream_player2d_stop(audio_2d)
		if !gt.node_add_child_checked(parent, gt.audio_stream_player2d_as_node(audio_2d)) {
			_ = gt.object_destroy_checked(gt.audio_stream_player2d_object_ptr(audio_2d))
		}
	} else if audio_2d_object != nil {
		_ = gt.object_destroy_checked(audio_2d_object)
	}

	if !gt.scene_tree_is_nil(gt.node_get_tree(parent)) {
		nil_tween := gt.Tween(nil)
		_, _ = gt.tween_running_checked(nil_tween)
		_ = gt.tween_stop_checked(nil_tween)
	}
}


configure_ui_nodes :: proc "contextless" (
	parent: gt.Node,
	label: gt.Label,
	damage: gt.GodotReal,
	texture: gt.Texture2D,
	texture_loaded: bool,
) {
	exercise_input_viewport_helpers(parent)

	button_path := gt.node_path_from_utf8("RollButton")
	button, button_ok := gt.node_get_node_as_button(parent, &button_path)
	gt.node_path_free(&button_path)
	if button_ok {
		_ = gt.button_set_text_utf8_checked(button, "Roll again from Odin")
		gt.button_set_flat(button, false)
		gt.button_set_clip_text(button, true)
		gt.button_set_text_alignment(button, .horizontal_alignment_center)
		base_button := gt.button_as_base_button(button)
		gt.base_button_set_disabled(base_button, false)
		gt.base_button_set_toggle_mode(base_button, false)
		gt.base_button_set_pressed_no_signal(base_button, false)
		gt.base_button_set_action_mode(base_button, .action_mode_button_release)
		_ = gt.base_button_get_draw_mode(base_button)
	}

	texture_path := gt.node_path_from_utf8("PreviewTexture")
	texture_rect, texture_ok := gt.node_get_node_as_texture_rect(parent, &texture_path)
	gt.node_path_free(&texture_path)
	if texture_ok {
		gt.texture_rect_set_flip_h(texture_rect, damage > 20)
		gt.texture_rect_set_flip_v(texture_rect, false)
		gt.texture_rect_set_expand_mode(texture_rect, .expand_keep_size)
		gt.texture_rect_set_stretch_mode(texture_rect, .stretch_keep_aspect_centered)
		if texture_loaded {
			gt.texture_rect_set_texture(texture_rect, texture)
			_ = gt.texture_rect_get_texture(texture_rect)
			_ = gt.texture2d_get_width(texture)
			_ = gt.texture2d_get_height(texture)
			_ = gt.texture2d_get_size(texture)
			_ = gt.texture2d_has_alpha(texture)
			_ = gt.texture2d_has_mipmaps(texture)
			gt.texture_rect_set_texture(texture_rect, gt.Texture2D(nil))
		}
	}

	panel_path := gt.node_path_from_utf8("InfoPanel")
	panel, panel_ok := gt.node_get_node_as_panel(parent, &panel_path)
	gt.node_path_free(&panel_path)
	if panel_ok {
		panel_control := gt.panel_as_control(panel)
		gt.control_set_position_default(panel_control, gt.Vector2{24, 152})
		gt.control_set_size_default(panel_control, gt.Vector2{360, 64})
		gt.control_set_mouse_filter(panel_control, .mouse_filter_ignore)
	}

	container_path := gt.node_path_from_utf8("UiContainer")
	container, container_ok := gt.node_get_node_as_container(parent, &container_path)
	gt.node_path_free(&container_path)
	if container_ok {
		gt.container_queue_sort(container)
		gt.container_set_accessibility_region(container, true)
	}
}


configure_ui_resource_nodes :: proc "contextless" (
	parent: gt.Node,
	damage: gt.GodotReal,
	texture: gt.Texture2D,
	texture_loaded: bool,
) {
	progress_object := gt.construct_object(progress_bar_class_name)
	if progress, progress_ok := gt.object_ptr_try_as_progress_bar(progress_object); progress_ok {
		range_handle := gt.progress_bar_as_range(progress)
		gt.range_set_min(range_handle, 0)
		gt.range_set_max(range_handle, 100)
		gt.range_set_step(range_handle, 1)
		gt.range_set_value(range_handle, damage)
		gt.range_set_use_rounded_values(range_handle, true)
		gt.progress_bar_set_show_percentage(progress, true)
		gt.progress_bar_set_indeterminate(progress, false)
		gt.progress_bar_set_fill_mode(progress, i64(gt.ProgressBarFillMode.fill_begin_to_end))
		_ = gt.range_get_value(range_handle)
		_ = gt.range_get_as_ratio(range_handle)
		_ = gt.range_is_using_rounded_values(range_handle)
		_ = gt.progress_bar_get_fill_mode(progress)
		_ = gt.progress_bar_is_percentage_shown(progress)
		_ = gt.object_destroy_checked(gt.progress_bar_object_ptr(progress))
	} else if progress_object != nil {
		_ = gt.object_destroy_checked(progress_object)
	}

	texture_progress_object := gt.construct_object(texture_progress_bar_class_name)
	if texture_progress, texture_progress_ok := gt.object_ptr_try_as_texture_progress_bar(
		texture_progress_object,
	); texture_progress_ok {
		range_handle := gt.texture_progress_bar_as_range(texture_progress)
		gt.range_set_min(range_handle, 0)
		gt.range_set_max(range_handle, 100)
		gt.range_set_value(range_handle, damage)
		gt.texture_progress_bar_set_fill_mode(texture_progress, 0)
		gt.texture_progress_bar_set_tint_under(texture_progress, gt.Color{1, 1, 1, 0.35})
		gt.texture_progress_bar_set_tint_progress(texture_progress, gt.Color{0.2, 0.8, 1.0, 1.0})
		gt.texture_progress_bar_set_tint_over(texture_progress, gt.Color{1, 1, 1, 0.75})
		gt.texture_progress_bar_set_texture_progress_offset(texture_progress, gt.Vector2{1, 1})
		gt.texture_progress_bar_set_radial_initial_angle(texture_progress, 0)
		gt.texture_progress_bar_set_radial_center_offset(texture_progress, gt.Vector2{})
		gt.texture_progress_bar_set_fill_degrees(texture_progress, 180)
		gt.texture_progress_bar_set_stretch_margin(texture_progress, .side_left, 2)
		gt.texture_progress_bar_set_nine_patch_stretch(texture_progress, true)
		if texture_loaded {
			gt.texture_progress_bar_set_under_texture(texture_progress, texture)
			gt.texture_progress_bar_set_progress_texture(texture_progress, texture)
			gt.texture_progress_bar_set_over_texture(texture_progress, texture)
			_ = gt.texture_progress_bar_get_under_texture(texture_progress)
			_ = gt.texture_progress_bar_get_progress_texture(texture_progress)
			_ = gt.texture_progress_bar_get_over_texture(texture_progress)
		}
		_ = gt.texture_progress_bar_get_fill_mode(texture_progress)
		_ = gt.texture_progress_bar_get_tint_progress(texture_progress)
		_ = gt.texture_progress_bar_get_texture_progress_offset(texture_progress)
		_ = gt.texture_progress_bar_get_radial_initial_angle(texture_progress)
		_ = gt.texture_progress_bar_get_radial_center_offset(texture_progress)
		_ = gt.texture_progress_bar_get_fill_degrees(texture_progress)
		_ = gt.texture_progress_bar_get_stretch_margin(texture_progress, .side_left)
		_ = gt.texture_progress_bar_get_nine_patch_stretch(texture_progress)
		_ = gt.object_destroy_checked(gt.texture_progress_bar_object_ptr(texture_progress))
	} else if texture_progress_object != nil {
		_ = gt.object_destroy_checked(texture_progress_object)
	}

	style_box_object := gt.construct_object(style_box_class_name)
	if style_box, style_box_ok := gt.object_ptr_try_as_style_box(style_box_object); style_box_ok {
		gt.style_box_set_content_margin(style_box, .side_left, 4)
		gt.style_box_set_content_margin_all(style_box, 2)
		_ = gt.style_box_get_minimum_size(style_box)
		_ = gt.style_box_get_content_margin(style_box, .side_left)
		_ = gt.style_box_get_margin(style_box, .side_left)
		_ = gt.style_box_get_offset(style_box)
		_ = gt.style_box_test_mask(style_box, gt.Vector2{}, gt.Rect2{})
		_ = gt.object_destroy_checked(gt.style_box_object_ptr(style_box))
	} else if style_box_object != nil {
		_ = gt.object_destroy_checked(style_box_object)
	}

	texture_button_object := gt.construct_object(texture_button_class_name)
	if texture_button, texture_button_ok := gt.object_ptr_try_as_texture_button(
		texture_button_object,
	); texture_button_ok {
		gt.texture_button_set_ignore_texture_size(texture_button, false)
		gt.texture_button_set_stretch_mode(texture_button, .stretch_keep_aspect_centered)
		gt.texture_button_set_flip_h(texture_button, damage > 25)
		gt.texture_button_set_flip_v(texture_button, false)
		if texture_loaded {
			gt.texture_button_set_texture_normal(texture_button, texture)
			gt.texture_button_set_texture_hover(texture_button, texture)
			_ = gt.texture_button_get_texture_normal(texture_button)
			_ = gt.texture_button_get_texture_hover(texture_button)
		}
		_ = gt.texture_button_get_ignore_texture_size(texture_button)
		_ = gt.texture_button_get_stretch_mode(texture_button)
		_ = gt.texture_button_is_flipped_h(texture_button)
		_ = gt.object_destroy_checked(gt.texture_button_object_ptr(texture_button))
	} else if texture_button_object != nil {
		_ = gt.object_destroy_checked(texture_button_object)
	}
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
		if loader, loader_ok := gt.resource_loader_singleton_checked(); loader_ok {
			scene_path := gt.string_from_utf8("res://spawned_label.tscn")
			defer gt.string_free(&scene_path)

			_ = gt.resource_loader_exists_default(loader, &scene_path)
			dependencies := gt.resource_loader_get_dependencies(loader, &scene_path)
			gt.packed_string_array_free(&dependencies)
			_ = gt.resource_loader_has_cached(loader, &scene_path)
			_ = gt.resource_loader_get_resource_uid(loader, &scene_path)

			res_dir := gt.string_from_utf8("res://")
			directory_entries := gt.resource_loader_list_directory(loader, &res_dir)
			gt.packed_string_array_free(&directory_entries)
			gt.string_free(&res_dir)

			loaded, packed, err, loaded_ok := gt.resource_loader_load_packed_scene_owned_checked(
				loader,
				&scene_path,
			)
			gt.require_call_ok(&err)
			if loaded_ok {
				defer gt.owned_resource_destroy(&loaded)
				resource := gt.owned_resource_handle(loaded)
				resource_path := gt.resource_get_path(resource)
				gt.string_free(&resource_path)
				resource_name := gt.resource_get_name(resource)
				gt.string_free(&resource_name)
				_ = gt.resource_is_built_in(resource)
				unique_id := gt.resource_get_scene_unique_id(resource)
				gt.string_free(&unique_id)

				if gt.packed_scene_can_instantiate(packed) {
					spawned, spawned_ok := gt.packed_scene_instantiate_child_checked(
						packed,
						parent,
					)
					if spawned_ok {
						if spawned_label, spawned_label_ok := gt.node_try_as_label(spawned);
						   spawned_label_ok {
							_ = gt.label_set_text_utf8_checked(
								spawned_label,
								"Loaded and instantiated by Odin helpers",
							)
						}
					}
				}
			}
		}

		timer_path := gt.node_path_from_utf8("RollTimer")
		timer, timer_ok := gt.node_get_node_as_timer(parent, &timer_path)
		gt.node_path_free(&timer_path)
		if timer_ok {
			gt.timer_set_wait_time(timer, 0.5)
			gt.timer_set_one_shot(timer, true)
			gt.timer_start_default(timer)
		}

		children := gt.node_get_children_default(parent)
		gt.typed_array_free(&children)
		tree_string := gt.node_get_tree_string_pretty(parent)
		gt.string_free(&tree_string)
		scene_file_path := gt.node_get_scene_file_path(parent)
		gt.string_free(&scene_file_path)
		_ = gt.node_is_node_ready(parent)

		texture, texture_loaded := ensure_icon_texture(self)
		configure_ui_nodes(parent, label, damage, texture, texture_loaded)
		configure_ui_resource_nodes(parent, damage, texture, texture_loaded)
		configure_physics_nodes(parent, damage)
		configure_2d_gameplay_nodes(parent, damage)
		configure_animation_tween_nodes(parent, damage)

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

	_ = gt.label_set_text_utf8_checked(
		label,
		"Odin updated UI nodes, loaded resources, spawned a scene, armed a Timer, configured physics, 2D gameplay, and UI resource nodes, and exercised animation/tween APIs.",
	)
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
character_body2d_class_name_data: gt.ClassName
rigid_body2d_class_name_data: gt.ClassName
static_body2d_class_name_data: gt.ClassName
collision_shape2d_class_name_data: gt.ClassName
camera2d_class_name_data: gt.ClassName
marker2d_class_name_data: gt.ClassName
ray_cast2d_class_name_data: gt.ClassName
navigation_agent2d_class_name_data: gt.ClassName
theme_class_name_data: gt.ClassName
curve2d_class_name_data: gt.ClassName
path2d_class_name_data: gt.ClassName
back_buffer_copy_class_name_data: gt.ClassName
collision_polygon2d_class_name_data: gt.ClassName
canvas_layer_class_name_data: gt.ClassName
polygon2d_class_name_data: gt.ClassName
line2d_class_name_data: gt.ClassName
circle_shape2d_class_name_data: gt.ClassName
rectangle_shape2d_class_name_data: gt.ClassName
segment_shape2d_class_name_data: gt.ClassName
separation_ray_shape2d_class_name_data: gt.ClassName
world_boundary_shape2d_class_name_data: gt.ClassName
capsule_shape2d_class_name_data: gt.ClassName
canvas_modulate_class_name_data: gt.ClassName
parallax2d_class_name_data: gt.ClassName
font_file_class_name_data: gt.ClassName
tile_map_layer_class_name_data: gt.ClassName
tile_map_class_name_data: gt.ClassName
path_follow2d_class_name_data: gt.ClassName
visible_on_screen_notifier2d_class_name_data: gt.ClassName
texture_button_class_name_data: gt.ClassName
progress_bar_class_name_data: gt.ClassName
texture_progress_bar_class_name_data: gt.ClassName
style_box_class_name_data: gt.ClassName
audio_stream_player_class_name_data: gt.ClassName
audio_stream_player2d_class_name_data: gt.ClassName
audio_listener2d_class_name_data: gt.ClassName
remote_transform2d_class_name_data: gt.ClassName
animation_player_class_name_data: gt.ClassName
game_class_name: gt.ConstStringNamePtr
game_parent_name: gt.ConstStringNamePtr
character_body2d_class_name: gt.ConstStringNamePtr
rigid_body2d_class_name: gt.ConstStringNamePtr
static_body2d_class_name: gt.ConstStringNamePtr
collision_shape2d_class_name: gt.ConstStringNamePtr
camera2d_class_name: gt.ConstStringNamePtr
marker2d_class_name: gt.ConstStringNamePtr
ray_cast2d_class_name: gt.ConstStringNamePtr
navigation_agent2d_class_name: gt.ConstStringNamePtr
theme_class_name: gt.ConstStringNamePtr
curve2d_class_name: gt.ConstStringNamePtr
path2d_class_name: gt.ConstStringNamePtr
back_buffer_copy_class_name: gt.ConstStringNamePtr
collision_polygon2d_class_name: gt.ConstStringNamePtr
canvas_layer_class_name: gt.ConstStringNamePtr
polygon2d_class_name: gt.ConstStringNamePtr
line2d_class_name: gt.ConstStringNamePtr
circle_shape2d_class_name: gt.ConstStringNamePtr
rectangle_shape2d_class_name: gt.ConstStringNamePtr
segment_shape2d_class_name: gt.ConstStringNamePtr
separation_ray_shape2d_class_name: gt.ConstStringNamePtr
world_boundary_shape2d_class_name: gt.ConstStringNamePtr
capsule_shape2d_class_name: gt.ConstStringNamePtr
canvas_modulate_class_name: gt.ConstStringNamePtr
parallax2d_class_name: gt.ConstStringNamePtr
font_file_class_name: gt.ConstStringNamePtr
tile_map_layer_class_name: gt.ConstStringNamePtr
tile_map_class_name: gt.ConstStringNamePtr
path_follow2d_class_name: gt.ConstStringNamePtr
visible_on_screen_notifier2d_class_name: gt.ConstStringNamePtr
texture_button_class_name: gt.ConstStringNamePtr
progress_bar_class_name: gt.ConstStringNamePtr
texture_progress_bar_class_name: gt.ConstStringNamePtr
style_box_class_name: gt.ConstStringNamePtr
audio_stream_player_class_name: gt.ConstStringNamePtr
audio_stream_player2d_class_name: gt.ConstStringNamePtr
audio_listener2d_class_name: gt.ConstStringNamePtr
remote_transform2d_class_name: gt.ConstStringNamePtr
animation_player_class_name: gt.ConstStringNamePtr

empty_name_data: gt.StaticStringName
empty_name: gt.ConstStringNamePtr
empty_str_data: gt.String
empty_str: gt.ConstStringPtr

roll_damage_method_name_data: gt.StaticStringName
roll_damage_method_name: gt.ConstStringNamePtr
roll_damage_return_info: gt.PropertyInfo
roll_damage_method_info: gt.ClassMethodInfo
roll_into_label_method_name_data: gt.StaticStringName
roll_into_label_arg_name_data: gt.StaticStringName
roll_into_label_method_name: gt.ConstStringNamePtr
roll_into_label_arg_name: gt.ConstStringNamePtr
roll_into_label_arg_info: gt.PropertyInfo
roll_into_label_arg_meta := [1]gt.ClassMethodArgumentMetadata{.None}
roll_into_label_method_info: gt.ClassMethodInfo

difficulty_property_name_data: gt.StaticStringName
difficulty_setter_name_data: gt.StaticStringName
difficulty_getter_name_data: gt.StaticStringName
difficulty_property_name: gt.ConstStringNamePtr
difficulty_setter_name: gt.ConstStringNamePtr
difficulty_getter_name: gt.ConstStringNamePtr
difficulty_property_info: gt.PropertyInfo
difficulty_get_return_info: gt.PropertyInfo
difficulty_set_arg_info: gt.PropertyInfo
difficulty_set_arg_meta := [1]gt.ClassMethodArgumentMetadata{.None}
difficulty_get_method_info: gt.ClassMethodInfo
difficulty_set_method_info: gt.ClassMethodInfo

damage_rolled_signal_name_data: gt.StaticStringName
damage_rolled_arg_name_data: gt.StaticStringName
damage_rolled_signal_name: gt.ConstStringNamePtr
damage_rolled_arg_name: gt.ConstStringNamePtr
damage_rolled_arg_info: gt.PropertyInfo

game_instance_binding_callbacks := gt.InstanceBindingCallbacks{}

register_methods :: proc() {
	empty_name = gt.const_static_string_name_ptr(&empty_name_data)
	empty_str = gt.const_string_ptr(&empty_str_data)
	roll_damage_method_name = gt.const_static_string_name_ptr(&roll_damage_method_name_data)
	roll_into_label_method_name = gt.const_static_string_name_ptr(
		&roll_into_label_method_name_data,
	)
	roll_into_label_arg_name = gt.const_static_string_name_ptr(&roll_into_label_arg_name_data)
	difficulty_property_name = gt.const_static_string_name_ptr(&difficulty_property_name_data)
	difficulty_setter_name = gt.const_static_string_name_ptr(&difficulty_setter_name_data)
	difficulty_getter_name = gt.const_static_string_name_ptr(&difficulty_getter_name_data)

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
	damage_rolled_signal_name = gt.const_static_string_name_ptr(&damage_rolled_signal_name_data)
	damage_rolled_arg_name = gt.const_static_string_name_ptr(&damage_rolled_arg_name_data)

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
	game_class_name = gt.class_name_ptr(&game_name_data)
	game_parent_name = gt.class_name_ptr(&game_parent_name_data)
	character_body2d_class_name = gt.class_name_ptr(&character_body2d_class_name_data)
	rigid_body2d_class_name = gt.class_name_ptr(&rigid_body2d_class_name_data)
	static_body2d_class_name = gt.class_name_ptr(&static_body2d_class_name_data)
	collision_shape2d_class_name = gt.class_name_ptr(&collision_shape2d_class_name_data)
	camera2d_class_name = gt.class_name_ptr(&camera2d_class_name_data)
	marker2d_class_name = gt.class_name_ptr(&marker2d_class_name_data)
	ray_cast2d_class_name = gt.class_name_ptr(&ray_cast2d_class_name_data)
	navigation_agent2d_class_name = gt.class_name_ptr(&navigation_agent2d_class_name_data)
	theme_class_name = gt.class_name_ptr(&theme_class_name_data)
	curve2d_class_name = gt.class_name_ptr(&curve2d_class_name_data)
	path2d_class_name = gt.class_name_ptr(&path2d_class_name_data)
	back_buffer_copy_class_name = gt.class_name_ptr(&back_buffer_copy_class_name_data)
	collision_polygon2d_class_name = gt.class_name_ptr(&collision_polygon2d_class_name_data)
	canvas_layer_class_name = gt.class_name_ptr(&canvas_layer_class_name_data)
	polygon2d_class_name = gt.class_name_ptr(&polygon2d_class_name_data)
	line2d_class_name = gt.class_name_ptr(&line2d_class_name_data)
	circle_shape2d_class_name = gt.class_name_ptr(&circle_shape2d_class_name_data)
	rectangle_shape2d_class_name = gt.class_name_ptr(&rectangle_shape2d_class_name_data)
	segment_shape2d_class_name = gt.class_name_ptr(&segment_shape2d_class_name_data)
	separation_ray_shape2d_class_name = gt.class_name_ptr(&separation_ray_shape2d_class_name_data)
	world_boundary_shape2d_class_name = gt.class_name_ptr(&world_boundary_shape2d_class_name_data)
	capsule_shape2d_class_name = gt.class_name_ptr(&capsule_shape2d_class_name_data)
	canvas_modulate_class_name = gt.class_name_ptr(&canvas_modulate_class_name_data)
	parallax2d_class_name = gt.class_name_ptr(&parallax2d_class_name_data)
	font_file_class_name = gt.class_name_ptr(&font_file_class_name_data)
	tile_map_layer_class_name = gt.class_name_ptr(&tile_map_layer_class_name_data)
	tile_map_class_name = gt.class_name_ptr(&tile_map_class_name_data)
	path_follow2d_class_name = gt.class_name_ptr(&path_follow2d_class_name_data)
	visible_on_screen_notifier2d_class_name = gt.class_name_ptr(
		&visible_on_screen_notifier2d_class_name_data,
	)
	texture_button_class_name = gt.class_name_ptr(&texture_button_class_name_data)
	progress_bar_class_name = gt.class_name_ptr(&progress_bar_class_name_data)
	texture_progress_bar_class_name = gt.class_name_ptr(&texture_progress_bar_class_name_data)
	style_box_class_name = gt.class_name_ptr(&style_box_class_name_data)
	audio_stream_player_class_name = gt.class_name_ptr(&audio_stream_player_class_name_data)
	audio_stream_player2d_class_name = gt.class_name_ptr(&audio_stream_player2d_class_name_data)
	audio_listener2d_class_name = gt.class_name_ptr(&audio_listener2d_class_name_data)
	remote_transform2d_class_name = gt.class_name_ptr(&remote_transform2d_class_name_data)
	animation_player_class_name = gt.class_name_ptr(&animation_player_class_name_data)

	gt.class_name_init_latin1_cstring(&game_name_data, cstring("GameBrain"))
	gt.class_name_init_latin1_cstring(&game_parent_name_data, cstring("Node"))
	gt.class_name_init_latin1_cstring(
		&character_body2d_class_name_data,
		cstring("CharacterBody2D"),
	)
	gt.class_name_init_latin1_cstring(&rigid_body2d_class_name_data, cstring("RigidBody2D"))
	gt.class_name_init_latin1_cstring(&static_body2d_class_name_data, cstring("StaticBody2D"))
	gt.class_name_init_latin1_cstring(
		&collision_shape2d_class_name_data,
		cstring("CollisionShape2D"),
	)
	gt.class_name_init_latin1_cstring(&camera2d_class_name_data, cstring("Camera2D"))
	gt.class_name_init_latin1_cstring(&marker2d_class_name_data, cstring("Marker2D"))
	gt.class_name_init_latin1_cstring(&ray_cast2d_class_name_data, cstring("RayCast2D"))
	gt.class_name_init_latin1_cstring(
		&navigation_agent2d_class_name_data,
		cstring("NavigationAgent2D"),
	)
	gt.class_name_init_latin1_cstring(&theme_class_name_data, cstring("Theme"))
	gt.class_name_init_latin1_cstring(&curve2d_class_name_data, cstring("Curve2D"))
	gt.class_name_init_latin1_cstring(&path2d_class_name_data, cstring("Path2D"))
	gt.class_name_init_latin1_cstring(&back_buffer_copy_class_name_data, cstring("BackBufferCopy"))
	gt.class_name_init_latin1_cstring(
		&collision_polygon2d_class_name_data,
		cstring("CollisionPolygon2D"),
	)
	gt.class_name_init_latin1_cstring(&canvas_layer_class_name_data, cstring("CanvasLayer"))
	gt.class_name_init_latin1_cstring(&polygon2d_class_name_data, cstring("Polygon2D"))
	gt.class_name_init_latin1_cstring(&line2d_class_name_data, cstring("Line2D"))
	gt.class_name_init_latin1_cstring(&circle_shape2d_class_name_data, cstring("CircleShape2D"))
	gt.class_name_init_latin1_cstring(
		&rectangle_shape2d_class_name_data,
		cstring("RectangleShape2D"),
	)
	gt.class_name_init_latin1_cstring(&segment_shape2d_class_name_data, cstring("SegmentShape2D"))
	gt.class_name_init_latin1_cstring(
		&separation_ray_shape2d_class_name_data,
		cstring("SeparationRayShape2D"),
	)
	gt.class_name_init_latin1_cstring(
		&world_boundary_shape2d_class_name_data,
		cstring("WorldBoundaryShape2D"),
	)
	gt.class_name_init_latin1_cstring(&capsule_shape2d_class_name_data, cstring("CapsuleShape2D"))
	gt.class_name_init_latin1_cstring(&canvas_modulate_class_name_data, cstring("CanvasModulate"))
	gt.class_name_init_latin1_cstring(&parallax2d_class_name_data, cstring("Parallax2D"))
	gt.class_name_init_latin1_cstring(&font_file_class_name_data, cstring("FontFile"))
	gt.class_name_init_latin1_cstring(&tile_map_layer_class_name_data, cstring("TileMapLayer"))
	gt.class_name_init_latin1_cstring(&tile_map_class_name_data, cstring("TileMap"))
	gt.class_name_init_latin1_cstring(&path_follow2d_class_name_data, cstring("PathFollow2D"))
	gt.class_name_init_latin1_cstring(
		&visible_on_screen_notifier2d_class_name_data,
		cstring("VisibleOnScreenNotifier2D"),
	)
	gt.class_name_init_latin1_cstring(&texture_button_class_name_data, cstring("TextureButton"))
	gt.class_name_init_latin1_cstring(&progress_bar_class_name_data, cstring("ProgressBar"))
	gt.class_name_init_latin1_cstring(
		&texture_progress_bar_class_name_data,
		cstring("TextureProgressBar"),
	)
	gt.class_name_init_latin1_cstring(&style_box_class_name_data, cstring("StyleBox"))
	gt.class_name_init_latin1_cstring(
		&audio_stream_player_class_name_data,
		cstring("AudioStreamPlayer"),
	)
	gt.class_name_init_latin1_cstring(
		&audio_stream_player2d_class_name_data,
		cstring("AudioStreamPlayer2D"),
	)
	gt.class_name_init_latin1_cstring(
		&audio_listener2d_class_name_data,
		cstring("AudioListener2D"),
	)
	gt.class_name_init_latin1_cstring(
		&remote_transform2d_class_name_data,
		cstring("RemoteTransform2D"),
	)
	gt.class_name_init_latin1_cstring(
		&animation_player_class_name_data,
		cstring("AnimationPlayer"),
	)
	gt.init_class_bindings()

	gt.register_editor_visible_class(
		gt.EditorVisibleClassDescriptor {
			class_name = game_class_name,
			parent_class_name = game_parent_name,
			create_instance_func = create_instance,
			free_instance_func = free_instance,
			notification_func = notification_func,
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
