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

12. Animation and tween APIs.
   - Selected AnimationPlayer and Tween handles, borrowed-safe control/query
     wrappers, SceneTree.create_tween as a borrowed returned handle, facade
     helpers, deterministic blocker reporting, compile coverage, examples/game
     coverage, and full make ci validation.

13. More scene and resource workflows.
   - Selected Resource, ResourceLoader, and Node scene/resource query wrappers,
     explicit OwnedResource PackedScene loading helpers, checked scene
     instantiate-and-add helpers, deterministic resource/scene blocker reporting,
     examples/game workflow coverage, facade checks, and full make ci validation.

14. Broader 2D gameplay classes.
   - Selected Camera2D, Marker2D, and RayCast2D generated handles, checked casts,
     borrowed-safe primitive/vector/enum/RID/object methods, facade helpers,
     deterministic 2D gameplay blocker reporting, examples/game coverage, facade
     checks, and full make ci validation.

## Current goal: More UI resource integration

Expand selected UI and resource-facing APIs that are common in real Godot UI
work while preserving explicit Resource ownership and borrowed object handles.
This should make Odin UI code less dependent on hand-written GDScript glue for
texture buttons, progress/status UI, theme resources, fonts, and style boxes.

Keep this goal narrow. Prefer safe consumer/query paths first. Do not expose
broad Theme, Font, StyleBox, texture, or Resource mutation APIs until returned
resource ownership and long-lived editor/runtime storage are explicit.

1. Audit UI resource API gaps.
   - [ ] Inspect TextureButton, ProgressBar, Range, Theme, Font, StyleBox, and
     related common UI classes.
   - [ ] Classify borrowed-safe primitive/query/consumer methods separately from
     resource-returning, theme-mutation, font-data, stylebox-data, and
     ownership-sensitive APIs.
   - [ ] Add or refine generated report categories for UI resource blockers.

2. Add selected generated UI resource coverage.
   - [ ] Add a small safe class batch, starting with TextureButton, Range, and
     ProgressBar if their selected methods fit current type rules.
   - [ ] Generate primitive, enum, vector, borrowed-object, and borrowed-resource
     consumer methods only where ownership stays explicit.
   - [ ] Keep Theme, Font, StyleBox, and broad texture/resource returns skipped
     until owned-wrapper helpers are designed.

3. Add facade helpers for common UI usage.
   - [ ] Add nil-safe helpers where generated names are too low-level for common
     UI control setup.
   - [ ] Keep Texture2D, Theme, Font, StyleBox, and Resource handles borrowed
     unless wrapped in OwnedResource.
   - [ ] Avoid hidden retain, unref, or destroy behavior.

4. Exercise selected APIs in examples.
   - [ ] Update examples/game with deterministic UI resource usage through
     godot:godot only.
   - [ ] Avoid editor-only assumptions and headless-unstable rendering checks.
   - [ ] Keep resource cleanup explicit.

5. Add facade and reporting coverage.
   - [ ] Add compile checks for selected generated UI resource APIs and helpers.
   - [ ] Confirm generated reports explain remaining UI resource skips.
   - [ ] Keep generated output deterministic.

6. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm examples/game and examples/hello import only godot:godot.
   - [ ] Confirm no hidden ownership transfer, temporary Variant leak, broad
     Resource lifetime change, or raw offset poking was added.
   - [ ] Update this roadmap and the generated-class roadmap with completed
     status and the next feature candidate.

## Planned next iterations

After the current UI resource integration slice, pick one feature roadmap at a time:

1. Higher-level class authoring code generation.
   - Reduce method/property/signal/virtual registration boilerplate while
     preserving explicit callbacks, metadata lifetime, and unregistering.

2. Error handling and diagnostics polish.
   - More checked wrappers, clearer traps, generated support summaries, and
     better user-facing failure messages.

3. Packaging and external project workflow.
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
