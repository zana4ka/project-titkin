@tool
extends TextureRect
class_name WeaponsUI_Slot

@export_category("Weapon")
@export var weapon_texture_rect: TextureRect

@export_category("Selection")
@export var selection_animation_player: AnimationPlayer
@export var select_animation_name: StringName = &"select"
@export var deselect_animation_name: StringName = &"deselect"

var is_selected: bool = false:
	set(in_is_selected):
		
		if in_is_selected != is_selected:
			is_selected = in_is_selected
			_play_selection_animation()

func _ready() -> void:
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(selection_animation_player)
		_play_selection_animation(true)

func set_data(in_data: ItemData_Weapon) -> void:
	
	if in_data:
		weapon_texture_rect.texture = in_data.display_data.get_image()
		weapon_texture_rect.visible = true
	else:
		weapon_texture_rect.visible = false

func _play_selection_animation(in_skip: bool = false) -> void:
	
	if is_selected:
		selection_animation_player.play(select_animation_name, -1.0, 3.0)
	else:
		selection_animation_player.play(deselect_animation_name, -1.0, 6.0)
	
	if in_skip:
		selection_animation_player.advance(selection_animation_player.current_animation_length)
