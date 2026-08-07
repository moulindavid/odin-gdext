# Hello GDExtension example

Build from the repository root:

```sh
make hello
```

Run the headless smoke test:

```sh
make test-hello
```

Or open this directory as a Godot project. The extension registers `HelloNode`,
then `coucou.gd` creates it and calls:

```gdscript
var node: Object = ClassDB.instantiate("HelloNode")
var result: Variant = node.call("add", 7.0, 6.0)
```

Expected output includes:

```text
HelloNode created!
hello.add(7.0, 6.0) = 13.0
```

This example is intentionally low-level and manual. It demonstrates the current
prototype pipeline: generated GDExtension interface bindings, manual class
registration, a GDScript-callable method, basic Variant conversion, generated
math/utility binding smoke checks, and class unregistration during module
deinitialization.

If it does not open in Godot or the smoke test does not run, the generated
bindings, extension build, or local Godot setup may need to be refreshed.
