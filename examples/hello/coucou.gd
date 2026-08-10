extends Node

var pinged_count := 0

func _on_hello_pinged() -> void:
	pinged_count += 1

func _ready() -> void:
	var node: Object = ClassDB.instantiate("HelloNode")
	if node == null:
		push_error("HelloNode was not registered")
		get_tree().quit(1)
		return

	print("HelloNode created!")
	var has_pinged_signal := node.has_signal("pinged")
	print("hello.has_signal(pinged) = ", has_pinged_signal)
	node.connect("pinged", _on_hello_pinged)
	node.speed = 240.0
	var speed: Variant = node.speed
	print("hello.speed = ", speed)
	var result: Variant = node.call("add", 7.0, 6.0)
	print("hello.add(7.0, 6.0) = ", result)
	print("hello.pinged_count = ", pinged_count)
	node.free()

	if not has_pinged_signal:
		push_error("HelloNode.pinged signal was not registered")
		get_tree().quit(1)
		return

	if pinged_count != 1:
		push_error("HelloNode.pinged emitted %s times, expected 1" % pinged_count)
		get_tree().quit(1)
		return

	if speed != 240.0:
		push_error("HelloNode.speed returned %s, expected 240.0" % speed)
		get_tree().quit(1)
		return

	if result != 13.0:
		push_error("HelloNode.add returned %s, expected 13.0" % result)
		get_tree().quit(1)
