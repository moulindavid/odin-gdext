// godot/godot.odin -- Small convenience facade.
//
// This package intentionally re-exports only a tiny handwritten subset today.
// Import `godot:bindings` and `godot:bindings/builtin` directly for generated
// utility and builtin APIs.
package godot

import gbind "godot:bindings"
import gcore "godot:core"

// --- Core types ---
Object :: gcore.Object
RefCounted :: gcore.RefCounted
VariantStorage :: gcore.VariantStorage
Variant :: gcore.Variant
StringRepr :: gcore.StringRepr

// --- Core functions ---
is_nil :: gcore.is_nil
is_class :: gcore.is_class
cast_to :: gcore.cast_to
init_class_casting :: gcore.init_class_casting
object_to_variant :: gcore.object_to_variant
object_from_variant :: gcore.object_from_variant
godot_context :: gcore.godot_context

// --- Variant ---
variant_type :: gcore.variant_type
variant_is_type :: gcore.variant_is_type
variant_is_nil :: gcore.variant_is_nil
variant_ptr :: gcore.variant_ptr
const_variant_ptr :: gcore.const_variant_ptr
uninitialized_variant_ptr :: gcore.uninitialized_variant_ptr
variant_init_nil :: gcore.variant_init_nil
variant_nil :: gcore.variant_nil
variant_init_copy :: gcore.variant_init_copy
variant_copy :: gcore.variant_copy
variant_from_float :: gcore.variant_from_float
variant_from_int :: gcore.variant_from_int
variant_from_bool :: gcore.variant_from_bool
variant_from_cstring :: gcore.variant_from_cstring
variant_to_float :: gcore.variant_to_float
variant_to_int :: gcore.variant_to_int
variant_to_bool :: gcore.variant_to_bool
variant_to_string_storage :: gcore.variant_to_string_storage
variant_string_utf8_len :: gcore.variant_string_utf8_len
variant_try_utf8 :: gcore.variant_try_utf8
variant_try_float :: gcore.variant_try_float
variant_try_int :: gcore.variant_try_int
variant_try_bool :: gcore.variant_try_bool
variant_free :: gcore.variant_free
variant_free_temp :: gcore.variant_free_temp
call_error_ok :: gcore.call_error_ok
require_call_ok :: gcore.require_call_ok
variant_construct_checked :: gcore.variant_construct_checked
variant_call_checked :: gcore.variant_call_checked
array_new :: gcore.array_new
array_push :: gcore.array_push
array_size :: gcore.array_size
print :: gcore.print
print_init :: gcore.print_init

// --- Utility functions ---
sin :: gbind.sin
cos :: gbind.cos
tan :: gbind.tan
randf :: gbind.randf
