class_name SimplePath3D
extends Path3D


@export var follow_speed : float = 10.0
@export var loop : bool = true
@export var corner_wait := 3.0
@export var rotation_mode := PathFollow3D.ROTATION_NONE
var follows : Array[PathFollow3D] = []

var in_reverse : bool = false
var corner_wait_timer := 0.0

func _ready() -> void:
	_setup_children()

func _setup_children() -> void:
	corner_wait_timer = corner_wait
	var children := get_children()
	for child in children:
		remove_child(child)
		
		var follow = PathFollow3D.new()
		follow.loop = loop
		follow.rotation_mode = PathFollow3D.ROTATION_NONE
		follow.tilt_enabled = false
		follows.append(follow)
		
		add_child(follow, true)
		follow.add_child.call_deferred(child)
		#await follow.ready

func _physics_process(delta:float) -> void:
	_update_children(delta)

func _update_children(delta:float) -> void:
	for follow : PathFollow3D in follows:
		follow.progress += follow_speed * delta * (-1 if in_reverse else 1)
	
	
	if not loop and not follows.is_empty():
		var first_follow_ratio = follows[0].progress_ratio
		if first_follow_ratio == 0.0 or first_follow_ratio == 1.0:
			var should_reverse := false
			corner_wait_timer -= delta
			if corner_wait_timer <= 0.0:
				corner_wait_timer = corner_wait
				should_reverse = true
			
			if should_reverse:
				in_reverse = false if first_follow_ratio == 0.0 else true
	