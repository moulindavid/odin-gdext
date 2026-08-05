# thirdparty

## gdextension_interface.json

A machine-readable description of the GDExtension C interface, vendored from
the [Godot Engine](https://github.com/godotengine/godot) source tree:

- Source: `core/extension/gdextension_interface.json`
- Branch: `4.7` (commit of the Godot 4.7 stable release)
- License: MIT (Godot Engine)

Since Godot 4.6, `gdextension_interface.h` is *generated* from this JSON at
build time (see `core/extension/gdextension_interface_header_generator.cpp`).
We consume the JSON directly and generate our Odin bindings from it, which
keeps us in sync with the C ABI without parsing C headers.

To update for a newer Godot version:

```sh
curl -L -o thirdparty/gdextension_interface.json \
  https://raw.githubusercontent.com/godotengine/godot/BRANCH/core/extension/gdextension_interface.json
make interface
```

Then re-check with `make check`.
