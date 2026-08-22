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

## Current goal: Input and scene-tree gameplay APIs

Input and scene-tree access are likely the next generated API bottleneck for real
gameplay code. This slice should stay small and should first prove singleton and
scene-tree access rules before exposing broader engine APIs.

Keep this roadmap focused on gameplay-facing APIs that preserve the borrowed
object-handle model. Singleton and scene-tree handles must be treated as borrowed
by value. Resource loading, packed-scene instantiation, callable-heavy paths,
event objects, and ownership-sensitive scene changes stay deferred unless a
focused wrapper documents the safety model.

1. Investigate singleton access rules.
   - [x] Identify how selected singleton objects are retrieved through the Godot
     4.7 GDExtension API.
   - [x] Treat returned singleton object handles as borrowed by value.
   - [x] Trap or return `ok = false` when a singleton lookup is unavailable.
   - [x] Keep singleton storage out of user-owned data unless lifetime rules are
     documented.

2. Add a selected `Input` API batch.
   - [x] Generate or hand-wrap a minimal safe path for common input queries.
   - [x] Prefer primitive, `StringName`, and math-builtin signatures already
     covered by the safety model.
   - [x] Keep event objects, resources, arrays, and callable-heavy APIs skipped
     until reviewed.
   - [x] Re-export selected helpers through `godot:godot`.

3. Add a selected `SceneTree` API batch.
   - [x] Expose only borrowed-safe scene-tree queries first.
   - [x] Keep ownership-sensitive APIs such as scene changing, resource loading,
     and packed-scene instantiation deferred unless explicitly wrapped.
   - [x] Use checked object/class downcasts for returned handles.
   - [x] Re-export selected helpers through `godot:godot`.

4. Exercise the batch in examples.
   - [x] Use normal `godot:godot` imports only.
   - [x] Add one real example path that reads input or scene-tree state from
     Odin gameplay code.
   - [x] Keep broad engine coverage in smoke checks, not beginner examples.

5. Update generated reporting.
   - [x] Report singleton, input, and scene-tree blockers separately if useful.
   - [x] Keep unsupported signatures skipped with stable reasons.
   - [x] Preserve deterministic report and generated output order.

6. Validate before moving to the next feature roadmap.
   - [ ] Run `make ci`.
   - [ ] Confirm no generated wrapper violates borrowed singleton or object
     lifetime rules.
   - [ ] Confirm generated output is deterministic.

## Deferred until after this goal

- broad singleton coverage beyond selected safe APIs
- event object wrappers and input event lifetime-sensitive APIs
- ownership-sensitive scene-tree changes
- resource loading and scene instantiation workflows
- macro-like or generated user class declarations
- broad automatic method adapter generation
- vararg method adapters
- default-argument adapters for user methods
- broad generated signal wrappers
- arbitrary callable binding helpers
- full virtual method generation
- broad typed container mutation APIs
- broad `Resource`, `PackedScene`, texture, theme, and asset APIs
- `PackedScene.instantiate` and `Resource.duplicate` ownership-transfer wrappers
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
