// godot/godot.odin — Thin re-export facade.
//
// Re-exports the public API from godot-core and godot-bindings so users
// can import a single package:
//
//   import gt "godot:godot"
//   import gd "godot:godot-ffi"
//
// Direct imports for deeper access:
//   import gcore "godot:core"
//   import gbind "godot:bindings"
package godot

import gcore "godot:core"
import gbind "godot:bindings"

// --- Core types ---
Object                 :: gcore.Object
RefCounted             :: gcore.RefCounted
VariantBytes           :: gcore.VariantBytes
StringRepr             :: gcore.StringRepr

// --- Core functions ---
is_nil                 :: gcore.is_nil
is_class               :: gcore.is_class
cast_to                :: gcore.cast_to
init_class_casting     :: gcore.init_class_casting
object_to_variant      :: gcore.object_to_variant
object_from_variant    :: gcore.object_from_variant
godot_context          :: gcore.godot_context

// --- Variant ---
variant_from_float     :: gcore.variant_from_float
variant_from_int       :: gcore.variant_from_int
variant_from_bool      :: gcore.variant_from_bool
variant_from_cstring   :: gcore.variant_from_cstring
variant_to_float       :: gcore.variant_to_float
variant_to_int         :: gcore.variant_to_int
variant_to_bool        :: gcore.variant_to_bool
variant_free           :: gcore.variant_free
array_new              :: gcore.array_new
array_push             :: gcore.array_push
array_size             :: gcore.array_size
print                  :: gcore.print
print_init             :: gcore.print_init

// --- Utility functions ---
sin                    :: gbind.sin
cos                    :: gbind.cos
tan                    :: gbind.tan
randf                  :: gbind.randf
var_to_str             :: gbind.var_to_str
instance_from_id       :: gbind.instance_from_id
