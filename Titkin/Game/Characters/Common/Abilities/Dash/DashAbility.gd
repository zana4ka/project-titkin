@tool
extends GameplayAbility
class_name DashAbility

@export_category("Dash")
@export var dash_impulse_magnitude: float = 1000.0
@export var dash_velocity_damp_mul: float = 1.5
@export var dash_duration: float = 0.2

var dash_end_timer: Timer

func _ready() -> void:
	ability_tags = [ CommonTags.dash_ability ]
	owner_granted_tags = [ CommonTags.state_dashing, CommonTags.input_block_movement ]
	owner_must_not_have_tags = [ CommonTags.state_crouching ]

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload)# and get_owner_body().is_on_floor()

var damp_applied: bool = false

func activate_ability() -> void:
	
	if not commit_ability():
		return
	
	var owner_pawn := get_owner_pawn()
	var owner_body := get_owner_body()
	
	var dash_direction := owner_pawn.aim_direction
	if not owner_pawn.character_movement.last_movement_input.is_zero_approx():
		dash_direction = owner_pawn.character_movement.last_movement_input.normalized()
	
	assert(not damp_applied)
	owner_pawn.character_movement.launch_velocity_damp *= dash_velocity_damp_mul
	damp_applied = true
	
	owner_pawn.character_movement.launch(dash_impulse_magnitude * dash_direction)
	
	dash_end_timer = GameGlobals.spawn_one_shot_timer_for(self, _on_dash_ended, dash_duration)

func _on_dash_ended() -> void:
	end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	var owner_pawn := get_owner_pawn()
	if damp_applied:
		owner_pawn.character_movement.launch_velocity_damp /= dash_velocity_damp_mul
		damp_applied = false
	
	if is_instance_valid(dash_end_timer):
		dash_end_timer.queue_free()
	dash_end_timer = null
