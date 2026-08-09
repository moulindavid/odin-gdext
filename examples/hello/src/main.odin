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
		back, back_ok := gt.variant_try_object(&v)
		gd.debug_print(
			fmt.bprintf(
				buf[:],
				"variant object roundtrip: %v / %v (expect true / true)",
				back == obj,
				back_ok,
			),
		)
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

add_method_name_data: gd.StaticStringName
add_method_name := gd.const_static_string_name_ptr(&add_method_name_data)
add_arg_info := [2]gd.PropertyInfo{{type = .Float}, {type = .Float}}
add_arg_meta := [2]gd.ClassMethodArgumentMetadata{.None, .None}
add_return_info := gd.PropertyInfo {
	type = .Float,
}
add_method_info: gd.ClassMethodInfo

add_arg_a_name_data: gd.StaticStringName
add_arg_a_name := gd.const_static_string_name_ptr(&add_arg_a_name_data)
add_arg_b_name_data: gd.StaticStringName
add_arg_b_name := gd.const_static_string_name_ptr(&add_arg_b_name_data)

empty_name_data: gd.StaticStringName
empty_name := gd.const_static_string_name_ptr(&empty_name_data)
empty_str_data: gd.String
empty_str := gd.const_string_ptr(&empty_str_data)

register_methods :: proc() {
	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&add_method_name_data),
		cstring("add"),
	)
	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&add_arg_a_name_data),
		cstring("a"),
	)
	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&add_arg_b_name_data),
		cstring("b"),
	)
	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&empty_name_data),
		cstring(""),
	)
	gd.string_new_with_latin1_chars(gd.uninitialized_string_ptr(&empty_str_data), cstring(""))

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

// ---- Static StringName storage ----

hello_name_data: gd.StaticStringName
parent_name_data: gd.StaticStringName
hello_class_name := gd.const_static_string_name_ptr(&hello_name_data)
hello_parent_name := gd.const_static_string_name_ptr(&parent_name_data)
node_class_name_data: gd.StaticStringName
node_class_name := gd.const_static_string_name_ptr(&node_class_name_data)
node2d_class_name_data: gd.StaticStringName
node2d_class_name := gd.const_static_string_name_ptr(&node2d_class_name_data)

hello_instance_binding_callbacks := gd.InstanceBindingCallbacks {
	create_callback    = nil,
	free_callback      = nil,
	reference_callback = nil,
}

register_classes :: proc() {
	context = gt.godot_context()
	gd.debug_print("[odin-gdext] Registering HelloNode...")

	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&hello_name_data),
		cstring("HelloNode"),
	)
	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&parent_name_data),
		cstring("Node"),
	)
	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&node_class_name_data),
		cstring("Node"),
	)
	gd.static_string_name_init_latin1_cstring(
		gd.uninitialized_static_string_name_ptr(&node2d_class_name_data),
		cstring("Node2D"),
	)
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

	// Test: owned Array wrapper and Array Variant extraction
	arr := gt.array_new()
	v1 := gt.variant_from_float(10.0)
	v2 := gt.variant_from_float(20.0)
	gt.array_push(&arr, &v1)
	gt.array_push(&arr, &v2)
	size := gt.array_size(&arr)
	gd.debug_print(fmt.bprintf(buf[:], "Array size: %v (expect 2)", size))
	arr_v := gt.variant_from_array(&arr)
	arr_back, arr_back_ok := gt.variant_try_array(&arr_v)
	gd.debug_print(fmt.bprintf(buf[:], "variant_try_array(arr_v): %v (expect true)", arr_back_ok))
	if arr_back_ok do gt.array_free(&arr_back)
	gt.variant_free(&arr_v)
	gt.variant_free(&v1)
	gt.variant_free(&v2)
	gt.array_free(&arr)

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

	// Test: owned String wrapper and String Variant extraction
	gs := gt.string_from_utf8("Owned Godot String")
	string_text, string_ok, string_needed := gt.string_to_utf8(&gs, utf8_buf[:])
	gd.debug_print(
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
		gd.debug_print(
			fmt.bprintf(
				buf[:],
				"variant_try_string(gsv): %v / %v / %v bytes (expect owned string / true)",
				back_text,
				back_ok,
				back_needed,
			),
		)
	}
	gt.variant_free(&gsv)
	gt.string_free(&gs)

	// Test: owned StringName wrapper and StringName Variant extraction
	sn := gt.string_name_from_utf8_cstring(cstring("HelloNode"))
	snv := gt.variant_from_string_name(&sn)
	sn_back, sn_back_ok := gt.variant_try_string_name(&snv)
	gd.debug_print(
		fmt.bprintf(buf[:], "variant_try_string_name(snv): %v (expect true)", sn_back_ok),
	)
	if sn_back_ok do gt.string_name_free(&sn_back)
	gt.variant_free(&snv)
	gt.string_name_free(&sn)

	// Test: owned NodePath wrapper and NodePath Variant extraction
	np := gt.node_path_from_utf8("../HelloNode")
	npv := gt.variant_from_node_path(&np)
	np_back, np_back_ok := gt.variant_try_node_path(&npv)
	gd.debug_print(fmt.bprintf(buf[:], "variant_try_node_path(npv): %v (expect true)", np_back_ok))
	gd.debug_print(
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
	gd.debug_print(
		fmt.bprintf(buf[:], "node_path_get_name -> StringName: %v (expect true)", name_ok),
	)
	if name_ok do gt.string_name_free(&name_back)
	gt.variant_free(&name_v)
	gt.string_name_free(&name)

	concat_names := gt.node_path_get_concatenated_names(&np)
	concat_names_v := gt.variant_from_string_name(&concat_names)
	concat_names_back, concat_names_ok := gt.variant_try_string_name(&concat_names_v)
	gd.debug_print(
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
	gd.debug_print(
		fmt.bprintf(buf[:], "node_path_get_subname -> StringName: %v (expect true)", subname_ok),
	)
	if subname_ok do gt.string_name_free(&subname_back)
	gt.variant_free(&subname_v)
	gt.string_name_free(&subname)

	concat_subnames := gt.node_path_get_concatenated_subnames(&np_sub)
	concat_subnames_v := gt.variant_from_string_name(&concat_subnames)
	concat_subnames_back, concat_subnames_ok := gt.variant_try_string_name(&concat_subnames_v)
	gd.debug_print(
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

	// Test: Vector2 built-in
	vec := gbv2.vector2_new3(3.0, 4.0)
	vec_variant := gbv2.vector2_to_variant(vec)
	vec_back, vec_back_ok := gbv2.vector2_try_from_variant(&vec_variant)
	gd.debug_print(
		fmt.bprintf(
			buf[:],
			"Vector2 variant roundtrip: (%v, %v) / %v (expect 3,4 / true)",
			vec_back.x,
			vec_back.y,
			vec_back_ok,
		),
	)
	gt.variant_free(&vec_variant)
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
