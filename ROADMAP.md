# Roadmap

This project is an early prototype. The roadmap below tracks the path from the
current tested bindings toward a practical game-development GDExtension
workflow for Odin.

## Priority 0 - safety fixes before adding features — complete

Completed safety baseline for the current Godot 4.7 prototype:

- [x] Keep allocator behavior correct and documented, including resize and temp
  allocator policy.
- [x] Keep temporary `String`, temporary `Variant`, and Variant-returning call
  destruction rules correct for the current handwritten/generated helpers.
- [x] Avoid raw struct offset poking in examples and generated code.
- [x] Add clear nil/trap checks for resolved function pointers.
- [x] Keep examples unregistering classes during deinitialization.

Priority 0 is considered complete enough to unblock the next work. We need to
preserve these invariants while adding new bindings.

## Priority 1 - stabilize core value types - in progress

Finish the low-level value-type foundation before generating broad class APIs.
The goal is not to match `godot-rust/gdext` feature-for-feature yet, but to
have the same kind of safe core: explicit owned storage, pointer helpers,
Variant conversions, destructor rules, generated API integration, and runtime
smoke coverage for common Godot value types.

Remaining implementation order:

1. Finish shared storage for generated memory-compatible builtin elements.
   - [x] Move `Vector3` storage to `core` and make generated `Vector3` alias it.
   - [ ] Move `Vector4` storage to `core` and make generated `Vector4` alias it.
   - [ ] Move `Color` storage to `core` and make generated `Color` alias it.
   - [ ] Keep generated builtin methods using the same shared storage types as handwritten core wrappers.

2. Finish the remaining simple packed arrays.
   - [x] `PackedVector3Array`: owned wrapper, pointer helpers, new/copy/free, basic methods, Variant conversions, tests, and hello smoke coverage.
   - [ ] `PackedVector4Array`: owned wrapper, pointer helpers, new/copy/free, basic methods, Variant conversions, tests, and hello smoke coverage.
   - [ ] `PackedColorArray`: owned wrapper, pointer helpers, new/copy/free, basic methods, Variant conversions, tests, and hello smoke coverage.

3. Stabilize `String` enough for generated APIs.
   - [ ] Add a small safe method/operator set needed by generated APIs, such as length/is-empty/compare/hash if present in Godot metadata.
   - [ ] Define generated API rules for `String` parameters and returns: borrowed input storage, owned initialized return storage, and explicit destruction.
   - [ ] Add tests/examples proving String-returning generated or handwritten calls are destroyed correctly.

4. Add `RID` as the next standalone complex value type.
   - [ ] Query Godot metadata and destructor/constructor semantics before implementation.
   - [ ] Add owned storage or lightweight wrapper according to Godot's ABI semantics.
   - [ ] Add pointer helpers, construction/copy/free rules, Variant conversions, tests, and smoke coverage where practical.

5. Add `PackedStringArray` after the `String` ownership rules are integrated.
   - [ ] Owned wrapper, pointer helpers, new/copy/free, basic methods, and Variant conversions.
   - [ ] Ensure element access does not leak or return references to temporary String storage.
   - [ ] Add tests and hello smoke coverage.

6. Integrate completed complex value types into generated APIs.
   - [ ] Replace `rawptr` placeholders for value types whose ownership model is complete.
   - [ ] Keep `Variant` parameters borrowed as `^core.Variant`; never generate by-value owned Variant bit-copies.
   - [ ] Emit ownership comments for generated methods returning initialized owned Godot storage.
   - [ ] Keep generated output deterministic and fix generator/templates rather than generated files.

7. Decide the Priority 1 boundary for `Callable` and `Signal`.
   - [ ] Investigate constructors, destructors, call/connect behavior, and object lifetime implications.
   - [ ] If they are self-contained enough, add minimal owned wrappers and Variant conversions.
   - [ ] If they pull strongly into registration, signals, or virtual dispatch, document the boundary and defer the ergonomic parts to Priority 3/4.

Priority 1 can be considered complete when common value types used by generated
APIs have explicit ownership rules, CI and hello smoke tests cover the important
destruction paths, and any remaining raw/unsafe surfaces are intentional and
documented. :shrug: 

## Priority 2 - generated class bindings

Generate object/class APIs such as `Object`, `Node`, `Node2D`, `Resource`, method
binds, inheritance/upcast helpers, safe `cast_to`, enums/constants, and Odin
free-function wrappers.

Example target style:

```odin
import gt "godot:godot"

Player :: distinct gt.Node2D

_ready :: proc(self: Player) {
	gt.node2d_set_position(gt.Node2D(self), gt.Vector2{100, 50})
}
```

## Priority 3 - user class registration helpers

Build a small Odin-friendly helper layer over manual `ClassCreationInfo` and
`ClassMethodInfo` construction. Simple free
functions and typed descriptors should be enough to make examples and user
extensions much easier to write.

Possible shape:

```odin
gt.register_class(
	library,
	"HelloNode",
	"Node",
	create_instance,
	free_instance,
)
```

```odin
gt.register_method(
	HelloNode,
	"add",
	add,
	params = {gt.param("a", gt.GodotReal), gt.param("b", gt.GodotReal)},
	ret = gt.GodotReal,
)
```

The first goal is ergonomic wrappers for today's manual registration path; later
codegen can emit the same descriptors for larger class APIs.

## Priority 4 - properties, signals, notifications, and virtuals

Add the features needed for day-to-day game development:

- exported/editor-visible properties
- signal declaration and emission helpers
- generated notification constants and dispatch helpers
- virtual callbacks such as `_ready`, `_process`, and `_physics_process`
- editor-visible user classes
- optional `@tool`/tool-script style workflows later

These should build on the registration helper layer so user code can stay mostly
as simple Odin free functions plus explicit descriptors.
