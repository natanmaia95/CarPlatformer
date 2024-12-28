@tool
class_name PlayerDetectorArea3D
extends Area3D

## PLAYER_CLASS = PlayerCar
const PLAYER_HURTBOX_LAYER : int = 13


func on_player_entered(_player) -> void:
	print_debug("player detected!")

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(PLAYER_HURTBOX_LAYER, true)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body:Node3D) -> void:
	on_player_entered(body)
