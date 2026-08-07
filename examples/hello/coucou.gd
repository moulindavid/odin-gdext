extends Node

func _ready() -> void:
	var node: Object = ClassDB.instantiate("HelloNode")
	if node == null:
		push_error("HelloNode was not registered")
		get_tree().quit(1)
		return

	print("HelloNode created!")
	var result: Variant = node.call("add", 7.0, 6.0)
	print("hello.add(7.0, 6.0) = ", result)
	node.free()

	if result != 13.0:
		push_error("HelloNode.add returned %s, expected 13.0" % result)
		get_tree().quit(1)
