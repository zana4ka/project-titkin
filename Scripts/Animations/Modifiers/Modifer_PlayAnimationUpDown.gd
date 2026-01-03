extends AnimStateModifier
class_name AnimStateModifier_PlayAnimationUpDown

@export_category("Animations")
@export var animation_forward_name: StringName = &"idle"
@export var animation_up_name: StringName = &"idle_up"
@export var animation_down_name: StringName = &"idle_down"

@export_category("Tags")
@export var state_looking_up_tag: StringName = TitkinTags.state_looking_up
@export var state_looking_down_tag: StringName = TitkinTags.state_looking_down

func _modify(in_state: AnimState, in_delta: float) -> void:
	
	var tags_container := in_state.get_tags_container()
	
	var sprite := in_state.get_sprite()
	
	if tags_container.has_tag(state_looking_up_tag):
		sprite.play(animation_up_name)
	elif tags_container.has_tag(state_looking_down_tag):
		sprite.play(animation_down_name)
	else:
		sprite.play(animation_forward_name)
