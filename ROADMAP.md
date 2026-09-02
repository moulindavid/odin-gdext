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

10. Input event and viewport APIs.
   - Selected InputEvent, InputEventKey, InputEventMouseButton,
     InputEventMouseMotion, and Viewport handles, checked casts, borrowed-safe
     query wrappers, facade helpers, deterministic example coverage, and input
     or viewport blocker reporting.

11. Virtual callback model for gameplay classes.
   - Public callback descriptors, typed Node notification dispatch, verified
     process and physics-process delta sourcing, borrowed InputEvent callback
     adapters, class-builder metadata integration, facade coverage, and
     examples/game plus smoke coverage through godot:godot.

## Current goal: Animation and tween APIs

Expose a small animation and tween API surface for common gameplay polish while
preserving the existing Callable, Signal, Variant, object-handle, and resource
ownership rules. This is the next practical feature gap after custom classes can
run ready/process/input-style callbacks.

Keep this goal narrow. Start with borrowed-safe AnimationPlayer queries and
simple SceneTree/Tween creation or control paths only when ownership is clear.
Do not expose broad tween callback binding, varargs, or animation resource
mutation until the safety model is explicit.

1. Audit animation and tween APIs.
   - [ ] Inspect AnimationPlayer, Tween, SceneTree tween creation, and common
     callback or signal shapes.
   - [ ] Classify borrowed-safe methods separately from resource-owned,
     Callable-heavy, vararg, and lifetime-sensitive APIs.
   - [ ] Add stable generated report categories for animation and tween blockers.

2. Add selected AnimationPlayer generated coverage.
   - [ ] Generate the AnimationPlayer handle, checked casts, and safe query or
     primitive control methods.
   - [ ] Re-export selected APIs through godot:godot.
   - [ ] Defer Animation resource mutation and callback-heavy APIs.

3. Add selected Tween generated coverage.
   - [ ] Generate the Tween handle and safe primitive control/query methods.
   - [ ] Keep Tween handles borrowed unless a clear ownership path is proven.
   - [ ] Defer broad tweener construction, Callable callbacks, and varargs.

4. Add small facade helpers for common animation usage.
   - [ ] Add nil-safe helper procedures around selected AnimationPlayer and
     Tween handles.
   - [ ] Add checked helper names for common play/stop/running paths if generated
     names are too low-level.
   - [ ] Keep object/class handles borrowed by value.

5. Exercise animation/tween APIs in examples.
   - [ ] Update examples/game or smoke with deterministic animation/tween usage.
   - [ ] Keep normal examples importing only godot:godot.
   - [ ] Avoid CI behavior that depends on real frame timing beyond verified
     headless-safe calls.

6. Add facade and reporting coverage.
   - [ ] Add compile checks for selected animation and tween APIs.
   - [ ] Confirm generated reports explain remaining animation/tween skips.
   - [ ] Keep generated output deterministic.

7. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm examples/game and examples/hello import only godot:godot.
   - [ ] Confirm no hidden ownership transfer, temporary Variant leak, broad
     Callable binding, or raw offset poking was added.
   - [ ] Update this roadmap and the generated-class roadmap with completed
     status and the next feature candidate.

## Planned next iterations

After the current animation/tween slice, pick one feature roadmap at a time:

1. More scene and resource workflows.
   - Safer PackedScene instantiation, ResourceLoader coverage, selected resource
     ownership-transfer APIs, and typed load helpers for common game assets.

2. Broader 2D gameplay classes.
   - TileMap/TileMapLayer, RayCast2D, Marker2D, Camera2D, NavigationAgent2D, and
     small physics/resource-dependent batches.

3. More UI resource integration.
   - Theme, Font, StyleBox, TextureButton, ProgressBar, and common Control APIs
     once resource lifetimes are proven.

4. Higher-level class authoring code generation.
   - Reduce method/property/signal/virtual registration boilerplate while
     preserving explicit callbacks, metadata lifetime, and unregistering.

5. Error handling and diagnostics polish.
   - More checked wrappers, clearer traps, generated support summaries, and
     better user-facing failure messages.

6. Packaging and external project workflow.
   - Template project, collection/LSP setup docs, release/versioning policy, and
     repeatable use from a separate Godot game repository.

## Deferred until the related safety model exists

- broad singleton coverage beyond selected safe APIs
- arbitrary input event storage
- broad ownership-sensitive scene-tree changes
- broad generated Signal wrappers beyond fixed safe shapes
- broad generated Callable wrappers
- vararg method adapters
- broad typed container mutation APIs
- broad Resource, PackedScene, texture, theme, font, and asset APIs
- Resource.duplicate ownership-transfer wrappers
- broad generated virtual method bindings
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
