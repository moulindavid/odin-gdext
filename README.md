# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** early development. Godot 4.7 C-ABI bindings, class registration,
> lifecycle callbacks, method registration (GDScript-callable), typed object
> handles (`distinct ObjectPtr`), `is_class`-based casting, Variant marshaling,
> and utility function bindings (sin, cos, print, var_to_str) all work.

## Quick start

```sh
# Generate the C-interface bindings from vendored Godot 4.7 JSON
make interface

# Build the hello-world extension
make hello

# Test in Godot headless
make test-hello
```

## Architecture

```
odin-gdext/
├── generator/           ← codegen (FFI, future: class bindings)
├── core/                ← C-ABI + handwritten runtime
├── bindings/            ← generated wrappers (never edit by hand)
├── godot/               ← thin re-export facade
└── examples/hello/      ← minimal GDExtension proving the pipeline (can be loaded in godot)
```

- `core/` — handwritten runtime: C-ABI types, Variant marshaling, typed
  object handles, Godot-backed allocator, class registration helpers.
- `bindings/` — generated from `extension_api.json`: utility functions,
  per-class API wrappers, enums. Never edit by hand.
- `godot/` — thin re-export facade; users `import gt "godot:godot"`.
- `generator/` — reads `gdextension_interface.json` and `extension_api.json`,
  emits `core/interface*.odin` and `bindings/`.

### Layers

| Layer | Description | Status |
|-------|-------------|--------|
| `core/` | C-ABI types, helpers, Variant, typed handles, context | WIP |
| `generator/` | Codegen for `core/interface*.odin` from JSON | WIP |
| `bindings/utilities.odin` | Utility function bindings (sin, cos, var_to_str, etc.) | WIP |
| `bindings/` (rest) | Per-class API, enums, remaining utility functions | Planned |

## License

Apache 2.0 — see [LICENSE](LICENSE).
