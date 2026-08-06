// godot-bindings/utilities.odin — Godot built-in utility function bindings.
//
// Each @GlobalScope function (sin, cos, var_to_str, etc.) is exposed as a
// typed Odin proc. The underlying pointer resolves lazily on first call via
// variant_get_ptr_utility_function.
//
// https://docs.godotengine.org/en/stable/classes/class_@globalscope.html

package godot_bindings

import gcore "godot:core"

// ---------------------------------------------------------------------------
// Internal: lazy utility function resolution
// ---------------------------------------------------------------------------

@(private="file")
_UtilFunc :: struct {
	name_data: [8]u8,
	func:      gcore.PtrUtilityFunction,
	init:      bool,
}

@(private="file")
_ensure_utility :: proc "contextless" (uf: ^_UtilFunc, name: cstring, hash: i64) {
	if uf.init do return
	uf.init = true
	gcore.string_name_new_with_latin1_chars(
		cast(gcore.UninitializedStringNamePtr)&uf.name_data,
		name,
		true,
	)
	uf.func = gcore.variant_get_ptr_utility_function(cast(gcore.ConstStringNamePtr)&uf.name_data, hash)
}

// ---------------------------------------------------------------------------
// Math (float → float)
// ---------------------------------------------------------------------------

@(private="file")
_sin: _UtilFunc
@(private="file")
_cos: _UtilFunc
@(private="file")
_tan: _UtilFunc

sin :: proc "contextless" (angle_rad: f64) -> f64 {
	_ensure_utility(&_sin, cstring("sin"), 2140049587)
	a := angle_rad
	return gcore.call_utility_function_ptr_ret(_sin.func, f64, &a)
}

cos :: proc "contextless" (angle_rad: f64) -> f64 {
	_ensure_utility(&_cos, cstring("cos"), 2140049587)
	a := angle_rad
	return gcore.call_utility_function_ptr_ret(_cos.func, f64, &a)
}

tan :: proc "contextless" (angle_rad: f64) -> f64 {
	_ensure_utility(&_tan, cstring("tan"), 2140049587)
	a := angle_rad
	return gcore.call_utility_function_ptr_ret(_tan.func, f64, &a)
}

// ---------------------------------------------------------------------------
// Random
// ---------------------------------------------------------------------------

@(private="file")
_randf: _UtilFunc

randf :: proc "contextless" () -> f64 {
	_ensure_utility(&_randf, cstring("randf"), 2086227845)
	return gcore.call_utility_function_ptr_ret(_randf.func, f64)
}

// ---------------------------------------------------------------------------
// General: var_to_str (Variant → String)
// ---------------------------------------------------------------------------

@(private="file")
_var_to_str: _UtilFunc

// var_to_str converts a Variant to its string representation.
var_to_str :: proc "contextless" (variable: gcore.VariantBytes) -> gcore.StringRepr {
	_ensure_utility(&_var_to_str, cstring("var_to_str"), 866625479)
	v := variable
	arg: rawptr = &v
	return gcore.call_utility_function_ptr_ret(_var_to_str.func, gcore.StringRepr, arg)
}

// ---------------------------------------------------------------------------
// General: instance_from_id (int → Object)
// ---------------------------------------------------------------------------

@(private="file")
_instance_from_id: _UtilFunc

// instance_from_id retrieves an Object by its instance ID.
// Returns nil if the ID is invalid or the object has been freed.
instance_from_id :: proc "contextless" (instance_id: i64) -> gcore.ObjectPtr {
	_ensure_utility(&_instance_from_id, cstring("instance_from_id"), 1156694636)
	id := instance_id
	return gcore.call_utility_function_ptr_ret(_instance_from_id.func, gcore.ObjectPtr, &id)
}
