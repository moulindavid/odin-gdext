// Typed object handle helpers.
// Class handles are borrowed views over Godot-owned objects unless documented otherwise.
package godot_core


// Object is the base type for all Godot class handles.
Object :: ObjectPtr

// RefCounted is the base type for refcounted Godot objects.
RefCounted :: distinct ObjectPtr

// StringRepr is the 8-byte raw Godot String handle returned by utility
// functions. Convert to an Odin string via variant layer helpers.
StringRepr :: distinct [8]u8

// Null checks.

is_nil :: proc "contextless" (obj: Object) -> bool {
	return ObjectPtr(obj) == nil
}

// Variant conversion.

// object_to_variant wraps an ObjectPtr into an initialized Variant. The caller
// owns the returned Variant and must destroy it with variant_free.
object_to_variant :: proc "contextless" (obj: ObjectPtr) -> Variant {
	v: Variant
	ctor := require_variant_from_type_constructor(.Object)
	_obj := obj
	ctor(uninitialized_variant_ptr(&v), cast(TypePtr)&_obj)
	return v
}

// object_from_variant extracts an ObjectPtr from a Variant without taking
// ownership of it. Prefer variant_try_object when the Variant type is not known.
object_from_variant :: proc "contextless" (v: ^Variant) -> ObjectPtr {
	ctor := require_variant_to_type_constructor(.Object)
	result: ObjectPtr
	ctor(cast(UninitializedTypePtr)&result, variant_ptr(v))
	return result
}

// variant_try_object extracts ObjectPtr only from exact Object Variants. A nil
// Object stored in a Variant still returns ok=true with value=nil.
variant_try_object :: proc "contextless" (v: ^Variant) -> (value: ObjectPtr, ok: bool) {
	if !variant_is_type(v, .Object) do return nil, false
	return object_from_variant(v), true
}

// RefCounted ownership primitives.

ref_counted_class_name_data: StaticStringName
ref_counted_reference_method_name_data: StaticStringName
ref_counted_unreference_method_name_data: StaticStringName
ref_counted_reference_method_bind: MethodBindPtr
ref_counted_unreference_method_bind: MethodBindPtr
ref_counted_reference_initialized: bool

init_ref_counted_reference :: proc "contextless" () {
	if ref_counted_reference_initialized do return
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&ref_counted_class_name_data),
		cstring("RefCounted"),
	)
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&ref_counted_reference_method_name_data),
		cstring("reference"),
	)
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&ref_counted_unreference_method_name_data),
		cstring("unreference"),
	)
	ref_counted_reference_method_bind = require_classdb_method_bind(
		const_static_string_name_ptr(&ref_counted_class_name_data),
		const_static_string_name_ptr(&ref_counted_reference_method_name_data),
		2240911060,
	)
	ref_counted_unreference_method_bind = require_classdb_method_bind(
		const_static_string_name_ptr(&ref_counted_class_name_data),
		const_static_string_name_ptr(&ref_counted_unreference_method_name_data),
		2240911060,
	)
	ref_counted_reference_initialized = true
}

// ref_counted_retain increments the reference count for a borrowed RefCounted
// handle. Nil handles return false instead of trapping.
ref_counted_retain :: proc "contextless" (self: RefCounted) -> (ok: bool) {
	if ObjectPtr(self) == nil do return false
	init_ref_counted_reference()
	return call_method_ptr_ret(ref_counted_reference_method_bind, bool, ObjectPtr(self))
}

// ref_counted_unreference decrements one owned reference. The return value is
// Godot's unreference result; callers that own final destruction must handle it.
ref_counted_unreference :: proc "contextless" (
	self: RefCounted,
) -> (
	reached_zero: bool,
	ok: bool,
) {
	if ObjectPtr(self) == nil do return false, false
	init_ref_counted_reference()
	return call_method_ptr_ret(ref_counted_unreference_method_bind, bool, ObjectPtr(self)), true
}

object_destroy_checked :: proc "contextless" (object: ObjectPtr) -> (ok: bool) {
	if object == nil do return false
	if object_destroy == nil do _trap_nil_godot_function()
	object_destroy(object)
	return true
}

OwnedRefCounted :: struct {
	handle: RefCounted,
	owns:   bool,
}

owned_ref_counted_nil :: proc "contextless" () -> OwnedRefCounted {
	return {}
}

owned_ref_counted_is_nil :: proc "contextless" (self: OwnedRefCounted) -> bool {
	return !self.owns || ObjectPtr(self.handle) == nil
}

owned_ref_counted_handle :: proc "contextless" (self: OwnedRefCounted) -> RefCounted {
	return self.handle
}

// owned_ref_counted_init_owned wraps a RefCounted handle whose reference is
// already owned by Odin, such as a future construct-object helper result.
owned_ref_counted_init_owned :: proc "contextless" (
	handle: RefCounted,
) -> (
	owned: OwnedRefCounted,
	ok: bool,
) {
	if ObjectPtr(handle) == nil do return {}, false
	return OwnedRefCounted{handle = handle, owns = true}, true
}

// owned_ref_counted_retain creates one Odin-owned reference from a borrowed
// RefCounted handle. The caller must release or destroy the returned wrapper.
owned_ref_counted_retain :: proc "contextless" (
	handle: RefCounted,
) -> (
	owned: OwnedRefCounted,
	ok: bool,
) {
	if !ref_counted_retain(handle) do return {}, false
	return OwnedRefCounted{handle = handle, owns = true}, true
}

// owned_ref_counted_take moves ownership out of src by clearing src.
owned_ref_counted_take :: proc "contextless" (src: ^OwnedRefCounted) -> OwnedRefCounted {
	if src == nil do return {}
	dst := src^
	src^ = {}
	return dst
}

// owned_ref_counted_release releases one owned reference and clears the wrapper.
// Nil, already released, or non-owning wrappers are no-ops with ok=true.
owned_ref_counted_release :: proc "contextless" (
	self: ^OwnedRefCounted,
) -> (
	destroyed: bool,
	ok: bool,
) {
	if self == nil do return false, false
	if !self.owns || ObjectPtr(self.handle) == nil {
		self^ = {}
		return false, true
	}

	handle := self.handle
	self^ = {}

	reached_zero, unref_ok := ref_counted_unreference(handle)
	if !unref_ok do return false, false
	if reached_zero {
		return object_destroy_checked(ObjectPtr(handle)), true
	}
	return false, true
}

owned_ref_counted_destroy :: proc "contextless" (self: ^OwnedRefCounted) -> (ok: bool) {
	_, release_ok := owned_ref_counted_release(self)
	return release_ok
}

// Signal emission. These helpers call Object.emit_signal through Variant call
// storage. The signal name is borrowed, and each temporary Variant is destroyed
// before returning, including checked error paths.

emit_signal_method_name_data: StaticStringName
signal_emission_object_class_name_data: StaticStringName
emit_signal_method_bind: MethodBindPtr
signal_emission_initialized: bool

init_signal_emission :: proc "contextless" () {
	if signal_emission_initialized do return
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&emit_signal_method_name_data),
		cstring("emit_signal"),
	)
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&signal_emission_object_class_name_data),
		cstring("Object"),
	)
	emit_signal_method_bind = require_classdb_method_bind(
		const_static_string_name_ptr(&signal_emission_object_class_name_data),
		const_static_string_name_ptr(&emit_signal_method_name_data),
		4047867050,
	)
	signal_emission_initialized = true
}

object_emit_signal_0_checked :: proc "contextless" (
	object: ObjectPtr,
	signal_name: ConstStringNamePtr,
) -> (
	err: CallError,
) {
	if object == nil || signal_name == nil do _trap_nil_godot_function()
	init_signal_emission()

	if object_method_bind_call == nil do _trap_nil_godot_function()
	if emit_signal_method_bind == nil do _trap_nil_godot_function()

	signal_variant := variant_from_string_name_ptr(signal_name)
	args := [1]ConstVariantPtr{const_variant_ptr(&signal_variant)}
	ret: Variant
	object_method_bind_call(
		emit_signal_method_bind,
		object,
		&args[0],
		1,
		uninitialized_variant_ptr(&ret),
		&err,
	)
	if call_error_ok(&err) do variant_free(&ret)
	variant_free(&signal_variant)
	return
}

object_emit_signal_0 :: proc "contextless" (object: ObjectPtr, signal_name: ConstStringNamePtr) {
	err := object_emit_signal_0_checked(object, signal_name)
	require_call_ok(&err)
}

object_emit_signal_1_godot_real_checked :: proc "contextless" (
	object: ObjectPtr,
	signal_name: ConstStringNamePtr,
	value: GodotReal,
) -> (
	err: CallError,
) {
	if object == nil || signal_name == nil do _trap_nil_godot_function()
	init_signal_emission()

	if object_method_bind_call == nil do _trap_nil_godot_function()
	if emit_signal_method_bind == nil do _trap_nil_godot_function()

	signal_variant := variant_from_string_name_ptr(signal_name)
	value_variant := variant_from_float(value)
	args := [2]ConstVariantPtr {
		const_variant_ptr(&signal_variant),
		const_variant_ptr(&value_variant),
	}
	ret: Variant
	object_method_bind_call(
		emit_signal_method_bind,
		object,
		&args[0],
		2,
		uninitialized_variant_ptr(&ret),
		&err,
	)
	if call_error_ok(&err) do variant_free(&ret)
	variant_free(&value_variant)
	variant_free(&signal_variant)
	return
}

object_emit_signal_1_godot_real :: proc "contextless" (
	object: ObjectPtr,
	signal_name: ConstStringNamePtr,
	value: GodotReal,
) {
	err := object_emit_signal_1_godot_real_checked(object, signal_name, value)
	require_call_ok(&err)
}

// Class identity and checked casts.

is_class_method_name_data: StaticStringName
object_class_name_data: StaticStringName
is_class_method_bind: MethodBindPtr
class_casting_initialized: bool

// Call during module init, before any cast is attempted.
init_class_casting :: proc "contextless" () {
	if class_casting_initialized do return
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&is_class_method_name_data),
		cstring("is_class"),
	)
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&object_class_name_data),
		cstring("Object"),
	)
	is_class_method_bind = require_classdb_method_bind(
		const_static_string_name_ptr(&object_class_name_data),
		const_static_string_name_ptr(&is_class_method_name_data),
		2619796661,
	)
	class_casting_initialized = true
}

// is_class checks whether obj is an instance of (or derives from) class_name.
is_class :: proc "contextless" (obj: ObjectPtr, class_name: StringNamePtr) -> bool {
	if is_class_method_bind == nil do _trap_nil_godot_function()
	if object_method_bind_ptrcall == nil do _trap_nil_godot_function()
	result: bool
	args := [1]rawptr{class_name}
	object_method_bind_ptrcall(is_class_method_bind, obj, &args[0], &result)
	return result
}

// cast_to checks class identity, then reinterprets the ObjectPtr. GDExtension
// uses single inheritance so the pointer value is the same across the hierarchy.
cast_to :: proc "contextless" (
	obj: ObjectPtr,
	target_class_name: StringNamePtr,
	$Target: typeid,
) -> (
	result: Target,
	ok: bool,
) {
	if obj == nil || !is_class(obj, target_class_name) {
		return Target{}, false
	}
	return Target(obj), true
}
