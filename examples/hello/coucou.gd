extends Node

func _ready() -> void:
	var node: Object = ClassDB.instantiate("HelloNode")
	if node == null:
		push_error("HelloNode was not registered")
		get_tree().quit(1)
		return

	print("HelloNode created!")
	node.speed = 240.0
	var speed: Variant = node.speed
	print("hello.speed = ", speed)
	var result: Variant = node.call("add", 7.0, 6.0)
	print("hello.add(7.0, 6.0) = ", result)
	node.free()

	if speed != 240.0:
		push_error("HelloNode.speed returned %s, expected 240.0" % speed)
		get_tree().quit(1)
		return

	if result != 13.0:
		push_error("HelloNode.add returned %s, expected 13.0" % result)
		get_tree().quit(1)
