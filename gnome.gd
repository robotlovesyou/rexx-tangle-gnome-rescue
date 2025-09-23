class_name Gnome
extends CharacterBody2D


# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0

var _action: Enums.GnomeAction
var _state: GnomeState

func _ready() -> void:
	_begin_action(Enums.GnomeAction.GROUNDED)
	_switch_to_state(GnomeWaitState.new(self))
	ActionMonitor.began_action.connect(_player_began_action)

func _begin_action(action: Enums.GnomeAction) -> void:
	if action == _action: return
	_action = action

func _player_began_action(action: Enums.Action) -> void:
	print("player began action: %s" % Enums.action_name(action))

func _switch_to_state(state: GnomeState) -> void:
	if _state: _state.on_exit_state()
	_state = state
	_state.on_enter_state()

func _handle_gnome_event(event: Enums.GnomeEvent) -> void:
	match _state.state_id():
		GnomeState.StateID.WAITING:
			match event:
				Enums.GnomeEvent.PLAYER_COLLECTED:
					_switch_to_state(GnomeCollectedState.new(self))
		


func _physics_process(delta: float) -> void:
	pass
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# # Get the input direction and handle the movement/deceleration.
	# # As good practice, you should replace UI actions with custom gameplay actions.
	# var direction := Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)

	# move_and_slide()


func _on_player_collection_body_entered(body:Node2D) -> void:
	if body is Player:
		_handle_gnome_event(Enums.GnomeEvent.PLAYER_COLLECTED)
