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

## Current goal: typed arrays and typed dictionaries

Add a small, safe model for Godot typed containers so generated gameplay APIs can
return or consume collections without exposing raw temporary storage. This is the
next practical blocker for methods such as overlap queries, scene-tree queries,
and APIs that return collections of borrowed object/class handles.

Keep this roadmap narrow. Start with reporting, ownership rules, and selected
read-only or copy-out helpers. Do not expose broad typed container mutation,
borrowed slices into Godot storage, or typed arrays of lifetime-sensitive objects
until the contained-handle rules are explicit and tested.

1. Define typed container ownership rules.
   - [x] Document that typed array and dictionary wrapper values own only the
     container storage, not the Godot objects referenced inside it.
   - [x] Document that object/class handles read from containers are borrowed by
     value and must be checked for nil/class identity before use.
   - [x] Document that helpers must not return Odin slices into temporary Godot
     storage.
   - [x] Keep typed container helpers explicit about whether they copy, borrow,
     or destroy storage.

2. Improve generated reporting for typed containers.
   - [x] Split typed array, typed dictionary, and untyped container skips into
     separate report buckets.
   - [x] Include the element type in skip reasons where `extension_api.json`
     exposes it.
   - [x] Identify the smallest selected APIs unblocked by safe typed container
     reads.
   - [x] Keep generated wrappers disabled until their container and element
     ownership rules are implemented.

3. Add typed array storage aliases and pointer helpers where needed.
   - [x] Reuse existing `Array` storage for Godot typed arrays when the ABI uses
     normal `Array` storage with type metadata.
   - [x] Add named typed-array wrapper aliases only if they improve type safety
     for generated APIs.
   - [x] Preserve existing `Array` construction, copy, and destruction rules.
   - [x] Add facade exports only for helpers intended for normal users.

4. Add safe typed array read helpers for borrowed object handles.
   - [x] Start with arrays of selected classes such as `Node`, `Node2D`,
     `Area2D`, and `CollisionObject2D`.
   - [x] Provide checked `get_as_*` helpers returning `(value, ok)`.
   - [x] Treat nil elements and failed class checks as `ok = false`.
   - [x] Keep returned handles borrowed and avoid retaining or freeing objects.

5. Enable one small generated typed-array API batch.
   - [ ] Prefer `Area2D` overlap query methods if their return ownership is a
     normal owned `Array` value.
   - [ ] Generate wrappers only when the return container is owned and has an
     explicit destruction path.
   - [ ] Keep mutation-heavy or lifetime-sensitive container APIs skipped.
   - [ ] Re-export the selected wrappers through `godot:godot`.

6. Add smoke and facade coverage.
   - [ ] Add facade compile checks for typed container helpers and selected
     generated methods.
   - [ ] Add a smoke path that constructs or receives a typed container and reads
     borrowed handles safely.
   - [ ] Keep beginner examples readable and avoid making typed containers the
     first concept users see.
   - [ ] Confirm normal examples still import only `godot:godot`.

7. Validate before moving to the next feature roadmap.
   - [ ] Run `make ci`.
   - [ ] Confirm generated reports explain remaining typed container skips.
   - [ ] Confirm no helper returns slices or pointers into temporary Godot
     storage.
   - [ ] Confirm owned container values have matching destruction paths.

## Deferred until after this goal

- broad typed container mutation APIs
- default arguments and overload ergonomics
- broad vararg signal emission
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
