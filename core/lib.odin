// lib.odin -- core helpers built on top of the generated GDExtension interface.
//
// This file is hand-written. It provides:
//   - convenient aliases for the generated GDExtension* types
//   - ptrcall helpers for calling through resolved function pointers
//   - helpers for constructing/destroying builtin Variant types
//   - helpers for registering extension classes
//
// It intentionally stays close to the C API; ergonomic, type-safe wrappers
// live in the generated `godot` package.
// TODO: might need changes


package godot_core

import "base:intrinsics"
import "core:sync"

// ---------------------------------------------------------------------------
// Type aliases (canonical generated names in interface_defs.odin)
// ---------------------------------------------------------------------------

VariantPtr :: GDExtensionVariantPtr
ConstVariantPtr :: GDExtensionConstVariantPtr
UninitializedVariantPtr :: GDExtensionUninitializedVariantPtr

StringNamePtr :: GDExtensionStringNamePtr
ConstStringNamePtr :: GDExtensionConstStringNamePtr
UninitializedStringNamePtr :: GDExtensionUninitializedStringNamePtr

StringPtr :: GDExtensionStringPtr
ConstStringPtr :: GDExtensionConstStringPtr
UninitializedStringPtr :: GDExtensionUninitializedStringPtr

ObjectPtr :: GDExtensionObjectPtr
ConstObjectPtr :: GDExtensionConstObjectPtr
UninitializedObjectPtr :: GDExtensionUninitializedObjectPtr

TypePtr :: GDExtensionTypePtr
ConstTypePtr :: GDExtensionConstTypePtr
UninitializedTypePtr :: GDExtensionUninitializedTypePtr

MethodBindPtr :: GDExtensionMethodBindPtr
ClassInstancePtr :: GDExtensionClassInstancePtr
ClassLibraryPtr :: GDExtensionClassLibraryPtr
InstanceId :: GDObjectInstanceID

VariantType :: GDExtensionVariantType
VariantOperator :: GDExtensionVariantOperator
CallErrorType :: GDExtensionCallErrorType
CallError :: GDExtensionCallError
ClassMethodArgumentMetadata :: GDExtensionClassMethodArgumentMetadata
ClassMethodFlags :: GDExtensionClassMethodFlags
InitializationLevel :: GDExtensionInitializationLevel
Initialization :: GDExtensionInitialization

PropertyInfo :: GDExtensionPropertyInfo
MethodInfo :: GDExtensionMethodInfo
ClassMethodInfo :: GDExtensionClassMethodInfo
ClassCreationInfo :: GDExtensionClassCreationInfo6
InstanceBindingCallbacks :: GDExtensionInstanceBindingCallbacks
CallableCustomInfo :: GDExtensionCallableCustomInfo2

// Callback proc types (for class registration etc.)
ClassMethodCall :: GDExtensionClassMethodCall
ClassMethodPtrCall :: GDExtensionClassMethodPtrCall
ClassCreateInstance :: GDExtensionClassCreateInstance3
ClassFreeInstance :: GDExtensionClassFreeInstance
ClassNotification :: GDExtensionClassNotification2
ClassGetVirtual :: GDExtensionClassGetVirtual2
ClassGetVirtualCallData :: GDExtensionClassGetVirtualCallData2
ClassCallVirtualWithData :: GDExtensionClassCallVirtualWithData
ClassSet :: GDExtensionClassSet
ClassGet :: GDExtensionClassGet
ClassGetPropertyList :: GDExtensionClassGetPropertyList
ClassFreePropertyList :: GDExtensionClassFreePropertyList2
ClassPropertyCanRevert :: GDExtensionClassPropertyCanRevert
ClassPropertyGetRevert :: GDExtensionClassPropertyGetRevert
ClassValidateProperty :: GDExtensionClassValidateProperty
ClassReference :: GDExtensionClassReference
ClassUnreference :: GDExtensionClassUnreference
ClassToString :: GDExtensionClassToString
ClassRecreateInstance :: GDExtensionClassRecreateInstance
ClassGetRID :: GDExtensionClassGetRID

PtrConstructor :: GDExtensionPtrConstructor
PtrDestructor :: GDExtensionPtrDestructor
PtrBuiltInMethod :: GDExtensionPtrBuiltInMethod
PtrOperatorEvaluator :: GDExtensionPtrOperatorEvaluator
PtrSetter :: GDExtensionPtrSetter
PtrGetter :: GDExtensionPtrGetter
PtrIndexedSetter :: GDExtensionPtrIndexedSetter
PtrIndexedGetter :: GDExtensionPtrIndexedGetter
PtrKeyedSetter :: GDExtensionPtrKeyedSetter
PtrKeyedGetter :: GDExtensionPtrKeyedGetter
PtrKeyedChecker :: GDExtensionPtrKeyedChecker
PtrUtilityFunction :: GDExtensionPtrUtilityFunction
VariantFromTypeConstructor :: GDExtensionVariantFromTypeConstructorFunc
TypeFromVariantConstructor :: GDExtensionTypeFromVariantConstructorFunc

// ---------------------------------------------------------------------------
// Calling through resolved function pointers
// ---------------------------------------------------------------------------

_trap_nil_godot_function :: proc "contextless" () -> ! {
	intrinsics.debug_trap()
	unreachable()
}

_trap_godot_call_error :: proc "contextless" () -> ! {
	intrinsics.debug_trap()
	unreachable()
}

// Invoke a builtin type constructor on uninitialized storage `base`.
call_builtin_constructor :: proc "contextless" (
	constructor: PtrConstructor,
	base: UninitializedTypePtr,
	args: ..TypePtr,
) {
	if constructor == nil do _trap_nil_godot_function()
	constructor(base, raw_data(args))
}

// Invoke a builtin operator evaluator and return the typed result.
call_builtin_operator_ptr :: proc "contextless" (
	op: PtrOperatorEvaluator,
	a, b: TypePtr,
	$T: typeid,
) -> T {
	if op == nil do _trap_nil_godot_function()
	ret: T
	op(a, b, cast(TypePtr)&ret)
	return ret
}

// Invoke a builtin method returning a typed value.
call_builtin_method_ptr_ret :: proc "contextless" (
	method: PtrBuiltInMethod,
	base: TypePtr,
	$T: typeid,
	args: ..TypePtr,
) -> T {
	if method == nil do _trap_nil_godot_function()
	ret: T
	method(base, raw_data(args), cast(TypePtr)&ret, i32(len(args)))
	return ret
}

// Invoke a builtin method that writes an initialized return value into caller-provided storage.
call_builtin_method_ptr_ret_into :: proc "contextless" (
	method: PtrBuiltInMethod,
	base: TypePtr,
	ret: TypePtr,
	args: ..TypePtr,
) {
	if method == nil || ret == nil do _trap_nil_godot_function()
	method(base, raw_data(args), ret, i32(len(args)))
}

// Invoke a builtin method that returns nothing.
call_builtin_method_ptr_no_ret :: proc "contextless" (
	method: PtrBuiltInMethod,
	base: TypePtr,
	args: ..TypePtr,
) {
	if method == nil do _trap_nil_godot_function()
	method(base, raw_data(args), cast(TypePtr)nil, i32(len(args)))
}

// Call an Object method through its MethodBind, no return value.
call_method_ptr_no_ret :: proc "contextless" (
	method: MethodBindPtr,
	base: ObjectPtr,
	args: ..TypePtr,
) {
	if method == nil do _trap_nil_godot_function()
	if object_method_bind_ptrcall == nil do _trap_nil_godot_function()
	object_method_bind_ptrcall(method, base, raw_data(args), cast(TypePtr)nil)
}

// Call an Object method through its MethodBind, returning a typed value.
call_method_ptr_ret :: proc "contextless" (
	method: MethodBindPtr,
	$T: typeid,
	base: ObjectPtr,
	args: ..TypePtr,
) -> T {
	if method == nil do _trap_nil_godot_function()
	if object_method_bind_ptrcall == nil do _trap_nil_godot_function()
	ret: T
	object_method_bind_ptrcall(method, base, raw_data(args), cast(TypePtr)&ret)
	return ret
}

// Call a utility function returning a typed value.
call_utility_function_ptr_ret :: proc "contextless" (
	func: PtrUtilityFunction,
	$T: typeid,
	args: ..TypePtr,
) -> (
	ret: T,
) {
	if func == nil do _trap_nil_godot_function()
	func(cast(TypePtr)&ret, raw_data(args), i32(len(args)))
	return
}

// Call a utility function that returns nothing.
call_utility_function_ptr_no_ret :: proc "contextless" (
	func: PtrUtilityFunction,
	args: ..TypePtr,
) {
	if func == nil do _trap_nil_godot_function()
	func(cast(TypePtr)nil, raw_data(args), i32(len(args)))
}

// ---------------------------------------------------------------------------
// Builtin type construction / destruction
// ---------------------------------------------------------------------------

require_variant_from_type_constructor :: proc "contextless" (
	type: VariantType,
) -> VariantFromTypeConstructor {
	if get_variant_from_type_constructor == nil do _trap_nil_godot_function()
	ctor := get_variant_from_type_constructor(type)
	if ctor == nil do _trap_nil_godot_function()
	return ctor
}

require_variant_to_type_constructor :: proc "contextless" (
	type: VariantType,
) -> TypeFromVariantConstructor {
	if get_variant_to_type_constructor == nil do _trap_nil_godot_function()
	ctor := get_variant_to_type_constructor(type)
	if ctor == nil do _trap_nil_godot_function()
	return ctor
}

require_utility_function :: proc "contextless" (
	name: ConstStringNamePtr,
	hash: i64,
) -> PtrUtilityFunction {
	if variant_get_ptr_utility_function == nil do _trap_nil_godot_function()
	func := variant_get_ptr_utility_function(name, hash)
	if func == nil do _trap_nil_godot_function()
	return func
}

require_classdb_method_bind :: proc "contextless" (
	class_name: ConstStringNamePtr,
	method_name: ConstStringNamePtr,
	hash: i64,
) -> MethodBindPtr {
	if classdb_get_method_bind == nil do _trap_nil_godot_function()
	method := classdb_get_method_bind(class_name, method_name, hash)
	if method == nil do _trap_nil_godot_function()
	return method
}

// Fetch a builtin type constructor by its index (0-based).
get_builtin_constructor_by_index :: proc "contextless" (
	type: VariantType,
	index: i32,
) -> PtrConstructor {
	if variant_get_ptr_constructor == nil do _trap_nil_godot_function()
	return variant_get_ptr_constructor(type, index)
}

// Fetch the destructor for a builtin type. Returns nil if it has none.
get_builtin_destructor :: proc "contextless" (type: VariantType) -> PtrDestructor {
	if variant_get_ptr_destructor == nil do _trap_nil_godot_function()
	return variant_get_ptr_destructor(type)
}

// Construct a builtin type with typed arguments into `dest` (uninitialized).
construct_builtin :: proc "contextless" (
	type: VariantType,
	dest: UninitializedTypePtr,
	args: ..TypePtr,
) -> bool {
	constructor := get_builtin_constructor_by_index(type, i32(len(args)))
	if constructor == nil {
		return false
	}
	call_builtin_constructor(constructor, dest, ..args)
	return true
}

// Destroy a constructed builtin type (no-op for types without destructors).
destroy_builtin :: proc "contextless" (type: VariantType, ptr: TypePtr) {
	if destructor := get_builtin_destructor(type); destructor != nil {
		destructor(ptr)
	}
}

// ---------------------------------------------------------------------------
// Lazy-init for builtin methods
// ---------------------------------------------------------------------------

// BuiltinMethod holds a resolved builtin method pointer and its StringName
// storage. Used by generated bindings for one-time lazy resolution.
BuiltinMethod :: struct {
	name_data: StaticStringName,
	method:    PtrBuiltInMethod,
	init:      bool,
	mutex:     sync.Mutex,
}

// ensure_builtin_method resolves a builtin method pointer on first call.
ensure_builtin_method :: proc "contextless" (
	bm: ^BuiltinMethod,
	variant_type: VariantType,
	name: cstring,
	hash: i64,
) {
	sync.mutex_lock(&bm.mutex)
	defer sync.mutex_unlock(&bm.mutex)

	if bm.init do return

	if variant_get_ptr_builtin_method == nil do _trap_nil_godot_function()
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&bm.name_data),
		name,
	)
	method := variant_get_ptr_builtin_method(
		variant_type,
		const_static_string_name_ptr(&bm.name_data),
		hash,
	)
	if method == nil do _trap_nil_godot_function()
	bm.method = method
	bm.init = true
}

// ---------------------------------------------------------------------------
// String / StringName
// ---------------------------------------------------------------------------

// Construct a raw StringName from a null-terminated Latin-1 C string.
// `static = true` signals Godot the name lives for the process lifetime, so it
// can reuse the literal buffer; use it for string literals only and never destroy
// that static StringName. For owned, non-static names, prefer the StringName
// wrapper helpers and call string_name_free when done.
string_name_new :: proc "contextless" (
	dest: UninitializedStringNamePtr,
	str: cstring,
	static: bool = false,
) {
	string_name_new_with_latin1_chars(dest, str, static)
}

// Construct a String from a null-terminated UTF-8 C string.
string_new :: proc "contextless" (dest: UninitializedStringPtr, str: cstring) {
	string_new_with_latin1_chars(dest, str)
}

// ---------------------------------------------------------------------------
// Class names
// ---------------------------------------------------------------------------

// ClassName is process-lifetime StaticStringName storage for class and parent
// names used by registration. Keep the backing storage global or otherwise
// alive until the class is unregistered. Do not allocate it as a temporary.
ClassName :: distinct StaticStringName

// class_name_ptr returns a stable pointer into caller-owned ClassName storage.
// The pointer is only as long-lived as the storage passed here.
class_name_ptr :: proc "contextless" (name: ^ClassName) -> ConstStringNamePtr {
	if name == nil do _trap_nil_godot_function()
	return const_static_string_name_ptr(cast(^StaticStringName)name)
}

class_name_init_latin1_cstring :: proc "contextless" (name: ^ClassName, value: cstring) {
	if name == nil do _trap_nil_godot_function()
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(cast(^StaticStringName)name),
		value,
	)
}

// ---------------------------------------------------------------------------
// Class registration
// ---------------------------------------------------------------------------

// Register an extension class using the current (Godot 4.7) creation info.
register_class :: proc "contextless" (
	class_name: ConstStringNamePtr,
	parent_class_name: ConstStringNamePtr,
	info: ^ClassCreationInfo,
) {
	classdb_register_extension_class6(library, class_name, parent_class_name, info)
}

// Register an instantiable extension class with safe defaults for unsupported
// callbacks. The class and parent names must point to process-lifetime
// StringName storage, and user code remains responsible for explicit
// unregistration during deinitialization.
register_class_with_defaults :: proc "contextless" (
	class_name: ConstStringNamePtr,
	parent_class_name: ConstStringNamePtr,
	create_instance_func: ClassCreateInstance,
	free_instance_func: ClassFreeInstance,
	notification_func: ClassNotification,
	class_userdata: rawptr = nil,
) {
	info := ClassCreationInfo {
		is_virtual                  = false,
		is_abstract                 = false,
		is_exposed                  = true,
		is_runtime                  = false,
		icon_path                   = nil,
		set_func                    = nil,
		get_func                    = nil,
		get_property_list_func      = nil,
		free_property_list_func     = nil,
		property_can_revert_func    = nil,
		property_get_revert_func    = nil,
		validate_property_func      = nil,
		notification_func           = notification_func,
		to_string_func              = nil,
		reference_func              = nil,
		unreference_func            = nil,
		create_instance_func        = create_instance_func,
		free_instance_func          = free_instance_func,
		recreate_instance_func      = nil,
		get_virtual_func            = nil,
		get_virtual_call_data_func  = nil,
		call_virtual_with_data_func = nil,
		class_userdata              = class_userdata,
	}
	register_class(class_name, parent_class_name, &info)
}

unregister_class :: proc "contextless" (class_name: ConstStringNamePtr) {
	classdb_unregister_extension_class(library, class_name)
}

// Register a method on an extension class.
register_class_method :: proc "contextless" (
	class_name: ConstStringNamePtr,
	info: ^ClassMethodInfo,
) {
	classdb_register_extension_class_method(library, class_name, info)
}

// Register a signal on an extension class.
register_class_signal :: proc "contextless" (
	class_name: ConstStringNamePtr,
	signal_name: ConstStringNamePtr,
	argument_info: ^PropertyInfo,
	argument_count: i64,
) {
	classdb_register_extension_class_signal(
		library,
		class_name,
		signal_name,
		argument_info,
		argument_count,
	)
}

// ---------------------------------------------------------------------------
// Objects
// ---------------------------------------------------------------------------

// Set the GDExtension instance data for an object.
set_instance :: proc "contextless" (
	object: ObjectPtr,
	class_name: ConstStringNamePtr,
	instance: rawptr,
) {
	object_set_instance(object, class_name, instance)
}

// Bind a GDExtension instance (with callbacks) to an object.
set_instance_binding :: proc "contextless" (
	object: ObjectPtr,
	instance: rawptr,
	callbacks: ^InstanceBindingCallbacks,
) {
	object_set_instance_binding(object, library, instance, callbacks)
}

// attach_instance associates caller-allocated Odin instance data with a Godot
// object. It does not allocate, retain, or free the instance data; user code
// remains responsible for freeing it from the class free callback.
attach_instance :: proc "contextless" (
	object: ObjectPtr,
	class_name: ConstStringNamePtr,
	instance: rawptr,
	callbacks: ^InstanceBindingCallbacks,
) {
	if object == nil || class_name == nil || instance == nil || callbacks == nil {
		_trap_nil_godot_function()
	}
	set_instance(object, class_name, instance)
	set_instance_binding(object, instance, callbacks)
}

// class_instance_data returns typed Odin instance data previously attached to a
// Godot object. A nil ClassInstancePtr is treated as a failed lookup.
class_instance_data :: proc "contextless" (
	instance: ClassInstancePtr,
	$T: typeid,
) -> (
	data: ^T,
	ok: bool,
) {
	if instance == nil do return nil, false
	return cast(^T)instance, true
}

// Construct a plain Object of the given class.
construct_object :: proc "contextless" (class_name: ConstStringNamePtr) -> ObjectPtr {
	return classdb_construct_object3(class_name)
}

// ---------------------------------------------------------------------------
// Misc
// ---------------------------------------------------------------------------

// Verify the runtime Godot version matches expectations (>= major.minor).
check_version :: proc "contextless" (major, minor, patch: u32) -> bool {
	var := GDExtensionGodotVersion2{}
	get_godot_version2(&var)
	return var.major > major || (var.major == major && var.minor >= minor)
}

// ---------------------------------------------------------------------------
// Logging (bypasses Godot's print_error / print_warning prefix)
// ---------------------------------------------------------------------------

// Write a line to stdout. Avoids the ERROR:/WARNING: prefix that
// print_error / print_warning add. In headless mode stdout is the terminal;
// in the editor it goes to the terminal that launched Godot.
// TODO: replace with godot.print() once the high-level godot package
// is generated. Uses Odin's fmt under the hood; callers must have set
// context = godot_context() first.
import "core:fmt"

debug_print :: proc(msg: string) {
	fmt.println(msg)
}

/*
	Copyright 2026 David Moulin

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/
