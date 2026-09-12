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

15. More UI resource integration.
   - Selected TextureButton, Range, and ProgressBar generated handles, checked
     casts, borrowed Texture2D consumer methods, primitive Range and ProgressBar
     methods, deterministic UI resource blocker reporting, examples/game coverage,
     facade checks, and full make ci validation.

16. Higher-level class authoring code generation.
   - Added class authoring audit notes, a compact caller-owned
     ClassAuthoringDescriptor layer, simple GodotReal method and property
     shortcut storage, hello example coverage through godot:godot, facade
     compile checks, and full make ci validation.

## Current goal: Error handling and diagnostics polish

Make failures easier to diagnose without weakening the safety model. Prefer
checked helpers and deterministic diagnostic text around already-supported API
paths. Do not add broad exception-style handling or hide Godot CallError values
behind implicit global state.

1. Audit current checked and trapping helper coverage.
   - [ ] Inspect object construction, method bind lookup, Variant call, signal
     emission, resource loading, scene instantiation, and class registration
     helpers.
   - [ ] Identify places where callers only get `false` or a trap without enough
     context to debug the failed Godot operation.
   - [ ] Keep trap behavior for impossible nil function pointers and required
     method binds.

2. Add small diagnostic descriptors for common checked paths.
   - [ ] Provide compact operation/context strings for selected checked helpers.
   - [ ] Keep descriptors caller-owned or static and allocation-free.
   - [ ] Preserve returned `CallError` values where the current API exposes them.

3. Improve selected checked helper failure messages.
   - [ ] Start with resource loading, scene instantiation, object construction,
     and signal emission paths used by examples.
   - [ ] Avoid logging noisy success-path messages.
   - [ ] Do not introduce hidden Variant ownership changes.

4. Add facade coverage for diagnostics helpers.
   - [ ] Compile-check public diagnostic descriptor and checked helper APIs from
     tests/facade.
   - [ ] Keep normal examples importing only godot:godot.

5. Exercise one diagnostic path in examples or smoke coverage.
   - [ ] Prefer deterministic missing-resource or nil-object paths.
   - [ ] Keep runtime output concise and useful.

6. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm no hidden ownership transfer, temporary Variant leak, broad
     Resource lifetime change, or raw offset poking was added.
   - [ ] Update this roadmap with completed status and the next feature candidate.

## Planned next iterations

After the current diagnostics slice, pick one feature roadmap at a time:

1. Packaging and external project workflow.
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
