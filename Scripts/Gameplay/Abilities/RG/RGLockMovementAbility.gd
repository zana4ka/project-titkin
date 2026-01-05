@tool
extends GameplayAbility
class_name RGLockMovementAbility

func _ready() -> void:
	ability_tags = [ TitkinTags.lock_movement_ability ]
	owner_granted_tags = [ TitkinTags.state_locked_movement, CommonTags.block_input_movement ]

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload)

func commit_ability() -> void:
	owner_asc.try_end_abilities_by_tag(CommonTags.crouch_ability)

func on_ability_ended(in_was_cancelled: bool) -> void:
	pass
