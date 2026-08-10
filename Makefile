COLLECTION := godot
ROOT      := $(shell pwd)
ODIN      := odin

BUILDMODE := debug
ODIN_CHECK_FLAGS := -collection:$(COLLECTION)=$(ROOT) -vet -strict-style -default-to-nil-allocator
ODIN_TEST_FLAGS  := -collection:$(COLLECTION)=$(ROOT) -vet -strict-style
ODIN_FLAGS_COMMON := $(ODIN_CHECK_FLAGS) -show-timings

ifeq ($(BUILDMODE),release)
	ODIN_FLAGS_COMMON += -o:speed -no-bounds-check
else
	ODIN_FLAGS_COMMON += -debug -o:none
endif

INTERFACE_JSON := thirdparty/gdextension_interface.json
INTERFACE_OUT  := core/interface_defs.odin core/interface.odin
CODEGEN        := bin/godot-codegen
EXTENSION_API  := extension_api.json
BUILTIN_STAMP  := bindings/builtin/.stamp
CLASSES_STAMP  := bindings/classes/.stamp

$(CODEGEN): $(wildcard generator/*.odin generator/**/*.odin)
	@mkdir -p bin
	$(ODIN) build generator -out:$(CODEGEN) -o:speed

$(INTERFACE_OUT): $(INTERFACE_JSON) $(CODEGEN)
	@echo ">> Generating interface bindings..."
	$(CODEGEN) $(INTERFACE_JSON)

$(BUILTIN_STAMP): $(EXTENSION_API) $(CODEGEN)
	@echo ">> Generating builtin + utility bindings..."
	@mkdir -p bindings/builtin bindings/classes
	$(CODEGEN) --builtin $(EXTENSION_API)
	@touch $(BUILTIN_STAMP)
	@touch $(CLASSES_STAMP)

.PHONY: codegen interface builtins extension-api fmt fmt-check check check-generator check-bindings check-godot check-facade test-unit hello prepare-hello-cache test-hello ci clean

codegen: $(CODEGEN)

interface: $(INTERFACE_OUT)

builtins: $(BUILTIN_STAMP)

$(EXTENSION_API):
	@echo ">> Dumping extension API..."
	godot --headless --dump-extension-api $(EXTENSION_API)

extension-api: $(EXTENSION_API)

# Format handwritten Odin sources. Generated files are intentionally omitted.
fmt:
	odinfmt -w -path:core/context.odin
	odinfmt -w -path:core/lib.odin
	odinfmt -w -path:core/object.odin
	odinfmt -w -path:core/variant.odin
	odinfmt -w -path:generator
	odinfmt -w -path:godot
	odinfmt -w -path:examples
	odinfmt -w -path:tests

fmt-check:
	scripts/fmt-check.sh

check: interface
	$(ODIN) check core -no-entry-point $(ODIN_CHECK_FLAGS)

check-generator:
	$(ODIN) check generator $(ODIN_CHECK_FLAGS)

check-bindings: interface builtins
	$(ODIN) check bindings -no-entry-point $(ODIN_CHECK_FLAGS)
	$(ODIN) check bindings/builtin -no-entry-point $(ODIN_CHECK_FLAGS)
	$(ODIN) check bindings/classes -no-entry-point $(ODIN_CHECK_FLAGS)

check-godot: interface builtins
	$(ODIN) check godot -no-entry-point $(ODIN_CHECK_FLAGS)

# Type-check public facade usage without importing internal generated packages.
check-facade: interface builtins
	$(ODIN) check tests/facade -no-entry-point $(ODIN_CHECK_FLAGS)

# Run focused Odin unit tests that do not require launching Godot.
# Odin's test runner allocates internally, so this target intentionally omits
# -default-to-nil-allocator while keeping vet and strict style enabled.
test-unit: interface
	$(ODIN) test tests/core $(ODIN_TEST_FLAGS)

hello: interface builtins
	@mkdir -p examples/hello/bin
	$(ODIN) build examples/hello/src \
		$(ODIN_FLAGS_COMMON) \
		-build-mode:shared \
		-out:examples/hello/bin/hello.so

# Prepare the minimal Godot cache needed for runtime GDExtension discovery.
# Avoid `godot --import` in CI because Godot 4.7 currently crashes after the
# extension smoke path succeeds during editor-layout loading.
prepare-hello-cache:
	@mkdir -p examples/hello/.godot
	@printf '%s\n' 'res://hello.gdextension' > examples/hello/.godot/extension_list.cfg
	@touch examples/hello/.godot/.gdignore

test-hello: hello prepare-hello-cache
	godot --headless --path examples/hello --quit

# Full local/CI validation baseline. Keep this ordered and non-parallel so
# generated files are created before packages that import them are checked.
ci:
	$(MAKE) clean
	$(MAKE) fmt-check
	$(MAKE) interface
	$(MAKE) builtins
	$(MAKE) check
	$(MAKE) check-generator
	$(MAKE) check-bindings
	$(MAKE) check-godot
	$(MAKE) check-facade
	$(MAKE) test-unit
	$(MAKE) test-hello

clean:
	rm -rf examples/hello/bin/
	rm -rf examples/hello/.godot/
	rm -f examples/hello/*.uid
	rm -f core/interface_defs.odin core/interface.odin
	rm -f bindings/builtin/*.odin bindings/utilities.odin
	rm -f bindings/classes/*.odin
	rm -f bindings/builtin/.stamp bindings/classes/.stamp
	rm -f extension_api.json
	rm -f bin/godot-codegen
