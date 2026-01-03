@tool
extends Pawn2D
class_name RGPawn2D

@export_category("Components")
@export var collision: Pawn2D_Collision
@export var weapon: Pawn2D_Weapon

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(character_movement)
		assert(collision)
		assert(weapon)

func handle_controller_movement_input(in_input: Vector2) -> void:
	
	last_movement_input = in_input
	
	if asc.tags_container.has_tag(CommonTags.block_input_movement):
		character_movement.apply_movement_input(Vector2.ZERO)
	else:
		character_movement.apply_movement_input(last_movement_input)

func handle_move_up_input(in_event: InputEvent) -> void:
	
	if in_event.is_pressed():
		asc.try_activate_abilities_by_tag(TitkinTags.look_up_ability)
	else:
		asc.try_end_abilities_by_tag(TitkinTags.look_up_ability)

func handle_move_down_input(in_event: InputEvent) -> void:
	
	if in_event.is_pressed():
		if asc.try_activate_abilities_by_tag(CommonTags.crouch_ability):
			pass
		else:
			asc.try_activate_abilities_by_tag(TitkinTags.look_down_ability)
	else:
		asc.try_end_abilities_by_tag(CommonTags.crouch_ability)
		asc.try_end_abilities_by_tag(TitkinTags.look_down_ability)

func handle_primary_attack_input(in_event: InputEvent) -> void:
	if in_event.is_pressed():
		weapon.try_use_weapon(0)

func handle_secondary_attack_input(in_event: InputEvent) -> void:
	if in_event.is_pressed():
		weapon.try_use_weapon(1)

func handle_special_attack_input(in_event: InputEvent) -> void:
	if in_event.is_pressed():
		var special_ability := Pawn2D_SpecialAbility.try_get_from(self)
		special_ability.try_activate()

func handle_lock_movement_input(in_event: InputEvent) -> void:
	
	if in_event.is_pressed():
		asc.try_activate_abilities_by_tag(TitkinTags.lock_movement_ability)
	elif in_event.is_released():
		asc.try_end_abilities_by_tag(TitkinTags.lock_movement_ability)
