extends Node

@onready var result_label: Label = $Label

var hello_node: Object
var pinged_count := 0
var speed_changed_values: Array[float] = []

func _on_hello_pinged() -> void:
	pinged_count += 1

func _on_hello_speed_changed(value: float) -> void:
	speed_changed_values.append(value)

func _ready() -> void:
	hello_node = ClassDB.instantiate("HelloNode")
	var node := hello_node
	if node == null:
		push_error("HelloNode was not registered")
		get_tree().quit(1)
		return

	print("HelloNode created!")
	var has_pinged_signal := node.has_signal("pinged")
	var has_speed_changed_signal := node.has_signal("speed_changed")
	print("hello.has_signal(pinged) = ", has_pinged_signal)
	print("hello.has_signal(speed_changed) = ", has_speed_changed_signal)
	node.connect("pinged", _on_hello_pinged)
	node.connect("speed_changed", _on_hello_speed_changed)
	node.speed = 240.0
	var speed: Variant = node.speed
	print("hello.speed = ", speed)
	var result: Variant = node.call("add", 7.0, 6.0)
	print("hello.add(7.0, 6.0) = ", result)
	print("hello.pinged_count = ", pinged_count)
	print("hello.speed_changed_values = ", speed_changed_values)
	update_label_from_odin()

	if not has_pinged_signal:
		push_error("HelloNode.pinged signal was not registered")
		get_tree().quit(1)
		return

	if not has_speed_changed_signal:
		push_error("HelloNode.speed_changed signal was not registered")
		get_tree().quit(1)
		return

	if pinged_count != 1:
		push_error("HelloNode.pinged emitted %s times, expected 1" % pinged_count)
		get_tree().quit(1)
		return

	if speed_changed_values.size() != 1 or speed_changed_values[0] != 240.0:
		push_error("HelloNode.speed_changed values were %s, expected [240.0]" % [speed_changed_values])
		get_tree().quit(1)
		return

	if speed != 240.0:
		push_error("HelloNode.speed returned %s, expected 240.0" % speed)
		get_tree().quit(1)
		return

	if result != 13.0:
		push_error("HelloNode.add returned %s, expected 13.0" % result)
		get_tree().quit(1)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		update_label_from_odin()

func update_label_from_odin() -> void:
	if hello_node == null:
		return
	var value: float = hello_node.call("roll_math")
	result_label.text = "Space calls Odin roll_math(): %.3f" % value

func _exit_tree() -> void:
	if hello_node != null:
		hello_node.free()
		hello_node = null
