@tool
extends PlayerController

@export_category("Pawn")
@export var rg_pawn_scene_path: String = "res://Scenes/Pawns/RG/Player/PlayerRGPawn001.tscn"
@export var bu_pawn_scene_path: String = "res://Scenes/Pawns/BU/Player/PlayerBUPawn001.tscn"

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
		handle_jump_input()
		get_viewport().set_input_as_handled()

func handle_jump_input() -> void:
	if controlled_pawn:
		controlled_pawn.handle_controller_jump_input()

func handle_number_input(in_number: int, in_pressed: bool) -> void:
	
	if in_pressed:
		var weapons_container := ModularGlobals.try_get_from(self, ItemContainer_Weapons) as ItemContainer_Weapons
		weapons_container.try_select_weapon(in_number - 1)
