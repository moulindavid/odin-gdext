# Roadmap

## Long-term goal

Build an Odin GDExtension library that feels close to godot-rust/gdext in
capability while staying Odin-idiomatic:

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
- Owned Resource wrappers may expose borrowed typed handles only while the owned
  wrapper remains alive.
- No raw offset poking in examples, generated code, or public helpers.
- Resolved GDExtension function pointers and method binds must be checked or
  trapped before use.
- Registration metadata must live long enough for the Godot registration that
  uses it.
- Extension classes must unregister during deinitialization.
- Normal examples should import only godot:godot.

## Completed feature slices

These slices are complete and were validated with make ci when merged:

1. Low-level safety and value ownership groundwork.
   - Allocator/context policy, function pointer checks, explicit destruction
     rules, Variant/String/StringName/NodePath/RID/container ownership helpers,
     and primitive/builtin conversions.

2. Generated class API baseline.
   - Deterministic generated class reporting, selected class handles, safer
     method type mapping, checked casts, NodePath lookup helpers, public facade
     exports, and smoke/example coverage.

3. Resource and RefCounted ownership model.
   - Borrowed handles remain the default, with explicit OwnedRefCounted and
     OwnedResource wrappers for retained references.

4. Gameplay class expansion.
   - Selected Object, Node, Node2D, CanvasItem, Control, Timer,
     CollisionObject2D, Area2D, PackedScene, input, scene-tree, physics, and
     character APIs.

5. Signals and Callable groundwork.
   - Owned Callable and Signal storage, fixed-shape signal emission, selected
     generated signal wrappers, safe connection helpers, and blocker reporting.

6. Typed containers and default-argument ergonomics.
   - TypedArray storage over Array storage, checked typed-array reads for
     borrowed object handles, selected typed-array API coverage, and deterministic
     default-argument convenience wrappers.

7. Class authoring ergonomics.
   - Stable registration metadata, class builders, method/property/signal
     descriptors, typed instance-data helpers, virtual callback descriptors, and
     process/physics-process helpers.

8. Broader UI and Control APIs.
   - Selected BaseButton, Button, TextureRect, Panel, and Container handles,
     generated UI method wrappers, UTF-8 text facade helpers, UI blocker
     reporting, and examples/game UI coverage through godot:godot.

9. Broader resource and asset APIs.
   - Selected Texture2D and ImageTexture handles, checked resource downcasts,
     typed OwnedResource loading helpers, a safe texture consumer path,
     deterministic resource blocker reporting, and examples/game asset coverage.

## Current goal: Input event and viewport APIs

Expose a small, useful input-event and viewport API surface for gameplay code
while preserving the borrowed-handle and event-lifetime model. Existing input
polling is useful, but real projects also need selected InputEvent subclasses
and viewport queries for mouse, keyboard, UI, and camera-related systems.

Keep this goal narrow. InputEvent handles are borrowed unless an explicit owned
resource/reference wrapper is added. Do not store event handles beyond the Godot
callback that supplied them, and do not expose broad input-event mutation or
Viewport ownership-sensitive APIs until their lifetime rules are clear.

1. Audit InputEvent and Viewport signatures.
   - [x] Inspect InputEvent, InputEventKey, InputEventMouseButton,
     InputEventMouseMotion, Viewport, Window, and related input/viewport methods.
   - [x] Classify methods by borrowed-safe signatures, explicit owned-wrapper
     needs, and unsupported event-lifetime-sensitive cases.
   - [x] Keep event storage, arbitrary event construction, Viewport texture
     ownership, and server-heavy APIs skipped with deterministic reasons.

2. Add selected generated InputEvent handle coverage.
   - [x] Add selected InputEvent class handles and checked downcasts.
   - [x] Generate only borrowed-safe primitive, StringName, Vector2, and simple
     boolean/query methods.
   - [x] Re-export selected handles and casts through godot:godot.
   - [x] Keep unchecked casts limited to explicit inheritance upcasts.

3. Add selected generated Viewport coverage.
   - [x] Generate small borrowed-safe Viewport query wrappers needed by gameplay
     and UI code.
   - [x] Prefer methods returning primitives, Vector2, Rect2, or borrowed object
     handles with clear nil behavior.
   - [x] Defer ViewportTexture, render target, world, camera, and ownership-heavy
     APIs until resource ownership rules are explicit.

4. Add public facade helpers for common input-event checks.
   - [x] Provide nil-safe helpers for selected InputEvent subclasses.
   - [x] Add checked helpers for common key, mouse button, mouse motion, and
     action-style queries where generated names are too low-level.
   - [x] Keep helpers borrowed by value and document that event handles must not
     be retained after the callback.

5. Exercise the input and viewport path in examples.
   - [ ] Keep examples/game importing only godot:godot.
   - [ ] Add compile or runtime coverage for selected InputEvent downcasts and
     Viewport queries that remains deterministic in headless CI.
   - [ ] Avoid tests that depend on real keyboard or mouse input from CI.

6. Improve generated input and viewport reporting.
   - [ ] Split blocker report categories for input events, viewport resources,
     event construction, and ownership-sensitive viewport APIs where useful.
   - [ ] Keep generated output deterministic.
   - [ ] Use the report to choose the next input or viewport batch.

7. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm normal examples still import only godot:godot.
   - [ ] Confirm generated reports explain remaining input-event and viewport
     skips.
   - [ ] Confirm no event handle storage, hidden ownership transfer, or raw
     offset poking was added.

## Planned next iterations

After the current input-event/viewport slice, pick one roadmap at a time:

1. Animation and tween APIs.
   - AnimationPlayer, Tween, SceneTree tween creation, and callable/signal limits
     needed for common gameplay animation.

2. More UI resource integration.
   - Theme, Font, StyleBox, TextureButton, ProgressBar, and common Control APIs
     once resource lifetimes are proven.

3. Broader 2D gameplay classes.
   - TileMap/TileMapLayer, RayCast2D, Marker2D, Camera2D, NavigationAgent2D, and
     small physics/resource-dependent batches.

4. Higher-level class authoring code generation.
   - Reduce method/property/signal registration boilerplate while preserving
     explicit callbacks, metadata lifetime, and unregistering.

5. Error handling and diagnostics polish.
   - More checked wrappers, clearer traps, generated support summaries, and
     better user-facing failure messages.

6. Packaging and external project workflow.
   - Template project, collection/LSP setup docs, release/versioning policy, and
     repeatable use from a separate Godot game repository.

## Deferred until the related safety model exists

- broad singleton coverage beyond selected safe APIs
- arbitrary input event storage or callbacks
- broad ownership-sensitive scene-tree changes
- broad generated Signal wrappers beyond fixed safe shapes
- broad generated Callable wrappers
- vararg method adapters
- broad typed container mutation APIs
- broad Resource, PackedScene, texture, theme, font, and asset APIs
- Resource.duplicate ownership-transfer wrappers
- full generated virtual method bindings
- full 1000+ class API generation

## Validation baseline

Before considering any roadmap slice complete:

- make ci passes.
- Normal examples import only godot:godot.
- At least one example demonstrates a complete user class with:
  - instance data
  - method registration
  - property registration
  - signal registration and emission
  - notification or virtual callback handling
  - generated class handle usage
- Facade compile checks cover the public authoring helpers and selected generated
  APIs.
- Generated reports explain unsupported APIs with stable reasons.
