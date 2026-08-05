extends Node2D


func _ready():
	if ClassDB.class_exists("HelloNode"):
		var hello = ClassDB.instantiate("HelloNode")
		add_child(hello)
		print("HelloNode created!")
	else:
		print("HelloNode not found — extension loaded?")
