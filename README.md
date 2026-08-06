# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** early development. Godot 4.7 C-ABI bindings, class registration,
> lifecycle callbacks, and basic Variant marshaling work end-to-end.
> The `godot/` package has manual prototypes; full codegen from
> `extension_api.json` is planned.

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
- `godot/` is the ergonomic layer: Variant marshaling, utility functions, and eventually generated class bindings. Currently manual prototypes; codegen planned.
- `examples/hello/` is a minimal extension that proves the pipeline works in Godot 4.7.

### Layers (mirroring [godot-rust/gdext](https://github.com/godot-rust/gdext))

| Layer | Description | Status |
|-------|-------------|--------|
| `godot-ffi/` | Low-level C-ABI bindings (generated + hand helpers) | Working |
| `godot-codegen/` | Generates `godot-ffi/interface*.odin` from `gdextension_interface.json` | Working |
| `godot/` | Ergonomic layer: Variants, utility functions, class bindings | Manual prototypes; codegen planned |


## License

Apache 2.0 — see [LICENSE](LICENSE).
