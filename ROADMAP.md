# Roadmap

## Long-term goal

Build an Odin GDExtension library:

- safe low-level GDExtension bindings
- explicit Godot value ownership and destruction rules
- borrowed object/class handle APIs by default
- generated bindings that preserve the safety model
- ergonomic user class authoring for normal Godot gameplay code
- enough generated Godot API coverage to build real gameplay systems in Odin
- examples and CI that prove real Godot project usage keeps working

## Invariants

Keep these rules intact while adding features:

- Explicit ownership for Godot values. Owned `Variant`, `String`, `StringName`,
  `NodePath`, arrays, dictionaries, packed arrays, and similar values must have
  matching destruction paths.
- Object and class handles are borrowed unless a helper explicitly documents a
  retain/reference rule.
- `RefCounted` and `Resource` remain borrowed by default. Owned references must
  use the explicit `OwnedRefCounted` or `OwnedResource` wrappers.
- No raw offset poking in examples, generated code, or public helpers.
- Resolved GDExtension function pointers and method binds must be checked or
  trapped before use.
- Registration metadata must live long enough for the Godot registration that
  uses it.
- Extension classes must unregister during deinitialization.
- Normal examples should import only `godot:godot`.

## Completed: generated class API expansion

Selected generated Godot class APIs are now useful for focused Odin gameplay
code while preserving the borrowed-object and explicit-owned-value safety model.
The generated class slice includes support reporting, safer method type mapping,
practical scene/UI APIs, checked `NodePath` lookup helpers, public facade exports,
runtime example coverage, and generator guardrails for deterministic small-batch
class expansion.

## Completed: Resource and RefCounted ownership model

`RefCounted` and `Resource` now have an explicit owned-reference path while
normal object/class handles remain borrowed by default. The completed slice
added documentation, low-level retain/unreference helpers, `OwnedRefCounted`,
`OwnedResource`, generator reporting for owned-wrapper-only methods, runtime
smoke coverage, and full `make ci` validation.

## Completed: generated gameplay class API expansion

The generated gameplay class slice added selected borrowed-safe APIs for common
2D gameplay classes while keeping lifetime-sensitive APIs skipped. Completed
coverage includes `Timer`, `CollisionObject2D`, `Area2D`, and a cautious minimal
`PackedScene` slice. The public facade and examples now exercise these APIs
through `godot:godot`, and `make ci` passed for the completed slice.

## Completed: Signals and Callable groundwork

The signal and callable slice added a minimal safe model for direct gameplay
usage without enabling broad generated signal APIs. Completed coverage includes
owned `Callable` and `Signal` storage helpers, explicit destruction rules, safe
object signal connection helpers, fixed-arity signal emission helpers, generated
blocker reporting, facade compile coverage, smoke/example coverage, and full
`make ci` validation.

## Completed: typed arrays and typed dictionaries

The typed container slice added a first safe model for typed arrays returned by
selected generated APIs. Completed coverage includes typed container ownership
rules, typed array and typed dictionary blocker reporting, `TypedArray` storage
aliases over `Array` storage, checked read helpers for borrowed object handles,
selected generated `Area2D` overlap methods, facade exports, smoke/facade
coverage, and full `make ci` validation.

## Current goal: default arguments and overload ergonomics

Add a small generated wrapper strategy for Godot methods that are otherwise safe
but currently skipped or awkward because they expose default arguments. This
should improve real usability without expanding into varargs, broad overload
sets, or lifetime-sensitive APIs.

Keep this roadmap narrow. Start with reporting and deterministic naming, then
enable only a selected method batch where all explicit argument types already
satisfy the ownership model. Do not infer unsafe defaults, hide ownership, or
emit wrappers that collide with existing generated names.

1. Define default-argument wrapper policy.
   - [ ] Document that full-arity wrappers remain the canonical generated API.
   - [ ] Generate shorter convenience wrappers only when omitted arguments have
     stable `extension_api.json` defaults and supported types.
   - [ ] Keep wrapper names deterministic and collision-free.
   - [ ] Do not support varargs as part of this roadmap.

2. Improve reporting for default arguments.
   - [ ] Split default-argument skips from unsupported type and lifetime skips.
   - [ ] Report which arguments have defaults and their raw Godot default value.
   - [ ] Identify the smallest safe selected method batch that becomes useful
     with convenience wrappers.
   - [ ] Keep methods with unsupported default values skipped with explicit
     reasons.

3. Add default value parsing for primitive and simple value types.
   - [ ] Start with `bool`, integer values, `GodotReal`, empty `String`, and nil
     object defaults where ownership is clear.
   - [ ] Convert parsed defaults into local Odin temporaries before ptrcall.
   - [ ] Reuse existing owned value construction and destruction helpers for any
     default that needs Godot storage.
   - [ ] Defer complex expressions, enum aliases, objects needing construction,
     arrays, dictionaries, `Callable`, `Signal`, and resource defaults.

4. Generate deterministic convenience wrappers for selected methods.
   - [ ] Keep the full explicit wrapper unchanged.
   - [ ] Emit suffix-based or arity-based wrapper names that cannot collide with
     selected explicit methods.
   - [ ] Ensure temporary defaults are destroyed on every path.
   - [ ] Validate generated output remains stable.

5. Enable one small generated default-argument batch.
   - [ ] Prefer selected `Node`, `Control`, `Timer`, or `Area2D` methods already
     generated with explicit arguments.
   - [ ] Add only wrappers whose omitted arguments are primitive or simple owned
     values.
   - [ ] Re-export selected convenience wrappers through `godot:godot`.
   - [ ] Keep broad overload coverage deferred.

6. Add facade and smoke coverage.
   - [ ] Add facade compile checks for generated convenience wrappers.
   - [ ] Add or extend smoke/example usage where defaulted wrappers improve
     readability.
   - [ ] Keep beginner examples readable and still importing only `godot:godot`.
   - [ ] Confirm existing explicit wrappers still compile.

7. Validate before moving to the next feature roadmap.
   - [ ] Run `make ci`.
   - [ ] Confirm generated reports explain remaining default-argument skips.
   - [ ] Confirm no generated wrapper violates borrowed-object or owned-value
     destruction rules.
   - [ ] Confirm generated output is deterministic.

## Deferred until after this goal

- broad overload coverage
- vararg methods
- complex default value expressions
- broad typed container mutation APIs
- arbitrary callable binding helpers
- generated signal wrappers beyond selected safe paths
- broad `Resource`, `PackedScene`, texture, theme, and asset APIs
- `PackedScene.instantiate` and `Resource.duplicate` ownership-transfer wrappers
- full virtual method generation
- full 1000+ class API generation

## Validation

- `make ci` passes.
- Normal examples import only `godot:godot`.
- At least one example demonstrates a complete user class with:
  - instance data
  - method registration
  - property registration
  - signal registration and emission
  - notification handling
  - generated class handle usage
- Facade compile checks cover the public authoring helpers.
