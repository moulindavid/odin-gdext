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
INTERFACE_OUT  := godot-ffi/interface_defs.odin godot-ffi/interface.odin
CODEGEN        := bin/godot-codegen

# Build the codegen tool itself.
$(CODEGEN): $(wildcard godot-codegen/*.odin)
	@mkdir -p bin
	$(ODIN) build godot-codegen -out:$(CODEGEN) -o:speed

# Generate the FFI interface files.
$(INTERFACE_OUT): $(INTERFACE_JSON) $(CODEGEN)
	@echo ">> Generating interface bindings..."
	$(CODEGEN) $(INTERFACE_JSON)

.PHONY: codegen interface check hello test-hello clean

# Build the codegen tool.
codegen: $(CODEGEN)

# Generate the FFI interface.
interface: $(INTERFACE_OUT)

# Type-check the godot-ffi package.
check:
	$(ODIN) check godot-ffi -no-entry-point $(ODIN_FLAGS_COMMON)

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
	rm -f godot-ffi/interface_defs.odin godot-ffi/interface.odin
	rm -f bin/godot-codegen
