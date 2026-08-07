# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** early prototype. Current smoke-tested scope: Godot 4.7
> single-precision C ABI generation, manual class registration, manual lifecycle
> callbacks, manual method registration, basic Variant helpers, typed object
> handle experiments, generated math builtin bindings, and partial utility
> function bindings.

## Requirements

- Odin compiler on `PATH`.
- Godot **4.7** on `PATH`.
- Currently targets Godot's **single-precision** build/API only.
- `make` and a platform toolchain capable of building shared libraries.

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

A single `make hello` runs interface + builtins + build automatically, so it may
create or refresh generated files under `core/`, `bindings/builtin/`, and
`bindings/utilities.odin` before building the example extension.

`make check` type-checks the `core` package with `-vet -strict-style`.

## Imports

The `godot:godot` package is a small convenience facade for the handwritten core
helpers plus a few common utilities. It is not yet a complete facade over all
generated APIs. Import generated packages directly when you need them:

```odin
import gt "godot:godot"              // convenience facade: context, Variant helpers, a few utilities
import gd "godot:core"               // GDExtension C-ABI types/functions and runtime helpers
import bind "godot:bindings"         // generated @GlobalScope utilities
import builtin "godot:bindings/builtin" // generated builtin-type bindings
```

## API coverage

Current codegen is intentionally incomplete:

- Builtin generation focuses on simple/math builtins. Complex/value-owning
  builtins such as `String`, `StringName`, `NodePath`, `RID`, `Callable`,
  `Signal`, `Array`, `Dictionary`, and packed arrays are skipped until their
  ownership, lifetime, and ABI rules are implemented properly.
- Utility generation skips varargs and signatures involving unsupported complex
  return/argument types, including `String`, `Variant`, `Object`, `RID`, and
  several packed arrays. Generated utilities are available from
  `godot:bindings`; only a tiny subset is re-exported by `godot:godot`.
- Engine object class wrappers are planned, but not generated yet.
- Properties, signals, and virtual method overrides are not implemented yet.
- Ownership rules for value types are still being stabilized. Treat current
  `Variant`, `String`, `StringName`, and `Array` helpers as low-level prototype
  APIs whose construction/destruction rules may change.

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

- `core/` -- handwritten runtime: C-ABI types, basic manual Variant helpers,
  typed object handle experiments, Godot-backed allocator, class registration
  helpers, `BuiltinMethod` lazy-init pattern.
- `generator/` -- reads `gdextension_interface.json` and `extension_api.json`.
  Emits `core/interface*.odin`, `bindings/builtin/*.odin` for the currently
  supported builtin slice, and `bindings/utilities.odin` for supported
  @GlobalScope utility signatures.
- `bindings/builtin/` -- code-generated for simple/math builtin types: struct
  layout from real member offsets, `to_variant`/`from_variant`, constructors,
  instance/static methods, enums. Complex/value-owning builtins such as `String`,
  `StringName`, `NodePath`, `RID`, `Callable`, `Signal`, `Array`, `Dictionary`,
  and packed arrays are not complete yet.
- `bindings/utilities.odin` -- code-generated non-vararg @GlobalScope utility
  functions whose return and argument types are currently supported. Utilities
  involving unsupported complex types are skipped for now.
- `godot/` -- small handwritten convenience facade, not a complete re-export of
  every generated API.

### Layers

| Layer | Description | Status |
|-------|-------------|--------|
| `core/` | C-ABI types, helpers, basic Variant helpers, typed handle experiments, context | Partial |
| `generator/` | Codegen for FFI, builtin types, utility functions | Partial |
| `bindings/builtin/` | Math/simple builtin types (Vector2..Projection) with methods | Partial |
| `bindings/utilities.odin` | Supported @GlobalScope utility functions | Partial |
| `godot/` facade | Small convenience re-export package | Partial |
| `bindings/` (classes) | Per-class API wrappers for engine classes | Planned |
| Properties/signals | Getter/setter hooks on registered classes | Planned |
| Virtual methods | Override engine virtuals from Odin | Planned |

## Roadmap

See [ROADMAP.md](ROADMAP.md) for the detailed priority plan. In short, the next
steps are safety hardening, stable value-type wrappers, generated class bindings,
user-friendly registration helpers, and properties/signals/virtual callbacks.

## License

Apache 2.0 -- see [LICENSE](LICENSE).
