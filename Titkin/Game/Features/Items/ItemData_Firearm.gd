extends ItemData_Weapon
class_name ItemData_Firearm

const hold_projectile_num_meta: StringName = &"ItemData_Firearm_hold_projectile_num"

@export_category("Use")
func get_use_ability_script() -> GDScript:
	return preload("res://Titkin/Game/Features/Items/Abilities/FirearmUseAbility.gd")

@export_category("Projectile")
@export var projectile_data: ProjectileData2D
