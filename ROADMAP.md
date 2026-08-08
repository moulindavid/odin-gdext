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

Implement proper wrappers and ownership rules for:

- `Variant`
  - [x] Initial owned-storage helpers, nil/copy initialization, checked pointer adapters, and ABI tests.
  - [x] Minimal `CallError` helpers and checked `variant_call` / `variant_construct` wrappers for handwritten Variant APIs.
  - [x] Generated APIs borrow `^Variant` parameters instead of bit-copying owned storage, and document owned `Variant` returns.
  - [x] Runtime type inspection and exact-type `try` conversions for bool, int, and float Variants.
  - [x] Exact String Variant extraction to caller-provided UTF-8 buffers.
  - [ ] Richer conversion coverage for object, builtin, and other complex Variant conversions.
    - [x] Exact Object Variant extraction with `variant_try_object`.
    - [x] Generated exact-type `{builtin}_try_from_variant` helpers for current memory-compatible builtin types.
    - [ ] Additional complex conversions for StringName, NodePath, RID, Callable, Signal, Array, Dictionary, and packed arrays.
- [ ] `String`
  - [x] Initial owned-storage wrapper, checked pointer adapters, UTF-8 construction/extraction, and Variant conversion helpers.
  - [ ] Broader String methods/operators and generated API integration.
- [ ] `StringName`
- [ ] `NodePath`
- [ ] `Array`
- [ ] `Dictionary`
- [ ] packed arrays

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
	params = {gt.param("a", f64), gt.param("b", f64)},
	ret = f64,
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
