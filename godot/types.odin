// godot/types.odin — Typed object handle system.
//
// Each Godot class is represented as `distinct ObjectPtr`.
// Per-class API surface is generated as free functions.
//
// Pattern for a class (that will be codegen-ed):
//   Node2D :: distinct gd.ObjectPtr
//
//   node2d_object :: proc(self: Node2D) -> gd.ObjectPtr { return gd.ObjectPtr(self) }
//   node2d_unwrap :: proc(instance: gd.ClassInstancePtr, data_type: typeid) -> Node2D { ... }
//
//   // Free functions:
//   node2d_set_position :: proc(self: Node2D, pos: Vector2) { ... }
//   node2d_get_position :: proc(self: Node2D) -> Vector2 { ... }
//
// Usage:
//   n: Node2D = node2d_unwrap(instance)
//   pos := node2d_get_position(n)
//   upcast := gd.ObjectPtr(n)  // cast to base ObjectPtr
package godot

import gd "godot:godot-ffi"

// Object is the base type for all Godot class handles.
// All class types (Node, Node2D, etc.) are distinct aliases of ObjectPtr.
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
// Returns nil if the variant does not hold an Object.
object_from_variant :: proc "contextless" (v: VariantBytes) -> gd.ObjectPtr {
	_v := v
	ctor := gd.get_variant_to_type_constructor(.Object)
	result: gd.ObjectPtr
	ctor(cast(gd.TypePtr)&result, cast(gd.VariantPtr)&_v)
	return result
}

// ---- Casting ----

// object_cast_to attempts a dynamic cast via Godot's classdb.
// Returns (result, true) if the object is an instance of the target class.
object_cast_to :: proc "contextless" (
	obj: gd.ObjectPtr,
	target_class_tag: rawptr,
) -> (
	result: gd.ObjectPtr,
	ok: bool,
) {
	result = gd.object_cast_to(obj, target_class_tag)
	ok = result != nil
	return
}

// cast_to performs a dynamic cast into a typed distinct handle.
// Each class tag is generated per class, so for Node2D the call is:
//   if node2d, ok := cast_to(obj, Node2D_tag, Node2D); ok { ... }
cast_to :: proc "contextless" (
	obj: gd.ObjectPtr,
	target_class_tag: rawptr,
	$Target: typeid,
) -> (
	result: Target,
	ok: bool,
) {
	_raw := gd.object_cast_to(obj, target_class_tag)
	if _raw != nil {
		return Target(_raw), true
	}
	return Target{}, false
}
