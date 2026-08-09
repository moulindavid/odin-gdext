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
  - [x] Centralized Godot `float` ABI as `GodotReal` for the current Godot 4.7 `float_64` target.
  - [x] Exact String Variant extraction to caller-provided UTF-8 buffers.
  - [ ] Richer conversion coverage for object, builtin, and other complex Variant conversions.
    - [x] Exact Object Variant extraction with `variant_try_object`.
    - [x] Generated exact-type `{builtin}_try_from_variant` helpers for current memory-compatible builtin types.
    - [ ] Additional complex conversions for StringName, NodePath, RID, Callable, Signal, Array, Dictionary, and packed arrays.
- [ ] `String`
  - [x] Initial owned-storage wrapper, checked pointer adapters, UTF-8 construction/extraction, and Variant conversion helpers.
  - [ ] Broader String methods/operators and generated API integration.
- [ ] `StringName`
  - [x] Initial owned-storage wrapper, checked pointer adapters, cstring UTF-8 construction, and Variant conversion helpers.
  - [x] Static/non-static naming policy integration for generated and handwritten APIs.
    - [x] `StaticStringName` wrapper for process-lifetime literals, integrated into core lazy builtin-method lookup and handwritten core helpers.
    - [x] Replace example/manual registration raw StringName storage with policy helpers.
    - [x] Generated utility lookup uses `StaticStringName` policy helpers instead of raw storage casts.
- [ ] `NodePath`
  - [x] Initial owned-storage wrapper, checked pointer adapters, UTF-8/String construction, copy/free helpers, and Variant conversion helpers.
  - [x] Primitive method wrappers for `is_absolute`, name/subname counts, and hash.
  - [x] Owned `StringName`-returning helpers for names/subnames and concatenated names/subnames.
- [ ] `Array`
  - [x] Initial owned-storage wrapper, checked pointer adapters, new/copy/free helpers, `push`, `size`, and Variant conversion helpers.
  - [x] Additional safe methods for `get`, `set`, `clear`, `erase`, `has`, and `is_empty`.
- [ ] `Dictionary`
  - [x] Initial owned-storage wrapper, checked pointer adapters, new/copy/free helpers, `set`, `has`, `size`, `is_empty`, and Variant conversion helpers.
  - [x] Additional safe methods for `get`, `get_or_default`, `clear`, and `erase`.
- [ ] packed arrays
  - [x] Initial owned `PackedByteArray` wrapper, checked pointer adapters, new/copy/free helpers, basic byte methods, and Variant conversion helpers.
  - [x] Initial owned `PackedInt32Array` wrapper, checked pointer adapters, new/copy/free helpers, basic int32 methods, and Variant conversion helpers.
  - [x] Initial owned `PackedInt64Array` wrapper, checked pointer adapters, new/copy/free helpers, basic int64 methods, and Variant conversion helpers.
  - [x] Initial owned `PackedFloat32Array` wrapper, checked pointer adapters, new/copy/free helpers, basic float32 methods, and Variant conversion helpers.
  - [x] Initial owned `PackedFloat64Array` wrapper, checked pointer adapters, new/copy/free helpers, basic float64 methods, and Variant conversion helpers.

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
