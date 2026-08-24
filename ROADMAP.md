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

## Completed: Resource loading and scene instantiation groundwork

Resource loading and scene instantiation are the next feature bottleneck for real
Godot gameplay projects. This slice should make it possible to load selected
resources and instantiate scenes while keeping ownership transfers explicit.

Keep this roadmap narrow. Do not expose broad asset APIs, arbitrary resource
loading, or scene-changing helpers until the ownership model is explicit and
covered. `RefCounted` and `Resource` remain borrowed by default; any retained or
owned return must use the existing owned wrappers or a new documented wrapper.
`PackedScene.instantiate` must not be generated as a plain borrowed return until
its object ownership and destruction path are clear.

## Current goal: Physics and character gameplay APIs

Add a small generated API slice for common 2D physics gameplay. This should make
basic Odin gameplay code able to move a character body, inspect simple collision
state, and use selected collision object helpers without opening broad physics
server, RID-heavy, or shape/resource ownership surfaces.

Keep this roadmap narrow. Use existing primitive, math builtin, borrowed object,
typed-array, and explicit-owned-value rules. Do not generate broad physics server
APIs, `InputEvent` APIs, shape/resource mutation APIs, or object-lifetime-sensitive
helpers until their ownership and callback rules are explicit.

1. Investigate selected physics class signatures.
   - [ ] Inspect Godot 4.7 `CharacterBody2D`, `PhysicsBody2D`, `RigidBody2D`,
     `StaticBody2D`, and `CollisionShape2D` signatures in `extension_api.json`.
   - [ ] Identify a small borrowed-safe method batch using existing type rules.
   - [ ] Keep RID-heavy, server-heavy, shape-resource, and lifetime-sensitive
     methods skipped with stable reasons.
   - [ ] Decide which classes belong in this batch before expanding generator
     coverage.

2. Generate selected physics class handles and methods.
   - [ ] Add selected physics classes to the small generated class batch.
   - [ ] Generate only methods using supported primitive, `GodotReal`, math
     builtin, borrowed object, and typed-array mappings.
   - [ ] Keep object returns borrowed by value and owned value returns explicitly
     documented.
   - [ ] Re-export selected handles and wrappers through `godot:godot`.

3. Add focused facade helpers where generated wrappers are not enough.
   - [ ] Add checked helpers only for common safe patterns that need downcasts or
     nil handling.
   - [ ] Avoid wrappers that imply ownership transfer or hidden freeing.
   - [ ] Keep unchecked casts limited to explicit inheritance upcasts.

4. Exercise the physics API in examples.
   - [ ] Update a normal example or smoke path to call selected physics wrappers
     through `godot:godot` only.
   - [ ] Keep the runtime path deterministic in headless CI.
   - [ ] Avoid relying on real input events or physics frames unless the CI path
     proves them stable.

5. Update generated reporting.
   - [ ] Add physics-specific blocker reporting if it helps choose the next
     small batch.
   - [ ] Preserve deterministic output and stable skip reasons.
   - [ ] Confirm generated reports still separate resource, scene, input,
     typed-container, callable, and default-argument blockers.

6. Validate before moving to the next feature roadmap.
   - [ ] Run `make ci`.
   - [ ] Confirm no generated wrapper violates borrowed object, `Resource`,
     `RefCounted`, RID, or owned value rules.
   - [ ] Confirm normal examples still import only `godot:godot`.

## Deferred

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
