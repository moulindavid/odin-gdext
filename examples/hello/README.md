# Hello example

This is the small beginner example. Godot owns the scene and input; Odin
registers `HelloNode` with one method, one property, and one signal:

- `roll_math() -> float`
- `speed: float`
- `speed_changed(value: float)`

Run it from the repository root with:

```sh
make test-hello
```

For broad internal coverage, use the smoke example.
