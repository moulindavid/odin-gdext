package hello

import "core:fmt"
import gt "godot:godot"
import gd "godot:godot-ffi"

// ---- Per-instance data ----

HelloData :: struct {
	object: gd.ObjectPtr,
}

// ---- Class lifecycle callbacks ----

create_instance :: proc "c" (class_userdata: rawptr, notify_postinitialize: bool) -> gd.ObjectPtr {
	context = gd.godot_context()
	object := gd.construct_object(hello_parent_name)
	if object == nil {return nil}
	self_ := new_clone(HelloData{object = object})
	gd.set_instance(object, hello_class_name, self_)
	gd.set_instance_binding(object, self_, &hello_instance_binding_callbacks)
	return object
}

free_instance :: proc "c" (class_userdata: rawptr, instance: gd.ClassInstancePtr) {
	context = gd.godot_context()
	if instance == nil {return}
	free(cast(^HelloData)instance)
}

notification_func :: proc "c" (instance: gd.ClassInstancePtr, what: i32, reversed: bool) {
	if instance == nil {return}
	context = gd.godot_context()
	if what == 13 {
		gd.debug_print("Hello from Odin!")
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
	context = gd.godot_context()
	a := gt.variant_to_float(cast(^[24]u8)p_args[0])
	b := gt.variant_to_float(cast(^[24]u8)p_args[1])
	buf: [64]u8
	gd.debug_print(fmt.bprintf(buf[:], "add_call a=%v b=%v", a, b))
	rv := gt.variant_from_float(a + b)
	gd.variant_new_copy(r_return, cast(gd.ConstVariantPtr)&rv[0])
	gt.variant_free(&rv)
}

add_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: rawptr,
	p_args: [^]rawptr,
	r_ret: rawptr,
) {
	context = gd.godot_context()
	a := (cast(^f64)p_args[0])^
	b := (cast(^f64)p_args[1])^
	buf: [64]u8
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
	info := new(gd.ClassMethodInfo)
	info.name = add_method_name
	info.has_return_value = true
	info.return_value_info = &add_return_info
	info.return_value_metadata = .None
	info.argument_count = 2
	info.arguments_info = &add_arg_info[0]
	info.arguments_metadata = &add_arg_meta[0]
	add_return_info.name = add_method_name

	fn_call: gd.GDExtensionClassMethodCall = add_call
	fn_ptr: gd.GDExtensionClassMethodPtrCall = add_ptrcall
	(cast(^rawptr)(cast(uintptr)info + 16))^ = cast(rawptr)fn_call
	(cast(^rawptr)(cast(uintptr)info + 24))^ = cast(rawptr)fn_ptr

	gd.classdb_register_extension_class_method(gd.library, hello_class_name, info)
	gd.debug_print("[odin-gdext] Method add registered!")
	free(info)
}

// ---- Storage for StringNames (8 bytes each) ----

// StringNamePtr is const StringName* in C. We store the actual data in byte
// arrays and pass pointers to those arrays.
hello_name_data: [8]u8
parent_name_data: [8]u8
hello_class_name := gd.StringNamePtr(&hello_name_data[0])
hello_parent_name := gd.StringNamePtr(&parent_name_data[0])

hello_instance_binding_callbacks := gd.InstanceBindingCallbacks {
	create_callback    = nil,
	free_callback      = nil,
	reference_callback = nil,
}

register_classes :: proc() {
	context = gd.godot_context()
	gd.debug_print("[odin-gdext] Registering HelloNode...")

	gd.string_name_new_with_latin1_chars(hello_class_name, cstring("HelloNode"), true)
	gd.string_name_new_with_latin1_chars(hello_parent_name, cstring("Node"), true)

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

	gd.debug_print("[odin-gdext] Checking sizes...")
	buf: [64]u8
	gd.debug_print(fmt.bprintf(buf[:], "  MethodInfo: %v", size_of(gd.ClassMethodInfo)))
	gd.debug_print(fmt.bprintf(buf[:], "  PropertyInfo: %v", size_of(gd.PropertyInfo)))
	gd.debug_print(
		fmt.bprintf(buf[:], "  call_func offset: %v", offset_of(gd.ClassMethodInfo, call_func)),
	)
	gd.debug_print(
		fmt.bprintf(
			buf[:],
			"  ptrcall_func offset: %v",
			offset_of(gd.ClassMethodInfo, ptrcall_func),
		),
	)
	gd.debug_print(
		fmt.bprintf(
			buf[:],
			"  GDExtensionClassMethodCall size: %v",
			size_of(gd.GDExtensionClassMethodCall),
		),
	)
	gd.debug_print(
		fmt.bprintf(
			buf[:],
			"  GDExtensionClassMethodPtrCall size: %v",
			size_of(gd.GDExtensionClassMethodPtrCall),
		),
	)
	gd.debug_print("[odin-gdext] Sizes printed.")

	register_methods()

	// Test: variant round-trip (float, int, bool)
	vf := gt.variant_from_float(3.14)
	vi := gt.variant_from_int(-42)
	vb := gt.variant_from_bool(true)
	gd.debug_print(fmt.bprintf(buf[:], "Float: %v (expect 3.14)", gt.variant_to_float(&vf)))
	gd.debug_print(fmt.bprintf(buf[:], "Int:   %v (expect -42)", gt.variant_to_int(&vi)))
	gd.debug_print(fmt.bprintf(buf[:], "Bool:  %v (expect true)", gt.variant_to_bool(&vb)))
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
	gt.print(cast(gd.TypePtr)&vs[0])
	gt.variant_free(&vs)
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
	context = gd.godot_context()
	if level != .Scene {return}
	register_classes()
}

deinitialize_module :: proc "c" (user_data: rawptr, level: gd.InitializationLevel) {
	context = gd.godot_context()
}
