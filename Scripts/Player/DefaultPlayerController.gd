@tool
extends PlayerController

@export_category("Pawn")
@export var rg_pawn_scene_path: String = "res://Scenes/Pawns/DefaultRGPawn001.tscn"
@export var bu_pawn_scene_path: String = "res://Scenes/Pawns/DefaultBUPawn001.tscn"

func get_new_pawn_scene_path() -> String:
	if WorldGlobals._level is RGLevelBase2D:
		return rg_pawn_scene_path
	elif WorldGlobals._level is BULevelBase2D:
		return bu_pawn_scene_path
	else:
		return super()

func _unhandled_input(in_event: InputEvent) -> void:
	
	super(in_event)
	
	if get_viewport().is_input_handled():
		pass
	elif in_event.is_action_pressed(&"Jump"):
		HandleJumpInput()
		get_viewport().set_input_as_handled()

func HandleJumpInput() -> void:
	if controlled_pawn:
		controlled_pawn.handle_controller_jump_input()
