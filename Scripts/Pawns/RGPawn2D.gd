@tool
extends Pawn2D
class_name RGPawn2D



func _ready() -> void:
	super()

func handle_controller_tap_input(in_screen_position: Vector2, in_global_position: Vector2, in_released: bool) -> void:
	
	if in_released:
		pass
	else:
		
