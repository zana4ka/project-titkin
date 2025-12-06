extends ItemData_Weapon
class_name ItemData_Firearm

const hold_projectile_num_meta: StringName = &"ItemData_Firearm_hold_projectile_num"

@export_category("Projectile")
@export var projectile_data: ProjectileData2D

func _spawn_projectile(in_weapon: Pawn2D_Weapon) -> Projectile2D:
	
	var projectile_position := in_weapon.global_position
	var projectile_rotation := in_weapon.global_rotation
	
	var projectile_direction = in_weapon.owner_pawn.last_movement_input
	if projectile_direction.is_zero_approx():
		projectile_direction = in_weapon.owner_sprite.get_current_forward_direction()
	
	projectile_rotation = projectile_direction.angle()
	
	var out_projectile := Projectile2D.spawn(Transform2D(projectile_rotation, projectile_position), projectile_data, 0, in_weapon.owner_pawn)
	return out_projectile

func handle_use(in_weapon: Pawn2D_Weapon) -> void:
	
	var shoot_projectile := _spawn_projectile(in_weapon)
	
	if is_hold_use_input_mode():
		in_weapon.hold_weapon_uses_counter += 1
		shoot_projectile.set_meta(hold_projectile_num_meta, in_weapon.hold_weapon_uses_counter)

func handle_special_ability(in_weapon: Pawn2D_Weapon) -> void:
	
	var shoot_projectile := _spawn_projectile(in_weapon)
	shoot_projectile._power *= 3.0
	
	assert(not shoot_projectile.is_node_ready())
	shoot_projectile.ready.connect(_on_special_ability_projectile_ready.bind(shoot_projectile))

func _on_special_ability_projectile_ready(in_projectile: Projectile2D) -> void:
	in_projectile.set_lifetime(in_projectile.data.max_lifetime * 3.0)
