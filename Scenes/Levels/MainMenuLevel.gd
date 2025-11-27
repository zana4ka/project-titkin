extends Node2D
class_name MainMenuLevel

@export_category("New Game")
@export var new_game_button: BaseButton
@export var new_game_level_path: String = "res://Scenes/Levels/RGLevel001.tscn"

@export_category("Settings")
@export var settings_button: BaseButton

func _ready() -> void:
	
	assert(new_game_button)
	assert(settings_button)
	
	new_game_button.pressed.connect(_on_new_game_button_pressed)

func _on_new_game_button_pressed() -> void:
	WorldGlobals.load_scene_by_path(new_game_level_path)
