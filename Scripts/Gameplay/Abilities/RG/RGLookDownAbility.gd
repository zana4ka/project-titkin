@tool
extends GameplayAbility
class_name RGLookDownAbility

func _ready() -> void:
	ability_tags = [ TitkinTags.look_down_ability ]
	owner_granted_tags = [ TitkinTags.state_looking_down ]
	owner_must_not_have_tags = [ TitkinTags.state_looking_up ]

func can_activate() -> bool:
	return super()

func commit_ability() -> void:
	pass

func on_ability_ended(in_was_cancelled: bool) -> void:
	pass
