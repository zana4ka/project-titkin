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

func handle_number_input(in_number: int, in_pressed: bool) -> void:
	
	if in_pressed:
		var weapons_container := ModularGlobals.try_get_from(self, ItemContainer_Weapons) as ItemContainer_Weapons
		weapons_container.try_select_weapon(in_number - 1)

func handle_lock_movement_input(in_event: InputEvent) -> void:
	if controlled_pawn: controlled_pawn.handle_lock_movement_input(in_event.is_pressed() or in_event.is_echo())

func handle_special_ability_input(in_event: InputEvent) -> void:
	
	if in_event.is_pressed():
		var special_ability := Player_SpecialAbility.try_get_from(self)
		special_ability.try_activate()
