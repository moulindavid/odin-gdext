package hello

import "core:fmt"
import gbv2 "godot:bindings/builtin"
import gd "godot:core"
import gt "godot:godot"

// ---- Typed handle ----

HelloNode :: distinct gd.ObjectPtr

// HelloNode typed API -- per-class free functions.
// This pattern mirrors what codegen will produce for Node, Node2D, etc.
hello_node_object :: proc(self: HelloNode) -> gd.ObjectPtr {
	return gd.ObjectPtr(self)
}
hello_node_unwrap :: proc(instance: gd.ClassInstancePtr) -> HelloNode {
	return HelloNode((^HelloData)(instance).object)
}

// ---- Per-instance data ----

HelloData :: struct {
	object: gd.ObjectPtr,
}

// ---- Class lifecycle callbacks ----

NOTIFICATION_READY :: 13

create_instance :: proc "c" (class_userdata: rawptr, notify_postinitialize: bool) -> gd.ObjectPtr {
	context = gt.godot_context()
	object := gd.construct_object(hello_parent_name)
	if object == nil {return nil}
	self_ := new_clone(HelloData{object = object})
	gd.set_instance(object, hello_class_name, self_)
	gd.set_instance_binding(object, self_, &hello_instance_binding_callbacks)
	return object
}

free_instance :: proc "c" (class_userdata: rawptr, instance: gd.ClassInstancePtr) {
	context = gt.godot_context()
	if instance == nil {return}
	free(cast(^HelloData)instance)
}

notification_func :: proc "c" (instance: gd.ClassInstancePtr, what: i32, reversed: bool) {
	if instance == nil {return}
	context = gt.godot_context()
	if what == NOTIFICATION_READY {
		hn := hello_node_unwrap(instance)
		gd.debug_print("Hello from Odin!")

		obj := hello_node_object(hn)
		buf: [128]u8
		gd.debug_print(fmt.bprintf(buf[:], "is_nil: %v (expect false)", gt.is_nil(gt.Object(obj))))
		gd.debug_print(
			fmt.bprintf(
				buf[:],
				"is_class Node: %v (expect true)",
				gt.is_class(obj, node_class_name),
			),
		)
		gd.debug_print(
			fmt.bprintf(
				buf[:],
				"is_class Node2D: %v (expect false)",
				gt.is_class(obj, node2d_class_name),
			),
		)

		v := gt.object_to_variant(obj)
		back := gt.object_from_variant(&v)
		gd.debug_print(fmt.bprintf(buf[:], "variant roundtrip: %v (expect true)", back == obj))
		gt.variant_free(&v)

		// Utility functions
		gd.debug_print(fmt.bprintf(buf[:], "sin(1.0): %.6f (expect ~0.841471)", gt.sin(1.0)))
		gd.debug_print(fmt.bprintf(buf[:], "cos(0.0): %.6f (expect 1.0)", gt.cos(0.0)))
		gd.debug_print(fmt.bprintf(buf[:], "randf(): %.6f", gt.randf()))
	}
}

// ---- Method: add(a, b) -> a + b ----

add_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: gd.ClassInstancePtr,
	p_args: [^]gd.ConstVariantPtr,
	p_argument_count: i64,
	r_return: gd.VariantPtr,
	r_error: ^gd.CallError,
) {
	context = gt.godot_context()
	a := gt.variant_to_float(cast(^gt.Variant)p_args[0])
	b := gt.variant_to_float(cast(^gt.Variant)p_args[1])
	buf: [160]u8
	gd.debug_print(fmt.bprintf(buf[:], "add_call a=%v b=%v", a, b))
	rv := gt.variant_from_float(a + b)
	gt.variant_init_copy(r_return, &rv)
	gt.variant_free(&rv)
}

add_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: rawptr,
	p_args: [^]rawptr,
	r_ret: rawptr,
) {
	context = gt.godot_context()
	a := (cast(^f64)p_args[0])^
	b := (cast(^f64)p_args[1])^
	buf: [160]u8
	gd.debug_print(fmt.bprintf(buf[:], "add_ptrcall a=%v b=%v", a, b))
	(cast(^f64)r_ret)^ = a + b
}

add_method_name_data: [8]u8
add_method_name := gd.StringNamePtr(&add_method_name_data[0])
add_arg_info := [2]gd.PropertyInfo{{type = .Float}, {type = .Float}}
add_arg_meta := [2]gd.ClassMethodArgumentMetadata{.None, .None}
add_return_info := gd.PropertyInfo {
	type = .Float,
}
add_method_info: gd.ClassMethodInfo

add_arg_a_name_data: [8]u8
add_arg_a_name := gd.StringNamePtr(&add_arg_a_name_data[0])
add_arg_b_name_data: [8]u8
add_arg_b_name := gd.StringNamePtr(&add_arg_b_name_data[0])

empty_name_data: [8]u8
empty_name := gd.StringNamePtr(&empty_name_data[0])
empty_str_data: [8]u8
empty_str := gd.StringPtr(&empty_str_data[0])

register_methods :: proc() {
	gd.string_name_new_with_latin1_chars(
		cast(gd.UninitializedStringNamePtr)&add_method_name_data[0],
		cstring("add"),
		true,
	)
	gd.string_name_new_with_latin1_chars(
		cast(gd.UninitializedStringNamePtr)&add_arg_a_name_data[0],
		cstring("a"),
		true,
	)
	gd.string_name_new_with_latin1_chars(
		cast(gd.UninitializedStringNamePtr)&add_arg_b_name_data[0],
		cstring("b"),
		true,
	)
	gd.string_name_new_with_latin1_chars(
		cast(gd.UninitializedStringNamePtr)&empty_name_data[0],
		cstring(""),
		true,
	)
	gd.string_new_with_latin1_chars(cast(gd.UninitializedStringPtr)&empty_str_data[0], cstring(""))

	add_arg_info[0].name = add_arg_a_name
	add_arg_info[0].class_name = empty_name
	add_arg_info[0].hint_string = empty_str
	add_arg_info[1].name = add_arg_b_name
	add_arg_info[1].class_name = empty_name
	add_arg_info[1].hint_string = empty_str
	add_return_info.class_name = empty_name
	add_return_info.hint_string = empty_str
	info := &add_method_info
	info.name = add_method_name
	info.has_return_value = true
	info.return_value_info = &add_return_info
	info.return_value_metadata = .None
	info.argument_count = 2
	info.arguments_info = &add_arg_info[0]
	info.arguments_metadata = &add_arg_meta[0]
	add_return_info.name = add_method_name

	info.call_func = add_call
	info.ptrcall_func = add_ptrcall

	gd.classdb_register_extension_class_method(gd.library, hello_class_name, info)
	gd.debug_print("[odin-gdext] Method add registered!")
}

// ---- Storage for StringNames (8 bytes each) ----

// StringNamePtr is const StringName* in C. We store the actual data in byte
// arrays and pass pointers to those arrays.
hello_name_data: [8]u8
parent_name_data: [8]u8
hello_class_name := gd.StringNamePtr(&hello_name_data[0])
hello_parent_name := gd.StringNamePtr(&parent_name_data[0])
node_class_name_data: [8]u8
node_class_name := gd.StringNamePtr(&node_class_name_data[0])
node2d_class_name_data: [8]u8
node2d_class_name := gd.StringNamePtr(&node2d_class_name_data[0])

hello_instance_binding_callbacks := gd.InstanceBindingCallbacks {
	create_callback    = nil,
	free_callback      = nil,
	reference_callback = nil,
}

register_classes :: proc() {
	context = gt.godot_context()
	gd.debug_print("[odin-gdext] Registering HelloNode...")

	gd.string_name_new_with_latin1_chars(hello_class_name, cstring("HelloNode"), true)
	gd.string_name_new_with_latin1_chars(hello_parent_name, cstring("Node"), true)
	gd.string_name_new_with_latin1_chars(node_class_name, cstring("Node"), true)
	gd.string_name_new_with_latin1_chars(node2d_class_name, cstring("Node2D"), true)
	gt.init_class_casting()

	class_info := gd.ClassCreationInfo {
		is_virtual                  = false,
		is_abstract                 = false,
		is_exposed                  = true,
		is_runtime                  = false,
		icon_path                   = nil,
		set_func                    = nil,
		get_func                    = nil,
		get_property_list_func      = nil,
		free_property_list_func     = nil,
		property_can_revert_func    = nil,
		property_get_revert_func    = nil,
		validate_property_func      = nil,
		notification_func           = notification_func,
		to_string_func              = nil,
		reference_func              = nil,
		unreference_func            = nil,
		create_instance_func        = create_instance,
		free_instance_func          = free_instance,
		recreate_instance_func      = nil,
		get_virtual_func            = nil,
		get_virtual_call_data_func  = nil,
		call_virtual_with_data_func = nil,
		class_userdata              = nil,
	}

	gd.classdb_register_extension_class6(
		gd.library,
		hello_class_name,
		hello_parent_name,
		&class_info,
	)
	gd.debug_print("[odin-gdext] HelloNode registered!")

	buf: [160]u8

	register_methods()

	// Test: variant round-trip (float, int, bool)
	vf := gt.variant_from_float(3.14)
	vi := gt.variant_from_int(-42)
	vb := gt.variant_from_bool(true)
	gd.debug_print(fmt.bprintf(buf[:], "Float: %v (expect 3.14)", gt.variant_to_float(&vf)))
	gd.debug_print(fmt.bprintf(buf[:], "Int:   %v (expect -42)", gt.variant_to_int(&vi)))
	gd.debug_print(fmt.bprintf(buf[:], "Bool:  %v (expect true)", gt.variant_to_bool(&vb)))
	gd.debug_print(fmt.bprintf(buf[:], "Float type: %v (expect Float)", gt.variant_type(&vf)))
	vf_try, vf_ok := gt.variant_try_float(&vf)
	vi_as_float, vi_as_float_ok := gt.variant_try_float(&vi)
	gd.debug_print(
		fmt.bprintf(buf[:], "try_float(vf): %v / %v (expect 3.14 / true)", vf_try, vf_ok),
	)
	gd.debug_print(
		fmt.bprintf(
			buf[:],
			"try_float(vi): %v / %v (expect 0 / false)",
			vi_as_float,
			vi_as_float_ok,
		),
	)
	nil_variant := gt.variant_nil()
	gd.debug_print(
		fmt.bprintf(buf[:], "Nil Variant: %v (expect true)", gt.variant_is_nil(&nil_variant)),
	)
	gt.variant_free(&nil_variant)
	gt.variant_free(&vf)
	gt.variant_free(&vi)
	gt.variant_free(&vb)

	// Test: Array variant
	arr := gt.array_new()
	v1 := gt.variant_from_float(10.0)
	v2 := gt.variant_from_float(20.0)
	gt.array_push(&arr, &v1)
	gt.array_push(&arr, &v2)
	size := gt.array_size(&arr)
	gd.debug_print(fmt.bprintf(buf[:], "Array size: %v (expect 2)", size))
	gt.variant_free(&v1)
	gt.variant_free(&v2)
	gt.variant_free(&arr)

	// Test: print utility function
	gt.print_init()
	vs := gt.variant_from_cstring(cstring("Hello from Odin via Variant!"))
	gt.print(gt.variant_ptr(&vs))
	utf8_buf: [128]u8
	utf8_text, utf8_ok, utf8_needed := gt.variant_try_utf8(&vs, utf8_buf[:])
	gd.debug_print(
		fmt.bprintf(
			buf[:],
			"try_utf8(vs): %v / %v / %v bytes (expect message / true)",
			utf8_text,
			utf8_ok,
			utf8_needed,
		),
	)
	gt.variant_free(&vs)

	// Test: Vector2 built-in
	vec := gbv2.vector2_new3(3.0, 4.0)
	gd.debug_print(fmt.bprintf(buf[:], "Vector2(3,4): (%v, %v) (expect 3,4)", vec.x, vec.y))
	len := gbv2.vector2_length(vec)
	gd.debug_print(fmt.bprintf(buf[:], "Vector2(3,4).length(): %v (expect 5)", len))
	n := gbv2.vector2_normalized(vec)
	gd.debug_print(fmt.bprintf(buf[:], "Vector2(3,4).normalized(): (%v, %v)", n.x, n.y))
	dot := gbv2.vector2_dot(vec, gbv2.Vector2{1, 0})
	gd.debug_print(fmt.bprintf(buf[:], "Vector2(3,4).dot(1,0): %v (expect 3)", dot))

	// Utility function smoke test
	gd.debug_print(fmt.bprintf(buf[:], "sin(1.0): %.6f (expect ~0.841471)", gt.sin(1.0)))
	gd.debug_print(fmt.bprintf(buf[:], "cos(0.0): %.6f (expect 1.0)", gt.cos(0.0)))
	gd.debug_print(fmt.bprintf(buf[:], "randf(): %.6f", gt.randf()))
}

// ---- Entry point ----

@(export)
hello_library_init :: proc "c" (
	get_proc_address: gd.GDExtensionInterfaceGetProcAddress,
	library: gd.GDExtensionClassLibraryPtr,
	initialization: ^gd.GDExtensionInitialization,
) -> bool {
	gd.init(library, get_proc_address)

	initialization.initialize = initialize_module
	initialization.deinitialize = deinitialize_module
	initialization.minimum_initialization_level = .Scene
	initialization.userdata = nil
	return true
}

initialize_module :: proc "c" (user_data: rawptr, level: gd.InitializationLevel) {
	context = gt.godot_context()
	if level != .Scene {return}
	register_classes()
}

deinitialize_module :: proc "c" (user_data: rawptr, level: gd.InitializationLevel) {
	context = gt.godot_context()
	if level != .Scene {return}
	gd.unregister_class(hello_class_name)
}
