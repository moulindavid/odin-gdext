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

## Current goal: Signals and Callable groundwork

Add a small, safe signal and callable model so generated gameplay APIs can grow
beyond direct method calls. This is the next feature bottleneck for real Godot
usage: `Area2D`, UI controls, timers, and many scene systems rely on connecting,
emitting, and handling signals.

Keep this roadmap narrow. Start with explicit, fixed-shape helpers and generated
support reporting. Do not enable broad vararg signal emission, arbitrary
`Callable` construction, or generated signal wrappers until ownership and
temporary `Variant` cleanup are proven.

1. Define signal and callable ownership rules.
   - [x] Document borrowed versus owned `Callable` and `Signal` storage rules in
     code comments near the wrappers.
   - [x] Decide which helpers return owned initialized values and which only
     borrow existing Godot storage.
   - [x] Document temporary `Variant` cleanup rules for signal arguments.
   - [x] Keep unsupported callable/signal forms skipped with stable reasons in
     generated reports.

2. Add minimal `Callable` storage helpers.
   - [x] Add `Callable` storage, pointer helpers, copy/init helpers, and a
     destructor if the Godot ABI exposes them through builtin APIs.
   - [x] Add nil/trap checks for any constructor, destructor, or method bind used
     by the wrappers.
   - [x] Add a compile or smoke check proving owned `Callable` values are
     destroyed on every path.
   - [x] Do not expose arbitrary lambda/object binding helpers until the object
     lifetime model is explicit.

3. Add minimal `Signal` storage helpers.
   - [x] Add `Signal` storage, pointer helpers, copy/init helpers, and a
     destructor if needed by the Godot ABI.
   - [x] Support constructing or retrieving a signal only through safe selected
     paths.
   - [x] Keep signal values owned or borrowed according to explicit helper names.
   - [x] Add focused tests for destruction and type checks where practical.

4. Add safe object signal connection helpers.
   - [ ] Wrap selected Godot object signal connection APIs behind helpers with
     explicit object-handle borrowing rules.
   - [ ] Start with connecting an object signal to an existing `Callable`.
   - [ ] Return checked errors or trap consistently based on the existing call
     error pattern.
   - [ ] Defer flags-heavy or bind-argument-heavy connection helpers until the
     minimal path is proven.

5. Add safe signal emission helpers.
   - [ ] Keep the existing no-argument emission path working through the public
     facade.
   - [ ] Add fixed-arity primitive emission helpers, starting with one and two
     primitive arguments.
   - [ ] Destroy every temporary `Variant` on success and failure paths.
   - [ ] Return or trap on `GDExtensionCallError` consistently.
   - [ ] Defer broad vararg emission helpers.

6. Teach the generator to report signal and callable blockers.
   - [ ] Extend generated API reporting to separate skipped `Callable` and
     `Signal` methods from other unsupported signatures.
   - [ ] Identify a small set of generated APIs that become safe once the minimal
     helpers exist.
   - [ ] Keep generated wrappers disabled for APIs whose object lifetime or
     argument ownership remains unclear.

7. Exercise the minimal model in examples.
   - [ ] Use normal `godot:godot` imports only.
   - [ ] Add or update a real example where Odin registers or emits a signal in a
     way visible from the Godot project.
   - [ ] If safe connection is ready, connect a selected Godot signal to an Odin
     method or callable path.
   - [ ] Keep broad smoke coverage separate from the beginner example.

8. Validate before moving to the next feature roadmap.
   - [ ] Run `make ci`.
   - [ ] Confirm every temporary `Variant`, owned `Callable`, and owned `Signal`
     has an explicit destruction path.
   - [ ] Confirm generated reports explain remaining signal/callable skips.
   - [ ] Confirm normal examples still import only `godot:godot`.

## Deferred until after this goal

- broad vararg signal emission
- arbitrary callable binding helpers
- default arguments and overload ergonomics
- typed arrays and typed dictionaries
- broad `Resource`, `PackedScene`, texture, theme, and asset APIs
- `PackedScene.instantiate` and `Resource.duplicate` ownership-transfer wrappers
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
