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

``` sh
 # to test
 make clean && rm -f bin/godot-codegen godot-ffi/interface*.odin && make hello && godot --headless --path examples/hello --import && godot --headless --path examples/hello --quit
 ```
 
## Architecture

`godot-codegen/main.odin` reads `thirdparty/gdextension_interface.json` and generates `godot-ffi/interface_defs.odin` and `godot-ffi/interface.odin`. Those files, together with the hand-written `godot-ffi/lib.odin` and `godot-ffi/context.odin`, form the `godot-ffi` package that extensions link against. `examples/hello/` is a minimal extension that proves the pipeline works end-to-end in Godot 4.7.

### Layers (mirroring [godot-rust/gdext](https://github.com/godot-rust/gdext))

| Layer | Description | Status |
|-------|-------------|--------|
| `godot-ffi/` | Low-level C-ABI bindings (generated + hand helpers) | ✅ |
| `godot-codegen/` | Tool that generates `godot-ffi/interface*.odin` from `gdextension_interface.json` | ✅ |


## License

Apache 2.0 — see [LICENSE](LICENSE).
