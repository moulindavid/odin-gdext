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

## Current goal: class authoring ergonomics

Make custom Odin classes less verbose to write while preserving the explicit
safety model. This is the main gap between the current low-level registration
helpers and the kind of day-to-day authoring experience people expect from a
rust-gdext-like library.

Keep this roadmap focused on helper APIs, not magic. Users should still see the
important lifecycle pieces: class registration, instance allocation, method
adapters, properties, signals, notifications, and unregister cleanup. The goal is
to remove repetitive metadata boilerplate, not to hide ownership or lifetime
rules.

1. Add stable registration storage helpers.
   - [x] Provide reusable storage structs for class names, parent names, method
     names, property names, signal names, and hint strings.
   - [x] Keep backing storage caller-owned and long-lived for the registered
     class.
   - [x] Make `StaticStringName` and `String` initialization less repetitive for
     registration metadata.
   - [x] Do not hide explicit class unregister during deinitialization.

2. Add a small class builder API.
   - [x] Provide a begin/register/finalize pattern for one extension class.
   - [x] Keep create, free, and notification callbacks explicit.
   - [x] Register methods, properties, and signals through builder helpers.
   - [x] Trap or return errors consistently when required metadata or function
     pointers are missing.

3. Add higher-level method descriptor helpers.
   - [x] Add concise helpers for common fixed signatures such as no-argument
     methods, `GodotReal -> void`, and `GodotReal, GodotReal -> GodotReal`.
   - [x] Preserve the existing call and ptrcall adapter safety rules.
   - [x] Keep raw descriptors available for advanced signatures.
   - [x] Do not add varargs, default-argument adapters, `Callable`, or `Signal`
     method signatures in this slice.

4. Add higher-level property helpers.
   - [x] Add helpers for common editor-visible properties such as `GodotReal`,
     `bool`, `int`, and `String` where ownership rules are clear.
   - [x] Keep getter and setter method names explicit and backed by stable
     storage.
   - [x] Reuse the existing `PropertyInfo` construction path.
   - [x] Keep hints, hint strings, and usage flags visible to the caller.

5. Add higher-level signal registration helpers.
   - [x] Add concise helpers for no-argument signals and fixed primitive
     argument signals.
   - [x] Reuse the existing signal metadata storage and emission cleanup rules.
   - [x] Keep broad vararg signals deferred.
   - [x] Keep generated signal wrappers separate from user class signal
     registration helpers.

6. Add typed instance callback helpers.
   - [x] Provide small helpers for retrieving typed extension-owned instance
     data inside callbacks.
   - [x] Preserve explicit allocation and freeing of extension-owned data.
   - [x] Keep the owning Godot object handle borrowed by value.
   - [x] Add nil checks for invalid `ClassInstancePtr` and missing instance
     data.

7. Convert a beginner example to the authoring helpers.
   - [x] Keep `examples/hello` importing only `godot:godot`.
   - [x] Show one class with instance data, one method, one property, one signal,
     and notification handling.
   - [x] Keep broad coverage in `examples/smoke` instead of the beginner
     example.
   - [x] Keep unregister cleanup explicit and visible.

8. Validate before moving to the next feature roadmap.
   - [x] Add facade compile checks for the new authoring helpers.
   - [x] Run `make ci`.
   - [x] Confirm normal examples import only `godot:godot`.
   - [x] Confirm registration metadata storage outlives registration.

## Deferred until after this goal

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
