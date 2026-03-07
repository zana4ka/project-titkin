@tool
extends TitkinPawn2D
class_name BUPawn2D

func handle_block_input(in_event: InputEvent) -> bool:
	
	if in_event.is_pressed():
		return asc.try_activate_abilities_by_tag(TitkinTags.block_ability)
	else:
		return asc.try_end_abilities_by_tag(TitkinTags.block_ability)
