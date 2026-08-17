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
ClassMethodCall :: gcore.ClassMethodCall
ClassMethodPtrCall :: gcore.ClassMethodPtrCall
ClassMethodArgumentMetadata :: gcore.ClassMethodArgumentMetadata
PropertyInfo :: gcore.PropertyInfo
ClassMethodInfo :: gcore.ClassMethodInfo
EditorVisibleClassDescriptor :: gcore.EditorVisibleClassDescriptor
PropertyUsageStorage :: gcore.PropertyUsageStorage
PropertyUsageEditor :: gcore.PropertyUsageEditor
PropertyUsageDefault :: gcore.PropertyUsageDefault
MethodPropertyDescriptor :: gcore.MethodPropertyDescriptor
ClassMemberDefaults :: gcore.ClassMemberDefaults
ClassPropertyDescriptor :: gcore.ClassPropertyDescriptor
ClassSignalDescriptor :: gcore.ClassSignalDescriptor
ClassMethodDescriptor :: gcore.ClassMethodDescriptor
OdinClassMethod :: gcore.OdinClassMethod
OdinClassProperty :: gcore.OdinClassProperty
OdinClassSignal :: gcore.OdinClassSignal
OdinClassDescriptor :: gcore.OdinClassDescriptor
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
HorizontalAlignment :: gclass.HorizontalAlignment
VerticalAlignment :: gclass.VerticalAlignment
Resource :: gclass.Resource
OwnedResource :: struct {
	ref: OwnedRefCounted,
}
Node :: gclass.Node
CanvasItem :: gclass.CanvasItem
Node2D :: gclass.Node2D
Control :: gclass.Control
Sprite2D :: gclass.Sprite2D
Label :: gclass.Label
Timer :: gclass.Timer
CollisionObject2D :: gclass.CollisionObject2D
Area2D :: gclass.Area2D
PackedScene :: gclass.PackedScene

// --- Core functions ---
init :: gcore.init
construct_object :: gcore.construct_object
debug_print :: gcore.debug_print
is_nil :: gcore.is_nil
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
class_instance_data :: gcore.class_instance_data
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
class_builder_begin :: gcore.class_builder_begin
class_builder_methods :: gcore.class_builder_methods
class_builder_properties :: gcore.class_builder_properties
class_builder_signals :: gcore.class_builder_signals
class_builder_finalize :: gcore.class_builder_finalize
class_builder_register :: gcore.class_builder_register
class_builder_unregister :: gcore.class_builder_unregister
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
class_property_godot_real :: gcore.class_property_godot_real
class_property_int :: gcore.class_property_int
class_property_bool :: gcore.class_property_bool
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
godot_context :: gcore.godot_context
init_class_bindings :: gclass.init_class_bindings
ref_counted_as_object :: gclass.ref_counted_as_object
resource_as_ref_counted :: gclass.resource_as_ref_counted
resource_as_object :: gclass.resource_as_object
ref_counted_get_reference_count :: gclass.ref_counted_get_reference_count
resource_get_path :: gclass.resource_get_path
resource_get_rid :: gclass.resource_get_rid
resource_set_local_to_scene :: gclass.resource_set_local_to_scene
resource_is_local_to_scene :: gclass.resource_is_local_to_scene
node_as_object :: gclass.node_as_object
node_get_parent :: gclass.node_get_parent
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
object_is_ref_counted :: gclass.object_is_ref_counted
object_try_as_ref_counted :: gclass.object_try_as_ref_counted
object_is_resource :: gclass.object_is_resource
object_try_as_resource :: gclass.object_try_as_resource
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
object_is_timer :: gclass.object_is_timer
object_try_as_timer :: gclass.object_try_as_timer
object_is_collision_object2d :: gclass.object_is_collision_object2d
object_try_as_collision_object2d :: gclass.object_try_as_collision_object2d
object_is_area2d :: gclass.object_is_area2d
object_try_as_area2d :: gclass.object_try_as_area2d
object_is_packed_scene :: gclass.object_is_packed_scene
object_try_as_packed_scene :: gclass.object_try_as_packed_scene
ref_counted_is_resource :: gclass.ref_counted_is_resource
ref_counted_try_as_resource :: gclass.ref_counted_try_as_resource
ref_counted_is_packed_scene :: gclass.ref_counted_is_packed_scene
ref_counted_try_as_packed_scene :: gclass.ref_counted_try_as_packed_scene
resource_is_packed_scene :: gclass.resource_is_packed_scene
resource_try_as_packed_scene :: gclass.resource_try_as_packed_scene
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
control_is_label :: gclass.control_is_label
control_try_as_label :: gclass.control_try_as_label
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
packed_scene_as_resource :: gclass.packed_scene_as_resource
packed_scene_as_ref_counted :: gclass.packed_scene_as_ref_counted
packed_scene_as_object :: gclass.packed_scene_as_object
packed_scene_pack :: gclass.packed_scene_pack
packed_scene_can_instantiate :: gclass.packed_scene_can_instantiate

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

packed_scene_is_nil :: proc "contextless" (self: PackedScene) -> bool {
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

packed_scene_object_ptr :: proc "contextless" (self: PackedScene) -> ObjectPtr {
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

object_ptr_try_as_packed_scene :: proc "contextless" (
	self: ObjectPtr,
) -> (
	value: PackedScene,
	ok: bool,
) {
	if self == nil do return {}, false
	return object_try_as_packed_scene(Object(self))
}

// --- Class enums and constants ---
ObjectConnectFlags :: gclass.ObjectConnectFlags
ResourceDeepDuplicateMode :: gclass.ResourceDeepDuplicateMode
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
TimerTimerProcessCallback :: gclass.TimerTimerProcessCallback
ControlFocusBehaviorRecursive :: gclass.ControlFocusBehaviorRecursive
ControlMouseBehaviorRecursive :: gclass.ControlMouseBehaviorRecursive
ControlCursorShape :: gclass.ControlCursorShape
ControlLayoutPreset :: gclass.ControlLayoutPreset
ControlLayoutPresetMode :: gclass.ControlLayoutPresetMode
ControlSizeFlags :: gclass.ControlSizeFlags
ControlMouseFilter :: gclass.ControlMouseFilter
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

// dispatch_node_lifecycle_callbacks is the compact public callback-table path
// for common Node lifecycle notifications. Process callbacks are notification
// callbacks only; they do not synthesize _process(delta) or
// _physics_process(delta) data.
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
