# Roadmap

## Long-term goal

Build the Odin equivalent of [godot-rust/gdext](https://github.com/godot-rust/gdext):
an idiomatic, safe, practical Godot 4 GDExtension library for real game
development in Odin, while staying Odin-idiomatic and explicit about ownership.

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

17. Error handling and diagnostics polish.
   - Added diagnostics audit notes, allocation-free diagnostic descriptors,
     diagnostic variants for selected resource loading, scene instantiation, and
     signal emission helpers, concise diagnostic printing, facade compile
     coverage, examples/game diagnostic output, and full make ci validation.

18. Packaging and external project workflow.
   - Added a minimal external hello template with Odin source, Makefile,
     `.gdextension`, and `ols.json` files for a separate Godot project plus Odin
     extension layout. Added `check-template` validation, included the template
     in formatting and CI, documented the local collection workflow, and
     validated with full make ci.

19. Release and versioning policy.
   - Added a lightweight compatibility policy documenting validated Odin,
     OLS/odinfmt, Godot, and `GodotReal` assumptions; generated API refresh
     expectations; and compatibility-sensitive change categories. Added a
     lightweight changelog, aligned README and usage/template docs with CI, and
     validated with full make ci.

20. 2D utility generated APIs.
   - Added selected generated `PathFollow2D` and `VisibleOnScreenNotifier2D`
     handles, casts, upcasts, and borrowed-safe methods. Exposed the selected
     surface through `godot:godot`, added facade compile coverage, exercised both
     classes in examples/game, updated generated reporting and CHANGELOG, and
     validated with full make ci.

21. NavigationAgent2D generated APIs.
   - Added selected generated `NavigationAgent2D` handle, casts, and
     borrowed-safe primitive, vector, color, RID, and packed-vector path query
     methods while leaving enum/bitfield/result-return navigation APIs skipped.
     Exposed the selected surface through `godot:godot`, added facade compile
     coverage, exercised runtime configuration in examples/game, updated
     generated reporting and CHANGELOG, and validated with full make ci.

22. Root window generated APIs.
   - Added selected generated `Window` handle, casts, upcasts, and borrowed-safe
     root-window query methods plus `Node.get_window` and `SceneTree.get_root`.
     Exposed the selected surface through `godot:godot`, added facade compile
     coverage, exercised runtime root-window access in examples/game, updated
     generated reporting and CHANGELOG, and validated with full make ci.

23. TextureProgressBar generated APIs.
   - Added selected generated `TextureProgressBar` handle, casts, upcasts, and
     borrowed-safe texture, tint, fill, radial, and stretch-margin methods.
     Exposed the selected surface through `godot:godot`, added facade compile
     coverage, exercised runtime configuration in examples/game, updated
     generated reporting and CHANGELOG, and validated with full make ci.

## Current goal: Awaiting next generated API slice

Pick the next small generated API batch from concrete gameplay needs. Continue
expanding selected safe Godot APIs while preserving borrowed object handles,
explicit owned value destruction, deterministic support reporting, facade
exports, compile coverage, and runtime example coverage.

## Planned next iterations

Pick one generated API roadmap at a time.

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
