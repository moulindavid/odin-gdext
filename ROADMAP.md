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

- Explicit ownership for Godot values. Owned Variant, String, StringName,
  NodePath, arrays, dictionaries, packed arrays, Callable, Signal, RID, and
  similar values must have matching destruction paths.
- Object and class handles are borrowed unless a helper explicitly documents a
  retain/reference rule.
- RefCounted and Resource remain borrowed by default. Owned references must use
  the explicit OwnedRefCounted or OwnedResource wrappers.
- No raw offset poking in examples, generated code, or public helpers.
- Resolved GDExtension function pointers and method binds must be checked or
  trapped before use.
- Registration metadata must live long enough for the Godot registration that
  uses it.
- Extension classes must unregister during deinitialization.
- Normal examples should import only godot:godot.

## Completed: generated class API expansion

Selected generated Godot class APIs are useful for focused Odin gameplay code
while preserving the borrowed-object and explicit-owned-value safety model. The
completed baseline includes support reporting, safer method type mapping,
practical scene and UI APIs, checked NodePath lookup helpers, public facade
exports, runtime example coverage, and generator guardrails for deterministic
small-batch class expansion.

## Completed: Resource and RefCounted ownership model

RefCounted and Resource now have an explicit owned-reference path while normal
object/class handles remain borrowed by default. The completed slice added
low-level retain/unreference helpers, OwnedRefCounted, OwnedResource, generator
reporting for owned-wrapper-only methods, runtime smoke coverage, and full make
ci validation.

## Completed: generated gameplay class API expansion

The generated gameplay class slice added selected borrowed-safe APIs for common
2D gameplay classes while keeping lifetime-sensitive APIs skipped. Completed
coverage includes Timer, CollisionObject2D, Area2D, and a cautious minimal
PackedScene slice. The public facade and examples exercise these APIs through
godot:godot, and make ci passed for the completed slice.

## Completed: Signals and Callable groundwork

The signal and callable groundwork added owned Callable and Signal storage
helpers, explicit destruction rules, safe object signal connection helpers,
fixed-arity signal emission helpers, generated blocker reporting, facade compile
coverage, smoke/example coverage, and full make ci validation.

## Completed: typed arrays and typed dictionaries

The typed container slice added a first safe model for typed arrays returned by
selected generated APIs. Completed coverage includes typed container ownership
rules, typed array and typed dictionary blocker reporting, TypedArray storage
over Array storage, checked read helpers for borrowed object handles, selected
generated Area2D overlap methods, facade exports, smoke/facade coverage, and
full make ci validation.

## Completed: default arguments and overload ergonomics

The default-argument slice added deterministic convenience wrappers for a small
safe method batch while keeping full-arity generated wrappers canonical.
Completed coverage includes default-argument reporting, parsing for simple safe
defaults, selected default wrappers, public facade exports, facade compile
coverage, example usage, deterministic generated output checks, and full make ci
validation.

## Completed: class authoring ergonomics

The class-authoring slice made custom Odin classes less verbose while keeping
lifecycle and ownership explicit. Completed coverage includes stable registration
metadata storage, a small class builder, fixed-signature method helpers,
typed-property helpers, signal registration helpers, typed instance-data helpers,
facade compile coverage, and a beginner examples/hello class using only
godot:godot. Full make ci passed for the completed slice.

## Completed: Input and scene-tree gameplay APIs

The input and scene-tree slice added borrowed singleton lookup rules, selected
Input query APIs, selected borrowed-safe SceneTree APIs, public facade exports,
generated singleton/input/scene-tree reporting, and real example usage through
godot:godot. Full make ci passed for the completed slice.

## Completed: Resource loading and scene instantiation groundwork

The resource loading and scene instantiation slice made it possible to load
selected resources and instantiate scenes while keeping ownership transfers
explicit. Completed coverage includes selected ResourceLoader singleton APIs,
owned resource loading helpers, explicit PackedScene instantiation helpers,
checked Node.add_child helpers, resource and scene blocker reporting, example
coverage, and full make ci validation.

## Completed: Physics and character gameplay APIs

The physics and character gameplay slice added a small generated API batch for
common 2D physics gameplay. Completed coverage includes selected PhysicsBody2D,
CharacterBody2D, RigidBody2D, StaticBody2D, and CollisionShape2D APIs, facade
exports, downcast/upcast helpers, typed-array helpers, deterministic physics
blocker reporting, example coverage, and full make ci validation.

## Current goal: Generated signal and callable wrappers

Use the completed minimal signal and callable storage model as the base for a
small generated wrapper slice. This should let selected Godot signal APIs become
usable through godot:godot without exposing broad varargs, arbitrary callable
binding, or unclear object lifetime behavior.

Keep this goal narrow. Generate only selected fixed-shape signal/callable APIs
whose arguments and ownership rules are already covered by the project safety
model. Unsupported forms must stay skipped with stable report reasons.

1. Investigate generated signal metadata.
   - [x] Inspect how Godot 4.7 extension_api.json represents class signals for
     selected classes.
   - [x] Choose the first small class and signal batch: Object, Node, Timer,
     Control, CollisionObject2D, and Area2D.
   - [x] Identify no-argument and borrowed-object-argument signal shapes that can
     reuse existing Signal/Callable paths without argument ownership transfer.
   - [x] Keep vararg, bind-argument-heavy, Callable-heavy, and lifetime-sensitive
     signals skipped.

2. Add deterministic signal/callable support reporting.
   - [x] Extend generated API reports to list selected signals separately from
     skipped signal and callable blockers.
   - [x] Include class name, signal name, argument types, and skip reason.
   - [x] Preserve stable output ordering and stable skip reason names.
   - [x] Use the report to choose the smallest safe generated wrapper batch.

3. Generate fixed-shape signal helper wrappers.
   - [x] Start with no-argument signals and then one or two supported argument
     signals.
   - [x] Reuse existing Signal, Callable, and temporary Variant destruction
     helpers.
   - [x] Return checked errors or trap consistently with the existing call-error
     pattern.
   - [x] Do not generate broad vararg emission or arbitrary Callable
     construction.

4. Generate selected signal connection helpers.
   - [ ] Start with connecting an object signal to an existing borrowed Callable
     or selected method callable path that has clear lifetime rules.
   - [ ] Keep object handles borrowed by value.
   - [ ] Keep connection flags explicit and avoid bind-argument helpers for now.
   - [ ] Keep unsupported connection shapes reported rather than generated.

5. Re-export selected wrappers through the public facade.
   - [ ] Keep godot:godot as the normal user path.
   - [ ] Re-export only the signal/callable helpers intended for gameplay code.
   - [ ] Keep low-level godot:core access available but unnecessary for the
     selected path.
   - [ ] Add facade compile checks for generated signal and callable helpers.

6. Exercise the generated signal path in examples.
   - [ ] Use normal examples or smoke coverage to connect or emit a selected
     generated signal through godot:godot.
   - [ ] Keep beginner examples readable and keep broad smoke coverage separate.
   - [ ] Destroy every temporary Variant, owned Callable, and owned Signal on
     every success and failure path.
   - [ ] Avoid relying on timing-sensitive runtime behavior unless CI proves it
     stable.

7. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm generated reports explain remaining signal and callable skips.
   - [ ] Confirm no generated wrapper violates borrowed object or owned value
     destruction rules.
   - [ ] Confirm normal examples still import only godot:godot.

## Deferred

- broad singleton coverage beyond selected safe APIs
- event object wrappers and input event lifetime-sensitive APIs
- broad ownership-sensitive scene-tree changes
- broad resource loading and asset APIs
- macro-like or generated user class declarations
- broad automatic method adapter generation
- vararg method adapters
- default-argument adapters for user methods
- broad generated signal wrappers beyond fixed safe shapes
- arbitrary callable binding helpers
- full virtual method generation
- broad typed container mutation APIs
- broad Resource, PackedScene, texture, theme, and asset APIs
- Resource.duplicate ownership-transfer wrappers
- full 1000+ class API generation

## Validation

- make ci passes.
- Normal examples import only godot:godot.
- At least one example demonstrates a complete user class with:
  - instance data
  - method registration
  - property registration
  - signal registration and emission
  - notification handling
  - generated class handle usage
- Facade compile checks cover the public authoring helpers.
