extends ItemData_Firearm
class_name ItemData_Firearm_Charged

@export_category("Charge")
@export var charge_min: float = 0.25
@export var charge_max: float = 2.0

@export_category("Projectile")
@export var projectile_power_mul_min: float = 1.0
@export var projectile_power_mul_max: float = 2.5

func adjust_projectile_power(in_power: float, in_charge: float) -> float:
	return in_power * remap(in_charge, charge_min, charge_max, projectile_power_mul_min, projectile_power_mul_max)

@export_category("Use")
func get_use_ability_script() -> GDScript:
	return preload("res://Titkin/Game/Features/Items/Abilities/FirearmUseAbility_Charged.gd")
