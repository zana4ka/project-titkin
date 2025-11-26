extends ItemData_Weapon
class_name ItemData_Firearm

const hold_projectile_num_meta: StringName = &"ItemData_Firearm_hold_projectile_num"

@export_category("Projectile")
@export var projectile_data: ProjectileData2D

func handle_use(in_weapon: Pawn2D_Weapon) -> void:
	
	var projectile_position := in_weapon.global_position
	var projectile_rotation := in_weapon.global_rotation
	
	if in_weapon.owner_sprite._Direction == AnimationData2D.Direction.Left:
		projectile_rotation = (PI - projectile_rotation)
	
	var _projectile := Projectile2D.spawn(Transform2D(projectile_rotation, projectile_position), projectile_data, 0, in_weapon.owner_pawn)
	
	if is_hold_use_input_mode():
		in_weapon.hold_weapon_uses_counter += 1
		_projectile.set_meta(hold_projectile_num_meta, in_weapon.hold_weapon_uses_counter)
