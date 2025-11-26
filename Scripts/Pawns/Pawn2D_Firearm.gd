extends Pawn2D_Weapon
class_name Pawn2D_Firearm

const hold_projectile_num_meta: StringName = &"Pawn2D_Weapon_hold_projectile_num"

func _ready() -> void:
	super()

func _update_from_weapon_data() -> void:
	super()

func handle_use_weapon() -> void:
	
	var projectile_rotation := global_rotation
	if owner_sprite._Direction == AnimationData2D.Direction.Left:
		projectile_rotation = (PI - projectile_rotation)
	
	var _projectile := Projectile2D.spawn(Transform2D(projectile_rotation, global_position), weapon_data.projectile_data, 0, owner_pawn)
	
	if weapon_data.is_hold_use_input_mode():
		hold_weapon_uses_counter += 1
		_projectile.set_meta(hold_projectile_num_meta, hold_weapon_uses_counter)
