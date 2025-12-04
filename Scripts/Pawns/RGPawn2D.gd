@tool
extends Pawn2D
class_name RGPawn2D

@export_category("Components")
@export var owner_sprite: Pawn2D_Sprite
@export var owner_collision: Pawn2D_Collision

var is_movement_locked: bool = false:
	set(in_is_movement_locked):
		is_movement_locked = in_is_movement_locked

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
		assert(owner_sprite)
		assert(owner_collision)

func handle_controller_movement_input(in_input: Vector2) -> void:
	
	last_movement_input = in_input
	
	if is_movement_locked:
		character_movement.apply_movement_input(Vector2.ZERO)
	else:
		if is_crouching:
			character_movement.apply_movement_input(Vector2.ZERO)
		else:
			character_movement.apply_movement_input(last_movement_input)
		
		handle_up_input(last_movement_input.y < 0.0)
		handle_down_input(last_movement_input.y > 0.0)

func handle_up_input(in_pressed: bool) -> void:
	
	if in_pressed:
		owner_sprite.current_look_direction = AnimationData2D.LookDirection.Up
	else:
		owner_sprite.current_look_direction = AnimationData2D.LookDirection.Forward

func handle_down_input(in_pressed: bool) -> void:
	is_crouching = in_pressed

func _handle_crouch() -> void:
	
	owner_sprite.scale.y = 0.025
	
	assert(owner_collision.shape.resource_local_to_scene)
	(owner_collision.shape as CapsuleShape2D).height = 13.0
	
	position.y += 6.5

func _handle_un_crouch() -> void:
	
	position.y -= 6.5
	
	owner_sprite.scale.y = 0.05
	
	assert(owner_collision.shape.resource_local_to_scene)
	(owner_collision.shape as CapsuleShape2D).height = 26.0
