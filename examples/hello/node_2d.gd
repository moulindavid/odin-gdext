extends Node2D

func _ready():
	if ClassDB.class_exists("HelloNode"):
		var hello: HelloNode = ClassDB.instantiate("HelloNode")
		add_child(hello)
		print("HelloNode created!")
		var result: float = hello.add(7.0, 6.0)
		var result2 = hello.call("add", 7.0, 6.0)  # forces variant path
		print("hello.add(7.0, 6.0) = ", result)
		print("hello.call(add, 7.0, 6.0) = ", result2)
