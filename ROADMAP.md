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

## Current goal: Broader resource and asset APIs

Make common asset workflows usable from Odin gameplay code without weakening the
ownership model. The first target is loading resources, downcasting them to
selected borrowed typed handles, and passing those handles into generated APIs
only while the owning wrapper remains alive.

Keep this goal narrow. Do not expose broad cache APIs, Resource.duplicate,
threaded loading, arbitrary resource mutation, or full texture/theme/font APIs
until each ownership transfer and lifetime rule is explicit.

1. Audit resource and asset signatures.
   - [x] Inspect ResourceLoader, Resource, Texture2D, ImageTexture, AudioStream,
     PackedScene, TextureRect, Button, Sprite2D, and common asset consumers.
   - [x] Identify methods that fit the existing OwnedResource, borrowed handle,
     String, StringName, RID, primitive, and math-builtin rules.
   - [x] Keep threaded loading, cache-sensitive APIs, duplicate/instantiate
     ownership transfers, theme/font/stylebox APIs, and unsupported server APIs
     skipped with deterministic reasons.
   - [x] Prefer a small texture-first batch before audio, themes, or broader
     Resource coverage.

2. Add selected generated resource handle coverage.
   - [x] Add selected handles for Texture2D and ImageTexture if their safe method
     surface is useful.
   - [x] Generate checked downcasts from Resource/Object to selected resource
     handle types.
   - [x] Keep resource handles borrowed by value, never ownership-transferring.
   - [x] Re-export selected handles and casts through godot:godot.

3. Add typed OwnedResource helper APIs.
   - [x] Add checked helpers that load a resource and expose a borrowed typed
     handle while the OwnedResource remains alive.
   - [x] Make the lifetime rule obvious in procedure names and comments.
   - [x] Return ok = false for nil resources, failed loads, or failed class
     checks.
   - [x] Keep destruction explicit through owned_resource_destroy.

4. Enable one safe asset-consumer path.
   - [ ] Add or generate a small texture consumer path such as TextureRect or
     Sprite2D texture assignment.
   - [ ] Require the caller to keep the OwnedResource alive for as long as Godot
     may use the borrowed texture handle.
   - [ ] Avoid hiding Godot node/resource ownership behind broad convenience APIs.
   - [ ] Keep theme, font, stylebox, material, and event-object APIs deferred.

5. Exercise the asset path in examples.
   - [ ] Update examples/game to load one texture-like resource and use it
     through godot:godot only.
   - [ ] Keep the example deterministic in headless CI.
   - [ ] Preserve existing method, property, signal, virtual callback, scene,
     physics, and UI coverage.

6. Improve generated resource reporting.
   - [ ] Refine report categories for texture, audio, theme/font/stylebox,
     threaded loading, duplicate, and cache-related blockers.
   - [ ] Use the report to choose the next asset batch instead of manually
     patching generated files.

7. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm normal examples still import only godot:godot.
   - [ ] Confirm generated reports explain remaining resource and asset skips.
   - [ ] Confirm no hidden ownership transfer or raw offset poking was added.

## Planned next iterations

After the current resource/asset slice, pick one roadmap at a time:

1. Input event and viewport APIs.
   - Minimal InputEvent wrappers, Viewport mouse/keyboard queries, and event
     lifetime rules for callbacks.

2. Animation and tween APIs.
   - AnimationPlayer, Tween, SceneTree tween creation, and callable/signal limits
     needed for common gameplay animation.

3. More UI resource integration.
   - Theme, Font, StyleBox, TextureButton, ProgressBar, and common Control APIs
     once resource lifetimes are proven.

4. Broader 2D gameplay classes.
   - TileMap/TileMapLayer, RayCast2D, Marker2D, Camera2D, NavigationAgent2D, and
     small physics/resource-dependent batches.

5. Higher-level class authoring code generation.
   - Reduce method/property/signal registration boilerplate while preserving
     explicit callbacks, metadata lifetime, and unregistering.

6. Error handling and diagnostics polish.
   - More checked wrappers, clearer traps, generated support summaries, and
     better user-facing failure messages.

7. Packaging and external project workflow.
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
