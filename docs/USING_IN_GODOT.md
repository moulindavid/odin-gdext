# Using odin-gdext in a Godot project

`odin-gdext` is currently best used as a hybrid workflow: Godot owns scenes,
input, UI, resources, and editor workflow, while Odin owns focused gameplay
logic and selected extension classes.

This guide uses the current `examples/game` project as the reference shape.

## Requirements

- Odin compiler on `PATH`.
- `odinfmt` on `PATH` for formatting checks.
- Godot 4.7 on `PATH`.
- `make` and a native toolchain that can build shared libraries.

## Build the extension library

From the repository root:

```sh
make example-game
```

This generates the required GDExtension interface and selected bindings, builds
the beginner example shared library at:

```text
examples/game/bin/game.so
```

and runs the Godot project headless. The lower-level hello example remains
available with:

```sh
make test-hello
```

## Godot project layout

A minimal Godot project that uses an Odin extension usually looks like this:

```text
my_game/
  project.godot
  my_game.gdextension
  bin/
    my_game_ext.so
  scripts/
    main.gd
odin/
  src/
    main.odin
```

The `.gdextension` file tells Godot which exported entry symbol to call and
where the compiled shared library lives. The current hello example uses:

```ini
[configuration]

entry_symbol = "game_library_init"
compatibility_minimum = "4.7"

[libraries]
linuxbsd.x86_64 = "bin/game.so"
windows.x86_64 = "bin/game.dll"
```

The `entry_symbol` must match the exported Odin initialization procedure. The
library paths are relative to the Godot project directory.

## Minimal Odin entry point shape

Normal user-facing code should import the facade package:

```odin
import gt "godot:godot"
```

A typical extension initializes Godot's interface, installs the Godot-backed
Odin context, registers classes during scene initialization, and unregisters
those classes during deinitialization.

The important shape is:

```odin
game_library_init :: proc "c" (
    get_proc_address: gt.InterfaceGetProcAddress,
    library: gt.ClassLibraryPtr,
    initialization: ^gt.Initialization,
) -> gt.Bool {
    ok := gt.initialize_extension(get_proc_address, library, initialization)
    if !ok do return false

    gt.register_initializer(register_scene_classes, .Scene)
    gt.register_deinitializer(unregister_scene_classes, .Scene)
    return true
}
```

Class registration metadata such as class names, parent names, method names,
property metadata, signal names, and hint strings must be stored in stable
storage that outlives the registered class. Use process-lifetime storage for
registered classes.

## Object handles and instance data ownership

Godot object and class handles exposed by `godot:godot` are borrowed by default.
An `ObjectPtr`, `Object`, `Node`, `Node2D`, `Resource`, or similar handle is a
reference to an object owned by Godot unless a helper explicitly documents a
retain or reference-count rule. Passing one of these handles to a generated
wrapper does not transfer ownership to Odin, and storing one does not keep the
Godot object alive.

Extension-owned instance data is separate from the Godot object lifetime. Your
create callback allocates Odin data, attaches it to the Godot object, and your
free callback releases that Odin data. It is valid for that data to store the
owning Godot object pointer as a borrowed handle:

```odin
GameBrainData :: struct {
    object: gt.ObjectPtr, // borrowed owner pointer, not owned by Odin
    difficulty: gt.GodotReal,
}
```

Use that stored pointer only while the instance binding is alive, normally inside
registered method, property, signal, and notification callbacks for the same
object. Do not treat it as a retained reference, do not free it from Odin, and do
not use it after the free callback has run. Storing handles to other Godot
objects is currently unsafe unless normal Godot ownership guarantees their
lifetime, for example a parent owns a child for the whole use window and your
code can tolerate the handle becoming invalid when Godot removes it.

`RefCounted` and `Resource` are exposed today as borrowed handles only. The
facade can call selected methods on them, but it does not yet provide a public
retain/unref-safe wrapper. Do not store a `RefCounted` or `Resource` handle as if
Odin owns a reference unless you add an explicit, audited lifetime helper first.

This is deliberate. Godot 4.7 exposes low-level reference callbacks and
`RefCounted.reference` / `RefCounted.unreference`, and constructing a refcounted
object starts with a reference the caller must eventually release. Those rules
need an owned wrapper before they are safe in normal user code, so the current
facade and generated class API keep `RefCounted` and `Resource` methods
borrowed-only and skip public retain/unref helpers.

The planned owned reference model uses two separate concepts:

- Borrowed handles: `gt.RefCounted` and `gt.Resource` are lightweight views over
  Godot-owned objects. Passing, returning, or storing them does not change the
  reference count.
- Owned handles: `gt.OwnedRefCounted` and `gt.OwnedResource` will represent one
  Odin-owned reference acquired through an explicit retain operation or through
  an API that documents ownership transfer.

The intended Odin rules are:

1. Retain borrowed `RefCounted` or `Resource` handles explicitly before storing
   them beyond the current callback or generated wrapper call.
2. Release owned handles explicitly with a release or destroy helper. There is
   no hidden destructor behavior.
3. Copying an owned wrapper value does not duplicate the Godot reference. Use an
   explicit retain helper to create a second owned reference.
4. Move-like handoff is represented by passing the wrapper by pointer and
   clearing the source to nil after transfer.
5. Nil retain returns `ok = false`. Nil release is a no-op. Releasing an already
   released wrapper is also a no-op so cleanup paths can be simple.
6. Generated class methods continue to return borrowed object handles unless the
   wrapper name or documentation explicitly says the returned value is owned.

## Recommended Odin class authoring layout

For a game-specific extension, keep the Odin side explicit and stable:

1. Store class names, method names, property names, signal names, and hint
   strings in global or otherwise process-lifetime storage.
2. Allocate extension-owned instance data in the create callback.
3. Attach that data to the Godot object with `gt.attach_instance`.
4. Retrieve typed data in callbacks with `gt.class_instance_data`.
5. Register the class and members through `gt.OdinClassDescriptor`.
6. Unregister the class during extension deinitialization.

A typical registration shape is:

```odin
methods := [2]gt.OdinClassMethod{roll_method, set_label_method}
properties := [1]gt.OdinClassProperty{difficulty_property.property}
signals := [1]gt.OdinClassSignal{damage_signal}

gt.register_odin_class(
    gt.OdinClassDescriptor{
        class_name = game_class_name,
        parent_class_name = game_parent_name,
        create_instance_func = create_instance,
        free_instance_func = free_instance,
        methods = methods[:],
        properties = properties[:],
        signals = signals[:],
    },
)
```

`gt.OdinClassDescriptor` does not own or copy metadata. The arrays,
`PropertyInfo`, `ClassMethodInfo`, adapter userdata, names, and hint strings must
remain valid for the registration call and any later Godot reads of that
metadata. The examples use process-lifetime storage for this reason.

Primitive properties can use typed helpers such as
`gt.class_property_godot_real`, `gt.class_property_int`, and
`gt.class_property_bool`. These helpers build the property, getter method, and
setter method descriptors from caller-owned stable storage while preserving the
same Variant and ptrcall ABI rules as the underlying method adapters.

Current simple method adapters cover:

- `() -> void`
- `() -> bool`
- `() -> int`
- `() -> GodotReal`
- `() -> String`, returning owned Godot String storage through the adapter
- `(bool) -> void`
- `(int) -> void`
- `(GodotReal) -> void`
- `(String) -> void`, receiving borrowed String storage for the callback
- `(ObjectPtr) -> void`, receiving a borrowed object handle
- `GodotReal, GodotReal -> GodotReal`

Object handles passed to adapters are borrowed. If you need a specific class,
use checked helpers such as `gt.object_ptr_try_as_label` before calling generated
class methods. Do not store the handle unless Godot ownership guarantees it stays
valid for your whole use window.

Unsupported or deferred signatures include varargs, broad object-lifetime-sensitive
APIs, arbitrary callable binding, broad signal argument shapes, and ownership
transfer that is not explicitly wrapped. For those, keep the raw `Variant` and
ptrcall callbacks explicit until a safe helper exists.

## Node lifecycle callbacks

For common `Node` lifecycle hooks, use `gt.NodeVirtualCallbackDescriptor` from
your class notification callback. The dispatcher maps Godot notifications to
explicit Odin procedures and leaves raw notification handling available for
advanced cases.

```odin
node_virtuals := gt.NodeVirtualCallbackDescriptor{
    ready = on_ready,
    process = on_process,
}

notification :: proc "c" (instance: gt.ClassInstancePtr, what: i32, reversed: bool) {
    context = gt.godot_context()
    self, ok := gt.class_instance_data(instance, MyData)
    if !ok do return

    node, node_ok := gt.object_ptr_try_as_node(self.object)
    if !node_ok do return
    if gt.dispatch_node_virtual_descriptor(instance, node, what, reversed, &node_virtuals) do return
}
```

`process(delta)` and `physics_process(delta)` deltas come from Godot through the
generated `Node.get_process_delta_time` and `Node.get_physics_process_delta_time`
wrappers. Enable those callbacks explicitly, for example from `ready`, with
`gt.node_enable_process_callback(node)` or
`gt.node_enable_physics_process_callback(node)`.

## Instantiate an Odin-backed class from GDScript

Once the extension is loaded, GDScript can instantiate the registered class by
name:

```gdscript
var brain := ClassDB.instantiate("GameBrain")
add_child(brain)
```

If GDScript creates the node directly, GDScript should also free it when done:

```gdscript
func _exit_tree() -> void:
    if brain != null:
        brain.queue_free()
```

The extension class itself should unregister during extension deinitialization.

## Call a method

Odin methods registered through GDExtension can be called from GDScript like any
Godot method:

```gdscript
var value := brain.call("roll_damage")
print(value)
```

For simple typed methods, prefer the public facade registration helpers. Keep
advanced Variant and ptrcall paths explicit until the signature is covered by a
safe adapter.

## Read and write a property

Editor-visible properties are registered with explicit getter and setter method
names. From GDScript, use normal property access or `set` and `get`:

```gdscript
brain.difficulty = 3.5
print(brain.difficulty)

brain.set("difficulty", 7.0)
print(brain.get("difficulty"))
```

The getter and setter names passed during registration must live in stable
`StringName` storage for the lifetime required by the registered class metadata.

## Connect to a signal

Signals registered by the Odin extension can be connected from GDScript:

```gdscript
brain.connect("damage_rolled", _on_damage_rolled)

func _on_damage_rolled(value: float) -> void:
    print("Odin damage roll: ", value)
```

Signal emission helpers destroy temporary `Variant` values on every path. If you
write a custom signal emission path, keep the same cleanup rule.

## Cleanup rules

Keep these rules visible when building real features:

- Odin-owned Godot values such as owned `Variant`, `String`, `StringName`,
  `NodePath`, arrays, dictionaries, and packed arrays must be destroyed with the
  matching facade or core helper.
- `variant_from(...)` is the public construction proc group for representative
  Variant conversions. It returns an owned Variant, so still call
  `variant_free`.
- `variant_try.float(&variant)` plus the other `variant_try.*` helpers are the
  public checked extraction grouping. `Variant` parameters are normally
  borrowed; do not store borrowed Variant pointers beyond the call that provided
  them.
- Object and class handles are borrowed Godot objects. Generated wrappers do not
  take ownership of Godot objects.
- Extension-owned instance data is allocated and freed explicitly by your create
  and free callbacks.
- Class registration metadata must outlive the registered class.
- Registered extension classes must be unregistered during extension
  deinitialization.

## Current limitations

The current recommended model is hybrid Godot plus Odin:

- Godot and GDScript own scenes, input, UI, resources, node lookup, and editor
  workflow.
- Odin owns focused logic and selected extension classes with simple methods,
  properties, and signals.

Incomplete areas to plan around:

- broad generated class coverage beyond the selected common classes
- ergonomic resource loading and node lookup helpers
- `Callable` and broad `Signal` APIs
- varargs, default arguments, and object-lifetime-sensitive signatures
- full virtual callback helpers such as `_process(delta)` and
  `_physics_process(delta)`
- Godot versions or precision modes other than the current Godot 4.7
  `GodotReal` assumption

Before moving a feature into Odin, check that:

1. The Godot APIs you need are available through `godot:godot` or can be wrapped
   with a small explicit helper.
2. Any owned Godot value has a clear matching free call.
3. Any object handle stays borrowed and is not retained as if Odin owned it.
4. Any registered name or metadata lives at least until class unregistration.
5. The method signature fits an existing safe adapter, or you are ready to keep
   Variant and ptrcall handling explicit.
6. A small Godot smoke path can exercise the feature headless.

## Current recommended use

Good first uses are focused systems called by Godot:

- gameplay calculators
- random or procedural math
- deterministic combat or scoring logic
- small Odin-backed classes with simple methods, properties, and signals
- systems where GDScript owns scene wiring and Odin owns the hot or typed logic

For current limitations, see [ROADMAP.md](../ROADMAP.md) and the project README.
