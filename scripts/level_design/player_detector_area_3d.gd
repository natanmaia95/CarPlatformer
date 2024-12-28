@tool
class_name PlayerDetectorArea3D
extends Area3D

## PLAYER_CLASS = PlayerCar
const PLAYER_HURTBOX_LAYER : int = 13


func on_player_entered(_player) -> void:
	print_debug("player detected!")

func on_player_exited(_player) -> void:
	print_debug("player undetected!")

func toggle(new_value=null) -> void:
	if new_value == null: new_value = !monitoring
	monitoring = new_value

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	monitorable = false
	set_collision_mask_value(PLAYER_HURTBOX_LAYER, true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body:Node3D) -> void:
	on_player_entered(body)

func _on_body_exited(body:Node3D) -> void:
	on_player_exited(body)
