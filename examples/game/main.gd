extends Node

@onready var label: Label = $Label

var brain: Object
var roll_count := 0

func _ready() -> void:
    brain = ClassDB.instantiate("GameBrain")
    if brain == null:
        push_error("GameBrain was not registered")
        get_tree().quit(1)
        return

    add_child(brain)
    brain.connect("damage_rolled", _on_damage_rolled)
    brain.difficulty = 2.0
    _roll_once()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
        _roll_once()

func _roll_once() -> void:
    brain.call("roll_into_label", label)

func _on_damage_rolled(value: float) -> void:
    roll_count += 1
    print("Odin damage roll %d: %s" % [roll_count, value])

func _exit_tree() -> void:
    if brain != null:
        brain.queue_free()
        brain = null
