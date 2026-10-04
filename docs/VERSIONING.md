# Versioning and compatibility policy

`odin-gdext` is still a prototype. This policy documents what is validated today
and how compatibility changes should be handled until the project is mature
enough for a stronger release process.

## Validated toolchain

The authoritative toolchain is the one used by `.github/workflows/ci.yml`.
Current CI validates:

- Odin `dev-2026-09`
- OLS `odinfmt` from OLS `dev-2026-08`
- Godot `4.7-stable`
- Godot `float_64` extension API shape, surfaced through `GodotReal`

Local development should use the same Odin and OLS formatter versions when
possible. In particular, use the OLS `odinfmt` binary with the `-path:` CLI used
by the repository Makefile:

```sh
odinfmt -w -path:examples
```

Other Odin, OLS, or Godot patch versions may work, but they are best-effort until
CI validates them. When moving to a newer Odin, OLS, or Godot release, update CI,
README requirements, and this document in the same change.

## Godot support

The current target is Godot 4.7 with the `float_64` ABI shape. Other Godot
minor versions and precision modes are unsupported until the generator, runtime,
examples, and CI are updated for them.

`.gdextension` files should keep `compatibility_minimum = "4.7"` while the
project targets Godot 4.7. If a future slice adds another Godot minor version,
that slice should explicitly document whether it replaces or adds to the support
matrix.

## Odin support

The project tracks one validated Odin dev release at a time. The validated Odin
version should be pinned in CI and documented in the README. Moving to a newer
Odin release requires a full `make ci` pass and runtime example coverage because
shared-library initialization and allocator behavior can affect GDExtension code.

## Generated API refresh policy

Generated bindings are intentionally ignored by git. CI regenerates them from:

- `thirdparty/gdextension_interface.json`
- `extension_api.json` dumped from the validated Godot executable

Refresh generated APIs when one of these changes:

- the validated Godot version changes
- generator support rules change
- selected generated class, builtin, or utility coverage changes
- generated support reports need to expose a new blocker category

After a generator or Godot-version change, review the generated class report for
stable support/skip reasons before considering the slice complete.

## Changelog and compatibility notes

Release notes live in `CHANGELOG.md` for now. Keep entries lightweight and tied
to merged roadmap slices.

Until the project is ready for a package/release process, do not promise SemVer.
Treat these as compatibility-sensitive changes that should be documented in the
changelog and roadmap:

- public `godot:godot` facade renames or signature changes
- ownership rule changes for values, object handles, `Resource`, or `RefCounted`
- `.gdextension` entrypoint or template layout changes
- generated selected API removals or behavior changes
- supported Godot/Odin/OLS toolchain changes

Generated API additions are usually non-breaking, but still mention meaningful
coverage expansions in release notes so external users know what changed.
