extends ItemData
class_name ItemData_Weapon

@export_category("Sprite")
@export var weapon_sprite_frames: SpriteFrames

enum UseInputMode
{
	Auto = 0,
	Single = 1,
	Hold = 2,
}

@export_category("Input")
@export var use_input_mode: UseInputMode = UseInputMode.Auto

func is_auto_use_input_mode() -> bool:
	return use_input_mode == UseInputMode.Auto

func is_single_use_input_mode() -> bool:
	return use_input_mode == UseInputMode.Single

func is_hold_use_input_mode() -> bool:
	return use_input_mode == UseInputMode.Hold
