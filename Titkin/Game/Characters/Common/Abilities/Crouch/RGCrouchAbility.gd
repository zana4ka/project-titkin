@tool
extends GameplayAbility
class_name RGCrouchAbility

@export_category("Collision")
@export var crouch_height: float = 13.0
@export var uncrouch_height: float = 26.0

func _ready() -> void:
	ability_tags = [ CommonTags.crouch_ability ]
	owner_granted_tags = [ CommonTags.state_crouching, CommonTags.block_input_movement ]
	owner_must_not_have_tags = [ TitkinTags.state_locked_movement ]

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload) and get_owner_body().is_on_floor()

func commit_ability() -> void:
	_handle_crouch()

func on_ability_ended(in_was_cancelled: bool) -> void:
	_handle_un_crouch()

func _handle_crouch() -> void:
	
	var owner_pawn := get_owner_pawn() as RGPawn2D
	var owner_collision := Pawn2D_Collision.try_get_from(owner_pawn)
	
	assert(owner_collision.shape.resource_local_to_scene)
	(owner_collision.shape as CapsuleShape2D).height = crouch_height
	
	owner_pawn.position.y += crouch_height * 0.5

func _handle_un_crouch() -> void:
	
	var owner_pawn := get_owner_pawn() as RGPawn2D
	var owner_collision := Pawn2D_Collision.try_get_from(owner_pawn)
	
	owner_pawn.position.y -= crouch_height * 0.5
	
	assert(owner_collision.shape.resource_local_to_scene)
	(owner_collision.shape as CapsuleShape2D).height = uncrouch_height
