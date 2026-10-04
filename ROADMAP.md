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

## Current goal: Release and versioning policy

Define the practical compatibility policy before broader API expansion. Keep the
policy lightweight and useful for external users: supported Godot, Odin, and OLS
versions, generated API refresh expectations, changelog expectations, and how
consumer projects should pin a local checkout. Do not add release automation or a
package-manager abstraction until the policy is clear.

1. Audit current version references and compatibility docs.
   - [ ] Review README, docs/USING_IN_GODOT.md, templates, CI, and Makefile.
   - [ ] Identify every stated Odin, OLS/odinfmt, Godot, and `GodotReal` support
     assumption.
   - [ ] Remove stale version wording and align examples with current CI.

2. Document the supported toolchain policy.
   - [ ] State the currently validated Odin version.
   - [ ] State the currently validated OLS/odinfmt version and expected formatter
     CLI.
   - [ ] State the currently validated Godot 4.7 version and precision target.
   - [ ] Explain whether newer patch versions are expected to work or merely
     best-effort until CI proves them.

3. Define generated API refresh expectations.
   - [ ] Document when `extension_api.json` and generated bindings should be
     refreshed.
   - [ ] Keep generated files ignored and regenerated by CI.
   - [ ] Explain how support reports should be reviewed after generator changes.

4. Define changelog and compatibility expectations.
   - [ ] Add a lightweight changelog or document where release notes should live.
   - [ ] Describe what counts as a breaking change for public facade APIs,
     ownership rules, templates, and generated selected APIs.
   - [ ] Keep the policy honest for a prototype; avoid promising SemVer until the
     project is ready.

5. Validate before moving to the next feature roadmap.
   - [ ] Run make ci.
   - [ ] Confirm normal examples and templates import only godot:godot.
   - [ ] Confirm docs match CI versions and no generated files need committing.
   - [ ] Update this roadmap with completed status and the next feature candidate.

## Planned next iterations

After the current release/versioning policy slice, pick one feature roadmap at a
time:

1. Broader generated API coverage.
   - Continue expanding selected safe Godot APIs based on real game needs.

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
