package facade_tests

import gt "godot:godot"

// Compile-only smoke coverage for public generated class APIs. This package
// intentionally imports only godot:godot, proving normal users do not need to
// import internal generated class packages directly.
class_facade_compile_smoke :: proc "contextless" (
	object: gt.Object,
	node2d: gt.Node2D,
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
