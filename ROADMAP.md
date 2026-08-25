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

## Completed: Generated signal and callable wrappers

The generated signal/callable wrapper slice made selected Godot signals usable
through godot:godot without enabling broad varargs or arbitrary callable binding.
Completed coverage includes signal metadata parsing, selected signal reporting,
generated fixed-shape signal name/Signal/emit/connect wrappers, facade exports,
facade compile coverage, smoke runtime coverage, and full make ci validation.

## Current goal: Virtual callbacks and process helpers

Make normal Odin classes feel closer to Godot script classes for common lifecycle
and frame callbacks while preserving explicit registration and callback safety.
This is the next practical step toward a rust-gdext-like authoring experience:
users should be able to define ready, enter_tree, exit_tree, process, and
physics_process handlers without manually matching raw notification numbers.

Keep this goal narrow. Use the existing notification dispatch path and generated
Node process APIs. Do not fake delta values, generate broad virtual methods, or
hide registration/deinitialization rules.

1. Audit the current notification and virtual callback model.
   - [x] Inspect existing NodeVirtualCallbacks, notification dispatch helpers,
     and example usage.
   - [x] Verify Godot notification IDs used for ready, enter tree, exit tree,
     process, and physics process.
   - [x] Verify the safe source for process delta and physics process delta.
   - [x] Keep raw notification dispatch available for advanced users.

2. Add typed Node virtual callback descriptors.
   - [x] Provide a user-facing descriptor for common Node callbacks.
   - [x] Support ready, enter_tree, exit_tree, process(delta), and
     physics_process(delta) where delta is verified.
   - [x] Keep callbacks explicit Odin procedures and avoid macro-like hidden
     registration for now.
   - [x] Preserve explicit reversed notification handling.

3. Add process enablement helpers.
   - [x] Provide small facade helpers for enabling and disabling process and
     physics_process on extension-owned Node instances.
   - [x] Reuse generated Node.set_process and Node.set_physics_process wrappers.
   - [x] Keep object handles borrowed by value.
   - [x] Avoid event/input callback helpers in this slice.

4. Update examples to use the virtual callback helpers.
   - [x] Keep examples importing only godot:godot.
   - [x] Update hello or game to use typed ready and process-style helpers.
   - [x] Keep the beginner example readable and smoke coverage broader.
   - [x] Ensure extension classes still unregister during deinitialization.

5. Add compile and smoke coverage.
   - [x] Add facade compile checks for the new callback descriptor and process
     helpers.
   - [x] Add deterministic runtime smoke coverage for ready and, if stable in
     headless CI, process or physics_process.
   - [x] Keep timing-sensitive assertions out unless CI proves them stable.
   - [x] Preserve existing signal, property, method, and generated class coverage.

6. Update reporting or docs only where useful.
   - [ ] Document the callback and delta source in code comments near the helper.
   - [ ] Keep full virtual method generation deferred.
   - [ ] If generator reporting needs a virtual-method blocker section, add it
     deterministically.

7. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm normal examples still import only godot:godot.
   - [ ] Confirm no raw offset poking or hidden ownership transfer was added.
   - [ ] Confirm raw notification access remains available.

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
