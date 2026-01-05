@abstract
@tool
extends GameplayAbility
class_name WeaponUseAbilityBase

var hold_weapon_uses_counter: int = 0

func _ready() -> void:
	ability_tags = [ TitkinTags.weapon_use_ability ]
	owner_granted_tags = [ TitkinTags.state_using_weapon ]

func get_weapon_data() -> ItemData_Weapon:
	return (owner_asc as TitkinASC).weapons_container.get_selected_weapon_data()

func get_weapon_sprite() -> Pawn2D_WeaponSprite:
	return (owner_asc as TitkinASC).weapon_sprite

func apply_cost() -> void:
	super()

func apply_cooldown() -> void:
	var weapon_data := get_weapon_data()
	cooldown_time_left = weapon_data.base_cooldown

func commit_ability() -> void:
	_use_or_end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	hold_weapon_uses_counter = 0

func _use_or_end_ability() -> void:
	
	if can_activate(current_payload):
		
		_handle_use()
		
		var weapon_data := get_weapon_data()
		if weapon_data.is_hold_use_input_mode():
			hold_weapon_uses_counter += 1
		
	else:
		end_ability()

@abstract
func _handle_use() -> void

func _handle_use_cooldown_finished() -> void:
	
	var weapon_data := get_weapon_data()
	
	match weapon_data.use_input_mode:
		ItemData_Weapon.UseInputMode.Auto:
			_use_or_end_ability()
		ItemData_Weapon.UseInputMode.Hold:
			if is_input_action_pressed(CommonInputActions.primary_attack): _use_or_end_ability()
		ItemData_Weapon.UseInputMode.Single:
			pass
