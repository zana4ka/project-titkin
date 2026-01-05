extends Node
class_name Pawn2D_SpecialCharge

static func try_get_from(in_node: Node) -> Pawn2D_SpecialCharge:
	return ModularGlobals.try_get_from(in_node, Pawn2D_SpecialCharge)

@export_category("Owner")
@export var owner_pawn: Pawn2D

@export_category("Charge")
@export var charge_per_kill: float = 0.25

var current_charge: float = 0.0:
	set(in_charge):
		current_charge = clampf(in_charge, 0.0, 1.0)
		current_charge_changed.emit()
signal current_charge_changed()

signal activated()
signal activation_failed()

func _ready() -> void:
	
	assert(owner_pawn)
	
	PawnGlobals.pawn_died.connect(_on_pawn_died)

func _enter_tree():
	if not Engine.is_editor_hint(): ModularGlobals.init_modular_node(self)

func _exit_tree():
	if not Engine.is_editor_hint(): ModularGlobals.deinit_modular_node(self)

func _on_pawn_died(in_pawn: Pawn2D, in_immediately: bool) -> void:
	
	var pawn_damage_receiver := DamageReceiver.try_get_from(in_pawn)
	if not pawn_damage_receiver:
		return
	
	if pawn_damage_receiver.LastDamageInstigator == owner_pawn:
		current_charge += charge_per_kill

func subtract_charge() -> void:
	current_charge -= 1.0
