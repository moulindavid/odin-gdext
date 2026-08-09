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
