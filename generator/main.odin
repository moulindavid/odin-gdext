#+feature dynamic-literals
package bindgen

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

// ---------------------------------------------------------------------------
// JSON model structs -- mirror gdextension_interface.json schema
// ---------------------------------------------------------------------------

Header :: struct {
	_copyright:     []string `json:"_copyright"`,
	format_version: u32 `json:"format_version"`,
	types:          []HeaderType `json:"types"`,
	interface:      []HeaderInterfaceFunction `json:"interface"`,
}

HeaderType :: struct {
	name:         string `json:"name"`,
	kind:         string `json:"kind"`,
	description:  []string `json:"description,omitempty"`,
	since:        string `json:"since,omitempty"`,
	deprecated:   HeaderDeprecated `json:"deprecated,omitempty"`,
	is_bitfield:  bool `json:"is_bitfield,omitempty"`,
	values:       []HeaderEnumValue `json:"values,omitempty"`,
	parent:       string `json:"parent,omitempty"`,
	is_const:     bool `json:"is_const,omitempty"`,
	alias_type:   string `json:"type,omitempty"`,
	members:      []HeaderStructMember `json:"members,omitempty"`,
	return_value: HeaderReturnValue `json:"return_value,omitempty"`,
	arguments:    []HeaderArgument `json:"arguments,omitempty"`,
}

HeaderDeprecated :: struct {
	since:        string `json:"since"`,
	replace_with: string `json:"replace_with,omitempty"`,
}

HeaderEnumValue :: struct {
	name:        string `json:"name"`,
	value:       i64 `json:"value"`,
	description: []string `json:"description,omitempty"`,
}

HeaderStructMember :: struct {
	name:        string `json:"name"`,
	type:        string `json:"type"`,
	description: []string `json:"description,omitempty"`,
}

HeaderReturnValue :: struct {
	type:        string `json:"type"`,
	description: []string `json:"description,omitempty"`,
}

HeaderArgument :: struct {
	name:        string `json:"name,omitempty"`,
	type:        string `json:"type"`,
	description: []string `json:"description,omitempty"`,
}

HeaderInterfaceFunction :: struct {
	name:         string `json:"name"`,
	description:  []string `json:"description,omitempty"`,
	since:        string `json:"since,omitempty"`,
	deprecated:   HeaderDeprecated `json:"deprecated,omitempty"`,
	return_value: HeaderReturnValue `json:"return_value,omitempty"`,
	arguments:    []HeaderArgument `json:"arguments,omitempty"`,
}

// ---------------------------------------------------------------------------
// Output file paths
// ---------------------------------------------------------------------------

OUT_INTERFACE_DEFS :: "core/interface_defs.odin"
OUT_INTERFACE :: "core/interface.odin"

// ---------------------------------------------------------------------------
// C type → Odin type mapping
// ---------------------------------------------------------------------------

map_c_type :: proc(c_type: string, defined: ^map[string]bool) -> string {
	if c_type == "" {return "rawptr"}

	switch c_type {
	case "void":
		return "rawptr"
	case "GDExtensionInt":
		return "i64"
	case "GDExtensionBool":
		return "bool"
	case "GDObjectInstanceID":
		return "u64"
	case "int8_t":
		return "i8"
	case "int16_t":
		return "i16"
	case "int32_t":
		return "i32"
	case "int64_t":
		return "i64"
	case "uint8_t":
		return "u8"
	case "uint16_t":
		return "u16"
	case "uint32_t":
		return "u32"
	case "uint64_t":
		return "u64"
	case "float":
		return "f32"
	case "double":
		return "f64"
	case "size_t":
		return "c.size_t"
	case "char":
		return "c.char"
	case "char16_t":
		return "u16"
	case "char32_t":
		return "u32"
	case "wchar_t":
		return "c.wchar_t"
	}

	is_const := strings.has_prefix(c_type, "const ")
	core := c_type if !is_const else strings.trim_prefix(c_type, "const ")

	if is_const && core == "char*" {return "cstring"}
	if core == "void*" {return "rawptr"}

	switch core {
	case "char*", "uint8_t*":
		return "[^]u8"
	case "char16_t*":
		return "[^]u16"
	case "char32_t*":
		return "[^]u32"
	case "wchar_t*":
		return "[^]c.wchar_t"
	case "GDExtensionConstTypePtr*",
	     "GDExtensionTypePtr*",
	     "GDExtensionConstVariantPtr*",
	     "GDExtensionVariantPtr*":
		base := core[:len(core) - 1]
		return fmt.aprintf("[^]%s", base)
	}

	if strings.has_suffix(core, "*") {
		base := strings.trim_space(strings.trim_suffix(core, "*"))
		if base == "void" {return "rawptr"}
		if defined[base] {return fmt.aprintf("^%s", base)}
		return "rawptr"
	}

	if defined[core] {return core}

	fmt.eprintfln("WARNING: unknown C type %q → rawptr", c_type)
	return "rawptr"
}

// ---------------------------------------------------------------------------
// Name conversion helpers
// ---------------------------------------------------------------------------

to_pascal :: proc(snake: string) -> string {
	b := strings.builder_make(context.temp_allocator)
	up := true
	for r in snake {
		if r == '_' {up = true; continue}
		if up && r >= 'a' && r <= 'z' {
			strings.write_rune(&b, r - 32) // uppercase
			up = false
		} else {
			strings.write_rune(&b, r)
			up = false
		}
	}
	return strings.to_string(b)
}

strip_enum_prefix :: proc(enum_name, value: string) -> string {
	if enum_name == "GDExtensionInitializationLevel" {
		if value == "GDEXTENSION_MAX_INITIALIZATION_LEVEL" {return "Max"}
	}

	prefixes := map[string][]string {
		"GDExtensionVariantType"                 = {"GDEXTENSION_VARIANT_TYPE_"},
		"GDExtensionVariantOperator"             = {"GDEXTENSION_VARIANT_OP_"},
		"GDExtensionCallErrorType"               = {
			"GDEXTENSION_CALL_ERROR_",
			"GDEXTENSION_CALL_",
		},
		"GDExtensionClassMethodFlags"            = {
			"GDEXTENSION_METHOD_FLAG_",
			"GDEXTENSION_METHOD_FLAGS_",
		},
		"GDExtensionClassMethodArgumentMetadata" = {"GDEXTENSION_METHOD_ARGUMENT_METADATA_"},
		"GDExtensionInitializationLevel"         = {"GDEXTENSION_INITIALIZATION_"},
	}

	if ps, ok := prefixes[enum_name]; ok {
		for p in ps {
			if strings.has_prefix(value, p) {
				return value[len(p):]
			}
		}
	}
	return value
}

pascalize_snake :: proc(s: string) -> string {
	parts := strings.split(s, "_", context.temp_allocator)
	b := strings.builder_make(context.temp_allocator)
	for p, i in parts {
		if len(p) == 0 {continue}
		if i > 0 {strings.write_byte(&b, '_')}
		strings.write_byte(&b, p[0])
		for c in p[1:] {
			r := c
			if c >= 'A' && c <= 'Z' {r = c + 32}
			strings.write_rune(&b, r)
		}
	}
	return strings.to_string(b)
}

ilog2 :: proc(x: u64) -> int {
	// Returns floor(log2(x)) for x > 0.
	n := 0
	v := x
	for v > 1 {v >>= 1; n += 1}
	return n
}

// ---------------------------------------------------------------------------
// Doc comment emission
// ---------------------------------------------------------------------------

emit_doc :: proc(
	b: ^strings.Builder,
	desc: []string,
	since: string,
	deprecated: HeaderDeprecated,
	indent: string = "    ",
) {
	has_desc := len(desc) > 0
	has_since := len(since) > 0
	has_depr := len(deprecated.since) > 0
	if !has_desc && !has_since && !has_depr {return}

	strings.write_string(b, indent)
	strings.write_string(b, "/**\n")
	if has_desc {
		for line in desc {
			strings.write_string(b, indent)
			strings.write_string(b, " * ")
			strings.write_string(b, line)
			strings.write_byte(b, '\n')
		}
	}
	if has_since {
		fmt.sbprintf(b, "%s * @since %s\n", indent, since)
	}
	if has_depr {
		if len(deprecated.replace_with) > 0 {
			fmt.sbprintf(
				b,
				"%s * @deprecated since %s -- use %s\n",
				indent,
				deprecated.since,
				deprecated.replace_with,
			)
		} else {
			fmt.sbprintf(b, "%s * @deprecated since %s\n", indent, deprecated.since)
		}
	}
	fmt.sbprintf(b, "%s */\n", indent)
}

// ---------------------------------------------------------------------------
// Type generation
// ---------------------------------------------------------------------------

gen_alias :: proc(b: ^strings.Builder, t: HeaderType, defined: ^map[string]bool) {
	emit_doc(b, t.description, t.since, t.deprecated, "")
	target := map_c_type(t.alias_type, defined)
	fmt.sbprintf(b, "%s :: %s\n\n", t.name, target)
}

gen_handle :: proc(b: ^strings.Builder, t: HeaderType) {
	emit_doc(b, t.description, t.since, t.deprecated, "")
	// TODO: migrate handles to distinct rawptr aliases once core/examples have
	// explicit casts for const/uninitialized pointer roles.
	fmt.sbprintf(b, "%s :: rawptr\n\n", t.name)
}

gen_enum :: proc(b: ^strings.Builder, t: HeaderType) {
	emit_doc(b, t.description, t.since, t.deprecated, "")
	if t.is_bitfield {
		flag_name := fmt.aprintf("%s_Flag", t.name)
		fmt.sbprintf(b, "%s :: bit_set[%s; u32]\n", t.name, flag_name)
		fmt.sbprintf(b, "%s :: enum u32 {{\n", flag_name)
	} else {
		fmt.sbprintf(b, "%s :: enum c.int {{\n", t.name)
	}

	seen := make(map[string]bool, len(t.values))
	defer delete(seen)
	for v in t.values {
		stripped := strip_enum_prefix(t.name, v.name)
		name := pascalize_snake(stripped)

		// deduplicate
		candidate := name
		counter := 2
		for seen[candidate] {
			candidate = fmt.aprintf("%s_%d", name, counter)
			counter += 1
		}
		seen[candidate] = true

		value := v.value
		if t.is_bitfield && value > 0 {
			value = i64(ilog2(u64(value)))
		}

		emit_doc(b, v.description, "", {}, "    ")
		fmt.sbprintf(b, "    %s = %d,\n", candidate, value)
	}
	strings.write_string(b, "}\n\n")
}

gen_function_type :: proc(b: ^strings.Builder, t: HeaderType, defined: ^map[string]bool) {
	emit_doc(b, t.description, t.since, t.deprecated, "")
	write_proc_type(b, t.name, t.arguments, t.return_value.type, defined)
}

gen_struct :: proc(b: ^strings.Builder, t: HeaderType, defined: ^map[string]bool) {
	emit_doc(b, t.description, t.since, t.deprecated, "")
	if len(t.parent) > 0 {
		fmt.sbprintf(b, "%s :: struct {{\n    using _: %s,\n", t.name, t.parent)
	} else {
		fmt.sbprintf(b, "%s :: struct {{\n", t.name)
	}
	for m in t.members {
		emit_doc(b, m.description, "", {}, "    ")
		mtype := map_c_type(m.type, defined)
		fmt.sbprintf(b, "    %s: %s,\n", m.name, mtype)
	}
	strings.write_string(b, "}\n\n")
}

// ---------------------------------------------------------------------------
// Proc type emission (shared by function types & interface function types)
// ---------------------------------------------------------------------------

write_proc_type :: proc(
	b: ^strings.Builder,
	type_name: string,
	args: []HeaderArgument,
	cret: string,
	defined: ^map[string]bool,
) {
	strings.write_string(b, type_name)
	strings.write_string(b, " :: #type proc \"c\" (")
	if len(args) == 0 {
		strings.write_string(b, ")")
	} else {
		strings.write_byte(b, '\n')
		for i in 0 ..< len(args) {
			a := args[i]
			aname := a.name if len(a.name) > 0 else fmt.aprintf("arg%d", i)
			atype := map_c_type(a.type, defined)
			emit_doc(b, a.description, "", {}, "    ")
			fmt.sbprintf(b, "    %s: %s,\n", aname, atype)
		}
		strings.write_string(b, ")")
	}
	if len(cret) > 0 && cret != "void" {
		fmt.sbprintf(b, " -> %s", map_c_type(cret, defined))
	}
	strings.write_byte(b, '\n')
}

// ---------------------------------------------------------------------------
// Interface function → proc type alias  (interface_defs.odin)
// ---------------------------------------------------------------------------

gen_interface_proc_type :: proc(
	b: ^strings.Builder,
	f: HeaderInterfaceFunction,
	defined: ^map[string]bool,
) {
	type_name := fmt.aprintf("ExtensionInterface%s", to_pascal(f.name))
	emit_doc(b, f.description, f.since, f.deprecated, "")
	write_proc_type(b, type_name, f.arguments, f.return_value.type, defined)
}

interface_function_is_required :: proc(f: HeaderInterfaceFunction) -> bool {
	if len(f.deprecated.since) > 0 {return false}
	for line in f.description {
		if strings.contains(strings.to_lower(line), "optional") {return false}
	}
	return true
}

// ---------------------------------------------------------------------------
// Interface globals + init()  (interface.odin)
// ---------------------------------------------------------------------------

gen_globals_and_init :: proc(iface: []HeaderInterfaceFunction) -> string {
	b := strings.builder_make(context.temp_allocator)

	for f in iface {
		emit_doc(&b, f.description, f.since, f.deprecated, "")
		type_name := fmt.aprintf("ExtensionInterface%s", to_pascal(f.name))
		fmt.sbprintf(&b, "%s: %s\n\n", f.name, type_name)
	}

	strings.write_string(
		&b,
		"// The library handle Godot passed to the entry point. Set by init().\n",
	)
	strings.write_string(&b, "library: GDExtensionClassLibraryPtr\n\n")

	strings.write_string(
		&b,
		"// Resolves every interface function pointer from the host Godot instance.\n",
	)
	strings.write_string(
		&b,
		"// MUST be called exactly once, from the library entry point, before any other\n",
	)
	strings.write_string(&b, "// binding is used.\n")
	strings.write_string(&b, "init :: proc \"contextless\" (\n")
	strings.write_string(&b, "    p_library: GDExtensionClassLibraryPtr,\n")
	strings.write_string(&b, "    p_get_proc_address: GDExtensionInterfaceGetProcAddress,\n")
	strings.write_string(&b, ") {\n")
	strings.write_string(&b, "    if p_get_proc_address == nil do _trap_nil_godot_function()\n")
	strings.write_string(&b, "    library = p_library\n")

	for f in iface {
		type_name := fmt.aprintf("ExtensionInterface%s", to_pascal(f.name))
		fmt.sbprintf(
			&b,
			"    %s = cast(%s)p_get_proc_address(\"%s\")\n",
			f.name,
			type_name,
			f.name,
		)
		if interface_function_is_required(f) {
			fmt.sbprintf(&b, "    if %s == nil do _trap_nil_godot_function()\n", f.name)
		}
	}
	strings.write_string(&b, "}\n")

	return strings.to_string(b)
}

// ---------------------------------------------------------------------------
// Main entry point
// ---------------------------------------------------------------------------

main :: proc() {
	if len(os.args) < 2 {
		fmt.eprintln("usage: bindgen <gdextension_interface.json>")
		fmt.eprintln("       bindgen --builtin <extension_api.json>")
		os.exit(1)
	}

	if os.args[1] == "--builtin" {
		if len(os.args) < 3 {
			fmt.eprintln("ERROR: --builtin requires <extension_api.json>")
			os.exit(1)
		}
		if !generate_builtin_bindings(os.args[2]) {
			os.exit(1)
		}
		return
	}

	json_path := os.args[1]

	// ---- read JSON ----
	data, err := os.read_entire_file_from_path(json_path, context.temp_allocator)
	if err != nil {
		fmt.eprintfln("ERROR: cannot read %s: %v", json_path, err)
		os.exit(1)
	}

	header: Header
	uerr := json.unmarshal(data, &header)
	if uerr != nil {
		fmt.eprintfln("ERROR: failed to parse JSON: %v", uerr)
		os.exit(1)
	}

	// ---- build set of defined type names ----
	defined := make(map[string]bool, len(header.types))
	defer delete(defined)
	for t in header.types {
		defined[t.name] = true
	}

	// ---- generate interface_defs.odin ----
	defs := strings.builder_make(context.allocator)
	defer strings.builder_destroy(&defs)

	fmt.sbprintf(&defs, "// Code generated by bindgen from %s. DO NOT EDIT.\n\n", json_path)
	strings.write_string(&defs, "package godot_core\n\n")
	strings.write_string(&defs, "import \"core:c\"\n\n")

	for t in header.types {
		switch t.kind {
		case "alias":
			gen_alias(&defs, t, &defined)
		case "handle":
			gen_handle(&defs, t)
		case "enum":
			gen_enum(&defs, t)
		case "function":
			gen_function_type(&defs, t, &defined)
		case "struct":
			gen_struct(&defs, t, &defined)
		case:
			fmt.eprintfln("WARNING: unknown type kind %q for %s", t.kind, t.name)
		}
	}

	for f in header.interface {
		gen_interface_proc_type(&defs, f, &defined)
	}

	werr := os.write_entire_file(OUT_INTERFACE_DEFS, transmute([]byte)strings.to_string(defs))
	if werr != nil {
		fmt.eprintfln("ERROR: failed to write %s: %v", OUT_INTERFACE_DEFS, werr)
		os.exit(1)
	}

	// ---- generate + write interface.odin ----
	iface_header := fmt.aprintf(
		"// Code generated by bindgen from %s. DO NOT EDIT.\n\npackage godot_core\n\n",
		json_path,
	)
	iface_body := gen_globals_and_init(header.interface)
	iface_full := strings.concatenate({iface_header, iface_body}, context.temp_allocator)

	werr2 := os.write_entire_file(OUT_INTERFACE, transmute([]byte)iface_full)
	if werr2 != nil {
		fmt.eprintfln("ERROR: failed to write %s: %v", OUT_INTERFACE, werr2)
		os.exit(1)
	}

	fmt.printfln(
		"Generated %s  (%d types, %d interface functions)",
		OUT_INTERFACE_DEFS,
		len(header.types),
		len(header.interface),
	)
	fmt.printfln("Generated %s", OUT_INTERFACE)
}
