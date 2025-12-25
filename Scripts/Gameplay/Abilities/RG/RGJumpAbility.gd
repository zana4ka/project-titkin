@tool
extends GameplayAbility
class_name RGJumpAbility

func _ready() -> void:
	ability_tags = [ CommonTags.jump_ability ]
	owner_granted_tags = [ CommonTags.state_jumping ]

func can_activate() -> bool:
	return super() and owner_asc.owner_pawn.character_movement.can_jump()

func commit_ability() -> void:
	
	owner_asc.owner_pawn.input_action_handled.connect(_on_owner_input_action_handled)
	owner_asc.owner_pawn.character_movement.landed.connect(_on_owner_landed)
	
	owner_asc.owner_pawn.character_movement.try_jump()

func _on_owner_input_action_handled(in_action_event: InputEvent) -> void:
	if in_action_event.is_action_released(CommonActions.jump):
		end_ability()

func _on_owner_landed() -> void:
	end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	if owner_asc.owner_pawn.input_action_handled.is_connected(_on_owner_input_action_handled):
		owner_asc.owner_pawn.input_action_handled.disconnect(_on_owner_input_action_handled)
	
	if owner_asc.owner_pawn.character_movement.landed.is_connected(_on_owner_landed):
		owner_asc.owner_pawn.character_movement.landed.disconnect(_on_owner_landed)
