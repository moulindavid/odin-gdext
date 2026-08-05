// context.odin — Odin runtime shim backed by Godot's memory allocator.
//
// This provides an `Allocator` and a `Context` that route allocations
// through Godot's mem_alloc / mem_realloc / mem_free interface functions,
// so that Odin dynamic memory (maps, dynamic arrays, temp allocator) uses
// the same heap as the engine.
// TODO: might need changes

package gdextension

import "base:runtime"
import "core:c"
import "core:mem"

godot_allocator_proc :: proc(
	allocator_data: rawptr,
	mode: mem.Allocator_Mode,
	size, alignment: int,
	old_memory: rawptr,
	old_size: int,
	loc := #caller_location,
) -> (
	[]byte,
	mem.Allocator_Error,
) {
	switch mode {
	case .Alloc, .Alloc_Non_Zeroed:
		ptr := mem_alloc(cast(c.size_t)size)
		if ptr == nil {
			return nil, .Out_Of_Memory
		}
		return mem.byte_slice(ptr, size), nil

	case .Free:
		mem_free(old_memory)

	case .Free_All:
		return nil, .Mode_Not_Implemented

	case .Resize, .Resize_Non_Zeroed:
		ptr: rawptr
		if old_memory == nil {
			ptr = mem_alloc(cast(c.size_t)size)
			if ptr == nil {
				return nil, .Out_Of_Memory
			}
			return mem.byte_slice(ptr, size), nil
		}
		ptr = mem_realloc(ptr, cast(c.size_t)size)
		if ptr == nil {
			return nil, .Out_Of_Memory
		}
		return mem.byte_slice(ptr, size), nil

	case .Query_Features:
		set := (^mem.Allocator_Mode_Set)(old_memory)
		if set != nil {
			set^ = {.Alloc, .Alloc_Non_Zeroed, .Free, .Resize, .Query_Features}
		}
		return nil, nil

	case .Query_Info:
		return nil, .Mode_Not_Implemented
	}

	return nil, nil
}

godot_allocator :: #force_inline proc "contextless" () -> (a: runtime.Allocator) {
	return mem.Allocator{procedure = godot_allocator_proc}
}

@(private)
default_godot_allocator := godot_allocator()

@(private)
temp_arena := runtime.Arena {
	backing_allocator = default_godot_allocator,
}

@(private)
default_temp_godot_allocator := runtime.Allocator{runtime.arena_allocator_proc, &temp_arena}

// Return a Godot-backed Odin context. Call this at the top of every Godot
// callback (virtual calls, method calls, init/deinit, etc.).
godot_context :: #force_inline proc "contextless" () -> (c: runtime.Context) {
	c.allocator = default_godot_allocator
	c.temp_allocator = default_temp_godot_allocator
	return
}
