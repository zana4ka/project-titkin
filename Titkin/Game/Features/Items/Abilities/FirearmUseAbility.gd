@tool
extends WeaponUseAbilityBase
class_name FirearmUseAbility

#func _ready() -> void:
#	ability_tags = [ TitkinTags.weapon_use_ability ]
#	owner_granted_tags = [ TitkinTags.state_using_weapon ]

func can_activate(in_payload: Variant) -> bool:
	
	if in_payload == ItemData_Firearm.special_attack_mode:
		var owner_special_charge = Pawn2D_SpecialCharge.try_get_from(get_owner_pawn())
		if not owner_special_charge.can_subtract_charge():
			return false
	
	return super(in_payload)

func apply_cost() -> void:
	
	super()
	
	if current_payload == ItemData_Firearm.special_attack_mode:
		var owner_special_charge = Pawn2D_SpecialCharge.try_get_from(get_owner_pawn())
		owner_special_charge.subtract_charge()

func apply_cooldown() -> void:
	super()

func commit_ability() -> void:
	super()

func _handle_use() -> void:
	var shoot_projectile := _spawn_projectile()

func _spawn_projectile() -> Projectile2D:
	
	var firearm_data := get_weapon_data() as ItemData_Firearm
	var weapon_sprite := get_weapon_sprite()
	var owner_pawn := get_owner_pawn()
	
	var projectile_position := weapon_sprite.global_position
	var projectile_rotation := weapon_sprite.global_rotation
	
	var projectile_direction = owner_pawn.aim_direction
	projectile_rotation = projectile_direction.angle()
	
	var out_projectile := Projectile2D.spawn(Transform2D(projectile_rotation, projectile_position), firearm_data.projectile_data, 0, owner_pawn)
	out_projectile.set_meta(ItemData_Firearm.hold_projectile_num_meta, hold_weapon_uses_counter)
	out_projectile.ready.connect(_on_spawned_projectile_ready.bind(out_projectile))
	
	if current_payload == ItemData_Firearm.special_attack_mode:
		out_projectile._power *= 3.0
	return out_projectile

func _on_spawned_projectile_ready(in_projectile: Projectile2D) -> void:
	if current_payload == ItemData_Firearm.special_attack_mode:
		in_projectile.set_lifetime(in_projectile.data.max_lifetime * 3.0)
