class_name CarSmoothCameraOrigin
extends Node3D


#@export var tracking_speed := 10.0
@export var tracking_lerp_weight : float = 10.0
@export var car : CharacterBody3D

var speed_factor : float = 0.5

func _ready() -> void:
	top_level = true
	if not car:
		car = get_parent()

func _physics_process(delta: float) -> void:
	update_tracking(delta)

func update_tracking(delta:float) -> void:
	var target_position : Vector3 = car.global_position
	target_position += car.get_real_velocity() * speed_factor
	
	#global_position.move_toward(target_position, tracking_speed*delta)
	global_position = global_position.lerp(target_position, tracking_lerp_weight*delta)
