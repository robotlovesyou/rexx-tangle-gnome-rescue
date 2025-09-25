class_name Gnome
extends CharacterBody2D


# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0

@export var movement_config: PlayerMovementConfig
var _action: Enums.GnomeAction
var _player_action: Enums.Action
var _touching_player: bool = false
var _state: GnomeState
var _follow_index: int


var follow_index: int:
	get:
		return _follow_index

func _ready() -> void:
	_begin_action(Enums.GnomeAction.GROUNDED)
	_switch_to_state(GnomeWaitState.new(self))
	ActionMonitor.began_action.connect(_player_began_action)

func _begin_action(action: Enums.GnomeAction) -> void:
	if action == _action: return
	_action = action
	print("Gnome Action: %s" % Enums.gnome_action_name(_action))
	match _action:
		Enums.GnomeAction.AIRBORNE:
			_handle_gnome_event(Enums.GnomeEvent.BECAME_AIRBORNE)
		Enums.GnomeAction.GROUNDED:
			_handle_gnome_event(Enums.GnomeEvent.BECAME_GROUNDED)

func _player_began_action(action: Enums.Action) -> void:
	print("player began action: %s" % Enums.action_name(action))
	_player_action = action
	match _player_action:
		Enums.Action.IDLING:
			_handle_gnome_event(Enums.GnomeEvent.PLAYER_BECAME_IDLE)
		_:
			_handle_gnome_event(Enums.GnomeEvent.PLAYER_STOPPED_IDLING)


func _switch_to_state(state: GnomeState) -> void:
	if _state: _state.on_exit_state()
	_state = state
	_state.on_enter_state()
	print("Gnome switched to state: %s" % _state.state_name())

func _handle_gnome_event(event: Enums.GnomeEvent) -> void:
	match _state.state_id():
		GnomeState.StateID.WAITING:
			match event:
				Enums.GnomeEvent.PLAYER_COLLECTED:
					_switch_to_state(GnomeCollectedState.new(self))
		GnomeState.StateID.COLLECTED:
			match event:
				Enums.GnomeEvent.COLLECTION_DONE:
					_switch_to_state(GnomeLerpFollowState.new(self))
		GnomeState.StateID.LERP_FOLLOW:
			match event:
				Enums.GnomeEvent.LERP_FOLLOW_DONE:
					if _should_enter_stray():
						_switch_to_state(GnomeStrayState.new(self))
					else:
						_switch_to_state(GnomeFollowState.new(self))
		GnomeState.StateID.FOLLOW:
			match event:
				Enums.GnomeEvent.BECAME_GROUNDED, Enums.GnomeEvent.PLAYER_COLLECTED, Enums.GnomeEvent.PLAYER_BECAME_IDLE:
					if _should_enter_stray():
						_switch_to_state(GnomeStrayState.new(self))
		GnomeState.StateID.STRAY:
			match event: 
				Enums.GnomeEvent.PLAYER_STOPPED_IDLING:
					_switch_to_state(GnomeLerpFollowState.new(self))
		


func _physics_process(delta: float) -> void:
	_state.on_physics_process(delta)
	_state.on_animate($AnimatedSprite2D)
	if is_on_floor():
		_begin_action(Enums.GnomeAction.GROUNDED)
	else:
		_begin_action(Enums.GnomeAction.AIRBORNE)
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
		_touching_player = true
		_handle_gnome_event(Enums.GnomeEvent.PLAYER_COLLECTED)

func _on_player_collection_body_exited(body: Node2D) -> void:
	if body is Player:
		_touching_player = false

func collection_complete(index: int) -> void:
	_follow_index = index
	_handle_gnome_event(Enums.GnomeEvent.COLLECTION_DONE)

func lerp_follow_complete():
	_handle_gnome_event(Enums.GnomeEvent.LERP_FOLLOW_DONE)

func _should_enter_stray() -> bool:
	return _action == Enums.GnomeAction.GROUNDED and _player_action == Enums.Action.IDLING and _touching_player
