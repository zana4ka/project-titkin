@tool
extends GameplayAbility
class_name BUJumpAbility

@export_category("Jump")
@export var jump_animation_player: AnimationPlayer
@export var jump_animation_name: StringName = &"jump"

func _ready() -> void:
	
	ability_tags = [ CommonTags.jump_ability ]
	owner_granted_tags = [ CommonTags.state_jumping ]
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(jump_animation_player)

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload) and not jump_animation_player.is_playing()

func commit_ability() -> void:
	
	var owner_pawn := get_owner_pawn()
	
	owner_pawn.character_movement.landed.connect(_on_owner_landed, Object.CONNECT_ONE_SHOT)
	jump_animation_player.play(jump_animation_name)

func _on_owner_landed() -> void:
	end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	var owner_pawn := get_owner_pawn()
	
	if owner_pawn.character_movement.landed.is_connected(_on_owner_landed):
		owner_pawn.character_movement.landed.disconnect(_on_owner_landed)
