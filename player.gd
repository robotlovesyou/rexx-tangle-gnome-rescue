class_name Player
extends CharacterBody2D

@export var movement_config: PlayerMovementConfig


var _action: Enums.Action = Enums.Action.NONE
var _direction: float = 1.0
var _last_direction: float = 1.0
var _has_jumped: bool = false
var _has_stopped_jump: bool = false
var _wall_jump_normal: Vector2


func _begin_action(action: Enums.Action) -> void:
	if action == _action: return
	_action = action
	# print(Enums.action_name(_action))
	ActionMonitor.action = _action

func _is_jumping() -> bool:
	# return true for any jumping action (jumping, double jumping, wall jumping)
	return _action == Enums.Action.JUMPING or _action == Enums.Action.DOUBLE_JUMPING or _action == Enums.Action.WALL_JUMPING

func _has_direction() -> bool:
	return _direction != 0.0


func _ready() -> void:
	_begin_action(Enums.Action.IDLING)
	
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
	_append_to_history(delta)

func _determine_direction() -> void:
	var temp_direciton = _direction
	if $WallJumpTimer.time_left > 0.0:
		_direction = _wall_jump_normal.x
	else:
		_direction = Input.get_axis("ui_left", "ui_right")

	if _direction:
		_last_direction = temp_direciton

func _determine_has_jumped_or_stopped() -> void:
	_has_jumped = Input.is_action_just_pressed("ui_accept")
	# if Input.is_action_just_pressed("ui_accept"):
	# 	_has_jumped = is_on_wall_only() or is_on_floor() or _action == Enums.Action.JUMPING or _action == Enums.Action.FALLING
	# else:
	# 	_has_jumped = false
	
	
	_has_stopped_jump = Input.is_action_just_released("ui_accept") and not is_on_floor()
		
func _determine_action() -> Enums.Action:
	var on_floor = is_on_floor()
	if is_on_wall_only() and _has_jumped:
		return Enums.Action.WALL_JUMPING
	if _has_jumped and _action == Enums.Action.JUMPING:
		return Enums.Action.DOUBLE_JUMPING
	if _has_jumped:
		return Enums.Action.JUMPING
	if is_on_wall_only():
		return Enums.Action.WALL_SLIDING_DOWN if velocity.y > 0.0 else Enums.Action.WALL_SLIDING_UP
	if not is_on_floor() and _is_jumping():
		return _action
	if not on_floor and not _is_jumping():
		if velocity.x > 0.0:
			return Enums.Action.JUMPING
		else:
			return Enums.Action.FALLING
	if on_floor and _has_direction():
		return Enums.Action.WALKING
	if on_floor and not _has_direction():
		return Enums.Action.IDLING

	return Enums.Action.NONE

func _handle_lateral_movement(delta:float) -> void:
	if _direction:
		velocity.x = move_toward(velocity.x, _direction * movement_config.SPEED, movement_config.ACCELERATION * delta)
	else:
		var friction = movement_config.ACCELERATION if is_on_floor() else movement_config.AIR_RESISTANCE
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func _handle_jump() -> void:
	if _has_jumped:
		if is_on_wall_only():
			velocity.y = movement_config.JUMP_VELOCITY
			_wall_jump_normal = get_wall_normal()
			velocity.x = movement_config.SPEED * _wall_jump_normal.x
			$WallJumpTimer.start()
		elif is_on_floor() or $CoyoteJumpTimer.time_left > 0.0:
			velocity.y = movement_config.JUMP_VELOCITY
			velocity += get_platform_velocity()
		elif not is_on_floor() and _action == Enums.Action.DOUBLE_JUMPING:
			velocity.y = movement_config.JUMP_VELOCITY * movement_config.DOUBLE_JUMP_SCALE
	elif _has_stopped_jump:
		velocity.y *= movement_config.SHORT_JUMP_SCALE
		

func _handle_coyote_timer(was_on_floor: bool) -> void:
	if was_on_floor and not is_on_floor() and velocity.y >= 0.0:
		$CoyoteJumpTimer.start()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if is_on_wall_only() and velocity.y >= 0.0:	
			velocity += get_gravity() * movement_config.WALL_SLIDE_SCALE * delta
			velocity.y = min(velocity.y, movement_config.WALL_SLIDE_MAX_SPEED)
		else:
			velocity += get_gravity() * delta

func _animate_action() -> void:
	if _has_direction():
		$AnimatedSprite2D.flip_h = _direction > 0.0
	else:
		$AnimatedSprite2D.flip_h = 	_last_direction > 0.0
		
	match _action:
		Enums.Action.WALKING:
			$AnimatedSprite2D.play("walk")
		Enums.Action.JUMPING, Enums.Action.DOUBLE_JUMPING, Enums.Action.FALLING:
			$AnimatedSprite2D.play("jump")
		Enums.Action.WALL_SLIDING_DOWN:
			$AnimatedSprite2D.play("wall_slide_down")
		Enums.Action.WALL_SLIDING_UP:
			$AnimatedSprite2D.play("wall_slide_up")
		_:
			$AnimatedSprite2D.play("idle")

func _append_to_history(delta: float) -> void:
	MovementHistory.append(position, get_platform_velocity() * delta, _action, $AnimatedSprite2D.flip_h)
