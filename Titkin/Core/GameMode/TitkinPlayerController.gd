@tool
extends PlayerController
class_name TitkinPlayerController

@export_category("Pawn")
@export var rg_pawn_scene_path: String = "res://Titkin/Game/Characters/Player/Kokki/Kokki_Run'n'Gun.tscn"
@export var bu_pawn_scene_path: String = "res://Titkin/Game/Characters/Player/Kokki/Kokki_Beat'emUp.tscn"

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		var rg_level := WorldGlobals._level as RGLevelBase2D
		if rg_level:
			rg_level.set_camera_limits_from_level_bounds(self)

func get_new_pawn_scene_path() -> String:
	
	if WorldGlobals._level is RGLevelBase2D:
		return rg_pawn_scene_path
	elif WorldGlobals._level is BULevelBase2D:
		return bu_pawn_scene_path
	else:
		return super()

func init_new_pawn(in_new_pawn: Pawn2D) -> void:
	
	super(in_new_pawn)
	

func handle_number_input(in_number: int, in_pressed: bool) -> void:
	
	if in_pressed:
		var weapons_container := ModularGlobals.try_get_from(self, ItemContainer_Weapons) as ItemContainer_Weapons
		weapons_container.try_select_weapon(in_number - 1)
