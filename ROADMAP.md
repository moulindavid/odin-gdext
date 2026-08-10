# Roadmap

This roadmap now tracks the next practical goal: make `odin-gdext` easy to try
inside a normal Godot project.

Rules to keep : explicit
ownership, no raw offset poking, checked function pointers, stable registration
metadata, and unregister cleanup during deinitialization.

## Current goal: real Godot project usage

## Plan

1. Add `docs/USING_IN_GODOT.md`.
   - [x] Explain how to build the extension shared library.
   - [x] Explain where to place the `.gdextension` file and compiled library in
     a Godot project.
   - [x] Show the minimal Odin extension entry point and class registration
     shape.
   - [x] Show how to instantiate an Odin-backed class from GDScript.
   - [x] Show how to call an Odin method, read/write a property, and connect to
     a signal.
   - [x] Document required cleanup: freeing owned values and unregistering
     classes during deinitialization.

2. Add a cleaner example project or template.
   - [ ] Create a beginner-facing example that demonstrates one small game-like
     feature.
   - [ ] Keep the normal example importing only `godot:godot`.
   - [ ] Keep the example focused on user workflow rather than exhaustive smoke
     coverage.
   - [ ] Include a scene, script, `.gdextension` file, and Makefile target path
     that mirror a real project layout.

3. Split the current hello example responsibilities.
   - [ ] Keep `hello` as a simple beginner example.
   - [ ] Move broad internal coverage into a separate `smoke` example or test
     fixture.
   - [ ] Keep CI coverage for class creation, methods, properties, signal
     emission, notifications, instance binding, value conversions, and unregister
     cleanup.
   - [ ] Avoid making the beginner example look like a test dump.

4. Add a Makefile target for the example workflow.
   - [ ] Add a target such as `make example-game`.
   - [ ] Build the extension, prepare the Godot project files, and run the
     example headless when possible.
   - [ ] Keep `make ci` using deterministic targets and generated-file ordering.
   - [ ] Document which target a new user should run first.

5. Document current limitations clearly.
   - [ ] State that the current recommended model is hybrid Godot plus Odin:
     Godot/GDScript owns scenes, input, UI, and resources while Odin owns focused
     logic and selected extension classes.
   - [ ] List incomplete areas: broad class coverage, rich node lookup/resource
     loading helpers, `Callable`, ergonomic `Signal`, varargs/default arguments,
     object-lifetime-sensitive signatures, and full virtual callbacks.
   - [ ] Document the current Godot 4.7 `GodotReal` assumption.
   - [ ] Keep a short checklist for deciding whether a feature is safe to build
     with the current API.

## Done when

- A new developer can follow `docs/USING_IN_GODOT.md` and create or run a small
  Godot project that calls Odin code.
- The beginner example is easy to skim and is not overloaded with internal smoke
  checks.
- Internal smoke coverage still exists and runs in CI.
- `make ci` passes.
- README points users to the usage guide and clearly labels the project as a
  hybrid-feature prototype, not a complete Godot API binding yet.
