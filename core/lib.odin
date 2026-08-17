// Handwritten core helpers over the generated GDExtension interface.
// Keep this layer close to the C API; safer public APIs belong in godot:godot.


package godot_core

import "base:intrinsics"
import "core:sync"

// Type aliases for generated interface names.

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

// Callable and Signal ownership rules:
// - Raw ObjectPtr/class handles captured by signal or callable helpers remain borrowed.
// - Helpers returning Callable or Signal storage own an initialized Godot value and
//   must name the matching destruction helper.
// - Helpers taking ^Callable, ^Signal, ^Variant, or ConstStringNamePtr borrow the
//   pointed-to storage for the duration of the call only.
// - Temporary Variant arguments created for signal emission must be destroyed on
//   every success and failure path.
// - Generated APIs keep Callable, Signal, varargs, and unclear object-lifetime
//   signatures skipped until a focused wrapper documents their ownership.

// Callback proc types used by class registration.
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

// Calls through resolved function pointers.

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

// Builtin type construction and destruction.

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

// Lazy builtin method lookup.

// Cached builtin method pointer plus stable StringName storage.
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

// Raw String and StringName helpers.

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

// Class names.

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

RegistrationStringName :: struct {
	storage: StaticStringName,
}

registration_string_name_ptr :: proc "contextless" (
	name: ^RegistrationStringName,
) -> ConstStringNamePtr {
	if name == nil do _trap_nil_godot_function()
	return const_static_string_name_ptr(&name.storage)
}

registration_string_name_mut_ptr :: proc "contextless" (
	name: ^RegistrationStringName,
) -> StringNamePtr {
	if name == nil do _trap_nil_godot_function()
	return static_string_name_ptr(&name.storage)
}

registration_string_name_init_latin1_cstring :: proc "contextless" (
	name: ^RegistrationStringName,
	value: cstring,
) {
	if name == nil do _trap_nil_godot_function()
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&name.storage),
		value,
	)
}

RegistrationString :: struct {
	storage: String,
}

registration_string_ptr :: proc "contextless" (value: ^RegistrationString) -> ConstStringPtr {
	if value == nil do _trap_nil_godot_function()
	return const_string_ptr(&value.storage)
}

registration_string_mut_ptr :: proc "contextless" (value: ^RegistrationString) -> StringPtr {
	if value == nil do _trap_nil_godot_function()
	return string_ptr(&value.storage)
}

registration_string_init_utf8 :: proc "contextless" (value: ^RegistrationString, text: string) {
	if value == nil do _trap_nil_godot_function()
	string_init_utf8(uninitialized_string_ptr(&value.storage), text)
}

registration_string_free :: proc "contextless" (value: ^RegistrationString) {
	if value == nil do return
	string_free(&value.storage)
}

ClassRegistrationNames :: struct {
	class_name:  ClassName,
	parent_name: ClassName,
}

class_registration_names_init :: proc "contextless" (
	names: ^ClassRegistrationNames,
	class_name: cstring,
	parent_name: cstring,
) {
	if names == nil do _trap_nil_godot_function()
	class_name_init_latin1_cstring(&names.class_name, class_name)
	class_name_init_latin1_cstring(&names.parent_name, parent_name)
}

class_registration_class_name :: proc "contextless" (
	names: ^ClassRegistrationNames,
) -> ConstStringNamePtr {
	if names == nil do _trap_nil_godot_function()
	return class_name_ptr(&names.class_name)
}

class_registration_parent_name :: proc "contextless" (
	names: ^ClassRegistrationNames,
) -> ConstStringNamePtr {
	if names == nil do _trap_nil_godot_function()
	return class_name_ptr(&names.parent_name)
}

// Class registration.

// Register an extension class using the current (Godot 4.7) creation info.
register_class :: proc "contextless" (
	class_name: ConstStringNamePtr,
	parent_class_name: ConstStringNamePtr,
	info: ^ClassCreationInfo,
) {
	classdb_register_extension_class6(library, class_name, parent_class_name, info)
}

EditorVisibleClassDescriptor :: struct {
	class_name:           ConstStringNamePtr,
	parent_class_name:    ConstStringNamePtr,
	create_instance_func: ClassCreateInstance,
	free_instance_func:   ClassFreeInstance,
	notification_func:    ClassNotification,
	class_userdata:       rawptr,
}

// register_editor_visible_class registers an instantiable class using the
// minimal Godot 4.7 metadata needed for editor visibility: exposed class
// creation info, a registered parent, then separately registered methods,
// properties, and signals. The class and parent names must point to
// process-lifetime StringName storage that outlives the registered class.
// Method, property, and signal metadata storage must also remain stable while
// Godot reads it. Optional tool-script style workflows and custom icons are
// intentionally deferred.
register_editor_visible_class :: proc "contextless" (desc: EditorVisibleClassDescriptor) {
	if desc.class_name == nil ||
	   desc.parent_class_name == nil ||
	   desc.create_instance_func == nil ||
	   desc.free_instance_func == nil {
		_trap_nil_godot_function()
	}
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
		notification_func           = desc.notification_func,
		to_string_func              = nil,
		reference_func              = nil,
		unreference_func            = nil,
		create_instance_func        = desc.create_instance_func,
		free_instance_func          = desc.free_instance_func,
		recreate_instance_func      = nil,
		get_virtual_func            = nil,
		get_virtual_call_data_func  = nil,
		call_virtual_with_data_func = nil,
		class_userdata              = desc.class_userdata,
	}
	register_class(desc.class_name, desc.parent_class_name, &info)
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
	register_editor_visible_class(
		EditorVisibleClassDescriptor {
			class_name = class_name,
			parent_class_name = parent_class_name,
			create_instance_func = create_instance_func,
			free_instance_func = free_instance_func,
			notification_func = notification_func,
			class_userdata = class_userdata,
		},
	)
}

unregister_class :: proc "contextless" (class_name: ConstStringNamePtr) {
	classdb_unregister_extension_class(library, class_name)
}

PropertyUsageStorage :: u32(2)
PropertyUsageEditor :: u32(4)
PropertyUsageDefault :: PropertyUsageStorage | PropertyUsageEditor

MethodPropertyDescriptor :: struct {
	type:        VariantType,
	name:        StringNamePtr,
	class_name:  StringNamePtr,
	hint_string: StringPtr,
	hint:        u32,
	usage:       u32,
}

ClassMemberDefaults :: struct {
	class_name:  StringNamePtr,
	hint_string: StringPtr,
	hint:        u32,
}

class_member_defaults :: proc "contextless" (
	class_name: StringNamePtr,
	hint_string: StringPtr,
	hint: u32 = 0,
) -> ClassMemberDefaults {
	if class_name == nil || hint_string == nil do _trap_nil_godot_function()
	return ClassMemberDefaults{class_name = class_name, hint_string = hint_string, hint = hint}
}

class_member_property :: proc "contextless" (
	defaults: ClassMemberDefaults,
	type: VariantType,
	name: StringNamePtr,
	usage: u32 = 0,
) -> MethodPropertyDescriptor {
	if defaults.class_name == nil || defaults.hint_string == nil || name == nil {
		_trap_nil_godot_function()
	}
	return MethodPropertyDescriptor {
		type = type,
		name = name,
		class_name = defaults.class_name,
		hint_string = defaults.hint_string,
		hint = defaults.hint,
		usage = usage,
	}
}

ClassPropertyDescriptor :: struct {
	property: MethodPropertyDescriptor,
	setter:   ConstStringNamePtr,
	getter:   ConstStringNamePtr,
}

// ClassSignalDescriptor borrows stable StringName and PropertyInfo storage. The
// caller must keep that metadata alive for the registered class lifetime.
ClassSignalDescriptor :: struct {
	name:           ConstStringNamePtr,
	argument_info:  ^PropertyInfo,
	argument_count: i64,
}

ClassMethodDescriptor :: struct {
	name:                  StringNamePtr,
	method_userdata:       rawptr,
	call_func:             ClassMethodCall,
	ptrcall_func:          ClassMethodPtrCall,
	method_flags:          u32,
	return_value_info:     ^PropertyInfo,
	return_value_metadata: ClassMethodArgumentMetadata,
	argument_count:        u32,
	arguments_info:        ^PropertyInfo,
	arguments_metadata:    ^ClassMethodArgumentMetadata,
}

OdinClassMethod :: struct {
	info:       ^ClassMethodInfo,
	descriptor: ClassMethodDescriptor,
}

OdinClassProperty :: struct {
	info:       ^PropertyInfo,
	descriptor: ClassPropertyDescriptor,
}

OdinClassSignal :: struct {
	descriptor: ClassSignalDescriptor,
}

OdinClassDescriptor :: struct {
	class_name:           ConstStringNamePtr,
	parent_class_name:    ConstStringNamePtr,
	create_instance_func: ClassCreateInstance,
	free_instance_func:   ClassFreeInstance,
	notification_func:    ClassNotification,
	class_userdata:       rawptr,
	methods:              []OdinClassMethod,
	properties:           []OdinClassProperty,
	signals:              []OdinClassSignal,
}

ClassBuilder :: struct {
	desc: OdinClassDescriptor,
}

class_builder_begin :: proc "contextless" (
	class_name: ConstStringNamePtr,
	parent_class_name: ConstStringNamePtr,
	create_instance_func: ClassCreateInstance,
	free_instance_func: ClassFreeInstance,
	notification_func: ClassNotification = nil,
	class_userdata: rawptr = nil,
) -> ClassBuilder {
	if class_name == nil ||
	   parent_class_name == nil ||
	   create_instance_func == nil ||
	   free_instance_func == nil {
		_trap_nil_godot_function()
	}
	return ClassBuilder {
		desc = OdinClassDescriptor {
			class_name = class_name,
			parent_class_name = parent_class_name,
			create_instance_func = create_instance_func,
			free_instance_func = free_instance_func,
			notification_func = notification_func,
			class_userdata = class_userdata,
		},
	}
}

class_builder_methods :: proc "contextless" (builder: ^ClassBuilder, methods: []OdinClassMethod) {
	if builder == nil do _trap_nil_godot_function()
	builder.desc.methods = methods
}

class_builder_properties :: proc "contextless" (
	builder: ^ClassBuilder,
	properties: []OdinClassProperty,
) {
	if builder == nil do _trap_nil_godot_function()
	builder.desc.properties = properties
}

class_builder_signals :: proc "contextless" (builder: ^ClassBuilder, signals: []OdinClassSignal) {
	if builder == nil do _trap_nil_godot_function()
	builder.desc.signals = signals
}

class_builder_finalize :: proc "contextless" (builder: ^ClassBuilder) -> OdinClassDescriptor {
	if builder == nil ||
	   builder.desc.class_name == nil ||
	   builder.desc.parent_class_name == nil ||
	   builder.desc.create_instance_func == nil ||
	   builder.desc.free_instance_func == nil {
		_trap_nil_godot_function()
	}
	return builder.desc
}

class_builder_register :: proc "contextless" (builder: ^ClassBuilder) {
	desc := class_builder_finalize(builder)
	register_odin_class(desc)
}

class_builder_unregister :: proc "contextless" (builder: ^ClassBuilder) {
	desc := class_builder_finalize(builder)
	unregister_odin_class(desc)
}

// register_odin_class registers one Odin-backed class and its member metadata.
// The descriptor is consumed immediately; Godot-facing names, PropertyInfo,
// ClassMethodInfo, adapters, and callback data must be caller-owned stable
// storage that remains valid for the registered class.
register_odin_class :: proc "contextless" (desc: OdinClassDescriptor) {
	register_editor_visible_class(
		EditorVisibleClassDescriptor {
			class_name = desc.class_name,
			parent_class_name = desc.parent_class_name,
			create_instance_func = desc.create_instance_func,
			free_instance_func = desc.free_instance_func,
			notification_func = desc.notification_func,
			class_userdata = desc.class_userdata,
		},
	)

	for method in desc.methods {
		register_class_method_with_descriptor(desc.class_name, method.info, method.descriptor)
	}
	for property in desc.properties {
		register_class_property_with_descriptor(
			desc.class_name,
			property.info,
			property.descriptor,
		)
	}
	for signal in desc.signals {
		register_class_signal_with_descriptor(desc.class_name, signal.descriptor)
	}
}

unregister_odin_class :: proc "contextless" (desc: OdinClassDescriptor) {
	if desc.class_name == nil do _trap_nil_godot_function()
	unregister_class(desc.class_name)
}

// init_method_property_info fills caller-owned PropertyInfo storage. Name,
// class_name, and hint_string must point to storage that remains valid while
// Godot reads the method metadata. Use process-lifetime StringName storage for
// names and stable String storage for hint text.
init_method_property_info :: proc "contextless" (
	info: ^PropertyInfo,
	desc: MethodPropertyDescriptor,
) {
	if info == nil || desc.name == nil || desc.class_name == nil || desc.hint_string == nil {
		_trap_nil_godot_function()
	}
	info.type = desc.type
	info.name = desc.name
	info.class_name = desc.class_name
	info.hint = desc.hint
	info.hint_string = desc.hint_string
	info.usage = desc.usage
}

// init_class_method_info fills caller-owned ClassMethodInfo storage from stable
// caller-owned metadata. This helper does not generate adapters and does not
// alter Variant or ptrcall ABI rules; call_func and ptrcall_func remain explicit.
init_class_method_info :: proc "contextless" (
	info: ^ClassMethodInfo,
	desc: ClassMethodDescriptor,
) {
	if info == nil || desc.name == nil || desc.call_func == nil || desc.ptrcall_func == nil {
		_trap_nil_godot_function()
	}
	if desc.return_value_info != nil && desc.return_value_info.name == nil {
		_trap_nil_godot_function()
	}
	if desc.argument_count > 0 && (desc.arguments_info == nil || desc.arguments_metadata == nil) {
		_trap_nil_godot_function()
	}
	info.name = desc.name
	info.method_userdata = desc.method_userdata
	info.call_func = desc.call_func
	info.ptrcall_func = desc.ptrcall_func
	info.method_flags = desc.method_flags
	info.has_return_value = desc.return_value_info != nil
	info.return_value_info = desc.return_value_info
	info.return_value_metadata = desc.return_value_metadata
	info.argument_count = desc.argument_count
	info.arguments_info = desc.arguments_info
	info.arguments_metadata = desc.arguments_metadata
	info.default_argument_count = 0
	info.default_arguments = nil
}

init_class_property_info :: proc "contextless" (
	info: ^PropertyInfo,
	desc: ClassPropertyDescriptor,
) {
	if desc.setter == nil || desc.getter == nil do _trap_nil_godot_function()
	init_method_property_info(info, desc.property)
}

register_class_property_with_descriptor :: proc "contextless" (
	class_name: ConstStringNamePtr,
	info: ^PropertyInfo,
	desc: ClassPropertyDescriptor,
) {
	if class_name == nil do _trap_nil_godot_function()
	init_class_property_info(info, desc)
	classdb_register_extension_class_property(library, class_name, info, desc.setter, desc.getter)
}

register_class_method_with_descriptor :: proc "contextless" (
	class_name: ConstStringNamePtr,
	info: ^ClassMethodInfo,
	desc: ClassMethodDescriptor,
) {
	if class_name == nil do _trap_nil_godot_function()
	init_class_method_info(info, desc)
	register_class_method(class_name, info)
}

ClassMethodGodotReal2ToGodotReal :: #type proc "contextless" (
	instance: ClassInstancePtr,
	a: GodotReal,
	b: GodotReal,
) -> (
	value: GodotReal,
	ok: bool,
)

ClassMethodGodotReal2ToGodotRealAdapter :: struct {
	method: ClassMethodGodotReal2ToGodotReal,
}

ClassMethodVoid :: #type proc "contextless" (instance: ClassInstancePtr) -> bool

ClassMethodVoidAdapter :: struct {
	method: ClassMethodVoid,
}

ClassMethodGetGodotReal :: #type proc "contextless" (
	instance: ClassInstancePtr,
) -> (
	value: GodotReal,
	ok: bool,
)

ClassMethodGetGodotRealAdapter :: struct {
	method: ClassMethodGetGodotReal,
}

ClassMethodSetGodotReal :: #type proc "contextless" (
	instance: ClassInstancePtr,
	value: GodotReal,
) -> bool

ClassMethodSetGodotRealAdapter :: struct {
	method: ClassMethodSetGodotReal,
}

ClassMethodGetBool :: #type proc "contextless" (
	instance: ClassInstancePtr,
) -> (
	value: bool,
	ok: bool,
)

ClassMethodGetBoolAdapter :: struct {
	method: ClassMethodGetBool,
}

ClassMethodSetBool :: #type proc "contextless" (instance: ClassInstancePtr, value: bool) -> bool

ClassMethodSetBoolAdapter :: struct {
	method: ClassMethodSetBool,
}

ClassMethodGetInt :: #type proc "contextless" (
	instance: ClassInstancePtr,
) -> (
	value: i64,
	ok: bool,
)

ClassMethodGetIntAdapter :: struct {
	method: ClassMethodGetInt,
}

ClassMethodSetInt :: #type proc "contextless" (instance: ClassInstancePtr, value: i64) -> bool

ClassMethodSetIntAdapter :: struct {
	method: ClassMethodSetInt,
}

ClassMethodGetString :: #type proc "contextless" (
	instance: ClassInstancePtr,
) -> (
	value: String,
	ok: bool,
)

ClassMethodGetStringAdapter :: struct {
	method: ClassMethodGetString,
}

ClassMethodSetString :: #type proc "contextless" (
	instance: ClassInstancePtr,
	value: ^String,
) -> bool

ClassMethodSetStringAdapter :: struct {
	method: ClassMethodSetString,
}

ClassMethodSetObjectPtr :: #type proc "contextless" (
	instance: ClassInstancePtr,
	value: ObjectPtr,
) -> bool

ClassMethodSetObjectPtrAdapter :: struct {
	method: ClassMethodSetObjectPtr,
}

ClassFixedMethodStorage :: struct {
	method_info:       ClassMethodInfo,
	return_info:       PropertyInfo,
	argument_info:     [2]PropertyInfo,
	argument_metadata: [2]ClassMethodArgumentMetadata,
}

class_method_void :: proc "contextless" (
	info: ^ClassMethodInfo,
	name: StringNamePtr,
	adapter: ^ClassMethodVoidAdapter,
) -> OdinClassMethod {
	if info == nil || name == nil || adapter == nil do _trap_nil_godot_function()
	return OdinClassMethod {
		info = info,
		descriptor = ClassMethodDescriptor {
			name = name,
			method_userdata = adapter,
			call_func = class_method_void_call,
			ptrcall_func = class_method_void_ptrcall,
		},
	}
}

class_method_get_godot_real :: proc "contextless" (
	storage: ^ClassFixedMethodStorage,
	defaults: ClassMemberDefaults,
	name: StringNamePtr,
	adapter: ^ClassMethodGetGodotRealAdapter,
) -> OdinClassMethod {
	if storage == nil || name == nil || adapter == nil do _trap_nil_godot_function()
	init_method_property_info(&storage.return_info, class_member_property(defaults, .Float, name))
	return OdinClassMethod {
		info = &storage.method_info,
		descriptor = ClassMethodDescriptor {
			name = name,
			method_userdata = adapter,
			call_func = class_method_get_godot_real_call,
			ptrcall_func = class_method_get_godot_real_ptrcall,
			return_value_info = &storage.return_info,
			return_value_metadata = .None,
		},
	}
}

class_method_set_godot_real :: proc "contextless" (
	storage: ^ClassFixedMethodStorage,
	defaults: ClassMemberDefaults,
	name: StringNamePtr,
	argument_name: StringNamePtr,
	adapter: ^ClassMethodSetGodotRealAdapter,
) -> OdinClassMethod {
	if storage == nil || name == nil || argument_name == nil || adapter == nil {
		_trap_nil_godot_function()
	}
	storage.argument_metadata[0] = .None
	init_method_property_info(
		&storage.argument_info[0],
		class_member_property(defaults, .Float, argument_name),
	)
	return OdinClassMethod {
		info = &storage.method_info,
		descriptor = ClassMethodDescriptor {
			name = name,
			method_userdata = adapter,
			call_func = class_method_set_godot_real_call,
			ptrcall_func = class_method_set_godot_real_ptrcall,
			argument_count = 1,
			arguments_info = &storage.argument_info[0],
			arguments_metadata = &storage.argument_metadata[0],
		},
	}
}

class_method_godot_real2_to_godot_real :: proc "contextless" (
	storage: ^ClassFixedMethodStorage,
	defaults: ClassMemberDefaults,
	name: StringNamePtr,
	argument_a_name: StringNamePtr,
	argument_b_name: StringNamePtr,
	adapter: ^ClassMethodGodotReal2ToGodotRealAdapter,
) -> OdinClassMethod {
	if storage == nil ||
	   name == nil ||
	   argument_a_name == nil ||
	   argument_b_name == nil ||
	   adapter == nil {
		_trap_nil_godot_function()
	}
	storage.argument_metadata[0] = .None
	storage.argument_metadata[1] = .None
	init_method_property_info(&storage.return_info, class_member_property(defaults, .Float, name))
	init_method_property_info(
		&storage.argument_info[0],
		class_member_property(defaults, .Float, argument_a_name),
	)
	init_method_property_info(
		&storage.argument_info[1],
		class_member_property(defaults, .Float, argument_b_name),
	)
	return OdinClassMethod {
		info = &storage.method_info,
		descriptor = ClassMethodDescriptor {
			name = name,
			method_userdata = adapter,
			call_func = class_method_godot_real2_to_godot_real_call,
			ptrcall_func = class_method_godot_real2_to_godot_real_ptrcall,
			return_value_info = &storage.return_info,
			return_value_metadata = .None,
			argument_count = 2,
			arguments_info = &storage.argument_info[0],
			arguments_metadata = &storage.argument_metadata[0],
		},
	}
}

ClassPrimitivePropertyStorage :: struct {
	property_info:      PropertyInfo,
	getter_return_info: PropertyInfo,
	setter_arg_info:    PropertyInfo,
	setter_arg_meta:    [1]ClassMethodArgumentMetadata,
	getter_method_info: ClassMethodInfo,
	setter_method_info: ClassMethodInfo,
}

ClassTypedPropertyDescriptor :: struct {
	property:    MethodPropertyDescriptor,
	getter_name: StringNamePtr,
	setter_name: StringNamePtr,
}

ClassTypedProperty :: struct {
	property: OdinClassProperty,
	getter:   OdinClassMethod,
	setter:   OdinClassMethod,
}

class_property_godot_real :: proc "contextless" (
	storage: ^ClassPrimitivePropertyStorage,
	desc: ClassTypedPropertyDescriptor,
	getter_adapter: ^ClassMethodGetGodotRealAdapter,
	setter_adapter: ^ClassMethodSetGodotRealAdapter,
) -> ClassTypedProperty {
	if storage == nil || getter_adapter == nil || setter_adapter == nil {
		_trap_nil_godot_function()
	}
	return class_property_primitive(
		storage,
		desc,
		getter_adapter,
		setter_adapter,
		class_method_get_godot_real_call,
		class_method_get_godot_real_ptrcall,
		class_method_set_godot_real_call,
		class_method_set_godot_real_ptrcall,
	)
}

class_property_int :: proc "contextless" (
	storage: ^ClassPrimitivePropertyStorage,
	desc: ClassTypedPropertyDescriptor,
	getter_adapter: ^ClassMethodGetIntAdapter,
	setter_adapter: ^ClassMethodSetIntAdapter,
) -> ClassTypedProperty {
	if storage == nil || getter_adapter == nil || setter_adapter == nil {
		_trap_nil_godot_function()
	}
	return class_property_primitive(
		storage,
		desc,
		getter_adapter,
		setter_adapter,
		class_method_get_int_call,
		class_method_get_int_ptrcall,
		class_method_set_int_call,
		class_method_set_int_ptrcall,
	)
}

class_property_bool :: proc "contextless" (
	storage: ^ClassPrimitivePropertyStorage,
	desc: ClassTypedPropertyDescriptor,
	getter_adapter: ^ClassMethodGetBoolAdapter,
	setter_adapter: ^ClassMethodSetBoolAdapter,
) -> ClassTypedProperty {
	if storage == nil || getter_adapter == nil || setter_adapter == nil {
		_trap_nil_godot_function()
	}
	return class_property_primitive(
		storage,
		desc,
		getter_adapter,
		setter_adapter,
		class_method_get_bool_call,
		class_method_get_bool_ptrcall,
		class_method_set_bool_call,
		class_method_set_bool_ptrcall,
	)
}

class_property_primitive :: proc "contextless" (
	storage: ^ClassPrimitivePropertyStorage,
	desc: ClassTypedPropertyDescriptor,
	getter_adapter: rawptr,
	setter_adapter: rawptr,
	getter_call: ClassMethodCall,
	getter_ptrcall: ClassMethodPtrCall,
	setter_call: ClassMethodCall,
	setter_ptrcall: ClassMethodPtrCall,
) -> ClassTypedProperty {
	if storage == nil ||
	   desc.property.name == nil ||
	   desc.property.class_name == nil ||
	   desc.property.hint_string == nil ||
	   desc.getter_name == nil ||
	   desc.setter_name == nil ||
	   getter_adapter == nil ||
	   setter_adapter == nil ||
	   getter_call == nil ||
	   getter_ptrcall == nil ||
	   setter_call == nil ||
	   setter_ptrcall == nil {
		_trap_nil_godot_function()
	}

	storage.setter_arg_meta[0] = .None
	init_method_property_info(&storage.getter_return_info, desc.property)
	init_method_property_info(&storage.setter_arg_info, desc.property)

	return ClassTypedProperty {
		property = OdinClassProperty {
			info = &storage.property_info,
			descriptor = ClassPropertyDescriptor {
				property = desc.property,
				setter = desc.setter_name,
				getter = desc.getter_name,
			},
		},
		getter = OdinClassMethod {
			info = &storage.getter_method_info,
			descriptor = ClassMethodDescriptor {
				name = desc.getter_name,
				method_userdata = getter_adapter,
				call_func = getter_call,
				ptrcall_func = getter_ptrcall,
				return_value_info = &storage.getter_return_info,
				return_value_metadata = .None,
			},
		},
		setter = OdinClassMethod {
			info = &storage.setter_method_info,
			descriptor = ClassMethodDescriptor {
				name = desc.setter_name,
				method_userdata = setter_adapter,
				call_func = setter_call,
				ptrcall_func = setter_ptrcall,
				argument_count = 1,
				arguments_info = &storage.setter_arg_info,
				arguments_metadata = &storage.setter_arg_meta[0],
			},
		},
	}
}

_set_call_error :: proc "contextless" (
	err: ^CallError,
	error: CallErrorType,
	argument: i32 = 0,
	expected: i32 = 0,
) {
	if err == nil do return
	err.error = error
	err.argument = argument
	err.expected = expected
}

// class_method_godot_real2_to_godot_real_call adapts a fixed-arity
// GodotReal, GodotReal -> GodotReal method to the Variant call ABI. Store a
// process-lifetime ClassMethodGodotReal2ToGodotRealAdapter in method_userdata.
class_method_godot_real2_to_godot_real_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	if method_userdata == nil || r_return == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count < 2 {
		_set_call_error(r_error, .Too_Few_Arguments, 0, 2)
		return
	}
	if p_argument_count > 2 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 2)
		return
	}
	if p_args == nil {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Float)
		return
	}

	adapter := cast(^ClassMethodGodotReal2ToGodotRealAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	if p_args[0] == nil {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Float)
		return
	}
	a, a_ok := variant_try_float(cast(^Variant)p_args[0])
	if !a_ok {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Float)
		return
	}
	if p_args[1] == nil {
		_set_call_error(r_error, .Invalid_Argument, 1, cast(i32)VariantType.Float)
		return
	}
	b, b_ok := variant_try_float(cast(^Variant)p_args[1])
	if !b_ok {
		_set_call_error(r_error, .Invalid_Argument, 1, cast(i32)VariantType.Float)
		return
	}

	value, ok := adapter.method(p_instance, a, b)
	if !ok {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}

	rv := variant_from_float(value)
	variant_init_copy(r_return, &rv)
	variant_free(&rv)
	_set_call_error(r_error, .Ok)
}

// class_method_godot_real2_to_godot_real_ptrcall adapts the same method to the
// validated ptrcall ABI. Godot validates argument count and type metadata before
// this path, so it reads the two GodotReal arguments directly.
class_method_godot_real2_to_godot_real_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	if method_userdata == nil || p_instance == nil || p_args == nil || r_ret == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodGodotReal2ToGodotRealAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	a := (cast(^GodotReal)p_args[0])^
	b := (cast(^GodotReal)p_args[1])^
	value, ok := adapter.method(p_instance, a, b)
	if !ok do _trap_godot_call_error()
	(cast(^GodotReal)r_ret)^ = value
}

class_method_void_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count > 0 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 0)
		return
	}

	adapter := cast(^ClassMethodVoidAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	if !adapter.method(p_instance) {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if r_return != nil do variant_init_nil(r_return)
	_set_call_error(r_error, .Ok)
}

class_method_void_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = p_args
	_ = r_ret
	if method_userdata == nil || p_instance == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodVoidAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()
	if !adapter.method(p_instance) do _trap_godot_call_error()
}

class_method_get_godot_real_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || r_return == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count > 0 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 0)
		return
	}

	adapter := cast(^ClassMethodGetGodotRealAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, ok := adapter.method(p_instance)
	if !ok {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}

	rv := variant_from_float(value)
	variant_init_copy(r_return, &rv)
	variant_free(&rv)
	_set_call_error(r_error, .Ok)
}

class_method_get_godot_real_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || p_instance == nil || r_ret == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodGetGodotRealAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value, ok := adapter.method(p_instance)
	if !ok do _trap_godot_call_error()
	(cast(^GodotReal)r_ret)^ = value
}

class_method_set_godot_real_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	if method_userdata == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count < 1 {
		_set_call_error(r_error, .Too_Few_Arguments, 0, 1)
		return
	}
	if p_argument_count > 1 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 1)
		return
	}
	if p_args == nil || p_args[0] == nil {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Float)
		return
	}

	adapter := cast(^ClassMethodSetGodotRealAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, value_ok := variant_try_float(cast(^Variant)p_args[0])
	if !value_ok {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Float)
		return
	}
	if !adapter.method(p_instance, value) {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if r_return != nil do variant_init_nil(r_return)
	_set_call_error(r_error, .Ok)
}

class_method_set_godot_real_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = r_ret
	if method_userdata == nil || p_instance == nil || p_args == nil || p_args[0] == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodSetGodotRealAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value := (cast(^GodotReal)p_args[0])^
	if !adapter.method(p_instance, value) do _trap_godot_call_error()
}

class_method_get_bool_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || r_return == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count > 0 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 0)
		return
	}

	adapter := cast(^ClassMethodGetBoolAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, ok := adapter.method(p_instance)
	if !ok {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}

	rv := variant_from_bool(value)
	variant_init_copy(r_return, &rv)
	variant_free(&rv)
	_set_call_error(r_error, .Ok)
}

class_method_get_bool_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || p_instance == nil || r_ret == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodGetBoolAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value, ok := adapter.method(p_instance)
	if !ok do _trap_godot_call_error()
	(cast(^bool)r_ret)^ = value
}

class_method_set_bool_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	if method_userdata == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count < 1 {
		_set_call_error(r_error, .Too_Few_Arguments, 0, 1)
		return
	}
	if p_argument_count > 1 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 1)
		return
	}
	if p_args == nil || p_args[0] == nil {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Bool)
		return
	}

	adapter := cast(^ClassMethodSetBoolAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, value_ok := variant_try_bool(cast(^Variant)p_args[0])
	if !value_ok {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Bool)
		return
	}
	if !adapter.method(p_instance, value) {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if r_return != nil do variant_init_nil(r_return)
	_set_call_error(r_error, .Ok)
}

class_method_set_bool_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = r_ret
	if method_userdata == nil || p_instance == nil || p_args == nil || p_args[0] == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodSetBoolAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value := (cast(^bool)p_args[0])^
	if !adapter.method(p_instance, value) do _trap_godot_call_error()
}

class_method_get_int_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || r_return == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count > 0 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 0)
		return
	}

	adapter := cast(^ClassMethodGetIntAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, ok := adapter.method(p_instance)
	if !ok {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}

	rv := variant_from_int(value)
	variant_init_copy(r_return, &rv)
	variant_free(&rv)
	_set_call_error(r_error, .Ok)
}

class_method_get_int_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || p_instance == nil || r_ret == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodGetIntAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value, ok := adapter.method(p_instance)
	if !ok do _trap_godot_call_error()
	(cast(^i64)r_ret)^ = value
}

class_method_set_int_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	if method_userdata == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count < 1 {
		_set_call_error(r_error, .Too_Few_Arguments, 0, 1)
		return
	}
	if p_argument_count > 1 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 1)
		return
	}
	if p_args == nil || p_args[0] == nil {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Int)
		return
	}

	adapter := cast(^ClassMethodSetIntAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, value_ok := variant_try_int(cast(^Variant)p_args[0])
	if !value_ok {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Int)
		return
	}
	if !adapter.method(p_instance, value) {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if r_return != nil do variant_init_nil(r_return)
	_set_call_error(r_error, .Ok)
}

class_method_set_int_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = r_ret
	if method_userdata == nil || p_instance == nil || p_args == nil || p_args[0] == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodSetIntAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value := (cast(^i64)p_args[0])^
	if !adapter.method(p_instance, value) do _trap_godot_call_error()
}

class_method_get_string_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || r_return == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count > 0 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 0)
		return
	}

	adapter := cast(^ClassMethodGetStringAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, ok := adapter.method(p_instance)
	if !ok {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	defer string_free(&value)

	rv := variant_from_string(&value)
	variant_init_copy(r_return, &rv)
	variant_free(&rv)
	_set_call_error(r_error, .Ok)
}

class_method_get_string_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = p_args
	if method_userdata == nil || p_instance == nil || r_ret == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodGetStringAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value, ok := adapter.method(p_instance)
	if !ok do _trap_godot_call_error()
	defer string_free(&value)
	string_init_copy(r_ret, &value)
}

class_method_set_string_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	if method_userdata == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count < 1 {
		_set_call_error(r_error, .Too_Few_Arguments, 0, 1)
		return
	}
	if p_argument_count > 1 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 1)
		return
	}
	if p_args == nil || p_args[0] == nil {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.String)
		return
	}

	adapter := cast(^ClassMethodSetStringAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, value_ok := variant_try_string(cast(^Variant)p_args[0])
	if !value_ok {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.String)
		return
	}
	defer string_free(&value)
	if !adapter.method(p_instance, &value) {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if r_return != nil do variant_init_nil(r_return)
	_set_call_error(r_error, .Ok)
}

class_method_set_string_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = r_ret
	if method_userdata == nil || p_instance == nil || p_args == nil || p_args[0] == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodSetStringAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value := cast(^String)p_args[0]
	if !adapter.method(p_instance, value) do _trap_godot_call_error()
}

class_method_set_object_ptr_call :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstVariantPtr,
	p_argument_count: i64,
	r_return: VariantPtr,
	r_error: ^CallError,
) {
	context = godot_context()

	if method_userdata == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}
	if p_instance == nil {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if p_argument_count < 1 {
		_set_call_error(r_error, .Too_Few_Arguments, 0, 1)
		return
	}
	if p_argument_count > 1 {
		_set_call_error(r_error, .Too_Many_Arguments, 0, 1)
		return
	}
	if p_args == nil || p_args[0] == nil {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Object)
		return
	}

	adapter := cast(^ClassMethodSetObjectPtrAdapter)method_userdata
	if adapter.method == nil {
		_set_call_error(r_error, .Invalid_Method)
		return
	}

	value, value_ok := variant_try_object(cast(^Variant)p_args[0])
	if !value_ok {
		_set_call_error(r_error, .Invalid_Argument, 0, cast(i32)VariantType.Object)
		return
	}
	if !adapter.method(p_instance, value) {
		_set_call_error(r_error, .Instance_Is_Null)
		return
	}
	if r_return != nil do variant_init_nil(r_return)
	_set_call_error(r_error, .Ok)
}

class_method_set_object_ptr_ptrcall :: proc "c" (
	method_userdata: rawptr,
	p_instance: ClassInstancePtr,
	p_args: [^]ConstTypePtr,
	r_ret: TypePtr,
) {
	context = godot_context()

	_ = r_ret
	if method_userdata == nil || p_instance == nil || p_args == nil || p_args[0] == nil {
		_trap_nil_godot_function()
	}
	adapter := cast(^ClassMethodSetObjectPtrAdapter)method_userdata
	if adapter.method == nil do _trap_nil_godot_function()

	value := (cast(^ObjectPtr)p_args[0])^
	if !adapter.method(p_instance, value) do _trap_godot_call_error()
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

register_class_signal_with_descriptor :: proc "contextless" (
	class_name: ConstStringNamePtr,
	desc: ClassSignalDescriptor,
) {
	if class_name == nil || desc.name == nil || desc.argument_count < 0 {
		_trap_nil_godot_function()
	}
	if desc.argument_count > 0 && desc.argument_info == nil do _trap_nil_godot_function()
	register_class_signal(class_name, desc.name, desc.argument_info, desc.argument_count)
}

// Objects.

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

// Misc.

// Verify the runtime Godot version matches expectations (>= major.minor).
check_version :: proc "contextless" (major, minor, patch: u32) -> bool {
	var := GDExtensionGodotVersion2{}
	get_godot_version2(&var)
	return var.major > major || (var.major == major && var.minor >= minor)
}

// Logging.

// Write a line to stdout. Avoids the ERROR:/WARNING: prefix that
// print_error / print_warning add. In headless mode stdout is the terminal;
// in the editor it goes to the terminal that launched Godot.
// Uses Odin's fmt; callers must set context = godot_context() first.
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
