@abstract
@tool
extends Pawn2D
class_name TitkinPawn2D

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(character_movement)

##
## Transforms
##
func adjust_body_direction(in_direction: Vector2) -> Vector2:
	
	if in_direction.x > 0.0:
		return Vector2.RIGHT
	elif in_direction.x < 0.0:
		return Vector2.LEFT
	else:
		return body_direction

##
## Input
##
func handle_controller_movement_input(in_input: Vector2) -> void:
	
	last_movement_input = in_input
	
	if asc.tags_container.has_tag(CommonTags.block_input_movement):
		
		character_movement.apply_movement_input(Vector2.ZERO)
		
		if last_movement_input.is_zero_approx():
			aim_direction = body_direction
		else:
			aim_direction = last_movement_input.normalized()
	else:
		character_movement.apply_movement_input(last_movement_input)
		
		if is_zero_approx(last_movement_input.y):
			aim_direction = body_direction
		else:
			aim_direction = last_movement_input.normalized()

func handle_move_up_input(in_event: InputEvent) -> bool:
	return false
	#if in_event.is_pressed():
	#	asc.try_activate_abilities_by_tag(TitkinTags.look_up_ability)
	#else:
	#	asc.try_end_abilities_by_tag(TitkinTags.look_up_ability)

func handle_move_down_input(in_event: InputEvent) -> bool:
	return false
	#if in_event.is_pressed():
	#	if not asc.tags_container.has_tag(TitkinTags.state_locked_movement):
	#		asc.try_activate_abilities_by_tag(CommonTags.crouch_ability)
	#else:
	#	asc.try_end_abilities_by_tag(CommonTags.crouch_ability)

func handle_primary_attack_input(in_event: InputEvent) -> bool:
	
	if in_event.is_pressed():
		return asc.try_activate_abilities_by_tag(CommonTags.weapon_use_ability, ItemData_Weapon.primary_attack_mode)
	else:
		return asc.try_end_abilities_by_tag(CommonTags.weapon_use_ability)

func handle_secondary_attack_input(in_event: InputEvent) -> bool:
	
	if in_event.is_pressed():
		return asc.try_activate_abilities_by_tag(CommonTags.weapon_use_ability, ItemData_Weapon.secondary_attack_mode)
	else:
		return asc.try_end_abilities_by_tag(CommonTags.weapon_use_ability)

func handle_special_attack_input(in_event: InputEvent) -> bool:
	
	if in_event.is_pressed():
		return asc.try_activate_abilities_by_tag(CommonTags.weapon_use_ability, ItemData_Weapon.special_attack_mode)
	else:
		return asc.try_end_abilities_by_tag(CommonTags.weapon_use_ability)
