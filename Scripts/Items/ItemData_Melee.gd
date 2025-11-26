extends ItemData_Weapon
class_name ItemData_Melee

@export_category("Animation")
@export var swing_animation_name: StringName = &"swing"

func handle_use(in_weapon: Pawn2D_Weapon) -> void:
	in_weapon.animation_player.play(swing_animation_name)
