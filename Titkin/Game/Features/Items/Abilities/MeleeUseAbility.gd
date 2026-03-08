@tool
extends WeaponUseAbilityBase
class_name MeleeUseAbility

const animation_libary_key: StringName = &"melee_use_ability"

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(owner_asc.animation_player)

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload)

func apply_cost() -> void:
	super()

func apply_cooldown() -> void:
	var melee_data := get_weapon_data() as ItemData_Melee
	var swing_data := melee_data.mode_swing_data[current_payload]
	cooldown_time_left = melee_data.base_cooldown * swing_data.cooldown_mul

func activate_ability() -> void:
	
	var melee_data := get_weapon_data() as ItemData_Melee
	assert(melee_data.animation_library)
	owner_asc.animation_player.add_animation_library(animation_libary_key, melee_data.animation_library)
	
	super()

func _handle_use() -> UseHandleType:
	
	var melee_data := get_weapon_data() as ItemData_Melee
	var swing_data := melee_data.mode_swing_data[current_payload]
	
	var swing_animation_name := animation_libary_key + "/" + swing_data.animation_name
	
	assert(owner_asc.animation_player.get_animation_library(animation_libary_key) == melee_data.animation_library)
	owner_asc.animation_player.animation_finished.connect(_on_swing_animation_finished, Object.CONNECT_ONE_SHOT)
	
	assert(owner_asc.animation_player.has_animation(swing_animation_name))
	owner_asc.animation_player.play(swing_animation_name, -1.0, swing_data.animation_speed_mul)
	return UseHandleType.Immediate

func _on_swing_animation_finished(in_animation_name: StringName) -> void:
	
	var melee_data := get_weapon_data() as ItemData_Melee
	var swing_data := melee_data.mode_swing_data[current_payload]
	
	var swing_animation_name := animation_libary_key + "/" + swing_data.animation_name
	assert(in_animation_name == swing_animation_name)
	
	end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	if owner_asc.animation_player.animation_finished.is_connected(_on_swing_animation_finished):
		owner_asc.animation_player.animation_finished.disconnect(_on_swing_animation_finished)
	
	if owner_asc.animation_player.is_playing():
		owner_asc.animation_player.stop()
	
	owner_asc.animation_player.remove_animation_library(animation_libary_key)
	
	super(in_was_cancelled)
