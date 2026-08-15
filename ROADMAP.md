# Roadmap

## Long-term goal

Build an Odin GDExtension library :

- safe low-level GDExtension bindings
- explicit Godot value ownership and destruction rules
- borrowed object/class handle APIs by default
- generated bindings that preserve the safety model
- ergonomic user class authoring for normal Godot gameplay code
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

## Current goal: generated gameplay class API expansion

Continue the generated class API roadmap with a small gameplay-focused batch.
The target is enough selected class coverage to build common 2D gameplay systems
from Odin without opening broad unsafe Godot APIs.

Initial class targets from `ROADMAP_GENERATED_CLASSES.md`:

- `Timer`
- `CollisionObject2D`
- `Area2D`
- cautious `Resource` and `PackedScene` evaluation using the new owned-reference
  model

Keep the generator selective. Do not enable the full Godot class API, varargs,
default arguments, `Callable`, broad `Signal`, or object-lifetime-sensitive
methods until their safety rules are explicit.

1. Refresh the generated class API support baseline.
   - [x] Include `Timer`, `CollisionObject2D`, `Area2D`, `Resource`, and
     `PackedScene` in the selected class report candidate analysis.
   - [x] Keep unsupported methods skipped with deterministic reasons.
   - [x] Separate borrowed-safe methods from methods requiring owned wrappers or
     object-lifetime review.
   - [x] Use the report to choose the smallest safe generated method batch.

2. Generate borrowed-safe `Timer` APIs.
   - [x] Add the `Timer` handle, upcasts, downcasts, constants, and enums where
     applicable.
   - [x] Generate primitive and `GodotReal` timer configuration methods such as
     wait time, one shot, autostart, paused, start, and stop where signatures are
     safe.
   - [x] Re-export selected `Timer` APIs through `godot:godot`.
   - [x] Add facade compile coverage and a small runtime use in an example or
     smoke path.

3. Generate borrowed-safe `CollisionObject2D` APIs.
   - [x] Add the `CollisionObject2D` handle and inheritance helpers.
   - [x] Generate safe collision layer, mask, disable mode, input pickable, and
     RID access methods where return ownership is clear.
   - [x] Keep shape owner APIs skipped until object lifetime and container rules
     are explicit.
   - [x] Re-export selected APIs through the facade and add compile coverage.

4. Generate borrowed-safe `Area2D` APIs.
   - [x] Add the `Area2D` handle and checked downcast helpers.
   - [x] Generate monitoring, monitorable, priority, gravity, damping, and audio
     bus methods where signatures are safe.
   - [x] Keep body/area collection APIs, signal-heavy APIs, and callback-heavy
     paths skipped until `Array`, `Signal`, and object-lifetime rules are ready.
   - [x] Exercise at least one `Area2D` method path in smoke coverage if it can
     run headless deterministically.

5. Evaluate `Resource` and `PackedScene` with the owned-reference model.
   - [ ] Reclassify report entries that can now use `OwnedRefCounted` or
     `OwnedResource` safely.
   - [ ] Keep `Resource.duplicate`, texture setters/getters, scene instantiation,
     and broad resource-loading APIs skipped until exact ownership transfer is
     verified.
   - [ ] If a minimal safe `PackedScene` method exists, generate only that method
     and document whether its result is borrowed or owned.
   - [ ] Prefer no generated API over an unclear ownership transfer.

6. Prove normal usage through the public facade.
   - [ ] Keep normal examples importing only `godot:godot`.
   - [ ] Add facade compile checks for every newly exposed class handle and
     method group.
   - [ ] Add or extend a Godot headless smoke path showing one realistic 2D
     gameplay use of the new generated APIs.

7. Validate before moving to the next feature roadmap.
   - [ ] Run `make ci`.
   - [ ] Confirm the generated API report is deterministic and useful.
   - [ ] Confirm no generated wrapper violates borrowed-object or owned-value
     destruction rules.

Deferred until after this goal:

- broad `Resource`, `PackedScene`, texture, theme, and asset APIs
- `Callable` wrappers
- full `Signal` wrappers
- vararg methods
- default arguments
- broad typed arrays and dictionaries
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
