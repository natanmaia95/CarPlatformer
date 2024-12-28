@tool
class_name PlayerKillArea3D
extends PlayerDetectorArea3D


func on_player_entered(player) -> void:
	super(player)
	player.kill()
