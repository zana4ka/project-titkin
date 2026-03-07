extends ItemData_Weapon
class_name ItemData_Melee

@export_category("Use")
func get_use_ability_script() -> GDScript:
	return preload("res://Titkin/Game/Features/Items/Abilities/MeleeUseAbility.gd")

@export_category("Animation")
@export var mode_swing_data: Dictionary[int, ItemData_MeleeSwingData] = {}
@export var animation_library: AnimationLibrary
