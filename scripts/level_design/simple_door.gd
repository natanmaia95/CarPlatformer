@tool
class_name SimpleDoor
extends Node3D


@export var is_open : bool = false:
	set(value):
		is_open = value
		do_animation()
		#if is_open: do_open()
		#else: do_close()
		#if Engine.is_editor_hint() and anim_player:
			#anim_player.seek(anim_player.current_animation_length)


@export_category("Internal")
## Do not change this.
@export var set_up : bool = false
@export var anim_player : AnimationPlayer = null


func toggle(new_value=null) -> void:
	if new_value == null: new_value = !is_open
	is_open = new_value


func do_open() -> void:
	if anim_player.has_animation("open"):
		anim_player.play("open")
		anim_player.speed_scale = 1.0
	else:
		push_error("SimpleDoor %s has no \'open\' animation!" % self)


func do_close() -> void:
	#if anim_player.has_animation("close"):
		#anim_player.play("close")
	#else:
		#push_error("SimpleDoor %s has no \'close\' animation!" % self)
	if anim_player.has_animation("close"):
		var anim_pos = anim_player.current_animation_position
		anim_player.play("open")
		anim_player.seek(anim_pos)
		#anim_player.speed_scale = -1.0
	else:
		push_error("SimpleDoor %s has no \'close\' animation!" % self)


func do_animation() -> void:
	if !anim_player.has_animation("open"):
		push_error("SimpleDoor %s has no \'open\' animation!" % self)
		return
	
	var anim_pos = 0.0 if is_open else 1.0
	if anim_player.current_animation: anim_pos = anim_player.current_animation_position
	print(anim_pos," ", anim_player.current_animation)
	anim_player.play("open", -1, 1.0, false if is_open else true)
	#anim_player.seek(anim_pos, true, true)
	anim_player.speed_scale = 1.0 if is_open else -1.0
	#print(anim_pos," ", anim_player.current_animation)


func _ready() -> void:
	if not set_up and Engine.is_editor_hint():
		set_up = true
		anim_player = AnimationPlayer.new()
		anim_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
		add_child(anim_player, true)
		anim_player.owner = get_tree().edited_scene_root
		return


func _get_configuration_warnings():
	var return_array = []
	if !anim_player.has_animation("open"): return_array.append("No \'open\' animation.")
	if !anim_player.has_animation("close"): return_array.append("No \'close\' animation.")
	return return_array
