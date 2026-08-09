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
StringStorage :: gcore.StringStorage
String :: gcore.String
StringNameStorage :: gcore.StringNameStorage
StringName :: gcore.StringName
StaticStringName :: gcore.StaticStringName
NodePathStorage :: gcore.NodePathStorage
NodePath :: gcore.NodePath
ArrayStorage :: gcore.ArrayStorage
Array :: gcore.Array
DictionaryStorage :: gcore.DictionaryStorage
Dictionary :: gcore.Dictionary
PackedByteArrayStorage :: gcore.PackedByteArrayStorage
PackedByteArray :: gcore.PackedByteArray
PackedInt32ArrayStorage :: gcore.PackedInt32ArrayStorage
PackedInt32Array :: gcore.PackedInt32Array
PackedInt64ArrayStorage :: gcore.PackedInt64ArrayStorage
PackedInt64Array :: gcore.PackedInt64Array
PackedFloat32ArrayStorage :: gcore.PackedFloat32ArrayStorage
PackedFloat32Array :: gcore.PackedFloat32Array
PackedFloat64ArrayStorage :: gcore.PackedFloat64ArrayStorage
PackedFloat64Array :: gcore.PackedFloat64Array
PackedVector2ArrayStorage :: gcore.PackedVector2ArrayStorage
PackedVector2Array :: gcore.PackedVector2Array
PackedVector3ArrayStorage :: gcore.PackedVector3ArrayStorage
PackedVector3Array :: gcore.PackedVector3Array
PackedVector4ArrayStorage :: gcore.PackedVector4ArrayStorage
PackedVector4Array :: gcore.PackedVector4Array
PackedColorArrayStorage :: gcore.PackedColorArrayStorage
PackedColorArray :: gcore.PackedColorArray
StringRepr :: gcore.StringRepr
GodotReal :: gcore.GodotReal
Vector2 :: gcore.Vector2
Vector3 :: gcore.Vector3
Vector4 :: gcore.Vector4
Color :: gcore.Color

// --- Core functions ---
is_nil :: gcore.is_nil
is_class :: gcore.is_class
cast_to :: gcore.cast_to
init_class_casting :: gcore.init_class_casting
object_to_variant :: gcore.object_to_variant
object_from_variant :: gcore.object_from_variant
variant_try_object :: gcore.variant_try_object
godot_context :: gcore.godot_context

// --- String ---
string_ptr :: gcore.string_ptr
const_string_ptr :: gcore.const_string_ptr
uninitialized_string_ptr :: gcore.uninitialized_string_ptr
string_init_utf8 :: gcore.string_init_utf8
string_from_utf8 :: gcore.string_from_utf8
string_utf8_len :: gcore.string_utf8_len
string_to_utf8 :: gcore.string_to_utf8
string_free :: gcore.string_free

// --- StringName ---
string_name_ptr :: gcore.string_name_ptr
const_string_name_ptr :: gcore.const_string_name_ptr
uninitialized_string_name_ptr :: gcore.uninitialized_string_name_ptr
string_name_init_utf8_cstring :: gcore.string_name_init_utf8_cstring
string_name_from_utf8_cstring :: gcore.string_name_from_utf8_cstring
string_name_free :: gcore.string_name_free
static_string_name_ptr :: gcore.static_string_name_ptr
const_static_string_name_ptr :: gcore.const_static_string_name_ptr
uninitialized_static_string_name_ptr :: gcore.uninitialized_static_string_name_ptr
static_string_name_init_latin1_cstring :: gcore.static_string_name_init_latin1_cstring

// --- NodePath ---
node_path_ptr :: gcore.node_path_ptr
const_node_path_ptr :: gcore.const_node_path_ptr
uninitialized_node_path_ptr :: gcore.uninitialized_node_path_ptr
node_path_init_from_string :: gcore.node_path_init_from_string
node_path_from_string :: gcore.node_path_from_string
node_path_init_utf8 :: gcore.node_path_init_utf8
node_path_from_utf8 :: gcore.node_path_from_utf8
node_path_init_copy :: gcore.node_path_init_copy
node_path_copy :: gcore.node_path_copy
node_path_free :: gcore.node_path_free
node_path_is_absolute :: gcore.node_path_is_absolute
node_path_get_name :: gcore.node_path_get_name
node_path_get_subname :: gcore.node_path_get_subname
node_path_get_concatenated_names :: gcore.node_path_get_concatenated_names
node_path_get_concatenated_subnames :: gcore.node_path_get_concatenated_subnames
node_path_get_name_count :: gcore.node_path_get_name_count
node_path_get_subname_count :: gcore.node_path_get_subname_count
node_path_hash :: gcore.node_path_hash

// --- Array ---
array_ptr :: gcore.array_ptr
const_array_ptr :: gcore.const_array_ptr
uninitialized_array_ptr :: gcore.uninitialized_array_ptr
array_init_new :: gcore.array_init_new
array_new :: gcore.array_new
array_init_copy :: gcore.array_init_copy
array_copy :: gcore.array_copy
array_free :: gcore.array_free
array_push :: gcore.array_push
array_size :: gcore.array_size
array_is_empty :: gcore.array_is_empty
array_clear :: gcore.array_clear
array_get :: gcore.array_get
array_set :: gcore.array_set
array_erase :: gcore.array_erase
array_has :: gcore.array_has

// --- Dictionary ---
dictionary_ptr :: gcore.dictionary_ptr
const_dictionary_ptr :: gcore.const_dictionary_ptr
uninitialized_dictionary_ptr :: gcore.uninitialized_dictionary_ptr
dictionary_init_new :: gcore.dictionary_init_new
dictionary_new :: gcore.dictionary_new
dictionary_init_copy :: gcore.dictionary_init_copy
dictionary_copy :: gcore.dictionary_copy
dictionary_free :: gcore.dictionary_free
dictionary_set :: gcore.dictionary_set
dictionary_has :: gcore.dictionary_has
dictionary_size :: gcore.dictionary_size
dictionary_is_empty :: gcore.dictionary_is_empty
dictionary_clear :: gcore.dictionary_clear
dictionary_erase :: gcore.dictionary_erase
dictionary_get_or_default :: gcore.dictionary_get_or_default
dictionary_get :: gcore.dictionary_get

// --- PackedByteArray ---
packed_byte_array_ptr :: gcore.packed_byte_array_ptr
const_packed_byte_array_ptr :: gcore.const_packed_byte_array_ptr
uninitialized_packed_byte_array_ptr :: gcore.uninitialized_packed_byte_array_ptr
packed_byte_array_init_new :: gcore.packed_byte_array_init_new
packed_byte_array_new :: gcore.packed_byte_array_new
packed_byte_array_init_copy :: gcore.packed_byte_array_init_copy
packed_byte_array_copy :: gcore.packed_byte_array_copy
packed_byte_array_free :: gcore.packed_byte_array_free
packed_byte_array_size :: gcore.packed_byte_array_size
packed_byte_array_is_empty :: gcore.packed_byte_array_is_empty
packed_byte_array_clear :: gcore.packed_byte_array_clear
packed_byte_array_get :: gcore.packed_byte_array_get
packed_byte_array_set :: gcore.packed_byte_array_set
packed_byte_array_push :: gcore.packed_byte_array_push

// --- PackedInt32Array ---
packed_int32_array_ptr :: gcore.packed_int32_array_ptr
const_packed_int32_array_ptr :: gcore.const_packed_int32_array_ptr
uninitialized_packed_int32_array_ptr :: gcore.uninitialized_packed_int32_array_ptr
packed_int32_array_init_new :: gcore.packed_int32_array_init_new
packed_int32_array_new :: gcore.packed_int32_array_new
packed_int32_array_init_copy :: gcore.packed_int32_array_init_copy
packed_int32_array_copy :: gcore.packed_int32_array_copy
packed_int32_array_free :: gcore.packed_int32_array_free
packed_int32_array_size :: gcore.packed_int32_array_size
packed_int32_array_is_empty :: gcore.packed_int32_array_is_empty
packed_int32_array_clear :: gcore.packed_int32_array_clear
packed_int32_array_get :: gcore.packed_int32_array_get
packed_int32_array_set :: gcore.packed_int32_array_set
packed_int32_array_push :: gcore.packed_int32_array_push

// --- PackedInt64Array ---
packed_int64_array_ptr :: gcore.packed_int64_array_ptr
const_packed_int64_array_ptr :: gcore.const_packed_int64_array_ptr
uninitialized_packed_int64_array_ptr :: gcore.uninitialized_packed_int64_array_ptr
packed_int64_array_init_new :: gcore.packed_int64_array_init_new
packed_int64_array_new :: gcore.packed_int64_array_new
packed_int64_array_init_copy :: gcore.packed_int64_array_init_copy
packed_int64_array_copy :: gcore.packed_int64_array_copy
packed_int64_array_free :: gcore.packed_int64_array_free
packed_int64_array_size :: gcore.packed_int64_array_size
packed_int64_array_is_empty :: gcore.packed_int64_array_is_empty
packed_int64_array_clear :: gcore.packed_int64_array_clear
packed_int64_array_get :: gcore.packed_int64_array_get
packed_int64_array_set :: gcore.packed_int64_array_set
packed_int64_array_push :: gcore.packed_int64_array_push

// --- PackedFloat32Array ---
packed_float32_array_ptr :: gcore.packed_float32_array_ptr
const_packed_float32_array_ptr :: gcore.const_packed_float32_array_ptr
uninitialized_packed_float32_array_ptr :: gcore.uninitialized_packed_float32_array_ptr
packed_float32_array_init_new :: gcore.packed_float32_array_init_new
packed_float32_array_new :: gcore.packed_float32_array_new
packed_float32_array_init_copy :: gcore.packed_float32_array_init_copy
packed_float32_array_copy :: gcore.packed_float32_array_copy
packed_float32_array_free :: gcore.packed_float32_array_free
packed_float32_array_size :: gcore.packed_float32_array_size
packed_float32_array_is_empty :: gcore.packed_float32_array_is_empty
packed_float32_array_clear :: gcore.packed_float32_array_clear
packed_float32_array_get :: gcore.packed_float32_array_get
packed_float32_array_set :: gcore.packed_float32_array_set
packed_float32_array_push :: gcore.packed_float32_array_push

// --- PackedFloat64Array ---
packed_float64_array_ptr :: gcore.packed_float64_array_ptr
const_packed_float64_array_ptr :: gcore.const_packed_float64_array_ptr
uninitialized_packed_float64_array_ptr :: gcore.uninitialized_packed_float64_array_ptr
packed_float64_array_init_new :: gcore.packed_float64_array_init_new
packed_float64_array_new :: gcore.packed_float64_array_new
packed_float64_array_init_copy :: gcore.packed_float64_array_init_copy
packed_float64_array_copy :: gcore.packed_float64_array_copy
packed_float64_array_free :: gcore.packed_float64_array_free
packed_float64_array_size :: gcore.packed_float64_array_size
packed_float64_array_is_empty :: gcore.packed_float64_array_is_empty
packed_float64_array_clear :: gcore.packed_float64_array_clear
packed_float64_array_get :: gcore.packed_float64_array_get
packed_float64_array_set :: gcore.packed_float64_array_set
packed_float64_array_push :: gcore.packed_float64_array_push

// --- PackedVector2Array ---
packed_vector2_array_ptr :: gcore.packed_vector2_array_ptr
const_packed_vector2_array_ptr :: gcore.const_packed_vector2_array_ptr
uninitialized_packed_vector2_array_ptr :: gcore.uninitialized_packed_vector2_array_ptr
packed_vector2_array_init_new :: gcore.packed_vector2_array_init_new
packed_vector2_array_new :: gcore.packed_vector2_array_new
packed_vector2_array_init_copy :: gcore.packed_vector2_array_init_copy
packed_vector2_array_copy :: gcore.packed_vector2_array_copy
packed_vector2_array_free :: gcore.packed_vector2_array_free
packed_vector2_array_size :: gcore.packed_vector2_array_size
packed_vector2_array_is_empty :: gcore.packed_vector2_array_is_empty
packed_vector2_array_clear :: gcore.packed_vector2_array_clear
packed_vector2_array_get :: gcore.packed_vector2_array_get
packed_vector2_array_set :: gcore.packed_vector2_array_set
packed_vector2_array_push :: gcore.packed_vector2_array_push

// --- PackedVector3Array ---
packed_vector3_array_ptr :: gcore.packed_vector3_array_ptr
const_packed_vector3_array_ptr :: gcore.const_packed_vector3_array_ptr
uninitialized_packed_vector3_array_ptr :: gcore.uninitialized_packed_vector3_array_ptr
packed_vector3_array_init_new :: gcore.packed_vector3_array_init_new
packed_vector3_array_new :: gcore.packed_vector3_array_new
packed_vector3_array_init_copy :: gcore.packed_vector3_array_init_copy
packed_vector3_array_copy :: gcore.packed_vector3_array_copy
packed_vector3_array_free :: gcore.packed_vector3_array_free
packed_vector3_array_size :: gcore.packed_vector3_array_size
packed_vector3_array_is_empty :: gcore.packed_vector3_array_is_empty
packed_vector3_array_clear :: gcore.packed_vector3_array_clear
packed_vector3_array_get :: gcore.packed_vector3_array_get
packed_vector3_array_set :: gcore.packed_vector3_array_set
packed_vector3_array_push :: gcore.packed_vector3_array_push

// --- PackedVector4Array ---
packed_vector4_array_ptr :: gcore.packed_vector4_array_ptr
const_packed_vector4_array_ptr :: gcore.const_packed_vector4_array_ptr
uninitialized_packed_vector4_array_ptr :: gcore.uninitialized_packed_vector4_array_ptr
packed_vector4_array_init_new :: gcore.packed_vector4_array_init_new
packed_vector4_array_new :: gcore.packed_vector4_array_new
packed_vector4_array_init_copy :: gcore.packed_vector4_array_init_copy
packed_vector4_array_copy :: gcore.packed_vector4_array_copy
packed_vector4_array_free :: gcore.packed_vector4_array_free
packed_vector4_array_size :: gcore.packed_vector4_array_size
packed_vector4_array_is_empty :: gcore.packed_vector4_array_is_empty
packed_vector4_array_clear :: gcore.packed_vector4_array_clear
packed_vector4_array_get :: gcore.packed_vector4_array_get
packed_vector4_array_set :: gcore.packed_vector4_array_set
packed_vector4_array_push :: gcore.packed_vector4_array_push

// --- PackedColorArray ---
packed_color_array_ptr :: gcore.packed_color_array_ptr
const_packed_color_array_ptr :: gcore.const_packed_color_array_ptr
uninitialized_packed_color_array_ptr :: gcore.uninitialized_packed_color_array_ptr
packed_color_array_init_new :: gcore.packed_color_array_init_new
packed_color_array_new :: gcore.packed_color_array_new
packed_color_array_init_copy :: gcore.packed_color_array_init_copy
packed_color_array_copy :: gcore.packed_color_array_copy
packed_color_array_free :: gcore.packed_color_array_free
packed_color_array_size :: gcore.packed_color_array_size
packed_color_array_is_empty :: gcore.packed_color_array_is_empty
packed_color_array_clear :: gcore.packed_color_array_clear
packed_color_array_get :: gcore.packed_color_array_get
packed_color_array_set :: gcore.packed_color_array_set
packed_color_array_push :: gcore.packed_color_array_push

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
variant_from_string :: gcore.variant_from_string
variant_from_string_name :: gcore.variant_from_string_name
variant_from_node_path :: gcore.variant_from_node_path
variant_from_array :: gcore.variant_from_array
variant_from_dictionary :: gcore.variant_from_dictionary
variant_from_packed_byte_array :: gcore.variant_from_packed_byte_array
variant_from_packed_int32_array :: gcore.variant_from_packed_int32_array
variant_from_packed_int64_array :: gcore.variant_from_packed_int64_array
variant_from_packed_float32_array :: gcore.variant_from_packed_float32_array
variant_from_packed_float64_array :: gcore.variant_from_packed_float64_array
variant_from_packed_vector2_array :: gcore.variant_from_packed_vector2_array
variant_from_packed_vector3_array :: gcore.variant_from_packed_vector3_array
variant_from_packed_vector4_array :: gcore.variant_from_packed_vector4_array
variant_from_packed_color_array :: gcore.variant_from_packed_color_array
variant_from_utf8 :: gcore.variant_from_utf8
variant_from_cstring :: gcore.variant_from_cstring
variant_to_float :: gcore.variant_to_float
variant_to_int :: gcore.variant_to_int
variant_to_bool :: gcore.variant_to_bool
variant_to_string_storage :: gcore.variant_to_string_storage
variant_to_string :: gcore.variant_to_string
variant_try_string :: gcore.variant_try_string
variant_to_string_name :: gcore.variant_to_string_name
variant_try_string_name :: gcore.variant_try_string_name
variant_to_node_path :: gcore.variant_to_node_path
variant_try_node_path :: gcore.variant_try_node_path
variant_to_array :: gcore.variant_to_array
variant_try_array :: gcore.variant_try_array
variant_to_dictionary :: gcore.variant_to_dictionary
variant_try_dictionary :: gcore.variant_try_dictionary
variant_to_packed_byte_array :: gcore.variant_to_packed_byte_array
variant_try_packed_byte_array :: gcore.variant_try_packed_byte_array
variant_to_packed_int32_array :: gcore.variant_to_packed_int32_array
variant_try_packed_int32_array :: gcore.variant_try_packed_int32_array
variant_to_packed_int64_array :: gcore.variant_to_packed_int64_array
variant_try_packed_int64_array :: gcore.variant_try_packed_int64_array
variant_to_packed_float32_array :: gcore.variant_to_packed_float32_array
variant_try_packed_float32_array :: gcore.variant_try_packed_float32_array
variant_to_packed_float64_array :: gcore.variant_to_packed_float64_array
variant_try_packed_float64_array :: gcore.variant_try_packed_float64_array
variant_to_packed_vector2_array :: gcore.variant_to_packed_vector2_array
variant_try_packed_vector2_array :: gcore.variant_try_packed_vector2_array
variant_to_packed_vector3_array :: gcore.variant_to_packed_vector3_array
variant_try_packed_vector3_array :: gcore.variant_try_packed_vector3_array
variant_to_packed_vector4_array :: gcore.variant_to_packed_vector4_array
variant_try_packed_vector4_array :: gcore.variant_try_packed_vector4_array
variant_to_packed_color_array :: gcore.variant_to_packed_color_array
variant_try_packed_color_array :: gcore.variant_try_packed_color_array
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
print :: gcore.print
print_init :: gcore.print_init

// --- Utility functions ---
sin :: gbind.sin
cos :: gbind.cos
tan :: gbind.tan
randf :: gbind.randf
