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

## Completed: generated class API expansion

Selected generated Godot class APIs are now useful for focused Odin gameplay
code while preserving the borrowed-object and explicit-owned-value safety model.
The generated class slice includes support reporting, safer method type mapping,
practical scene/UI APIs, checked `NodePath` lookup helpers, public facade exports,
runtime example coverage, and generator guardrails for deterministic small-batch
class expansion.

## Current goal: Resource and RefCounted ownership model

The next deferred feature from generated class expansion is an explicit owned
reference model for `RefCounted` and `Resource`. The goal is to keep borrowed
object handles as the default while adding a small, auditable owned-reference
path for APIs that return or store refcounted Godot objects.

This goal should unlock safer future work around `Resource`, `PackedScene`,
textures, themes, and other object-lifetime-sensitive generated APIs. Do not
broaden generated `Resource` or `RefCounted` APIs until the ownership rules are
implemented and smoke-tested.

1. Define the owned reference design.
   - [ ] Document the distinction between borrowed object handles, borrowed
     `RefCounted`/`Resource` handles, and owned references.
   - [ ] Decide the public wrapper shape for an owned refcounted handle.
   - [ ] Specify copy, move-like handoff, release, and nil behavior in Odin
     terms.
   - [ ] Keep normal generated object/class returns borrowed unless a wrapper
     explicitly documents ownership transfer.

2. Add low-level retain and release helpers.
   - [ ] Wrap Godot 4.7 `RefCounted` reference and unreference calls safely.
   - [ ] Trap or return `ok = false` for nil handles.
   - [ ] Preserve borrowed-only behavior for existing typed class handles.
   - [ ] Add focused unit or compile checks for helper signatures.

3. Add an owned `RefCounted` wrapper.
   - [ ] Store a typed borrowed handle plus ownership state explicitly.
   - [ ] Provide init, retain, release, and destroy helpers.
   - [ ] Make double-release and nil-release behavior explicit.
   - [ ] Avoid hidden destructor behavior that would surprise Odin users.

4. Add an owned `Resource` wrapper on top of the `RefCounted` model.
   - [ ] Support checked creation from a borrowed `Resource` handle.
   - [ ] Support explicit release through the same refcount path.
   - [ ] Keep generated `Resource` method wrappers borrowed by default.
   - [ ] Do not expose broad resource-loading APIs until ownership is verified.

5. Update generated class skip rules.
   - [ ] Reclassify deferred `Resource` and `RefCounted` APIs based on the new
     ownership model.
   - [ ] Keep APIs such as `duplicate`, texture setters/getters, and scene
     resource APIs skipped until their exact return ownership is known.
   - [ ] Make the generated API report distinguish borrowed-safe APIs from APIs
     requiring an owned reference wrapper.

6. Add a minimal runtime smoke path.
   - [ ] Exercise one owned `Resource` or `RefCounted` retain/release path in a
     Godot headless example.
   - [ ] Prove existing borrowed handle usage still works.
   - [ ] Ensure every owned reference acquired in the smoke path is released.

7. Validate the model before expanding resource-heavy APIs.
   - [ ] Run `make ci`.
   - [ ] Keep normal examples importing only `godot:godot`.
   - [ ] Do not enable broad `Resource`, `PackedScene`, texture, theme, or asset
     APIs until this goal is complete.

Deferred until after this goal:

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
