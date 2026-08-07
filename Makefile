# ---------------------------------------------------------------------------
# odin-gdext — Odin bindings for Godot 4 GDExtension
# ---------------------------------------------------------------------------

COLLECTION := godot
ROOT      := $(shell pwd)
ODIN      := odin

BUILDMODE := debug
ODIN_FLAGS_COMMON := -collection:$(COLLECTION)=$(ROOT) -vet -strict-style -default-to-nil-allocator -show-timings

ifeq ($(BUILDMODE),release)
	ODIN_FLAGS_COMMON += -o:speed -no-bounds-check
else
	ODIN_FLAGS_COMMON += -debug -o:none
endif

INTERFACE_JSON := thirdparty/gdextension_interface.json
INTERFACE_OUT  := core/interface_defs.odin core/interface.odin
CODEGEN        := bin/godot-codegen
EXTENSION_API  := thirdparty/extension_api.json

# Build the codegen tool itself.
$(CODEGEN): $(wildcard generator/*.odin generator/**/*.odin)
	@mkdir -p bin
	$(ODIN) build generator -out:$(CODEGEN) -o:speed

# Generate the FFI interface files.
$(INTERFACE_OUT): $(INTERFACE_JSON) $(CODEGEN)
	@echo ">> Generating interface bindings..."
	$(CODEGEN) $(INTERFACE_JSON)

.PHONY: codegen interface extension-api check hello test-hello clean

# Build the codegen tool.
codegen: $(CODEGEN)

# Generate the FFI interface.
interface: $(INTERFACE_OUT)

# Dump the full Godot extension API (builtin classes, utility functions, etc.).
$(EXTENSION_API):
	@echo ">> Dumping extension API..."
	godot --dump-extension-api $(EXTENSION_API)

extension-api: $(EXTENSION_API)

# Type-check the core package.
check:
	$(ODIN) check core -no-entry-point -collection:$(COLLECTION)=$(ROOT) -vet -strict-style -default-to-nil-allocator

# Build the hello-world extension shared library.
hello: interface
	@mkdir -p examples/hello/bin
	$(ODIN) build examples/hello/src \
		$(ODIN_FLAGS_COMMON) \
		-build-mode:shared \
		-out:examples/hello/bin/hello.so

# Test in Godot headless.
test-hello: hello
	godot --headless --path examples/hello --import
	godot --headless --path examples/hello --quit

clean:
	rm -rf examples/hello/bin/
	rm -f core/interface_defs.odin core/interface.odin
	rm -f thirdparty/extension_api.json
	rm -f bin/godot-codegen
