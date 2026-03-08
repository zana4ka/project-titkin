@tool
extends FirearmUseAbility
class_name FirearmUseAbility_Charged

#func _ready() -> void:
#	ability_tags = [ TitkinTags.weapon_use_ability ]
#	owner_granted_tags = [ TitkinTags.state_using_weapon ]

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload)

func apply_cost() -> void:
	super()

func apply_cooldown() -> void:
	super()

func activate_ability() -> void:
	super()

var current_charge_time: float = 0.0:
	set(in_time):
		
		current_charge_time = in_time
		
		var firearm_data := get_weapon_data() as ItemData_Firearm_Charged
		if not hit_charge_max and current_charge_time >= firearm_data.charge_max:
			
			current_charge_time = firearm_data.charge_max
			
			if firearm_data.is_hold_use_input_mode():
				receive_use_finished.emit()
		
		hit_charge_min = current_charge_time >= firearm_data.charge_min
		hit_charge_max = current_charge_time >= firearm_data.charge_max
		
		var weapon_sprite := Pawn2D_WeaponSprite.try_get_from(get_owner_pawn())
		weapon_sprite.modulate = Color.WHITE.lerp(Color.ORANGE, current_charge_time / firearm_data.charge_max)

var hit_charge_min: bool = false:
	set(in_hit):
		if in_hit != hit_charge_min:
			hit_charge_min = in_hit
var hit_charge_max: bool = false:
	set(in_hit):
		if in_hit != hit_charge_max:
			hit_charge_max = in_hit

## Charge start
func _handle_use() -> UseHandleType:
	
	current_charge_time = 0.0
	received_input.connect(_on_received_input, Object.CONNECT_ONE_SHOT)
	return UseHandleType.WaitForFinish

func _process(in_delta: float) -> void:
	
	super(in_delta)
	
	if is_active():
		current_charge_time += in_delta

func _on_received_input(in_type: AbilityInput) -> void:
	if in_type == AbilityInput.Release:
		_handle_use_finish()

## Charge finish
func _handle_use_finish() -> void:
	
	if hit_charge_min:
		var shoot_projectile := _spawn_projectile()
	else:
		cancel_ability()
	
	receive_use_finished.emit()

func _spawn_projectile() -> Projectile2D:
	
	var firearm_data := get_weapon_data() as ItemData_Firearm_Charged
	
	var out_projectile := super()
	out_projectile._power = firearm_data.adjust_projectile_power(out_projectile._power, current_charge_time)
	return out_projectile

func _on_spawned_projectile_ready(in_projectile: Projectile2D) -> void:
	super(in_projectile)

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	current_charge_time = 0.0
	
	if received_input.is_connected(_on_received_input):
		received_input.disconnect(_on_received_input)
	
	super(in_was_cancelled)
