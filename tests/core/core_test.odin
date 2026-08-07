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
variant_pointer_helpers_preserve_storage_address :: proc(t: ^testing.T) {
	v: gd.Variant
	_ = gd.variant_ptr(&v)
	_ = gd.const_variant_ptr(&v)
	_ = gd.uninitialized_variant_ptr(&v)
}
