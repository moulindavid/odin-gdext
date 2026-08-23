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

## Completed: default arguments and overload ergonomics

The default-argument slice added deterministic convenience wrappers for a small
safe method batch while keeping full-arity generated wrappers canonical.
Completed coverage includes default-argument reporting, parsing for simple safe
defaults, selected `_default` wrappers, public facade exports, facade compile
coverage, example usage, deterministic generated output checks, and full
`make ci` validation.

## Completed: class authoring ergonomics

The class-authoring slice made custom Odin classes less verbose while keeping
lifecycle and ownership explicit. Completed coverage includes stable registration
metadata storage, a small class builder, fixed-signature method helpers,
typed-property helpers, signal registration helpers, typed instance-data helpers,
facade compile coverage, and a beginner `examples/hello` class using only
`godot:godot`. Full `make ci` passed for the completed slice.

## Completed: Input and scene-tree gameplay APIs

The input and scene-tree slice added borrowed singleton lookup rules, selected
`Input` query APIs, selected borrowed-safe `SceneTree` APIs, public facade
exports, generated singleton/input/scene-tree reporting, and real example usage
through `godot:godot`. Full `make ci` passed for the completed slice.

## Current goal: Resource loading and scene instantiation groundwork

Resource loading and scene instantiation are the next feature bottleneck for real
Godot gameplay projects. This slice should make it possible to load selected
resources and instantiate scenes while keeping ownership transfers explicit.

Keep this roadmap narrow. Do not expose broad asset APIs, arbitrary resource
loading, or scene-changing helpers until the ownership model is explicit and
covered. `RefCounted` and `Resource` remain borrowed by default; any retained or
owned return must use the existing owned wrappers or a new documented wrapper.
`PackedScene.instantiate` must not be generated as a plain borrowed return until
its object ownership and destruction path are clear.

1. Investigate resource loader and packed-scene ownership rules.
   - [x] Inspect Godot 4.7 `ResourceLoader`, `Resource`, and `PackedScene`
     signatures in `extension_api.json`.
   - [x] Decide which return values are borrowed, retained, or owned by the
     caller.
   - [x] Keep unsupported ownership-sensitive methods skipped with stable
     reasons.
   - [x] Document the first safe wrapper policy in code comments near the helper
     implementation.

2. Add a minimal `ResourceLoader` API path.
   - [x] Add selected `ResourceLoader` class or singleton access if available.
   - [x] Start with one checked load helper for paths that returns an explicit
     owned or borrowed wrapper according to the investigated policy.
   - [x] Keep cache mode, threaded loading, dependencies, and broad type hints
     deferred unless the ownership model is clear.
   - [x] Re-export selected helpers through `godot:godot`.

3. Add explicit `PackedScene.instantiate` wrapper.
   - [x] Keep the generated raw method skipped until a focused wrapper documents
     ownership transfer.
   - [x] Return a checked borrowed or owned object handle according to Godot's
     actual lifetime rule.
   - [x] Provide selected typed downcast helpers for common instantiated roots
     such as `Node` and `Node2D`.
   - [x] Avoid implicit freeing or unref behavior for instantiated scene roots.

4. Add safe scene-tree integration helpers if needed.
   - [x] Consider `Node.add_child` only if object lifetime and ownership remain
     clear.
   - [x] Keep scene changing, current-scene replacement, and deletion helpers
     deferred unless each has a focused ownership rule.
   - [x] Prefer checked helper APIs over broad generated wrappers for
     ownership-sensitive paths.

5. Exercise the workflow in examples.
   - [ ] Add or update a normal example that loads or instantiates a scene from
     Odin through `godot:godot` only.
   - [ ] Keep the example deterministic in headless CI.
   - [ ] Destroy or release every owned value on all paths.

6. Update generated reporting.
   - [ ] Report resource-loading and scene-instantiation blockers separately if
     useful.
   - [ ] Keep generated `Resource`, `PackedScene`, and singleton wrappers disabled
     when ownership remains unclear.
   - [ ] Preserve deterministic report and generated output order.

7. Validate before moving to the next feature roadmap.
   - [ ] Run `make ci`.
   - [ ] Confirm no generated wrapper violates borrowed object, `Resource`, or
     `RefCounted` ownership rules.
   - [ ] Confirm normal examples still import only `godot:godot`.

## Deferred until after this goal

- broad singleton coverage beyond selected safe APIs
- event object wrappers and input event lifetime-sensitive APIs
- broad ownership-sensitive scene-tree changes
- broad resource loading and asset APIs
- macro-like or generated user class declarations
- broad automatic method adapter generation
- vararg method adapters
- default-argument adapters for user methods
- broad generated signal wrappers
- arbitrary callable binding helpers
- full virtual method generation
- broad typed container mutation APIs
- broad `Resource`, `PackedScene`, texture, theme, and asset APIs
- `Resource.duplicate` ownership-transfer wrappers
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
