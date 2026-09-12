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

## Current goal: More scene and resource workflows

Expand real gameplay workflows around loading and instantiating resources while
preserving the borrowed-object default and explicit owned-resource rules. This
slice should make common scene spawning and asset lookup more useful without
opening broad ownership-transfer APIs.

Keep this goal narrow. Prefer selected helper paths over broad generated
coverage. Do not expose Resource.duplicate, broad PackedScene state mutation, or
lifetime-sensitive scene-tree changes until ownership and destruction are clear.

1. Audit scene and resource workflow gaps.
   - [ ] Inspect PackedScene, ResourceLoader, Resource, Node, and SceneTree
     methods needed for common spawn/load workflows.
   - [ ] Classify borrowed-safe methods separately from ownership-transfer,
     cache, threaded-loading, duplicate, and scene-tree lifetime-sensitive APIs.
   - [ ] Keep generated report categories stable for scene/resource blockers.

2. Add selected generated scene/resource coverage.
   - [ ] Add only borrowed-safe query/control wrappers that fit the current
     Resource and OwnedResource model.
   - [ ] Keep PackedScene.instantiate routed through explicit checked facade
     helpers until ownership transfer is fully documented.
   - [ ] Keep Resource.duplicate and broad scene-state APIs deferred.

3. Improve facade helpers for common loading and spawning.
   - [ ] Add or refine typed load helpers for selected Resource-derived handles.
   - [ ] Add nil-safe checked spawn/add-child helper combinations for common
     Node and Node2D workflows.
   - [ ] Keep all returned object/class handles borrowed unless wrapped in
     OwnedResource or another explicit owned type.

4. Exercise workflows in examples.
   - [ ] Update examples/game with deterministic resource/scene workflow usage.
   - [ ] Keep normal examples importing only godot:godot.
   - [ ] Avoid CI behavior that depends on editor-only asset import side effects.

5. Add facade and reporting coverage.
   - [ ] Add compile checks for selected scene/resource helpers and generated
     APIs.
   - [ ] Confirm generated reports explain remaining scene/resource skips.
   - [ ] Keep generated output deterministic.

6. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm examples/game and examples/hello import only godot:godot.
   - [ ] Confirm no hidden ownership transfer, temporary Variant leak, broad
     scene-tree lifetime change, or raw offset poking was added.
   - [ ] Update this roadmap and the generated-class roadmap with completed
     status and the next feature candidate.

## Planned next iterations

After the current scene/resource workflow slice, pick one feature roadmap at a time:

1. Broader 2D gameplay classes.
   - TileMap/TileMapLayer, RayCast2D, Marker2D, Camera2D, NavigationAgent2D, and
     small physics/resource-dependent batches.

2. More UI resource integration.
   - Theme, Font, StyleBox, TextureButton, ProgressBar, and common Control APIs
     once resource lifetimes are proven.

3. Higher-level class authoring code generation.
   - Reduce method/property/signal/virtual registration boilerplate while
     preserving explicit callbacks, metadata lifetime, and unregistering.

4. Error handling and diagnostics polish.
   - More checked wrappers, clearer traps, generated support summaries, and
     better user-facing failure messages.

5. Packaging and external project workflow.
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
