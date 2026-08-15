package hello

import "core:fmt"
import gt "godot:godot"

// Local typed handle used by the example.

HelloNode :: distinct gt.ObjectPtr

hello_node_object :: proc "contextless" (self: HelloNode) -> gt.ObjectPtr {
	return gt.ObjectPtr(self)
}
hello_node_from_instance :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: HelloNode,
	ok: bool,
) {
	data, data_ok := gt.class_instance_data(instance, HelloData)
	if !data_ok do return {}, false
	return HelloNode(data.object), true
}

// Extension-owned instance data.

HelloData :: struct {
	object: gt.ObjectPtr,
	speed:  gt.GodotReal,
}

// Class lifecycle callbacks.


create_instance :: proc "c" (class_userdata: rawptr, notify_postinitialize: bool) -> gt.ObjectPtr {
	context = gt.godot_context()
	object := gt.construct_object(hello_parent_name)
	if object == nil {return nil}

	node2d := gt.Node2D(object)
	gt.node2d_set_position(node2d, gt.Vector2{100, 50})
	position := gt.node2d_get_position(node2d)
	gt.node2d_set_rotation(node2d, 1.25)
	rotation := gt.node2d_get_rotation(node2d)
	buf: [256]u8
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"generated Node2D position: (%v,%v) rotation=%.2f (expect 100,50,1.25)",
			position.x,
			position.y,
			rotation,
		),
	)

	node := gt.node2d_as_node(node2d)
	parent := gt.node_get_parent(node)
	self_is_ancestor := gt.node_is_ancestor_of(node, node)
	path_to_self := gt.node_get_path_to(node, node, false)
	path_to_self_hash := gt.node_path_hash(&path_to_self)
	gt.node_path_free(&path_to_self)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"generated Node mapping: parent_nil=%v self_ancestor=%v path_hash=%v (expect true,false,owned)",
			gt.is_nil(gt.Object(parent)),
			self_is_ancestor,
			path_to_self_hash,
		),
	)

	cast_node2d, cast_node2d_ok := gt.object_try_as_node2d(gt.Object(object))
	cast_node, cast_node_ok := gt.object_try_as_node(gt.Object(object))
	nil_object: gt.Object
	nil_node2d, nil_node2d_ok := gt.object_try_as_node2d(nil_object)
	downcast_identity_ok :=
		gt.node2d_as_object(cast_node2d) == object &&
		gt.node_as_object(cast_node) == object &&
		gt.node2d_as_object(nil_node2d) == nil
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"generated downcasts: is_node2d=%v object->Node2D=%v object->Node=%v nil->Node2D=%v identity=%v (expect true,true,true,false,true)",
			gt.object_is_node2d(gt.Object(object)),
			cast_node2d_ok,
			cast_node_ok,
			nil_node2d_ok,
			downcast_identity_ok,
		),
	)

	ref_object := gt.construct_object(ref_counted_class_name)
	owned_ref_ok := false
	owned_ref_release_ok := false
	owned_ref_destroyed := false
	owned_ref_count: i64 = -1
	if ref_object != nil {
		ref_counted := gt.RefCounted(ref_object)
		owned_ref_count = gt.ref_counted_get_reference_count(ref_counted)
		owned_ref, init_ok := gt.owned_ref_counted_init_owned(ref_counted)
		owned_ref_ok = init_ok
		if init_ok {
			owned_ref_destroyed, owned_ref_release_ok = gt.owned_ref_counted_release(&owned_ref)
		}
	}
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"owned RefCounted smoke: count=%v init=%v release=%v destroyed=%v (expect 1,true,true,true)",
			owned_ref_count,
			owned_ref_ok,
			owned_ref_release_ok,
			owned_ref_destroyed,
		),
	)

	canvas_item := gt.node2d_as_canvas_item(node2d)
	gt.canvas_item_hide(canvas_item)
	hidden := gt.canvas_item_is_visible(canvas_item)
	gt.canvas_item_show(canvas_item)
	shown := gt.canvas_item_is_visible(canvas_item)
	gt.canvas_item_queue_redraw(canvas_item)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"generated CanvasItem mapping: hidden=%v shown=%v (expect false,true)",
			hidden,
			shown,
		),
	)

	meta_name := gt.string_name_from_utf8_cstring(cstring("odin_meta_value"))
	meta_value := gt.variant_from_int(1234)
	gt.object_set_meta(gt.Object(object), &meta_name, &meta_value)
	meta_default := gt.variant_nil()
	meta_back := gt.object_get_meta(gt.Object(object), &meta_name, &meta_default)
	meta_int, meta_ok := gt.variant_try_int(&meta_back)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"generated Variant mapping: meta=%v/%v (expect 1234/true)",
			meta_int,
			meta_ok,
		),
	)
	gt.variant_free(&meta_back)
	gt.variant_free(&meta_default)
	gt.variant_free(&meta_value)
	gt.string_name_free(&meta_name)

	self_ := new_clone(HelloData{object = object, speed = 120.0})
	gt.attach_instance(object, hello_class_name, self_, &hello_instance_binding_callbacks)
	return object
}

free_instance :: proc "c" (class_userdata: rawptr, instance: gt.ClassInstancePtr) {
	context = gt.godot_context()
	self_, ok := gt.class_instance_data(instance, HelloData)
	if !ok do return
	free(self_)
}

hello_ready :: proc(instance: gt.ClassInstancePtr, reversed: bool) {
	_ = reversed
	hn, hn_ok := hello_node_from_instance(instance)
	if !hn_ok do return
	gt.debug_print("Hello from Odin!")

	obj := hello_node_object(hn)
	buf: [128]u8
	gt.debug_print(fmt.bprintf(buf[:], "is_nil: %v (expect false)", gt.is_nil(gt.Object(obj))))
	gt.debug_print(
		fmt.bprintf(buf[:], "is_class Node: %v (expect true)", gt.is_class(obj, node_class_name)),
	)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"is_class Node2D: %v (expect true)",
			gt.is_class(obj, node2d_class_name),
		),
	)

	v := gt.object_to_variant(obj)
	back, back_ok := gt.variant_try_object(&v)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"variant object roundtrip: %v / %v (expect true / true)",
			back == obj,
			back_ok,
		),
	)
	gt.variant_free(&v)

	node2d := gt.Node2D(obj)
	gt.node2d_set_position(node2d, gt.Vector2{100, 50})
	position := gt.node2d_get_position(node2d)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"generated Node2D position: (%v,%v) (expect 100,50)",
			position.x,
			position.y,
		),
	)

	// Generated utility smoke checks.
	gt.debug_print(fmt.bprintf(buf[:], "sin(1.0): %.6f (expect ~0.841471)", gt.sin(1.0)))
	gt.debug_print(fmt.bprintf(buf[:], "cos(0.0): %.6f (expect 1.0)", gt.cos(0.0)))
	gt.debug_print(fmt.bprintf(buf[:], "randf(): %.6f", gt.randf()))
}

hello_node_virtuals := gt.NodeVirtualCallbacks {
	ready = hello_ready,
}

notification_func :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	context = gt.godot_context()
	if gt.dispatch_node_virtual_callbacks(instance, what, reversed, &hello_node_virtuals) do return
}

// Method adapters.

add :: proc "contextless" (self: HelloNode, a: gt.GodotReal, b: gt.GodotReal) -> gt.GodotReal {
	_ = self
	return a + b
}

add_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	a: gt.GodotReal,
	b: gt.GodotReal,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	self, self_ok := hello_node_from_instance(instance)
	if !self_ok do return 0, false
	gt.object_emit_signal_0(hello_node_object(self), pinged_signal_name)
	return add(self, a, b), true
}

add_method_adapter := gt.ClassMethodGodotReal2ToGodotRealAdapter {
	method = add_adapter_method,
}

roll_math :: proc "contextless" (self: HelloNode) -> gt.GodotReal {
	_ = self
	r := gt.randf() * 10.0
	wave := gt.sin(r) + gt.cos(r * 0.5)
	return r * r + wave * 5.0
}

roll_math_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	self, self_ok := hello_node_from_instance(instance)
	if !self_ok do return 0, false
	return roll_math(self), true
}

roll_math_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = roll_math_adapter_method,
}

get_speed_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
) -> (
	value: gt.GodotReal,
	ok: bool,
) {
	self_, self_ok := gt.class_instance_data(instance, HelloData)
	if !self_ok do return 0, false
	return self_.speed, true
}

set_speed_adapter_method :: proc "contextless" (
	instance: gt.ClassInstancePtr,
	value: gt.GodotReal,
) -> bool {
	self_, self_ok := gt.class_instance_data(instance, HelloData)
	if !self_ok do return false
	self_.speed = value
	gt.object_emit_signal_1_godot_real(self_.object, speed_changed_signal_name, value)
	return true
}

get_speed_method_adapter := gt.ClassMethodGetGodotRealAdapter {
	method = get_speed_adapter_method,
}

set_speed_method_adapter := gt.ClassMethodSetGodotRealAdapter {
	method = set_speed_adapter_method,
}

add_method_name_data: gt.StaticStringName
add_method_name := gt.const_static_string_name_ptr(&add_method_name_data)
add_arg_info: [2]gt.PropertyInfo
add_arg_meta := [2]gt.ClassMethodArgumentMetadata{.None, .None}
add_return_info: gt.PropertyInfo
add_method_info: gt.ClassMethodInfo

add_arg_a_name_data: gt.StaticStringName
add_arg_a_name := gt.const_static_string_name_ptr(&add_arg_a_name_data)
add_arg_b_name_data: gt.StaticStringName
add_arg_b_name := gt.const_static_string_name_ptr(&add_arg_b_name_data)
roll_math_method_name_data: gt.StaticStringName
roll_math_method_name := gt.const_static_string_name_ptr(&roll_math_method_name_data)
roll_math_return_info: gt.PropertyInfo
roll_math_method_info: gt.ClassMethodInfo

empty_name_data: gt.StaticStringName
empty_name := gt.const_static_string_name_ptr(&empty_name_data)
empty_str_data: gt.String
empty_str := gt.const_string_ptr(&empty_str_data)

speed_property_name_data: gt.StaticStringName
speed_setter_name_data: gt.StaticStringName
speed_getter_name_data: gt.StaticStringName
speed_property_name := gt.const_static_string_name_ptr(&speed_property_name_data)
speed_setter_name := gt.const_static_string_name_ptr(&speed_setter_name_data)
speed_getter_name := gt.const_static_string_name_ptr(&speed_getter_name_data)
speed_property_info: gt.PropertyInfo
speed_get_return_info: gt.PropertyInfo
speed_set_arg_info: gt.PropertyInfo
speed_set_arg_meta := [1]gt.ClassMethodArgumentMetadata{.None}
speed_get_method_info: gt.ClassMethodInfo
speed_set_method_info: gt.ClassMethodInfo

pinged_signal_name_data: gt.StaticStringName
pinged_signal_name := gt.const_static_string_name_ptr(&pinged_signal_name_data)
speed_changed_signal_name_data: gt.StaticStringName
speed_changed_arg_name_data: gt.StaticStringName
speed_changed_signal_name := gt.const_static_string_name_ptr(&speed_changed_signal_name_data)
speed_changed_arg_name := gt.const_static_string_name_ptr(&speed_changed_arg_name_data)
speed_changed_arg_info: gt.PropertyInfo

register_methods :: proc() {
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&add_method_name_data),
		cstring("add"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&add_arg_a_name_data),
		cstring("a"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&add_arg_b_name_data),
		cstring("b"),
	)
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
	gt.string_init_utf8(gt.uninitialized_string_ptr(&empty_str_data), "")

	gt.init_method_property_info(
		&add_arg_info[0],
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = add_arg_a_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.init_method_property_info(
		&add_arg_info[1],
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = add_arg_b_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.init_method_property_info(
		&add_return_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = add_method_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)

	gt.register_class_method_with_descriptor(
		hello_class_name,
		&add_method_info,
		gt.ClassMethodDescriptor {
			name = add_method_name,
			method_userdata = &add_method_adapter,
			call_func = gt.class_method_godot_real2_to_godot_real_call,
			ptrcall_func = gt.class_method_godot_real2_to_godot_real_ptrcall,
			return_value_info = &add_return_info,
			return_value_metadata = .None,
			argument_count = 2,
			arguments_info = &add_arg_info[0],
			arguments_metadata = &add_arg_meta[0],
		},
	)
	gt.init_method_property_info(
		&roll_math_return_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = roll_math_method_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_method_with_descriptor(
		hello_class_name,
		&roll_math_method_info,
		gt.ClassMethodDescriptor {
			name = roll_math_method_name,
			method_userdata = &roll_math_method_adapter,
			call_func = gt.class_method_get_godot_real_call,
			ptrcall_func = gt.class_method_get_godot_real_ptrcall,
			return_value_info = &roll_math_return_info,
			return_value_metadata = .None,
		},
	)
	gt.debug_print("[odin-gdext] Methods add and roll_math registered!")

	gt.init_method_property_info(
		&speed_get_return_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = speed_property_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_method_with_descriptor(
		hello_class_name,
		&speed_get_method_info,
		gt.ClassMethodDescriptor {
			name = speed_getter_name,
			method_userdata = &get_speed_method_adapter,
			call_func = gt.class_method_get_godot_real_call,
			ptrcall_func = gt.class_method_get_godot_real_ptrcall,
			return_value_info = &speed_get_return_info,
			return_value_metadata = .None,
		},
	)

	gt.init_method_property_info(
		&speed_set_arg_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = speed_property_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_method_with_descriptor(
		hello_class_name,
		&speed_set_method_info,
		gt.ClassMethodDescriptor {
			name = speed_setter_name,
			method_userdata = &set_speed_method_adapter,
			call_func = gt.class_method_set_godot_real_call,
			ptrcall_func = gt.class_method_set_godot_real_ptrcall,
			argument_count = 1,
			arguments_info = &speed_set_arg_info,
			arguments_metadata = &speed_set_arg_meta[0],
		},
	)
	gt.debug_print("[odin-gdext] Property accessors registered!")
}

register_properties :: proc() {
	gt.register_class_property_with_descriptor(
		hello_class_name,
		&speed_property_info,
		gt.ClassPropertyDescriptor {
			property = gt.MethodPropertyDescriptor {
				type = .Float,
				name = speed_property_name,
				class_name = empty_name,
				hint_string = empty_str,
				usage = gt.PropertyUsageDefault,
			},
			setter = speed_setter_name,
			getter = speed_getter_name,
		},
	)
	gt.debug_print("[odin-gdext] Property speed registered!")
}

register_signals :: proc() {
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&pinged_signal_name_data),
		cstring("pinged"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&speed_changed_signal_name_data),
		cstring("speed_changed"),
	)
	gt.static_string_name_init_latin1_cstring(
		gt.uninitialized_static_string_name_ptr(&speed_changed_arg_name_data),
		cstring("value"),
	)
	gt.register_class_signal_with_descriptor(
		hello_class_name,
		gt.ClassSignalDescriptor{name = pinged_signal_name},
	)
	gt.init_method_property_info(
		&speed_changed_arg_info,
		gt.MethodPropertyDescriptor {
			type = .Float,
			name = speed_changed_arg_name,
			class_name = empty_name,
			hint_string = empty_str,
		},
	)
	gt.register_class_signal_with_descriptor(
		hello_class_name,
		gt.ClassSignalDescriptor {
			name = speed_changed_signal_name,
			argument_info = &speed_changed_arg_info,
			argument_count = 1,
		},
	)
	gt.debug_print("[odin-gdext] Signals pinged and speed_changed registered!")
}

// Process-lifetime registration metadata.

hello_name_data: gt.ClassName
parent_name_data: gt.ClassName
hello_class_name := gt.class_name_ptr(&hello_name_data)
hello_parent_name := gt.class_name_ptr(&parent_name_data)
node_class_name_data: gt.ClassName
node_class_name := gt.class_name_ptr(&node_class_name_data)
node2d_class_name_data: gt.ClassName
node2d_class_name := gt.class_name_ptr(&node2d_class_name_data)
ref_counted_class_name_data: gt.ClassName
ref_counted_class_name := gt.class_name_ptr(&ref_counted_class_name_data)

hello_instance_binding_callbacks := gt.InstanceBindingCallbacks {
	create_callback    = nil,
	free_callback      = nil,
	reference_callback = nil,
}

register_classes :: proc() {
	context = gt.godot_context()
	gt.debug_print("[odin-gdext] Registering HelloNode...")

	gt.class_name_init_latin1_cstring(&hello_name_data, cstring("HelloNode"))
	gt.class_name_init_latin1_cstring(&parent_name_data, cstring("Node2D"))
	gt.class_name_init_latin1_cstring(&node_class_name_data, cstring("Node"))
	gt.class_name_init_latin1_cstring(&node2d_class_name_data, cstring("Node2D"))
	gt.class_name_init_latin1_cstring(&ref_counted_class_name_data, cstring("RefCounted"))
	gt.init_class_bindings()

	gt.register_editor_visible_class(
		gt.EditorVisibleClassDescriptor {
			class_name = hello_class_name,
			parent_class_name = hello_parent_name,
			create_instance_func = create_instance,
			free_instance_func = free_instance,
			notification_func = notification_func,
		},
	)
	gt.debug_print("[odin-gdext] HelloNode registered!")

	buf: [160]u8

	register_methods()
	register_properties()
	register_signals()

	// Variant primitive round-trip.
	vf := gt.variant_from_float(3.14)
	vi := gt.variant_from_int(-42)
	vb := gt.variant_from_bool(true)
	gt.debug_print(fmt.bprintf(buf[:], "Float: %v (expect 3.14)", gt.variant_to_float(&vf)))
	gt.debug_print(fmt.bprintf(buf[:], "Int:   %v (expect -42)", gt.variant_to_int(&vi)))
	gt.debug_print(fmt.bprintf(buf[:], "Bool:  %v (expect true)", gt.variant_to_bool(&vb)))
	gt.debug_print(fmt.bprintf(buf[:], "Float type: %v (expect Float)", gt.variant_type(&vf)))
	vf_try, vf_ok := gt.variant_try_float(&vf)
	vi_as_float, vi_as_float_ok := gt.variant_try_float(&vi)
	gt.debug_print(
		fmt.bprintf(buf[:], "try_float(vf): %v / %v (expect 3.14 / true)", vf_try, vf_ok),
	)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"try_float(vi): %v / %v (expect 0 / false)",
			vi_as_float,
			vi_as_float_ok,
		),
	)
	nil_variant := gt.variant_nil()
	gt.debug_print(
		fmt.bprintf(buf[:], "Nil Variant: %v (expect true)", gt.variant_is_nil(&nil_variant)),
	)
	gt.variant_free(&nil_variant)
	gt.variant_free(&vf)
	gt.variant_free(&vi)
	gt.variant_free(&vb)


	// RID values do not own the server resource they identify.
	rid := gt.rid_new()
	rid_copy := gt.rid_copy(&rid)
	rid_v := gt.variant_from_rid(&rid)
	rid_back, rid_back_ok := gt.variant_try_rid(&rid_v)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"RID: valid=%v id=%v copy_id=%v roundtrip=%v (expect false / 0 / 0 / true)",
			gt.rid_is_valid(&rid),
			gt.rid_get_id(&rid),
			gt.rid_get_id(&rid_copy),
			rid_back_ok,
		),
	)
	if rid_back_ok do gt.rid_free(&rid_back)
	gt.variant_free(&rid_v)
	gt.rid_free(&rid_copy)
	gt.rid_free(&rid)

	// Array wrapper and Variant extraction.
	arr := gt.array_new()
	v1 := gt.variant_from_float(10.0)
	v2 := gt.variant_from_float(20.0)
	gt.array_push(&arr, &v1)
	gt.array_push(&arr, &v2)
	size := gt.array_size(&arr)
	arr_first := gt.array_get(&arr, 0)
	arr_first_value, arr_first_ok := gt.variant_try_float(&arr_first)
	arr_has_v1_before_erase := gt.array_has(&arr, &v1)
	gt.array_erase(&arr, &v1)
	arr_size_after_erase := gt.array_size(&arr)
	gt.array_set(&arr, 0, &v1)
	arr_first_after_set := gt.array_get(&arr, 0)
	arr_first_after_set_value, arr_first_after_set_ok := gt.variant_try_float(&arr_first_after_set)
	gt.array_clear(&arr)
	arr_empty_after_clear := gt.array_is_empty(&arr)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"Array: size=%v get0=%v/%v has10=%v erase_size=%v set0=%v/%v clear_empty=%v",
			size,
			arr_first_value,
			arr_first_ok,
			arr_has_v1_before_erase,
			arr_size_after_erase,
			arr_first_after_set_value,
			arr_first_after_set_ok,
			arr_empty_after_clear,
		),
	)
	gt.variant_free(&arr_first_after_set)
	gt.variant_free(&arr_first)
	gt.array_push(&arr, &v1)
	gt.array_push(&arr, &v2)
	arr_v := gt.variant_from_array(&arr)
	arr_back, arr_back_ok := gt.variant_try_array(&arr_v)
	gt.debug_print(fmt.bprintf(buf[:], "variant_try_array(arr_v): %v (expect true)", arr_back_ok))
	if arr_back_ok do gt.array_free(&arr_back)
	gt.variant_free(&arr_v)
	gt.variant_free(&v1)
	gt.variant_free(&v2)
	gt.array_free(&arr)

	// Dictionary wrapper and Variant extraction.
	dict := gt.dictionary_new()
	dict_key := gt.variant_from_cstring(cstring("answer"))
	dict_value := gt.variant_from_int(42)
	dict_set_ok := gt.dictionary_set(&dict, &dict_key, &dict_value)
	dict_has_key := gt.dictionary_has(&dict, &dict_key)
	dict_size := gt.dictionary_size(&dict)
	dict_empty := gt.dictionary_is_empty(&dict)
	dict_got := gt.dictionary_get(&dict, &dict_key)
	dict_got_value, dict_got_ok := gt.variant_try_int(&dict_got)
	dict_erased := gt.dictionary_erase(&dict, &dict_key)
	dict_size_after_erase := gt.dictionary_size(&dict)
	_ = gt.dictionary_set(&dict, &dict_key, &dict_value)
	gt.dictionary_clear(&dict)
	dict_empty_after_clear := gt.dictionary_is_empty(&dict)
	_ = gt.dictionary_set(&dict, &dict_key, &dict_value)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"Dictionary: set=%v has=%v size=%v empty=%v get=%v/%v erase=%v erase_size=%v clear_empty=%v",
			dict_set_ok,
			dict_has_key,
			dict_size,
			dict_empty,
			dict_got_value,
			dict_got_ok,
			dict_erased,
			dict_size_after_erase,
			dict_empty_after_clear,
		),
	)
	gt.variant_free(&dict_got)
	dict_v := gt.variant_from_dictionary(&dict)
	dict_back, dict_back_ok := gt.variant_try_dictionary(&dict_v)
	gt.debug_print(
		fmt.bprintf(buf[:], "variant_try_dictionary(dict_v): %v (expect true)", dict_back_ok),
	)
	if dict_back_ok do gt.dictionary_free(&dict_back)
	gt.variant_free(&dict_v)
	gt.variant_free(&dict_key)
	gt.variant_free(&dict_value)
	gt.dictionary_free(&dict)

	// PackedByteArray wrapper and Variant extraction.
	bytes := gt.packed_byte_array_new()
	gt.packed_byte_array_push(&bytes, 7)
	gt.packed_byte_array_push(&bytes, 42)
	bytes_size := gt.packed_byte_array_size(&bytes)
	bytes_first := gt.packed_byte_array_get(&bytes, 0)
	gt.packed_byte_array_set(&bytes, 1, 99)
	bytes_second_after_set := gt.packed_byte_array_get(&bytes, 1)
	bytes_v := gt.variant_from_packed_byte_array(&bytes)
	bytes_back, bytes_back_ok := gt.variant_try_packed_byte_array(&bytes_v)
	bytes_back_size: i64 = 0
	if bytes_back_ok {
		bytes_back_size = gt.packed_byte_array_size(&bytes_back)
		gt.packed_byte_array_free(&bytes_back)
	}
	gt.packed_byte_array_clear(&bytes)
	bytes_empty_after_clear := gt.packed_byte_array_is_empty(&bytes)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedByteArray: size=%v get0=%v set1=%v roundtrip=%v/%v clear_empty=%v",
			bytes_size,
			bytes_first,
			bytes_second_after_set,
			bytes_back_ok,
			bytes_back_size,
			bytes_empty_after_clear,
		),
	)
	gt.variant_free(&bytes_v)
	gt.packed_byte_array_free(&bytes)

	// PackedInt32Array wrapper and Variant extraction.
	ints := gt.packed_int32_array_new()
	gt.packed_int32_array_push(&ints, -10)
	gt.packed_int32_array_push(&ints, 2048)
	ints_size := gt.packed_int32_array_size(&ints)
	ints_first := gt.packed_int32_array_get(&ints, 0)
	gt.packed_int32_array_set(&ints, 1, -4096)
	ints_second_after_set := gt.packed_int32_array_get(&ints, 1)
	ints_v := gt.variant_from_packed_int32_array(&ints)
	ints_back, ints_back_ok := gt.variant_try_packed_int32_array(&ints_v)
	ints_back_size: i64 = 0
	if ints_back_ok {
		ints_back_size = gt.packed_int32_array_size(&ints_back)
		gt.packed_int32_array_free(&ints_back)
	}
	gt.packed_int32_array_clear(&ints)
	ints_empty_after_clear := gt.packed_int32_array_is_empty(&ints)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedInt32Array: size=%v get0=%v set1=%v roundtrip=%v/%v clear_empty=%v",
			ints_size,
			ints_first,
			ints_second_after_set,
			ints_back_ok,
			ints_back_size,
			ints_empty_after_clear,
		),
	)
	gt.variant_free(&ints_v)
	gt.packed_int32_array_free(&ints)

	// PackedInt64Array wrapper and Variant extraction.
	wide_ints := gt.packed_int64_array_new()
	gt.packed_int64_array_push(&wide_ints, -10000000000)
	gt.packed_int64_array_push(&wide_ints, 9000000000)
	wide_ints_size := gt.packed_int64_array_size(&wide_ints)
	wide_ints_first := gt.packed_int64_array_get(&wide_ints, 0)
	gt.packed_int64_array_set(&wide_ints, 1, -9000000000)
	wide_ints_second_after_set := gt.packed_int64_array_get(&wide_ints, 1)
	wide_ints_v := gt.variant_from_packed_int64_array(&wide_ints)
	wide_ints_back, wide_ints_back_ok := gt.variant_try_packed_int64_array(&wide_ints_v)
	wide_ints_back_size: i64 = 0
	if wide_ints_back_ok {
		wide_ints_back_size = gt.packed_int64_array_size(&wide_ints_back)
		gt.packed_int64_array_free(&wide_ints_back)
	}
	gt.packed_int64_array_clear(&wide_ints)
	wide_ints_empty_after_clear := gt.packed_int64_array_is_empty(&wide_ints)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedInt64Array: size=%v get0=%v set1=%v roundtrip=%v/%v clear_empty=%v",
			wide_ints_size,
			wide_ints_first,
			wide_ints_second_after_set,
			wide_ints_back_ok,
			wide_ints_back_size,
			wide_ints_empty_after_clear,
		),
	)
	gt.variant_free(&wide_ints_v)
	gt.packed_int64_array_free(&wide_ints)

	// PackedFloat32Array wrapper and Variant extraction.
	floats32 := gt.packed_float32_array_new()
	gt.packed_float32_array_push(&floats32, f32(1.5))
	gt.packed_float32_array_push(&floats32, f32(-2.25))
	floats32_size := gt.packed_float32_array_size(&floats32)
	floats32_first := gt.packed_float32_array_get(&floats32, 0)
	gt.packed_float32_array_set(&floats32, 1, f32(3.75))
	floats32_second_after_set := gt.packed_float32_array_get(&floats32, 1)
	floats32_v := gt.variant_from_packed_float32_array(&floats32)
	floats32_back, floats32_back_ok := gt.variant_try_packed_float32_array(&floats32_v)
	floats32_back_size: i64 = 0
	if floats32_back_ok {
		floats32_back_size = gt.packed_float32_array_size(&floats32_back)
		gt.packed_float32_array_free(&floats32_back)
	}
	gt.packed_float32_array_clear(&floats32)
	floats32_empty_after_clear := gt.packed_float32_array_is_empty(&floats32)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedFloat32Array: size=%v get0=%v set1=%v roundtrip=%v/%v clear_empty=%v",
			floats32_size,
			floats32_first,
			floats32_second_after_set,
			floats32_back_ok,
			floats32_back_size,
			floats32_empty_after_clear,
		),
	)
	gt.variant_free(&floats32_v)
	gt.packed_float32_array_free(&floats32)

	// PackedFloat64Array wrapper and Variant extraction.
	floats64 := gt.packed_float64_array_new()
	gt.packed_float64_array_push(&floats64, 1.5)
	gt.packed_float64_array_push(&floats64, -2.25)
	floats64_size := gt.packed_float64_array_size(&floats64)
	floats64_first := gt.packed_float64_array_get(&floats64, 0)
	gt.packed_float64_array_set(&floats64, 1, 3.75)
	floats64_second_after_set := gt.packed_float64_array_get(&floats64, 1)
	floats64_v := gt.variant_from_packed_float64_array(&floats64)
	floats64_back, floats64_back_ok := gt.variant_try_packed_float64_array(&floats64_v)
	floats64_back_size: i64 = 0
	if floats64_back_ok {
		floats64_back_size = gt.packed_float64_array_size(&floats64_back)
		gt.packed_float64_array_free(&floats64_back)
	}
	gt.packed_float64_array_clear(&floats64)
	floats64_empty_after_clear := gt.packed_float64_array_is_empty(&floats64)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedFloat64Array: size=%v get0=%v set1=%v roundtrip=%v/%v clear_empty=%v",
			floats64_size,
			floats64_first,
			floats64_second_after_set,
			floats64_back_ok,
			floats64_back_size,
			floats64_empty_after_clear,
		),
	)
	gt.variant_free(&floats64_v)
	gt.packed_float64_array_free(&floats64)


	// PackedStringArray returns owned String elements.
	strings := gt.packed_string_array_new()
	strings_first_input := gt.string_from_utf8("alpha")
	strings_second_input := gt.string_from_utf8("beta")
	strings_replacement := gt.string_from_utf8("gamma")
	gt.packed_string_array_push(&strings, &strings_first_input)
	gt.packed_string_array_push(&strings, &strings_second_input)
	strings_size := gt.packed_string_array_size(&strings)
	strings_first := gt.packed_string_array_get(&strings, 0)
	gt.packed_string_array_set(&strings, 1, &strings_replacement)
	strings_second_after_set := gt.packed_string_array_get(&strings, 1)
	strings_v := gt.variant_from_packed_string_array(&strings)
	strings_back, strings_back_ok := gt.variant_try_packed_string_array(&strings_v)
	strings_back_size: i64 = 0
	if strings_back_ok {
		strings_back_size = gt.packed_string_array_size(&strings_back)
		gt.packed_string_array_free(&strings_back)
	}
	strings_first_buf: [64]u8
	strings_second_buf: [64]u8
	strings_first_text, strings_first_ok, _ := gt.string_to_utf8(
		&strings_first,
		strings_first_buf[:],
	)
	strings_second_text, strings_second_ok, _ := gt.string_to_utf8(
		&strings_second_after_set,
		strings_second_buf[:],
	)
	gt.packed_string_array_clear(&strings)
	strings_empty_after_clear := gt.packed_string_array_is_empty(&strings)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedStringArray: size=%v get0=%v/%v set1=%v/%v roundtrip=%v/%v clear_empty=%v",
			strings_size,
			strings_first_text,
			strings_first_ok,
			strings_second_text,
			strings_second_ok,
			strings_back_ok,
			strings_back_size,
			strings_empty_after_clear,
		),
	)
	gt.variant_free(&strings_v)
	gt.string_free(&strings_second_after_set)
	gt.string_free(&strings_first)
	gt.string_free(&strings_replacement)
	gt.string_free(&strings_second_input)
	gt.string_free(&strings_first_input)
	gt.packed_string_array_free(&strings)

	// PackedVector2Array wrapper and Variant extraction.
	vectors2 := gt.packed_vector2_array_new()
	gt.packed_vector2_array_push(&vectors2, gt.Vector2{3, 4})
	gt.packed_vector2_array_push(&vectors2, gt.Vector2{-1, 2})
	vectors2_size := gt.packed_vector2_array_size(&vectors2)
	vectors2_first := gt.packed_vector2_array_get(&vectors2, 0)
	gt.packed_vector2_array_set(&vectors2, 1, gt.Vector2{6, 8})
	vectors2_second_after_set := gt.packed_vector2_array_get(&vectors2, 1)
	vectors2_v := gt.variant_from_packed_vector2_array(&vectors2)
	vectors2_back, vectors2_back_ok := gt.variant_try_packed_vector2_array(&vectors2_v)
	vectors2_back_size: i64 = 0
	if vectors2_back_ok {
		vectors2_back_size = gt.packed_vector2_array_size(&vectors2_back)
		gt.packed_vector2_array_free(&vectors2_back)
	}
	gt.packed_vector2_array_clear(&vectors2)
	vectors2_empty_after_clear := gt.packed_vector2_array_is_empty(&vectors2)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedVector2Array: size=%v get0=(%v,%v) set1=(%v,%v) roundtrip=%v/%v clear_empty=%v",
			vectors2_size,
			vectors2_first.x,
			vectors2_first.y,
			vectors2_second_after_set.x,
			vectors2_second_after_set.y,
			vectors2_back_ok,
			vectors2_back_size,
			vectors2_empty_after_clear,
		),
	)
	gt.variant_free(&vectors2_v)
	gt.packed_vector2_array_free(&vectors2)

	// PackedVector3Array wrapper and Variant extraction.
	vectors3 := gt.packed_vector3_array_new()
	gt.packed_vector3_array_push(&vectors3, gt.Vector3{1, 2, 3})
	gt.packed_vector3_array_push(&vectors3, gt.Vector3{-1, -2, -3})
	vectors3_size := gt.packed_vector3_array_size(&vectors3)
	vectors3_first := gt.packed_vector3_array_get(&vectors3, 0)
	gt.packed_vector3_array_set(&vectors3, 1, gt.Vector3{4, 5, 6})
	vectors3_second_after_set := gt.packed_vector3_array_get(&vectors3, 1)
	vectors3_v := gt.variant_from_packed_vector3_array(&vectors3)
	vectors3_back, vectors3_back_ok := gt.variant_try_packed_vector3_array(&vectors3_v)
	vectors3_back_size: i64 = 0
	if vectors3_back_ok {
		vectors3_back_size = gt.packed_vector3_array_size(&vectors3_back)
		gt.packed_vector3_array_free(&vectors3_back)
	}
	gt.packed_vector3_array_clear(&vectors3)
	vectors3_empty_after_clear := gt.packed_vector3_array_is_empty(&vectors3)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedVector3Array: size=%v get0=(%v,%v,%v) set1=(%v,%v,%v) roundtrip=%v/%v clear_empty=%v",
			vectors3_size,
			vectors3_first.x,
			vectors3_first.y,
			vectors3_first.z,
			vectors3_second_after_set.x,
			vectors3_second_after_set.y,
			vectors3_second_after_set.z,
			vectors3_back_ok,
			vectors3_back_size,
			vectors3_empty_after_clear,
		),
	)
	gt.variant_free(&vectors3_v)
	gt.packed_vector3_array_free(&vectors3)


	// PackedVector4Array wrapper and Variant extraction.
	vectors4 := gt.packed_vector4_array_new()
	gt.packed_vector4_array_push(&vectors4, gt.Vector4{1, 2, 3, 4})
	gt.packed_vector4_array_push(&vectors4, gt.Vector4{-1, -2, -3, -4})
	vectors4_size := gt.packed_vector4_array_size(&vectors4)
	vectors4_first := gt.packed_vector4_array_get(&vectors4, 0)
	gt.packed_vector4_array_set(&vectors4, 1, gt.Vector4{5, 6, 7, 8})
	vectors4_second_after_set := gt.packed_vector4_array_get(&vectors4, 1)
	vectors4_v := gt.variant_from_packed_vector4_array(&vectors4)
	vectors4_back, vectors4_back_ok := gt.variant_try_packed_vector4_array(&vectors4_v)
	vectors4_back_size: i64 = 0
	if vectors4_back_ok {
		vectors4_back_size = gt.packed_vector4_array_size(&vectors4_back)
		gt.packed_vector4_array_free(&vectors4_back)
	}
	gt.packed_vector4_array_clear(&vectors4)
	vectors4_empty_after_clear := gt.packed_vector4_array_is_empty(&vectors4)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedVector4Array: size=%v get0=(%v,%v,%v,%v) set1=(%v,%v,%v,%v) roundtrip=%v/%v clear_empty=%v",
			vectors4_size,
			vectors4_first.x,
			vectors4_first.y,
			vectors4_first.z,
			vectors4_first.w,
			vectors4_second_after_set.x,
			vectors4_second_after_set.y,
			vectors4_second_after_set.z,
			vectors4_second_after_set.w,
			vectors4_back_ok,
			vectors4_back_size,
			vectors4_empty_after_clear,
		),
	)
	gt.variant_free(&vectors4_v)
	gt.packed_vector4_array_free(&vectors4)


	// PackedColorArray wrapper and Variant extraction.
	colors := gt.packed_color_array_new()
	gt.packed_color_array_push(&colors, gt.Color{1, 0, 0, 1})
	gt.packed_color_array_push(&colors, gt.Color{0, 1, 0, 1})
	colors_size := gt.packed_color_array_size(&colors)
	colors_first := gt.packed_color_array_get(&colors, 0)
	gt.packed_color_array_set(&colors, 1, gt.Color{0, 0, 1, 0.5})
	colors_second_after_set := gt.packed_color_array_get(&colors, 1)
	colors_v := gt.variant_from_packed_color_array(&colors)
	colors_back, colors_back_ok := gt.variant_try_packed_color_array(&colors_v)
	colors_back_size: i64 = 0
	if colors_back_ok {
		colors_back_size = gt.packed_color_array_size(&colors_back)
		gt.packed_color_array_free(&colors_back)
	}
	gt.packed_color_array_clear(&colors)
	colors_empty_after_clear := gt.packed_color_array_is_empty(&colors)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"PackedColorArray: size=%v get0=(%v,%v,%v,%v) set1=(%v,%v,%v,%v) roundtrip=%v/%v clear_empty=%v",
			colors_size,
			colors_first.r,
			colors_first.g,
			colors_first.b,
			colors_first.a,
			colors_second_after_set.r,
			colors_second_after_set.g,
			colors_second_after_set.b,
			colors_second_after_set.a,
			colors_back_ok,
			colors_back_size,
			colors_empty_after_clear,
		),
	)
	gt.variant_free(&colors_v)
	gt.packed_color_array_free(&colors)

	// print utility function.
	gt.print_init()
	vs := gt.variant_from_cstring(cstring("Hello from Odin via Variant!"))
	gt.print(gt.variant_ptr(&vs))
	utf8_buf: [128]u8
	utf8_text, utf8_ok, utf8_needed := gt.variant_try_utf8(&vs, utf8_buf[:])
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"try_utf8(vs): %v / %v / %v bytes (expect message / true)",
			utf8_text,
			utf8_ok,
			utf8_needed,
		),
	)
	gt.variant_free(&vs)

	// String wrapper and Variant extraction.
	gs := gt.string_from_utf8("Owned Godot String")
	gs_prefix := gt.string_from_utf8("Owned")
	gs_suffix := gt.string_from_utf8("String")
	gs_needle := gt.string_from_utf8("Godot")
	gs_case := gt.string_from_utf8("owned godot string")
	string_text, string_ok, string_needed := gt.string_to_utf8(&gs, utf8_buf[:])
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"string_to_utf8(gs): %v / %v / %v bytes (expect owned string / true)",
			string_text,
			string_ok,
			string_needed,
		),
	)
	gsv := gt.variant_from_string(&gs)
	gs_back, gs_back_ok := gt.variant_try_string(&gsv)
	if gs_back_ok {
		defer gt.string_free(&gs_back)
		back_text, back_ok, back_needed := gt.string_to_utf8(&gs_back, utf8_buf[:])
		gt.debug_print(
			fmt.bprintf(
				buf[:],
				"variant_try_string(gsv): %v / %v / %v bytes (expect owned string / true)",
				back_text,
				back_ok,
				back_needed,
			),
		)
	}
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"string methods: len=%v empty=%v hash>0=%v begins=%v ends=%v contains=%v nocase=%v",
			gt.string_length(&gs),
			gt.string_is_empty(&gs),
			gt.string_hash(&gs) != 0,
			gt.string_begins_with(&gs, &gs_prefix),
			gt.string_ends_with(&gs, &gs_suffix),
			gt.string_contains(&gs, &gs_needle),
			gt.string_nocasecmp_to(&gs, &gs_case) == 0,
		),
	)
	generated_html := gt.color_to_html(gt.Color{0.25, 0.5, 0.75, 1}, true)
	generated_html_text, generated_html_ok, generated_html_needed := gt.string_to_utf8(
		&generated_html,
		utf8_buf[:],
	)
	generated_color := gt.color_html(&generated_html)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"generated String return: %v / %v / %v bytes -> color=(%v,%v,%v,%v)",
			generated_html_text,
			generated_html_ok,
			generated_html_needed,
			generated_color.r,
			generated_color.g,
			generated_color.b,
			generated_color.a,
		),
	)
	gt.string_free(&generated_html)
	gt.variant_free(&gsv)
	gt.string_free(&gs_case)
	gt.string_free(&gs_needle)
	gt.string_free(&gs_suffix)
	gt.string_free(&gs_prefix)
	gt.string_free(&gs)

	// StringName wrapper and Variant extraction.
	sn := gt.string_name_from_utf8_cstring(cstring("HelloNode"))
	snv := gt.variant_from_string_name(&sn)
	sn_back, sn_back_ok := gt.variant_try_string_name(&snv)
	gt.debug_print(
		fmt.bprintf(buf[:], "variant_try_string_name(snv): %v (expect true)", sn_back_ok),
	)
	if sn_back_ok do gt.string_name_free(&sn_back)
	gt.variant_free(&snv)
	gt.string_name_free(&sn)

	// NodePath wrapper and Variant extraction.
	np := gt.node_path_from_utf8("../HelloNode")
	npv := gt.variant_from_node_path(&np)
	np_back, np_back_ok := gt.variant_try_node_path(&npv)
	gt.debug_print(fmt.bprintf(buf[:], "variant_try_node_path(npv): %v (expect true)", np_back_ok))
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"node_path: absolute=%v names=%v subnames=%v hash>0=%v (expect false / 2 / 0 / true)",
			gt.node_path_is_absolute(&np),
			gt.node_path_get_name_count(&np),
			gt.node_path_get_subname_count(&np),
			gt.node_path_hash(&np) != 0,
		),
	)
	name := gt.node_path_get_name(&np, 1)
	name_v := gt.variant_from_string_name(&name)
	name_back, name_ok := gt.variant_try_string_name(&name_v)
	gt.debug_print(
		fmt.bprintf(buf[:], "node_path_get_name -> StringName: %v (expect true)", name_ok),
	)
	if name_ok do gt.string_name_free(&name_back)
	gt.variant_free(&name_v)
	gt.string_name_free(&name)

	concat_names := gt.node_path_get_concatenated_names(&np)
	concat_names_v := gt.variant_from_string_name(&concat_names)
	concat_names_back, concat_names_ok := gt.variant_try_string_name(&concat_names_v)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"node_path_get_concatenated_names -> StringName: %v (expect true)",
			concat_names_ok,
		),
	)
	if concat_names_ok do gt.string_name_free(&concat_names_back)
	gt.variant_free(&concat_names_v)
	gt.string_name_free(&concat_names)

	np_sub := gt.node_path_from_utf8("HelloNode:foo")
	subname := gt.node_path_get_subname(&np_sub, 0)
	subname_v := gt.variant_from_string_name(&subname)
	subname_back, subname_ok := gt.variant_try_string_name(&subname_v)
	gt.debug_print(
		fmt.bprintf(buf[:], "node_path_get_subname -> StringName: %v (expect true)", subname_ok),
	)
	if subname_ok do gt.string_name_free(&subname_back)
	gt.variant_free(&subname_v)
	gt.string_name_free(&subname)

	concat_subnames := gt.node_path_get_concatenated_subnames(&np_sub)
	concat_subnames_v := gt.variant_from_string_name(&concat_subnames)
	concat_subnames_back, concat_subnames_ok := gt.variant_try_string_name(&concat_subnames_v)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"node_path_get_concatenated_subnames -> StringName: %v (expect true)",
			concat_subnames_ok,
		),
	)
	if concat_subnames_ok do gt.string_name_free(&concat_subnames_back)
	gt.variant_free(&concat_subnames_v)
	gt.string_name_free(&concat_subnames)
	gt.node_path_free(&np_sub)
	if np_back_ok do gt.node_path_free(&np_back)
	gt.variant_free(&npv)
	gt.node_path_free(&np)

	// Vector2 generated builtin.
	vec := gt.vector2_new3(3.0, 4.0)
	vec_variant := gt.vector2_to_variant(vec)
	vec_back, vec_back_ok := gt.vector2_try_from_variant(&vec_variant)
	gt.debug_print(
		fmt.bprintf(
			buf[:],
			"Vector2 variant roundtrip: (%v, %v) / %v (expect 3,4 / true)",
			vec_back.x,
			vec_back.y,
			vec_back_ok,
		),
	)
	gt.variant_free(&vec_variant)
	gt.debug_print(fmt.bprintf(buf[:], "Vector2(3,4): (%v, %v) (expect 3,4)", vec.x, vec.y))
	len := gt.vector2_length(vec)
	gt.debug_print(fmt.bprintf(buf[:], "Vector2(3,4).length(): %v (expect 5)", len))
	n := gt.vector2_normalized(vec)
	gt.debug_print(fmt.bprintf(buf[:], "Vector2(3,4).normalized(): (%v, %v)", n.x, n.y))
	dot := gt.vector2_dot(vec, gt.Vector2{1, 0})
	gt.debug_print(fmt.bprintf(buf[:], "Vector2(3,4).dot(1,0): %v (expect 3)", dot))

	// Utility function smoke check.
	gt.debug_print(fmt.bprintf(buf[:], "sin(1.0): %.6f (expect ~0.841471)", gt.sin(1.0)))
	gt.debug_print(fmt.bprintf(buf[:], "cos(0.0): %.6f (expect 1.0)", gt.cos(0.0)))
	gt.debug_print(fmt.bprintf(buf[:], "randf(): %.6f", gt.randf()))
}

// GDExtension entry point.

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
	if level != .Scene {return}
	register_classes()
}

deinitialize_module :: proc "c" (user_data: rawptr, level: gt.InitializationLevel) {
	context = gt.godot_context()
	if level != .Scene {return}
	gt.unregister_class(hello_class_name)
	gt.string_free(&empty_str_data)
	gt.debug_print("[odin-gdext] HelloNode unregistered!")
}
