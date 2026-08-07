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
variant_from_float :: gcore.variant_from_float
variant_from_int :: gcore.variant_from_int
variant_from_bool :: gcore.variant_from_bool
variant_from_cstring :: gcore.variant_from_cstring
variant_to_float :: gcore.variant_to_float
variant_to_int :: gcore.variant_to_int
variant_to_bool :: gcore.variant_to_bool
variant_free :: gcore.variant_free
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
