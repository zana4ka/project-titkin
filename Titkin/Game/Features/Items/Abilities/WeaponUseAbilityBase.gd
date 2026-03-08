@abstract
@tool
extends GameplayAbility
class_name WeaponUseAbilityBase

enum UseHandleType
{
	Immediate,
	WaitForFinish
}

var hold_weapon_uses_counter: int = 0

func _ready() -> void:
	ability_tags = [ CommonTags.weapon_use_ability ]
	owner_granted_tags = [ CommonTags.state_using_weapon ]

func get_weapon_data() -> ItemData_Weapon:
	return (owner_asc as TitkinASC).weapons_container.get_selected_weapon_data()

func get_weapon_sprite() -> Pawn2D_WeaponSprite:
	return Pawn2D_WeaponSprite.try_get_from(owner_asc.owner_pawn)

func apply_cost() -> void:
	super()

func apply_cooldown() -> void:
	var weapon_data := get_weapon_data()
	cooldown_time_left = weapon_data.base_cooldown

func activate_ability() -> void:
	
	if not commit_ability():
		return
	
	_use_or_end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	receive_use_finished.emit()
	
	if cooldown_finished.is_connected(_handle_use_cooldown_finished):
		cooldown_finished.disconnect(_handle_use_cooldown_finished)
	
	hold_weapon_uses_counter = 0

signal receive_use_finished()

func _use_or_end_ability() -> void:
	
	if check_cost(current_payload) and check_tags(current_payload):
		
		cooldown_finished.connect(_handle_use_cooldown_finished, Object.CONNECT_ONE_SHOT)
		
		apply_cost()
		apply_cooldown()
		
		if _handle_use() == UseHandleType.WaitForFinish:
			await receive_use_finished
		
		if is_active():
			var weapon_data := get_weapon_data()
			match weapon_data.use_input_mode:
				ItemData_Weapon.UseInputMode.Auto:
					pass
				ItemData_Weapon.UseInputMode.Hold:
					hold_weapon_uses_counter += 1
				ItemData_Weapon.UseInputMode.Single:
					end_ability()
	else:
		end_ability()

@abstract
func _handle_use() -> UseHandleType

func _handle_use_cooldown_finished() -> void:
	
	if not is_active():
		return
	
	var weapon_data := get_weapon_data()
	
	match weapon_data.use_input_mode:
		ItemData_Weapon.UseInputMode.Auto:
			_use_or_end_ability()
		ItemData_Weapon.UseInputMode.Hold:
			if last_input_since_activaion == AbilityInput.Release:
				end_ability()
			else:
				_use_or_end_ability()
		ItemData_Weapon.UseInputMode.Single:
			#end_ability()
			pass
