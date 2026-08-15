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

## Current goal: generated class API expansion

Make selected generated Godot class APIs useful for real Odin gameplay code
without weakening the borrowed-object and explicit-owned-value safety model.
This goal is feature-focused: docs and tests are acceptance checks, not the main
objective.

Start with selected high-value scene and UI classes instead of generating the
full Godot class API at once:

- `Object`
- `Node`
- `CanvasItem`
- `Node2D`
- `Control`
- `Label`
- `Sprite2D`
- `Timer`
- `Area2D`
- `CollisionObject2D`
- `Resource`
- `PackedScene`

Classes may be added or deferred based on type-mapping safety. Do not expose APIs
that require ownership rules the project does not have yet.

1. Add generated API support reporting.
   - [x] Emit a deterministic report of generated class methods.
   - [x] Emit a deterministic report of skipped class methods.
   - [x] Include skip reasons such as unsupported type, vararg, default argument,
     object lifetime, typed array, `Callable`, or `Signal`.
   - [x] Make the report useful for choosing the next class or type-mapping
     slice.

2. Expand safe class method type mapping.
   - [ ] Support primitive parameters and returns: `bool`, integer types, and
     `GodotReal`.
   - [ ] Support common math builtins by value where storage and ABI rules are
     already covered.
   - [ ] Support borrowed object/class handles by value.
   - [ ] Support `String`, `StringName`, and `NodePath` only through the existing
     owned-storage and borrowed-pointer rules.
   - [ ] Keep `Variant` parameters borrowed as `^core.Variant`; `Variant` returns
     are owned and require `core.variant_free`.

3. Generate practical scene and UI APIs.
   - [ ] Expand `Node` wrappers for safe name, tree, child, parent, and path
     operations where ownership is clear.
   - [ ] Expand `CanvasItem` wrappers for visibility and common drawing-related
     state where signatures are safe.
   - [ ] Expand `Node2D` wrappers for position, rotation, scale, transform, and
     common movement helpers.
   - [ ] Expand `Control` wrappers for common UI state where signatures are safe.
   - [ ] Expand `Label` wrappers for text and basic display options.
   - [ ] Expand `Sprite2D` wrappers for transform and simple display state;
     defer texture/resource ownership until the reference model is explicit.

4. Add selected node lookup helpers.
   - [ ] Provide safe `NodePath`-based lookup wrappers for selected classes.
   - [ ] Return `(value, ok)` for checked lookup and typed downcast helpers.
   - [ ] Treat nil results and failed class checks as `ok = false`.
   - [ ] Keep returned handles borrowed.

5. Expose selected generated APIs through the public facade.
   - [ ] Re-export only the stable selected class handles and wrappers.
   - [ ] Keep normal examples importing only `godot:godot`.
   - [ ] Keep internal generated packages available for advanced users without
     making them the beginner path.

6. Exercise expanded generated APIs in a real example.
   - [ ] Use Odin to control a Godot scene object through generated APIs.
   - [ ] Include at least one `Label` update and one `Node2D` or `CanvasItem`
     state change.
   - [ ] Keep the beginner example readable and move broad coverage to smoke
     checks when needed.

7. Stabilize generator behavior before broad coverage.
   - [ ] Keep output deterministic.
   - [ ] Avoid name collisions with methods, constants, enums, and helpers.
   - [ ] Prefer small class batches over enabling the full 1000+ class API.
   - [ ] Do not start full `Resource` or `RefCounted` ownership support in this
     roadmap.

Deferred until their safety model is explicit:

- owned `RefCounted` and `Resource` wrappers
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
