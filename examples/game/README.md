# Game example

This is the beginner-facing example for using `odin-gdext` from a normal Godot
project.

Godot owns the scene and input. Odin registers a small `GameBrain` class that
rolls damage, emits a signal, and updates a Godot `Label` through the generated
borrowed `Label` handle API.

The class exposes:

- `roll_damage() -> float`
- `roll_into_label(label: Label) -> void`
- `difficulty: float`
- `damage_rolled(value: float)`

Press Space in the running project to call Odin again and update the label.

Run it from the repository root with:

```sh
make example-game
```

For now, the project layout mirrors the intended target:

```text
examples/game/
  game.gdextension
  main.gd
  main.tscn
  src/main.odin
```
