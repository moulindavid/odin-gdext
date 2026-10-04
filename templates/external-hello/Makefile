# Minimal external odin-gdext consumer Makefile.
# Override these paths for your local layout:
#   make ODIN_GDEXT=../odin-gdext GODOT_PROJECT=../my_game

ODIN       ?= odin
ODIN_GDEXT ?= ../odin-gdext
GODOT_PROJECT ?= ../game
LIB_NAME   ?= external_hello
BUILDMODE  ?= debug

OUT_DIR := $(GODOT_PROJECT)/bin
OUT_LIB := $(OUT_DIR)/$(LIB_NAME).so

ODIN_FLAGS := -collection:godot=$(ODIN_GDEXT) -vet -strict-style -default-to-nil-allocator

ifeq ($(BUILDMODE),release)
	ODIN_FLAGS += -o:speed -no-bounds-check
else
	ODIN_FLAGS += -debug -o:none
endif

.PHONY: build check clean

build:
	@mkdir -p $(OUT_DIR)
	$(ODIN) build src $(ODIN_FLAGS) -build-mode:shared -out:$(OUT_LIB)

check:
	$(ODIN) check src -no-entry-point $(ODIN_FLAGS)

clean:
	rm -f $(OUT_LIB)
