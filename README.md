# Odin bindings for Godot 4 ![Godot 4.7.0](https://img.shields.io/badge/Godot-4.7.0-478CBF?style=flat&logo=godotengine&logoColor=white)

**odin-gdext** provides Odin language bindings for [Godot 4](https://godotengine.org/)
via the *GDExtension* C API.

> **Status:** hybrid-feature prototype. You can use it for focused Odin-backed
> game systems inside a normal Godot project, but it is not a complete Godot API
> binding yet. Current smoke-tested scope: Godot 4.7
> Godot 4.7 float ABI generation, manual lifecycle callbacks, registration
> helpers for user classes and simple methods/properties/signals, basic Variant
> helpers, typed object handle experiments, selected generated class wrappers,
> generated math builtin bindings, and partial utility function bindings.

## Requirements

- Odin compiler on `PATH` (currently validated with `dev-2026-07`).
- `odinfmt` on `PATH`.
- Godot **4.7** on `PATH`.
- Currently targets Godot 4.7's `float_64` API shape through `GodotReal`.
- `make` and a platform toolchain capable of building shared libraries.

## Quick start

For the beginner Godot workflow, start with:

```sh
make example-game
```

That builds `examples/game/bin/game.so`, prepares the Godot extension cache, and runs the small example project headless. For lower-level validation and generation workflows:

```sh
# Dump Godot's extension API (requires Godot 4.7 on PATH)
make extension-api

# Generate ALL bindings (FFI + builtin types + utility functions)
make builtins
make interface

# Build the hello-world extension
make hello

# Test in Godot headless
make test-hello

# Run the full local validation baseline used by CI
make ci
```

A single `make hello` runs interface + builtins + build automatically, so it may
create or refresh generated files under `core/`, `bindings/builtin/`, and
`bindings/utilities.odin` before building the example extension.

`make check` type-checks the `core` package with `-vet -strict-style` and
`-default-to-nil-allocator`. Additional focused checks are available for the
generator, generated bindings, and public facade.

## Validation and CI

Use `make ci` before opening a pull request or starting a larger roadmap slice.
It performs a clean validation pass in a fixed order:

1. `make clean`
2. `make fmt-check`
3. `make interface`
4. `make builtins`
5. `make check`
6. `make check-generator`
7. `make check-bindings`
8. `make check-godot`
9. `make test-unit`
10. `make test-smoke`
11. `make test-hello`
12. `make example-game`

`make test-unit` is the minimal Odin unit-test harness for focused tests that do
not need to launch Godot. Odin's test runner allocates internally, so that target
keeps `-vet` and `-strict-style` but intentionally omits
`-default-to-nil-allocator`. Runtime integration is still covered by
`make test-smoke`, which keeps broad runtime coverage, plus the beginner `make example-game` workflow.

The GitHub Actions workflow in `.github/workflows/ci.yml` installs Odin,
downloads `odinfmt` from the OLS tooling releases, downloads Godot 4.7, and runs
`make ci`. Generated bindings remain ignored by git; CI regenerates and checks
them instead of requiring generated output commits.

## Imports

Normal examples should start with the public facade only:

```odin
import gt "godot:godot"
```

The facade re-exports the stable core value helpers, selected generated builtin,
utility, and class APIs, and the registration pieces needed by the hello example.
Low-level `godot:core` remains available for advanced GDExtension C ABI work,
but common class registration should not need to import it directly. Import
internal generated packages directly only when working outside the selected
facade coverage:

```odin
import bind "godot:bindings"            // generated @GlobalScope utilities
import builtin "godot:bindings/builtin" // generated builtin-type bindings
```

## Editor-visible extension classes

For Godot 4.7, an extension class must be registered with exposed class
creation metadata, a registered parent class name, and a `.gdextension` file
that points at the exported entry symbol. User classes should register methods,
properties, and signals after registering the class. Optional tool-script style
workflows and custom editor icons are deferred until their lifetime and reload
behavior is explicit.

Use `godot.register_editor_visible_class` for the low-level explicit path, or
`godot.register_odin_class` with `godot.OdinClassDescriptor` when registering an
Odin-backed class with methods, properties, and signals together. The class name,
parent name, method names, property metadata, signal names, and hint strings
passed to registration helpers must live at least until the class is unregistered
during extension deinitialization. Process-lifetime `ClassName` and
`StaticStringName` storage is the intended pattern.

## User class registration notes

For class and parent names, use `ClassName` storage through the public facade:

```odin
player_name_data: gt.ClassName
player_parent_name_data: gt.ClassName
player_name := gt.class_name_ptr(&player_name_data)
player_parent_name := gt.class_name_ptr(&player_parent_name_data)

gt.class_name_init_latin1_cstring(&player_name_data, cstring("Player"))
gt.class_name_init_latin1_cstring(&player_parent_name_data, cstring("Node2D"))
```

The backing `ClassName` storage must outlive the registered class. Use global or
otherwise process-lifetime storage for registered class names and parent names.
Do not create class-name storage as a temporary local value and keep the returned
pointer after that storage goes out of scope.

Instance data remains extension-owned. Allocate it explicitly in your create
callback, attach it with `gt.attach_instance`, retrieve it with
`gt.class_instance_data`, and free it explicitly in your free callback:

```odin
self := new_clone(PlayerData{object = object})
gt.attach_instance(object, player_name, self, &player_instance_binding_callbacks)

self, ok := gt.class_instance_data(instance, PlayerData)
if ok do free(self)
```

The helper only calls Godot's `set_instance` and `set_instance_binding` for the
caller-provided pointer. It does not allocate, retain, unref, or free extension
owned data.

Object and class handles in the facade are borrowed by default. This includes
`ObjectPtr`, selected typed handles such as `Node` or `Node2D`, and the current
`RefCounted` and `Resource` handles. Generated wrappers do not take ownership of
Godot objects, and storing a handle in Odin data does not keep that object alive.

It is safe for extension-owned instance data to store the owning object pointer
as a borrowed handle when that data is attached in the create callback and freed
in the matching free callback:

```odin
PlayerData :: struct {
    object: gt.ObjectPtr, // borrowed owner pointer, not owned by Odin
}
```

Use stored object handles only while Godot still owns the object and the instance
binding is alive. Do not free Godot objects from Odin through these handles, do
not use them after the free callback runs, and do not treat `RefCounted` or
`Resource` handles as retained references until a public retain/unref model is
added.

For now, `RefCounted` and `Resource` stay borrowed-only in the public facade.
Godot 4.7 has low-level reference callbacks and `RefCounted` reference methods,
but constructing a refcounted object gives the caller a reference that must be
released later. odin-gdext intentionally defers public retain/unref helpers until
there is an owned wrapper that can make that balance explicit.

Notification helpers provide a small dispatch pattern for common `Node`
lifecycle notifications while keeping raw notification numbers available for
advanced handling:

```odin
ready :: proc(instance: gt.ClassInstancePtr, reversed: bool) {
	_ = reversed
	self, ok := gt.class_instance_data(instance, PlayerData)
	if !ok do return
	_ = self
}

player_notifications := gt.NodeNotificationHandlers{
	ready = ready,
}

notification_func :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
	context = gt.godot_context()
	if gt.dispatch_node_notification(instance, what, reversed, &player_notifications) do return
	if what == gt.node_notification_ready {
		// Raw notification numbers remain available when needed.
	}
}
```

Class authoring helpers use explicit descriptors over caller-owned stable
metadata storage. `godot.OdinClassDescriptor` groups class creation callbacks,
methods, properties, and signals without taking ownership of the backing storage.
For advanced signatures, call and ptrcall callbacks can stay fully explicit so
Variant construction/destruction and ptrcall ABI casts remain under user control.
For simple signatures, the facade exposes typed callbacks backed by stable
adapter userdata:

```odin
member_defaults := gt.class_member_defaults(empty_name, empty_string)
gt.init_method_property_info(
	&arg_info[0],
	gt.class_member_property(member_defaults, .Float, arg_name),
)

// Global or otherwise process-lifetime storage.
real2_adapter: gt.ClassMethodGodotReal2ToGodotRealAdapter
real2_adapter.method = add_adapter_method

gt.register_class_method_with_descriptor(class_name, &method_info, gt.ClassMethodDescriptor{
	name = method_name,
	method_userdata = &real2_adapter,
	call_func = gt.class_method_godot_real2_to_godot_real_call,
	ptrcall_func = gt.class_method_godot_real2_to_godot_real_ptrcall,
	return_value_info = &return_info,
	argument_count = 2,
	arguments_info = &arg_info[0],
	arguments_metadata = &arg_meta[0],
})
```

The helper fills `PropertyInfo` and `ClassMethodInfo`; it does not copy or own
metadata arrays and does not change Variant/ptrcall ownership rules. Keep method
names, argument names, hint strings, `PropertyInfo`, metadata arrays,
`ClassMethodInfo`, and adapter userdata storage alive for the registration call.
Available simple typed adapters currently cover `() -> void`, `() -> bool`,
`() -> int`, `() -> GodotReal`, `() -> String`, `(bool) -> void`,
`(int) -> void`, `(GodotReal) -> void`, `(String) -> void`,
`(ObjectPtr) -> void`, and `GodotReal, GodotReal -> GodotReal`. String-returning
adapters return owned Godot String storage through the adapter and String
argument adapters borrow the String only for the callback. Object handle
arguments are borrowed and should be checked with helpers such as
`object_ptr_try_as_label` before using a specific generated class API. Varargs,
default arguments, `Callable`, `Signal`, owned `RefCounted` or `Resource`
transfer, and broad object-lifetime-sensitive method adapters are intentionally
deferred until their safety model is explicit.

## API coverage

This project is still a prototype. It aims for a small, safe, smoke-tested
subset before broad Godot API coverage. Detailed sequencing lives in
[ROADMAP.md](ROADMAP.md).

### Usable now

- Runtime: generated GDExtension interface bindings, Godot-backed allocator
  context, checked function-pointer loading, and CI validation.
- Values: owned-storage helpers for `Variant`, `String`, `StringName`,
  `StaticStringName`, `NodePath`, `RID`, `Array`, `Dictionary`, packed arrays,
  and generated math builtins.
- Generated APIs: math/simple builtin wrappers, supported non-vararg
  `@GlobalScope` utilities, and selected borrowed class handles for `Object`,
  `RefCounted`, `Resource`, `Node`, `CanvasItem`, `Node2D`, and `Control`.
- User classes: `OdinClassDescriptor`, stable class names, instance binding,
  method/property/signal descriptors, primitive property helpers, simple typed
  method adapters, node lifecycle callback dispatch, and editor-visible metadata.
- Facade: normal examples can import only `godot:godot`. The smoke example
  covers class creation, methods, property access, signal emission,
  notifications, value conversions, and unregister cleanup.

### Still incomplete

The current recommended model is hybrid Godot plus Odin: Godot/GDScript owns
scenes, input, UI, resources, and editor workflow while Odin owns focused logic
and selected extension classes.

- Full 1000+ class coverage.
- `Callable`, `Signal`, typed arrays/dictionaries, and broad complex conversions.
- Varargs, default arguments, and object-lifetime-sensitive signatures.
- Broad typed method adapter generation and full virtual callback helpers such
  as `_process(delta)` and `_physics_process(delta)`.
- Rich node lookup and resource loading helpers.
- Other Godot versions and precision targets. Current Godot 4.7 float ABI
  assumptions are centralized behind `GodotReal`.

### Safe-use checklist

Before moving a feature into Odin, verify that the Godot APIs you need are
available through the facade or can be wrapped explicitly, owned values have a
matching free call, object handles remain borrowed, registration metadata lives
long enough, the method signature has a safe adapter or explicit Variant path,
and a small Godot smoke path can exercise the feature.

### Ownership rules to remember

- Object/class handles are borrowed by value. Generated wrappers do not own,
  retain, unref, or free Godot objects.
- Owned value wrappers must be destroyed explicitly with their matching free
  helper, for example `variant_free`, `string_free`, or `array_free`.
- Use `variant_from(...)` for facade-level Variant construction and
  `variant_try.float(&variant)` plus the other `variant_try.*` helpers for
  checked extraction. `variant_from` returns an owned Variant that still needs
  `variant_free`.
- Generated wrappers borrow completed owned value parameters by pointer and
  return initialized owned values with destruction comments.
- Extension-owned instance data is allocated and freed by your callbacks. It
  may store the owning Godot object pointer only as a borrowed handle.
- `RefCounted` and `Resource` handles are not retained by the public facade yet;
  treat them as borrowed until an explicit reference-count helper exists.
- Registration metadata storage must outlive the registration that uses it. Use
  process-lifetime storage for class names, method names, property names, signal
  names, and hint strings.

## Architecture

```
odin-gdext/
├── generator/                <- codegen (FFI, builtin types, utilities, classes)
├── core/                     <- C-ABI + handwritten runtime
├── bindings/
│   ├── builtin/              <- generated builtin type bindings
│   ├── classes/              <- selected generated class wrappers
│   └── utilities.odin        <- generated @GlobalScope functions
├── godot/                    <- thin re-export facade
└── examples/hello/           <- smoke-tested example extension
```

- `core/` -- handwritten runtime: C-ABI types, owned Variant storage helpers,
  typed object handle experiments, Godot-backed allocator, class registration
  helpers, `BuiltinMethod` lazy-init pattern.
- `generator/` -- reads `gdextension_interface.json` and `extension_api.json`.
  Emits `core/interface*.odin`, `bindings/builtin/*.odin` for the currently
  supported builtin slice, and `bindings/utilities.odin` for supported
  @GlobalScope utility signatures.
- `bindings/builtin/` -- code-generated for simple/math builtin types: struct
  layout from real member offsets, `to_variant`/`from_variant`, constructors,
  instance/static methods, enums. Complex/value-owning builtins such as `String`,
  `StringName`, `NodePath`, `Callable`, `Signal`, `Array`, `Dictionary`,
  and packed arrays are not complete yet.
- `bindings/utilities.odin` -- code-generated non-vararg @GlobalScope utility
  functions whose return and argument types are currently supported. Utilities
  involving unsupported complex types are skipped until their safety rules are defined.
- `godot/` -- small handwritten convenience facade, not a complete re-export of
  every generated API.

### Layers

| Layer | Description | Status |
|-------|-------------|--------|
| `core/` | C-ABI types, helpers, owned Variant storage helpers, typed handle experiments, context | Partial |
| `generator/` | Codegen for FFI, builtin types, utility functions, selected classes | Partial |
| `bindings/builtin/` | Math/simple builtin types (Vector2..Projection) with methods | Partial |
| `bindings/utilities.odin` | Supported @GlobalScope utility functions | Partial |
| `godot/` facade | Small convenience re-export package | Partial |
| `bindings/classes/` | Selected per-class API wrappers for engine classes | Partial |
| Properties/signals | Descriptors, registration helpers, and simple emission helpers | Partial |
| Virtual callbacks | Notification dispatch helpers for common Node lifecycle callbacks | Partial |

## Roadmap

See [ROADMAP.md](ROADMAP.md) for the short plan.

## License

Apache 2.0 -- see [LICENSE](LICENSE).
