extends Node2D


func _ready():
	if ClassDB.class_exists("HelloNode"):
		var hello = ClassDB.instantiate("HelloNode")
		add_child(hello)
		print("HelloNode created!")
		var result = hello.add(3.0, 5.0)
		print("add(3.0, 5.0) = ", result)
	else:
		print("HelloNode not found — extension loaded?")
