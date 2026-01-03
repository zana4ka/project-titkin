@tool
extends GameplayAbility
class_name RGLookUpAbility

func _ready() -> void:
	ability_tags = [ TitkinTags.look_up_ability ]
	owner_granted_tags = [ TitkinTags.state_looking_up ]
	owner_must_not_have_tags = [ TitkinTags.state_looking_down ]

func can_activate() -> bool:
	return super()

func commit_ability() -> void:
	pass

func on_ability_ended(in_was_cancelled: bool) -> void:
	pass
