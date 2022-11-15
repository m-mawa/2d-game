 extends Actor

var pos = []
var linear_v = []
var last_v
var recording = true
var rewinding = false

export var stomp_impulse: = 600.0

onready var _animated_sprite = $AnimatedSprite

func _on_StompDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()


func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)
	var is_falling := _velocity.y > 0.0 and not is_on_floor()
	var is_jumping := Input.is_action_just_pressed("jump") and not is_on_floor()
	var is_idling := is_on_floor() and is_zero_approx(_velocity.x)
	var is_runningR := is_on_floor() and not is_zero_approx(_velocity.x) and Input.is_action_just_pressed("move_right")
	var is_runningL := is_on_floor() and not is_zero_approx(_velocity.x) and Input.is_action_just_pressed("move_left")
	
	#Анимации
	if is_idling:
		_animated_sprite.play("idle")
	if is_runningR:
		_animated_sprite.play("runR")
	if is_runningL:
		_animated_sprite.play("runL")
	if is_falling:
		_animated_sprite.play("fall")
	if is_jumping:
		_animated_sprite.play("jump")

	#перемотка времени
	if Input.is_action_just_pressed("rewind"):
		if rewinding:
			rewinding = false
			recording = true
		else:
			recording = false
			rewinding = true
	rewind_effect()

func rewind_effect():
	if recording:
		pos.append(global_position)
		linear_v.append(_velocity.x)
		if pos.size() > 240:
			pos.remove(0)
			linear_v.remove(0)
	if rewinding:
		if pos.size() > 0:
			global_position = pos[pos.size() - 1]
			last_v = linear_v[linear_v.size() - 1]
			pos.remove(pos.size() - 1)
			linear_v.remove(linear_v.size() - 1)
		else:
			_velocity.x = last_v
			rewinding = false
			recording = true
			
		

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity


func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)


func die() -> void:
	_animated_sprite.play("dead")
	PlayerData.deaths += 1
	queue_free()
