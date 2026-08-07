// context.odin -- Odin runtime shim backed by Godot's memory allocator.
//
// Routes Odin dynamic allocations through Godot's mem_alloc2 / mem_realloc2 /
// mem_free2, so the engine and Odin code share the same heap. Godot's allocator
// API exposes only normal heap alignment, so stricter Odin allocation requests
// are handled by an overallocating alignment shim.
package godot_core

import "base:runtime"
import "core:c"
import "core:mem"

_aligned_header_size :: size_of(rawptr)

_needs_aligned_allocation :: #force_inline proc "contextless" (alignment: int) -> bool {
	return alignment > align_of(rawptr)
}

_aligned_alloc :: proc "contextless" (size, alignment: int) -> rawptr {
	if !_needs_aligned_allocation(alignment) {
		return mem_alloc2(cast(c.size_t)size, false)
	}

	alloc_size := size + alignment - 1 + _aligned_header_size
	base := mem_alloc2(cast(c.size_t)alloc_size, false)
	if base == nil {
		return nil
	}

	base_addr := cast(uintptr)base
	start := base_addr + _aligned_header_size
	aligned_addr := (start + cast(uintptr)alignment - 1) & ~(cast(uintptr)alignment - 1)
	(cast(^rawptr)(aligned_addr - _aligned_header_size))^ = base
	return cast(rawptr)aligned_addr
}

_aligned_free :: proc "contextless" (ptr: rawptr, alignment: int) {
	if ptr == nil {
		return
	}

	if !_needs_aligned_allocation(alignment) {
		mem_free2(ptr, false)
		return
	}

	ptr_addr := cast(uintptr)ptr
	base := (cast(^rawptr)(ptr_addr - _aligned_header_size))^
	mem_free2(base, false)
}

_aligned_resize :: proc "contextless" (
	old_memory: rawptr,
	old_size, size, alignment: int,
) -> rawptr {
	if !_needs_aligned_allocation(alignment) {
		return mem_realloc2(old_memory, cast(c.size_t)size, false)
	}

	new_memory := _aligned_alloc(size, alignment)
	if new_memory == nil {
		return nil
	}

	copy_size := old_size
	if size < copy_size {
		copy_size = size
	}
	copy(mem.byte_slice(new_memory, copy_size), mem.byte_slice(old_memory, copy_size))
	_aligned_free(old_memory, alignment)
	return new_memory
}

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
		ptr := _aligned_alloc(size, alignment)
		if ptr == nil {
			return nil, .Out_Of_Memory
		}
		return mem.byte_slice(ptr, size), nil

	case .Free:
		_aligned_free(old_memory, alignment)

	case .Free_All:
		return nil, .Mode_Not_Implemented

	case .Resize, .Resize_Non_Zeroed:
		ptr := _aligned_resize(old_memory, old_size, size, alignment)
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

// godot_context returns an Odin context whose persistent allocator is backed by
// Godot. The temp allocator intentionally remains Odin's default thread-local
// temp allocator; sharing one Godot-backed arena across callbacks is not safe.
// Call at the top of every Godot callback (virtual calls, method calls,
// init/deinit, etc.).
godot_context :: #force_inline proc "contextless" () -> (c: runtime.Context) {
	c = runtime.default_context()
	c.allocator = _default_allocator
	return
}
