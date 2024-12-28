class_name PlayerButtonArea3D
extends PlayerDetectorArea3D

signal toggled(new_value)

enum Mode {
	TOGGLE, HOLD
}

@export var pressed : bool = false :
	set(value):
		pressed = value
		send_toggle()

@export var one_use : bool = false
@export var mode : Mode = Mode.TOGGLE



#from parent
#func toggle(new_value=null) -> void:
	#if new_value == null: new_value = !monitoring
	#monitoring = new_value

func on_player_entered(_player) -> void:
	if mode == Mode.HOLD:
		pressed = true
	elif mode == Mode.TOGGLE:
		pressed = !pressed
	
	if one_use:
		toggle(false) # turns off monitoring, the ability to detect player

func on_player_exited(_player) -> void:
	if mode == Mode.HOLD:
		pressed = false

func send_toggle() -> void:
	
	toggled.emit(pressed)
