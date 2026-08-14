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
- `RefCounted` and `Resource` remain borrowed-only until an owned reference model
  is designed and tested.
- No raw offset poking in examples, generated code, or public helpers.
- Resolved GDExtension function pointers and method binds must be checked or
  trapped before use.
- Registration metadata must live long enough for the Godot registration that
  uses it.
- Extension classes must unregister during deinitialization.
- Normal examples should import only `godot:godot`.

## Completed baseline

The project is currently usable for hybrid Godot plus Odin features:

- Priority 0 safety baseline for allocators, Variant/String cleanup, function
  pointer checks, and registration cleanup.
- Priority 0.5 CI baseline with generated binding checks, unit tests, facade
  checks, and Godot headless smoke coverage.
- Priority 1 core value ownership and conversion helpers for `Variant`,
  strings, names, paths, RID, containers, packed arrays, and generated math
  builtins.
- Priority 2 selected generated class handles, constants, enums, downcasts, and
  public facade exports.
- Priority 3 user class registration helpers for class creation, instance
  binding, method metadata, simple typed adapters, and notifications.
- Priority 4 early properties, signals, notification dispatch, and virtual-style
  helpers.
- Real usage layer: `docs/USING_IN_GODOT.md`, a beginner game example,
  split hello/smoke examples, `make example-game`, and documented limitations.

## Completed: safe object and user-class model

The object/reference model is explicit enough to support real project usage:

- Object and class handles are borrowed by default.
- `RefCounted` and `Resource` remain borrowed-only until an owned reference model
  is designed.
- Selected typed class handles have nil, upcast, downcast, and object pointer
  helpers.
- User class descriptors reduce registration boilerplate while keeping creation,
  freeing, metadata lifetime, and unregistering explicit.
- Public `Variant` conversion helpers follow a consistent construction and
  checked extraction pattern.
- Selected generated classes include common scene/UI handles such as `Sprite2D`
  and `Label`.
- `make ci` validates the current model.

## Current goal: ergonomic user class authoring

The next step toward a rust-gdext-like library is to make normal Odin class
authoring structured and repeatable without hiding ownership or GDExtension
lifetime rules.

1. Add a typed class descriptor pattern.
   - [x] Provide a small descriptor shape for an Odin-backed class.
   - [x] Group class name, parent name, create/free callbacks, notification
     callbacks, methods, properties, and signals.
   - [x] Keep registration and unregistration explicit.
   - [x] Keep all stable metadata storage owned by the extension code.
   - [x] Update `examples/hello` or `examples/game` to use the pattern.

2. Add typed property adapter helpers.
   - [ ] Start with primitive properties: `GodotReal`, `int`, and `bool`.
   - [ ] Add getter and setter adapters that retrieve typed Odin instance data.
   - [ ] Preserve ptrcall ABI rules.
   - [ ] Keep temporary `Variant` destruction explicit on call paths.
   - [ ] Add facade compile coverage and smoke coverage.

3. Add typed method adapters for common signatures.
   - [ ] Support `() -> String` and `String -> void` once ownership is clear.
   - [ ] Support simple object-handle parameters only as borrowed values.
   - [ ] Add fixed arity helpers for common game code before broad generation.
   - [ ] Defer varargs, default arguments, `Callable`, `Signal`, and complex
     ownership-sensitive signatures.

4. Improve notification and virtual callback ergonomics.
   - [ ] Provide a compact callback table for common node lifecycle events.
   - [ ] Keep raw notification numbers available.
   - [ ] Verify a safe source for `_process(delta)` and `_physics_process(delta)`
     before exposing typed delta callbacks.
   - [ ] Do not fake delta values.

5. Add a real usage example that exercises the authoring model.
   - [ ] Add or update an example where Odin controls a `Label` or `Sprite2D`.
   - [ ] Trigger behavior from Godot input, such as pressing Space.
   - [ ] Use random numbers, math helpers, a property, a signal, and a generated
     class handle.
   - [ ] Keep the beginner example clean and move broad checks to smoke.

6. Add documentation for the class authoring model.
   - [ ] Document the recommended layout for a game-specific Odin extension.
   - [ ] Show how to register and unregister classes.
   - [ ] Explain instance data ownership.
   - [ ] Explain method/property/signal metadata lifetime.
   - [ ] List unsupported signatures clearly.

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
