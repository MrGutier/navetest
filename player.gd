extends CharacterBody3D

# How fast the player moves in meters per second.
@export var max_speed = 14

# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var sensitivity = 300
@export var acceleration=0.5
@export var acceleration_horizontal=0.25
@export var rotating_speed=0.05
@export var rotating_speed_z=0.04
var target_velocity = Vector3.ZERO


func _physics_process(delta):
	
	
	
	var input_direction = Vector3.ZERO
	
	if Input.is_action_pressed("control"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		input_direction.z += 1
	if Input.is_action_pressed("move_forward"):
		input_direction.z -= 1
	if Input.is_action_pressed("move_up"):
		input_direction.y += 1
	if Input.is_action_pressed("move_down"):
		input_direction.y -= 1
		
	if Input.is_action_pressed("rotate_right"):
		var rot_z=-rotating_speed_z
		rotate_object_local(Vector3(0, 0, 1), rot_z)
		$Camera_Controller.rotation.z=lerp_angle($Camera_Controller.rotation.z,rotation.z,0.1)
		
	if Input.is_action_pressed("rotate_left"):
		var rot_z=+rotating_speed_z
		rotate_object_local(Vector3(0, 0, 1), rot_z)
		$Camera_Controller.rotation.z=lerp_angle($Camera_Controller.rotation.z,rotation.z,0.1)


	# Moving the Character
	var direction = (transform.basis*Vector3(input_direction.x,input_direction.y,input_direction.z)).normalized()

	if direction:
		velocity.x=velocity.x+direction.x*acceleration
		velocity.y=velocity.y+direction.y*acceleration
		velocity.z=velocity.z+direction.z*acceleration
		if velocity.length()>max_speed:
			velocity=velocity.normalized()* max_speed
		print(velocity)
	
	velocity=velocity*0.99
	move_and_collide(velocity*delta)
	
	#make camera controller match the position of the player
	
	if !Input.is_action_pressed("camera_lock"):
		var a = Quaternion(transform.basis)
		var b = Quaternion($Camera_Controller.transform.basis)
		var c = a.slerp(b,rotating_speed)
		transform.basis = Basis(c)
	$Camera_Controller.position=lerp($Camera_Controller.position,position,0.1)

	
func _input(event):
	if event is InputEventMouseMotion:
		#var rot_x=-event.relative.x/sensitivity
		#var rot_y=-event.relative.y/sensitivity
		
		$Camera_Controller.rotate_object_local(Vector3(0, 1, 0), -event.relative.x/sensitivity)
		$Camera_Controller.rotate_object_local(Vector3(1, 0, 0), -event.relative.y/sensitivity)
		transform = transform.orthonormalized()
