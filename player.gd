extends CharacterBody2D

@export var movement_config: PlayerMovementConfig


enum Action {NONE, IDLE, FALLING, WALKING, JUMPING}
func _action_name(action: Action) -> String: return Action.find_key(int(action))

signal began_action(Action)


# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0

var _action: Action = Action.NONE
var _direction: float = 1.0
var _last_direction: float = 1.0
var _has_jumped: bool = false
var _has_stopped_jump: bool = false


func _begin_action(action: Action) -> void:
	if action == _action: return
	print(_action_name(action))
	_action = action
	began_action.emit(_action)

func _is_jumping() -> bool:
	# return true for any jumping action (jumping, double jumping, wall jumping)
	return _action == Action.JUMPING

func _has_direction() -> bool:
	return _direction != 0.0


func _ready() -> void:
	_begin_action(Action.IDLE)
	
func _physics_process(delta: float) -> void:
	var was_on_floor = is_on_floor()
	_determine_direction()
	_determine_has_jumped_or_stopped()
	_begin_action(_determine_action())
	_apply_gravity(delta)

	_handle_jump()
	_handle_lateral_movement(delta)
	
	move_and_slide()
	_handle_coyote_timer(was_on_floor)
	_animate_action()

func _determine_direction() -> void:
	var temp_direciton = _direction
	_direction = Input.get_axis("ui_left", "ui_right")
	if _direction:
		_last_direction = temp_direciton

func _determine_has_jumped_or_stopped() -> void:
	_has_jumped = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	_has_stopped_jump = Input.is_action_just_released("ui_accept") and not is_on_floor()
		
func _determine_action() -> Action:
	var on_floor = is_on_floor()
	if _has_jumped or not on_floor and _is_jumping():
		return Action.JUMPING
	if not on_floor and not _is_jumping():
		return Action.FALLING
	if on_floor and _has_direction():
		return Action.WALKING
	if on_floor and not _has_direction():
		return Action.IDLE

	return Action.NONE

func _handle_lateral_movement(delta:float) -> void:
	if _direction:
		velocity.x = move_toward(velocity.x, _direction * movement_config.SPEED, movement_config.ACCELERATION * delta)
	else:
		var friction = movement_config.ACCELERATION if is_on_floor() else movement_config.AIR_RESISTANCE
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func _handle_jump() -> void:
	if _has_jumped:
		if is_on_floor() or $CoyoteJumpTimer.time_left > 0.0:
			velocity.y = movement_config.JUMP_VELOCITY
			velocity += get_platform_velocity()
	elif _has_stopped_jump:
		velocity.y *= movement_config.SHORT_JUMP_SCALE
		# if is_on_wall_only():
		# 	velocity.y = player_movement_config.JUMP_VELOCITY
		# 	wall_jump_normal = get_wall_normal()
		# 	velocity.x = player_movement_config.SPEED * wall_jump_normal.x
		# 	$WallJumpTimer.start()
		# 	has_double_jumped = false
		# elif is_on_floor() or $CoyoteJumpTimer.time_left > 0.0:
		# 	velocity.y = player_movement_config.JUMP_VELOCITY
		# 	velocity += get_platform_velocity()
		# 	has_double_jumped = false
		# elif not has_double_jumped:
		# 	velocity.y = player_movement_config.JUMP_VELOCITY
		# 	has_double_jumped = true

func _handle_coyote_timer(was_on_floor: bool) -> void:
	if was_on_floor and not is_on_floor() and velocity.x >= 0.0:
		$CoyoteJumpTimer.start()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if is_on_wall_only() and velocity.y >= 0.0:
			pass
		# 	velocity += get_gravity() * player_movement_config.WALL_SLIDE_SCALE * delta
		# 	velocity.y = min(velocity.y, player_movement_config.WALL_SLIDE_MAX_SPEED)
		else:
			velocity += get_gravity() * delta

func _animate_action() -> void:
	if _has_direction():
		$AnimatedSprite2D.flip_h = _direction > 0.0
	else:
		$AnimatedSprite2D.flip_h = 	_last_direction > 0.0
		
	match _action:
		Action.WALKING:
			$AnimatedSprite2D.play("walk")
		_:
			$AnimatedSprite2D.play("idle")

