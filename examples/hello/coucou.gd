extends Node

func _ready() -> void:
	var node := HelloNode.new()
	print("HelloNode created!")
	var result := node.add(7.0, 6.0)
	print("hello.add(7.0, 6.0) = ", result)
	node.free()
