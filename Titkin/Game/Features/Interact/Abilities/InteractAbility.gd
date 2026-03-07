@tool
extends GameplayAbility
class_name InteractAbility

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		pass

func can_activate(in_payload: Variant) -> bool:
	
	if super(in_payload):
		var interact_source := InteractSource.try_get_from(get_owner_pawn())
		return is_instance_valid(interact_source.selected_target)
	return false

func apply_cost() -> void:
	super()

func apply_cooldown() -> void:
	cooldown_time_left = 1.0

func activate_ability() -> void:
	
	if not commit_ability():
		return
	
	var interact_source := InteractSource.try_get_from(get_owner_pawn())
	interact_source.start_interact_with_selected_target()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	var interact_source := InteractSource.try_get_from(get_owner_pawn())
	interact_source.finish_interact_with_selected_target(not in_was_cancelled)
