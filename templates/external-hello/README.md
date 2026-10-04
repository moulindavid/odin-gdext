# External hello template

This is a minimal starter for using `odin-gdext` from a separate Odin extension
folder next to a normal Godot project.

Expected local layout:

```text
my_game/
  project.godot
  external_hello.gdextension
  bin/
my_game_odin/
  Makefile
  ols.json
  src/main.odin
odin-gdext/
```

Copy this template directory to `my_game_odin/`, then copy
`external_hello.gdextension` into the Godot project root.

Build the shared library into the Godot project:

```sh
make ODIN_GDEXT=../odin-gdext GODOT_PROJECT=../my_game
```

The Makefile passes the odin-gdext checkout as an Odin collection:

```sh
-collection:godot=../odin-gdext
```

That makes this import resolve:

```odin
import gt "godot:godot"
```

For editor tooling, update `ols.json` so the `godot` collection path points at
your local `odin-gdext` checkout. Use an absolute path if your editor opens this
folder from a different working directory.

The template registers a `HelloNode` class with:

- `roll_math() -> float`
- `speed: float`
- `speed_changed(value: float)`
- a `_ready` notification callback through `NodeVirtualCallbackDescriptor`
