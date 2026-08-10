# Game example

This is the beginner-facing example for using `odin-gdext` from a normal Godot
project.

Godot owns the scene, input, and label. Odin registers a small `GameBrain` class
with:

- `roll_damage() -> float`
- `difficulty: float`
- `damage_rolled(value: float)`

Run it from the repository root with the example target once it is available:

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
