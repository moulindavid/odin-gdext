// godot-core/object.odin -- Typed object handle system.
//
// Each Godot class is represented as `distinct ObjectPtr`.
// Per-class API surface is generated as free functions.
//
// Pattern for a class (codegen'd):
//   Node2D :: distinct ObjectPtr
//
//   node2d_object :: proc(self: Node2D) -> ObjectPtr { return ObjectPtr(self) }
//   node2d_unwrap :: proc(instance: ClassInstancePtr, data_type: typeid) -> Node2D { ... }
//
// Usage:
//   n: Node2D = node2d_unwrap(instance)
//   pos := node2d_get_position(n)
//   upcast := ObjectPtr(n)  // cast to base ObjectPtr
package godot_core


// Object is the base type for all Godot class handles.
Object :: ObjectPtr

// RefCounted is the base type for refcounted Godot objects.
RefCounted :: distinct ObjectPtr

// StringRepr is the 8-byte raw Godot String handle returned by utility
// functions. Convert to an Odin string via variant layer helpers.
StringRepr :: distinct [8]u8

// ---- Null check ----

is_nil :: proc "contextless" (obj: Object) -> bool {
	return ObjectPtr(obj) == nil
}

// ---- Variant conversion ----

// object_to_variant wraps an ObjectPtr into an initialized Variant. The caller
// owns the returned Variant and must destroy it with variant_free.
object_to_variant :: proc "contextless" (obj: ObjectPtr) -> Variant {
	v: Variant
	ctor := require_variant_from_type_constructor(.Object)
	_obj := obj
	ctor(cast(UninitializedVariantPtr)&v, cast(TypePtr)&_obj)
	return v
}

// object_from_variant extracts an ObjectPtr from a Variant without taking
// ownership of it.
object_from_variant :: proc "contextless" (v: ^Variant) -> ObjectPtr {
	ctor := require_variant_to_type_constructor(.Object)
	result: ObjectPtr
	ctor(cast(TypePtr)&result, cast(VariantPtr)v)
	return result
}

// ---- Class identity (is_class-based casting) ----

is_class_method_name_data: [8]u8
is_class_method_name := StringNamePtr(&is_class_method_name_data[0])
object_class_name_data: [8]u8
object_class_name := StringNamePtr(&object_class_name_data[0])
is_class_method_bind: MethodBindPtr

// Call once, during module init, before any cast is attempted.
init_class_casting :: proc() {
	string_name_new_with_latin1_chars(
		cast(UninitializedStringNamePtr)&is_class_method_name_data[0],
		cstring("is_class"),
		true,
	)
	string_name_new_with_latin1_chars(
		cast(UninitializedStringNamePtr)&object_class_name_data[0],
		cstring("Object"),
		true,
	)
	is_class_method_bind = require_classdb_method_bind(
		object_class_name,
		is_class_method_name,
		2619796661,
	)
}

// is_class checks whether obj is an instance of (or derives from) class_name.
is_class :: proc "contextless" (obj: ObjectPtr, class_name: StringNamePtr) -> bool {
	if is_class_method_bind == nil do _trap_nil_godot_function()
	if object_method_bind_ptrcall == nil do _trap_nil_godot_function()
	result: bool
	args := [1]rawptr{class_name}
	object_method_bind_ptrcall(is_class_method_bind, obj, &args[0], &result)
	return result
}

// cast_to checks class identity, then reinterprets the ObjectPtr. GDExtension
// uses single inheritance so the pointer value is the same across the hierarchy.
cast_to :: proc "contextless" (
	obj: ObjectPtr,
	target_class_name: StringNamePtr,
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
