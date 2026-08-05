# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** early development. The low-level interface is complete for
> Godot 4.7; class registration and lifecycle callbacks work end-to-end.
> The high-level `godot` package is planned (not yet generated).

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
thirdparty/gdextension_interface.json   ← vendored from Godot source
        │
        │  godot-codegen/main.odin
        ▼
godot-ffi/interface_defs.odin    ─┐  generated: proc types, enums, bit_sets,
godot-ffi/interface.odin         ─┘  structs, global proc vars + init()
godot-ffi/lib.odin               ← hand-written: aliases, ptrcall helpers,
                                   class registration, object construction
godot-ffi/context.odin            ← hand-written: Godot-backed Odin allocator
        │
        ▼
examples/hello/                  ← minimal working GDExtension (proves
                                   end-to-end: loads in Godot 4.7, registers
                                   a class, fires _ready notification)
```

### Layers (mirroring [godot-rust/gdext](https://github.com/godot-rust/gdext))

| Layer | Description | Status |
|-------|-------------|--------|
| `godot-ffi/` | Low-level C-ABI bindings (generated + hand helpers) | ✅ |
| `godot-codegen/` | Tool that generates `godot-ffi/interface*.odin` from `gdextension_interface.json` | ✅ |


## License

Apache 2.0 — see [LICENSE](LICENSE).
