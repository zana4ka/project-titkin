@tool
extends GameplayAbility
class_name RGJumpAbility

@export_category("Animations")
@export var jump_animation_name: StringName = &""

func _ready() -> void:
	ability_tags = [ CommonTags.jump_ability ]
	owner_granted_tags = [ CommonTags.state_jumping ]

func can_activate() -> bool:
	return super() and owner_asc.owner_pawn.character_movement.can_jump()

func commit_ability() -> void:
	
	#owner_asc.owner_pawn.input_action_handled.connect(_on_owner_input_action_handled)
	owner_asc.owner_pawn.character_movement.landed.connect(_on_owner_landed)
	
	owner_asc.owner_pawn.character_movement.try_jump()
	
	if not jump_animation_name.is_empty():
		var owner_sprite := Pawn2D_Sprite.try_get_from(owner_asc.owner_pawn)
		owner_sprite.play_override_animation(jump_animation_name)

#func _on_owner_input_action_handled(in_action_event: InputEvent) -> void:
#	if in_action_event.is_action_released(CommonActions.jump):
#		end_ability()

func _on_owner_landed() -> void:
	end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	if not jump_animation_name.is_empty():
		var owner_sprite := Pawn2D_Sprite.try_get_from(owner_asc.owner_pawn)
		owner_sprite.cancel_override_animation(jump_animation_name)
	
	#if owner_asc.owner_pawn.input_action_handled.is_connected(_on_owner_input_action_handled):
	#	owner_asc.owner_pawn.input_action_handled.disconnect(_on_owner_input_action_handled)
	
	if owner_asc.owner_pawn.character_movement.landed.is_connected(_on_owner_landed):
		owner_asc.owner_pawn.character_movement.landed.disconnect(_on_owner_landed)
