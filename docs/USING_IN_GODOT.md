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

The project targets Godot 4.7's `float_64` API shape through `GodotReal`.

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

## Instantiate an Odin-backed class from GDScript

Once the extension is loaded, GDScript can instantiate the registered class by
name:

```gdscript
var hello_node := ClassDB.instantiate("HelloNode")
add_child(hello_node)
```

If GDScript creates the node directly, GDScript should also free it when done:

```gdscript
func _exit_tree() -> void:
    if hello_node != null:
        hello_node.queue_free()
```

The extension class itself should unregister during extension deinitialization.

## Call a method

Odin methods registered through GDExtension can be called from GDScript like any
Godot method:

```gdscript
var value := hello_node.call("roll_math")
print(value)
```

For simple typed methods, prefer the public facade registration helpers. Keep
advanced Variant and ptrcall paths explicit until the signature is covered by a
safe adapter.

## Read and write a property

Editor-visible properties are registered with explicit getter and setter method
names. From GDScript, use normal property access or `set` and `get`:

```gdscript
hello_node.speed = 3.5
print(hello_node.speed)

hello_node.set("speed", 7.0)
print(hello_node.get("speed"))
```

The getter and setter names passed during registration must live in stable
`StringName` storage for the lifetime required by the registered class metadata.

## Connect to a signal

Signals registered by the Odin extension can be connected from GDScript:

```gdscript
hello_node.connect("pinged", _on_pinged)
hello_node.connect("speed_changed", _on_speed_changed)

func _on_pinged() -> void:
    print("Odin signal received")

func _on_speed_changed(value: float) -> void:
    print("new speed: ", value)
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

## Current recommended use

Good first uses are focused systems called by Godot:

- gameplay calculators
- random or procedural math
- deterministic combat or scoring logic
- small Odin-backed classes with simple methods, properties, and signals
- systems where GDScript owns scene wiring and Odin owns the hot or typed logic

For current limitations, see [ROADMAP.md](../ROADMAP.md) and the project README.
