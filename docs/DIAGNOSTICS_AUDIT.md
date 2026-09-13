# Error handling and diagnostics audit

Current checked helpers preserve the safety model, but several common failure
paths return only `ok = false` without enough context for users to debug a Godot
project quickly.

Keep as traps:

- unresolved required GDExtension function pointers
- missing required builtin constructors, destructors, utility functions, and
  method binds
- nil registration metadata or callback pointers that would make a class invalid
- impossible adapter misuse, such as too many fixed signal arguments

Good existing checked paths:

- `Variant` calls return `CallError`
- signal emission returns `CallError`
- resource loading returns `OwnedResource`, `CallError`, and `ok`
- typed resource loading destroys owned wrappers on failed downcasts
- scene instantiation helpers destroy unparented nodes on failed add paths

Gaps worth improving first:

- resource loading cannot explain whether the failure was nil input, a Godot call
  error, nil returned object, non-Resource return, retain failure, or typed
  downcast failure
- scene instantiation cannot explain nil PackedScene, nil parent, failed root
  creation, failed typed downcast, or failed add-child cleanup
- signal emission exposes `CallError`, but common callers still need a small
  helper to turn failure into a concise operation-specific diagnostic
- examples have deterministic missing-resource paths that can exercise one
  concise diagnostic without making success-path logs noisy
