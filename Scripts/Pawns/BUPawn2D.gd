@tool
extends Pawn2D
class_name BUPawn2D

@export_category("Weapon")
@export var weapon: Pawn2D_Weapon

var is_blocking: bool = false:
	set(in_is_blocking):
		if in_is_blocking != is_blocking:
			is_blocking = in_is_blocking
			if is_blocking: _handle_enable_block()
			else: _handle_disable_block()

func _ready() -> void:
	
	super()
	
	#if Engine.is_editor_hint():
	#	pass
	#else:
	#	assert(weapon)

func handle_controller_movement_input(in_input: Vector2) -> void:
	
	last_movement_input = in_input
	
	if is_blocking:
		character_movement.apply_movement_input(Vector2.ZERO)
	else:
		character_movement.apply_movement_input(last_movement_input)

func handle_primary_attack_input(in_event: InputEvent) -> void:
	if in_event.is_pressed():
		weapon.try_use_weapon(0)

func handle_secondary_attack_input(in_event: InputEvent) -> void:
	if in_event.is_pressed():
		weapon.try_use_weapon(1)

func handle_special_attack_input(in_event: InputEvent) -> void:
	if in_event.is_pressed():
		weapon.try_use_special_ability()

func handle_block_input(in_event: InputEvent) -> void:
	is_blocking = in_event.is_pressed() or in_event.is_echo()

func _handle_enable_block() -> void:
	damage_receiver.AddDamageImmunityTo(DamageReceiver.DamageType_RangedHit)
	modulate = Color.YELLOW

func _handle_disable_block() -> void:
	damage_receiver.RemoveDamageImmunityFrom(DamageReceiver.DamageType_RangedHit)
	modulate = Color.WHITE
