# Roadmap

This roadmap tracks the next work needed to move `odin-gdext` from a usable
hybrid-feature prototype toward a more rust-gdext-like foundation.

## Invariants

Keep these rules intact while adding features:

- Explicit ownership for Godot values. Owned `Variant`, `String`, `StringName`,
  `NodePath`, arrays, dictionaries, packed arrays, and similar values must have
  matching destruction paths.
- Object and class handles are borrowed unless a helper explicitly documents a
  retain/reference rule.
- No raw offset poking in examples, generated code, or public helpers.
- Resolved GDExtension function pointers and method binds must be checked or
  trapped before use.
- Registration metadata must live long enough for the Godot registration that
  uses it.
- Extension classes must unregister during deinitialization.
- Normal examples should import only `godot:godot`.

## Completed baseline

The project is currently usable for hybrid Godot plus Odin features:

- Priority 0 safety baseline for allocators, Variant/String cleanup, function
  pointer checks, and registration cleanup.
- Priority 0.5 CI baseline with generated binding checks, unit tests, facade
  checks, and Godot headless smoke coverage.
- Priority 1 core value ownership and conversion helpers for `Variant`,
  strings, names, paths, RID, containers, packed arrays, and generated math
  builtins.
- Priority 2 selected generated class handles, constants, enums, downcasts, and
  public facade exports.
- Priority 3 user class registration helpers for class creation, instance
  binding, method metadata, simple typed adapters, and notifications.
- Priority 4 early properties, signals, notification dispatch, and virtual-style
  helpers.
- Real usage layer: `docs/USING_IN_GODOT.md`, a beginner game example,
  split hello/smoke examples, `make example-game`, and documented limitations.

## Current goal: safe object and user-class model

The next step toward rust-gdext-like structure is to make the object/reference
model explicit before expanding generated class coverage too far. This should
clarify what Odin owns, what Godot owns, and what can safely be stored across
callbacks.

## Plan

1. Define object handle ownership rules.
   - [x] Document borrowed Godot object/class handles in `docs/USING_IN_GODOT.md`
     and README.
   - [x] Document extension-owned instance data and how it differs from Godot
     object lifetime.
   - [x] Document when storing `ObjectPtr` or typed class handles in Odin data is
     allowed, and what remains unsafe.
   - [x] Document current `RefCounted` and `Resource` limitations.
   - [x] Add a small compile or smoke check showing safe storage of the owning
     Godot object pointer inside extension-owned instance data.

2. Add typed object handle helper APIs.
   - [x] Add nil-safe helper procedures for selected typed handles.
   - [x] Add checked conversion helpers from `Object` to selected typed handles
     where generated downcasts are not enough for user code.
   - [x] Keep unchecked casts limited to explicit inheritance upcasts.
   - [x] Keep all object/class handle helpers borrowed by value.

3. Decide the first `RefCounted` and `Resource` safety layer.
   - [ ] Inspect Godot 4.7 GDExtension APIs available for reference counting.
   - [ ] Decide whether public retain/unref helpers are safe enough now or must
     remain deferred.
   - [ ] Prevent public docs and examples from implying that Odin owns ordinary
     Godot objects.
   - [ ] Add tests or facade checks for the chosen rule.

4. Improve user class descriptors.
   - [ ] Reduce repeated class/method/property/signal boilerplate without hiding
     ownership or metadata lifetime.
   - [ ] Keep create/free callbacks explicit.
   - [ ] Keep registration and unregistration explicit.
   - [ ] Provide a compact descriptor pattern that examples can share.
   - [ ] Update `examples/hello` or `examples/game` only after the helper is
     clearer than the current explicit code.

5. Broaden typed method adapter coverage for common signatures.
   - [ ] `() -> void`.
   - [ ] `() -> bool`.
   - [ ] `() -> int`.
   - [ ] `(float) -> void`.
   - [ ] `(int) -> void`.
   - [ ] `(bool) -> void`.
   - [ ] Defer `String`, object handles, varargs, default arguments, `Callable`,
     `Signal`, and object-lifetime-sensitive signatures until ownership is
     explicit.

6. Shape a coherent public Variant conversion pattern.
   - [ ] Group existing `variant_from_*` helpers behind an Odin-friendly proc
     group or naming pattern.
   - [ ] Group checked extraction helpers behind a matching `try` pattern.
   - [ ] Keep borrowed parameters and owned returns obvious at call sites.
   - [ ] Add facade compile coverage for representative conversions.

7. Expand generated class APIs only after the above rules are stable.
   - [ ] Add more common scene/resource classes incrementally.
   - [ ] Keep skip rules deterministic for unsupported signatures.
   - [ ] Prefer generator fixes over manual patches to generated files.
   - [ ] Keep generated methods aligned with the borrowed object handle model.

## Validation

- README and usage docs clearly explain borrowed object handles,
  extension-owned instance data, and current `RefCounted` limitations.
- Public helpers make nil checks, upcasts, downcasts, and object storage rules
  easy to follow.
- Common simple method signatures can be registered without hand-writing Variant
  and ptrcall plumbing.
- Examples remain beginner-friendly while smoke coverage still protects the
  low-level safety rules.
- `make ci` passes.
