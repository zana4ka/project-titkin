@tool
extends Pawn2D
class_name RGPawn2D

@export_category("Components")
@export var sprite: Pawn2D_Sprite
@export var collision: Pawn2D_Collision
@export var weapon: Pawn2D_Weapon

var is_movement_locked: bool = false:
	set(in_is_movement_locked):
		is_movement_locked = in_is_movement_locked

@export var can_crouch: bool = false
var is_crouching: bool = false:
	set(in_is_crouching):
		
		if in_is_crouching != is_crouching:
			
			is_crouching = in_is_crouching
			
			if is_crouching: _handle_crouch()
			else: _handle_un_crouch()

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(character_movement)
		assert(sprite)
		assert(collision)
		assert(weapon)

func handle_controller_movement_input(in_input: Vector2) -> void:
	
	last_movement_input = in_input
	
	if is_movement_locked:
		character_movement.apply_movement_input(Vector2.ZERO)
	else:
		if is_crouching:
			character_movement.apply_movement_input(Vector2.ZERO)
		else:
			character_movement.apply_movement_input(last_movement_input)
		
		handle_up_input(last_movement_input.y < -0.5)
		handle_down_input(last_movement_input.y > 0.5)

func handle_up_input(in_pressed: bool) -> void:
	
	if in_pressed:
		sprite.current_look_direction = AnimationData2D.LookDirection.Up
	else:
		sprite.current_look_direction = AnimationData2D.LookDirection.Forward

func handle_down_input(in_pressed: bool) -> void:
	if can_crouch:
		is_crouching = in_pressed

func _handle_crouch() -> void:
	
	sprite.play_override_animation(&"crouch")
	
	assert(collision.shape.resource_local_to_scene)
	(collision.shape as CapsuleShape2D).height = 13.0
	
	position.y += 6.5

func _handle_un_crouch() -> void:
	
	position.y -= 6.5
	
	sprite.cancel_override_animation(&"crouch")
	
	assert(collision.shape.resource_local_to_scene)
	(collision.shape as CapsuleShape2D).height = 26.0

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
	is_movement_locked = in_event.is_pressed() or in_event.is_echo()
