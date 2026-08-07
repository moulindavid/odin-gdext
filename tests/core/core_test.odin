package core_tests

import "core:testing"
import gd "godot:core"

@(test)
variant_storage_matches_documented_abi_size :: proc(t: ^testing.T) {
	testing.expect_value(t, size_of(gd.Variant), gd.GDExtensionVariant_Size)
	testing.expect_value(t, len(gd.Variant{}), gd.GDExtensionVariant_Size)
}
