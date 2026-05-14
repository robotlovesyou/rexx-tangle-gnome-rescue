class_name AliveStrategy
extends PlayerStrategy

var _action: Enums.Action = Enums.Action.NONE
var _previous_action: Enums.Action = Enums.Action.NONE
var _direction: float = 1.0
var _last_direction: float = 1.0
var _has_jumped: bool = false
var _has_stopped_jump: bool = false
var _wall_jump_normal: Vector2
var _killed_enemy_last_frame := false
var _input_strategy: InputStrategy

func on_enter() -> void:
	_input_strategy = StandardInputStrategy.new()
	_begin_action(Enums.Action.IDLING)

func on_exit() -> void:
	_parent.stop_playing_walk()
	
# This function is intended to be used in subclasses to modify the player's velocity
func _modify_velocity(velocity: Vector2) -> Vector2:
	return velocity

func on_physics_process(delta: float) -> void:
	_previous_action = _action
	var previous_velocity = _parent.velocity
	var was_on_floor = _parent.is_on_floor()

	_determine_direction()
	_determine_has_jumped_or_stopped()
	_begin_action(_determine_action())
	_play_action()
	_apply_gravity(delta)

	_handle_jump()
	_handle_lateral_movement(delta)
	
	_parent.velocity = _modify_velocity(_parent.velocity)
	_parent.move_and_slide()
	_check_falling()
	_check_for_enemy_collision(previous_velocity)
	_handle_coyote_timer(was_on_floor)
	_append_to_history(delta)
	_show_debug_message()
	
func _check_falling() -> void:
	if _parent.velocity.y > _parent.movement_config.MAX_SAFE_FALL_SPEED:
		_parent.start_falling()
	
func _show_debug_message() -> void:
	pass
	#_parent.set_debug_text("%s" % _parent.velocity.y)
	
func _action_did_change() -> bool: return _action != _previous_action

func _action_still_walking() -> bool:
	const _walking_actions = [Enums.Action.WALKING, Enums.Action.PLATFORM_WALKING]
	return _previous_action in _walking_actions and _action in _walking_actions

func _begin_action(action: Enums.Action) -> void:
	if action == _action: return
	# print("%s => %s" % [Enums.action_name(_action), Enums.action_name(action)])
	_action = action
	ActionMonitor.action = _action

func _is_jumping() -> bool:
	# return true for any jumping action (jumping, double jumping, wall jumping)
	return _action == Enums.Action.JUMPING or _action == Enums.Action.DOUBLE_JUMPING or _action == Enums.Action.DOUBLE_JUMPED or _action == Enums.Action.WALL_JUMPING

func _is_skidding() -> bool:
	return _parent.is_on_floor() and abs(_parent.velocity.x) > 100.0 and ((_direction != 0.0 and sign(_direction) != sign(_parent.velocity.x)) or _direction == 0.0)

func _has_direction() -> bool:
	return _direction != 0.0

func _check_for_enemy_collision(velocity_before_collision: Vector2):
	for i in _parent.get_slide_collision_count():
		var collision = _parent.get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Enemy"):
			# var angle = collision.get_normal().angle_to(Vector2.UP)
			var point_relative_to_enemy = _parent.position - collider.global_position
			# print(point_relative_to_enemy)
			# if abs(angle) < 0.5: #45º
			# SUPER HACKY, am I above the enemy and moving down. Works so far...
			if point_relative_to_enemy.y < -10.0 and velocity_before_collision.y > 0.0:
				_killed_enemy_last_frame = true
				Events.player_killed_enemy_async(collider as CharacterBody2D)
			else:
				Events.player_hit_enemy_async(collider as CharacterBody2D)
		if collider.is_in_group("Ghost"):
			Events.player_hit_ghost_async(collider as PathFollowerGhost)

func _determine_direction() -> void:
	var temp_direction = _direction
	if _parent.wall_jump_timer.time_left > 0.0:
		_direction = _wall_jump_normal.x
	else:
		_direction = _input_strategy.get_h_axis()

	if _direction:
		_last_direction = temp_direction

func _determine_has_jumped_or_stopped() -> void:
	_has_jumped = _input_strategy.just_pressed_jump()
	_has_stopped_jump = _input_strategy.just_released_jump() and not _parent.is_on_floor() and _parent.velocity.y <= 0
	# if Input.is_action_just_pressed("ui_accept"):
	# 	_has_jumped = is_on_wall_only() or is_on_floor() or _action == Enums.Action.JUMPING or _action == Enums.Action.FALLING
	# else:
	# 	_has_jumped = false

func _is_on_platform() -> bool:
	if not _parent.is_on_floor(): return false
	for i in range(_parent.get_slide_collision_count()):
		var collision = _parent.get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Node:
			if (collider as Node).is_in_group("MovingPlatform"):
				if collision.get_normal().angle_to(Vector2.UP) <= _parent.floor_max_angle:
					return true
	return false
		
func _determine_action() -> Enums.Action:
	var on_floor = _parent.is_on_floor()
	var on_platform = _is_on_platform()
	if _parent.is_cast_on_wall_only() and _has_jumped:
		return Enums.Action.WALL_JUMPING
	if _has_jumped and _action == Enums.Action.JUMPING:
		return Enums.Action.DOUBLE_JUMPING
	if _is_jumping() and _action == Enums.Action.DOUBLE_JUMPING: 
		return Enums.Action.DOUBLE_JUMPED
	if _has_jumped and !_is_jumping():
		return Enums.Action.JUMPING
	if _parent.is_cast_on_wall_only():
		return Enums.Action.WALL_SLIDING
	if not on_floor and _is_jumping():
		return _action
	if not on_floor and not _is_jumping():
		if _parent.velocity.x > 0.0:
			return Enums.Action.JUMPING
		else:
			return Enums.Action.FALLING
	if on_floor and on_platform and _has_direction():
		return Enums.Action.PLATFORM_WALKING
	if on_floor and on_platform:
		return Enums.Action.PLATFORM_IDLING
	if on_floor and _has_direction():
		return Enums.Action.WALKING
	if on_floor and not _has_direction():
		return Enums.Action.IDLING

	return Enums.Action.NONE

func _handle_lateral_movement(delta:float) -> void:
	if _direction:
		_parent.velocity.x = move_toward(_parent.velocity.x, _direction * _parent.movement_config.SPEED, _parent.movement_config.ACCELERATION * delta)
	else:
		var friction = _parent.movement_config.ACCELERATION if _parent.is_on_floor() else _parent.movement_config.AIR_RESISTANCE
		_parent.velocity.x = move_toward(_parent.velocity.x, 0, friction * delta)

func _handle_jump() -> void:
	if _has_jumped:
		if _parent.is_cast_on_wall_only():
			_parent.velocity.y = _parent.movement_config.JUMP_VELOCITY
			_wall_jump_normal = _parent.get_cast_wall_normal()
			_parent.velocity.x = _parent.movement_config.SPEED * _wall_jump_normal.x
			_parent.wall_jump_timer.start()
		elif _parent.is_on_floor() or _parent.coyote_jump_timer.time_left > 0.0:
			_parent.velocity.y = _parent.movement_config.JUMP_VELOCITY
			if _is_on_platform():
				_parent.velocity += _parent.get_platform_velocity()
		elif not _parent.is_on_floor() and _action == Enums.Action.DOUBLE_JUMPING:
			_parent.velocity.y = _parent.movement_config.JUMP_VELOCITY * _parent.movement_config.DOUBLE_JUMP_SCALE
	elif _has_stopped_jump:
		_parent.velocity.y *= _parent.movement_config.SHORT_JUMP_SCALE
	elif _killed_enemy_last_frame:
		_parent.velocity.y = _parent.movement_config.JUMP_VELOCITY * _parent.movement_config.DOUBLE_JUMP_SCALE
		_killed_enemy_last_frame = false
		

func _handle_coyote_timer(was_on_floor: bool) -> void:
	if was_on_floor and not _parent.is_on_floor() and _parent.velocity.y >= 0.0:
		_parent.coyote_jump_timer.start()

func _apply_gravity(delta: float) -> void:
	if not _parent.is_on_floor():
		if _parent.is_cast_on_wall_only() and _parent.velocity.y >= 0.0:	
			_parent.velocity += _parent.get_gravity() * _parent.movement_config.WALL_SLIDE_SCALE * delta
			_parent.velocity.y = min(_parent.velocity.y, _parent.movement_config.WALL_SLIDE_MAX_SPEED)
		else:
			_parent.velocity += _parent.get_gravity() * delta
			
func _determine_flip() -> bool:
	var flip := false
	if _has_direction():
		flip = _direction > 0.0
	else:
		flip = _last_direction > 0.0
	
	return flip

func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.flip_h = _determine_flip()

	var jump_emitting := false
		
	match _action:
		Enums.Action.WALKING, Enums.Action.PLATFORM_WALKING:
			animated_sprite.play( "walk")
		Enums.Action.JUMPING, Enums.Action.DOUBLE_JUMPING, Enums.Action.DOUBLE_JUMPED, Enums.Action.WALL_JUMPING, Enums.Action.FALLING:
			if _action_did_change():
				animated_sprite.stop()
			animated_sprite.play("jump")
			jump_emitting = true
		Enums.Action.WALL_SLIDING:
			if _action_did_change():
				animated_sprite.play("wall_hit")
		_:
			animated_sprite.play("idle")

	_parent.jump_particles.emitting = jump_emitting

func _append_to_history(delta: float) -> void:
	_parent.append_to_history(delta, _action)

func _play_action() -> void:
	if _is_skidding():
		_parent.play_skid()
	else:
		_parent.stop_skid()

	if !_action_did_change(): return
	if !_action_still_walking():
		_parent.stop_playing_walk()
	match _action:
		Enums.Action.WALKING, Enums.Action.PLATFORM_WALKING:
			_parent.play_walk()
		Enums.Action.JUMPING, Enums.Action.DOUBLE_JUMPING, Enums.Action.WALL_JUMPING:
			_parent.play_jump()
