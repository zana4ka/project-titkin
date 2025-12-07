extends ItemData_Weapon
class_name ItemData_Melee

@export_category("Animation")
@export var mode_swing_data: Dictionary[int, ItemData_MeleeSwingData] = { }

func handle_use(in_weapon: Pawn2D_Weapon, in_mode: int) -> float:
	
	var swing_data := mode_swing_data[in_mode]
	
	in_weapon.animation_player.play(swing_data.animation_name, -1.0, swing_data.animation_speed_mul)
	return base_cooldown * swing_data.cooldown_mul

func handle_special_ability(in_weapon: Pawn2D_Weapon) -> float:
	return base_cooldown_special
