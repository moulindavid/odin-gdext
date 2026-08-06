# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** early development. Godot 4.7 C-ABI bindings, class registration,
> lifecycle callbacks, **class method registration** with GDScript-callable
> methods, typed object handles (`distinct ObjectPtr`), `is_class`-based
> dynamic casting, and Variant marshaling

## Quick start

```sh
# Generate the C-interface bindings from vendored Godot 4.7 JSON
make interface

# Build the hello-world extension
make hello

# Test in Godot headless
make test-hello
```

```sh
# Full clean rebuild + test
make clean && rm -f bin/godot-codegen godot-ffi/interface*.odin && make hello && godot --headless --path examples/hello --import && godot --headless --path examples/hello --quit
```

## Architecture

- `godot-codegen/main.odin` reads `thirdparty/gdextension_interface.json` and generates `godot-ffi/interface_defs.odin` + `godot-ffi/interface.odin`.
- `godot-ffi/` is the low-level C-ABI package: generated proc types/enums/structs + hand-written helpers (`lib.odin`, `context.odin`).
- `godot/` is the ergonomic Odin layer: Variant marshaling (`variant.odin`), typed object handles (`types.odin`), utility function bindings (`utilities.odin`). Full class bindings codegen from `extension_api.json` planned.
- `examples/hello/` is a minimal extension that proves the pipeline works in Godot 4.7: registers `HelloNode` extending `Node`, exports `add(a, b)` callable from GDScript, exercises `is_nil`/`is_class`/variant round-trip at startup.

### Layers

| Layer | Description | Status |
|-------|-------------|--------|
| `godot-ffi/` | Low-level C-ABI bindings (generated + hand helpers) | WIP |
| `godot-codegen/` | Generates `godot-ffi/interface*.odin` from `gdextension_interface.json` | WIP |
| `godot/variant.odin` | Variant marshaling (float, int, bool, string, array, object) | WIP |
| `godot/types.odin` | Typed handles (`distinct ObjectPtr`), `is_class` casting, variant conversion | WIP |
| `godot/utilities.odin` | Utility function bindings (sin, cos, var_to_str, etc.) | WIP |
| `godot/**` (rest) | Utility function codegen, per-class API generation | Planned |

## License

Apache 2.0 — see [LICENSE](LICENSE).
