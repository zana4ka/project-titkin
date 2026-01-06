@tool
extends TitkinPawn2D
class_name RGPawn2D

func handle_lock_movement_input(in_event: InputEvent) -> bool:
	
	if in_event.is_pressed():
		return asc.try_activate_abilities_by_tag(TitkinTags.lock_movement_ability)
	else:
		return asc.try_end_abilities_by_tag(TitkinTags.lock_movement_ability)

func handle_crouch_input(in_event: InputEvent) -> bool:
	
	if in_event.is_pressed():
		return asc.try_activate_abilities_by_tag(CommonTags.crouch_ability)
	else:
		return asc.try_end_abilities_by_tag(CommonTags.crouch_ability)
