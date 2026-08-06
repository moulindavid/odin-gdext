package hello

import "core:fmt"
import gd "godot:godot-ffi"
import gt "godot:godot"

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

	// Test: variant round-trip (float, int, bool)
	buf: [64]u8
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
