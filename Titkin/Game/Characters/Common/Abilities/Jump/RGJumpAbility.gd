@tool
extends GameplayAbility
class_name RGJumpAbility

@export_category("Jump")
@export var jump_impulse_magnitude: float = 400.0

func _ready() -> void:
	ability_tags = [ CommonTags.jump_ability ]
	owner_granted_tags = [ CommonTags.state_jumping ]
	owner_must_not_have_tags = [ CommonTags.state_crouching ]

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload) and get_owner_body().is_on_floor()

func activate_ability() -> void:
	
	if not commit_ability():
		return
	
	var owner_pawn := get_owner_pawn()
	var owner_body := get_owner_body()
	
	owner_pawn.character_movement.landed.connect(_on_owner_landed, Object.CONNECT_ONE_SHOT)
	owner_pawn.character_movement.launch(jump_impulse_magnitude * owner_body.up_direction)

func _on_owner_landed() -> void:
	end_ability()

func on_ability_ended(in_was_cancelled: bool) -> void:
	
	var owner_pawn := get_owner_pawn()
	
	if owner_pawn.character_movement.landed.is_connected(_on_owner_landed):
		owner_pawn.character_movement.landed.disconnect(_on_owner_landed)
