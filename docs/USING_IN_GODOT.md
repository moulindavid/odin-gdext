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
- `Variant` parameters are normally borrowed. Do not store borrowed Variant
  pointers beyond the call that provided them.
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
