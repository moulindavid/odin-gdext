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
