#!/usr/bin/env sh
set -eu

tmp_dir="$(mktemp -d)"
cleanup() {
	rm -rf "$tmp_dir"
}
trap cleanup EXIT INT HUP TERM

mkdir -p "$tmp_dir/core"
cp core/context.odin "$tmp_dir/core/context.odin"
cp core/lib.odin "$tmp_dir/core/lib.odin"
cp core/object.odin "$tmp_dir/core/object.odin"
cp core/variant.odin "$tmp_dir/core/variant.odin"
cp -R generator "$tmp_dir/generator"
cp -R godot "$tmp_dir/godot"
cp -R examples "$tmp_dir/examples"
cp -R tests "$tmp_dir/tests"

odinfmt -w -path:"$tmp_dir/core/context.odin"
odinfmt -w -path:"$tmp_dir/core/lib.odin"
odinfmt -w -path:"$tmp_dir/core/object.odin"
odinfmt -w -path:"$tmp_dir/core/variant.odin"
odinfmt -w -path:"$tmp_dir/generator"
odinfmt -w -path:"$tmp_dir/godot"
odinfmt -w -path:"$tmp_dir/examples"
odinfmt -w -path:"$tmp_dir/tests"

diff -u core/context.odin "$tmp_dir/core/context.odin"
diff -u core/lib.odin "$tmp_dir/core/lib.odin"
diff -u core/object.odin "$tmp_dir/core/object.odin"
diff -u core/variant.odin "$tmp_dir/core/variant.odin"
diff -ru generator "$tmp_dir/generator"
diff -ru godot "$tmp_dir/godot"
diff -ru examples "$tmp_dir/examples"
diff -ru tests "$tmp_dir/tests"
