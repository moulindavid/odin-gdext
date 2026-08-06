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

## extension_api.json

A machine-readable dump of Godot's full extension API — built-in classes,
utility functions, global enums, singletons, native structures, and more.

Generated locally from a Godot binary (not vendored from source):

```sh
make extension-api
# equivalent to: godot --dump-extension-api thirdparty/extension_api.json
```

This file is ~7 MB and is git-ignored. It does not change between minor
patch releases, but should be re-dumped when moving to a new Godot minor.

We consume it in `godot-codegen` to generate:
- `godot/utilities.odin` — typed wrappers for @GlobalScope utility functions
