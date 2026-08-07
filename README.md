# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** early development. Godot 4.7 single-precision: C-ABI bindings,
> class registration, lifecycle callbacks, method registration (GDScript-callable),
> typed object handles (`distinct ObjectPtr`), `is_class`-based casting, Variant
> marshaling, 16 builtin math types (Vector2, Color, Basis, etc.), and 80 utility
> functions (sin, cos, randf, etc.) all code-generated and tested.

## Quick start

```sh
# Dump Godot's extension API (requires Godot 4.7 on PATH)
make extension-api

# Generate ALL bindings (FFI + builtin types + utility functions)
make builtins
make interface

# Build the hello-world extension
make hello

# Test in Godot headless
make test-hello
```

A single `make hello` runs interface + builtins + build automatically.
`make check` type-checks the `core` package with `-vet -strict-style`.

## Architecture

```
odin-gdext/
├── generator/                ← codegen (FFI, builtin types, utilities)
├── core/                     ← C-ABI + handwritten runtime
├── bindings/
│   ├── builtin/              ← generated builtin type bindings
│   └── utilities.odin        ← generated @GlobalScope functions
├── godot/                    ← thin re-export facade
└── examples/hello/           ← minimal GDExtension proving the pipeline
```

- `core/` -- handwritten runtime: C-ABI types, Variant marshaling, typed
  object handles, Godot-backed allocator, class registration helpers,
  `BuiltinMethod` lazy-init pattern.
- `generator/` -- reads `gdextension_interface.json` and `extension_api.json`.
  Emits `core/interface*.odin`, `bindings/builtin/*.odin` (16 math types),
  and `bindings/utilities.odin` (80 functions).
- `bindings/builtin/` -- code-generated: struct layout from real member offsets,
  `to_variant`/`from_variant`, constructors, instance/static methods, enums.
- `bindings/utilities.odin` -- code-generated: all non-vararg, non-complex
  @GlobalScope utility functions with lazy-init resolution.
- `godot/` -- thin re-export facade; users `import gt "godot:godot"`.

### Layers

| Layer | Description | Status |
|-------|-------------|--------|
| `core/` | C-ABI types, helpers, Variant, typed handles, context | Done |
| `generator/` | Codegen for FFI, builtin types, utility functions | Done |
| `bindings/builtin/` | 16 math types (Vector2..Projection) with methods | Done |
| `bindings/utilities.odin` | 80 @GlobalScope utility functions | Done |
| `bindings/` (classes) | Per-class API wrappers for engine classes | Planned |
| Properties/signals | Getter/setter hooks on registered classes | Planned |
| Virtual methods | Override engine virtuals from Odin | Planned |

## License

Apache 2.0 -- see [LICENSE](LICENSE).
