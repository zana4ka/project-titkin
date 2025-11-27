extends Node
class_name Pawn2D_PingPong

@export_category("Owner")
@export var owner_pawn: Pawn2D
@export var owner_character_movement: Pawn2D_CharacterMovement

@export_category("Force")
@export var force_forward_direction: Vector2 = Vector2.UP
@export var force_magniude: float = 50.0
@export var force_enabled: bool = false:
	set(in_enabled):
		force_enabled = in_enabled
		set_physics_process(force_enabled)

var current_force: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	assert(owner_pawn)
	assert(owner_character_movement)
	
	owner_character_movement.bounce.connect(_on_owner_bounce)
	
	current_force = force_forward_direction * force_magniude
	force_enabled = force_enabled

func _physics_process(in_delta: float) -> void:
	
	owner_character_movement.apply_force(current_force)
	

func _on_owner_bounce(in_bounce_collision: KinematicCollision2D) -> void:
	
	if in_bounce_collision.get_normal().dot(force_forward_direction) > 0.5:
		current_force = force_forward_direction * force_magniude
	else:
		current_force = -force_forward_direction * force_magniude
