# Roadmap

This project is an early prototype. The roadmap below tracks the path from the
current tested bindings toward a practical game-development GDExtension
workflow for Odin.

## Priority 0 - safety fixes before adding features - complete

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

## Priority 1 - stabilize core value types - complete

Finish the low-level value-type foundation before generating broad class APIs.
The goal is not to match `godot-rust/gdext` feature-for-feature yet, but to
have the same kind of safe core: explicit owned storage, pointer helpers,
Variant conversions, destructor rules, generated API integration, and runtime
smoke coverage for common Godot value types.

Remaining implementation order:

1. Finish shared storage for generated memory-compatible builtin elements.
   - [x] Move `Vector3` storage to `core` and make generated `Vector3` alias it.
   - [x] Move `Vector4` storage to `core` and make generated `Vector4` alias it.
   - [x] Move `Color` storage to `core` and make generated `Color` alias it.
   - [x] Keep generated builtin methods using the same shared storage types as handwritten core wrappers.

2. Finish the remaining simple packed arrays.
   - [x] `PackedVector3Array`: owned wrapper, pointer helpers, new/copy/free, basic methods, Variant conversions, tests, and hello smoke coverage.
   - [x] `PackedVector4Array`: owned wrapper, pointer helpers, new/copy/free, basic methods, Variant conversions, tests, and hello smoke coverage.
   - [x] `PackedColorArray`: owned wrapper, pointer helpers, new/copy/free, basic methods, Variant conversions, tests, and hello smoke coverage.

3. Stabilize `String` enough for generated APIs.
   - [x] Add a small safe method/operator set needed by generated APIs, such as length/is-empty/compare/hash if present in Godot metadata.
   - [x] Define generated API rules for `String` parameters and returns: borrowed input storage, owned initialized return storage, and explicit destruction.
   - [x] Add tests/examples proving String-returning generated or handwritten calls are destroyed correctly.

4. Add `RID` as the next standalone complex value type.
   - [x] Query Godot metadata and destructor/constructor semantics before implementation.
   - [x] Add owned storage or lightweight wrapper according to Godot's ABI semantics.
   - [x] Add pointer helpers, construction/copy/free rules, Variant conversions, tests, and smoke coverage where practical.

5. Add `PackedStringArray` after the `String` ownership rules are integrated.
   - [x] Owned wrapper, pointer helpers, new/copy/free, basic methods, and Variant conversions.
   - [x] Ensure element access does not leak or return references to temporary String storage.
   - [x] Add tests and hello smoke coverage.

6. Integrate completed complex value types into generated APIs.
   - [x] Replace `rawptr` placeholders for value types whose ownership model is complete.
   - [x] Keep `Variant` parameters borrowed as `^core.Variant`; never generate by-value owned Variant bit-copies.
   - [x] Emit ownership comments for generated methods returning initialized owned Godot storage.
   - [x] Keep generated output deterministic and fix generator/templates rather than generated files.

7. Decide the Priority 1 boundary for `Callable` and `Signal`.
   - [x] Investigate constructors, destructors, call/connect behavior, and object lifetime implications.
   - [x] If they are self-contained enough, add minimal owned wrappers and Variant conversions. Decision: not self-contained enough for Priority 1 because useful `Callable`/`Signal` APIs depend on Object lifetime, varargs, call/connect behavior, and registration semantics.
   - [x] If they pull strongly into registration, signals, or virtual dispatch, document the boundary and defer the ergonomic parts to Priority 3/4.

Priority 1 is considered complete for the current Godot 4.7 prototype: common
value types used by generated APIs have explicit ownership rules, CI and hello
smoke tests cover the important destruction paths, and remaining raw/unsafe
surfaces are intentional and documented. `Callable` and `Signal` remain intentionally deferred to Priority
3/4 because their safe API depends on object lifetime, registration, varargs,
and signal connection semantics rather than standalone value storage alone. 

## Priority 2 - generated class bindings

Generate object/class APIs on top of the existing `core.ObjectPtr` handle model.
Priority 2 is about Godot-owned object handles and generated method-bind wrappers;
user class registration helpers, properties, signals, virtual callbacks, and
`Callable` ergonomics stay in Priority 3/4.

Target public style:

```odin
import gt "godot:godot"

Player :: distinct gt.Node2D

_ready :: proc(self: Player) {
	gt.node2d_set_position(gt.Node2D(self), gt.Vector2{100, 50})
}
```

Implementation order:

1. Parse class metadata from `extension_api.json`.
   - [x] Add generator structs for `classes`, `singletons`, class methods,
     constants, enums, inheritance, return values, arguments, hashes, and flags
     needed for class generation.
   - [x] Inspect representative metadata for `Object`, `Node`, `Node2D`,
     `CanvasItem`, `Resource`, and `RefCounted` before emitting broad output.
   - [x] Keep generation deterministic and report or skip unsupported method
     shapes explicitly.

2. Generate minimal class handle files.
   - [x] Add a generated class package such as `bindings/classes`.
   - [x] Generate borrowed object handle types using the existing model:
     `Object` as `core.Object`, other classes as `distinct core.ObjectPtr`.
   - [x] Generate explicit upcast helpers such as `node2d_as_node`,
     `node2d_as_canvas_item`, and `node2d_as_object`.
   - [x] Document that generated class handles do not own or free Godot objects.

3. Generate class binding initialization.
   - [x] Generate process-lifetime `StaticStringName` storage for class and
     method names.
   - [x] Generate `MethodBindPtr` caches resolved with
     `core.require_classdb_method_bind`.
   - [x] Generate one explicit `init_class_bindings` entry point and call it
     from the extension initialization path before generated class methods are
     used.
   - [x] Preserve Priority 0 nil/trap checks for unresolved function pointers
     and method binds.

4. Generate a first safe method-wrapper slice.
   - [x] Start with selected `Object` and `Node2D` methods only.
   - [x] Generate non-vararg, non-virtual methods whose argument and return
     types are already covered by Priority 1 value-type rules.
   - [x] First runtime target: `node2d_set_position` and
     `node2d_get_position` through `object_method_bind_ptrcall`.
   - [x] Add hello smoke coverage that calls generated class methods from the
     extension.

5. Define class method type-mapping rules.
   - [x] Object/class parameters and returns are borrowed handles by value; no
     generated wrapper takes ownership of a Godot object.
   - [x] Completed owned value types keep the Priority 1 rule: borrowed
     pointer parameters and owned initialized return values with explicit
     destruction comments.
   - [x] Primitive and memory-compatible builtin values are passed by value
     using the documented Godot 4.7 `GodotReal` ABI rule for `float`.
   - [x] `Variant` parameters remain borrowed as `^core.Variant`; Variant
     returns are owned and must be destroyed with `core.variant_free`.
   - [x] Skip `Callable`, `Signal`, vararg methods, and unsupported typed-array
     or object-lifetime-sensitive APIs until their safety model is explicit.

6. Generate safe downcasts and class identity helpers.
   - [x] Generate wrappers around `core.cast_to` for selected classes, using
     Godot `is_class` checks before reinterpretation.
   - [x] Return `(value, ok)` for checked downcasts and treat nil objects as
     failed casts.
   - [x] Keep unchecked casts limited to explicit inheritance upcasts.

7. Generate class constants and enums.
   - [x] Emit Odin-safe names for class enums and constants.
   - [x] Include important notification and mode constants, especially for
     `Object`, `Node`, and common scene classes.
   - [x] Keep output deterministic and avoid collisions with generated method
     and type names.

8. Integrate generated classes into the public facade.
   - [x] Re-export selected class handle types and free-function wrappers from
     `godot/godot.odin`.
   - [x] Keep examples importing only `godot:godot` for normal usage.
   - [x] Add checks/tests proving generated class APIs compile without importing
     internal generated packages directly.

9. Expand class coverage incrementally.
   - [x] After `Object`/`Node`/`Node2D` works, add `CanvasItem`, `Control`,
     `Resource`, `RefCounted`, and other common scene/resource classes.
   - [x] Avoid generating the full 1000+ class API until skip rules, type
     mapping, inheritance helpers, and smoke coverage are stable.
   - [x] Prefer fixing generator logic over patching generated files manually.

Priority 2 is complete when a small but useful generated class API can be used
from the hello extension, class wrappers preserve object lifetime safety, and CI
checks generated class bindings alongside the existing value-type bindings.

## Priority 3 - user class registration helpers

Build a small Odin-friendly helper layer over manual class registration while
preserving explicit ownership, callback, and cleanup rules. The goal is not to
hide GDExtension behind magic, but to make normal user classes practical without
requiring direct `ClassCreationInfo`, `ClassMethodInfo`, or instance-binding
boilerplate in every extension.

1. Add minimal class registration helpers.
   - [ ] Provide a helper that builds `ClassCreationInfo` with safe defaults.
   - [ ] Keep create/free/notification callbacks explicit.
   - [ ] Keep unregistering classes explicit during deinitialization.
   - [ ] Update hello to use the helper instead of direct
     `classdb_register_extension_class6`.

2. Add static class-name helpers.
   - [ ] Make process-lifetime `StaticStringName` class and parent names easier
     to initialize.
   - [ ] Document that the backing storage must outlive the registered class.
   - [ ] Avoid returning pointers to temporary StringName storage.

3. Add instance binding helpers.
   - [ ] Wrap `set_instance` and `set_instance_binding` into a small helper.
   - [ ] Add checked helpers for retrieving typed Odin instance data from
     `ClassInstancePtr`.
   - [ ] Keep allocation and freeing of extension-owned data explicit.

4. Add method metadata registration helpers.
   - [ ] Provide descriptors for method name, return type, arguments, metadata,
     call callback, and ptrcall callback.
   - [ ] Build `ClassMethodInfo` and `PropertyInfo` safely from stable storage.
   - [ ] Update hello's `add` method registration to use the helper.
   - [ ] Preserve explicit Variant destruction and ptrcall ABI rules.

5. Add typed method adapter helpers for simple signatures.
   - [ ] Start with fixed arity primitive signatures such as
     `GodotReal, GodotReal -> GodotReal`.
   - [ ] Generate or provide explicit adapters for both call and ptrcall paths.
   - [ ] Defer varargs, default arguments, `Callable`, `Signal`, and complex
     object-lifetime-sensitive signatures.

6. Add notification dispatch helpers.
   - [ ] Provide a small pattern for dispatching common notifications such as
     ready, process, physics process, enter tree, and exit tree.
   - [ ] Keep raw notification numbers available for advanced usage.
   - [ ] Prepare this path for Priority 4 virtual callback helpers.

7. Move normal examples to the public facade.
   - [ ] Keep hello importing only `godot:godot` for normal usage.
   - [ ] Re-export only the registration pieces intended for users.
   - [ ] Keep low-level `godot:core` access available but unnecessary for common
     class registration.

8. Add coverage for registration helpers.
   - [ ] Add facade compile checks for class and method registration helpers.
   - [ ] Keep hello smoke coverage exercising class creation, method
     registration, instance binding, notifications, and unregister cleanup.
   - [ ] Run `make ci` before considering Priority 3 complete.


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
