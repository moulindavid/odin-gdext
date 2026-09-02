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

## Current goal: Virtual callback model for gameplay classes

Make custom Odin classes feel closer to godot-rust/gdext's everyday gameplay
workflow while staying Odin-idiomatic and explicit. The target is not macro
magic, but a small, safe authoring layer where users can define instance data and
wire common Godot callbacks such as ready, process, physics process, input, and
unhandled input without hand-writing raw notification dispatch each time.

Keep this goal narrow. Virtual callbacks must still use explicit registration,
stable metadata storage, borrowed object handles, and explicit temporary value
cleanup. InputEvent handles passed to callbacks are borrowed and must not be
stored beyond the callback.

1. Define the virtual callback authoring shape.
   - [x] Choose a small public descriptor shape for user callbacks.
   - [x] Cover ready, enter tree, exit tree, process, physics process, input,
     and unhandled input as the first target set.
   - [x] Keep raw notification fallback available for advanced use.
   - [x] Document callback argument ownership near the helper APIs.

2. Add typed dispatch helpers for common Node callbacks.
   - [ ] Convert Godot notifications into typed Odin callbacks where the data is
     already available safely.
   - [ ] Preserve explicit reversed handling.
   - [ ] Keep process and physics-process delta sourcing through the verified
     Node process callback path, not guessed notification data.
   - [ ] Trap or return checked errors consistently with existing callback
     helpers.

3. Add InputEvent callback helpers.
   - [ ] Add a borrowed InputEvent callback adapter for _input-like methods.
   - [ ] Add a borrowed InputEvent callback adapter for _unhandled_input-like
     methods if the callback path is verified.
   - [ ] Reuse the existing InputEvent downcasts and facade helpers.
   - [ ] Do not allow storing event handles in extension-owned data without an
     explicit owned/copy model.

4. Integrate virtual descriptors into class registration helpers.
   - [ ] Let class builder or registration metadata include the common virtual
     callback descriptor.
   - [ ] Keep create, free, method, property, signal, and unregister flows
     explicit.
   - [ ] Avoid broad code generation until the hand-written helper shape is
     proven in examples.

5. Exercise the model in examples.
   - [ ] Update examples/game with a small custom Odin gameplay class using
     ready, process or physics process, input, a property, and a signal.
   - [ ] Keep normal examples importing only godot:godot.
   - [ ] Keep deterministic CI coverage separate from real keyboard or mouse
     input when needed.

6. Add facade and smoke coverage.
   - [ ] Add compile checks for the public virtual callback descriptors.
   - [ ] Keep smoke coverage exercising registration, instance binding,
     generated class handles, properties, signals, and virtual callbacks.
   - [ ] Confirm every temporary Variant and borrowed InputEvent path is cleaned
     up or bounded to the callback.

7. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm examples/game and examples/hello import only godot:godot.
   - [ ] Confirm no raw offset poking, hidden object ownership transfer, or event
     handle retention was added.
   - [ ] Update this roadmap and the generated-class roadmap with completed
     status and the next feature candidate.

## Planned next iterations

After the current virtual-callback slice, pick one feature roadmap at a time:

1. Animation and tween APIs.
   - AnimationPlayer, Tween, SceneTree tween creation, and typed callable/signal
     limits needed for common gameplay animation.

2. More scene and resource workflows.
   - Safer PackedScene instantiation, ResourceLoader coverage, selected resource
     ownership-transfer APIs, and typed load helpers for common game assets.

3. Broader 2D gameplay classes.
   - TileMap/TileMapLayer, RayCast2D, Marker2D, Camera2D, NavigationAgent2D, and
     small physics/resource-dependent batches.

4. More UI resource integration.
   - Theme, Font, StyleBox, TextureButton, ProgressBar, and common Control APIs
     once resource lifetimes are proven.

5. Higher-level class authoring code generation.
   - Reduce method/property/signal/virtual registration boilerplate while
     preserving explicit callbacks, metadata lifetime, and unregistering.

6. Error handling and diagnostics polish.
   - More checked wrappers, clearer traps, generated support summaries, and
     better user-facing failure messages.

7. Packaging and external project workflow.
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
