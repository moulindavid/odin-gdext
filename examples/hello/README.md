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
var result := node.add(7.0, 6.0)
```

Expected output includes:

```text
HelloNode created!
hello.add(7.0, 6.0) = 13.0
```

This example is intentionally low-level and manual. It demonstrates the current
prototype pipeline: generated GDExtension interface bindings, manual class
registration, a GDScript-callable method, basic Variant conversion, and generated
math/utility binding smoke checks.

If it doesn´t open in godot or test dont run -> we might have some problem
