extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
		target_velocity.x = direction.x * speed
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		target_velocity.x = direction.x * speed
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
		target_velocity.z = direction.z * speed
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		target_velocity.z = direction.z * speed
	if Input.is_action_pressed("move_up"):
		target_velocity.y = speed
	if Input.is_action_pressed("move_down"):
		target_velocity.y = -speed
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# Moving the Character
	velocity = target_velocity
	target_velocity = target_velocity*0.95
	move_and_slide()
