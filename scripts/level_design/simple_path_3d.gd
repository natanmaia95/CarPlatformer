class_name SimplePath3D
extends Path3D


@export var enabled : bool = true
@export var follow_speed : float = 10.0
@export var loop : bool = true
@export var corner_wait := 3.0
@export var rotation_mode := PathFollow3D.ROTATION_NONE
@export var starting_ratio : float = 0.0
var follows : Array[PathFollow3D] = []

var in_reverse : bool = false
var corner_wait_timer := 0.0

func toggle(new_value=null) -> void:
	if new_value == null: new_value = !enabled
	enabled = new_value

func _ready() -> void:
	corner_wait_timer = corner_wait
	_setup_children()

func _setup_children() -> void:
	var children := get_children()
	for child in children:
		#remove_child(child)
		
		var follow = PathFollow3D.new()
		follow.loop = loop
		follow.rotation_mode = PathFollow3D.ROTATION_NONE
		follow.tilt_enabled = false
		#follow.progress_ratio = starting_ratio
		follows.append(follow)
		
		add_child(follow, true)
		child.reparent(follow)
		follow.set_deferred("progress_ratio", starting_ratio)
		#await follow.ready

func _physics_process(delta:float) -> void:
	_update_children(delta)

func _update_children(delta:float) -> void:
	if not enabled: 
		corner_wait_timer = 0.0
		return
	
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
		else:
			corner_wait_timer = corner_wait
	
	
