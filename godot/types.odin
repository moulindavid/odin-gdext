// godot/types.odin — Typed object handle system.
//
// Each Godot class is represented as `distinct ObjectPtr`.
// Per-class API surface is generated as free functions.
//
// Pattern for a class (codegen'd):
//   Node2D :: distinct gd.ObjectPtr
//
//   node2d_object :: proc(self: Node2D) -> gd.ObjectPtr { return gd.ObjectPtr(self) }
//   node2d_unwrap :: proc(instance: gd.ClassInstancePtr, data_type: typeid) -> Node2D { ... }
//
// Usage:
//   n: Node2D = node2d_unwrap(instance)
//   pos := node2d_get_position(n)
//   upcast := gd.ObjectPtr(n)  // cast to base ObjectPtr
package godot

import gd "godot:godot-ffi"

// Object is the base type for all Godot class handles.
Object :: gd.ObjectPtr

// RefCounted is the base type for refcounted Godot objects.
RefCounted :: distinct gd.ObjectPtr

// ---- Null check ----

is_nil :: proc "contextless" (obj: Object) -> bool {
	return gd.ObjectPtr(obj) == nil
}

// ---- Variant conversion ----

VariantBytes :: distinct [24]u8

// object_to_variant wraps an ObjectPtr into a Variant.
object_to_variant :: proc "contextless" (obj: gd.ObjectPtr) -> VariantBytes {
	v: VariantBytes
	ctor := gd.get_variant_from_type_constructor(.Object)
	_obj := obj
	ctor(cast(gd.UninitializedVariantPtr)&v, cast(gd.TypePtr)&_obj)
	return v
}

// object_from_variant extracts an ObjectPtr from a Variant.
object_from_variant :: proc "contextless" (v: VariantBytes) -> gd.ObjectPtr {
	_v := v
	ctor := gd.get_variant_to_type_constructor(.Object)
	result: gd.ObjectPtr
	ctor(cast(gd.TypePtr)&result, cast(gd.VariantPtr)&_v)
	return result
}

// ---- Class identity (is_class-based casting, replaces deprecated object_cast_to) ----

is_class_method_name_data: [8]u8
is_class_method_name := gd.StringNamePtr(&is_class_method_name_data[0])
object_class_name_data: [8]u8
object_class_name := gd.StringNamePtr(&object_class_name_data[0])
is_class_method_bind: gd.MethodBindPtr

// Call once, during module init, before any cast is attempted.
init_class_casting :: proc() {
	gd.string_name_new_with_latin1_chars(
		cast(gd.UninitializedStringNamePtr)&is_class_method_name_data[0],
		cstring("is_class"),
		true,
	)
	gd.string_name_new_with_latin1_chars(
		cast(gd.UninitializedStringNamePtr)&object_class_name_data[0],
		cstring("Object"),
		true,
	)
	/* from 4.7 extension_api.json
    "name": "is_class",
	"hash": 2619796661,
	"return_value": {"type": "bool"},
	"arguments": [{"name": "class", "type": "StringName"}]
	*/
	is_class_method_bind = gd.classdb_get_method_bind(
		object_class_name,
		is_class_method_name,
		2619796661,
	)
}

// is_class checks whether obj is an instance of (or derives from) class_name.
is_class :: proc "contextless" (obj: gd.ObjectPtr, class_name: gd.StringNamePtr) -> bool {
	result: bool
	args := [1]rawptr{class_name}
	gd.object_method_bind_ptrcall(is_class_method_bind, obj, &args[0], &result)
	return result
}

// cast_to checks class identity, then reinterprets the pointer — valid per
// Godot's own docs, since GDExtension object pointers need no adjustment
// across the Object hierarchy (single inheritance).
cast_to :: proc "contextless" (
	obj: gd.ObjectPtr,
	target_class_name: gd.StringNamePtr,
	$Target: typeid,
) -> (
	result: Target,
	ok: bool,
) {
	if obj == nil || !is_class(obj, target_class_name) {
		return Target{}, false
	}
	return Target(obj), true
}
