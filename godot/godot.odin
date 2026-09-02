// Public convenience facade for normal extension code.
// Low-level godot:core remains available for advanced GDExtension work.
package godot

import gbind "godot:bindings"
import gbind_builtin "godot:bindings/builtin"
import gclass "godot:bindings/classes"
import gcore "godot:core"

// --- Core types ---
Object :: gcore.Object
RefCounted :: gcore.RefCounted
OwnedRefCounted :: gcore.OwnedRefCounted
ObjectPtr :: gcore.ObjectPtr
ClassInstancePtr :: gcore.ClassInstancePtr
ClassLibraryPtr :: gcore.ClassLibraryPtr
InterfaceGetProcAddress :: gcore.GDExtensionInterfaceGetProcAddress
Initialization :: gcore.Initialization
InitializationLevel :: gcore.InitializationLevel
VariantPtr :: gcore.VariantPtr
ConstVariantPtr :: gcore.ConstVariantPtr
StringNamePtr :: gcore.StringNamePtr
ConstStringNamePtr :: gcore.ConstStringNamePtr
StringPtr :: gcore.StringPtr
ConstStringPtr :: gcore.ConstStringPtr
CallError :: gcore.CallError
ClassCreateInstance :: gcore.ClassCreateInstance
ClassFreeInstance :: gcore.ClassFreeInstance
ClassNotification :: gcore.ClassNotification
ClassVirtualReady :: gcore.ClassVirtualReady
ClassVirtualTree :: gcore.ClassVirtualTree
ClassVirtualProcess :: gcore.ClassVirtualProcess
ClassVirtualInputEvent :: gcore.ClassVirtualInputEvent
ClassVirtualRawNotification :: gcore.ClassVirtualRawNotification
ClassMethodCall :: gcore.ClassMethodCall
ClassMethodPtrCall :: gcore.ClassMethodPtrCall
ClassMethodArgumentMetadata :: gcore.ClassMethodArgumentMetadata
PropertyInfo :: gcore.PropertyInfo
ClassMethodInfo :: gcore.ClassMethodInfo
EditorVisibleClassDescriptor :: gcore.EditorVisibleClassDescriptor
PropertyUsageStorage :: gcore.PropertyUsageStorage
PropertyUsageEditor :: gcore.PropertyUsageEditor
PropertyUsageDefault :: gcore.PropertyUsageDefault
NodeNotificationEnterTree :: gcore.NodeNotificationEnterTree
NodeNotificationExitTree :: gcore.NodeNotificationExitTree
NodeNotificationReady :: gcore.NodeNotificationReady
NodeNotificationPhysicsProcess :: gcore.NodeNotificationPhysicsProcess
NodeNotificationProcess :: gcore.NodeNotificationProcess
MethodPropertyDescriptor :: gcore.MethodPropertyDescriptor
ClassMemberDefaults :: gcore.ClassMemberDefaults
ClassPropertyDescriptor :: gcore.ClassPropertyDescriptor
ClassSignalDescriptor :: gcore.ClassSignalDescriptor
ClassMethodDescriptor :: gcore.ClassMethodDescriptor
OdinClassMethod :: gcore.OdinClassMethod
OdinClassProperty :: gcore.OdinClassProperty
OdinClassSignal :: gcore.OdinClassSignal
ClassSignalStorage :: gcore.ClassSignalStorage
OdinClassDescriptor :: gcore.OdinClassDescriptor
ClassVirtualCallbacks :: gcore.ClassVirtualCallbacks
ClassVirtualDescriptor :: gcore.ClassVirtualDescriptor
ClassBuilder :: gcore.ClassBuilder
ClassMethodGodotReal2ToGodotReal :: gcore.ClassMethodGodotReal2ToGodotReal
ClassMethodGodotReal2ToGodotRealAdapter :: gcore.ClassMethodGodotReal2ToGodotRealAdapter
ClassMethodVoid :: gcore.ClassMethodVoid
ClassMethodVoidAdapter :: gcore.ClassMethodVoidAdapter
ClassMethodGetGodotReal :: gcore.ClassMethodGetGodotReal
ClassMethodGetGodotRealAdapter :: gcore.ClassMethodGetGodotRealAdapter
ClassMethodSetGodotReal :: gcore.ClassMethodSetGodotReal
ClassMethodSetGodotRealAdapter :: gcore.ClassMethodSetGodotRealAdapter
ClassMethodGetBool :: gcore.ClassMethodGetBool
ClassMethodGetBoolAdapter :: gcore.ClassMethodGetBoolAdapter
ClassMethodSetBool :: gcore.ClassMethodSetBool
ClassMethodSetBoolAdapter :: gcore.ClassMethodSetBoolAdapter
ClassMethodGetInt :: gcore.ClassMethodGetInt
ClassMethodGetIntAdapter :: gcore.ClassMethodGetIntAdapter
ClassMethodSetInt :: gcore.ClassMethodSetInt
ClassMethodSetIntAdapter :: gcore.ClassMethodSetIntAdapter
ClassMethodGetString :: gcore.ClassMethodGetString
ClassMethodGetStringAdapter :: gcore.ClassMethodGetStringAdapter
ClassMethodSetString :: gcore.ClassMethodSetString
ClassMethodSetStringAdapter :: gcore.ClassMethodSetStringAdapter
ClassMethodSetObjectPtr :: gcore.ClassMethodSetObjectPtr
ClassMethodSetObjectPtrAdapter :: gcore.ClassMethodSetObjectPtrAdapter
ClassFixedMethodStorage :: gcore.ClassFixedMethodStorage
ClassPrimitivePropertyStorage :: gcore.ClassPrimitivePropertyStorage
ClassTypedPropertyDescriptor :: gcore.ClassTypedPropertyDescriptor
ClassTypedProperty :: gcore.ClassTypedProperty
InstanceBindingCallbacks :: gcore.InstanceBindingCallbacks
VariantType :: gcore.VariantType
VariantStorage :: gcore.VariantStorage
Variant :: gcore.Variant
StringStorage :: gcore.StringStorage
String :: gcore.String
StringNameStorage :: gcore.StringNameStorage
StringName :: gcore.StringName
StaticStringName :: gcore.StaticStringName
ClassName :: gcore.ClassName
RegistrationStringName :: gcore.RegistrationStringName
RegistrationString :: gcore.RegistrationString
ClassRegistrationNames :: gcore.ClassRegistrationNames
NodePathStorage :: gcore.NodePathStorage
NodePath :: gcore.NodePath
CallableStorage :: gcore.CallableStorage
Callable :: gcore.Callable
SignalStorage :: gcore.SignalStorage
Signal :: gcore.Signal
RIDStorage :: gcore.RIDStorage
RID :: gcore.RID
ArrayStorage :: gcore.ArrayStorage
Array :: gcore.Array
TypedArrayStorage :: gcore.TypedArrayStorage
TypedArray :: gcore.TypedArray
DictionaryStorage :: gcore.DictionaryStorage
Dictionary :: gcore.Dictionary
PackedByteArrayStorage :: gcore.PackedByteArrayStorage
PackedByteArray :: gcore.PackedByteArray
PackedInt32ArrayStorage :: gcore.PackedInt32ArrayStorage
PackedInt32Array :: gcore.PackedInt32Array
PackedInt64ArrayStorage :: gcore.PackedInt64ArrayStorage
PackedInt64Array :: gcore.PackedInt64Array
PackedFloat32ArrayStorage :: gcore.PackedFloat32ArrayStorage
PackedFloat32Array :: gcore.PackedFloat32Array
PackedFloat64ArrayStorage :: gcore.PackedFloat64ArrayStorage
PackedFloat64Array :: gcore.PackedFloat64Array
PackedStringArrayStorage :: gcore.PackedStringArrayStorage
PackedStringArray :: gcore.PackedStringArray
PackedVector2ArrayStorage :: gcore.PackedVector2ArrayStorage
PackedVector2Array :: gcore.PackedVector2Array
PackedVector3ArrayStorage :: gcore.PackedVector3ArrayStorage
PackedVector3Array :: gcore.PackedVector3Array
PackedVector4ArrayStorage :: gcore.PackedVector4ArrayStorage
PackedVector4Array :: gcore.PackedVector4Array
PackedColorArrayStorage :: gcore.PackedColorArrayStorage
PackedColorArray :: gcore.PackedColorArray
StringRepr :: gcore.StringRepr
GodotReal :: gcore.GodotReal
Vector2 :: gcore.Vector2
Vector3 :: gcore.Vector3
Vector4 :: gcore.Vector4
Color :: gcore.Color
Vector2i :: gbind_builtin.Vector2i
Rect2 :: gbind_builtin.Rect2
Rect2i :: gbind_builtin.Rect2i
Vector3i :: gbind_builtin.Vector3i
Transform2D :: gbind_builtin.Transform2D
Vector4i :: gbind_builtin.Vector4i
Plane :: gbind_builtin.Plane
Quaternion :: gbind_builtin.Quaternion
AABB :: gbind_builtin.AABB
Basis :: gbind_builtin.Basis
Transform3D :: gbind_builtin.Transform3D
Projection :: gbind_builtin.Projection
Error :: gclass.Error
Side :: gclass.Side
Key :: gclass.Key
KeyLocation :: gclass.KeyLocation
MouseButton :: gclass.MouseButton
HorizontalAlignment :: gclass.HorizontalAlignment
VerticalAlignment :: gclass.VerticalAlignment
Resource :: gclass.Resource
Texture2D :: gclass.Texture2D
ImageTexture :: gclass.ImageTexture
// Resource loading policy: ResourceLoader.load returns a Resource through a
// Variant call in focused helpers. The helper retains the borrowed Resource into
// OwnedResource before freeing the temporary Variant, so callers always receive
// an explicit owned reference and must release or destroy it.
OwnedResource :: struct {
	ref: OwnedRefCounted,
}
Node :: gclass.Node
CanvasItem :: gclass.CanvasItem
Node2D :: gclass.Node2D
Control :: gclass.Control
BaseButton :: gclass.BaseButton
Button :: gclass.Button
TextureRect :: gclass.TextureRect
Panel :: gclass.Panel
Container :: gclass.Container
Sprite2D :: gclass.Sprite2D
Label :: gclass.Label
Timer :: gclass.Timer
CollisionObject2D :: gclass.CollisionObject2D
Area2D :: gclass.Area2D
PhysicsBody2D :: gclass.PhysicsBody2D
CharacterBody2D :: gclass.CharacterBody2D
RigidBody2D :: gclass.RigidBody2D
StaticBody2D :: gclass.StaticBody2D
CollisionShape2D :: gclass.CollisionShape2D
PackedScene :: gclass.PackedScene
ResourceLoader :: gclass.ResourceLoader
Input :: gclass.Input
InputEvent :: gclass.InputEvent
InputEventFromWindow :: gclass.InputEventFromWindow
InputEventWithModifiers :: gclass.InputEventWithModifiers
InputEventKey :: gclass.InputEventKey
InputEventMouse :: gclass.InputEventMouse
InputEventMouseButton :: gclass.InputEventMouseButton
InputEventMouseMotion :: gclass.InputEventMouseMotion
Viewport :: gclass.Viewport
SceneTree :: gclass.SceneTree

// --- Core functions ---
init :: gcore.init
construct_object :: gcore.construct_object
debug_print :: gcore.debug_print
is_nil :: gcore.is_nil
global_get_singleton_checked :: gcore.global_get_singleton_checked
global_get_singleton_or_trap :: gcore.global_get_singleton_or_trap
is_class :: gcore.is_class
cast_to :: gcore.cast_to
init_class_casting :: gcore.init_class_casting
register_editor_visible_class :: gcore.register_editor_visible_class
register_class_with_defaults :: gcore.register_class_with_defaults
unregister_class :: gcore.unregister_class
registration_string_name_ptr :: gcore.registration_string_name_ptr
registration_string_name_mut_ptr :: gcore.registration_string_name_mut_ptr
registration_string_name_init_latin1_cstring :: gcore.registration_string_name_init_latin1_cstring
registration_string_ptr :: gcore.registration_string_ptr
registration_string_mut_ptr :: gcore.registration_string_mut_ptr
registration_string_init_utf8 :: gcore.registration_string_init_utf8
registration_string_free :: gcore.registration_string_free
class_registration_names_init :: gcore.class_registration_names_init
class_registration_class_name :: gcore.class_registration_class_name
class_registration_parent_name :: gcore.class_registration_parent_name
attach_instance :: gcore.attach_instance
attach_typed_instance :: gcore.attach_typed_instance
class_instance_data :: gcore.class_instance_data
class_instance_data_or_trap :: gcore.class_instance_data_or_trap
class_member_defaults :: gcore.class_member_defaults
class_member_property :: gcore.class_member_property
init_method_property_info :: gcore.init_method_property_info
init_class_property_info :: gcore.init_class_property_info
init_class_method_info :: gcore.init_class_method_info
register_class_property_with_descriptor :: gcore.register_class_property_with_descriptor
register_class_signal_with_descriptor :: gcore.register_class_signal_with_descriptor
register_class_method_with_descriptor :: gcore.register_class_method_with_descriptor
register_odin_class :: gcore.register_odin_class
unregister_odin_class :: gcore.unregister_odin_class
class_signal_0 :: gcore.class_signal_0
class_signal_1_godot_real :: gcore.class_signal_1_godot_real
class_signal_2_godot_real :: gcore.class_signal_2_godot_real
class_builder_begin :: gcore.class_builder_begin
class_virtual_descriptor :: gcore.class_virtual_descriptor
class_builder_methods :: gcore.class_builder_methods
class_builder_properties :: gcore.class_builder_properties
class_builder_signals :: gcore.class_builder_signals
class_builder_finalize :: gcore.class_builder_finalize
class_builder_register :: gcore.class_builder_register
class_builder_unregister :: gcore.class_builder_unregister
class_method_void :: gcore.class_method_void
class_method_get_godot_real :: gcore.class_method_get_godot_real
class_method_set_godot_real :: gcore.class_method_set_godot_real
class_method_godot_real2_to_godot_real :: gcore.class_method_godot_real2_to_godot_real
class_method_godot_real2_to_godot_real_call :: gcore.class_method_godot_real2_to_godot_real_call
class_method_godot_real2_to_godot_real_ptrcall ::
	gcore.class_method_godot_real2_to_godot_real_ptrcall
class_method_void_call :: gcore.class_method_void_call
class_method_void_ptrcall :: gcore.class_method_void_ptrcall
class_method_get_godot_real_call :: gcore.class_method_get_godot_real_call
class_method_get_godot_real_ptrcall :: gcore.class_method_get_godot_real_ptrcall
class_method_set_godot_real_call :: gcore.class_method_set_godot_real_call
class_method_set_godot_real_ptrcall :: gcore.class_method_set_godot_real_ptrcall
class_method_get_bool_call :: gcore.class_method_get_bool_call
class_method_get_bool_ptrcall :: gcore.class_method_get_bool_ptrcall
class_method_set_bool_call :: gcore.class_method_set_bool_call
class_method_set_bool_ptrcall :: gcore.class_method_set_bool_ptrcall
class_method_get_int_call :: gcore.class_method_get_int_call
class_method_get_int_ptrcall :: gcore.class_method_get_int_ptrcall
class_method_set_int_call :: gcore.class_method_set_int_call
class_method_set_int_ptrcall :: gcore.class_method_set_int_ptrcall
class_method_get_string_call :: gcore.class_method_get_string_call
class_method_get_string_ptrcall :: gcore.class_method_get_string_ptrcall
class_method_set_string_call :: gcore.class_method_set_string_call
class_method_set_string_ptrcall :: gcore.class_method_set_string_ptrcall
class_method_set_object_ptr_call :: gcore.class_method_set_object_ptr_call
class_method_set_object_ptr_ptrcall :: gcore.class_method_set_object_ptr_ptrcall
class_typed_property_descriptor :: gcore.class_typed_property_descriptor
class_property_godot_real :: gcore.class_property_godot_real
class_property_int :: gcore.class_property_int
class_property_bool :: gcore.class_property_bool
class_property_string :: gcore.class_property_string
object_to_variant :: gcore.object_to_variant
object_from_variant :: gcore.object_from_variant
variant_try_object :: gcore.variant_try_object
ref_counted_retain :: gcore.ref_counted_retain
ref_counted_unreference :: gcore.ref_counted_unreference
object_destroy_checked :: gcore.object_destroy_checked
owned_ref_counted_nil :: gcore.owned_ref_counted_nil
owned_ref_counted_is_nil :: gcore.owned_ref_counted_is_nil
owned_ref_counted_handle :: gcore.owned_ref_counted_handle
owned_ref_counted_init_owned :: gcore.owned_ref_counted_init_owned
owned_ref_counted_retain :: gcore.owned_ref_counted_retain
owned_ref_counted_take :: gcore.owned_ref_counted_take
owned_ref_counted_release :: gcore.owned_ref_counted_release
owned_ref_counted_destroy :: gcore.owned_ref_counted_destroy
variant_from_string_name_ptr :: gcore.variant_from_string_name_ptr
init_signal_emission :: gcore.init_signal_emission
object_emit_signal_0_checked :: gcore.object_emit_signal_0_checked
object_emit_signal_0 :: gcore.object_emit_signal_0
object_emit_signal_1_godot_real_checked :: gcore.object_emit_signal_1_godot_real_checked
object_emit_signal_1_godot_real :: gcore.object_emit_signal_1_godot_real
object_emit_signal_2_godot_real_checked :: gcore.object_emit_signal_2_godot_real_checked
object_emit_signal_2_godot_real :: gcore.object_emit_signal_2_godot_real
// --- Generated signal wrappers ---
object_script_changed_signal_name :: gclass.object_script_changed_signal_name
object_script_changed_signal :: gclass.object_script_changed_signal
object_connect_script_changed_checked :: gclass.object_connect_script_changed_checked
object_connect_script_changed :: gclass.object_connect_script_changed
object_emit_script_changed_checked :: gclass.object_emit_script_changed_checked
object_emit_script_changed :: gclass.object_emit_script_changed
object_property_list_changed_signal_name :: gclass.object_property_list_changed_signal_name
object_property_list_changed_signal :: gclass.object_property_list_changed_signal
object_connect_property_list_changed_checked :: gclass.object_connect_property_list_changed_checked
object_connect_property_list_changed :: gclass.object_connect_property_list_changed
object_emit_property_list_changed_checked :: gclass.object_emit_property_list_changed_checked
object_emit_property_list_changed :: gclass.object_emit_property_list_changed
node_ready_signal_name :: gclass.node_ready_signal_name
node_ready_signal :: gclass.node_ready_signal
node_connect_ready_checked :: gclass.node_connect_ready_checked
node_connect_ready :: gclass.node_connect_ready
node_emit_ready_checked :: gclass.node_emit_ready_checked
node_emit_ready :: gclass.node_emit_ready
node_renamed_signal_name :: gclass.node_renamed_signal_name
node_renamed_signal :: gclass.node_renamed_signal
node_connect_renamed_checked :: gclass.node_connect_renamed_checked
node_connect_renamed :: gclass.node_connect_renamed
node_emit_renamed_checked :: gclass.node_emit_renamed_checked
node_emit_renamed :: gclass.node_emit_renamed
node_tree_entered_signal_name :: gclass.node_tree_entered_signal_name
node_tree_entered_signal :: gclass.node_tree_entered_signal
node_connect_tree_entered_checked :: gclass.node_connect_tree_entered_checked
node_connect_tree_entered :: gclass.node_connect_tree_entered
node_emit_tree_entered_checked :: gclass.node_emit_tree_entered_checked
node_emit_tree_entered :: gclass.node_emit_tree_entered
node_tree_exiting_signal_name :: gclass.node_tree_exiting_signal_name
node_tree_exiting_signal :: gclass.node_tree_exiting_signal
node_connect_tree_exiting_checked :: gclass.node_connect_tree_exiting_checked
node_connect_tree_exiting :: gclass.node_connect_tree_exiting
node_emit_tree_exiting_checked :: gclass.node_emit_tree_exiting_checked
node_emit_tree_exiting :: gclass.node_emit_tree_exiting
node_tree_exited_signal_name :: gclass.node_tree_exited_signal_name
node_tree_exited_signal :: gclass.node_tree_exited_signal
node_connect_tree_exited_checked :: gclass.node_connect_tree_exited_checked
node_connect_tree_exited :: gclass.node_connect_tree_exited
node_emit_tree_exited_checked :: gclass.node_emit_tree_exited_checked
node_emit_tree_exited :: gclass.node_emit_tree_exited
node_child_entered_tree_signal_name :: gclass.node_child_entered_tree_signal_name
node_child_entered_tree_signal :: gclass.node_child_entered_tree_signal
node_connect_child_entered_tree_checked :: gclass.node_connect_child_entered_tree_checked
node_connect_child_entered_tree :: gclass.node_connect_child_entered_tree
node_emit_child_entered_tree_checked :: gclass.node_emit_child_entered_tree_checked
node_emit_child_entered_tree :: gclass.node_emit_child_entered_tree
node_child_exiting_tree_signal_name :: gclass.node_child_exiting_tree_signal_name
node_child_exiting_tree_signal :: gclass.node_child_exiting_tree_signal
node_connect_child_exiting_tree_checked :: gclass.node_connect_child_exiting_tree_checked
node_connect_child_exiting_tree :: gclass.node_connect_child_exiting_tree
node_emit_child_exiting_tree_checked :: gclass.node_emit_child_exiting_tree_checked
node_emit_child_exiting_tree :: gclass.node_emit_child_exiting_tree
timer_timeout_signal_name :: gclass.timer_timeout_signal_name
timer_timeout_signal :: gclass.timer_timeout_signal
timer_connect_timeout_checked :: gclass.timer_connect_timeout_checked
timer_connect_timeout :: gclass.timer_connect_timeout
timer_emit_timeout_checked :: gclass.timer_emit_timeout_checked
timer_emit_timeout :: gclass.timer_emit_timeout
control_resized_signal_name :: gclass.control_resized_signal_name
control_resized_signal :: gclass.control_resized_signal
control_connect_resized_checked :: gclass.control_connect_resized_checked
control_connect_resized :: gclass.control_connect_resized
control_emit_resized_checked :: gclass.control_emit_resized_checked
control_emit_resized :: gclass.control_emit_resized
control_mouse_entered_signal_name :: gclass.control_mouse_entered_signal_name
control_mouse_entered_signal :: gclass.control_mouse_entered_signal
control_connect_mouse_entered_checked :: gclass.control_connect_mouse_entered_checked
control_connect_mouse_entered :: gclass.control_connect_mouse_entered
control_emit_mouse_entered_checked :: gclass.control_emit_mouse_entered_checked
control_emit_mouse_entered :: gclass.control_emit_mouse_entered
control_mouse_exited_signal_name :: gclass.control_mouse_exited_signal_name
control_mouse_exited_signal :: gclass.control_mouse_exited_signal
control_connect_mouse_exited_checked :: gclass.control_connect_mouse_exited_checked
control_connect_mouse_exited :: gclass.control_connect_mouse_exited
control_emit_mouse_exited_checked :: gclass.control_emit_mouse_exited_checked
control_emit_mouse_exited :: gclass.control_emit_mouse_exited
area2d_body_entered_signal_name :: gclass.area2d_body_entered_signal_name
area2d_body_entered_signal :: gclass.area2d_body_entered_signal
area2d_connect_body_entered_checked :: gclass.area2d_connect_body_entered_checked
area2d_connect_body_entered :: gclass.area2d_connect_body_entered
area2d_emit_body_entered_checked :: gclass.area2d_emit_body_entered_checked
area2d_emit_body_entered :: gclass.area2d_emit_body_entered
area2d_body_exited_signal_name :: gclass.area2d_body_exited_signal_name
area2d_body_exited_signal :: gclass.area2d_body_exited_signal
area2d_connect_body_exited_checked :: gclass.area2d_connect_body_exited_checked
area2d_connect_body_exited :: gclass.area2d_connect_body_exited
area2d_emit_body_exited_checked :: gclass.area2d_emit_body_exited_checked
area2d_emit_body_exited :: gclass.area2d_emit_body_exited
area2d_area_entered_signal_name :: gclass.area2d_area_entered_signal_name
area2d_area_entered_signal :: gclass.area2d_area_entered_signal
area2d_connect_area_entered_checked :: gclass.area2d_connect_area_entered_checked
area2d_connect_area_entered :: gclass.area2d_connect_area_entered
area2d_emit_area_entered_checked :: gclass.area2d_emit_area_entered_checked
area2d_emit_area_entered :: gclass.area2d_emit_area_entered
area2d_area_exited_signal_name :: gclass.area2d_area_exited_signal_name
area2d_area_exited_signal :: gclass.area2d_area_exited_signal
area2d_connect_area_exited_checked :: gclass.area2d_connect_area_exited_checked
area2d_connect_area_exited :: gclass.area2d_connect_area_exited
area2d_emit_area_exited_checked :: gclass.area2d_emit_area_exited_checked
area2d_emit_area_exited :: gclass.area2d_emit_area_exited
collision_object2d_mouse_entered_signal_name :: gclass.collision_object2d_mouse_entered_signal_name
collision_object2d_mouse_entered_signal :: gclass.collision_object2d_mouse_entered_signal
collision_object2d_connect_mouse_entered_checked ::
	gclass.collision_object2d_connect_mouse_entered_checked
collision_object2d_connect_mouse_entered :: gclass.collision_object2d_connect_mouse_entered
collision_object2d_emit_mouse_entered_checked ::
	gclass.collision_object2d_emit_mouse_entered_checked
collision_object2d_emit_mouse_entered :: gclass.collision_object2d_emit_mouse_entered
collision_object2d_mouse_exited_signal_name :: gclass.collision_object2d_mouse_exited_signal_name
collision_object2d_mouse_exited_signal :: gclass.collision_object2d_mouse_exited_signal
collision_object2d_connect_mouse_exited_checked ::
	gclass.collision_object2d_connect_mouse_exited_checked
collision_object2d_connect_mouse_exited :: gclass.collision_object2d_connect_mouse_exited
collision_object2d_emit_mouse_exited_checked :: gclass.collision_object2d_emit_mouse_exited_checked
collision_object2d_emit_mouse_exited :: gclass.collision_object2d_emit_mouse_exited

godot_context :: gcore.godot_context
init_class_bindings :: gclass.init_class_bindings
ref_counted_as_object :: gclass.ref_counted_as_object
resource_as_ref_counted :: gclass.resource_as_ref_counted
resource_as_object :: gclass.resource_as_object
texture2d_as_resource :: gclass.texture2d_as_resource
texture2d_as_ref_counted :: gclass.texture2d_as_ref_counted
texture2d_as_object :: gclass.texture2d_as_object
image_texture_as_texture2d :: gclass.image_texture_as_texture2d
image_texture_as_resource :: gclass.image_texture_as_resource
image_texture_as_ref_counted :: gclass.image_texture_as_ref_counted
image_texture_as_object :: gclass.image_texture_as_object
ref_counted_get_reference_count :: gclass.ref_counted_get_reference_count
resource_get_path :: gclass.resource_get_path
resource_get_rid :: gclass.resource_get_rid
resource_set_local_to_scene :: gclass.resource_set_local_to_scene
resource_is_local_to_scene :: gclass.resource_is_local_to_scene
texture2d_get_mipmap_count :: gclass.texture2d_get_mipmap_count
texture2d_get_width :: gclass.texture2d_get_width
texture2d_get_height :: gclass.texture2d_get_height
texture2d_get_size :: gclass.texture2d_get_size
texture2d_has_alpha :: gclass.texture2d_has_alpha
texture2d_has_mipmaps :: gclass.texture2d_has_mipmaps
node_as_object :: gclass.node_as_object
node_get_parent :: gclass.node_get_parent
node_get_tree :: gclass.node_get_tree
node_get_viewport :: gclass.node_get_viewport
node_set_name :: gclass.node_set_name
node_get_name :: gclass.node_get_name
node_has_node :: gclass.node_has_node
node_get_node_or_null :: gclass.node_get_node_or_null
node_get_child_count :: gclass.node_get_child_count
node_get_child_count_default :: gclass.node_get_child_count_default
node_get_child :: gclass.node_get_child
node_get_child_default :: gclass.node_get_child_default
node_is_inside_tree :: gclass.node_is_inside_tree
node_get_path :: gclass.node_get_path
node_is_ancestor_of :: gclass.node_is_ancestor_of
node_get_path_to :: gclass.node_get_path_to
node_get_path_to_default :: gclass.node_get_path_to_default
node_remove_from_group :: gclass.node_remove_from_group
node_is_in_group :: gclass.node_is_in_group
node_set_process :: gclass.node_set_process
node_is_processing :: gclass.node_is_processing
node_get_process_delta_time :: gclass.node_get_process_delta_time
node_set_physics_process :: gclass.node_set_physics_process
node_is_physics_processing :: gclass.node_is_physics_processing
node_get_physics_process_delta_time :: gclass.node_get_physics_process_delta_time
canvas_item_set_visible :: gclass.canvas_item_set_visible
canvas_item_is_visible :: gclass.canvas_item_is_visible
canvas_item_is_visible_in_tree :: gclass.canvas_item_is_visible_in_tree
canvas_item_show :: gclass.canvas_item_show
canvas_item_hide :: gclass.canvas_item_hide
canvas_item_queue_redraw :: gclass.canvas_item_queue_redraw
canvas_item_move_to_front :: gclass.canvas_item_move_to_front
canvas_item_set_as_top_level :: gclass.canvas_item_set_as_top_level
canvas_item_is_set_as_top_level :: gclass.canvas_item_is_set_as_top_level
canvas_item_set_light_mask :: gclass.canvas_item_set_light_mask
canvas_item_get_light_mask :: gclass.canvas_item_get_light_mask
canvas_item_set_modulate :: gclass.canvas_item_set_modulate
canvas_item_get_modulate :: gclass.canvas_item_get_modulate
canvas_item_set_self_modulate :: gclass.canvas_item_set_self_modulate
canvas_item_get_self_modulate :: gclass.canvas_item_get_self_modulate
canvas_item_set_z_index :: gclass.canvas_item_set_z_index
canvas_item_get_z_index :: gclass.canvas_item_get_z_index
canvas_item_set_z_as_relative :: gclass.canvas_item_set_z_as_relative
canvas_item_is_z_relative :: gclass.canvas_item_is_z_relative
canvas_item_set_y_sort_enabled :: gclass.canvas_item_set_y_sort_enabled
canvas_item_is_y_sort_enabled :: gclass.canvas_item_is_y_sort_enabled
canvas_item_set_draw_behind_parent :: gclass.canvas_item_set_draw_behind_parent
canvas_item_is_draw_behind_parent_enabled :: gclass.canvas_item_is_draw_behind_parent_enabled
canvas_item_get_canvas :: gclass.canvas_item_get_canvas
canvas_item_get_canvas_item :: gclass.canvas_item_get_canvas_item
canvas_item_draw_set_transform_matrix :: gclass.canvas_item_draw_set_transform_matrix
canvas_item_get_transform :: gclass.canvas_item_get_transform
canvas_item_get_global_transform :: gclass.canvas_item_get_global_transform
canvas_item_get_global_transform_with_canvas :: gclass.canvas_item_get_global_transform_with_canvas
canvas_item_get_viewport_transform :: gclass.canvas_item_get_viewport_transform
canvas_item_get_viewport_rect :: gclass.canvas_item_get_viewport_rect
canvas_item_get_canvas_transform :: gclass.canvas_item_get_canvas_transform
canvas_item_get_screen_transform :: gclass.canvas_item_get_screen_transform
canvas_item_get_local_mouse_position :: gclass.canvas_item_get_local_mouse_position
canvas_item_get_global_mouse_position :: gclass.canvas_item_get_global_mouse_position
canvas_item_as_node :: gclass.canvas_item_as_node
canvas_item_as_object :: gclass.canvas_item_as_object
node2d_as_canvas_item :: gclass.node2d_as_canvas_item
node2d_as_node :: gclass.node2d_as_node
node2d_as_object :: gclass.node2d_as_object
object_get_class :: gclass.object_get_class
object_is_class :: gclass.object_is_class
object_set_meta :: gclass.object_set_meta
object_get_meta :: gclass.object_get_meta
node2d_set_position :: gclass.node2d_set_position
node2d_get_position :: gclass.node2d_get_position
node2d_set_rotation :: gclass.node2d_set_rotation
node2d_get_rotation :: gclass.node2d_get_rotation
node2d_set_rotation_degrees :: gclass.node2d_set_rotation_degrees
node2d_get_rotation_degrees :: gclass.node2d_get_rotation_degrees
node2d_set_skew :: gclass.node2d_set_skew
node2d_get_skew :: gclass.node2d_get_skew
node2d_set_scale :: gclass.node2d_set_scale
node2d_get_scale :: gclass.node2d_get_scale
node2d_rotate :: gclass.node2d_rotate
node2d_translate :: gclass.node2d_translate
node2d_global_translate :: gclass.node2d_global_translate
node2d_apply_scale :: gclass.node2d_apply_scale
node2d_set_global_position :: gclass.node2d_set_global_position
node2d_get_global_position :: gclass.node2d_get_global_position
node2d_set_global_rotation :: gclass.node2d_set_global_rotation
node2d_get_global_rotation :: gclass.node2d_get_global_rotation
node2d_set_global_scale :: gclass.node2d_set_global_scale
node2d_get_global_scale :: gclass.node2d_get_global_scale
node2d_set_transform :: gclass.node2d_set_transform
node2d_set_global_transform :: gclass.node2d_set_global_transform
node2d_look_at :: gclass.node2d_look_at
node2d_get_angle_to :: gclass.node2d_get_angle_to
node2d_to_local :: gclass.node2d_to_local
node2d_to_global :: gclass.node2d_to_global
node2d_get_relative_transform_to_parent :: gclass.node2d_get_relative_transform_to_parent
control_accept_event :: gclass.control_accept_event
control_set_custom_minimum_size :: gclass.control_set_custom_minimum_size
control_get_custom_minimum_size :: gclass.control_get_custom_minimum_size
control_get_maximum_size :: gclass.control_get_maximum_size
control_get_combined_maximum_size :: gclass.control_get_combined_maximum_size
control_get_minimum_size :: gclass.control_get_minimum_size
control_get_combined_minimum_size :: gclass.control_get_combined_minimum_size
control_set_propagate_maximum_size :: gclass.control_set_propagate_maximum_size
control_is_propagating_maximum_size :: gclass.control_is_propagating_maximum_size
control_get_bound_minimum_size :: gclass.control_get_bound_minimum_size
control_get_anchor :: gclass.control_get_anchor
control_set_offset :: gclass.control_set_offset
control_get_offset :: gclass.control_get_offset
control_set_begin :: gclass.control_set_begin
control_set_end :: gclass.control_set_end
control_set_position :: gclass.control_set_position
control_set_position_default :: gclass.control_set_position_default
control_set_size :: gclass.control_set_size
control_set_size_default :: gclass.control_set_size_default
control_reset_size :: gclass.control_reset_size
control_set_custom_maximum_size :: gclass.control_set_custom_maximum_size
control_set_global_position :: gclass.control_set_global_position
control_set_global_position_default :: gclass.control_set_global_position_default
control_set_rotation :: gclass.control_set_rotation
control_set_rotation_degrees :: gclass.control_set_rotation_degrees
control_set_scale :: gclass.control_set_scale
control_set_pivot_offset :: gclass.control_set_pivot_offset
control_get_begin :: gclass.control_get_begin
control_get_end :: gclass.control_get_end
control_get_position :: gclass.control_get_position
control_get_size :: gclass.control_get_size
control_get_rotation :: gclass.control_get_rotation
control_get_rotation_degrees :: gclass.control_get_rotation_degrees
control_get_scale :: gclass.control_get_scale
control_get_pivot_offset :: gclass.control_get_pivot_offset
control_get_custom_maximum_size :: gclass.control_get_custom_maximum_size
control_get_parent_area_size :: gclass.control_get_parent_area_size
control_get_global_position :: gclass.control_get_global_position
control_get_screen_position :: gclass.control_get_screen_position
control_get_rect :: gclass.control_get_rect
control_get_global_rect :: gclass.control_get_global_rect
control_set_focus_mode :: gclass.control_set_focus_mode
control_get_focus_mode :: gclass.control_get_focus_mode
control_has_focus :: gclass.control_has_focus
control_has_focus_default :: gclass.control_has_focus_default
control_grab_focus :: gclass.control_grab_focus
control_grab_focus_default :: gclass.control_grab_focus_default
control_release_focus :: gclass.control_release_focus
control_set_mouse_filter :: gclass.control_set_mouse_filter
control_get_mouse_filter :: gclass.control_get_mouse_filter
sprite2d_set_texture :: gclass.sprite2d_set_texture
sprite2d_get_texture :: gclass.sprite2d_get_texture
sprite2d_set_centered :: gclass.sprite2d_set_centered
sprite2d_is_centered :: gclass.sprite2d_is_centered
sprite2d_set_offset :: gclass.sprite2d_set_offset
sprite2d_get_offset :: gclass.sprite2d_get_offset
sprite2d_set_flip_h :: gclass.sprite2d_set_flip_h
sprite2d_is_flipped_h :: gclass.sprite2d_is_flipped_h
sprite2d_set_flip_v :: gclass.sprite2d_set_flip_v
sprite2d_is_flipped_v :: gclass.sprite2d_is_flipped_v
sprite2d_set_region_enabled :: gclass.sprite2d_set_region_enabled
sprite2d_is_region_enabled :: gclass.sprite2d_is_region_enabled
sprite2d_set_region_rect :: gclass.sprite2d_set_region_rect
sprite2d_get_region_rect :: gclass.sprite2d_get_region_rect
sprite2d_set_region_filter_clip_enabled :: gclass.sprite2d_set_region_filter_clip_enabled
sprite2d_is_region_filter_clip_enabled :: gclass.sprite2d_is_region_filter_clip_enabled
sprite2d_is_pixel_opaque :: gclass.sprite2d_is_pixel_opaque
sprite2d_set_frame :: gclass.sprite2d_set_frame
sprite2d_get_frame :: gclass.sprite2d_get_frame
sprite2d_set_vframes :: gclass.sprite2d_set_vframes
sprite2d_get_vframes :: gclass.sprite2d_get_vframes
sprite2d_set_hframes :: gclass.sprite2d_set_hframes
sprite2d_get_hframes :: gclass.sprite2d_get_hframes
sprite2d_set_frame_coords :: gclass.sprite2d_set_frame_coords
sprite2d_get_frame_coords :: gclass.sprite2d_get_frame_coords
sprite2d_get_rect :: gclass.sprite2d_get_rect
label_set_text :: gclass.label_set_text
label_get_text :: gclass.label_get_text
label_set_clip_text :: gclass.label_set_clip_text
label_is_clipping_text :: gclass.label_is_clipping_text
label_set_horizontal_alignment :: gclass.label_set_horizontal_alignment
label_get_horizontal_alignment :: gclass.label_get_horizontal_alignment
label_set_vertical_alignment :: gclass.label_set_vertical_alignment
label_get_vertical_alignment :: gclass.label_get_vertical_alignment
label_set_text_direction :: gclass.label_set_text_direction
label_get_text_direction :: gclass.label_get_text_direction
label_set_language :: gclass.label_set_language
label_get_language :: gclass.label_get_language
label_set_paragraph_separator :: gclass.label_set_paragraph_separator
label_get_paragraph_separator :: gclass.label_get_paragraph_separator
label_set_tab_stops :: gclass.label_set_tab_stops
label_get_tab_stops :: gclass.label_get_tab_stops
label_set_ellipsis_char :: gclass.label_set_ellipsis_char
label_get_ellipsis_char :: gclass.label_get_ellipsis_char
label_set_uppercase :: gclass.label_set_uppercase
label_is_uppercase :: gclass.label_is_uppercase
label_get_line_count :: gclass.label_get_line_count
label_get_visible_line_count :: gclass.label_get_visible_line_count
label_get_total_character_count :: gclass.label_get_total_character_count
label_set_visible_characters :: gclass.label_set_visible_characters
label_get_visible_characters :: gclass.label_get_visible_characters
label_set_visible_ratio :: gclass.label_set_visible_ratio
label_get_visible_ratio :: gclass.label_get_visible_ratio
label_set_lines_skipped :: gclass.label_set_lines_skipped
label_get_lines_skipped :: gclass.label_get_lines_skipped
label_set_max_lines_visible :: gclass.label_set_max_lines_visible
label_get_max_lines_visible :: gclass.label_get_max_lines_visible
label_set_structured_text_bidi_override_options ::
	gclass.label_set_structured_text_bidi_override_options
label_get_structured_text_bidi_override_options ::
	gclass.label_get_structured_text_bidi_override_options
label_get_character_bounds :: gclass.label_get_character_bounds
base_button_set_pressed :: gclass.base_button_set_pressed
base_button_is_pressed :: gclass.base_button_is_pressed
base_button_set_pressed_no_signal :: gclass.base_button_set_pressed_no_signal
base_button_is_hovered :: gclass.base_button_is_hovered
base_button_set_toggle_mode :: gclass.base_button_set_toggle_mode
base_button_is_toggle_mode :: gclass.base_button_is_toggle_mode
base_button_set_shortcut_in_tooltip :: gclass.base_button_set_shortcut_in_tooltip
base_button_is_shortcut_in_tooltip_enabled :: gclass.base_button_is_shortcut_in_tooltip_enabled
base_button_set_disabled :: gclass.base_button_set_disabled
base_button_is_disabled :: gclass.base_button_is_disabled
base_button_set_action_mode :: gclass.base_button_set_action_mode
base_button_get_action_mode :: gclass.base_button_get_action_mode
base_button_get_draw_mode :: gclass.base_button_get_draw_mode
base_button_set_keep_pressed_outside :: gclass.base_button_set_keep_pressed_outside
base_button_is_keep_pressed_outside :: gclass.base_button_is_keep_pressed_outside
base_button_set_shortcut_feedback :: gclass.base_button_set_shortcut_feedback
base_button_is_shortcut_feedback :: gclass.base_button_is_shortcut_feedback
button_set_text :: gclass.button_set_text
button_get_text :: gclass.button_get_text
button_set_text_direction :: gclass.button_set_text_direction
button_get_text_direction :: gclass.button_get_text_direction
button_set_language :: gclass.button_set_language
button_get_language :: gclass.button_get_language
button_set_flat :: gclass.button_set_flat
button_is_flat :: gclass.button_is_flat
button_set_clip_text :: gclass.button_set_clip_text
button_get_clip_text :: gclass.button_get_clip_text
button_set_text_alignment :: gclass.button_set_text_alignment
button_get_text_alignment :: gclass.button_get_text_alignment
button_set_icon_alignment :: gclass.button_set_icon_alignment
button_get_icon_alignment :: gclass.button_get_icon_alignment
button_set_vertical_icon_alignment :: gclass.button_set_vertical_icon_alignment
button_get_vertical_icon_alignment :: gclass.button_get_vertical_icon_alignment
button_set_expand_icon :: gclass.button_set_expand_icon
button_is_expand_icon :: gclass.button_is_expand_icon
texture_rect_set_texture :: gclass.texture_rect_set_texture
texture_rect_get_texture :: gclass.texture_rect_get_texture
texture_rect_set_expand_mode :: gclass.texture_rect_set_expand_mode
texture_rect_get_expand_mode :: gclass.texture_rect_get_expand_mode
texture_rect_set_flip_h :: gclass.texture_rect_set_flip_h
texture_rect_is_flipped_h :: gclass.texture_rect_is_flipped_h
texture_rect_set_flip_v :: gclass.texture_rect_set_flip_v
texture_rect_is_flipped_v :: gclass.texture_rect_is_flipped_v
texture_rect_set_stretch_mode :: gclass.texture_rect_set_stretch_mode
texture_rect_get_stretch_mode :: gclass.texture_rect_get_stretch_mode
container_queue_sort :: gclass.container_queue_sort
container_fit_child_in_rect :: gclass.container_fit_child_in_rect
container_set_accessibility_region :: gclass.container_set_accessibility_region
container_is_accessibility_region :: gclass.container_is_accessibility_region
control_as_canvas_item :: gclass.control_as_canvas_item
control_as_node :: gclass.control_as_node
control_as_object :: gclass.control_as_object
sprite2d_as_node2d :: gclass.sprite2d_as_node2d
sprite2d_as_canvas_item :: gclass.sprite2d_as_canvas_item
sprite2d_as_node :: gclass.sprite2d_as_node
sprite2d_as_object :: gclass.sprite2d_as_object
label_as_control :: gclass.label_as_control
label_as_canvas_item :: gclass.label_as_canvas_item
label_as_node :: gclass.label_as_node
label_as_object :: gclass.label_as_object
base_button_as_control :: gclass.base_button_as_control
base_button_as_canvas_item :: gclass.base_button_as_canvas_item
base_button_as_node :: gclass.base_button_as_node
base_button_as_object :: gclass.base_button_as_object
button_as_base_button :: gclass.button_as_base_button
button_as_control :: gclass.button_as_control
button_as_canvas_item :: gclass.button_as_canvas_item
button_as_node :: gclass.button_as_node
button_as_object :: gclass.button_as_object
texture_rect_as_control :: gclass.texture_rect_as_control
texture_rect_as_canvas_item :: gclass.texture_rect_as_canvas_item
texture_rect_as_node :: gclass.texture_rect_as_node
texture_rect_as_object :: gclass.texture_rect_as_object
panel_as_control :: gclass.panel_as_control
panel_as_canvas_item :: gclass.panel_as_canvas_item
panel_as_node :: gclass.panel_as_node
panel_as_object :: gclass.panel_as_object
container_as_control :: gclass.container_as_control
container_as_canvas_item :: gclass.container_as_canvas_item
container_as_node :: gclass.container_as_node
container_as_object :: gclass.container_as_object
object_is_ref_counted :: gclass.object_is_ref_counted
object_try_as_ref_counted :: gclass.object_try_as_ref_counted
object_is_resource :: gclass.object_is_resource
object_try_as_resource :: gclass.object_try_as_resource
object_is_texture2d :: gclass.object_is_texture2d
object_try_as_texture2d :: gclass.object_try_as_texture2d
object_is_image_texture :: gclass.object_is_image_texture
object_try_as_image_texture :: gclass.object_try_as_image_texture
resource_is_texture2d :: gclass.resource_is_texture2d
resource_try_as_texture2d :: gclass.resource_try_as_texture2d
resource_is_image_texture :: gclass.resource_is_image_texture
resource_try_as_image_texture :: gclass.resource_try_as_image_texture
texture2d_is_image_texture :: gclass.texture2d_is_image_texture
texture2d_try_as_image_texture :: gclass.texture2d_try_as_image_texture
object_is_node :: gclass.object_is_node
object_try_as_node :: gclass.object_try_as_node
object_is_canvas_item :: gclass.object_is_canvas_item
object_try_as_canvas_item :: gclass.object_try_as_canvas_item
object_is_node2d :: gclass.object_is_node2d
object_try_as_node2d :: gclass.object_try_as_node2d
object_is_control :: gclass.object_is_control
object_try_as_control :: gclass.object_try_as_control
object_is_sprite2d :: gclass.object_is_sprite2d
object_try_as_sprite2d :: gclass.object_try_as_sprite2d
object_is_label :: gclass.object_is_label
object_try_as_label :: gclass.object_try_as_label
object_is_base_button :: gclass.object_is_base_button
object_try_as_base_button :: gclass.object_try_as_base_button
object_is_button :: gclass.object_is_button
object_try_as_button :: gclass.object_try_as_button
object_is_texture_rect :: gclass.object_is_texture_rect
object_try_as_texture_rect :: gclass.object_try_as_texture_rect
object_is_panel :: gclass.object_is_panel
object_try_as_panel :: gclass.object_try_as_panel
object_is_container :: gclass.object_is_container
object_try_as_container :: gclass.object_try_as_container
object_is_timer :: gclass.object_is_timer
object_try_as_timer :: gclass.object_try_as_timer
object_is_collision_object2d :: gclass.object_is_collision_object2d
object_try_as_collision_object2d :: gclass.object_try_as_collision_object2d
object_is_area2d :: gclass.object_is_area2d
object_try_as_area2d :: gclass.object_try_as_area2d
object_is_physics_body2d :: gclass.object_is_physics_body2d
object_try_as_physics_body2d :: gclass.object_try_as_physics_body2d
object_is_character_body2d :: gclass.object_is_character_body2d
object_try_as_character_body2d :: gclass.object_try_as_character_body2d
object_is_rigid_body2d :: gclass.object_is_rigid_body2d
object_try_as_rigid_body2d :: gclass.object_try_as_rigid_body2d
object_is_static_body2d :: gclass.object_is_static_body2d
object_try_as_static_body2d :: gclass.object_try_as_static_body2d
object_is_collision_shape2d :: gclass.object_is_collision_shape2d
object_try_as_collision_shape2d :: gclass.object_try_as_collision_shape2d
object_is_packed_scene :: gclass.object_is_packed_scene
object_try_as_packed_scene :: gclass.object_try_as_packed_scene
object_is_resource_loader :: gclass.object_is_resource_loader
object_try_as_resource_loader :: gclass.object_try_as_resource_loader
object_is_input :: gclass.object_is_input
object_try_as_input :: gclass.object_try_as_input
object_is_input_event :: gclass.object_is_input_event
object_try_as_input_event :: gclass.object_try_as_input_event
object_is_input_event_from_window :: gclass.object_is_input_event_from_window
object_try_as_input_event_from_window :: gclass.object_try_as_input_event_from_window
object_is_input_event_with_modifiers :: gclass.object_is_input_event_with_modifiers
object_try_as_input_event_with_modifiers :: gclass.object_try_as_input_event_with_modifiers
object_is_input_event_key :: gclass.object_is_input_event_key
object_try_as_input_event_key :: gclass.object_try_as_input_event_key
object_is_input_event_mouse :: gclass.object_is_input_event_mouse
object_try_as_input_event_mouse :: gclass.object_try_as_input_event_mouse
object_is_input_event_mouse_button :: gclass.object_is_input_event_mouse_button
object_try_as_input_event_mouse_button :: gclass.object_try_as_input_event_mouse_button
object_is_input_event_mouse_motion :: gclass.object_is_input_event_mouse_motion
object_try_as_input_event_mouse_motion :: gclass.object_try_as_input_event_mouse_motion
object_is_viewport :: gclass.object_is_viewport
object_try_as_viewport :: gclass.object_try_as_viewport
object_is_scene_tree :: gclass.object_is_scene_tree
object_try_as_scene_tree :: gclass.object_try_as_scene_tree
ref_counted_is_resource :: gclass.ref_counted_is_resource
ref_counted_try_as_resource :: gclass.ref_counted_try_as_resource
ref_counted_is_packed_scene :: gclass.ref_counted_is_packed_scene
ref_counted_try_as_packed_scene :: gclass.ref_counted_try_as_packed_scene
resource_is_packed_scene :: gclass.resource_is_packed_scene
resource_try_as_packed_scene :: gclass.resource_try_as_packed_scene
ref_counted_is_input_event :: gclass.ref_counted_is_input_event
ref_counted_try_as_input_event :: gclass.ref_counted_try_as_input_event
ref_counted_is_input_event_from_window :: gclass.ref_counted_is_input_event_from_window
ref_counted_try_as_input_event_from_window :: gclass.ref_counted_try_as_input_event_from_window
ref_counted_is_input_event_with_modifiers :: gclass.ref_counted_is_input_event_with_modifiers
ref_counted_try_as_input_event_with_modifiers ::
	gclass.ref_counted_try_as_input_event_with_modifiers
ref_counted_is_input_event_key :: gclass.ref_counted_is_input_event_key
ref_counted_try_as_input_event_key :: gclass.ref_counted_try_as_input_event_key
ref_counted_is_input_event_mouse :: gclass.ref_counted_is_input_event_mouse
ref_counted_try_as_input_event_mouse :: gclass.ref_counted_try_as_input_event_mouse
ref_counted_is_input_event_mouse_button :: gclass.ref_counted_is_input_event_mouse_button
ref_counted_try_as_input_event_mouse_button :: gclass.ref_counted_try_as_input_event_mouse_button
ref_counted_is_input_event_mouse_motion :: gclass.ref_counted_is_input_event_mouse_motion
ref_counted_try_as_input_event_mouse_motion :: gclass.ref_counted_try_as_input_event_mouse_motion
resource_is_input_event :: gclass.resource_is_input_event
resource_try_as_input_event :: gclass.resource_try_as_input_event
resource_is_input_event_from_window :: gclass.resource_is_input_event_from_window
resource_try_as_input_event_from_window :: gclass.resource_try_as_input_event_from_window
resource_is_input_event_with_modifiers :: gclass.resource_is_input_event_with_modifiers
resource_try_as_input_event_with_modifiers :: gclass.resource_try_as_input_event_with_modifiers
resource_is_input_event_key :: gclass.resource_is_input_event_key
resource_try_as_input_event_key :: gclass.resource_try_as_input_event_key
resource_is_input_event_mouse :: gclass.resource_is_input_event_mouse
resource_try_as_input_event_mouse :: gclass.resource_try_as_input_event_mouse
resource_is_input_event_mouse_button :: gclass.resource_is_input_event_mouse_button
resource_try_as_input_event_mouse_button :: gclass.resource_try_as_input_event_mouse_button
resource_is_input_event_mouse_motion :: gclass.resource_is_input_event_mouse_motion
resource_try_as_input_event_mouse_motion :: gclass.resource_try_as_input_event_mouse_motion
input_event_is_input_event_from_window :: gclass.input_event_is_input_event_from_window
input_event_try_as_input_event_from_window :: gclass.input_event_try_as_input_event_from_window
input_event_is_input_event_with_modifiers :: gclass.input_event_is_input_event_with_modifiers
input_event_try_as_input_event_with_modifiers ::
	gclass.input_event_try_as_input_event_with_modifiers
input_event_is_input_event_key :: gclass.input_event_is_input_event_key
input_event_try_as_input_event_key :: gclass.input_event_try_as_input_event_key
input_event_is_input_event_mouse :: gclass.input_event_is_input_event_mouse
input_event_try_as_input_event_mouse :: gclass.input_event_try_as_input_event_mouse
input_event_is_input_event_mouse_button :: gclass.input_event_is_input_event_mouse_button
input_event_try_as_input_event_mouse_button :: gclass.input_event_try_as_input_event_mouse_button
input_event_is_input_event_mouse_motion :: gclass.input_event_is_input_event_mouse_motion
input_event_try_as_input_event_mouse_motion :: gclass.input_event_try_as_input_event_mouse_motion
input_event_from_window_is_input_event_with_modifiers ::
	gclass.input_event_from_window_is_input_event_with_modifiers
input_event_from_window_try_as_input_event_with_modifiers ::
	gclass.input_event_from_window_try_as_input_event_with_modifiers
input_event_from_window_is_input_event_key :: gclass.input_event_from_window_is_input_event_key
input_event_from_window_try_as_input_event_key ::
	gclass.input_event_from_window_try_as_input_event_key
input_event_from_window_is_input_event_mouse :: gclass.input_event_from_window_is_input_event_mouse
input_event_from_window_try_as_input_event_mouse ::
	gclass.input_event_from_window_try_as_input_event_mouse
input_event_from_window_is_input_event_mouse_button ::
	gclass.input_event_from_window_is_input_event_mouse_button
input_event_from_window_try_as_input_event_mouse_button ::
	gclass.input_event_from_window_try_as_input_event_mouse_button
input_event_from_window_is_input_event_mouse_motion ::
	gclass.input_event_from_window_is_input_event_mouse_motion
input_event_from_window_try_as_input_event_mouse_motion ::
	gclass.input_event_from_window_try_as_input_event_mouse_motion
input_event_with_modifiers_is_input_event_key ::
	gclass.input_event_with_modifiers_is_input_event_key
input_event_with_modifiers_try_as_input_event_key ::
	gclass.input_event_with_modifiers_try_as_input_event_key
input_event_with_modifiers_is_input_event_mouse ::
	gclass.input_event_with_modifiers_is_input_event_mouse
input_event_with_modifiers_try_as_input_event_mouse ::
	gclass.input_event_with_modifiers_try_as_input_event_mouse
input_event_with_modifiers_is_input_event_mouse_button ::
	gclass.input_event_with_modifiers_is_input_event_mouse_button
input_event_with_modifiers_try_as_input_event_mouse_button ::
	gclass.input_event_with_modifiers_try_as_input_event_mouse_button
input_event_with_modifiers_is_input_event_mouse_motion ::
	gclass.input_event_with_modifiers_is_input_event_mouse_motion
input_event_with_modifiers_try_as_input_event_mouse_motion ::
	gclass.input_event_with_modifiers_try_as_input_event_mouse_motion
input_event_mouse_is_input_event_mouse_button ::
	gclass.input_event_mouse_is_input_event_mouse_button
input_event_mouse_try_as_input_event_mouse_button ::
	gclass.input_event_mouse_try_as_input_event_mouse_button
input_event_mouse_is_input_event_mouse_motion ::
	gclass.input_event_mouse_is_input_event_mouse_motion
input_event_mouse_try_as_input_event_mouse_motion ::
	gclass.input_event_mouse_try_as_input_event_mouse_motion
node_is_canvas_item :: gclass.node_is_canvas_item
node_try_as_canvas_item :: gclass.node_try_as_canvas_item
node_is_node2d :: gclass.node_is_node2d
node_try_as_node2d :: gclass.node_try_as_node2d
node_is_control :: gclass.node_is_control
node_try_as_control :: gclass.node_try_as_control
node_is_sprite2d :: gclass.node_is_sprite2d
node_try_as_sprite2d :: gclass.node_try_as_sprite2d
node_is_label :: gclass.node_is_label
node_try_as_label :: gclass.node_try_as_label
node_is_base_button :: gclass.node_is_base_button
node_try_as_base_button :: gclass.node_try_as_base_button
node_is_button :: gclass.node_is_button
node_try_as_button :: gclass.node_try_as_button
node_is_texture_rect :: gclass.node_is_texture_rect
node_try_as_texture_rect :: gclass.node_try_as_texture_rect
node_is_panel :: gclass.node_is_panel
node_try_as_panel :: gclass.node_try_as_panel
node_is_container :: gclass.node_is_container
node_try_as_container :: gclass.node_try_as_container
node_is_timer :: gclass.node_is_timer
node_try_as_timer :: gclass.node_try_as_timer
node_is_collision_object2d :: gclass.node_is_collision_object2d
node_try_as_collision_object2d :: gclass.node_try_as_collision_object2d
node_is_area2d :: gclass.node_is_area2d
node_try_as_area2d :: gclass.node_try_as_area2d
canvas_item_is_node2d :: gclass.canvas_item_is_node2d
canvas_item_try_as_node2d :: gclass.canvas_item_try_as_node2d
canvas_item_is_control :: gclass.canvas_item_is_control
canvas_item_try_as_control :: gclass.canvas_item_try_as_control
canvas_item_is_sprite2d :: gclass.canvas_item_is_sprite2d
canvas_item_try_as_sprite2d :: gclass.canvas_item_try_as_sprite2d
canvas_item_is_label :: gclass.canvas_item_is_label
canvas_item_try_as_label :: gclass.canvas_item_try_as_label
canvas_item_is_base_button :: gclass.canvas_item_is_base_button
canvas_item_try_as_base_button :: gclass.canvas_item_try_as_base_button
canvas_item_is_button :: gclass.canvas_item_is_button
canvas_item_try_as_button :: gclass.canvas_item_try_as_button
canvas_item_is_texture_rect :: gclass.canvas_item_is_texture_rect
canvas_item_try_as_texture_rect :: gclass.canvas_item_try_as_texture_rect
canvas_item_is_panel :: gclass.canvas_item_is_panel
canvas_item_try_as_panel :: gclass.canvas_item_try_as_panel
canvas_item_is_container :: gclass.canvas_item_is_container
canvas_item_try_as_container :: gclass.canvas_item_try_as_container
canvas_item_is_collision_object2d :: gclass.canvas_item_is_collision_object2d
canvas_item_try_as_collision_object2d :: gclass.canvas_item_try_as_collision_object2d
canvas_item_is_area2d :: gclass.canvas_item_is_area2d
canvas_item_try_as_area2d :: gclass.canvas_item_try_as_area2d
node2d_is_sprite2d :: gclass.node2d_is_sprite2d
node2d_try_as_sprite2d :: gclass.node2d_try_as_sprite2d
node2d_is_collision_object2d :: gclass.node2d_is_collision_object2d
node2d_try_as_collision_object2d :: gclass.node2d_try_as_collision_object2d
node2d_is_area2d :: gclass.node2d_is_area2d
node2d_try_as_area2d :: gclass.node2d_try_as_area2d
collision_object2d_is_area2d :: gclass.collision_object2d_is_area2d
collision_object2d_try_as_area2d :: gclass.collision_object2d_try_as_area2d
collision_object2d_is_physics_body2d :: gclass.collision_object2d_is_physics_body2d
collision_object2d_try_as_physics_body2d :: gclass.collision_object2d_try_as_physics_body2d
collision_object2d_is_character_body2d :: gclass.collision_object2d_is_character_body2d
collision_object2d_try_as_character_body2d :: gclass.collision_object2d_try_as_character_body2d
collision_object2d_is_rigid_body2d :: gclass.collision_object2d_is_rigid_body2d
collision_object2d_try_as_rigid_body2d :: gclass.collision_object2d_try_as_rigid_body2d
collision_object2d_is_static_body2d :: gclass.collision_object2d_is_static_body2d
collision_object2d_try_as_static_body2d :: gclass.collision_object2d_try_as_static_body2d
physics_body2d_is_character_body2d :: gclass.physics_body2d_is_character_body2d
physics_body2d_try_as_character_body2d :: gclass.physics_body2d_try_as_character_body2d
physics_body2d_is_rigid_body2d :: gclass.physics_body2d_is_rigid_body2d
physics_body2d_try_as_rigid_body2d :: gclass.physics_body2d_try_as_rigid_body2d
physics_body2d_is_static_body2d :: gclass.physics_body2d_is_static_body2d
physics_body2d_try_as_static_body2d :: gclass.physics_body2d_try_as_static_body2d
node_is_collision_shape2d :: gclass.node_is_collision_shape2d
node_try_as_collision_shape2d :: gclass.node_try_as_collision_shape2d
node_is_viewport :: gclass.node_is_viewport
node_try_as_viewport :: gclass.node_try_as_viewport
canvas_item_is_collision_shape2d :: gclass.canvas_item_is_collision_shape2d
canvas_item_try_as_collision_shape2d :: gclass.canvas_item_try_as_collision_shape2d
node2d_is_collision_shape2d :: gclass.node2d_is_collision_shape2d
node2d_try_as_collision_shape2d :: gclass.node2d_try_as_collision_shape2d
control_is_label :: gclass.control_is_label
control_try_as_label :: gclass.control_try_as_label
control_is_base_button :: gclass.control_is_base_button
control_try_as_base_button :: gclass.control_try_as_base_button
control_is_button :: gclass.control_is_button
control_try_as_button :: gclass.control_try_as_button
control_is_texture_rect :: gclass.control_is_texture_rect
control_try_as_texture_rect :: gclass.control_try_as_texture_rect
control_is_panel :: gclass.control_is_panel
control_try_as_panel :: gclass.control_try_as_panel
control_is_container :: gclass.control_is_container
control_try_as_container :: gclass.control_try_as_container
base_button_is_button :: gclass.base_button_is_button
base_button_try_as_button :: gclass.base_button_try_as_button
timer_as_node :: gclass.timer_as_node
timer_as_object :: gclass.timer_as_object
timer_set_wait_time :: gclass.timer_set_wait_time
timer_get_wait_time :: gclass.timer_get_wait_time
timer_set_one_shot :: gclass.timer_set_one_shot
timer_is_one_shot :: gclass.timer_is_one_shot
timer_set_autostart :: gclass.timer_set_autostart
timer_has_autostart :: gclass.timer_has_autostart
timer_start :: gclass.timer_start
timer_start_default :: gclass.timer_start_default
timer_stop :: gclass.timer_stop
timer_set_paused :: gclass.timer_set_paused
timer_is_paused :: gclass.timer_is_paused
timer_set_ignore_time_scale :: gclass.timer_set_ignore_time_scale
timer_is_ignoring_time_scale :: gclass.timer_is_ignoring_time_scale
timer_is_stopped :: gclass.timer_is_stopped
timer_get_time_left :: gclass.timer_get_time_left
collision_object2d_as_node2d :: gclass.collision_object2d_as_node2d
collision_object2d_as_canvas_item :: gclass.collision_object2d_as_canvas_item
collision_object2d_as_node :: gclass.collision_object2d_as_node
collision_object2d_as_object :: gclass.collision_object2d_as_object
collision_object2d_get_rid :: gclass.collision_object2d_get_rid
collision_object2d_set_collision_layer :: gclass.collision_object2d_set_collision_layer
collision_object2d_get_collision_layer :: gclass.collision_object2d_get_collision_layer
collision_object2d_set_collision_mask :: gclass.collision_object2d_set_collision_mask
collision_object2d_get_collision_mask :: gclass.collision_object2d_get_collision_mask
collision_object2d_set_collision_layer_value :: gclass.collision_object2d_set_collision_layer_value
collision_object2d_get_collision_layer_value :: gclass.collision_object2d_get_collision_layer_value
collision_object2d_set_collision_mask_value :: gclass.collision_object2d_set_collision_mask_value
collision_object2d_get_collision_mask_value :: gclass.collision_object2d_get_collision_mask_value
collision_object2d_set_collision_priority :: gclass.collision_object2d_set_collision_priority
collision_object2d_get_collision_priority :: gclass.collision_object2d_get_collision_priority
collision_object2d_set_disable_mode :: gclass.collision_object2d_set_disable_mode
collision_object2d_get_disable_mode :: gclass.collision_object2d_get_disable_mode
collision_object2d_set_pickable :: gclass.collision_object2d_set_pickable
collision_object2d_is_pickable :: gclass.collision_object2d_is_pickable
area2d_as_collision_object2d :: gclass.area2d_as_collision_object2d
area2d_as_node2d :: gclass.area2d_as_node2d
area2d_as_canvas_item :: gclass.area2d_as_canvas_item
area2d_as_node :: gclass.area2d_as_node
area2d_as_object :: gclass.area2d_as_object
area2d_set_gravity_space_override_mode :: gclass.area2d_set_gravity_space_override_mode
area2d_get_gravity_space_override_mode :: gclass.area2d_get_gravity_space_override_mode
area2d_set_gravity_is_point :: gclass.area2d_set_gravity_is_point
area2d_is_gravity_a_point :: gclass.area2d_is_gravity_a_point
area2d_set_gravity_point_unit_distance :: gclass.area2d_set_gravity_point_unit_distance
area2d_get_gravity_point_unit_distance :: gclass.area2d_get_gravity_point_unit_distance
area2d_set_gravity_point_center :: gclass.area2d_set_gravity_point_center
area2d_get_gravity_point_center :: gclass.area2d_get_gravity_point_center
area2d_set_gravity_direction :: gclass.area2d_set_gravity_direction
area2d_get_gravity_direction :: gclass.area2d_get_gravity_direction
area2d_set_gravity :: gclass.area2d_set_gravity
area2d_get_gravity :: gclass.area2d_get_gravity
area2d_set_linear_damp_space_override_mode :: gclass.area2d_set_linear_damp_space_override_mode
area2d_get_linear_damp_space_override_mode :: gclass.area2d_get_linear_damp_space_override_mode
area2d_set_angular_damp_space_override_mode :: gclass.area2d_set_angular_damp_space_override_mode
area2d_get_angular_damp_space_override_mode :: gclass.area2d_get_angular_damp_space_override_mode
area2d_set_linear_damp :: gclass.area2d_set_linear_damp
area2d_get_linear_damp :: gclass.area2d_get_linear_damp
area2d_set_angular_damp :: gclass.area2d_set_angular_damp
area2d_get_angular_damp :: gclass.area2d_get_angular_damp
area2d_set_priority :: gclass.area2d_set_priority
area2d_get_priority :: gclass.area2d_get_priority
area2d_set_monitoring :: gclass.area2d_set_monitoring
area2d_is_monitoring :: gclass.area2d_is_monitoring
area2d_set_monitorable :: gclass.area2d_set_monitorable
area2d_is_monitorable :: gclass.area2d_is_monitorable
area2d_has_overlapping_bodies :: gclass.area2d_has_overlapping_bodies
area2d_has_overlapping_areas :: gclass.area2d_has_overlapping_areas
area2d_get_overlapping_bodies :: gclass.area2d_get_overlapping_bodies
area2d_get_overlapping_areas :: gclass.area2d_get_overlapping_areas
area2d_set_audio_bus_name :: gclass.area2d_set_audio_bus_name
area2d_get_audio_bus_name :: gclass.area2d_get_audio_bus_name
area2d_set_audio_bus_override :: gclass.area2d_set_audio_bus_override
area2d_is_overriding_audio_bus :: gclass.area2d_is_overriding_audio_bus
physics_body2d_as_collision_object2d :: gclass.physics_body2d_as_collision_object2d
physics_body2d_as_node2d :: gclass.physics_body2d_as_node2d
physics_body2d_as_canvas_item :: gclass.physics_body2d_as_canvas_item
physics_body2d_as_node :: gclass.physics_body2d_as_node
physics_body2d_as_object :: gclass.physics_body2d_as_object
character_body2d_as_physics_body2d :: gclass.character_body2d_as_physics_body2d
character_body2d_as_collision_object2d :: gclass.character_body2d_as_collision_object2d
character_body2d_as_node2d :: gclass.character_body2d_as_node2d
character_body2d_as_canvas_item :: gclass.character_body2d_as_canvas_item
character_body2d_as_node :: gclass.character_body2d_as_node
character_body2d_as_object :: gclass.character_body2d_as_object
rigid_body2d_as_physics_body2d :: gclass.rigid_body2d_as_physics_body2d
rigid_body2d_as_collision_object2d :: gclass.rigid_body2d_as_collision_object2d
rigid_body2d_as_node2d :: gclass.rigid_body2d_as_node2d
rigid_body2d_as_canvas_item :: gclass.rigid_body2d_as_canvas_item
rigid_body2d_as_node :: gclass.rigid_body2d_as_node
rigid_body2d_as_object :: gclass.rigid_body2d_as_object
static_body2d_as_physics_body2d :: gclass.static_body2d_as_physics_body2d
static_body2d_as_collision_object2d :: gclass.static_body2d_as_collision_object2d
static_body2d_as_node2d :: gclass.static_body2d_as_node2d
static_body2d_as_canvas_item :: gclass.static_body2d_as_canvas_item
static_body2d_as_node :: gclass.static_body2d_as_node
static_body2d_as_object :: gclass.static_body2d_as_object
collision_shape2d_as_node2d :: gclass.collision_shape2d_as_node2d
collision_shape2d_as_canvas_item :: gclass.collision_shape2d_as_canvas_item
collision_shape2d_as_node :: gclass.collision_shape2d_as_node
collision_shape2d_as_object :: gclass.collision_shape2d_as_object
physics_body2d_get_gravity :: gclass.physics_body2d_get_gravity
physics_body2d_get_collision_exceptions :: gclass.physics_body2d_get_collision_exceptions
physics_body2d_add_collision_exception_with :: gclass.physics_body2d_add_collision_exception_with
physics_body2d_remove_collision_exception_with ::
	gclass.physics_body2d_remove_collision_exception_with
character_body2d_set_velocity :: gclass.character_body2d_set_velocity
character_body2d_get_velocity :: gclass.character_body2d_get_velocity
character_body2d_move_and_slide :: gclass.character_body2d_move_and_slide
character_body2d_apply_floor_snap :: gclass.character_body2d_apply_floor_snap
character_body2d_set_safe_margin :: gclass.character_body2d_set_safe_margin
character_body2d_get_safe_margin :: gclass.character_body2d_get_safe_margin
character_body2d_set_up_direction :: gclass.character_body2d_set_up_direction
character_body2d_get_up_direction :: gclass.character_body2d_get_up_direction
character_body2d_is_on_floor :: gclass.character_body2d_is_on_floor
character_body2d_is_on_wall :: gclass.character_body2d_is_on_wall
character_body2d_get_real_velocity :: gclass.character_body2d_get_real_velocity
rigid_body2d_set_mass :: gclass.rigid_body2d_set_mass
rigid_body2d_get_mass :: gclass.rigid_body2d_get_mass
rigid_body2d_set_gravity_scale :: gclass.rigid_body2d_set_gravity_scale
rigid_body2d_get_gravity_scale :: gclass.rigid_body2d_get_gravity_scale
rigid_body2d_set_linear_velocity :: gclass.rigid_body2d_set_linear_velocity
rigid_body2d_get_linear_velocity :: gclass.rigid_body2d_get_linear_velocity
rigid_body2d_set_contact_monitor :: gclass.rigid_body2d_set_contact_monitor
rigid_body2d_is_contact_monitor_enabled :: gclass.rigid_body2d_is_contact_monitor_enabled
rigid_body2d_get_contact_count :: gclass.rigid_body2d_get_contact_count
rigid_body2d_apply_central_impulse :: gclass.rigid_body2d_apply_central_impulse
rigid_body2d_apply_central_force :: gclass.rigid_body2d_apply_central_force
rigid_body2d_get_colliding_bodies :: gclass.rigid_body2d_get_colliding_bodies
static_body2d_set_constant_linear_velocity :: gclass.static_body2d_set_constant_linear_velocity
static_body2d_get_constant_linear_velocity :: gclass.static_body2d_get_constant_linear_velocity
static_body2d_set_constant_angular_velocity :: gclass.static_body2d_set_constant_angular_velocity
static_body2d_get_constant_angular_velocity :: gclass.static_body2d_get_constant_angular_velocity
collision_shape2d_set_disabled :: gclass.collision_shape2d_set_disabled
collision_shape2d_is_disabled :: gclass.collision_shape2d_is_disabled
collision_shape2d_set_one_way_collision_direction ::
	gclass.collision_shape2d_set_one_way_collision_direction
collision_shape2d_get_one_way_collision_direction ::
	gclass.collision_shape2d_get_one_way_collision_direction
collision_shape2d_set_debug_color :: gclass.collision_shape2d_set_debug_color
collision_shape2d_get_debug_color :: gclass.collision_shape2d_get_debug_color
packed_scene_as_resource :: gclass.packed_scene_as_resource
packed_scene_as_ref_counted :: gclass.packed_scene_as_ref_counted
packed_scene_as_object :: gclass.packed_scene_as_object
packed_scene_pack :: gclass.packed_scene_pack
packed_scene_can_instantiate :: gclass.packed_scene_can_instantiate
resource_loader_as_object :: gclass.resource_loader_as_object
resource_loader_singleton_checked :: gclass.resource_loader_singleton_checked
resource_loader_exists :: gclass.resource_loader_exists
resource_loader_exists_default :: gclass.resource_loader_exists_default
input_as_object :: gclass.input_as_object
input_event_as_resource :: gclass.input_event_as_resource
input_event_as_ref_counted :: gclass.input_event_as_ref_counted
input_event_as_object :: gclass.input_event_as_object
input_event_from_window_as_input_event :: gclass.input_event_from_window_as_input_event
input_event_from_window_as_resource :: gclass.input_event_from_window_as_resource
input_event_from_window_as_ref_counted :: gclass.input_event_from_window_as_ref_counted
input_event_from_window_as_object :: gclass.input_event_from_window_as_object
input_event_with_modifiers_as_input_event_from_window ::
	gclass.input_event_with_modifiers_as_input_event_from_window
input_event_with_modifiers_as_input_event :: gclass.input_event_with_modifiers_as_input_event
input_event_with_modifiers_as_resource :: gclass.input_event_with_modifiers_as_resource
input_event_with_modifiers_as_ref_counted :: gclass.input_event_with_modifiers_as_ref_counted
input_event_with_modifiers_as_object :: gclass.input_event_with_modifiers_as_object
input_event_key_as_input_event_with_modifiers ::
	gclass.input_event_key_as_input_event_with_modifiers
input_event_key_as_input_event_from_window :: gclass.input_event_key_as_input_event_from_window
input_event_key_as_input_event :: gclass.input_event_key_as_input_event
input_event_key_as_resource :: gclass.input_event_key_as_resource
input_event_key_as_ref_counted :: gclass.input_event_key_as_ref_counted
input_event_key_as_object :: gclass.input_event_key_as_object
input_event_mouse_as_input_event_with_modifiers ::
	gclass.input_event_mouse_as_input_event_with_modifiers
input_event_mouse_as_input_event_from_window :: gclass.input_event_mouse_as_input_event_from_window
input_event_mouse_as_input_event :: gclass.input_event_mouse_as_input_event
input_event_mouse_as_resource :: gclass.input_event_mouse_as_resource
input_event_mouse_as_ref_counted :: gclass.input_event_mouse_as_ref_counted
input_event_mouse_as_object :: gclass.input_event_mouse_as_object
input_event_mouse_button_as_input_event_mouse ::
	gclass.input_event_mouse_button_as_input_event_mouse
input_event_mouse_button_as_input_event_with_modifiers ::
	gclass.input_event_mouse_button_as_input_event_with_modifiers
input_event_mouse_button_as_input_event_from_window ::
	gclass.input_event_mouse_button_as_input_event_from_window
input_event_mouse_button_as_input_event :: gclass.input_event_mouse_button_as_input_event
input_event_mouse_button_as_resource :: gclass.input_event_mouse_button_as_resource
input_event_mouse_button_as_ref_counted :: gclass.input_event_mouse_button_as_ref_counted
input_event_mouse_button_as_object :: gclass.input_event_mouse_button_as_object
input_event_mouse_motion_as_input_event_mouse ::
	gclass.input_event_mouse_motion_as_input_event_mouse
input_event_mouse_motion_as_input_event_with_modifiers ::
	gclass.input_event_mouse_motion_as_input_event_with_modifiers
input_event_mouse_motion_as_input_event_from_window ::
	gclass.input_event_mouse_motion_as_input_event_from_window
input_event_mouse_motion_as_input_event :: gclass.input_event_mouse_motion_as_input_event
input_event_mouse_motion_as_resource :: gclass.input_event_mouse_motion_as_resource
input_event_mouse_motion_as_ref_counted :: gclass.input_event_mouse_motion_as_ref_counted
input_event_mouse_motion_as_object :: gclass.input_event_mouse_motion_as_object
viewport_as_node :: gclass.viewport_as_node
viewport_as_object :: gclass.viewport_as_object
input_singleton_checked :: gclass.input_singleton_checked
input_is_anything_pressed :: gclass.input_is_anything_pressed
input_is_action_pressed :: gclass.input_is_action_pressed
input_is_action_pressed_default :: gclass.input_is_action_pressed_default
input_is_action_just_pressed :: gclass.input_is_action_just_pressed
input_is_action_just_pressed_default :: gclass.input_is_action_just_pressed_default
input_is_action_just_released :: gclass.input_is_action_just_released
input_is_action_just_released_default :: gclass.input_is_action_just_released_default
input_get_action_strength :: gclass.input_get_action_strength
input_get_action_strength_default :: gclass.input_get_action_strength_default
input_get_action_raw_strength :: gclass.input_get_action_raw_strength
input_get_action_raw_strength_default :: gclass.input_get_action_raw_strength_default
input_get_axis :: gclass.input_get_axis
input_get_vector :: gclass.input_get_vector
input_get_vector_default :: gclass.input_get_vector_default
input_get_last_mouse_velocity :: gclass.input_get_last_mouse_velocity
input_get_last_mouse_screen_velocity :: gclass.input_get_last_mouse_screen_velocity
input_set_use_accumulated_input :: gclass.input_set_use_accumulated_input
input_is_using_accumulated_input :: gclass.input_is_using_accumulated_input
input_flush_buffered_events :: gclass.input_flush_buffered_events
input_event_get_device :: gclass.input_event_get_device
input_event_is_action :: gclass.input_event_is_action
input_event_is_action_default :: gclass.input_event_is_action_default
input_event_is_action_pressed :: gclass.input_event_is_action_pressed
input_event_is_action_pressed_default :: gclass.input_event_is_action_pressed_default
input_event_is_action_released :: gclass.input_event_is_action_released
input_event_is_action_released_default :: gclass.input_event_is_action_released_default
input_event_get_action_strength :: gclass.input_event_get_action_strength
input_event_get_action_strength_default :: gclass.input_event_get_action_strength_default
input_event_is_canceled :: gclass.input_event_is_canceled
input_event_is_pressed :: gclass.input_event_is_pressed
input_event_is_released :: gclass.input_event_is_released
input_event_is_echo :: gclass.input_event_is_echo
input_event_as_text :: gclass.input_event_as_text
input_event_is_match :: gclass.input_event_is_match
input_event_is_match_default :: gclass.input_event_is_match_default
input_event_is_action_type :: gclass.input_event_is_action_type
input_event_from_window_get_window_id :: gclass.input_event_from_window_get_window_id
input_event_with_modifiers_is_command_or_control_autoremap ::
	gclass.input_event_with_modifiers_is_command_or_control_autoremap
input_event_with_modifiers_is_command_or_control_pressed ::
	gclass.input_event_with_modifiers_is_command_or_control_pressed
input_event_with_modifiers_is_alt_pressed :: gclass.input_event_with_modifiers_is_alt_pressed
input_event_with_modifiers_is_shift_pressed :: gclass.input_event_with_modifiers_is_shift_pressed
input_event_with_modifiers_is_ctrl_pressed :: gclass.input_event_with_modifiers_is_ctrl_pressed
input_event_with_modifiers_is_meta_pressed :: gclass.input_event_with_modifiers_is_meta_pressed
input_event_key_get_keycode :: gclass.input_event_key_get_keycode
input_event_key_get_physical_keycode :: gclass.input_event_key_get_physical_keycode
input_event_key_get_key_label :: gclass.input_event_key_get_key_label
input_event_key_get_unicode :: gclass.input_event_key_get_unicode
input_event_key_get_location :: gclass.input_event_key_get_location
input_event_key_get_keycode_with_modifiers :: gclass.input_event_key_get_keycode_with_modifiers
input_event_key_get_physical_keycode_with_modifiers ::
	gclass.input_event_key_get_physical_keycode_with_modifiers
input_event_key_get_key_label_with_modifiers :: gclass.input_event_key_get_key_label_with_modifiers
input_event_key_as_text_keycode :: gclass.input_event_key_as_text_keycode
input_event_key_as_text_physical_keycode :: gclass.input_event_key_as_text_physical_keycode
input_event_key_as_text_key_label :: gclass.input_event_key_as_text_key_label
input_event_key_as_text_location :: gclass.input_event_key_as_text_location
input_event_mouse_get_position :: gclass.input_event_mouse_get_position
input_event_mouse_get_global_position :: gclass.input_event_mouse_get_global_position
input_event_mouse_button_get_factor :: gclass.input_event_mouse_button_get_factor
input_event_mouse_button_get_button_index :: gclass.input_event_mouse_button_get_button_index
input_event_mouse_button_is_double_click :: gclass.input_event_mouse_button_is_double_click
input_event_mouse_motion_get_tilt :: gclass.input_event_mouse_motion_get_tilt
input_event_mouse_motion_get_pressure :: gclass.input_event_mouse_motion_get_pressure
input_event_mouse_motion_get_pen_inverted :: gclass.input_event_mouse_motion_get_pen_inverted
input_event_mouse_motion_get_relative :: gclass.input_event_mouse_motion_get_relative
input_event_mouse_motion_get_screen_relative :: gclass.input_event_mouse_motion_get_screen_relative
input_event_mouse_motion_get_velocity :: gclass.input_event_mouse_motion_get_velocity
input_event_mouse_motion_get_screen_velocity :: gclass.input_event_mouse_motion_get_screen_velocity
viewport_get_canvas_transform :: gclass.viewport_get_canvas_transform
viewport_get_global_canvas_transform :: gclass.viewport_get_global_canvas_transform
viewport_get_stretch_transform :: gclass.viewport_get_stretch_transform
viewport_get_final_transform :: gclass.viewport_get_final_transform
viewport_get_screen_transform :: gclass.viewport_get_screen_transform
viewport_get_visible_rect :: gclass.viewport_get_visible_rect
viewport_has_transparent_background :: gclass.viewport_has_transparent_background
viewport_is_using_hdr_2d :: gclass.viewport_is_using_hdr_2d
viewport_is_using_taa :: gclass.viewport_is_using_taa
viewport_is_using_debanding :: gclass.viewport_is_using_debanding
viewport_is_using_occlusion_culling :: gclass.viewport_is_using_occlusion_culling
viewport_is_using_oversampling :: gclass.viewport_is_using_oversampling
viewport_get_oversampling_override :: gclass.viewport_get_oversampling_override
viewport_get_oversampling :: gclass.viewport_get_oversampling
viewport_get_physics_object_picking :: gclass.viewport_get_physics_object_picking
viewport_get_physics_object_picking_sort :: gclass.viewport_get_physics_object_picking_sort
viewport_get_physics_object_picking_first_only ::
	gclass.viewport_get_physics_object_picking_first_only
viewport_get_viewport_rid :: gclass.viewport_get_viewport_rid
viewport_get_mouse_position :: gclass.viewport_get_mouse_position
viewport_gui_is_dragging :: gclass.viewport_gui_is_dragging
viewport_gui_is_drag_successful :: gclass.viewport_gui_is_drag_successful
viewport_gui_get_focus_owner :: gclass.viewport_gui_get_focus_owner
viewport_gui_get_hovered_control :: gclass.viewport_gui_get_hovered_control
viewport_is_input_disabled :: gclass.viewport_is_input_disabled
viewport_get_positional_shadow_atlas_size :: gclass.viewport_get_positional_shadow_atlas_size
viewport_get_positional_shadow_atlas_16_bits :: gclass.viewport_get_positional_shadow_atlas_16_bits
viewport_is_snap_controls_to_pixels_enabled :: gclass.viewport_is_snap_controls_to_pixels_enabled
viewport_is_snap_2d_transforms_to_pixel_enabled ::
	gclass.viewport_is_snap_2d_transforms_to_pixel_enabled
viewport_is_snap_2d_vertices_to_pixel_enabled ::
	gclass.viewport_is_snap_2d_vertices_to_pixel_enabled
viewport_is_input_handled :: gclass.viewport_is_input_handled
viewport_is_handling_input_locally :: gclass.viewport_is_handling_input_locally
viewport_is_embedding_subwindows :: gclass.viewport_is_embedding_subwindows
viewport_get_drag_threshold :: gclass.viewport_get_drag_threshold
viewport_get_canvas_cull_mask :: gclass.viewport_get_canvas_cull_mask
viewport_get_canvas_cull_mask_bit :: gclass.viewport_get_canvas_cull_mask_bit
viewport_get_mesh_lod_threshold :: gclass.viewport_get_mesh_lod_threshold
viewport_is_audio_listener_2d :: gclass.viewport_is_audio_listener_2d
viewport_is_using_own_world_3d :: gclass.viewport_is_using_own_world_3d
viewport_is_3d_disabled :: gclass.viewport_is_3d_disabled
viewport_is_using_xr :: gclass.viewport_is_using_xr
viewport_get_scaling_3d_scale :: gclass.viewport_get_scaling_3d_scale
viewport_get_fsr_sharpness :: gclass.viewport_get_fsr_sharpness
viewport_get_texture_mipmap_bias :: gclass.viewport_get_texture_mipmap_bias
scene_tree_as_object :: gclass.scene_tree_as_object
scene_tree_has_group :: gclass.scene_tree_has_group
scene_tree_is_accessibility_enabled :: gclass.scene_tree_is_accessibility_enabled
scene_tree_is_accessibility_supported :: gclass.scene_tree_is_accessibility_supported
scene_tree_is_debugging_collisions_hint :: gclass.scene_tree_is_debugging_collisions_hint
scene_tree_is_debugging_paths_hint :: gclass.scene_tree_is_debugging_paths_hint
scene_tree_is_debugging_navigation_hint :: gclass.scene_tree_is_debugging_navigation_hint
scene_tree_get_edited_scene_root :: gclass.scene_tree_get_edited_scene_root
scene_tree_is_paused :: gclass.scene_tree_is_paused
scene_tree_get_node_count :: gclass.scene_tree_get_node_count
scene_tree_get_frame :: gclass.scene_tree_get_frame
scene_tree_is_physics_interpolation_enabled :: gclass.scene_tree_is_physics_interpolation_enabled
scene_tree_get_nodes_in_group :: gclass.scene_tree_get_nodes_in_group
scene_tree_get_first_node_in_group :: gclass.scene_tree_get_first_node_in_group
scene_tree_get_node_count_in_group :: gclass.scene_tree_get_node_count_in_group
scene_tree_get_current_scene :: gclass.scene_tree_get_current_scene
scene_tree_is_multiplayer_poll_enabled :: gclass.scene_tree_is_multiplayer_poll_enabled

// --- Borrowed object handle helpers ---
object_ptr_is_nil :: proc "contextless" (self: ObjectPtr) -> bool {
	return self == nil
}

object_is_nil :: proc "contextless" (self: Object) -> bool {
	return ObjectPtr(self) == nil
}

ref_counted_is_nil :: proc "contextless" (self: RefCounted) -> bool {
	return ObjectPtr(self) == nil
}

resource_is_nil :: proc "contextless" (self: Resource) -> bool {
	return ObjectPtr(self) == nil
}

texture2d_is_nil :: proc "contextless" (self: Texture2D) -> bool {
	return ObjectPtr(self) == nil
}

image_texture_is_nil :: proc "contextless" (self: ImageTexture) -> bool {
	return ObjectPtr(self) == nil
}

node_is_nil :: proc "contextless" (self: Node) -> bool {
	return ObjectPtr(self) == nil
}

canvas_item_is_nil :: proc "contextless" (self: CanvasItem) -> bool {
	return ObjectPtr(self) == nil
}

node2d_is_nil :: proc "contextless" (self: Node2D) -> bool {
	return ObjectPtr(self) == nil
}

control_is_nil :: proc "contextless" (self: Control) -> bool {
	return ObjectPtr(self) == nil
}

base_button_is_nil :: proc "contextless" (self: BaseButton) -> bool {
	return ObjectPtr(self) == nil
}

button_is_nil :: proc "contextless" (self: Button) -> bool {
	return ObjectPtr(self) == nil
}

texture_rect_is_nil :: proc "contextless" (self: TextureRect) -> bool {
	return ObjectPtr(self) == nil
}

panel_is_nil :: proc "contextless" (self: Panel) -> bool {
	return ObjectPtr(self) == nil
}

container_is_nil :: proc "contextless" (self: Container) -> bool {
	return ObjectPtr(self) == nil
}

sprite2d_is_nil :: proc "contextless" (self: Sprite2D) -> bool {
	return ObjectPtr(self) == nil
}

label_is_nil :: proc "contextless" (self: Label) -> bool {
	return ObjectPtr(self) == nil
}

timer_is_nil :: proc "contextless" (self: Timer) -> bool {
	return ObjectPtr(self) == nil
}

collision_object2d_is_nil :: proc "contextless" (self: CollisionObject2D) -> bool {
	return ObjectPtr(self) == nil
}

area2d_is_nil :: proc "contextless" (self: Area2D) -> bool {
	return ObjectPtr(self) == nil
}

physics_body2d_is_nil :: proc "contextless" (self: PhysicsBody2D) -> bool {
	return ObjectPtr(self) == nil
}

character_body2d_is_nil :: proc "contextless" (self: CharacterBody2D) -> bool {
	return ObjectPtr(self) == nil
}

rigid_body2d_is_nil :: proc "contextless" (self: RigidBody2D) -> bool {
	return ObjectPtr(self) == nil
}

static_body2d_is_nil :: proc "contextless" (self: StaticBody2D) -> bool {
	return ObjectPtr(self) == nil
}

collision_shape2d_is_nil :: proc "contextless" (self: CollisionShape2D) -> bool {
	return ObjectPtr(self) == nil
}

packed_scene_is_nil :: proc "contextless" (self: PackedScene) -> bool {
	return ObjectPtr(self) == nil
}

resource_loader_is_nil :: proc "contextless" (self: ResourceLoader) -> bool {
	return ObjectPtr(self) == nil
}

input_is_nil :: proc "contextless" (self: Input) -> bool {
	return ObjectPtr(self) == nil
}

input_event_is_nil :: proc "contextless" (self: InputEvent) -> bool {
	return ObjectPtr(self) == nil
}

input_event_from_window_is_nil :: proc "contextless" (self: InputEventFromWindow) -> bool {
	return ObjectPtr(self) == nil
}

input_event_with_modifiers_is_nil :: proc "contextless" (self: InputEventWithModifiers) -> bool {
	return ObjectPtr(self) == nil
}

input_event_key_is_nil :: proc "contextless" (self: InputEventKey) -> bool {
	return ObjectPtr(self) == nil
}

input_event_mouse_is_nil :: proc "contextless" (self: InputEventMouse) -> bool {
	return ObjectPtr(self) == nil
}

input_event_mouse_button_is_nil :: proc "contextless" (self: InputEventMouseButton) -> bool {
	return ObjectPtr(self) == nil
}

input_event_mouse_motion_is_nil :: proc "contextless" (self: InputEventMouseMotion) -> bool {
	return ObjectPtr(self) == nil
}

viewport_is_nil :: proc "contextless" (self: Viewport) -> bool {
	return ObjectPtr(self) == nil
}

scene_tree_is_nil :: proc "contextless" (self: SceneTree) -> bool {
	return ObjectPtr(self) == nil
}

node_get_node_checked :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Node,
	ok: bool,
) {
	if node_is_nil(self) || path == nil do return Node(nil), false

	value = node_get_node_or_null(self, path)
	if node_is_nil(value) do return Node(nil), false
	return value, true
}

node_get_node_as_canvas_item :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: CanvasItem,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return CanvasItem(nil), false
	return node_try_as_canvas_item(node)
}

node_get_node_as_node2d :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Node2D,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Node2D(nil), false
	return node_try_as_node2d(node)
}

node_get_node_as_control :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Control,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Control(nil), false
	return node_try_as_control(node)
}

node_get_node_as_base_button :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: BaseButton,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return BaseButton(nil), false
	return node_try_as_base_button(node)
}

node_get_node_as_button :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Button,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Button(nil), false
	return node_try_as_button(node)
}

node_get_node_as_texture_rect :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: TextureRect,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return TextureRect(nil), false
	return node_try_as_texture_rect(node)
}

node_get_node_as_panel :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Panel,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Panel(nil), false
	return node_try_as_panel(node)
}

node_get_node_as_container :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Container,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Container(nil), false
	return node_try_as_container(node)
}

node_get_node_as_sprite2d :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Sprite2D,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Sprite2D(nil), false
	return node_try_as_sprite2d(node)
}

node_get_node_as_label :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Label,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Label(nil), false
	return node_try_as_label(node)
}

label_set_text_utf8_checked :: proc "contextless" (self: Label, text: string) -> bool {
	if label_is_nil(self) do return false
	value := string_from_utf8(text)
	defer string_free(&value)
	label_set_text(self, &value)
	return true
}

label_get_text_utf8_checked :: proc "contextless" (
	self: Label,
	buffer: []u8,
) -> (
	value: string,
	ok: bool,
	needed: int,
) {
	if label_is_nil(self) do return "", false, 0
	text := label_get_text(self)
	defer string_free(&text)
	return string_to_utf8(&text, buffer)
}

button_set_text_utf8_checked :: proc "contextless" (self: Button, text: string) -> bool {
	if button_is_nil(self) do return false
	value := string_from_utf8(text)
	defer string_free(&value)
	button_set_text(self, &value)
	return true
}

button_get_text_utf8_checked :: proc "contextless" (
	self: Button,
	buffer: []u8,
) -> (
	value: string,
	ok: bool,
	needed: int,
) {
	if button_is_nil(self) do return "", false, 0
	text := button_get_text(self)
	defer string_free(&text)
	return string_to_utf8(&text, buffer)
}

node_get_node_as_timer :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Timer,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Timer(nil), false
	return node_try_as_timer(node)
}

node_get_node_as_collision_object2d :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: CollisionObject2D,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return CollisionObject2D(nil), false
	return node_try_as_collision_object2d(node)
}

node_get_node_as_area2d :: proc "contextless" (
	self: Node,
	path: ^NodePath,
) -> (
	value: Area2D,
	ok: bool,
) {
	node, node_ok := node_get_node_checked(self, path)
	if !node_ok do return Area2D(nil), false
	return node_try_as_area2d(node)
}

object_ptr_as_object :: proc "contextless" (self: ObjectPtr) -> Object {
	return Object(self)
}

ref_counted_object_ptr :: proc "contextless" (self: RefCounted) -> ObjectPtr {
	return ObjectPtr(self)
}

resource_object_ptr :: proc "contextless" (self: Resource) -> ObjectPtr {
	return ObjectPtr(self)
}

owned_resource_nil :: proc "contextless" () -> OwnedResource {
	return {}
}

owned_resource_is_nil :: proc "contextless" (self: OwnedResource) -> bool {
	return owned_ref_counted_is_nil(self.ref)
}

owned_resource_handle :: proc "contextless" (self: OwnedResource) -> Resource {
	return Resource(ObjectPtr(owned_ref_counted_handle(self.ref)))
}

// The returned Texture2D is a borrowed view of the owned resource. Keep the
// OwnedResource alive for as long as Godot may use the texture handle.
owned_resource_try_as_texture2d :: proc "contextless" (
	self: OwnedResource,
) -> (
	texture: Texture2D,
	ok: bool,
) {
	if owned_resource_is_nil(self) do return {}, false
	return resource_try_as_texture2d(owned_resource_handle(self))
}

// The returned ImageTexture is a borrowed view of the owned resource. Keep the
// OwnedResource alive for as long as Godot may use the image texture handle.
owned_resource_try_as_image_texture :: proc "contextless" (
	self: OwnedResource,
) -> (
	texture: ImageTexture,
	ok: bool,
) {
	if owned_resource_is_nil(self) do return {}, false
	return resource_try_as_image_texture(owned_resource_handle(self))
}

owned_resource_init_owned :: proc "contextless" (
	handle: Resource,
) -> (
	owned: OwnedResource,
	ok: bool,
) {
	if resource_is_nil(handle) do return {}, false
	ref, ref_ok := owned_ref_counted_init_owned(resource_as_ref_counted(handle))
	if !ref_ok do return {}, false
	return OwnedResource{ref = ref}, true
}

owned_resource_retain :: proc "contextless" (
	handle: Resource,
) -> (
	owned: OwnedResource,
	ok: bool,
) {
	if resource_is_nil(handle) do return {}, false
	ref, ref_ok := owned_ref_counted_retain(resource_as_ref_counted(handle))
	if !ref_ok do return {}, false
	return OwnedResource{ref = ref}, true
}

owned_resource_take :: proc "contextless" (src: ^OwnedResource) -> OwnedResource {
	if src == nil do return {}
	dst := src^
	src^ = {}
	return dst
}

owned_resource_release :: proc "contextless" (
	self: ^OwnedResource,
) -> (
	destroyed: bool,
	ok: bool,
) {
	if self == nil do return false, false
	return owned_ref_counted_release(&self.ref)
}

owned_resource_destroy :: proc "contextless" (self: ^OwnedResource) -> (ok: bool) {
	_, release_ok := owned_resource_release(self)
	return release_ok
}

resource_loader_load_class_name_data: StaticStringName
resource_loader_load_method_name_data: StaticStringName
resource_loader_load_method_bind: gcore.MethodBindPtr
resource_loader_load_initialized: bool

init_resource_loader_load :: proc "contextless" () {
	if resource_loader_load_initialized do return
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&resource_loader_load_class_name_data),
		cstring("ResourceLoader"),
	)
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&resource_loader_load_method_name_data),
		cstring("load"),
	)
	resource_loader_load_method_bind = gcore.require_classdb_method_bind(
		const_static_string_name_ptr(&resource_loader_load_class_name_data),
		const_static_string_name_ptr(&resource_loader_load_method_name_data),
		3358495409,
	)
	resource_loader_load_initialized = true
}

// resource_loader_load_owned_with_cache_mode_checked loads a path through a
// Variant call and stores the returned Resource in an OwnedResource. The caller
// owns the returned wrapper and must call owned_resource_destroy or
// owned_resource_release.
resource_loader_load_owned_with_cache_mode_checked :: proc "contextless" (
	self: ResourceLoader,
	path: ^String,
	cache_mode: ResourceLoaderCacheMode,
	take_returned_reference: bool,
) -> (
	owned: OwnedResource,
	err: CallError,
	ok: bool,
) {
	if resource_loader_is_nil(self) || path == nil do return {}, {}, false
	init_resource_loader_load()

	path_variant := variant_from_string(path)
	type_hint := string_from_utf8("")
	type_hint_variant := variant_from_string(&type_hint)
	cache_mode_variant := variant_from_int(i64(cache_mode))
	args := [3]ConstVariantPtr {
		const_variant_ptr(&path_variant),
		const_variant_ptr(&type_hint_variant),
		const_variant_ptr(&cache_mode_variant),
	}

	ret: Variant
	gcore.object_method_bind_call(
		resource_loader_load_method_bind,
		ObjectPtr(self),
		&args[0],
		3,
		uninitialized_variant_ptr(&ret),
		&err,
	)
	variant_free(&cache_mode_variant)
	variant_free(&type_hint_variant)
	string_free(&type_hint)
	variant_free(&path_variant)

	if !call_error_ok(&err) do return {}, err, false
	defer variant_free(&ret)

	object, object_ok := variant_try_object(&ret)
	if !object_ok || object == nil do return {}, err, false
	resource, resource_ok := object_ptr_try_as_resource(object)
	if !resource_ok do return {}, err, false
	if take_returned_reference {
		owned_resource, owned_ok := owned_resource_init_owned(resource)
		return owned_resource, err, owned_ok
	}
	retained, retained_ok := owned_resource_retain(resource)
	return retained, err, retained_ok
}

// resource_loader_load_owned_checked keeps the default Godot cache reuse policy.
// Use typed helpers when the borrow must be tied to a specific OwnedResource.
resource_loader_load_owned_checked :: proc "contextless" (
	self: ResourceLoader,
	path: ^String,
) -> (
	owned: OwnedResource,
	err: CallError,
	ok: bool,
) {
	return resource_loader_load_owned_with_cache_mode_checked(self, path, .cache_mode_reuse, false)
}

resource_loader_load_owned :: proc "contextless" (
	self: ResourceLoader,
	path: ^String,
) -> OwnedResource {
	owned, err, ok := resource_loader_load_owned_checked(self, path)
	require_call_ok(&err)
	if !ok do gcore._trap_nil_godot_function()
	return owned
}

// resource_loader_load_texture2d_owned_checked loads a resource and returns a
// borrowed Texture2D view tied to the returned OwnedResource. Destroy the owned
// wrapper after Godot no longer needs the texture handle.
resource_loader_load_texture2d_owned_checked :: proc "contextless" (
	self: ResourceLoader,
	path: ^String,
) -> (
	owned: OwnedResource,
	texture: Texture2D,
	err: CallError,
	ok: bool,
) {
	owned, err, ok = resource_loader_load_owned_with_cache_mode_checked(
		self,
		path,
		.cache_mode_ignore,
		true,
	)
	if !call_error_ok(&err) || !ok do return {}, {}, err, false

	texture_ok: bool
	texture, texture_ok = owned_resource_try_as_texture2d(owned)
	if !texture_ok {
		owned_resource_destroy(&owned)
		return {}, {}, err, false
	}
	return owned, texture, err, true
}

resource_loader_load_texture2d_owned :: proc "contextless" (
	self: ResourceLoader,
	path: ^String,
) -> (
	owned: OwnedResource,
	texture: Texture2D,
) {
	checked_err: CallError
	checked_ok: bool
	owned, texture, checked_err, checked_ok = resource_loader_load_texture2d_owned_checked(
		self,
		path,
	)
	require_call_ok(&checked_err)
	if !checked_ok do gcore._trap_nil_godot_function()
	return owned, texture
}

// resource_loader_load_image_texture_owned_checked is the ImageTexture variant
// of resource_loader_load_texture2d_owned_checked.
resource_loader_load_image_texture_owned_checked :: proc "contextless" (
	self: ResourceLoader,
	path: ^String,
) -> (
	owned: OwnedResource,
	texture: ImageTexture,
	err: CallError,
	ok: bool,
) {
	owned, err, ok = resource_loader_load_owned_with_cache_mode_checked(
		self,
		path,
		.cache_mode_ignore,
		true,
	)
	if !call_error_ok(&err) || !ok do return {}, {}, err, false

	texture_ok: bool
	texture, texture_ok = owned_resource_try_as_image_texture(owned)
	if !texture_ok {
		owned_resource_destroy(&owned)
		return {}, {}, err, false
	}
	return owned, texture, err, true
}

resource_loader_load_image_texture_owned :: proc "contextless" (
	self: ResourceLoader,
	path: ^String,
) -> (
	owned: OwnedResource,
	texture: ImageTexture,
) {
	checked_err: CallError
	checked_ok: bool
	owned, texture, checked_err, checked_ok = resource_loader_load_image_texture_owned_checked(
		self,
		path,
	)
	require_call_ok(&checked_err)
	if !checked_ok do gcore._trap_nil_godot_function()
	return owned, texture
}

packed_scene_instantiate_class_name_data: StaticStringName
packed_scene_instantiate_method_name_data: StaticStringName
packed_scene_instantiate_method_bind: gcore.MethodBindPtr
packed_scene_instantiate_initialized: bool

init_packed_scene_instantiate :: proc "contextless" () {
	if packed_scene_instantiate_initialized do return
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&packed_scene_instantiate_class_name_data),
		cstring("PackedScene"),
	)
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&packed_scene_instantiate_method_name_data),
		cstring("instantiate"),
	)
	packed_scene_instantiate_method_bind = gcore.require_classdb_method_bind(
		const_static_string_name_ptr(&packed_scene_instantiate_class_name_data),
		const_static_string_name_ptr(&packed_scene_instantiate_method_name_data),
		2628778455,
	)
	packed_scene_instantiate_initialized = true
}

// packed_scene_instantiate_node_checked creates a new scene root. The returned
// Node is not borrowed from the PackedScene. If it is not added to the scene
// tree, the caller must destroy it with object_destroy_checked.
packed_scene_instantiate_node_checked :: proc "contextless" (
	self: PackedScene,
) -> (
	root: Node,
	ok: bool,
) {
	if packed_scene_is_nil(self) do return {}, false
	init_packed_scene_instantiate()

	edit_state := PackedSceneGenEditState.gen_edit_state_disabled
	root = gcore.call_method_ptr_ret(
		packed_scene_instantiate_method_bind,
		Node,
		ObjectPtr(self),
		cast(gcore.TypePtr)&edit_state,
	)
	return root, !node_is_nil(root)
}

packed_scene_instantiate_node :: proc "contextless" (self: PackedScene) -> Node {
	root, ok := packed_scene_instantiate_node_checked(self)
	if !ok do gcore._trap_nil_godot_function()
	return root
}

// The typed helper returns the root even when the downcast fails so callers can
// decide whether to destroy or otherwise handle the unparented instance.
packed_scene_instantiate_node2d_checked :: proc "contextless" (
	self: PackedScene,
) -> (
	root: Node,
	value: Node2D,
	ok: bool,
) {
	created_root, root_ok := packed_scene_instantiate_node_checked(self)
	if !root_ok do return {}, {}, false
	root = created_root
	value, ok = node_try_as_node2d(root)
	return
}

node_add_child_class_name_data: StaticStringName
node_add_child_method_name_data: StaticStringName
node_add_child_method_bind: gcore.MethodBindPtr
node_add_child_initialized: bool

init_node_add_child :: proc "contextless" () {
	if node_add_child_initialized do return
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&node_add_child_class_name_data),
		cstring("Node"),
	)
	static_string_name_init_latin1_cstring(
		uninitialized_static_string_name_ptr(&node_add_child_method_name_data),
		cstring("add_child"),
	)
	node_add_child_method_bind = gcore.require_classdb_method_bind(
		const_static_string_name_ptr(&node_add_child_class_name_data),
		const_static_string_name_ptr(&node_add_child_method_name_data),
		3863233950,
	)
	node_add_child_initialized = true
}

// node_add_child_checked parents an existing unparented child. After success,
// the scene tree owns the node lifecycle; callers must not destroy that child.
// This helper intentionally keeps scene changes and deletion APIs deferred.
node_add_child_checked :: proc "contextless" (parent: Node, child: Node) -> (ok: bool) {
	if node_is_nil(parent) || node_is_nil(child) do return false
	init_node_add_child()
	_child := child
	force_readable_name := false
	internal := NodeInternalMode.internal_mode_disabled
	gcore.call_method_ptr_no_ret(
		node_add_child_method_bind,
		ObjectPtr(parent),
		cast(gcore.TypePtr)&_child,
		cast(gcore.TypePtr)&force_readable_name,
		cast(gcore.TypePtr)&internal,
	)
	return true
}

node_object_ptr :: proc "contextless" (self: Node) -> ObjectPtr {
	return ObjectPtr(self)
}

canvas_item_object_ptr :: proc "contextless" (self: CanvasItem) -> ObjectPtr {
	return ObjectPtr(self)
}

node2d_object_ptr :: proc "contextless" (self: Node2D) -> ObjectPtr {
	return ObjectPtr(self)
}

control_object_ptr :: proc "contextless" (self: Control) -> ObjectPtr {
	return ObjectPtr(self)
}

base_button_object_ptr :: proc "contextless" (self: BaseButton) -> ObjectPtr {
	return ObjectPtr(self)
}

button_object_ptr :: proc "contextless" (self: Button) -> ObjectPtr {
	return ObjectPtr(self)
}

texture_rect_object_ptr :: proc "contextless" (self: TextureRect) -> ObjectPtr {
	return ObjectPtr(self)
}

panel_object_ptr :: proc "contextless" (self: Panel) -> ObjectPtr {
	return ObjectPtr(self)
}

container_object_ptr :: proc "contextless" (self: Container) -> ObjectPtr {
	return ObjectPtr(self)
}

sprite2d_object_ptr :: proc "contextless" (self: Sprite2D) -> ObjectPtr {
	return ObjectPtr(self)
}

label_object_ptr :: proc "contextless" (self: Label) -> ObjectPtr {
	return ObjectPtr(self)
}

timer_object_ptr :: proc "contextless" (self: Timer) -> ObjectPtr {
	return ObjectPtr(self)
}

collision_object2d_object_ptr :: proc "contextless" (self: CollisionObject2D) -> ObjectPtr {
	return ObjectPtr(self)
}

area2d_object_ptr :: proc "contextless" (self: Area2D) -> ObjectPtr {
	return ObjectPtr(self)
}

physics_body2d_object_ptr :: proc "contextless" (self: PhysicsBody2D) -> ObjectPtr {
	return ObjectPtr(self)
}

character_body2d_object_ptr :: proc "contextless" (self: CharacterBody2D) -> ObjectPtr {
	return ObjectPtr(self)
}

rigid_body2d_object_ptr :: proc "contextless" (self: RigidBody2D) -> ObjectPtr {
	return ObjectPtr(self)
}

static_body2d_object_ptr :: proc "contextless" (self: StaticBody2D) -> ObjectPtr {
	return ObjectPtr(self)
}

collision_shape2d_object_ptr :: proc "contextless" (self: CollisionShape2D) -> ObjectPtr {
	return ObjectPtr(self)
}

packed_scene_object_ptr :: proc "contextless" (self: PackedScene) -> ObjectPtr {
	return ObjectPtr(self)
}

texture2d_object_ptr :: proc "contextless" (self: Texture2D) -> ObjectPtr {
	return ObjectPtr(self)
}

image_texture_object_ptr :: proc "contextless" (self: ImageTexture) -> ObjectPtr {
	return ObjectPtr(self)
}

resource_loader_object_ptr :: proc "contextless" (self: ResourceLoader) -> ObjectPtr {
	return ObjectPtr(self)
}

input_object_ptr :: proc "contextless" (self: Input) -> ObjectPtr {
	return ObjectPtr(self)
}

input_event_object_ptr :: proc "contextless" (self: InputEvent) -> ObjectPtr {
	return ObjectPtr(self)
}

input_event_from_window_object_ptr :: proc "contextless" (
	self: InputEventFromWindow,
) -> ObjectPtr {
	return ObjectPtr(self)
}

input_event_with_modifiers_object_ptr :: proc "contextless" (
	self: InputEventWithModifiers,
) -> ObjectPtr {
	return ObjectPtr(self)
}

input_event_key_object_ptr :: proc "contextless" (self: InputEventKey) -> ObjectPtr {
	return ObjectPtr(self)
}

input_event_mouse_object_ptr :: proc "contextless" (self: InputEventMouse) -> ObjectPtr {
	return ObjectPtr(self)
}

input_event_mouse_button_object_ptr :: proc "contextless" (
	self: InputEventMouseButton,
) -> ObjectPtr {
	return ObjectPtr(self)
}

input_event_mouse_motion_object_ptr :: proc "contextless" (
	self: InputEventMouseMotion,
) -> ObjectPtr {
	return ObjectPtr(self)
}

viewport_object_ptr :: proc "contextless" (self: Viewport) -> ObjectPtr {
	return ObjectPtr(self)
}

scene_tree_object_ptr :: proc "contextless" (self: SceneTree) -> ObjectPtr {
	return ObjectPtr(self)
}

object_ptr_try_as_ref_counted :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: RefCounted,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_ref_counted(Object(self))
}

object_ptr_try_as_resource :: proc "contextless" (self: ObjectPtr) -> (value: Resource, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_resource(Object(self))
}

object_ptr_try_as_texture2d :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: Texture2D,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_texture2d(Object(self))
}

object_ptr_try_as_image_texture :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: ImageTexture,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_image_texture(Object(self))
}

object_ptr_try_as_input_event :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: InputEvent,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_input_event(Object(self))
}

object_ptr_try_as_input_event_key :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: InputEventKey,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_input_event_key(Object(self))
}

object_ptr_try_as_input_event_mouse_button :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: InputEventMouseButton,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_input_event_mouse_button(Object(self))
}

object_ptr_try_as_input_event_mouse_motion :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: InputEventMouseMotion,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_input_event_mouse_motion(Object(self))
}

object_ptr_try_as_viewport :: proc "contextless" (self: ObjectPtr) -> (value: Viewport, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_viewport(Object(self))
}

// InputEvent callback handlers receive a borrowed InputEvent handle. The handle
// is valid only for the callback that supplied it unless Godot explicitly gives
// user code a longer-lived object through another API.
InputEventCallbackHandler :: #type proc(instance: ClassInstancePtr, event: InputEvent) -> bool
NodeInputEventCallbackHandler :: #type proc(
	instance: ClassInstancePtr,
	node: Node,
	event: InputEvent,
) -> bool

InputEventCallbackDescriptor :: struct {
	input:           InputEventCallbackHandler,
	unhandled_input: InputEventCallbackHandler,
}

NodeInputEventCallbackDescriptor :: struct {
	input:           NodeInputEventCallbackHandler,
	unhandled_input: NodeInputEventCallbackHandler,
}

input_event_callback_descriptor :: proc "contextless" (
	input: InputEventCallbackHandler = nil,
	unhandled_input: InputEventCallbackHandler = nil,
) -> InputEventCallbackDescriptor {
	return InputEventCallbackDescriptor{input = input, unhandled_input = unhandled_input}
}

node_input_event_callback_descriptor :: proc "contextless" (
	input: NodeInputEventCallbackHandler = nil,
	unhandled_input: NodeInputEventCallbackHandler = nil,
) -> NodeInputEventCallbackDescriptor {
	return NodeInputEventCallbackDescriptor{input = input, unhandled_input = unhandled_input}
}

dispatch_input_event_callback :: proc(
	instance: ClassInstancePtr,
	event_object: ObjectPtr,
	handler: InputEventCallbackHandler,
) -> bool {
	if handler == nil do return false
	event, event_ok := object_ptr_try_as_input_event(event_object)
	if !event_ok do return false
	return handler(instance, event)
}

dispatch_node_input_event_callback :: proc(
	instance: ClassInstancePtr,
	node: Node,
	event_object: ObjectPtr,
	handler: NodeInputEventCallbackHandler,
) -> bool {
	if handler == nil || node_is_nil(node) do return false
	event, event_ok := object_ptr_try_as_input_event(event_object)
	if !event_ok do return false
	return handler(instance, node, event)
}

// InputEvent handles are borrowed from Godot. Do not store them beyond the
// callback or object storage that supplied them.
input_event_try_key :: proc "contextless" (self: InputEvent) -> (value: InputEventKey, ok: bool) {
	if input_event_is_nil(self) do return {}, false
	return input_event_try_as_input_event_key(self)
}

input_event_try_mouse_button :: proc "contextless" (
	self: InputEvent,
) -> (
	value: InputEventMouseButton,
	ok: bool,
) {
	if input_event_is_nil(self) do return {}, false
	return input_event_try_as_input_event_mouse_button(self)
}

input_event_try_mouse_motion :: proc "contextless" (
	self: InputEvent,
) -> (
	value: InputEventMouseMotion,
	ok: bool,
) {
	if input_event_is_nil(self) do return {}, false
	return input_event_try_as_input_event_mouse_motion(self)
}

input_event_action_pressed :: proc "contextless" (self: InputEvent, action: ^StringName) -> bool {
	if input_event_is_nil(self) || action == nil do return false
	return input_event_is_action_pressed_default(self, action)
}

input_event_action_released :: proc "contextless" (self: InputEvent, action: ^StringName) -> bool {
	if input_event_is_nil(self) || action == nil do return false
	return input_event_is_action_released_default(self, action)
}

input_event_action_strength :: proc "contextless" (
	self: InputEvent,
	action: ^StringName,
) -> GodotReal {
	if input_event_is_nil(self) || action == nil do return 0
	return input_event_get_action_strength_default(self, action)
}

input_event_key_code_checked :: proc "contextless" (self: InputEvent) -> (key: Key, ok: bool) {
	event, event_ok := input_event_try_key(self)
	if !event_ok do return {}, false
	return input_event_key_get_keycode(event), true
}

input_event_mouse_button_index_checked :: proc "contextless" (
	self: InputEvent,
) -> (
	button: MouseButton,
	ok: bool,
) {
	event, event_ok := input_event_try_mouse_button(self)
	if !event_ok do return {}, false
	return input_event_mouse_button_get_button_index(event), true
}

input_event_mouse_position_checked :: proc "contextless" (
	self: InputEvent,
) -> (
	position: Vector2,
	ok: bool,
) {
	if input_event_is_nil(self) do return {}, false
	if mouse_motion, motion_ok := input_event_try_mouse_motion(self); motion_ok {
		return input_event_mouse_get_position(
				input_event_mouse_motion_as_input_event_mouse(mouse_motion),
			),
			true
	}
	if mouse_button, button_ok := input_event_try_mouse_button(self); button_ok {
		return input_event_mouse_get_position(
				input_event_mouse_button_as_input_event_mouse(mouse_button),
			),
			true
	}
	return {}, false
}

viewport_mouse_position_checked :: proc "contextless" (
	self: Viewport,
) -> (
	position: Vector2,
	ok: bool,
) {
	if viewport_is_nil(self) do return {}, false
	return viewport_get_mouse_position(self), true
}

viewport_focused_control_checked :: proc "contextless" (
	self: Viewport,
) -> (
	control: Control,
	ok: bool,
) {
	if viewport_is_nil(self) do return {}, false
	control = viewport_gui_get_focus_owner(self)
	if control_is_nil(control) do return {}, false
	return control, true
}

object_ptr_try_as_node :: proc "contextless" (self: ObjectPtr) -> (value: Node, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_node(Object(self))
}

object_ptr_try_as_canvas_item :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: CanvasItem,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_canvas_item(Object(self))
}

object_ptr_try_as_node2d :: proc "contextless" (self: ObjectPtr) -> (value: Node2D, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_node2d(Object(self))
}

object_ptr_try_as_control :: proc "contextless" (self: ObjectPtr) -> (value: Control, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_control(Object(self))
}

object_ptr_try_as_base_button :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: BaseButton,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_base_button(Object(self))
}

object_ptr_try_as_button :: proc "contextless" (self: ObjectPtr) -> (value: Button, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_button(Object(self))
}

object_ptr_try_as_texture_rect :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: TextureRect,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_texture_rect(Object(self))
}

object_ptr_try_as_panel :: proc "contextless" (self: ObjectPtr) -> (value: Panel, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_panel(Object(self))
}

object_ptr_try_as_container :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: Container,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_container(Object(self))
}

object_ptr_try_as_sprite2d :: proc "contextless" (self: ObjectPtr) -> (value: Sprite2D, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_sprite2d(Object(self))
}

object_ptr_try_as_label :: proc "contextless" (self: ObjectPtr) -> (value: Label, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_label(Object(self))
}

object_ptr_try_as_timer :: proc "contextless" (self: ObjectPtr) -> (value: Timer, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_timer(Object(self))
}

object_ptr_try_as_collision_object2d :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: CollisionObject2D,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_collision_object2d(Object(self))
}

object_ptr_try_as_area2d :: proc "contextless" (self: ObjectPtr) -> (value: Area2D, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_area2d(Object(self))
}

typed_array_get_node :: proc "contextless" (
	array: ^TypedArray,
	index: i64,
) -> (
	value: Node,
	ok: bool,
) {
	object, object_ok := typed_array_get_object(array, index)
	if !object_ok do return {}, false
	return object_ptr_try_as_node(object)
}

typed_array_get_node2d :: proc "contextless" (
	array: ^TypedArray,
	index: i64,
) -> (
	value: Node2D,
	ok: bool,
) {
	object, object_ok := typed_array_get_object(array, index)
	if !object_ok do return {}, false
	return object_ptr_try_as_node2d(object)
}

typed_array_get_area2d :: proc "contextless" (
	array: ^TypedArray,
	index: i64,
) -> (
	value: Area2D,
	ok: bool,
) {
	object, object_ok := typed_array_get_object(array, index)
	if !object_ok do return {}, false
	return object_ptr_try_as_area2d(object)
}

typed_array_get_collision_object2d :: proc "contextless" (
	array: ^TypedArray,
	index: i64,
) -> (
	value: CollisionObject2D,
	ok: bool,
) {
	object, object_ok := typed_array_get_object(array, index)
	if !object_ok do return {}, false
	return object_ptr_try_as_collision_object2d(object)
}

object_ptr_try_as_physics_body2d :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: PhysicsBody2D,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_physics_body2d(Object(self))
}

object_ptr_try_as_character_body2d :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: CharacterBody2D,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_character_body2d(Object(self))
}

object_ptr_try_as_rigid_body2d :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: RigidBody2D,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_rigid_body2d(Object(self))
}

object_ptr_try_as_static_body2d :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: StaticBody2D,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_static_body2d(Object(self))
}

object_ptr_try_as_collision_shape2d :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: CollisionShape2D,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_collision_shape2d(Object(self))
}

typed_array_get_physics_body2d :: proc "contextless" (
	array: ^TypedArray,
	index: i64,
) -> (
	value: PhysicsBody2D,
	ok: bool,
) {
	object, object_ok := typed_array_get_object(array, index)
	if !object_ok do return {}, false
	return object_ptr_try_as_physics_body2d(object)
}

object_ptr_try_as_packed_scene :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: PackedScene,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_packed_scene(Object(self))
}

object_ptr_try_as_resource_loader :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: ResourceLoader,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_resource_loader(Object(self))
}

object_ptr_try_as_input :: proc "contextless" (self: ObjectPtr) -> (value: Input, ok: bool) {
	if self == nil do return {}, false
	return object_try_as_input(Object(self))
}

object_ptr_try_as_scene_tree :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: SceneTree,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_scene_tree(Object(self))
}

// --- Class enums and constants ---
ObjectConnectFlags :: gclass.ObjectConnectFlags
ResourceDeepDuplicateMode :: gclass.ResourceDeepDuplicateMode
PackedSceneGenEditState :: gclass.PackedSceneGenEditState
ResourceLoaderThreadLoadStatus :: gclass.ResourceLoaderThreadLoadStatus
ResourceLoaderCacheMode :: gclass.ResourceLoaderCacheMode
NodeProcessMode :: gclass.NodeProcessMode
NodeProcessThreadGroup :: gclass.NodeProcessThreadGroup
NodeProcessThreadMessages :: gclass.NodeProcessThreadMessages
NodePhysicsInterpolationMode :: gclass.NodePhysicsInterpolationMode
NodeDuplicateFlags :: gclass.NodeDuplicateFlags
NodeInternalMode :: gclass.NodeInternalMode
NodeAutoTranslateMode :: gclass.NodeAutoTranslateMode
CanvasItemTextureFilter :: gclass.CanvasItemTextureFilter
CanvasItemTextureRepeat :: gclass.CanvasItemTextureRepeat
CanvasItemClipChildrenMode :: gclass.CanvasItemClipChildrenMode
CanvasItemOversamplingWithScale :: gclass.CanvasItemOversamplingWithScale
ControlFocusMode :: gclass.ControlFocusMode
BaseButtonActionMode :: gclass.BaseButtonActionMode
BaseButtonDrawMode :: gclass.BaseButtonDrawMode
TextureRectExpandMode :: gclass.TextureRectExpandMode
TextureRectStretchMode :: gclass.TextureRectStretchMode
TimerTimerProcessCallback :: gclass.TimerTimerProcessCallback
ControlFocusBehaviorRecursive :: gclass.ControlFocusBehaviorRecursive
ControlMouseBehaviorRecursive :: gclass.ControlMouseBehaviorRecursive
ControlCursorShape :: gclass.ControlCursorShape
ControlLayoutPreset :: gclass.ControlLayoutPreset
ControlLayoutPresetMode :: gclass.ControlLayoutPresetMode
ControlSizeFlags :: gclass.ControlSizeFlags
ControlMouseFilter :: gclass.ControlMouseFilter
InputMouseMode :: gclass.InputMouseMode
InputCursorShape :: gclass.InputCursorShape
SceneTreeGroupCallFlags :: gclass.SceneTreeGroupCallFlags
object_notification_postinitialize :: gclass.object_notification_postinitialize
object_notification_predelete :: gclass.object_notification_predelete
object_notification_extension_reloaded :: gclass.object_notification_extension_reloaded
node_notification_enter_tree :: gclass.node_notification_enter_tree
node_notification_exit_tree :: gclass.node_notification_exit_tree
node_notification_ready :: gclass.node_notification_ready
node_notification_process :: gclass.node_notification_process
node_notification_physics_process :: gclass.node_notification_physics_process
canvas_item_notification_draw :: gclass.canvas_item_notification_draw
canvas_item_notification_transform_changed :: gclass.canvas_item_notification_transform_changed
canvas_item_notification_visibility_changed :: gclass.canvas_item_notification_visibility_changed
control_notification_resized :: gclass.control_notification_resized
control_notification_focus_enter :: gclass.control_notification_focus_enter
control_notification_focus_exit :: gclass.control_notification_focus_exit
control_notification_theme_changed :: gclass.control_notification_theme_changed

// --- Notification helpers ---
NodeNotificationHandler :: #type proc(instance: ClassInstancePtr, reversed: bool)
NodeRawNotificationHandler :: #type proc(instance: ClassInstancePtr, what: i32, reversed: bool)
NodeVirtualHandler :: #type proc(instance: ClassInstancePtr, node: Node, reversed: bool)
NodeProcessVirtualHandler :: #type proc(
	instance: ClassInstancePtr,
	node: Node,
	delta: GodotReal,
	reversed: bool,
)

NodeNotificationHandlers :: struct {
	enter_tree:      NodeNotificationHandler,
	exit_tree:       NodeNotificationHandler,
	ready:           NodeNotificationHandler,
	process:         NodeNotificationHandler,
	physics_process: NodeNotificationHandler,
}

NodeLifecycleCallbacks :: struct {
	enter_tree:       NodeNotificationHandler,
	exit_tree:        NodeNotificationHandler,
	ready:            NodeNotificationHandler,
	process:          NodeNotificationHandler,
	physics_process:  NodeNotificationHandler,
	raw_notification: NodeRawNotificationHandler,
}

NodeVirtualCallbacks :: NodeLifecycleCallbacks

NodeVirtualCallbackDescriptor :: struct {
	enter_tree:       NodeVirtualHandler,
	exit_tree:        NodeVirtualHandler,
	ready:            NodeVirtualHandler,
	process:          NodeProcessVirtualHandler,
	physics_process:  NodeProcessVirtualHandler,
	raw_notification: NodeRawNotificationHandler,
}

node_virtual_callback_descriptor :: proc "contextless" (
	ready: NodeVirtualHandler = nil,
	enter_tree: NodeVirtualHandler = nil,
	exit_tree: NodeVirtualHandler = nil,
	process: NodeProcessVirtualHandler = nil,
	physics_process: NodeProcessVirtualHandler = nil,
	raw_notification: NodeRawNotificationHandler = nil,
) -> NodeVirtualCallbackDescriptor {
	return NodeVirtualCallbackDescriptor {
		enter_tree = enter_tree,
		exit_tree = exit_tree,
		ready = ready,
		process = process,
		physics_process = physics_process,
		raw_notification = raw_notification,
	}
}

// dispatch_node_notification calls a typed handler for common Node lifecycle
// notifications and returns true when a handler ran. Unknown notifications and
// nil handlers are left to the caller so raw notification numbers remain usable.
dispatch_node_notification :: proc(
	instance: ClassInstancePtr,
	what: i32,
	reversed: bool,
	handlers: ^NodeNotificationHandlers,
) -> bool {
	if handlers == nil do return false

	switch what {
	case node_notification_enter_tree:
		if handlers.enter_tree != nil {
			handlers.enter_tree(instance, reversed)
			return true
		}
	case node_notification_exit_tree:
		if handlers.exit_tree != nil {
			handlers.exit_tree(instance, reversed)
			return true
		}
	case node_notification_ready:
		if handlers.ready != nil {
			handlers.ready(instance, reversed)
			return true
		}
	case node_notification_process:
		if handlers.process != nil {
			handlers.process(instance, reversed)
			return true
		}
	case node_notification_physics_process:
		if handlers.physics_process != nil {
			handlers.physics_process(instance, reversed)
			return true
		}
	}
	return false
}

// dispatch_node_lifecycle_callbacks maps Godot Node notifications to a
// compact callback table. The generated constants currently match Godot 4.7:
// enter_tree=10, exit_tree=11, ready=13, physics_process=16, process=17.
// Use generated Node delta getters from a typed virtual helper instead of
// inventing delta values in the raw notification path.
dispatch_node_lifecycle_callbacks :: proc(
	instance: ClassInstancePtr,
	what: i32,
	reversed: bool,
	callbacks: ^NodeLifecycleCallbacks,
) -> bool {
	if callbacks == nil do return false

	switch what {
	case node_notification_enter_tree:
		if callbacks.enter_tree != nil {
			callbacks.enter_tree(instance, reversed)
			return true
		}
	case node_notification_exit_tree:
		if callbacks.exit_tree != nil {
			callbacks.exit_tree(instance, reversed)
			return true
		}
	case node_notification_ready:
		if callbacks.ready != nil {
			callbacks.ready(instance, reversed)
			return true
		}
	case node_notification_process:
		if callbacks.process != nil {
			callbacks.process(instance, reversed)
			return true
		}
	case node_notification_physics_process:
		if callbacks.physics_process != nil {
			callbacks.physics_process(instance, reversed)
			return true
		}
	}

	if callbacks.raw_notification != nil {
		callbacks.raw_notification(instance, what, reversed)
		return true
	}
	return false
}

dispatch_node_virtual_callbacks :: proc(
	instance: ClassInstancePtr,
	what: i32,
	reversed: bool,
	callbacks: ^NodeVirtualCallbacks,
) -> bool {
	return dispatch_node_lifecycle_callbacks(instance, what, reversed, callbacks)
}

// dispatch_node_virtual_descriptor passes a borrowed Node handle to typed
// callbacks. Process deltas come from Godot through generated Node methods.
dispatch_node_virtual_descriptor :: proc(
	instance: ClassInstancePtr,
	node: Node,
	what: i32,
	reversed: bool,
	callbacks: ^NodeVirtualCallbackDescriptor,
) -> bool {
	if callbacks == nil do return false
	if node_is_nil(node) {
		if callbacks.raw_notification != nil {
			callbacks.raw_notification(instance, what, reversed)
			return true
		}
		return false
	}

	switch what {
	case node_notification_enter_tree:
		if callbacks.enter_tree != nil {
			callbacks.enter_tree(instance, node, reversed)
			return true
		}
	case node_notification_exit_tree:
		if callbacks.exit_tree != nil {
			callbacks.exit_tree(instance, node, reversed)
			return true
		}
	case node_notification_ready:
		if callbacks.ready != nil {
			callbacks.ready(instance, node, reversed)
			return true
		}
	case node_notification_process:
		if callbacks.process != nil {
			delta := node_get_process_delta_time(node)
			callbacks.process(instance, node, delta, reversed)
			return true
		}
	case node_notification_physics_process:
		if callbacks.physics_process != nil {
			delta := node_get_physics_process_delta_time(node)
			callbacks.physics_process(instance, node, delta, reversed)
			return true
		}
	}

	if callbacks.raw_notification != nil {
		callbacks.raw_notification(instance, what, reversed)
		return true
	}
	return false
}


node_set_process_callback_enabled :: proc "contextless" (self: Node, enabled: bool) -> bool {
	if node_is_nil(self) do return false
	node_set_process(self, enabled)
	return true
}

node_enable_process_callback :: proc "contextless" (self: Node) -> bool {
	return node_set_process_callback_enabled(self, true)
}

node_disable_process_callback :: proc "contextless" (self: Node) -> bool {
	return node_set_process_callback_enabled(self, false)
}

node_set_physics_process_callback_enabled :: proc "contextless" (
	self: Node,
	enabled: bool,
) -> bool {
	if node_is_nil(self) do return false
	node_set_physics_process(self, enabled)
	return true
}

node_enable_physics_process_callback :: proc "contextless" (self: Node) -> bool {
	return node_set_physics_process_callback_enabled(self, true)
}

node_disable_physics_process_callback :: proc "contextless" (self: Node) -> bool {
	return node_set_physics_process_callback_enabled(self, false)
}

// --- String ---
string_ptr :: gcore.string_ptr
const_string_ptr :: gcore.const_string_ptr
uninitialized_string_ptr :: gcore.uninitialized_string_ptr
string_init_utf8 :: gcore.string_init_utf8
string_from_utf8 :: gcore.string_from_utf8
string_init_copy :: gcore.string_init_copy
string_copy :: gcore.string_copy
string_utf8_len :: gcore.string_utf8_len
string_to_utf8 :: gcore.string_to_utf8
string_free :: gcore.string_free
string_length :: gcore.string_length
string_is_empty :: gcore.string_is_empty
string_hash :: gcore.string_hash
string_casecmp_to :: gcore.string_casecmp_to
string_nocasecmp_to :: gcore.string_nocasecmp_to
string_naturalcasecmp_to :: gcore.string_naturalcasecmp_to
string_naturalnocasecmp_to :: gcore.string_naturalnocasecmp_to
string_begins_with :: gcore.string_begins_with
string_ends_with :: gcore.string_ends_with
string_contains :: gcore.string_contains

// --- StringName ---
string_name_ptr :: gcore.string_name_ptr
const_string_name_ptr :: gcore.const_string_name_ptr
uninitialized_string_name_ptr :: gcore.uninitialized_string_name_ptr
string_name_init_utf8_cstring :: gcore.string_name_init_utf8_cstring
string_name_from_utf8_cstring :: gcore.string_name_from_utf8_cstring
string_name_free :: gcore.string_name_free
static_string_name_ptr :: gcore.static_string_name_ptr
const_static_string_name_ptr :: gcore.const_static_string_name_ptr
uninitialized_static_string_name_ptr :: gcore.uninitialized_static_string_name_ptr
static_string_name_init_latin1_cstring :: gcore.static_string_name_init_latin1_cstring
class_name_ptr :: gcore.class_name_ptr
class_name_init_latin1_cstring :: gcore.class_name_init_latin1_cstring

// --- NodePath ---
node_path_ptr :: gcore.node_path_ptr
const_node_path_ptr :: gcore.const_node_path_ptr
uninitialized_node_path_ptr :: gcore.uninitialized_node_path_ptr
node_path_init_from_string :: gcore.node_path_init_from_string
node_path_from_string :: gcore.node_path_from_string
node_path_init_utf8 :: gcore.node_path_init_utf8
node_path_from_utf8 :: gcore.node_path_from_utf8
node_path_init_copy :: gcore.node_path_init_copy
node_path_copy :: gcore.node_path_copy
node_path_free :: gcore.node_path_free
callable_ptr :: gcore.callable_ptr
const_callable_ptr :: gcore.const_callable_ptr
uninitialized_callable_ptr :: gcore.uninitialized_callable_ptr
callable_init_nil :: gcore.callable_init_nil
callable_nil :: gcore.callable_nil
callable_init_copy :: gcore.callable_init_copy
callable_copy :: gcore.callable_copy
callable_init_object_method :: gcore.callable_init_object_method
callable_from_object_method :: gcore.callable_from_object_method
callable_free :: gcore.callable_free
callable_is_null :: gcore.callable_is_null
callable_is_valid :: gcore.callable_is_valid
signal_ptr :: gcore.signal_ptr
const_signal_ptr :: gcore.const_signal_ptr
uninitialized_signal_ptr :: gcore.uninitialized_signal_ptr
signal_init_nil :: gcore.signal_init_nil
signal_nil :: gcore.signal_nil
signal_init_copy :: gcore.signal_init_copy
signal_copy :: gcore.signal_copy
signal_init_object_signal :: gcore.signal_init_object_signal
signal_from_object_signal :: gcore.signal_from_object_signal
signal_free :: gcore.signal_free
signal_is_null :: gcore.signal_is_null
signal_connect_checked :: gcore.signal_connect_checked
signal_connect :: gcore.signal_connect
object_signal_connect_checked :: gcore.object_signal_connect_checked
object_signal_connect :: gcore.object_signal_connect
signal_get_name :: gcore.signal_get_name
node_path_is_absolute :: gcore.node_path_is_absolute
node_path_get_name :: gcore.node_path_get_name
node_path_get_subname :: gcore.node_path_get_subname
node_path_get_concatenated_names :: gcore.node_path_get_concatenated_names
node_path_get_concatenated_subnames :: gcore.node_path_get_concatenated_subnames
node_path_get_name_count :: gcore.node_path_get_name_count
node_path_get_subname_count :: gcore.node_path_get_subname_count
node_path_hash :: gcore.node_path_hash

// --- RID ---
rid_ptr :: gcore.rid_ptr
const_rid_ptr :: gcore.const_rid_ptr
uninitialized_rid_ptr :: gcore.uninitialized_rid_ptr
rid_init_new :: gcore.rid_init_new
rid_new :: gcore.rid_new
rid_init_copy :: gcore.rid_init_copy
rid_copy :: gcore.rid_copy
rid_free :: gcore.rid_free
rid_is_valid :: gcore.rid_is_valid
rid_get_id :: gcore.rid_get_id

// --- Array ---
array_ptr :: gcore.array_ptr
const_array_ptr :: gcore.const_array_ptr
uninitialized_array_ptr :: gcore.uninitialized_array_ptr
array_init_new :: gcore.array_init_new
array_new :: gcore.array_new
array_init_copy :: gcore.array_init_copy
array_copy :: gcore.array_copy
array_free :: gcore.array_free
typed_array_ptr :: gcore.typed_array_ptr
const_typed_array_ptr :: gcore.const_typed_array_ptr
uninitialized_typed_array_ptr :: gcore.uninitialized_typed_array_ptr
typed_array_free :: gcore.typed_array_free
typed_array_size :: gcore.typed_array_size
typed_array_get_variant :: gcore.typed_array_get_variant
typed_array_get_object :: gcore.typed_array_get_object
array_push :: gcore.array_push
array_size :: gcore.array_size
array_is_empty :: gcore.array_is_empty
array_clear :: gcore.array_clear
array_get :: gcore.array_get
array_set :: gcore.array_set
array_erase :: gcore.array_erase
array_has :: gcore.array_has

// --- Dictionary ---
dictionary_ptr :: gcore.dictionary_ptr
const_dictionary_ptr :: gcore.const_dictionary_ptr
uninitialized_dictionary_ptr :: gcore.uninitialized_dictionary_ptr
dictionary_init_new :: gcore.dictionary_init_new
dictionary_new :: gcore.dictionary_new
dictionary_init_copy :: gcore.dictionary_init_copy
dictionary_copy :: gcore.dictionary_copy
dictionary_free :: gcore.dictionary_free
dictionary_set :: gcore.dictionary_set
dictionary_has :: gcore.dictionary_has
dictionary_size :: gcore.dictionary_size
dictionary_is_empty :: gcore.dictionary_is_empty
dictionary_clear :: gcore.dictionary_clear
dictionary_erase :: gcore.dictionary_erase
dictionary_get_or_default :: gcore.dictionary_get_or_default
dictionary_get :: gcore.dictionary_get

// --- PackedByteArray ---
packed_byte_array_ptr :: gcore.packed_byte_array_ptr
const_packed_byte_array_ptr :: gcore.const_packed_byte_array_ptr
uninitialized_packed_byte_array_ptr :: gcore.uninitialized_packed_byte_array_ptr
packed_byte_array_init_new :: gcore.packed_byte_array_init_new
packed_byte_array_new :: gcore.packed_byte_array_new
packed_byte_array_init_copy :: gcore.packed_byte_array_init_copy
packed_byte_array_copy :: gcore.packed_byte_array_copy
packed_byte_array_free :: gcore.packed_byte_array_free
packed_byte_array_size :: gcore.packed_byte_array_size
packed_byte_array_is_empty :: gcore.packed_byte_array_is_empty
packed_byte_array_clear :: gcore.packed_byte_array_clear
packed_byte_array_get :: gcore.packed_byte_array_get
packed_byte_array_set :: gcore.packed_byte_array_set
packed_byte_array_push :: gcore.packed_byte_array_push

// --- PackedInt32Array ---
packed_int32_array_ptr :: gcore.packed_int32_array_ptr
const_packed_int32_array_ptr :: gcore.const_packed_int32_array_ptr
uninitialized_packed_int32_array_ptr :: gcore.uninitialized_packed_int32_array_ptr
packed_int32_array_init_new :: gcore.packed_int32_array_init_new
packed_int32_array_new :: gcore.packed_int32_array_new
packed_int32_array_init_copy :: gcore.packed_int32_array_init_copy
packed_int32_array_copy :: gcore.packed_int32_array_copy
packed_int32_array_free :: gcore.packed_int32_array_free
packed_int32_array_size :: gcore.packed_int32_array_size
packed_int32_array_is_empty :: gcore.packed_int32_array_is_empty
packed_int32_array_clear :: gcore.packed_int32_array_clear
packed_int32_array_get :: gcore.packed_int32_array_get
packed_int32_array_set :: gcore.packed_int32_array_set
packed_int32_array_push :: gcore.packed_int32_array_push

// --- PackedInt64Array ---
packed_int64_array_ptr :: gcore.packed_int64_array_ptr
const_packed_int64_array_ptr :: gcore.const_packed_int64_array_ptr
uninitialized_packed_int64_array_ptr :: gcore.uninitialized_packed_int64_array_ptr
packed_int64_array_init_new :: gcore.packed_int64_array_init_new
packed_int64_array_new :: gcore.packed_int64_array_new
packed_int64_array_init_copy :: gcore.packed_int64_array_init_copy
packed_int64_array_copy :: gcore.packed_int64_array_copy
packed_int64_array_free :: gcore.packed_int64_array_free
packed_int64_array_size :: gcore.packed_int64_array_size
packed_int64_array_is_empty :: gcore.packed_int64_array_is_empty
packed_int64_array_clear :: gcore.packed_int64_array_clear
packed_int64_array_get :: gcore.packed_int64_array_get
packed_int64_array_set :: gcore.packed_int64_array_set
packed_int64_array_push :: gcore.packed_int64_array_push

// --- PackedFloat32Array ---
packed_float32_array_ptr :: gcore.packed_float32_array_ptr
const_packed_float32_array_ptr :: gcore.const_packed_float32_array_ptr
uninitialized_packed_float32_array_ptr :: gcore.uninitialized_packed_float32_array_ptr
packed_float32_array_init_new :: gcore.packed_float32_array_init_new
packed_float32_array_new :: gcore.packed_float32_array_new
packed_float32_array_init_copy :: gcore.packed_float32_array_init_copy
packed_float32_array_copy :: gcore.packed_float32_array_copy
packed_float32_array_free :: gcore.packed_float32_array_free
packed_float32_array_size :: gcore.packed_float32_array_size
packed_float32_array_is_empty :: gcore.packed_float32_array_is_empty
packed_float32_array_clear :: gcore.packed_float32_array_clear
packed_float32_array_get :: gcore.packed_float32_array_get
packed_float32_array_set :: gcore.packed_float32_array_set
packed_float32_array_push :: gcore.packed_float32_array_push

// --- PackedFloat64Array ---
packed_float64_array_ptr :: gcore.packed_float64_array_ptr
const_packed_float64_array_ptr :: gcore.const_packed_float64_array_ptr
uninitialized_packed_float64_array_ptr :: gcore.uninitialized_packed_float64_array_ptr
packed_float64_array_init_new :: gcore.packed_float64_array_init_new
packed_float64_array_new :: gcore.packed_float64_array_new
packed_float64_array_init_copy :: gcore.packed_float64_array_init_copy
packed_float64_array_copy :: gcore.packed_float64_array_copy
packed_float64_array_free :: gcore.packed_float64_array_free
packed_float64_array_size :: gcore.packed_float64_array_size
packed_float64_array_is_empty :: gcore.packed_float64_array_is_empty
packed_float64_array_clear :: gcore.packed_float64_array_clear
packed_float64_array_get :: gcore.packed_float64_array_get
packed_float64_array_set :: gcore.packed_float64_array_set
packed_float64_array_push :: gcore.packed_float64_array_push

// --- PackedStringArray ---
packed_string_array_ptr :: gcore.packed_string_array_ptr
const_packed_string_array_ptr :: gcore.const_packed_string_array_ptr
uninitialized_packed_string_array_ptr :: gcore.uninitialized_packed_string_array_ptr
packed_string_array_init_new :: gcore.packed_string_array_init_new
packed_string_array_new :: gcore.packed_string_array_new
packed_string_array_init_copy :: gcore.packed_string_array_init_copy
packed_string_array_copy :: gcore.packed_string_array_copy
packed_string_array_free :: gcore.packed_string_array_free
packed_string_array_size :: gcore.packed_string_array_size
packed_string_array_is_empty :: gcore.packed_string_array_is_empty
packed_string_array_clear :: gcore.packed_string_array_clear
packed_string_array_get :: gcore.packed_string_array_get
packed_string_array_set :: gcore.packed_string_array_set
packed_string_array_push :: gcore.packed_string_array_push

// --- PackedVector2Array ---
packed_vector2_array_ptr :: gcore.packed_vector2_array_ptr
const_packed_vector2_array_ptr :: gcore.const_packed_vector2_array_ptr
uninitialized_packed_vector2_array_ptr :: gcore.uninitialized_packed_vector2_array_ptr
packed_vector2_array_init_new :: gcore.packed_vector2_array_init_new
packed_vector2_array_new :: gcore.packed_vector2_array_new
packed_vector2_array_init_copy :: gcore.packed_vector2_array_init_copy
packed_vector2_array_copy :: gcore.packed_vector2_array_copy
packed_vector2_array_free :: gcore.packed_vector2_array_free
packed_vector2_array_size :: gcore.packed_vector2_array_size
packed_vector2_array_is_empty :: gcore.packed_vector2_array_is_empty
packed_vector2_array_clear :: gcore.packed_vector2_array_clear
packed_vector2_array_get :: gcore.packed_vector2_array_get
packed_vector2_array_set :: gcore.packed_vector2_array_set
packed_vector2_array_push :: gcore.packed_vector2_array_push

// --- PackedVector3Array ---
packed_vector3_array_ptr :: gcore.packed_vector3_array_ptr
const_packed_vector3_array_ptr :: gcore.const_packed_vector3_array_ptr
uninitialized_packed_vector3_array_ptr :: gcore.uninitialized_packed_vector3_array_ptr
packed_vector3_array_init_new :: gcore.packed_vector3_array_init_new
packed_vector3_array_new :: gcore.packed_vector3_array_new
packed_vector3_array_init_copy :: gcore.packed_vector3_array_init_copy
packed_vector3_array_copy :: gcore.packed_vector3_array_copy
packed_vector3_array_free :: gcore.packed_vector3_array_free
packed_vector3_array_size :: gcore.packed_vector3_array_size
packed_vector3_array_is_empty :: gcore.packed_vector3_array_is_empty
packed_vector3_array_clear :: gcore.packed_vector3_array_clear
packed_vector3_array_get :: gcore.packed_vector3_array_get
packed_vector3_array_set :: gcore.packed_vector3_array_set
packed_vector3_array_push :: gcore.packed_vector3_array_push

// --- PackedVector4Array ---
packed_vector4_array_ptr :: gcore.packed_vector4_array_ptr
const_packed_vector4_array_ptr :: gcore.const_packed_vector4_array_ptr
uninitialized_packed_vector4_array_ptr :: gcore.uninitialized_packed_vector4_array_ptr
packed_vector4_array_init_new :: gcore.packed_vector4_array_init_new
packed_vector4_array_new :: gcore.packed_vector4_array_new
packed_vector4_array_init_copy :: gcore.packed_vector4_array_init_copy
packed_vector4_array_copy :: gcore.packed_vector4_array_copy
packed_vector4_array_free :: gcore.packed_vector4_array_free
packed_vector4_array_size :: gcore.packed_vector4_array_size
packed_vector4_array_is_empty :: gcore.packed_vector4_array_is_empty
packed_vector4_array_clear :: gcore.packed_vector4_array_clear
packed_vector4_array_get :: gcore.packed_vector4_array_get
packed_vector4_array_set :: gcore.packed_vector4_array_set
packed_vector4_array_push :: gcore.packed_vector4_array_push

// --- PackedColorArray ---
packed_color_array_ptr :: gcore.packed_color_array_ptr
const_packed_color_array_ptr :: gcore.const_packed_color_array_ptr
uninitialized_packed_color_array_ptr :: gcore.uninitialized_packed_color_array_ptr
packed_color_array_init_new :: gcore.packed_color_array_init_new
packed_color_array_new :: gcore.packed_color_array_new
packed_color_array_init_copy :: gcore.packed_color_array_init_copy
packed_color_array_copy :: gcore.packed_color_array_copy
packed_color_array_free :: gcore.packed_color_array_free
packed_color_array_size :: gcore.packed_color_array_size
packed_color_array_is_empty :: gcore.packed_color_array_is_empty
packed_color_array_clear :: gcore.packed_color_array_clear
packed_color_array_get :: gcore.packed_color_array_get
packed_color_array_set :: gcore.packed_color_array_set
packed_color_array_push :: gcore.packed_color_array_push

// --- Variant ---
variant_type :: gcore.variant_type
variant_is_type :: gcore.variant_is_type
variant_is_nil :: gcore.variant_is_nil
variant_ptr :: gcore.variant_ptr
const_variant_ptr :: gcore.const_variant_ptr
uninitialized_variant_ptr :: gcore.uninitialized_variant_ptr
variant_init_nil :: gcore.variant_init_nil
variant_nil :: gcore.variant_nil
variant_init_copy :: gcore.variant_init_copy
variant_copy :: gcore.variant_copy
variant_from_float :: gcore.variant_from_float
variant_from_int :: gcore.variant_from_int
variant_from_bool :: gcore.variant_from_bool
variant_from_string :: gcore.variant_from_string
variant_from_string_name :: gcore.variant_from_string_name
variant_from_node_path :: gcore.variant_from_node_path
variant_from_rid :: gcore.variant_from_rid
variant_from_array :: gcore.variant_from_array
variant_from_dictionary :: gcore.variant_from_dictionary
variant_from_packed_byte_array :: gcore.variant_from_packed_byte_array
variant_from_packed_int32_array :: gcore.variant_from_packed_int32_array
variant_from_packed_int64_array :: gcore.variant_from_packed_int64_array
variant_from_packed_float32_array :: gcore.variant_from_packed_float32_array
variant_from_packed_float64_array :: gcore.variant_from_packed_float64_array
variant_from_packed_string_array :: gcore.variant_from_packed_string_array
variant_from_packed_vector2_array :: gcore.variant_from_packed_vector2_array
variant_from_packed_vector3_array :: gcore.variant_from_packed_vector3_array
variant_from_packed_vector4_array :: gcore.variant_from_packed_vector4_array
variant_from_packed_color_array :: gcore.variant_from_packed_color_array
variant_from_utf8 :: gcore.variant_from_utf8
variant_from_cstring :: gcore.variant_from_cstring
variant_to_float :: gcore.variant_to_float
variant_to_int :: gcore.variant_to_int
variant_to_bool :: gcore.variant_to_bool
variant_to_string_storage :: gcore.variant_to_string_storage
variant_to_string :: gcore.variant_to_string
variant_try_string :: gcore.variant_try_string
variant_to_string_name :: gcore.variant_to_string_name
variant_try_string_name :: gcore.variant_try_string_name
variant_to_node_path :: gcore.variant_to_node_path
variant_try_node_path :: gcore.variant_try_node_path
variant_to_rid :: gcore.variant_to_rid
variant_try_rid :: gcore.variant_try_rid
variant_to_array :: gcore.variant_to_array
variant_try_array :: gcore.variant_try_array
variant_to_dictionary :: gcore.variant_to_dictionary
variant_try_dictionary :: gcore.variant_try_dictionary
variant_to_packed_byte_array :: gcore.variant_to_packed_byte_array
variant_try_packed_byte_array :: gcore.variant_try_packed_byte_array
variant_to_packed_int32_array :: gcore.variant_to_packed_int32_array
variant_try_packed_int32_array :: gcore.variant_try_packed_int32_array
variant_to_packed_int64_array :: gcore.variant_to_packed_int64_array
variant_try_packed_int64_array :: gcore.variant_try_packed_int64_array
variant_to_packed_float32_array :: gcore.variant_to_packed_float32_array
variant_try_packed_float32_array :: gcore.variant_try_packed_float32_array
variant_to_packed_float64_array :: gcore.variant_to_packed_float64_array
variant_try_packed_float64_array :: gcore.variant_try_packed_float64_array
variant_to_packed_string_array :: gcore.variant_to_packed_string_array
variant_try_packed_string_array :: gcore.variant_try_packed_string_array
variant_to_packed_vector2_array :: gcore.variant_to_packed_vector2_array
variant_try_packed_vector2_array :: gcore.variant_try_packed_vector2_array
variant_to_packed_vector3_array :: gcore.variant_to_packed_vector3_array
variant_try_packed_vector3_array :: gcore.variant_try_packed_vector3_array
variant_to_packed_vector4_array :: gcore.variant_to_packed_vector4_array
variant_try_packed_vector4_array :: gcore.variant_try_packed_vector4_array
variant_to_packed_color_array :: gcore.variant_to_packed_color_array
variant_try_packed_color_array :: gcore.variant_try_packed_color_array
variant_string_utf8_len :: gcore.variant_string_utf8_len
variant_try_utf8 :: gcore.variant_try_utf8
variant_try_float :: gcore.variant_try_float
variant_try_int :: gcore.variant_try_int
variant_try_bool :: gcore.variant_try_bool

// Public Variant conversion grouping. `variant_from` returns an owned initialized
// Variant that must be destroyed with variant_free. `variant_try` groups checked
// extraction helpers; owned value results still follow their matching free rule.
variant_from :: proc {
	variant_from_float,
	variant_from_int,
	variant_from_bool,
	variant_from_string,
	variant_from_string_name,
	variant_from_node_path,
	variant_from_rid,
	variant_from_array,
	variant_from_dictionary,
	variant_from_packed_byte_array,
	variant_from_packed_int32_array,
	variant_from_packed_int64_array,
	variant_from_packed_float32_array,
	variant_from_packed_float64_array,
	variant_from_packed_string_array,
	variant_from_packed_vector2_array,
	variant_from_packed_vector3_array,
	variant_from_packed_vector4_array,
	variant_from_packed_color_array,
	variant_from_utf8,
	variant_from_cstring,
	object_to_variant,
}

VariantTryGroup :: struct {
	float:                #type proc "contextless" (v: ^Variant) -> (value: GodotReal, ok: bool),
	int:                  #type proc "contextless" (v: ^Variant) -> (value: i64, ok: bool),
	bool:                 #type proc "contextless" (v: ^Variant) -> (value: bool, ok: bool),
	string:               #type proc "contextless" (v: ^Variant) -> (value: String, ok: bool),
	string_name:          #type proc "contextless" (v: ^Variant) -> (value: StringName, ok: bool),
	node_path:            #type proc "contextless" (v: ^Variant) -> (value: NodePath, ok: bool),
	rid:                  #type proc "contextless" (v: ^Variant) -> (value: RID, ok: bool),
	array:                #type proc "contextless" (v: ^Variant) -> (value: Array, ok: bool),
	dictionary:           #type proc "contextless" (v: ^Variant) -> (value: Dictionary, ok: bool),
	packed_byte_array:    #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedByteArray,
		ok: bool,
	),
	packed_int32_array:   #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedInt32Array,
		ok: bool,
	),
	packed_int64_array:   #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedInt64Array,
		ok: bool,
	),
	packed_float32_array: #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedFloat32Array,
		ok: bool,
	),
	packed_float64_array: #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedFloat64Array,
		ok: bool,
	),
	packed_string_array:  #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedStringArray,
		ok: bool,
	),
	packed_vector2_array: #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedVector2Array,
		ok: bool,
	),
	packed_vector3_array: #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedVector3Array,
		ok: bool,
	),
	packed_vector4_array: #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedVector4Array,
		ok: bool,
	),
	packed_color_array:   #type proc "contextless" (
		v: ^Variant,
	) -> (
		value: PackedColorArray,
		ok: bool,
	),
	object:               #type proc "contextless" (v: ^Variant) -> (value: ObjectPtr, ok: bool),
}

variant_try := VariantTryGroup {
	float                = variant_try_float,
	int                  = variant_try_int,
	bool                 = variant_try_bool,
	string               = variant_try_string,
	string_name          = variant_try_string_name,
	node_path            = variant_try_node_path,
	rid                  = variant_try_rid,
	array                = variant_try_array,
	dictionary           = variant_try_dictionary,
	packed_byte_array    = variant_try_packed_byte_array,
	packed_int32_array   = variant_try_packed_int32_array,
	packed_int64_array   = variant_try_packed_int64_array,
	packed_float32_array = variant_try_packed_float32_array,
	packed_float64_array = variant_try_packed_float64_array,
	packed_string_array  = variant_try_packed_string_array,
	packed_vector2_array = variant_try_packed_vector2_array,
	packed_vector3_array = variant_try_packed_vector3_array,
	packed_vector4_array = variant_try_packed_vector4_array,
	packed_color_array   = variant_try_packed_color_array,
	object               = variant_try_object,
}

variant_free :: gcore.variant_free
variant_free_temp :: gcore.variant_free_temp
call_error_ok :: gcore.call_error_ok
require_call_ok :: gcore.require_call_ok
variant_construct_checked :: gcore.variant_construct_checked
variant_call_checked :: gcore.variant_call_checked
print :: gcore.print
print_init :: gcore.print_init

// --- Generated builtin helpers used by the public facade smoke path ---
color_to_html :: gbind_builtin.color_to_html
color_html :: gbind_builtin.color_html
vector2_new3 :: gbind_builtin.vector2_new3
vector2_to_variant :: gbind_builtin.vector2_to_variant
vector2_try_from_variant :: gbind_builtin.vector2_try_from_variant
vector2_length :: gbind_builtin.vector2_length
vector2_normalized :: gbind_builtin.vector2_normalized
vector2_dot :: gbind_builtin.vector2_dot

// --- Utility functions ---
sin :: gbind.sin
cos :: gbind.cos
tan :: gbind.tan
randf :: gbind.randf
