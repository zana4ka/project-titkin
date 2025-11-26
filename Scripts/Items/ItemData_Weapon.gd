extends ItemData
class_name ItemData_Weapon

@export_category("Sprite")
@export var weapon_sprite_frames: SpriteFrames

enum FireInputMode
{
	Auto = 0,
	Single = 1,
	Hold = 2,
}

@export_category("Projectile")
@export var projectile_data: ProjectileData2D
@export var base_fire_rate: float = 1.0
@export var fire_input_mode: FireInputMode = FireInputMode.Auto

func is_auto_fire_input_mode() -> bool:
	return fire_input_mode == FireInputMode.Auto

func is_single_fire_input_mode() -> bool:
	return fire_input_mode == FireInputMode.Single

func is_hold_fire_input_mode() -> bool:
	return fire_input_mode == FireInputMode.Hold
