// context.odin — Odin runtime shim backed by Godot's memory allocator.
//
// Routes Odin dynamic allocations through Godot's mem_alloc / mem_realloc /
// mem_free, so the engine and Odin code share the same heap.
package godot_core

import "base:runtime"
import "core:c"
import "core:mem"

_allocator_proc :: proc(
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

_allocator :: #force_inline proc "contextless" () -> (a: runtime.Allocator) {
	return mem.Allocator{procedure = _allocator_proc}
}

@(private)
_default_allocator := _allocator()

@(private)
_temp_arena := runtime.Arena {
	backing_allocator = _default_allocator,
}

@(private)
_default_temp_allocator := runtime.Allocator{runtime.arena_allocator_proc, &_temp_arena}

// godot_context returns a Godot-backed Odin context.
// Call at the top of every Godot callback (virtual calls, method calls,
// init/deinit, etc.).
godot_context :: #force_inline proc "contextless" () -> (c: runtime.Context) {
	c.allocator = _default_allocator
	c.temp_allocator = _default_temp_allocator
	return
}
