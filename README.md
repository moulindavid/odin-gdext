# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** early prototype. Current smoke-tested scope: Godot 4.7
> single-precision C ABI generation, manual class registration, manual lifecycle
> callbacks, manual method registration, basic Variant helpers, typed object
> handle experiments, generated math builtin bindings, and partial utility
> function bindings.

## Requirements

- Odin compiler on `PATH` (currently validated with `dev-2026-07`).
- `odinfmt` on `PATH`.
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

# Run the full local validation baseline used by CI
make ci
```

A single `make hello` runs interface + builtins + build automatically, so it may
create or refresh generated files under `core/`, `bindings/builtin/`, and
`bindings/utilities.odin` before building the example extension.

`make check` type-checks the `core` package with `-vet -strict-style` and
`-default-to-nil-allocator`. Additional focused checks are available for the
generator, generated bindings, and public facade.

## Validation and CI

Use `make ci` before opening a pull request or starting a larger roadmap slice.
It performs a clean validation pass in a fixed order:

1. `make clean`
2. `make fmt-check`
3. `make interface`
4. `make builtins`
5. `make check`
6. `make check-generator`
7. `make check-bindings`
8. `make check-godot`
9. `make test-unit`
10. `make test-hello`

`make test-unit` is the minimal Odin unit-test harness for focused tests that do
not need to launch Godot. Odin's test runner allocates internally, so that target
keeps `-vet` and `-strict-style` but intentionally omits
`-default-to-nil-allocator`. Runtime integration is still covered by
`make test-hello`, which builds the example extension and runs Godot headless.

The GitHub Actions workflow in `.github/workflows/ci.yml` installs Odin,
downloads `odinfmt` from the OLS tooling releases, downloads Godot 4.7, and runs
`make ci`. Generated bindings remain ignored by git; CI regenerates and checks
them instead of requiring generated output commits.

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
  return/argument types, including `String`, `Object`, `RID`, `Variant` returns,
  and several packed arrays. `Variant` arguments are generated as borrowed
  `^core.Variant` parameters to avoid unsafe owned-storage bit copies. Generated
  utilities are available from `godot:bindings`; only a tiny subset is
  re-exported by `godot:godot`.
- Engine object class wrappers are planned, but not generated yet.
- Properties, signals, and virtual method overrides are not implemented yet.
- Ownership rules for value types are still being stabilized. `Variant` now has
  explicit owned-storage helpers (`variant_nil`, `variant_copy`,
  `variant_init_copy`, pointer adapters, and `variant_free`) plus minimal
  `CallError` helpers and checked wrappers for `variant_call` /
  `variant_construct`. Generated wrappers borrow `^core.Variant` parameters and
  document owned `core.Variant` returns. Runtime type inspection, exact-type
  `variant_try_bool` / `variant_try_int` / `variant_try_float`, `variant_try_object`,
  caller-buffer `variant_try_utf8` String extraction, and generated exact-type
  `{builtin}_try_from_variant` helpers for current memory-compatible builtin types
  are available, but broader complex conversion coverage is still incomplete.
  `String` has an initial owned-storage wrapper (`string_from_utf8`,
  `string_to_utf8`, `string_free`, `variant_from_string`, and `variant_try_string`),
  but broader String methods/operators and generated API integration are still pending.
  `StringName` has an initial owned, non-static wrapper (`string_name_from_utf8_cstring`,
  `string_name_free`, `variant_from_string_name`, and `variant_try_string_name`) plus
  a `StaticStringName` wrapper for process-lifetime literals used by core/generated
  builtin-method and utility lookup helpers, plus the hello example's manual
  registration data. Static names must only use process-lifetime strings and must never
  be destroyed. `NodePath` has an initial owned wrapper (`node_path_from_utf8`,
  `node_path_free`, `variant_from_node_path`, and `variant_try_node_path`) plus primitive
  method wrappers and owned `StringName`-returning helpers for names/subnames. Generated
  API integration is still pending. `Array` has an initial owned-storage wrapper
  (`array_new`, `array_copy`, `array_free`, `array_push`, `array_size`, `array_get`,
  `array_set`, `array_clear`, `array_erase`, `array_has`, `array_is_empty`,
  `variant_from_array`, and `variant_try_array`). `Dictionary` has the same initial
  owned-storage pattern plus `dictionary_set`, `dictionary_get`, `dictionary_get_or_default`,
  `dictionary_has`, `dictionary_erase`, `dictionary_clear`, `dictionary_size`,
  `dictionary_is_empty`, `variant_from_dictionary`, and `variant_try_dictionary`.
  `PackedByteArray` has an initial owned-storage wrapper (`packed_byte_array_new`,
  `packed_byte_array_copy`, `packed_byte_array_free`, `packed_byte_array_push`,
  `packed_byte_array_get`, `packed_byte_array_set`, `packed_byte_array_clear`,
  `packed_byte_array_size`, `packed_byte_array_is_empty`, `variant_from_packed_byte_array`,
  and `variant_try_packed_byte_array`). `PackedInt32Array` mirrors that initial
  owned-storage/basic-method/Variant-conversion pattern. Broader methods, typed
  arrays/dictionaries, the other packed arrays, and generated API integration are
  still pending.

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

- `core/` -- handwritten runtime: C-ABI types, owned Variant storage helpers,
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
| `core/` | C-ABI types, helpers, owned Variant storage helpers, typed handle experiments, context | Partial |
| `generator/` | Codegen for FFI, builtin types, utility functions | Partial |
| `bindings/builtin/` | Math/simple builtin types (Vector2..Projection) with methods | Partial |
| `bindings/utilities.odin` | Supported @GlobalScope utility functions | Partial |
| `godot/` facade | Small convenience re-export package | Partial |
| `bindings/` (classes) | Per-class API wrappers for engine classes | Planned |
| Properties/signals | Getter/setter hooks on registered classes | Planned |
| Virtual methods | Override engine virtuals from Odin | Planned |

## Roadmap

See [ROADMAP.md](ROADMAP.md) for the short plan.

## License

Apache 2.0 -- see [LICENSE](LICENSE).
