extends Node

@onready var result_label: Label = $Label

var hello_node: Object
var speed_changes: Array[float] = []

func _ready() -> void:
    hello_node = ClassDB.instantiate("HelloNode")
    if hello_node == null:
        push_error("HelloNode was not registered")
        get_tree().quit(1)
        return

    add_child(hello_node)
    hello_node.connect("speed_changed", _on_speed_changed)
    hello_node.speed = 2.0
    update_label_from_odin()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
        update_label_from_odin()

func update_label_from_odin() -> void:
    if hello_node == null:
        return
    var value: float = hello_node.call("roll_math")
    result_label.text = "Space calls Odin roll_math(): %.3f at speed %.1f" % [value, hello_node.speed]

func _on_speed_changed(value: float) -> void:
    speed_changes.append(value)
    print("Odin speed changed: ", value)

func _exit_tree() -> void:
    if hello_node != null:
        hello_node.queue_free()
        hello_node = null
