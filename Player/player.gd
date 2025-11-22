class_name Player
extends CharacterBody2D

@export var movement_config: PlayerMovementConfig

class PlayerState:
	var _parent: Player

	func _init(parent: Player):
		_parent = parent

	func on_enter() -> void:
		pass

	func on_exit() -> void:
		pass

	func on_physics_process(delta: float) -> void:
		pass

	func on_animate(animated_sprite: AnimatedSprite2D) -> void:
		pass

class AliveState:
	extends PlayerState

	var _action: Enums.Action = Enums.Action.NONE
	var _direction: float = 1.0
	var _last_direction: float = 1.0
	var _has_jumped: bool = false
	var _has_stopped_jump: bool = false
	var _wall_jump_normal: Vector2
	var _killed_enemy_last_frame := false

	func on_enter() -> void:
		_begin_action(Enums.Action.IDLING)

	func on_physics_process(delta: float) -> void:
		var was_on_floor = _parent.is_on_floor()
		_determine_direction()
		_determine_has_jumped_or_stopped()
		_begin_action(_determine_action())
		_apply_gravity(delta)

		_handle_jump()
		_handle_lateral_movement(delta)
		
		_parent.move_and_slide()
		_check_for_enemy_collision()
		_handle_coyote_timer(was_on_floor)
		# _animate_action()
		_append_to_history(delta)

	func _begin_action(action: Enums.Action) -> void:
		if action == _action: return
		print(Enums.action_name(action))
		_action = action
		ActionMonitor.action = _action

	func _is_jumping() -> bool:
		# return true for any jumping action (jumping, double jumping, wall jumping)
		return _action == Enums.Action.JUMPING or _action == Enums.Action.DOUBLE_JUMPING or _action == Enums.Action.DOUBLE_JUMPED or _action == Enums.Action.WALL_JUMPING

	func _has_direction() -> bool:
		return _direction != 0.0

	func _check_for_enemy_collision():
		for i in _parent.get_slide_collision_count():
			var collision = _parent.get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("Enemy"):
				var angle = collision.get_normal().angle_to(Vector2.UP)
				if abs(angle) < 0.5: #45º
					_killed_enemy_last_frame = true
					Events.player_killed_enemy_async(collider as CharacterBody2D)
				else:
					Events.player_hit_enemy_async(collider as CharacterBody2D)
				

	func _determine_direction() -> void:
		var temp_direciton = _direction
		if _parent.wall_jump_timer.time_left > 0.0:
			_direction = _wall_jump_normal.x
		else:
			_direction = Input.get_axis("ui_left", "ui_right")

		if _direction:
			_last_direction = temp_direciton

	func _determine_has_jumped_or_stopped() -> void:
		_has_jumped = Input.is_action_just_pressed("ui_accept")
		_has_stopped_jump = Input.is_action_just_released("ui_accept") and not _parent.is_on_floor()
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
		if _parent.is_on_wall_only() and _has_jumped:
			return Enums.Action.WALL_JUMPING
		if _has_jumped and _action == Enums.Action.JUMPING:
			return Enums.Action.DOUBLE_JUMPING
		if _is_jumping() and _action == Enums.Action.DOUBLE_JUMPING: 
			return Enums.Action.DOUBLE_JUMPED
		if _has_jumped and !_is_jumping():
			return Enums.Action.JUMPING
		if _parent.is_on_wall_only():
			return Enums.Action.WALL_SLIDING_DOWN if _parent.velocity.y > 0.0 else Enums.Action.WALL_SLIDING_UP
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
			if _parent.is_on_wall_only():
				_parent.velocity.y = _parent.movement_config.JUMP_VELOCITY
				_wall_jump_normal = _parent.get_wall_normal()
				_parent.velocity.x = _parent.movement_config.SPEED * _wall_jump_normal.x
				_parent.wall_jump_timer.start()
			elif _parent.is_on_floor() or _parent.coyote_jump_timer.time_left > 0.0:
				_parent.velocity.y = _parent.movement_config.JUMP_VELOCITY
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
			if _parent.is_on_wall_only() and _parent.velocity.y >= 0.0:	
				_parent.velocity += _parent.get_gravity() * _parent.movement_config.WALL_SLIDE_SCALE * delta
				_parent.velocity.y = min(_parent.velocity.y, _parent.movement_config.WALL_SLIDE_MAX_SPEED)
			else:
				_parent.velocity += _parent.get_gravity() * delta

	func on_animate(animated_sprite: AnimatedSprite2D) -> void:
		if _has_direction():
			animated_sprite.flip_h = _direction > 0.0
		else:
			animated_sprite.flip_h = 	_last_direction > 0.0
			
		match _action:
			Enums.Action.WALKING, Enums.Action.PLATFORM_WALKING:
				animated_sprite.play( "walk")
			Enums.Action.JUMPING, Enums.Action.DOUBLE_JUMPING, Enums.Action.FALLING:
				animated_sprite.play("jump")
			Enums.Action.WALL_SLIDING_DOWN:
				animated_sprite.play("wall_slide_down")
			Enums.Action.WALL_SLIDING_UP:
				animated_sprite.play("wall_slide_up")
			_:
				animated_sprite.play("idle")

	func _append_to_history(delta: float) -> void:
		MovementHistory.append(_parent.position, _parent.get_platform_velocity() * delta, _action, _parent.animated_sprite.flip_h)

class AppearState:
	extends PlayerState

	const EXIT_STATE_AFTER_SECONDS := 1.0
	const PARTICLES_INITIAL_Y = -12
	const PARTICLES_FINAL_Y = 15

	var _time := 0.0

	func on_enter() -> void:
		_parent.animated_sprite.flip_h = true
		_parent.animated_sprite.play("appear")
		_parent.appear_particles.emitting = true
		_parent.appear_particles.position.y = PARTICLES_INITIAL_Y

	func on_exit() -> void:
		_parent.appear_particles.emitting = false

	func on_physics_process(delta: float) -> void:
		_time += delta
		_parent.appear_particles.position.y = (PARTICLES_FINAL_Y - PARTICLES_INITIAL_Y) * (_time / EXIT_STATE_AFTER_SECONDS) + PARTICLES_INITIAL_Y
		if _time > EXIT_STATE_AFTER_SECONDS:
			_parent.done_appearing()


var _state: PlayerState

var wall_jump_timer: Timer:
	get: return $WallJumpTimer

var coyote_jump_timer: Timer:
	get: return $CoyoteJumpTimer

var animated_sprite: AnimatedSprite2D:
	get: return $AnimatedSprite2D

var appear_particles: GPUParticles2D:
	get: return $AppearParticles

func _ready() -> void:
	_switch_to_state(AppearState.new(self))

func done_appearing() -> void:
	_switch_to_state(AliveState.new(self))

func _switch_to_state(state: PlayerState) -> void:
	if _state: _state.on_exit()
	_state = state
	_state.on_enter()

	
func _physics_process(delta: float) -> void:
	_state.on_physics_process(delta)
	_state.on_animate(animated_sprite)

func get_camera() -> Camera2D:
	return $Camera2D
