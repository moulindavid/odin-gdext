# Variant marshaling progress

Total: 38 Variant types (excluding Nil and Var_Max).

## Primitives

| Type | from (Variant ← Odin) | to (Variant → Odin) | Notes |
|------|----------------------|---------------------|-------|
| Nil | — | — | `godot-ffi/interface::variant_new_nil` exists in interface |
| Bool | | | |
| Int | | | |
| Float | done | | `variant_from_float`|
| String | done | | via `string_new_with_latin1_chars` then `get_variant_from_type_constructor` |

## Math types

| Type | from | to | Notes |
|------|------|----|-------|
| Vector2 | | | `[2]f32` |
| Vector2i | | | `[2]i32` |
| Rect2 | | | |
| Rect2i | | | |
| Vector3 | | | |
| Vector3i | | | |
| Transform2d | | | |
| Vector4 | | | |
| Vector4i | | | |
| Plane | | | |
| Quaternion | | | |
| Aabb | | | |
| Basis | | | |
| Transform3d | | | |
| Projection | | | |

## Misc types

| Type | from | to | Notes |
|------|------|----|-------|
| Color | | | |
| String_Name | | | Already used internally via `string_name_new_with_latin1_chars` |
| Node_Path | | | |
| Rid | | | |
| Object | | | Needs Gd<T> wrapper |
| Callable | | | |
| Signal | | | |
| Dictionary | | | Similar to Array: `variant_construct` + `variant_call` |
| Array | done | | `variant_construct`, `array_new`, `array_push`, `array_size` |
| Packed_Byte_Array | | | |
| Packed_Int32_Array | | | |
| Packed_Int64_Array | | | |
| Packed_Float32_Array | | | |
| Packed_Float64_Array | | | |
| Packed_String_Array | | | |
| Packed_Vector2_Array | | | |
| Packed_Vector3_Array | | | |
| Packed_Color_Array | | | |
| Packed_Vector4_Array | | | |

## Priority for next milestone (class methods)

1. variant_to_float / variant_to_int / variant_to_bool
2. variant_from_int / variant_from_bool

Then: Vector2, Vector3, Color (most commonly used in game methods).
