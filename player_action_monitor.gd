class_name PlayerActionMonitor
extends Node

signal began_action(action: Enums.Action)

var _action: Enums.Action = Enums.Action.NONE

func _ready() -> void:
    print("action monitor ready")

var action: Enums.Action:
    get:
        return _action
    set(value):
        _action = value
        began_action.emit(_action)