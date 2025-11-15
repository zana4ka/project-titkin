@tool
extends Pawn2D_CharacterMovement
class_name Pawn2D_BUMovement

const jump_offset_target_height_fraction_meta: StringName = &"Pawn2D_BUMovement_jump_offset_target_height_fraction"

static func get_jump_offset_target_height_fraction(in_offset_target: Node2D) -> float:
	return in_offset_target.get_meta(jump_offset_target_height_fraction_meta, 0.0)

@export_category("Jump")
@export var jump_animation_player: AnimationPlayer
@export var jump_animation_name: StringName = &"jump"
@export var jump_offset_max: Vector2 = Vector2(0.0, -24.0)
@export var jump_offset_targets: Array[Node2D] = []

@export var jump_height_fraction: float = 0.0:
	set(in_fraction):
		jump_height_fraction = in_fraction
		update_jump_offset_targets()

@export var is_in_air: bool = false

func _ready() -> void:
	
	super()
	
	is_in_air = false

func apply_jump_input() -> void:
	
	if not is_in_air:
		
		var prev_jump_time_left := 0.0
		if jump_animation_player.current_animation == jump_animation_name:
			prev_jump_time_left = jump_animation_player.current_animation_length - jump_animation_player.current_animation_position
			jump_animation_player.stop()
		
		jump_animation_player.play(jump_animation_name)
		jump_animation_player.advance(prev_jump_time_left * 0.3)

func update_jump_offset_targets() -> void:
	
	for sample_target: Node2D in jump_offset_targets:
		sample_target.position = jump_offset_max * jump_height_fraction
		sample_target.set_meta(jump_offset_target_height_fraction_meta, jump_height_fraction)
