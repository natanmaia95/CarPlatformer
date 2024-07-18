extends CharacterBody3D

@export var bounce_on_walls := false

var boost_timer := 0.0

var steering_speed = 220

var was_on_floor_last_frame := false
var velocity_last_frame := Vector3.ZERO

func _physics_process(delta):
	if boost_timer > 0:
		boost_timer -= delta
	
	align_up_with_floor(delta)
	

	
	var steering = Input.get_axis("ui_left", "ui_right")
	#if boost_timer > 0:
		#steering *= 1.5
	if get_speed() > 3.0:
		global_rotate(global_basis.y, -steering * deg_to_rad(steering_speed) * delta)
	
	# apply skid drag
	velocity -= velocity.project(global_transform.basis.x) * 5.0 * delta 
	# apply rolling drag
	velocity -= velocity.project(-global_transform.basis.z) * 3.0 * delta
	
	# apply engine
	velocity += -global_basis.z * Input.get_action_strength("ui_up") * 70 * delta
	# apply boost
	var boost_input = Input.get_action_strength("ui_accept")
	if boost_input and boost_timer <= 0:
		boost_timer = 0.5
		velocity += -global_basis.z * 30
	#if boost_timer > 0:
		#velocity += -global_basis.z * 20 * delta
	
	# jump
	#if was_on_floor_last_frame:
		#print("was on floor")
		#if not is_on_floor():
			#
	#else:
		#print("was already falling")
	if was_on_floor_last_frame and not is_on_floor() and boost_timer > 0:
		velocity = velocity.normalized() * 20
		velocity += Vector3.UP * 10
		$AnimationPlayer.play("jump")
		print("jump")
	
	# bounce on wall
	if is_on_wall():
		var normal = Vector3(get_wall_normal().x, 0, get_wall_normal().z).normalized()
		var collision := get_last_slide_collision()
		if bounce_on_walls:
			velocity = velocity.bounce(normal)
			look_at(global_position + (-global_basis.z).bounce(normal), global_basis.y)
			move_and_slide()
		else:
			#velocity = velocity.bounce(normal) * 5
			print(velocity_last_frame)
			#velocity = velocity_last_frame.bounce(normal) * 0.5
			velocity = velocity_last_frame.bounce(normal).normalized() * 10
			move_and_slide()
	
	# apply gravity
	velocity += Vector3.DOWN * 40.0 * delta
	
	
	was_on_floor_last_frame = is_on_floor()
	velocity_last_frame = velocity
	move_and_slide()
	



func _process(delta):
	var skid_amount = velocity.normalized().cross(global_basis.z).y * 2 * min(1.0, get_speed()*0.5)
	#print(skid_amount)
	var old_skid_bs = $AnimationTree.get("parameters/skid_bs/blend_position")
	$AnimationTree.set("parameters/skid_bs/blend_position", move_toward(old_skid_bs, skid_amount, 8 * delta))
	
	#if is_on_floor():
		#look_at(global_position - global_basis.z, get_floor_normal())


func align_up_with_floor(delta):
	var up : Vector3
	if is_on_floor():
		up = get_floor_normal()
		if up == Vector3.ZERO: return
	else:
		up = Vector3.UP
	basis = lerp(basis, align_up(basis, up), delta*10.0).orthonormalized()

func align_up(node_basis, normal):
	var result = Basis()
	var scale = node_basis.get_scale() # Only if your node might have a scale other than (1,1,1)
	
	result.x = normal.cross(node_basis.z)
	result.y = normal
	result.z = node_basis.x.cross(normal)
	
	result = result.orthonormalized()
	result.x *= scale.x 
	result.y *= scale.y 
	result.z *= scale.z 
	
	return result


func get_speed():
	var real = get_real_velocity()
	var speed = (real - real.project(global_basis.y)).length()
	return speed
