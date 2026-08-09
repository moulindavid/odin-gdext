#+feature dynamic-literals
package bindgen

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

// ---------------------------------------------------------------------------
// JSON model -- extension_api.json schema
// ---------------------------------------------------------------------------

ExtensionApiRoot :: struct {
	builtin_classes:              []ExtensionApiBuiltinClass `json:"builtin_classes"`,
	classes:                      []ExtensionApiClass `json:"classes"`,
	singletons:                   []ExtensionApiSingleton `json:"singletons"`,
	utility_functions:            []ExtensionApiUtilityFunction `json:"utility_functions"`,
	builtin_class_member_offsets: []ExtensionApiMemberOffsets `json:"builtin_class_member_offsets"`,
}

ExtensionApiBuiltinClass :: struct {
	name:         string `json:"name"`,
	members:      []ExtensionApiMember `json:"members,omitempty"`,
	constructors: []ExtensionApiConstructor `json:"constructors,omitempty"`,
	methods:      []ExtensionApiMethod `json:"methods,omitempty"`,
	enums:        []ExtensionApiEnum `json:"enums,omitempty"`,
	constants:    []ExtensionApiConstant `json:"constants,omitempty"`,
}

ExtensionApiMember :: struct {
	name: string `json:"name"`,
	type: string `json:"type"`,
}

ExtensionApiConstructor :: struct {
	index:     i32 `json:"index"`,
	arguments: []ExtensionApiConstructorArg `json:"arguments,omitempty"`,
}

ExtensionApiConstructorArg :: struct {
	name: string `json:"name"`,
	type: string `json:"type"`,
}

ExtensionApiMethod :: struct {
	name:        string `json:"name"`,
	return_type: string `json:"return_type,omitempty"`,
	is_static:   bool `json:"is_static"`,
	is_vararg:   bool `json:"is_vararg"`,
	hash:        i64 `json:"hash"`,
	arguments:   []ExtensionApiMethodArg `json:"arguments,omitempty"`,
}

ExtensionApiMethodArg :: struct {
	name: string `json:"name"`,
	type: string `json:"type"`,
}

ExtensionApiEnum :: struct {
	name:   string `json:"name"`,
	values: []ExtensionApiEnumValue `json:"values"`,
}

ExtensionApiEnumValue :: struct {
	name:  string `json:"name"`,
	value: i64 `json:"value"`,
}

ExtensionApiConstant :: struct {
	name:  string `json:"name"`,
	type:  string `json:"type"`,
	value: string `json:"value"`,
}

ExtensionApiClass :: struct {
	name:      string `json:"name"`,
	inherits:  string `json:"inherits,omitempty"`,
	methods:   []ExtensionApiClassMethod `json:"methods,omitempty"`,
	enums:     []ExtensionApiEnum `json:"enums,omitempty"`,
	constants: []ExtensionApiClassConstant `json:"constants,omitempty"`,
}

ExtensionApiClassMethod :: struct {
	name:         string `json:"name"`,
	return_value: ExtensionApiClassReturnValue `json:"return_value,omitempty"`,
	is_static:    bool `json:"is_static,omitempty"`,
	is_vararg:    bool `json:"is_vararg,omitempty"`,
	is_virtual:   bool `json:"is_virtual,omitempty"`,
	hash:         i64 `json:"hash"`,
	arguments:    []ExtensionApiMethodArg `json:"arguments,omitempty"`,
}

ExtensionApiClassReturnValue :: struct {
	type: string `json:"type,omitempty"`,
}

ExtensionApiClassConstant :: struct {
	name:  string `json:"name"`,
	type:  string `json:"type,omitempty"`,
	value: json.Value `json:"value"`,
}

ExtensionApiSingleton :: struct {
	name: string `json:"name"`,
	type: string `json:"type"`,
}

ExtensionApiUtilityFunction :: struct {
	name:        string `json:"name"`,
	return_type: string `json:"return_type,omitempty"`,
	is_vararg:   bool `json:"is_vararg"`,
	hash:        i64 `json:"hash"`,
	arguments:   []ExtensionApiUtilityArg `json:"arguments,omitempty"`,
}

ExtensionApiUtilityArg :: struct {
	name: string `json:"name"`,
	type: string `json:"type"`,
}

ExtensionApiMemberOffsets :: struct {
	classes: []ExtensionApiMemberOffsetClass `json:"classes"`,
}

ExtensionApiMemberOffsetClass :: struct {
	name:    string `json:"name"`,
	members: []ExtensionApiMemberOffsetEntry `json:"members"`,
}

ExtensionApiMemberOffsetEntry :: struct {
	member: string `json:"member"`,
	offset: i32 `json:"offset"`,
	meta:   string `json:"meta"`,
}

// ---------------------------------------------------------------------------
// Type mapping: Godot name → Odin name
//
// Two separate maps because GDExtension uses different sizes for members
// (native storage, f32) vs method args/returns (Godot `float` ABI, core.GodotReal).
// ---------------------------------------------------------------------------

member_type_map := map[string]string {
	"Nil"     = "rawptr",
	"bool"    = "bool",
	"int"     = "i64",
	"int32"   = "i32",
	"int64"   = "i64",
	"float"   = "f32",
	"double"  = "f64",
	"Variant" = "rawptr",
}

arg_type_map := map[string]string {
	"Nil"     = "rawptr",
	"bool"    = "bool",
	"int"     = "i64",
	"int32"   = "i32",
	"int64"   = "i64",
	"float"   = "core.GodotReal",
	"double"  = "f64",
	"Variant" = "core.Variant",
}

// Entries common to both maps (builtin types, pointer types).
common_type_entries := []struct {
	godot, odin: string,
}{{"Callable", "rawptr"}, {"Signal", "rawptr"}}

init_type_maps :: proc() {
	for e in common_type_entries {
		member_type_map[e.godot] = e.odin
		arg_type_map[e.godot] = e.odin
	}
}


Core_Value_Entry :: struct {
	godot: string,
	odin:  string,
	ptr:   string,
	free:  string,
}

completed_core_value_entries := []Core_Value_Entry {
	{"String", "core.String", "core.const_string_ptr", "core.string_free"},
	{"StringName", "core.StringName", "core.const_string_name_ptr", "core.string_name_free"},
	{"NodePath", "core.NodePath", "core.const_node_path_ptr", "core.node_path_free"},
	{"RID", "core.RID", "core.const_rid_ptr", "core.rid_free"},
	{"Array", "core.Array", "core.const_array_ptr", "core.array_free"},
	{"Dictionary", "core.Dictionary", "core.const_dictionary_ptr", "core.dictionary_free"},
	{
		"PackedByteArray",
		"core.PackedByteArray",
		"core.const_packed_byte_array_ptr",
		"core.packed_byte_array_free",
	},
	{
		"PackedInt32Array",
		"core.PackedInt32Array",
		"core.const_packed_int32_array_ptr",
		"core.packed_int32_array_free",
	},
	{
		"PackedInt64Array",
		"core.PackedInt64Array",
		"core.const_packed_int64_array_ptr",
		"core.packed_int64_array_free",
	},
	{
		"PackedFloat32Array",
		"core.PackedFloat32Array",
		"core.const_packed_float32_array_ptr",
		"core.packed_float32_array_free",
	},
	{
		"PackedFloat64Array",
		"core.PackedFloat64Array",
		"core.const_packed_float64_array_ptr",
		"core.packed_float64_array_free",
	},
	{
		"PackedStringArray",
		"core.PackedStringArray",
		"core.const_packed_string_array_ptr",
		"core.packed_string_array_free",
	},
	{
		"PackedVector2Array",
		"core.PackedVector2Array",
		"core.const_packed_vector2_array_ptr",
		"core.packed_vector2_array_free",
	},
	{
		"PackedVector3Array",
		"core.PackedVector3Array",
		"core.const_packed_vector3_array_ptr",
		"core.packed_vector3_array_free",
	},
	{
		"PackedVector4Array",
		"core.PackedVector4Array",
		"core.const_packed_vector4_array_ptr",
		"core.packed_vector4_array_free",
	},
	{
		"PackedColorArray",
		"core.PackedColorArray",
		"core.const_packed_color_array_ptr",
		"core.packed_color_array_free",
	},
}

completed_core_value_entry :: proc(godot_name: string) -> (entry: Core_Value_Entry, ok: bool) {
	for e in completed_core_value_entries {
		if e.godot == godot_name do return e, true
	}
	return {}, false
}

// Resolve a Godot type name to an Odin type for struct members (native storage).
resolve_member_type :: proc(godot_name: string) -> string {
	if t, ok := member_type_map[godot_name]; ok {return t}
	return godot_name // builtin type with same name
}

// Resolve a Godot type name to an Odin type for method return values (ABI).
// Variant and String returns are owned initialized storage; callers must destroy
// them with core.variant_free or core.string_free when done.
resolve_return_type :: proc(godot_name: string) -> string {
	if entry, ok := completed_core_value_entry(godot_name); ok {return entry.odin}
	if t, ok := arg_type_map[godot_name]; ok {return t}
	return godot_name
}

// Resolve a Godot type name to an Odin type for parameters (ABI). Variant and
// completed core value parameters are borrowed to avoid unsafe by-value copies
// of owned storage.
resolve_param_type :: proc(godot_name: string) -> string {
	if godot_name == "Variant" do return "^core.Variant"
	if entry, ok := completed_core_value_entry(godot_name); ok {
		return fmt.aprintf("^%s", entry.odin)
	}
	return resolve_return_type(godot_name)
}

param_ptr_expr :: proc(arg_name, godot_type: string) -> string {
	if godot_type == "Variant" do return fmt.aprintf("core.variant_ptr(%s)", arg_name)
	if entry, ok := completed_core_value_entry(godot_type); ok {
		return fmt.aprintf("%s(%s)", entry.ptr, arg_name)
	}
	return fmt.aprintf("cast(core.TypePtr)&_%s", arg_name)
}

// ---------------------------------------------------------------------------
// Variant type enum name: JSON uses names like "AABB", "Transform2D" but
// GDExtensionVariantType uses .Aabb, .Transform2d.
// ---------------------------------------------------------------------------

variant_enum_name_map := map[string]string {
	"Transform2D" = "Transform2d",
	"Transform3D" = "Transform3d",
	"AABB"        = "Aabb",
}

variant_enum_name :: proc(json_name: string) -> string {
	if n, ok := variant_enum_name_map[json_name]; ok {return n}
	return json_name
}

// ---------------------------------------------------------------------------
// Skip list: complex types needing manual handling.
// ---------------------------------------------------------------------------

skip_builtins := map[string]bool {
	"Nil"                = true,
	"bool"               = true,
	"int"                = true,
	"float"              = true,
	"String"             = true,
	"StringName"         = true,
	"NodePath"           = true,
	"RID"                = true,
	"Callable"           = true,
	"Signal"             = true,
	"Dictionary"         = true,
	"Array"              = true,
	"PackedByteArray"    = true,
	"PackedInt32Array"   = true,
	"PackedInt64Array"   = true,
	"PackedFloat32Array" = true,
	"PackedFloat64Array" = true,
	"PackedStringArray"  = true,
	"PackedVector2Array" = true,
	"PackedVector3Array" = true,
	"PackedColorArray"   = true,
	"PackedVector4Array" = true,
}

// ---------------------------------------------------------------------------
// Constructor name heuristic
// ---------------------------------------------------------------------------

constructor_name :: proc(lower: string, index: i32, n_args: int) -> string {
	if index == 0 {return fmt.aprintf("%s_new", lower)}
	// Index 1 with 1 arg is typically a copy constructor; give it a name.
	// Other constructors get index-based names.
	return fmt.aprintf("%s_new%d", lower, index)
}

// ---------------------------------------------------------------------------
// Emitters
// ---------------------------------------------------------------------------

// Emit the Odin struct definition matching Godot's memory layout.
// Uses real member data from builtin_class_member_offsets if available;
// falls back to the members list from the class definition.
emit_struct :: proc(
	b: ^strings.Builder,
	c: ExtensionApiBuiltinClass,
	real_members: map[string][]ExtensionApiMemberOffsetEntry,
) {
	strings.write_string(b, "// ---- Struct (memory-compatible with Godot) ----\n\n")
	if c.name == "Vector2" || c.name == "Vector3" || c.name == "Vector4" || c.name == "Color" {
		fmt.sbprintf(b, "%s :: core.%s\n\n", c.name, c.name)
		return
	}
	fmt.sbprintf(b, "%s :: struct {{\n", c.name)

	if entries, ok := real_members[c.name]; ok {
		// Use offset data -- only real struct fields
		for e in entries {
			mt := resolve_member_type(e.meta)
			fmt.sbprintf(b, "\t%s: %s,\n", e.member, mt)
		}
	} else {
		// Fallback: use members list from class definition
		for m in c.members {
			mt := resolve_member_type(m.type)
			fmt.sbprintf(b, "\t%s: %s,\n", m.name, mt)
		}
	}
	strings.write_string(b, "}\n\n")
}

// Emit variant_from / variant_to conversions.
emit_variant_conversion :: proc(b: ^strings.Builder, c: ExtensionApiBuiltinClass) {
	lower := strings.to_lower(c.name)
	vt_name := variant_enum_name(c.name)

	strings.write_string(b, "// ---- Variant conversion ----\n\n")

	// to_variant
	fmt.sbprintf(
		b,
		"// %s_to_variant returns an initialized Variant; call core.variant_free when done.\n",
		lower,
	)
	fmt.sbprintf(
		b,
		"%s_to_variant :: proc \"contextless\" (v: %s) -> core.Variant {{\n",
		lower,
		c.name,
	)
	strings.write_string(b, "\tresult: core.Variant\n")
	fmt.sbprintf(b, "\tctor := core.require_variant_from_type_constructor(.%s)\n", vt_name)
	strings.write_string(b, "\t_v := v\n")
	strings.write_string(
		b,
		"\tctor(core.uninitialized_variant_ptr(&result), cast(core.TypePtr)&_v)\n",
	)
	strings.write_string(b, "\treturn result\n")
	strings.write_string(b, "}\n\n")

	// from_variant
	fmt.sbprintf(
		b,
		"%s_from_variant :: proc \"contextless\" (v: ^core.Variant) -> %s {{\n",
		lower,
		c.name,
	)
	fmt.sbprintf(b, "\tctor := core.require_variant_to_type_constructor(.%s)\n", vt_name)
	fmt.sbprintf(b, "\tresult: %s\n", c.name)
	strings.write_string(
		b,
		"\tctor(cast(core.UninitializedTypePtr)&result, core.variant_ptr(v))\n",
	)
	strings.write_string(b, "\treturn result\n")
	strings.write_string(b, "}\n\n")

	// try_from_variant
	fmt.sbprintf(
		b,
		"%s_try_from_variant :: proc \"contextless\" (v: ^core.Variant) -> (value: %s, ok: bool) {{\n",
		lower,
		c.name,
	)
	fmt.sbprintf(
		b,
		"\tif !core.variant_is_type(v, .%s) do return %s{{}}, false\n",
		vt_name,
		c.name,
	)
	fmt.sbprintf(b, "\treturn %s_from_variant(v), true\n", lower)
	strings.write_string(b, "}\n\n")
}

// Emit constructors. Each is selected by index (not arg count).
emit_constructors :: proc(b: ^strings.Builder, c: ExtensionApiBuiltinClass) {
	if len(c.constructors) == 0 {return}
	lower := strings.to_lower(c.name)
	vt_name := variant_enum_name(c.name)

	strings.write_string(b, "// ---- Constructors ----\n\n")

	for ctor in c.constructors {
		ct_name := constructor_name(lower, ctor.index, len(ctor.arguments))

		// Build argument list for proc signature
		args_list := ""
		for arg, j in ctor.arguments {
			at := resolve_param_type(arg.type)
			if j > 0 {args_list = strings.concatenate({args_list, ", "})}
			args_list = strings.concatenate({args_list, fmt.aprintf("%s: %s", arg.name, at)})
		}

		fmt.sbprintf(b, "%s :: proc \"contextless\" (%s) -> %s {{\n", ct_name, args_list, c.name)
		fmt.sbprintf(b, "\tresult: %s\n", c.name)
		fmt.sbprintf(
			b,
			"\tctor := core.get_builtin_constructor_by_index(.%s, %d)\n",
			vt_name,
			ctor.index,
		)

		// Copy addressable value args to locals. Variant args are borrowed and
		// passed as pointers to their existing initialized storage.
		for arg in ctor.arguments {
			if arg.type == "Variant" do continue
			if _, ok := completed_core_value_entry(arg.type); ok do continue
			fmt.sbprintf(b, "\t_%s := %s\n", arg.name, arg.name)
		}

		// Call constructor
		strings.write_string(
			b,
			"\tcore.call_builtin_constructor(ctor, cast(core.UninitializedTypePtr)&result",
		)
		for arg in ctor.arguments {
			fmt.sbprintf(b, ",\n\t\t%s", param_ptr_expr(arg.name, arg.type))
		}
		strings.write_string(b, ")\n")
		strings.write_string(b, "\treturn result\n")
		strings.write_string(b, "}\n\n")
	}
}

// Emit methods. Handles both instance and static methods.
emit_methods :: proc(b: ^strings.Builder, c: ExtensionApiBuiltinClass) {
	if len(c.methods) == 0 {return}
	lower := strings.to_lower(c.name)
	vt_name := variant_enum_name(c.name)

	strings.write_string(b, "// ---- Methods ----\n\n")

	for m in c.methods {
		if m.is_vararg {continue} 	// skip vararg methods for now

		method_var := fmt.aprintf("_%s_%s", lower, m.name)
		fmt.sbprintf(b, "@(private=\"file\")\n%s: core.BuiltinMethod\n\n", method_var)

		// Build proc signature
		returns_void := m.return_type == "" || m.return_type == "void"
		ret_type := "" if returns_void else resolve_return_type(m.return_type)
		if m.return_type == "Variant" {
			fmt.sbprintf(
				b,
				"// %s_%s returns an initialized Variant; call core.variant_free when done.\n",
				lower,
				m.name,
			)
		} else if entry, ok := completed_core_value_entry(m.return_type); ok {
			fmt.sbprintf(
				b,
				"// %s_%s returns initialized %s storage; call %s when done.\n",
				lower,
				m.name,
				entry.godot,
				entry.free,
			)
		}

		if m.is_static {
			// Static: no self parameter
			args_list := ""
			for arg, j in m.arguments {
				at := resolve_param_type(arg.type)
				if j > 0 {args_list = strings.concatenate({args_list, ", "})}
				args_list = strings.concatenate({args_list, fmt.aprintf("%s: %s", arg.name, at)})
			}
			if returns_void {
				fmt.sbprintf(
					b,
					"%s_%s :: proc \"contextless\" (%s) {{\n",
					lower,
					m.name,
					args_list,
				)
			} else {
				fmt.sbprintf(
					b,
					"%s_%s :: proc \"contextless\" (%s) -> %s {{\n",
					lower,
					m.name,
					args_list,
					ret_type,
				)
			}
		} else {
			// Instance: self is first parameter
			fmt.sbprintf(b, "%s_%s :: proc \"contextless\" (self_: %s", lower, m.name, c.name)
			for arg in m.arguments {
				at := resolve_param_type(arg.type)
				fmt.sbprintf(b, ", %s: %s", arg.name, at)
			}
			if returns_void {
				fmt.sbprintf(b, ") {{\n")
			} else {
				fmt.sbprintf(b, ") -> %s {{\n", ret_type)
			}
		}

		fmt.sbprintf(
			b,
			"\tcore.ensure_builtin_method(&%s, .%s, cstring(\"%s\"), %d)\n",
			method_var,
			vt_name,
			m.name,
			m.hash,
		)

		// Copy addressable value args to locals. Variant args are borrowed and
		// passed as pointers to their existing initialized storage.
		if !m.is_static {
			fmt.sbprintf(b, "\t_self_ := self_\n")
		}
		for arg in m.arguments {
			if arg.type == "Variant" do continue
			if _, ok := completed_core_value_entry(arg.type); ok do continue
			fmt.sbprintf(b, "\t_%s := %s\n", arg.name, arg.name)
		}

		// Build the call
		if m.is_static {
			// Static: base is nil
			if returns_void {
				fmt.sbprintf(b, "\tcore.call_builtin_method_ptr_no_ret(%s.method, nil", method_var)
			} else {
				fmt.sbprintf(
					b,
					"\treturn core.call_builtin_method_ptr_ret(%s.method, nil, %s",
					method_var,
					ret_type,
				)
			}
			for arg in m.arguments {
				fmt.sbprintf(b, ",\n\t\t%s", param_ptr_expr(arg.name, arg.type))
			}
			strings.write_string(b, ")\n")
		} else {
			// Instance: base is &_v
			if returns_void {
				fmt.sbprintf(
					b,
					"\tcore.call_builtin_method_ptr_no_ret(%s.method, cast(core.TypePtr)&_self_",
					method_var,
				)
			} else {
				fmt.sbprintf(
					b,
					"\treturn core.call_builtin_method_ptr_ret(%s.method, cast(core.TypePtr)&_self_, %s",
					method_var,
					ret_type,
				)
			}
			for arg in m.arguments {
				fmt.sbprintf(b, ",\n\t\t%s", param_ptr_expr(arg.name, arg.type))
			}
			strings.write_string(b, ")\n")
		}

		strings.write_string(b, "}\n\n")
	}
}

// Emit enums associated with the builtin type.
emit_enums :: proc(b: ^strings.Builder, c: ExtensionApiBuiltinClass) {
	if len(c.enums) == 0 {return}
	strings.write_string(b, "// ---- Enums ----\n\n")

	for e in c.enums {
		fmt.sbprintf(b, "%s%s :: enum {{\n", c.name, e.name)
		for v in e.values {
			fmt.sbprintf(b, "\t%s = %d,\n", v.name, v.value)
		}
		strings.write_string(b, "}\n\n")
	}
}

// Emit constants. These are constructor expressions like "Vector2(0, 0)".
// We emit them as commented documentation for now.
emit_constants :: proc(b: ^strings.Builder, c: ExtensionApiBuiltinClass) {
	if len(c.constants) == 0 {return}
	strings.write_string(
		b,
		"// ---- Constants (from extension_api.json; implement manually) ----\n",
	)
	strings.write_string(b, "// See Godot docs for values.\n//\n")
	upper := strings.to_upper(c.name)
	for ct in c.constants {
		fmt.sbprintf(b, "// %s_%s = %s\n", upper, ct.name, ct.value)
	}
	strings.write_string(b, "\n")
}

// ---------------------------------------------------------------------------
// Main generation for one builtin class
// ---------------------------------------------------------------------------

generate_one :: proc(
	c: ExtensionApiBuiltinClass,
	real_members: map[string][]ExtensionApiMemberOffsetEntry,
) -> bool {
	// Skip empty types
	if skip_builtins[c.name] {return true}
	if len(c.members) == 0 && len(c.methods) == 0 && len(c.constructors) == 0 {
		return true
	}

	lower := strings.to_lower(c.name)
	path := fmt.aprintf("bindings/builtin/%s.odin", lower)

	b := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&b)

	fmt.sbprintf(
		&b,
		"// bindings/builtin/%s.odin -- Godot %s built-in type bindings.\n",
		lower,
		c.name,
	)
	fmt.sbprintf(&b, "// Auto-generated from extension_api.json. DO NOT EDIT.\n\n")
	strings.write_string(&b, "package godot_bindings_builtin\n\n")
	strings.write_string(&b, "import core \"godot:core\"\n\n")

	emit_struct(&b, c, real_members)
	emit_variant_conversion(&b, c)
	emit_constructors(&b, c)
	emit_methods(&b, c)
	emit_enums(&b, c)
	emit_constants(&b, c)

	err := os.write_entire_file(path, transmute([]byte)strings.to_string(b))
	if err != nil {
		fmt.eprintfln("ERROR: %v", err)
		return false
	}
	fmt.printfln("  %s", path)
	return true
}

// ---------------------------------------------------------------------------
// Utility function codegen
// ---------------------------------------------------------------------------

// Return types that need complex struct storage.
skip_util_return := map[string]bool {
	"Object"           = true,
	"PackedByteArray"  = true,
	"PackedInt64Array" = true,
	"RID"              = true,
	"String"           = true,
	"Variant"          = true,
}

// Arg types that need complex struct storage.
skip_util_arg := map[string]bool {
	"String" = true,
}

generate_utility_bindings :: proc(root: ^ExtensionApiRoot) -> bool {
	path := "bindings/utilities.odin"

	b := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&b)

	strings.write_string(
		&b,
		"// bindings/utilities.odin -- Godot @GlobalScope utility function bindings.\n",
	)
	strings.write_string(&b, "// Auto-generated from extension_api.json. DO NOT EDIT.\n\n")
	strings.write_string(&b, "package godot_bindings\n\n")
	strings.write_string(&b, "import core \"godot:core\"\n")
	strings.write_string(&b, "import \"core:sync\"\n\n")

	// _UtilFunc struct
	strings.write_string(
		&b,
		"// ---------------------------------------------------------------------------\n",
	)
	strings.write_string(&b, "// Internal: lazy utility function resolution\n")
	strings.write_string(
		&b,
		"// ---------------------------------------------------------------------------\n\n",
	)
	strings.write_string(&b, "@(private=\"file\")\n")
	strings.write_string(&b, "_UtilFunc :: struct {\n")
	strings.write_string(&b, "\tname_data: core.StaticStringName,\n")
	strings.write_string(&b, "\tfunc:      core.PtrUtilityFunction,\n")
	strings.write_string(&b, "\tinit:      bool,\n")
	strings.write_string(&b, "\tmutex:     sync.Mutex,\n")
	strings.write_string(&b, "}\n\n")

	strings.write_string(&b, "@(private=\"file\")\n")
	strings.write_string(
		&b,
		"_ensure_utility :: proc \"contextless\" (uf: ^_UtilFunc, name: cstring, hash: i64) {\n",
	)
	strings.write_string(&b, "\tsync.mutex_lock(&uf.mutex)\n")
	strings.write_string(&b, "\tdefer sync.mutex_unlock(&uf.mutex)\n\n")
	strings.write_string(&b, "\tif uf.init do return\n\n")
	strings.write_string(&b, "\tcore.static_string_name_init_latin1_cstring(\n")
	strings.write_string(&b, "\t\tcore.uninitialized_static_string_name_ptr(&uf.name_data),\n")
	strings.write_string(&b, "\t\tname,\n")
	strings.write_string(&b, "\t)\n")
	strings.write_string(
		&b,
		"\tfunc := core.require_utility_function(core.const_static_string_name_ptr(&uf.name_data), hash)\n",
	)
	strings.write_string(&b, "\tuf.func = func\n")
	strings.write_string(&b, "\tuf.init = true\n")
	strings.write_string(&b, "}\n\n")

	// Group functions by category for readability
	count := 0
	for uf in root.utility_functions {
		if uf.is_vararg {continue}
		if skip_util_return[uf.return_type] {continue}
		has_skip := false
		for a in uf.arguments {
			if skip_util_arg[a.type] {has_skip = true; break}
		}
		if has_skip {continue}

		// Package-level var for lazy init
		var_name := fmt.aprintf("_%s", uf.name)
		fmt.sbprintf(&b, "@(private=\"file\")\n%s: _UtilFunc\n\n", var_name)

		returns_void := uf.return_type == "" || uf.return_type == "void"
		ret_type := "" if returns_void else resolve_return_type(uf.return_type)

		// Proc signature
		if returns_void {
			fmt.sbprintf(&b, "%s :: proc \"contextless\" (", uf.name)
		} else {
			fmt.sbprintf(&b, "%s :: proc \"contextless\" (", uf.name)
		}
		for a, j in uf.arguments {
			at := resolve_param_type(a.type)
			if j > 0 {strings.write_string(&b, ", ")}
			fmt.sbprintf(&b, "%s: %s", a.name, at)
		}
		if returns_void {
			fmt.sbprintf(&b, ") {{\n")
		} else {
			fmt.sbprintf(&b, ") -> %s {{\n", ret_type)
		}

		// Ensure + copy args
		fmt.sbprintf(
			&b,
			"\t_ensure_utility(&%s, cstring(\"%s\"), %d)\n",
			var_name,
			uf.name,
			uf.hash,
		)
		for a in uf.arguments {
			if a.type == "Variant" do continue
			fmt.sbprintf(&b, "\t_%s := %s\n", a.name, a.name)
		}

		// Call
		if returns_void {
			fmt.sbprintf(&b, "\tcore.call_utility_function_ptr_no_ret(%s.func", var_name)
		} else {
			fmt.sbprintf(
				&b,
				"\treturn core.call_utility_function_ptr_ret(%s.func, %s",
				var_name,
				ret_type,
			)
		}
		for a in uf.arguments {
			fmt.sbprintf(&b, ",\n\t\t%s", param_ptr_expr(a.name, a.type))
		}
		strings.write_string(&b, ")\n")
		strings.write_string(&b, "}\n\n")
		count += 1
	}

	err := os.write_entire_file(path, transmute([]byte)strings.to_string(b))
	if err != nil {
		fmt.eprintfln("ERROR: %v", err)
		return false
	}
	fmt.printfln("  %s  (%d utility functions)", path, count)
	return true
}


// ---------------------------------------------------------------------------
// Class handle codegen
// ---------------------------------------------------------------------------

selected_class_names := []string {
	"Object",
	"RefCounted",
	"Resource",
	"Node",
	"CanvasItem",
	"Node2D",
	"Control",
}

Selected_Class_Method :: struct {
	class_name:  string,
	method_name: string,
}

selected_class_methods := []Selected_Class_Method {
	{"Object", "get_class"},
	{"Object", "is_class"},
	{"Node", "get_parent"},
	{"Node", "is_ancestor_of"},
	{"Node", "get_path_to"},
	{"Node2D", "set_position"},
	{"Node2D", "get_position"},
	{"Node2D", "set_rotation"},
	{"Node2D", "get_rotation"},
}

is_selected_class :: proc(name: string) -> bool {
	for selected in selected_class_names {
		if selected == name do return true
	}
	return false
}

find_class :: proc(root: ^ExtensionApiRoot, name: string) -> (class: ExtensionApiClass, ok: bool) {
	for c in root.classes {
		if c.name == name do return c, true
	}
	return {}, false
}

find_class_method :: proc(
	class: ExtensionApiClass,
	name: string,
) -> (
	method: ExtensionApiClassMethod,
	ok: bool,
) {
	for m in class.methods {
		if m.name == name do return m, true
	}
	return {}, false
}

class_type_expr :: proc(class_name: string) -> string {
	if class_name == "Object" do return "core.Object"
	if class_name == "RefCounted" do return "core.RefCounted"
	return fmt.aprintf("distinct core.ObjectPtr")
}

class_handle_expr :: proc(class_name: string) -> string {
	if class_name == "Object" do return "core.Object"
	if class_name == "RefCounted" do return "core.RefCounted"
	return class_name
}

class_abi_type_map := map[string]string {
	"Nil"     = "rawptr",
	"bool"    = "bool",
	"int"     = "i64",
	"int32"   = "i32",
	"int64"   = "i64",
	"float"   = "core.GodotReal",
	"double"  = "f64",
	"Vector2" = "core.Vector2",
	"Vector3" = "core.Vector3",
	"Vector4" = "core.Vector4",
	"Color"   = "core.Color",
}

// Class method mapping rules:
// - Godot Object/class params and returns are borrowed handles by value.
// - Completed owned value params are borrowed pointers; returns are owned storage.
// - Variant params are borrowed pointers; Variant returns are owned storage.
// - Primitive and memory-compatible builtin values are passed by value.
resolve_class_return_type :: proc(godot_name: string) -> (odin_type: string, ok: bool) {
	if godot_name == "" || godot_name == "void" do return "", true
	if godot_name == "Variant" do return "core.Variant", true
	if entry, entry_ok := completed_core_value_entry(godot_name); entry_ok do return entry.odin, true
	if is_selected_class(godot_name) do return class_handle_expr(godot_name), true
	if t, map_ok := class_abi_type_map[godot_name]; map_ok do return t, true
	return "", false
}

resolve_class_param_type :: proc(godot_name: string) -> (odin_type: string, ok: bool) {
	if godot_name == "Variant" do return "^core.Variant", true
	if entry, entry_ok := completed_core_value_entry(godot_name); entry_ok {
		return fmt.aprintf("^%s", entry.odin), true
	}
	return resolve_class_return_type(godot_name)
}

class_param_ptr_expr :: proc(arg_name, godot_type: string) -> string {
	if godot_type == "Variant" do return fmt.aprintf("core.variant_ptr(%s)", arg_name)
	if entry, ok := completed_core_value_entry(godot_type); ok {
		return fmt.aprintf("%s(%s)", entry.ptr, arg_name)
	}
	return fmt.aprintf("cast(core.TypePtr)&_%s", arg_name)
}

class_method_supported :: proc(method: ExtensionApiClassMethod) -> bool {
	if method.is_vararg || method.is_virtual do return false
	if _, ok := resolve_class_return_type(method.return_value.type); !ok do return false
	for arg in method.arguments {
		if _, ok := resolve_class_param_type(arg.type); !ok do return false
	}
	return true
}

class_proc_prefix :: proc(class_name: string) -> string {
	b := strings.builder_make(context.temp_allocator)
	for r, i in class_name {
		if r >= 'A' && r <= 'Z' {
			if i > 0 {
				prev := class_name[i - 1]
				if prev >= 'a' && prev <= 'z' {
					strings.write_byte(&b, '_')
				}
			}
			strings.write_rune(&b, r + 32)
		} else {
			strings.write_rune(&b, r)
		}
	}
	return strings.to_string(b)
}

emit_class_upcast :: proc(b: ^strings.Builder, class: ExtensionApiClass, ancestor: string) {
	lower := class_proc_prefix(class.name)
	ancestor_lower := class_proc_prefix(ancestor)
	ancestor_type := class_handle_expr(ancestor)
	fmt.sbprintf(
		b,
		"%s_as_%s :: proc \"contextless\" (self: %s) -> %s {{\n",
		lower,
		ancestor_lower,
		class.name,
		ancestor_type,
	)
	fmt.sbprintf(b, "\treturn %s(self)\n", ancestor_type)
	strings.write_string(b, "}\n\n")
}

emit_class_binding_storage :: proc(b: ^strings.Builder, root: ^ExtensionApiRoot) -> bool {
	strings.write_string(b, "// ---- Binding initialization ----\n\n")
	strings.write_string(b, "class_bindings_initialized: bool\n\n")

	for name in selected_class_names {
		prefix := class_proc_prefix(name)
		fmt.sbprintf(b, "%s_class_name_data: core.StaticStringName\n", prefix)
	}
	strings.write_string(b, "\n")

	for entry in selected_class_methods {
		class, class_ok := find_class(root, entry.class_name)
		if !class_ok {
			fmt.eprintfln("ERROR: class %q missing from extension_api.json", entry.class_name)
			return false
		}
		method, method_ok := find_class_method(class, entry.method_name)
		if !method_ok {
			fmt.eprintfln(
				"ERROR: method %q.%q missing from extension_api.json",
				entry.class_name,
				entry.method_name,
			)
			return false
		}

		class_prefix := class_proc_prefix(entry.class_name)
		method_prefix := class_proc_prefix(entry.method_name)
		fmt.sbprintf(
			b,
			"%s_%s_method_name_data: core.StaticStringName\n",
			class_prefix,
			method_prefix,
		)
		fmt.sbprintf(
			b,
			"%s_%s_method_bind: core.MethodBindPtr // hash %d\n\n",
			class_prefix,
			method_prefix,
			method.hash,
		)
	}
	return true
}

emit_init_static_string_name :: proc(b: ^strings.Builder, storage_name, literal: string) {
	fmt.sbprintf(
		b,
		"\tcore.static_string_name_init_latin1_cstring(\n" +
		"\t\tcore.uninitialized_static_string_name_ptr(&%s),\n" +
		"\t\tcstring(\"%s\"),\n" +
		"\t)\n",
		storage_name,
		literal,
	)
}

emit_class_binding_init :: proc(b: ^strings.Builder, root: ^ExtensionApiRoot) -> bool {
	strings.write_string(b, "init_class_bindings :: proc \"contextless\" () {\n")
	strings.write_string(b, "\tif class_bindings_initialized do return\n\n")
	strings.write_string(b, "\tcore.init_class_casting()\n\n")

	for name in selected_class_names {
		prefix := class_proc_prefix(name)
		emit_init_static_string_name(b, fmt.aprintf("%s_class_name_data", prefix), name)
	}
	strings.write_string(b, "\n")

	for entry in selected_class_methods {
		class, class_ok := find_class(root, entry.class_name)
		if !class_ok do return false
		method, method_ok := find_class_method(class, entry.method_name)
		if !method_ok do return false

		class_prefix := class_proc_prefix(entry.class_name)
		method_prefix := class_proc_prefix(entry.method_name)
		method_name_storage := fmt.aprintf("%s_%s_method_name_data", class_prefix, method_prefix)
		emit_init_static_string_name(b, method_name_storage, entry.method_name)
		fmt.sbprintf(
			b,
			"\t%s_%s_method_bind = core.require_classdb_method_bind(\n" +
			"\t\tcore.const_static_string_name_ptr(&%s_class_name_data),\n" +
			"\t\tcore.const_static_string_name_ptr(&%s),\n" +
			"\t\t%d,\n" +
			"\t)\n",
			class_prefix,
			method_prefix,
			class_prefix,
			method_name_storage,
			method.hash,
		)
	}

	strings.write_string(b, "\n\tclass_bindings_initialized = true\n")
	strings.write_string(b, "}\n\n")
	return true
}

emit_class_method_wrappers :: proc(b: ^strings.Builder, root: ^ExtensionApiRoot) -> bool {
	strings.write_string(b, "// ---- Selected class methods ----\n\n")

	for entry in selected_class_methods {
		class, class_ok := find_class(root, entry.class_name)
		if !class_ok do return false
		method, method_ok := find_class_method(class, entry.method_name)
		if !method_ok do return false
		if !class_method_supported(method) {
			fmt.eprintfln(
				"ERROR: unsupported selected class method %s.%s",
				entry.class_name,
				entry.method_name,
			)
			return false
		}

		class_prefix := class_proc_prefix(entry.class_name)
		method_prefix := class_proc_prefix(entry.method_name)
		proc_name := fmt.aprintf("%s_%s", class_prefix, method_prefix)
		method_bind_name := fmt.aprintf("%s_%s_method_bind", class_prefix, method_prefix)
		self_type := class_handle_expr(entry.class_name)
		returns_void := method.return_value.type == "" || method.return_value.type == "void"
		ret_type := ""
		if !returns_void {
			resolved_ret, ret_ok := resolve_class_return_type(method.return_value.type)
			if !ret_ok do return false
			ret_type = resolved_ret
			if method.return_value.type == "Variant" {
				fmt.sbprintf(
					b,
					"// %s returns an initialized Variant; call core.variant_free when done.\n",
					proc_name,
				)
			} else if entry_value, entry_ok := completed_core_value_entry(
				method.return_value.type,
			); entry_ok {
				fmt.sbprintf(
					b,
					"// %s returns initialized %s storage; call %s when done.\n",
					proc_name,
					entry_value.godot,
					entry_value.free,
				)
			} else if is_selected_class(method.return_value.type) {
				fmt.sbprintf(
					b,
					"// %s returns a borrowed %s handle; do not free or unref it.\n",
					proc_name,
					method.return_value.type,
				)
			}
		}

		fmt.sbprintf(b, "%s :: proc \"contextless\" (self: %s", proc_name, self_type)
		for arg in method.arguments {
			param_type, param_ok := resolve_class_param_type(arg.type)
			if !param_ok do return false
			fmt.sbprintf(b, ", %s: %s", arg.name, param_type)
		}
		if returns_void {
			strings.write_string(b, ") {\n")
		} else {
			fmt.sbprintf(b, ") -> %s {{\n", ret_type)
		}

		for arg in method.arguments {
			if arg.type == "Variant" do continue
			if _, ok := completed_core_value_entry(arg.type); ok do continue
			fmt.sbprintf(b, "\t_%s := %s\n", arg.name, arg.name)
		}

		if returns_void {
			fmt.sbprintf(
				b,
				"\tcore.call_method_ptr_no_ret(%s, core.ObjectPtr(self)",
				method_bind_name,
			)
		} else {
			fmt.sbprintf(
				b,
				"\treturn core.call_method_ptr_ret(%s, %s, core.ObjectPtr(self)",
				method_bind_name,
				ret_type,
			)
		}
		for arg in method.arguments {
			fmt.sbprintf(b, ",\n\t\t%s", class_param_ptr_expr(arg.name, arg.type))
		}
		strings.write_string(b, ")\n")
		strings.write_string(b, "}\n\n")
	}

	return true
}

generate_class_bindings :: proc(root: ^ExtensionApiRoot) -> bool {
	path := "bindings/classes/classes.odin"

	b := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&b)

	strings.write_string(
		&b,
		"// bindings/classes/classes.odin -- selected Godot class handle bindings.\n",
	)
	strings.write_string(&b, "// Auto-generated from extension_api.json. DO NOT EDIT.\n\n")
	strings.write_string(&b, "package godot_bindings_classes\n\n")
	strings.write_string(&b, "import core \"godot:core\"\n\n")
	strings.write_string(
		&b,
		"// Generated class handles are borrowed views over Godot-owned objects.\n",
	)
	strings.write_string(&b, "// They do not own, retain, unref, or free the underlying object.\n")
	strings.write_string(
		&b,
		"// Class method object parameters and returns are borrowed handles by value.\n\n",
	)

	if !emit_class_binding_storage(&b, root) {return false}
	if !emit_class_binding_init(&b, root) {return false}

	selected := make(map[string]ExtensionApiClass, len(selected_class_names))
	defer delete(selected)
	for name in selected_class_names {
		class, ok := find_class(root, name)
		if !ok {
			fmt.eprintfln("ERROR: class %q missing from extension_api.json", name)
			return false
		}
		selected[name] = class
	}

	for name in selected_class_names {
		class := selected[name]
		fmt.sbprintf(
			&b,
			"// %s inherits %s.\n",
			class.name,
			class.inherits if len(class.inherits) > 0 else "<none>",
		)
		fmt.sbprintf(&b, "%s :: %s\n\n", class.name, class_type_expr(class.name))
	}

	for name in selected_class_names {
		class := selected[name]
		if class.name == "Object" do continue

		strings.write_string(&b, "// ---- ")
		strings.write_string(&b, class.name)
		strings.write_string(&b, " upcasts ----\n\n")

		ancestor := class.inherits
		for len(ancestor) > 0 {
			if is_selected_class(ancestor) {
				emit_class_upcast(&b, class, ancestor)
			}
			ancestor_class, ok := find_class(root, ancestor)
			if !ok do break
			ancestor = ancestor_class.inherits
		}
	}

	if !emit_class_method_wrappers(&b, root) {return false}

	err := os.write_entire_file(path, transmute([]byte)strings.to_string(b))
	if err != nil {
		fmt.eprintfln("ERROR: %v", err)
		return false
	}
	fmt.printfln("  %s  (%d class handles)", path, len(selected_class_names))
	return true
}

// ---------------------------------------------------------------------------
// Entry point -- called from main.odin for `--builtin` flag.
// ---------------------------------------------------------------------------

generate_builtin_bindings :: proc(json_path: string) -> bool {
	init_type_maps()

	data, err := os.read_entire_file_from_path(json_path, context.temp_allocator)
	if err != nil {
		fmt.eprintfln("ERROR: cannot read %s: %v", json_path, err)
		return false
	}

	root: ExtensionApiRoot
	uerr := json.unmarshal(data, &root)
	if uerr != nil {
		fmt.eprintfln("ERROR: failed to parse extension_api.json: %v", uerr)
		return false
	}

	// Build real struct member map from offset data (computed properties excluded).
	// Use the first build configuration only (matches the running Godot build).
	real_members := make(map[string][]ExtensionApiMemberOffsetEntry, 32)
	if len(root.builtin_class_member_offsets) > 0 {
		for c in root.builtin_class_member_offsets[0].classes {
			real_members[c.name] = c.members
		}
	}

	for class in root.builtin_classes {
		if !generate_one(class, real_members) {return false}
	}

	if !generate_utility_bindings(&root) {return false}
	if !generate_class_bindings(&root) {return false}

	return true
}
