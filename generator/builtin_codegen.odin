#+feature dynamic-literals
package bindgen

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

// JSON model for extension_api.json.

ExtensionApiRoot :: struct {
	builtin_classes:              []ExtensionApiBuiltinClass `json:"builtin_classes"`,
	classes:                      []ExtensionApiClass `json:"classes"`,
	singletons:                   []ExtensionApiSingleton `json:"singletons"`,
	utility_functions:            []ExtensionApiUtilityFunction `json:"utility_functions"`,
	global_enums:                 []ExtensionApiEnum `json:"global_enums"`,
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
	name:          string `json:"name"`,
	type:          string `json:"type"`,
	default_value: string `json:"default_value,omitempty"`,
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

// Type mapping. Members use native storage; methods use the Godot `float` ABI.

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
	if _, typed_array_ok := typed_array_element_type(godot_type); typed_array_ok {
		return fmt.aprintf("core.const_typed_array_ptr(%s)", arg_name)
	}
	if entry, ok := completed_core_value_entry(godot_type); ok {
		return fmt.aprintf("%s(%s)", entry.ptr, arg_name)
	}
	return fmt.aprintf("cast(core.TypePtr)&_%s", arg_name)
}


odin_identifier_reserved := map[string]bool {
	"auto_cast"   = true,
	"bit_field"   = true,
	"bit_set"     = true,
	"break"       = true,
	"case"        = true,
	"cast"        = true,
	"context"     = true,
	"continue"    = true,
	"defer"       = true,
	"distinct"    = true,
	"do"          = true,
	"dynamic"     = true,
	"else"        = true,
	"enum"        = true,
	"fallthrough" = true,
	"for"         = true,
	"foreign"     = true,
	"if"          = true,
	"import"      = true,
	"in"          = true,
	"map"         = true,
	"matrix"      = true,
	"not_in"      = true,
	"or_else"     = true,
	"or_return"   = true,
	"package"     = true,
	"proc"        = true,
	"return"      = true,
	"struct"      = true,
	"switch"      = true,
	"transmute"   = true,
	"typeid"      = true,
	"union"       = true,
	"using"       = true,
	"when"        = true,
	"where"       = true,
}

is_ident_alpha :: proc(ch: u8) -> bool {
	return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_'
}

is_ident_digit :: proc(ch: u8) -> bool {
	return ch >= '0' && ch <= '9'
}

is_ident_upper :: proc(ch: u8) -> bool {
	return ch >= 'A' && ch <= 'Z'
}

is_ident_lower :: proc(ch: u8) -> bool {
	return ch >= 'a' && ch <= 'z'
}

to_lower_ascii :: proc(ch: u8) -> u8 {
	if is_ident_upper(ch) do return ch + 32
	return ch
}

to_upper_ascii :: proc(ch: u8) -> u8 {
	if is_ident_lower(ch) do return ch - 32
	return ch
}

odin_safe_snake_identifier :: proc(name: string) -> string {
	b := strings.builder_make(context.temp_allocator)
	previous_underscore := false
	previous_was_lower_or_digit := false

	for ch in transmute([]u8)name {
		if is_ident_alpha(ch) || is_ident_digit(ch) {
			if is_ident_upper(ch) && previous_was_lower_or_digit && !previous_underscore {
				strings.write_byte(&b, '_')
			}
			strings.write_byte(&b, to_lower_ascii(ch))
			previous_underscore = false
			previous_was_lower_or_digit = is_ident_lower(ch) || is_ident_digit(ch)
		} else if !previous_underscore {
			strings.write_byte(&b, '_')
			previous_underscore = true
			previous_was_lower_or_digit = false
		}
	}

	result := strings.to_string(b)
	for len(result) > 0 && result[len(result) - 1] == '_' {
		result = result[:len(result) - 1]
	}
	if len(result) == 0 {
		result = "_"
	}
	if is_ident_digit(result[0]) {
		result = fmt.aprintf("_%s", result)
	}
	if odin_identifier_reserved[result] {
		result = fmt.aprintf("%s_", result)
	}
	return result
}

odin_safe_pascal_identifier :: proc(name: string) -> string {
	snake := odin_safe_snake_identifier(name)
	b := strings.builder_make(context.temp_allocator)
	capitalize_next := true
	for ch in transmute([]u8)snake {
		if ch == '_' {
			capitalize_next = true
			continue
		}
		out := ch
		if capitalize_next {
			out = to_upper_ascii(ch)
			capitalize_next = false
		}
		strings.write_byte(&b, out)
	}
	result := strings.to_string(b)
	if len(result) == 0 {
		result = "_"
	}
	if is_ident_digit(result[0]) {
		result = fmt.aprintf("_%s", result)
	}
	return result
}

class_enum_type_name :: proc(class_name, enum_name: string) -> string {
	return fmt.aprintf(
		"%s%s",
		odin_safe_pascal_identifier(class_name),
		odin_safe_pascal_identifier(enum_name),
	)
}

class_constant_name :: proc(class_name, constant_name: string) -> string {
	return fmt.aprintf(
		"%s_%s",
		odin_safe_snake_identifier(class_name),
		odin_safe_snake_identifier(constant_name),
	)
}

class_enum_value_name :: proc(value_name: string) -> string {
	return odin_safe_snake_identifier(value_name)
}

global_enum_type_map: map[string]string

init_global_enum_type_map :: proc(root: ^ExtensionApiRoot) {
	global_enum_type_map = make(map[string]string, len(root.global_enums))
	for enum_ in root.global_enums {
		global_enum_type_map[enum_.name] = odin_safe_pascal_identifier(enum_.name)
	}
}

// Variant enum names differ from JSON names, for example AABB -> .Aabb.

variant_enum_name_map := map[string]string {
	"Transform2D" = "Transform2d",
	"Transform3D" = "Transform3d",
	"AABB"        = "Aabb",
}

variant_enum_name :: proc(json_name: string) -> string {
	if n, ok := variant_enum_name_map[json_name]; ok {return n}
	return json_name
}

// Types skipped until their ownership or ABI rules are explicit.

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

// Constructor naming.

constructor_name :: proc(lower: string, index: i32, n_args: int) -> string {
	if index == 0 {return fmt.aprintf("%s_new", lower)}
	// Index 1 with 1 arg is typically a copy constructor; give it a name.
	// Other constructors get index-based names.
	return fmt.aprintf("%s_new%d", lower, index)
}

// Builtin emitters.

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
		if m.is_vararg {continue}

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

// Emit builtin constants as comments until constructor expressions are supported.
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

// Builtin class generation.

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

// Utility function generation.

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


// Class handle generation.

Max_Selected_Class_Count :: 24

selected_class_names := []string {
	"Object",
	"RefCounted",
	"Resource",
	"Node",
	"CanvasItem",
	"Node2D",
	"Control",
	"Sprite2D",
	"Label",
	"Timer",
	"CollisionObject2D",
	"Area2D",
	"PhysicsBody2D",
	"CharacterBody2D",
	"RigidBody2D",
	"StaticBody2D",
	"CollisionShape2D",
	"PackedScene",
	"ResourceLoader",
	"Input",
	"SceneTree",
}

candidate_class_names := []string {
	"CharacterBody2D",
	"PhysicsBody2D",
	"RigidBody2D",
	"StaticBody2D",
	"CollisionShape2D",
}

Selected_Class_Method :: struct {
	class_name:  string,
	method_name: string,
}

selected_class_methods := []Selected_Class_Method {
	{"Object", "get_class"},
	{"Object", "is_class"},
	{"Object", "set_meta"},
	{"Object", "get_meta"},
	{"RefCounted", "get_reference_count"},
	{"Resource", "get_path"},
	{"Resource", "get_rid"},
	{"Resource", "set_local_to_scene"},
	{"Resource", "is_local_to_scene"},
	{"Node", "get_parent"},
	{"Node", "get_tree"},
	{"Node", "set_name"},
	{"Node", "get_name"},
	{"Node", "has_node"},
	{"Node", "get_node_or_null"},
	{"Node", "get_child_count"},
	{"Node", "get_child"},
	{"Node", "is_inside_tree"},
	{"Node", "get_path"},
	{"Node", "is_ancestor_of"},
	{"Node", "get_path_to"},
	{"Node", "remove_from_group"},
	{"Node", "is_in_group"},
	{"Node", "set_process"},
	{"Node", "is_processing"},
	{"Node", "get_process_delta_time"},
	{"Node", "set_physics_process"},
	{"Node", "is_physics_processing"},
	{"Node", "get_physics_process_delta_time"},
	{"CanvasItem", "set_visible"},
	{"CanvasItem", "is_visible"},
	{"CanvasItem", "is_visible_in_tree"},
	{"CanvasItem", "show"},
	{"CanvasItem", "hide"},
	{"CanvasItem", "queue_redraw"},
	{"CanvasItem", "move_to_front"},
	{"CanvasItem", "set_as_top_level"},
	{"CanvasItem", "is_set_as_top_level"},
	{"CanvasItem", "set_light_mask"},
	{"CanvasItem", "get_light_mask"},
	{"CanvasItem", "set_modulate"},
	{"CanvasItem", "get_modulate"},
	{"CanvasItem", "set_self_modulate"},
	{"CanvasItem", "get_self_modulate"},
	{"CanvasItem", "set_z_index"},
	{"CanvasItem", "get_z_index"},
	{"CanvasItem", "set_z_as_relative"},
	{"CanvasItem", "is_z_relative"},
	{"CanvasItem", "set_y_sort_enabled"},
	{"CanvasItem", "is_y_sort_enabled"},
	{"CanvasItem", "set_draw_behind_parent"},
	{"CanvasItem", "is_draw_behind_parent_enabled"},
	{"CanvasItem", "get_canvas"},
	{"CanvasItem", "get_canvas_item"},
	{"CanvasItem", "draw_set_transform_matrix"},
	{"CanvasItem", "get_transform"},
	{"CanvasItem", "get_global_transform"},
	{"CanvasItem", "get_global_transform_with_canvas"},
	{"CanvasItem", "get_viewport_transform"},
	{"CanvasItem", "get_viewport_rect"},
	{"CanvasItem", "get_canvas_transform"},
	{"CanvasItem", "get_screen_transform"},
	{"CanvasItem", "get_local_mouse_position"},
	{"CanvasItem", "get_global_mouse_position"},
	{"Node2D", "set_position"},
	{"Node2D", "get_position"},
	{"Node2D", "set_rotation"},
	{"Node2D", "get_rotation"},
	{"Node2D", "set_rotation_degrees"},
	{"Node2D", "get_rotation_degrees"},
	{"Node2D", "set_skew"},
	{"Node2D", "get_skew"},
	{"Node2D", "set_scale"},
	{"Node2D", "get_scale"},
	{"Node2D", "rotate"},
	{"Node2D", "translate"},
	{"Node2D", "global_translate"},
	{"Node2D", "apply_scale"},
	{"Node2D", "set_global_position"},
	{"Node2D", "get_global_position"},
	{"Node2D", "set_global_rotation"},
	{"Node2D", "get_global_rotation"},
	{"Node2D", "set_global_scale"},
	{"Node2D", "get_global_scale"},
	{"Node2D", "set_transform"},
	{"Node2D", "set_global_transform"},
	{"Node2D", "look_at"},
	{"Node2D", "get_angle_to"},
	{"Node2D", "to_local"},
	{"Node2D", "to_global"},
	{"Node2D", "get_relative_transform_to_parent"},
	{"Control", "accept_event"},
	{"Control", "set_custom_minimum_size"},
	{"Control", "get_custom_minimum_size"},
	{"Control", "get_maximum_size"},
	{"Control", "get_combined_maximum_size"},
	{"Control", "get_minimum_size"},
	{"Control", "get_combined_minimum_size"},
	{"Control", "set_propagate_maximum_size"},
	{"Control", "is_propagating_maximum_size"},
	{"Control", "get_bound_minimum_size"},
	{"Control", "get_anchor"},
	{"Control", "set_offset"},
	{"Control", "get_offset"},
	{"Control", "set_begin"},
	{"Control", "set_end"},
	{"Control", "set_position"},
	{"Control", "set_size"},
	{"Control", "reset_size"},
	{"Control", "set_custom_maximum_size"},
	{"Control", "set_global_position"},
	{"Control", "set_rotation"},
	{"Control", "set_rotation_degrees"},
	{"Control", "set_scale"},
	{"Control", "set_pivot_offset"},
	{"Control", "get_begin"},
	{"Control", "get_end"},
	{"Control", "get_position"},
	{"Control", "get_size"},
	{"Control", "get_rotation"},
	{"Control", "get_rotation_degrees"},
	{"Control", "get_scale"},
	{"Control", "get_pivot_offset"},
	{"Control", "get_custom_maximum_size"},
	{"Control", "get_parent_area_size"},
	{"Control", "get_global_position"},
	{"Control", "get_screen_position"},
	{"Control", "get_rect"},
	{"Control", "get_global_rect"},
	{"Control", "set_focus_mode"},
	{"Control", "get_focus_mode"},
	{"Control", "has_focus"},
	{"Control", "grab_focus"},
	{"Control", "release_focus"},
	{"Control", "set_mouse_filter"},
	{"Control", "get_mouse_filter"},
	{"Sprite2D", "set_centered"},
	{"Sprite2D", "is_centered"},
	{"Sprite2D", "set_offset"},
	{"Sprite2D", "get_offset"},
	{"Sprite2D", "set_flip_h"},
	{"Sprite2D", "is_flipped_h"},
	{"Sprite2D", "set_flip_v"},
	{"Sprite2D", "is_flipped_v"},
	{"Sprite2D", "set_region_enabled"},
	{"Sprite2D", "is_region_enabled"},
	{"Sprite2D", "set_region_rect"},
	{"Sprite2D", "get_region_rect"},
	{"Sprite2D", "set_region_filter_clip_enabled"},
	{"Sprite2D", "is_region_filter_clip_enabled"},
	{"Sprite2D", "is_pixel_opaque"},
	{"Sprite2D", "set_frame"},
	{"Sprite2D", "get_frame"},
	{"Sprite2D", "set_vframes"},
	{"Sprite2D", "get_vframes"},
	{"Sprite2D", "set_hframes"},
	{"Sprite2D", "get_hframes"},
	{"Sprite2D", "set_frame_coords"},
	{"Sprite2D", "get_frame_coords"},
	{"Sprite2D", "get_rect"},
	{"Label", "set_text"},
	{"Label", "get_text"},
	{"Label", "set_clip_text"},
	{"Label", "is_clipping_text"},
	{"Label", "set_horizontal_alignment"},
	{"Label", "get_horizontal_alignment"},
	{"Label", "set_vertical_alignment"},
	{"Label", "get_vertical_alignment"},
	{"Label", "set_text_direction"},
	{"Label", "get_text_direction"},
	{"Label", "set_language"},
	{"Label", "get_language"},
	{"Label", "set_paragraph_separator"},
	{"Label", "get_paragraph_separator"},
	{"Label", "set_tab_stops"},
	{"Label", "get_tab_stops"},
	{"Label", "set_ellipsis_char"},
	{"Label", "get_ellipsis_char"},
	{"Label", "set_uppercase"},
	{"Label", "is_uppercase"},
	{"Label", "get_line_count"},
	{"Label", "get_visible_line_count"},
	{"Label", "get_total_character_count"},
	{"Label", "set_visible_characters"},
	{"Label", "get_visible_characters"},
	{"Label", "set_visible_ratio"},
	{"Label", "get_visible_ratio"},
	{"Label", "set_lines_skipped"},
	{"Label", "get_lines_skipped"},
	{"Label", "set_max_lines_visible"},
	{"Label", "get_max_lines_visible"},
	{"Label", "set_structured_text_bidi_override_options"},
	{"Label", "get_structured_text_bidi_override_options"},
	{"Label", "get_character_bounds"},
	{"Timer", "set_wait_time"},
	{"Timer", "get_wait_time"},
	{"Timer", "set_one_shot"},
	{"Timer", "is_one_shot"},
	{"Timer", "set_autostart"},
	{"Timer", "has_autostart"},
	{"Timer", "start"},
	{"Timer", "stop"},
	{"Timer", "set_paused"},
	{"Timer", "is_paused"},
	{"Timer", "set_ignore_time_scale"},
	{"Timer", "is_ignoring_time_scale"},
	{"Timer", "is_stopped"},
	{"Timer", "get_time_left"},
	{"CollisionObject2D", "get_rid"},
	{"CollisionObject2D", "set_collision_layer"},
	{"CollisionObject2D", "get_collision_layer"},
	{"CollisionObject2D", "set_collision_mask"},
	{"CollisionObject2D", "get_collision_mask"},
	{"CollisionObject2D", "set_collision_layer_value"},
	{"CollisionObject2D", "get_collision_layer_value"},
	{"CollisionObject2D", "set_collision_mask_value"},
	{"CollisionObject2D", "get_collision_mask_value"},
	{"CollisionObject2D", "set_collision_priority"},
	{"CollisionObject2D", "get_collision_priority"},
	{"CollisionObject2D", "set_disable_mode"},
	{"CollisionObject2D", "get_disable_mode"},
	{"CollisionObject2D", "set_pickable"},
	{"CollisionObject2D", "is_pickable"},
	{"Area2D", "set_gravity_space_override_mode"},
	{"Area2D", "get_gravity_space_override_mode"},
	{"Area2D", "set_gravity_is_point"},
	{"Area2D", "is_gravity_a_point"},
	{"Area2D", "set_gravity_point_unit_distance"},
	{"Area2D", "get_gravity_point_unit_distance"},
	{"Area2D", "set_gravity_point_center"},
	{"Area2D", "get_gravity_point_center"},
	{"Area2D", "set_gravity_direction"},
	{"Area2D", "get_gravity_direction"},
	{"Area2D", "set_gravity"},
	{"Area2D", "get_gravity"},
	{"Area2D", "set_linear_damp_space_override_mode"},
	{"Area2D", "get_linear_damp_space_override_mode"},
	{"Area2D", "set_angular_damp_space_override_mode"},
	{"Area2D", "get_angular_damp_space_override_mode"},
	{"Area2D", "set_linear_damp"},
	{"Area2D", "get_linear_damp"},
	{"Area2D", "set_angular_damp"},
	{"Area2D", "get_angular_damp"},
	{"Area2D", "set_priority"},
	{"Area2D", "get_priority"},
	{"Area2D", "set_monitoring"},
	{"Area2D", "is_monitoring"},
	{"Area2D", "set_monitorable"},
	{"Area2D", "is_monitorable"},
	{"Area2D", "has_overlapping_bodies"},
	{"Area2D", "has_overlapping_areas"},
	{"Area2D", "get_overlapping_bodies"},
	{"Area2D", "get_overlapping_areas"},
	{"Area2D", "set_audio_bus_name"},
	{"Area2D", "get_audio_bus_name"},
	{"Area2D", "set_audio_bus_override"},
	{"Area2D", "is_overriding_audio_bus"},
	{"PhysicsBody2D", "get_gravity"},
	{"PhysicsBody2D", "get_collision_exceptions"},
	{"PhysicsBody2D", "add_collision_exception_with"},
	{"PhysicsBody2D", "remove_collision_exception_with"},
	{"CharacterBody2D", "set_velocity"},
	{"CharacterBody2D", "get_velocity"},
	{"CharacterBody2D", "move_and_slide"},
	{"CharacterBody2D", "apply_floor_snap"},
	{"CharacterBody2D", "set_safe_margin"},
	{"CharacterBody2D", "get_safe_margin"},
	{"CharacterBody2D", "set_up_direction"},
	{"CharacterBody2D", "get_up_direction"},
	{"CharacterBody2D", "is_on_floor"},
	{"CharacterBody2D", "is_on_wall"},
	{"CharacterBody2D", "get_real_velocity"},
	{"RigidBody2D", "set_mass"},
	{"RigidBody2D", "get_mass"},
	{"RigidBody2D", "set_gravity_scale"},
	{"RigidBody2D", "get_gravity_scale"},
	{"RigidBody2D", "set_linear_velocity"},
	{"RigidBody2D", "get_linear_velocity"},
	{"RigidBody2D", "set_contact_monitor"},
	{"RigidBody2D", "is_contact_monitor_enabled"},
	{"RigidBody2D", "get_contact_count"},
	{"RigidBody2D", "apply_central_impulse"},
	{"RigidBody2D", "apply_central_force"},
	{"RigidBody2D", "get_colliding_bodies"},
	{"StaticBody2D", "set_constant_linear_velocity"},
	{"StaticBody2D", "get_constant_linear_velocity"},
	{"StaticBody2D", "set_constant_angular_velocity"},
	{"StaticBody2D", "get_constant_angular_velocity"},
	{"CollisionShape2D", "set_disabled"},
	{"CollisionShape2D", "is_disabled"},
	{"CollisionShape2D", "set_one_way_collision_direction"},
	{"CollisionShape2D", "get_one_way_collision_direction"},
	{"CollisionShape2D", "set_debug_color"},
	{"CollisionShape2D", "get_debug_color"},
	{"PackedScene", "pack"},
	{"PackedScene", "can_instantiate"},
	{"ResourceLoader", "exists"},
	{"Input", "is_anything_pressed"},
	{"Input", "is_action_pressed"},
	{"Input", "is_action_just_pressed"},
	{"Input", "is_action_just_released"},
	{"Input", "get_action_strength"},
	{"Input", "get_action_raw_strength"},
	{"Input", "get_axis"},
	{"Input", "get_vector"},
	{"Input", "get_last_mouse_velocity"},
	{"Input", "get_last_mouse_screen_velocity"},
	{"Input", "set_use_accumulated_input"},
	{"Input", "is_using_accumulated_input"},
	{"Input", "flush_buffered_events"},
	{"SceneTree", "has_group"},
	{"SceneTree", "is_accessibility_enabled"},
	{"SceneTree", "is_accessibility_supported"},
	{"SceneTree", "is_debugging_collisions_hint"},
	{"SceneTree", "is_debugging_paths_hint"},
	{"SceneTree", "is_debugging_navigation_hint"},
	{"SceneTree", "get_edited_scene_root"},
	{"SceneTree", "is_paused"},
	{"SceneTree", "get_node_count"},
	{"SceneTree", "get_frame"},
	{"SceneTree", "is_physics_interpolation_enabled"},
	{"SceneTree", "get_nodes_in_group"},
	{"SceneTree", "get_first_node_in_group"},
	{"SceneTree", "get_node_count_in_group"},
	{"SceneTree", "get_current_scene"},
	{"SceneTree", "is_multiplayer_poll_enabled"},
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

validate_selected_class_api :: proc(root: ^ExtensionApiRoot) -> bool {
	if len(selected_class_names) > Max_Selected_Class_Count {
		fmt.eprintfln(
			"ERROR: selected class batch has %d classes; keep batches at or below %d before broad generation",
			len(selected_class_names),
			Max_Selected_Class_Count,
		)
		return false
	}

	seen_classes := make(map[string]bool, len(selected_class_names))
	defer delete(seen_classes)
	for class_name in selected_class_names {
		if seen_classes[class_name] {
			fmt.eprintfln("ERROR: duplicate selected class %q", class_name)
			return false
		}
		seen_classes[class_name] = true
		if _, class_ok := find_class(root, class_name); !class_ok {
			fmt.eprintfln("ERROR: selected class %q missing from extension_api.json", class_name)
			return false
		}
	}

	seen_methods := make(map[string]bool, len(selected_class_methods))
	defer delete(seen_methods)
	seen_proc_names := make(map[string]bool, len(selected_class_methods))
	defer delete(seen_proc_names)
	for entry in selected_class_methods {
		if !seen_classes[entry.class_name] {
			fmt.eprintfln(
				"ERROR: selected method %s.%s uses a class outside selected_class_names",
				entry.class_name,
				entry.method_name,
			)
			return false
		}

		method_key := fmt.aprintf("%s.%s", entry.class_name, entry.method_name)
		if seen_methods[method_key] {
			fmt.eprintfln("ERROR: duplicate selected class method %s", method_key)
			return false
		}
		seen_methods[method_key] = true

		proc_name := fmt.aprintf(
			"%s_%s",
			class_proc_prefix(entry.class_name),
			class_proc_prefix(entry.method_name),
		)
		if seen_proc_names[proc_name] {
			fmt.eprintfln("ERROR: generated class method proc name collision: %s", proc_name)
			return false
		}
		seen_proc_names[proc_name] = true

		class, class_ok := find_class(root, entry.class_name)
		if !class_ok do return false
		method, method_ok := find_class_method(class, entry.method_name)
		if !method_ok {
			fmt.eprintfln(
				"ERROR: selected class method %s.%s missing from extension_api.json",
				entry.class_name,
				entry.method_name,
			)
			return false
		}
		if !class_method_supported(entry.class_name, method) {
			fmt.eprintfln(
				"ERROR: unsupported selected class method %s.%s: %s",
				entry.class_name,
				entry.method_name,
				class_method_skip_reason(entry.class_name, method),
			)
			return false
		}
	}

	return true
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


class_enum_type_from_godot :: proc(godot_name: string) -> (odin_type: string, ok: bool) {
	if !strings.has_prefix(godot_name, "enum::") do return "", false
	rest := strings.trim_prefix(godot_name, "enum::")
	if enum_type, enum_ok := global_enum_type_map[rest]; enum_ok do return enum_type, true
	parts := strings.split(rest, ".", context.temp_allocator)
	if len(parts) != 2 do return "", false
	if !is_selected_class(parts[0]) do return "", false
	return class_enum_type_name(parts[0], parts[1]), true
}

class_abi_type_map := map[string]string {
	"Nil"         = "rawptr",
	"bool"        = "bool",
	"int"         = "i64",
	"int32"       = "i32",
	"int64"       = "i64",
	"float"       = "core.GodotReal",
	"double"      = "f64",
	"Vector2"     = "core.Vector2",
	"Vector3"     = "core.Vector3",
	"Vector4"     = "core.Vector4",
	"Color"       = "core.Color",
	"Vector2i"    = "builtin.Vector2i",
	"Rect2"       = "builtin.Rect2",
	"Rect2i"      = "builtin.Rect2i",
	"Vector3i"    = "builtin.Vector3i",
	"Transform2D" = "builtin.Transform2D",
	"Vector4i"    = "builtin.Vector4i",
	"Plane"       = "builtin.Plane",
	"Quaternion"  = "builtin.Quaternion",
	"AABB"        = "builtin.AABB",
	"Basis"       = "builtin.Basis",
	"Transform3D" = "builtin.Transform3D",
	"Projection"  = "builtin.Projection",
}

// Class method mapping rules:
// - Godot Object/class params and returns are borrowed handles by value.
// - Completed owned value params are borrowed pointers; returns are owned storage.
// - Variant params are borrowed pointers; Variant returns are owned storage.
// - Primitive and memory-compatible builtin values are passed by value.
// - Typed array returns use owned core.TypedArray storage and explicit destruction.
// - Callable, Signal, varargs, typed dictionaries, and lifetime-sensitive APIs are deferred.
resolve_class_return_type :: proc(godot_name: string) -> (odin_type: string, ok: bool) {
	if godot_name == "" || godot_name == "void" do return "", true
	if enum_type, enum_ok := class_enum_type_from_godot(godot_name); enum_ok do return enum_type, true
	if godot_name == "Variant" do return "core.Variant", true
	if _, typed_array_ok := typed_array_element_type(godot_name); typed_array_ok {
		return "core.TypedArray", true
	}
	if entry, entry_ok := completed_core_value_entry(godot_name); entry_ok do return entry.odin, true
	if is_selected_class(godot_name) do return class_handle_expr(godot_name), true
	if t, map_ok := class_abi_type_map[godot_name]; map_ok do return t, true
	return "", false
}

resolve_class_param_type :: proc(godot_name: string) -> (odin_type: string, ok: bool) {
	if godot_name == "Variant" do return "^core.Variant", true
	if _, typed_array_ok := typed_array_element_type(godot_name); typed_array_ok {
		return "^core.TypedArray", true
	}
	if entry, entry_ok := completed_core_value_entry(godot_name); entry_ok {
		return fmt.aprintf("^%s", entry.odin), true
	}
	return resolve_class_return_type(godot_name)
}

class_param_ptr_expr :: proc(arg_name, godot_type: string) -> string {
	if godot_type == "Variant" do return fmt.aprintf("core.variant_ptr(%s)", arg_name)
	if _, typed_array_ok := typed_array_element_type(godot_type); typed_array_ok {
		return fmt.aprintf("core.const_typed_array_ptr(%s)", arg_name)
	}
	if entry, ok := completed_core_value_entry(godot_type); ok {
		return fmt.aprintf("%s(%s)", entry.ptr, arg_name)
	}
	return fmt.aprintf("cast(core.TypePtr)&_%s", arg_name)
}

typed_array_element_type :: proc(godot_name: string) -> (element_type: string, ok: bool) {
	prefix := "typedarray::"
	if strings.has_prefix(godot_name, prefix) do return godot_name[len(prefix):], true
	if strings.has_prefix(godot_name, "TypedArray") do return "unknown", true
	return "", false
}

typed_dictionary_element_type :: proc(godot_name: string) -> (element_type: string, ok: bool) {
	prefix := "typeddictionary::"
	if strings.has_prefix(godot_name, prefix) do return godot_name[len(prefix):], true
	if strings.has_prefix(godot_name, "TypedDictionary") do return "unknown", true
	return "", false
}

class_type_deferred_until_safety_model :: proc(godot_name: string) -> bool {
	if godot_name == "Callable" || godot_name == "Signal" do return true
	if _, ok := typed_dictionary_element_type(godot_name); ok do return true
	if strings.has_prefix(godot_name, "bitfield::") do return true
	return false
}

class_method_owned_wrapper_reason :: proc(class_name, method_name: string) -> string {
	if class_name == "RefCounted" &&
	   (method_name == "init_ref" || method_name == "reference" || method_name == "unreference") {
		return "owned RefCounted wrapper"
	}
	return ""
}

class_method_deferred_reason :: proc(class_name, method_name: string) -> string {
	if reason := class_method_owned_wrapper_reason(class_name, method_name); len(reason) > 0 {
		return reason
	}
	if class_name == "Control" && method_name == "force_drag" do return "object lifetime"
	if class_name == "Resource" &&
	   (method_name == "duplicate" || method_name == "duplicate_deep") {
		return "object lifetime"
	}
	if class_name == "PackedScene" &&
	   (method_name == "instantiate" || method_name == "get_state") {
		return "object lifetime"
	}
	if class_name == "ResourceLoader" {
		if method_name == "load" ||
		   method_name == "load_threaded_get" ||
		   method_name == "get_cached_ref" {
			return "resource ownership"
		}
	}
	if class_name == "Object" && (method_name == "set_script" || method_name == "get_script") {
		return "object lifetime"
	}
	return ""
}

class_method_deferred_until_safety_model :: proc(class_name, method_name: string) -> bool {
	return len(class_method_deferred_reason(class_name, method_name)) > 0
}

class_type_deferred_reason :: proc(godot_name: string) -> string {
	if godot_name == "Callable" do return "Callable"
	if godot_name == "Signal" do return "Signal"
	if element_type, ok := typed_dictionary_element_type(godot_name); ok {
		return fmt.aprintf("typed dictionary<%s>", element_type)
	}
	if strings.has_prefix(godot_name, "bitfield::") do return "bitfield"
	return ""
}


class_method_uses_typed_array :: proc(method: ExtensionApiClassMethod) -> bool {
	if _, ok := typed_array_element_type(method.return_value.type); ok do return true
	for arg in method.arguments {
		if _, ok := typed_array_element_type(arg.type); ok do return true
	}
	return false
}

class_method_uses_typed_dictionary :: proc(method: ExtensionApiClassMethod) -> bool {
	if _, ok := typed_dictionary_element_type(method.return_value.type); ok do return true
	for arg in method.arguments {
		if _, ok := typed_dictionary_element_type(arg.type); ok do return true
	}
	return false
}

class_method_uses_untyped_container :: proc(method: ExtensionApiClassMethod) -> bool {
	if method.return_value.type == "Array" || method.return_value.type == "Dictionary" do return true
	for arg in method.arguments {
		if arg.type == "Array" || arg.type == "Dictionary" do return true
	}
	return false
}

class_method_uses_callable_or_signal :: proc(method: ExtensionApiClassMethod) -> bool {
	if method.return_value.type == "Callable" || method.return_value.type == "Signal" do return true
	for arg in method.arguments {
		if arg.type == "Callable" || arg.type == "Signal" do return true
	}
	return false
}

class_method_selected :: proc(class_name, method_name: string) -> bool {
	for entry in selected_class_methods {
		if entry.class_name == class_name && entry.method_name == method_name do return true
	}
	return false
}

is_candidate_class :: proc(class_name: string) -> bool {
	for name in candidate_class_names {
		if name == class_name do return true
	}
	return false
}

resolve_candidate_class_return_type :: proc(godot_name: string) -> (odin_type: string, ok: bool) {
	if godot_name == "" || godot_name == "void" do return "", true
	if enum_type, enum_ok := class_enum_type_from_godot(godot_name); enum_ok do return enum_type, true
	if godot_name == "Variant" do return "core.Variant", true
	if _, typed_array_ok := typed_array_element_type(godot_name); typed_array_ok {
		return "core.TypedArray", true
	}
	if entry, entry_ok := completed_core_value_entry(godot_name); entry_ok do return entry.odin, true
	if is_selected_class(godot_name) || is_candidate_class(godot_name) {
		return class_handle_expr(godot_name), true
	}
	if t, map_ok := class_abi_type_map[godot_name]; map_ok do return t, true
	return "", false
}

resolve_candidate_class_param_type :: proc(godot_name: string) -> (odin_type: string, ok: bool) {
	if godot_name == "Variant" do return "^core.Variant", true
	if _, typed_array_ok := typed_array_element_type(godot_name); typed_array_ok {
		return "^core.TypedArray", true
	}
	if entry, entry_ok := completed_core_value_entry(godot_name); entry_ok {
		return fmt.aprintf("^%s", entry.odin), true
	}
	return resolve_candidate_class_return_type(godot_name)
}

class_method_candidate_skip_reason :: proc(
	class_name: string,
	method: ExtensionApiClassMethod,
) -> string {
	if method.is_vararg do return "vararg"
	if method.is_virtual do return "virtual"
	if reason := class_method_deferred_reason(class_name, method.name); len(reason) > 0 {
		return reason
	}
	if reason := class_type_deferred_reason(method.return_value.type); len(reason) > 0 {
		return fmt.aprintf("return type %s deferred: %s", method.return_value.type, reason)
	}
	if _, ok := resolve_candidate_class_return_type(method.return_value.type); !ok {
		return fmt.aprintf("unsupported return type %s", method.return_value.type)
	}
	for arg in method.arguments {
		if reason := class_type_deferred_reason(arg.type); len(reason) > 0 {
			return fmt.aprintf("argument %s type %s deferred: %s", arg.name, arg.type, reason)
		}
		if _, ok := resolve_candidate_class_param_type(arg.type); !ok {
			return fmt.aprintf("unsupported argument %s type %s", arg.name, arg.type)
		}
	}
	return ""
}

class_method_has_default_arguments :: proc(method: ExtensionApiClassMethod) -> bool {
	for arg in method.arguments {
		if len(arg.default_value) > 0 do return true
	}
	return false
}


class_method_trailing_default_count :: proc(method: ExtensionApiClassMethod) -> int {
	count := 0
	for i := len(method.arguments) - 1; i >= 0; i -= 1 {
		if len(method.arguments[i].default_value) == 0 do break
		count += 1
	}
	return count
}

class_method_has_non_trailing_default :: proc(method: ExtensionApiClassMethod) -> bool {
	seen_default := false
	for arg in method.arguments {
		has_default := len(arg.default_value) > 0
		if has_default {
			seen_default = true
		} else if seen_default {
			return true
		}
	}
	return false
}

is_integer_default_literal :: proc(value: string) -> bool {
	if len(value) == 0 do return false
	start := 0
	if value[0] == '-' || value[0] == '+' {
		if len(value) == 1 do return false
		start = 1
	}
	for ch in transmute([]u8)value[start:] {
		if ch < '0' || ch > '9' do return false
	}
	return true
}

is_real_default_literal :: proc(value: string) -> bool {
	if is_integer_default_literal(value) do return true
	if len(value) == 0 do return false
	start := 0
	if value[0] == '-' || value[0] == '+' {
		if len(value) == 1 do return false
		start = 1
	}
	digit_count := 0
	dot_count := 0
	for ch in transmute([]u8)value[start:] {
		if ch >= '0' && ch <= '9' {
			digit_count += 1
		} else if ch == '.' {
			dot_count += 1
			if dot_count > 1 do return false
		} else {
			return false
		}
	}
	return digit_count > 0
}

class_default_argument_supported :: proc(
	arg: ExtensionApiMethodArg,
) -> (
	ok: bool,
	reason: string,
) {
	value := arg.default_value
	if arg.type == "bool" {
		if value == "true" || value == "false" do return true, ""
		return false, "unsupported bool default"
	}
	if arg.type == "int" || arg.type == "int32" || arg.type == "int64" {
		if is_integer_default_literal(value) do return true, ""
		return false, "unsupported integer default"
	}
	if arg.type == "float" || arg.type == "double" {
		if is_real_default_literal(value) do return true, ""
		return false, "unsupported real default"
	}
	if arg.type == "String" && value == "\"\"" do return true, ""
	if is_selected_class(arg.type) && (value == "null" || value == "nil") do return true, ""
	return false, fmt.aprintf("unsupported default for %s", arg.type)
}

class_method_default_wrapper_supported :: proc(
	method: ExtensionApiClassMethod,
) -> (
	ok: bool,
	reason: string,
) {
	if !class_method_has_default_arguments(method) do return false, "no default arguments"
	if class_method_has_non_trailing_default(method) do return false, "non-trailing default argument"
	trailing_count := class_method_trailing_default_count(method)
	if trailing_count == 0 do return false, "no trailing default arguments"
	start := len(method.arguments) - trailing_count
	for arg in method.arguments[start:] {
		if arg_ok, arg_reason := class_default_argument_supported(arg); !arg_ok {
			return false, fmt.aprintf("%s %q", arg_reason, arg.default_value)
		}
	}
	return true, ""
}

class_method_default_report :: proc(method: ExtensionApiClassMethod) -> string {
	b := strings.builder_make(context.temp_allocator)
	first := true
	for arg in method.arguments {
		if len(arg.default_value) == 0 do continue
		if !first do strings.write_string(&b, ", ")
		fmt.sbprintf(&b, "%s: %s = %s", arg.name, arg.type, arg.default_value)
		first = false
	}
	return strings.to_string(b)
}

class_default_arg_ptr_expr :: proc(arg: ExtensionApiMethodArg) -> string {
	if arg.type == "String" do return fmt.aprintf("core.const_string_ptr(&_%s_default)", arg.name)
	return fmt.aprintf("cast(core.TypePtr)&_%s", arg.name)
}

class_default_arg_value_expr :: proc(arg: ExtensionApiMethodArg) -> string {
	if arg.type == "String" do return fmt.aprintf("&_%s_default", arg.name)
	return fmt.aprintf("_%s", arg.name)
}

emit_class_default_argument_local :: proc(
	b: ^strings.Builder,
	arg: ExtensionApiMethodArg,
) -> bool {
	value := arg.default_value
	if arg.type == "String" && value == "\"\"" {
		fmt.sbprintf(b, "\t_%s_default := core.string_from_utf8(\"\")\n", arg.name)
		fmt.sbprintf(b, "\tdefer core.string_free(&_%s_default)\n", arg.name)
		return true
	}
	param_type, param_ok := resolve_class_param_type(arg.type)
	if !param_ok do return false
	if is_selected_class(arg.type) && (value == "null" || value == "nil") {
		fmt.sbprintf(b, "\t_%s: %s\n", arg.name, param_type)
		return true
	}
	fmt.sbprintf(b, "\t_%s := %s(%s)\n", arg.name, param_type, value)
	return true
}

class_method_skip_reason :: proc(class_name: string, method: ExtensionApiClassMethod) -> string {
	if method.is_vararg do return "vararg"
	if method.is_virtual do return "virtual"
	if reason := class_method_deferred_reason(class_name, method.name); len(reason) > 0 {
		return reason
	}
	if reason := class_type_deferred_reason(method.return_value.type); len(reason) > 0 {
		return fmt.aprintf("return type %s deferred: %s", method.return_value.type, reason)
	}
	if _, ok := resolve_class_return_type(method.return_value.type); !ok {
		return fmt.aprintf("unsupported return type %s", method.return_value.type)
	}
	for arg in method.arguments {
		if reason := class_type_deferred_reason(arg.type); len(reason) > 0 {
			return fmt.aprintf("argument %s type %s deferred: %s", arg.name, arg.type, reason)
		}
		if _, ok := resolve_class_param_type(arg.type); !ok {
			return fmt.aprintf("unsupported argument %s type %s", arg.name, arg.type)
		}
	}
	if !class_method_selected(class_name, method.name) {
		if class_method_has_default_arguments(method) do return "default argument"
		return "not selected for current coverage slice"
	}
	return ""
}

class_method_supported :: proc(class_name: string, method: ExtensionApiClassMethod) -> bool {
	if method.is_vararg || method.is_virtual do return false
	if class_method_deferred_until_safety_model(class_name, method.name) do return false
	if class_type_deferred_until_safety_model(method.return_value.type) do return false
	if _, ok := resolve_class_return_type(method.return_value.type); !ok do return false
	for arg in method.arguments {
		if class_type_deferred_until_safety_model(arg.type) do return false
		if _, ok := resolve_class_param_type(arg.type); !ok do return false
	}
	return true
}


class_inherits_from :: proc(
	root: ^ExtensionApiRoot,
	class: ExtensionApiClass,
	ancestor_name: string,
) -> bool {
	ancestor := class.inherits
	for len(ancestor) > 0 {
		if ancestor == ancestor_name do return true
		ancestor_class, ok := find_class(root, ancestor)
		if !ok do break
		ancestor = ancestor_class.inherits
	}
	return false
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


emit_global_enums :: proc(b: ^strings.Builder, root: ^ExtensionApiRoot) {
	if len(root.global_enums) == 0 do return

	strings.write_string(b, "// ---- Global enums ----\n\n")
	strings.write_string(
		b,
		"// Global enum type names are Odin-safe versions of extension_api.json names.\n\n",
	)

	used_types := make(map[string]bool, len(root.global_enums))
	defer delete(used_types)
	for enum_ in root.global_enums {
		enum_type := odin_safe_pascal_identifier(enum_.name)
		if used_types[enum_type] do continue
		used_types[enum_type] = true

		fmt.sbprintf(b, "%s :: enum i64 {{\n", enum_type)
		used_values := make(map[string]bool, len(enum_.values))
		for value in enum_.values {
			value_name := class_enum_value_name(value.name)
			if used_values[value_name] {
				value_name = fmt.aprintf("%s_%d", value_name, value.value)
			}
			used_values[value_name] = true
			fmt.sbprintf(b, "\t%s = %d,\n", value_name, value.value)
		}
		delete(used_values)
		strings.write_string(b, "}\n\n")
	}
}

class_method_needs_builtin_import :: proc(root: ^ExtensionApiRoot) -> bool {
	for entry in selected_class_methods {
		class, class_ok := find_class(root, entry.class_name)
		if !class_ok do continue
		method, method_ok := find_class_method(class, entry.method_name)
		if !method_ok do continue

		if ret_type, ret_ok := resolve_class_return_type(method.return_value.type); ret_ok {
			if strings.has_prefix(ret_type, "builtin.") do return true
		}
		for arg in method.arguments {
			if param_type, param_ok := resolve_class_param_type(arg.type); param_ok {
				if strings.has_prefix(param_type, "builtin.") do return true
			}
		}
	}
	return false
}

emit_class_constants_and_enums :: proc(
	b: ^strings.Builder,
	selected: map[string]ExtensionApiClass,
) {
	strings.write_string(b, "// ---- Class enums and constants ----\n\n")
	strings.write_string(
		b,
		"// Constants are prefixed with the class name to avoid package-level collisions.\n",
	)
	strings.write_string(b, "// Enum values are scoped to their generated enum type.\n\n")

	for class_name in selected_class_names {
		class := selected[class_name]
		if len(class.enums) == 0 && len(class.constants) == 0 do continue

		fmt.sbprintf(b, "// %s\n\n", class.name)
		for enum_ in class.enums {
			enum_type := class_enum_type_name(class.name, enum_.name)
			fmt.sbprintf(b, "%s :: enum i64 {{\n", enum_type)
			used_values := make(map[string]bool, len(enum_.values))
			for value in enum_.values {
				value_name := class_enum_value_name(value.name)
				if used_values[value_name] {
					value_name = fmt.aprintf("%s_%d", value_name, value.value)
				}
				used_values[value_name] = true
				fmt.sbprintf(b, "\t%s = %d,\n", value_name, value.value)
			}
			delete(used_values)
			strings.write_string(b, "}\n\n")
		}

		used_constants := make(map[string]bool, len(class.constants))
		for constant in class.constants {
			constant_name := class_constant_name(class.name, constant.name)
			if used_constants[constant_name] {
				constant_name = fmt.aprintf("%s_%d", constant_name, constant.value)
			}
			used_constants[constant_name] = true
			fmt.sbprintf(b, "%s :: %d\n", constant_name, constant.value)
		}
		delete(used_constants)
		if len(class.constants) > 0 {
			strings.write_string(b, "\n")
		}
	}
}

emit_class_downcast :: proc(
	b: ^strings.Builder,
	source_name: string,
	source_type: string,
	target_name: string,
	target_type: string,
) {
	source_lower := class_proc_prefix(source_name)
	target_lower := class_proc_prefix(target_name)
	fmt.sbprintf(
		b,
		"%s_is_%s :: proc \"contextless\" (self: %s) -> bool {{\n",
		source_lower,
		target_lower,
		source_type,
	)
	strings.write_string(b, "\tif core.ObjectPtr(self) == nil {return false}\n")
	fmt.sbprintf(
		b,
		"\treturn core.is_class(core.ObjectPtr(self), core.static_string_name_ptr(&%s_class_name_data))\n",
		target_lower,
	)
	strings.write_string(b, "}\n\n")

	fmt.sbprintf(
		b,
		"%s_try_as_%s :: proc \"contextless\" (self: %s) -> (value: %s, ok: bool) {{\n",
		source_lower,
		target_lower,
		source_type,
		target_type,
	)
	fmt.sbprintf(
		b,
		"\treturn core.cast_to(core.ObjectPtr(self), core.static_string_name_ptr(&%s_class_name_data), %s)\n",
		target_lower,
		target_type,
	)
	strings.write_string(b, "}\n\n")
}

emit_class_downcasts :: proc(
	b: ^strings.Builder,
	root: ^ExtensionApiRoot,
	selected: map[string]ExtensionApiClass,
) {
	strings.write_string(b, "// ---- Checked downcasts and class identity helpers ----\n\n")
	strings.write_string(
		b,
		"// These helpers keep downcasts checked through Object.is_class/core.cast_to.\n",
	)
	strings.write_string(b, "// Nil objects always return ok=false for try_as helpers.\n\n")

	for source_name in selected_class_names {
		source_type := class_handle_expr(source_name)

		for target_name in selected_class_names {
			if source_name == target_name do continue
			target_class := selected[target_name]
			if !class_inherits_from(root, target_class, source_name) do continue

			emit_class_downcast(
				b,
				source_name,
				source_type,
				target_name,
				class_handle_expr(target_name),
			)
		}
	}
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


selected_singleton_for_class :: proc(
	root: ^ExtensionApiRoot,
	class_name: string,
) -> (
	name: string,
	ok: bool,
) {
	for singleton in root.singletons {
		if singleton.type == class_name do return singleton.name, true
	}
	return "", false
}

emit_selected_singleton_helpers :: proc(b: ^strings.Builder, root: ^ExtensionApiRoot) {
	strings.write_string(b, "// ---- Selected singleton helpers ----\n\n")
	strings.write_string(
		b,
		"// Singleton handles are borrowed Godot-owned objects; do not free or unref them.\n\n",
	)

	for class_name in selected_class_names {
		singleton_name, singleton_ok := selected_singleton_for_class(root, class_name)
		if !singleton_ok do continue

		prefix := class_proc_prefix(class_name)
		fmt.sbprintf(
			b,
			"%s_singleton_checked :: proc \"contextless\" () -> (value: %s, ok: bool) {{\n",
			prefix,
			class_handle_expr(class_name),
		)
		strings.write_string(b, "\tinit_class_bindings()\n")
		fmt.sbprintf(
			b,
			"\tobject, object_ok := core.global_get_singleton_checked(core.const_static_string_name_ptr(&%s_class_name_data))\n",
			prefix,
		)
		strings.write_string(b, "\tif !object_ok do return {}, false\n")
		fmt.sbprintf(b, "\treturn object_try_as_%s(core.Object(object))\n", prefix)
		strings.write_string(b, "}\n\n")
		_ = singleton_name
	}
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

emit_class_method_report_signature :: proc(
	b: ^strings.Builder,
	class_name: string,
	method: ExtensionApiClassMethod,
) {
	fmt.sbprintf(b, "`%s.%s(", class_name, method.name)
	for arg, index in method.arguments {
		if index > 0 do strings.write_string(b, ", ")
		fmt.sbprintf(b, "%s: %s", arg.name, arg.type)
		if len(arg.default_value) > 0 {
			fmt.sbprintf(b, " = %s", arg.default_value)
		}
	}
	return_type := method.return_value.type
	if len(return_type) == 0 do return_type = "void"
	fmt.sbprintf(b, ") -> %s`", return_type)
}

generate_class_api_report :: proc(root: ^ExtensionApiRoot) -> bool {
	path := "bindings/classes/api_report.md"

	generated := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&generated)
	owned_wrapper := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&owned_wrapper)
	skipped := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&skipped)
	signal_callable_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&signal_callable_blockers)
	typed_array_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&typed_array_blockers)
	typed_dictionary_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&typed_dictionary_blockers)
	untyped_container_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&untyped_container_blockers)
	default_argument_wrappers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&default_argument_wrappers)
	default_argument_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&default_argument_blockers)
	candidate_analysis := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&candidate_analysis)
	singleton_report := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&singleton_report)
	input_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&input_blockers)
	scene_tree_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&scene_tree_blockers)
	resource_loading_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&resource_loading_blockers)
	scene_instantiation_blockers := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&scene_instantiation_blockers)

	generated_count := 0
	owned_wrapper_count := 0
	skipped_count := 0
	signal_callable_blocker_count := 0
	typed_array_blocker_count := 0
	typed_dictionary_blocker_count := 0
	untyped_container_blocker_count := 0
	default_argument_wrapper_count := 0
	default_argument_blocker_count := 0
	candidate_safe_count := 0
	candidate_owned_wrapper_count := 0
	candidate_skipped_count := 0
	singleton_count := 0
	input_blocker_count := 0
	scene_tree_blocker_count := 0
	resource_loading_blocker_count := 0
	scene_instantiation_blocker_count := 0

	for class_name in selected_class_names {
		if singleton_name, singleton_ok := selected_singleton_for_class(root, class_name);
		   singleton_ok {
			fmt.sbprintf(
				&singleton_report,
				"- `%s` singleton returns borrowed `%s` handles.\n",
				singleton_name,
				class_name,
			)
			singleton_count += 1
		}
	}

	for class_name in selected_class_names {
		class, class_ok := find_class(root, class_name)
		if !class_ok {
			fmt.eprintfln("ERROR: class %q missing from extension_api.json", class_name)
			return false
		}

		for method in class.methods {
			reason := class_method_skip_reason(class.name, method)
			if len(reason) == 0 {
				strings.write_string(&generated, "- ")
				emit_class_method_report_signature(&generated, class.name, method)
				strings.write_byte(&generated, '\n')
				generated_count += 1
				if class_method_has_default_arguments(method) {
					if default_ok, default_reason := class_method_default_wrapper_supported(
						method,
					); default_ok {
						strings.write_string(&default_argument_wrappers, "- ")
						emit_class_method_report_signature(
							&default_argument_wrappers,
							class.name,
							method,
						)
						fmt.sbprintf(
							&default_argument_wrappers,
							": convenience wrapper for %s\n",
							class_method_default_report(method),
						)
						default_argument_wrapper_count += 1
					} else {
						strings.write_string(&default_argument_blockers, "- ")
						emit_class_method_report_signature(
							&default_argument_blockers,
							class.name,
							method,
						)
						fmt.sbprintf(
							&default_argument_blockers,
							": selected explicit wrapper only, %s, defaults: %s\n",
							default_reason,
							class_method_default_report(method),
						)
						default_argument_blocker_count += 1
					}
				}
			} else if reason == class_method_owned_wrapper_reason(class.name, method.name) {
				strings.write_string(&owned_wrapper, "- ")
				emit_class_method_report_signature(&owned_wrapper, class.name, method)
				fmt.sbprintf(&owned_wrapper, ": %s\n", reason)
				owned_wrapper_count += 1
			} else {
				strings.write_string(&skipped, "- ")
				emit_class_method_report_signature(&skipped, class.name, method)
				fmt.sbprintf(&skipped, ": %s\n", reason)
				skipped_count += 1
				if class_method_has_default_arguments(method) {
					strings.write_string(&default_argument_blockers, "- ")
					emit_class_method_report_signature(
						&default_argument_blockers,
						class.name,
						method,
					)
					fmt.sbprintf(
						&default_argument_blockers,
						": %s, defaults: %s\n",
						reason,
						class_method_default_report(method),
					)
					default_argument_blocker_count += 1
				}
				if class_method_uses_callable_or_signal(method) {
					strings.write_string(&signal_callable_blockers, "- ")
					emit_class_method_report_signature(
						&signal_callable_blockers,
						class.name,
						method,
					)
					fmt.sbprintf(&signal_callable_blockers, ": %s\n", reason)
					signal_callable_blocker_count += 1
				}
				if class.name == "Input" {
					strings.write_string(&input_blockers, "- ")
					emit_class_method_report_signature(&input_blockers, class.name, method)
					fmt.sbprintf(&input_blockers, ": %s\n", reason)
					input_blocker_count += 1
				} else if class.name == "SceneTree" {
					strings.write_string(&scene_tree_blockers, "- ")
					emit_class_method_report_signature(&scene_tree_blockers, class.name, method)
					fmt.sbprintf(&scene_tree_blockers, ": %s\n", reason)
					scene_tree_blocker_count += 1
				} else if class.name == "ResourceLoader" {
					strings.write_string(&resource_loading_blockers, "- ")
					emit_class_method_report_signature(
						&resource_loading_blockers,
						class.name,
						method,
					)
					fmt.sbprintf(&resource_loading_blockers, ": %s\n", reason)
					resource_loading_blocker_count += 1
				} else if class.name == "PackedScene" &&
				   (method.name == "instantiate" || method.name == "get_state") {
					strings.write_string(&scene_instantiation_blockers, "- ")
					emit_class_method_report_signature(
						&scene_instantiation_blockers,
						class.name,
						method,
					)
					fmt.sbprintf(&scene_instantiation_blockers, ": %s\n", reason)
					scene_instantiation_blocker_count += 1
				}
			}
		}
	}

	for class_name in candidate_class_names {
		class, class_ok := find_class(root, class_name)
		if !class_ok {
			fmt.eprintfln("ERROR: candidate class %q missing from extension_api.json", class_name)
			return false
		}

		fmt.sbprintf(&candidate_analysis, "### %s\n\n", class.name)
		for method in class.methods {
			reason := class_method_candidate_skip_reason(class.name, method)
			strings.write_string(&candidate_analysis, "- ")
			emit_class_method_report_signature(&candidate_analysis, class.name, method)
			if len(reason) == 0 {
				if class_method_has_default_arguments(method) {
					strings.write_string(
						&candidate_analysis,
						": borrowed-safe candidate, explicit default arguments required\n",
					)
					strings.write_string(&default_argument_blockers, "- candidate ")
					emit_class_method_report_signature(
						&default_argument_blockers,
						class.name,
						method,
					)
					fmt.sbprintf(
						&default_argument_blockers,
						": candidate not selected, defaults: %s\n",
						class_method_default_report(method),
					)
					default_argument_blocker_count += 1
				} else {
					strings.write_string(&candidate_analysis, ": borrowed-safe candidate\n")
				}
				candidate_safe_count += 1
			} else if reason == class_method_owned_wrapper_reason(class.name, method.name) {
				fmt.sbprintf(&candidate_analysis, ": owned-wrapper method, %s\n", reason)
				candidate_owned_wrapper_count += 1
			} else {
				fmt.sbprintf(&candidate_analysis, ": skipped, %s\n", reason)
				candidate_skipped_count += 1
				if class_method_uses_callable_or_signal(method) {
					strings.write_string(&signal_callable_blockers, "- candidate ")
					emit_class_method_report_signature(
						&signal_callable_blockers,
						class.name,
						method,
					)
					fmt.sbprintf(&signal_callable_blockers, ": %s\n", reason)
					signal_callable_blocker_count += 1
				}
			}
		}
		strings.write_byte(&candidate_analysis, '\n')
	}

	b := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&b)

	strings.write_string(&b, "# Generated class API support report\n\n")
	strings.write_string(&b, "Generated from `extension_api.json`. DO NOT EDIT.\n\n")
	strings.write_string(
		&b,
		"This report covers the selected generated class slice and the next candidate gameplay classes.\n\n",
	)
	strings.write_string(
		&b,
		"Borrowed-safe methods are generated as class wrappers. Owned-wrapper methods are intentionally routed through explicit facade helpers instead. Candidate borrowed-safe methods are not generated until they are added to the selected class batch.\n\n",
	)
	strings.write_string(&b, "## Summary\n\n")
	fmt.sbprintf(&b, "- Selected classes: %d\n", len(selected_class_names))
	fmt.sbprintf(&b, "- Selected singleton classes: %d\n", singleton_count)
	fmt.sbprintf(&b, "- Candidate classes: %d\n", len(candidate_class_names))
	fmt.sbprintf(&b, "- Borrowed-safe generated methods: %d\n", generated_count)
	fmt.sbprintf(&b, "- Owned-wrapper methods: %d\n", owned_wrapper_count)
	fmt.sbprintf(&b, "- Skipped selected-class methods: %d\n", skipped_count)
	fmt.sbprintf(&b, "- Callable/Signal blockers: %d\n", signal_callable_blocker_count)
	fmt.sbprintf(&b, "- Typed array blockers: %d\n", typed_array_blocker_count)
	fmt.sbprintf(&b, "- Typed dictionary blockers: %d\n", typed_dictionary_blocker_count)
	fmt.sbprintf(&b, "- Untyped container blockers: %d\n", untyped_container_blocker_count)
	fmt.sbprintf(
		&b,
		"- Default-argument convenience wrappers: %d\n",
		default_argument_wrapper_count,
	)
	fmt.sbprintf(&b, "- Default-argument blockers: %d\n", default_argument_blocker_count)
	fmt.sbprintf(&b, "- Input blockers: %d\n", input_blocker_count)
	fmt.sbprintf(&b, "- SceneTree blockers: %d\n", scene_tree_blocker_count)
	fmt.sbprintf(&b, "- Resource-loading blockers: %d\n", resource_loading_blocker_count)
	fmt.sbprintf(&b, "- Scene-instantiation blockers: %d\n", scene_instantiation_blocker_count)
	fmt.sbprintf(&b, "- Borrowed-safe candidate methods: %d\n", candidate_safe_count)
	fmt.sbprintf(&b, "- Owned-wrapper candidate methods: %d\n", candidate_owned_wrapper_count)
	fmt.sbprintf(&b, "- Skipped candidate methods: %d\n\n", candidate_skipped_count)
	strings.write_string(&b, "## Selected singleton helpers\n\n")
	strings.write_string(&b, strings.to_string(singleton_report))
	strings.write_string(&b, "\n## Borrowed-safe generated methods\n\n")
	strings.write_string(&b, strings.to_string(generated))
	strings.write_string(&b, "\n## Owned-wrapper methods\n\n")
	strings.write_string(&b, strings.to_string(owned_wrapper))
	strings.write_string(&b, "\n## Skipped selected-class methods\n\n")
	strings.write_string(&b, strings.to_string(skipped))
	strings.write_string(&b, "\n## Callable and Signal blockers\n\n")
	strings.write_string(&b, strings.to_string(signal_callable_blockers))
	strings.write_string(&b, "\n## Typed array blockers\n\n")
	strings.write_string(&b, strings.to_string(typed_array_blockers))
	strings.write_string(&b, "\n## Typed dictionary blockers\n\n")
	strings.write_string(&b, strings.to_string(typed_dictionary_blockers))
	strings.write_string(&b, "\n## Untyped container blockers\n\n")
	strings.write_string(&b, strings.to_string(untyped_container_blockers))
	strings.write_string(&b, "\n## Default-argument convenience wrappers\n\n")
	strings.write_string(&b, strings.to_string(default_argument_wrappers))
	strings.write_string(&b, "\n## Default-argument blockers\n\n")
	strings.write_string(&b, strings.to_string(default_argument_blockers))
	strings.write_string(&b, "\n## Input blockers\n\n")
	strings.write_string(&b, strings.to_string(input_blockers))
	strings.write_string(&b, "\n## SceneTree blockers\n\n")
	strings.write_string(&b, strings.to_string(scene_tree_blockers))
	strings.write_string(&b, "\n## Resource-loading blockers\n\n")
	strings.write_string(&b, strings.to_string(resource_loading_blockers))
	strings.write_string(&b, "\n## Scene-instantiation blockers\n\n")
	strings.write_string(&b, strings.to_string(scene_instantiation_blockers))
	strings.write_string(&b, "\n## Candidate class analysis\n\n")
	strings.write_string(&b, strings.to_string(candidate_analysis))

	err := os.write_entire_file(path, transmute([]byte)strings.to_string(b))
	if err != nil {
		fmt.eprintfln("ERROR: %v", err)
		return false
	}
	fmt.printfln(
		"  %s  (%d generated, %d default wrappers, %d owned-wrapper, %d skipped, %d candidate-safe class methods)",
		path,
		generated_count,
		default_argument_wrapper_count,
		owned_wrapper_count,
		skipped_count,
		candidate_safe_count,
	)
	return true
}


emit_class_method_default_wrapper :: proc(
	b: ^strings.Builder,
	method: ExtensionApiClassMethod,
	proc_name: string,
	self_type: string,
	ret_type: string,
	returns_void: bool,
) -> bool {
	default_ok, _ := class_method_default_wrapper_supported(method)
	if !default_ok do return true

	default_count := class_method_trailing_default_count(method)
	explicit_count := len(method.arguments) - default_count
	wrapper_name := fmt.aprintf("%s_default", proc_name)

	strings.write_string(
		b,
		"// Convenience wrapper using supported trailing defaults; full-arity wrapper remains canonical.\n",
	)
	if !returns_void {
		fmt.sbprintf(b, "// %s returns the same ownership as %s.\n", wrapper_name, proc_name)
	}
	fmt.sbprintf(b, "%s :: proc \"contextless\" (self: %s", wrapper_name, self_type)
	for arg in method.arguments[:explicit_count] {
		param_type, param_ok := resolve_class_param_type(arg.type)
		if !param_ok do return false
		fmt.sbprintf(b, ", %s: %s", arg.name, param_type)
	}
	if returns_void {
		strings.write_string(b, ") {\n")
	} else {
		fmt.sbprintf(b, ") -> %s {{\n", ret_type)
	}

	for arg in method.arguments[explicit_count:] {
		if !emit_class_default_argument_local(b, arg) do return false
	}

	if returns_void {
		fmt.sbprintf(b, "\t%s(self", proc_name)
	} else {
		fmt.sbprintf(b, "\treturn %s(self", proc_name)
	}
	for arg in method.arguments[:explicit_count] {
		fmt.sbprintf(b, ", %s", arg.name)
	}
	for arg in method.arguments[explicit_count:] {
		fmt.sbprintf(b, ", %s", class_default_arg_value_expr(arg))
	}
	strings.write_string(b, ")\n")
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
		if !class_method_supported(entry.class_name, method) {
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
			} else if _, typed_array_ok := typed_array_element_type(method.return_value.type);
			   typed_array_ok {
				fmt.sbprintf(
					b,
					"// %s returns initialized TypedArray storage; call core.typed_array_free when done.\n",
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

		if !emit_class_method_default_wrapper(
			b,
			method,
			proc_name,
			self_type,
			ret_type,
			returns_void,
		) {
			return false
		}
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
	if class_method_needs_builtin_import(root) {
		strings.write_string(&b, "import builtin \"godot:bindings/builtin\"\n")
	}
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

	emit_class_downcasts(&b, root, selected)
	emit_selected_singleton_helpers(&b, root)
	emit_global_enums(&b, root)
	emit_class_constants_and_enums(&b, selected)

	strings.write_string(
		&b,
		"// Callable, Signal, varargs, typed arrays, owned-wrapper-only methods, and lifetime-sensitive APIs are not generated here.\n\n",
	)

	if !emit_class_method_wrappers(&b, root) {return false}

	err := os.write_entire_file(path, transmute([]byte)strings.to_string(b))
	if err != nil {
		fmt.eprintfln("ERROR: %v", err)
		return false
	}
	fmt.printfln("  %s  (%d class handles)", path, len(selected_class_names))
	return true
}

// Entry point for the --builtin generation path.

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
	init_global_enum_type_map(&root)
	if !validate_selected_class_api(&root) {return false}

	// Use member offsets from the first build configuration, matching the running Godot build.
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
	if !generate_class_api_report(&root) {return false}
	if !generate_class_bindings(&root) {return false}

	return true
}
