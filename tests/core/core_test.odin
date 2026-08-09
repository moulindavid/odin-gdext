package core_tests

import "core:testing"
import gd "godot:core"

@(test)
variant_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.VariantStorage), gd.GDExtensionVariant_Size)
	testing.expect_value(t, size_of(gd.Variant), gd.GDExtensionVariant_Size)
	testing.expect_value(t, len(gd.VariantStorage{}), gd.GDExtensionVariant_Size)
}

@(test)
string_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.StringStorage), gd.GDExtensionString_Size)
	testing.expect_value(t, size_of(gd.String), gd.GDExtensionString_Size)
	testing.expect_value(t, len(gd.StringStorage{}), gd.GDExtensionString_Size)
}

@(test)
string_name_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.StringNameStorage), gd.GDExtensionStringName_Size)
	testing.expect_value(t, size_of(gd.StringName), gd.GDExtensionStringName_Size)
	testing.expect_value(t, size_of(gd.StaticStringName), gd.GDExtensionStringName_Size)
	testing.expect_value(t, len(gd.StringNameStorage{}), gd.GDExtensionStringName_Size)
}

@(test)
node_path_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.NodePathStorage), gd.GDExtensionNodePath_Size)
	testing.expect_value(t, size_of(gd.NodePath), gd.GDExtensionNodePath_Size)
	testing.expect_value(t, len(gd.NodePathStorage{}), gd.GDExtensionNodePath_Size)
}

@(test)
array_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.ArrayStorage), gd.GDExtensionArray_Size)
	testing.expect_value(t, size_of(gd.Array), gd.GDExtensionArray_Size)
	testing.expect_value(t, len(gd.ArrayStorage{}), gd.GDExtensionArray_Size)
}

@(test)
dictionary_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.DictionaryStorage), gd.GDExtensionDictionary_Size)
	testing.expect_value(t, size_of(gd.Dictionary), gd.GDExtensionDictionary_Size)
	testing.expect_value(t, len(gd.DictionaryStorage{}), gd.GDExtensionDictionary_Size)
}

@(test)
packed_byte_array_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.PackedByteArrayStorage), gd.GDExtensionPackedByteArray_Size)
	testing.expect_value(t, size_of(gd.PackedByteArray), gd.GDExtensionPackedByteArray_Size)
	testing.expect_value(t, len(gd.PackedByteArrayStorage{}), gd.GDExtensionPackedByteArray_Size)
}

@(test)
packed_int32_array_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(
		t,
		size_of(gd.PackedInt32ArrayStorage),
		gd.GDExtensionPackedInt32Array_Size,
	)
	testing.expect_value(t, size_of(gd.PackedInt32Array), gd.GDExtensionPackedInt32Array_Size)
	testing.expect_value(t, len(gd.PackedInt32ArrayStorage{}), gd.GDExtensionPackedInt32Array_Size)
}

@(test)
packed_int64_array_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(
		t,
		size_of(gd.PackedInt64ArrayStorage),
		gd.GDExtensionPackedInt64Array_Size,
	)
	testing.expect_value(t, size_of(gd.PackedInt64Array), gd.GDExtensionPackedInt64Array_Size)
	testing.expect_value(t, len(gd.PackedInt64ArrayStorage{}), gd.GDExtensionPackedInt64Array_Size)
}

@(test)
packed_float32_array_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(
		t,
		size_of(gd.PackedFloat32ArrayStorage),
		gd.GDExtensionPackedFloat32Array_Size,
	)
	testing.expect_value(t, size_of(gd.PackedFloat32Array), gd.GDExtensionPackedFloat32Array_Size)
	testing.expect_value(
		t,
		len(gd.PackedFloat32ArrayStorage{}),
		gd.GDExtensionPackedFloat32Array_Size,
	)
}

@(test)
variant_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	v: gd.Variant
	_ = gd.variant_ptr(&v)
	_ = gd.const_variant_ptr(&v)
	_ = gd.uninitialized_variant_ptr(&v)
}

@(test)
string_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	s: gd.String
	_ = gd.string_ptr(&s)
	_ = gd.const_string_ptr(&s)
	_ = gd.uninitialized_string_ptr(&s)
}

@(test)
string_name_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	s: gd.StringName
	_ = gd.string_name_ptr(&s)
	_ = gd.const_string_name_ptr(&s)
	_ = gd.uninitialized_string_name_ptr(&s)

	static: gd.StaticStringName
	_ = gd.static_string_name_ptr(&static)
	_ = gd.const_static_string_name_ptr(&static)
	_ = gd.uninitialized_static_string_name_ptr(&static)
}

@(test)
node_path_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	p: gd.NodePath
	_ = gd.node_path_ptr(&p)
	_ = gd.const_node_path_ptr(&p)
	_ = gd.uninitialized_node_path_ptr(&p)
}

@(test)
array_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	a: gd.Array
	_ = gd.array_ptr(&a)
	_ = gd.const_array_ptr(&a)
	_ = gd.uninitialized_array_ptr(&a)
}

@(test)
dictionary_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	d: gd.Dictionary
	_ = gd.dictionary_ptr(&d)
	_ = gd.const_dictionary_ptr(&d)
	_ = gd.uninitialized_dictionary_ptr(&d)
}

@(test)
packed_byte_array_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	a: gd.PackedByteArray
	_ = gd.packed_byte_array_ptr(&a)
	_ = gd.const_packed_byte_array_ptr(&a)
	_ = gd.uninitialized_packed_byte_array_ptr(&a)
}

@(test)
packed_int32_array_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	a: gd.PackedInt32Array
	_ = gd.packed_int32_array_ptr(&a)
	_ = gd.const_packed_int32_array_ptr(&a)
	_ = gd.uninitialized_packed_int32_array_ptr(&a)
}

@(test)
packed_int64_array_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	a: gd.PackedInt64Array
	_ = gd.packed_int64_array_ptr(&a)
	_ = gd.const_packed_int64_array_ptr(&a)
	_ = gd.uninitialized_packed_int64_array_ptr(&a)
}

@(test)
packed_float32_array_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	a: gd.PackedFloat32Array
	_ = gd.packed_float32_array_ptr(&a)
	_ = gd.const_packed_float32_array_ptr(&a)
	_ = gd.uninitialized_packed_float32_array_ptr(&a)
}

@(test)
call_error_ok_reports_only_success :: proc(t: ^testing.T) {
	ok := gd.CallError {
		error = .Ok,
	}
	invalid := gd.CallError {
		error = .Invalid_Method,
	}

	testing.expect_value(t, gd.call_error_ok(&ok), true)
	testing.expect_value(t, gd.call_error_ok(&invalid), false)
}
