@tool
extends GameplayAbility
class_name BUBlockAbility

func _ready() -> void:
	ability_tags = [ TitkinTags.block_ability ]
	owner_granted_tags = [ TitkinTags.state_blocking, CommonTags.input_block_movement ]

func can_activate(in_payload: Variant) -> bool:
	return super(in_payload)

func activate_ability() -> void:
	
	if not commit_ability():
		return
	
	_handle_enable_block()

func on_ability_ended(in_was_cancelled: bool) -> void:
	_handle_disable_block()

func _handle_enable_block() -> void:
	var owner_pawn := get_owner_pawn() as BUPawn2D
	owner_pawn.damage_receiver.AddDamageImmunityTo(DamageReceiver.DamageType_RangedHit)
	owner_pawn.modulate = Color.YELLOW

func _handle_disable_block() -> void:
	var owner_pawn := get_owner_pawn() as BUPawn2D
	owner_pawn.damage_receiver.RemoveDamageImmunityFrom(DamageReceiver.DamageType_RangedHit)
	owner_pawn.modulate = Color.WHITE
