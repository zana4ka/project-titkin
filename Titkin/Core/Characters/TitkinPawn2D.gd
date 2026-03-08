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

func _process(in_delta: float) -> void:
	
	#super(in_delta)
	
	_process_aim_direction(in_delta)

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

func _process_aim_direction(in_delta: float) -> void:
	
	if asc.tags_container.has_tag(CommonTags.input_block_movement):
		
		if character_movement.last_movement_input.is_zero_approx():
			if sync_aim_with_body_direction:
				aim_direction = body_direction
		else:
			aim_direction = character_movement.last_movement_input.normalized()
	else:
		if character_movement.last_movement_input.is_zero_approx():
			pass
		else:
			if is_zero_approx(character_movement.last_movement_input.y):
				if sync_aim_with_body_direction:
					aim_direction = body_direction
			else:
				aim_direction = character_movement.last_movement_input.normalized()

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
